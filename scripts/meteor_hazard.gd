extends Node2D
class_name MeteorHazard

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

signal impact(position, radius, current_health_ratio, knockback)

var warning_duration: float = 1.0
var linger_duration: float = 0.42
var damage_radius: float = 92.0
var current_health_ratio: float = 0.20
var knockback: float = 240.0
var primary_color: Color = Color(1.0, 0.80, 0.42)
var secondary_color: Color = Color(0.96, 0.30, 0.16)

var _time: float = 0.0
var _impacted: bool = false
var _warning_ring_sprite: Sprite2D
var _warning_core_sprite: Sprite2D
var _meteor_sprite: Sprite2D
var _impact_burst_sprite: Sprite2D
var _impact_ring_sprite: Sprite2D
var _impact_core_sprite: Sprite2D


func _ready() -> void:
	z_index = -2
	_setup_visuals()
	_update_visuals()


func _process(delta: float) -> void:
	_time += delta
	if not _impacted and _time >= warning_duration:
		_impacted = true
		impact.emit(global_position, damage_radius, current_health_ratio, knockback)

	_update_visuals()
	if _impacted and _time >= warning_duration + linger_duration:
		queue_free()


func _setup_visuals() -> void:
	_warning_ring_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"WarningRing",
		SVG_EFFECT_LIBRARY.get_texture("meteor_warning_ring", primary_color, secondary_color),
		0
	)
	_warning_core_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"WarningCore",
		SVG_EFFECT_LIBRARY.get_texture("meteor_warning_core", primary_color, secondary_color),
		1
	)
	_meteor_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Meteor",
		SVG_EFFECT_LIBRARY.get_texture("meteor_body", primary_color, secondary_color),
		2
	)
	_impact_burst_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"ImpactBurst",
		SVG_EFFECT_LIBRARY.get_texture("impact_burst", primary_color, secondary_color),
		3
	)
	_impact_ring_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"ImpactRing",
		SVG_EFFECT_LIBRARY.get_texture("impact_ring", primary_color, secondary_color),
		4
	)
	_impact_core_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"ImpactCore",
		SVG_EFFECT_LIBRARY.get_texture("impact_core", secondary_color, primary_color),
		5
	)

	add_child(_warning_ring_sprite)
	add_child(_warning_core_sprite)
	add_child(_meteor_sprite)
	add_child(_impact_burst_sprite)
	add_child(_impact_ring_sprite)
	add_child(_impact_core_sprite)


func _update_visuals() -> void:
	if not _impacted:
		_update_warning_visuals()
		return
	_update_impact_visuals()


func _update_warning_visuals() -> void:
	var t := clampf(_time / maxf(warning_duration, 0.001), 0.0, 1.0)
	var pulse := 0.92 + sin(t * PI * 7.0) * 0.08
	var warning_radius := damage_radius * pulse
	var warning_alpha := lerpf(0.22, 0.54, t)
	var meteor_offset := Vector2(0.0, -lerpf(240.0, 42.0, t))

	_warning_ring_sprite.visible = true
	_warning_core_sprite.visible = true
	_meteor_sprite.visible = true
	_impact_burst_sprite.visible = false
	_impact_ring_sprite.visible = false
	_impact_core_sprite.visible = false

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_warning_ring_sprite, warning_radius * 2.18)
	_warning_ring_sprite.rotation = t * 0.8
	_warning_ring_sprite.modulate = Color(1.0, 1.0, 1.0, warning_alpha)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_warning_core_sprite, damage_radius * 1.28)
	_warning_core_sprite.rotation = -t * 1.1
	_warning_core_sprite.modulate = Color(1.0, 1.0, 1.0, warning_alpha * 0.58)

	_meteor_sprite.position = meteor_offset
	_meteor_sprite.rotation = deg_to_rad(18.0) + t * 0.18
	SVG_EFFECT_LIBRARY.set_sprite_size(_meteor_sprite, Vector2(40.0 + t * 16.0, 78.0 + t * 30.0))
	_meteor_sprite.modulate = Color(1.0, 1.0, 1.0, 0.64 + t * 0.24)


func _update_impact_visuals() -> void:
	var t := clampf((_time - warning_duration) / maxf(linger_duration, 0.001), 0.0, 1.0)
	var outer_radius := lerpf(damage_radius * 0.42, damage_radius * 1.16, t)
	var inner_radius := lerpf(damage_radius * 0.12, damage_radius * 0.52, t)
	var alpha := 1.0 - t

	_warning_ring_sprite.visible = false
	_warning_core_sprite.visible = false
	_meteor_sprite.visible = false
	_impact_burst_sprite.visible = true
	_impact_ring_sprite.visible = true
	_impact_core_sprite.visible = true

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_impact_burst_sprite, outer_radius * 2.58)
	_impact_burst_sprite.rotation = t * 1.8
	_impact_burst_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.84)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_impact_ring_sprite, outer_radius * 2.12)
	_impact_ring_sprite.rotation = -t * 1.06
	_impact_ring_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.68)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_impact_core_sprite, inner_radius * 2.20)
	_impact_core_sprite.rotation = t * 2.4
	_impact_core_sprite.modulate = Color(1.0, 1.0, 1.0, alpha * 0.96)
