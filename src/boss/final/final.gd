extends Node2D
class_name Final

@onready var player = GameManager.player
@onready var debug = owner.find_child("debug")
@onready var animation = owner.find_child("AnimationPlayer")

func _ready():
	set_physics_process(false)
	
func enter():
	set_physics_process(true)
	
func exit():
	set_physics_process(false)
	
func transition():
	pass
	
func _physics_process(delta):
	transition()
