extends CharacterBody2D

@export var speed : int
@export var run_speed : int
@onready var anim = $AnimationTree
@onready var detector = $Detector

var facing_dir = Vector2(0,1)
var target_node
var ui_locked = false
var locked = false

func _ready():
	detector.body_entered.connect(detect)
	detector.body_exited.connect(left)

func _physics_process(_delta):
	if not locked and not ui_locked:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = input_dir * speed
		
		move_and_slide()
		
		if(velocity == Vector2.ZERO): #Animation setting
			if(input_dir != Vector2.ZERO):
				anim.set("parameters/Idle/blend_position", input_dir)
				facing_dir = input_dir
			anim.get("parameters/playback").travel("Idle")
		else:
			facing_dir = input_dir
			if Input.is_action_pressed("run"):
				velocity = input_dir * run_speed
				#anim.set("parameters/Run/blend_position", input_dir)
				#anim.get("parameters/playback").travel("Run")
				move_and_slide()
			else:
				anim.set("parameters/Move/blend_position", input_dir)
				anim.get("parameters/playback").travel("Move")
			
			anim.set("parameters/Idle/blend_position", input_dir)
		
		#print(velocity)
		move_detector()
		
		if(Input.is_action_just_pressed("interact")): #Raycasting
			if target_node is AnimatableBody2D: #for NPC
				print("Interacting NPC: ",target_node)
				target_node.on_interact()
				anim.get("parameters/playback").travel("Idle")
			if target_node is StaticBody2D: #for environment
				print("Interacting object: ",target_node)
				target_node.on_interact()
				anim.get("parameters/playback").travel("Idle")

func move_detector():
	var target_space = Vector2.ZERO
	if(facing_dir.x > 0):
		target_space = Vector2(24,15)
	if(facing_dir.x < 0):
		target_space = Vector2(-24,15)
	if(facing_dir.y > 0):
		target_space = Vector2(0,40)
	if(facing_dir.y < 0):
		target_space = Vector2(0,-10)
	detector.set(("position"), target_space)

func detect(entered_node):
	target_node = entered_node
	print(target_node)
	return target_node

func left(_node):
	target_node = null

func on_save():
	return global_position

func on_load(data):
	global_position = data
	
func lock(state):
	locked = !locked
	if state:
		locked = state
		
	print("Lock set to:",locked)
		
func face_to(dir : Vector2):
	anim.set("parameters/Idle/blend_position", dir)
	anim.get("parameters/playback").travel("Idle")
	print("Facing player to ",dir)
