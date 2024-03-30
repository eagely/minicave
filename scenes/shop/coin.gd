extends Node2D


func _ready():
	$AnimationPlayer.play("idle")


func _on_hitbox_area_area_entered(area):
	GameManager.sound("coin")
	GameManager.gain_coins(1)
	queue_free()
