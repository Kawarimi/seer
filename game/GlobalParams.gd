@tool
extends Node

@export var params : Dictionary
@export var load_params = false

func _process(_delta):
	if Engine.is_editor_hint():
		if load_params:
			print("extending global param list")
			var all_params = FileAccess.open("res://game/all_params.txt", FileAccess.READ)
			print(all_params.get_csv_line())
			for p in all_params.get_csv_line():
				if not params[p]:
					params[p] = false
			load_params = false
	
func on_load(data):
	params = data

func on_save():
	return params
