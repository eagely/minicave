extends Menu

func _on_buy_teleportation():
	GameManager.add_item("teleportation")
	GameManager.close(self)


func _on_buy_leaping():
	GameManager.add_item("leaping")
	GameManager.close(self)


func _on_buy_strength():
	GameManager.add_item("strength")
	GameManager.close(self)
