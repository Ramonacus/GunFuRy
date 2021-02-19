extends KinematicBody2D

#States enum
const State = {
	IDLE = "idle",
	WALKING = "walking",
	ATTACKING = "attacking"
}
var state = State.IDLE
var previous_state = ""

# Animations enum
const Animation = {
	WALK = "Zombi walk E",
	ATTACK = "Zombi attack E"
}

const speed = 50
var direction = Vector2()

const attack_range = 20

onready var player = get_node("../Player")


func _ready():
	state = State.WALKING

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


# WALKING state
func start_walking():
	$AnimationPlayer.play(Animation.WALK)

func process_walking(delta):
	var vector_to_player = player.get_position() - get_position()
	direction = vector_to_player.normalized()
	$Sprite.set_flip_h(direction.x < 0)	
	
	if vector_to_player.length() <= attack_range:
		state = State.ATTACKING


# Attack state
func start_attacking():
	$AnimationPlayer.play(Animation.ATTACK)
	$Hitbox.rotation = Vector2.RIGHT.angle_to(direction)
	direction = Vector2()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != Animation.WALK:
		state = State.WALKING

func _on_Hitbox_area_entered(area):
	area.find_parent("Player").take_damage()
