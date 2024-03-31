extends Menu

func _on_buy_teleportation():
	if GameManager.coins >= 200:
		GameManager.add_item("teleportation")
		GameManager.lose_coins(200)
		GameManager.sound("buy")		
	else:
		GameManager.shake_screen()
		GameManager.close(self)		


func _on_buy_leaping():
	if GameManager.coins >= 50:
		GameManager.add_item("leaping")
		GameManager.lose_coins(50)
		GameManager.sound("buy")
	else:
		GameManager.shake_screen()
		GameManager.close(self)		
		


func _on_buy_strength():
	if GameManager.coins >= 100:
		GameManager.add_item("strength")
		GameManager.lose_coins(100)
		GameManager.sound("buy")		
	else:
		GameManager.shake_screen()
		GameManager.close(self)		

