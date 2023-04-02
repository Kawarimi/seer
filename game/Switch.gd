extends Node

@onready var anim = $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D
@export var mode = false

func on_interact():
	audio.volume_db = 0
	if mode:
		anim.play("on")
		mode = false
	else:
		anim.play("off")
		mode = true

func on_save():
	return mode
	
func on_load(data):
	mode = !data
	audio.volume_db = -100
	if mode:
		anim.play("on")
		mode = false
	else:
		anim.play("off")
		mode = true
