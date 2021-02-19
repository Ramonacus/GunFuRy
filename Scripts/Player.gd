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
	IDLE = "Hero idle"
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


# Standing state
func start_idle():
	$AnimationPlayer.play(Animation.IDLE)
	print("Idle")

func start_walking():
	$AnimationPlayer.play(Animation.IDLE)
	print("Walking")

func process_idle(delta):
	process_standing()

func process_walking(delta):
	process_standing()

func process_standing():
	direction = get_input_direction()
	state = State.WALKING if (direction.length() > 0) else State.IDLE
	$Sprite.set_flip_h(direction.x < 0)

func get_input_direction():
	# Detect up/down/left/right keystate and only move when pressed.
	var user_input = Vector2()
	if Input.is_action_pressed('ui_right'):
		user_input.x += 1
	if Input.is_action_pressed('ui_left'):
		user_input.x -= 1
	if Input.is_action_pressed('ui_down'):
		user_input.y += 1
	if Input.is_action_pressed('ui_up'):
		user_input.y -= 1
	return user_input.normalized()


func take_damage():
	print("Ouch")

