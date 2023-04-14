@tool
extends Node
class_name Sequence

const sequence_flags = ["text_finished"]

@onready var anim = $AnimationPlayer
@export var on_advance : Dictionary
@export var active = true
@export var on_new = ""

func _process(_delta):
	if Engine.is_editor_hint():
		if on_advance.size() == 0:
			print("Setting sequence dict")
			for f in sequence_flags:
				on_advance[f] = PackedStringArray()
	
func on_save():
	return [active, on_advance, on_new]
	
func on_load(data):
	activate(data[0])
	on_advance = data[1]
	on_new = data[2]
	on_init()

func on_init():
	if(on_new != ""):
		anim.play(on_new)
		on_new = ""

func advance_seq(key : String):
	if active and len(on_advance[key]) > 0:
		print("Advancing sequence")
		anim.play(on_advance[key][0])
		on_advance[key].remove_at(0)

func activate(state):
	active = state
	
func skip(key : String):
	anim.seek(anim.get_current_animation_length())
	if(key):
		advance_seq(key)
