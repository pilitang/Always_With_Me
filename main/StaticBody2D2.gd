class_name Live_3
extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Rpc.data.level_3:
		$CollisionShape2D.disabled = true
	pass
