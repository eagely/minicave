extends HBoxContainer

@onready var slots = get_children()

func _ready():
	for slot in slots:
		slot.show_empty()

func _input(event):
	for i in range(0, 3):
		if event.is_action_pressed("hotbar_" + str(i + 1)) and not event.is_echo():
			slots[i].use_item()
