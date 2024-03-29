extends CharacterBody2D

signal level_completed
signal died

const SPEED = 300
const JUMP_FORCE = -300
const DOUBLE_JUMP_FORCE = -200
const CLIMB_SPEED = -100
const STANDING_HEIGHT = 80
const DUCKING_HEIGHT = 40
var max_health = 10
var hp = max_health
var str = 5
var can_take_damage = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_size
var can_double_jump = true
var is_ducking = false
var tried_standing_up_but_couldnt = false
var awaiting_click_for_teleport = false
var tp_coords
var last_animation = null
var can_hit = true
var facing_right = true
var teleport_cursor = preload("res://assets/cursors/png/cursor-pointer-35.png")
var normal_cursor = preload("res://assets/cursors/png/cursor-pointer-18.png")

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
	if Input.is_action_just_pressed("jump") and not is_ducking:
		if is_on_floor():
			velocity.y += JUMP_FORCE
			can_double_jump = true
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_FORCE
			can_double_jump = false
	
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
			
	# Duck
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
	
	if Input.is_action_just_pressed("interact"):
		awaiting_click_for_teleport = true
		Input.set_custom_mouse_cursor(teleport_cursor)
	elif Input.is_action_just_pressed("left_click"):
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
			
		elif can_hit:
			attack()
	
	if direction != 0 and facing_right != (direction == 1):
		flip()
	move_and_slide()

func start(pos):
	position = pos
	hp = 10

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
		$Camera.shake()
		$Camera.frame_freeze(0.05, 0.5)

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func _on_melee_area_area_entered(area):
	if area.get_parent().is_in_group("Attackable"):
		area.get_parent().call("hit", str)

func _on_hit_collision_delay_timeout():
	$MeleeArea/Rectangle.disabled = true	
