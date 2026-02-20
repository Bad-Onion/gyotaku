shader_type canvas_item;


uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform float horizon_level : hint_range(0.0, 1.0) = 0.53; // Adjust to match the mountain line
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.01;
uniform float wave_frequency : hint_range(0.0, 50.0) = 25.0;
uniform float wave_speed : hint_range(0.0, 10.0) = 2.0;
uniform vec4 water_tint : source_color = vec4(0.1, 0.4, 0.7, 0.3);


void fragment() {
    // Generate a horizontal distortion based on the UV.y and TIME
    float wave = sin(UV.y * wave_frequency + TIME * wave_speed) * wave_amplitude;

    // Calculate the reflection UV.
    // We flip the sampling point above the horizon relative to how far down we are below it.
    float distance_from_horizon = SCREEN_UV.y - horizon_level;
    vec2 reflection_uv = vec2(SCREEN_UV.x + wave, horizon_level - distance_from_horizon);

    // Fetch the color from the screen texture
    vec4 reflected_color = texture(screen_texture, reflection_uv);

    // Blend the reflection with the base water tint
    COLOR = mix(reflected_color, water_tint, water_tint.a);
}
