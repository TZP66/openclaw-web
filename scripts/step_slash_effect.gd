extends Node2D
class_name StepSlashEffect

const SVG_EFFECT_LIBRARY := preload("res://scripts/svg_effect_library.gd")

var duration: float = 0.26
var radius: float = 84.0
var facing_direction: Vector2 = Vector2.RIGHT
var primary_color: Color = Color(1.0, 0.92, 0.80)
var secondary_color: Color = Color(0.98, 0.42, 0.30)

var _time: float = 0.0
var _ring_sprite: Sprite2D
var _glyph_sprite: Sprite2D
var _core_sprite: Sprite2D
var _blade_sprites: Array[Sprite2D] = []


func _ready() -> void:
	_ring_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Ring",
		SVG_EFFECT_LIBRARY.get_texture("step_ring", primary_color, secondary_color),
		0
	)
	_glyph_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Glyph",
		SVG_EFFECT_LIBRARY.get_texture("step_glyph", primary_color, secondary_color),
		1
	)
	_core_sprite = SVG_EFFECT_LIBRARY.create_sprite(
		"Core",
		SVG_EFFECT_LIBRARY.get_texture("impact_core", secondary_color, primary_color),
		2
	)
	add_child(_ring_sprite)
	add_child(_glyph_sprite)
	add_child(_core_sprite)

	for index in range(3):
		var blade_sprite := SVG_EFFECT_LIBRARY.create_sprite(
			"Blade%d" % index,
			SVG_EFFECT_LIBRARY.get_texture("satellite_blade", primary_color, secondary_color),
			3 + index
		)
		_blade_sprites.append(blade_sprite)
		add_child(blade_sprite)

	_update_visuals()


func _process(delta: float) -> void:
	_time += delta
	_update_visuals()
	if _time >= duration:
		queue_free()


func _update_visuals() -> void:
	var t := clampf(_time / maxf(duration, 0.001), 0.0, 1.0)
	var base_direction := facing_direction.normalized()
	if base_direction == Vector2.ZERO:
		base_direction = Vector2.RIGHT

	var fade := 1.0 - t
	var spin_angle := base_direction.angle() + TAU * t
	var ring_radius := lerpf(radius * 0.58, radius, minf(1.0, t * 1.15))
	var inner_radius := maxf(12.0, ring_radius - maxf(12.0, radius * 0.18))
	var trail_span := lerpf(PI * 1.45, PI * 0.58, t)
	var blade_distance := ring_radius * 0.96

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_ring_sprite, ring_radius * 2.34)
	_ring_sprite.rotation = spin_angle + t * 1.3
	_ring_sprite.modulate = Color(1.0, 1.0, 1.0, fade * 0.78)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_glyph_sprite, inner_radius * 2.54)
	_glyph_sprite.rotation = -spin_angle * 0.56
	_glyph_sprite.modulate = Color(1.0, 1.0, 1.0, fade * 0.70)

	SVG_EFFECT_LIBRARY.set_sprite_diameter(_core_sprite, lerpf(radius * 0.22, radius * 0.46, t))
	_core_sprite.rotation = t * 3.4
	_core_sprite.modulate = Color(1.0, 1.0, 1.0, fade * 0.40)

	_update_blade_sprite(_blade_sprites[0], spin_angle - trail_span * 0.55, blade_distance, fade * 0.26, 0.86)
	_update_blade_sprite(_blade_sprites[1], spin_angle - trail_span * 0.28, blade_distance, fade * 0.48, 0.94)
	_update_blade_sprite(_blade_sprites[2], spin_angle, blade_distance, fade, 1.0)


func _update_blade_sprite(sprite: Sprite2D, angle: float, distance: float, alpha: float, scale_factor: float) -> void:
	sprite.position = Vector2.RIGHT.rotated(angle) * distance
	sprite.rotation = angle + PI
	SVG_EFFECT_LIBRARY.set_sprite_size(
		sprite,
		Vector2(
			clampf(radius * 0.28 * scale_factor, 18.0, 28.0),
			clampf(radius * 0.58 * scale_factor, 28.0, 52.0)
		)
	)
	sprite.modulate = Color(1.0, 1.0, 1.0, alpha)
