extends KinematicBody2D

# States enum
const State = {
	IDLE = "idle",
	WALKING = "walking",
	ATTACKING = "attacking"
}
var state = State.IDLE
var previous_state = ""

# Animations enum
const Animation = {
	IDLE = "Hero idle",
	ATTACKING = "Hero attacking"
}


var speed = 150
var direction = Vector2()
onready var sprite: AnimatedSprite = $AnimatedSprite

func _ready():
	state = State.IDLE

func _physics_process(delta):
	move_and_collide(speed * direction * delta)

func _process(delta):
	if state != previous_state:
		change_state()
	if has_method("process_" + state):
		call("process_" + state, delta)

func change_state(new_state = null):
	if (new_state):
		state = new_state
	if state == previous_state:
		print_debug("Changing to the same state")
	
	if has_method("start_" + state):
		call("start_" + state)
	if has_method("stop_" + previous_state):
		call("stop_" + previous_state)
	previous_state = state

func get_input_direction():
	# Detect up/down/left/right keystate and only move when pressed.
	var user_input = Vector2()
	if Input.is_action_pressed("ui_right"):
		user_input.x += 1
	if Input.is_action_pressed("ui_left"):
		user_input.x -= 1
	if Input.is_action_pressed("ui_down"):
		user_input.y += 1
	if Input.is_action_pressed("ui_up"):
		user_input.y -= 1
	return user_input.normalized()
	
	
# Standing state
func start_idle():
	$AnimationPlayer.play(Animation.IDLE)
	speed = 0

func start_walking():
	$AnimationPlayer.play(Animation.IDLE)
	speed = 150

func process_idle(delta):
	process_standing()

func process_walking(delta):
	process_standing()

func process_standing():
	var input_direction  = get_input_direction()
	if input_direction.length():
		direction = input_direction
	$Sprite.set_flip_h(direction.x < 0)
	if Input.is_action_just_pressed("ui_punch"):
		state = State.ATTACKING
	elif input_direction.length() > 0:
		state = State.WALKING
	else:
		state = State.IDLE


# Attacking state
func start_attacking():
	$AnimationPlayer.play(Animation.ATTACKING)
	$Hitbox.rotation = Vector2.RIGHT.angle_to(direction)
	speed = 0


func take_damage():
	print("Ouch")


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		Animation.ATTACKING:
			state = State.WALKING

func _on_Hitbox_area_entered(area):
	area.get_parent().take_damage()
