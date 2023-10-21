extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Role:
		if Rpc.data.level_2:
			var node = await Loading.load_path("res://dialogue/dialogue.tscn").complete
			node.dialogue("res://json/after_scene2.json")
			await node.dialogue_complete
		else:
#		is_trigger = true
			var node = await Loading.load_path("res://dialogue/dialogue.tscn").complete
			node.dialogue("res://json/before_scene2.json")
			await node.dialogue_complete
			
			var pop = await Loading.load_path("res://main/pop.tscn").complete
			pop.data = "Going to the market to buy things"
	pass # Replace with function body.
