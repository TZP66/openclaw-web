extends Node2D
class_name WorldBackground

const GRID_SPACING := 96.0
const GROUND_CELL := Vector2(560.0, 420.0)
const TILE_CELL := Vector2(320.0, 256.0)
const RUNE_CELL := Vector2(720.0, 560.0)
const REDRAW_CAMERA_STEP := 1.0

var camera: Camera2D = null
var ground_dark: Color = Color(0.05, 0.08, 0.10)
var ground_mid: Color = Color(0.08, 0.13, 0.16)
var line_color: Color = Color(0.16, 0.26, 0.30, 0.55)
var rune_color: Color = Color(0.44, 0.86, 1.0, 0.18)
var ember_color: Color = Color(0.96, 0.82, 0.36, 0.12)

var _viewport_size: Vector2 = Vector2.ZERO
var _last_camera_anchor: Vector2 = Vector2.INF


func set_camera(target_camera: Camera2D) -> void:
	camera = target_camera
	_viewport_size = get_viewport_rect().size
	_last_camera_anchor = Vector2.INF
	queue_redraw()


func set_palette(palette: Dictionary) -> void:
	ground_dark = palette.get("ground_dark", ground_dark)
	ground_mid = palette.get("ground_mid", ground_mid)
	line_color = palette.get("line_color", line_color)
	rune_color = palette.get("rune_color", rune_color)
	ember_color = palette.get("ember_color", ember_color)
	queue_redraw()


func _process(_delta: float) -> void:
	var current_viewport: Vector2 = get_viewport_rect().size
	var camera_anchor := _get_camera_anchor()
	if current_viewport != _viewport_size or camera_anchor.distance_to(_last_camera_anchor) >= REDRAW_CAMERA_STEP:
		_viewport_size = current_viewport
		_last_camera_anchor = camera_anchor
		queue_redraw()


func _draw() -> void:
	var viewport_size := _viewport_size
	if viewport_size == Vector2.ZERO:
		viewport_size = get_viewport_rect().size

	var camera_anchor := _get_camera_anchor()
	var top_left := camera_anchor - viewport_size * 0.5
	var bottom_right := top_left + viewport_size

	draw_rect(Rect2(top_left, viewport_size), ground_dark)
	_draw_ground_fields(top_left, bottom_right)
	_draw_grid(top_left, bottom_right)
	_draw_tiles(top_left, bottom_right)
	_draw_runes(top_left, bottom_right)
	_draw_embers(top_left, bottom_right)


func _draw_ground_fields(top_left: Vector2, bottom_right: Vector2) -> void:
	var start_col := int(floor(top_left.x / GROUND_CELL.x)) - 1
	var end_col := int(ceil(bottom_right.x / GROUND_CELL.x)) + 1
	var start_row := int(floor(top_left.y / GROUND_CELL.y)) - 1
	var end_row := int(ceil(bottom_right.y / GROUND_CELL.y)) + 1

	for row in range(start_row, end_row + 1):
		for col in range(start_col, end_col + 1):
			var variant := abs((row * 19 + col * 23) % 5)
			var cell_origin := Vector2(float(col) * GROUND_CELL.x, float(row) * GROUND_CELL.y)
			var inset := Vector2(38.0 + float(variant % 3) * 18.0, 32.0 + float(abs((row - col) % 3)) * 14.0)
			var plate_rect := Rect2(cell_origin + inset, GROUND_CELL - inset * 2.0)
			var plate_color := ground_mid.darkened(0.08 * float(abs((row + col) % 2)))
			if variant == 0:
				plate_color = ground_mid.lightened(0.08)
			draw_rect(plate_rect, Color(plate_color.r, plate_color.g, plate_color.b, 0.34))
			draw_rect(plate_rect.grow(-12.0), Color(ground_dark.r, ground_dark.g, ground_dark.b, 0.22))

			if abs((row + col) % 2) == 0:
				var lane_height := 26.0 + float(variant) * 2.0
				var lane_y := cell_origin.y + GROUND_CELL.y * 0.5 - lane_height * 0.5 + float((variant - 2) * 6)
				var lane_rect := Rect2(Vector2(cell_origin.x + 24.0, lane_y), Vector2(GROUND_CELL.x - 48.0, lane_height))
				draw_rect(lane_rect, Color(line_color.r, line_color.g, line_color.b, 0.14))


func _draw_grid(top_left: Vector2, bottom_right: Vector2) -> void:
	var start_x := floor(top_left.x / GRID_SPACING) * GRID_SPACING
	var end_x := ceil(bottom_right.x / GRID_SPACING) * GRID_SPACING
	var start_y := floor(top_left.y / GRID_SPACING) * GRID_SPACING
	var end_y := ceil(bottom_right.y / GRID_SPACING) * GRID_SPACING

	var x := start_x
	while x <= end_x:
		draw_line(Vector2(x, start_y), Vector2(x, end_y), line_color, 1.2)
		x += GRID_SPACING

	var y := start_y
	while y <= end_y:
		draw_line(Vector2(start_x, y), Vector2(end_x, y), line_color, 1.2)
		y += GRID_SPACING


func _draw_tiles(top_left: Vector2, bottom_right: Vector2) -> void:
	var start_col := int(floor(top_left.x / TILE_CELL.x)) - 1
	var end_col := int(ceil(bottom_right.x / TILE_CELL.x)) + 1
	var start_row := int(floor(top_left.y / TILE_CELL.y)) - 1
	var end_row := int(ceil(bottom_right.y / TILE_CELL.y)) + 1

	for row in range(start_row, end_row + 1):
		for col in range(start_col, end_col + 1):
			var parity := abs((row * 17 + col * 13) % 4)
			if parity == 1:
				continue
			var cell_origin := Vector2(float(col) * TILE_CELL.x, float(row) * TILE_CELL.y)
			var offset := Vector2(42.0 + float((row + col) & 1) * 34.0, 30.0 + float(abs((row * 3 + col) % 3)) * 22.0)
			var tile_size := Vector2(96.0 + float(parity % 2) * 34.0, 60.0)
			var tile_pos := cell_origin + offset
			draw_rect(Rect2(tile_pos, tile_size), Color(0.12, 0.18, 0.21, 0.22))
			draw_rect(Rect2(tile_pos + Vector2(6.0, 6.0), tile_size - Vector2(12.0, 12.0)), Color(0.07, 0.10, 0.12, 0.16))


func _draw_runes(top_left: Vector2, bottom_right: Vector2) -> void:
	var start_col := int(floor(top_left.x / RUNE_CELL.x)) - 1
	var end_col := int(ceil(bottom_right.x / RUNE_CELL.x)) + 1
	var start_row := int(floor(top_left.y / RUNE_CELL.y)) - 1
	var end_row := int(ceil(bottom_right.y / RUNE_CELL.y)) + 1

	for row in range(start_row, end_row + 1):
		for col in range(start_col, end_col + 1):
			var center := Vector2(float(col) * RUNE_CELL.x + 180.0 + float((row & 1) * 110), float(row) * RUNE_CELL.y + 160.0 + float(abs(col % 3)) * 56.0)
			draw_circle(center, 44.0, rune_color)
			draw_arc(center, 44.0, 0.0, TAU, 36, Color(rune_color.r, rune_color.g, rune_color.b, 0.54), 2.0)
			draw_arc(center, 24.0, 0.0, TAU, 20, Color(ember_color.r, ember_color.g, ember_color.b, 0.74), 1.8)
			for angle_index in range(6):
				var angle := TAU * float(angle_index) / 6.0
				var direction := Vector2.RIGHT.rotated(angle)
				draw_line(center + direction * 12.0, center + direction * 30.0, Color(0.98, 0.92, 0.56, 0.34), 1.4)


func _draw_embers(top_left: Vector2, bottom_right: Vector2) -> void:
	var spacing := 180.0
	var start_col := int(floor(top_left.x / spacing)) - 1
	var end_col := int(ceil(bottom_right.x / spacing)) + 1
	var start_row := int(floor(top_left.y / spacing)) - 1
	var end_row := int(ceil(bottom_right.y / spacing)) + 1

	for row in range(start_row, end_row + 1):
		for col in range(start_col, end_col + 1):
			if ((row * 5 + col * 7) & 1) != 0:
				continue
			var dot := Vector2(float(col) * spacing + 72.0 + float(abs(row % 3)) * 18.0, float(row) * spacing + 54.0 + float(abs(col % 4)) * 12.0)
			draw_circle(dot, 3.0, ember_color)


func _get_camera_anchor() -> Vector2:
	if camera != null and is_instance_valid(camera):
		return camera.global_position
	return Vector2.ZERO
