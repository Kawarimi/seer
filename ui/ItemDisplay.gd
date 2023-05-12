extends Node

@onready var image = $ItemImage
@onready var value_label = $Value
@onready var text_label = $ItemText

func display(text : String, price : int, img):
	image.texture = img
	value_label.text = str(price)
	text_label.text = text
	if(price == 0):
		value_label.hide()
	else:
		value_label.show()
