extends Node

var game_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	game_menu = Globals.game_menu

func add_item(item_name : StringName):
	game_menu.inventory_add(item_name)
	
func remove_item(item_name : StringName):
	game_menu.inventory_remove(item_name)

func note_load(note_name : StringName):
	print("Loading note: ",note_name)
	note_add(note_name)

func note_add(note_text : String):
	game_menu.note_add(note_text)

func param_change(p_name : String, value : bool):
	Globals.global_params.get("params")[p_name] = value
