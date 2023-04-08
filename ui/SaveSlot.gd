extends Control

@onready var date_label = $Date
@onready var loc_label = $Location
@onready var button = $Button

func set_text(text):
	button.text = text

func set_menu(save_menu):
	button.pressed.connect(save_menu.on_save_accept)

func set_meta_labels(date, loc):
	date_label.text = date
	loc_label.text = loc

func disable_invalid():
	if(date_label.text == ""):
		button.disabled = true
