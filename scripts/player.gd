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
var _split_root: Node2D
var _split_base: Sprite2D
var _split_back_arm_pivot: Node2D
var _split_back_arm: Sprite2D
var _split_front_arm_pivot: Node2D
var _split_front_arm: Sprite2D
var _model_offset: Vector2 = Vector2.ZERO
var _model_scale: Vector2 = Vector2.ONE
var _split_model_center: Vector2 = Vector2(80.0, 80.0)
var _split_back_rest: Vector2 = Vector2.ZERO
var _split_front_rest: Vector2 = Vector2.ZERO
var _use_frame_animation: bool = false
var _use_split_model: bool = false
var _visual_facing_left: bool = false
var _signature_name: String = ""
var _signature_timer: float = 0.0
var _signature_duration: float = 0.0
var _signature_strength: float = 0.0
var _signature_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	collision_layer = 1
	collision_mask = 4
	_ensure_collision_shape()
	_ensure_sprite()
	_refresh_model()


func _physics_process(delta: float) -> void:
	_hurt_cooldown = maxf(0.0, _hurt_cooldown - delta)
	_flash_timer = maxf(0.0, _flash_timer - delta)
	_signature_timer = maxf(0.0, _signature_timer - delta)

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
	_signature_name = ""
	_signature_timer = 0.0
	_signature_duration = 0.0
	_signature_strength = 0.0
	_signature_direction = Vector2.ZERO
	_touch_move_vector = Vector2.ZERO
	velocity = Vector2.ZERO
	_facing_direction = Vector2.DOWN
	_visual_facing_left = false
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
		_signature_timer = 0.0
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


func trigger_action_signature(signature_name: String, duration: float = 0.18, strength: float = 1.0, direction: Vector2 = Vector2.ZERO) -> void:
	if signature_name.is_empty():
		return

	_signature_name = signature_name
	_signature_duration = maxf(duration, 0.01)
	_signature_timer = _signature_duration
	_signature_strength = maxf(strength, 0.0)
	_signature_direction = direction.normalized() if direction != Vector2.ZERO else _facing_direction
	if _signature_direction != Vector2.ZERO:
		_facing_direction = _signature_direction
	_update_visual_state()


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
	elif character_id == "alchemist":
		accent = Color(0.72, 0.92, 0.46, 0.28)
	elif character_id == "ranger":
		accent = Color(0.96, 0.86, 0.42, 0.28)
	elif character_id == "warden":
		accent = Color(0.52, 0.96, 0.84, 0.30)
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


func _ensure_split_rig() -> void:
	_split_root = get_node_or_null("ModelSplitRoot")
	if _split_root == null:
		_split_root = Node2D.new()
		_split_root.name = "ModelSplitRoot"
		_split_root.z_index = 2
		add_child(_split_root)

	_split_back_arm_pivot = _split_root.get_node_or_null("BackArmPivot")
	if _split_back_arm_pivot == null:
		_split_back_arm_pivot = Node2D.new()
		_split_back_arm_pivot.name = "BackArmPivot"
		_split_back_arm_pivot.z_index = 0
		_split_root.add_child(_split_back_arm_pivot)

	_split_base = _split_root.get_node_or_null("BaseSprite")
	if _split_base == null:
		_split_base = Sprite2D.new()
		_split_base.name = "BaseSprite"
		_split_base.centered = true
		_split_base.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		_split_base.z_index = 1
		_split_root.add_child(_split_base)

	_split_back_arm = _split_back_arm_pivot.get_node_or_null("BackArmSprite")
	if _split_back_arm == null:
		_split_back_arm = Sprite2D.new()
		_split_back_arm.name = "BackArmSprite"
		_split_back_arm.centered = true
		_split_back_arm.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		_split_back_arm_pivot.add_child(_split_back_arm)

	_split_front_arm_pivot = _split_root.get_node_or_null("FrontArmPivot")
	if _split_front_arm_pivot == null:
		_split_front_arm_pivot = Node2D.new()
		_split_front_arm_pivot.name = "FrontArmPivot"
		_split_front_arm_pivot.z_index = 2
		_split_root.add_child(_split_front_arm_pivot)

	_split_front_arm = _split_front_arm_pivot.get_node_or_null("FrontArmSprite")
	if _split_front_arm == null:
		_split_front_arm = Sprite2D.new()
		_split_front_arm.name = "FrontArmSprite"
		_split_front_arm.centered = true
		_split_front_arm.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		_split_front_arm_pivot.add_child(_split_front_arm)


func _refresh_model() -> void:
	_ensure_sprite()
	_ensure_split_rig()
	var model_info := SVG_MODEL_LIBRARY.get_character_model(character_id)
	_model_offset = model_info.get("game_offset", Vector2.ZERO)
	_model_scale = Vector2.ONE
	_use_frame_animation = SVG_MODEL_LIBRARY.has_character_frame_animation(character_id)
	_use_split_model = (not _use_frame_animation) and SVG_MODEL_LIBRARY.has_character_split_model(character_id)
	var reference_texture: Texture2D = null

	if _use_frame_animation:
		_sprite.texture = _get_current_frame_animation_texture(active and velocity.length_squared() > 1.0)
		_sprite.visible = true
		if _split_root != null:
			_split_root.visible = false
		reference_texture = _sprite.texture
	elif _use_split_model:
		var split_model := SVG_MODEL_LIBRARY.get_character_split_model(character_id)
		var parts: Dictionary = split_model.get("parts", {})
		_split_model_center = split_model.get("model_center", Vector2(80.0, 80.0))
		_split_base.texture = SVG_MODEL_LIBRARY.get_character_part_texture(character_id, "base")
		_split_back_arm.texture = SVG_MODEL_LIBRARY.get_character_part_texture(character_id, "back_arm")
		_split_front_arm.texture = SVG_MODEL_LIBRARY.get_character_part_texture(character_id, "front_arm_weapon")
		if _split_base.texture == null or _split_back_arm.texture == null or _split_front_arm.texture == null:
			_use_split_model = false
		else:
			_split_back_rest = _get_split_anchor_offset(parts.get("back_arm", {}))
			_split_front_rest = _get_split_anchor_offset(parts.get("front_arm_weapon", {}))
			_split_back_arm_pivot.position = _split_back_rest
			_split_front_arm_pivot.position = _split_front_rest
			_split_root.visible = true
			_sprite.visible = false
			reference_texture = _split_base.texture

	else:
		_sprite.texture = SVG_MODEL_LIBRARY.get_character_texture(character_id)
		_sprite.visible = true
		if _split_root != null:
			_split_root.visible = false
		reference_texture = _sprite.texture

	if reference_texture != null:
		var texture_size := reference_texture.get_size()
		if texture_size.y > 0.0:
			var scale_value := float(model_info.get("game_height", 88.0)) / texture_size.y
			_model_scale = Vector2.ONE * scale_value
	_update_visual_state()


func _update_visual_state() -> void:
	if _sprite == null and _split_root == null:
		return

	if absf(_facing_direction.x) > 0.12:
		_visual_facing_left = _facing_direction.x < 0.0

	var moving := active and velocity.length_squared() > 1.0
	var pulse := absf(sin(_motion_phase)) if moving else 0.0
	var bob := sin(_motion_phase) * 2.4 if moving else 0.0
	var signature_pose := _get_signature_pose()
	if _use_frame_animation and _sprite != null:
		var frame_texture := _get_current_frame_animation_texture(moving)
		if frame_texture != null:
			_sprite.texture = frame_texture
	if _use_split_model:
		_update_split_visual_state(moving, pulse, bob, signature_pose)
		return

	if _sprite == null:
		return

	_sprite.flip_h = _visual_facing_left
	_sprite.position = _model_offset + Vector2(0.0, bob) + signature_pose.get("offset", Vector2.ZERO)
	_sprite.rotation = clampf(velocity.x / maxf(move_speed, 1.0), -1.0, 1.0) * 0.08 + float(signature_pose.get("rotation", 0.0))
	var scale_multiplier: Vector2 = signature_pose.get("scale", Vector2.ONE)
	_sprite.scale = Vector2(_model_scale.x * (1.0 - pulse * 0.04) * scale_multiplier.x, _model_scale.y * (1.0 + pulse * 0.05) * scale_multiplier.y)
	_sprite.self_modulate = Color(1.0, 0.92, 0.82) if _flash_timer > 0.0 else Color.WHITE


func _get_current_frame_animation_texture(moving: bool) -> Texture2D:
	var animation_id := _resolve_frame_animation_id(moving)
	var frame_index := _resolve_frame_animation_index(animation_id, moving)
	return SVG_MODEL_LIBRARY.get_character_animation_texture(character_id, animation_id, frame_index)


func _resolve_frame_animation_id(moving: bool) -> String:
	if _signature_timer > 0.0 and SVG_MODEL_LIBRARY.get_character_animation_frame_count(character_id, _signature_name) > 0:
		return _signature_name
	if moving and SVG_MODEL_LIBRARY.get_character_animation_frame_count(character_id, "move") > 0:
		return "move"
	return "idle"


func _resolve_frame_animation_index(animation_id: String, moving: bool) -> int:
	var frame_count := SVG_MODEL_LIBRARY.get_character_animation_frame_count(character_id, animation_id)
	if frame_count <= 1:
		return 0

	if _signature_timer > 0.0 and animation_id == _signature_name:
		var progress := _get_signature_progress()
		if progress < 0.0:
			return 0
		return clampi(int(floor(progress * float(frame_count))), 0, frame_count - 1)

	if animation_id == "move" and moving:
		var cycle := fposmod(_motion_phase, TAU)
		return clampi(int(floor(cycle / TAU * float(frame_count))), 0, frame_count - 1)

	return 0


func _get_split_anchor_offset(part_info: Dictionary) -> Vector2:
	var anchor: Vector2 = part_info.get("anchor", _split_model_center)
	return (anchor - _split_model_center) * SVG_MODEL_LIBRARY.RASTER_SCALE


func _get_signature_progress() -> float:
	if _signature_timer <= 0.0 or _signature_duration <= 0.0 or _signature_strength <= 0.0:
		return -1.0
	return clampf(1.0 - _signature_timer / _signature_duration, 0.0, 1.0)


func _update_split_visual_state(moving: bool, pulse: float, bob: float, signature_pose: Dictionary) -> void:
	if _split_root == null or _split_base == null or _split_back_arm_pivot == null or _split_front_arm_pivot == null:
		return

	var scale_multiplier: Vector2 = signature_pose.get("scale", Vector2.ONE)
	var facing_sign := -1.0 if _visual_facing_left else 1.0
	_split_root.visible = true
	_split_root.position = _model_offset + Vector2(0.0, bob) + signature_pose.get("offset", Vector2.ZERO)
	_split_root.rotation = clampf(velocity.x / maxf(move_speed, 1.0), -1.0, 1.0) * 0.08 + float(signature_pose.get("rotation", 0.0))
	_split_root.scale = Vector2(_model_scale.x * facing_sign * scale_multiplier.x, _model_scale.y * scale_multiplier.y)
	_split_root.self_modulate = Color(1.0, 0.92, 0.82) if _flash_timer > 0.0 else Color.WHITE

	var move_cycle := sin(_motion_phase) if moving else 0.0
	var sway_pixels := move_cycle * (1.6 + 4.4 * pulse)
	var arm_bounce := absf(move_cycle) * (1.0 + 1.8 * pulse)
	var base_position := Vector2(0.0, -0.25 * arm_bounce)
	var base_rotation := sway_pixels * 0.008
	var back_position := _split_back_rest + Vector2(-0.55 * sway_pixels, 0.42 * arm_bounce)
	var front_position := _split_front_rest + Vector2(0.75 * sway_pixels, -0.28 * arm_bounce)
	var back_rotation := -0.04 - sway_pixels * 0.012
	var front_rotation := 0.06 + sway_pixels * 0.010
	var base_scale := Vector2.ONE
	var back_scale := Vector2.ONE
	var front_scale := Vector2.ONE
	var progress := _get_signature_progress()
	var strength := _signature_strength

	if progress >= 0.0:
		var peak := sin(progress * PI) * strength
		var windup := clampf(1.0 - progress * 2.0, 0.0, 1.0) * strength
		var release := clampf((progress - 0.20) / 0.80, 0.0, 1.0) * strength
		match _signature_name:
			"draw_shot":
				var draw_hold := clampf(progress / 0.55, 0.0, 1.0) * strength
				var snap := clampf((progress - 0.55) / 0.45, 0.0, 1.0) * strength
				back_position += Vector2(-18.0 * draw_hold + 8.0 * snap, -10.0 * draw_hold + 4.0 * snap)
				back_rotation += -0.72 * draw_hold + 0.36 * snap
				front_position += Vector2(10.0 * draw_hold - 6.0 * snap, -6.0 * draw_hold + 2.0 * snap)
				front_rotation += -0.18 * draw_hold + 0.20 * snap
				base_rotation += -0.05 * draw_hold + 0.03 * snap
				front_scale.x += 0.06 * draw_hold
			"glaive_throw":
				back_position += Vector2(-10.0 * windup + 6.0 * release, 4.0 * windup)
				back_rotation += -0.22 * windup + 0.28 * release
				front_position += Vector2(-8.0 * windup + 22.0 * release, -4.0 * windup - 8.0 * release)
				front_rotation += 0.24 * windup + 0.96 * release
				base_rotation += 0.08 * peak
				front_scale = Vector2(1.06 + 0.08 * release, 0.98 - 0.04 * windup)
			"trail_dash":
				back_position += Vector2(-10.0 * peak, 8.0 * peak)
				back_rotation += -0.54 * peak
				front_position += Vector2(-16.0 * peak, 10.0 * peak)
				front_rotation += -0.84 * peak
				base_position += Vector2(-4.0 * peak, 2.0 * peak)
				base_rotation += -0.10 * peak
				back_scale = Vector2(1.0 + 0.05 * peak, 1.0 - 0.03 * peak)
				front_scale = Vector2(1.0 + 0.10 * peak, 0.94 - 0.06 * peak)

	_split_base.position = base_position
	_split_base.rotation = base_rotation
	_split_base.scale = base_scale
	_split_back_arm_pivot.position = back_position
	_split_back_arm_pivot.rotation = back_rotation
	_split_back_arm_pivot.scale = back_scale
	_split_front_arm_pivot.position = front_position
	_split_front_arm_pivot.rotation = front_rotation
	_split_front_arm_pivot.scale = front_scale


func _get_signature_pose() -> Dictionary:
	if _signature_timer <= 0.0 or _signature_duration <= 0.0 or _signature_strength <= 0.0:
		return {
			"offset": Vector2.ZERO,
			"rotation": 0.0,
			"scale": Vector2.ONE,
		}

	var progress := 1.0 - _signature_timer / _signature_duration
	var peak := sin(progress * PI)
	var forward := _signature_direction if _signature_direction != Vector2.ZERO else _facing_direction
	if forward == Vector2.ZERO:
		forward = Vector2.DOWN
	forward = forward.normalized()
	var side := forward.orthogonal()
	var lean_x := clampf(forward.x, -1.0, 1.0)
	var offset := Vector2.ZERO
	var rotation := 0.0
	var scale := Vector2.ONE
	var strength := _signature_strength
	var windup := clampf(1.0 - progress * 2.0, 0.0, 1.0)
	var release := clampf((progress - 0.18) / 0.82, 0.0, 1.0)
	var signature_id := _signature_name

	match character_id:
		"caster":
			if signature_id == "storm_cast":
				release *= 1.18
			elif signature_id == "nova_cast":
				offset += side * sin(progress * TAU) * 1.8 * strength
			offset += forward * (-5.0 * windup + 4.0 * release) * strength
			offset += Vector2(0.0, -6.0 * peak * strength)
			rotation += lean_x * (0.04 * windup + 0.08 * release) * strength
			scale = Vector2(1.0 - 0.05 * peak * strength, 1.0 + 0.11 * peak * strength)
		"blade":
			if signature_id == "dash_cut":
				release = maxf(release, peak)
			elif signature_id == "mooncut":
				offset += side * 2.2 * sin(progress * PI) * strength
			offset += forward * (10.0 * peak * strength)
			offset += Vector2(0.0, 2.0 * windup * strength)
			rotation += lean_x * 0.18 * peak * strength
			scale = Vector2(1.10 + 0.04 * peak * strength, 0.88 - 0.04 * peak * strength)
		"thunder":
			if signature_id == "orb_throw":
				offset += forward * 2.0 * strength
			offset += forward * (3.0 + 4.0 * release) * strength
			offset += side * sin(progress * TAU) * 2.4 * strength
			offset += Vector2(0.0, -5.0 * peak * strength)
			rotation += lean_x * 0.12 * peak * strength + sin(progress * TAU) * 0.03 * strength
			scale = Vector2(0.96 - 0.03 * peak * strength, 1.08 + 0.08 * peak * strength)
		"alchemist":
			if signature_id == "catalyst_burst":
				release *= 1.16
				offset += side * 2.0 * sin(progress * PI) * strength
			offset += forward * (-6.0 * windup + 8.0 * release) * strength
			offset += side * 1.6 * windup * strength
			offset += Vector2(0.0, -3.0 * release * strength)
			rotation += lean_x * (-0.08 * windup + 0.12 * release) * strength
			scale = Vector2(1.02 + 0.04 * release * strength, 1.0 + 0.05 * windup * strength - 0.07 * release * strength)
		"ranger":
			if signature_id == "trail_dash":
				release *= 1.20
			elif signature_id == "glaive_throw":
				offset += side * 2.4 * strength
			offset += forward * (-8.0 * windup + 5.0 * release) * strength
			offset += side * -2.0 * windup * strength
			offset += Vector2(0.0, -4.0 * peak * strength)
			rotation += lean_x * (-0.10 * windup + 0.08 * release) * strength
			scale = Vector2(1.08 + 0.10 * windup * strength, 0.94 - 0.04 * windup * strength + 0.03 * release * strength)
		"warden":
			if signature_id == "brace_pulse":
				release *= 1.10
			offset += forward * (2.0 * release) * strength
			offset += Vector2(0.0, 5.0 * windup * strength)
			rotation += lean_x * 0.04 * release * strength
			scale = Vector2(1.08 + 0.04 * windup * strength, 0.90 - 0.05 * windup * strength)
		_:
			offset += Vector2(0.0, -3.0 * peak * strength)
			rotation += lean_x * 0.06 * peak * strength
			scale = Vector2(1.0, 1.0 + 0.05 * peak * strength)

	return {
		"offset": offset,
		"rotation": rotation,
		"scale": scale,
	}
