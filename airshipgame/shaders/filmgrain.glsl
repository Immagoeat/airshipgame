#[compute]
#version 450

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
}