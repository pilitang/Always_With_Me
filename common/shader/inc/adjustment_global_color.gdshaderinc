


vec3 adjust_global_color(vec3 g_color){
	return mix(pow((g_color.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)), g_color.rgb * (1.0 / 12.92), lessThan(g_color.rgb, vec3(0.04045)));
}