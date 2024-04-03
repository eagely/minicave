extends Node

@onready var text_box_scene = preload("res://scenes/gameui/text_box.tscn")

var dialog_lines = []
var sounds = null
var cur_line_index = 0
var text_box
var text_box_position
var is_dialog_active = false
var global_disable = false
var shrink_scale = Vector2(1, 1)
var volume = 1.0

func start_dialog(position, lines, new_sounds = null):
	if is_dialog_active or global_disable:
		return
	dialog_lines = lines
	text_box_position = position
	sounds = new_sounds	
	show_text_box()
	is_dialog_active = true
	
func show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.scale = shrink_scale
	GameManager.main.level.add_child(text_box)
	text_box.global_position = text_box_position
	if sounds:
		text_box.display_text(dialog_lines[cur_line_index], sounds[cur_line_index], volume)
	
func _unhandled_input(event):
	if event.is_action_pressed("advance_dialog") and is_dialog_active:
		text_box.queue_free()
		cur_line_index += 1
		if cur_line_index >= dialog_lines.size():
			is_dialog_active = false
			cur_line_index = 0
			return
		await show_text_box()
		
func cancel_dialog():
	is_dialog_active = false
	cur_line_index = 0
	dialog_lines = []
