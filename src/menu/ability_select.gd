extends Menu

var left
var right

var left_ability
var right_ability

func _ready():
	randomize()
	left = find_child("Left")
	right = find_child("Right")
	
	_update_abilities()

func _update_abilities():
	var filtered_keys = []
	for key in GameManager.Abilities.keys():
		if key == "EXTRA_BULLET" or not GameManager.abilities_unlocked[key]:
			filtered_keys.append(key)
	
	if filtered_keys.size() > 1:
		left_ability = filtered_keys[randi() % filtered_keys.size()]
		right_ability = filtered_keys[randi() % filtered_keys.size()]
		
		while right_ability == left_ability:
			right_ability = filtered_keys[randi() % filtered_keys.size()]
		
		left.text = left_ability.replace("_", " ")
		right.text = right_ability.replace("_", " ")
	elif filtered_keys.size() == 1:
		left_ability = filtered_keys[0]
		right_ability = filtered_keys[0]
		left.text = left_ability.replace("_", " ")
		right.text = right_ability.replace("_", " ")
	else:
		left.text = "None"
		right.text = "None"

	

func _on_left_pressed():
	GameManager.select_ability(left_ability)
	GameManager.sound("ability")
	emit_signal("selected")
	
func _on_right_pressed():
	GameManager.select_ability(right_ability)
	GameManager.sound("ability")	
	emit_signal("selected")
