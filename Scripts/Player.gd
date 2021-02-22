extends KinematicBody2D

const MAX_SPEED = 150
const ACCELERATION = 25

# States enum
const State = {
	IDLE = "idle",
	WALKING = "walking",
	ATTACKING = "attacking"
}

# Animations enum
const Animation = {
	IDLE = "Hero idle",
	ATTACKING = "Hero attacking"
}

var direction = Vector2()
var speed = 0
var state = ""
var attack_buffer = []
var health = 30


func _ready():
	change_state(State.IDLE)


func _physics_process(delta):
	move_and_slide(speed * direction)


func _process(delta):
	if has_method("process_" + state):
		call("process_" + state, delta)


func change_state(new_state):
	if state == new_state:
		return
	
	if has_method("stop_" + state):
		call("stop_" + state)
	state = new_state
	if has_method("start_" + state):
		call("start_" + state)


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


func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
		


# Standing state
func start_idle():
	$AnimationPlayer.play(Animation.IDLE)

func start_walking():
	$AnimationPlayer.play(Animation.IDLE)
	speed = 0

func process_idle(delta):
	speed = max(0, speed - ACCELERATION)
	process_standing()

func process_walking(delta):
	speed = min(MAX_SPEED, speed + ACCELERATION)
	process_standing()

func process_standing():
	var input_direction  = get_input_direction()
	if input_direction.length():
		direction = input_direction
	$Sprite.set_flip_h(direction.x < 0)
	if Input.is_action_just_pressed("ui_punch"):
		change_state(State.ATTACKING)
	elif input_direction.length() > 0:
		change_state(State.WALKING)
	else:
		change_state(State.IDLE)


# Attacking state
func start_attacking():
	$Sprite.set_flip_h(direction.x < 0)
	$AnimationPlayer.play(Animation.ATTACKING)
	$Hitbox.rotation = Vector2.RIGHT.angle_to(direction)
	speed = 0

func process_attacking(delta):
	if Input.is_action_just_pressed("ui_punch"):
		attack_buffer.push_back(get_input_direction())


# Signals and events
func on_attack_animation_end():
	var buffered_attack = attack_buffer.pop_front()
	if buffered_attack == null:
		change_state(State.IDLE)
	else:
		direction = buffered_attack if buffered_attack.length() else direction
		start_attacking()

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		Animation.ATTACKING:
			on_attack_animation_end()

func _on_Hitbox_area_entered(area):
	area.get_parent().take_damage(10)
