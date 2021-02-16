extends KinematicBody2D


var speed = 150
var direction = Vector2()
onready var sprite: AnimatedSprite = $AnimatedSprite

func calculate_direction():
	# Detect up/down/left/right keystate and only move when pressed.
	direction = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
	if Input.is_action_pressed('ui_down'):
		direction.y += 1
	if Input.is_action_pressed('ui_up'):
		direction.y -= 1
	direction = direction.normalized()


func _physics_process(delta):
	calculate_direction()
	move_and_collide(speed * direction * delta)


