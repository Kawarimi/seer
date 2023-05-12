extends Node2D

@export var linked_elevator : Node2D
@onready var anim = $Elevator_Door/AnimationPlayer
@onready var player = $%Player
@onready var detector = $Area2D
var open = false

func _ready():
	detector.body_exited.connect(close)

func _physics_process(_delta):
	if open and detector.global_position.distance_to(player.global_position) > 128:
		anim.play("elevator_close_out")
		open = false

func on_interact():
	anim.play("elevator_close")
	anim.queue("elevator_move")
	linked_elevator.get_node("Elevator_Door/Dark3").modulate = Color("ffffff00")
	await get_tree().physics_frame
	player.global_position -= global_position - linked_elevator.global_position
	await anim.animation_finished
	
	linked_elevator.get("anim").play("elevator_open_out")
	linked_elevator.set("open", true)

func close(_n):
	print("Exited elevator")
