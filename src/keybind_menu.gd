extends Control

@onready var input_button_scene = preload("res://input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"move_right": "Move Right",
	"move_left": "Move Left",
	"jump": "Jump",
	"interact": "Interact",
	"duck": "Duck"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	create_action_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."
		
func _input(event):
	if is_remapping:
		if event is InputEvent or (event is InputEventMouseButton and event.pressed) and not event is InputEventMouseMotion:
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
				

			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			remapping_button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()


func _on_reset_button_pressed():
	create_action_list()
