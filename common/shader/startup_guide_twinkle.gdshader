shader_type canvas_item;
uniform float ld = 0.35;
uniform float time = 1;

void fragment(){
	if (COLOR.r > ld && COLOR.g > ld && COLOR.b > ld){
		float r = clamp(COLOR.r*sin(TIME*time),-1,1);
		float g = clamp(COLOR.g*sin(TIME*time),-1,1);
		float b = clamp(COLOR.b*sin(TIME*time),-1,1);
		float a = clamp(.1*sin(TIME*time),0,1);
		COLOR = COLOR+vec4(abs(r),abs(g),abs(b),a);
	}
	
}