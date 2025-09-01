shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D overlay_texture;
uniform float opacity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec4 overlay_color = texture(overlay_texture, UV);

    vec3 result;
    for (int i = 0; i < 3; i++) {
        if (overlay_color[i] < 0.5) {
            result[i] = 2.0 * overlay_color[i] * screen_color[i];
        } else {
            result[i] = 1.0 - 2.0 * (1.0 - overlay_color[i]) * (1.0 - screen_color[i]);
        }
    }

    vec3 final_color = mix(screen_color.rgb, result, opacity);
    COLOR = vec4(final_color, screen_color.a);
}
