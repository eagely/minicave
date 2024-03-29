extends CharacterBody2D

var speed = 150
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
var last_animation = ""
var dying = false
var hp = 10

func _physics_process(delta):
	if dying:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (not $RayCastDown.is_colliding() or is_on_wall()) and is_on_floor():
		flip()
	if not $Animation.is_playing() or not "hit".contains(last_animation):
		play("walk")
		
	$Animation.flip_h = true
	velocity.x = speed	
	move_and_slide()
	

func flip():
	facing_right = !facing_right
	scale.x = -abs(scale.x)
	speed = -speed
	
func play(name):
	last_animation = name
	$Animation.play(name)

func _on_hitbox_area_entered(area):
	if not dying and area.is_in_group("Hittable") and area.get_parent().name == "Player":
		area.get_parent().die()
		
func die():
	play("die")
	dying = true

func hit(damage):
	hp -= damage
	if hp <= 0:
		die()
	else:
		play("hit")

func _on_animation_finished():
	if last_animation == "die":
		queue_free()
