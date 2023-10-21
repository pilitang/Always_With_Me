extends SvgAnimation

func status_change(_status:bool):
	if not is_inside_tree() :return
	if status :
		%animationPlayer.play("rotate")
	else :
		%animationPlayer.stop()
