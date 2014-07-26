uniform vec2 u_linewidth;
uniform float u_gamma;
uniform float u_fade;

uniform vec2 u_pattern_size;
uniform vec2 u_pattern_tl;
uniform vec2 u_pattern_br;

uniform sampler2D u_image;

varying vec2 v_normal;
varying float v_linesofar;

void main() {
    // Calculate the distance of the pixel from the line in pixels.
    float dist = length(v_normal) * length(gl_PointCoord * 2.0 - 1.0);

    // Calculate the antialiasing fade factor. This is either when fading in
    // the line in case of an offset line (v_linewidth.t) or when fading out
    // (v_linewidth.s)
    float alpha = clamp(min(dist - (u_linewidth.t - 1.0), u_linewidth.s - dist) * u_gamma, 0.0, 1.0);

    float x = mod(v_linesofar / u_pattern_size.x, 1.0);
    float y = 0.5 + (v_normal.y * u_linewidth.s / u_pattern_size.y);
    vec2 pos = mix(u_pattern_tl, u_pattern_br, vec2(x, y));
    float x2 = mod(x * 2.0, 1.0);
    vec2 pos2 = mix(u_pattern_tl, u_pattern_br, vec2(x2, y));

    vec4 color = texture2D(u_image, pos) * (1.0 - u_fade) + u_fade * texture2D(u_image, pos2);

    color.rgb *= color.a;

    gl_FragColor = color * alpha;
}