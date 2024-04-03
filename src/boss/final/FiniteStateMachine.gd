extends Node2D

var current_state: Final
var previous_state: Final

func _ready():
	current_state = get_child(0) as Final
	previous_state = current_state
	current_state.enter()

func change_state(state):
	if state == previous_state.name:
		return

	current_state = find_child(state) as Final
	current_state.enter()

	
	previous_state.exit()
	previous_state = current_state
