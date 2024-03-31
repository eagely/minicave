extends Area2D
class_name InteractionArea

@export var action_name = "interact"

var interact = func(): pass



func _on_body_entered(body):
	InteractionManager.register_area(self)


func _on_body_exited(body):
	InteractionManager.unregister_area(self)
