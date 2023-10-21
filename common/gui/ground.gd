extends Object
class_name Ground

const GRID_EMPTY: int = -1;
const GRID_GRASS: int = 0;

var ground_data: Array;
var vertices: Array;
var outline: Array;
var size: int;
var distortion: int;
var padding: int;
var rng = RandomNumberGenerator.new();

func _init(size: int,distortion: int,padding: int):
	self.rng.randomize();
	rebuild(size, distortion, padding);

func generate_segment(length: int) -> Array:
	var result = [];
	if length < 4 * distortion:
		return result;
	while(len(result) < distortion):
		var n = rng.randi_range(0, length);
		if not result.has(n):
			result.append(n);
	result.sort();
	return result;

func generate_vertices() -> Array:

	var result = [];
#	var rng = RandomNumberGenerator.new()
	var type = "square";
	match type:
		"square":
			var base_shape: Array = [
				Vector2(padding, padding),
				Vector2(size + padding, padding),
				Vector2(size + padding, size + padding),
				Vector2(padding, size + padding)
			];
#			distort
			if distortion > 0:
				var noise_point1 = [];
				var noise_point2 = [];
				var noise_point3 = [];
				var noise_point4 = [];
				var segment1 = generate_segment(size);
				var segment2 = generate_segment(size);
				var segment3 = generate_segment(size);
				var segment4 = generate_segment(size);
				var tmp_unit: int = (size) / (distortion + distortion/4);
#				print_debug("tmp_unit: ", tmp_unit);
				for i in distortion:
					noise_point1.append(Vector2(base_shape[0].x + segment1[i], base_shape[0].y - rng.randi_range(1, padding)));
					noise_point2.append(Vector2(base_shape[1].x + rng.randi_range(1, padding), base_shape[1].y + segment2[i]));
					noise_point3.append(Vector2(base_shape[2].x - segment3[i], base_shape[2].y + rng.randi_range(1, padding)));
					noise_point4.append(Vector2(base_shape[3].x - rng.randi_range(1, padding), base_shape[3].y - segment4[i]));
				result = \
				[base_shape[0]] + noise_point1 + \
				[base_shape[1]] + noise_point2 + \
				[base_shape[2]] + noise_point3 + \
				[base_shape[3]] + noise_point4;
			else:
				result = base_shape;
#				print_debug("done");
#			rasterize
			pass
#			print_debug(result);
		"round":
			pass
#			scan filling
#
#	for point in result:
#		pass
	vertices = result;
	return result;

func make_line(x1: int, y1: int, x2: int, y2: int) -> Array:
	var result: Array;
	var dx: int = int(abs(x1-x2));
	var dy: int = int(abs(y1-y2));
	var sx: int;
	if x1<x2: sx = 1;
	else: sx = -1;
	var sy: int;
	if y1<y2: sy = 1;
	else: sy = -1;
	var err: int;
	if dx>dy: err = dx/2;
	else: err = -dy/2;
	var e2: int;
	var x: int = x1;
	var y: int = y1;
	while(x!=x2 or y!=y2):
		e2 = err;
		if(e2> -dx):
			err-=dy;
			x += sx;
		if(e2 < dy):
			err += dx;
			y += sy;
		result.append(Vector2(x, y));
#	result.pop_back();
	return result;

func make_outline() -> Array:
#	var vertices = generate_outline("square", size, distortion, padding);
	var result = [];
	for i in len(vertices):
		if i == len(vertices) - 1:
			result = result + make_line(vertices[i].x, vertices[i].y, vertices[0].x, vertices[0].y);
		else:
			result = result + make_line(vertices[i].x, vertices[i].y, vertices[i+1].x, vertices[i+1].y);
	pass
	outline = result;
	for point in outline:
		ground_data[point.x][point.y] = GRID_GRASS;
#		ground_data[point.x][point.y] = 0;
	for p in vertices:
		ground_data[p.x][p.y] = GRID_GRASS;
#		ground_data[p.x][p.y] = 1;
#	print_debug(ground_data)
	return result;

func grow_row(x: int, y: int) -> Array:
	var line: Array = [];
	var grow_flag: bool = true;
	var i: int = 0;
	while (grow_flag):
		var next: Vector2 = Vector2(x + i, y);
#		if (not outline.has(next)):
		if (ground_data[next.x][next.y] == -1):
			ground_data[next.x][next.y] = GRID_GRASS;
#			ground_data[next.x][next.y] = 2;
			line.push_back(next);
		else:
			grow_flag = false;
		i += 1;
#		if i > 128:
#			break;
		pass
	grow_flag = true;
	i = 1;
	while (grow_flag):
		var next: Vector2 = Vector2(x - i, y);
#		if (not outline.has(next)):
		if (ground_data[next.x][next.y] == -1):
			ground_data[next.x][next.y] = GRID_GRASS;
#			ground_data[next.x][next.y] = 2;
#			line.append(next);
			line.push_front(next);
		else:
			grow_flag = false;
		i += 1;
#		if i > 128:
#			break;
		pass
#	print_debug(line)
	return line;

func find_seed(row: Array) -> Array:
	var result: Array = [];
	var flag: bool = true;
	for p in row:
		if ground_data[p.x][p.y+1] != -1:
			flag = true;
		else:
			if flag:
				flag = false;
				result.insert(0, Vector2(p.x, p.y+1));
	flag = true;
	for p in row:
		if ground_data[p.x][p.y-1] != -1:
			flag = true;
		else:
			if flag:
				flag = false;
				result.insert(0, Vector2(p.x, p.y-1));
	return result;

func fill_region() -> Array:
	var result = [];
	var start_seed: Vector2 = Vector2(size/2 + padding, size/2 + padding);
	var seed_stack: Array = [start_seed];
	
	while (not seed_stack.is_empty()):
		var current_seed = seed_stack.pop_front();
		var current_row = grow_row(int(current_seed.x), int(current_seed.y));
#		result += current_row;
		var seed_found = find_seed(current_row);
		if len(seed_found) > 1:
			print_debug("found seed: ", seed_found)
		seed_stack = seed_found + seed_stack;
		pass
#	print_debug("fill.");
	return result;

func rebuild(size: int, distortion: int, padding: int):
#	print_debug("rebuild info: ");
	self.size = size;
	self.distortion = distortion;
	self.padding = padding;
	ground_data = [];
	for i in size + 2*padding + 1:
		ground_data.append([]);
		for j in size + 2*padding + 1:
			ground_data[i].append(GRID_EMPTY);
	vertices = generate_vertices();
	outline = make_outline();
	fill_region();
#	print_debug("           ", (ground_data))




