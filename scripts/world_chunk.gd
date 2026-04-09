extends Node2D
class_name WorldChunk

const DEFAULT_CHUNK_SIZE := Vector2(1600.0, 1600.0)
const OBSTACLE_MARGIN := 220.0
const ORIGIN_CLEAR_RADIUS := 360.0

var chunk_coord: Vector2i = Vector2i.ZERO
var chunk_size: Vector2 = DEFAULT_CHUNK_SIZE
var style_id: String = "sky_ruins"
var ground_dark: Color = Color(0.05, 0.08, 0.10)
var ground_mid: Color = Color(0.08, 0.13, 0.16)
var line_color: Color = Color(0.16, 0.26, 0.30, 0.55)
var rune_color: Color = Color(0.44, 0.86, 1.0, 0.18)
var ember_color: Color = Color(0.96, 0.82, 0.36, 0.12)
var accent_color: Color = Color(0.82, 0.92, 1.0, 0.16)


func configure(new_chunk_coord: Vector2i, new_chunk_size: Vector2, palette: Dictionary) -> void:
	chunk_coord = new_chunk_coord
	chunk_size = new_chunk_size
	style_id = String(palette.get("style_id", style_id))
	ground_dark = palette.get("ground_dark", ground_dark)
	ground_mid = palette.get("ground_mid", ground_mid)
	line_color = palette.get("line_color", line_color)
	rune_color = palette.get("rune_color", rune_color)
	ember_color = palette.get("ember_color", ember_color)
	accent_color = palette.get("accent_color", accent_color)
	_rebuild()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, chunk_size + Vector2.ONE), ground_dark)
	match style_id:
		"bridge_train":
			_draw_bridge_train_tracks()
			_draw_bridge_train_break_zones()
			_draw_bridge_train_girders()
			_draw_bridge_train_alert_net()
			_draw_bridge_train_signals()
			_draw_bridge_train_debris()
		"black_fog_hunt":
			_draw_black_fog_trails()
			_draw_black_fog_wall_ribbons()
			_draw_black_fog_bands()
			_draw_black_fog_false_beacons()
			_draw_black_fog_lanterns()
			_draw_black_fog_embers()
		"airship_breach":
			_draw_airship_deck_panels()
			_draw_airship_warning_lanes()
			_draw_airship_breach_rifts()
			_draw_airship_torn_armor()
			_draw_airship_wind_trails()
			_draw_airship_sky_debris()
		"ember_forge":
			_draw_foundry_channels()
			_draw_heat_grids()
			_draw_foundry_cores()
			_draw_foundry_scaffolds()
			_draw_sparks()
		"void_marsh":
			_draw_marsh_paths()
			_draw_marsh_pools()
			_draw_roots()
			_draw_marsh_totems()
			_draw_spores()
		"prism_archive":
			_draw_archive_aisles()
			_draw_prism_windows()
			_draw_refraction_seals()
			_draw_archive_motes()
		"clockwork_garden":
			_draw_garden_paths()
			_draw_gear_beds()
			_draw_clock_arbors()
			_draw_clock_petals()
		_:
			_draw_sky_paths()
			_draw_floating_tiles()
			_draw_runes()
			_draw_sky_relics()
			_draw_embers()


func _rebuild() -> void:
	for child in get_children():
		child.queue_free()
	_spawn_obstacles()
	queue_redraw()


func _draw_sky_paths() -> void:
	var rng := _make_rng(11)
	var vertical_x := 180.0 + rng.randf_range(0.0, chunk_size.x - 360.0)
	var horizontal_y := 180.0 + rng.randf_range(0.0, chunk_size.y - 360.0)
	var road_color := Color(line_color.r, line_color.g, line_color.b, 0.22)
	var road_inner := Color(ground_mid.r, ground_mid.g, ground_mid.b, 0.46)

	draw_rect(Rect2(Vector2(vertical_x - 92.0, 0.0), Vector2(184.0, chunk_size.y)), road_color)
	draw_rect(Rect2(Vector2(vertical_x - 58.0, 0.0), Vector2(116.0, chunk_size.y)), road_inner)
	draw_rect(Rect2(Vector2(0.0, horizontal_y - 92.0), Vector2(chunk_size.x, 184.0)), road_color)
	draw_rect(Rect2(Vector2(0.0, horizontal_y - 58.0), Vector2(chunk_size.x, 116.0)), road_inner)

	for marker_index in range(12):
		var marker_y := 48.0 + float(marker_index) * 92.0
		draw_rect(Rect2(Vector2(vertical_x - 6.0, marker_y), Vector2(12.0, 36.0)), Color(0.94, 0.96, 0.88, 0.26))
	for marker_index in range(12):
		var marker_x := 48.0 + float(marker_index) * 92.0
		draw_rect(Rect2(Vector2(marker_x, horizontal_y - 6.0), Vector2(36.0, 12.0)), Color(0.94, 0.96, 0.88, 0.26))


func _draw_floating_tiles() -> void:
	var rng := _make_rng(23)
	for index in range(7 + rng.randi_range(0, 2)):
		var size := Vector2(rng.randf_range(170.0, 380.0), rng.randf_range(120.0, 260.0))
		var position_offset := Vector2(
			rng.randf_range(42.0, chunk_size.x - size.x - 42.0),
			rng.randf_range(42.0, chunk_size.y - size.y - 42.0)
		)
		var tint := ground_mid.lightened(0.05 * float(index % 2))
		draw_rect(Rect2(position_offset, size), Color(tint.r, tint.g, tint.b, 0.30))
		draw_rect(Rect2(position_offset + Vector2(8.0, 8.0), size - Vector2(16.0, 16.0)), Color(ground_dark.r, ground_dark.g, ground_dark.b, 0.20))
		if index % 2 == 0:
			draw_arc(position_offset + size * 0.5, minf(size.x, size.y) * 0.22, 0.0, TAU, 24, Color(accent_color.r, accent_color.g, accent_color.b, 0.44), 1.8)


func _draw_runes() -> void:
	var rng := _make_rng(53)
	for _rune_index in range(3 + rng.randi_range(0, 2)):
		var center := Vector2(
			rng.randf_range(180.0, chunk_size.x - 180.0),
			rng.randf_range(180.0, chunk_size.y - 180.0)
		)
		var outer_radius := rng.randf_range(34.0, 54.0)
		var inner_radius := outer_radius * 0.54
		draw_circle(center, outer_radius, rune_color)
		draw_arc(center, outer_radius, 0.0, TAU, 40, Color(rune_color.r, rune_color.g, rune_color.b, 0.58), 2.0)
		draw_arc(center, inner_radius, 0.0, TAU, 28, Color(accent_color.r, accent_color.g, accent_color.b, 0.72), 1.8)
		for angle_index in range(6):
			var angle := TAU * float(angle_index) / 6.0
			var direction := Vector2.RIGHT.rotated(angle)
			draw_line(center + direction * (inner_radius * 0.5), center + direction * (outer_radius - 8.0), Color(0.98, 0.92, 0.56, 0.30), 1.4)


func _draw_embers() -> void:
	var rng := _make_rng(71)
	for _ember_index in range(34):
		var dot := Vector2(
			rng.randf_range(18.0, chunk_size.x - 18.0),
			rng.randf_range(18.0, chunk_size.y - 18.0)
		)
		draw_circle(dot, rng.randf_range(1.4, 3.2), Color(ember_color.r, ember_color.g, ember_color.b, 0.84))


func _draw_sky_relics() -> void:
	var rng := _make_rng(79)
	for _relic_index in range(5):
		var center := Vector2(
			rng.randf_range(120.0, chunk_size.x - 120.0),
			rng.randf_range(120.0, chunk_size.y - 120.0)
		)
		var wing_span := rng.randf_range(90.0, 150.0)
		draw_line(center + Vector2(-wing_span, 0.0), center + Vector2(-wing_span * 0.22, -30.0), Color(accent_color.r, accent_color.g, accent_color.b, 0.26), 5.0)
		draw_line(center + Vector2(wing_span, 0.0), center + Vector2(wing_span * 0.22, -30.0), Color(accent_color.r, accent_color.g, accent_color.b, 0.26), 5.0)
		draw_colored_polygon(PackedVector2Array([
			center + Vector2(0.0, -54.0),
			center + Vector2(-16.0, -4.0),
			center + Vector2(0.0, 24.0),
			center + Vector2(16.0, -4.0),
		]), Color(0.94, 0.96, 0.88, 0.16))
		draw_arc(center, wing_span * 0.22, 0.0, TAU, 22, Color(rune_color.r, rune_color.g, rune_color.b, 0.40), 2.2)
		draw_arc(center + Vector2(0.0, 4.0), wing_span * 0.12, 0.0, TAU, 18, Color(accent_color.r, accent_color.g, accent_color.b, 0.32), 1.8)
		draw_circle(center, 7.0, Color(0.94, 0.96, 0.88, 0.26))


func _draw_foundry_channels() -> void:
	var rng := _make_rng(101)
	for row in range(4):
		var y := 180.0 + float(row) * 280.0 + rng.randf_range(-36.0, 36.0)
		draw_rect(Rect2(Vector2(0.0, y - 34.0), Vector2(chunk_size.x, 68.0)), Color(line_color.r, line_color.g, line_color.b, 0.24))
		draw_rect(Rect2(Vector2(0.0, y - 18.0), Vector2(chunk_size.x, 36.0)), Color(rune_color.r, rune_color.g, rune_color.b, 0.52))
		draw_line(Vector2(0.0, y - 20.0), Vector2(chunk_size.x, y - 20.0), Color(1.0, 0.70, 0.30, 0.14), 2.0)
		draw_line(Vector2(0.0, y + 20.0), Vector2(chunk_size.x, y + 20.0), Color(0.20, 0.08, 0.06, 0.30), 2.0)
	for column in range(3):
		var x := 260.0 + float(column) * 420.0 + rng.randf_range(-24.0, 24.0)
		for segment in range(4):
			var segment_top := 90.0 + float(segment) * 320.0 + rng.randf_range(-16.0, 16.0)
			var segment_height := 148.0
			var pipe_tint := Color(0.28, 0.12, 0.08, 0.40)
			draw_rect(Rect2(Vector2(x - 18.0, segment_top), Vector2(36.0, segment_height)), pipe_tint)
			draw_circle(Vector2(x, segment_top), 18.0, pipe_tint)
			draw_circle(Vector2(x, segment_top + segment_height), 18.0, pipe_tint)
			var elbow_dir := -1.0 if segment % 2 == 0 else 1.0
			var elbow_y := segment_top + segment_height * 0.52
			draw_line(Vector2(x + elbow_dir * 18.0, elbow_y), Vector2(x + elbow_dir * 86.0, elbow_y), Color(0.40, 0.18, 0.12, 0.36), 9.0)
			draw_circle(Vector2(x + elbow_dir * 86.0, elbow_y), 13.0, Color(1.0, 0.64, 0.28, 0.16))


func _draw_heat_grids() -> void:
	var rng := _make_rng(113)
	for index in range(12):
		var x := 90.0 + float(index) * 120.0
		var alpha := 0.16 + float(index % 2) * 0.06
		draw_line(Vector2(x, 0.0), Vector2(x, chunk_size.y), Color(accent_color.r, accent_color.g, accent_color.b, alpha), 1.4)
	for index in range(10):
		var y := 100.0 + float(index) * 140.0 + rng.randf_range(-12.0, 12.0)
		draw_line(Vector2(0.0, y), Vector2(chunk_size.x, y), Color(1.0, 0.62, 0.28, 0.12), 1.2)


func _draw_foundry_cores() -> void:
	var rng := _make_rng(127)
	for _core_index in range(5):
		var center := Vector2(
			rng.randf_range(180.0, chunk_size.x - 180.0),
			rng.randf_range(180.0, chunk_size.y - 180.0)
		)
		var radius := rng.randf_range(26.0, 46.0)
		draw_circle(center, radius + 14.0, Color(0.32, 0.10, 0.08, 0.30))
		draw_circle(center, radius, Color(1.0, 0.54, 0.18, 0.42))
		draw_arc(center, radius + 10.0, 0.0, TAU, 32, Color(1.0, 0.84, 0.42, 0.42), 2.2)


func _draw_sparks() -> void:
	var rng := _make_rng(139)
	for _spark_index in range(42):
		var point := Vector2(
			rng.randf_range(12.0, chunk_size.x - 12.0),
			rng.randf_range(12.0, chunk_size.y - 12.0)
		)
		draw_line(point, point + Vector2(rng.randf_range(-6.0, 6.0), rng.randf_range(-10.0, 10.0)), Color(1.0, 0.82, 0.36, 0.66), 1.2)


func _draw_foundry_scaffolds() -> void:
	var rng := _make_rng(151)
	for _frame_index in range(6):
		var origin := Vector2(
			rng.randf_range(80.0, chunk_size.x - 220.0),
			rng.randf_range(110.0, chunk_size.y - 160.0)
		)
		var width := rng.randf_range(70.0, 140.0)
		var height := rng.randf_range(54.0, 120.0)
		var tint := Color(0.34, 0.18, 0.12, 0.32)
		draw_line(origin, origin + Vector2(width, 0.0), tint, 3.0)
		draw_line(origin, origin + Vector2(0.0, height), tint, 3.0)
		draw_line(origin + Vector2(width, 0.0), origin + Vector2(width, height), tint, 3.0)
		draw_line(origin + Vector2(0.0, height), origin + Vector2(width, height), tint, 3.0)
		draw_line(origin, origin + Vector2(width, height), Color(1.0, 0.66, 0.28, 0.14), 2.0)
		draw_line(origin + Vector2(width, 0.0), origin + Vector2(0.0, height), Color(1.0, 0.66, 0.28, 0.14), 2.0)
		draw_rect(Rect2(origin + Vector2(8.0, height * 0.46), Vector2(maxf(28.0, width - 16.0), 8.0)), Color(1.0, 0.54, 0.20, 0.12))
		for chain_index in range(2):
			var chain_x := origin.x + width * (0.28 + float(chain_index) * 0.34)
			var chain_top := origin.y + 10.0
			var chain_bottom := origin.y + height * 0.64
			for link_index in range(4):
				var link_y := chain_top + float(link_index) * (chain_bottom - chain_top) / 4.0
				draw_line(Vector2(chain_x, link_y), Vector2(chain_x, link_y + 10.0), Color(1.0, 0.72, 0.32, 0.18), 1.6)
			draw_arc(Vector2(chain_x, chain_bottom + 8.0), 8.0, 0.2, PI - 0.2, 12, Color(1.0, 0.72, 0.32, 0.22), 1.6)


func _draw_marsh_paths() -> void:
	var rng := _make_rng(211)
	for path_index in range(3):
		var start_y := 240.0 + float(path_index) * 320.0 + rng.randf_range(-60.0, 60.0)
		var prev := Vector2(0.0, start_y)
		for segment in range(1, 9):
			var current := Vector2(float(segment) / 8.0 * chunk_size.x, start_y + sin(float(segment) * 0.75 + float(path_index)) * 92.0)
			draw_line(prev, current, Color(line_color.r, line_color.g, line_color.b, 0.28), 56.0)
			draw_line(prev, current, Color(ground_mid.r, ground_mid.g, ground_mid.b, 0.46), 28.0)
			prev = current


func _draw_marsh_pools() -> void:
	var rng := _make_rng(223)
	for _pool_index in range(6):
		var center := Vector2(
			rng.randf_range(140.0, chunk_size.x - 140.0),
			rng.randf_range(140.0, chunk_size.y - 140.0)
		)
		var radius_x := rng.randf_range(70.0, 140.0)
		var radius_y := rng.randf_range(46.0, 100.0)
		draw_set_transform(center, 0.0, Vector2.ONE)
		draw_circle(Vector2.ZERO, radius_x, Color(0.08, 0.18, 0.14, 0.20))
		draw_arc(Vector2.ZERO, minf(radius_x, radius_y), 0.0, TAU, 30, Color(accent_color.r, accent_color.g, accent_color.b, 0.22), 1.6)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_roots() -> void:
	var rng := _make_rng(239)
	for _root_index in range(24):
		var start := Vector2(rng.randf_range(0.0, chunk_size.x), rng.randf_range(0.0, chunk_size.y))
		var end := start + Vector2(rng.randf_range(-120.0, 120.0), rng.randf_range(-90.0, 90.0))
		draw_line(start, end, Color(0.20, 0.36, 0.20, 0.32), 2.4)


func _draw_spores() -> void:
	var rng := _make_rng(251)
	for _spore_index in range(46):
		var point := Vector2(rng.randf_range(18.0, chunk_size.x - 18.0), rng.randf_range(18.0, chunk_size.y - 18.0))
		draw_circle(point, rng.randf_range(1.8, 4.0), Color(accent_color.r, accent_color.g, accent_color.b, 0.44))


func _draw_marsh_totems() -> void:
	var rng := _make_rng(263)
	for _totem_index in range(5):
		var center := Vector2(
			rng.randf_range(120.0, chunk_size.x - 120.0),
			rng.randf_range(120.0, chunk_size.y - 120.0)
		)
		var radius := rng.randf_range(28.0, 44.0)
		draw_circle(center, radius * 1.30, Color(0.14, 0.22, 0.16, 0.22))
		draw_line(center + Vector2(0.0, -radius * 1.06), center + Vector2(0.0, radius * 0.96), Color(0.22, 0.36, 0.22, 0.30), 6.0)
		draw_line(center + Vector2(-radius * 0.52, -radius * 0.30), center + Vector2(radius * 0.52, -radius * 0.56), Color(0.72, 0.88, 0.68, 0.18), 2.4)
		draw_arc(center, radius, 0.0, TAU, 24, Color(accent_color.r, accent_color.g, accent_color.b, 0.30), 1.8)
		draw_arc(center + Vector2(0.0, 4.0), radius * 0.52, 0.0, TAU, 18, Color(0.72, 0.88, 0.68, 0.24), 1.4)
		draw_line(center + Vector2(-radius * 0.4, 0.0), center + Vector2(radius * 0.4, 0.0), Color(0.72, 0.88, 0.68, 0.22), 2.0)
		draw_line(center + Vector2(0.0, -radius * 0.4), center + Vector2(0.0, radius * 0.4), Color(0.72, 0.88, 0.68, 0.22), 2.0)


func _draw_archive_aisles() -> void:
	var rng := _make_rng(311)
	for row in range(4):
		var y := 180.0 + float(row) * 300.0 + rng.randf_range(-32.0, 32.0)
		draw_rect(Rect2(Vector2(0.0, y - 56.0), Vector2(chunk_size.x, 112.0)), Color(line_color.r, line_color.g, line_color.b, 0.18))
		draw_rect(Rect2(Vector2(0.0, y - 32.0), Vector2(chunk_size.x, 64.0)), Color(ground_mid.r, ground_mid.g, ground_mid.b, 0.34))
	for column in range(3):
		var x := 240.0 + float(column) * 420.0 + rng.randf_range(-18.0, 18.0)
		draw_rect(Rect2(Vector2(x - 36.0, 0.0), Vector2(72.0, chunk_size.y)), Color(rune_color.r, rune_color.g, rune_color.b, 0.10))


func _draw_prism_windows() -> void:
	var rng := _make_rng(323)
	for _window_index in range(6):
		var center := Vector2(
			rng.randf_range(140.0, chunk_size.x - 140.0),
			rng.randf_range(160.0, chunk_size.y - 160.0)
		)
		var width := rng.randf_range(84.0, 140.0)
		var height := rng.randf_range(120.0, 180.0)
		var diamond := PackedVector2Array([
			center + Vector2(0.0, -height * 0.5),
			center + Vector2(width * 0.5, 0.0),
			center + Vector2(0.0, height * 0.5),
			center + Vector2(-width * 0.5, 0.0),
		])
		draw_colored_polygon(diamond, Color(ground_mid.r, ground_mid.g, ground_mid.b, 0.22))
		draw_arc(center, minf(width, height) * 0.28, 0.0, TAU, 22, Color(accent_color.r, accent_color.g, accent_color.b, 0.36), 1.8)
		draw_line(center + Vector2(-width * 0.24, 0.0), center + Vector2(width * 0.24, 0.0), Color(0.98, 0.99, 1.0, 0.24), 2.0)


func _draw_refraction_seals() -> void:
	var rng := _make_rng(337)
	for _seal_index in range(5):
		var center := Vector2(
			rng.randf_range(180.0, chunk_size.x - 180.0),
			rng.randf_range(180.0, chunk_size.y - 180.0)
		)
		var radius := rng.randf_range(28.0, 46.0)
		draw_arc(center, radius, 0.0, TAU, 28, Color(rune_color.r, rune_color.g, rune_color.b, 0.42), 2.0)
		for side in range(6):
			var angle := TAU * float(side) / 6.0
			var point := center + Vector2.RIGHT.rotated(angle) * radius
			draw_circle(point, 4.0, Color(accent_color.r, accent_color.g, accent_color.b, 0.52))


func _draw_archive_motes() -> void:
	var rng := _make_rng(349)
	for _mote_index in range(44):
		var point := Vector2(rng.randf_range(18.0, chunk_size.x - 18.0), rng.randf_range(18.0, chunk_size.y - 18.0))
		draw_circle(point, rng.randf_range(1.2, 3.0), Color(accent_color.r, accent_color.g, accent_color.b, 0.56))


func _draw_garden_paths() -> void:
	var rng := _make_rng(401)
	for lane_index in range(3):
		var y := 240.0 + float(lane_index) * 360.0 + rng.randf_range(-44.0, 44.0)
		draw_rect(Rect2(Vector2(0.0, y - 46.0), Vector2(chunk_size.x, 92.0)), Color(line_color.r, line_color.g, line_color.b, 0.18))
		draw_rect(Rect2(Vector2(0.0, y - 24.0), Vector2(chunk_size.x, 48.0)), Color(ground_mid.r, ground_mid.g, ground_mid.b, 0.34))
	for column in range(4):
		var x := 180.0 + float(column) * 320.0 + rng.randf_range(-24.0, 24.0)
		draw_line(Vector2(x, 0.0), Vector2(x, chunk_size.y), Color(ember_color.r, ember_color.g, ember_color.b, 0.12), 2.0)


func _draw_gear_beds() -> void:
	var rng := _make_rng(419)
	for _gear_index in range(7):
		var center := Vector2(
			rng.randf_range(120.0, chunk_size.x - 120.0),
			rng.randf_range(120.0, chunk_size.y - 120.0)
		)
		var outer := rng.randf_range(26.0, 44.0)
		var points := PackedVector2Array()
		for index in range(16):
			var angle := TAU * float(index) / 16.0
			var local_radius := outer * (1.20 if index % 2 == 0 else 0.88)
			points.append(center + Vector2.RIGHT.rotated(angle) * local_radius)
		draw_colored_polygon(points, Color(rune_color.r, rune_color.g, rune_color.b, 0.18))
		draw_circle(center, outer * 0.36, Color(accent_color.r, accent_color.g, accent_color.b, 0.34))


func _draw_clock_arbors() -> void:
	var rng := _make_rng(433)
	for _arbor_index in range(5):
		var center := Vector2(
			rng.randf_range(140.0, chunk_size.x - 140.0),
			rng.randf_range(140.0, chunk_size.y - 140.0)
		)
		var span := rng.randf_range(80.0, 140.0)
		draw_line(center + Vector2(-span, 30.0), center + Vector2(-span * 0.28, -24.0), Color(line_color.r, line_color.g, line_color.b, 0.28), 6.0)
		draw_line(center + Vector2(span, 30.0), center + Vector2(span * 0.28, -24.0), Color(line_color.r, line_color.g, line_color.b, 0.28), 6.0)
		draw_arc(center + Vector2(0.0, 4.0), span * 0.42, PI, TAU, 28, Color(accent_color.r, accent_color.g, accent_color.b, 0.30), 2.0)
		draw_circle(center, 7.0, Color(0.98, 0.98, 0.92, 0.20))


func _draw_clock_petals() -> void:
	var rng := _make_rng(447)
	for _petal_index in range(32):
		var point := Vector2(rng.randf_range(18.0, chunk_size.x - 18.0), rng.randf_range(18.0, chunk_size.y - 18.0))
		draw_line(point, point + Vector2(rng.randf_range(-8.0, 8.0), rng.randf_range(-4.0, 4.0)), Color(ember_color.r, ember_color.g, ember_color.b, 0.52), 1.2)


func _draw_bridge_train_tracks() -> void:
	var rng := _make_rng(463)
	for lane_index in range(3):
		var y := 220.0 + float(lane_index) * 300.0 + rng.randf_range(-28.0, 28.0)
		draw_rect(Rect2(Vector2(0.0, y - 40.0), Vector2(chunk_size.x, 80.0)), Color(line_color.r, line_color.g, line_color.b, 0.30))
		draw_line(Vector2(0.0, y - 18.0), Vector2(chunk_size.x, y - 18.0), Color(0.70, 0.74, 0.78, 0.42), 3.6)
		draw_line(Vector2(0.0, y + 18.0), Vector2(chunk_size.x, y + 18.0), Color(0.70, 0.74, 0.78, 0.42), 3.6)
		for sleeper in range(20):
			var x := 18.0 + float(sleeper) * 82.0 + rng.randf_range(-8.0, 8.0)
			draw_rect(Rect2(Vector2(x, y - 22.0), Vector2(36.0, 44.0)), Color(0.20, 0.18, 0.14, 0.44))
		var stripe_color := Color(1.0, 0.82, 0.36, 0.18)
		for stripe_index in range(10):
			var stripe_x := 60.0 + float(stripe_index) * 160.0
			draw_line(Vector2(stripe_x, y - 52.0), Vector2(stripe_x + 44.0, y - 44.0), stripe_color, 3.0)


func _draw_bridge_train_break_zones() -> void:
	var rng := _make_rng(467)
	for lane_index in range(3):
		var y := 220.0 + float(lane_index) * 300.0 + rng.randf_range(-18.0, 18.0)
		var break_center_x := 300.0 + float(lane_index) * 360.0 + rng.randf_range(-36.0, 72.0)
		var gap_width := rng.randf_range(180.0, 260.0)
		var outer_rect := Rect2(Vector2(break_center_x - gap_width * 0.5, y - 82.0), Vector2(gap_width, 164.0))
		var inner_rect := outer_rect.grow_individual(-18.0, -22.0, -18.0, -22.0)
		draw_rect(outer_rect, Color(0.06, 0.06, 0.08, 0.62))
		draw_rect(inner_rect, Color(0.02, 0.02, 0.03, 0.78))
		_draw_warning_chevrons(outer_rect.grow(-10.0), Color(1.0, 0.74, 0.26, 0.44), Color(0.16, 0.10, 0.08, 0.40), 30.0)
		var cut_left := break_center_x - gap_width * 0.5
		var cut_right := break_center_x + gap_width * 0.5
		for rail_offset in [-18.0, 18.0]:
			draw_line(Vector2(cut_left - 86.0, y + rail_offset), Vector2(cut_left - 8.0, y + rail_offset), Color(0.74, 0.76, 0.80, 0.44), 3.4)
			draw_line(Vector2(cut_right + 8.0, y + rail_offset), Vector2(cut_right + 86.0, y + rail_offset), Color(0.74, 0.76, 0.80, 0.44), 3.4)
			draw_line(Vector2(cut_left - 12.0, y + rail_offset - 7.0), Vector2(cut_left + 16.0, y + rail_offset + 7.0), Color(1.0, 0.82, 0.48, 0.22), 2.0)
			draw_line(Vector2(cut_right - 16.0, y + rail_offset - 7.0), Vector2(cut_right + 12.0, y + rail_offset + 7.0), Color(1.0, 0.82, 0.48, 0.22), 2.0)
		for beacon_side in [-1.0, 1.0]:
			var beacon := Vector2(break_center_x + beacon_side * (gap_width * 0.5 + 26.0), y - 56.0)
			draw_circle(beacon, 7.0, Color(1.0, 0.72, 0.28, 0.54))
			draw_circle(beacon, 18.0, Color(1.0, 0.70, 0.28, 0.16))
			draw_arc(beacon, 28.0, 0.0, TAU, 18, Color(1.0, 0.86, 0.52, 0.12), 1.4)
		for spark_index in range(8):
			var spark_origin := Vector2(
				break_center_x + rng.randf_range(-gap_width * 0.28, gap_width * 0.28),
				y + rng.randf_range(-58.0, 58.0)
			)
			var spark_end := spark_origin + Vector2(rng.randf_range(-12.0, 12.0), rng.randf_range(-18.0, 18.0))
			draw_line(spark_origin, spark_end, Color(1.0, 0.84, 0.44, 0.22), 1.4)


func _draw_bridge_train_girders() -> void:
	var rng := _make_rng(479)
	for col in range(5):
		var x := 120.0 + float(col) * 320.0 + rng.randf_range(-16.0, 16.0)
		draw_rect(Rect2(Vector2(x - 14.0, 0.0), Vector2(28.0, chunk_size.y)), Color(0.22, 0.22, 0.24, 0.34))
		for section in range(8):
			var y := 44.0 + float(section) * 190.0
			draw_line(Vector2(x - 34.0, y), Vector2(x + 34.0, y + 54.0), Color(accent_color.r, accent_color.g, accent_color.b, 0.20), 2.0)
			draw_line(Vector2(x + 34.0, y), Vector2(x - 34.0, y + 54.0), Color(accent_color.r, accent_color.g, accent_color.b, 0.20), 2.0)
	for _beam in range(6):
		var origin := Vector2(rng.randf_range(80.0, chunk_size.x - 260.0), rng.randf_range(120.0, chunk_size.y - 120.0))
		var span := rng.randf_range(120.0, 260.0)
		draw_line(origin, origin + Vector2(span, rng.randf_range(-20.0, 20.0)), Color(0.30, 0.30, 0.33, 0.30), 6.0)


func _draw_bridge_train_alert_net() -> void:
	var rng := _make_rng(487)
	for lane_index in range(3):
		var y := 208.0 + float(lane_index) * 300.0 + rng.randf_range(-12.0, 12.0)
		var left_x := 110.0 + rng.randf_range(-20.0, 20.0)
		var right_x := chunk_size.x - 110.0 + rng.randf_range(-20.0, 20.0)
		draw_line(Vector2(left_x, y - 92.0), Vector2(right_x, y - 92.0), Color(1.0, 0.78, 0.34, 0.14), 2.4)
		draw_line(Vector2(left_x, y + 92.0), Vector2(right_x, y + 92.0), Color(1.0, 0.78, 0.34, 0.14), 2.4)
		for post_index in range(6):
			var x := 120.0 + float(post_index) * 270.0 + rng.randf_range(-14.0, 14.0)
			draw_line(Vector2(x, y - 102.0), Vector2(x, y - 70.0), Color(0.24, 0.24, 0.26, 0.38), 3.0)
			draw_line(Vector2(x, y + 70.0), Vector2(x, y + 102.0), Color(0.24, 0.24, 0.26, 0.38), 3.0)
	for tape_index in range(7):
		var start := Vector2(80.0 + float(tape_index) * 210.0, 120.0 + rng.randf_range(0.0, chunk_size.y - 240.0))
		var end := start + Vector2(rng.randf_range(90.0, 180.0), rng.randf_range(-40.0, 40.0))
		draw_line(start, end, Color(1.0, 0.84, 0.42, 0.18), 4.2)
		draw_line(start + Vector2(0.0, 6.0), end + Vector2(0.0, 6.0), Color(0.18, 0.14, 0.10, 0.20), 2.2)


func _draw_bridge_train_signals() -> void:
	var rng := _make_rng(491)
	for _signal in range(7):
		var base := Vector2(rng.randf_range(90.0, chunk_size.x - 90.0), rng.randf_range(110.0, chunk_size.y - 110.0))
		var mast_height := rng.randf_range(44.0, 82.0)
		draw_line(base, base + Vector2(0.0, -mast_height), Color(0.14, 0.14, 0.16, 0.58), 4.0)
		var lamp := base + Vector2(0.0, -mast_height - 6.0)
		draw_circle(lamp, 8.0, Color(0.98, 0.80, 0.40, 0.36))
		draw_circle(lamp, 16.0, Color(0.98, 0.82, 0.42, 0.14))
		draw_arc(lamp, 24.0, 0.0, TAU, 18, Color(1.0, 0.90, 0.56, 0.14), 1.4)
		draw_line(lamp + Vector2(-20.0, 2.0), lamp + Vector2(20.0, 2.0), Color(1.0, 0.86, 0.50, 0.22), 1.8)


func _draw_bridge_train_debris() -> void:
	var rng := _make_rng(503)
	for _plate_index in range(9):
		var center := Vector2(
			rng.randf_range(100.0, chunk_size.x - 100.0),
			rng.randf_range(100.0, chunk_size.y - 100.0)
		)
		var width := rng.randf_range(34.0, 74.0)
		var height := rng.randf_range(14.0, 34.0)
		var polygon := PackedVector2Array([
			center + Vector2(-width * 0.5, -height * 0.3),
			center + Vector2(width * 0.2, -height * 0.5),
			center + Vector2(width * 0.5, height * 0.1),
			center + Vector2(-width * 0.3, height * 0.5),
		])
		draw_colored_polygon(polygon, Color(0.24, 0.24, 0.27, 0.30))
		draw_line(polygon[0], polygon[2], Color(0.90, 0.72, 0.34, 0.18), 1.6)
		for rivet in range(3):
			var point := center + Vector2(rng.randf_range(-width * 0.34, width * 0.34), rng.randf_range(-height * 0.30, height * 0.30))
			draw_circle(point, 1.8, Color(0.84, 0.86, 0.88, 0.30))


func _draw_black_fog_trails() -> void:
	var rng := _make_rng(521)
	for path_index in range(4):
		var start_y := 180.0 + float(path_index) * 320.0 + rng.randf_range(-44.0, 44.0)
		var previous := Vector2(0.0, start_y)
		for segment in range(1, 10):
			var current := Vector2(
				float(segment) / 9.0 * chunk_size.x,
				start_y + sin(float(segment) * 0.72 + float(path_index) * 0.8) * 96.0
			)
			draw_line(previous, current, Color(0.06, 0.08, 0.10, 0.50), 62.0)
			draw_line(previous, current, Color(line_color.r, line_color.g, line_color.b, 0.16), 22.0)
			previous = current


func _draw_black_fog_wall_ribbons() -> void:
	var rng := _make_rng(533)
	for ribbon_index in range(5):
		var center := Vector2(
			220.0 + float(ribbon_index) * 280.0 + rng.randf_range(-44.0, 44.0),
			160.0 + rng.randf_range(0.0, chunk_size.y - 320.0)
		)
		var span := rng.randf_range(280.0, 520.0)
		var angle := rng.randf_range(-0.48, 0.48)
		var direction := Vector2.RIGHT.rotated(angle)
		var side := direction.orthogonal()
		var width := rng.randf_range(54.0, 92.0)
		var fog_band := PackedVector2Array([
			center - direction * span * 0.5 - side * width,
			center + direction * span * 0.5 - side * width * 0.42,
			center + direction * span * 0.5 + side * width,
			center - direction * span * 0.5 + side * width * 0.42,
		])
		draw_colored_polygon(fog_band, Color(0.02, 0.04, 0.05, 0.26))
		draw_line(center - direction * span * 0.5, center + direction * span * 0.5, Color(0.58, 0.84, 0.74, 0.08), 2.2)
		draw_line(center - direction * span * 0.5 + side * width * 0.36, center + direction * span * 0.5 + side * width * 0.18, Color(0.76, 0.98, 0.88, 0.06), 1.8)


func _draw_black_fog_bands() -> void:
	var rng := _make_rng(541)
	for _fog_layer in range(16):
		var center := Vector2(
			rng.randf_range(80.0, chunk_size.x - 80.0),
			rng.randf_range(80.0, chunk_size.y - 80.0)
		)
		var radius := rng.randf_range(72.0, 190.0)
		draw_circle(center, radius, Color(0.02, 0.03, 0.04, 0.16))
		draw_arc(center, radius * 0.72, 0.0, TAU, 24, Color(rune_color.r, rune_color.g, rune_color.b, 0.10), 1.4)
	for column in range(7):
		var x := 80.0 + float(column) * 240.0
		draw_rect(Rect2(Vector2(x, 0.0), Vector2(80.0, chunk_size.y)), Color(0.03, 0.04, 0.05, 0.10))


func _draw_black_fog_false_beacons() -> void:
	var rng := _make_rng(547)
	for _beacon in range(9):
		var center := Vector2(
			rng.randf_range(100.0, chunk_size.x - 100.0),
			rng.randf_range(100.0, chunk_size.y - 100.0)
		)
		var is_false := rng.randf() < 0.55
		var mast_height := rng.randf_range(24.0, 54.0)
		draw_line(center + Vector2(0.0, mast_height), center, Color(0.06, 0.08, 0.09, 0.42), 2.8)
		if is_false:
			draw_circle(center, 4.6, Color(1.0, 0.74, 0.42, 0.20))
			draw_circle(center + Vector2(8.0, -3.0), 3.4, Color(0.72, 0.98, 0.86, 0.18))
			draw_arc(center, 18.0, 0.2, PI - 0.2, 16, Color(1.0, 0.78, 0.42, 0.10), 1.2)
			draw_line(center + Vector2(-10.0, -10.0), center + Vector2(10.0, 10.0), Color(0.86, 0.96, 0.88, 0.12), 1.2)
			draw_line(center + Vector2(-10.0, 10.0), center + Vector2(10.0, -10.0), Color(0.86, 0.96, 0.88, 0.12), 1.2)
		else:
			draw_circle(center, 5.2, Color(0.72, 1.0, 0.86, 0.34))
			draw_circle(center, 18.0, Color(0.74, 0.98, 0.86, 0.10))
			var beam_dir := Vector2.RIGHT.rotated(rng.randf_range(0.0, TAU))
			draw_line(center, center + beam_dir * 48.0, Color(0.74, 0.98, 0.86, 0.14), 2.0)


func _draw_black_fog_lanterns() -> void:
	var rng := _make_rng(557)
	for _lantern in range(10):
		var center := Vector2(
			rng.randf_range(90.0, chunk_size.x - 90.0),
			rng.randf_range(90.0, chunk_size.y - 90.0)
		)
		draw_circle(center, 6.0, Color(0.72, 1.0, 0.86, 0.46))
		draw_circle(center, 20.0, Color(0.72, 0.98, 0.84, 0.16))
		draw_arc(center, 34.0, 0.0, TAU, 22, Color(0.76, 0.98, 0.86, 0.10), 1.2)
		var beam_dir := Vector2.RIGHT.rotated(rng.randf_range(0.0, TAU))
		draw_line(center, center + beam_dir * 44.0, Color(0.72, 0.98, 0.86, 0.18), 2.2)


func _draw_black_fog_embers() -> void:
	var rng := _make_rng(571)
	for _ember in range(48):
		var point := Vector2(rng.randf_range(12.0, chunk_size.x - 12.0), rng.randf_range(12.0, chunk_size.y - 12.0))
		draw_circle(point, rng.randf_range(1.2, 2.8), Color(0.64, 0.92, 0.80, 0.34))
	for _eye in range(16):
		var point := Vector2(rng.randf_range(14.0, chunk_size.x - 14.0), rng.randf_range(14.0, chunk_size.y - 14.0))
		draw_line(point + Vector2(-2.0, 0.0), point + Vector2(2.0, 0.0), Color(0.92, 0.98, 0.92, 0.22), 1.2)


func _draw_airship_deck_panels() -> void:
	var rng := _make_rng(587)
	for row in range(7):
		var y := 80.0 + float(row) * 220.0 + rng.randf_range(-12.0, 12.0)
		draw_line(Vector2(0.0, y), Vector2(chunk_size.x, y), Color(line_color.r, line_color.g, line_color.b, 0.28), 2.4)
	for column in range(9):
		var x := 84.0 + float(column) * 180.0 + rng.randf_range(-10.0, 10.0)
		draw_line(Vector2(x, 0.0), Vector2(x, chunk_size.y), Color(line_color.r, line_color.g, line_color.b, 0.20), 1.8)
	for plate in range(24):
		var center := Vector2(rng.randf_range(100.0, chunk_size.x - 100.0), rng.randf_range(100.0, chunk_size.y - 100.0))
		draw_circle(center, 2.2, Color(0.84, 0.90, 0.94, 0.24))


func _draw_airship_warning_lanes() -> void:
	var rng := _make_rng(593)
	for lane_index in range(4):
		var y := 170.0 + float(lane_index) * 300.0 + rng.randf_range(-20.0, 20.0)
		var lane_rect := Rect2(Vector2(60.0, y - 34.0), Vector2(chunk_size.x - 120.0, 68.0))
		_draw_warning_chevrons(lane_rect, Color(1.0, 0.78, 0.30, 0.20), Color(0.10, 0.12, 0.16, 0.16), 24.0)
		draw_line(Vector2(80.0, y - 40.0), Vector2(chunk_size.x - 80.0, y - 40.0), Color(1.0, 0.86, 0.48, 0.12), 1.8)
		draw_line(Vector2(80.0, y + 40.0), Vector2(chunk_size.x - 80.0, y + 40.0), Color(1.0, 0.86, 0.48, 0.12), 1.8)
	for marker_index in range(8):
		var marker := Vector2(100.0 + float(marker_index) * 180.0, 120.0 + rng.randf_range(0.0, chunk_size.y - 240.0))
		draw_arc(marker, 20.0, -0.8, 0.8, 12, Color(1.0, 0.84, 0.42, 0.14), 1.4)
		draw_arc(marker, 20.0, PI - 0.8, PI + 0.8, 12, Color(1.0, 0.84, 0.42, 0.14), 1.4)


func _draw_airship_breach_rifts() -> void:
	var rng := _make_rng(601)
	for _rift in range(5):
		var center := Vector2(
			rng.randf_range(180.0, chunk_size.x - 180.0),
			rng.randf_range(180.0, chunk_size.y - 180.0)
		)
		var radius := rng.randf_range(36.0, 72.0)
		draw_circle(center, radius * 1.34, Color(0.02, 0.03, 0.05, 0.30))
		draw_circle(center, radius, Color(0.10, 0.16, 0.22, 0.36))
		draw_arc(center, radius * 1.08, 0.0, TAU, 30, Color(accent_color.r, accent_color.g, accent_color.b, 0.34), 2.0)
		for fracture in range(6):
			var angle := TAU * float(fracture) / 6.0 + rng.randf_range(-0.22, 0.22)
			var end := center + Vector2.RIGHT.rotated(angle) * (radius + rng.randf_range(28.0, 62.0))
			draw_line(center, end, Color(0.74, 0.90, 1.0, 0.14), 1.8)


func _draw_airship_torn_armor() -> void:
	var rng := _make_rng(613)
	for _plate in range(11):
		var center := Vector2(
			rng.randf_range(90.0, chunk_size.x - 90.0),
			rng.randf_range(90.0, chunk_size.y - 90.0)
		)
		var size := rng.randf_range(28.0, 72.0)
		var plate_points := PackedVector2Array([
			center + Vector2(-size * 0.82, -size * 0.24),
			center + Vector2(-size * 0.10, -size * 0.74),
			center + Vector2(size * 0.70, -size * 0.16),
			center + Vector2(size * 0.46, size * 0.64),
			center + Vector2(-size * 0.54, size * 0.48),
		])
		draw_colored_polygon(plate_points, Color(0.30, 0.36, 0.42, 0.22))
		draw_line(plate_points[0], plate_points[2], Color(0.84, 0.94, 1.0, 0.12), 1.2)
		draw_line(plate_points[1], plate_points[4], Color(0.74, 0.88, 1.0, 0.08), 1.0)
		for rivet in range(3):
			var rivet_point := center + Vector2(rng.randf_range(-size * 0.30, size * 0.30), rng.randf_range(-size * 0.26, size * 0.26))
			draw_circle(rivet_point, 1.8, Color(0.86, 0.90, 0.96, 0.22))
	for vent_index in range(12):
		var vent_origin := Vector2(
			rng.randf_range(60.0, chunk_size.x - 140.0),
			rng.randf_range(80.0, chunk_size.y - 80.0)
		)
		var vent_end := vent_origin + Vector2(rng.randf_range(46.0, 120.0), rng.randf_range(-18.0, 18.0))
		draw_line(vent_origin, vent_end, Color(0.78, 0.92, 1.0, 0.16), 2.4)
		draw_line(vent_origin + Vector2(0.0, 4.0), vent_end + Vector2(0.0, 4.0), Color(0.26, 0.40, 0.54, 0.12), 1.2)


func _draw_airship_wind_trails() -> void:
	var rng := _make_rng(619)
	for _trail in range(34):
		var origin := Vector2(
			rng.randf_range(0.0, chunk_size.x),
			rng.randf_range(0.0, chunk_size.y)
		)
		var length := rng.randf_range(34.0, 92.0)
		var angle := rng.randf_range(-0.34, 0.34)
		var end := origin + Vector2(length, 0.0).rotated(angle)
		draw_line(origin, end, Color(0.78, 0.92, 1.0, 0.24), 1.4)
		draw_line(origin + Vector2(0.0, 3.0), end + Vector2(0.0, 3.0), Color(0.34, 0.52, 0.68, 0.16), 1.0)


func _draw_airship_sky_debris() -> void:
	var rng := _make_rng(641)
	for _debris in range(18):
		var center := Vector2(rng.randf_range(80.0, chunk_size.x - 80.0), rng.randf_range(80.0, chunk_size.y - 80.0))
		var size := rng.randf_range(14.0, 36.0)
		var polygon := PackedVector2Array([
			center + Vector2(-size * 0.6, -size * 0.2),
			center + Vector2(size * 0.3, -size * 0.6),
			center + Vector2(size * 0.7, size * 0.1),
			center + Vector2(-size * 0.2, size * 0.6),
		])
		draw_colored_polygon(polygon, Color(0.36, 0.42, 0.50, 0.22))
		draw_line(polygon[0], polygon[2], Color(0.80, 0.90, 1.0, 0.12), 1.2)


func _draw_warning_chevrons(area: Rect2, stripe_color: Color, shadow_color: Color, stripe_width: float) -> void:
	if area.size.x <= 0.0 or area.size.y <= 0.0 or stripe_width <= 0.0:
		return
	draw_rect(area, shadow_color)
	var stripe_count := int(ceil((area.size.x + area.size.y) / stripe_width)) + 2
	for stripe_index in range(stripe_count):
		var x0 := area.position.x + float(stripe_index) * stripe_width - area.size.y
		var stripe := PackedVector2Array([
			Vector2(x0, area.position.y),
			Vector2(x0 + stripe_width * 0.56, area.position.y),
			Vector2(x0 + area.size.y + stripe_width * 0.56, area.position.y + area.size.y),
			Vector2(x0 + area.size.y, area.position.y + area.size.y),
		])
		draw_colored_polygon(stripe, stripe_color)


func _spawn_obstacles() -> void:
	var rng := _make_rng(307)
	for spec_variant in _build_obstacle_specs(rng):
		var spec: Dictionary = spec_variant
		var block_size: Vector2 = spec.get("size", Vector2(260.0, 72.0))
		var local_position: Vector2 = spec.get("position", chunk_size * 0.5)
		var global_center := position + local_position
		if global_center.length() < ORIGIN_CLEAR_RADIUS:
			continue

		var block := PlatformBlock.new()
		block.position = local_position
		block.configure(
			block_size,
			spec.get("body", ground_mid.lightened(0.10)),
			spec.get("top", accent_color.lightened(0.12)),
			{
				"detail_color": spec.get("detail", ground_dark.lightened(0.12)),
				"glow_color": spec.get("glow", Color(accent_color.r, accent_color.g, accent_color.b, 0.24)),
				"style_id": style_id,
				"variant": String(spec.get("variant", "slab")),
			}
		)
		add_child(block)


func _build_obstacle_specs(rng: RandomNumberGenerator) -> Array[Dictionary]:
	var colors := _get_obstacle_palette()
	var specs: Array[Dictionary] = []
	match style_id:
		"bridge_train":
			specs = _build_bridge_train_specs(rng, colors)
		"black_fog_hunt":
			specs = _build_black_fog_specs(rng, colors)
		"airship_breach":
			specs = _build_airship_specs(rng, colors)
		"ember_forge":
			specs = _build_ember_specs(rng, colors)
		"void_marsh":
			specs = _build_void_specs(rng, colors)
		"prism_archive":
			specs = _build_prism_specs(rng, colors)
		"clockwork_garden":
			specs = _build_clock_specs(rng, colors)
		_:
			specs = _build_sky_specs(rng, colors)
	return _jitter_obstacle_specs(specs, rng)


func _get_obstacle_palette() -> Dictionary:
	match style_id:
		"bridge_train":
			return {
				"body": Color(0.28, 0.29, 0.32),
				"top": Color(0.96, 0.78, 0.34),
				"detail": Color(0.10, 0.11, 0.14),
				"glow": Color(1.0, 0.86, 0.42, 0.26),
			}
		"black_fog_hunt":
			return {
				"body": Color(0.08, 0.10, 0.12),
				"top": Color(0.72, 0.90, 0.82),
				"detail": Color(0.03, 0.04, 0.06),
				"glow": Color(0.76, 0.98, 0.88, 0.20),
			}
		"airship_breach":
			return {
				"body": Color(0.24, 0.28, 0.34),
				"top": Color(0.82, 0.94, 1.0),
				"detail": Color(0.08, 0.11, 0.15),
				"glow": Color(0.86, 0.96, 1.0, 0.26),
			}
		"ember_forge":
			return {
				"body": Color(0.34, 0.22, 0.18),
				"top": Color(0.92, 0.52, 0.22),
				"detail": Color(0.16, 0.10, 0.10),
				"glow": Color(1.0, 0.72, 0.36, 0.22),
			}
		"void_marsh":
			return {
				"body": Color(0.16, 0.24, 0.18),
				"top": Color(0.54, 0.82, 0.52),
				"detail": Color(0.08, 0.14, 0.10),
				"glow": Color(0.66, 0.84, 0.74, 0.20),
			}
		"prism_archive":
			return {
				"body": Color(0.24, 0.30, 0.40),
				"top": Color(0.80, 0.94, 1.0),
				"detail": Color(0.10, 0.14, 0.22),
				"glow": Color(0.82, 0.98, 1.0, 0.24),
			}
		"clockwork_garden":
			return {
				"body": Color(0.28, 0.30, 0.24),
				"top": Color(0.92, 0.82, 0.44),
				"detail": Color(0.14, 0.16, 0.12),
				"glow": Color(0.96, 0.88, 0.56, 0.22),
			}
		_:
			return {
				"body": Color(0.20, 0.25, 0.32),
				"top": Color(0.50, 0.80, 1.0),
				"detail": Color(0.10, 0.14, 0.20),
				"glow": Color(0.74, 0.92, 1.0, 0.22),
			}


func _build_sky_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(280.0, 280.0), Vector2(236.0, 152.0), "sky_relay", colors),
				_make_obstacle_spec(Vector2(760.0, 360.0), Vector2(420.0, 74.0), "bridge", colors),
				_make_obstacle_spec(Vector2(1210.0, 300.0), Vector2(250.0, 164.0), "sky_shrine", colors),
				_make_obstacle_spec(Vector2(450.0, 1020.0), Vector2(360.0, 72.0), "bridge", colors),
				_make_obstacle_spec(Vector2(1110.0, 1120.0), Vector2(280.0, 84.0), "altar", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(360.0, 420.0), Vector2(320.0, 72.0), "bridge", colors),
				_make_obstacle_spec(Vector2(1000.0, 330.0), Vector2(320.0, 72.0), "bridge", colors),
				_make_obstacle_spec(Vector2(780.0, 760.0), Vector2(220.0, 168.0), "altar", colors),
				_make_obstacle_spec(Vector2(260.0, 1180.0), Vector2(232.0, 146.0), "sky_relay", colors),
				_make_obstacle_spec(Vector2(1300.0, 1120.0), Vector2(246.0, 154.0), "sky_shrine", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(300.0, 300.0), Vector2(238.0, 150.0), "sky_shrine", colors),
				_make_obstacle_spec(Vector2(1260.0, 360.0), Vector2(230.0, 150.0), "sky_relay", colors),
				_make_obstacle_spec(Vector2(520.0, 760.0), Vector2(420.0, 72.0), "bridge", colors),
				_make_obstacle_spec(Vector2(1070.0, 860.0), Vector2(360.0, 70.0), "bridge", colors),
				_make_obstacle_spec(Vector2(790.0, 1250.0), Vector2(300.0, 86.0), "altar", colors),
			]
	if rng.randf() < 0.7:
		specs.append(_make_obstacle_spec(Vector2(770.0, 118.0 + rng.randf_range(0.0, 80.0)), Vector2(230.0, 62.0), "bridge", colors))
	return specs


func _build_ember_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(360.0, 340.0), Vector2(420.0, 88.0), "forge_wall", colors),
				_make_obstacle_spec(Vector2(1240.0, 360.0), Vector2(280.0, 88.0), "slag_bin", colors),
				_make_obstacle_spec(Vector2(820.0, 760.0), Vector2(240.0, 160.0), "forge_tank", colors),
				_make_obstacle_spec(Vector2(360.0, 1150.0), Vector2(280.0, 92.0), "slag_bin", colors),
				_make_obstacle_spec(Vector2(1220.0, 1110.0), Vector2(360.0, 90.0), "forge_wall", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(280.0, 360.0), Vector2(232.0, 156.0), "forge_crane", colors),
				_make_obstacle_spec(Vector2(790.0, 300.0), Vector2(420.0, 86.0), "forge_wall", colors),
				_make_obstacle_spec(Vector2(1300.0, 340.0), Vector2(238.0, 162.0), "forge_tank", colors),
				_make_obstacle_spec(Vector2(520.0, 980.0), Vector2(320.0, 94.0), "slag_bin", colors),
				_make_obstacle_spec(Vector2(1080.0, 1030.0), Vector2(320.0, 94.0), "slag_bin", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(440.0, 300.0), Vector2(260.0, 86.0), "forge_wall", colors),
				_make_obstacle_spec(Vector2(1120.0, 300.0), Vector2(260.0, 86.0), "forge_wall", colors),
				_make_obstacle_spec(Vector2(300.0, 780.0), Vector2(236.0, 164.0), "forge_tank", colors),
				_make_obstacle_spec(Vector2(1280.0, 780.0), Vector2(236.0, 164.0), "forge_crane", colors),
				_make_obstacle_spec(Vector2(790.0, 1180.0), Vector2(420.0, 96.0), "slag_bin", colors),
			]
	if rng.randf() < 0.6:
		specs.append(_make_obstacle_spec(Vector2(780.0 + rng.randf_range(-120.0, 120.0), 520.0), Vector2(200.0, 78.0), "forge_wall", colors))
	return specs


func _build_void_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(340.0, 340.0), Vector2(300.0, 80.0), "reed_bank", colors),
				_make_obstacle_spec(Vector2(1100.0, 320.0), Vector2(240.0, 88.0), "altar", colors),
				_make_obstacle_spec(Vector2(760.0, 760.0), Vector2(232.0, 162.0), "bog_tree", colors),
				_make_obstacle_spec(Vector2(390.0, 1160.0), Vector2(280.0, 82.0), "reed_bank", colors),
				_make_obstacle_spec(Vector2(1180.0, 1080.0), Vector2(300.0, 88.0), "altar", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(270.0, 360.0), Vector2(222.0, 150.0), "spore_pod", colors),
				_make_obstacle_spec(Vector2(780.0, 340.0), Vector2(360.0, 82.0), "reed_bank", colors),
				_make_obstacle_spec(Vector2(1310.0, 360.0), Vector2(230.0, 154.0), "bog_tree", colors),
				_make_obstacle_spec(Vector2(490.0, 930.0), Vector2(260.0, 84.0), "altar", colors),
				_make_obstacle_spec(Vector2(1080.0, 1100.0), Vector2(360.0, 84.0), "reed_bank", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(420.0, 280.0), Vector2(260.0, 84.0), "altar", colors),
				_make_obstacle_spec(Vector2(1180.0, 340.0), Vector2(300.0, 80.0), "reed_bank", colors),
				_make_obstacle_spec(Vector2(320.0, 820.0), Vector2(224.0, 158.0), "bog_tree", colors),
				_make_obstacle_spec(Vector2(1240.0, 860.0), Vector2(230.0, 156.0), "spore_pod", colors),
				_make_obstacle_spec(Vector2(790.0, 1190.0), Vector2(300.0, 88.0), "altar", colors),
			]
	if rng.randf() < 0.7:
		specs.append(_make_obstacle_spec(Vector2(780.0, 600.0 + rng.randf_range(-90.0, 90.0)), Vector2(240.0, 76.0), "reed_bank", colors))
	return specs


func _build_prism_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(320.0, 320.0), Vector2(236.0, 158.0), "prism_cluster", colors),
				_make_obstacle_spec(Vector2(820.0, 320.0), Vector2(360.0, 90.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(1260.0, 320.0), Vector2(260.0, 152.0), "prism_shelf", colors),
				_make_obstacle_spec(Vector2(480.0, 1020.0), Vector2(320.0, 84.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(1120.0, 1120.0), Vector2(240.0, 156.0), "prism_cluster", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(280.0, 360.0), Vector2(228.0, 150.0), "prism_shelf", colors),
				_make_obstacle_spec(Vector2(780.0, 360.0), Vector2(420.0, 86.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(1320.0, 360.0), Vector2(224.0, 154.0), "prism_cluster", colors),
				_make_obstacle_spec(Vector2(520.0, 920.0), Vector2(260.0, 84.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(1080.0, 1120.0), Vector2(360.0, 86.0), "prism_shelf", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(400.0, 300.0), Vector2(240.0, 160.0), "prism_cluster", colors),
				_make_obstacle_spec(Vector2(1180.0, 300.0), Vector2(240.0, 160.0), "prism_cluster", colors),
				_make_obstacle_spec(Vector2(320.0, 820.0), Vector2(260.0, 156.0), "prism_shelf", colors),
				_make_obstacle_spec(Vector2(1240.0, 820.0), Vector2(260.0, 156.0), "prism_shelf", colors),
				_make_obstacle_spec(Vector2(790.0, 1180.0), Vector2(360.0, 90.0), "archive_gate", colors),
			]
	if rng.randf() < 0.7:
		specs.append(_make_obstacle_spec(Vector2(780.0, 600.0 + rng.randf_range(-90.0, 90.0)), Vector2(220.0, 144.0), "prism_cluster", colors))
	return specs


func _build_clock_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(320.0, 320.0), Vector2(300.0, 88.0), "gear_bed", colors),
				_make_obstacle_spec(Vector2(1100.0, 320.0), Vector2(232.0, 156.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(760.0, 760.0), Vector2(360.0, 88.0), "clock_arbor", colors),
				_make_obstacle_spec(Vector2(420.0, 1120.0), Vector2(280.0, 88.0), "gear_bed", colors),
				_make_obstacle_spec(Vector2(1180.0, 1080.0), Vector2(236.0, 154.0), "clock_column", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(280.0, 360.0), Vector2(228.0, 154.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(800.0, 320.0), Vector2(360.0, 90.0), "gear_bed", colors),
				_make_obstacle_spec(Vector2(1320.0, 360.0), Vector2(240.0, 156.0), "clock_arbor", colors),
				_make_obstacle_spec(Vector2(520.0, 920.0), Vector2(260.0, 88.0), "gear_bed", colors),
				_make_obstacle_spec(Vector2(1080.0, 1120.0), Vector2(360.0, 88.0), "clock_arbor", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(420.0, 300.0), Vector2(260.0, 88.0), "clock_arbor", colors),
				_make_obstacle_spec(Vector2(1180.0, 300.0), Vector2(260.0, 88.0), "clock_arbor", colors),
				_make_obstacle_spec(Vector2(320.0, 820.0), Vector2(232.0, 154.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(1240.0, 820.0), Vector2(232.0, 154.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(790.0, 1180.0), Vector2(320.0, 92.0), "gear_bed", colors),
			]
	if rng.randf() < 0.7:
		specs.append(_make_obstacle_spec(Vector2(780.0, 620.0 + rng.randf_range(-80.0, 80.0)), Vector2(220.0, 80.0), "gear_bed", colors))
	return specs


func _build_bridge_train_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(320.0, 300.0), Vector2(360.0, 86.0), "bridge", colors),
				_make_obstacle_spec(Vector2(1190.0, 320.0), Vector2(320.0, 90.0), "forge_wall", colors),
				_make_obstacle_spec(Vector2(780.0, 700.0), Vector2(240.0, 168.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(430.0, 1090.0), Vector2(300.0, 88.0), "slag_bin", colors),
				_make_obstacle_spec(Vector2(1140.0, 1090.0), Vector2(300.0, 88.0), "bridge", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(260.0, 360.0), Vector2(228.0, 160.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(790.0, 320.0), Vector2(420.0, 88.0), "bridge", colors),
				_make_obstacle_spec(Vector2(1320.0, 360.0), Vector2(232.0, 156.0), "forge_wall", colors),
				_make_obstacle_spec(Vector2(520.0, 930.0), Vector2(320.0, 90.0), "slag_bin", colors),
				_make_obstacle_spec(Vector2(1080.0, 1110.0), Vector2(360.0, 92.0), "bridge", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(400.0, 300.0), Vector2(280.0, 88.0), "bridge", colors),
				_make_obstacle_spec(Vector2(1180.0, 300.0), Vector2(280.0, 88.0), "bridge", colors),
				_make_obstacle_spec(Vector2(320.0, 780.0), Vector2(232.0, 160.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(1240.0, 820.0), Vector2(236.0, 160.0), "clock_column", colors),
				_make_obstacle_spec(Vector2(790.0, 1180.0), Vector2(360.0, 90.0), "forge_wall", colors),
			]
	if rng.randf() < 0.72:
		specs.append(_make_obstacle_spec(Vector2(780.0, 560.0 + rng.randf_range(-90.0, 90.0)), Vector2(240.0, 82.0), "bridge", colors))
	return specs


func _build_black_fog_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(320.0, 320.0), Vector2(286.0, 82.0), "reed_bank", colors),
				_make_obstacle_spec(Vector2(1120.0, 320.0), Vector2(230.0, 156.0), "bog_tree", colors),
				_make_obstacle_spec(Vector2(760.0, 760.0), Vector2(228.0, 160.0), "spore_pod", colors),
				_make_obstacle_spec(Vector2(440.0, 1110.0), Vector2(300.0, 86.0), "altar", colors),
				_make_obstacle_spec(Vector2(1160.0, 1090.0), Vector2(280.0, 86.0), "reed_bank", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(270.0, 340.0), Vector2(226.0, 154.0), "bog_tree", colors),
				_make_obstacle_spec(Vector2(800.0, 320.0), Vector2(390.0, 84.0), "reed_bank", colors),
				_make_obstacle_spec(Vector2(1320.0, 360.0), Vector2(224.0, 154.0), "spore_pod", colors),
				_make_obstacle_spec(Vector2(500.0, 920.0), Vector2(260.0, 84.0), "altar", colors),
				_make_obstacle_spec(Vector2(1080.0, 1120.0), Vector2(360.0, 86.0), "reed_bank", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(410.0, 300.0), Vector2(260.0, 86.0), "altar", colors),
				_make_obstacle_spec(Vector2(1180.0, 320.0), Vector2(286.0, 82.0), "reed_bank", colors),
				_make_obstacle_spec(Vector2(300.0, 820.0), Vector2(230.0, 156.0), "bog_tree", colors),
				_make_obstacle_spec(Vector2(1240.0, 840.0), Vector2(226.0, 154.0), "spore_pod", colors),
				_make_obstacle_spec(Vector2(790.0, 1190.0), Vector2(320.0, 88.0), "reed_bank", colors),
			]
	if rng.randf() < 0.76:
		specs.append(_make_obstacle_spec(Vector2(780.0, 620.0 + rng.randf_range(-88.0, 88.0)), Vector2(220.0, 80.0), "altar", colors))
	return specs


func _build_airship_specs(rng: RandomNumberGenerator, colors: Dictionary) -> Array[Dictionary]:
	var layout := rng.randi_range(0, 2)
	var specs: Array[Dictionary] = []
	match layout:
		0:
			specs = [
				_make_obstacle_spec(Vector2(320.0, 300.0), Vector2(320.0, 90.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(1160.0, 320.0), Vector2(230.0, 156.0), "sky_relay", colors),
				_make_obstacle_spec(Vector2(760.0, 760.0), Vector2(360.0, 88.0), "prism_shelf", colors),
				_make_obstacle_spec(Vector2(420.0, 1080.0), Vector2(260.0, 154.0), "clock_arbor", colors),
				_make_obstacle_spec(Vector2(1180.0, 1090.0), Vector2(320.0, 92.0), "archive_gate", colors),
			]
		1:
			specs = [
				_make_obstacle_spec(Vector2(280.0, 360.0), Vector2(228.0, 154.0), "sky_relay", colors),
				_make_obstacle_spec(Vector2(780.0, 340.0), Vector2(420.0, 88.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(1320.0, 360.0), Vector2(236.0, 154.0), "clock_arbor", colors),
				_make_obstacle_spec(Vector2(520.0, 920.0), Vector2(260.0, 88.0), "prism_shelf", colors),
				_make_obstacle_spec(Vector2(1080.0, 1120.0), Vector2(360.0, 88.0), "archive_gate", colors),
			]
		_:
			specs = [
				_make_obstacle_spec(Vector2(400.0, 300.0), Vector2(260.0, 90.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(1180.0, 300.0), Vector2(260.0, 90.0), "archive_gate", colors),
				_make_obstacle_spec(Vector2(320.0, 820.0), Vector2(230.0, 154.0), "sky_relay", colors),
				_make_obstacle_spec(Vector2(1240.0, 820.0), Vector2(230.0, 154.0), "clock_arbor", colors),
				_make_obstacle_spec(Vector2(790.0, 1180.0), Vector2(320.0, 92.0), "prism_shelf", colors),
			]
	if rng.randf() < 0.70:
		specs.append(_make_obstacle_spec(Vector2(780.0, 600.0 + rng.randf_range(-86.0, 86.0)), Vector2(220.0, 82.0), "archive_gate", colors))
	return specs


func _make_obstacle_spec(local_position: Vector2, block_size: Vector2, variant_name: String, colors: Dictionary) -> Dictionary:
	return {
		"position": local_position,
		"size": block_size,
		"variant": variant_name,
		"body": colors.get("body", ground_mid.lightened(0.10)),
		"top": colors.get("top", accent_color.lightened(0.10)),
		"detail": colors.get("detail", ground_dark.lightened(0.10)),
		"glow": colors.get("glow", Color(accent_color.r, accent_color.g, accent_color.b, 0.20)),
	}


func _jitter_obstacle_specs(specs: Array[Dictionary], rng: RandomNumberGenerator) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for spec_variant in specs:
		var spec: Dictionary = spec_variant.duplicate(true)
		var block_size: Vector2 = spec.get("size", Vector2(260.0, 72.0))
		block_size.x = clampf(block_size.x + rng.randf_range(-18.0, 22.0), 96.0, chunk_size.x - OBSTACLE_MARGIN)
		block_size.y = clampf(block_size.y + rng.randf_range(-8.0, 12.0), 52.0, 320.0)
		var local_position: Vector2 = spec.get("position", chunk_size * 0.5)
		local_position += Vector2(rng.randf_range(-28.0, 28.0), rng.randf_range(-22.0, 22.0))
		local_position = _clamp_obstacle_position(local_position, block_size)
		spec["size"] = block_size
		spec["position"] = local_position
		result.append(spec)
	return result


func _clamp_obstacle_position(local_position: Vector2, block_size: Vector2) -> Vector2:
	return Vector2(
		clampf(local_position.x, block_size.x * 0.5 + 42.0, chunk_size.x - block_size.x * 0.5 - 42.0),
		clampf(local_position.y, block_size.y * 0.5 + 42.0, chunk_size.y - block_size.y * 0.5 - 42.0)
	)


func _make_rng(salt: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(hash([chunk_coord.x, chunk_coord.y, salt]))
	return rng
