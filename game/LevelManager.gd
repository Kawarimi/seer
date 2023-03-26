extends Node

@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_level(level : PackedScene):
	add_child(level.instantiate())
	
	var current_level = get_child(0)
	current_level.queue_free()

func load_scene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)


func player_to_point(point: Vector2):
	player.position = point
