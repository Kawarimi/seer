extends Node

@onready var text = $Text
@onready var arrow = $Arrow
@onready var timer = $Timer
	
func set_text(_text):
	text.text = _text

func selected():
	timer.start()
	arrow.show()

func deselected():
	timer.stop()
	arrow.hide()

func _on_timer_timeout():
	arrow.visible = !arrow.visible
