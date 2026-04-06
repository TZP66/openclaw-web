extends StaticBody2D
class_name PlatformBlock

var size: Vector2 = Vector2(320.0, 48.0)
var body_color: Color = Color(0.22, 0.26, 0.32)
var top_color: Color = Color(0.48, 0.67, 0.30)
var detail_color: Color = Color(0.14, 0.18, 0.24)
var glow_color: Color = Color(0.72, 0.88, 1.0, 0.18)
var style_id: String = "sky_ruins"
var variant: String = "slab"

var _impact_timer: float = 0.0
var _impact_local: Vector2 = Vector2.ZERO
var _impact_color: Color = Color(0.82, 0.92, 1.0)
var _shape_node: CollisionShape2D


func _ready() -> void:
	add_to_group("terrain")
	collision_layer = 4
	collision_mask = 0
	set_process(true)
	_ensure_shape()
	_refresh_shape()


func _process(delta: float) -> void:
	if _impact_timer <= 0.0:
		return
	_impact_timer = maxf(0.0, _impact_timer - delta)
	queue_redraw()


func configure(block_size: Vector2, fill: Color = body_color, top: Color = top_color, options: Dictionary = {}) -> void:
	size = block_size
	body_color = fill
	top_color = top
	detail_color = options.get("detail_color", fill.darkened(0.22))
	glow_color = options.get("glow_color", Color(top.r, top.g, top.b, 0.24))
	style_id = String(options.get("style_id", style_id))
	variant = String(options.get("variant", variant))
	if is_inside_tree():
		_refresh_shape()


func absorb_projectile(hit_position: Vector2, projectile_tint: Color = Color(0.82, 0.92, 1.0)) -> void:
	var rect := Rect2(-size * 0.5, size)
	var local_hit := to_local(hit_position)
	_impact_local = Vector2(
		clampf(local_hit.x, rect.position.x + 6.0, rect.end.x - 6.0),
		clampf(local_hit.y, rect.position.y + 6.0, rect.end.y - 6.0)
	)
	_impact_color = projectile_tint
	_impact_timer = 0.22
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(-size * 0.5, size)
	var top_height := minf(14.0, size.y * 0.30)
	var shadow_rect := Rect2(rect.position + Vector2(0.0, 7.0), rect.size)
	var outline := body_color.darkened(0.30)
	var panel := body_color.lightened(0.08)

	draw_rect(shadow_rect, Color(0.02, 0.03, 0.05, 0.28))
	draw_rect(rect, body_color)
	draw_rect(Rect2(rect.position + Vector2(0.0, 3.0), Vector2(size.x, top_height)), top_color)
	draw_rect(Rect2(rect.position + Vector2(12.0, top_height + 8.0), Vector2(maxf(0.0, size.x - 24.0), maxf(12.0, size.y - top_height - 18.0))), panel)
	draw_line(rect.position + Vector2(0.0, top_height + 5.0), rect.position + Vector2(size.x, top_height + 5.0), outline, 2.0)
	draw_line(rect.position + Vector2(0.0, size.y - 8.0), rect.position + Vector2(size.x, size.y - 8.0), Color(0.01, 0.01, 0.02, 0.30), 2.0)
	draw_rect(Rect2(rect.position, Vector2(size.x, 2.0)), Color(1.0, 1.0, 1.0, 0.08))

	_draw_variant_details(rect, top_height)

	if _impact_timer > 0.0:
		var alpha := _impact_timer / 0.22
		draw_circle(_impact_local, 9.0 + (1.0 - alpha) * 8.0, Color(_impact_color.r, _impact_color.g, _impact_color.b, 0.22 * alpha))
		draw_arc(_impact_local, 6.0 + (1.0 - alpha) * 10.0, 0.0, TAU, 22, Color(1.0, 1.0, 1.0, 0.46 * alpha), 1.8)
		for ray_index in range(4):
			var angle := TAU * float(ray_index) / 4.0 + 0.35
			var direction := Vector2.RIGHT.rotated(angle)
			draw_line(_impact_local + direction * 2.0, _impact_local + direction * (10.0 + (1.0 - alpha) * 4.0), Color(_impact_color.r, _impact_color.g, _impact_color.b, 0.54 * alpha), 1.4)


func _draw_variant_details(rect: Rect2, top_height: float) -> void:
	var dark := detail_color.darkened(0.14)
	var light := detail_color.lightened(0.12)
	var center := rect.position + rect.size * 0.5
	match variant:
		"bridge":
			for index in range(1, max(2, int(size.x / 74.0))):
				var x := rect.position.x + float(index) * size.x / float(max(2, int(size.x / 74.0)))
				draw_line(Vector2(x, rect.position.y + top_height + 8.0), Vector2(x, rect.position.y + size.y - 10.0), dark, 2.0)
			draw_rect(Rect2(rect.position + Vector2(18.0, top_height + 12.0), Vector2(maxf(20.0, size.x - 36.0), 10.0)), Color(glow_color.r, glow_color.g, glow_color.b, 0.12))
		"pillar":
			draw_rect(Rect2(center.x - size.x * 0.18, rect.position.y + 12.0, size.x * 0.36, size.y - 22.0), dark)
			for band_index in range(3):
				var band_y := rect.position.y + 18.0 + float(band_index) * (size.y - 32.0) / 3.0
				draw_line(Vector2(rect.position.x + 10.0, band_y), Vector2(rect.end.x - 10.0, band_y), light, 2.0)
		"forge_wall":
			draw_rect(Rect2(rect.position + Vector2(12.0, top_height + 10.0), Vector2(maxf(20.0, size.x - 24.0), maxf(12.0, size.y - top_height - 22.0))), dark)
			for vent_index in range(max(1, int(size.x / 86.0))):
				var vent_x := rect.position.x + 24.0 + float(vent_index) * 74.0
				draw_rect(Rect2(Vector2(vent_x, rect.position.y + top_height + 18.0), Vector2(26.0, maxf(12.0, size.y - top_height - 38.0))), Color(glow_color.r, glow_color.g, glow_color.b, 0.22))
		"slag_bin":
			draw_colored_polygon(PackedVector2Array([
				Vector2(rect.position.x + 14.0, rect.position.y + size.y - 12.0),
				Vector2(rect.position.x + 46.0, rect.position.y + top_height + 12.0),
				Vector2(rect.end.x - 46.0, rect.position.y + top_height + 12.0),
				Vector2(rect.end.x - 14.0, rect.position.y + size.y - 12.0),
			]), dark)
			draw_arc(Vector2(center.x, rect.position.y + top_height + 18.0), minf(size.x, size.y) * 0.20, 0.2, PI - 0.2, 20, Color(glow_color.r, glow_color.g, glow_color.b, 0.42), 2.0)
		"reed_bank":
			for reed_index in range(max(5, int(size.x / 24.0))):
				var x := rect.position.x + 10.0 + float(reed_index) * (size.x - 20.0) / float(max(1, int(size.x / 24.0) - 1))
				var top_offset := 10.0 + 8.0 * sin(float(reed_index) * 0.8)
				draw_line(Vector2(x, rect.position.y + size.y - 8.0), Vector2(x + 2.0, rect.position.y + top_offset), light, 2.0)
			draw_rect(Rect2(rect.position + Vector2(10.0, top_height + 10.0), Vector2(maxf(20.0, size.x - 20.0), 12.0)), Color(glow_color.r, glow_color.g, glow_color.b, 0.14))
		"altar":
			draw_arc(center, minf(size.x, size.y) * 0.24, 0.0, TAU, 26, Color(glow_color.r, glow_color.g, glow_color.b, 0.54), 2.0)
			draw_line(Vector2(center.x, rect.position.y + top_height + 10.0), Vector2(center.x, rect.end.y - 12.0), light, 2.0)
			draw_line(Vector2(rect.position.x + 16.0, center.y), Vector2(rect.end.x - 16.0, center.y), light, 2.0)
		_:
			for index in range(1, max(2, int(size.x / 90.0))):
				var seam_x := rect.position.x + float(index) * 90.0
				draw_line(Vector2(seam_x, rect.position.y + top_height + 8.0), Vector2(seam_x, rect.end.y - 8.0), dark, 2.0)
			draw_line(Vector2(rect.position.x + 14.0, rect.position.y + size.y * 0.5), Vector2(rect.end.x - 14.0, rect.position.y + size.y * 0.5), light, 1.6)

	if style_id == "sky_ruins":
		draw_arc(center, minf(size.x, size.y) * 0.18, 0.0, TAU, 22, Color(glow_color.r, glow_color.g, glow_color.b, 0.20), 1.6)
	elif style_id == "ember_forge":
		draw_line(Vector2(rect.position.x + 14.0, rect.position.y + size.y - 16.0), Vector2(rect.end.x - 14.0, rect.position.y + size.y - 16.0), Color(1.0, 0.58, 0.22, 0.18), 2.0)
	elif style_id == "void_marsh":
		draw_circle(Vector2(center.x, rect.position.y + top_height + 14.0), minf(size.x, size.y) * 0.12, Color(glow_color.r, glow_color.g, glow_color.b, 0.18))


func _ensure_shape() -> void:
	_shape_node = get_node_or_null("CollisionShape2D")
	if _shape_node == null:
		_shape_node = CollisionShape2D.new()
		_shape_node.name = "CollisionShape2D"
		add_child(_shape_node)


func _refresh_shape() -> void:
	var shape := _shape_node.shape as RectangleShape2D
	if shape == null:
		shape = RectangleShape2D.new()
		_shape_node.shape = shape
	shape.size = size
	queue_redraw()