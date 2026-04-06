extends Node2D
class_name WorldMap

const CHUNK_SIZE := Vector2(1600.0, 1600.0)
const ACTIVE_RADIUS := 2
const WORLD_CHUNK_SCRIPT := preload("res://scripts/world_chunk.gd")

var focus_target: Node2D = null
var ground_dark: Color = Color(0.05, 0.08, 0.10)
var ground_mid: Color = Color(0.08, 0.13, 0.16)
var line_color: Color = Color(0.16, 0.26, 0.30, 0.55)
var rune_color: Color = Color(0.44, 0.86, 1.0, 0.18)
var ember_color: Color = Color(0.96, 0.82, 0.36, 0.12)
var accent_color: Color = Color(0.82, 0.92, 1.0, 0.16)
var style_id: String = "sky_ruins"

var _loaded_center_chunk: Vector2i = Vector2i(999999, 999999)
var _loaded_chunks: Dictionary = {}


func _ready() -> void:
	z_index = -50
	_refresh_chunks(true)


func set_focus_target(target: Node2D) -> void:
	focus_target = target
	_loaded_center_chunk = Vector2i(999999, 999999)
	_refresh_chunks(true)


func set_palette(palette: Dictionary) -> void:
	ground_dark = palette.get("ground_dark", ground_dark)
	ground_mid = palette.get("ground_mid", ground_mid)
	line_color = palette.get("line_color", line_color)
	rune_color = palette.get("rune_color", rune_color)
	ember_color = palette.get("ember_color", ember_color)
	accent_color = palette.get("accent_color", accent_color)
	style_id = String(palette.get("style_id", style_id))

	for chunk in _loaded_chunks.values():
		if chunk != null and is_instance_valid(chunk):
			chunk.configure(chunk.chunk_coord, CHUNK_SIZE, _make_palette())


func _process(_delta: float) -> void:
	_refresh_chunks(false)


func _refresh_chunks(force: bool) -> void:
	var center_chunk := _world_to_chunk(_get_focus_position())
	if not force and center_chunk == _loaded_center_chunk:
		return

	_loaded_center_chunk = center_chunk
	var required_chunks: Dictionary = {}
	for chunk_y in range(center_chunk.y - ACTIVE_RADIUS, center_chunk.y + ACTIVE_RADIUS + 1):
		for chunk_x in range(center_chunk.x - ACTIVE_RADIUS, center_chunk.x + ACTIVE_RADIUS + 1):
			var coord := Vector2i(chunk_x, chunk_y)
			required_chunks[coord] = true
			if _loaded_chunks.has(coord):
				continue

			var chunk = WORLD_CHUNK_SCRIPT.new()
			chunk.position = Vector2(float(coord.x) * CHUNK_SIZE.x, float(coord.y) * CHUNK_SIZE.y)
			chunk.configure(coord, CHUNK_SIZE, _make_palette())
			add_child(chunk)
			_loaded_chunks[coord] = chunk

	var existing_coords: Array = _loaded_chunks.keys()
	for coord_variant in existing_coords:
		var coord: Vector2i = coord_variant
		if required_chunks.has(coord):
			continue

		var chunk = _loaded_chunks[coord]
		_loaded_chunks.erase(coord)
		if chunk != null and is_instance_valid(chunk):
			chunk.queue_free()


func _make_palette() -> Dictionary:
	return {
		"ground_dark": ground_dark,
		"ground_mid": ground_mid,
		"line_color": line_color,
		"rune_color": rune_color,
		"ember_color": ember_color,
		"accent_color": accent_color,
		"style_id": style_id,
	}


func _get_focus_position() -> Vector2:
	if focus_target != null and is_instance_valid(focus_target):
		return focus_target.global_position
	return Vector2.ZERO


func _world_to_chunk(world_position: Vector2) -> Vector2i:
	return Vector2i(
		int(floor(world_position.x / CHUNK_SIZE.x)),
		int(floor(world_position.y / CHUNK_SIZE.y))
	)
