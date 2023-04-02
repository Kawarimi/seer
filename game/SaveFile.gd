extends Node

const save_path = "user://save/save_%s.sav"
const meta_path = "user://save/saves.meta"

var save_idx

static func meta_new(save_name, timedate, level_key):
	return {save_name : {
		"date": timedate, 
		"onload": level_key
		}}
		
static func save_new(level : String, save_data):
	return {level: save_data}
