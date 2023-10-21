shader_type canvas_item;
uniform float Fuzziness = 5;

float normpdf(in float x, in float sigma){
    return 0.39894*exp(-.5*x*x/(sigma*sigma))/sigma;
}

uniform float radius : hint_range(0.0, 1.0) = 0.0;
uniform vec2 size = vec2(1.0, 1.0);
uniform bool cool = false;





vec4 gaussian_blur(sampler2D src, vec2 size_gb, vec2 uv, int m_size){
    vec4 cc = texture(src, uv);
    vec3 c = cc.rgb;
    int k_size = (m_size-1)/2;
    float sigma = 7.;
    vec3 final_color = vec3(0.);
    float z = 0.;
    for(int i=-k_size;i<=k_size;i++){
        float n = normpdf(float(i), sigma);
        z+=n;
        for(int j=-k_size;j<=k_size;j++){
            final_color+=n*n*texture(src,uv+(size_gb*Fuzziness)*vec2(float(i),float(j))).rgb;
        }
    }
    return vec4(final_color/z/z,1.);
}

void fragment(){
	if (cool == false ){
		COLOR = texture(TEXTURE, UV);
	}
	
	vec2 size_ratio = vec2(max(1.0, size.x / size.y), max(1.0, size.y / size.x));
	float half_radius = 0.5 * radius;
	vec2 dist_max = half_radius / size_ratio;
	vec2 edge_pos = clamp(UV, dist_max, 1.0 - dist_max);
	float edge_dist = distance(UV * size_ratio, edge_pos * size_ratio);
	
    COLOR = gaussian_blur(TEXTURE ,TEXTURE_PIXEL_SIZE ,UV , 20);
	COLOR.a *= step(edge_dist, half_radius + 0.000001);
}