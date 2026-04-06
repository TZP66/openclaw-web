extends CharacterBody2D
class_name Player

const SVG_MODEL_LIBRARY := preload("res://scripts/svg_model_library.gd")

signal damaged(current_health)
signal died

var active: bool = false
var move_speed: float = 240.0
var move_speed_multiplier: float = 1.0
var max_health: int = 8
var health: int = 8
var pickup_radius: float = 140.0
var character_id: String = "caster"

var _body_radius: float = 18.0
var _hurt_cooldown: float = 0.0
var _flash_timer: float = 0.0
var _facing_direction: Vector2 = Vector2.DOWN
var _motion_phase: float = 0.0
var _touch_move_vector: Vector2 = Vector2.ZERO
var _shape_node: CollisionShape2D
var _sprite: Sprite2D
var _model_offset: Vector2 = Vector2.ZERO
var _model_scale: Vector2 = Vector2.ONE


func _ready() -> void:
	collision_layer = 1
	collision_mask = 4
	_ensure_collision_shape()
	_ensure_sprite()
	_refresh_model()


func _physics_process(delta: float) -> void:
	_hurt_cooldown = maxf(0.0, _hurt_cooldown - delta)
	_flash_timer = maxf(0.0, _flash_timer - delta)

	if not active:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_visual_state()
		return

	var keyboard_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_vector := keyboard_input
	if _touch_move_vector.length_squared() > 0.0 and _touch_move_vector.length_squared() >= keyboard_input.length_squared():
		input_vector = _touch_move_vector
	if input_vector != Vector2.ZERO:
		_facing_direction = input_vector.normalized()
		_motion_phase += delta * 8.0
	else:
		_motion_phase = move_toward(_motion_phase, 0.0, delta * 8.0)

	velocity = input_vector * move_speed * move_speed_multiplier
	move_and_slide()
	_update_visual_state()


func reset_for_run(start_position: Vector2, new_max_health: int, new_speed: float, new_pickup_radius: float) -> void:
	global_position = start_position
	move_speed = new_speed
	move_speed_multiplier = 1.0
	max_health = max(1, new_max_health)
	health = max_health
	pickup_radius = new_pickup_radius
	active = true
	_hurt_cooldown = 0.0
	_flash_timer = 0.0
	_touch_move_vector = Vector2.ZERO
	velocity = Vector2.ZERO
	_facing_direction = Vector2.DOWN
	_update_visual_state()
	queue_redraw()


func set_build_stats(new_speed: float, new_max_health: int, new_pickup_radius: float) -> void:
	var old_max_health: int = max(1, max_health)
	var health_ratio := float(health) / float(old_max_health)
	move_speed = new_speed
	max_health = max(1, new_max_health)
	pickup_radius = new_pickup_radius
	health = clampi(int(round(health_ratio * float(max_health))), 1, max_health)
	_update_visual_state()


func set_move_speed_multiplier(multiplier: float) -> void:
	move_speed_multiplier = clampf(multiplier, 0.25, 2.4)


func set_character(new_character_id: String) -> void:
	character_id = new_character_id if not new_character_id.is_empty() else "caster"
	_refresh_model()
	queue_redraw()


func set_active(is_active: bool) -> void:
	active = is_active
	if not active:
		_touch_move_vector = Vector2.ZERO
		velocity = Vector2.ZERO
	_update_visual_state()


func set_touch_move_vector(vector: Vector2) -> void:
	_touch_move_vector = vector.limit_length(1.0)


func set_facing_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return
	_facing_direction = direction.normalized()
	_update_visual_state()
	queue_redraw()


func get_facing_direction() -> Vector2:
	return _facing_direction


func take_damage(amount: int) -> void:
	if amount <= 0 or not active or health <= 0 or _hurt_cooldown > 0.0:
		return

	health = max(0, health - amount)
	_hurt_cooldown = 0.55
	_flash_timer = 0.18
	damaged.emit(health)
	_update_visual_state()
	queue_redraw()

	if health <= 0:
		active = false
		died.emit()


func heal(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return
	health = min(max_health, health + amount)


func is_alive() -> bool:
	return health > 0


func get_pickup_radius() -> float:
	return pickup_radius


func get_body_radius() -> float:
	return _body_radius


func _draw() -> void:
	var accent := Color(0.40, 0.86, 1.0, 0.24)
	if character_id == "blade":
		accent = Color(1.0, 0.58, 0.34, 0.26)
	elif character_id == "thunder":
		accent = Color(0.56, 0.84, 1.0, 0.30)
	if _flash_timer > 0.0:
		accent = Color(1.0, 0.92, 0.72, 0.36)

	draw_circle(Vector2(0.0, 14.0), _body_radius + 9.0, Color(0.03, 0.05, 0.07, 0.28))
	draw_arc(Vector2(0.0, 6.0), _body_radius + 14.0, 0.0, TAU, 36, accent, 2.2)


func _ensure_collision_shape() -> void:
	_shape_node = get_node_or_null("CollisionShape2D")
	if _shape_node == null:
		_shape_node = CollisionShape2D.new()
		_shape_node.name = "CollisionShape2D"
		add_child(_shape_node)

	var shape := CircleShape2D.new()
	shape.radius = _body_radius
	_shape_node.shape = shape


func _ensure_sprite() -> void:
	_sprite = get_node_or_null("ModelSprite")
	if _sprite == null:
		_sprite = Sprite2D.new()
		_sprite.name = "ModelSprite"
		_sprite.z_index = 2
		_sprite.centered = true
		_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		add_child(_sprite)


func _refresh_model() -> void:
	_ensure_sprite()
	var model_info := SVG_MODEL_LIBRARY.get_character_model(character_id)
	_sprite.texture = SVG_MODEL_LIBRARY.get_character_texture(character_id)
	_model_offset = model_info.get("game_offset", Vector2.ZERO)
	_model_scale = Vector2.ONE
	if _sprite.texture != null:
		var texture_size := _sprite.texture.get_size()
		if texture_size.y > 0.0:
			var scale_value := float(model_info.get("game_height", 88.0)) / texture_size.y
			_model_scale = Vector2.ONE * scale_value
	_update_visual_state()


func _update_visual_state() -> void:
	if _sprite == null:
		return

	if absf(_facing_direction.x) > 0.12:
		_sprite.flip_h = _facing_direction.x < 0.0

	var moving := active and velocity.length_squared() > 1.0
	var pulse := absf(sin(_motion_phase)) if moving else 0.0
	var bob := sin(_motion_phase) * 2.4 if moving else 0.0
	_sprite.position = _model_offset + Vector2(0.0, bob)
	_sprite.rotation = clampf(velocity.x / maxf(move_speed, 1.0), -1.0, 1.0) * 0.08
	_sprite.scale = Vector2(_model_scale.x * (1.0 - pulse * 0.04), _model_scale.y * (1.0 + pulse * 0.05))
	_sprite.self_modulate = Color(1.0, 0.92, 0.82) if _flash_timer > 0.0 else Color.WHITE
