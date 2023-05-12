extends Node
@onready var fxanim = $EffectPlayer

func fade_out():
	fxanim.play("fade_out")
	$Panel/AnimatedSprite2D.play("default")
	await fxanim.animation_finished
	return
	
func fade_in():
	fxanim.play_backwards("fade_out")
	$Panel/AnimatedSprite2D.stop()
	await fxanim.animation_finished
	return
