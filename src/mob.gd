extends RigidBody2D


func _ready():
	#var mob_types = $Animation.sprite_frames.get_animation_names()
	#$Animation.play(mob_types[randi() % mob_types.size()])
	pass


func _process(delta):
	pass


func _on_visible_notifier_screen_exited():
	queue_free()
