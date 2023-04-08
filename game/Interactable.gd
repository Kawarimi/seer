extends Node

@onready var dialogue = $DialogueTree

func on_interact():
	if(dialogue):
		dialogue.play()
