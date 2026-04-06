extends Node
class_name GameAudio

const SAMPLE_RATE := 22050

var _streams: Dictionary = {}
var _master_volume_ratio: float = 1.0


func _ready() -> void:
	_build_streams()


func set_master_volume_ratio(value: float) -> void:
	_master_volume_ratio = clampf(value, 0.0, 1.0)


func get_master_volume_ratio() -> float:
	return _master_volume_ratio


func play_player_shot(weapon_key: String) -> void:
	match weapon_key:
		"spread":
			_play_stream("shot_spread", randf_range(0.98, 1.04), -10.0)
		"rapid":
			_play_stream("shot_rapid", randf_range(1.02, 1.08), -12.0)
		"power":
			_play_stream("shot_power", randf_range(0.96, 1.01), -8.0)
		_:
			_play_stream("shot_rifle", randf_range(0.99, 1.04), -10.5)


func play_enemy_shot(is_boss: bool = false) -> void:
	if is_boss:
		_play_stream("shot_boss", randf_range(0.97, 1.02), -6.0)
	else:
		_play_stream("shot_enemy", randf_range(0.98, 1.04), -11.0)


func play_damage(is_player: bool, is_boss: bool = false) -> void:
	if is_boss:
		_play_stream("hit_boss", randf_range(0.97, 1.03), -8.0)
	elif is_player:
		_play_stream("hit_player", randf_range(0.99, 1.04), -10.0)
	else:
		_play_stream("hit_enemy", randf_range(0.98, 1.05), -12.0)


func play_kill(is_boss: bool = false) -> void:
	if is_boss:
		_play_stream("kill_boss", randf_range(0.99, 1.02), -5.0)
	else:
		_play_stream("kill_enemy", randf_range(1.00, 1.05), -9.0)


func play_pickup() -> void:
	_play_stream("pickup", randf_range(0.99, 1.03), -10.0)


func _build_streams() -> void:
	_streams["shot_rifle"] = _create_wave(0.08, 860.0, 560.0, 0.78, 1, 0.08, 2.6)
	_streams["shot_spread"] = _create_wave(0.10, 720.0, 420.0, 0.76, 2, 0.12, 2.1)
	_streams["shot_rapid"] = _create_wave(0.05, 1140.0, 780.0, 0.62, 1, 0.06, 2.8)
	_streams["shot_power"] = _create_wave(0.14, 420.0, 180.0, 0.88, 3, 0.18, 1.8)
	_streams["shot_enemy"] = _create_wave(0.09, 540.0, 300.0, 0.66, 1, 0.12, 2.2)
	_streams["shot_boss"] = _create_wave(0.18, 260.0, 90.0, 0.92, 3, 0.22, 1.5)
	_streams["hit_player"] = _create_wave(0.10, 320.0, 180.0, 0.72, 2, 0.28, 1.7)
	_streams["hit_enemy"] = _create_wave(0.07, 460.0, 240.0, 0.58, 1, 0.24, 2.3)
	_streams["hit_boss"] = _create_wave(0.14, 180.0, 70.0, 0.92, 3, 0.32, 1.4)
	_streams["kill_enemy"] = _create_wave(0.16, 420.0, 100.0, 0.86, 2, 0.34, 1.5)
	_streams["kill_boss"] = _create_wave(0.34, 180.0, 36.0, 1.0, 3, 0.38, 1.2)
	_streams["pickup"] = _create_wave(0.12, 520.0, 960.0, 0.60, 2, 0.02, 2.6)


func _play_stream(key: String, pitch_scale: float, volume_db: float) -> void:
	if not _streams.has(key):
		return
	if _master_volume_ratio <= 0.001:
		return

	var player := AudioStreamPlayer.new()
	player.stream = _streams[key]
	player.pitch_scale = pitch_scale
	player.volume_db = volume_db + linear_to_db(_master_volume_ratio)
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()


func _create_wave(
	duration: float,
	start_frequency: float,
	end_frequency: float,
	amplitude: float,
	wave_type: int,
	noise_mix: float,
	decay_power: float
) -> AudioStreamWAV:
	var sample_count: int = max(1, int(duration * SAMPLE_RATE))
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var phase: float = 0.0
	var rng := RandomNumberGenerator.new()
	rng.seed = int(duration * 100000.0 + start_frequency * 11.0 + end_frequency * 17.0 + wave_type * 101)

	for index in range(sample_count):
		var t: float = float(index) / float(max(sample_count - 1, 1))
		var frequency: float = lerpf(start_frequency, end_frequency, t)
		phase += TAU * frequency / float(SAMPLE_RATE)
		var base_sample: float = _sample_wave(phase, wave_type)
		var noise_sample: float = rng.randf_range(-1.0, 1.0)
		var attack: float = min(1.0, float(index) / max(1.0, SAMPLE_RATE * 0.004))
		var envelope: float = attack * pow(1.0 - t, decay_power)
		var mixed: float = lerpf(base_sample, noise_sample, noise_mix)
		var sample: float = clampf(mixed * amplitude * envelope, -1.0, 1.0)
		var value: int = int(round(sample * 32767.0))
		data[index * 2] = value & 0xFF
		data[index * 2 + 1] = (value >> 8) & 0xFF

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = data
	return stream


func _sample_wave(phase: float, wave_type: int) -> float:
	match wave_type:
		1:
			return 1.0 if sin(phase) >= 0.0 else -1.0
		2:
			return asin(sin(phase)) * (2.0 / PI)
		3:
			return (fposmod(phase, TAU) / PI) - 1.0
		_:
			return sin(phase)
