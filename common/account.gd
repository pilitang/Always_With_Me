extends Node


const PATH_ROLE_HEAD_PORTRAIT = "user://role_head_portrait.png"
enum SEX {
	NONE = 0,
	BOY = 1,
	GIRL = 2
}

signal uid_change()
signal user_change()
signal login_change()
signal role_change()
signal pokemon_change()
signal map_change()
signal item_change()

var UID : String = "" :
	set(value):
		KvStore.put("UID",value)
		emit_signal("uid_change")
	get :
		return KvStore.get_value("UID","")

var user : Dictionary = {} :
	set(value):
		var isLoginChange =  (user.is_empty() and not value.is_empty() ) or (not user.is_empty() and value.is_empty() )
		KvStore.put("USER",value)
		emit_signal("user_change")
		if isLoginChange :
			emit_signal("login_change")
	get :
		return KvStore.get_value("USER",{})


var local_user = {} : 
	set(value):
		KvStore.put("LOCAL_USER",value)
	get:
		return KvStore.get_value("LOCAL_USER",{})



var sex : int = 0 :
	set(value) :
		if user.is_empty():
			var temp = local_user
			temp["SEX"] = value
			local_user = temp
		else:
			var temp = user
			temp.userBase.sex = value
			user = temp
		emit_signal("role_change")
	get:
		if user.is_empty():
			return local_user["SEX"] if local_user.has("SEX") else SEX.NONE
		else:
			return user.userBase.sex  

var nickName : String = "" :
	set(value):
		if user.is_empty():
			var temp = local_user
			temp["NICKNAME"] = value
			local_user = temp
		else:
			var temp = user
			temp.userBase.nickName = value
			user = temp
	get:
		if user.is_empty():
			return local_user["NICKNAME"] if local_user.has("NICKNAME") else SEX.NONE
		else:
			return user.userBase.nickName  

var role : Dictionary = {} :
	set(value):
		if user.is_empty():
			var temp = local_user
			temp["ROLE"] = value
			local_user = temp
		else:
			var temp = user
			temp.userRole.data = JsonWrapper.toJson(value)
			user = temp	
		emit_signal("role_change")
	get :
		if user.is_empty():
			return local_user["ROLE"] if local_user.has("ROLE") else {}
		else:
			return JsonWrapper.convertJson(user.userRole.data )

var pokemon : Dictionary = {} :
	set(value):
		if user.is_empty():
			var temp = local_user
			temp["POKEMON"] = value
			local_user = temp
		else:
			var temp = user
			temp.userPokemon.data = JsonWrapper.toJson(value)
			user = temp	
		emit_signal("pokemon_change")
	get :
		if user.is_empty():
			return local_user["POKEMON"] if local_user.has("POKEMON") else {}
		else:
			return JsonWrapper.convertJson(user.userPokemon.data )


var map : Dictionary = {} :
	set(value):
		if value.is_empty():
			KvStore.remove_key("LOCAL_MAP")
			KvStore.remove_key("MAP_"+UID)
		else :
			if UID.is_empty():
				KvStore.put("LOCAL_MAP",value)
			else:
				KvStore.put("MAP_"+UID,value)
			emit_signal("map_change")
	get :
		if UID.is_empty():
			return KvStore.get_value("LOCAL_MAP",MapWrapper.MAP_DEFAULT)
		else:
			return KvStore.get_value("MAP_"+UID,MapWrapper.MAP_DEFAULT)

func update_map(new_map):
	new_map.lastUpdateTime = TimeUtil.serverTimeMillsecond()
	self.map = new_map



var item : Dictionary = {} : 
	set(value):
		if value.is_empty():
			KvStore.remove_key("LOCAL_ITEM")
			KvStore.remove_key("ITEM_"+UID)
		else :
			if UID.is_empty():
				KvStore.put("LOCAL_ITEM",value)
			else:
				KvStore.put("ITEM_"+UID,value)
			emit_signal("item_change")
	get :
		if UID.is_empty():
			return KvStore.get_value("LOCAL_ITEM",ItemWrapper.ITEM_DEFAULT)
		else:
			return KvStore.get_value("ITEM_"+UID,ItemWrapper.ITEM_DEFAULT)
#	set(value):
#		if value.has("itemLastSyncTime") and value.itemLastSyncTime > self.item.itemLastSyncTime:
#			KvStore.put("ITEM",value)
#			emit_signal("item_change")
#	get:
#		return KvStore.get_value("ITEM",{"data":{},"itemLastSyncTime":0})



func isLogin():
	return not UID.is_empty()

func logout() :

	map = {}
	item = {}
	role = {}
	pokemon = {}
	user = {}
	UID = ""

func doRefresh() :
	if user.is_empty() : return
	var httpResult = await UserService.profile(user.userBase.uId).request_completed
	var commonResult = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
	if commonResult == null : return
	self.user = commonResult
	
func isBoy() -> bool :
	return sex == SEX.BOY

func is_visitor_login():
	if local_user.has("SEX") and local_user.has("NICKNAME") and \
	local_user.has("POKEMON") and  local_user.has("ROLE") :
		if not local_user["POKEMON"].is_empty() and not local_user["ROLE"].is_empty():
			return true
	return false

func need_fill_info():
	if user.is_empty() or user.userBase.nickName == "" or \
	user.userPokemon.data.is_empty() or user.userRole.data.is_empty()  :
		return true
	else :
		return false
		


