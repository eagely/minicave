extends Node2D


func _ready():
	$AnimationPlayer.play("idle")



func _on_hitbox_area_body_entered(body):
	if body == GameManager.player:
		GameManager.sound("coin")
		GameManager.gain_coins(10)
		queue_free()
