extends Node2D

var role = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Rpc.geam = self
	pass
#	multiplayer.peer_connected.connect(synchronous_connect_arr)
#	Rpc.update_connect_arr.connect(update_connect_arr)
#	if multiplayer.is_server():
##		await 
#		for item in  Rpc.connect_arr:
#			var play = load("res://role/role.tscn").instantiate()
#			play.id = item
#			if item == multiplayer.get_unique_id():
#				role = play
#			$Node2D.add_child(play)
#
#
#	pass # Replace with function body.
#func update_connect_arr():
#	for i in $Node2D.get_children():
#		i.queue_free()
#
#	for item in  Rpc.connect_arr:
#		var play = load("res://role/role.tscn").instantiate()
#		play.id = item
#		if item == multiplayer.get_unique_id():
#			role = play
#		$Node2D.add_child(play)
	pass
func _process(delta):
	$Label.text = str(Rpc.connect_arr.keys())
	for id in Rpc.connect_arr:
		if Rpc.connect_arr[id] == null:
			var play = load("res://role/role.tscn").instantiate()
			play.id = id
			if id == multiplayer.get_unique_id():
				role = play
			Rpc.connect_arr[id] = play
			$Node2D.add_child(play)
	if role != null:
		$Camera2D.position = role.position
	sync_data.rpc(Rpc.data)
	%TextureRect_levle_1.visible =Rpc.data.level_1
	%TextureRect_levle_2.visible =Rpc.data.level_2
	%TextureRect_levle_3.visible =Rpc.data.level_3
	$StaticBody2D/CollisionShape2D.disabled = Rpc.data.level_1




@rpc()
func sync_data(my_data):
	Rpc.data = my_data
	
func _on_button_pressed():
	var value = str(role.id)+":"+%LineEdit.text + "\n"
	dialogue(value)
	
func dialogue(value):
	sync_dialogue.rpc(value)
	%dialogue.text += value
	pass # Replace with function body.

@rpc("any_peer")
func sync_dialogue(value):
	%dialogue.text += value


func _on_scene_1_body_entered(body):
	if body is Role:
		Bgm.stream = load("res://Music/scene1.mp3")
		Bgm.play()
	pass # Replace with function body.


func _on_scene_2_body_entered(body):
	if body is Role:
		Bgm.stream = load("res://Music/scene2.mp3")
		Bgm.play()
	pass # Replace with function body.


func _on_scene_3_body_entered(body):
	if body is Role:
		Bgm.stream = load("res://Music/scene3.mp3")
		Bgm.play()
	pass # Replace with function body.



func _on_scene_4_body_entered(body):
	if body is Role:
		Bgm.stream = load("res://Music/Always with me.mp3")
		Bgm.play()
	pass # Replace with function body.
