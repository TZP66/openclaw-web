extends CharacterBody2D
class_name EnemySoldier

const SVG_MODEL_LIBRARY := preload("res://scripts/svg_model_library.gd")

signal defeated(enemy, experience_value)
signal special_attack(position, radius, primary_color, secondary_color)
signal summon_requested(position, summon_type, count, radius)
signal boss_phase_changed(enemy, phase_index)

var target: Player = null
var active: bool = true
var archetype: String = "wisp"
var elite: bool = false
var boss: bool = false
var speed: float = 90.0
var health: int = 18
var max_health: int = 18
var shield: int = 0
var max_shield: int = 0
var touch_damage: int = 1
var experience_value: int = 1

var _body_radius: float = 14.0
var _touch_cooldown: float = 0.0
var _flash_timer: float = 0.0
var _knockback: Vector2 = Vector2.ZERO
var _phase: float = 0.0
var _special_timer: float = 0.0
var _dash_time: float = 0.0
var _dash_velocity: Vector2 = Vector2.ZERO
var _orbit_direction: float = 1.0
var _summon_type: String = "seer"
var _special_cycle: int = 0
var _boss_phase_index: int = 0
var _boss_phase_thresholds := [0.70, 0.40, 0.15]
var _shape_node: CollisionShape2D
var _sprite: Sprite2D
var _model_offset: Vector2 = Vector2.ZERO
var _model_scale: Vector2 = Vector2.ONE
var _facing_direction: Vector2 = Vector2.RIGHT


func _ready() -> void:
	collision_layer = 2
	collision_mask = 4
	_ensure_collision_shape()
	_ensure_sprite()
	_refresh_model()


func configure(type_name: String, wave_rank: int, is_elite: bool, player_target: Player, options: Dictionary = {}) -> void:
	archetype = type_name
	elite = is_elite
	target = player_target
	boss = bool(options.get("boss", false)) or archetype in ["storm_archon", "forge_tyrant", "void_matriarch"]
	_phase = randf() * TAU
	_special_timer = randf_range(1.1, 2.2)
	_dash_time = 0.0
	_dash_velocity = Vector2.ZERO
	_orbit_direction = 1.0 if randf() < 0.5 else -1.0
	_summon_type = String(options.get("summon_type", "seer"))
	_special_cycle = randi() % 3
	_boss_phase_index = 0
	shield = 0
	max_shield = 0

	match archetype:
		"lancer":
			_body_radius = 16.0
			speed = 86.0 + float(wave_rank) * 2.0
			max_health = 28 + wave_rank * 4
			touch_damage = 1
			experience_value = 2
			_special_timer = randf_range(1.8, 2.6)
		"brute":
			_body_radius = 20.0
			speed = 62.0 + float(wave_rank) * 1.4
			max_health = 48 + wave_rank * 7
			touch_damage = 2
			experience_value = 3
		"embermage":
			_body_radius = 18.0
			speed = 76.0 + float(wave_rank) * 1.7
			max_health = 34 + wave_rank * 5
			touch_damage = 2
			experience_value = 2
			_special_timer = randf_range(1.5, 2.3)
		"seer":
			_body_radius = 16.0
			speed = 92.0 + float(wave_rank) * 2.0
			max_health = 28 + wave_rank * 4
			touch_damage = 1
			experience_value = 2
		"mireling":
			_body_radius = 22.0
			speed = 58.0 + float(wave_rank) * 1.3
			max_health = 58 + wave_rank * 8
			touch_damage = 2
			experience_value = 3
		"storm_archon":
			boss = true
			_body_radius = 42.0
			speed = 112.0 + float(wave_rank) * 2.8
			max_health = 460 + wave_rank * 36
			touch_damage = 3
			experience_value = 20
			_special_timer = 3.1
		"forge_tyrant":
			boss = true
			_body_radius = 46.0
			speed = 72.0 + float(wave_rank) * 1.4
			max_health = 620 + wave_rank * 44
			touch_damage = 4
			experience_value = 24
			_special_timer = 3.8
		"void_matriarch":
			boss = true
			_body_radius = 40.0
			speed = 86.0 + float(wave_rank) * 1.9
			max_health = 540 + wave_rank * 40
			touch_damage = 3
			experience_value = 22
			_special_timer = 4.4
		_:
			_body_radius = 14.0
			speed = 80.0 + float(wave_rank) * 2.2
			max_health = 22 + wave_rank * 3
			touch_damage = 1
			experience_value = 1

	if elite and not boss:
		_body_radius += 8.0
		speed *= 1.12
		max_health = int(round(float(max_health) * 2.2))
		touch_damage += 1
		experience_value += 4

	health = max_health
	_update_shape()
	_refresh_model()
	queue_redraw()


func _physics_process(delta: float) -> void:
	_touch_cooldown = maxf(0.0, _touch_cooldown - delta)
	_special_timer = maxf(0.0, _special_timer - delta)
	_dash_time = maxf(0.0, _dash_time - delta)
	if _flash_timer > 0.0:
		_flash_timer = maxf(0.0, _flash_timer - delta)
		if _flash_timer <= 0.0:
			queue_redraw()
	_phase += delta * (1.2 if boss else 1.8)

	if not active or target == null or not is_instance_valid(target) or not target.is_alive():
		velocity = _knockback
		_knockback = _knockback.move_toward(Vector2.ZERO, 620.0 * delta)
		move_and_slide()
		_update_visual_state()
		return

	var to_player := target.global_position - global_position
	var direction := to_player.normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.DOWN
	_facing_direction = direction

	_process_special_behavior(to_player, direction)

	var desired_velocity := _build_desired_velocity(to_player, direction)
	velocity = desired_velocity + _knockback
	_knockback = _knockback.move_toward(Vector2.ZERO, 780.0 * delta)
	move_and_slide()
	_update_visual_state()

	var hurt_distance := _body_radius + target.get_body_radius() + (10.0 if boss else 4.0)
	if global_position.distance_to(target.global_position) <= hurt_distance and _touch_cooldown <= 0.0:
		target.take_damage(touch_damage)
		_touch_cooldown = 0.9 if boss else 0.72

	if boss:
		queue_redraw()


func set_active(is_active: bool) -> void:
	active = is_active
	if not active:
		velocity = Vector2.ZERO


func take_damage(amount: int, impulse: Vector2 = Vector2.ZERO) -> void:
	if amount <= 0 or health <= 0:
		return

	if shield > 0:
		var absorbed := mini(shield, amount)
		shield -= absorbed
		amount -= absorbed
	if amount > 0:
		health = max(0, health - amount)
	_flash_timer = 0.14
	_apply_impulse_internal(impulse)
	_check_boss_phase_transition()
	_update_visual_state()
	queue_redraw()

	if health <= 0:
		active = false
		defeated.emit(self, experience_value)
		queue_free()


func get_body_radius() -> float:
	return _body_radius


func set_shield(amount: int) -> void:
	max_shield = max(amount, 0)
	shield = max_shield
	queue_redraw()


func scale_vitality(multiplier: float, include_shield: bool = false) -> void:
	if multiplier <= 0.0:
		return
	max_health = max(1, int(round(float(max_health) * multiplier)))
	health = max(1, int(round(float(health) * multiplier)))
	if include_shield and max_shield > 0:
		max_shield = max(1, int(round(float(max_shield) * multiplier)))
		shield = max(0, int(round(float(shield) * multiplier)))
	queue_redraw()


func apply_impulse(impulse: Vector2) -> void:
	if impulse == Vector2.ZERO or health <= 0:
		return
	_apply_impulse_internal(impulse)


func _apply_impulse_internal(impulse: Vector2) -> void:
	var knockback_scale := 0.22 if boss else 1.0
	_knockback += impulse * knockback_scale * (1.0 / maxf(_body_radius, 1.0))


func is_boss() -> bool:
	return boss


func get_boss_phase_index() -> int:
	return _boss_phase_index


func _process_special_behavior(to_player: Vector2, direction: Vector2) -> void:
	if _special_timer > 0.0:
		return

	match archetype:
		"lancer":
			_dash_velocity = direction * speed * 3.2
			_dash_time = 0.34
			_special_timer = randf_range(1.8, 2.6)
		"embermage":
			var radius := 72.0
			special_attack.emit(global_position, radius, Color(1.0, 0.76, 0.34), Color(1.0, 0.38, 0.18))
			if _player_in_radius(global_position, radius):
				target.take_damage(1)
			_special_timer = randf_range(1.9, 2.7)
		"storm_archon":
			_use_storm_archon_skill(direction)
		"forge_tyrant":
			_use_forge_tyrant_skill(direction)
		"void_matriarch":
			_use_void_matriarch_skill(direction)


func _use_storm_archon_skill(direction: Vector2) -> void:
	var phase_bonus := float(_boss_phase_index)
	var cycle := _special_cycle % 3
	if cycle == 0:
		var blast_radius := 92.0 + phase_bonus * 10.0
		_dash_velocity = direction * speed * (4.6 + phase_bonus * 0.45)
		_dash_time = 0.66 + phase_bonus * 0.04
		_orbit_direction *= -1.0
		special_attack.emit(global_position, blast_radius, Color(0.84, 0.94, 1.0), Color(0.28, 0.70, 1.0))
		var flank_positions: Array[Vector2] = []
		if _boss_phase_index >= 2:
			var flank_offset := direction.orthogonal() * (112.0 + phase_bonus * 10.0)
			flank_positions = [
				target.global_position + flank_offset,
				target.global_position - flank_offset,
			]
			for blast_position in flank_positions:
				special_attack.emit(blast_position, 52.0 + phase_bonus * 4.0, Color(0.82, 0.92, 1.0), Color(0.20, 0.54, 0.98))
		if _player_in_radius(global_position, blast_radius) or _player_in_any_radius(flank_positions, 52.0 + phase_bonus * 4.0):
			target.take_damage(2 + int(_boss_phase_index >= 2))
		_special_timer = maxf(2.9, 4.2 - phase_bonus * 0.30)
	elif cycle == 1:
		var cross_distance := 96.0 + phase_bonus * 12.0
		var cross_positions: Array[Vector2] = [
			target.global_position,
			target.global_position + Vector2(cross_distance, 0.0),
			target.global_position + Vector2(-cross_distance, 0.0),
			target.global_position + Vector2(0.0, cross_distance),
			target.global_position + Vector2(0.0, -cross_distance),
		]
		if _boss_phase_index >= 1:
			var diagonal := cross_distance * 0.72
			cross_positions.append_array([
				target.global_position + Vector2(diagonal, diagonal),
				target.global_position + Vector2(diagonal, -diagonal),
				target.global_position + Vector2(-diagonal, diagonal),
				target.global_position + Vector2(-diagonal, -diagonal),
			])
		for blast_position in cross_positions:
			special_attack.emit(blast_position, 64.0 + phase_bonus * 4.0, Color(0.88, 0.96, 1.0), Color(0.34, 0.62, 1.0))
		if _player_in_any_radius(cross_positions, 64.0 + phase_bonus * 4.0):
			target.take_damage(2 + int(_boss_phase_index >= 2))
		_special_timer = maxf(3.2, 4.9 - phase_bonus * 0.34)
	else:
		var ring_positions: Array[Vector2] = []
		var ring_count := 6 + _boss_phase_index * 2
		var ring_radius := 148.0 + phase_bonus * 12.0
		for index in range(ring_count):
			var angle := TAU * float(index) / float(ring_count) + _phase * 0.18
			ring_positions.append(global_position + Vector2.RIGHT.rotated(angle) * ring_radius)
		for blast_position in ring_positions:
			special_attack.emit(blast_position, 58.0 + phase_bonus * 4.0, Color(0.68, 0.88, 1.0), Color(0.20, 0.54, 0.98))
		var center_radius := 74.0 + phase_bonus * 8.0
		special_attack.emit(global_position, center_radius, Color(0.88, 0.96, 1.0), Color(0.28, 0.70, 1.0))
		if _player_in_any_radius(ring_positions, 58.0 + phase_bonus * 4.0) or _player_in_radius(global_position, center_radius):
			target.take_damage(1 + int(_boss_phase_index >= 1))
		_special_timer = maxf(3.4, 5.3 - phase_bonus * 0.38)
	_special_cycle += 1


func _use_forge_tyrant_skill(direction: Vector2) -> void:
	var phase_bonus := float(_boss_phase_index)
	var cycle := _special_cycle % 3
	if cycle == 0:
		var shockwave_radius := 146.0 + phase_bonus * 14.0
		special_attack.emit(global_position, shockwave_radius, Color(1.0, 0.76, 0.42), Color(0.92, 0.32, 0.18))
		var side_bursts: Array[Vector2] = []
		if _boss_phase_index >= 1:
			var side_offset := direction.orthogonal() * (108.0 + phase_bonus * 10.0)
			side_bursts = [global_position + side_offset, global_position - side_offset]
			for blast_position in side_bursts:
				special_attack.emit(blast_position, 52.0 + phase_bonus * 4.0, Color(1.0, 0.84, 0.52), Color(0.84, 0.24, 0.12))
		if _player_in_radius(global_position, shockwave_radius) or _player_in_any_radius(side_bursts, 52.0 + phase_bonus * 4.0):
			target.take_damage(2 + int(_boss_phase_index >= 2))
		_special_timer = maxf(3.2, 4.6 - phase_bonus * 0.30)
	elif cycle == 1:
		var orthogonal := direction.orthogonal()
		var artillery_positions: Array[Vector2] = [
			global_position.lerp(target.global_position, 0.42),
			target.global_position + orthogonal * 96.0,
			target.global_position - orthogonal * 96.0,
			target.global_position,
		]
		if _boss_phase_index >= 1:
			artillery_positions.append(target.global_position + direction * (136.0 + phase_bonus * 12.0))
			artillery_positions.append(target.global_position - direction * 84.0)
		if _boss_phase_index >= 2:
			artillery_positions.append(global_position + orthogonal * 152.0)
			artillery_positions.append(global_position - orthogonal * 152.0)
		for blast_position in artillery_positions:
			special_attack.emit(blast_position, 56.0 + phase_bonus * 4.0, Color(1.0, 0.82, 0.46), Color(0.92, 0.30, 0.16))
		if _player_in_any_radius(artillery_positions, 56.0 + phase_bonus * 4.0):
			target.take_damage(2 + int(_boss_phase_index >= 2))
		_special_timer = maxf(3.5, 5.2 - phase_bonus * 0.34)
	else:
		_dash_velocity = direction * speed * (3.2 + phase_bonus * 0.30)
		_dash_time = 0.58 + phase_bonus * 0.05
		var rush_positions: Array[Vector2] = []
		for index in range(1, 4 + _boss_phase_index):
			rush_positions.append(global_position + direction * (66.0 + float(index) * (54.0 + phase_bonus * 4.0)))
		for blast_position in rush_positions:
			special_attack.emit(blast_position, 52.0 + phase_bonus * 4.0, Color(1.0, 0.70, 0.32), Color(0.74, 0.18, 0.10))
		if _boss_phase_index >= 2:
			special_attack.emit(global_position, 88.0, Color(1.0, 0.82, 0.48), Color(0.86, 0.24, 0.12))
		if _player_in_any_radius(rush_positions, 52.0 + phase_bonus * 4.0) or (_boss_phase_index >= 2 and _player_in_radius(global_position, 88.0)):
			target.take_damage(1 + int(_boss_phase_index >= 1))
		_special_timer = maxf(3.6, 5.5 - phase_bonus * 0.38)
	_special_cycle += 1


func _use_void_matriarch_skill(_direction: Vector2) -> void:
	var phase_bonus := float(_boss_phase_index)
	var cycle := _special_cycle % 3
	if cycle == 0:
		var brood_radius := 118.0 + phase_bonus * 12.0
		special_attack.emit(global_position, brood_radius, Color(0.72, 0.66, 1.0), Color(0.24, 0.16, 0.40))
		if _boss_phase_index >= 2:
			for index in range(4):
				var angle := TAU * float(index) / 4.0 + _phase * 0.10
				special_attack.emit(global_position + Vector2.RIGHT.rotated(angle) * 104.0, 42.0 + phase_bonus * 4.0, Color(0.78, 0.70, 1.0), Color(0.30, 0.18, 0.42))
		summon_requested.emit(global_position, _summon_type, 3 + _boss_phase_index, 196.0 + phase_bonus * 12.0)
		if _player_in_radius(global_position, brood_radius):
			target.take_damage(2 + int(_boss_phase_index >= 2))
		_special_timer = maxf(3.8, 5.4 - phase_bonus * 0.30)
	elif cycle == 1:
		var bloom_positions: Array[Vector2] = []
		var bloom_count := 3 + _boss_phase_index
		var bloom_distance := 112.0 + phase_bonus * 8.0
		for index in range(bloom_count):
			var angle := TAU * float(index) / float(bloom_count) + 0.35
			bloom_positions.append(target.global_position + Vector2.RIGHT.rotated(angle) * bloom_distance)
		for blast_position in bloom_positions:
			special_attack.emit(blast_position, 66.0 + phase_bonus * 4.0, Color(0.80, 0.72, 1.0), Color(0.28, 0.16, 0.40))
		if _boss_phase_index >= 1:
			special_attack.emit(target.global_position, 48.0 + phase_bonus * 4.0, Color(0.84, 0.76, 1.0), Color(0.28, 0.16, 0.40))
		if _player_in_any_radius(bloom_positions, 66.0 + phase_bonus * 4.0) or (_boss_phase_index >= 1 and _player_in_radius(target.global_position, 48.0 + phase_bonus * 4.0)):
			target.take_damage(1 + int(_boss_phase_index >= 2))
		_special_timer = maxf(4.0, 5.7 - phase_bonus * 0.34)
	else:
		var brood_ring: Array[Vector2] = []
		var brood_count := 5 + _boss_phase_index * 2
		var brood_radius := 154.0 + phase_bonus * 14.0
		for index in range(brood_count):
			var angle := TAU * float(index) / float(brood_count) + _phase * 0.12
			brood_ring.append(global_position + Vector2.RIGHT.rotated(angle) * brood_radius)
		for blast_position in brood_ring:
			special_attack.emit(blast_position, 60.0 + phase_bonus * 4.0, Color(0.68, 0.60, 1.0), Color(0.18, 0.12, 0.32))
		summon_requested.emit(global_position, _summon_type, 1 + int(_boss_phase_index >= 1), 170.0 + phase_bonus * 12.0)
		if _player_in_any_radius(brood_ring, 60.0 + phase_bonus * 4.0):
			target.take_damage(1 + int(_boss_phase_index >= 1))
		_special_timer = maxf(4.2, 6.0 - phase_bonus * 0.38)
	_special_cycle += 1


func _player_in_radius(center: Vector2, radius: float) -> bool:
	if target == null or not is_instance_valid(target) or not target.is_alive():
		return false
	return center.distance_to(target.global_position) <= radius + target.get_body_radius()


func _player_in_any_radius(centers: Array[Vector2], radius: float) -> bool:
	for center in centers:
		if _player_in_radius(center, radius):
			return true
	return false


func _build_desired_velocity(to_player: Vector2, direction: Vector2) -> Vector2:
	if _dash_time > 0.0:
		return _dash_velocity

	var boss_phase_speed_bonus := 1.0 + float(_boss_phase_index) * 0.06
	match archetype:
		"lancer":
			if to_player.length() < 110.0:
				return direction.orthogonal() * speed * 0.7
			return direction * speed
		"brute":
			return direction * speed
		"embermage":
			return direction * speed * 0.74 + direction.orthogonal() * cos(_phase * 1.6) * 62.0
		"seer":
			return direction * speed + direction.orthogonal() * sin(_phase) * 34.0
		"mireling":
			var pull_speed := speed * (0.68 if to_player.length() < 120.0 else 1.0)
			return direction * pull_speed + direction.orthogonal() * sin(_phase * 0.75) * 18.0
		"storm_archon":
			return direction * speed * 0.74 * boss_phase_speed_bonus + direction.orthogonal() * _orbit_direction * (94.0 + float(_boss_phase_index) * 10.0)
		"forge_tyrant":
			return direction * speed * (0.86 + float(_boss_phase_index) * 0.04) + direction.orthogonal() * cos(_phase * 0.85) * (18.0 + float(_boss_phase_index) * 4.0)
		"void_matriarch":
			var orbit_velocity := direction.orthogonal() * _orbit_direction * (92.0 + float(_boss_phase_index) * 8.0)
			var pull := direction * (54.0 + float(_boss_phase_index) * 8.0)
			if to_player.length() < 180.0:
				pull *= -0.35
			return orbit_velocity + pull
		_:
			return direction * speed


func _draw() -> void:
	var accent_color := _get_highlight_color()
	draw_circle(Vector2(0.0, 10.0), _body_radius + 8.0, Color(0.02, 0.02, 0.04, 0.24))

	if boss:
		var aura_radius := _body_radius + 16.0 + sin(_phase * 1.4) * 3.0
		draw_arc(Vector2.ZERO, aura_radius, 0.0, TAU, 56, Color(accent_color.r, accent_color.g, accent_color.b, 0.30), 3.2)
		for index in range(3):
			var angle := _phase * 0.6 + TAU * float(index) / 3.0
			var orb_position := Vector2.RIGHT.rotated(angle) * (_body_radius + 10.0)
			draw_circle(orb_position, 4.0, Color(accent_color.r, accent_color.g, accent_color.b, 0.82))
		_draw_boss_phase_pips(accent_color)
	elif elite:
		draw_arc(Vector2.ZERO, _body_radius + 8.0, 0.0, TAU, 42, Color(accent_color.r, accent_color.g, accent_color.b, 0.46), 2.4)

	if boss or elite or health < max_health or shield > 0:
		_draw_health_bar(accent_color)


func _draw_health_bar(fill_color: Color) -> void:
	var health_ratio := float(health) / float(max(max_health, 1))
	var bar_width := _body_radius * 2.0 + (18.0 if boss else 8.0)
	var bar_y := -_body_radius - (22.0 if boss else 14.0)
	draw_rect(Rect2(-bar_width * 0.5, bar_y, bar_width, 5.0 if boss else 4.0), Color(0.10, 0.08, 0.10, 0.62))
	if max_shield > 0:
		var shield_ratio := float(shield) / float(max(max_shield, 1))
		var shield_y := bar_y - 5.0
		draw_rect(Rect2(-bar_width * 0.5, shield_y, bar_width, 3.0), Color(0.08, 0.14, 0.22, 0.72))
		draw_rect(Rect2(-bar_width * 0.5, shield_y, bar_width * shield_ratio, 3.0), Color(0.42, 0.76, 1.0, 0.94))
	draw_rect(Rect2(-bar_width * 0.5, bar_y, bar_width * health_ratio, 5.0 if boss else 4.0), fill_color)


func _draw_boss_phase_pips(fill_color: Color) -> void:
	var pip_count := _boss_phase_thresholds.size()
	if pip_count <= 0:
		return
	var spacing := 14.0
	var start_x := -spacing * float(pip_count - 1) * 0.5
	var y := -_body_radius - 32.0
	for index in range(pip_count):
		var active_pip := index < _boss_phase_index
		var pip_color := fill_color if active_pip else Color(0.14, 0.16, 0.20, 0.88)
		draw_circle(Vector2(start_x + float(index) * spacing, y), 3.4, pip_color)


func _check_boss_phase_transition() -> void:
	if not boss or health <= 0:
		return

	var vitality_ratio := _get_effective_vitality_ratio()
	while _boss_phase_index < _boss_phase_thresholds.size() and vitality_ratio <= float(_boss_phase_thresholds[_boss_phase_index]):
		_boss_phase_index += 1
		_special_timer = minf(_special_timer, 0.45)
		_dash_time = 0.0
		_dash_velocity = Vector2.ZERO
		queue_redraw()
		boss_phase_changed.emit(self, _boss_phase_index)


func _get_effective_vitality_ratio() -> float:
	var total_max := float(max(max_health + max_shield, 1))
	var total_current := float(max(health + shield, 0))
	return total_current / total_max


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
	shape.radius = _body_radius
	_shape_node.shape = shape


func _ensure_sprite() -> void:
	_sprite = get_node_or_null("ModelSprite")
	if _sprite == null:
		_sprite = Sprite2D.new()
		_sprite.name = "ModelSprite"
		_sprite.centered = true
		_sprite.z_index = 2
		_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		add_child(_sprite)


func _refresh_model() -> void:
	_ensure_sprite()
	var model_info := SVG_MODEL_LIBRARY.get_enemy_model(archetype)
	_sprite.texture = SVG_MODEL_LIBRARY.get_enemy_texture(archetype)
	_model_offset = model_info.get("game_offset", Vector2.ZERO)
	_model_scale = Vector2.ONE
	if _sprite.texture != null:
		var texture_size := _sprite.texture.get_size()
		if texture_size.y > 0.0:
			var target_height := float(model_info.get("game_height", 72.0))
			if elite and not boss:
				target_height *= 1.12
			var scale_value := target_height / texture_size.y
			_model_scale = Vector2.ONE * scale_value
	_update_visual_state()


func _update_visual_state() -> void:
	if _sprite == null:
		return

	if absf(_facing_direction.x) > 0.12:
		_sprite.flip_h = _facing_direction.x < 0.0

	var hoverer := archetype in ["wisp", "embermage", "seer", "storm_archon", "void_matriarch"]
	var pulse := absf(sin(_phase * (1.4 if boss else 1.8)))
	var bob := sin(_phase * (1.5 if hoverer else 1.1)) * (4.0 if hoverer else 1.4)
	if not hoverer:
		bob += minf(2.0, velocity.length() * 0.01)

	_sprite.position = _model_offset + Vector2(0.0, bob)
	_sprite.rotation = clampf(velocity.x / maxf(speed * 2.0, 1.0), -1.0, 1.0) * (0.12 if boss else 0.08)
	_sprite.scale = Vector2(_model_scale.x * (1.0 - pulse * 0.03), _model_scale.y * (1.0 + pulse * 0.04))
	if _flash_timer > 0.0:
		_sprite.self_modulate = Color(1.0, 0.92, 0.82)
	elif elite and not boss:
		_sprite.self_modulate = Color(1.0, 0.98, 0.92)
	else:
		_sprite.self_modulate = Color.WHITE


func _get_highlight_color() -> Color:
	if elite and not boss:
		return Color(1.0, 0.92, 0.56)

	match archetype:
		"lancer":
			return Color(0.84, 0.96, 1.0)
		"brute":
			return Color(0.96, 0.60, 0.34)
		"embermage", "forge_tyrant":
			return Color(1.0, 0.78, 0.34)
		"seer", "void_matriarch":
			return Color(0.82, 0.72, 1.0)
		"mireling":
			return Color(0.66, 0.92, 0.58)
		"storm_archon":
			return Color(0.84, 0.96, 1.0)
		_:
			return Color(1.0, 0.70, 0.42)
