@tool
extends Container

class_name WaterfallFlowContainer

# The flow container will fit as many children in a row as it can
# using their minimum size, and will then continue checked the next row.
# Does not use SIZE_EXPAND flags of children.

# TODO: half-respect vertical SIZE_EXPAND flags by expanding the child to match
#       the tallest child in that row?
# TODO: Respect scaled children?
# TODO: Can we find a way to intuitively use a child's horizontal SIZE_EXPAND
#       flag?

@export var h_separation: int = 0
@export var v_separation: int = 0
@export var columns: int = 2

var reported_height_at_last_minimum_size_call: float = 0
	
func _get_minimum_size() -> Vector2:
	var height = calculate_layout(false)
	reported_height_at_last_minimum_size_call = height
	return Vector2(size.x, height)

func _notification(what):
	if (what==NOTIFICATION_SORT_CHILDREN):
		var height = calculate_layout(true)
		size.y = height
		if height != reported_height_at_last_minimum_size_call:
			make_parent_reevaluate_our_size()
# If apply is true, the children will actually be moved to the calculated
# locations.
# Returns the resulting height.
func calculate_layout(apply: bool,childNum :int = get_child_count()) -> float:
	var container_width: float = size.x

	var fixWidth = (container_width-h_separation*(columns-1))/columns 
	var current_column : int = 0
	var columnsHeight : Array = []
	for column in columns :
		columnsHeight.append(0)
	
	var prePositionHeight= 0
	for childIndex in childNum :
		var child = get_child(childIndex)
		if child == null :
			continue
		if not child.has_method("get_combined_minimum_size"):
			continue
		if not child.visible:
			continue
		var child_min_size: Vector2 = child.get_combined_minimum_size()
		child.custom_minimum_size = Vector2(fixWidth, child_min_size.y)	
		var curPosition = Vector2.ZERO
		
		if child is BaseDataControl and child.data.has("waterfall"):
			current_column = child.data.waterfall.column
			var positionHeight = prePositionHeight+child.data.waterfall.diffHeight
			curPosition = Vector2( current_column*(fixWidth+h_separation), positionHeight)
			columnsHeight[current_column] =positionHeight + child_min_size.y
			prePositionHeight = positionHeight
		else :
			var minHeight = columnsHeight[0]
			for column in columns :
				minHeight = min(columnsHeight[column],minHeight)
			for column in columns :
				if minHeight ==  columnsHeight[column] :
					current_column = column
					break
					
			var margin = v_separation
			if child.get_index() < columns :
				margin = 0

			curPosition = Vector2( current_column*(fixWidth+h_separation), columnsHeight[current_column] + margin)
			if child is BaseDataControl :
				child.data["waterfall"] = {
					"column" : current_column,
					"diffHeight" : (curPosition.y - prePositionHeight)

				}
			prePositionHeight = curPosition.y
			columnsHeight[current_column] += child_min_size.y + margin
		
		if apply:
			fit_child_in_rect(child, Rect2(curPosition, child_min_size))
			
	var maxHeight = 0
	for column in columns :
		maxHeight = max(columnsHeight[column],maxHeight)
	return maxHeight
	
func make_parent_reevaluate_our_size():
	# Hacky solution. Once there is a function for this, use it.
	custom_minimum_size = Vector2(0, 20000)
	custom_minimum_size = Vector2(0, 0)
