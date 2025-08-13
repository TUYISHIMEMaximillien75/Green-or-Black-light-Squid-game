extends Node2D

var is_green: bool = true
onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_switch_light_loop()

func _switch_light_loop() -> void:
	while true:
		if is_green:
			sprite.modulate = Color.green
			await get_tree().create_timer(5.0).timeout
			is_green = false
		else:
			sprite.modulate = Color.red
			await get_tree().create_timer(7.0).timeout
			is_green = true
