extends CharacterBody2D


var game_over
var restart
var can_move = true
var timer=0
var message_label
func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		#direction.x += 10
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	velocity = direction * Global.speed
	
	move_and_slide()
	
	timer += delta
	#print(timer)
	if can_move and timer > 5.0:
		can_move = false
		timer = 0
		#print(can_move)
	if not can_move and timer > 7.0:
		can_move = true
		timer = 0
	var movement = (
		Input.is_action_pressed("ui_up") or
		Input.is_action_pressed("ui_down") or
		Input.is_action_pressed("ui_left") or
		Input.is_action_pressed("ui_right")
	)
	if can_move:
		#pass
		if movement:
			Global.idle_timer = 0
		else:
			Global.idle_timer +=delta
			if Global.idle_timer > 3.0:
				_show_message("You stood still too long during green light! GAME OVER!")
				game_over.visible = true
				restart.visible = true
				get_tree().paused = true
	elif not can_move:
		if movement:
			_show_message("Jesus! how dare you move in dark light You are fired out of game")
			game_over.visible =true
			restart.visible =true
			get_tree().paused = true
		
	
		
func _ready():
	pass
	#print("working")
	game_over = get_node("../GameOverLabel") # Adjust path if needed
	game_over.visible = false
	restart = get_node("../RestartButton") # Adjust path if needed
	restart.visible = false
	
	message_label = get_node("../MessageLabel")  # Add your message label node path here
	message_label.text = ""
	message_label.visible = false
	
func _show_message(text: String) -> void:
	message_label.text = text
	message_label.visible = true

func _clear_message() -> void:
	message_label.text = ""
	message_label.visible = false
