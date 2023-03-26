extends Node

@export var option_text : Array[String]
@export var option_flag : Array[String]

func _ready():
	pass # Replace with function body.

func get_length():
	return len(option_text)
