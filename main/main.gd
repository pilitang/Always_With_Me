extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#创建服务器
func _on_button_pressed():
	Rpc.create_server(int(%LineEdit_port.text))
	Loading.load_path("res://main/geam.tscn")
	
	queue_free()
	pass # Replace with function body.

func _on_button_2_pressed():
	Rpc.create_client((%LineEdit_ip.text),int(%LineEdit_port.text))
	Loading.load_path("res://main/geam.tscn")
	queue_free()
	pass # Replace with function body.
