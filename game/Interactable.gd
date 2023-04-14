extends StaticBody2D
class_name Interactable

@onready var dialogue = get_node_or_null("DialogueTree")
@onready var anim = get_node_or_null("AnimationPlayer")
@export var on_interact_anim = ""
@export var enabled = true

func on_interact():
	if enabled:
		if dialogue:
			dialogue.play()
		if anim and on_interact_anim != "":
			anim.play(on_interact_anim)
	
