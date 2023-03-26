extends AnimatableBody2D

@onready var dialogue_tree = $DialogueTree
@onready var anim = $AnimationTree
@export var animated = false

var pos

func _ready():
	pos = self.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(animated):
		var velocity = self.position - pos
		pos = self.position
		
		if(velocity == Vector2.ZERO): #Animation setting
			anim.get("parameters/playback").travel("Idle")
		else:
			anim.set("parameters/Idle/blend_position", velocity)
			anim.set("parameters/Move/blend_position", velocity)
			anim.get("parameters/playback").travel("Move")

func on_interact():
	if not dialogue_tree == null:
		dialogue_tree.play()
	
