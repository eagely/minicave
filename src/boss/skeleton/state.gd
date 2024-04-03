extends Node2D
class_name Skel # cant name it State cause its taken by golem boss

@onready var debug = owner.find_child("debug")
@onready var player = GameManager.player
@onready var animation_player = owner.find_child("AnimationPlayer")

func _ready():
	set_physics_process(false)

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass

func _physics_process(_delta):
	transition()
