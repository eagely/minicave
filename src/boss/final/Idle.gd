extends Final

@onready var collision = owner.get_node("Hitbox")

var player_entered: bool = false:
	set(value):
		player_entered = value


func _on_player_entered(body):
	if body == GameManager.player:
		player_entered = true


func transition():
	if player_entered:
		get_parent().change_state("Summon")
