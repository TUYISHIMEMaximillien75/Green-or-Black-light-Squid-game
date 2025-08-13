extends Node2D

var is_green = true  # start with green

func _ready() -> void:
	start_switching()

func start_switching() -> void:
	# This function runs the loop asynchronously
	_switch_light_loop()

func _switch_light_loop() -> void:
	while true:
		if is_green:
			modulate = Color.GREEN
			await get_tree().create_timer(5.0).timeout
			is_green = false
		else:
			modulate = Color.RED
			await get_tree().create_timer(7.0).timeout
			is_green = true
