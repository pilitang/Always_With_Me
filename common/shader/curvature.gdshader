// NOTE: Shader automatically converted from Godot Engine 4.0.3.rc1's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;



		


#include "inc/common.gdshaderinc"
#include "inc/curvature.gdshaderinc"

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	VERTEX = curvature_vertex(MODEL_MATRIX,VERTEX);
}






void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	if (emission_enabled) {
		vec3 emission_tex = texture(texture_emission,base_uv).rgb;
		EMISSION = (emission.rgb+emission_tex)*emission_energy;
	}
	
	if (ao_enabled) {
		AO = dot(texture(texture_ambient_occlusion,base_uv),ao_texture_channel);
		AO_LIGHT_AFFECT = ao_light_affect;
	}

	if (normal_enabled) {
		NORMAL_MAP = texture(texture_normal,base_uv).rgb;
		NORMAL_MAP_DEPTH = normal_scale;
	}


	
}
