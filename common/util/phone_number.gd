class_name PhoneNumber
extends RefCounted


static func testing(number:String)->bool:
	var regex = RegEx.new()
	regex.compile("^\\d{11}$")
	return regex.search(number) != null
