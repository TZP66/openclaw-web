extends Node2D
class_name ExplosionEffect

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

var duration: float = 0.45
var radius: float = 56.0
var primary_color: Color = Color(1.0, 0.77, 0.28)
var secondary_color: Color = Color(1.0, 0.38, 0.20)

var _time: float = 0.0
var _burst_sprite: Sprite2D
var _ring_sprite: Sprite2D
var _core_sprite: Sprite2D


func _ready() -> void:
	_burst_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Burst",
		SVG_EFFECT_LIBRARY.get_texture("impact_burst", primary_color, secondary_color),
		0
	)
	_ring_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Ring",
		SVG_EFFECT_LIBRARY.get_texture("impact_ring", primary_color, secondary_color),
		1
	)
	_core_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Core",
		SVG_EFFECT_LIBRARY.get_texture("impact_core", secondary_color, primary_color),
		2
	)
	add_child(_burst_sprite)
	add_child(_ring_sprite)
	add_child(_core_sprite)
	_update_visuals()


func _process(delta: float) -> void:
	_time += delta
	_update_visuals()
	if _time >= duration:
		queue_free()


func _update_visuals() -> void:
	var t := clampf(_time / maxf(duration, 0.001), 0.0, 1.0)
	var outer_radius := lerpf(radius * 0.25, radius, t)
	var inner_radius := lerpf(radius * 0.16, radius * 0.54, t)
	var alpha := 1.0 - t

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_burst_sprite, outer_radius * 2.58)
	_burst_sprite.rotation = t * 1.7
	_burst_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.82)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_ring_sprite, outer_radius * 2.08)
	_ring_sprite.rotation = -t * 1.04
	_ring_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.64)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_core_sprite, inner_radius * 2.18)
	_core_sprite.rotation = t * 2.6
	_core_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.96)
