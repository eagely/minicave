extends Button

signal used_skill(skill)

@export var stats: Item = null:
	set(value):
		stats = value
		if value:
			icon = value.icon
		else:
			icon = null
			
@export var skill: Skill = null

var old_icon = null

var amount = 0:
	set(value):
		amount = value
		if amount <= 0:
			hide()
		else:
			show()

func _ready():
	set_process_input(false)

func use_item():
	if not stats:
		return
	emit_signal("used_skill", skill)
	
func show_empty():
	if icon:
		old_icon = icon
	icon = null
	
func show_full():
	icon = old_icon
	
