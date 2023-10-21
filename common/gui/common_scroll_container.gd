class_name CommonScrollContainer
extends BaseScrollContainer



const TYPE_HEADER = "header"
const TYPE_FOOTER = "footer"
const TYPE_ITEM = "item"
const META_TYPE = "type"

signal load_more

signal on_item_click(node)
signal on_item_long_click(node)

signal on_child_item_click(child,node)
signal on_child_item_long_click(child,node)

signal complete()
@onready var container : Container = get_child(0)
var itemScene :Resource = null

var header :BaseDataControl = null
var footer :BaseDataControl = null

var childClickName : Array = []

var needRefresh : bool  = true
var hasMore: bool  = false
var pageKey: String = ""    #获取更多时需要传入那个key
var pageValue: String = ""   #翻页pageKey对应的值

var data : Array : set = data_set
func data_set(new_value :Array):
	var headerNum :int = 1 if hasHeader() and header.get_parent() !=null else 0
	for index in container.get_child_count() :
		var item = container.get_child(index)
		if getMeta(item,META_TYPE) == TYPE_ITEM :
			if index - headerNum < new_value.size()  :
				item.data = new_value[index - headerNum ]
	for item in container.get_children() :
		if getMeta(item,META_TYPE) == TYPE_ITEM :
			if not new_value.has(item.data) :
				removeItem(item)
	if hasHeader() and header.get_parent() == null : addHeader()
	setScrollvalue(0)
	data = new_value
	queue_sort()

func data_change(index ,value):
	var item = find_item(data[index])
	if item != null:
		item.data = value
	data[index] = value

func _ready():

	connect("scroll_started",Callable(self,"scroll_started"))
	connect("scroll_ended",Callable(self,"scroll_ended"))

var isScrolling = false
func scroll_started():
	isScrolling = true
func scroll_ended():
	isScrolling = false
	queue_sort()
	
	
func getScrollOffset() -> int:
	return max(800,getScrollLength())*3
	
func getScrollLength() -> float:
	if container is VBoxContainer:
		return size.y
	elif container is HBoxContainer:
		return size.x
	elif vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
		return size.y
	elif vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		return size.x
	else : return size.y

func getContainerLength() -> float:
	if container is VBoxContainer:
		return container.size.y
	elif container is HBoxContainer:
		return container.size.x
	elif vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
		return container.size.y
	elif vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		return container.size.x
	else : return container.size.y


func getCurrentScrollPosition() -> int:
	if container is VBoxContainer:
		return scroll_vertical
	elif container is HBoxContainer:
		return scroll_horizontal
	elif vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
		return scroll_vertical
	elif vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		return scroll_horizontal
	else : return scroll_vertical

func scrollMaxValue() :
	if container is VBoxContainer:
		return get_v_scroll_bar().max_value
	elif container is HBoxContainer:
		return get_h_scroll_bar().max_value
	elif vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
		return get_v_scroll_bar().max_value
	elif vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		return get_h_scroll_bar().max_value
	else : return get_v_scroll_bar().max_value


func getItemLength(item :Control) -> int:
	var combin_size = item.get_combined_minimum_size()
	if container is VBoxContainer:
		return combin_size.y
	elif container is HBoxContainer:
		return combin_size.x
	elif vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
		return combin_size.y
	elif  vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		return combin_size.x
	else : return combin_size.y

func getSeparation() -> int:
	if container is BoxContainer :
		return  container.get("theme_override_constants/separation")  if container.get("theme_override_constants/separation") !=null else 4
	elif container is GridContainer :
		if vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
			return  container.get("theme_override_constants/v_separation")  if container.get("theme_override_constants/v_separation") !=null else 4
		elif vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
			return  container.get("theme_override_constants/h_separation")  if container.get("theme_override_constants/h_separation") !=null else 4
		else : 
			return  container.get("theme_override_constants/v_separation")  if container.get("theme_override_constants/v_separation") !=null else 4
	elif container is WaterfallFlowContainer :
		return container.v_separation
	return 0


func setScrollvalue(value :int) :
	if container is VBoxContainer:
		scroll_vertical = value
	elif container is HBoxContainer:
		scroll_horizontal = value
	elif vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
		scroll_vertical = value
	elif vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		scroll_horizontal = value
	else :
		scroll_vertical = value

func canRefresh() -> bool :
	if not needRefresh : return false 
	var result = false;
	if container is VBoxContainer:
		result = vertical_scroll_mode != SCROLL_MODE_DISABLED and scroll_vertical == 0 
	elif container is HBoxContainer:
		result = horizontal_scroll_mode != SCROLL_MODE_DISABLED and scroll_horizontal == 0 
	elif vertical_scroll_mode != SCROLL_MODE_DISABLED  and horizontal_scroll_mode == SCROLL_MODE_DISABLED:
		result = vertical_scroll_mode != SCROLL_MODE_DISABLED and scroll_vertical == 0 
	elif vertical_scroll_mode == SCROLL_MODE_DISABLED and horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		result = horizontal_scroll_mode != SCROLL_MODE_DISABLED  and scroll_horizontal == 0 
	else : 
		result = vertical_scroll_mode != SCROLL_MODE_DISABLED and scroll_vertical == 0 
		
	if not result : return false 
	var isFirst = false
	var firstItem = container.get_child(0) if container.get_child_count() >0 else null	
	
	if firstItem != null :
		if hasHeader() and header.get_parent() == null and getMeta(firstItem,META_TYPE) == TYPE_HEADER :
			isFirst = true
		if not hasHeader() and getMeta(firstItem,META_TYPE) == TYPE_ITEM and data.find(firstItem.data)  == 0 :
			isFirst = true
	else:
		isFirst = true
	return isFirst 
	
func canLoadMore() -> bool :
	return hasMore

func _notification(what):
	if (what==NOTIFICATION_SORT_CHILDREN):
		need_update()

var isUpdate = false

func need_update():
	if data.size() <= 0 : return
	if isUpdate : return
	isUpdate = true
	var next = false
	if container is BoxContainer :
		next = await box_update()
	if container is GridContainer  :
		next = await grid_update()
	isUpdate = false
	if next : queue_sort()
	complete.emit()

func grid_update()  -> bool :
	var columns = container.columns
	var removeList = []
	var currentScrollPosition = getCurrentScrollPosition() 
	var scrollLength = getScrollLength()
	var scrollOffset = getScrollOffset()
	
	if container.get_child_count() <= 0 : 
		for index in columns:
			if index < data.size() : item_inserted(index) 
		return true
	else :
		if not SysUtil.isMobile() or (SysUtil.isMobile() and not isScrolling):
			var firstItem = container.get_child(0) 
			var itemLength = getItemLength(firstItem) 
			if currentScrollPosition - itemLength -getSeparation()  > scrollOffset :
				for index in columns:
						removeList.append(container.get_child(index))
			for item in removeList :
				removeItem(item)
			if removeList.size() >0  :
				setScrollvalue(currentScrollPosition - itemLength-getSeparation())
				await get_tree().process_frame
				return true


			if firstItem !=null and currentScrollPosition  < scrollOffset and getMeta(firstItem,META_TYPE) == TYPE_ITEM :
				if data.find(firstItem.data) >0:
					for index in columns:
						item_inserted( data.find(firstItem.data)-index-1,false ) 
					await get_tree().process_frame
					setScrollvalue(getCurrentScrollPosition()+getItemLength( container.get_child(0))+getSeparation() )
					return true
					
		removeList = []
		var lastItem =container.get_child( container.get_child_count() -1) 
		if getContainerLength() - getItemLength(lastItem)-getSeparation() -currentScrollPosition > scrollLength+scrollOffset :
			for index in columns:
				removeList.append(container.get_child(container.get_child_count()-1-index))
		for item in removeList :
			removeItem(item)
		if removeList.size() >0  :
			await get_tree().process_frame
			return true
			
		if getContainerLength() -currentScrollPosition < scrollLength+scrollOffset :
			if getMeta(lastItem,META_TYPE) == TYPE_ITEM :
				var lastIndex = data.find(lastItem.data)
				if lastIndex < data.size() -1 :
					for index in columns:
						if lastIndex+ index+1 < data.size() : item_inserted(lastIndex+ index+1  ) 
					await get_tree().process_frame
					return true
				else :		
					if(canLoadMore()):
						emit_signal("load_more")
					else :
						addFooter()
	return false
	
func box_update() -> bool:

	var currentScrollPosition = getCurrentScrollPosition()
	var scrollLength = getScrollLength()
	var scrollOffset = getScrollOffset()
	
	if container.get_child_count() <= 0 : 
		item_inserted(0 ) 
		return true
	else :
		if not SysUtil.isMobile() or (SysUtil.isMobile() and not isScrolling):
			var firstItem = container.get_child(0)
			var itemLength = getItemLength(firstItem) 
			if currentScrollPosition - itemLength -getSeparation()  > scrollOffset :
				removeItem(firstItem)
				setScrollvalue(currentScrollPosition - itemLength - getSeparation()  )
				await get_tree().process_frame
				return true
		
			if currentScrollPosition  < scrollOffset  and getMeta(firstItem,META_TYPE) == TYPE_ITEM :
				if data.find(firstItem.data) >0:
					var firstIndex = data.find(firstItem.data)
					item_inserted( firstIndex-1,false )
					await get_tree().process_frame
					setScrollvalue(getCurrentScrollPosition() + getItemLength( container.get_child(0)) +getSeparation() )
					return true
				elif hasHeader():
					addHeader()
					await get_tree().process_frame
					setScrollvalue(currentScrollPosition + getItemLength(header)  +getSeparation()  )
					return true
					
		var lastItem =container.get_child( container.get_child_count() -1) 
		if getContainerLength() -getItemLength(lastItem) -getSeparation() -currentScrollPosition > scrollLength +scrollOffset :
			removeItem(lastItem)
			await get_tree().process_frame
			return true
			
		if getContainerLength()  -currentScrollPosition < scrollLength+scrollOffset  :
			if getMeta(lastItem,META_TYPE) == TYPE_ITEM :
				var lastIndex = data.find(lastItem.data)
				if lastIndex < data.size() -1 :
					item_inserted(lastIndex +1 )
					if(data.size()-1 > lastIndex +1) : 
						await get_tree().process_frame
						return true
				else :	
					if(canLoadMore()):
						emit_signal("load_more")
					else :
						addFooter()
			elif getMeta(lastItem,META_TYPE) == TYPE_HEADER :
				item_inserted( 0 )
				await get_tree().process_frame
				return true
	return false

func registItemType(path : String) :
	itemScene = load(path)


func registHeader(path : String) :
	if header !=null : header.queue_free()
	header = load(path).instantiate()
	header.set_meta(META_TYPE,TYPE_HEADER)
	addHeader()

func registFooter(path : String) :
	if footer !=null : footer.queue_free()
	footer = load(path).instantiate()
	footer.set_meta(META_TYPE,TYPE_FOOTER)
	

func addHeader() :
	container.add_child(header) 
	container.move_child(header,0)
	
func addFooter() :
	if hasFooter() and footer.get_parent() == null : container.add_child(footer) 

func removeFooter() :
	if hasFooter() and footer.get_parent() != null: container.remove_child(footer) 
	
func hasHeader() -> bool :
	return header !=null

func hasFooter() -> bool :
	return footer !=null

func getMeta(item :Node,key :String):
	return item.get_meta(key ) if item != null and item.has_meta(key) else null

func add_data(list:Array ) :
	removeFooter() 
	data.append_array(list)
	queue_sort()
	
func insert_data(list:Array ) :
	list.reverse() 
	for value in list :
		data.insert(0,value)
	queue_sort()



func scroll_to_index( scroll_index : int ) :
	var headerNum :int = 1 if hasHeader() and header.get_parent() !=null else 0
	var removeList= []
	for index in container.get_child_count() :
		var item = container.get_child(index)
		if getMeta(item,META_TYPE) == TYPE_ITEM :
			if scroll_index + index - headerNum < data.size()  :
				item.data = data[scroll_index + index - headerNum ]
			else :
				removeList.append(item)
	for item in removeList :
		removeItem(item)

	if hasHeader() and header.get_parent() == null : addHeader()
	setScrollvalue(0)
	queue_sort()
	
func scroll_to_bottom():
	await get_tree().process_frame
	setScrollvalue( scrollMaxValue() )
	queue_sort()
	
func remove_data(index :int ) :
	if index >= data.size() or index < 0 : return
	var indexData = data.pop_at(index) 
	for item in container.get_children(): 
		if indexData == item.data :
			removeItem(item)

func get_data(index :int)  :
	if index >= data.size() or index < 0 : return null
	return data[index]

func get_index_by_data(value) -> int :
	return data.find(value)


func getItem() -> BaseDataControl:
	var item = itemScene.instantiate()
	item.set_meta(META_TYPE,TYPE_ITEM)
	item.connect("on_click",Callable(self,"item_click"))
	item.connect("on_long_click",Callable(self,"item_long_click"))
	for childName in childClickName :
		var child :BaseControl = item.find_child(childName)
		if child  != null :
			child.itemRoot = item
			child.connect("on_click",Callable(self,"item_child_click"))
			child.connect("on_long_click",Callable(self,"item_child_long_click"))
	return item

func removeItem(item : Node) :
#	print_debug("removeItem : ", data.find(item.data))
	if item.has_meta(META_TYPE) && (item.get_meta(META_TYPE) == TYPE_HEADER or item.get_meta(META_TYPE) == TYPE_FOOTER) :
		container.remove_child(item)
	elif item.has_meta(META_TYPE) && item.get_meta(META_TYPE) == TYPE_ITEM :
			container.remove_child(item)
			item.queue_free()
	
func item_inserted(index :int ,isEnd : bool =true ) -> BaseDataControl:
#	print_debug("item_inserted : ", index)
	var item : BaseDataControl = getItem() 
	if isEnd : 
		container.add_child(item) 
	else: 
		container.add_child(item) 
		container.move_child(item, 0) 
	item.data = data[index]
	return item
	
func find_item(itemData) :
	for item in container.get_children():
		if item.has_meta(META_TYPE) and item.get_meta(META_TYPE) == TYPE_ITEM and item.data == itemData :
			return item
	return null
	
func notify_data_change_id(index :int) :
	if index < data.size():
		notify_data_change(data[index])


func notify_data_change(itemData ) :
	for item in container.get_children(): 
		if itemData == item.data :
			item.data = itemData
			break


func item_click(node : BaseDataControl):
	emit_signal("on_item_click",node)

func item_long_click(node : BaseDataControl):
	emit_signal("on_item_long_click",node)

func item_child_click(node : BaseControl):
	emit_signal("on_child_item_click",node,node.itemRoot)

func item_child_long_click(node :BaseControl ):
	emit_signal("on_child_item_long_click",node,node.itemRoot)
		
