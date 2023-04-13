@tool
extends Node

@onready var audio = $AudioStreamPlayer2D
@onready var point_light = $PointLight2D
@export var active = false:
	set(new):
		active = new
		mode = !new
		if Engine.is_editor_hint() and point_light:
			if(active):
				point_light.energy = brightness
			else:
				point_light.energy = 0

@export var brightness : float

@export_category("SFX")
@export var on_sfx : AudioStreamMP3
@export var off_sfx : AudioStreamMP3

var mode = !active

func light():
	if(mode):
		audio.stream = on_sfx
		point_light.energy = brightness
		mode = false
	else:
		audio.stream = off_sfx
		point_light.energy = 0
		mode = true

func on_interact():
	light()
	audio.play()

func on_save():
	return mode
	
func on_load(data):
	print("LIGHT IS:",data)
	mode = !data
	light()
