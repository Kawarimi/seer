extends Node

const save_slot = preload("res://ui/save_slot.tscn")
const Save = preload("res://game/SaveFile.gd")
const max_saves = 7
@onready var container = $MenuPanel/VBoxContainer

signal save_game

var selected_index = 0
var active = false

func _ready():
	hide_menu()

func _process(_delta):
	if active:
		if(Input.is_action_just_pressed("ui_up")):
			var idx = selected_index-1
			if 0 <= idx:
				select_option(idx)
		if(Input.is_action_just_pressed("ui_down")):
			var idx = selected_index+1
			if idx < max_saves:
				select_option(idx)
		if Input.is_action_just_pressed("ui_accept"):
			save_game.emit(selected_index)
			container.get_child(selected_index).set_text("SAVED")
			await get_tree().create_timer(0.5).timeout
			hide_menu()

func show_menu():
	$MenuPanel.show()
	var saves = FileAccess.open(Save.meta_path, FileAccess.READ)
	if saves:
		saves = saves.get_var()

	for i in max_saves:
		var slot = save_slot.instantiate()
		container.add_child(slot)
		slot.set_text("SAVE %s" % (i+1))
		if saves and saves.has(i):
			var meta = saves[i]
			slot.set_date(meta["date"])
			slot.set_loc("at %s" % meta["onload"])
	container.get_child(0).selected()
	await get_tree().create_timer(0.2).timeout
	active = true
	
func select_option(target_index):
	container.get_child(selected_index).deselected()
	container.get_child(target_index).selected()
	selected_index = target_index

func hide_menu():
	for n in container.get_child_count():
		container.get_child(n).queue_free()
	$MenuPanel.hide()
	active = false
