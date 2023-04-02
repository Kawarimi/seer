extends Node

@export var current_sequence : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func text_finished():
	current_sequence.advance_seq(["text_finished"])
