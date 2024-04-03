extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var audio_stream_player = $AudioStreamPlayer

const MAX_WIDTH = 384
var text = ""
var index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying

func display_text(text_to_display):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24

	label.text = ""
	display_letter()
	
func display_letter():
	label.text += text[index]
	
	index += 1
	if index >= text.length():
		emit_signal("finished_displaying")
		return
	
	match text[index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
			var new_audio_player = audio_stream_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
			if text[index] in ["a", "e", "i", "o", "u"]:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.volume_db = GameManager.main.find_child("SfxVolumeSlider").value if GameManager.main.find_child("SfxVolumeSlider").value > -30 else -80		
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()


func _on_letter_display_timer_timeout():
	display_letter()
