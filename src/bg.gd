extends ParallaxBackground

# Path to the player node from the current scene root
var player = GameManager.player

func _process(delta):
	self.scroll_offset.x = player.position.x * -0.5
