extends Camera2D
class_name DraggableCamera2D


# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
@export var zoom_factor := 0.25
# Duration of the zoom's tween animation.
@export var zoom_duration := 0.1


# The camera's target zoom level.
var _zoom_level : float = 1.0 :
	set(value):
		_zoom_level = value
		var tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", Vector2(_zoom_level, _zoom_level), zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false

var main_cam : Camera2D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# zoom out
		if event.pressed && event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_level = _zoom_level - zoom_factor * _zoom_level
		# zoom in
		if event.pressed && event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_level = _zoom_level + zoom_factor * _zoom_level
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			_previousPosition = event.position
			_moveCamera = true
		else:
			_moveCamera = false
	elif event is InputEventMouseMotion && _moveCamera:
		position += (_previousPosition - event.position) / _zoom_level
		_previousPosition = event.position
