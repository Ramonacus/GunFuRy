extends Actor

var DECELERATION: = MAX_SPEED / .12
var ACCELERATION: = DECELERATION + MAX_SPEED / .08

func _process(delta: float) -> void:
	var velocity: = direction * speed
	velocity += get_input_direction() * ACCELERATION * delta
	speed = max(0, min(MAX_SPEED, velocity.length() - DECELERATION * delta))
	direction = velocity.normalized()
	if (speed):
		print(speed)
	
	
func get_input_direction() -> Vector2:
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2(x, y).clamped(1.0)
