extends MarginContainer

signal finished_displaying

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var audio_stream_player = $AudioStreamPlayer

const MAX_WIDTH = 384
var text = ""
var index = 0
var letter_time = 0.04
var space_time = 0.08
var punctuation_time = 0.3

func display_text(text_to_display, sound, vol, just_audio):
	if just_audio:
		$NinePatchRect.hide()
		label.modulate.a = 0
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

	$Narrator.stream = sound
	$Narrator.volume_db = vol
	$Narrator.play()
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


func _on_letter_display_timer_timeout():
	display_letter()

#func load_mp3(path):
#	var file = FileAccess.open(path, FileAccess.READ)
#	var sound = AudioStreamMP3.new()
#	sound.data = file.get_buffer(file.get_length())
#	return sound
