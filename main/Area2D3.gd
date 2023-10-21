extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Role:
		var pop = await Loading.load_path("res://main/pop.tscn").complete
		pop.data = "Bought a bowl of ramen!"
		Rpc.data.level_2 = true
	pass # Replace with function body.
