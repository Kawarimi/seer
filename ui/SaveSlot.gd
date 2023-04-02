extends "res://ui/OptionsContainer.gd"

@onready var date_label = $Date
@onready var loc_label = $Location

func set_date(date):
	date_label.text = date

func set_loc(loc):
	loc_label.text = loc
