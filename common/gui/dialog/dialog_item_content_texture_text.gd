extends BaseDataControl

#data = [{path:"",text:""}]
var is_separation_line = true
	
func data_update():
	%separation_line.visible = is_separation_line
	%label.text = data.text
	if data.path != "":
		%textureContainer.visible = true
		%textureRect.texture = load(data.path)
	else :
		%textureContainer.visible = false
