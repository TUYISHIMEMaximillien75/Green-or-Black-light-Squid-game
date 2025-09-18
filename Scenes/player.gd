extends CharacterBody2D

const BASE_SPEED = 200
const SCALE_STEP = 0.01
const MIN_SCALE = 0.5
const MAX_SCALE = 2.0

const SCREEN_WIDTH = 1152
const SCREEN_HEIGHT = 648

var can_move = true
var timer = 0.0
var total_time_survived = 0.0
var idle_time = 0.0 

var score_label
var game_over_label
var restart_button
var message_label 

func _ready():
	position = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT)
	velocity = Vector2.ZERO
	timer = 0.0
	can_move = true
	idle_time = 0.0

	score_label = get_node("../ScoreLabel") 
	score_label.text = "Score: 0"
	
	game_over_label = get_node("../GameOverLabel") 
	game_over_label.visible = false

	restart_button = get_node("../RestartButton") 
	restart_button.visible = false

	message_label = get_node("../MessageLabel")  
	message_label.text = ""
	message_label.visible = false

func _physics_process(delta):
	#print(5)
	#print(Global.testNum)
	timer += delta
	if can_move and timer > Global.timer1:
		can_move = false
		timer = 0.0
		game_over_label.visible = false
		_show_message("Block light! Stop moving!")

	elif not can_move and timer > Global.timer1:
		can_move = true
		timer = 0.0
		game_over_label.visible = false
		_show_message("Green light! You can move now!")
	
	var is_moving = (
		Input.is_action_pressed("ui_up") or
		Input.is_action_pressed("ui_down") or
		Input.is_action_pressed("ui_left") or
		Input.is_action_pressed("ui_right")
	)

	if can_move:
		if is_moving:
			idle_time = 0.0  
		else:
			idle_time += delta
			if idle_time > Global.idle_time:
				
				_show_message("Yoi stood stil too long during green light! GAME OVER!")
				game_over_label.visible = true
				restart_button.visible = true
				get_tree().paused = true

	
	if not can_move and is_moving:
		_show_message("You moved during Black light! GAME OVER!")
		game_over_label.visible = true
		restart_button.visible = true
		get_tree().paused = true  

	
	if not get_tree().paused:
		total_time_survived += delta
		score_label.text = "Score: " + str(int(total_time_survived))

	var move_dir_y = 0
	var move_dir_x = 0

	if can_move:
		if Input.is_action_pressed("ui_up"):
			if scale.x > MIN_SCALE:
				scale.x = max(scale.x - SCALE_STEP, MIN_SCALE)
				scale.y = max(scale.y - SCALE_STEP, MIN_SCALE)
			move_dir_y = -1
		elif Input.is_action_pressed("ui_down"):
			if scale.x < MAX_SCALE:
				scale.x = min(scale.x + SCALE_STEP, MAX_SCALE)
				scale.y = min(scale.y + SCALE_STEP, MAX_SCALE)
			move_dir_y = 1

		if Input.is_action_pressed("ui_left"):
			move_dir_x = -1
		elif Input.is_action_pressed("ui_right"):
			move_dir_x = 1

		var dynamic_speed_y = (BASE_SPEED * scale.x) * 0.5
		var dynamic_speed_x = BASE_SPEED * 0.5

		velocity.y = move_dir_y * dynamic_speed_y
		velocity.x = move_dir_x * dynamic_speed_x
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	position.x = clamp(position.x, 0, SCREEN_WIDTH)
	position.y = clamp(position.y, 0, SCREEN_HEIGHT / 2)

func _show_message(text: String) -> void:
	message_label.text = text
	message_label.visible = true

func _clear_message() -> void:
	message_label.text = ""
	message_label.visible = false

func _on_restart_button_pressed() -> void:
	_show_message("Restarting...")
	get_tree().paused = false
	restart_button.visible = false
	game_over_label.visible = false
	total_time_survived = 0
	timer = 0
	can_move = true
	idle_time = 0
	score_label.text = "Score: 0"
	_clear_message()

	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
