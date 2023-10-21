@tool
extends Line2D

var glo_pos_history = Vector2()
var prepare = false
func _ready():
	#初始化历史全局坐标
	glo_pos_history = global_position

func _process(_delta):
	if prepare:
		#每帧添加一个 point
		add_point(Vector2(0,0))
		#遍历除新增外的其他 point 并加上上一帧全局位置和当前帧全局位置的差值
		for i in range(get_point_count()-1):
			set_point_position(i,get_point_position(i)+glo_pos_history - global_position)
		#限制 point 数量，当达到限制的数量时删除 points 数组中最早创建的 point ，也就是下标为 0 的 point
		#后面的 point 下标会自动前移
		if get_point_count() > 20:
			remove_point(0)
		#更新全局位置历史供下一帧调用
		glo_pos_history = global_position
