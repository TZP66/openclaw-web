extends StaticBody2D
class_name BossTank

signal projectile_fired(projectile)
signal shot_fired
signal damaged(boss, current, maximum)
signal defeated(boss)
signal health_changed(current, maximum)

const BASE_MAX_HEALTH := 24

var target: Node2D = null
var active: bool = false
var health: int = BASE_MAX_HEALTH
var max_health: int = BASE_MAX_HEALTH
var stage_rank: int = 1
var projectile_speed_main: float = 520.0
var projectile_speed_side: float = 470.0
var projectile_range: float = 1060.0
var burst_cooldown: float = 1.35
var fan_cooldown: float = 1.8

var _attack_timer: float = 0.9
var _flash_timer: float = 0.0
var _pattern_index: int = 0
var _turret_direction: Vector2 = Vector2.LEFT
var _shape_node: CollisionShape2D


func _ready() -> void:
	add_to_group("enemy")
	add_to_group("boss")
	_ensure_shape()
	health_changed.emit(health, max_health)


func _process(delta: float) -> void:
	_attack_timer = maxf(0.0, _attack_timer - delta)
	_flash_timer = maxf(0.0, _flash_timer - delta)

	if target != null and is_instance_valid(target):
		var aim_target := target.global_position + Vector2(0.0, -20.0)
		_turret_direction = (aim_target - (global_position + Vector2(-82.0, -54.0))).normalized()
		if _turret_direction == Vector2.ZERO:
			_turret_direction = Vector2.LEFT

	if active and _can_attack() and _attack_timer <= 0.0:
		_fire_pattern()

	queue_redraw()


func configure(threat: int) -> void:
	stage_rank = max(1, threat)
	max_health = BASE_MAX_HEALTH + int((stage_rank - 1) * 2.5)
	health = max_health
	projectile_speed_main = 520.0 + float(stage_rank - 1) * 12.0
	projectile_speed_side = 470.0 + float(stage_rank - 1) * 11.0
	projectile_range = 1060.0 + float(stage_rank - 1) * 20.0
	burst_cooldown = maxf(0.78, 1.35 - float(stage_rank - 1) * 0.018)
	fan_cooldown = maxf(1.08, 1.8 - float(stage_rank - 1) * 0.02)
	_attack_timer = 0.9
	_pattern_index = 0
	if is_inside_tree():
		health_changed.emit(health, max_health)
		queue_redraw()


func set_target(player_target: Node2D) -> void:
	target = player_target


func set_active(is_active: bool) -> void:
	active = is_active


func is_alive() -> bool:
	return health > 0


func take_damage(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return
	health = max(0, health - amount)
	_flash_timer = 0.16
	health_changed.emit(health, max_health)
	if health <= 0:
		active = false
		defeated.emit(self)
		queue_free()
		return
	damaged.emit(self, health, max_health)


func _can_attack() -> bool:
	if target == null or not is_instance_valid(target):
		return false
	if target.has_method("is_alive") and not target.is_alive():
		return false
	var delta_to_player := target.global_position - global_position
	return absf(delta_to_player.x) <= 1280.0 and absf(delta_to_player.y) <= 360.0


func _fire_pattern() -> void:
	var base_direction := _turret_direction
	if base_direction == Vector2.ZERO:
		base_direction = Vector2.LEFT

	var angles: Array = []
	if _pattern_index % 2 == 0:
		angles = _get_burst_angles()
		_attack_timer = burst_cooldown
	else:
		angles = _get_fan_angles()
		_attack_timer = fan_cooldown

	for angle in angles:
		var projectile := Projectile.new()
		projectile.from_player = false
		projectile.damage = 1
		projectile.speed = projectile_speed_main if absf(float(angle)) < 0.24 else projectile_speed_side
		projectile.direction = base_direction.rotated(float(angle))
		projectile.tint = Color(1.0, 0.50, 0.24) if stage_rank >= 12 else Color(1.0, 0.42, 0.24)
		projectile.radius = 6.2
		projectile.lifetime = 2.3
		projectile.max_travel_distance = projectile_range
		projectile.source = self
		projectile.global_position = global_position + Vector2(-82.0, -54.0) + projectile.direction * 44.0
		projectile_fired.emit(projectile)

	_pattern_index += 1
	shot_fired.emit()


func _get_burst_angles() -> Array:
	if stage_rank >= 15:
		return [-0.34, -0.17, 0.0, 0.17, 0.34]
	if stage_rank >= 8:
		return [-0.28, -0.08, 0.08, 0.28]
	return [-0.22, 0.0, 0.22]


func _get_fan_angles() -> Array:
	if stage_rank >= 18:
		return [-0.60, -0.38, -0.18, 0.0, 0.18, 0.38, 0.60]
	if stage_rank >= 10:
		return [-0.52, -0.31, -0.10, 0.10, 0.31, 0.52]
	return [-0.42, -0.21, 0.0, 0.21, 0.42]


func _draw() -> void:
	var hull := Color(0.35, 0.39, 0.46) if stage_rank < 12 else Color(0.42, 0.29, 0.27)
	if _flash_timer > 0.0:
		hull = Color(1.0, 0.92, 0.74)
	var armor := Color(0.64, 0.70, 0.78)
	var tread := Color(0.12, 0.14, 0.16)
	var weak := Color(0.98, 0.51, 0.23)

	draw_rect(Rect2(-92.0, -72.0, 184.0, 64.0), hull)
	draw_rect(Rect2(-118.0, -20.0, 236.0, 24.0), tread)
	draw_rect(Rect2(-96.0, -8.0, 192.0, 16.0), armor)
	draw_rect(Rect2(-50.0, -112.0, 108.0, 48.0), armor)
	draw_rect(Rect2(-18.0, -96.0, 44.0, 22.0), weak)

	for index in range(6):
		var wheel_x := -88.0 + float(index) * 36.0
		draw_circle(Vector2(wheel_x, -8.0), 10.0, Color(0.23, 0.26, 0.29))

	var turret_base := Vector2(-6.0, -88.0)
	var barrel_start := Vector2(-20.0, -86.0)
	var barrel_end := barrel_start + _turret_direction * 92.0
	draw_circle(turret_base, 24.0, hull)
	draw_line(barrel_start, barrel_end, armor, 14.0)
	draw_line(barrel_end, barrel_end + _turret_direction * 18.0, weak, 8.0)
	if stage_rank >= 14:
		draw_circle(Vector2(-6.0, -88.0), 6.0, Color(1.0, 0.86, 0.36))


func _ensure_shape() -> void:
	_shape_node = get_node_or_null("CollisionShape2D")
	if _shape_node == null:
		_shape_node = CollisionShape2D.new()
		_shape_node.name = "CollisionShape2D"
		add_child(_shape_node)
	var shape := RectangleShape2D.new()
	shape.size = Vector2(236.0, 116.0)
	_shape_node.shape = shape
	_shape_node.position = Vector2(0.0, -54.0)
