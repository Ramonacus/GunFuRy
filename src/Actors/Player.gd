extends Actor

var ACCELERATION: = 50
var DECELERATION: = 75

func _process(delta) -> void:
	var input_direction = get_input_direction()
	if input_direction.length():
		speed = min(speed + ACCELERATION, MAX_SPEED)
		direction = input_direction
	else:
		speed = 0
	
func get_input_direction() -> Vector2:
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2(x, y).clamped(1.0)
