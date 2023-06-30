extends Node
class_name DialogueTree

@onready var textbox = $/root/Control/Textbox

var enabled_flags = []

var selected : Node

var option_index = 0
signal option_chosen
signal reading

func _ready():
	selected = $"."

func play(): #returns false on tree end, and index
	option_index = 0
	
	var adv = advance()
	
	textbox.load_dialogue(
		selected.get("text"),selected.get("names"),selected.get("image"),
		selected.get("options_text"),selected.get("sfx"), self)
	if selected.get_options_length() > 0:
		await option_chosen
	
	reading.emit()

	return [adv, option_index]
		
func advance():
	var branch_count = selected.get_child_count()
	print("Branch count:", branch_count)
	
	if branch_count > 0:
		var i = 0
		while not move_down(branch_count, i):
			i += 1
		return true
	
	if branch_count == 0:
		while selected.get_parent() != self:
			selected = selected.get_parent()
		if(selected.get("looping")):
			return false
		selected.queue_free()
		selected = $"."
		return false
		

func move_down(count, i):
	if option_index > count:
		if check_flags(selected.get_child(i)):
			selected = selected.get_child(i)
			return true
		else:
			return false
	else:
		if check_flags(selected.get_child(option_index+i)):
			selected = selected.get_child(option_index+i)
			return true
		else:
			return false

func check_flags(branch):
	if branch.get("condition_flags"):
		var flags = branch.get("condition_flags")
		var i = 0
		for flag in flags:
			if flag in enabled_flags:
				i += 1
		if i == len(flags):
			return true
		else:
			return false
	return true

func set_option_index(idx : int):
	option_index = idx
	option_chosen.emit()
