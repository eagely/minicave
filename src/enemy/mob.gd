extends CharacterBody2D

signal died(pos, type)

@onready var health_bar = $HealthBar
var speed = 150
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
var last_animation = ""
var dying = false
var max_hp = 100
var hp = max_hp
var strength = 30
var hurt = false

var rand_index = randi() % 3
var damage_multiplier = [5, 1, 0.5][rand_index]
var color = ["green_", "blue_", "purple_"][rand_index]

func _ready():
	var sprite = $Animation
	if not sprite.material is ShaderMaterial or not sprite.material.resource_local_to_scene:
		sprite.material = sprite.material.duplicate(true)
		sprite.material.resource_local_to_scene = true
	health_bar.init_health(hp)
	$Animation.flip_h = true	

func _physics_process(delta):
	if dying:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var collider = $RayCastDown.get_collider()
	if ((not $RayCastDown.is_colliding() or (collider and collider.get_parent().name == "Player")) or is_on_wall()) and is_on_floor():
		flip()
	if not $Animation.is_playing() or not last_animation == "hit":
		play("walk")
		
	for body in $HitboxArea.get_overlapping_bodies():
		if body == GameManager.player:
			body.hit(strength)
	
	velocity.x = speed if not hurt else 0
	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x *= -1
	health_bar.scale.x *= -1
	health_bar.position.x = health_bar.size.x * (-1 if facing_right else 1) / 2
	speed = -speed

func play(anim_name):
	last_animation = anim_name
	$Animation.play(color + anim_name)

func die():
	play("die")
	dying = true

func hit(damage):
	$AnimationPlayer.play("hit")
	hp -= damage * damage_multiplier
	if hp <= 0:
		die()
		health_bar.health = 0
	else:
		play("hit")
		hurt = true
		health_bar.health = hp	
		

func _on_animation_finished():
	if last_animation == "die":
		emit_signal("died", global_position, rand_index)
		queue_free()
	elif last_animation == "hit":
		hurt = false


func _on_hitbox_area_body_entered(body):
	if body == GameManager.player:
		body.hit(strength)
