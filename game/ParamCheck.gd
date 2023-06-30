extends Node

signal checked
signal checked_false
signal detected

@onready var check_on_area = get_node_or_null("Area2D")

func _ready():
	if check_on_area:
		check_on_area.connect("area_entered", area_entered)

func area_entered(_n):
	detected.emit()
	print("Param Area entered")

func check(param_name : String):
	var params = Globals.global_params.get("params")
	print("Checking: ",param_name)
	if params[param_name] == true:
		checked.emit()
	else:
		checked_false.emit()
	return params[param_name]

func save_exists_check():
	if FileAccess.open(SaveFile.save_path % SaveFile.save_idx, FileAccess.READ):
		checked.emit()
		return true
	checked_false.emit()
	return false

func _on_detected(type):
	match type:
		"save_check":
			save_exists_check()
		_:
			check(type)

func item_check(items : Array[String]):
	print("Checking: ",items)
	var inv = Globals.game_menu.get("inventory")
	if items in inv:
		checked.emit()
	else:
		checked_false.emit()
