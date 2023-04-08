extends Node
class_name DialogueSet

@export var condition_flags : Array[String]
@export var looping = false

@export_group("Dialogue Set")
@export var text: Array[String]
@export var image : Array[SpriteFrames]
@export var names : Array[String]

@export_group("Option Set")
@export var options_text : Array[String]
@export var option_flag : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_options_length():
	return len(options_text)
