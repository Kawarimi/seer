extends Node
class_name Sequence

@onready var anim = $AnimationPlayer
@export var on_advance : Dictionary
@export var active = true

var awaiting_text_finished = false
	
func on_save():
	return [active, on_advance]
	
func on_load(data):
	activate(data[0])
	on_advance = data[1]

func advance_seq(key : String):
	if active:
		match key:
			"text_finished":
				if awaiting_text_finished:
					play_seq(key)
					awaiting_text_finished = false
			"on_new":
				if on_advance.has(key):
					play_seq(key)
			"param_check":
				play_seq(key)
			_:
				if Globals.global_params.get("params")[key] == true:
					play_seq(key)
				
func play_seq(key):
	if on_advance[key] is PackedStringArray:
		print("Playing: ",on_advance[key][0])
		anim.play(on_advance[key][0])
		on_advance[key].remove_at(0)
	else:
		print("Playing: ",on_advance[key])
		anim.play(on_advance[key])

func activate(state):
	active = state
	
func skip(key : String):
	anim.seek(anim.get_current_animation_length())
	if(key):
		advance_seq(key)

func _on_checked():
	advance_seq("param_check")

func _on_dialogue_reading():
	awaiting_text_finished = true
