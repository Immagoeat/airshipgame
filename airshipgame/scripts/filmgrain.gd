@tool
extends CompositorEffect
class_name FilmGrainEffect

@export var grain_amount: float = 0.15
@export var grain_size: float = 1.0

var rd: RenderingDevice
var shader: RID
var pipeline: RID
var shader_compiled := false

const GLSL_SOURCE = "#version 450
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16f, set = 0, binding = 0) uniform image2D color_image;

layout(push_constant, std430) uniform Params {
    float grain_amount;
    float grain_size;
    float time;
    float pad;
} params;

float rand(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    ivec2 uv = ivec2(gl_GlobalInvocationID.xy);
    ivec2 size = imageSize(color_image);
    if (uv.x >= size.x || uv.y >= size.y) return;

    vec2 suv = vec2(uv) / vec2(size);
    vec2 seed = suv * params.grain_size + fract(vec2(params.time * 8.0, params.time * 5.3));
    float noise = rand(seed);

    vec4 color = imageLoad(color_image, uv);
    color.rgb += (noise - 0.5) * params.grain_amount;
    color.rgb = clamp(color.rgb, 0.0, 1.0);
    imageStore(color_image, uv, color);
}"

func _init() -> void:
	effect_callback_type = EFFECT_CALLBACK_TYPE_POST_TRANSPARENT

func _compile_shader() -> void:
	rd = RenderingServer.get_rendering_device()
	if not rd:
		return

	var src := RDShaderSource.new()
	src.source_compute = GLSL_SOURCE
	src.language = RenderingDevice.SHADER_LANGUAGE_GLSL

	var spirv := rd.shader_compile_spirv_from_source(src)
	if spirv == null:
		push_error("Film grain SPIRV compilation failed")
		return

	if spirv.compile_error_compute != "":
		push_error("Film grain compile error: " + spirv.compile_error_compute)
		return

	shader = rd.shader_create_from_spirv(spirv)
	if not shader.is_valid():
		push_error("Film grain shader RID invalid")
		return

	pipeline = rd.compute_pipeline_create(shader)
	shader_compiled = pipeline.is_valid()

func _render_callback(p_effect_callback_type: int, p_render_data: RenderData) -> void:
	if not shader_compiled:
		_compile_shader()

	if not shader_compiled or not rd:
		return
	if not shader.is_valid() or not pipeline.is_valid():
		return

	var render_scene_buffers = p_render_data.get_render_scene_buffers()
	if not render_scene_buffers:
		return

	var size = render_scene_buffers.get_internal_size()
	if size.x == 0 or size.y == 0:
		return

	var x_groups = (size.x - 1) / 8 + 1
	var y_groups = (size.y - 1) / 8 + 1

	var push_constant := PackedFloat32Array([
		grain_amount,
		grain_size,
		Time.get_ticks_msec() / 1000.0,
		0.0
	])

	for view in range(render_scene_buffers.get_view_count()):
		var color_image = render_scene_buffers.get_color_layer(view)

		var uniform := RDUniform.new()
		uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
		uniform.binding = 0
		uniform.add_id(color_image)

		var uniform_set = UniformSetCacheRD.get_cache(shader, 0, [uniform])
		if not uniform_set.is_valid():
			continue

		var compute_list = rd.compute_list_begin()
		rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
		rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
		rd.compute_list_set_push_constant(compute_list, push_constant.to_byte_array(), push_constant.size() * 4)
		rd.compute_list_dispatch(compute_list, x_groups, y_groups, 1)
		rd.compute_list_end()
