extends Area2D
class_name WeaponPickup

signal collected(pickup, weapon_key, weapon_name)

var weapon_key: String = "spread"
var weapon_name: String = "散射枪"
var pickup_color: Color = Color(0.29, 0.78, 1.0)

var _shape_node: CollisionShape2D
var _pulse: float = 0.0


func _ready() -> void:
	collision_layer = 8
	collision_mask = 1
	monitoring = true
	_ensure_shape()
	body_entered.connect(_on_body_entered)


func setup(new_weapon_key: String, new_weapon_name: String, color: Color) -> void:
	weapon_key = new_weapon_key
	weapon_name = new_weapon_name
	pickup_color = color
	if is_inside_tree():
		queue_redraw()


func _process(delta: float) -> void:
	_pulse += delta
	queue_redraw()


func _draw() -> void:
	var bob := sin(_pulse * 3.0) * 4.0
	var center := Vector2(0.0, bob)
	draw_circle(center, 22.0, _with_alpha(pickup_color, 0.18))
	draw_circle(center, 14.0, pickup_color)
	draw_circle(center, 6.0, Color(0.97, 0.98, 1.0))

	match weapon_key:
		"spread":
			draw_line(center + Vector2(-12.0, 4.0), center + Vector2(12.0, -8.0), Color(1.0, 0.99, 1.0), 3.0)
			draw_line(center + Vector2(-12.0, 4.0), center + Vector2(12.0, 0.0), Color(1.0, 0.99, 1.0), 3.0)
			draw_line(center + Vector2(-12.0, 4.0), center + Vector2(12.0, 8.0), Color(1.0, 0.99, 1.0), 3.0)
		"rapid":
			draw_rect(Rect2(center + Vector2(-10.0, -8.0), Vector2(6.0, 16.0)), Color(1.0, 0.99, 1.0))
			draw_rect(Rect2(center + Vector2(2.0, -8.0), Vector2(6.0, 16.0)), Color(1.0, 0.99, 1.0))
			draw_rect(Rect2(center + Vector2(14.0, -8.0), Vector2(6.0, 16.0)), Color(1.0, 0.99, 1.0))
		"power":
			var points := PackedVector2Array([
				center + Vector2(-10.0, 8.0),
				center + Vector2(0.0, -12.0),
				center + Vector2(10.0, 8.0),
			])
			draw_colored_polygon(points, Color(1.0, 0.99, 1.0))
		_:
			draw_line(center + Vector2(-10.0, 0.0), center + Vector2(10.0, 0.0), Color(1.0, 0.99, 1.0), 3.0)


func _ensure_shape() -> void:
	_shape_node = get_node_or_null("CollisionShape2D")
	if _shape_node == null:
		_shape_node = CollisionShape2D.new()
		_shape_node.name = "CollisionShape2D"
		add_child(_shape_node)
	var shape := CircleShape2D.new()
	shape.radius = 18.0
	_shape_node.shape = shape


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("apply_weapon_pickup"):
			body.apply_weapon_pickup(weapon_key)
		collected.emit(self, weapon_key, weapon_name)
		queue_free()


func _with_alpha(color: Color, alpha: float) -> Color:
	return Color(color.r, color.g, color.b, alpha)

