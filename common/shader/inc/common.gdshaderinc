uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128)= 1;
uniform float roughness : hint_range(0,1) = 0.5;
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular = 0.5;
uniform float metallic;
uniform bool emission_enabled = false;
uniform sampler2D texture_emission : source_color, hint_default_black,filter_linear_mipmap,repeat_enable;
uniform vec4 emission : source_color;
uniform float emission_energy;
uniform bool ao_enabled = false;
uniform sampler2D texture_ambient_occlusion : hint_default_white, filter_linear_mipmap,repeat_enable;
uniform vec4 ao_texture_channel =vec4(1,0,0,0);
uniform float ao_light_affect;
uniform bool normal_enabled = false;
uniform sampler2D texture_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16,16);


uniform vec3 uv1_scale= vec3(1,1,1);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale= vec3(1,1,1);
uniform vec3 uv2_offset;