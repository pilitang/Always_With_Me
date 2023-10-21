class_name Role
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var fx = Vector2()
@export var id = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	position = Vector2(randi()%100,randi()%100)
	if id == multiplayer.get_unique_id():
		sync_post.rpc(position)
func _physics_process(delta):
	if Rpc.connect_arr[id] != self:
		queue_free()
	if id == multiplayer.get_unique_id() or (id ==1 and multiplayer.is_server()):
		velocity.x = Input.get_axis("a", "d")* SPEED
		velocity.y = Input.get_axis("w", "s")* SPEED
#		fx = velocity
	if multiplayer.is_server():
		$Label.text = str("Chihiro")
		
		
		#$AnimatedSprite2D.sprite_frames("res://role/haku.tres")
		if Input.is_action_just_pressed("tab"):
			if Rpc.data.level_1:
				for item in $Area2D.get_overlapping_bodies():
					if item is Live_3:
						var node = await Loading.load_path("res://control.tscn").complete
			else:
				for item in $Area2D.get_overlapping_bodies():
					if item is Live:
						var node = await Loading.load_path("res://dialogue/dialogue.tscn").complete
						node.dialogue("res://json/before_scene1.json")
						await node.dialogue_complete
						Loading.load_path("res://main/lave_1.tscn")
#					print("======")
	else:	
		$Label.text = str("Haku")
		#var frames = preload("res://role/haku.tres")
		#$AnimatedSprite2D.set_sprite_frames(frames)
		
	if velocity.x > 0:
		$AnimatedSprite2D.play("right")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("left")
	if velocity.y > 0:
		$AnimatedSprite2D.play("down")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("up")
#	if id == multiplayer.get_unique_id():
	move_and_slide()
	
		
#	if multiplayer.is_server():
#		var my_velocity = velocity
#	if id == multiplayer.get_unique_id() or (id ==1 and multiplayer.is_server()):
	if id == multiplayer.get_unique_id():
		print_once_per_client.rpc(velocity,position)
#func _input(event):
#	if event.is_

@rpc("any_peer")
func sync_post(my_id,my_position):
	if multiplayer.get_remote_sender_id() == id:
		position = my_position
@rpc("any_peer")
func print_once_per_client(my_id,my_velocity,my_position):
#	print(my_id)
	if multiplayer.get_remote_sender_id() == id:
		velocity = my_velocity
		position = my_position
