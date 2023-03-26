extends AnimationTree

@export var on_finish : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_textbox_text_finished():
	var playback = get("parameters/playback")
	playback.travel(on_finish.pop_front())
	print(playback.get_current_node())
