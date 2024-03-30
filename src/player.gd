extends CharacterBody2D

signal level_completed
signal died

@onready var health_bar = $UI/HealthBar

const SPEED = 300
const MAX_JUMP = -300
const STANDING_HEIGHT = 80
const DUCKING_HEIGHT = 40
var jump = MAX_JUMP
var max_jump_time = 0.5
var is_jumping_descent = false
var jump_time = 0
var is_jumping = false
var max_hp = 100
var hp = max_hp
var strength = 60
var can_take_damage = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_size

# Ducking
var is_ducking = false
var tried_standing_up_but_couldnt = false

# Skills
var awaiting_click_for_teleport = false
var tp_coords
var teleport_cursor = preload("res://assets/cursors/png/cursor-pointer-35.png")
var normal_cursor = preload("res://assets/cursors/png/cursor-pointer-18.png")
var is_leaping = false
var jump_buffer_timer = 0.5

# Animations
var last_animation = null
var facing_right = true


# Combat
var can_hit = true


# GameManager.items


func _ready():
	GameManager.player = self	
	screen_size = get_viewport_rect().size
	$UI.hide()
	GameManager.connect("gained_coins", _on_gained_coins)

func _physics_process(delta):
	
	# Movement
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
	
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * (2.25 if is_jumping_descent else 1.5)
	else:
		is_jumping = false
		if jump_buffer_timer > 0 and not is_jumping:
			velocity.y = jump / 2 * (3 if is_leaping else 1)
			is_jumping = true
			jump_time = 0
			jump_buffer_timer = 0

		
	var can_jump = is_on_floor()
	var jump_pressed = Input.is_action_just_pressed("jump")
	var jump_held = Input.is_action_pressed("jump")

	if not is_on_floor() and jump_pressed:
		jump_buffer_timer = 0.5

	if is_on_floor() and jump_buffer_timer > 0 and not is_jumping:
		velocity.y = jump / 2 * (3 if is_leaping else 1)
		is_jumping = true
		jump_time = 0
		jump_buffer_timer = 0

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if jump_buffer_timer <= 0 or is_jumping:
			jump_buffer_timer = 0

	if is_on_floor() and jump_pressed and can_jump and not is_jumping:
		velocity.y = jump / 2 * (3 if is_leaping else 1)
		is_jumping = true
		jump_time = 0

	if is_jumping and jump_held and jump_time < max_jump_time:
		velocity.y += jump * 2 * delta * (3 if is_leaping else 1)
		jump_time += delta
	elif is_jumping:
		is_jumping = false
		is_leaping = false
		is_jumping_descent = true


		
	# Animations
	if not $Animation.is_playing() or not "duck unduck teleport unteleport attack".contains(last_animation):
		if is_ducking:
			play("duck_idle")
		else:
			if velocity.y != 0:
				play("jump")
			elif velocity.x != 0:
				play("walk")
			else:
				play("idle")
		
		
		
		
		
	# Ducking
	if Input.is_action_just_pressed("duck") and !is_ducking:
		$Hitbox.position.y += 20
		$Hitbox.scale.y = 0.5
		play("duck")
		is_ducking = true
	elif Input.is_action_just_released("duck"):
		if can_unduck():
			unduck()
		else:
			tried_standing_up_but_couldnt = true
	
	# If you unducked under a 1 block ceiling and then left it
	if tried_standing_up_but_couldnt and can_unduck():
		unduck()
		tried_standing_up_but_couldnt = false
	
	elif Input.is_action_just_pressed("right_click"):
		if awaiting_click_for_teleport:
			Input.set_custom_mouse_cursor(normal_cursor)
			tp_coords = get_global_mouse_position()		
			var checker = $TeleportShapeCast
			checker.global_position = tp_coords
			checker.force_shapecast_update()
			for adjust in [-50, 100]:
				if checker.is_colliding():
					tp_coords.y = tp_coords.y + adjust
					checker.global_position = tp_coords
					checker.force_shapecast_update()

			if checker.is_colliding():
				$Camera.shake()
			else:
				awaiting_click_for_teleport = false
				play("teleport")
				GameManager.remove_item("teleportation")
			
			
	if Input.is_action_just_pressed("left_click") and can_hit:
		attack()
	
	if direction != 0 and facing_right != (direction == 1):
		flip()
	move_and_slide()

func start(pos):
	position = pos
	hp = max_hp
	health_bar.init_health(hp)

func can_unduck():
	$UnduckRayCast.target_position = Vector2(0, -(STANDING_HEIGHT - DUCKING_HEIGHT))
	return not $UnduckRayCast.is_colliding()
	
func unduck():
	$Hitbox.position.y -= 20
	$Hitbox.scale.y = 1
	is_ducking = false
	play("unduck")

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

func flip():
	scale.x = -abs(scale.x)
	facing_right = !facing_right

func _on_hit_cooldown_timeout():
	can_hit = true

func hit(damage):
	if can_take_damage:
		iframes()
		hp -= damage
		if hp <= 0:
			emit_signal("died")
			health_bar.health = 0
		else:
			health_bar.health = hp
		$Camera.shake()
		$Camera.frame_freeze(0.05, 0.5)
		GameManager.sound("hit")

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func _on_melee_area_area_entered(area):
	if area.get_parent().is_in_group("Attackable"):
		area.get_parent().call("hit", strength)

func _on_hit_collision_delay_timeout():
	$MeleeArea/Rectangle.disabled = true


func hide_health_bar():
	$UI.hide()


func perform_teleportation(skill):
	if awaiting_click_for_teleport:
		awaiting_click_for_teleport = false
	elif GameManager.items["teleportation"] <= 0:
		$Camera.shake()
	else:
		awaiting_click_for_teleport = true
		Input.set_custom_mouse_cursor(teleport_cursor)


func perform_leaping(skill):
	if is_leaping:
		is_leaping = false
	elif GameManager.items["leaping"] <= 0:
		$Camera.shake()
	else:
		is_leaping = true
		GameManager.remove_item("leaping")


func perform_strength(skill):
	if GameManager.items["strength"] <= 0:
		$Camera.shake()
	else:
		$StrengthTimer.start()
		strength *= 2
		GameManager.remove_item("strength")


func _on_strength_timer_timeout():
	strength /= 2
	
func _on_gained_coins(amt):
	$UI/CoinControl/Label.text = str(GameManager.coins)
