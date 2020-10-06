shader_type canvas_item;

uniform vec4 color : hint_color = vec4(1.0);
uniform vec4 emit_color : hint_color = vec4(0.);
uniform sampler2D face_texture;
uniform bool use_texture;
uniform vec2 tile_grid_size = vec2(1.0);

void fragment() {
	vec4 col = clamp(color + emit_color, vec4(0.), vec4(1.));
	if (use_texture)
		col = texture(face_texture, UV * tile_grid_size);
	COLOR = col;
}
