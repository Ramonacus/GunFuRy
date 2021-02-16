extends KinematicBody2D

var speed = 50
var direction = Vector2()
onready var player: KinematicBody2D = get_node("../Player")
onready var sprite: AnimatedSprite = $AnimatedSprite

func calculate_direction():
	direction = (player.get_position() - get_position()).normalized()
	sprite.set_flip_h(direction.x < 0)

func _physics_process(delta):
	calculate_direction()
	move_and_collide(speed * direction * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
