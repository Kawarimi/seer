extends StaticBody2D
class_name Interactable

@onready var dialogue = get_node_or_null("DialogueTree")
@onready var anim = get_node_or_null("AnimationPlayer")
@export var on_interact_anim = ""
@export var dialogue_anims : Array[String]
@export var enabled = true

func on_interact():
	if enabled:
		if dialogue:
			var selected_idx = dialogue.play()[1] #Gets selected option index
			if anim:
				anim.play(dialogue_anims[selected_idx])
		else:
			if anim and on_interact_anim != "":
				anim.play(on_interact_anim)
