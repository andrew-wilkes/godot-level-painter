shader_type spatial;
render_mode depth_draw_always;

uniform float face_z = 0.1;
uniform vec4 color : hint_color = vec4(1.0);
uniform vec4 emit_color : hint_color = vec4(0.);
uniform sampler2D face_texture;
uniform bool use_texture;
uniform vec2 tile_grid_size = vec2(1.0);

varying vec3 v;

void vertex() {
	v = vec3(VERTEX.x, -VERTEX.y, VERTEX.z);
}

void fragment() {
	vec4 col = color;
	if (use_texture && abs(v.z) > face_z - 0.001)
		col = texture(face_texture, fract((v.xy + vec2(1.)) * tile_grid_size / 2.));
	ALBEDO = col.rgb;
	ALPHA = col.a;
	EMISSION = emit_color.rgb;
}
