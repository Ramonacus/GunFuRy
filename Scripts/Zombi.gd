extends KinematicBody2D

#States enum
const State = {
	IDLE = "idle",
	WALKING = "walking",
	ATTACKING = "attacking"
}
var state = State.IDLE

# Animations enum
const Animation = {
	WALK = "Zombi walk E",
	ATTACK = "Zombi attack E"
}

const speed = 50
var direction = Vector2()

const attack_range = 20

var health = 30

onready var player = get_node("../Player")


func _ready():
	change_state(State.WALKING)

func _physics_process(delta):
	move_and_collide(speed * direction * delta)

func _process(delta):
	if has_method("process_" + state):
		call("process_" + state, delta)

func change_state(new_state):
	if state == new_state:
		print_debug("Changing to the same state")
	
	if has_method("stop_" + state):
		call("stop_" + state)
	state = new_state
	if has_method("start_" + state):
		call("start_" + state)


# WALKING state
func start_walking():
	$AnimationPlayer.play(Animation.WALK)

func process_walking(delta):
	var vector_to_player = player.get_position() - get_position()
	direction = vector_to_player.normalized()
	$Sprite.set_flip_h(direction.x < 0)	
	
	if vector_to_player.length() <= attack_range:
		change_state(State.ATTACKING)


# Attack state
func start_attacking():
	$AnimationPlayer.play(Animation.ATTACK)
	$Hitbox.rotation = Vector2.RIGHT.angle_to(direction)
	direction = Vector2()

func take_damage(damage):
	health -= 10
	if health <= 0:
		queue_free()
	else:
		change_state(State.WALKING)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != Animation.WALK:
		change_state(State.WALKING)

func _on_Hitbox_area_entered(area):
	area.find_parent("Player").take_damage()

