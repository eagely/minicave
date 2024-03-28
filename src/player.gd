extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -150.0
var screen_size

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.y != 0:
		$Animation.play("jump")
	elif velocity.x != 0:
		$Animation.play("walk")
	else:
		$Animation.play("idle")
		
	$Animation.flip_h = velocity.x < 0
	move_and_slide()


func start(pos):
	position = pos
	show()
	$Hitbox.disabled = false
