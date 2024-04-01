extends Skel

@onready var collision = $"../../PlayerDetection/CollisionShape2D"
@onready var health_bar = owner.find_child("HealthBar")


var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		health_bar.set_deferred("visible", value)


func _on_player_detection_body_entered(body):
	player_entered = true

func transition():
	if player_entered:
		get_parent().change_state("Follow")
