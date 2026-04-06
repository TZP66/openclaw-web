extends Area2D
class_name SpellSatellite

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

var orbit_owner: Node2D = null
var orbit_radius: float = 88.0
var angular_speed: float = 2.0
var damage: int = 10
var hit_interval: float = 0.22
var angle_offset: float = 0.0
var hit_knockback: float = 90.0
var visual_style: String = "arcane"
var primary_color: Color = Color(0.58, 0.34, 1.0)
var secondary_color: Color = Color(0.96, 0.88, 0.42, 0.84)
var body_radius: float = 12.0

var _time: float = 0.0
var _shape_node: CollisionShape2D
var _hit_cooldowns: Dictionary = {}
var _body_sprite: Sprite2D
var _detail_sprite: Sprite2D


func _ready() -> void:
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 2
	_ensure_collision_shape()
	_setup_visuals()
	_update_visuals()


func configure(
	new_owner: Node2D,
	start_angle: float,
	new_radius: float,
	new_speed: float,
	new_damage: int,
	options: Dictionary = {}
) -> void:
	orbit_owner = new_owner
	angle_offset = start_angle
	orbit_radius = new_radius
	angular_speed = new_speed
	damage = new_damage
	visual_style = String(options.get("visual_style", visual_style))
	primary_color = options.get("primary_color", primary_color)
	secondary_color = options.get("secondary_color", secondary_color)
	body_radius = float(options.get("body_radius", body_radius))
	hit_interval = float(options.get("hit_interval", hit_interval))
	hit_knockback = float(options.get("hit_knockback", hit_knockback))
	_update_shape()
	if is_inside_tree():
		_setup_visuals()
		_update_visuals()


func _physics_process(delta: float) -> void:
	if orbit_owner == null or not is_instance_valid(orbit_owner):
		queue_free()
		return

	_time += delta
	var cooldown_keys: Array = _hit_cooldowns.keys()
	for key_variant in cooldown_keys:
		var key: int = int(key_variant)
		var remaining: float = float(_hit_cooldowns[key]) - delta
		if remaining <= 0.0:
			_hit_cooldowns.erase(key)
		else:
			_hit_cooldowns[key] = remaining

	var orbit_angle := angle_offset + _time * angular_speed
	global_position = orbit_owner.global_position + Vector2.RIGHT.rotated(orbit_angle) * orbit_radius

	for body in get_overlapping_bodies():
		var body_id := body.get_instance_id()
		if _hit_cooldowns.has(body_id):
			continue
		if not body.has_method("take_damage"):
			continue

		var to_body := (body.global_position - global_position).normalized()
		if to_body == Vector2.ZERO:
			to_body = Vector2.RIGHT
		body.take_damage(damage, to_body * hit_knockback)
		_hit_cooldowns[body_id] = hit_interval

	_update_visuals()


func _setup_visuals() -> void:
	var body_texture: Texture2D = null
	var detail_texture: Texture2D = null
	if visual_style == "blade":
		body_texture = SVG_EFFECT_LIBRARY.get_texture("satellite_blade", primary_color, secondary_color)
		detail_texture = SVG_EFFECT_LIBRARY.get_texture("satellite_blade_glow", secondary_color, primary_color)
	else:
		body_texture = SVG_EFFECT_LIBRARY.get_texture("satellite_arcane", primary_color, secondary_color)
		detail_texture = SVG_EFFECT_LIBRARY.get_texture("satellite_arcane_ring", secondary_color, primary_color)

	if _body_sprite == null:
		_body_sprite = SVG_EFFECT_LIBRARY.create_sprite("Body", body_texture, 0)
		add_child(_body_sprite)
	else:
		_body_sprite.texture = body_texture

	if _detail_sprite == null:
		_detail_sprite = SVG_EFFECT_LIBRARY.create_sprite("Detail", detail_texture, 1)
		add_child(_detail_sprite)
	else:
		_detail_sprite.texture = detail_texture


func _update_visuals() -> void:
	if _body_sprite == null or _detail_sprite == null:
		return

	if visual_style == "blade":
		SVG_EFFECT_LIBRARY.set_sprite_size(_body_sprite, Vector2(body_radius * 1.40, body_radius * 2.56))
		_body_sprite.rotation = _time * 6.6
		_body_sprite.modulate = Color(1.0, 1.0, 1.0, 0.98)

		SVG_EFFECT_LIBRARY.set_sprite_size(_detail_sprite, Vector2(body_radius * 2.04, body_radius * 3.02))
		_detail_sprite.rotation = _time * 4.4
		_detail_sprite.modulate = Color(1.0, 1.0, 1.0, 0.72)
		return

	var pulse := 0.92 + sin(_time * 5.4) * 0.08
	SVG_EFFECT_LIBRARY.set_sprite_diameter(_body_sprite, body_radius * 2.26 * pulse)
	_body_sprite.rotation = _time * 3.8
	_body_sprite.modulate = Color(1.0, 1.0, 1.0, 0.96)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_detail_sprite, body_radius * 3.12)
	_detail_sprite.rotation = -_time * 2.8
	_detail_sprite.modulate = Color(1.0, 1.0, 1.0, maxf(0.64, secondary_color.a))


func _ensure_collision_shape() -> void:
	_shape_node = get_node_or_null("CollisionShape2D")
	if _shape_node == null:
		_shape_node = CollisionShape2D.new()
		_shape_node.name = "CollisionShape2D"
		add_child(_shape_node)
	_update_shape()


func _update_shape() -> void:
	if _shape_node == null:
		return
	var shape := CircleShape2D.new()
	shape.radius = body_radius
	_shape_node.shape = shape
