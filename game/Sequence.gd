extends Node

@export var on_finish : Array[String]
@onready var anim_tree = $AnimationTree
@onready var playback =  anim_tree.get("parameters/playback")
@export var active = false
@export var current_node : String

func _ready():
	pass
	
func set_tree(node):
	current_node = node
	playback.start(node)
	
func on_save():
	print(current_node)
	return [active, current_node]
	
func on_load(data):
	activate(data[0])
	set_tree(data[1])

func advance_seq(params = []): #implement params into animationtree !!!
	active = anim_tree.get("active")
	if(active):
		if(params.has("text_finished")):
			playback.travel(on_finish.pop_front())
			print(playback.get_current_node())

func activate(state):
	active = state
	anim_tree.active = state
