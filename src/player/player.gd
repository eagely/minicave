extends CharacterBody2D

signal died

@onready var health_bar = $UI/HealthBar

const SPEED = 300
const STANDING_HEIGHT = 80
const DUCKING_HEIGHT = 40

var max_hp = 100
var hp = max_hp
var strength = 60
var can_take_damage = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_size

# Jumping
var is_grounded = false
var jump_height = 150
var jump_time_to_peak = 0.5
var jump_time_to_descent = 0.35
var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
var is_jumping = false

# Ducking
var is_ducking = false
var tried_standing_up_but_couldnt = false

# Potions
var awaiting_click_for_teleport = false
var tp_coords
var teleport_cursor = preload("res://assets/cursors/png/cursor-pointer-35.png")
var normal_cursor = preload("res://assets/cursors/png/cursor-pointer-18.png")
var is_leaping = false
var jump_timer_timer = 0.5


#Skills
var can_dash = false


# Animations
var last_animation = null
var facing_right = true


# Combat
var can_hit = true
var can_shoot = true
var bullet_scene = preload("res://scenes/player/player_bullet.tscn")
var is_shooting = true
var is_meleeing = false


var coins_on_cur_level = 0
var last_checked_level = 1

func _ready():
	GameManager.player = self	
	screen_size = get_viewport_rect().size
	$UI.hide()
	GameManager.connect("gained_coins", _on_gained_coins)
	GameManager.connect("level_loaded", _on_level_loaded)
	GameManager.connect("skill_unlocked", _on_skill_unlocked)

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	if is_on_floor() and not is_grounded:
		is_grounded = true
	elif $CoyoteTimer.is_stopped() and is_grounded:
		$CoyoteTimer.start()
		
	if is_grounded:
		if not $JumpBuffer.is_stopped():
			velocity.y = jump_velocity * (3 if is_leaping else 1)
			is_grounded = false
			is_leaping = false
	
	if Input.is_action_just_released("jump"):
		if velocity.y <= -100:
			velocity.y = -100
	
	if Input.is_action_just_pressed("jump") and not is_ducking:
			$JumpBuffer.start()
	
	if not $Animation.is_playing() or not "duck unduck teleport unteleport attack".contains(last_animation):
		if is_ducking:
			play("duck_idle")
		else:
			if not is_grounded:
				play("jump")
			elif velocity.x != 0:
				play("walk")
			else:
				play("idle")
		
	if Input.is_action_pressed("duck") and !is_ducking:
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
				GameManager.shake_screen()
			else:
				awaiting_click_for_teleport = false
				play("teleport")
				GameManager.remove_item("teleportation")
			
			
	if direction != 0 and facing_right != (direction == 1):
		flip()
	move_and_slide()

func get_gravity():
	return jump_gravity if velocity.y < 0 else fall_gravity

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
	
func _on_shoot_cooldown_timeout():
	can_shoot = true
	
func hit(damage):
	if can_take_damage:
		iframes()
		hp -= damage
		if hp <= 0:
			emit_signal("died")
			health_bar.health = max_hp
			GameManager.lose_coins(coins_on_cur_level)
		else:
			health_bar.health = hp
		GameManager.shake_screen()
		GameManager.sound("hit")

func iframes():
	can_take_damage = false
	await get_tree().create_timer(0.5).timeout
	can_take_damage = true

func _on_melee_area_body_entered(body):
	if body.is_in_group("Attackable"):
		body.hit(strength)

func _on_hit_collision_delay_timeout():
	$MeleeArea/Rectangle.disabled = true


func hide_health_bar():
	$UI.hide()


func perform_teleportation(skill):
	if awaiting_click_for_teleport:
		awaiting_click_for_teleport = false
	elif GameManager.items["teleportation"] <= 0:
		GameManager.shake_screen()
	else:
		awaiting_click_for_teleport = true
		Input.set_custom_mouse_cursor(teleport_cursor)


func perform_leaping(skill):
	if is_leaping:
		is_leaping = false
	elif GameManager.items["leaping"] <= 0:
		GameManager.shake_screen()
	else:
		is_leaping = true
		GameManager.remove_item("leaping")


func perform_strength(skill):
	if GameManager.items["strength"] <= 0:
		GameManager.shake_screen()
	else:
		$StrengthTimer.start()
		strength *= 2
		GameManager.remove_item("strength")


func _on_strength_timer_timeout():
	strength /= 2


func _on_gained_coins(amt):
	if amt > 0 and last_checked_level == GameManager.cur_level:
		coins_on_cur_level += amt
	else:
		coins_on_cur_level = 0
	$UI/CoinControl/Label.text = str(GameManager.coins)


func _on_level_loaded(id):
	if id != last_checked_level:
		last_checked_level = id
		coins_on_cur_level = 0
		if 5 - (id % 5) != 5:
			$UI/UntilBoss.show()
			$UI/UntilBoss.text = "Stages until boss: " + str(5 - (id % 5))
		else:
			$UI/UntilBoss.hide()


func _on_skill_unlocked(name):
	match name:
		"dash":
			can_dash = true


func _input(event):
	if not event.is_echo():
		if event.is_action_pressed("debug_complete_level"):
			GameManager.load_next_level()
		elif event.is_action_pressed("left_click"):
			if is_shooting and can_shoot:
				shoot()
			elif is_meleeing and can_hit:
				attack()
		elif event.is_action_pressed("cycle_attack_mode"):
			is_shooting = !is_shooting
			is_meleeing = !is_meleeing


func shoot():
	if is_ducking:
		return
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.position.y -= 10
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.damage = strength / 5
	get_tree().current_scene.call_deferred("add_child", bullet)
	can_shoot = false
	$ShootCooldown.start()


func _on_coyote_timer_timeout():
	is_grounded = false
