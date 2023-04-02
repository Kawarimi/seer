extends StaticBody2D

@export var linked_point : Node2D
@export var linked_scene_path = ""
@export var animated = false
@export var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func on_interact():
	if enabled:
		if animated:
			var anim = $AnimationPlayer
			anim.play("door_open")
			anim.connect("animation_finished", transition)
		else:
			transition("")

func transition(_name):
	if(linked_scene_path != ""):
		$/root/Control/LevelManager.load_level(load(linked_scene_path))
	if(linked_point != null):
		$/root/Control/LevelManager.player_to_point(linked_point.global_position)
