extends BaseControl

@onready var http_request = $HTTPRequest

const API_KEY = "dW8qAha1nFVB7MVSWONsm53Z"
const SECRET_KEY = "KeYdkovucQ98xP8eoSY1ZtQINIYj0EaZ"
const TOKEN_URL = "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=dW8qAha1nFVB7MVSWONsm53Z&client_secret=KeYdkovucQ98xP8eoSY1ZtQINIYj0EaZ"

var content = ""
var response = ""
var start_str1 = ""
var end_str1 = ""
var content_1 = ""
var raw_data1 = ""
var pressed_num = 0
var messages = []

func save(filename, content):
	var file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_line(content)
	

func load(filename):
	var file = FileAccess.open(filename, FileAccess.READ)
	var content = file.get_as_text()
	print(content)
	return content
	
func get_access_token():
	$HTTPRequest.request_completed.connect(_on_http_request_request_completed)
	$HTTPRequest.request("https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=dW8qAha1nFVB7MVSWONsm53Z&client_secret=KeYdkovucQ98xP8eoSY1ZtQINIYj0EaZ")
	
	
func asscess_wenxin(data_to_send, access_token):
	$HTTPRequest2.request_completed.connect(_on_http_request_2_request_completed)
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	var url = "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/llama_2_70b?access_token=" + access_token
	print(url)
	print(json)
	$HTTPRequest2.request(url, headers, HTTPClient.METHOD_POST, json)

# send messages to wenxinyiyan and get the response
# need read and write files
func commit_1():
	raw_data1 = $TextEdit.text
	#save("res://raw_data1.txt", raw_data1)
	start_str1 = 'i want you to act as my English teacher. i will a story in English. i want you to keep your reply neat, limiting the reply to 100 words. Now let\'s start practicing, please check the sentences, """"'
	end_str1 = '""""Remember, i want you to strictly correct my grammer mistakes, typos and factual errors and help me replace it with a more authentic expression based on the meaning of the sentence I have written.'
	content_1 = start_str1 + raw_data1 + end_str1
	messages.append({"role": "user", "content": content_1})
	var send_data = {"messages": messages}
	return send_data

func commit_2():
	pass
	
func commit_3():
	pass
	

func _on_button_pressed():
	get_access_token()
		


func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var access_token = json["access_token"]
	var send_data = commit_1()
	asscess_wenxin(send_data, access_token)
	print(access_token)
	
#var commit_num = 0:
#	set(value):
#		commit_num = value
#		if commit_num>3:
#			Rpc.data.level_3 = true
#			get_parent().get_parent().queue_free()
func _on_http_request_2_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	content = json["result"]
	#save("res://content_1.txt", content)
	print(content)
	Rpc.geam.dialogue(content)
	$Label.text = content
	Rpc.data.level_3 = true
	get_parent().get_parent().queue_free()
	#commit_num += 1
	
	


func _on_on_click(node):
	
	pass # Replace with function body.
