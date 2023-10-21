shader_type canvas_item;

uniform sampler2D texture;
uniform float time;
uniform vec2 resolution;
uniform vec4 dissolveColor;  // Controllo del colore e della trasparenza dell'effetto di dissolvenza
uniform float circleSize;  // Controllo sulla grandezza del cerchio
uniform sampler2D hologramTexture;
uniform float maxR = .5;
uniform float smoothness = .5;
uniform float displayRatio =1.7;
void fragment() {
    // normalized configurable factors
//    float maxR = .5;
    
    float minR = maxR * (1.0 - smoothness);
    vec2 centerUv = vec2(0.5, 0.5);
    
    
    
    // just to play animation
    
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = UV;
    vec2 duv = uv;
    duv.x *= displayRatio;
    centerUv.x *= displayRatio;

    vec3 col = texture(texture, uv).rgb;
    float dist = length(centerUv - duv);
	COLOR.a = 0.;
    if (dist > maxR) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } 
    
    if (maxR > dist && dist > minR) {
        col = mix(col, vec3(0.0, 0.0, 0.0), smoothstep(minR/maxR,1.0,dist/maxR));
    }

   // COLOR = vec4(col,1.0);
}