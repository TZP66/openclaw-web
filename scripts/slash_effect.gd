extends Node2D
class_name SlashEffect

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

var duration: float = 0.18
var radius: float = 96.0
var arc_span: float = PI
var facing_direction: Vector2 = Vector2.RIGHT
var primary_color: Color = Color(1.0, 0.92, 0.78)
var secondary_color: Color = Color(0.98, 0.42, 0.30)

var _time: float = 0.0
var _body_sprite: Sprite2D
var _edge_sprite: Sprite2D
var _flare_sprite: Sprite2D


func _ready() -> void:
	_body_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Body",
		SVG_EFFECT_LIBRARY.get_texture("slash_arc", primary_color, secondary_color),
		0
	)
	_edge_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Edge",
		SVG_EFFECT_LIBRARY.get_texture("slash_edge", secondary_color, primary_color),
		1
	)
	_flare_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Flare",
		SVG_EFFECT_LIBRARY.get_texture("slash_flare", secondary_color, primary_color),
		2
	)
	add_child(_body_sprite)
	add_child(_edge_sprite)
	add_child(_flare_sprite)
	_update_visuals()


func _process(delta: float) -> void:
	_time += delta
	_update_visuals()
	if _time >= duration:
		queue_free()


func _update_visuals() -> void:
	var t := clampf(_time / maxf(duration, 0.001), 0.0, 1.0)
	var draw_direction := facing_direction.normalized()
	if draw_direction == Vector2.ZERO:
		draw_direction = Vector2.RIGHT

	var base_angle := draw_direction.angle()
	var outer_radius := lerpf(radius * 0.52, radius, t)
	var visible_span := lerpf(arc_span * 0.60, arc_span, t)
	var fade := 1.0 - t
	var span_scale := clampf(visible_span / PI, 0.68, 1.28)
	var swing_rotation := base_angle + lerpf(-visible_span * 0.14, visible_span * 0.10, t)
	var forward_offset := draw_direction * lerpf(radius * 0.08, radius * 0.16, t)

	_body_sprite.position = forward_offset
	_body_sprite.rotation = swing_rotation
	SVG_EFFECT_LIBRARY.set_sprite_size(
		_body_sprite,
		Vector2(outer_radius * 2.34, outer_radius * 1.70 * span_scale)
	)
	_body_sprite.modulate = Color(1.0, 1.0, 1.0, fade * 0.72)

	_edge_sprite.position = forward_offset
	_edge_sprite.rotation = swing_rotation
	SVG_EFFECT_LIBRARY.set_sprite_size(
		_edge_sprite,
		Vector2(outer_radius * 2.24, outer_radius * 1.42 * span_scale)
	)
	_edge_sprite.modulate = Color(1.0, 1.0, 1.0, fade * 0.96)

	_flare_sprite.position = draw_direction * (outer_radius * 0.56)
	_flare_sprite.rotation = base_angle
	SVG_EFFECT_LIBRARY.set_sprite_diameter(_flare_sprite, outer_radius * 0.90)
	_flare_sprite.modulate = Color(1.0, 1.0, 1.0, fade * 0.84)
