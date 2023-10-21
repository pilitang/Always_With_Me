class_name SvgAnimation
extends BaseControl


@export var status : bool = false : 
	set(value) :
		if status != value:
			if value:
				status_change(true)
			else :
				status_change(false)
		status = value

func status_change(_status):
	pass
