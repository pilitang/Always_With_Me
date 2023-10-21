extends BaseDataControl


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SHARE_PLATFORM_WEIXIN = 1
const SHARE_PLATFORM_WEIXIN_CIRCLE = 2
const SHARE_PLATFORM_QQ = 3
const SHARE_PLATFORM_QZONE = 4
# Called when the node enters the scene tree for the first time.
func share(platform):
	if SysUtil.isAndroid() and Engine.has_singleton("AndroidNative"):
		var singleton = Engine.get_singleton("AndroidNative")
		singleton.share(platform,data)
	if SysUtil.isIOS() and Engine.has_singleton("IphoneNative"):
		var singleton = Engine.get_singleton("IphoneNative")
		singleton.share(platform,data)
	super.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_weixin_on_click(node):
	share(SHARE_PLATFORM_WEIXIN)
	pass # Replace with function body.


func _on_weixinCircle_on_click(node):
	share(SHARE_PLATFORM_WEIXIN_CIRCLE)
	pass # Replace with function body.


func _on_QQ_on_click(node):
	share(SHARE_PLATFORM_QQ)
	pass # Replace with function body.


func _on_QZone_on_click(node):
	share(SHARE_PLATFORM_QZONE)
	pass # Replace with function body.


func _on_on_click(node):
	super.queue_free()
	pass # Replace with function body.
