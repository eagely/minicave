extends Node2D

var scroll_speed = -50
@onready var label = $Control/Label as Label

func _process(delta):
	label.position.y -= scroll_speed * delta
	if label.position.y + label.size.y < 0:
		label.position.y = label.size.y
