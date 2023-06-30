extends StaticBody2D

@export var linked_door = ""
@export var linked_scene = ""
@export var animated = false
@export var enabled = true
@export var locked = false
@onready var anim = $AnimationPlayer
@onready var spawn = $SpawnPoint
@onready var dialogue = get_node_or_null("DialogueTree")

var spawn_direction : Vector2

func _ready():
	spawn_direction = spawn.position

func on_interact():
	if enabled:
		if locked:
			if dialogue:
				dialogue.play()
		else:
			if animated:
				anim.play("door_open")
				if(linked_scene != ""):
					ResourceLoader.load_threaded_request(Globals.level_path % linked_scene)
					await Globals.global_fx.fade_out()
				else:
					await anim.animation_finished
				transition()
			else:
				transition()

func transition():
		if(linked_scene != ""):
			Globals.level_manager.call_deferred("load_level", false, linked_scene, linked_door)
		else:
			Globals.level_manager.player_to_door(linked_door)
			if animated:
				anim.play("door_close")
