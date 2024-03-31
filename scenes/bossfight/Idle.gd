extends State

@onready var collision = $"../../PlayerDetection/Circle"
@onready var health_bar = owner.find_child("HealthBar")
@onready var fsm = get_parent()

var player_entered = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		health_bar.set_deferred("visible", value)
		
func transition():
	if player_entered:
		fsm.change_state("Follow")


func _on_player_detection_area_entered(area):
	if area.get_parent() and area.get_parent() == GameManager.player:
		player_entered = true
