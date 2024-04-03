extends Final

@onready var minion_scene = preload("res://scenes/boss/skeleton/minion.tscn")
var can_transition : bool


func enter():
	super.enter()
	can_transition = false
	
	animation.play("summon")
	await animation.animation_finished 
	
	can_transition = true

func spawn():
	var minion = minion_scene.instantiate()
	
	minion.position = global_position + Vector2(40, -40)
	
	GameManager.main.get_node("TemporaryElements").add_child(minion)
	owner.hp += 10

func transition():
	if can_transition:
		get_parent().change_state("Attack")
