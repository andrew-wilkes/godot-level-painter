shader_type spatial;
render_mode depth_draw_always;

uniform float face_z = 1.0;
uniform vec4 color : hint_color = vec4(1.0);
uniform vec4 emit_color : hint_color = vec4(0.);
uniform sampler2D face_texture;
uniform bool use_texture;
uniform vec2 tile_grid_size = vec2(1.0);

varying vec3 v;

void vertex() {
	v = vec3(VERTEX.x, VERTEX.y, VERTEX.z);
}

void fragment() {
	vec4 col = color;
	if (use_texture && abs(v.z) < 0.999) {
		float x_off = fract((1. + v.x) / .4);
		if (x_off < 0.001 || x_off > 0.999)
			col = texture(face_texture, fract((v.yz + vec2(1.)) / 2.));
		else
			col = texture(face_texture, fract((v.xz + vec2(1.)) / 2.));
	}
	ALBEDO = col.rgb;
	ALPHA = col.a;
	EMISSION = emit_color.rgb;
}
