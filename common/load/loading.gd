extends CanvasLayer
#var BaseRouter = self
signal complete(node)
var path = "" :
	set(value):
		path = value
		set_process(false)
		%ProgressBar.max_value = 100
		%ProgressBar.value = 0
		var state =  ResourceLoader.load_threaded_request(path, "", true)
		if state == OK: set_process(true)

func load_path(value,time_value = 0):
	self.path = value
	time = time_value
	$Control.visible = true
	return self

func _ready():
	$Control.visible = false
	set_process(false)

var time = 0
var progress: Array = []

func _process(_delta):
	var load_status = ResourceLoader.load_threaded_get_status(path, progress)
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED :
			set_process(false)
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS : 
			%ProgressBar.value = clamp(progress[0]*100,0,70)
		ResourceLoader.THREAD_LOAD_LOADED :
			set_process(false)
			var node = ResourceLoader.load_threaded_get(path).instantiate()
			node.visible = false
			get_tree().get_root().add_child(node)
			%ProgressBar.value = clamp(progress[0]*100,0,80)
			complete.emit(node)
			var tween = get_tree().create_tween()
			tween.tween_property(%ProgressBar,"value",100,time)

			await get_tree().create_timer(time).timeout
			node.visible = true
			$Control.visible = false

