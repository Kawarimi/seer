extends Node

@onready var current_level = get_child(0)
@onready var sequences = get_node(current_level.name+"/Sequences").get_children()
const level_path = "res://scenes/%s.tscn"

signal level_loaded

var save : Dictionary

var player

func _ready():
	find_new(current_level)
	if(FileAccess.open(SaveFile.save_path % 0, FileAccess.READ)): #TEMP DEV CODE
			SaveFile.save_idx = 0
	if SaveFile.save_idx != null:
		print("Loading game from save ", SaveFile.save_idx)
		load_game(SaveFile.save_idx)
		await level_loaded
	seq_init_all()

func find_new(on_scene):
	player = on_scene.find_child("Player")
	sequences = get_node(on_scene.name+"/Sequences").get_children()

func load_level(level : String):
	if current_level.name != level:
		save[current_level.name] = save_nodes()
	current_level.queue_free()
	
	var scene = load(level_path % level)
	var new_level = scene.instantiate()
	add_child(new_level)
	new_level.set_owner(self)
	find_new(new_level)
	
	if save.has(level):
		for node in save[level]:
			get_node(node).on_load(save[level][node])

	current_level = new_level
	level_loaded.emit()
	return new_level

func player_to_point(point: Vector2):
	print("Moving player to: ", point)
	player.global_position = point

func player_activated(state):
	player.set("active", state)
	print("Player state set to: ", state)

func load_game(idx):
	print("Loading game")
	var onload_level = FileAccess.open(SaveFile.meta_path, FileAccess.READ).get_var()[idx]["onload"]
	save = FileAccess.open(SaveFile.save_path % idx, FileAccess.READ).get_var()

	load_level(onload_level)

func save_nodes():
	var nodes = get_tree().get_nodes_in_group("Persist")
	var save_data = {}
	for n in nodes:
		print("Saved ", n.name)
		save_data.merge({n.get_path():n.on_save()})
	
	return save_data

func _on_save_menu_save_game(save_idx : int):
	var timedate = Time.get_datetime_string_from_system(false,true)
	
	save[current_level.name] = save_nodes()
	
	var meta : Dictionary
	if(FileAccess.open(SaveFile.meta_path, FileAccess.READ)):
		meta = FileAccess.open(SaveFile.meta_path, FileAccess.READ).get_var()
	meta[save_idx] = {"date": timedate, "onload": current_level.name}
	
	FileAccess.open(SaveFile.save_path % save_idx, FileAccess.WRITE).store_var(save)
	FileAccess.open(SaveFile.meta_path, FileAccess.WRITE).store_var(meta)

func _on_textbox_text_finished():
	print("Text finished")
	seq_adv_all("text_finished")

func seq_adv_all(key : String):
	for seq in sequences:
		seq.advance_seq(key)
		
func seq_init_all():
	for seq in sequences:
		seq.on_init()
