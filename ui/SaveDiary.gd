extends Node

@onready var dialogue_tree = $Tree
@onready var anim = $AnimationPlayer
@onready var save_menu =  $/root/Control/SaveMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_interact():
	anim.play("diary_open")
	await anim.animation_finished
	var option = await dialogue_tree.play()
	if(option[1] == 0):
		save_menu.show_menu()
	else:
		close_diary()

func close_diary():
	anim.play_backwards("diary_open")
