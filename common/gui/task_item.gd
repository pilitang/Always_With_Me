extends BaseDataControl


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func data_update():
	set_meta(Meta.DATA,data)
	self.text = data.describe + " ("+str(data.number)+"/"+str(data.number_max)+")"
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
