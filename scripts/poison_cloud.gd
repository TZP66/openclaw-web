extends Node2D
class_name PoisonCloudHazard

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

signal pulse(position, radius, max_health_ratio_per_second, elapsed_time, knockback)

var lifetime: float = 5.8
var velocity: Vector2 = Vector2.RIGHT * 110.0
var damage_radius: float = 112.0
var max_health_ratio_per_second: float = 0.01
var knockback: float = 96.0
var pulse_interval: float = 0.7
var primary_color: Color = Color(0.58, 0.90, 0.44)
var secondary_color: Color = Color(0.22, 0.46, 0.18)

var _time: float = 0.0
var _pulse_timer: float = 0.0
var _next_pulse_delay: float = 0.0
var _ring_sprite: Sprite2D
var _core_sprite: Sprite2D
var _puff_sprites: Array[Sprite2D] = []


func _ready() -> void:
	z_index = -1
	_next_pulse_delay = pulse_interval * 0.35
	_pulse_timer = _next_pulse_delay
	_setup_visuals()
	_update_visuals()


func _process(delta: float) -> void:
	_time += delta
	position += velocity * delta
	_pulse_timer -= delta
	if _pulse_timer <= 0.0:
		pulse.emit(global_position, damage_radius, max_health_ratio_per_second, _next_pulse_delay, knockback)
		_next_pulse_delay = pulse_interval
		_pulse_timer += _next_pulse_delay

	_update_visuals()
	if _time >= lifetime:
		queue_free()


func _setup_visuals() -> void:
	_ring_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Ring",
		SVG_EFFECT_LIBRARY.get_texture("poison_ring", primary_color, secondary_color),
		0
	)
	_core_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Core",
		SVG_EFFECT_LIBRARY.get_texture("poison_core", primary_color, secondary_color),
		1
	)
	add_child(_ring_sprite)
	add_child(_core_sprite)

	for index in range(4):
		var puff_sprite := SVG_EFFECT_LIBRARY.create_sprite(
			"Puff%d" % index,
			SVG_EFFECT_LIBRARY.get_texture("poison_puff", primary_color, secondary_color),
			2 + index
		)
		_puff_sprites.append(puff_sprite)
		add_child(puff_sprite)


func _update_visuals() -> void:
	var fade_in := clampf(_time / 0.7, 0.0, 1.0)
	var fade_out := clampf((lifetime - _time) / 1.0, 0.0, 1.0)
	var alpha := minf(fade_in, fade_out)
	var drift := _time * 0.9
	var offsets := [
		Vector2.ZERO,
		Vector2(cos(drift * 1.1) * 26.0, sin(drift * 0.9) * 14.0),
		Vector2(cos(drift * 0.7 + 1.4) * 34.0, sin(drift * 1.3 + 0.4) * 22.0),
		Vector2(cos(drift * 1.5 + 2.6) * 22.0, sin(drift * 1.1 + 2.2) * 28.0),
	]
	var radii := [damage_radius * 0.58, damage_radius * 0.44, damage_radius * 0.50, damage_radius * 0.36]

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_ring_sprite, damage_radius * 1.96)
	_ring_sprite.rotation = -_time * 0.22
	_ring_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.72)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_core_sprite, damage_radius * 1.24)
	_core_sprite.rotation = _time * 0.36
	_core_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.42)

	for index in range(_puff_sprites.size()):
		var puff_sprite := _puff_sprites[index]
		puff_sprite.position = offsets[index]
		puff_sprite.rotation = drift * (0.18 + float(index) * 0.09)
		SVG_EFFECT_LIBRARY.set_sprite_diameter(puff_sprite, radii[index] * 2.24)
		puff_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * (0.48 + float(index) * 0.10))
