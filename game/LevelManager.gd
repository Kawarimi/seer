extends Node

@onready var current_level = get_child(0)
const Save = preload("res://game/SaveFile.gd")
const level_path = "res://scenes/%s.tscn"

var seq_man
var player
var loaded_save

func _ready():
	find_new()
	if SaveFile.save_idx != null:
		load_game(SaveFile.save_idx)

func find_new():
	player = current_level.find_child("Player")
	seq_man = current_level.find_child("Sequences")
	print(player)

func load_level(level : String):
	current_level.queue_free()
	await get_tree().process_frame
	
	var scene = load(level_path % level)
	add_child(scene.instantiate())
	current_level = get_child(0)
	find_new()
	
	for node in loaded_save[current_level.name]:
		get_node(node).on_load(loaded_save[current_level.name][node])

func player_to_point(point: Vector2):
	player.global_position = point

func _on_textbox_player_activated(state):
	player.set("active", state) 

func _on_textbox_text_finished():
	seq_man.text_finished()

func load_game(idx):
	var level = FileAccess.open(Save.meta_path, FileAccess.READ).get_var()[idx]["onload"]
	loaded_save = FileAccess.open(Save.save_path % idx, FileAccess.READ).get_var()

	load_level(level)

func save_nodes():
	var nodes = get_tree().get_nodes_in_group("Persist")
	var save_data = {}
	for n in nodes:
		print("Saved ", n.name)
		save_data.merge({n.get_path():n.on_save()})
	
	return save_data

func _on_save_menu_save_game(save_idx : int):
	var timedate = Time.get_datetime_string_from_system(false,true)
	
	var save = Save.save_new(current_level.name,save_nodes()) #add other levels !!!
	var meta = Save.meta_new(save_idx, timedate, current_level.name) #add player custom name
	
	FileAccess.open(Save.save_path % save_idx, FileAccess.WRITE).store_var(save)
	FileAccess.open(Save.meta_path, FileAccess.WRITE).store_var(meta)
