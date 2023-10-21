shader_type canvas_item;
render_mode blend_mix;

uniform vec2 size = vec2(1.0, 1.0);



uniform float round_all = 0.;

uniform float left_top = 0.;
uniform float right_top = 0.;
uniform float left_bottom = 0.;
uniform float right_botom = 0.;

uniform vec4 border_color : source_color;
uniform vec4 Background_color : source_color;
uniform float Background_color_a =0.;

uniform float border_width   = 0.;
uniform bool isColor = false;
uniform bool isBackground_color = false;
void fragment() {
	vec2 size_ratio = vec2(max(1.0, size.x / size.y), max(1.0, size.y / size.x));
	if( !isColor ) {
		COLOR = texture(TEXTURE, UV);
	}
//	if ( isBackground_color){
//		vec4 a = (Background_color - texture(TEXTURE, UV));
//		vec4 b = Background_color - a;
//		if (a != Background_color){
//			a = 1.-a;
//		}
//		COLOR = a+b;
//		COLOR = Background_color*(1.-texture(TEXTURE, UV))+texture(TEXTURE, UV);
//		COLOR.a = texture(TEXTURE, UV).a;
//		COLOR = texture(TEXTURE, UV)*Background_color;
//		COLOR.a = 1.0 - (texture(TEXTURE, UV)*Background_color).a;
//		COLOR += ;
//	}
	if (COLOR.a <= Background_color_a && isBackground_color){
		COLOR = Background_color;

	}
	float minSize = min(size.x,size.y);
	float left_top_my = left_top/minSize;
	float right_top_my = right_top/minSize;
	float left_bottom_my = left_bottom/minSize;
	float right_botom_my = right_botom/minSize;
	float border_width_my = border_width/minSize;
	if (round_all>0.){
		left_top_my = round_all/minSize;
		right_top_my = round_all/minSize;
		left_bottom_my = round_all/minSize;
		right_botom_my = round_all/minSize;
	}
	vec2 uv = UV;
	if (uv.x*size_ratio.x  <= left_top_my && uv.y*size_ratio.y+left_top_my <= left_top_my*2.){
		float len = length(vec2(uv.x*size_ratio.x - (left_top_my),(uv.y)*size_ratio.y-(left_top_my)));
		if (0.<step(left_top_my-border_width_my,len ) ){
			COLOR.rgb = border_color.rgb;
			COLOR.a = border_color.a;
		}
		if (0.<step(left_top_my,len ) ){
			COLOR.a = 0.;
		}
	}
	else if (uv.x*size_ratio.x <= left_bottom_my && (1.-uv.y)*size_ratio.y+left_bottom_my <= left_bottom_my*2.){
		float len = length(vec2(uv.x*size_ratio.x - (left_bottom_my),(1.-uv.y)*size_ratio.y-(left_bottom_my)));
		if (0.<step(left_bottom_my-border_width_my,len) ){
			COLOR.rgb = border_color.rgb;
			COLOR.a = border_color.a;
		}
		if (0.<step(left_bottom_my,len) ){
			COLOR.a = 0.;
		}
	}
	else if ((1.-uv.x)*size_ratio.x <= right_top_my && uv.y*size_ratio.y+right_top_my <= right_top_my*2.){
		float len = length(vec2((1.-uv.x)*size_ratio.x - (right_top_my),uv.y*size_ratio.y-(right_top_my)));
		if (0. < step(right_top_my-border_width_my,len)){
			COLOR.rgb = border_color.rgb;
			COLOR.a = border_color.a;
		}
		if (0. < step(right_top_my,len)){
			COLOR.a = 0.;
		}
	}
	else if ((1.-uv.x)*size_ratio.x <= right_botom_my && (1.-uv.y)*size_ratio.y+right_botom_my <= right_botom_my*2.){
		float len = length(vec2((1.-uv.x)*size_ratio.x - (right_botom_my),(1.-uv.y)*size_ratio.y-(right_botom_my)));
		if (0. < step(right_botom_my-border_width_my,len)){
			COLOR.rgb = border_color.rgb;
			COLOR.a = border_color.a;
		}
		if (0. < step(right_botom_my,len)){
			COLOR.a = 0.;
		}
	}
	else if (uv.x<= border_width_my/size_ratio.x || uv.y<= border_width_my/size_ratio.y || 1.-uv.x<= border_width_my/size_ratio.x || 1.-uv.y<= border_width_my/size_ratio.y) {
		COLOR.rgb = border_color.rgb;
		COLOR.a = border_color.a;
	}	
}