extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@warning_ignore("integer_division")
func _ready():
	position =  Vector2(get_window().size.x/2,0)
	self_modulate = Color(1,0,0)
	add_theme_font_size_override("font_size", 26)
# Called when the node enters the scene tree for the first time.

func _process(_delta):
#	ProjectSettings.set_setting("editor/movie_writer/fps",Engine.get_frames_per_second())
	text = "FPS: " + str(Engine.get_frames_per_second())
	pass
#	set_text("FPS: " + str(Engine.get_frames_per_second()) + "/        wuti_shuliang:" + str(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME))
#	+"/              dingdian:" + str(Performance.get_monitor(Performance.RENDER_VERTICES_IN_FRAME))
#	+"/              zhengaibain :" + str(Performance.get_monitor(Performance.RENDER_SURFACE_CHANGES_IN_FRAME)))



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
