extends CharacterBody3D

var acceleration := Vector3(0.0, 0.0, 0.0)
var ypr := Vector3(0.0, 0.0, 0.0)
var ypr_acceleration := Vector3(0.0, 0.0, 0.0)

var yaw_input := 0.0
var pitch_input := 0.0
var roll_input := 0.0
var acceleration_input := 0.0

const ACCELERATION_STRENGTH = 50.0
const BRAKE_STRENGTH = 0.9

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_handle_inputs(delta)
	ypr += delta * ypr_acceleration
	rotate_object_local(Vector3(1,0,0), delta * ypr[1])
	rotate_object_local(Vector3(0,1,0), delta * ypr[0])
	rotate_object_local(Vector3(0,0,1), delta * ypr[2])
	velocity += delta * acceleration
	move_and_slide()
	
func _handle_inputs(delta: float) -> void:
	acceleration_input = Input.get_action_strength("Accelerate")
	acceleration = -transform.basis.z * acceleration_input * ACCELERATION_STRENGTH
	if Input.is_action_pressed("Brake"):
		velocity = velocity * BRAKE_STRENGTH
	
	yaw_input = Input.get_axis("right", "left")
	pitch_input = Input.get_axis("up", "down")
	roll_input = Input.get_axis("roll_right", "roll_left")
	_maybe_dampen_rotation(yaw_input, 0)
	_maybe_dampen_rotation(pitch_input, 1)
	_maybe_dampen_rotation(roll_input, 2)
	ypr_acceleration += Vector3(delta * yaw_input, delta * pitch_input, delta * roll_input)
	
	
func _maybe_dampen_rotation(rotation_input: float, axis: int):
	if rotation_input == 0:
		ypr[axis] = ypr[axis] * 0.98
		ypr_acceleration[axis] = 0.0
		if ypr[axis] < 0.1 and ypr[axis] > -0.1:
			ypr[axis] = 0.0
	
