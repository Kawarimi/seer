extends CanvasLayer

const tween_speed = 0.075

@onready var next_symbol = $TextboxContainer/NextArrow/Next
@onready var text_label = $TextboxContainer/Text/TextLabel
@onready var name_label = $TextboxContainer/PortraitBox/ImageLabel/Name
@onready var img_display = $TextboxContainer/PortraitBox/ImageLabel/Image

var text_tween

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY

var active_tree = null
var tree_finished = false

var text_queue
var name_queue
var img_queue

signal player_activated
signal text_finished

@onready var option_template = preload("res://ui/option_container.tscn")
@onready var container = $OptionsContainer/Options/HBoxContainer

var selected_index = 0
var options_length = 0
var options_queue = []

var options_active = false

signal set_tree_option_index

func _ready():
	hide_textbox()
	hide_options()

func _queue_reset():
	text_queue = []
	name_queue = []
	img_queue = []
	options_queue = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(options_active):
		if(Input.is_action_just_pressed("ui_left")):
			select_option(normalize_range(selected_index-1,options_length))
		if(Input.is_action_just_pressed("ui_right")):
			select_option(normalize_range(selected_index+1,options_length))
		if(Input.is_action_just_pressed("ui_accept")): #add more
			print("picked option")
			set_tree_option_index.connect(active_tree.set_option_index)
			set_tree_option_index.emit(selected_index)
			await get_tree().create_timer(0.1).timeout
			hide_options()
			active_tree.play()
	else:
		match current_state:
			State.READY:
				pass
			State.READING:
				if(Input.is_action_just_pressed("ui_accept")):
					text_label.visible_ratio = 1
					text_tween.kill()
					text_reading_finished()
			State.FINISHED:
				if(Input.is_action_just_pressed("ui_accept")):
					await get_tree().create_timer(0.1).timeout
					if tree_finished:
						hide_textbox()
						text_finished.emit()
					else:
						next_text()
						next_symbol.hide()

func show_textbox():
	$TextboxContainer.show()
	next_symbol.hide()
	player_activated.emit(false)
	$TextboxContainer/PortraitBox.show()
	$TextboxContainer/Text.set("theme_override_constants/margin_left", 155)

func hide_textbox():
	$TextboxContainer.hide()
	_queue_reset()
	current_state = State.READY
	player_activated.emit(true)
	
func hide_image():
	$TextboxContainer/PortraitBox.hide()
	$TextboxContainer/Text.set("theme_override_constants/margin_left", 25)

func text_reading_finished():
	next_symbol.show()
	if text_queue == []:
		tree_finished = !active_tree.play()
	current_state = State.FINISHED

func next_text():
	var read_time = len(text_queue[0]) * tween_speed
	
	text_tween = create_tween()
	text_tween.finished.connect(text_reading_finished)
	
	text_label.text = text_queue.pop_front()
	text_label.visible_ratio = 0
	if not name_queue == []:
		if not name_queue[0] == "":
			name_label.text = name_queue.pop_front()
	if not img_queue == []:
		if not img_queue[0] == null:
			img_display.sprite_frames = img_queue.pop_front()
	#img_display.play()
	
	current_state = State.READING
	
	var interpolation = text_tween.tween_property(text_label, "visible_ratio", 1, read_time)
	interpolation.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func load_dialogue(dialogueset, tree):
	print("Loading dialogue onto textbox")
	text_queue += dialogueset.get("dialogue_text")
	name_queue += dialogueset.get("dialogue_name")
	img_queue += dialogueset.get("dialogue_image")
	
	show_textbox()
	if(img_queue == [] && name_queue == []):
		hide_image()
	
	active_tree = tree
	tree_finished = false
	next_text()

func show_options():
	$OptionsContainer.show()
	options_active = true
	for option in options_queue:
		var new_option = option_template.instantiate()
		container.add_child(new_option)
		new_option.set_text(option)
	container.get_child(0).selected()
	player_activated.emit(false)
	
func select_option(target_index):
	container.get_child(selected_index).deselected()
	container.get_child(target_index).selected()
	selected_index = target_index

func hide_options():
	print("Options hidden")
	for n in container.get_child_count():
		container.get_child(n).queue_free()
	$OptionsContainer.hide()
	options_active = false
	player_activated.emit(true)
	_queue_reset()

func normalize_range(val, mod):
	var remainder = val % mod
	if(remainder < 0):
		return mod + remainder
	else: 
		return remainder

func load_options(optionset, tree):
	print("Options loaded")
	options_queue += optionset.get("option_text")
	options_length = optionset.get_length()
	active_tree = tree
	await get_tree().create_timer(0.2).timeout
	show_options()
