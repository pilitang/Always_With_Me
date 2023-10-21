class_name WebSocket
extends Node

var socket = WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED


func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if last_state != state: print_debug("WebsocketClient", "链接创建" )
			
		while socket.get_available_packet_count():
			on_data(socket.get_packet())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		if last_state != state: print_debug("WebsocketClient", "链接断开" )
		var _code = socket.get_close_code()
		var _reason = socket.get_close_reason()
#		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
	last_state = state

func on_data(packet :PackedByteArray):
	PacketWrapper.parse(packet)

func open() :
	if not Account.isLogin() : return
	if socket.get_ready_state() == WebSocketPeer.STATE_CONNECTING or  socket.get_ready_state() == WebSocketPeer.STATE_OPEN: return
	close()
	socket.connect_to_url(BaseNetwork.websocket_url+"/?uId="+Account.UID)

func close() :
	socket.close()

func isActive() -> bool :
	return socket.get_ready_state() == WebSocketPeer.STATE_OPEN
