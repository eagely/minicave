extends Area2D

func _process(delta):
	$Animation.play("idle")

func _on_area_entered(area):
	if area.get_parent().name == "Player" and not get_parent().has_node("Tutorial"):
		GameManager.load_next_level()
