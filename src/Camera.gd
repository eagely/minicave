extends Camera2D

var rand_str = 20
var fade = 5.0
var str = 0.0
var rng = RandomNumberGenerator.new()
var shake_enabled = true

func shake():
	str = rand_str

func _process(delta):
	if (!shake_enabled):
		return
	if str > 0:
		str = lerpf(str, 0, fade * delta)
		
	offset = rand_offset()

func rand_offset():
	return Vector2(rng.randf_range(-str, str), rng.randf_range(-str, str))

func frame_freeze(time_scale, duration):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1
