shader_type spatial;
render_mode cull_disabled;

uniform vec4 color: hint_color;

varying vec3 v;

void vertex() {
	v = abs(VERTEX);
}

void fragment() {
	float n = 0.98;
	if (v.x > n && v.z > n || v.x > n && v.y > n || v.y > n && v.z > n) {
		ALBEDO = color.rgb;
		ALPHA = color.a;
	} else {
		ALPHA = 0.;
	}
}
