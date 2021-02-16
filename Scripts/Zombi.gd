extends KinematicBody2D

enum State {STANDING, ATTACKING}
var state = State.STANDING

var speed = 50
var direction = Vector2()

var attack_range = 20
var attack_cooldown = 1.4
var attack_timer

onready var player: KinematicBody2D = get_node("../Player")
onready var sprite: AnimatedSprite = $AnimatedSprite


func _physics_process(delta):
	move_and_collide(speed * direction * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.STANDING:	
			process_standing(delta)
		State.ATTACKING:
			process_attacking(delta)


func process_standing(delta):
	var vectorToPlayer = player.get_position() - get_position()
	direction = vectorToPlayer.normalized()
	sprite.set_flip_h(direction.x < 0)
	
	if vectorToPlayer.length() <= attack_range:
		attack()
	print(vectorToPlayer.length() )


func process_attacking(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		state = State.STANDING
		sprite.animation = "Zombi walk E"


func attack():
	direction = Vector2()
	state = State.ATTACKING
	sprite.animation = "Zombi attack E"
	attack_timer = attack_cooldown
	
