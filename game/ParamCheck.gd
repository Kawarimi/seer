extends Node

signal checked
signal detected

@onready var check_on_area = get_node_or_null("Area2D")

func _ready():
	check_on_area.connect("area_entered", area_entered)

func area_entered(_n):
	detected.emit()
	print("Param Area entered")

func globals_check(param_name):
	if Globals.get(param_name):
		checked.emit()
	return Globals.get(param_name)

func save_exists_check():
	if FileAccess.open(SaveFile.save_path % SaveFile.save_idx, FileAccess.READ):
		checked.emit()
		return true
	return false

func _on_detected(type):
	if type == "save_check":
		save_exists_check()
	else:
		globals_check(type)
