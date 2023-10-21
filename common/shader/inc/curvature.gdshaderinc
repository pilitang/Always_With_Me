global uniform bool is_curvature;
global uniform float curvature_radius;
global uniform vec3 player_position;


float get_depth(float dist){
	return sqrt(dist*dist + curvature_radius * curvature_radius) - curvature_radius ;
}

vec3 curvature_vertex(mat4  model_matrix ,vec3 vertex ) {
	if (is_curvature ){
		vec3 vertex_world =(model_matrix * vec4(vertex, 1.0)).xyz ;
		vec3 dist = vertex_world -player_position;
		float depth = get_depth(length(dist.xz));
		vertex_world.y -= depth;
		vec3 vertex_local = (inverse(model_matrix) * vec4(vertex_world, 1.0)).xyz;
		vertex = vertex_local;
	}
	return vertex;
}
