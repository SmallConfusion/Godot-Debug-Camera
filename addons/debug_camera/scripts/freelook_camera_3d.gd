extends Camera3D
class_name FreelookCamera3D


@export_range(0, 10, 0.01) var sensitivity : float = 3
@export_range(0, 1000, 0.1) var default_velocity : float = 5
@export_range(0, 10, 0.01) var speed_scale : float = 1.17
@export_range(1, 100, 0.1) var boost_speed_multiplier : float = 3.0
@onready var _velocity = default_velocity

var throw_tween : Tween


func _process(delta: float) -> void:
	var direction = Vector3(
		float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_E)) - float(Input.is_physical_key_pressed(KEY_Q)), 
		float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	).normalized()
	
	if Input.is_physical_key_pressed(KEY_SHIFT): # boost
		position += direction.rotated(Vector3.UP, rotation.y) * delta * _velocity * boost_speed_multiplier
	else:
		position += direction.rotated(Vector3.UP, rotation.y) * delta * _velocity


func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x / 1000 * sensitivity
			rotation.x -= event.relative.y / 1000 * sensitivity
			rotation.x = clamp(rotation.x, PI/-2, PI/2)
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			MOUSE_BUTTON_WHEEL_UP: # increase fly velocity
				_velocity *= speed_scale
			MOUSE_BUTTON_WHEEL_DOWN: # decrease fly velocity
				_velocity /= speed_scale
