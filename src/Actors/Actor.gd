extends KinematicBody2D

class_name Actor

export var MAX_SPEED: = 250

var direction: = Vector2.ZERO
var speed: = 0

func _physics_process(delta) -> void:
	move_and_slide(direction * speed)
