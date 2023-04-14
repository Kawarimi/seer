extends CanvasLayer

const tween_speed = 0.075

@onready var next_symbol = $TextboxContainer/NextArrow/Next
@onready var text_label = $TextboxContainer/Text/TextLabel
@onready var name_label = $TextboxContainer/PortraitBox/ImageLabel/Name
@onready var img_display = $TextboxContainer/PortraitBox/ImageLabel/Image
@onready var text_audio = $AudioStreamPlayer

var text_tween

enum State {
	READY,
	READING,
	FINISHED,
	OPTIONS
}

var current_state = State.READY

var tree_finished = false
var active_tree = null

var text_queue = []
var name_queue = []
var img_queue = []
var aud_queue = []

signal player_activated
signal text_finished

const option_template = preload("res://ui/option_container.tscn")
@onready var container = $OptionsContainer/Options/HBoxContainer

var selected_index = 0
var options = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
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
					if text_queue == []:
						play_tree()
						print("Tree status: ", tree_finished)		
					if not tree_finished and not text_queue == []:
						next_text()
						next_symbol.hide()
			State.OPTIONS:
				if(Input.is_action_just_pressed("ui_left")):
					select_option(normalize_range(selected_index-1,len(options)))
				if(Input.is_action_just_pressed("ui_right")):
					select_option(normalize_range(selected_index+1,len(options)))
				if(Input.is_action_just_pressed("ui_accept")): #add more
					print("picked option")
					active_tree.set_option_index(selected_index)
					hide_options()
					play_tree()

func play_tree():
	var adv = await active_tree.advance()
	tree_finished = !adv
	if tree_finished:
		hide_textbox()
		text_finished.emit()

func show_textbox():
	$TextboxContainer.show()
	next_symbol.hide()
	player_activated.emit(false)
	$TextboxContainer/PortraitBox.show()
	$TextboxContainer/Text.set("theme_override_constants/margin_left", 155)

func hide_textbox():
	$TextboxContainer.hide()
	text_audio.stream = null
	current_state = State.READY
	player_activated.emit(true)
	
func hide_image():
	$TextboxContainer/PortraitBox.hide()
	$TextboxContainer/Text.set("theme_override_constants/margin_left", 25)

func text_reading_finished():
	if(len(options) > 0):
		show_options()
	else:
		next_symbol.show()
		current_state = State.FINISHED
	text_audio.stop()

func next_text():
	var read_time = len(text_queue[0]) * tween_speed
	
	text_tween = create_tween()
	text_tween.finished.connect(text_reading_finished)
	var interpolation = text_tween.tween_property(text_label, "visible_ratio", 1, read_time)
	interpolation.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	text_label.text = text_queue.pop_front()
	text_label.visible_ratio = 0
	if not name_queue == []:
		var _name = name_queue.pop_front()
		if not _name == "":
			name_label.text = _name
	if not img_queue == []:
		var img = img_queue.pop_front()
		if not img == null:
			img_display.sprite_frames =  img
	if not aud_queue == []:
		var audio = aud_queue.pop_front()
		if not audio == null:
			text_audio.stream = audio
	img_display.play()
	text_audio.play()
	
	current_state = State.READING

func load_dialogue(_text, _name, _img, _options, _audio, tree):
	print("Loading dialogue onto textbox")
	text_queue.assign(_text)
	name_queue.assign(_name)
	img_queue.assign(_img)
	options.assign(_options)
	aud_queue.assign(_audio)
	active_tree = tree
	
	show_textbox()
	if(img_queue == [] && name_queue == []):
		hide_image()
	next_text()
	tree_finished = false

func show_options():
	$OptionsContainer.show()
	for option in options:
		var new_option = option_template.instantiate()
		container.add_child(new_option)
		new_option.set_text(option)
	container.get_child(0).selected()
	player_activated.emit(false)
	current_state = State.OPTIONS
	
func select_option(target_index):
	container.get_child(selected_index).deselected()
	container.get_child(target_index).selected()
	selected_index = target_index

func hide_options():
	print("Options hidden")
	for n in container.get_child_count():
		container.get_child(n).queue_free()
	$OptionsContainer.hide()
	player_activated.emit(true)
	current_state = State.READY
	selected_index = 0

func normalize_range(val, mod):
	var remainder = val % mod
	if(remainder < 0):
		return mod + remainder
	else: 
		return remainder
