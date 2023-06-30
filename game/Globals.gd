extends Node

@onready var level_manager = $/root/Control/LevelManager
@onready var global_fx = $/root/Control/Effects
@onready var game_menu = $/root/Control/Menu

@onready var global_params = $/root/Control/GlobalParams

const level_path = "res://scenes/%s.tscn"
const note_dir = "res://game/notes/%s.txt"
