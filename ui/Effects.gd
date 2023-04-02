extends Node
@onready var fxanim = $EffectPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fade_out():
	fxanim.play("fade_out")

func black():
	fxanim.play("black")
