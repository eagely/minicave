extends Menu

func _process(delta):
	$CoinControl/Label.text = str(GameManager.coins)

func _on_buy_teleportation():
	var price = int($PanelContainer/MarginContainer/GridContainer/Teleportation/Button.text)
	if price == 2:
		GameManager.bought_for_cheap = true
	if GameManager.coins >= price:
		GameManager.add_item("teleportation")
		GameManager.lose_coins(price)
		GameManager.sound("buy")		
	else:
		GameManager.shake_screen()
		GameManager.close(self)


func _on_buy_leaping():
	var price = int($PanelContainer/MarginContainer/GridContainer/Leaping/Button.text)
	if price == 0.5:
		GameManager.bought_for_cheap = true
	if GameManager.coins >= price:
		GameManager.add_item("leaping")
		GameManager.lose_coins(price)
		GameManager.sound("buy")
	else:
		GameManager.shake_screen()
		GameManager.close(self)


func _on_buy_shrinking():
	var price = int($PanelContainer/MarginContainer/GridContainer/Shrinking/Button.text)
	if price == 0.5:
		GameManager.bought_for_cheap = true
	if GameManager.coins >= price:
		GameManager.add_item("shrinking")
		GameManager.lose_coins(price)
		GameManager.sound("buy")
	else:
		GameManager.shake_screen()
		GameManager.close(self)

