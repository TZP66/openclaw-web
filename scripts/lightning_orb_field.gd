extends Node2D
class_name LightningOrbField

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

signal pulse_requested(origin)

var duration: float = 5.0
var radius: float = 126.0
var pulse_interval: float = 0.68
var startup_delay: float = 0.16
var primary_color: Color = Color(0.46, 0.84, 1.0)
var secondary_color: Color = Color(0.86, 0.96, 1.0)

var _time: float = 0.0
var _pulse_timer: float = 0.0
var _pulse_flash: float = 0.0
var _body_sprite: Sprite2D
var _ring_sprite: Sprite2D
var _core_sprite: Sprite2D


func _ready() -> void:
	_body_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Body",
		SVG_EFFECT_LIBRARY.get_texture("projectile_orb", primary_color, secondary_color),
		0
	)
	_ring_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Ring",
		SVG_EFFECT_LIBRARY.get_texture("projectile_orb_ring", secondary_color, primary_color),
		1
	)
	_core_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Core",
		SVG_EFFECT_LIBRARY.get_texture("impact_ring", primary_color, secondary_color),
		2
	)
	add_child(_body_sprite)
	add_child(_ring_sprite)
	add_child(_core_sprite)
	_pulse_timer = maxf(startup_delay, 0.02)
	_update_visuals()


func _process(delta: float) -> void:
	_time += delta
	_pulse_timer -= delta
	_pulse_flash = maxf(0.0, _pulse_flash - delta * 2.8)
	if _pulse_timer <= 0.0:
		_pulse_timer += maxf(pulse_interval, 0.08)
		_pulse_flash = 1.0
		pulse_requested.emit(global_position)
	_update_visuals()
	if _time >= duration:
		queue_free()


func _update_visuals() -> void:
	var life_ratio := clampf(_time / maxf(duration, 0.001), 0.0, 1.0)
	var pulse_scale := 1.0 + _pulse_flash * 0.18
	var orbit_spin := _time * 1.8
	var alpha := 1.0 - life_ratio * 0.22

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_body_sprite, radius * 0.56 * pulse_scale)
	_body_sprite.rotation = orbit_spin
	_body_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.94)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_ring_sprite, radius * (1.12 + _pulse_flash * 0.42))
	_ring_sprite.rotation = -orbit_spin * 1.34
	_ring_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * (0.72 + _pulse_flash * 0.18))

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_core_sprite, radius * (0.84 + _pulse_flash * 0.34))
	_core_sprite.rotation = orbit_spin * 0.86
	_core_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.34)
