extends Area2D

func _process(delta):
	$Animation.play("default")

func _on_area_entered(area):
	if area.get_parent().name == "Player" and not get_parent().has_node("Tutorial"):
		area.get_parent().emit_signal("level_completed")
