extends Node

@onready var seqs = get_children()

func _on_textbox_text_finished():
	for seq in seqs:
		seq.advance_seq("text_finished")
