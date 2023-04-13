extends Control

@onready var date_label = $Date
@onready var loc_label = $Location
@onready var button = $Button
var slot_idx : int

func set_slot(idx):
	slot_idx = idx
	set_text("SAVE %s" % (idx+1))
	
func set_text(text):
	button.text = text

func set_meta_labels(date, loc):
	date_label.text = date
	loc_label.text = loc

func disable_invalid():
	if(date_label.text == ""):
		button.disabled = true

func _on_button_pressed():
	$/root/Control/SaveMenu.on_save_accept(slot_idx)

func disable():
	button.disabled = true
