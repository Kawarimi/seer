extends StaticBody2D

@export var linked_door = ""
@export var linked_scene = ""
@export var animated = false
@export var enabled = true
@onready var anim = $AnimationPlayer
@onready var spawn = $SpawnPoint
@onready var level = $/root/Control/LevelManager
@onready var fx = $/root/Control/Effects

func on_interact():
	if enabled:
		if animated:
			anim.play("door_open")
			if(linked_scene != ""):		
				await fx.fade_out()
			else:
				await anim.animation_finished
			transition()
		else:
			transition()

func transition():
		if(linked_scene != ""):
			level.call_deferred("load_level", linked_scene, linked_door)
		else:
			level.player_to_door(linked_door)
			if animated:
				anim.play("door_close")
