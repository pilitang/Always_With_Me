extends Control

var data = FileUtil.loadAssets("res://json/lave_0.json")
signal pressed(node)
var fs = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Bgm.stream_paused = true
	print(data)
	while fs < 6:
		data.shuffle()
		$HBoxContainer/Button.text = data.front().expression[0]
		$HBoxContainer/Button2.text = data.front().expression[1]
		$AudioStreamPlayer.stream = load(data.front().bgm)
		$AudioStreamPlayer.play()
		var node = await pressed
		if data.front().correct == node.text:
			fs += 1
	Bgm.stream_paused = false
	Rpc.data.level_1 = true
	var node = await Loading.load_path("res://main/pop.tscn").complete
	node.data = "Congratulations and welcome to the Soup House"
	get_parent().queue_free()
#		pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(fs)
	pass


#func _on_button_pressed():
#	pressed.emit()
#	pass # Replace with function body.
#
#
#func _on_button_2_pressed():
#	pressed.emit()
#	pass # Replace with function body.


func _on_button_on_click(node):
	pressed.emit(node)
	pass # Replace with function body.
