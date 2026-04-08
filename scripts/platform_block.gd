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
const THEMED_BODY_VARIANTS := [
	"bridge",
	"sky_relay",
	"sky_shrine",
	"forge_wall",
	"forge_tank",
	"forge_crane",
	"slag_bin",
	"reed_bank",
	"bog_tree",
	"spore_pod",
	"altar",
	"prism_cluster",
	"archive_gate",
	"prism_shelf",
	"gear_bed",
	"clock_column",
	"clock_arbor",
]


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
	if THEMED_BODY_VARIANTS.has(variant):
		_draw_themed_variant(rect, top_height)
	else:
		_draw_generic_body(rect, top_height)
		_draw_variant_details(rect, top_height)
	_draw_style_accent(rect, top_height)

	if _impact_timer > 0.0:
		var alpha := _impact_timer / 0.22
		draw_circle(_impact_local, 9.0 + (1.0 - alpha) * 8.0, Color(_impact_color.r, _impact_color.g, _impact_color.b, 0.22 * alpha))
		draw_arc(_impact_local, 6.0 + (1.0 - alpha) * 10.0, 0.0, TAU, 22, Color(1.0, 1.0, 1.0, 0.46 * alpha), 1.8)
		for ray_index in range(4):
			var angle := TAU * float(ray_index) / 4.0 + 0.35
			var direction := Vector2.RIGHT.rotated(angle)
			draw_line(_impact_local + direction * 2.0, _impact_local + direction * (10.0 + (1.0 - alpha) * 4.0), Color(_impact_color.r, _impact_color.g, _impact_color.b, 0.54 * alpha), 1.4)


func _draw_generic_body(rect: Rect2, top_height: float) -> void:
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


func _draw_themed_variant(rect: Rect2, top_height: float) -> void:
	var dark := detail_color.darkened(0.14)
	var light := detail_color.lightened(0.12)
	var center := rect.position + rect.size * 0.5
	var shadow := Color(0.02, 0.03, 0.05, 0.22)
	match variant:
		"bridge":
			draw_circle(center + Vector2(0.0, size.y * 0.28), size.x * 0.22, shadow)
			var deck_y := rect.position.y + size.y * 0.56
			var plank_count: int = maxi(3, int(size.x / 82.0))
			for plank_index in range(plank_count):
				var plank_width := maxf(34.0, size.x / float(plank_count) - 8.0)
				var plank_x := rect.position.x + 10.0 + float(plank_index) * (plank_width + 6.0)
				var plank_rect := Rect2(Vector2(plank_x, deck_y + sin(float(plank_index) * 0.7) * 2.0), Vector2(plank_width, 14.0))
				draw_rect(plank_rect, body_color.lightened(0.06))
				draw_line(plank_rect.position, plank_rect.position + Vector2(plank_width, 0.0), top_color, 2.0)
			draw_line(Vector2(rect.position.x + 16.0, rect.position.y + top_height + 4.0), Vector2(rect.position.x + 34.0, deck_y + 6.0), light, 2.0)
			draw_line(Vector2(rect.end.x - 16.0, rect.position.y + top_height + 4.0), Vector2(rect.end.x - 34.0, deck_y + 6.0), light, 2.0)
		"sky_relay":
			draw_circle(center + Vector2(0.0, size.y * 0.26), size.x * 0.18, shadow)
			draw_colored_polygon(PackedVector2Array([
				Vector2(center.x - size.x * 0.10, rect.end.y - 18.0),
				Vector2(center.x - size.x * 0.20, rect.position.y + size.y * 0.54),
				Vector2(center.x, rect.position.y + 10.0),
				Vector2(center.x + size.x * 0.20, rect.position.y + size.y * 0.54),
				Vector2(center.x + size.x * 0.10, rect.end.y - 18.0),
			]), dark)
			for side in [-1.0, 1.0]:
				draw_colored_polygon(PackedVector2Array([
					Vector2(center.x + side * size.x * 0.08, rect.position.y + size.y * 0.30),
					Vector2(center.x + side * size.x * 0.30, rect.position.y + size.y * 0.42),
					Vector2(center.x + side * size.x * 0.20, rect.position.y + size.y * 0.72),
					Vector2(center.x + side * size.x * 0.04, rect.position.y + size.y * 0.56),
				]), Color(light.r, light.g, light.b, 0.88))
			draw_arc(Vector2(center.x, center.y - size.y * 0.08), size.x * 0.24, 0.0, TAU, 28, Color(glow_color.r, glow_color.g, glow_color.b, 0.54), 3.0)
			draw_arc(Vector2(center.x, center.y + size.y * 0.06), size.x * 0.15, 0.0, TAU, 24, Color(top_color.r, top_color.g, top_color.b, 0.44), 2.0)
			draw_circle(Vector2(center.x, center.y - size.y * 0.08), minf(size.x, size.y) * 0.11, light)
			draw_circle(Vector2(center.x, center.y - size.y * 0.08), minf(size.x, size.y) * 0.05, Color(top_color.r, top_color.g, top_color.b, 0.92))
		"sky_shrine":
			draw_circle(center + Vector2(0.0, size.y * 0.26), size.x * 0.18, shadow)
			var plinth := PackedVector2Array([
				Vector2(center.x - size.x * 0.30, rect.end.y - 18.0),
				Vector2(center.x - size.x * 0.20, rect.end.y - 32.0),
				Vector2(center.x + size.x * 0.20, rect.end.y - 32.0),
				Vector2(center.x + size.x * 0.30, rect.end.y - 18.0),
			])
			draw_colored_polygon(plinth, body_color.darkened(0.12))
			var arch_width := size.x * 0.48
			var pillar_width := maxf(18.0, size.x * 0.10)
			var pillar_top := rect.position.y + size.y * 0.34
			draw_rect(Rect2(center.x - arch_width * 0.5, pillar_top, pillar_width, rect.end.y - pillar_top - 24.0), dark)
			draw_rect(Rect2(center.x + arch_width * 0.5 - pillar_width, pillar_top, pillar_width, rect.end.y - pillar_top - 24.0), dark)
			draw_arc(Vector2(center.x, rect.position.y + size.y * 0.56), arch_width * 0.5, PI, TAU, 28, light, 6.0)
			draw_line(Vector2(center.x - arch_width * 0.14, rect.position.y + size.y * 0.22), Vector2(center.x + arch_width * 0.14, rect.position.y + size.y * 0.22), Color(top_color.r, top_color.g, top_color.b, 0.72), 3.0)
			draw_circle(Vector2(center.x, rect.position.y + size.y * 0.42), minf(size.x, size.y) * 0.10, Color(glow_color.r, glow_color.g, glow_color.b, 0.74))
			draw_circle(Vector2(center.x, rect.position.y + size.y * 0.42), minf(size.x, size.y) * 0.05, Color(top_color.r, top_color.g, top_color.b, 0.96))
		"forge_wall":
			draw_circle(center + Vector2(0.0, size.y * 0.24), size.x * 0.26, shadow)
			var belt_rect := Rect2(rect.position.x + 12.0, rect.position.y + size.y * 0.40, maxf(40.0, size.x - 24.0), maxf(24.0, size.y * 0.28))
			draw_rect(belt_rect, dark)
			draw_line(belt_rect.position, belt_rect.position + Vector2(belt_rect.size.x, 0.0), top_color, 4.0)
			draw_line(Vector2(belt_rect.position.x, belt_rect.end.y), belt_rect.end, body_color.darkened(0.26), 4.0)
			for brace_index in range(max(2, int(size.x / 110.0))):
				var brace_x := belt_rect.position.x + 24.0 + float(brace_index) * maxf(60.0, belt_rect.size.x / float(max(2, int(size.x / 110.0))))
				draw_line(Vector2(brace_x, rect.position.y + 18.0), Vector2(brace_x - 18.0, belt_rect.position.y), light, 3.0)
				draw_line(Vector2(brace_x, rect.position.y + 18.0), Vector2(brace_x + 18.0, belt_rect.position.y), light, 3.0)
			for vent_index in range(max(2, int(size.x / 82.0))):
				var vent_x := belt_rect.position.x + 18.0 + float(vent_index) * maxf(44.0, belt_rect.size.x / float(max(2, int(size.x / 82.0))))
				draw_rect(Rect2(Vector2(vent_x, belt_rect.position.y + 8.0), Vector2(14.0, maxf(12.0, belt_rect.size.y - 16.0))), Color(glow_color.r, glow_color.g, glow_color.b, 0.30))
		"forge_tank":
			var furnace_center := Vector2(center.x, rect.position.y + size.y * 0.56)
			var furnace_radius := minf(size.x * 0.24, size.y * 0.30)
			draw_circle(furnace_center + Vector2(0.0, furnace_radius * 1.26), furnace_radius * 1.12, shadow)
			draw_circle(furnace_center, furnace_radius * 1.16, body_color.darkened(0.12))
			draw_circle(furnace_center, furnace_radius * 0.88, dark)
			draw_circle(furnace_center, furnace_radius * 0.34, Color(1.0, 0.58, 0.22, 0.44))
			draw_arc(furnace_center, furnace_radius * 0.60, -0.9, 0.9, 18, Color(1.0, 0.84, 0.44, 0.66), 4.0)
			draw_arc(furnace_center, furnace_radius * 0.88, PI * 0.15, PI * 0.85, 20, light, 3.0)
			draw_rect(Rect2(furnace_center.x - 14.0, rect.position.y + 12.0, 28.0, maxf(20.0, furnace_center.y - rect.position.y - furnace_radius - 6.0)), body_color.darkened(0.08))
			draw_line(Vector2(furnace_center.x - furnace_radius - 16.0, furnace_center.y - 8.0), Vector2(furnace_center.x - furnace_radius - 42.0, furnace_center.y - 8.0), light, 5.0)
			draw_line(Vector2(furnace_center.x + furnace_radius + 16.0, furnace_center.y + 6.0), Vector2(furnace_center.x + furnace_radius + 44.0, furnace_center.y + 6.0), light, 5.0)
			draw_rect(Rect2(furnace_center.x - furnace_radius * 0.54, rect.end.y - 20.0, 16.0, 14.0), dark)
			draw_rect(Rect2(furnace_center.x + furnace_radius * 0.38, rect.end.y - 20.0, 16.0, 14.0), dark)
		"forge_crane":
			draw_circle(center + Vector2(0.0, size.y * 0.30), size.x * 0.18, shadow)
			var top_y := rect.position.y + 18.0
			var bottom_y := rect.end.y - 14.0
			var left_base := rect.position.x + size.x * 0.20
			var right_base := rect.end.x - size.x * 0.20
			var left_top := Vector2(center.x - size.x * 0.10, top_y)
			var right_top := Vector2(center.x + size.x * 0.18, top_y)
			draw_line(Vector2(left_base, bottom_y), left_top, dark, 8.0)
			draw_line(Vector2(right_base, bottom_y), right_top, dark, 8.0)
			draw_line(left_top, right_top, light, 8.0)
			draw_line(Vector2(left_base + 18.0, bottom_y - 10.0), Vector2(right_base - 12.0, top_y + 28.0), Color(top_color.r, top_color.g, top_color.b, 0.26), 4.0)
			var chain_x := center.x + size.x * 0.05
			for chain_index in range(4):
				var segment_top := top_y + 14.0 + float(chain_index) * 18.0
				draw_line(Vector2(chain_x, segment_top), Vector2(chain_x, segment_top + 12.0), Color(glow_color.r, glow_color.g, glow_color.b, 0.70), 2.4)
			var hook_center := Vector2(chain_x, rect.position.y + size.y * 0.62)
			draw_arc(hook_center, size.x * 0.08, -0.1, PI + 0.15, 18, Color(1.0, 0.66, 0.28, 0.82), 3.0)
			draw_colored_polygon(PackedVector2Array([
				Vector2(hook_center.x - 30.0, hook_center.y + 18.0),
				Vector2(hook_center.x + 24.0, hook_center.y + 18.0),
				Vector2(hook_center.x + 18.0, hook_center.y + 42.0),
				Vector2(hook_center.x - 24.0, hook_center.y + 42.0),
			]), body_color.darkened(0.10))
		"slag_bin":
			draw_circle(center + Vector2(0.0, size.y * 0.24), size.x * 0.20, shadow)
			var trough := PackedVector2Array([
				Vector2(rect.position.x + 18.0, rect.position.y + size.y * 0.52),
				Vector2(rect.position.x + 48.0, rect.position.y + size.y * 0.30),
				Vector2(rect.end.x - 48.0, rect.position.y + size.y * 0.30),
				Vector2(rect.end.x - 18.0, rect.position.y + size.y * 0.52),
				Vector2(rect.end.x - 42.0, rect.end.y - 14.0),
				Vector2(rect.position.x + 42.0, rect.end.y - 14.0),
			])
			draw_colored_polygon(trough, dark)
			draw_line(Vector2(rect.position.x + 48.0, rect.position.y + size.y * 0.30), Vector2(rect.end.x - 48.0, rect.position.y + size.y * 0.30), top_color, 3.0)
			draw_line(Vector2(rect.position.x + 42.0, rect.end.y - 14.0), Vector2(rect.end.x - 42.0, rect.end.y - 14.0), body_color.darkened(0.22), 3.0)
			draw_arc(Vector2(center.x, rect.position.y + size.y * 0.52), minf(size.x, size.y) * 0.18, 0.15, PI - 0.15, 20, Color(1.0, 0.58, 0.22, 0.54), 3.0)
		"reed_bank":
			draw_circle(center + Vector2(0.0, size.y * 0.22), size.x * 0.22, shadow)
			draw_colored_polygon(PackedVector2Array([
				Vector2(rect.position.x + 12.0, rect.end.y - 14.0),
				Vector2(rect.position.x + size.x * 0.20, rect.position.y + size.y * 0.44),
				Vector2(center.x, rect.position.y + size.y * 0.34),
				Vector2(rect.end.x - size.x * 0.20, rect.position.y + size.y * 0.46),
				Vector2(rect.end.x - 12.0, rect.end.y - 14.0),
			]), body_color.darkened(0.08))
			for reed_index in range(max(6, int(size.x / 22.0))):
				var x := rect.position.x + 16.0 + float(reed_index) * (size.x - 32.0) / float(max(1, max(6, int(size.x / 22.0)) - 1))
				var top_offset := 8.0 + 10.0 * sin(float(reed_index) * 0.7)
				draw_line(Vector2(x, rect.end.y - 16.0), Vector2(x + 3.0, rect.position.y + top_offset), Color(top_color.r, top_color.g, top_color.b, 0.74), 2.2)
		"bog_tree":
			draw_circle(center + Vector2(0.0, size.y * 0.28), size.x * 0.18, shadow)
			draw_colored_polygon(PackedVector2Array([
				Vector2(center.x - size.x * 0.06, rect.end.y - 18.0),
				Vector2(center.x - size.x * 0.12, rect.position.y + size.y * 0.58),
				Vector2(center.x - size.x * 0.04, rect.position.y + size.y * 0.24),
				Vector2(center.x + size.x * 0.08, rect.position.y + size.y * 0.38),
				Vector2(center.x + size.x * 0.12, rect.end.y - 20.0),
			]), dark)
			draw_circle(Vector2(center.x - size.x * 0.12, rect.position.y + size.y * 0.34), size.x * 0.16, Color(light.r, light.g, light.b, 0.86))
			draw_circle(Vector2(center.x + size.x * 0.08, rect.position.y + size.y * 0.26), size.x * 0.18, Color(light.r, light.g, light.b, 0.92))
			draw_circle(Vector2(center.x + size.x * 0.18, rect.position.y + size.y * 0.38), size.x * 0.12, Color(top_color.r, top_color.g, top_color.b, 0.66))
			for root_index in range(3):
				var root_dir := -1.0 + float(root_index)
				draw_line(Vector2(center.x, rect.end.y - 20.0), Vector2(center.x + root_dir * size.x * 0.20, rect.end.y - 4.0), body_color.darkened(0.26), 4.0)
		"spore_pod":
			draw_circle(center + Vector2(0.0, size.y * 0.28), size.x * 0.18, shadow)
			var stem_bases: Array[Vector2] = [
				Vector2(center.x - size.x * 0.12, rect.end.y - 18.0),
				Vector2(center.x + size.x * 0.02, rect.end.y - 16.0),
				Vector2(center.x + size.x * 0.16, rect.end.y - 14.0),
			]
			var stem_tops: Array[Vector2] = [
				Vector2(center.x - size.x * 0.14, rect.position.y + size.y * 0.54),
				Vector2(center.x + size.x * 0.02, rect.position.y + size.y * 0.40),
				Vector2(center.x + size.x * 0.18, rect.position.y + size.y * 0.60),
			]
			var cap_radii: Array[float] = [size.y * 0.16, size.y * 0.20, size.y * 0.14]
			for pod_index in range(stem_bases.size()):
				draw_line(stem_bases[pod_index], stem_tops[pod_index], dark, 6.0)
				draw_circle(stem_tops[pod_index], cap_radii[pod_index], light)
				draw_arc(stem_tops[pod_index], cap_radii[pod_index], PI, TAU, 18, Color(top_color.r, top_color.g, top_color.b, 0.82), 3.0)
				draw_circle(stem_tops[pod_index] + Vector2(0.0, cap_radii[pod_index] * 0.12), cap_radii[pod_index] * 0.26, Color(glow_color.r, glow_color.g, glow_color.b, 0.52))
		"prism_cluster":
			draw_circle(center + Vector2(0.0, size.y * 0.24), size.x * 0.20, shadow)
			var prism_bases: Array[Vector2] = [
				Vector2(center.x - size.x * 0.16, rect.end.y - 16.0),
				Vector2(center.x + size.x * 0.02, rect.end.y - 16.0),
				Vector2(center.x + size.x * 0.20, rect.end.y - 16.0),
			]
			var prism_tops: Array[Vector2] = [
				Vector2(center.x - size.x * 0.18, rect.position.y + size.y * 0.34),
				Vector2(center.x + size.x * 0.02, rect.position.y + size.y * 0.18),
				Vector2(center.x + size.x * 0.18, rect.position.y + size.y * 0.40),
			]
			for prism_index in range(prism_bases.size()):
				var base := prism_bases[prism_index]
				var top := prism_tops[prism_index]
				draw_colored_polygon(PackedVector2Array([
					base + Vector2(-size.x * 0.07, 0.0),
					top,
					base + Vector2(size.x * 0.07, 0.0),
					base + Vector2(0.0, size.y * 0.10),
				]), Color(light.r, light.g, light.b, 0.84 if prism_index == 1 else 0.66))
				draw_line(base + Vector2(-size.x * 0.07, 0.0), top, Color(top_color.r, top_color.g, top_color.b, 0.78), 2.0)
				draw_line(top, base + Vector2(size.x * 0.07, 0.0), Color(top_color.r, top_color.g, top_color.b, 0.78), 2.0)
		"archive_gate":
			draw_circle(center + Vector2(0.0, size.y * 0.22), size.x * 0.20, shadow)
			var pillar_width := maxf(18.0, size.x * 0.10)
			var pillar_height := size.y * 0.54
			draw_rect(Rect2(center.x - size.x * 0.24, rect.end.y - pillar_height - 18.0, pillar_width, pillar_height), dark)
			draw_rect(Rect2(center.x + size.x * 0.14, rect.end.y - pillar_height - 18.0, pillar_width, pillar_height), dark)
			draw_arc(Vector2(center.x, rect.position.y + size.y * 0.56), size.x * 0.24, PI, TAU, 24, light, 6.0)
			draw_rect(Rect2(center.x - size.x * 0.20, rect.position.y + size.y * 0.28, size.x * 0.40, 10.0), Color(top_color.r, top_color.g, top_color.b, 0.56))
			draw_circle(Vector2(center.x, rect.position.y + size.y * 0.46), minf(size.x, size.y) * 0.08, Color(glow_color.r, glow_color.g, glow_color.b, 0.84))
		"prism_shelf":
			draw_circle(center + Vector2(0.0, size.y * 0.24), size.x * 0.18, shadow)
			var shelf_top := rect.position.y + size.y * 0.32
			for shelf_index in range(3):
				var y := shelf_top + float(shelf_index) * size.y * 0.18
				draw_rect(Rect2(rect.position.x + 18.0, y, size.x - 36.0, 8.0), dark)
			for crystal_index in range(4):
				var x := rect.position.x + 36.0 + float(crystal_index) * (size.x - 72.0) / 3.0
				draw_colored_polygon(PackedVector2Array([
					Vector2(x, rect.position.y + size.y * 0.58),
					Vector2(x + size.x * 0.05, rect.position.y + size.y * 0.42),
					Vector2(x + size.x * 0.10, rect.position.y + size.y * 0.58),
					Vector2(x + size.x * 0.05, rect.position.y + size.y * 0.70),
				]), Color(light.r, light.g, light.b, 0.86))
		"gear_bed":
			draw_circle(center + Vector2(0.0, size.y * 0.24), size.x * 0.22, shadow)
			draw_rect(Rect2(rect.position.x + 16.0, rect.position.y + size.y * 0.40, size.x - 32.0, size.y * 0.22), dark)
			for gear_index in range(3):
				var gear_center := Vector2(rect.position.x + size.x * (0.24 + float(gear_index) * 0.26), rect.position.y + size.y * 0.52)
				draw_arc(gear_center, size.x * 0.09, 0.0, TAU, 22, Color(top_color.r, top_color.g, top_color.b, 0.82), 3.0)
				draw_circle(gear_center, size.x * 0.03, Color(glow_color.r, glow_color.g, glow_color.b, 0.78))
		"clock_column":
			draw_circle(center + Vector2(0.0, size.y * 0.22), size.x * 0.18, shadow)
			draw_rect(Rect2(center.x - size.x * 0.08, rect.position.y + 16.0, size.x * 0.16, size.y - 32.0), dark)
			draw_circle(Vector2(center.x, rect.position.y + size.y * 0.34), size.x * 0.13, Color(light.r, light.g, light.b, 0.88))
			draw_line(
				Vector2(center.x, rect.position.y + size.y * 0.34),
				Vector2(center.x, rect.position.y + size.y * 0.22),
				Color((light.r + top_color.r) * 0.5, (light.g + top_color.g) * 0.5, (light.b + top_color.b) * 0.5, 0.86),
				3.0
			)
			draw_line(Vector2(center.x, rect.position.y + size.y * 0.34), Vector2(center.x + size.x * 0.08, rect.position.y + size.y * 0.40), Color(top_color.r, top_color.g, top_color.b, 0.78), 3.0)
		"clock_arbor":
			draw_circle(center + Vector2(0.0, size.y * 0.24), size.x * 0.18, shadow)
			draw_line(Vector2(rect.position.x + size.x * 0.24, rect.end.y - 16.0), Vector2(center.x - size.x * 0.06, rect.position.y + size.y * 0.24), dark, 8.0)
			draw_line(Vector2(rect.end.x - size.x * 0.24, rect.end.y - 16.0), Vector2(center.x + size.x * 0.06, rect.position.y + size.y * 0.24), dark, 8.0)
			draw_arc(Vector2(center.x, rect.position.y + size.y * 0.42), size.x * 0.20, PI, TAU, 24, light, 5.0)
			draw_circle(Vector2(center.x, rect.position.y + size.y * 0.42), size.x * 0.06, Color(glow_color.r, glow_color.g, glow_color.b, 0.82))
		"altar":
			draw_circle(center + Vector2(0.0, size.y * 0.24), size.x * 0.20, shadow)
			draw_colored_polygon(PackedVector2Array([
				Vector2(center.x - size.x * 0.26, rect.end.y - 16.0),
				Vector2(center.x - size.x * 0.18, rect.end.y - 34.0),
				Vector2(center.x + size.x * 0.18, rect.end.y - 34.0),
				Vector2(center.x + size.x * 0.26, rect.end.y - 16.0),
			]), body_color.darkened(0.08))
			draw_colored_polygon(PackedVector2Array([
				Vector2(center.x - size.x * 0.14, rect.end.y - 34.0),
				Vector2(center.x - size.x * 0.08, rect.position.y + size.y * 0.34),
				Vector2(center.x + size.x * 0.08, rect.position.y + size.y * 0.34),
				Vector2(center.x + size.x * 0.14, rect.end.y - 34.0),
			]), dark)
			draw_arc(Vector2(center.x, rect.position.y + size.y * 0.42), minf(size.x, size.y) * 0.18, 0.0, TAU, 24, Color(glow_color.r, glow_color.g, glow_color.b, 0.70), 2.4)
			draw_circle(Vector2(center.x, rect.position.y + size.y * 0.42), minf(size.x, size.y) * 0.05, Color(top_color.r, top_color.g, top_color.b, 0.90))
		_:
			_draw_generic_body(rect, top_height)
			_draw_variant_details(rect, top_height)


func _draw_variant_details(rect: Rect2, top_height: float) -> void:
	var dark := detail_color.darkened(0.14)
	var light := detail_color.lightened(0.12)
	match variant:
		"pillar":
			var center := rect.position + rect.size * 0.5
			draw_rect(Rect2(center.x - size.x * 0.18, rect.position.y + 12.0, size.x * 0.36, size.y - 22.0), dark)
			for band_index in range(3):
				var band_y := rect.position.y + 18.0 + float(band_index) * (size.y - 32.0) / 3.0
				draw_line(Vector2(rect.position.x + 10.0, band_y), Vector2(rect.end.x - 10.0, band_y), light, 2.0)
		_:
			for index in range(1, max(2, int(size.x / 90.0))):
				var seam_x := rect.position.x + float(index) * 90.0
				draw_line(Vector2(seam_x, rect.position.y + top_height + 8.0), Vector2(seam_x, rect.end.y - 8.0), dark, 2.0)
			draw_line(Vector2(rect.position.x + 14.0, rect.position.y + size.y * 0.5), Vector2(rect.end.x - 14.0, rect.position.y + size.y * 0.5), light, 1.6)


func _draw_style_accent(rect: Rect2, top_height: float) -> void:
	var center := rect.position + rect.size * 0.5
	if style_id == "sky_ruins":
		draw_arc(center, minf(size.x, size.y) * 0.18, 0.0, TAU, 22, Color(glow_color.r, glow_color.g, glow_color.b, 0.20), 1.6)
	elif style_id == "ember_forge":
		draw_line(Vector2(rect.position.x + 14.0, rect.position.y + size.y - 16.0), Vector2(rect.end.x - 14.0, rect.position.y + size.y - 16.0), Color(1.0, 0.58, 0.22, 0.18), 2.0)
	elif style_id == "void_marsh":
		draw_circle(Vector2(center.x, rect.position.y + top_height + 14.0), minf(size.x, size.y) * 0.12, Color(glow_color.r, glow_color.g, glow_color.b, 0.18))
	elif style_id == "prism_archive":
		draw_arc(center, minf(size.x, size.y) * 0.20, -0.8, 0.8, 18, Color(glow_color.r, glow_color.g, glow_color.b, 0.40), 2.0)
		draw_line(Vector2(center.x, rect.position.y + top_height + 6.0), Vector2(center.x, rect.end.y - 10.0), Color(top_color.r, top_color.g, top_color.b, 0.22), 1.6)
	elif style_id == "clockwork_garden":
		draw_circle(Vector2(center.x, rect.position.y + top_height + 14.0), minf(size.x, size.y) * 0.08, Color(glow_color.r, glow_color.g, glow_color.b, 0.28))
		draw_line(Vector2(rect.position.x + 18.0, rect.position.y + size.y * 0.36), Vector2(rect.end.x - 18.0, rect.position.y + size.y * 0.36), Color(top_color.r, top_color.g, top_color.b, 0.18), 1.6)


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
