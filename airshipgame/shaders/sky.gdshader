shader_type sky;

uniform vec4 day_sky : source_color;
uniform vec4 day_horizon : source_color;
uniform vec4 night_sky : source_color;
uniform vec4 night_horizon : source_color;

uniform vec3 sun_direction;
uniform float saturation_amount : hint_range(0.0, 1.0) = 0.4;

// Adjust this to move the horizon line up or down
// Negative values push it LOWER, positive values pull it HIGHER
uniform float horizon_offset : hint_range(-2.0, 2.0) = -0.3;

uniform float star_density : hint_range(0.0, 1.0) = 0.4;
uniform float star_threshold : hint_range(0.8, 1.0) = 0.96;

void sky() {
    // 1. Calculate view height with the new horizon offset bias
    // We use a high multiplier (e.g., 4.0) to keep the horizon transition sharp
    float view_height = clamp((EYEDIR.y - horizon_offset) * 4.0, 0.0, 1.0);
    
    // 2. Determine day/night mix factor based on the sun's vector height
    float day_factor = clamp((sun_direction.y + 0.2) * 2.0, 0.0, 1.0);
    
    // 3. Blend the day and night colors together
    vec4 current_sky = mix(night_sky, day_sky, day_factor);
    vec4 current_horizon = mix(night_horizon, day_horizon, day_factor);
    vec4 final_color = mix(current_horizon, current_sky, view_height);
    
    // 4. Desaturation Step
    float luma = dot(final_color.rgb, vec3(0.2126, 0.7152, 0.0722));
    vec3 desaturated_rgb = mix(vec3(luma), final_color.rgb, saturation_amount);
    
    COLOR = desaturated_rgb;
    ALPHA = final_color.a;
}
