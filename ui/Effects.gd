extends Node
@onready var fxanim = $EffectPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if(SaveFile.save_idx == null):
		$Panel.modulate = Color(Color.BLACK, 1)
