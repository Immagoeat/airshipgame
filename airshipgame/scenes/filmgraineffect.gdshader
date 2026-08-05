shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05;
uniform float grain_size : hint_range(1.0, 200.0) = 100.0;

float rand(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);

    vec2 seed = SCREEN_UV * grain_size + fract(vec2(TIME * 8.0, TIME * 5.3));
    float noise = rand(seed);

    color.rgb += (noise - 0.5) * grain_amount;
    color.rgb = clamp(color.rgb, 0.0, 1.0);

    COLOR = color;
}