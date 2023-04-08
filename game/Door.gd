extends StaticBody2D

@export var linked_door = ""
@export var linked_scene = ""
@export var animated = false
@export var enabled = true
@onready var anim = $AnimationPlayer
@onready var spawn = $SpawnPoint

func on_interact():
	if enabled:
		if animated:
			anim.play("door_open")
		else:
			transition()

func transition():
		var level = $/root/Control/LevelManager
		if(linked_scene != ""):
			level = level.load_level(linked_scene)
		level.find_child(linked_door).spawn_player()
		if animated:
			anim.play("RESET")

func spawn_player():
	$/root/Control/LevelManager.player_to_point(spawn.global_position)
