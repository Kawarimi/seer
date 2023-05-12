extends Node

@onready var menu_panel = $TopPanel
@onready var game_panel = $GamePanel
@onready var item_panel = $ItemsPanel
@onready var note_panel = $NotesPanel
@onready var menu_item = preload("res://ui/item.tscn")
@onready var item_container = $ItemsPanel/ScrollContainer/VBoxContainer
@onready var item_display = $ItemsPanel/ItemDisplay

var items_list : Dictionary

var enabled = true
var confirm = false
var current_menu = 0

var inventory : Array[String]
var notes : Array[String]

signal opened

func _ready():
	for item_dir in DirAccess.open("res://game/items").get_files():
		var item = load("res://game/items/%s"%item_dir)
		items_list[item.get("name")] = item
	print(items_list)

func _process(_delta):
	if enabled:
		if Input.is_action_just_pressed("menu"):
			if(menu_panel.visible):
				menu_close()
			else:
				menu_open()
		if note_panel.has_focus():
			if Input.is_action_just_pressed("ui_right"):
				pass #NOTES SCROLL HERE
			if Input.is_action_just_pressed("ui_left"):
				pass #NOTES SCROLL HERE

func inventory_load():
	inventory.sort()
	for item in inventory:
		var new_item = menu_item.instantiate()
		item_container.add_child(new_item)
		new_item.connect("focus_entered", _on_item_focus_entered.bind(item))
		new_item.set("text", item)
	if(len(inventory)>0):
		var items_button = $TopPanel/ItemsButton
		item_container.get_child(0).focus_neighbor_top = items_button.get_path()
		items_button.focus_neighbor_bottom = item_container.get_child(0).get_path()

func inventory_clean():
	for child in item_container.get_children():
		child.queue_free()

func menu_open():
	menu_panel.show()
	menu_panel.get_child(current_menu).grab_focus()
	opened.emit(true)
	
func menu_close():
	hide_all()
	menu_panel.hide()
	opened.emit(false)

func _on_save_menu_opened(status):
	enabled = !status

func _on_use_button_pressed():
	pass # Replace with function body.

func _on_discard_button_pressed():
	pass # Replace with function body.

func _on_items_button_focus_entered():
	hide_all()
	current_menu = 0
	if(len(inventory)>0):
		item_panel.show()

func _on_notes_button_focus_entered():
	hide_all()
	current_menu = 1
	note_panel.show()

func _on_game_button_focus_entered():
	hide_all()
	current_menu = 2
	game_panel.show()

func hide_all():
	item_panel.hide()
	game_panel.hide()
	note_panel.hide()
	item_display.hide()

func _on_item_focus_entered(item_name):
	var item = items_list[item_name]
	item_display.display(item.get("desc"),item.get("price"),item.get("img"))
	item_display.show()

func inventory_add(item):
	inventory.append(item)
	inventory_load()

func inventory_remove(item):
	inventory.remove_at(inventory.find(item))
	inventory_load()

func on_save():
	return [inventory, notes]

func on_load(data):
	inventory = data[0]
	notes = data[1]
