extends Control
class_name SkillSlotDisplay

const UI_FONT := preload("res://assets/fonts/NotoSansSC-VF.ttf")

var _skill_data: Dictionary = {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	focus_mode = Control.FOCUS_NONE
	resized.connect(queue_redraw)


func set_skill_data(skill_data: Dictionary) -> void:
	_skill_data = skill_data.duplicate(true)
	tooltip_text = String(_skill_data.get("tooltip", ""))
	visible = not _skill_data.is_empty()
	queue_redraw()


func _draw() -> void:
	if _skill_data.is_empty():
		return

	var slot_rect := Rect2(Vector2.ONE, size - Vector2.ONE * 2.0)
	if slot_rect.size.x <= 0.0 or slot_rect.size.y <= 0.0:
		return

	var unlocked := bool(_skill_data.get("unlocked", false))
	var passive := bool(_skill_data.get("passive", false))
	var accent: Color = _skill_data.get("accent", Color(0.50, 0.82, 1.0))
	var cooldown_remaining := maxf(0.0, float(_skill_data.get("cooldown_remaining", 0.0)))
	var cooldown_max := maxf(0.0, float(_skill_data.get("cooldown_max", 0.0)))
	var cooldown_ratio := cooldown_remaining / cooldown_max if cooldown_max > 0.001 else 0.0
	var ready := unlocked and (passive or cooldown_remaining <= 0.02)

	var background := Color(0.04, 0.06, 0.09, 0.92)
	var border := Color(0.18, 0.28, 0.34, 0.98)
	if unlocked:
		background = Color(accent.r * 0.18 + 0.05, accent.g * 0.16 + 0.05, accent.b * 0.16 + 0.07, 0.98)
		border = Color(accent.r, accent.g, accent.b, 0.94 if ready else 0.72)
	if not unlocked:
		background = Color(0.08, 0.09, 0.11, 0.96)
		border = Color(0.24, 0.24, 0.26, 0.82)

	draw_rect(slot_rect, background, true)
	draw_rect(slot_rect, border, false, maxf(2.0, size.x * 0.03))

	var accent_bar_height := maxf(4.0, size.y * 0.06)
	draw_rect(
		Rect2(slot_rect.position + Vector2(0.0, slot_rect.size.y - accent_bar_height), Vector2(slot_rect.size.x, accent_bar_height)),
		Color(border.r, border.g, border.b, 0.92),
		true
	)

	var icon_rect := Rect2(
		Vector2(size.x * 0.16, size.y * 0.22),
		Vector2(size.x * 0.68, size.y * 0.42)
	)
	if icon_rect.size.x > 8.0 and icon_rect.size.y > 8.0:
		var icon_color := accent if unlocked else Color(0.42, 0.44, 0.48)
		_draw_icon(String(_skill_data.get("icon_id", "")), icon_rect, icon_color)

	if not unlocked:
		draw_rect(slot_rect, Color(0.02, 0.02, 0.03, 0.68), true)
		_draw_center_text("未解锁", size.y * 0.14, Color(0.86, 0.88, 0.90))
	else:
		if cooldown_ratio > 0.01 and not passive:
			var cover_height := slot_rect.size.y * clampf(cooldown_ratio, 0.0, 1.0)
			draw_rect(Rect2(slot_rect.position, Vector2(slot_rect.size.x, cover_height)), Color(0.01, 0.02, 0.03, 0.62), true)
			_draw_center_text("%.1f" % cooldown_remaining, size.y * 0.18, Color(1.0, 0.98, 0.96))
		elif ready and not passive:
			draw_rect(slot_rect.grow(1.0), Color(border.r, border.g, border.b, 0.22), false, maxf(2.0, size.x * 0.04))

	var level := int(_skill_data.get("level", 0))
	var badge_rect := Rect2(6.0, 6.0, minf(size.x * 0.34, 42.0), minf(size.y * 0.18, 22.0))
	draw_rect(badge_rect, Color(0.00, 0.00, 0.00, 0.34), true)
	if unlocked:
		_draw_text_in_rect("Lv.%d" % level, badge_rect, size.y * 0.11, Color(0.98, 0.99, 1.0), HORIZONTAL_ALIGNMENT_CENTER)
	else:
		_draw_text_in_rect("--", badge_rect, size.y * 0.11, Color(0.78, 0.80, 0.84), HORIZONTAL_ALIGNMENT_CENTER)

	var meta_text := String(_skill_data.get("meta", ""))
	if not meta_text.is_empty():
		var meta_width := minf(size.x * 0.34, 44.0)
		var meta_rect := Rect2(size.x - meta_width - 6.0, 6.0, meta_width, minf(size.y * 0.18, 22.0))
		draw_rect(meta_rect, Color(0.00, 0.00, 0.00, 0.28), true)
		_draw_text_in_rect(meta_text, meta_rect, size.y * 0.11, Color(0.94, 0.96, 1.0), HORIZONTAL_ALIGNMENT_CENTER)

	var name_rect := Rect2(6.0, size.y * 0.72, size.x - 12.0, size.y * 0.18)
	_draw_text_in_rect(String(_skill_data.get("name", "")), name_rect, size.y * 0.12, Color(0.95, 0.97, 1.0), HORIZONTAL_ALIGNMENT_CENTER)


func _draw_center_text(text: String, font_size: float, color: Color) -> void:
	var text_rect := Rect2(8.0, size.y * 0.36, size.x - 16.0, size.y * 0.24)
	_draw_text_in_rect(text, text_rect, font_size, color, HORIZONTAL_ALIGNMENT_CENTER)


func _draw_text_in_rect(text: String, rect: Rect2, font_size: float, color: Color, alignment: HorizontalAlignment) -> void:
	if text.is_empty():
		return
	var baseline_y := rect.position.y + rect.size.y * 0.72
	draw_string(
		UI_FONT,
		Vector2(rect.position.x, baseline_y),
		text,
		alignment,
		rect.size.x,
		int(round(font_size)),
		color
	)


func _draw_icon(icon_id: String, rect: Rect2, color: Color) -> void:
	match icon_id:
		"orbit":
			_draw_orbit_icon(rect, color)
		"nova":
			_draw_nova_icon(rect, color)
		"storm":
			_draw_storm_icon(rect, color)
		"chain":
			_draw_chain_icon(rect, color)
		"detonate":
			_draw_detonate_icon(rect, color)
		"storm_orb":
			_draw_storm_orb_icon(rect, color)
		"ascension":
			_draw_ascension_icon(rect, color)
		"slash":
			_draw_slash_icon(rect, color)
		"blade_ring":
			_draw_blade_ring_icon(rect, color)
		"mooncut":
			_draw_mooncut_icon(rect, color)
		"step_slash":
			_draw_step_slash_icon(rect, color)
		"flask":
			_draw_flask_icon(rect, color)
		"miasma":
			_draw_miasma_icon(rect, color)
		"shardburst":
			_draw_shardburst_icon(rect, color)
		"catalyst":
			_draw_catalyst_icon(rect, color)
		"needle":
			_draw_needle_icon(rect, color)
		"volley":
			_draw_volley_icon(rect, color)
		"glaive":
			_draw_glaive_icon(rect, color)
		"trail":
			_draw_trail_icon(rect, color)
		"pulse":
			_draw_pulse_icon(rect, color)
		"ward":
			_draw_ward_icon(rect, color)
		"beacon":
			_draw_beacon_icon(rect, color)
		"relay":
			_draw_relay_icon(rect, color)
		_:
			_draw_bolt_icon(rect, color)


func _draw_bolt_icon(rect: Rect2, color: Color) -> void:
	var points := PackedVector2Array([
		rect.position + Vector2(rect.size.x * 0.56, rect.size.y * 0.04),
		rect.position + Vector2(rect.size.x * 0.34, rect.size.y * 0.48),
		rect.position + Vector2(rect.size.x * 0.54, rect.size.y * 0.48),
		rect.position + Vector2(rect.size.x * 0.42, rect.size.y * 0.98),
		rect.position + Vector2(rect.size.x * 0.78, rect.size.y * 0.42),
		rect.position + Vector2(rect.size.x * 0.58, rect.size.y * 0.42),
	])
	draw_colored_polygon(points, color)


func _draw_orbit_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	var orbit_radius := minf(rect.size.x, rect.size.y) * 0.34
	draw_arc(center, orbit_radius, 0.0, TAU, 32, Color(color.r, color.g, color.b, 0.88), maxf(2.0, rect.size.x * 0.06))
	draw_circle(center, orbit_radius * 0.32, color)
	for index in range(3):
		var angle := TAU * float(index) / 3.0 - PI * 0.5
		draw_circle(center + Vector2.RIGHT.rotated(angle) * orbit_radius, orbit_radius * 0.18, Color(0.98, 0.99, 1.0))


func _draw_nova_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	var outer := minf(rect.size.x, rect.size.y) * 0.48
	var inner := outer * 0.44
	var points := PackedVector2Array()
	for index in range(12):
		var angle := TAU * float(index) / 12.0 - PI * 0.5
		var radius := outer if index % 2 == 0 else inner
		points.append(center + Vector2.RIGHT.rotated(angle) * radius)
	draw_colored_polygon(points, color)
	draw_circle(center, outer * 0.18, Color(0.98, 0.99, 1.0))


func _draw_storm_icon(rect: Rect2, color: Color) -> void:
	var cloud_color := Color(color.r * 0.72 + 0.18, color.g * 0.72 + 0.18, color.b * 0.72 + 0.18, 1.0)
	var center := rect.get_center()
	draw_circle(center + Vector2(-rect.size.x * 0.18, -rect.size.y * 0.08), rect.size.x * 0.18, cloud_color)
	draw_circle(center + Vector2(0.0, -rect.size.y * 0.14), rect.size.x * 0.22, cloud_color)
	draw_circle(center + Vector2(rect.size.x * 0.20, -rect.size.y * 0.04), rect.size.x * 0.16, cloud_color)
	draw_rect(Rect2(center + Vector2(-rect.size.x * 0.30, -rect.size.y * 0.02), Vector2(rect.size.x * 0.60, rect.size.y * 0.20)), cloud_color, true)
	_draw_bolt_icon(Rect2(rect.position + Vector2(rect.size.x * 0.30, rect.size.y * 0.24), rect.size * 0.40), color)


func _draw_chain_icon(rect: Rect2, color: Color) -> void:
	var left := rect.position + Vector2(rect.size.x * 0.18, rect.size.y * 0.66)
	var mid := rect.position + Vector2(rect.size.x * 0.48, rect.size.y * 0.26)
	var right := rect.position + Vector2(rect.size.x * 0.80, rect.size.y * 0.58)
	draw_circle(left, rect.size.x * 0.10, Color(color.r, color.g, color.b, 0.82))
	draw_circle(mid, rect.size.x * 0.10, Color(0.98, 0.99, 1.0))
	draw_circle(right, rect.size.x * 0.10, Color(color.r, color.g, color.b, 0.82))
	draw_line(left, mid, color, maxf(3.0, rect.size.x * 0.08))
	draw_line(mid, right, Color(0.98, 0.99, 1.0), maxf(3.0, rect.size.x * 0.08))
	_draw_bolt_icon(Rect2(rect.position + Vector2(rect.size.x * 0.34, rect.size.y * 0.24), rect.size * 0.28), color)


func _draw_detonate_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	var outer := minf(rect.size.x, rect.size.y) * 0.34
	draw_circle(center, outer, Color(color.r, color.g, color.b, 0.22))
	var burst := PackedVector2Array()
	for index in range(10):
		var angle := TAU * float(index) / 10.0 - PI * 0.5
		var radius := outer * (1.55 if index % 2 == 0 else 0.92)
		burst.append(center + Vector2.RIGHT.rotated(angle) * radius)
	draw_colored_polygon(burst, Color(color.r, color.g, color.b, 0.78))
	_draw_bolt_icon(Rect2(center - rect.size * 0.16, rect.size * 0.32), Color(0.98, 0.99, 1.0))


func _draw_storm_orb_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	var radius := minf(rect.size.x, rect.size.y) * 0.22
	draw_circle(center, radius * 1.36, Color(color.r, color.g, color.b, 0.16))
	draw_circle(center, radius, color)
	draw_arc(center, radius * 1.86, 0.0, TAU, 28, Color(0.94, 0.98, 1.0, 0.82), maxf(2.0, rect.size.x * 0.05))
	draw_arc(center, radius * 1.36, -1.5, 1.2, 18, Color(color.r, color.g, color.b, 0.92), maxf(2.0, rect.size.x * 0.05))
	_draw_bolt_icon(Rect2(rect.position + Vector2(rect.size.x * 0.56, rect.size.y * 0.26), rect.size * 0.26), Color(0.98, 0.99, 1.0))


func _draw_ascension_icon(rect: Rect2, color: Color) -> void:
	var crown := PackedVector2Array([
		rect.position + Vector2(rect.size.x * 0.18, rect.size.y * 0.80),
		rect.position + Vector2(rect.size.x * 0.28, rect.size.y * 0.38),
		rect.position + Vector2(rect.size.x * 0.46, rect.size.y * 0.58),
		rect.position + Vector2(rect.size.x * 0.60, rect.size.y * 0.20),
		rect.position + Vector2(rect.size.x * 0.74, rect.size.y * 0.58),
		rect.position + Vector2(rect.size.x * 0.90, rect.size.y * 0.34),
		rect.position + Vector2(rect.size.x * 0.82, rect.size.y * 0.80),
	])
	draw_colored_polygon(crown, Color(color.r, color.g, color.b, 0.30))
	draw_line(rect.position + Vector2(rect.size.x * 0.22, rect.size.y * 0.82), rect.position + Vector2(rect.size.x * 0.80, rect.size.y * 0.82), color, maxf(3.0, rect.size.x * 0.08))
	_draw_bolt_icon(Rect2(rect.position + Vector2(rect.size.x * 0.36, rect.size.y * 0.16), rect.size * 0.32), Color(0.98, 0.99, 1.0))


func _draw_slash_icon(rect: Rect2, color: Color) -> void:
	var start := rect.position + Vector2(rect.size.x * 0.12, rect.size.y * 0.78)
	var mid := rect.position + Vector2(rect.size.x * 0.52, rect.size.y * 0.40)
	var tip := rect.position + Vector2(rect.size.x * 0.86, rect.size.y * 0.12)
	draw_line(start, mid, color, maxf(3.0, rect.size.x * 0.10))
	draw_line(mid, tip, Color(0.98, 0.99, 1.0), maxf(3.0, rect.size.x * 0.10))
	draw_arc(rect.get_center(), minf(rect.size.x, rect.size.y) * 0.42, PI * 0.10, PI * 0.90, 24, Color(color.r, color.g, color.b, 0.80), maxf(2.0, rect.size.x * 0.05))


func _draw_blade_ring_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	var ring_radius := minf(rect.size.x, rect.size.y) * 0.34
	draw_arc(center, ring_radius, 0.0, TAU, 42, color, maxf(3.0, rect.size.x * 0.08))
	for index in range(4):
		var angle := TAU * float(index) / 4.0 + PI * 0.25
		var base := center + Vector2.RIGHT.rotated(angle) * ring_radius
		var tangent := Vector2.RIGHT.rotated(angle).orthogonal().normalized()
		var tip := center + Vector2.RIGHT.rotated(angle) * (ring_radius + rect.size.x * 0.18)
		var points := PackedVector2Array([
			base - tangent * rect.size.x * 0.06,
			base + tangent * rect.size.x * 0.06,
			tip,
		])
		draw_colored_polygon(points, Color(0.98, 0.99, 1.0))


func _draw_mooncut_icon(rect: Rect2, color: Color) -> void:
	var outer_center := rect.get_center() + Vector2(-rect.size.x * 0.06, 0.0)
	var radius := minf(rect.size.x, rect.size.y) * 0.34
	draw_circle(outer_center, radius, color)
	draw_circle(outer_center + Vector2(rect.size.x * 0.16, -rect.size.y * 0.02), radius * 0.82, Color(0.08, 0.10, 0.14))
	draw_arc(outer_center + Vector2(rect.size.x * 0.10, 0.0), radius * 0.94, -0.9, 0.9, 18, Color(0.98, 0.99, 1.0, 0.72), maxf(2.0, rect.size.x * 0.04))


func _draw_step_slash_icon(rect: Rect2, color: Color) -> void:
	var line_width := maxf(3.0, rect.size.x * 0.09)
	draw_line(rect.position + Vector2(rect.size.x * 0.12, rect.size.y * 0.82), rect.position + Vector2(rect.size.x * 0.42, rect.size.y * 0.22), color, line_width)
	draw_line(rect.position + Vector2(rect.size.x * 0.48, rect.size.y * 0.78), rect.position + Vector2(rect.size.x * 0.78, rect.size.y * 0.18), Color(0.98, 0.99, 1.0), line_width)
	var arrow := PackedVector2Array([
		rect.position + Vector2(rect.size.x * 0.70, rect.size.y * 0.46),
		rect.position + Vector2(rect.size.x * 0.92, rect.size.y * 0.46),
		rect.position + Vector2(rect.size.x * 0.84, rect.size.y * 0.32),
		rect.position + Vector2(rect.size.x * 0.98, rect.size.y * 0.50),
		rect.position + Vector2(rect.size.x * 0.84, rect.size.y * 0.68),
		rect.position + Vector2(rect.size.x * 0.92, rect.size.y * 0.54),
		rect.position + Vector2(rect.size.x * 0.70, rect.size.y * 0.54),
	])
	draw_colored_polygon(arrow, color)


func _draw_flask_icon(rect: Rect2, color: Color) -> void:
	var body := PackedVector2Array([
		rect.position + Vector2(rect.size.x * 0.36, rect.size.y * 0.16),
		rect.position + Vector2(rect.size.x * 0.64, rect.size.y * 0.16),
		rect.position + Vector2(rect.size.x * 0.70, rect.size.y * 0.40),
		rect.position + Vector2(rect.size.x * 0.82, rect.size.y * 0.78),
		rect.position + Vector2(rect.size.x * 0.18, rect.size.y * 0.78),
		rect.position + Vector2(rect.size.x * 0.30, rect.size.y * 0.40),
	])
	draw_colored_polygon(body, Color(color.r, color.g, color.b, 0.26))
	draw_line(rect.position + Vector2(rect.size.x * 0.42, rect.size.y * 0.14), rect.position + Vector2(rect.size.x * 0.58, rect.size.y * 0.14), color, maxf(3.0, rect.size.x * 0.08))
	draw_arc(rect.get_center() + Vector2(0.0, rect.size.y * 0.12), rect.size.x * 0.22, 0.2, PI - 0.2, 18, color, maxf(2.0, rect.size.x * 0.05))
	draw_circle(rect.get_center() + Vector2(0.0, rect.size.y * 0.18), rect.size.x * 0.09, Color(0.98, 0.99, 1.0))


func _draw_miasma_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	draw_circle(center + Vector2(-rect.size.x * 0.16, rect.size.y * 0.04), rect.size.x * 0.18, Color(color.r, color.g, color.b, 0.22))
	draw_circle(center + Vector2(rect.size.x * 0.02, -rect.size.y * 0.04), rect.size.x * 0.20, Color(color.r, color.g, color.b, 0.30))
	draw_circle(center + Vector2(rect.size.x * 0.18, rect.size.y * 0.08), rect.size.x * 0.16, Color(color.r, color.g, color.b, 0.24))
	draw_arc(center, rect.size.x * 0.34, 0.0, TAU, 28, color, maxf(2.0, rect.size.x * 0.05))


func _draw_shardburst_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	for index in range(5):
		var angle := -0.8 + float(index) * 0.4
		var direction := Vector2.RIGHT.rotated(angle)
		var tangent := direction.orthogonal().normalized()
		var base := center + direction * rect.size.x * 0.04
		var tip := center + direction * rect.size.x * 0.36
		draw_colored_polygon(PackedVector2Array([
			base - tangent * rect.size.x * 0.04,
			base + tangent * rect.size.x * 0.04,
			tip,
		]), Color(color.r, color.g, color.b, 0.84 if index != 2 else 1.0))


func _draw_catalyst_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	draw_circle(center, rect.size.x * 0.16, Color(color.r, color.g, color.b, 0.24))
	for index in range(6):
		var angle := TAU * float(index) / 6.0
		var direction := Vector2.RIGHT.rotated(angle)
		draw_line(center + direction * rect.size.x * 0.08, center + direction * rect.size.x * 0.34, color, maxf(2.0, rect.size.x * 0.05))
		draw_circle(center + direction * rect.size.x * 0.38, rect.size.x * 0.05, Color(0.98, 0.99, 1.0))


func _draw_needle_icon(rect: Rect2, color: Color) -> void:
	var start := rect.position + Vector2(rect.size.x * 0.14, rect.size.y * 0.72)
	var end := rect.position + Vector2(rect.size.x * 0.86, rect.size.y * 0.28)
	draw_line(start, end, color, maxf(3.0, rect.size.x * 0.07))
	draw_line(start + Vector2(0.0, rect.size.y * 0.10), end + Vector2(0.0, rect.size.y * 0.10), Color(0.98, 0.99, 1.0), maxf(2.0, rect.size.x * 0.05))


func _draw_volley_icon(rect: Rect2, color: Color) -> void:
	for index in range(4):
		var x := 0.18 + float(index) * 0.16
		draw_line(
			rect.position + Vector2(rect.size.x * x, rect.size.y * 0.76),
			rect.position + Vector2(rect.size.x * (x + 0.18), rect.size.y * 0.22),
			color if index % 2 == 0 else Color(0.98, 0.99, 1.0),
			maxf(2.0, rect.size.x * 0.05)
		)


func _draw_glaive_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	draw_arc(center, rect.size.x * 0.28, -1.0, 1.2, 20, color, maxf(3.0, rect.size.x * 0.07))
	draw_colored_polygon(PackedVector2Array([
		rect.position + Vector2(rect.size.x * 0.58, rect.size.y * 0.16),
		rect.position + Vector2(rect.size.x * 0.84, rect.size.y * 0.34),
		rect.position + Vector2(rect.size.x * 0.66, rect.size.y * 0.52),
	]), Color(0.98, 0.99, 1.0))


func _draw_trail_icon(rect: Rect2, color: Color) -> void:
	var line_width := maxf(4.0, rect.size.x * 0.10)
	draw_line(rect.position + Vector2(rect.size.x * 0.14, rect.size.y * 0.74), rect.position + Vector2(rect.size.x * 0.86, rect.size.y * 0.26), color, line_width)
	draw_line(rect.position + Vector2(rect.size.x * 0.14, rect.size.y * 0.54), rect.position + Vector2(rect.size.x * 0.70, rect.size.y * 0.18), Color(0.98, 0.99, 1.0, 0.84), maxf(2.0, rect.size.x * 0.05))


func _draw_pulse_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	draw_circle(center, rect.size.x * 0.10, Color(0.98, 0.99, 1.0))
	draw_arc(center, rect.size.x * 0.22, 0.0, TAU, 24, color, maxf(2.0, rect.size.x * 0.05))
	draw_arc(center, rect.size.x * 0.34, 0.0, TAU, 28, Color(color.r, color.g, color.b, 0.58), maxf(2.0, rect.size.x * 0.04))


func _draw_ward_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	draw_arc(center, rect.size.x * 0.28, 0.0, TAU, 32, color, maxf(2.0, rect.size.x * 0.05))
	for index in range(3):
		var angle := TAU * float(index) / 3.0 - PI * 0.5
		draw_circle(center + Vector2.RIGHT.rotated(angle) * rect.size.x * 0.28, rect.size.x * 0.07, Color(0.98, 0.99, 1.0))


func _draw_beacon_icon(rect: Rect2, color: Color) -> void:
	var center := rect.get_center()
	draw_line(center + Vector2(0.0, rect.size.y * 0.28), center + Vector2(0.0, -rect.size.y * 0.08), color, maxf(3.0, rect.size.x * 0.06))
	draw_circle(center + Vector2(0.0, -rect.size.y * 0.12), rect.size.x * 0.10, Color(0.98, 0.99, 1.0))
	draw_arc(center + Vector2(0.0, rect.size.y * 0.02), rect.size.x * 0.30, 0.0, TAU, 26, Color(color.r, color.g, color.b, 0.74), maxf(2.0, rect.size.x * 0.04))


func _draw_relay_icon(rect: Rect2, color: Color) -> void:
	var left := rect.position + Vector2(rect.size.x * 0.22, rect.size.y * 0.64)
	var mid := rect.position + Vector2(rect.size.x * 0.50, rect.size.y * 0.32)
	var right := rect.position + Vector2(rect.size.x * 0.80, rect.size.y * 0.58)
	draw_line(left, mid, color, maxf(3.0, rect.size.x * 0.06))
	draw_line(mid, right, Color(0.98, 0.99, 1.0), maxf(3.0, rect.size.x * 0.06))
	draw_circle(left, rect.size.x * 0.06, color)
	draw_circle(mid, rect.size.x * 0.06, Color(0.98, 0.99, 1.0))
	draw_circle(right, rect.size.x * 0.06, color)
