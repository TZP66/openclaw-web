extends Area2D
class_name GoalBeacon

signal player_reached

var goal_enabled: bool = false

var _shape_node: CollisionShape2D
var _pulse: float = 0.0


func _ready() -> void:
	collision_layer = 4
	collision_mask = 1
	monitoring = true
	_ensure_shape()
	body_entered.connect(_on_body_entered)


func set_goal_enabled(enabled: bool) -> void:
	goal_enabled = enabled
	queue_redraw()


func _process(delta: float) -> void:
	_pulse += delta
	queue_redraw()


func _draw() -> void:
	var bob := sin(_pulse * 3.2) * 4.0
	var pole_color := Color(0.70, 0.75, 0.86)
	var flag_color := Color(0.92, 0.33, 0.28) if goal_enabled else Color(0.34, 0.38, 0.44)
	var glow_color := Color(1.0, 0.85, 0.28) if goal_enabled else Color(0.54, 0.58, 0.66)

	draw_rect(Rect2(-8.0, -108.0, 16.0, 108.0), pole_color)
	draw_rect(Rect2(8.0, -98.0 + bob, 72.0, 28.0), flag_color)
	draw_rect(Rect2(-28.0, -2.0, 56.0, 12.0), Color(0.17, 0.19, 0.23))
	draw_circle(Vector2(0.0, -114.0), 8.0 + sin(_pulse * 4.0) * 1.2, glow_color)

	if not goal_enabled:
		draw_line(Vector2(-18.0, -90.0), Vector2(18.0, -54.0), Color(1.0, 0.78, 0.24), 5.0)


func _ensure_shape() -> void:
	_shape_node = get_node_or_null("CollisionShape2D")
	if _shape_node == null:
		_shape_node = CollisionShape2D.new()
		_shape_node.name = "CollisionShape2D"
		add_child(_shape_node)

	var shape := RectangleShape2D.new()
	shape.size = Vector2(96.0, 140.0)
	_shape_node.shape = shape
	_shape_node.position = Vector2(18.0, -60.0)


func _on_body_entered(body: Node) -> void:
	if goal_enabled and body.is_in_group("player"):
		player_reached.emit()
