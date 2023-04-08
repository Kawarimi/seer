extends Node

const save_slot = preload("res://ui/save_slot.tscn")
const max_saves = 7
@onready var container = $MenuPanel/VBoxContainer

signal save_game
signal player_activated

var selected_index = 0
var active = false

func _process(_delta):
	if active:
		if(Input.is_action_just_pressed("ui_up")):
			var idx = selected_index-1
			if 0 <= idx:
				selected_index = idx
		if(Input.is_action_just_pressed("ui_down")):
			var idx = selected_index+1
			if idx < max_saves:
				selected_index = idx
		if Input.is_action_just_pressed("ui_cancel"):
			hide_menu()
			
func on_save_accept():
	save_game.emit(selected_index)
	container.get_child(selected_index).set_text("SAVED")
	await get_tree().create_timer(0.5).timeout
	hide_menu()

func show_menu():
	$MenuPanel.show()
	var saves = FileAccess.open(SaveFile.meta_path, FileAccess.READ)
	if saves:
		saves = saves.get_var()

	for i in max_saves:
		var slot = save_slot.instantiate()
		container.add_child(slot)
		if saves and saves.has(i):
			var meta = saves[i]
			slot.set_meta_labels(meta["date"], ("at %s" % meta["onload"]))
		slot.set_text("SAVE %s" % (i+1))
		slot.set_menu(self)
		slot.set_focus_mode(2)

	container.get_child(0).grab_focus()
	
	await get_tree().process_frame
	player_activated.emit(false)
	active = true

func hide_menu():
	for n in container.get_child_count():
		container.get_child(n).queue_free()
	$MenuPanel.hide()
	active = false
	player_activated.emit(true)
	if get_node_or_null("/root/Control/LevelManager/home/TileMap/Diary"):
		$/root/Control/LevelManager/home/TileMap/Diary.close_diary()
