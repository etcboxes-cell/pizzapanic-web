shader_type canvas_item;
render_mode unshaded;

// The existing cheese illustration is the full state. Reveal it left-to-right
// over the sauce texture while leaving the decorative gold frame untouched.
uniform float fill_ratio : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    vec4 result = original;
    // The bar's inner track occupies approximately 8%-91% of the width
    // and 45%-59% of the height of the approved transparent artwork.
    float inside_x = step(0.083, UV.x) * (1.0 - step(0.909, UV.x));
    float inside_y = step(0.464, UV.y) * (1.0 - step(0.573, UV.y));
    float lane = inside_x * inside_y;
    float edge = 0.083 + clamp(fill_ratio, 0.0, 1.0) * (0.909 - 0.083);
    float unfilled = smoothstep(edge - 0.003, edge + 0.003, UV.x);
    // Sample the existing tomato-sauce part of the approved image, not a flat
    // rectangle, so the progress appears to melt across the pizza track.
    float sauce_x = 0.73 + fract((UV.x - 0.083) * 2.8) * 0.15;
    vec4 sauce = texture(TEXTURE, vec2(sauce_x, UV.y));
    result.rgb = mix(original.rgb, sauce.rgb, lane * unfilled);
    COLOR = result;
}
