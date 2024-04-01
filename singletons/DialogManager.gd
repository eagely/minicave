extends Node

@onready var text_box_scene = preload("res://scenes/gameui/text_box.tscn")

var dialog_lines = []
var cur_line_index = 0

var text_box
var text_box_position

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position, lines):
	if is_dialog_active:
		return
	
	dialog_lines = lines
	text_box_position = position
	show_text_box()
	
	is_dialog_active = true
	
func show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.connect("finished_displaying", _on_text_box_finished_displaying)
	text_box.name = "TextBox"
	GameManager.player.get_node("UI").add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[cur_line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	
func _unhandled_input(event):
	if event.is_action_pressed("advance_dialog") and is_dialog_active and can_advance_line:
		text_box.queue_free()
		cur_line_index += 1
		if cur_line_index >= dialog_lines.size():
			is_dialog_active = false
			cur_line_index = 0
			dialog_lines = []
			return
		show_text_box()
		
func hide_all():
	if GameManager.player.get_node("UI").has_node("TextBox"):
		GameManager.player.get_node("UI").get_node("TextBox").hide()

func show_all():
	if GameManager.player.get_node("UI").has_node("TextBox"):
		GameManager.player.get_node("UI").get_node("TextBox").show()

func cancel_dialog():
	if GameManager.player.get_node("UI").has_node("TextBox"):
		is_dialog_active = false
		cur_line_index = 0
		dialog_lines = []
		GameManager.player.get_node("UI").get_node("TextBox").queue_free()
