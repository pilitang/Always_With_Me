class_name CommonRefreshHeader
extends RefreshInterface

func _ready():
	visible = false
	
func status_change():
	status_refreshing() if status == STATUS_LOADING else status_none()
	
func offset_change():
	if status == STATUS_LOADING :
		status_refreshing()
	elif offset > getStartOffset() :
		status_can_refresh()
	else : 
		status_none()

func status_none():
	%label.text = "下拉刷新"
	%arrowDown.visible = true
	%loading.visible = false
	%arrowDown.status = false
	%loading.status = false
	if offset >0 :
		visible = true
	else :	
		visible = false	
	
func status_can_refresh():
	%label.text = "释放刷新"

	%arrowDown.visible = true
	%loading.visible = false
	%arrowDown.status = true
	%loading.status = false
	visible = true
func status_refreshing():
	%arrowDown.visible = false
	%loading.visible = true
	%arrowDown.status = false
	%loading.status = true
	%label.text = "刷新中"
	visible = true

