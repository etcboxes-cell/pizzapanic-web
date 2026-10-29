shader_type canvas_item;
render_mode unshaded;

// Alpha 12.83: animate the approved glossy pizza bar without distorting its
// decorative golden frame or transparency. UVs refer to the original 1672x941 PNG.
uniform float fill_ratio : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    vec4 result = original;
    // Only alter the inner sauce/cheese lane, never its gold border.
    float inside_x = smoothstep(0.066, 0.078, UV.x) * (1.0 - smoothstep(0.905, 0.915, UV.x));
    float inside_y = smoothstep(0.464, 0.484, UV.y) * (1.0 - smoothstep(0.584, 0.605, UV.y));
    float inner_mask = inside_x * inside_y;

    // Reuse the existing sauce and cheese textures from the artist's PNG.
    vec2 sauce_uv = vec2(0.728 + fract(UV.x * 7.7) * 0.150, UV.y);
    vec2 cheese_uv = vec2(0.17 + fract(UV.x * 4.1) * 0.38, UV.y);
    vec3 sauce = texture(TEXTURE, sauce_uv).rgb;
    vec3 cheese = texture(TEXTURE, cheese_uv).rgb;

    // A gently rippling cheese edge; TIME only affects its visual contour.
    float ripple = 0.005 * sin(UV.y * 115.0 + TIME * 5.0);
    float edge = mix(0.078, 0.905, clamp(fill_ratio, 0.0, 1.0)) + ripple;
    float remaining = smoothstep(edge - 0.012, edge + 0.006, UV.x);
    // Gently animate the molten surface without moving the frame.
    float bubbles = 0.025 * sin(UV.x * 85.0 + TIME * 3.0) * sin(UV.y * 90.0 - TIME * 2.1);
    vec3 lane = mix(cheese, sauce, remaining) * (1.0 + bubbles);
    result.rgb = mix(original.rgb, lane, inner_mask);
    COLOR = vec4(result.rgb, original.a);
}
