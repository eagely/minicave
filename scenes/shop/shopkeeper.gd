extends Node2D

@onready var interaction_area = $InteractionArea
@onready var animation = $Animation
@onready var shop = $ShopLayer/Shop

const lines = [
	"Hey there!"
]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	$Animation.play("idle")

func _on_interact():
	GameManager.open(shop)
