extends Node2D
class_name ExperienceOrb

signal collected(orb, value)

var value: int = 1
var target: Player = null

var _velocity: Vector2 = Vector2.ZERO


func configure(player_target: Player, orb_value: int) -> void:
	target = player_target
	value = max(1, orb_value)


func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return

	var to_player := target.global_position - global_position
	var distance := to_player.length()
	var pickup_radius := target.get_pickup_radius()
	if distance <= pickup_radius and distance > 0.0:
		var pull_speed := maxf(220.0, distance * 4.2)
		_velocity = _velocity.lerp(to_player.normalized() * pull_speed, clampf(delta * 4.8, 0.0, 1.0))
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, 200.0 * delta)

	global_position += _velocity * delta
	if distance <= target.get_body_radius() + 10.0:
		collected.emit(self, value)
		queue_free()
		return


func _draw() -> void:
	var color := Color(0.44, 0.94, 1.0)
	if value >= 4:
		color = Color(1.0, 0.84, 0.34)
	draw_circle(Vector2.ZERO, 12.0, Color(color.r, color.g, color.b, 0.22))
	draw_circle(Vector2.ZERO, 7.0, color)
	draw_circle(Vector2(0.0, -2.0), 3.0, Color(1.0, 1.0, 1.0, 0.58))
