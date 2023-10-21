@tool
extends BaseControl
@export var text = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	%Label.text = text

