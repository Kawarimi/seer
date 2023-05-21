extends StaticBody2D

@export var linked_door = ""
@export var linked_scene = ""
@export var animated = false
@export var enabled = true
@export var spawn_direction : Vector2
@onready var anim = $AnimationPlayer
@onready var spawn = $SpawnPoint

func on_interact():
	if enabled:
		if animated:
			anim.play("door_open")
			if(linked_scene != ""):
				await Globals.fx.fade_out()
			else:
				await anim.animation_finished
			transition()
		else:
			transition()

func transition():
		if(linked_scene != ""):
			Globals.level_manager.call_deferred("load_level", linked_scene, linked_door)
		else:
			Globals.level_manager.player_to_door(linked_door)
			if animated:
				anim.play("door_close")
