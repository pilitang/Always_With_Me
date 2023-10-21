class_name CommonPagerDelegate
extends RefCounted

var pager : CommonPager = null
var indicator : CommonIndicator = null

func _init(p : CommonPager,i : CommonIndicator):
	pager = p
	indicator = i
	
	pager.connect("slide_distance_change",Callable(indicator,"slide_distance_change"))
	pager.connect("index_change",Callable(indicator,"index_change"))
	indicator.connect("click",Callable(pager,"set_index"))
