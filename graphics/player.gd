extends CharacterBody2D

@export var speed = 500

func _ready():
	position = Vector2(100, 500)
	
	
	
func _process(delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity  = direction * speed
	move_and_slide()
	#position += direction * speed * delta
	
	
	#*************Need to remember***********
	#if Input.is_action_pressed("ui_down"):
		#position += Vector2(1, 0) * 50 * delta
		#$PlayerImage.rotation += 0.1 * delta
