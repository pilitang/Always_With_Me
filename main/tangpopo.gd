extends Area2D

#var is_trigger = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Role:
#		is_trigger = true
		var node = await Loading.load_path("res://dialogue/dialogue.tscn").complete
		node.dialogue("res://json/before_scene1.json")
		await node.dialogue_complete
#		print("======")
	pass # Replace with function body.
