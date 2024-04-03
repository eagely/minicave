extends Camera2D

var rand_str = 20
var fade = 5.0
var str = 0.0
var rng = RandomNumberGenerator.new()

func shake():
	str = rand_str

func _process(delta):
	if (!GameManager.screen_shake_enabled):
		return
	if str > 0:
		str = lerpf(str, 0, fade * delta)
		
	offset = rand_offset()
	$RainParticles.emitting = true

func rand_offset():
	return Vector2(rng.randf_range(-str, str), rng.randf_range(-str, str))


