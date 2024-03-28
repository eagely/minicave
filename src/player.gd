extends CharacterBody2D

const JUMP_FORCE = -300
const DOUBLE_JUMP_FORCE = -200
var speed = 300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_size
var paused = false
var can_double_jump = true
var is_ducking = false
var standing_height = 80
var ducking_height = 40
var tried_standing_up_but_couldnt = false
var awaiting_click_for_teleport = false
var tp_coords
var last_animation = null

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	if (paused):
		return
	
	var direction = Input.get_axis("move_left", "move_right")
	
	# Left / Right
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0
		
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Jump
	if Input.is_action_just_pressed("jump") and !is_ducking:
		if is_on_floor():
			velocity.y += JUMP_FORCE
			can_double_jump = true
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_FORCE
			can_double_jump = false
	
	# Animations
	if (!$Animation.is_playing() or !"duck unduck teleport unteleport".contains(last_animation)) and !Input.is_action_pressed("duck"):
		if velocity.y != 0:
			play("jump")
		elif velocity.x != 0:
			if is_ducking:
				play("duck_idle")
			else:
				play("walk")
		else:
			if is_ducking:
				play("duck_idle")
			else:
				play("idle")
		
	# Duck
	if Input.is_action_just_pressed("duck") and !is_ducking:
		$Hitbox.position.y += 20
		$Hitbox.scale.y = 0.5
		play("duck")
		is_ducking = true
	elif Input.is_action_just_released("duck"):
		if can_stand_up():
			stand_up()
		else:
			tried_standing_up_but_couldnt = true
	
	if tried_standing_up_but_couldnt and can_stand_up():
		stand_up()
		tried_standing_up_but_couldnt = false
	
	if Input.is_action_just_pressed("interact"):
		awaiting_click_for_teleport = true
	if Input.is_action_pressed("left_click") and awaiting_click_for_teleport:
		tp_coords = get_global_mouse_position()		
		var checker = $TeleportChecker

		checker.global_position = tp_coords
		checker.force_shapecast_update()
		if checker.is_colliding():
			tp_coords.y = tp_coords.y - 40
			checker.global_position = tp_coords
			checker.force_shapecast_update()
		
		if checker.is_colliding():
			$Camera.shake()
		else:
			awaiting_click_for_teleport = false
			play("teleport")
	
	$Animation.flip_h = direction == -1
	
	move_and_slide()


func start(pos):
	position = pos
	unpause()
	
func pause():
	paused = true
	$Hitbox.disabled = true
	$Camera.enabled = false
	hide()	
	
func unpause():
	paused = false
	show()
	$Hitbox.disabled = false
	$Camera.enabled = true

func can_stand_up():
	$RayCastUp.target_position = Vector2(0, -(standing_height - ducking_height))
	return !$RayCastUp.is_colliding()
	
func stand_up():
	$Hitbox.position.y -= 20
	$Hitbox.scale.y = 1
	play("unduck")	
	is_ducking = false

func play(name):
	last_animation = name
	$Animation.play(name)

func _on_animation_finished():
	if last_animation == "teleport":
		position = tp_coords
		play("unteleport")
