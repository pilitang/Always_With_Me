class_name RefreshInterface
extends Control

const STATUS_NONE = 0
const STATUS_LOADING = 1
var offset :int  = 0 :
	set(value):
		offset = value
		offset_change()

func offset_change():
	pass

var status :int = STATUS_NONE : 
	set(value):
		status = value
		status_change()

func status_change():
	pass
	
func getStartOffset()-> int:
	return get_parent().startOffset

