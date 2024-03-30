extends Node2D

var strength = 50

func _on_hitbox_area_area_entered(area):
	if area.get_parent().name == "Player":
		area.get_parent().hit(strength)
