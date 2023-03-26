extends Node

const dialogue_script = preload("res://ui/Dialogue.gd")
const options_script = preload("res://ui/OptionSet.gd")
@onready var textbox = $/root/Control/Textbox

var selected_node : Node

var option_index = 0

func _ready():
	selected_node = $"."

func play(): #returns false on tree end
	if(advance_tree()):
		if(selected_node is dialogue_script):
			textbox.load_dialogue(selected_node, self)
		if(selected_node is options_script):
			textbox.load_options(selected_node, self)
	else:
		return false

func advance_tree():
	var branch_count = selected_node.get_child_count()
	print("Branch count:", branch_count)
		
	if branch_count > 0:
		if option_index > branch_count:
			selected_node = selected_node.get_child(0)
			return true
		else:
			selected_node = selected_node.get_child(option_index)
			return true
	else: 
		if selected_node != self:
			while(selected_node.get_parent() != self):
				selected_node = selected_node.get_parent()
			if selected_node is dialogue_script and selected_node.get("condition_flags").has("LOOPING"):
				return false
			else:
				selected_node.free()
				selected_node = $"."
				return false
		else:
			return false

func set_option_index(idx : int):
	option_index = idx
