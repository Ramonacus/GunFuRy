extends KinematicBody2D

enum State {STANDING, ATTACKING}
var state = State.STANDING

# Animations enum
const Animations = {
	WALK = "Zombi walk E",
	ATTACK = "Zombi attack E"
}

const speed = 50
var direction = Vector2()

const attack_range = 20

onready var player: KinematicBody2D = get_node("../Player")


func _ready():
	start_standing()


func _physics_process(delta):
	move_and_collide(speed * direction * delta)


func _process(delta):
	match state:
		State.STANDING:	
			process_standing(delta)
		State.ATTACKING:
			process_attacking(delta)


# Standing state
func start_standing():
	state = State.STANDING
	$AnimationPlayer.play(Animations.WALK)


func process_standing(delta):
	var vector_to_player = player.get_position() - get_position()
	$Sprite.set_flip_h(vector_to_player.x < 0)	
	
	if vector_to_player.length() <= attack_range:
		start_attack(vector_to_player)
	else:
		direction = vector_to_player.normalized()


# Attack state
func start_attack(vector_to_player):
	direction = Vector2()
	state = State.ATTACKING
	$AnimationPlayer.play(Animations.ATTACK)
	$Hitbox.rotation = Vector2.RIGHT.angle_to(vector_to_player)


func process_attacking(delta):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != Animations.WALK:
		start_standing()



func _on_Hitbox_area_entered(area):
	area.find_parent("Player").take_damage()
