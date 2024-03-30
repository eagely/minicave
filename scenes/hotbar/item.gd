extends Resource
class_name Item

@export var icon: Texture2D
@export var name: String

@export_enum("Consumable")
var type = "Consumable"

@export_multiline var description: String
