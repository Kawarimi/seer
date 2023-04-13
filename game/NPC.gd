extends AnimatableBody2D

@onready var dialogue = get_node_or_null("DialogueTree")
@onready var anim_tree = get_node_or_null("AnimationTree")
@export var animated = false
@export var on_interact_anim = ""

var status = NPCState.Normal
var pos : Vector2

enum NPCState {
	Normal,
	Destroyed
}

func _ready():
	pos = self.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(animated):
		var velocity = self.position - pos
		pos = self.position
		
		if(velocity == Vector2.ZERO): #Animation setting
			anim_tree.get("parameters/playback").travel("Idle")
		else:
			anim_tree.set("parameters/Idle/blend_position", velocity)
			anim_tree.set("parameters/Move/blend_position", velocity)
			anim_tree.get("parameters/playback").travel("Move")

func on_interact():
	if(dialogue):
		dialogue.play()
	if(anim_tree and on_interact_anim != ""):
		anim_tree.play(on_interact_anim)

func on_save():
	return [status, pos]
	
func on_load(data : Array):
	status = data[0]
	position = data[1]
	if(status == NPCState.Destroyed):
		destroy()

func destroy():
	visible = false
	if(status == NPCState.Destroyed):
		queue_free()
	status = NPCState.Destroyed
