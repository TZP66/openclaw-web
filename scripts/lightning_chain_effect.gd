extends Node2D
class_name LightningChainEffect

var duration: float = 0.14
var thickness: float = 8.0
var primary_color: Color = Color(0.74, 0.90, 1.0)
var secondary_color: Color = Color(0.34, 0.62, 1.0)

var _time: float = 0.0
var _points: PackedVector2Array = PackedVector2Array()


func configure_link(start_position: Vector2, end_position: Vector2, seed: int = 0) -> void:
	global_position = start_position
	var local_end := end_position - start_position
	var length := local_end.length()
	if length <= 0.001:
		_points = PackedVector2Array([Vector2.ZERO, Vector2.ZERO])
		queue_redraw()
		return

	var direction := local_end / length
	var normal := direction.orthogonal()
	var rng := RandomNumberGenerator.new()
	rng.seed = int(seed)
	var point_count := maxi(4, mini(8, int(round(length / 64.0)) + 3))
	_points.clear()
	_points.append(Vector2.ZERO)
	for index in range(1, point_count - 1):
		var t := float(index) / float(point_count - 1)
		var offset_strength := sin(t * PI) * clampf(length * 0.14, 10.0, 28.0)
		var offset := rng.randf_range(-offset_strength, offset_strength)
		_points.append(direction * (length * t) + normal * offset)
	_points.append(local_end)
	queue_redraw()


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()
	if _time >= duration:
		queue_free()


func _draw() -> void:
	if _points.size() < 2:
		return

	var fade := 1.0 - clampf(_time / maxf(duration, 0.001), 0.0, 1.0)
	var glow_width := thickness * 1.7
	var core_width := thickness
	var accent_width := maxf(2.0, thickness * 0.34)

	draw_polyline(_points, Color(primary_color.r, primary_color.g, primary_color.b, fade * 0.26), glow_width, true)
	draw_polyline(_points, Color(secondary_color.r, secondary_color.g, secondary_color.b, fade * 0.90), core_width, true)
	draw_polyline(_points, Color(1.0, 1.0, 1.0, fade * 0.88), accent_width, true)

	for point in _points:
		draw_circle(point, thickness * 0.18, Color(1.0, 1.0, 1.0, fade * 0.72))
