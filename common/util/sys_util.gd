class_name SysUtil
extends RefCounted


static func isAndroid() -> bool :
	return OS.get_name() == "Android"

static func isIOS() -> bool :
	return OS.get_name() == "iOS"

static func isMobile() -> bool :
	return isAndroid() or isIOS()
	
static func deviceOp() -> String :
	var value = ""
	if isAndroid() and  Engine.has_singleton("AndroidNative"):
		var singleton = Engine.get_singleton("AndroidNative")
		value = singleton.getDeviceOp()
	if isIOS() and Engine.has_singleton("IphoneNative"):
		var singleton = Engine.get_singleton("IphoneNative")
		value = singleton.getDeviceOp()
	return value
	
static func deviceType() -> String :
	var value = ""
	if isAndroid() and  Engine.has_singleton("AndroidNative"):
		var singleton = Engine.get_singleton("AndroidNative")
		value = singleton.getDeviceType()
	if isIOS() and Engine.has_singleton("IphoneNative"):
		var singleton = Engine.get_singleton("IphoneNative")
		value = singleton.getDeviceType()
	return value
	
static func appVersion() -> String :
	var value = ""
	if isAndroid() and  Engine.has_singleton("AndroidNative"):
		var singleton = Engine.get_singleton("AndroidNative")
		value = singleton.getAppVersion()
	if isIOS() and Engine.has_singleton("IphoneNative"):
		var singleton = Engine.get_singleton("IphoneNative")
		value = singleton.getAppVersion()
	return value

static func apiVersion() -> String :
	return "1.0.2"
	
static func fillHeight(node : ColorRect) :
	if isAndroid() and  Engine.has_singleton("StatusBar"):
		var singleton = Engine.get_singleton("StatusBar")
		node.custom_minimum_size.x  = singleton.getHeight()
	if isIOS() and  Engine.has_singleton("StatusBar"):
		var _singleton = Engine.get_singleton("StatusBar")


static func createTimer(node :Node ,wait_time : float = 0.1) :
	var timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time =wait_time
	node.add_child(timer)
	return timer

#static func get_virtual_height():
#	if isMobile():
#		if isIOS() :
#			return int(float(DisplayServer.virtual_keyboard_get_height() - Global.normal_virtual_keyboard_height)/float(DisplayServer.screen_get_size().y)*1080)
#		else :
#			return DisplayServer.virtual_keyboard_get_height() - Global.normal_virtual_keyboard_height
#	else :
#		return 0

