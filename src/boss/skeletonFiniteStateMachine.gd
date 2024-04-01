extends Node2D

var current_state: Skel
var previous_state: Skel

func _ready():
	current_state = find_child("Idle") as Skel
	previous_state = current_state
	current_state.enter()

func change_state(skel):
	current_state = find_child(skel) as Skel
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
