extends Node2D
class_name MapRuleZone

const UI_FONT := preload("res://assets/fonts/NotoSansSC-VF.ttf")

var radius: float = 88.0
var primary_color: Color = Color(0.94, 0.72, 0.34, 0.92)
var secondary_color: Color = Color(0.98, 0.94, 0.76, 0.58)
var label: String = ""
var sublabel: String = ""
var icon_style: String = "altar"
var progress: float = -1.0
var active: bool = false
var pulse_speed: float = 1.2
var fill_alpha: float = 0.16

var _time: float = 0.0


func _ready() -> void:
	z_index = -1


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	var pulse := 0.92 + sin(_time * pulse_speed) * 0.06
	var ring_radius := radius * pulse
	var fill := Color(primary_color.r, primary_color.g, primary_color.b, fill_alpha if not active else fill_alpha + 0.10)
	var ring := primary_color if not active else secondary_color

	draw_circle(Vector2.ZERO, radius * 0.94, fill)
	draw_arc(Vector2.ZERO, ring_radius, 0.0, TAU, 72, Color(ring.r, ring.g, ring.b, 0.86), maxf(2.0, radius * 0.04))
	draw_arc(Vector2.ZERO, radius * 0.62, 0.0, TAU, 56, Color(secondary_color.r, secondary_color.g, secondary_color.b, 0.42), maxf(1.6, radius * 0.026))

	if progress >= 0.0:
		draw_arc(
			Vector2.ZERO,
			radius * 1.06,
			-PI * 0.5,
			-PI * 0.5 + TAU * clampf(progress, 0.0, 1.0),
			64,
			Color(secondary_color.r, secondary_color.g, secondary_color.b, 0.96),
			maxf(3.0, radius * 0.06)
		)

	match icon_style:
		"pool":
			_draw_pool_icon()
		"mud":
			_draw_mud_icon()
		_:
			_draw_altar_icon()

	_draw_label_block()


func _draw_altar_icon() -> void:
	var inner := radius * 0.34
	var core := PackedVector2Array([
		Vector2(0.0, -inner),
		Vector2(inner * 0.80, 0.0),
		Vector2(0.0, inner),
		Vector2(-inner * 0.80, 0.0),
	])
	draw_colored_polygon(core, Color(secondary_color.r, secondary_color.g, secondary_color.b, 0.88))
	draw_arc(Vector2.ZERO, inner * 0.94, 0.0, TAU, 28, Color(primary_color.r, primary_color.g, primary_color.b, 0.78), maxf(2.0, radius * 0.04))

	for index in range(4):
		var angle := TAU * float(index) / 4.0 + _time * 0.18
		var point := Vector2.RIGHT.rotated(angle) * radius * 0.48
		draw_circle(point, radius * 0.08, Color(primary_color.r, primary_color.g, primary_color.b, 0.66))


func _draw_pool_icon() -> void:
	draw_circle(Vector2.ZERO, radius * 0.24, Color(secondary_color.r, secondary_color.g, secondary_color.b, 0.34))
	draw_circle(Vector2(-radius * 0.20, radius * 0.04), radius * 0.18, Color(primary_color.r, primary_color.g, primary_color.b, 0.32))
	draw_circle(Vector2(radius * 0.18, -radius * 0.06), radius * 0.20, Color(primary_color.r, primary_color.g, primary_color.b, 0.28))
	draw_arc(Vector2.ZERO, radius * 0.40, 0.0, TAU, 36, Color(secondary_color.r, secondary_color.g, secondary_color.b, 0.70), maxf(2.0, radius * 0.04))


func _draw_mud_icon() -> void:
	for index in range(3):
		var angle := -0.7 + float(index) * 0.7
		var center := Vector2.RIGHT.rotated(angle) * radius * 0.18
		draw_circle(center, radius * (0.16 + float(index) * 0.03), Color(primary_color.r, primary_color.g, primary_color.b, 0.30))
	draw_arc(Vector2.ZERO, radius * 0.36, 0.2, PI - 0.2, 24, Color(secondary_color.r, secondary_color.g, secondary_color.b, 0.72), maxf(2.0, radius * 0.04))


func _draw_label_block() -> void:
	if not label.is_empty():
		draw_string(
			UI_FONT,
			Vector2(-radius * 0.66, radius * 1.34),
			label,
			HORIZONTAL_ALIGNMENT_LEFT,
			radius * 1.32,
			maxi(12, int(round(radius * 0.18))),
			Color(0.96, 0.98, 1.0, 0.96)
		)
	if not sublabel.is_empty():
		draw_string(
			UI_FONT,
			Vector2(-radius * 0.70, radius * 1.58),
			sublabel,
			HORIZONTAL_ALIGNMENT_LEFT,
			radius * 1.40,
			maxi(10, int(round(radius * 0.13))),
			Color(0.84, 0.90, 0.96, 0.88)
		)
