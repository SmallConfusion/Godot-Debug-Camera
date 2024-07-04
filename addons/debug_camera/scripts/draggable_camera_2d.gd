extends Camera2D
class_name DraggableCamera2D


# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
@export var zoom_factor := 0.25
# Duration of the zoom's tween animation.
@export var zoom_duration := 0.2

@export var throw_distance := 8.

@onready var _throw_duration := throw_distance / 50.

var throw_tween : Tween

# The camera's target zoom level.
var _zoom_level : float = 1.0

var _previous_position: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false

var _throw_position := Vector2.ZERO


func _zoom():
	get_tree().create_tween().tween_property(self, "zoom", Vector2(_zoom_level, _zoom_level), zoom_duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


func _throw():
	throw_tween = get_tree().create_tween()
	throw_tween.tween_property(self, "position", _throw_position + position, _throw_duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# zoom out
		if event.pressed && event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_level = _zoom_level - zoom_factor * _zoom_level
			_zoom()
		# zoom in
		if event.pressed && event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_level = _zoom_level + zoom_factor * _zoom_level
			_zoom()
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			_previous_position = event.position
			_moveCamera = true
			if throw_tween:
				throw_tween.stop()
				_throw_position = Vector2.ZERO
		else:
			_moveCamera = false
			_throw()
			
	elif event is InputEventMouseMotion && _moveCamera:
		position += (_previous_position - event.position) / _zoom_level
		_throw_position = (_previous_position - event.position) * throw_distance
		_previous_position = event.position
