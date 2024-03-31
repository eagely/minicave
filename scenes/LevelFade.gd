extends CanvasLayer


var fading_in = false
var fading_out = false


func _process(delta):
	print(fading_in)
	print(fading_out)
	if fading_out:
		if $ColorRect.modulate.a >= 0:
			$ColorRect.modulate.a -= 127 * delta
	elif fading_in:
		if $ColorRect.modulate.a <= 255:
			$ColorRect.modulate.a += 127 * delta
		
	
