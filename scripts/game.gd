extends Node2D

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	LEVEL_UP,
	GAME_OVER,
	VICTORY,
}

const WORLD_MAP_SCRIPT := preload("res://scripts/world_map.gd")
const PLAYER_SCRIPT := preload("res://scripts/player.gd")
const ENEMY_SCRIPT := preload("res://scripts/enemy_soldier.gd")
const PROJECTILE_SCRIPT := preload("res://scripts/projectile.gd")
const ORB_SCRIPT := preload("res://scripts/experience_orb.gd")
const EFFECT_SCRIPT := preload("res://scripts/explosion_effect.gd")
const SLASH_EFFECT_SCRIPT := preload("res://scripts/slash_effect.gd")
const STEP_SLASH_EFFECT_SCRIPT := preload("res://scripts/step_slash_effect.gd")
const LIGHTNING_CHAIN_EFFECT_SCRIPT := preload("res://scripts/lightning_chain_effect.gd")
const LIGHTNING_ORB_FIELD_SCRIPT := preload("res://scripts/lightning_orb_field.gd")
const SATELLITE_SCRIPT := preload("res://scripts/spell_satellite.gd")
const METEOR_HAZARD_SCRIPT := preload("res://scripts/meteor_hazard.gd")
const POISON_CLOUD_SCRIPT := preload("res://scripts/poison_cloud.gd")
const HUD_SCRIPT := preload("res://scripts/hud.gd")
const TITLE_SCREEN_SCRIPT := preload("res://scripts/title_screen.gd")
const AUDIO_SCRIPT := preload("res://scripts/game_audio.gd")
const HISTORY_SAVE_PATH := "user://run_records.cfg"
const DEFAULT_MASTER_VOLUME := 0.82
const MAX_RECENT_RUNS := 8
const RUN_MODE_NORMAL := "normal"
const RUN_MODE_ENDLESS := "endless"
const DEFAULT_CAREER_STATS := {
	"total_runs": 0,
	"total_victories": 0,
	"total_kills": 0,
	"best_run_kills": 0,
	"best_survival_time": 0.0,
	"fastest_clear_time": 0.0,
}

const CHARACTER_DEFINITIONS := [
	{
		"id": "caster",
		"name": "秘术师",
		"title": "远程术士",
		"summary": "以远程奥术压制战场，擅长安全输出与范围控场。",
		"detail": "初始技能为奥术箭，生命略低，但持续火力更强。",
		"accent": Color(0.46, 0.84, 1.0),
	},
	{
		"id": "blade",
		"name": "刀客",
		"title": "近战武者",
		"summary": "贴身搏杀型角色，依靠斩击、旋刃与突进打爆发。",
		"detail": "初始技能改为半圆挥击接短火焰刀气，生命更高，近身压制与中距补刀更强。",
		"accent": Color(0.98, 0.54, 0.36),
	},
	{
		"id": "thunder",
		"name": "闪电哥",
		"title": "雷链行者",
		"summary": "依靠连锁闪电、爆裂电荷与雷球领域持续清场，擅长连环处决与大范围压制。",
		"detail": "基础技能会自动丢出连锁闪电，能在敌群之间跳跃；后续可解锁击杀爆炸、雷球领域与雷霆进化。",
		"accent": Color(0.42, 0.78, 1.0),
	},
]

const PLAYER_START := Vector2.ZERO
const MAX_ENEMIES := 150
const MESSAGE_DURATION := 2.0
const TOUCH_MOVE_RADIUS := 108.0
const TOUCH_MOVE_TOP_PORTRAIT := 112.0
const TOUCH_MOVE_TOP_LANDSCAPE := 96.0
const UPGRADE_LIMITS := {
	"bolt": 7,
	"orbit": 4,
	"nova": 4,
	"storm": 4,
	"slash": 7,
	"blade_ring": 4,
	"mooncut": 4,
	"step_slash": 4,
	"chain": 7,
	"detonate": 4,
	"storm_orb": 4,
	"ascension": 1,
	"stride": 4,
	"vitality": 4,
	"focus": 4,
	"magnet": 4,
	"mastery": 4,
}
const MAP_DEFINITIONS := [
	{
		"id": "sky_ruins",
		"name": "天穹遗迹",
		"tagline": "断裂桥道与残柱把战场切成多条高速通路。",
		"description": "幽羽与枪骑会从桥边夹击，风暴执政官则用突进和雷暴持续压迫走位。",
		"intro": "遗迹上空的猎杀号令已经锁定你。",
		"terrain_hint": "桥面与石柱能形成清晰拉扯路线，也能替你挡住火力。",
		"boss_name": "风暴执政官",
		"boss_archetype": "storm_archon",
		"boss_summon_type": "wisp",
		"enemy_labels": ["幽羽", "枪骑"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.18,
		"enemy_cap_bonus": 6,
		"hazard_type": "",
		"palette": {
			"style_id": "sky_ruins",
			"ground_dark": Color(0.04, 0.06, 0.08),
			"ground_mid": Color(0.08, 0.14, 0.18),
			"line_color": Color(0.20, 0.30, 0.36, 0.52),
			"rune_color": Color(0.46, 0.88, 1.0, 0.16),
			"ember_color": Color(0.94, 0.86, 0.42, 0.14),
			"accent_color": Color(0.76, 0.92, 1.0, 0.18),
		},
		"waves": [
			{"until": 100.0, "weights": {"wisp": 1.0}},
			{"until": 220.0, "weights": {"wisp": 0.74, "lancer": 0.26}},
			{"until": 360.0, "weights": {"wisp": 0.58, "lancer": 0.42}},
			{"until": 500.0, "weights": {"wisp": 0.40, "lancer": 0.60}},
			{"until": 999.0, "weights": {"wisp": 0.26, "lancer": 0.74}},
		],
	},
	{
		"id": "ember_forge",
		"name": "余烬熔炉",
		"tagline": "炉墙与矿渣槽把战区压缩成沉重而狭长的走廊。",
		"description": "蛮铠与烬术师会逼你围绕掩体转火，而熔炉暴君会不断投射爆裂与封路压力。",
		"intro": "热浪穿透整座铸区，脚下的金属地面开始发亮。",
		"terrain_hint": "长炉墙和渣槽会制造狭窄咽喉口，适合换血和抢输出窗口。",
		"boss_name": "熔炉暴君",
		"boss_archetype": "forge_tyrant",
		"boss_summon_type": "embermage",
		"enemy_labels": ["蛮铠", "烬术师"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.04,
		"enemy_cap_bonus": -2,
		"hazard_type": "meteor",
		"hazard_interval": Vector2(4.8, 7.8),
		"palette": {
			"style_id": "ember_forge",
			"ground_dark": Color(0.09, 0.05, 0.04),
			"ground_mid": Color(0.18, 0.10, 0.08),
			"line_color": Color(0.40, 0.18, 0.10, 0.56),
			"rune_color": Color(1.0, 0.44, 0.18, 0.18),
			"ember_color": Color(1.0, 0.82, 0.36, 0.18),
			"accent_color": Color(1.0, 0.68, 0.34, 0.20),
		},
		"waves": [
			{"until": 120.0, "weights": {"brute": 1.0}},
			{"until": 260.0, "weights": {"brute": 0.78, "embermage": 0.22}},
			{"until": 420.0, "weights": {"brute": 0.62, "embermage": 0.38}},
			{"until": 560.0, "weights": {"brute": 0.50, "embermage": 0.50}},
			{"until": 999.0, "weights": {"brute": 0.38, "embermage": 0.62}},
		],
	},
	{
		"id": "void_marsh",
		"name": "虚沼祭坛",
		"tagline": "祭坛与芦苇滩会不断迫使你改线。",
		"description": "先知与泥沼兽会拉扯节奏，而虚空主母会用召唤和绽放陷阱淹没战场。",
		"intro": "潮湿迷雾正向你合围，耳边低语越来越近。",
		"terrain_hint": "祭坛和芦苇会切断追击路线，但同样会挡住你的投射物。",
		"boss_name": "虚空主母",
		"boss_archetype": "void_matriarch",
		"boss_summon_type": "seer",
		"enemy_labels": ["先知", "泥沼兽"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.12,
		"enemy_cap_bonus": 2,
		"hazard_type": "poison_cloud",
		"hazard_interval": Vector2(5.6, 8.4),
		"palette": {
			"style_id": "void_marsh",
			"ground_dark": Color(0.04, 0.06, 0.05),
			"ground_mid": Color(0.08, 0.14, 0.10),
			"line_color": Color(0.18, 0.28, 0.18, 0.48),
			"rune_color": Color(0.58, 0.42, 0.88, 0.16),
			"ember_color": Color(0.68, 0.92, 0.72, 0.12),
			"accent_color": Color(0.76, 0.72, 1.0, 0.16),
		},
		"waves": [
			{"until": 110.0, "weights": {"seer": 1.0}},
			{"until": 250.0, "weights": {"seer": 0.72, "mireling": 0.28}},
			{"until": 390.0, "weights": {"seer": 0.56, "mireling": 0.44}},
			{"until": 540.0, "weights": {"seer": 0.42, "mireling": 0.58}},
			{"until": 999.0, "weights": {"seer": 0.28, "mireling": 0.72}},
		],
	},
]

var _state: GameState = GameState.MENU

var _world_root: Node2D
var _map_root: WorldMap
var _hazard_root: Node2D
var _actor_root: Node2D
var _enemy_root: Node2D
var _projectile_root: Node2D
var _orb_root: Node2D
var _effect_root: Node2D
var _satellite_root: Node2D
var _player: Player
var _camera: Camera2D
var _hud: GameHud
var _title_screen: TitleScreen
var _audio: GameAudio

var _enemies: Array[EnemySoldier] = []
var _projectiles: Array[SpellProjectile] = []
var _orbs: Array[ExperienceOrb] = []
var _satellites: Array[SpellSatellite] = []
var _upgrade_choices: Array[Dictionary] = []

var _mobile_layout: bool = false
var _max_enemy_count: int = MAX_ENEMIES
var _max_orb_count: int = 90
var _selected_map_id: String = "sky_ruins"
var _selected_character_id: String = "caster"
var _selected_run_mode_id: String = RUN_MODE_NORMAL
var _current_run_mode_id: String = RUN_MODE_NORMAL
var _current_map: Dictionary = {}
var _map_best_kills: Dictionary = {}
var _career_stats: Dictionary = DEFAULT_CAREER_STATS.duplicate(true)
var _recent_runs: Array[Dictionary] = []
var _master_volume_ratio: float = DEFAULT_MASTER_VOLUME
var _boss_enemy: EnemySoldier = null
var _boss_spawned: bool = false
var _boss_defeated: bool = false
var _boss_warning_shown: bool = false
var _next_boss_spawn_time: float = 600.0

var _run_time: float = 0.0
var _spawn_budget: float = 0.0
var _cleanup_timer: float = 0.0
var _hud_refresh_timer: float = 0.0
var _message_timer: float = 0.0
var _hazard_timer: float = 0.0
var _level: int = 1
var _kills: int = 0
var _experience: float = 0.0
var _xp_to_next: float = 6.0

var _bolt_level: int = 1
var _orbit_level: int = 0
var _nova_level: int = 0
var _storm_level: int = 0
var _stride_level: int = 0
var _vitality_level: int = 0
var _focus_level: int = 0
var _magnet_level: int = 0
var _mastery_level: int = 0
var _slash_level: int = 1
var _blade_ring_level: int = 0
var _mooncut_level: int = 0
var _step_slash_level: int = 0
var _flame_split_mutation: bool = false
var _rend_mutation: bool = false
var _execution_mutation: bool = false
var _chain_level: int = 1
var _detonate_level: int = 0
var _storm_orb_level: int = 0
var _ascension_level: int = 0

var _bolt_timer: float = 0.0
var _nova_timer: float = 1.4
var _storm_timer: float = 3.0
var _slash_timer: float = 0.0
var _mooncut_timer: float = 1.2
var _step_slash_timer: float = 2.4
var _chain_timer: float = 0.0
var _storm_orb_timer: float = 1.8
var _touch_move_vector: Vector2 = Vector2.ZERO
var _touch_pointer_id: int = -1
var _touch_pointer_origin: Vector2 = Vector2.ZERO
var _touch_mouse_active: bool = false
var _dot_damage_buffers: Dictionary = {}
var _thunder_orb_field: Node2D = null

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_input(true)
	_rng.randomize()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_mobile_layout = _is_mobile_layout()
	_load_profile_data()
	_configure_runtime_limits()
	_setup_input_map()
	_set_current_map(_selected_map_id)
	_build_scene()
	_show_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if _handle_mobile_touch_input(event):
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("pause"):
		if _state == GameState.PLAYING:
			_open_pause_menu()
			get_viewport().set_input_as_handled()
		elif _state == GameState.PAUSED:
			_resume_from_pause()
			get_viewport().set_input_as_handled()
		return

	if _state != GameState.LEVEL_UP:
		return

	if event.is_action_pressed("upgrade_1"):
		_apply_upgrade_choice(0)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("upgrade_2"):
		_apply_upgrade_choice(1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("upgrade_3"):
		_apply_upgrade_choice(2)
		get_viewport().set_input_as_handled()


func _handle_mobile_touch_input(event: InputEvent) -> bool:
	if _state != GameState.PLAYING or not _mobile_layout:
		return false

	if event is InputEventScreenTouch:
		var touch_event: InputEventScreenTouch = event
		if touch_event.pressed:
			if _touch_pointer_id == -1 and not _touch_mouse_active and _can_start_touch_move(touch_event.position):
				_touch_pointer_id = touch_event.index
				_begin_touch_move(touch_event.position)
				return true
		elif touch_event.index == _touch_pointer_id:
			_reset_touch_move_state()
			return true
		return false

	if event is InputEventScreenDrag:
		var drag_event: InputEventScreenDrag = event
		if drag_event.index == _touch_pointer_id:
			_update_touch_move(drag_event.position)
			return true
		return false

	if event is InputEventMouseButton:
		var mouse_button: InputEventMouseButton = event
		if mouse_button.button_index != MOUSE_BUTTON_LEFT or _touch_pointer_id != -1:
			return false
		if mouse_button.pressed:
			if _can_start_touch_move(mouse_button.position):
				_touch_mouse_active = true
				_begin_touch_move(mouse_button.position)
				return true
		elif _touch_mouse_active:
			_reset_touch_move_state()
			return true
		return false

	if event is InputEventMouseMotion and _touch_mouse_active and _touch_pointer_id == -1:
		var mouse_motion: InputEventMouseMotion = event
		_update_touch_move(mouse_motion.position)
		return true

	return false


func _can_start_touch_move(screen_position: Vector2) -> bool:
	return screen_position.y >= _get_touch_move_top_margin()


func _begin_touch_move(screen_position: Vector2) -> void:
	_touch_pointer_origin = screen_position
	_update_touch_move(screen_position)


func _update_touch_move(screen_position: Vector2) -> void:
	var offset := screen_position - _touch_pointer_origin
	if offset.length() > TOUCH_MOVE_RADIUS:
		var direction := offset.normalized()
		_touch_pointer_origin = screen_position - direction * TOUCH_MOVE_RADIUS
		offset = direction * TOUCH_MOVE_RADIUS
	_apply_touch_move_vector(offset / TOUCH_MOVE_RADIUS)


func _reset_touch_move_state() -> void:
	_touch_pointer_id = -1
	_touch_mouse_active = false
	_touch_pointer_origin = Vector2.ZERO
	_apply_touch_move_vector(Vector2.ZERO)


func _get_touch_move_top_margin() -> float:
	var viewport_size := get_viewport().get_visible_rect().size
	if RuntimeLayout.is_portrait(viewport_size):
		return TOUCH_MOVE_TOP_PORTRAIT
	return TOUCH_MOVE_TOP_LANDSCAPE


func _process(delta: float) -> void:
	_update_camera(delta)
	_update_message_timer(delta)

	if _state != GameState.PLAYING:
		return

	_run_time += delta
	_spawn_budget += delta * _get_spawn_rate()
	_cleanup_timer += delta
	_hud_refresh_timer += delta

	_update_spell_attacks(delta)
	_update_environment_hazards(delta)

	if not _boss_warning_shown and not _boss_spawned and _run_time >= _get_boss_spawn_time() - _get_boss_warning_time():
		_boss_warning_shown = true
		_show_message("首领预警：%s 即将降临。" % _get_current_boss_name(), Color(1.0, 0.86, 0.54), 2.8)

	if not _boss_spawned and _run_time >= _get_boss_spawn_time():
		_spawn_boss()

	_spawn_regular_enemies()

	if _cleanup_timer >= 1.25:
		_cleanup_timer = 0.0
		_cleanup_far_entities()

	if _hud_refresh_timer >= 0.12:
		_hud_refresh_timer = 0.0
		_update_hud()


func _build_scene() -> void:
	_world_root = Node2D.new()
	_world_root.name = "WorldRoot"
	_world_root.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(_world_root)

	_map_root = WORLD_MAP_SCRIPT.new()
	_map_root.name = "WorldMap"
	_map_root.set_palette(_get_current_palette())
	_world_root.add_child(_map_root)

	_hazard_root = Node2D.new()
	_hazard_root.name = "Hazards"
	_world_root.add_child(_hazard_root)

	_actor_root = Node2D.new()
	_actor_root.name = "ActorRoot"
	_world_root.add_child(_actor_root)

	_enemy_root = Node2D.new()
	_enemy_root.name = "Enemies"
	_actor_root.add_child(_enemy_root)

	_projectile_root = Node2D.new()
	_projectile_root.name = "Projectiles"
	_actor_root.add_child(_projectile_root)

	_orb_root = Node2D.new()
	_orb_root.name = "ExperienceOrbs"
	_actor_root.add_child(_orb_root)

	_effect_root = Node2D.new()
	_effect_root.name = "Effects"
	_actor_root.add_child(_effect_root)

	_satellite_root = Node2D.new()
	_satellite_root.name = "Satellites"
	_actor_root.add_child(_satellite_root)

	_player = PLAYER_SCRIPT.new()
	_player.name = "Player"
	_player.global_position = PLAYER_START
	_actor_root.add_child(_player)
	_player.set_touch_move_vector(Vector2.ZERO)
	_player.damaged.connect(_on_player_damaged)
	_player.died.connect(_on_player_died)

	_camera = Camera2D.new()
	_camera.name = "Camera2D"
	_camera.enabled = true
	_camera.global_position = PLAYER_START
	_world_root.add_child(_camera)

	_map_root.set_focus_target(_player)

	_hud = HUD_SCRIPT.new()
	_hud.name = "Hud"
	add_child(_hud)
	_hud.upgrade_selected.connect(_on_upgrade_selected)
	_hud.restart_requested.connect(_on_restart_requested)
	_hud.pause_requested.connect(_on_pause_requested)
	_hud.pause_resume_requested.connect(_on_pause_resume_requested)
	_hud.pause_suicide_requested.connect(_on_pause_suicide_requested)
	_hud.pause_exit_requested.connect(_on_pause_exit_requested)
	_hud.move_vector_changed.connect(_on_touch_move_changed)

	_title_screen = TITLE_SCREEN_SCRIPT.new()
	_title_screen.name = "TitleScreen"
	add_child(_title_screen)
	_title_screen.start_requested.connect(_on_map_start_requested)
	_title_screen.map_selected.connect(_on_map_selected)
	_title_screen.character_selected.connect(_on_character_selected)
	_title_screen.volume_changed.connect(_on_menu_volume_changed)

	_audio = AUDIO_SCRIPT.new()
	_audio.name = "Audio"
	add_child(_audio)
	_audio.set_master_volume_ratio(_master_volume_ratio)

func _show_menu() -> void:
	_reset_runtime_collections()
	_reset_progression_state()
	_release_direction_actions()
	_reset_touch_move_state()
	_set_pause_state(false)

	_player.set_active(false)
	_player.global_position = PLAYER_START
	_camera.global_position = PLAYER_START
	_map_root.set_palette(_get_current_palette())
	_map_root.set_focus_target(_player)

	_hud.hide_upgrade_choices()
	_hud.hide_pause_menu()
	_hud.hide_result()
	_hud.set_message("")
	_hud.set_pause_button_visible(false)
	_message_timer = 0.0

	_title_screen.configure_maps(
		MAP_DEFINITIONS,
		_selected_map_id,
		_map_best_kills,
		CHARACTER_DEFINITIONS,
		_selected_character_id,
		_build_history_summary(),
		_recent_runs,
		_master_volume_ratio,
		_selected_run_mode_id
	)
	_title_screen.open_home()
	_title_screen.show_screen()
	_on_map_selected(_selected_map_id)
	_on_character_selected(_selected_character_id)

	_state = GameState.MENU


func _start_run() -> void:
	_reset_runtime_collections()
	_current_run_mode_id = _sanitize_run_mode(_selected_run_mode_id)
	_reset_progression_state()
	_release_direction_actions()
	_reset_touch_move_state()
	_set_current_map(_selected_map_id)
	_map_root.set_palette(_get_current_palette())
	_map_root.set_focus_target(_player)

	_title_screen.hide_screen()
	_hud.hide_result()
	_hud.hide_upgrade_choices()
	_hud.hide_pause_menu()

	_player.set_character(_selected_character_id)
	_player.global_position = PLAYER_START
	_apply_player_build(true)
	_camera.global_position = PLAYER_START
	_sync_satellites()

	_state = GameState.PLAYING
	_set_pause_state(false)
	_show_message(String(_current_map.get("intro", "战斗开始。")), Color(0.86, 0.96, 1.0), 3.2)
	_update_hud()


func _reset_runtime_collections() -> void:
	_clear_node_children(_hazard_root)
	_clear_node_children(_enemy_root)
	_clear_node_children(_projectile_root)
	_clear_node_children(_orb_root)
	_clear_node_children(_effect_root)
	_clear_node_children(_satellite_root)
	_enemies.clear()
	_projectiles.clear()
	_orbs.clear()
	_satellites.clear()
	_upgrade_choices.clear()
	_boss_enemy = null
	_thunder_orb_field = null


func _reset_progression_state() -> void:
	_run_time = 0.0
	_spawn_budget = 0.0
	_cleanup_timer = 0.0
	_hud_refresh_timer = 0.0
	_message_timer = 0.0
	_hazard_timer = _roll_hazard_interval()
	_dot_damage_buffers.clear()
	_level = 1
	_kills = 0
	_experience = 0.0
	_xp_to_next = _get_xp_needed(_level)

	_bolt_level = 1
	_orbit_level = 0
	_nova_level = 0
	_storm_level = 0
	_stride_level = 0
	_vitality_level = 0
	_focus_level = 0
	_magnet_level = 0
	_mastery_level = 0
	_slash_level = 1
	_blade_ring_level = 0
	_mooncut_level = 0
	_step_slash_level = 0
	_flame_split_mutation = false
	_rend_mutation = false
	_execution_mutation = false
	_chain_level = 1
	_detonate_level = 0
	_storm_orb_level = 0
	_ascension_level = 0

	_bolt_timer = 0.0
	_nova_timer = 1.4
	_storm_timer = 3.0
	_slash_timer = 0.0
	_mooncut_timer = 1.2
	_step_slash_timer = 2.4
	_chain_timer = 0.0
	_storm_orb_timer = 1.8

	_boss_spawned = false
	_boss_defeated = false
	_boss_warning_shown = false
	_next_boss_spawn_time = _get_initial_boss_spawn_time()


func _clear_node_children(node: Node) -> void:
	if node == null:
		return
	for child in node.get_children():
		child.queue_free()


func _release_direction_actions() -> void:
	for action in ["move_left", "move_right", "move_up", "move_down"]:
		Input.action_release(action)


func _update_message_timer(delta: float) -> void:
	if _message_timer <= 0.0:
		return
	_message_timer = maxf(0.0, _message_timer - delta)
	if _message_timer <= 0.0:
		_hud.set_message("")


func _update_spell_attacks(delta: float) -> void:
	var candidates: Array[Dictionary] = []
	if false and _is_thunder_character():
		_append_upgrade_candidate(candidates, "chain", _is_upgrade_available("chain", _chain_level), "连锁闪电 +1", "普通技能额外连锁 1 个目标，并提升闪电伤害与搜索距离。")
		_append_upgrade_candidate(candidates, "detonate", _is_upgrade_available("detonate", _detonate_level), "电荷爆裂", "击败敌人后有概率引发雷电爆炸，升级提高概率与爆炸范围。")
		_append_upgrade_candidate(candidates, "storm_orb", _is_upgrade_available("storm_orb", _storm_orb_level), "雷球领域", "投出一个持续 5 秒的闪电球，周期性对附近敌人释放连锁闪电。")
		_append_upgrade_candidate(candidates, "ascension", _ascension_level < 1, "雷霆进化", "连锁闪电额外 +5 跳，全部闪电伤害 +200%，攻击有 50% 概率召唤雷暴打击。")
	elif _is_blade_character():
		_update_blade_attacks(delta)
		return
	if _is_thunder_character():
		_update_thunder_attacks(delta)
		return

	_bolt_timer -= delta
	if _bolt_timer <= 0.0:
		_fire_bolts()
		_bolt_timer += _get_bolt_cooldown()

	if _nova_level > 0:
		_nova_timer -= delta
		if _nova_timer <= 0.0:
			_cast_nova()
			_nova_timer += _get_nova_cooldown()

	if _storm_level > 0:
		_storm_timer -= delta
		if _storm_timer <= 0.0:
			_cast_storm()
			_storm_timer += _get_storm_cooldown()


func _update_environment_hazards(delta: float) -> void:
	var hazard_type := String(_current_map.get("hazard_type", ""))
	if hazard_type.is_empty():
		return

	_hazard_timer -= delta
	if _hazard_timer > 0.0:
		return

	_spawn_map_hazard(hazard_type)
	_hazard_timer = _roll_hazard_interval()


func _spawn_map_hazard(hazard_type: String) -> void:
	match hazard_type:
		"meteor":
			_spawn_meteor_hazard()
		"poison_cloud":
			_spawn_poison_cloud()


func _spawn_meteor_hazard() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return

	var meteor: MeteorHazard = METEOR_HAZARD_SCRIPT.new()
	meteor.global_position = _pick_hazard_focus_position(36.0, 420.0)
	meteor.warning_duration = _rng.randf_range(0.92, 1.22)
	meteor.damage_radius = _rng.randf_range(80.0, 108.0)
	meteor.current_health_ratio = 0.20
	meteor.knockback = 250.0
	meteor.impact.connect(_on_meteor_impact)
	_hazard_root.add_child(meteor)


func _spawn_poison_cloud() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	if _player == null or not is_instance_valid(_player):
		return

	var viewport_size := get_viewport().get_visible_rect().size
	var travel_direction := Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
	if travel_direction == Vector2.ZERO:
		travel_direction = Vector2.RIGHT
	var cloud: PoisonCloudHazard = POISON_CLOUD_SCRIPT.new()
	var travel_span := maxf(viewport_size.length() * 0.56, 480.0)
	var lateral_span := maxf(viewport_size.y * 0.34, 140.0)
	cloud.global_position = _player.global_position - travel_direction * travel_span + travel_direction.orthogonal() * _rng.randf_range(-lateral_span, lateral_span)
	cloud.velocity = travel_direction * _rng.randf_range(80.0, 116.0)
	cloud.lifetime = _rng.randf_range(4.8, 6.4)
	cloud.damage_radius = _rng.randf_range(96.0, 126.0)
	cloud.max_health_ratio_per_second = 0.01
	cloud.pulse_interval = _rng.randf_range(0.45, 0.58)
	cloud.pulse.connect(_on_poison_cloud_pulse)
	_hazard_root.add_child(cloud)


func _pick_hazard_focus_position(min_distance: float, max_distance: float) -> Vector2:
	if _player == null or not is_instance_valid(_player):
		return PLAYER_START

	if not _enemies.is_empty() and _rng.randf() < 0.58:
		var live_enemies: Array[EnemySoldier] = []
		for enemy in _enemies:
			if enemy != null and is_instance_valid(enemy):
				live_enemies.append(enemy)
		if not live_enemies.is_empty():
			var enemy := live_enemies[_rng.randi_range(0, live_enemies.size() - 1)]
			return enemy.global_position + Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)) * _rng.randf_range(0.0, 72.0)

	return _player.global_position + Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)) * _rng.randf_range(min_distance, max_distance)


func _fire_bolts() -> void:
	if _player == null or not is_instance_valid(_player):
		return

	var count := _get_bolt_count()
	var targets := _get_nearest_enemies(_player.global_position, count, 900.0)
	for index in range(count):
		var direction := Vector2.RIGHT.rotated(_run_time * 0.7 + TAU * float(index) / float(max(count, 1)))
		var target: EnemySoldier = null
		if index < targets.size():
			target = targets[index]
			if target != null and is_instance_valid(target):
				direction = (target.global_position - _player.global_position).normalized()
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT

		var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
		projectile.global_position = _player.global_position + direction * 24.0
		projectile.direction = direction
		projectile.damage = _get_bolt_damage()
		projectile.speed = 760.0
		projectile.radius = 7.0
		projectile.pierce = _get_bolt_pierce()
		projectile.max_distance = 820.0
		projectile.knockback = 180.0
		projectile.tint = Color(0.44, 0.88, 1.0)
		if target != null and is_instance_valid(target):
			projectile.homing_target = target
			projectile.homing_strength = 8.0
		_register_projectile(projectile)

	_audio.play_player_shot("spread" if count > 1 else "rapid")


func _cast_nova() -> void:
	if _player == null or not is_instance_valid(_player):
		return

	var count := _get_nova_projectile_count()
	for index in range(count):
		var angle := TAU * float(index) / float(count) + _run_time * 0.2
		var direction := Vector2.RIGHT.rotated(angle)
		var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
		projectile.global_position = _player.global_position
		projectile.direction = direction
		projectile.damage = _get_nova_damage()
		projectile.speed = 480.0
		projectile.radius = 10.0
		projectile.pierce = 2
		projectile.max_distance = 420.0
		projectile.knockback = 220.0
		projectile.tint = Color(0.98, 0.72, 0.30)
		_register_projectile(projectile)

	_spawn_effect(_player.global_position, 72.0, Color(0.98, 0.84, 0.42), Color(1.0, 0.40, 0.20), 0.34)
	_audio.play_player_shot("power")


func _cast_storm() -> void:
	if _player == null or not is_instance_valid(_player):
		return

	var targets := _get_nearest_enemies(_player.global_position, _get_storm_target_count(), 920.0)
	if targets.is_empty():
		return

	for target in targets:
		if target == null or not is_instance_valid(target):
			continue
		_spawn_effect(target.global_position, 56.0, Color(0.84, 0.94, 1.0), Color(0.26, 0.60, 1.0), 0.30)
		target.take_damage(_get_storm_damage())

	_audio.play_player_shot("power")


func _update_thunder_attacks(delta: float) -> void:
	_chain_timer -= delta
	if _chain_timer <= 0.0:
		if _cast_chain_lightning_attack():
			_chain_timer += _get_chain_cooldown()
		else:
			_chain_timer = 0.12

	if _storm_orb_level > 0:
		_storm_orb_timer -= delta
		if _storm_orb_timer <= 0.0:
			if _cast_storm_orb():
				_storm_orb_timer += _get_storm_orb_cooldown()
			else:
				_storm_orb_timer = 0.24


func _cast_chain_lightning_attack() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false

	var origin := _player.global_position
	var facing := _player.get_facing_direction()
	if facing != Vector2.ZERO:
		origin += facing.normalized() * 18.0
	var hit_enemies := _emit_chain_lightning(
		origin,
		_get_chain_target_count(),
		_get_chain_initial_range(),
		_get_chain_bounce_range(),
		_get_chain_damage(),
		_get_chain_knockback(),
		true
	)
	if hit_enemies.is_empty():
		return false

	var first_target := hit_enemies[0]
	if first_target != null and is_instance_valid(first_target):
		var next_facing := (first_target.global_position - _player.global_position).normalized()
		if next_facing != Vector2.ZERO:
			_player.set_facing_direction(next_facing)
	_spawn_effect(_player.global_position, 24.0, Color(0.82, 0.96, 1.0), Color(0.36, 0.68, 1.0), 0.16)
	_audio.play_player_shot("power" if hit_enemies.size() >= 4 else "spread")
	return true


func _emit_chain_lightning(origin: Vector2, max_targets: int, initial_range: float, bounce_range: float, damage: int, knockback: float, allow_thunder_strike: bool) -> Array[EnemySoldier]:
	var hit_enemies: Array[EnemySoldier] = []
	if max_targets <= 0 or damage <= 0:
		return hit_enemies

	var current_origin := origin
	var current_range := initial_range
	for bounce_index in range(max_targets):
		var target := _get_chain_target_from_origin(current_origin, hit_enemies, current_range)
		if target == null:
			break
		var target_position := target.global_position
		_spawn_lightning_link_effect(current_origin, target_position, 8.8 if bounce_index == 0 else 7.2)
		_spawn_effect(target_position, 20.0 if bounce_index == 0 else 15.0, Color(0.86, 0.98, 1.0), Color(0.32, 0.62, 1.0), 0.12)
		var impulse_direction := (target_position - current_origin).normalized()
		if impulse_direction == Vector2.ZERO:
			impulse_direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		target.take_damage(damage, impulse_direction * knockback)
		hit_enemies.append(target)
		current_origin = target_position
		current_range = bounce_range

	if allow_thunder_strike and _ascension_level > 0 and not hit_enemies.is_empty() and _rng.randf() < _get_thunder_strike_proc_chance():
		var strike_index := _rng.randi_range(0, hit_enemies.size() - 1)
		var strike_target := hit_enemies[strike_index]
		if strike_target != null and is_instance_valid(strike_target):
			_trigger_thunder_strike(strike_target.global_position)

	return hit_enemies


func _get_chain_target_from_origin(origin: Vector2, excluded: Array[EnemySoldier], max_distance: float) -> EnemySoldier:
	var nearest: EnemySoldier = null
	var nearest_distance_sq := max_distance * max_distance
	for enemy_variant in _enemies:
		var enemy: EnemySoldier = enemy_variant
		if enemy == null or not is_instance_valid(enemy):
			continue
		if excluded.has(enemy):
			continue
		var distance_sq := origin.distance_squared_to(enemy.global_position)
		if distance_sq > nearest_distance_sq:
			continue
		nearest_distance_sq = distance_sq
		nearest = enemy
	return nearest


func _cast_storm_orb() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	if _effect_root == null or not is_instance_valid(_effect_root):
		return false

	var target_position := _get_storm_orb_target_position()
	if target_position == Vector2.ZERO and _player.global_position == Vector2.ZERO and _enemies.is_empty():
		return false

	if _thunder_orb_field != null and is_instance_valid(_thunder_orb_field):
		_thunder_orb_field.queue_free()

	var field = LIGHTNING_ORB_FIELD_SCRIPT.new()
	field.global_position = target_position
	field.duration = _get_storm_orb_duration()
	field.radius = _get_storm_orb_radius()
	field.pulse_interval = _get_storm_orb_pulse_interval()
	field.primary_color = Color(0.44, 0.78, 1.0)
	field.secondary_color = Color(0.90, 0.98, 1.0)
	field.pulse_requested.connect(_on_lightning_orb_pulse)
	_effect_root.add_child(field)
	_thunder_orb_field = field

	var throw_direction := (target_position - _player.global_position).normalized()
	if throw_direction == Vector2.ZERO:
		throw_direction = _player.get_facing_direction()
	if throw_direction == Vector2.ZERO:
		throw_direction = Vector2.RIGHT
	_player.set_facing_direction(throw_direction)
	_spawn_lightning_link_effect(_player.global_position + throw_direction * 18.0, target_position, 6.2)
	_spawn_effect(target_position, field.radius * 0.26, Color(0.86, 0.98, 1.0), Color(0.32, 0.62, 1.0), 0.18)
	_audio.play_player_shot("power")
	return true


func _get_storm_orb_target_position() -> Vector2:
	if _player == null or not is_instance_valid(_player):
		return PLAYER_START

	var targets := _get_nearest_enemies(_player.global_position, 1, _get_storm_orb_cast_range())
	if not targets.is_empty():
		var target := targets[0]
		if target != null and is_instance_valid(target):
			return target.global_position

	var direction := _player.get_facing_direction()
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT.rotated(_run_time * 0.35)
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	return _player.global_position + direction.normalized() * minf(_get_storm_orb_cast_range() * 0.58, 230.0)


func _on_lightning_orb_pulse(origin: Vector2) -> void:
	_spawn_effect(origin, _get_storm_orb_radius() * 0.30, Color(0.84, 0.97, 1.0), Color(0.30, 0.60, 1.0), 0.14)
	_emit_chain_lightning(
		origin,
		_get_storm_orb_target_count(),
		_get_storm_orb_radius(),
		_get_chain_bounce_range(),
		_get_storm_orb_damage(),
		_get_chain_knockback() * 0.82,
		true
	)


func _trigger_thunder_strike(position: Vector2) -> void:
	var strike_radius := _get_thunder_strike_radius()
	_spawn_lightning_link_effect(position + Vector2(0.0, -strike_radius * 2.4), position, 10.0)
	_spawn_effect(position, strike_radius, Color(0.92, 0.99, 1.0), Color(0.40, 0.68, 1.0), 0.18)
	_damage_enemies_in_radius(position, strike_radius, _get_thunder_strike_damage(), 280.0)


func _try_trigger_detonate(position: Vector2) -> void:
	if _detonate_level <= 0:
		return
	if _rng.randf() > _get_detonate_chance():
		return

	_spawn_effect(position, _get_detonate_radius(), Color(0.88, 0.98, 1.0), Color(0.34, 0.62, 1.0), 0.28)
	var arc_targets := _get_nearest_enemies(position, 4, _get_detonate_radius() + 40.0)
	for target in arc_targets:
		if target == null or not is_instance_valid(target):
			continue
		_spawn_lightning_link_effect(position, target.global_position, 5.4)
	_damage_enemies_in_radius(position, _get_detonate_radius(), _get_detonate_damage(), 240.0)


func _spawn_lightning_link_effect(start_position: Vector2, end_position: Vector2, thickness: float = 8.0) -> void:
	if _effect_root == null or not is_instance_valid(_effect_root):
		return
	var effect = LIGHTNING_CHAIN_EFFECT_SCRIPT.new()
	effect.thickness = thickness
	effect.primary_color = Color(0.82, 0.96, 1.0)
	effect.secondary_color = Color(0.34, 0.62, 1.0)
	effect.configure_link(start_position, end_position, _rng.randi())
	_effect_root.add_child(effect)


func _update_blade_attacks(delta: float) -> void:
	_slash_timer -= delta
	if _slash_timer <= 0.0:
		if _perform_steel_slash():
			_slash_timer = _get_slash_cooldown()
		else:
			_slash_timer = 0.12

	if _mooncut_level > 0:
		_mooncut_timer -= delta
		if _mooncut_timer <= 0.0:
			if _cast_mooncut():
				_mooncut_timer = _get_mooncut_cooldown()
			else:
				_mooncut_timer = 0.24

	if _step_slash_level > 0:
		_step_slash_timer -= delta
		if _step_slash_timer <= 0.0:
			if _perform_step_slash():
				_step_slash_timer = _get_step_slash_cooldown()
			else:
				_step_slash_timer = 0.32


func _perform_steel_slash() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false

	var targets := _get_nearest_enemies(_player.global_position, 1, _get_slash_search_range())
	if targets.is_empty():
		return false

	var target := targets[0]
	if target == null or not is_instance_valid(target):
		return false

	var direction := (target.global_position - _player.global_position).normalized()
	if direction == Vector2.ZERO:
		direction = _player.get_facing_direction()
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	_player.set_facing_direction(direction)

	var slash_center := _player.global_position
	var hit_count := _damage_enemies_in_arc(
		slash_center,
		direction,
		_get_slash_range(),
		_get_slash_arc_span(),
		_get_slash_damage(),
		_get_slash_knockback(),
		_get_slash_target_count()
	)
	_spawn_slash_effect(_player.global_position, direction, _get_slash_range(), _get_slash_arc_span())
	var slash_wave := _spawn_slash_flame_wave(_player.global_position + direction * 18.0, direction)

	if hit_count <= 0 and slash_wave == null:
		return false

	_audio.play_player_shot("spread" if hit_count > 1 else "rapid")
	return true


func _spawn_slash_flame_wave(origin: Vector2, direction: Vector2) -> SpellProjectile:
	if _projectile_root == null or not is_instance_valid(_projectile_root):
		return null
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
	projectile.global_position = origin
	projectile.direction = direction.normalized()
	projectile.damage = _get_slash_wave_damage()
	projectile.speed = _get_slash_wave_speed()
	projectile.radius = _get_slash_wave_radius()
	projectile.pierce = 99
	projectile.max_distance = _get_slash_wave_range()
	projectile.knockback = _get_slash_knockback() * 0.90
	projectile.tint = Color(1.0, 0.62, 0.24)
	projectile.secondary_tint = Color(1.0, 0.88, 0.66, 0.64)
	projectile.visual_style = "flame_fan"
	projectile.split_on_hit = _flame_split_mutation
	projectile.split_count = 3
	projectile.split_spread = 0.34
	projectile.split_generation = 0
	projectile.split_max_generations = 1
	projectile.split_damage_scale = 0.62
	projectile.split_speed_scale = 0.98
	projectile.split_range_scale = 0.76
	projectile.split_radius_scale = 0.82
	projectile.split_knockback_scale = 0.84
	projectile.split_child_pierce = 99
	projectile.damage_falloff_on_hit = true
	projectile.damage_falloff_factor = 0.80
	projectile.min_damage_multiplier = 0.40
	_register_projectile(projectile)
	_spawn_effect(origin + direction.normalized() * 16.0, minf(_get_slash_wave_radius() * 1.8, 34.0), Color(1.0, 0.86, 0.54), Color(1.0, 0.42, 0.22), 0.14)
	return projectile


func _cast_mooncut() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false

	var target := _get_nearest_enemies(_player.global_position, 1, 760.0)
	if target.is_empty():
		return false

	var primary_direction := (target[0].global_position - _player.global_position).normalized()
	if primary_direction == Vector2.ZERO:
		primary_direction = _player.get_facing_direction()
	if primary_direction == Vector2.ZERO:
		primary_direction = Vector2.RIGHT
	_player.set_facing_direction(primary_direction)

	var count := _get_mooncut_projectile_count()
	var fan_offsets: Array[float] = []
	if count <= 1:
		fan_offsets.append(0.0)
	else:
		for index in range(count):
			fan_offsets.append((float(index) - float(count - 1) * 0.5) * 0.28)

	for angle_offset in fan_offsets:
		_spawn_blade_wave(primary_direction.rotated(angle_offset))

	if _rend_mutation:
		_spawn_blade_wave(primary_direction.rotated(0.44), 0.88, 0.96)
		_spawn_blade_wave(primary_direction.rotated(-0.44), 0.88, 0.96)

	_spawn_effect(_player.global_position + primary_direction * 18.0, 42.0, Color(0.92, 0.94, 1.0), Color(0.96, 0.50, 0.36), 0.20)
	_audio.play_player_shot("spread")
	return true


func _spawn_blade_wave(direction: Vector2, damage_scale: float = 1.0, speed_scale: float = 1.0) -> void:
	if _projectile_root == null or not is_instance_valid(_projectile_root):
		return
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
	projectile.global_position = _player.global_position + direction.normalized() * 20.0
	projectile.direction = direction.normalized()
	projectile.damage = max(1, int(round(float(_get_mooncut_damage()) * damage_scale)))
	projectile.speed = 520.0 * speed_scale
	projectile.radius = 11.0
	projectile.pierce = _get_mooncut_pierce()
	projectile.max_distance = _get_mooncut_range()
	projectile.knockback = 220.0
	projectile.tint = Color(0.90, 0.94, 1.0)
	projectile.secondary_tint = Color(1.0, 0.58, 0.38, 0.52)
	projectile.visual_style = "blade_wave"
	_register_projectile(projectile)


func _register_projectile(projectile: SpellProjectile) -> void:
	if projectile == null or _projectile_root == null or not is_instance_valid(_projectile_root):
		return
	projectile.finished.connect(_on_projectile_finished)
	projectile.split_requested.connect(_on_projectile_split_requested)
	_projectile_root.add_child(projectile)
	_projectiles.append(projectile)


func _perform_step_slash() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false

	var targets := _get_nearest_enemies(_player.global_position, 1, _get_step_slash_search_range())
	if targets.is_empty():
		return false

	var target: EnemySoldier = targets[0]
	if target == null or not is_instance_valid(target):
		return false

	var start_position := _player.global_position
	var direction := (target.global_position - start_position).normalized()
	if direction == Vector2.ZERO:
		direction = _player.get_facing_direction()
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	_player.set_facing_direction(direction)

	var radius := _get_step_slash_radius()
	var slash_center := start_position
	var hit_total := _damage_enemies_in_radius(slash_center, radius, _get_step_slash_damage(), _get_step_slash_knockback())
	if hit_total <= 0:
		target.take_damage(_get_step_slash_damage(), direction * _get_step_slash_knockback())
		hit_total = 1

	_spawn_step_slash_effect(slash_center, direction, radius)
	_spawn_effect(start_position, minf(radius * 0.36, 34.0), Color(1.0, 0.88, 0.70), Color(1.0, 0.56, 0.34), 0.16)
	if _execution_mutation:
		_trigger_execution_field(slash_center)

	_audio.play_player_shot("power")
	return true


func _trigger_execution_field(center: Vector2) -> int:
	var hit_total := _damage_enemies_in_radius(center, _get_execution_radius(), _get_execution_damage(), 320.0)
	_spawn_effect(center, _get_execution_radius() * 0.82, Color(1.0, 0.88, 0.72), Color(0.98, 0.30, 0.24), 0.28)
	return hit_total


func _spawn_regular_enemies() -> void:
	while _spawn_budget >= 1.0 and _enemies.size() < _get_active_enemy_cap():
		_spawn_budget -= 1.0
		var enemy_type := _pick_weighted_enemy_type()
		var elite_chance := minf(0.22, 0.04 + float(_get_wave_rank()) * 0.012)
		var is_elite := not _boss_spawned and _run_time >= 90.0 and _rng.randf() < elite_chance
		_spawn_enemy(enemy_type, is_elite)


func _spawn_enemy(type_name: String, is_elite: bool, options: Dictionary = {}) -> EnemySoldier:
	if _player == null or not is_instance_valid(_player):
		return null

	var enemy: EnemySoldier = ENEMY_SCRIPT.new()
	var spawn_position: Vector2 = options.get("spawn_position", _find_spawn_position(560.0, 980.0, 16.0))
	var wave_rank := int(options.get("wave_rank", _get_wave_rank()))
	enemy.global_position = spawn_position
	enemy.configure(type_name, wave_rank, is_elite, _player, options)
	enemy.defeated.connect(_on_enemy_defeated)
	enemy.special_attack.connect(_on_enemy_special_attack)
	enemy.summon_requested.connect(_on_enemy_summon_requested)
	_enemy_root.add_child(enemy)
	_enemies.append(enemy)
	return enemy


func _spawn_boss() -> void:
	if _boss_spawned or _boss_enemy != null:
		return

	var boss_position := _find_spawn_position(700.0, 860.0, 24.0)
	_boss_enemy = _spawn_enemy(
		String(_current_map.get("boss_archetype", "storm_archon")),
		false,
		{
			"boss": true,
			"summon_type": String(_current_map.get("boss_summon_type", "wisp")),
			"spawn_position": boss_position,
			"wave_rank": _get_wave_rank() + 2,
		}
	)
	if _boss_enemy == null:
		return

	_boss_spawned = true
	_spawn_effect(_boss_enemy.global_position, 120.0, Color(1.0, 0.86, 0.52), Color(1.0, 0.36, 0.18), 0.52)
	_show_message("%s 已降临战场。" % _get_current_boss_name(), Color(1.0, 0.90, 0.62), 3.4)
	_audio.play_enemy_shot(true)


func _find_spawn_position(min_distance: float, max_distance: float, radius: float) -> Vector2:
	if _player == null or not is_instance_valid(_player):
		return PLAYER_START

	for _attempt in range(18):
		var angle := _rng.randf_range(0.0, TAU)
		var distance := _rng.randf_range(min_distance, max_distance)
		var test_position := _player.global_position + Vector2.RIGHT.rotated(angle) * distance
		if not _is_position_blocked(test_position, radius):
			return test_position

	return _player.global_position + Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)) * max_distance


func _pick_weighted_enemy_type() -> String:
	var wave_weights: Dictionary = {}
	var last_wave: Dictionary = {}
	for wave_variant in _current_map.get("waves", []):
		var wave: Dictionary = wave_variant
		last_wave = wave
		if _run_time <= float(wave.get("until", 999.0)):
			wave_weights = Dictionary(wave.get("weights", {}))
			break

	if wave_weights.is_empty() and not last_wave.is_empty():
		wave_weights = Dictionary(last_wave.get("weights", {}))

	if wave_weights.is_empty():
		return String(_current_map.get("boss_summon_type", "wisp"))

	var total_weight := 0.0
	for weight_variant in wave_weights.values():
		total_weight += maxf(0.0, float(weight_variant))
	if total_weight <= 0.0:
		return String(wave_weights.keys()[0])

	var roll := _rng.randf_range(0.0, total_weight)
	for type_variant in wave_weights.keys():
		roll -= maxf(0.0, float(wave_weights[type_variant]))
		if roll <= 0.0:
			return String(type_variant)
	return String(wave_weights.keys()[0])


func _get_nearest_enemies(origin: Vector2, count: int, max_distance: float) -> Array[EnemySoldier]:
	var available: Array[EnemySoldier] = []
	for enemy in _enemies:
		if enemy == null or not is_instance_valid(enemy):
			continue
		available.append(enemy)

	var result: Array[EnemySoldier] = []
	var max_distance_sq := max_distance * max_distance
	while result.size() < count:
		var nearest: EnemySoldier = null
		var nearest_distance_sq := INF
		for enemy in available:
			var distance_sq := origin.distance_squared_to(enemy.global_position)
			if distance_sq > max_distance_sq:
				continue
			if distance_sq < nearest_distance_sq:
				nearest_distance_sq = distance_sq
				nearest = enemy
		if nearest == null:
			break
		result.append(nearest)
		available.erase(nearest)
	return result


func _damage_enemies_in_radius(center: Vector2, radius: float, damage: int, knockback: float, max_hits: int = -1) -> int:
	if damage <= 0:
		return 0

	var enemies := _get_nearest_enemies(center, _enemies.size(), radius + 24.0)
	var hit_total := 0
	for enemy in enemies:
		if enemy == null or not is_instance_valid(enemy):
			continue
		if center.distance_to(enemy.global_position) > radius + enemy.get_body_radius():
			continue
		var direction := (enemy.global_position - center).normalized()
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		enemy.take_damage(damage, direction * knockback)
		hit_total += 1
		if max_hits > 0 and hit_total >= max_hits:
			break
	return hit_total


func _damage_enemies_in_arc(center: Vector2, forward_direction: Vector2, radius: float, arc_span: float, damage: int, knockback: float, max_hits: int = -1) -> int:
	if damage <= 0:
		return 0

	var facing := forward_direction.normalized()
	if facing == Vector2.ZERO:
		facing = Vector2.RIGHT
	var min_dot := cos(arc_span * 0.5)
	var hits: Array[Dictionary] = []
	for enemy_variant in _enemies:
		var enemy: EnemySoldier = enemy_variant
		if enemy == null or not is_instance_valid(enemy):
			continue

		var to_enemy := enemy.global_position - center
		var distance := to_enemy.length()
		if distance > radius + enemy.get_body_radius():
			continue

		var direction := to_enemy.normalized()
		if direction == Vector2.ZERO:
			direction = facing
		if facing.dot(direction) < min_dot:
			continue

		hits.append({
			"enemy": enemy,
			"distance": distance,
		})

	hits.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("distance", 0.0)) < float(b.get("distance", 0.0))
	)

	var hit_total := 0
	for hit in hits:
		var enemy := hit.get("enemy", null) as EnemySoldier
		if enemy == null or not is_instance_valid(enemy):
			continue
		var impulse_direction := (enemy.global_position - center).normalized()
		if impulse_direction == Vector2.ZERO:
			impulse_direction = facing
		enemy.take_damage(damage, impulse_direction * knockback)
		hit_total += 1
		if max_hits > 0 and hit_total >= max_hits:
			break
	return hit_total


func _apply_line_damage(start_position: Vector2, end_position: Vector2, width: float, damage: int, knockback: float, max_hits: int = -1) -> int:
	if damage <= 0:
		return 0

	var hits: Array[Dictionary] = []
	for enemy_variant in _enemies:
		var enemy: EnemySoldier = enemy_variant
		if enemy == null or not is_instance_valid(enemy):
			continue
		var distance := _distance_to_segment(enemy.global_position, start_position, end_position)
		if distance > width + enemy.get_body_radius():
			continue
		hits.append({
			"enemy": enemy,
			"distance": start_position.distance_squared_to(enemy.global_position),
		})

	hits.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("distance", 0.0)) < float(b.get("distance", 0.0))
	)

	var hit_total := 0
	for hit in hits:
		var enemy := hit.get("enemy", null) as EnemySoldier
		if enemy == null or not is_instance_valid(enemy):
			continue
		var direction := (enemy.global_position - start_position).normalized()
		if direction == Vector2.ZERO:
			direction = (end_position - start_position).normalized()
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT
		enemy.take_damage(damage, direction * knockback)
		hit_total += 1
		if max_hits > 0 and hit_total >= max_hits:
			break
	return hit_total


func _distance_to_segment(point: Vector2, start_position: Vector2, end_position: Vector2) -> float:
	var segment := end_position - start_position
	var length_sq := segment.length_squared()
	if length_sq <= 0.001:
		return point.distance_to(start_position)
	var t := clampf((point - start_position).dot(segment) / length_sq, 0.0, 1.0)
	return point.distance_to(start_position + segment * t)


func _spawn_effect(position: Vector2, radius: float, primary_color: Color, secondary_color: Color, duration: float = 0.45) -> void:
	var effect: ExplosionEffect = EFFECT_SCRIPT.new()
	effect.global_position = position
	effect.radius = radius
	effect.duration = duration
	effect.primary_color = primary_color
	effect.secondary_color = secondary_color
	_effect_root.add_child(effect)


func _spawn_slash_effect(position: Vector2, direction: Vector2, radius: float, arc_span: float) -> void:
	var effect = SLASH_EFFECT_SCRIPT.new()
	effect.global_position = position
	effect.facing_direction = direction
	effect.radius = radius
	effect.arc_span = arc_span
	effect.duration = 0.16
	effect.primary_color = Color(1.0, 0.94, 0.82)
	effect.secondary_color = Color(0.98, 0.46, 0.32)
	_effect_root.add_child(effect)


func _spawn_step_slash_effect(position: Vector2, direction: Vector2, radius: float) -> void:
	var effect = STEP_SLASH_EFFECT_SCRIPT.new()
	effect.global_position = position
	effect.facing_direction = direction
	effect.radius = radius
	effect.duration = 0.26
	effect.primary_color = Color(1.0, 0.94, 0.82)
	effect.secondary_color = Color(0.98, 0.44, 0.32)
	_effect_root.add_child(effect)


func _roll_hazard_interval() -> float:
	var hazard_type := String(_current_map.get("hazard_type", ""))
	if hazard_type.is_empty():
		return 9999.0

	var base_range: Vector2 = _current_map.get("hazard_interval", Vector2(5.8, 8.0))
	var intensity := clampf(_run_time / 360.0, 0.0, 1.0)
	var min_interval := maxf(1.8, base_range.x * lerpf(1.0, 0.76, intensity))
	var max_interval := maxf(min_interval + 0.2, base_range.y * lerpf(1.0, 0.82, intensity))
	return _rng.randf_range(min_interval, max_interval)


func _apply_area_current_health_damage(center: Vector2, radius: float, current_health_ratio: float, knockback: float) -> void:
	if current_health_ratio <= 0.0:
		return

	var affected_actors := _get_actors_in_area(center, radius)
	for actor in affected_actors:
		var damage := maxi(1, int(ceili(_get_actor_current_health(actor) * current_health_ratio)))
		_apply_damage_to_actor(actor, damage, knockback, center)


func _apply_area_max_health_damage_over_time(center: Vector2, radius: float, ratio_per_second: float, elapsed_time: float, knockback: float) -> void:
	if ratio_per_second <= 0.0 or elapsed_time <= 0.0:
		return

	var affected_actors := _get_actors_in_area(center, radius)
	for actor in affected_actors:
		var raw_damage := _get_actor_max_health(actor) * ratio_per_second * elapsed_time
		_accumulate_dot_damage(actor, raw_damage, knockback, center)


func _get_actors_in_area(center: Vector2, radius: float) -> Array[Node]:
	var actors: Array[Node] = []
	if _player != null and is_instance_valid(_player) and _player.is_alive():
		if center.distance_to(_player.global_position) <= radius + _player.get_body_radius():
			actors.append(_player)

	for enemy_variant in _enemies.duplicate():
		var enemy: EnemySoldier = enemy_variant
		if enemy == null or not is_instance_valid(enemy):
			continue
		if center.distance_to(enemy.global_position) <= radius + enemy.get_body_radius():
			actors.append(enemy)
	return actors


func _apply_damage_to_actor(actor: Node, damage: int, knockback: float, center: Vector2) -> void:
	if damage <= 0 or actor == null or not is_instance_valid(actor):
		return

	if actor is Player:
		var player := actor as Player
		player.take_damage(damage)
		return

	if actor is EnemySoldier:
		var enemy := actor as EnemySoldier
		var impulse := enemy.global_position - center
		if impulse == Vector2.ZERO:
			impulse = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		enemy.take_damage(damage, impulse.normalized() * knockback)


func _accumulate_dot_damage(actor: Node, raw_damage: float, knockback: float, center: Vector2) -> void:
	if raw_damage <= 0.0 or actor == null or not is_instance_valid(actor):
		return

	var actor_id := actor.get_instance_id()
	var accumulated := float(_dot_damage_buffers.get(actor_id, 0.0)) + raw_damage
	var whole_damage := int(floor(accumulated))
	_dot_damage_buffers[actor_id] = accumulated - float(whole_damage)
	if whole_damage > 0:
		_apply_damage_to_actor(actor, whole_damage, knockback, center)


func _clear_dot_damage_buffer(actor: Node) -> void:
	if actor == null or not is_instance_valid(actor):
		return
	_dot_damage_buffers.erase(actor.get_instance_id())


func _get_actor_current_health(actor: Node) -> float:
	if actor is Player:
		var player := actor as Player
		return float(player.health)
	if actor is EnemySoldier:
		var enemy := actor as EnemySoldier
		return float(enemy.health)
	return 0.0


func _get_actor_max_health(actor: Node) -> float:
	if actor is Player:
		var player := actor as Player
		return float(player.max_health)
	if actor is EnemySoldier:
		var enemy := actor as EnemySoldier
		return float(enemy.max_health)
	return 0.0


func _spawn_orb(position: Vector2, value: int) -> void:
	var orb: ExperienceOrb = ORB_SCRIPT.new()
	orb.global_position = position
	orb.configure(_player, value)
	orb.collected.connect(_on_orb_collected)
	_orb_root.add_child(orb)
	_orbs.append(orb)


func _sync_satellites() -> void:
	_clear_node_children(_satellite_root)
	_satellites.clear()

	if _player == null or not is_instance_valid(_player):
		return

	var spell_lines: Array[String] = []
	if false and _is_thunder_character():
		spell_lines = [
			"连锁闪电 %d 级  连锁 %d" % [_chain_level, _get_chain_target_count()],
			"电荷爆裂 %d 级  概率 %.0f%%" % [_detonate_level, _get_detonate_chance() * 100.0],
			"雷球领域 %d 级  半径 %.0f" % [_storm_orb_level, _get_storm_orb_radius()],
			"雷霆进化 %d 级  雷暴 %.0f%%" % [_ascension_level, _get_thunder_strike_proc_chance() * 100.0],
		]
	elif _is_blade_character():
		var blade_ring_count := _get_blade_ring_count()
		for index in range(blade_ring_count):
			var blade_satellite: SpellSatellite = SATELLITE_SCRIPT.new()
			blade_satellite.configure(
				_player,
				TAU * float(index) / float(max(blade_ring_count, 1)),
				_get_blade_ring_radius(),
				_get_blade_ring_speed(),
				_get_blade_ring_damage(),
				{
					"visual_style": "blade",
					"primary_color": Color(0.88, 0.94, 1.0),
					"secondary_color": Color(0.98, 0.52, 0.36, 0.92),
					"body_radius": 12.0,
					"hit_interval": 0.20,
					"hit_knockback": 120.0,
				}
			)
			_satellite_root.add_child(blade_satellite)
			_satellites.append(blade_satellite)
		return

	var orbit_count := _get_orbit_count()
	for index in range(orbit_count):
		var satellite: SpellSatellite = SATELLITE_SCRIPT.new()
		satellite.configure(
			_player,
			TAU * float(index) / float(max(orbit_count, 1)),
			_get_orbit_radius(),
			_get_orbit_speed(),
			_get_orbit_damage()
		)
		_satellite_root.add_child(satellite)
		_satellites.append(satellite)

func _open_level_up() -> void:
	if _state != GameState.PLAYING:
		return

	_state = GameState.LEVEL_UP
	_upgrade_choices = _build_upgrade_choices()
	_hud.hide_pause_menu()
	_hud.show_upgrade_choices(_upgrade_choices)
	_hud.set_message("")
	_message_timer = 0.0
	_set_pause_state(true)


func _build_upgrade_choices() -> Array[Dictionary]:
	return _build_character_upgrade_choices()

	var candidates: Array[Dictionary] = []
	_append_upgrade_candidate(candidates, "bolt", _bolt_level < int(UPGRADE_LIMITS.get("bolt", 7)), "奥术弹 +1", "提升奥术弹伤害、数量与穿透。")
	_append_upgrade_candidate(candidates, "orbit", _orbit_level < int(UPGRADE_LIMITS.get("orbit", 4)), "环轨核心", "新增或强化环绕卫星。")
	_append_upgrade_candidate(candidates, "nova", _nova_level < int(UPGRADE_LIMITS.get("nova", 4)), "新星爆发", "按冷却释放一轮环形爆发。")
	_append_upgrade_candidate(candidates, "storm", _storm_level < int(UPGRADE_LIMITS.get("storm", 4)), "雷暴召引", "以闪电打击附近敌人。")
	_append_upgrade_candidate(candidates, "stride", _stride_level < int(UPGRADE_LIMITS.get("stride", 4)), "步幅矩阵", "提高移动速度。")
	_append_upgrade_candidate(candidates, "vitality", _vitality_level < int(UPGRADE_LIMITS.get("vitality", 4)), "生命编织", "提高生命上限并恢复部分生命。")
	_append_upgrade_candidate(candidates, "focus", _focus_level < int(UPGRADE_LIMITS.get("focus", 4)), "聚焦镜片", "缩短全部法术冷却。")
	_append_upgrade_candidate(candidates, "magnet", _magnet_level < int(UPGRADE_LIMITS.get("magnet", 4)), "磁引场", "扩大经验球吸附范围。")
	_append_upgrade_candidate(candidates, "mastery", _mastery_level < int(UPGRADE_LIMITS.get("mastery", 4)), "精通纹章", "提高法术威力与经验收益。")
	_append_upgrade_candidate(candidates, "repair", true, "战地修复", "立即恢复 3 点生命。")
	_append_upgrade_candidate(candidates, "cache", true, "秘术储备", "立即获得下一段经验条的 35%。")

	var pool: Array = candidates.duplicate()
	var result: Array[Dictionary] = []
	while result.size() < 3 and not pool.is_empty():
		var pick_index := _rng.randi_range(0, pool.size() - 1)
		var choice: Dictionary = pool[pick_index]
		result.append(choice)
		pool.remove_at(pick_index)
	return result


func _append_upgrade_candidate(target: Array[Dictionary], key: String, enabled: bool, title: String, desc: String) -> void:
	if not enabled:
		return
	target.append({
		"key": key,
		"title": title,
		"desc": desc,
	})


func _build_character_upgrade_choices() -> Array[Dictionary]:
	var candidates: Array[Dictionary] = []
	if _is_thunder_character():
		_append_upgrade_candidate(candidates, "chain", _is_upgrade_available("chain", _chain_level), "连锁闪电 +1", "普通技能额外连锁 1 个目标，并提升闪电伤害与搜索距离。")
		_append_upgrade_candidate(candidates, "detonate", _is_upgrade_available("detonate", _detonate_level), "电荷爆裂", "击败敌人后有概率引发雷电爆炸，升级提高概率与爆炸范围。")
		_append_upgrade_candidate(candidates, "storm_orb", _is_upgrade_available("storm_orb", _storm_orb_level), "雷球领域", "投出一个持续 5 秒的闪电球，周期性对附近敌人释放连锁闪电。")
		_append_upgrade_candidate(candidates, "ascension", _ascension_level < 1, "雷霆进化", "连锁闪电额外 +5 跳，全部闪电伤害 +200%，攻击有 50% 概率召唤雷暴打击。")
	elif _is_blade_character():
		_append_upgrade_candidate(candidates, "slash", _is_upgrade_available("slash", _slash_level), "钢刃斩 +1", "提升半圆挥击伤害，并延长火焰刀气的推进距离与波及范围。")
		_append_upgrade_candidate(candidates, "blade_ring", _is_upgrade_available("blade_ring", _blade_ring_level), "旋刃护环", "新增或强化围绕角色旋转的刀刃。")
		_append_upgrade_candidate(candidates, "mooncut", _is_upgrade_available("mooncut", _mooncut_level), "残月斩", "向敌人方向释放月牙刀波。")
		_append_upgrade_candidate(candidates, "step_slash", _is_upgrade_available("step_slash", _step_slash_level), "踏空圆斩", "在周身发动一次圆形范围斩击，击退附近敌人。")
		_append_upgrade_candidate(candidates, "mut_flame_split", _slash_level >= 4 and _blade_ring_level >= 2 and not _flame_split_mutation, "变异：焰刃分裂", "钢刃斩挥出的火焰刀气命中后会分裂为三道刀气。")
		_append_upgrade_candidate(candidates, "mut_rend", _mooncut_level >= 3 and not _rend_mutation, "变异：裂月", "残月斩额外生成两道交叉刀波，并提升穿透。")
		_append_upgrade_candidate(candidates, "mut_execution", _step_slash_level >= 3 and _slash_level >= 4 and not _execution_mutation, "变异：处决场", "踏空圆斩命中后会追加一次范围处决爆发。")
	else:
		_append_upgrade_candidate(candidates, "bolt", _is_upgrade_available("bolt", _bolt_level), "奥术箭 +1", "提升奥术箭伤害、数量与穿透。")
		_append_upgrade_candidate(candidates, "orbit", _is_upgrade_available("orbit", _orbit_level), "环轨核心", "新增或强化环绕法术卫星。")
		_append_upgrade_candidate(candidates, "nova", _is_upgrade_available("nova", _nova_level), "新星爆发", "释放一轮环形爆裂投射物。")
		_append_upgrade_candidate(candidates, "storm", _is_upgrade_available("storm", _storm_level), "雷暴牵引", "召唤连锁闪电打击附近敌人。")

	_append_generic_upgrade_candidates(candidates)

	var pool: Array = candidates.duplicate()
	var result: Array[Dictionary] = []
	while result.size() < 3 and not pool.is_empty():
		var pick_index := _rng.randi_range(0, pool.size() - 1)
		var choice: Dictionary = pool[pick_index]
		result.append(choice)
		pool.remove_at(pick_index)
	return result


func _append_generic_upgrade_candidates(target: Array[Dictionary]) -> void:
	_append_upgrade_candidate(target, "stride", _is_upgrade_available("stride", _stride_level), "步幅矩阵", "提升移动速度。")
	_append_upgrade_candidate(target, "vitality", _is_upgrade_available("vitality", _vitality_level), "生命编织", "提升生命上限，并恢复少量生命。")
	_append_upgrade_candidate(target, "focus", _is_upgrade_available("focus", _focus_level), "聚焦镜片", "缩短全部技能冷却。")
	_append_upgrade_candidate(target, "magnet", _is_upgrade_available("magnet", _magnet_level), "磁引场", "扩大经验球吸附范围。")
	_append_upgrade_candidate(target, "mastery", _is_upgrade_available("mastery", _mastery_level), "战斗精通", "提高输出强度与经验获取。")
	_append_upgrade_candidate(target, "repair", true, "战地修复", "立刻恢复 3 点生命。")
	_append_upgrade_candidate(target, "cache", true, "战备缓存", "立刻获得当前等级经验条的 35%。")


func _is_upgrade_available(key: String, current_level: int) -> bool:
	if _is_endless_mode():
		return true
	return current_level < int(UPGRADE_LIMITS.get(key, current_level + 1))


func _apply_character_upgrade_choice(index: int) -> void:
	if index < 0 or index >= _upgrade_choices.size():
		return

	var choice: Dictionary = _upgrade_choices[index]
	match String(choice.get("key", "")):
		"bolt":
			_bolt_level += 1
		"orbit":
			_orbit_level += 1
		"nova":
			_nova_level += 1
		"storm":
			_storm_level += 1
		"slash":
			_slash_level += 1
		"blade_ring":
			_blade_ring_level += 1
		"mooncut":
			_mooncut_level += 1
		"step_slash":
			_step_slash_level += 1
		"chain":
			_chain_level += 1
		"detonate":
			_detonate_level += 1
		"storm_orb":
			_storm_orb_level += 1
		"ascension":
			_ascension_level = max(_ascension_level, 1)
		"mut_flame_split":
			_flame_split_mutation = true
		"mut_rend":
			_rend_mutation = true
		"mut_execution":
			_execution_mutation = true
		"stride":
			_stride_level += 1
		"vitality":
			_vitality_level += 1
		"focus":
			_focus_level += 1
		"magnet":
			_magnet_level += 1
		"mastery":
			_mastery_level += 1
		"repair":
			_player.heal(3)
		"cache":
			_experience += _xp_to_next * 0.35
		_:
			return

	_upgrade_choices.clear()
	_hud.hide_upgrade_choices()
	_apply_player_build(false)
	_sync_satellites()
	_show_message("强化完成：%s" % String(choice.get("title", "技能")), Color(0.84, 0.96, 1.0), 1.8)
	_update_character_hud()

	_state = GameState.PLAYING
	_set_pause_state(false)
	if _experience >= _xp_to_next:
		_open_level_up()
	return
	_show_message("强化完成：%s" % String(choice.get("title", "技能")), Color(0.84, 0.96, 1.0), 1.8)
	_show_message("强化完成：%s" % String(choice.get("title", "技能")), Color(0.84, 0.96, 1.0), 1.8)
	_update_character_hud()

	_state = GameState.PLAYING
	_set_pause_state(false)
	if _experience >= _xp_to_next:
		_open_level_up()


func _apply_upgrade_choice(index: int) -> void:
	_apply_character_upgrade_choice(index)
	return

	if index < 0 or index >= _upgrade_choices.size():
		return

	var choice: Dictionary = _upgrade_choices[index]
	match String(choice.get("key", "")):
		"bolt":
			_bolt_level += 1
		"orbit":
			_orbit_level += 1
		"nova":
			_nova_level += 1
		"storm":
			_storm_level += 1
		"stride":
			_stride_level += 1
		"vitality":
			_vitality_level += 1
		"focus":
			_focus_level += 1
		"magnet":
			_magnet_level += 1
		"mastery":
			_mastery_level += 1
		"repair":
			_player.heal(3)
		"cache":
			_experience += _xp_to_next * 0.35

	_upgrade_choices.clear()
	_hud.hide_upgrade_choices()
	_apply_player_build(false)
	_sync_satellites()
	_show_message("强化完成：%s" % String(choice.get("title", "秘术")), Color(0.84, 0.96, 1.0), 1.8)
	_update_hud()

	_state = GameState.PLAYING
	_set_pause_state(false)
	if _experience >= _xp_to_next:
		_open_level_up()


func _apply_player_build(is_fresh_run: bool) -> void:
	var move_speed := _get_player_speed()
	var max_health := _get_player_max_health()
	var pickup_radius := _get_player_pickup_radius()
	_player.set_character(_selected_character_id)
	if is_fresh_run:
		_player.reset_for_run(PLAYER_START, max_health, move_speed, pickup_radius)
	else:
		_player.set_build_stats(move_speed, max_health, pickup_radius)
		if _vitality_level > 0:
			_player.heal(2)


func _update_character_hud() -> void:
	if _player == null or not is_instance_valid(_player):
		return

	var spell_lines: Array[String] = []
	var skill_entries := _build_hud_skill_entries()
	if _is_thunder_character():
		spell_lines = [
			"连锁闪电 %d 级  连锁 %d" % [_chain_level, _get_chain_target_count()],
			"电荷爆裂 %d 级  概率 %.0f%%" % [_detonate_level, _get_detonate_chance() * 100.0],
			"雷球领域 %d 级  半径 %.0f" % [_storm_orb_level, _get_storm_orb_radius()],
			"雷霆进化 %d 级  雷暴 %.0f%%" % [_ascension_level, _get_thunder_strike_proc_chance() * 100.0],
		]
	elif _is_blade_character():
		spell_lines = [
			"钢刃斩 %d 级  半圆挥击  刀气 %.0f" % [_slash_level, _get_slash_wave_range()],
			"旋刃护环 %d 级  刀刃 %d" % [_blade_ring_level, _get_blade_ring_count()],
			"残月斩 %d 级  刀波 %d  穿透 %d" % [_mooncut_level, _get_mooncut_projectile_count(), _get_mooncut_pierce()],
			"踏空圆斩 %d 级  半径 %.0f" % [_step_slash_level, _get_step_slash_radius()],
			"变异技能：%s" % _get_blade_mutation_text(),
		]
	else:
		spell_lines = [
			"奥术箭 %d 级  数量 %d  穿透 %d" % [_bolt_level, _get_bolt_count(), _get_bolt_pierce()],
			"环轨核心 %d 级  卫星 %d" % [_orbit_level, _get_orbit_count()],
			"新星爆发 %d 级  投射物 %d" % [_nova_level, _get_nova_projectile_count()],
			"雷暴牵引 %d 级  目标 %d" % [_storm_level, _get_storm_target_count()],
		]

	var threat_text := "%s   角色 %s   威胁 %d   经验 %.2f   冷却 %.2f" % [
		_get_objective_text(),
		_get_current_character_name(),
		_get_wave_rank(),
		_get_xp_gain_multiplier(),
		_get_cooldown_multiplier(),
	]
	_hud.set_run_stats(
		_level,
		_player.health,
		_player.max_health,
		_experience / maxf(_xp_to_next, 1.0),
		_format_time(_run_time),
		_kills,
		threat_text,
		spell_lines,
		skill_entries
	)


func _build_hud_skill_entries() -> Array[Dictionary]:
	if _is_thunder_character():
		return [
			_make_hud_skill_entry(
				"连锁闪电",
				"chain",
				_chain_level,
				true,
				false,
				maxf(_chain_timer, 0.0),
				_get_chain_cooldown(),
				Color(0.48, 0.82, 1.0),
				"连锁闪电 Lv.%d\n可攻击 %d 个敌人\n起跳范围 %.0f，跳跃范围 %.0f\n伤害 %d，冷却 %.1fs" % [_chain_level, _get_chain_target_count(), _get_chain_initial_range(), _get_chain_bounce_range(), _get_chain_damage(), _get_chain_cooldown()],
				"x%d" % _get_chain_target_count()
			),
			_make_hud_skill_entry(
				"电荷爆裂",
				"detonate",
				_detonate_level,
				_detonate_level > 0,
				true,
				0.0,
				0.0,
				Color(0.88, 0.96, 1.0),
				"电荷爆裂 Lv.%d\n击败敌人时有 %.0f%% 概率爆炸\n爆炸半径 %.0f，伤害 %d" % [_detonate_level, _get_detonate_chance() * 100.0, _get_detonate_radius(), _get_detonate_damage()],
				"%.0f%%" % (_get_detonate_chance() * 100.0)
			),
			_make_hud_skill_entry(
				"雷球领域",
				"storm_orb",
				_storm_orb_level,
				_storm_orb_level > 0,
				false,
				maxf(_storm_orb_timer, 0.0),
				_get_storm_orb_cooldown(),
				Color(0.64, 0.88, 1.0),
				"雷球领域 Lv.%d\n持续 %.1fs，半径 %.0f\n每次脉冲最多连锁 %d 个目标\n伤害 %d，冷却 %.1fs" % [_storm_orb_level, _get_storm_orb_duration(), _get_storm_orb_radius(), _get_storm_orb_target_count(), _get_storm_orb_damage(), _get_storm_orb_cooldown()],
				"x%d" % _get_storm_orb_target_count()
			),
			_make_hud_skill_entry(
				"雷霆进化",
				"ascension",
				_ascension_level,
				_ascension_level > 0,
				true,
				0.0,
				0.0,
				Color(0.98, 0.92, 0.68),
				"雷霆进化 Lv.%d\n连锁闪电 +%d\n全部闪电伤害 +200%%\n攻击有 %.0f%% 概率触发雷暴打击" % [_ascension_level, _get_ascension_chain_bonus(), _get_thunder_strike_proc_chance() * 100.0],
				"进化"
			),
		]
	if _is_blade_character():
		return [
			_make_hud_skill_entry(
				"钢刃斩",
				"slash",
				_slash_level,
				true,
				false,
				maxf(_slash_timer, 0.0),
				_get_slash_cooldown(),
				Color(1.0, 0.58, 0.34),
				"钢刃斩 Lv.%d\n半圆挥击，可命中 %d 个目标\n斩击距离 %.0f，刀气推进 %.0f，刀气半径 %.0f\n斩击伤害 %d，刀气伤害 %d\n刀气穿透敌人并递减伤害，最低保留 40%%\n冷却 %.1fs" % [_slash_level, _get_slash_target_count(), _get_slash_range(), _get_slash_wave_range(), _get_slash_wave_radius(), _get_slash_damage(), _get_slash_wave_damage(), _get_slash_cooldown()]
					+ ("\n变异：火焰刀气命中后分裂为三道" if _flame_split_mutation else ""),
				"x%d" % _get_slash_target_count() if _get_slash_target_count() > 1 else ""
			),
			_make_hud_skill_entry(
				"旋刃环",
				"blade_ring",
				_blade_ring_level,
				_blade_ring_level > 0,
				true,
				0.0,
				0.0,
				Color(0.86, 0.92, 0.98),
				"旋刃护环 Lv.%d\n被动技能，刀刃数量 %d\n半径 %.0f，伤害 %d" % [_blade_ring_level, _get_blade_ring_count(), _get_blade_ring_radius(), _get_blade_ring_damage()],
				"被动"
			),
			_make_hud_skill_entry(
				"残月斩",
				"mooncut",
				_mooncut_level,
				_mooncut_level > 0,
				false,
				maxf(_mooncut_timer, 0.0),
				_get_mooncut_cooldown(),
				Color(1.0, 0.68, 0.40),
				"残月斩 Lv.%d\n刀波 %d，穿透 %d\n射程 %.0f，伤害 %d，冷却 %.1fs" % [_mooncut_level, _get_mooncut_projectile_count(), _get_mooncut_pierce(), _get_mooncut_range(), _get_mooncut_damage(), _get_mooncut_cooldown()],
				"x%d" % _get_mooncut_projectile_count() if _get_mooncut_projectile_count() > 1 else ""
			),
			_make_hud_skill_entry(
				"踏空斩",
				"step_slash",
				_step_slash_level,
				_step_slash_level > 0,
				false,
				maxf(_step_slash_timer, 0.0),
				_get_step_slash_cooldown(),
				Color(1.0, 0.84, 0.42),
				"踏空圆斩 Lv.%d\n搜索距离 %.0f，范围 %.0f\n伤害 %d，冷却 %.1fs" % [_step_slash_level, _get_step_slash_search_range(), _get_step_slash_radius(), _get_step_slash_damage(), _get_step_slash_cooldown()]
					+ ("\n变异：处决场已激活" if _execution_mutation else ""),
				""
			),
		]

	return [
		_make_hud_skill_entry(
			"奥术箭",
			"bolt",
			_bolt_level,
			true,
			false,
			maxf(_bolt_timer, 0.0),
			_get_bolt_cooldown(),
			Color(0.44, 0.84, 1.0),
			"奥术箭 Lv.%d\n数量 %d，穿透 %d\n伤害 %d，冷却 %.1fs" % [_bolt_level, _get_bolt_count(), _get_bolt_pierce(), _get_bolt_damage(), _get_bolt_cooldown()],
			"x%d" % _get_bolt_count() if _get_bolt_count() > 1 else ""
		),
		_make_hud_skill_entry(
			"环轨核",
			"orbit",
			_orbit_level,
			_orbit_level > 0,
			true,
			0.0,
			0.0,
			Color(0.40, 0.98, 0.88),
			"环轨核心 Lv.%d\n被动技能，卫星数量 %d\n半径 %.0f，伤害 %d" % [_orbit_level, _get_orbit_count(), _get_orbit_radius(), _get_orbit_damage()],
			"被动"
		),
		_make_hud_skill_entry(
			"新星",
			"nova",
			_nova_level,
			_nova_level > 0,
			false,
			maxf(_nova_timer, 0.0),
			_get_nova_cooldown(),
			Color(1.0, 0.80, 0.36),
			"新星爆发 Lv.%d\n投射物 %d\n伤害 %d，冷却 %.1fs" % [_nova_level, _get_nova_projectile_count(), _get_nova_damage(), _get_nova_cooldown()],
			"x%d" % _get_nova_projectile_count()
		),
		_make_hud_skill_entry(
			"雷暴",
			"storm",
			_storm_level,
			_storm_level > 0,
			false,
			maxf(_storm_timer, 0.0),
			_get_storm_cooldown(),
			Color(0.62, 0.78, 1.0),
			"雷暴牵引 Lv.%d\n目标 %d\n伤害 %d，冷却 %.1fs" % [_storm_level, _get_storm_target_count(), _get_storm_damage(), _get_storm_cooldown()],
			"x%d" % _get_storm_target_count()
		),
	]


func _make_hud_skill_entry(
	name: String,
	icon_id: String,
	level: int,
	unlocked: bool,
	passive: bool,
	cooldown_remaining: float,
	cooldown_max: float,
	accent: Color,
	tooltip: String,
	meta: String = ""
) -> Dictionary:
	var resolved_tooltip := tooltip
	if not unlocked:
		resolved_tooltip = "%s\n尚未解锁" % name

	return {
		"name": name,
		"icon_id": icon_id,
		"level": maxi(level, 0),
		"unlocked": unlocked,
		"passive": passive,
		"cooldown_remaining": cooldown_remaining if unlocked and not passive else 0.0,
		"cooldown_max": cooldown_max if unlocked and not passive else 0.0,
		"accent": accent,
		"tooltip": resolved_tooltip,
		"meta": meta if unlocked else "",
	}


func _update_hud() -> void:
	_update_character_hud()
	return

	if _player == null or not is_instance_valid(_player):
		return

	var spell_lines := [
		"奥术弹 %d级  数量 %d  穿透 %d" % [_bolt_level, _get_bolt_count(), _get_bolt_pierce()],
		"环轨卫星 %d级  数量 %d" % [_orbit_level, _get_orbit_count()],
		"新星爆发 %d级  投射物 %d" % [_nova_level, _get_nova_projectile_count()],
		"雷暴召引 %d级  目标 %d" % [_storm_level, _get_storm_target_count()],
	]
	var threat_text := "%s   威胁 %d   经验 %.2f   冷却 %.2f" % [
		_get_objective_text(),
		_get_wave_rank(),
		_get_xp_gain_multiplier(),
		_get_cooldown_multiplier(),
	]
	_hud.set_run_stats(
		_level,
		_player.health,
		_player.max_health,
		_experience / maxf(_xp_to_next, 1.0),
		_format_time(_run_time),
		_kills,
		threat_text,
		spell_lines
	)


func _get_objective_text() -> String:
	if _is_endless_mode():
		if _boss_spawned and _boss_enemy != null and is_instance_valid(_boss_enemy):
			return "%s   无尽首领：%s" % [_get_current_map_name(), _get_current_boss_name()]
		var remaining_endless := maxf(0.0, _get_boss_spawn_time() - _run_time)
		return "%s   无尽模式   下次首领 %s" % [_get_current_map_name(), _format_time(remaining_endless)]
	if _boss_defeated:
		return "%s 已肃清" % _get_current_map_name()
	if _boss_spawned and _boss_enemy != null and is_instance_valid(_boss_enemy):
		return "%s   首领：%s" % [_get_current_map_name(), _get_current_boss_name()]
	var remaining := maxf(0.0, _get_boss_spawn_time() - _run_time)
	return "%s   首领倒计时 %s" % [_get_current_map_name(), _format_time(remaining)]


func _open_pause_menu() -> void:
	if _state != GameState.PLAYING:
		return
	_release_direction_actions()
	_state = GameState.PAUSED
	_hud.show_pause_menu(_is_endless_mode())
	_hud.set_message("")
	_message_timer = 0.0
	_set_pause_state(true)


func _resume_from_pause() -> void:
	if _state != GameState.PAUSED:
		return
	_hud.hide_pause_menu()
	_hud.set_message("")
	_message_timer = 0.0
	_state = GameState.PLAYING
	_set_pause_state(false)
	_update_hud()


func _exit_to_menu_from_pause() -> void:
	if _state != GameState.PAUSED:
		return
	_hud.hide_pause_menu()
	_hud.set_message("")
	_message_timer = 0.0
	_show_menu()


func _show_message(text: String, color: Color, duration: float = MESSAGE_DURATION) -> void:
	_hud.set_message(text, color)
	_message_timer = maxf(duration, 0.0)


func _build_record_result_suffix(record_result: Dictionary) -> String:
	var best_kills := int(record_result.get("best_kills", 0))
	var result_suffix := "\n历史记录：单局最高击败 %d。" % best_kills
	if bool(record_result.get("is_new_record", false)):
		result_suffix += "\n本次战斗刷新了该地图纪录。"
	return result_suffix


func _end_run_as_surrender() -> void:
	_release_direction_actions()
	_state = GameState.GAME_OVER
	_set_pause_state(true)
	_hud.hide_upgrade_choices()
	_hud.hide_pause_menu()
	var record_result := _record_map_best_kills(_selected_map_id, _kills)
	_record_run_history(false, true)
	var mode_label := "无尽模式" if _is_endless_mode() else "当前战斗"
	_hud.show_result(
		"主动结束",
		"你主动结束了 %s，在 %s 中坚持了 %s，击败了 %d 名敌人。角色：%s。%s" % [mode_label, _get_current_map_name(), _format_time(_run_time), _kills, _get_current_character_name(), _build_record_result_suffix(record_result)],
		"返回选图"
	)
	_show_message("本局已主动结束", Color(1.0, 0.74, 0.58), 99.0)


func _on_player_died() -> void:
	_release_direction_actions()
	_clear_dot_damage_buffer(_player)
	_state = GameState.GAME_OVER
	_set_pause_state(true)
	_hud.hide_upgrade_choices()
	_hud.hide_pause_menu()
	var record_result := _record_map_best_kills(_selected_map_id, _kills)
	_record_run_history(false)
	_hud.show_result(
		"作战失败",
		"你在 %s 中坚持了 %s，击败了 %d 名敌人。返回选图后可再次挑战。%s" % [_get_current_map_name(), _format_time(_run_time), _kills, _build_record_result_suffix(record_result)],
		"返回选图"
	)
	_show_message("战斗结束", Color(1.0, 0.68, 0.54), 99.0)


func _on_player_damaged(_current_health: int) -> void:
	_audio.play_damage(true)


func _on_run_cleared() -> void:
	_release_direction_actions()
	_state = GameState.VICTORY
	_set_pause_state(true)
	_hud.hide_upgrade_choices()
	_hud.hide_pause_menu()
	var record_result := _record_map_best_kills(_selected_map_id, _kills)
	_record_run_history(true)
	_hud.show_result(
		"区域肃清",
		"你成功完成了 %s，击败 %d 名敌人，并坚持了 %s。%s" % [_get_current_map_name(), _kills, _format_time(_run_time), _build_record_result_suffix(record_result)],
		"返回选图"
	)
	_show_message("%s 已肃清" % _get_current_map_name(), Color(0.86, 0.98, 1.0), 99.0)


func _cleanup_far_entities() -> void:
	for index in range(_enemies.size() - 1, -1, -1):
		var enemy := _enemies[index]
		if enemy == null or not is_instance_valid(enemy):
			_enemies.remove_at(index)
			continue
		if enemy.is_boss():
			continue
		var distance_sq := enemy.global_position.distance_squared_to(_player.global_position)
		if distance_sq > 2600.0 * 2600.0:
			_clear_dot_damage_buffer(enemy)
			enemy.queue_free()
			_enemies.remove_at(index)

	for index in range(_projectiles.size() - 1, -1, -1):
		var projectile := _projectiles[index]
		if projectile == null or not is_instance_valid(projectile):
			_projectiles.remove_at(index)

	for index in range(_orbs.size() - 1, -1, -1):
		var orb := _orbs[index]
		if orb == null or not is_instance_valid(orb):
			_orbs.remove_at(index)
			continue
		var orb_distance_sq := orb.global_position.distance_squared_to(_player.global_position)
		if orb_distance_sq > 2200.0 * 2200.0 or (_orbs.size() > _max_orb_count and orb_distance_sq > 1400.0 * 1400.0):
			orb.queue_free()
			_orbs.remove_at(index)

func _get_player_speed() -> float:
	var base_speed := 240.0
	if _is_blade_character():
		base_speed = 248.0
	elif _is_thunder_character():
		base_speed = 244.0
	return base_speed + float(_stride_level) * 22.0


func _get_player_max_health() -> int:
	var base_health := 8
	if _is_blade_character():
		base_health = 10
	elif _is_thunder_character():
		base_health = 9
	return base_health + _vitality_level * 2


func _get_player_pickup_radius() -> float:
	var base_radius := 140.0
	if _is_blade_character():
		base_radius = 132.0
	elif _is_thunder_character():
		base_radius = 146.0
	return base_radius + float(_magnet_level) * 50.0


func _get_spell_power_multiplier() -> float:
	return 1.0 + float(_mastery_level) * 0.16


func _get_xp_gain_multiplier() -> float:
	return 1.0 + float(_mastery_level) * 0.10


func _get_cooldown_multiplier() -> float:
	return maxf(0.58, 1.0 - float(_focus_level) * 0.08)


func _get_bolt_count() -> int:
	return 1 + int(_bolt_level / 2)


func _get_bolt_damage() -> int:
	return int(round((16.0 + float(_bolt_level - 1) * 5.0) * _get_spell_power_multiplier()))


func _get_bolt_pierce() -> int:
	return 1 + int((_bolt_level - 1) / 3)


func _get_bolt_cooldown() -> float:
	return maxf(0.18, (0.82 - float(_bolt_level - 1) * 0.06) * _get_cooldown_multiplier())


func _get_orbit_count() -> int:
	return _orbit_level


func _get_orbit_damage() -> int:
	return int(round((10.0 + float(max(_orbit_level - 1, 0)) * 4.0) * _get_spell_power_multiplier()))


func _get_orbit_radius() -> float:
	return 88.0 + float(max(_orbit_level - 1, 0)) * 12.0


func _get_orbit_speed() -> float:
	return 2.0 + float(_orbit_level) * 0.22


func _get_nova_projectile_count() -> int:
	return 8 + _nova_level * 2


func _get_nova_damage() -> int:
	return int(round((20.0 + float(max(_nova_level - 1, 0)) * 7.0) * _get_spell_power_multiplier()))


func _get_nova_cooldown() -> float:
	return maxf(2.4, (5.6 - float(max(_nova_level - 1, 0)) * 0.45) * _get_cooldown_multiplier())


func _get_storm_target_count() -> int:
	return 2 + _storm_level


func _get_storm_damage() -> int:
	return int(round((28.0 + float(max(_storm_level - 1, 0)) * 9.0) * _get_spell_power_multiplier()))


func _get_storm_cooldown() -> float:
	return maxf(2.8, (6.0 - float(max(_storm_level - 1, 0)) * 0.48) * _get_cooldown_multiplier())


func _get_lightning_power_multiplier() -> float:
	return _get_spell_power_multiplier() * (3.0 if _ascension_level > 0 else 1.0)


func _get_chain_target_count() -> int:
	return 5 + max(_chain_level - 1, 0) + _get_ascension_chain_bonus()


func _get_chain_damage() -> int:
	return int(round((20.0 + float(max(_chain_level - 1, 0)) * 6.0) * _get_lightning_power_multiplier()))


func _get_chain_cooldown() -> float:
	return maxf(0.30, (0.86 - float(max(_chain_level - 1, 0)) * 0.04) * _get_cooldown_multiplier())


func _get_chain_initial_range() -> float:
	return 360.0 + float(max(_chain_level - 1, 0)) * 18.0


func _get_chain_bounce_range() -> float:
	return 188.0 + float(max(_chain_level - 1, 0)) * 10.0


func _get_chain_knockback() -> float:
	return 168.0 + float(max(_chain_level - 1, 0)) * 10.0


func _get_detonate_chance() -> float:
	return minf(0.20 * float(_detonate_level), 0.75)


func _get_detonate_damage() -> int:
	return int(round((18.0 + float(max(_detonate_level - 1, 0)) * 12.0) * _get_lightning_power_multiplier()))


func _get_detonate_radius() -> float:
	return 72.0 + float(max(_detonate_level - 1, 0)) * 18.0


func _get_storm_orb_damage() -> int:
	return int(round((16.0 + float(max(_storm_orb_level - 1, 0)) * 8.0) * _get_lightning_power_multiplier()))


func _get_storm_orb_radius() -> float:
	return 132.0 + float(max(_storm_orb_level - 1, 0)) * 18.0


func _get_storm_orb_duration() -> float:
	return 5.0


func _get_storm_orb_cooldown() -> float:
	return maxf(3.0, (7.2 - float(max(_storm_orb_level - 1, 0)) * 0.42) * _get_cooldown_multiplier())


func _get_storm_orb_pulse_interval() -> float:
	return maxf(0.28, 0.72 - float(max(_storm_orb_level - 1, 0)) * 0.08)


func _get_storm_orb_target_count() -> int:
	return min(_get_chain_target_count(), 2 + _storm_orb_level * 2 + int(_ascension_level > 0))


func _get_storm_orb_cast_range() -> float:
	return 460.0 + float(max(_storm_orb_level - 1, 0)) * 22.0


func _get_ascension_chain_bonus() -> int:
	return 5 * _ascension_level


func _get_thunder_strike_proc_chance() -> float:
	return 0.5 if _ascension_level > 0 else 0.0


func _get_thunder_strike_damage() -> int:
	return int(round((34.0 + float(max(_chain_level - 1, 0)) * 9.0) * _get_lightning_power_multiplier()))


func _get_thunder_strike_radius() -> float:
	return 82.0 + float(max(_storm_orb_level - 1, 0)) * 10.0


func _get_slash_target_count() -> int:
	return 1 + int((_slash_level - 1) / 3)


func _get_slash_damage() -> int:
	return int(round((22.0 + float(_slash_level - 1) * 6.0) * _get_spell_power_multiplier()))


func _get_slash_range() -> float:
	return 88.0 + float(max(_slash_level - 1, 0)) * 10.0


func _get_slash_search_range() -> float:
	return maxf(_get_slash_range() + 24.0, _get_slash_wave_range())


func _get_slash_wave_damage() -> int:
	return int(round((14.0 + float(max(_slash_level - 1, 0)) * 4.0) * _get_spell_power_multiplier()))


func _get_slash_wave_range() -> float:
	return 132.0 + float(max(_slash_level - 1, 0)) * 28.0


func _get_slash_wave_radius() -> float:
	return 14.0 + float(max(_slash_level - 1, 0)) * 1.8


func _get_slash_wave_speed() -> float:
	return 460.0 + float(max(_slash_level - 1, 0)) * 8.0


func _get_slash_arc_span() -> float:
	return PI


func _get_slash_cooldown() -> float:
	return maxf(0.22, (0.76 - float(max(_slash_level - 1, 0)) * 0.05) * _get_cooldown_multiplier())


func _get_slash_knockback() -> float:
	return 220.0 + float(max(_slash_level - 1, 0)) * 14.0


func _get_blade_ring_count() -> int:
	return _blade_ring_level


func _get_blade_ring_damage() -> int:
	return int(round((12.0 + float(max(_blade_ring_level - 1, 0)) * 5.0) * _get_spell_power_multiplier()))


func _get_blade_ring_radius() -> float:
	return 74.0 + float(max(_blade_ring_level - 1, 0)) * 14.0


func _get_blade_ring_speed() -> float:
	return 2.6 + float(_blade_ring_level) * 0.34


func _get_mooncut_projectile_count() -> int:
	if _mooncut_level <= 0:
		return 0
	return 1 + int((_mooncut_level - 1) / 2)


func _get_mooncut_damage() -> int:
	return int(round((26.0 + float(max(_mooncut_level - 1, 0)) * 8.0) * _get_spell_power_multiplier()))


func _get_mooncut_pierce() -> int:
	return 1 + int(max(_mooncut_level - 1, 0) / 2) + int(_rend_mutation)


func _get_mooncut_range() -> float:
	return 320.0 + float(max(_mooncut_level - 1, 0)) * 42.0


func _get_mooncut_cooldown() -> float:
	return maxf(2.2, (5.0 - float(max(_mooncut_level - 1, 0)) * 0.42) * _get_cooldown_multiplier())


func _get_step_slash_damage() -> int:
	return int(round((32.0 + float(max(_step_slash_level - 1, 0)) * 10.0) * _get_spell_power_multiplier()))


func _get_step_slash_search_range() -> float:
	return 260.0 + float(max(_step_slash_level - 1, 0)) * 56.0


func _get_step_slash_radius() -> float:
	return 72.0 + float(max(_step_slash_level - 1, 0)) * 12.0


func _get_step_slash_cooldown() -> float:
	return maxf(3.1, (6.4 - float(max(_step_slash_level - 1, 0)) * 0.50) * _get_cooldown_multiplier())


func _get_step_slash_knockback() -> float:
	return 320.0 + float(max(_step_slash_level - 1, 0)) * 18.0


func _get_execution_radius() -> float:
	return 92.0


func _get_execution_damage() -> int:
	return max(1, int(round(float(_get_step_slash_damage()) * 0.66)))


func _get_blade_mutation_text() -> String:
	var names: Array[String] = []
	if _flame_split_mutation:
		names.append("焰刃分裂")
	if _rend_mutation:
		names.append("裂月")
	if _execution_mutation:
		names.append("处决场")
	if names.is_empty():
		return "暂无"
	return ", ".join(names)


func _get_xp_needed(level: int) -> float:
	return 6.0 + pow(float(level - 1), 1.34) * 4.2


func _get_wave_rank() -> int:
	var rank := 1 + int(_run_time / 50.0) + int((_level - 1) / 2)
	if _is_endless_mode():
		return maxi(rank, 1)
	return clampi(rank, 1, 12)


func _format_time(time_seconds: float) -> String:
	var total_seconds := int(floor(time_seconds))
	var minutes := int(total_seconds / 60)
	var seconds := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]


func _setup_input_map() -> void:
	_set_action_keys("move_left", [KEY_A, KEY_LEFT])
	_set_action_keys("move_right", [KEY_D, KEY_RIGHT])
	_set_action_keys("move_up", [KEY_W, KEY_UP])
	_set_action_keys("move_down", [KEY_S, KEY_DOWN])
	_set_action_keys("confirm", [KEY_ENTER, KEY_SPACE])
	_set_action_keys("pause", [KEY_ESCAPE, KEY_P])
	_set_action_keys("upgrade_1", [KEY_1, KEY_KP_1])
	_set_action_keys("upgrade_2", [KEY_2, KEY_KP_2])
	_set_action_keys("upgrade_3", [KEY_3, KEY_KP_3])


func _set_action_keys(action: StringName, keycodes: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for existing_event in InputMap.action_get_events(action):
		InputMap.action_erase_event(action, existing_event)
	for keycode in keycodes:
		var event := InputEventKey.new()
		event.physical_keycode = keycode
		event.keycode = keycode
		InputMap.action_add_event(action, event)


func _configure_runtime_limits() -> void:
	if _mobile_layout:
		_max_enemy_count = 74
		_max_orb_count = 54
	else:
		_max_enemy_count = 108
		_max_orb_count = 90


func _on_viewport_size_changed() -> void:
	_mobile_layout = _is_mobile_layout()
	_configure_runtime_limits()
	if not _mobile_layout:
		_reset_touch_move_state()


func _set_pause_state(paused: bool) -> void:
	if paused or _state != GameState.PLAYING:
		_reset_touch_move_state()
	get_tree().paused = paused
	_hud.set_touch_controls_visible(not paused and _state == GameState.PLAYING)
	_hud.set_pause_button_visible(_state == GameState.PLAYING)


func _apply_touch_move_vector(vector: Vector2) -> void:
	_touch_move_vector = vector.limit_length(1.0)
	if _player != null and is_instance_valid(_player):
		_player.set_touch_move_vector(_touch_move_vector)


func _update_camera(delta: float) -> void:
	if _camera == null or not is_instance_valid(_camera) or _player == null or not is_instance_valid(_player):
		return
	var follow_weight := clampf(delta * 7.5, 0.0, 1.0)
	_camera.global_position = _camera.global_position.lerp(_player.global_position, follow_weight)


func _is_position_blocked(test_position: Vector2, radius: float) -> bool:
	var query := PhysicsShapeQueryParameters2D.new()
	var shape := CircleShape2D.new()
	shape.radius = radius
	query.shape = shape
	query.transform = Transform2D(0.0, test_position)
	query.collision_mask = 4
	query.collide_with_bodies = true
	query.collide_with_areas = false
	var result := get_world_2d().direct_space_state.intersect_shape(query, 1)
	return not result.is_empty()


func _on_upgrade_selected(index: int) -> void:
	if _state == GameState.LEVEL_UP:
		_apply_upgrade_choice(index)


func _on_restart_requested() -> void:
	if _state == GameState.GAME_OVER or _state == GameState.VICTORY:
		_show_menu()


func _on_pause_requested() -> void:
	if _state == GameState.PLAYING:
		_open_pause_menu()


func _on_pause_resume_requested() -> void:
	if _state == GameState.PAUSED:
		_resume_from_pause()


func _on_pause_suicide_requested() -> void:
	if _state != GameState.PAUSED:
		return
	_hud.hide_pause_menu()
	_hud.set_message("")
	_message_timer = 0.0
	_end_run_as_surrender()


func _on_pause_exit_requested() -> void:
	if _state == GameState.PAUSED:
		_exit_to_menu_from_pause()


func _on_touch_move_changed(vector: Vector2) -> void:
	if _state != GameState.PLAYING:
		_apply_touch_move_vector(Vector2.ZERO)
		return
	_apply_touch_move_vector(vector)


func _on_map_selected(map_id: String) -> void:
	_handle_menu_map_selected(map_id)
	return

	if _state != GameState.MENU:
		return
	_set_current_map(map_id)
	_hud.set_run_stats(
		1,
		0,
		1,
		0.0,
		"00:00",
		0,
		"地图：%s   首领：%s" % [_get_current_map_name(), _get_current_boss_name()],
		[
			"敌群：%s" % _format_enemy_label_list(),
			"按 Enter / 空格开始。ESC、P 或暂停按钮可暂停战斗。",
		]
	)


func _on_map_start_requested(map_id: String, character_id: String = "", run_mode_id: String = RUN_MODE_NORMAL) -> void:
	_selected_character_id = _sanitize_character_id(character_id)
	_selected_run_mode_id = _sanitize_run_mode(run_mode_id)
	_set_current_map(map_id)
	_start_run()


func _on_character_selected(character_id: String) -> void:
	if _state != GameState.MENU:
		return
	_selected_character_id = _sanitize_character_id(character_id)
	if _player != null and is_instance_valid(_player):
		_player.set_character(_selected_character_id)
	_update_menu_preview()


func _on_menu_volume_changed(volume_ratio: float) -> void:
	_master_volume_ratio = clampf(volume_ratio, 0.0, 1.0)
	if _audio != null and is_instance_valid(_audio):
		_audio.set_master_volume_ratio(_master_volume_ratio)
	_save_profile_data()


func _handle_menu_map_selected(map_id: String) -> void:
	if _state != GameState.MENU:
		return
	_set_current_map(map_id)
	_update_menu_preview()


func _update_menu_preview() -> void:
	var skill_lines: Array[String] = []
	if _is_thunder_character():
		skill_lines = [
			"角色：闪电哥",
			"基础技能：连锁闪电，可攻击 5 个敌人",
			"后续技能：电荷爆裂、雷球领域、雷霆进化",
		]
	elif _is_blade_character():
		skill_lines = [
			"角色：刀客",
			"初始技能：钢刃斩",
			"后续技能：旋刃护环、残月斩、踏空圆斩",
		]
	else:
		skill_lines = [
			"角色：秘术师",
			"初始技能：奥术箭",
			"后续技能：环轨核心、新星爆发、雷暴牵引",
		]

	_hud.set_run_stats(
		1,
		_get_player_max_health(),
		_get_player_max_health(),
		0.0,
		"00:00",
		0,
		"地图：%s   首领：%s" % [_get_current_map_name(), _get_current_boss_name()],
		skill_lines
	)


func _on_projectile_finished(projectile: SpellProjectile) -> void:
	_projectiles.erase(projectile)


func _on_projectile_split_requested(projectile: SpellProjectile) -> void:
	if projectile == null or not is_instance_valid(projectile):
		return
	if _projectile_root == null or not is_instance_valid(_projectile_root):
		return

	var base_direction := projectile.direction.normalized()
	if base_direction == Vector2.ZERO:
		base_direction = Vector2.RIGHT

	var child_count := maxi(projectile.split_count, 0)
	if child_count <= 0:
		return

	_spawn_effect(projectile.global_position, maxf(18.0, projectile.radius * 2.2), Color(1.0, 0.88, 0.54), Color(1.0, 0.40, 0.18), 0.14)
	var start_angle := -projectile.split_spread * float(child_count - 1) * 0.5
	for index in range(child_count):
		var child_direction := base_direction.rotated(start_angle + projectile.split_spread * float(index))
		var child: SpellProjectile = PROJECTILE_SCRIPT.new()
		child.global_position = projectile.global_position + child_direction * maxf(8.0, projectile.radius * 0.8)
		child.direction = child_direction
		child.damage = max(1, int(round(float(projectile.damage) * projectile.split_damage_scale)))
		child.speed = projectile.speed * projectile.split_speed_scale
		child.radius = maxf(5.0, projectile.radius * projectile.split_radius_scale)
		child.pierce = maxi(1, projectile.split_child_pierce)
		child.max_distance = projectile.max_distance * projectile.split_range_scale
		child.knockback = projectile.knockback * projectile.split_knockback_scale
		child.tint = projectile.tint
		child.secondary_tint = projectile.secondary_tint
		child.visual_style = projectile.visual_style if projectile.split_visual_style.is_empty() else projectile.split_visual_style
		child.split_generation = projectile.split_generation + 1
		child.split_max_generations = projectile.split_max_generations
		child.split_on_hit = child.split_generation < child.split_max_generations
		child.split_count = projectile.split_count
		child.split_spread = projectile.split_spread
		child.split_damage_scale = projectile.split_damage_scale
		child.split_speed_scale = projectile.split_speed_scale
		child.split_range_scale = projectile.split_range_scale
		child.split_radius_scale = projectile.split_radius_scale
		child.split_knockback_scale = projectile.split_knockback_scale
		child.split_child_pierce = projectile.split_child_pierce
		child.split_visual_style = projectile.split_visual_style
		child.damage_falloff_on_hit = projectile.damage_falloff_on_hit
		child.damage_falloff_factor = projectile.damage_falloff_factor
		child.min_damage_multiplier = projectile.min_damage_multiplier
		_register_projectile(child)


func _on_orb_collected(orb: ExperienceOrb, value: int) -> void:
	_orbs.erase(orb)
	_experience += float(value) * _get_xp_gain_multiplier()
	_audio.play_pickup()
	while _experience >= _xp_to_next and _state == GameState.PLAYING:
		_experience -= _xp_to_next
		_level += 1
		_xp_to_next = _get_xp_needed(_level)
		_open_level_up()
	_update_hud()


func _on_enemy_defeated(enemy: EnemySoldier, experience_value: int) -> void:
	_enemies.erase(enemy)
	_clear_dot_damage_buffer(enemy)
	_kills += 1
	_spawn_orb(enemy.global_position, experience_value)
	if _is_thunder_character() and enemy != _boss_enemy:
		_try_trigger_detonate(enemy.global_position)
	if enemy == _boss_enemy:
		_boss_enemy = null
		_boss_spawned = false
		_spawn_effect(enemy.global_position, 150.0, Color(1.0, 0.86, 0.56), Color(1.0, 0.40, 0.20), 0.60)
		_audio.play_kill(true)
		if _is_endless_mode():
			_schedule_next_boss_spawn()
			_show_message("%s 已被击退，下一波首领正在逼近。" % _get_current_boss_name(), Color(1.0, 0.88, 0.60), 2.8)
			_update_hud()
			return
		_boss_defeated = true
		_on_run_cleared()
		return

	_audio.play_kill(false)


func _on_enemy_special_attack(position: Vector2, radius: float, primary_color: Color, secondary_color: Color) -> void:
	_spawn_effect(position, radius, primary_color, secondary_color, 0.36 if radius < 90.0 else 0.50)
	_audio.play_enemy_shot(radius >= 90.0)


func _on_enemy_summon_requested(position: Vector2, summon_type: String, count: int, radius: float) -> void:
	var spawn_total := mini(count, max(0, _get_active_enemy_cap() - _enemies.size()))
	for index in range(spawn_total):
		var angle := TAU * float(index) / float(max(spawn_total, 1)) + _rng.randf_range(-0.25, 0.25)
		var spawn_position := position + Vector2.RIGHT.rotated(angle) * _rng.randf_range(radius * 0.45, radius)
		if _is_position_blocked(spawn_position, 18.0):
			spawn_position = _find_spawn_position(320.0, 680.0, 18.0)
		_spawn_enemy(summon_type, false, {"spawn_position": spawn_position, "wave_rank": _get_wave_rank()})


func _on_meteor_impact(position: Vector2, radius: float, current_health_ratio: float, knockback: float) -> void:
	_spawn_effect(position, radius * 1.16, Color(1.0, 0.84, 0.46), Color(1.0, 0.34, 0.16), 0.42)
	_apply_area_current_health_damage(position, radius, current_health_ratio, knockback)
	_audio.play_enemy_shot(true)


func _on_poison_cloud_pulse(position: Vector2, radius: float, ratio_per_second: float, elapsed_time: float, knockback: float) -> void:
	_apply_area_max_health_damage_over_time(position, radius, ratio_per_second, elapsed_time, knockback)


func _set_current_map(map_id: String) -> void:
	if map_id.is_empty():
		map_id = String(MAP_DEFINITIONS[0].get("id", "sky_ruins"))
	_selected_map_id = map_id
	_current_map = _get_map_definition(map_id)
	_hazard_timer = _roll_hazard_interval()
	if _map_root != null and is_instance_valid(_map_root):
		_map_root.set_palette(_get_current_palette())


func _get_map_definition(map_id: String) -> Dictionary:
	for map_info_variant in MAP_DEFINITIONS:
		var map_info: Dictionary = map_info_variant
		if String(map_info.get("id", "")) == map_id:
			return map_info.duplicate(true)
	return Dictionary(MAP_DEFINITIONS[0]).duplicate(true)


func _load_profile_data() -> void:
	_map_best_kills.clear()
	_career_stats = DEFAULT_CAREER_STATS.duplicate(true)
	_recent_runs.clear()
	_master_volume_ratio = DEFAULT_MASTER_VOLUME
	var config := ConfigFile.new()
	var load_error := config.load(HISTORY_SAVE_PATH)
	if load_error != OK:
		return

	if config.has_section("best_kills"):
		for map_info_variant in MAP_DEFINITIONS:
			var map_info: Dictionary = map_info_variant
			var map_id := String(map_info.get("id", ""))
			if map_id.is_empty():
				continue
			_map_best_kills[map_id] = maxi(int(config.get_value("best_kills", map_id, 0)), 0)

	if config.has_section("career"):
		_career_stats["total_runs"] = maxi(int(config.get_value("career", "total_runs", 0)), 0)
		_career_stats["total_victories"] = maxi(int(config.get_value("career", "total_victories", 0)), 0)
		_career_stats["total_kills"] = maxi(int(config.get_value("career", "total_kills", 0)), 0)
		_career_stats["best_run_kills"] = maxi(int(config.get_value("career", "best_run_kills", 0)), 0)
		_career_stats["best_survival_time"] = maxf(float(config.get_value("career", "best_survival_time", 0.0)), 0.0)
		_career_stats["fastest_clear_time"] = maxf(float(config.get_value("career", "fastest_clear_time", 0.0)), 0.0)

	var saved_recent_runs_variant = config.get_value("history", "recent_runs", [])
	if saved_recent_runs_variant is Array:
		for run_variant in saved_recent_runs_variant:
			if run_variant is Dictionary:
				_recent_runs.append((run_variant as Dictionary).duplicate(true))
			if _recent_runs.size() >= MAX_RECENT_RUNS:
				break

	_master_volume_ratio = clampf(float(config.get_value("settings", "master_volume", DEFAULT_MASTER_VOLUME)), 0.0, 1.0)


func _save_profile_data() -> void:
	var config := ConfigFile.new()
	for map_info_variant in MAP_DEFINITIONS:
		var map_info: Dictionary = map_info_variant
		var map_id := String(map_info.get("id", ""))
		if map_id.is_empty():
			continue
		config.set_value("best_kills", map_id, maxi(int(_map_best_kills.get(map_id, 0)), 0))
	config.set_value("career", "total_runs", maxi(int(_career_stats.get("total_runs", 0)), 0))
	config.set_value("career", "total_victories", maxi(int(_career_stats.get("total_victories", 0)), 0))
	config.set_value("career", "total_kills", maxi(int(_career_stats.get("total_kills", 0)), 0))
	config.set_value("career", "best_run_kills", maxi(int(_career_stats.get("best_run_kills", 0)), 0))
	config.set_value("career", "best_survival_time", maxf(float(_career_stats.get("best_survival_time", 0.0)), 0.0))
	config.set_value("career", "fastest_clear_time", maxf(float(_career_stats.get("fastest_clear_time", 0.0)), 0.0))
	config.set_value("history", "recent_runs", _recent_runs.duplicate(true))
	config.set_value("settings", "master_volume", _master_volume_ratio)
	config.save(HISTORY_SAVE_PATH)


func _build_history_summary() -> Dictionary:
	var summary := _career_stats.duplicate(true)
	var maps_with_records := 0
	for map_info_variant in MAP_DEFINITIONS:
		var map_info: Dictionary = map_info_variant
		var map_id := String(map_info.get("id", ""))
		if maxi(int(_map_best_kills.get(map_id, 0)), 0) > 0:
			maps_with_records += 1
	summary["maps_with_records"] = maps_with_records
	summary["map_count"] = MAP_DEFINITIONS.size()
	return summary


func _record_run_history(victory: bool, surrendered: bool = false) -> void:
	_career_stats["total_runs"] = maxi(int(_career_stats.get("total_runs", 0)), 0) + 1
	_career_stats["total_kills"] = maxi(int(_career_stats.get("total_kills", 0)), 0) + maxi(_kills, 0)
	_career_stats["best_run_kills"] = maxi(int(_career_stats.get("best_run_kills", 0)), maxi(_kills, 0))
	_career_stats["best_survival_time"] = maxf(float(_career_stats.get("best_survival_time", 0.0)), _run_time)
	if victory:
		_career_stats["total_victories"] = maxi(int(_career_stats.get("total_victories", 0)), 0) + 1
		var fastest_clear_time := float(_career_stats.get("fastest_clear_time", 0.0))
		if fastest_clear_time <= 0.0 or _run_time < fastest_clear_time:
			_career_stats["fastest_clear_time"] = _run_time

	var now := Time.get_datetime_dict_from_system()
	var history_entry := {
		"timestamp": "%04d-%02d-%02d %02d:%02d" % [
			int(now.get("year", 0)),
			int(now.get("month", 0)),
			int(now.get("day", 0)),
			int(now.get("hour", 0)),
			int(now.get("minute", 0)),
		],
		"map_id": _selected_map_id,
		"map_name": _get_current_map_name(),
		"character_id": _selected_character_id,
		"character_name": _get_current_character_name(),
		"run_mode_id": _current_run_mode_id,
		"run_mode_name": _get_current_run_mode_name(),
		"kills": maxi(_kills, 0),
		"time_survived": _run_time,
		"victory": victory,
		"surrendered": surrendered,
	}
	_recent_runs.insert(0, history_entry)
	while _recent_runs.size() > MAX_RECENT_RUNS:
		_recent_runs.pop_back()

	_save_profile_data()


func _record_map_best_kills(map_id: String, kills: int) -> Dictionary:
	if map_id.is_empty():
		return {
			"best_kills": maxi(kills, 0),
			"is_new_record": false,
		}
	var previous_best := maxi(int(_map_best_kills.get(map_id, 0)), 0)
	var next_best := maxi(previous_best, kills)
	var is_new_record := kills > previous_best
	if next_best != previous_best:
		_map_best_kills[map_id] = next_best
	elif not _map_best_kills.has(map_id):
		_map_best_kills[map_id] = previous_best
	return {
		"best_kills": next_best,
		"is_new_record": is_new_record,
	}


func _get_current_palette() -> Dictionary:
	return Dictionary(_current_map.get("palette", {}))


func _get_character_definition(character_id: String) -> Dictionary:
	for character_info_variant in CHARACTER_DEFINITIONS:
		var character_info: Dictionary = character_info_variant
		if String(character_info.get("id", "")) == character_id:
			return character_info.duplicate(true)
	return Dictionary(CHARACTER_DEFINITIONS[0]).duplicate(true)


func _sanitize_character_id(character_id: String) -> String:
	var resolved_id := character_id
	if resolved_id.is_empty():
		resolved_id = String(CHARACTER_DEFINITIONS[0].get("id", "caster"))
	for character_info_variant in CHARACTER_DEFINITIONS:
		var character_info: Dictionary = character_info_variant
		if String(character_info.get("id", "")) == resolved_id:
			return resolved_id
	return String(CHARACTER_DEFINITIONS[0].get("id", "caster"))


func _sanitize_run_mode(run_mode_id: String) -> String:
	return RUN_MODE_ENDLESS if run_mode_id == RUN_MODE_ENDLESS else RUN_MODE_NORMAL


func _get_current_run_mode_name() -> String:
	return "无尽模式" if _current_run_mode_id == RUN_MODE_ENDLESS else "普通模式"


func _is_endless_mode() -> bool:
	return _current_run_mode_id == RUN_MODE_ENDLESS


func _get_current_character_definition() -> Dictionary:
	return _get_character_definition(_selected_character_id)


func _get_current_character_name() -> String:
	return String(_get_current_character_definition().get("name", "角色"))


func _is_blade_character() -> bool:
	return _selected_character_id == "blade"


func _is_thunder_character() -> bool:
	return _selected_character_id == "thunder"


func _get_current_map_name() -> String:
	return String(_current_map.get("name", "未命名地图"))


func _get_current_boss_name() -> String:
	return String(_current_map.get("boss_name", "未知首领"))


func _get_boss_spawn_time() -> float:
	return _next_boss_spawn_time


func _get_initial_boss_spawn_time() -> float:
	return float(_current_map.get("boss_time", 600.0))


func _get_endless_boss_interval() -> float:
	return maxf(150.0, _get_initial_boss_spawn_time() * 0.35)


func _schedule_next_boss_spawn(delay: float = -1.0) -> void:
	var next_delay := delay
	if next_delay <= 0.0:
		next_delay = _get_endless_boss_interval()
	_next_boss_spawn_time = _run_time + next_delay
	_boss_warning_shown = false
	_boss_defeated = false


func _get_boss_warning_time() -> float:
	return 30.0


func _get_active_enemy_cap() -> int:
	var map_cap := _max_enemy_count + int(_current_map.get("enemy_cap_bonus", 0))
	var opening_cap := 38 if _mobile_layout else 52
	var growth := mini(max(0, map_cap - opening_cap), int(_run_time / 14.0))
	return clampi(opening_cap + growth, 24, max(24, map_cap))


func _get_spawn_rate() -> float:
	var threat_rate := 1.25 + float(_current_map.get("spawn_rate_bonus", 0.0))
	threat_rate += minf(_run_time, 120.0) * 0.025
	threat_rate += maxf(_run_time - 120.0, 0.0) * 0.016
	threat_rate += maxf(_run_time - 360.0, 0.0) * 0.010
	if _run_time >= 180.0:
		threat_rate += 0.60
	if _run_time >= 300.0:
		threat_rate += 0.80
	if _run_time >= 480.0:
		threat_rate += 1.10
	return threat_rate


func _format_enemy_label_list() -> String:
	var labels: Array[String] = []
	for label_variant in _current_map.get("enemy_labels", []):
		labels.append(String(label_variant))
	return "、".join(labels)


func _is_mobile_layout() -> bool:
	return RuntimeLayout.is_touch_layout(get_viewport_rect().size)





