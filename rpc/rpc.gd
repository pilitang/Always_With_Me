extends Node

var peer = null
var is_server = false

var connect_arr = {}

signal update_connect_arr()
signal synchronous_connect_arr()
var geam = null
var data = {
	"level_1":false,
	"level_2":false,
	"level_3":false
}

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	
func create_server(port):
	peer = ENetMultiplayerPeer.new()
	print(peer.create_server(port, 10))
	multiplayer.multiplayer_peer = peer
	is_server = true
	connect_arr[1] = null
	update_connect_arr.emit()
	
func _on_player_connected(id):
	print("有玩家连接到客户端: ",id)
	connect_arr[id] = null
	update_connect_arr.emit()
	
	var dic = {}
	for i in connect_arr:
		dic[i].play = null
	synchronous.rpc(dic)
	pass
@rpc
func synchronous(value):
	update_connect_arr.emit()
	connect_arr = value
	synchronous_connect_arr.emit()
	
func create_client(ip,port):
	peer = ENetMultiplayerPeer.new()
	print(peer.create_client(ip, port))
	multiplayer.multiplayer_peer = peer
