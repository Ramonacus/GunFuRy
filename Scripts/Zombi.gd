extends KinematicBody2D

enum State {STANDING, ATTACKING}
var state = State.STANDING

var speed = 50
var direction = Vector2()
onready var player: KinematicBody2D = get_node("../Player")
onready var sprite: AnimatedSprite = $AnimatedSprite


func _physics_process(delta):
	move_and_collide(speed * direction * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.STANDING:	
			process_standing()


func process_standing():
	direction = (player.get_position() - get_position()).normalized()
	sprite.set_flip_h(direction.x < 0)
