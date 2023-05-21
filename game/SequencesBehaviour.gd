extends Node

@onready var level_manager = $/root/Control/LevelManager
@onready var game_menu = $/root/Control/Menu

const note_dir = "res://game/notes/%s.txt"

var current_items

# Called when the node enters the scene tree for the first time.
func _ready():
	current_items = game_menu.get("inventory")

func add_item(item_name : StringName):
	game_menu.inventory_add(item_name)
	current_items = game_menu.get("inventory")
	
func remove_item(item_name : StringName):
	game_menu.inventory_remove(item_name)
	current_items = game_menu.get("inventory")

func item_check(items : Array[String]):
	for item in items:
		if(current_items.has(items)):
			return true

func note_load(note_name : StringName):
	var text = FileAccess.open(note_dir % note_name, FileAccess.READ).get_as_text()
	game_menu.note_add(text)

func note_add(note_text : String):
	game_menu.note_add(note_text)
