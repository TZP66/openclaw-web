extends Control
class_name VirtualJoystick

signal move_vector_changed(vector)

const DEADZONE := 0.12

var base_radius: float = 88.0
var knob_radius: float = 26.0
var touch_area: Rect2 = Rect2(0.0, 0.0, 1.0, 1.0)
var show_only_while_active: bool = true

var _active_touch_id: int = -1
var _mouse_drag_active: bool = false
var _drag_vector: Vector2 = Vector2.ZERO
var _drag_origin: Vector2 = Vector2.ZERO
var _visual_active: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventScreenTouch:
		_handle_screen_touch(event)
		return
	if event is InputEventScreenDrag:
		_handle_screen_drag(event)
		return
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
		return
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)


func force_release() -> void:
	_release_drag()


func _exit_tree() -> void:
	_release_drag()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and not is_visible_in_tree():
		_release_drag()


func _draw() -> void:
	if not _visual_active and show_only_while_active:
		return
	if not _visual_active:
		return

	var knob_center := _drag_origin + _drag_vector * base_radius
	draw_circle(_drag_origin, knob_radius + 10.0, Color(0.02, 0.04, 0.06, 0.18))
	draw_arc(_drag_origin, base_radius * 0.55, 0.0, TAU, 32, Color(0.38, 0.84, 1.0, 0.32), 2.0)
	draw_line(_drag_origin, knob_center, Color(0.46, 0.88, 1.0, 0.36), 5.0)
	draw_circle(knob_center, knob_radius + 6.0, Color(0.02, 0.04, 0.06, 0.20))
	draw_circle(knob_center, knob_radius, Color(0.88, 0.95, 1.0, 0.86))
	draw_arc(knob_center, knob_radius + 4.0, 0.0, TAU, 24, Color(0.12, 0.36, 0.54, 0.72), 2.0)


func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		if _mouse_drag_active or _active_touch_id != -1:
			return
		if _is_point_inside_touch_area(event.position):
			_active_touch_id = event.index
			_begin_drag(event.position)
			get_viewport().set_input_as_handled()
	elif event.index == _active_touch_id:
		_release_drag()
		get_viewport().set_input_as_handled()


func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	if event.index != _active_touch_id:
		return
	_update_drag(event.position)
	get_viewport().set_input_as_handled()


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index != MOUSE_BUTTON_LEFT or _active_touch_id != -1:
		return

	if event.pressed:
		if _is_point_inside_touch_area(event.position):
			_mouse_drag_active = true
			_begin_drag(event.position)
			get_viewport().set_input_as_handled()
	elif _mouse_drag_active:
		_release_drag()
		get_viewport().set_input_as_handled()


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if not _mouse_drag_active or _active_touch_id != -1:
		return
	_update_drag(event.position)
	get_viewport().set_input_as_handled()


func _begin_drag(pointer_position: Vector2) -> void:
	_visual_active = true
	_drag_origin = _clamp_drag_origin(pointer_position)
	_update_drag(pointer_position)


func _update_drag(pointer_position: Vector2) -> void:
	var offset := pointer_position - _drag_origin
	var limit := maxf(base_radius, 1.0)
	if offset.length() > limit:
		offset = offset.normalized() * limit
	_drag_vector = offset / limit
	_emit_move_vector()
	queue_redraw()


func _release_drag() -> void:
	var had_input := _visual_active or _active_touch_id != -1 or _mouse_drag_active or _drag_vector != Vector2.ZERO
	_active_touch_id = -1
	_mouse_drag_active = false
	_drag_vector = Vector2.ZERO
	_visual_active = false
	if had_input:
		move_vector_changed.emit(Vector2.ZERO)
	queue_redraw()


func _emit_move_vector() -> void:
	var strength := _drag_vector.length()
	if strength < DEADZONE:
		move_vector_changed.emit(Vector2.ZERO)
		return

	var normalized_strength := clampf((strength - DEADZONE) / maxf(1.0 - DEADZONE, 0.0001), 0.0, 1.0)
	move_vector_changed.emit(_drag_vector.normalized() * normalized_strength)


func _is_point_inside_touch_area(point: Vector2) -> bool:
	return _get_touch_area_rect().has_point(point)


func _get_touch_area_rect() -> Rect2:
	var normalized := touch_area.abs()
	var area_position := Vector2(
		size.x * normalized.position.x,
		size.y * normalized.position.y
	)
	var area_size := Vector2(
		size.x * normalized.size.x,
		size.y * normalized.size.y
	)
	return Rect2(area_position, area_size)


func _clamp_drag_origin(pointer_position: Vector2) -> Vector2:
	var area := _get_touch_area_rect()
	var margin := Vector2(base_radius + 16.0, base_radius + 16.0)
	if area.size.x <= margin.x * 2.0 or area.size.y <= margin.y * 2.0:
		return area.get_center()

	return Vector2(
		clampf(pointer_position.x, area.position.x + margin.x, area.end.x - margin.x),
		clampf(pointer_position.y, area.position.y + margin.y, area.end.y - margin.y)
	)
