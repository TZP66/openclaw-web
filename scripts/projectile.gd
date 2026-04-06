extends Area2D
class_name SpellProjectile

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

signal finished(projectile)
signal split_requested(projectile)

var damage: int = 12
var speed: float = 720.0
var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 1.2
var radius: float = 6.0
var pierce: int = 1
var max_distance: float = 620.0
var knockback: float = 180.0
var tint: Color = Color(0.48, 0.86, 1.0)
var secondary_tint: Color = Color(1.0, 1.0, 1.0, 0.32)
var homing_strength: float = 0.0
var homing_target: Node2D = null
var visual_style: String = "orb"
var split_on_hit: bool = false
var split_count: int = 0
var split_spread: float = 0.28
var split_generation: int = 0
var split_max_generations: int = 0
var split_damage_scale: float = 0.66
var split_speed_scale: float = 0.94
var split_range_scale: float = 0.72
var split_radius_scale: float = 0.82
var split_knockback_scale: float = 0.82
var split_child_pierce: int = 1
var split_visual_style: String = ""
var damage_falloff_on_hit: bool = false
var damage_falloff_factor: float = 0.80
var min_damage_multiplier: float = 0.40

var _travelled: float = 0.0
var _shape_node: CollisionShape2D
var _hit_targets: Dictionary = {}
var _visual_time: float = 0.0
var _base_sprite: Sprite2D
var _detail_sprite: Sprite2D
var _split_emitted: bool = false
var _base_damage: int = 0


func _ready() -> void:
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 2
	_base_damage = damage
	_ensure_collision_shape()
	_setup_visuals()
	_update_visuals()


func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		_finish()
		return

	_visual_time += delta
	if homing_strength > 0.0 and homing_target != null and is_instance_valid(homing_target):
		var to_target := homing_target.global_position - global_position
		if to_target != Vector2.ZERO:
			var blend := clampf(delta * homing_strength, 0.0, 1.0)
			direction = direction.lerp(to_target.normalized(), blend).normalized()

	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	var start_position := global_position
	var motion := direction.normalized() * speed * delta
	var next_position := start_position + motion
	var terrain_hit := _intersect_terrain(start_position, next_position)
	if not terrain_hit.is_empty():
		global_position = Vector2(terrain_hit.get("position", next_position))
		var collider = terrain_hit.get("collider", null)
		if collider != null and is_instance_valid(collider) and collider.has_method("absorb_projectile"):
			collider.absorb_projectile(global_position, tint)
		_finish()
		return

	global_position = next_position
	_travelled += motion.length()
	if _travelled >= max_distance:
		_finish()
		return

	for body in get_overlapping_bodies():
		var body_id := body.get_instance_id()
		if _hit_targets.has(body_id):
			continue
		if body.is_in_group("terrain"):
			if body.has_method("absorb_projectile"):
				body.absorb_projectile(global_position, tint)
			_finish()
			return
		if not body.has_method("take_damage"):
			continue

		_hit_targets[body_id] = true
		body.take_damage(damage, direction.normalized() * knockback)
		pierce -= 1
		_apply_damage_falloff()

		if split_on_hit and not _split_emitted and split_count > 0 and split_generation < split_max_generations:
			_split_emitted = true
			split_requested.emit(self)
			_finish()
			return

		if pierce <= 0:
			_finish()
			return

	_update_visuals()


func _setup_visuals() -> void:
	var body_texture: Texture2D = null
	var detail_texture: Texture2D = null
	if visual_style == "flame_fan":
		body_texture = SVG_EFFECT_LIBRARY.get_texture("projectile_flame_fan", tint, secondary_tint)
		detail_texture = SVG_EFFECT_LIBRARY.get_texture("projectile_flame_fan_glow", secondary_tint, tint)
	elif visual_style == "blade_wave":
		body_texture = SVG_EFFECT_LIBRARY.get_texture("projectile_blade_wave", tint, secondary_tint)
		detail_texture = SVG_EFFECT_LIBRARY.get_texture("projectile_blade_wave_glow", secondary_tint, tint)
	else:
		body_texture = SVG_EFFECT_LIBRARY.get_texture("projectile_orb", tint, secondary_tint)
		detail_texture = SVG_EFFECT_LIBRARY.get_texture("projectile_orb_ring", secondary_tint, tint)

	if _base_sprite == null:
		_base_sprite = SVG_EFFECT_LIBRARY.create_sprite("Body", body_texture, 0)
		add_child(_base_sprite)
	else:
		_base_sprite.texture = body_texture

	if _detail_sprite == null:
		_detail_sprite = SVG_EFFECT_LIBRARY.create_sprite("Detail", detail_texture, 1)
		add_child(_detail_sprite)
	else:
		_detail_sprite.texture = detail_texture


func _update_visuals() -> void:
	var draw_direction := direction.normalized()
	if draw_direction == Vector2.ZERO:
		draw_direction = Vector2.RIGHT

	if visual_style == "flame_fan":
		var spread := maxf(42.0, radius * 5.8)
		var length := maxf(30.0, radius * 4.2)
		SVG_EFFECT_LIBRARY.set_sprite_size(_base_sprite, Vector2(spread, length))
		_base_sprite.rotation = draw_direction.angle() + PI * 0.5
		_base_sprite.modulate = Color(1.0, 1.0, 1.0, 0.98)

		SVG_EFFECT_LIBRARY.set_sprite_size(_detail_sprite, Vector2(spread * 1.10, length * 1.16))
		_detail_sprite.rotation = draw_direction.angle() + PI * 0.5
		_detail_sprite.modulate = Color(1.0, 1.0, 1.0, 0.84)
		return

	if visual_style == "blade_wave":
		var width := maxf(18.0, radius * 3.4)
		var length := maxf(42.0, radius * 6.2)
		SVG_EFFECT_LIBRARY.set_sprite_size(_base_sprite, Vector2(length, width))
		_base_sprite.rotation = draw_direction.angle()
		_base_sprite.modulate = Color(1.0, 1.0, 1.0, 0.96)

		SVG_EFFECT_LIBRARY.set_sprite_size(_detail_sprite, Vector2(length * 1.12, width * 1.18))
		_detail_sprite.rotation = draw_direction.angle()
		_detail_sprite.modulate = Color(1.0, 1.0, 1.0, 0.80)
		return

	var pulse := 0.94 + sin(_visual_time * 11.0) * 0.08
	var diameter := maxf(18.0, (radius * 2.8 + 10.0) * pulse)
	var detail_alpha := maxf(0.58, secondary_tint.a * 1.9)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_base_sprite, diameter)
	_base_sprite.rotation = _visual_time * 5.6
	_base_sprite.modulate = Color(1.0, 1.0, 1.0, 0.96)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_detail_sprite, diameter * 1.36)
	_detail_sprite.rotation = -_visual_time * 6.8
	_detail_sprite.modulate = Color(1.0, 1.0, 1.0, detail_alpha)


func _ensure_collision_shape() -> void:
	_shape_node = get_node_or_null("CollisionShape2D")
	if _shape_node == null:
		_shape_node = CollisionShape2D.new()
		_shape_node.name = "CollisionShape2D"
		add_child(_shape_node)

	var shape := CircleShape2D.new()
	shape.radius = radius
	_shape_node.shape = shape


func _intersect_terrain(from_position: Vector2, to_position: Vector2) -> Dictionary:
	var query := PhysicsRayQueryParameters2D.create(from_position, to_position)
	query.collision_mask = 4
	query.collide_with_bodies = true
	query.collide_with_areas = false
	return get_world_2d().direct_space_state.intersect_ray(query)


func _apply_damage_falloff() -> void:
	if not damage_falloff_on_hit:
		return
	var min_damage: int = max(1, int(round(float(max(_base_damage, 1)) * min_damage_multiplier)))
	damage = maxi(min_damage, int(round(float(max(damage, 1)) * damage_falloff_factor)))


func _finish() -> void:
	finished.emit(self)
	queue_free()
