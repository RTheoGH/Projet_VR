shader_type spatial;
render_mode unshaded, fog_disabled;
uniform sampler2D ui_tex;
void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}
void fragment() {
	vec4 v = texture(ui_tex, UV);
	ALBEDO = v.xyz;
	ALPHA = v.w;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
