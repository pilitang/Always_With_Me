@tool
extends MarginContainer

@export var spacing: int = 4 : set = spacingset
@export var width: int = 4 : set = widthset
@export var color: Color = Color(1,1,1,1) : set = colorset
var line:PackedVector2Array =[] 
func colorset(data):
	color = data
	queue_redraw()
func spacingset(data):
	spacing = data
	queue_redraw()
func widthset(data):
	width = data
	queue_redraw()
func _draw():

	for i in (int(size.x/spacing)):
#		line.append(Vector2(i,0))
		if (i%2) == 0:
			draw_line(Vector2((i)*spacing,size.y/2),Vector2((i+1)*spacing,size.y/2),color,width)
#			line.append(Vector2(spacing*i,size.y/2))
	
	
#	draw_polyline(line,Color(1,1,1,1),10)
	pass
