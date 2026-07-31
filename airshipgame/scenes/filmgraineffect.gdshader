shader_type canvas_item;

// Add 'filter_nearest' or 'filter_linear' to force Godot to capture the screen
uniform sampler2D screen_texture : hint_screen_texture, filter_linear; 
uniform float grain_amount : hint_range(0.0, 0.1) = 0.5;
uniform float grain_size : hint_range(0.1, 10.0) = 2.0;

void fragment() {
    // 1. Grab the base game image
    vec4 color = texture(screen_texture, SCREEN_UV);
    
    // 2. Generate random animated noise using mathematical hash
    float noise = (fract(sin(dot(UV + TIME, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
    
    // 3. Blend the noise into the original game view
    color.rgb += noise * grain_amount * grain_size;
    
    COLOR = clamp(color, 0.0, 1.0);
}
