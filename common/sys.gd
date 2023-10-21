extends Node

signal sys_init_change(data)
signal sys_resume_change(data)
signal sync_status_change(data)
signal notify_update_msg()

var sysInitData : Dictionary : 
	set(value):
		KvStore.put("SYSINIT",value)
		emit_signal("sys_init_change",value)
		
	get:
		return KvStore.get_value("SYSINIT",{})
	
var sysResumeData : Dictionary : 
	set(value):
		KvStore.put("SYSRESUME",value)
		emit_signal("sys_resume_change",value)
	get:
		return KvStore.get_value("SYSRESUME",{})


var mapLastSyncTime = 0
var itemLastSyncTime = 0

var syncStatus : Dictionary : 
	set(value):
		KvStore.put("SYNCSTATUS",value)
		TimeUtil.setTimeOffset(value.serverTime)
		emit_signal("sync_status_change",value)
		mapLastSyncTime = syncStatus.mapLastSyncTime
		itemLastSyncTime = syncStatus.itemLastSyncTime
		if value.bolNewMsg == true :
			emit_signal("notify_update_msg")
		if value.invalid != 0 :
			ToastRouter.showToast(value.invalidRemind)
			Account.logout()
	get :
		return KvStore.get_value("SYNCSTATUS",{})

var resource :Dictionary :
	set(value):
		KvStore.put("RESOURCE",value)
	get:
		return KvStore.get_value("RESOURCE",{})
	
var userSkin :Dictionary :
	set(value):
		KvStore.put("USER_SKIN",value)
	get:
		return KvStore.get_value("USER_SKIN",{})

var userPokemon :Dictionary :
	set(value):
		KvStore.put("USER_POKEMON",value)
	get:
		return KvStore.get_value("USER_POKEMON",{})

#data class ItemActionRecord(
#    var itemId: Int,
#    var time :Long,
#    var source : Int,
#    var count : Int
#)

var itemActionRecord = [] : 
	set(value):
		KvStore.put("ITEM_ACTION_RECORD",value)
	get:
		return KvStore.get_value("ITEM_ACTION_RECORD",[])

func item_action_record_add(itemId,source=0,count=1):
	var temp = itemActionRecord
	var time = TimeUtil.serverTimeMillsecond()
	temp.append({"itemId":itemId,"source":source,"count":count,"time":time})
	self.itemActionRecord = temp
	var item = Account.item.duplicate(true)
	item[ItemWrapper.ITEM_LAST_SYNC_TIME] = time
	if !item[ItemWrapper.DATA].has(str(itemId)):
		item[ItemWrapper.DATA][str(itemId)] = 0
	item[ItemWrapper.DATA][str(itemId)] += count
	if TaskWRapper.has_task(itemId,source):
		TaskWRapper.task_modify(itemId,source,abs(count))
	Account.item = item
	

var polling:Timer

var planetItemConfig = {}
var roleInitConfig = {}
var textureConfig = {}	
var meshConfig = {}
var sceneConfig = {}
var characterEidtConfig = {}
var itemCategoryConfig = {}
var itemCategoryConfigKey = {}
var itemCategoryPrimaryConfig = {}
var pokemonSelectConfig = {}
var planetInitConfig = {}

var itemDetailConfig = {}
var cropConfig = {}

var illustratedBookConfig = {}
var shopConfig = {}



var itemSyncPollTime = 0

var rockId = "57"
var treeId = "58"
var shellId = "59"
var fruitId = "60"

func _init():
	initPushToken()
	initLocalConfig()

const CONFIG_PREFIX = "res://config/json/"
const CONFIG_SUFFIX = ".json"
func initLocalConfig():
	meshConfig = FileUtil.loadAssets(CONFIG_PREFIX+"mesh"+CONFIG_SUFFIX)
	textureConfig = FileUtil.loadAssets(CONFIG_PREFIX+"texture"+CONFIG_SUFFIX)
	sceneConfig = FileUtil.loadAssets(CONFIG_PREFIX+"scene"+CONFIG_SUFFIX)
	planetItemConfig = FileUtil.loadAssets(CONFIG_PREFIX+"planetItem"+CONFIG_SUFFIX)
	roleInitConfig = FileUtil.loadAssets(CONFIG_PREFIX+"roleInitConfig"+CONFIG_SUFFIX)
	characterEidtConfig =  FileUtil.loadAssets(CONFIG_PREFIX+"characterEidtInitConfig"+CONFIG_SUFFIX)
	pokemonSelectConfig =  FileUtil.loadAssets(CONFIG_PREFIX+"pokemonSelectConfig"+CONFIG_SUFFIX)

	itemCategoryConfig = FileUtil.loadAssets(CONFIG_PREFIX+"itemCategoryConfig"+CONFIG_SUFFIX)
	
	itemCategoryConfigKey = itemCategoryConfig.data.keys()
	itemCategoryPrimaryConfig =  FileUtil.loadAssets(CONFIG_PREFIX+"itemCategoryPrimaryConfig"+CONFIG_SUFFIX)
	
	planetInitConfig =  FileUtil.loadAssets(CONFIG_PREFIX+"planetInitConfig"+CONFIG_SUFFIX)

	itemDetailConfig = FileUtil.loadAssets(CONFIG_PREFIX+"itemDetailConfig"+CONFIG_SUFFIX)
	
	cropConfig = FileUtil.loadAssets(CONFIG_PREFIX+"cropConfig"+CONFIG_SUFFIX)
	
	illustratedBookConfig = FileUtil.loadAssets(CONFIG_PREFIX+"illustratedBook"+CONFIG_SUFFIX)
	shopConfig = FileUtil.loadAssets(CONFIG_PREFIX+"shopConfig"+CONFIG_SUFFIX)

	


func _ready():
	Account.connect("uid_change",Callable(self,"uid_change"))
	

func uid_change():
	Global.webSocket.close()
	Sys.sysResume()


	

	

	

	
	
#生成轮询计时器
func add_polling():
	polling = Timer.new()
	polling.name = "Polling"
	polling.autostart = true
	polling.connect("timeout",Callable(self,"polling_timeout"))
	polling.paused = false
	add_child(polling)
	polling.start(1)


func polling_timeout():
	
	if not Account.isLogin() :return
	
	if TimeUtil.get_system_time_secs() %10 == 0:
		pushItemActionRecord()
		pullItem()
		
		pushMap()
		pullMap()
		
	if Global.webSocket.isActive() : return
	
	Global.webSocket.open()
	sync_status()

func initPushToken():
	if SysUtil.isAndroid() and Engine.has_singleton("AndroidNative"):
		var singleton = Engine.get_singleton("AndroidNative")
		singleton.connect("pushTokenChange",Callable(self,"pushTokenChange"))
	if SysUtil.isIOS() and Engine.has_singleton("IphoneNative"):
		var singleton = Engine.get_singleton("IphoneNative")
		singleton.connect("device_address_changed",Callable(self,"pushTokenChange"))
		
func pushTokenChange(_value :String):
	sysInit()
	
func getPushToken():
	var pushToken = ""
	if SysUtil.isAndroid() and Engine.has_singleton("AndroidNative"):
		var singleton = Engine.get_singleton("AndroidNative")
		pushToken = singleton.getPushToken()
	if SysUtil.isIOS() and Engine.has_singleton("IphoneNative"):
		var singleton = Engine.get_singleton("IphoneNative")
		pushToken = singleton.getPushToken()
	return pushToken
	
func sysInit() -> bool:
#	if not KVStore.get_value(ModuleCommon.SHOW_FIRST_OPEN ) : return
	var httpResult = await SysService.init( getPushToken() ).request_completed
	var result = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
	if result == null : return false
	self.sysInitData = result
	return true

func sysResume() :
	var httpResult = await SysService.resume().request_completed
	var result = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
	if result == null : return 
	self.sysResumeData = result

func sync_status() :
	var httpResult = await SysService.syncStatus().request_completed
	var result = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
	if result == null : return 
	self.syncStatus = result
#	print(syncStatus,"======================")

func resetNewCommentedNum():
	self.syncStatus.newCommentedNum = 0


#
#获取背包数据
func pullItem() -> bool :
	if itemLastSyncTime >0 and Account.item.itemLastSyncTime < itemLastSyncTime :
		var httpResult = await UserPlanetService.pullItem().request_completed
		var result = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
		if result == null : return false 
		Account.item = result
		return true
	else:
		return true
#上传背包数据
func pushItemActionRecord():
	if Account.item.itemLastSyncTime >= itemLastSyncTime and !itemActionRecord.is_empty():
		var pushArr = []
		for i in 10 :
			if i < itemActionRecord.size():
				pushArr.append(itemActionRecord[i])
			else :
				break
		var httpResult = await UserPlanetService.pushItemActionRecord(JsonWrapper.toJson({"list":pushArr})).request_completed
		var result = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
		if result != null :
				Account.item = result
				for record in pushArr:
					itemActionRecord.erase(record)
			
func pullMap() -> bool :
	if mapLastSyncTime >0 and Account.map.lastUpdateTime < mapLastSyncTime :
		var httpResult = await UserPlanetService.map(Account.user.userBase.uId ).request_completed
		var result = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
		if result != null :
			result.data = JsonWrapper.convertJson(result.data)
			Account.map = result
			mapLastSyncTime = result.lastUpdateTime
			return true
		else :
			return false
	else : 
		return true

func pushMap():
	if Account.map.lastUpdateTime > mapLastSyncTime :
		var httpResult = await UserPlanetService.updateMap(Account.map.lastUpdateTime ,JsonWrapper.toJson(Account.map.data)).request_completed
		var result = BaseNetwork.parse_send_result(httpResult[0],httpResult[1],httpResult[3],false)
		if result != null :
			result.data = JsonWrapper.convertJson(result.data)
			Account.map = result
			mapLastSyncTime = result.lastUpdateTime
