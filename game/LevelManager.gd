extends Node

@onready var current_level = get_child(0)
@onready var sequences = get_node(current_level.name+"/Sequences").get_children()

signal level_loaded

var save : Dictionary

var player
var text_locked = false
var menu_locked = false

var last_used_door

@onready var fx = $/root/Control/Effects

func _ready():
	find_new(current_level)
	if(FileAccess.open(SaveFile.save_path % -1, FileAccess.READ)): #TEMP DEV CODE
			SaveFile.save_idx = -1
	if SaveFile.save_idx != null:
		print("Loading game from save ", SaveFile.save_idx)
		load_game(SaveFile.save_idx)
		await level_loaded
	else:
		seq_adv_all("on_new")

func find_new(on_scene):
	player = on_scene.find_child("Player")
	sequences = get_node(on_scene.name+"/Sequences").get_children()

func load_level(fresh_load : bool, level: String, linked_door = null):
	if not fresh_load:
		_autosave(level, linked_door)
	
	current_level.free()
	
	var new_scene = null
	if ResourceLoader.load_threaded_get_status(Globals.level_path % level) == 0:
		new_scene = load(Globals.level_path % level)
	else:
		new_scene = ResourceLoader.load_threaded_get(Globals.level_path % level)
	
	var new_level = new_scene.instantiate()
	
	add_child(new_level)
	new_level.set_owner(self)
	find_new(new_level)
	
	if save.has(level):
		for node in save[level]:
			get_node(node).on_load(save[level][node])
			print("loaded ",node)
	
	current_level = new_level
	
	if linked_door:
		player_to_door(linked_door)
	
	seq_adv_all("on_new")
	
	level_loaded.emit()
	fx.fade_in()
	
	return new_level
	
func save_level():
	if current_level.name in save:
		save[current_level.name].merge(save_nodes(), true)
	else:
		save[current_level.name] = save_nodes()

func player_to_point(point: Vector2):
	print("Moving player to: ", point)
	player.global_position = point

func player_to_door(door_name: String):
	var door = find_child(door_name)
	player_to_point(door.get("spawn").global_position)
	player.face_to(door.get("spawn_direction"))
	last_used_door = door

func player_activated(state):
	if not text_locked or not menu_locked:
		player.set("ui_locked", state)
		player.get("anim").get("parameters/playback").travel("Idle")
		print("UI Lock set to: ", state)

func player_lock(state : bool):
	player.lock(state)

func load_game(idx):
	print("Loading game")
	var meta = FileAccess.open(SaveFile.meta_path, FileAccess.READ).get_var()[idx]
	save = FileAccess.open(SaveFile.save_path % idx, FileAccess.READ).get_var()
	
	var onloaddoor = null
	if(meta["onloaddoor"]):
		onloaddoor = meta["onloaddoor"]
	
	load_level(true, meta["onload"], onloaddoor)

func save_nodes():
	var nodes = get_tree().get_nodes_in_group("Persist")
	var save_data = {}
	for n in nodes:
		print("Saved ", n.name)
		save_data.merge({n.get_path():n.on_save()})
	
	return save_data

func _on_save_menu_save_game(save_idx : int):
	SaveFile.save_idx = save_idx
	var timedate = Time.get_datetime_string_from_system(false,true)
	
	save_level()
	
	var meta : Dictionary
	if(FileAccess.open(SaveFile.meta_path, FileAccess.READ)):
		meta = FileAccess.open(SaveFile.meta_path, FileAccess.READ).get_var()
	meta[save_idx] = {
	"date": timedate,
	"onload": current_level.name}
	
	FileAccess.open(SaveFile.save_path % save_idx, FileAccess.WRITE).store_var(save)
	FileAccess.open(SaveFile.meta_path, FileAccess.WRITE).store_var(meta)
	
func _autosave(load_to : String, load_to_door = null):
	print("AUTOSAVING")
	var timedate = Time.get_datetime_string_from_system(false,true)
	
	save_level()
	
	var meta : Dictionary
	if(FileAccess.open(SaveFile.meta_path, FileAccess.READ)):
		meta = FileAccess.open(SaveFile.meta_path, FileAccess.READ).get_var()
	meta[-1] = {
	"date": timedate,
	"onload": load_to,
	"onloaddoor": load_to_door}
	
	FileAccess.open(SaveFile.save_path % -1, FileAccess.WRITE).store_var(save)
	FileAccess.open(SaveFile.meta_path, FileAccess.WRITE).store_var(meta)

func seq_adv_all(key : String):
	for seq in sequences:
		seq.advance_seq(key)

func _on_textbox_text_finished():
	print("Text finished")
	seq_adv_all("text_finished")

func _on_textbox_opened(state):
	player_activated(state)
	text_locked = state

func _on_menu_opened(state):
	player_activated(state)
	menu_locked = state
