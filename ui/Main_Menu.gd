extends "res://ui/SaveMenu.gd"

@onready var continue_button = $Continue
@onready var load_button = $Load
@onready var load_menu = $MenuPanel
#@onready var load_container = $MenuPanel/VBoxContainer
var instructions_shown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.open(SaveFile.meta_path, FileAccess.READ) == null:
		continue_button.disabled = true
		load_button.disabled = true
	$"New Game".grab_focus()
		
func _process(_delta):
	if instructions_shown:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://scenes/Game1.tscn")
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
	load_game(selected_index)

func _on_play_pressed():
	$Instructions.show()
	instructions_shown = true

func _on_load_pressed():
	show_menu()
	for slot in container.get_children():
		slot.disable_invalid()

func _on_quit_pressed():
	get_tree().quit()

func load_game(idx):
	get_tree().change_scene_to_file("res://scenes/Game1.tscn")
	SaveFile.save_idx = idx

func _on_settings_pressed():
	$SettingsPanel.show()

func _on_continue_pressed():
	var meta = FileAccess.open(SaveFile.meta_path, FileAccess.READ).get_var()
	var unix_dates = []
	for save in meta:
		unix_dates.append(Time.get_unix_time_from_datetime_string(meta[save]["date"]))
	var latest = unix_dates.find(unix_dates.max())
	load_game(latest)
