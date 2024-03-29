extends CharacterBody2D

signal level_completed

const SPEED = 300
const JUMP_FORCE = -300
const DOUBLE_JUMP_FORCE = -200
const STANDING_HEIGHT = 80
const DUCKING_HEIGHT = 40
var strength = 5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_size
var can_double_jump = true
var is_ducking = false
var tried_standing_up_but_couldnt = false
var awaiting_click_for_teleport = false
var tp_coords
var last_animation = null
var spawnpoint = position
var can_hit = true
var facing_right = true

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	if Input.is_action_just_pressed("debug_level_completed"):
		emit_signal("level_completed")
	
	var direction = Input.get_axis("move_left", "move_right")
	
	# Left / Right
	if direction:
		velocity.x = direction * SPEED
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
	if (!$Animation.is_playing() or !"duck unduck teleport unteleport attack".contains(last_animation)) and !Input.is_action_pressed("duck"):
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
	elif Input.is_action_just_pressed("left_click"):
		if awaiting_click_for_teleport:
			tp_coords = get_global_mouse_position()		
			var checker = $TeleportShapeCast

			checker.global_position = tp_coords
			checker.force_shapecast_update()
			if checker.is_colliding():
				tp_coords.y = tp_coords.y - 60 # If you click on the top side of a block it should tp you there
				checker.global_position = tp_coords
				checker.force_shapecast_update()
			
			if checker.is_colliding():
				$Camera.shake()
			else:
				awaiting_click_for_teleport = false
				play("teleport")
		elif can_hit:
			attack()
	
	if direction != 0 and facing_right != (direction == 1):
		flip()
	move_and_slide()


func start(pos):
	spawnpoint = pos
	respawn()

func can_stand_up():
	$UnduckRayCast.target_position = Vector2(0, -(STANDING_HEIGHT - DUCKING_HEIGHT))
	return !$UnduckRayCast.is_colliding()
	
func stand_up():
	$Hitbox.position.y -= 20
	$Hitbox.scale.y = 1
	is_ducking = false

func play(name):
	last_animation = name
	$Animation.play(name)

func _on_animation_finished():
	if last_animation == "teleport":
		position = tp_coords
		play("unteleport")

func attack():
	$HitCooldown.start()
	$HitCollisionDelay.start()
	play("attack")
	can_hit = false
	$MeleeArea/Rectangle.disabled = false

	
func respawn():
	position = spawnpoint
	
func die():
	respawn()
	
func flip():
	scale.x = -abs(scale.x)
	facing_right = !facing_right

func _on_hit_cooldown_timeout():
	can_hit = true


func _on_melee_area_area_entered(area):
	if area.get_parent().is_in_group("Attackable"):
		area.get_parent().hit(strength)
		$MeleeArea/Rectangle.disabled = true


func _on_hit_collision_delay_timeout():
	$MeleeArea/Rectangle.disabled = true	
