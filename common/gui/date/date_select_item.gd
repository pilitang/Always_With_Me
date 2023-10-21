extends BaseDataControl
var obvious = false

	
func data_update():
	self.text = str(data)
	pass
func _ready():
	modulate.a = 0.1
func _process(delta):
	if obvious:
		modulate.a = 1
		obvious = false
	else:
		modulate.a = 0.3
