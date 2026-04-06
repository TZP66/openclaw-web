extends CanvasLayer
class_name TitleScreen

signal start_requested(map_id, character_id, mode_id)
signal map_selected(map_id)
signal character_selected(character_id)
signal volume_changed(volume_ratio)

enum MenuPage { HOME, SELECT, HISTORY, SETTINGS }
enum SelectFlowStep { CHARACTER, MAP, MODE }

const UI_FONT := preload("res://assets/fonts/NotoSansSC-VF.ttf")
const SVG_MODEL_LIBRARY := preload("res://scripts/svg_model_library.gd")
const RUN_MODE_DEFINITIONS := [
	{
		"id": "normal",
		"name": "普通模式",
		"summary": "10 分钟后首领来袭，击败后通关。",
		"detail": "适合完整体验一局标准流程。",
		"accent": Color(0.46, 0.84, 1.0),
	},
	{
		"id": "endless",
		"name": "无尽模式",
		"summary": "每张地图都能持续推进，只会因死亡或暂停主动结束而终止。",
		"detail": "等级与技能升级无上限，首领会周期性反复来袭。",
		"accent": Color(0.98, 0.58, 0.34),
	},
]

var _page: MenuPage = MenuPage.HOME
var _mobile_layout := false
var _portrait_layout := false
var _map_definitions: Array[Dictionary] = []
var _character_definitions: Array[Dictionary] = []
var _map_best_kills: Dictionary = {}
var _history_summary: Dictionary = {}
var _recent_runs: Array[Dictionary] = []
var _selected_map_id := ""
var _selected_character_id := ""
var _selected_mode_id := "normal"
var _select_step: SelectFlowStep = SelectFlowStep.CHARACTER
var _volume_ratio := 0.82

var _scroll_root: ScrollContainer
var _home_status: Label
var _home_preview: TextureRect
var _detail_character_preview: TextureRect
var _detail_title: Label
var _detail_meta: Label
var _detail_body: Label
var _detail_hint: Label
var _boss_preview: TextureRect
var _start_button: Button
var _volume_slider: HSlider
var _volume_value: Label
var _character_cards: Array[Dictionary] = []
var _map_cards: Array[Dictionary] = []
var _mode_cards: Array[Dictionary] = []


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	_sync_layout_flags()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_build_ui()
	_refresh_dynamic_v2()


func configure_maps(map_definitions, selected_map_id: String, map_best_kills: Dictionary = {}, character_definitions: Array = [], selected_character_id: String = "", history_summary: Dictionary = {}, recent_runs: Array = [], volume_ratio: float = 0.82, selected_mode_id: String = "normal") -> void:
	_map_definitions.clear()
	for v in map_definitions:
		var d: Dictionary = v
		_map_definitions.append(d.duplicate(true))
	_character_definitions.clear()
	for v in character_definitions:
		var d: Dictionary = v
		_character_definitions.append(d.duplicate(true))
	_map_best_kills = map_best_kills.duplicate(true)
	_history_summary = history_summary.duplicate(true)
	_recent_runs.clear()
	for v in recent_runs:
		var d: Dictionary = v
		_recent_runs.append(d.duplicate(true))
	_selected_map_id = selected_map_id if _has_map_id(selected_map_id) else _first_map_id()
	_selected_character_id = selected_character_id if _has_character_id(selected_character_id) else _first_character_id()
	_selected_mode_id = _sanitize_mode_id(selected_mode_id)
	_volume_ratio = clampf(volume_ratio, 0.0, 1.0)
	if is_node_ready():
		_rebuild_ui()


func show_screen() -> void:
	visible = true
	set_process_unhandled_input(true)
	if _scroll_root != null:
		_scroll_root.scroll_vertical = 0


func hide_screen() -> void:
	visible = false
	set_process_unhandled_input(false)


func open_home() -> void: _set_page(MenuPage.HOME)
func open_select() -> void:
	_select_step = SelectFlowStep.CHARACTER
	_set_page(MenuPage.SELECT)
func open_history() -> void: _set_page(MenuPage.HISTORY)
func open_settings() -> void: _set_page(MenuPage.SETTINGS)


func _set_page(page: MenuPage) -> void:
	_page = page
	if is_node_ready():
		_rebuild_ui()


func _set_select_step(step: SelectFlowStep) -> void:
	_select_step = step
	if _page == MenuPage.SELECT and is_node_ready():
		_rebuild_ui()
		if _scroll_root != null:
			_scroll_root.scroll_vertical = 0


func _on_viewport_size_changed() -> void:
	_sync_layout_flags()
	_rebuild_ui()


func _sync_layout_flags() -> void:
	var size := get_viewport().get_visible_rect().size
	_mobile_layout = RuntimeLayout.is_touch_layout(size)
	_portrait_layout = RuntimeLayout.is_portrait(size)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_ESCAPE and _page != MenuPage.HOME:
			if _page == MenuPage.SELECT:
				if _select_step == SelectFlowStep.MODE:
					_set_select_step(SelectFlowStep.MAP)
				elif _select_step == SelectFlowStep.MAP:
					_set_select_step(SelectFlowStep.CHARACTER)
				else:
					open_home()
			else:
				open_home()
			get_viewport().set_input_as_handled()
			return
		if _page == MenuPage.SELECT and _select_step == SelectFlowStep.MODE:
			if key_event.keycode == KEY_TAB:
				_select_mode_delta(-1 if key_event.shift_pressed else 1)
				get_viewport().set_input_as_handled()
				return
			if key_event.keycode == KEY_Q:
				_select_mode_delta(-1)
				get_viewport().set_input_as_handled()
				return
			if key_event.keycode == KEY_E:
				_select_mode_delta(1)
				get_viewport().set_input_as_handled()
				return
	if _page == MenuPage.HOME:
		if event.is_action_pressed("confirm"):
			_select_step = SelectFlowStep.CHARACTER
			open_select()
			get_viewport().set_input_as_handled()
		return
	if _page != MenuPage.SELECT:
		return
	if _select_step == SelectFlowStep.CHARACTER:
		if event.is_action_pressed("move_left") or event.is_action_pressed("move_up"):
			_select_character_delta(-1)
		elif event.is_action_pressed("move_right") or event.is_action_pressed("move_down"):
			_select_character_delta(1)
		elif event.is_action_pressed("confirm"):
			_set_select_step(SelectFlowStep.MAP)
		else:
			return
	elif _select_step == SelectFlowStep.MAP:
		if event.is_action_pressed("move_left") or event.is_action_pressed("move_up"):
			_select_map_delta(-1)
		elif event.is_action_pressed("move_right") or event.is_action_pressed("move_down"):
			_select_map_delta(1)
		elif event.is_action_pressed("confirm"):
			_set_select_step(SelectFlowStep.MODE)
		else:
			return
	else:
		if event.is_action_pressed("move_left") or event.is_action_pressed("move_up"):
			_select_mode_delta(-1)
		elif event.is_action_pressed("move_right") or event.is_action_pressed("move_down"):
			_select_mode_delta(1)
		elif event.is_action_pressed("confirm"):
			_emit_start()
		else:
			return
	get_viewport().set_input_as_handled()


func _rebuild_ui() -> void:
	var was_visible := visible
	for child in get_children():
		child.queue_free()
	_scroll_root = null
	_home_status = null
	_home_preview = null
	_detail_character_preview = null
	_detail_title = null
	_detail_meta = null
	_detail_body = null
	_detail_hint = null
	_boss_preview = null
	_start_button = null
	_volume_slider = null
	_volume_value = null
	_character_cards.clear()
	_map_cards.clear()
	_mode_cards.clear()
	_build_ui()
	_refresh_dynamic_v2()
	if was_visible: show_screen()
	else: hide_screen()


func _build_ui() -> void:
	var size := get_viewport().get_visible_rect().size
	var bg := ColorRect.new()
	bg.color = Color(0.03, 0.04, 0.07, 0.97)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var shell := Panel.new()
	shell.position = Vector2(18, 18)
	shell.size = size - Vector2(36, 36)
	shell.add_theme_stylebox_override("panel", _panel_style(Color(0.07, 0.10, 0.14, 0.98), Color(0.24, 0.36, 0.44, 0.92)))
	add_child(shell)
	_scroll_root = ScrollContainer.new()
	_scroll_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_scroll_root.offset_left = 12
	_scroll_root.offset_top = 12
	_scroll_root.offset_right = -12
	_scroll_root.offset_bottom = -12
	shell.add_child(_scroll_root)
	var root := VBoxContainer.new()
	root.custom_minimum_size.x = shell.size.x - 28
	root.add_theme_constant_override("separation", 14)
	_scroll_root.add_child(root)
	root.add_child(_header())
	match _page:
		MenuPage.HOME: _build_home(root)
		MenuPage.SELECT: _build_select_v2(root)
		MenuPage.HISTORY: _build_history(root)
		MenuPage.SETTINGS: _build_settings(root)


func _header() -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	var labels := VBoxContainer.new()
	labels.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	labels.add_child(_label("钢翼秘术旅团", 32 if not _mobile_layout else 22, Color(0.98, 0.99, 1.0)))
	labels.add_child(_label(_page_tip_v2(), 16 if not _mobile_layout else 12, Color(0.82, 0.92, 0.98)))
	row.add_child(labels)
	if _page != MenuPage.HOME:
		var back := _button("返回主菜单", 16 if _mobile_layout else 18)
		back.custom_minimum_size = Vector2(150, 46)
		_apply_secondary_button_style(back)
		back.pressed.connect(_on_back_pressed)
		row.add_child(back)
	return row


func _build_home(root: VBoxContainer) -> void:
	var row: BoxContainer = HBoxContainer.new() if not (_mobile_layout and _portrait_layout) else VBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	root.add_child(row)
	var intro := _card(180)
	var intro_box := _card_box(intro)
	intro_box.add_child(_label("主菜单", 26 if not _mobile_layout else 20, Color(1.0, 0.95, 0.72)))
	var intro_text := _label("点击开始游戏进入整备页，选择角色与地图后再正式开始战斗。", 15 if not _mobile_layout else 12, Color(0.90, 0.95, 0.99))
	intro_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro_box.add_child(intro_text)
	row.add_child(intro)
	var status := _card(180, Color(0.11, 0.15, 0.19, 0.98), Color(0.36, 0.56, 0.66, 0.86))
	var status_box := _card_box(status)
	var preview_row := HBoxContainer.new()
	preview_row.add_theme_constant_override("separation", 14)
	status_box.add_child(preview_row)
	_home_preview = _preview()
	_home_preview.custom_minimum_size = Vector2(84, 84)
	preview_row.add_child(_preview_frame(_home_preview, Vector2(96, 96)))
	_home_status = _label("", 15 if not _mobile_layout else 12, Color(0.88, 0.95, 0.99))
	_home_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_home_status.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_row.add_child(_home_status)
	row.add_child(status)
	var actions: BoxContainer = HBoxContainer.new() if not _mobile_layout else VBoxContainer.new()
	actions.add_theme_constant_override("separation", 12)
	root.add_child(actions)
	actions.add_child(_action_card("开始游戏", "进入角色与地图选择。", Color(0.96, 0.56, 0.34), _on_home_start_pressed))
	actions.add_child(_action_card("历史成就", "查看累计战绩与纪录。", Color(0.44, 0.78, 1.0), _on_history_pressed))
	actions.add_child(_action_card("设置", "调整总音量。", Color(0.62, 0.84, 0.54), _on_settings_pressed))


func _build_select_v2(root: VBoxContainer) -> void:
	if _select_step == SelectFlowStep.CHARACTER:
		_build_character_select_step(root, _mobile_layout and _portrait_layout)
	elif _select_step == SelectFlowStep.MAP:
		_build_map_select_step(root, _mobile_layout and _portrait_layout)
	else:
		_build_mode_select_step(root, _mobile_layout and _portrait_layout)


func _build_character_select_step(root: VBoxContainer, compact: bool) -> void:
	var selected_character := _selected_character()
	var accent: Color = selected_character.get("accent", Color(0.56, 0.80, 1.0))

	var intro := _card(0, Color(accent.r * 0.12 + 0.06, accent.g * 0.10 + 0.07, accent.b * 0.10 + 0.10, 0.98), Color(accent.r, accent.g, accent.b, 0.82))
	var intro_box := _card_box(intro, 16 if compact else 18)
	intro_box.add_child(_label("第 1 步：选择角色", 24 if compact else 30, Color(1.0, 0.95, 0.76)))
	var intro_text := _label("先确定本局角色，下一步只进入地图选择。流程拆成三步后，界面会更清楚。", 12 if compact else 15, Color(0.88, 0.94, 0.99))
	intro_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro_box.add_child(intro_text)
	root.add_child(intro)

	var layout: BoxContainer = VBoxContainer.new() if compact else HBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	root.add_child(layout)

	var char_section := _section_shell_v2("角色列表", "点击角色卡切换，确认后进入地图选择。", accent, 0)
	char_section.get("panel").size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_child(char_section.get("panel"))
	var char_grid := GridContainer.new()
	char_grid.columns = 2 if _character_definitions.size() > 1 else 1
	char_grid.add_theme_constant_override("h_separation", 12 if not compact else 10)
	char_grid.add_theme_constant_override("v_separation", 12 if not compact else 10)
	char_section.get("content").add_child(char_grid)
	for i in range(_character_definitions.size()):
		var char_entry := _character_card_v2(i)
		_character_cards.append(char_entry)
		char_grid.add_child(char_entry.get("panel"))

	var detail := _card(0, Color(0.10, 0.13, 0.18, 0.98), Color(accent.r, accent.g, accent.b, 0.82))
	detail.custom_minimum_size.x = 360 if not compact else 0
	layout.add_child(detail)
	var detail_box := _card_box(detail, 16 if compact else 18)
	var detail_bar := ColorRect.new()
	detail_bar.custom_minimum_size = Vector2(0, 8)
	detail_bar.color = accent
	detail_box.add_child(detail_bar)
	detail_box.add_child(_label("当前角色", 13 if compact else 14, Color(0.84, 0.92, 0.98)))
	var preview_row: BoxContainer = VBoxContainer.new() if compact else HBoxContainer.new()
	preview_row.add_theme_constant_override("separation", 12)
	detail_box.add_child(preview_row)
	_detail_character_preview = _preview()
	_detail_character_preview.custom_minimum_size = Vector2(132, 132) if compact else Vector2(150, 150)
	preview_row.add_child(_preview_frame_v2(_detail_character_preview, Vector2(0, 144) if compact else Vector2(160, 160), Color(0.12, 0.16, 0.22, 0.98), Color(accent.r, accent.g, accent.b, 0.86), 20))
	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 8)
	preview_row.add_child(text_box)
	_detail_title = _label("", 22 if compact else 28, Color(1.0, 0.96, 0.80))
	_detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_meta = _label("", 12 if compact else 14, Color(0.88, 0.94, 0.98))
	_detail_meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box.add_child(_detail_title)
	text_box.add_child(_detail_meta)
	_detail_body = _label("", 12 if compact else 14, Color(0.92, 0.96, 0.99))
	_detail_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_hint = _label("", 11 if compact else 13, Color(0.80, 0.88, 0.95))
	_detail_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_detail_body)
	detail_box.add_child(_detail_hint)
	_start_button = _button("下一步：选择地图", 18 if compact else 20)
	_start_button.custom_minimum_size = Vector2(0, 56 if compact else 60)
	_start_button.pressed.connect(_on_start_pressed)
	detail_box.add_child(_start_button)


func _build_map_select_step(root: VBoxContainer, compact: bool) -> void:
	var selected_map := _selected_map()
	var map_accent := _map_accent(selected_map)

	var intro := _card(0, Color(0.08, 0.11, 0.16, 0.98), Color(map_accent.r, map_accent.g, map_accent.b, 0.82))
	var intro_box := _card_box(intro, 16 if compact else 18)
	intro_box.add_child(_label("第 2 步：选择地图", 24 if compact else 30, Color(1.0, 0.95, 0.76)))
	var intro_text := _label("这一屏只保留地图列表和地图简报，确认后进入模式选择。", 12 if compact else 15, Color(0.88, 0.94, 0.99))
	intro_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro_box.add_child(intro_text)
	root.add_child(intro)

	var layout: BoxContainer = VBoxContainer.new() if compact else HBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	root.add_child(layout)

	var map_section := _section_shell_v2("地图选择", "这里只选地图。当前地图保持高亮，确认后进入模式选择。", map_accent, 0)
	map_section.get("panel").size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_child(map_section.get("panel"))
	var map_grid := GridContainer.new()
	map_grid.columns = 1 if compact else 2
	map_grid.add_theme_constant_override("h_separation", 12 if not compact else 10)
	map_grid.add_theme_constant_override("v_separation", 12 if not compact else 10)
	map_section.get("content").add_child(map_grid)
	for i in range(_map_definitions.size()):
		var map_entry := _map_card_v2(i, true)
		_map_cards.append(map_entry)
		map_grid.add_child(map_entry.get("panel"))

	var detail := _card(0, Color(0.10, 0.13, 0.18, 0.98), Color(map_accent.r, map_accent.g, map_accent.b, 0.80))
	detail.custom_minimum_size.x = 392 if not compact else 0
	layout.add_child(detail)
	var detail_box := _card_box(detail, 16 if compact else 18)
	var detail_bar := ColorRect.new()
	detail_bar.custom_minimum_size = Vector2(0, 8)
	detail_bar.color = map_accent
	detail_box.add_child(detail_bar)
	detail_box.add_child(_label("地图简报", 13 if compact else 14, Color(0.84, 0.92, 0.98)))
	_detail_title = _label("", 22 if compact else 30, Color(1.0, 0.96, 0.80))
	_detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_detail_title)
	_detail_meta = _label("", 12 if compact else 14, Color(0.88, 0.94, 0.98))
	_detail_meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_detail_meta)
	var boss_box := VBoxContainer.new()
	boss_box.add_theme_constant_override("separation", 6)
	detail_box.add_child(boss_box)
	boss_box.add_child(_label("首领预览", 11 if compact else 13, Color(0.82, 0.90, 0.98)))
	_boss_preview = _preview()
	_boss_preview.custom_minimum_size = Vector2(128, 128) if compact else Vector2(176, 176)
	boss_box.add_child(_preview_frame_v2(_boss_preview, Vector2(0, 142) if compact else Vector2(0, 192), Color(0.18, 0.12, 0.10, 0.98), Color(0.92, 0.58, 0.36, 0.86), 18 if compact else 22))
	_detail_body = _label("", 12 if compact else 15, Color(0.92, 0.96, 0.99))
	_detail_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_hint = _label("", 11 if compact else 13, Color(0.80, 0.88, 0.95))
	_detail_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_detail_body)
	var launch_panel := _card(0, Color(0.11, 0.15, 0.20, 0.98), Color(0.30, 0.40, 0.50, 0.86))
	detail_box.add_child(launch_panel)
	var launch_box := _card_box(launch_panel, 14)
	launch_box.add_child(_label("下一步", 14 if compact else 16, Color(1.0, 0.90, 0.66)))
	launch_box.add_child(_detail_hint)
	_start_button = _button("下一步：选择模式", 18 if compact else 21)
	_start_button.custom_minimum_size = Vector2(0, 56 if compact else 60)
	_start_button.pressed.connect(_on_start_pressed)
	launch_box.add_child(_start_button)


func _build_mode_select_step(root: VBoxContainer, compact: bool) -> void:
	var selected_mode := _selected_mode()
	var mode_accent := _mode_accent(selected_mode)

	var intro := _card(0, Color(mode_accent.r * 0.12 + 0.06, mode_accent.g * 0.10 + 0.07, mode_accent.b * 0.10 + 0.10, 0.98), Color(mode_accent.r, mode_accent.g, mode_accent.b, 0.82))
	var intro_box := _card_box(intro, 16 if compact else 18)
	intro_box.add_child(_label("第 3 步：选择模式并开始", 24 if compact else 30, Color(1.0, 0.95, 0.76)))
	var intro_text := _label("最后只选择普通模式或无尽模式，然后直接开始。", 12 if compact else 15, Color(0.88, 0.94, 0.99))
	intro_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro_box.add_child(intro_text)
	root.add_child(intro)

	var layout: BoxContainer = VBoxContainer.new() if compact else HBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	root.add_child(layout)

	var mode_section := _section_shell_v2("模式选择", "这里只保留模式卡和最终确认，不再重复地图列表。", mode_accent, 0)
	mode_section.get("panel").size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_child(mode_section.get("panel"))
	var mode_list: BoxContainer = VBoxContainer.new() if compact else HBoxContainer.new()
	mode_list.add_theme_constant_override("separation", 12 if not compact else 10)
	mode_section.get("content").add_child(mode_list)
	for i in range(RUN_MODE_DEFINITIONS.size()):
		var mode_entry := _mode_card_v2(i)
		_mode_cards.append(mode_entry)
		mode_list.add_child(mode_entry.get("panel"))

	var detail := _card(0, Color(0.10, 0.13, 0.18, 0.98), Color(mode_accent.r, mode_accent.g, mode_accent.b, 0.80))
	detail.custom_minimum_size.x = 392 if not compact else 0
	layout.add_child(detail)
	var detail_box := _card_box(detail, 16 if compact else 18)
	var detail_bar := ColorRect.new()
	detail_bar.custom_minimum_size = Vector2(0, 8)
	detail_bar.color = mode_accent
	detail_box.add_child(detail_bar)
	detail_box.add_child(_label("最终确认", 13 if compact else 14, Color(0.84, 0.92, 0.98)))
	_detail_title = _label("", 22 if compact else 30, Color(1.0, 0.96, 0.80))
	_detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_detail_title)
	_detail_meta = _label("", 12 if compact else 14, Color(0.88, 0.94, 0.98))
	_detail_meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_detail_meta)
	_detail_body = _label("", 12 if compact else 15, Color(0.92, 0.96, 0.99))
	_detail_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_hint = _label("", 11 if compact else 13, Color(0.80, 0.88, 0.95))
	_detail_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_detail_body)
	var launch_panel := _card(0, Color(0.11, 0.15, 0.20, 0.98), Color(0.30, 0.40, 0.50, 0.86))
	detail_box.add_child(launch_panel)
	var launch_box := _card_box(launch_panel, 14)
	launch_box.add_child(_label("开始", 14 if compact else 16, Color(1.0, 0.90, 0.66)))
	launch_box.add_child(_detail_hint)
	_start_button = _button("开始游戏", 18 if compact else 21)
	_start_button.custom_minimum_size = Vector2(0, 56 if compact else 60)
	_start_button.pressed.connect(_on_start_pressed)
	launch_box.add_child(_start_button)


func _build_history(root: VBoxContainer) -> void:
	var summary := "总战斗：%d\n胜利次数：%d\n总击败：%d\n单局最高：%d\n存活最久：%s\n最快通关：%s" % [int(_history_summary.get("total_runs", 0)), int(_history_summary.get("total_victories", 0)), int(_history_summary.get("total_kills", 0)), int(_history_summary.get("best_run_kills", 0)), _format_time(float(_history_summary.get("best_survival_time", 0.0))), _format_time_or_empty(float(_history_summary.get("fastest_clear_time", 0.0)))]
	root.add_child(_text_block("历史成就", summary))
	var map_lines: Array[String] = []
	for v in _map_definitions:
		var d: Dictionary = v
		map_lines.append("%s：单局最高击败 %s" % [String(d.get("name", "未知地图")), _best_kill_text(String(d.get("id", "")))])
	root.add_child(_text_block("地图纪录", "\n".join(map_lines)))
	var recent_lines: Array[String] = []
	for v in _recent_runs:
		var d: Dictionary = v
		recent_lines.append("%s | %s | %s | %s | 击败 %d | 存活 %s" % [String(d.get("timestamp", "未知时间")), String(d.get("map_name", "未知地图")), String(d.get("character_name", "未知角色")), String(d.get("run_mode_name", "普通模式")), int(d.get("kills", 0)), _format_time(float(d.get("time_survived", 0.0)))])
	if recent_lines.is_empty():
		recent_lines.append("暂无历史战绩，先开始一局吧。")
	root.add_child(_text_block("最近战绩", "\n".join(recent_lines), 220))


func _build_settings(root: VBoxContainer) -> void:
	var panel := _card(186)
	var box := _card_box(panel)
	box.add_child(_label("设置", 24 if not _mobile_layout else 18, Color(1.0, 0.95, 0.72)))
	var desc := _label("当前只提供总音量设置，修改后立即生效并自动保存。", 15 if not _mobile_layout else 12, Color(0.84, 0.92, 0.98))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(desc)
	_volume_value = _label("", 18 if not _mobile_layout else 14, Color(1.0, 0.90, 0.66))
	box.add_child(_volume_value)
	_volume_slider = HSlider.new()
	_volume_slider.min_value = 0
	_volume_slider.max_value = 100
	_volume_slider.step = 1
	_volume_slider.custom_minimum_size = Vector2(320 if not _mobile_layout else 240, 20)
	_volume_slider.value_changed.connect(_on_volume_slider_changed)
	box.add_child(_volume_slider)
	root.add_child(panel)


func _character_card_v2(index: int) -> Dictionary:
	var info: Dictionary = _character_definitions[index]
	var accent: Color = info.get("accent", Color(0.56, 0.80, 1.0))
	var compact := _mobile_layout and _portrait_layout
	var panel := _card(188 if compact else 226, Color(accent.r * 0.18 + 0.06, accent.g * 0.14 + 0.07, accent.b * 0.14 + 0.09, 0.98), Color(accent.r, accent.g, accent.b, 0.58))
	var box := _card_box(panel, 14)
	var bar := ColorRect.new()
	bar.custom_minimum_size = Vector2(0, 8)
	box.add_child(bar)
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	box.add_child(header)
	var heading := VBoxContainer.new()
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.add_theme_constant_override("separation", 4)
	header.add_child(heading)
	var title := _label(String(info.get("name", "角色")), 20 if compact else (24 if not _mobile_layout else 18), Color(0.98, 0.99, 1.0))
	var role := _label(String(info.get("title", "")), 11 if compact else (14 if not _mobile_layout else 11), Color(0.82, 0.92, 0.98))
	heading.add_child(title)
	heading.add_child(role)
	var state_tag := _tag_v2("点击切换", Color(0.10, 0.16, 0.22, 0.96), Color(accent.r, accent.g, accent.b, 0.72), 11 if compact else (12 if not _mobile_layout else 11), Color(1.0, 0.93, 0.76))
	header.add_child(state_tag.get("panel"))
	var preview := _preview()
	preview.custom_minimum_size = Vector2(84, 84) if compact else Vector2(108, 108)
	preview.texture = SVG_MODEL_LIBRARY.get_character_texture(String(info.get("id", "caster")))
	box.add_child(_preview_frame_v2(preview, Vector2(0, 96) if compact else Vector2(0, 118), Color(accent.r * 0.12 + 0.10, accent.g * 0.10 + 0.11, accent.b * 0.10 + 0.13, 0.98), Color(accent.r, accent.g, accent.b, 0.64), 16 if compact else 18))
	var summary := _label(String(info.get("summary", "")), 12 if compact else (14 if not _mobile_layout else 11), Color(0.88, 0.94, 0.98))
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(summary)
	if not compact:
		var detail := _label(String(info.get("detail", "")), 13 if not _mobile_layout else 11, Color(0.80, 0.89, 0.96))
		detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(detail)
	_attach_card_button(panel, _on_character_button_pressed.bind(index))
	return {
		"panel": panel,
		"bar": bar,
		"title": title,
		"role": role,
		"summary": summary,
		"state": state_tag.get("label"),
		"info": info,
	}


func _map_card_v2(index: int, wide: bool = false) -> Dictionary:
	var info: Dictionary = _map_definitions[index]
	var accent := _map_accent(info)
	var border := _map_border(info)
	var compact := _mobile_layout and _portrait_layout
	var panel := _card((220 if compact else 248) if wide else (196 if compact else 236), _map_fill(info), Color(border.r, border.g, border.b, 0.62))
	var box := _card_box(panel, 14)
	var bar := ColorRect.new()
	bar.custom_minimum_size = Vector2(0, 8)
	box.add_child(bar)
	var title := _label(String(info.get("name", "地图")), 19 if compact else (24 if wide else (22 if not _mobile_layout else 17)), Color(0.98, 0.99, 1.0))
	box.add_child(title)
	var boss := _label("首领 %s" % String(info.get("boss_name", "未知首领")), 11 if compact else (13 if wide else (14 if not _mobile_layout else 11)), Color(1.0, 0.88, 0.64))
	box.add_child(boss)
	var preview := _preview()
	preview.custom_minimum_size = Vector2(96, 96) if compact else (Vector2(120, 120) if wide else Vector2(100, 100))
	preview.texture = SVG_MODEL_LIBRARY.get_enemy_texture(String(info.get("boss_archetype", "storm_archon")))
	box.add_child(_preview_frame_v2(preview, Vector2(0, 110) if compact else (Vector2(0, 132) if wide else Vector2(0, 110)), Color(accent.r * 0.12 + 0.11, accent.g * 0.10 + 0.10, accent.b * 0.10 + 0.10, 0.98), Color(border.r, border.g, border.b, 0.72), 16 if compact else 18))
	var tagline := _label(String(info.get("tagline", "")), 12 if compact else (15 if wide else (14 if not _mobile_layout else 11)), Color(0.84, 0.92, 0.98))
	tagline.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var record := _label("", 11 if compact else (13 if not _mobile_layout else 11), Color(0.82, 0.90, 0.96))
	box.add_child(tagline)
	var terrain := _label("地形 %s" % String(info.get("terrain_hint", "")), 11 if compact else (13 if not _mobile_layout else 11), Color(0.80, 0.89, 0.96))
	terrain.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(terrain)
	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 8)
	box.add_child(footer)
	record.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(record)
	var state := _label("点击切换", 11 if compact else 12, Color(1.0, 0.90, 0.66))
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	footer.add_child(state)
	_attach_card_button(panel, _on_map_button_pressed.bind(index))
	return {
		"panel": panel,
		"bar": bar,
		"title": title,
		"tagline": tagline,
		"boss": boss,
		"record": record,
		"state": state,
		"info": info,
	}


func _mode_card_v2(index: int, dense: bool = false) -> Dictionary:
	var info: Dictionary = RUN_MODE_DEFINITIONS[index]
	var accent: Color = info.get("accent", Color(0.46, 0.84, 1.0))
	var compact := _mobile_layout and _portrait_layout
	var panel := _card((112 if compact else 124) if dense else (150 if compact else 164), Color(accent.r * 0.18 + 0.06, accent.g * 0.14 + 0.07, accent.b * 0.12 + 0.08, 0.98), Color(accent.r, accent.g, accent.b, 0.60))
	var box := _card_box(panel, 14)
	var bar := ColorRect.new()
	bar.custom_minimum_size = Vector2(0, 6 if dense else 8)
	box.add_child(bar)
	var title := _label(String(info.get("name", "模式")), 16 if dense else (18 if compact else 20), Color(0.98, 0.99, 1.0))
	var summary := _label(String(info.get("summary", "")), 11 if dense else (12 if compact else 13), Color(0.88, 0.94, 0.98))
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(title)
	box.add_child(summary)
	var state := _label("点击切换", 11, Color(1.0, 0.93, 0.76))
	box.add_child(state)
	if not compact and not dense:
		var detail := _label(String(info.get("detail", "")), 12, Color(0.80, 0.89, 0.96))
		detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(detail)
	_attach_card_button(panel, _on_mode_button_pressed.bind(index))
	return {
		"panel": panel,
		"bar": bar,
		"title": title,
		"summary": summary,
		"state": state,
		"info": info,
	}


func _section_shell_v2(title: String, subtitle: String, accent: Color, min_h: float = 0.0) -> Dictionary:
	var panel := _card(min_h, Color(accent.r * 0.12 + 0.05, accent.g * 0.10 + 0.06, accent.b * 0.10 + 0.08, 0.98), Color(accent.r, accent.g, accent.b, 0.76))
	var box := _card_box(panel, 16)
	var bar := ColorRect.new()
	bar.custom_minimum_size = Vector2(0, 8)
	bar.color = accent
	box.add_child(bar)
	box.add_child(_label(title, 22 if not _mobile_layout else 17, Color(1.0, 0.95, 0.76)))
	var desc := _label(subtitle, 14 if not _mobile_layout else 11, Color(0.84, 0.92, 0.98))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(desc)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	box.add_child(content)
	return {"panel": panel, "content": content}


func _tag_v2(text: String, fill: Color, border: Color, font_size: int = 12, font_color: Color = Color(0.96, 0.97, 1.0)) -> Dictionary:
	var panel := Panel.new()
	panel.custom_minimum_size = Vector2(maxf(132.0, float(text.length()) * float(font_size) * 0.72 + 24.0), 30.0)
	panel.add_theme_stylebox_override("panel", _panel_style(fill, border, 999, 2))
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.offset_left = 10
	margin.offset_top = 5
	margin.offset_right = -10
	margin.offset_bottom = -5
	panel.add_child(margin)
	var label := _label(text, font_size, font_color)
	margin.add_child(label)
	return {"panel": panel, "label": label}


func _preview_frame_v2(texture: TextureRect, size: Vector2, fill: Color, border: Color, radius: int = 16) -> Panel:
	var panel := Panel.new()
	panel.custom_minimum_size = size
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _panel_style(fill, border, radius, 4))
	texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	texture.offset_left = 8
	texture.offset_top = 8
	texture.offset_right = -8
	texture.offset_bottom = -8
	panel.add_child(texture)
	return panel


func _refresh_dynamic_v2() -> void:
	var selected_map := _selected_map()
	var selected_character := _selected_character()
	var selected_mode := _selected_mode()

	if _home_status != null:
		_home_status.text = "角色：%s\n地图：%s\n模式：%s\n总战斗：%d  胜利：%d\n总击败：%d  音量：%d%%" % [
			String(selected_character.get("name", "未选择")),
			String(selected_map.get("name", "未选择")),
			String(selected_mode.get("name", "普通模式")),
			int(_history_summary.get("total_runs", 0)),
			int(_history_summary.get("total_victories", 0)),
			int(_history_summary.get("total_kills", 0)),
			int(round(_volume_ratio * 100.0))
		]
		_home_preview.texture = SVG_MODEL_LIBRARY.get_character_texture(String(selected_character.get("id", "caster")))

	if _detail_title != null:
		if _detail_character_preview != null:
			_detail_character_preview.texture = SVG_MODEL_LIBRARY.get_character_texture(String(selected_character.get("id", "caster")))
		if _select_step == SelectFlowStep.CHARACTER:
			var accent: Color = selected_character.get("accent", Color(0.56, 0.80, 1.0))
			_detail_title.text = String(selected_character.get("name", "未选择角色"))
			_detail_meta.text = "定位：%s\n默认地图：%s" % [
				String(selected_character.get("title", "")),
				String(selected_map.get("name", "未选择地图"))
			]
			_detail_body.text = "%s\n\n%s" % [
				String(selected_character.get("summary", "")),
				String(selected_character.get("detail", ""))
			]
			_detail_hint.text = "确认角色后进入地图选择。"
			if _start_button != null:
				_start_button.text = "下一步：选择地图"
				_apply_primary_button_style(_start_button, accent, accent.lightened(0.20))
		elif _select_step == SelectFlowStep.MAP:
			_detail_title.text = String(selected_map.get("name", "未选择地图"))
			_detail_meta.text = "首领：%s\n历史最高击败：%s" % [
				String(selected_map.get("boss_name", "未知首领")),
				_best_kill_text(String(selected_map.get("id", "")))
			]
			_detail_body.text = "%s\n\n%s\n地形提示：%s" % [
				String(selected_map.get("tagline", "")),
				String(selected_map.get("description", "")),
				String(selected_map.get("terrain_hint", ""))
			]
			_detail_hint.text = "确认地图后进入模式选择。"
			if _boss_preview != null:
				_boss_preview.texture = SVG_MODEL_LIBRARY.get_enemy_texture(String(selected_map.get("boss_archetype", "storm_archon")))
			if _start_button != null:
				_start_button.text = "下一步：选择模式"
				_apply_primary_button_style(_start_button, _map_accent(selected_map), _map_border(selected_map))
		else:
			_detail_title.text = String(selected_mode.get("name", "普通模式"))
			_detail_meta.text = String(selected_mode.get("summary", ""))
			_detail_body.text = String(selected_mode.get("detail", ""))
			_detail_hint.text = "无尽模式仅在死亡或暂停自杀时结束，等级与技能升级都不封顶。" if _selected_mode_id == "endless" else "普通模式在首领被击退后结束本局。"
			if _start_button != null:
				_start_button.text = "开始游戏"
				_apply_primary_button_style(_start_button, _mode_accent(selected_mode), _mode_accent(selected_mode).lightened(0.18))

		for i in range(_character_cards.size()):
			var entry: Dictionary = _character_cards[i]
			var info: Dictionary = entry.get("info", {})
			var selected := i == _selected_character_index()
			var accent: Color = info.get("accent", Color(0.56, 0.80, 1.0))
			(entry.get("panel") as Panel).add_theme_stylebox_override("panel", _panel_style(Color(accent.r * 0.22 + 0.06, accent.g * 0.18 + 0.06, accent.b * 0.18 + 0.08, 0.98), Color(accent.r, accent.g, accent.b, 0.96 if selected else 0.54), 20, 10 if selected else 6))
			(entry.get("bar") as ColorRect).color = accent
			(entry.get("state") as Label).text = "当前已选" if selected else "点击选择"

		for i in range(_map_cards.size()):
			var entry: Dictionary = _map_cards[i]
			var info: Dictionary = entry.get("info", {})
			var selected := i == _selected_map_index()
			(entry.get("panel") as Panel).add_theme_stylebox_override("panel", _panel_style(_map_fill(info), Color(_map_border(info).r, _map_border(info).g, _map_border(info).b, 0.96 if selected else 0.58), 20, 10 if selected else 6))
			(entry.get("bar") as ColorRect).color = _map_accent(info)
			(entry.get("record") as Label).text = "历史最高击败：%s" % _best_kill_text(String(info.get("id", "")))

		for i in range(_mode_cards.size()):
			var entry: Dictionary = _mode_cards[i]
			var info: Dictionary = entry.get("info", {})
			var selected := i == _selected_mode_index()
			var accent: Color = _mode_accent(info)
			(entry.get("panel") as Panel).add_theme_stylebox_override("panel", _panel_style(Color(accent.r * 0.22 + 0.06, accent.g * 0.18 + 0.06, accent.b * 0.16 + 0.08, 0.98), Color(accent.r, accent.g, accent.b, 0.96 if selected else 0.56), 20, 10 if selected else 6))
			(entry.get("bar") as ColorRect).color = accent
			(entry.get("state") as Label).text = "当前已选" if selected else "点击选择"

	if _volume_slider != null:
		_volume_slider.value = round(_volume_ratio * 100.0)
		_volume_value.text = "%d%%" % int(round(_volume_slider.value))


func _selected_map_index() -> int:
	for i in range(_map_definitions.size()):
		if String(_map_definitions[i].get("id", "")) == _selected_map_id:
			return i
	return 0


func _selected_character_index() -> int:
	for i in range(_character_definitions.size()):
		if String(_character_definitions[i].get("id", "")) == _selected_character_id:
			return i
	return 0


func _selected_map() -> Dictionary:
	return _map_definitions[_selected_map_index()] if not _map_definitions.is_empty() else {}


func _selected_character() -> Dictionary:
	return _character_definitions[_selected_character_index()] if not _character_definitions.is_empty() else {}


func _selected_mode_index() -> int:
	for i in range(RUN_MODE_DEFINITIONS.size()):
		if String(RUN_MODE_DEFINITIONS[i].get("id", "")) == _selected_mode_id:
			return i
	return 0


func _selected_mode() -> Dictionary:
	return RUN_MODE_DEFINITIONS[_selected_mode_index()]


func _select_map_delta(delta: int) -> void:
	if not _map_definitions.is_empty(): _select_map_index(posmod(_selected_map_index() + delta, _map_definitions.size()))


func _select_character_delta(delta: int) -> void:
	if not _character_definitions.is_empty(): _select_character_index(posmod(_selected_character_index() + delta, _character_definitions.size()))


func _select_mode_delta(delta: int) -> void:
	_select_mode_index(posmod(_selected_mode_index() + delta, RUN_MODE_DEFINITIONS.size()))


func _select_map_index(index: int) -> void:
	_selected_map_id = String(_map_definitions[index].get("id", ""))
	_refresh_dynamic_v2()
	map_selected.emit(_selected_map_id)


func _select_character_index(index: int) -> void:
	_selected_character_id = String(_character_definitions[index].get("id", ""))
	_refresh_dynamic_v2()
	character_selected.emit(_selected_character_id)


func _select_mode_index(index: int) -> void:
	_selected_mode_id = String(RUN_MODE_DEFINITIONS[index].get("id", "normal"))
	_refresh_dynamic_v2()


func _emit_start() -> void: start_requested.emit(_selected_map_id, _selected_character_id, _selected_mode_id)
func _on_home_start_pressed() -> void:
	_select_step = SelectFlowStep.CHARACTER
	open_select()
func _on_history_pressed() -> void: open_history()
func _on_settings_pressed() -> void: open_settings()
func _on_back_pressed() -> void:
	if _page == MenuPage.SELECT:
		if _select_step == SelectFlowStep.MODE:
			_set_select_step(SelectFlowStep.MAP)
			return
		if _select_step == SelectFlowStep.MAP:
			_set_select_step(SelectFlowStep.CHARACTER)
			return
	open_home()
func _on_map_button_pressed(index: int) -> void: _select_map_index(index)
func _on_character_button_pressed(index: int) -> void: _select_character_index(index)
func _on_mode_button_pressed(index: int) -> void: _select_mode_index(index)
func _on_start_pressed() -> void:
	if _page == MenuPage.SELECT:
		if _select_step == SelectFlowStep.CHARACTER:
			_set_select_step(SelectFlowStep.MAP)
			return
		if _select_step == SelectFlowStep.MAP:
			_set_select_step(SelectFlowStep.MODE)
			return
	_emit_start()


func _on_volume_slider_changed(value: float) -> void:
	_volume_ratio = clampf(value / 100.0, 0.0, 1.0)
	if _volume_value != null:
		_volume_value.text = "%d%%" % int(round(value))
	volume_changed.emit(_volume_ratio)


func _card(min_h: float, fill: Color = Color(0.09, 0.12, 0.16, 0.98), border: Color = Color(0.28, 0.42, 0.50, 0.86)) -> Panel:
	var p := Panel.new()
	p.custom_minimum_size = Vector2(0, min_h)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", _panel_style(fill, border))
	return p


func _card_box(panel: Panel, pad: float = 18) -> VBoxContainer:
	var m := MarginContainer.new()
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	m.offset_left = pad; m.offset_top = pad; m.offset_right = -pad; m.offset_bottom = -pad
	panel.add_child(m)
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	m.add_child(box)
	return box


func _text_block(title: String, body: String, min_h: float = 184) -> Panel:
	var p := _card(min_h)
	var box := _card_box(p)
	box.add_child(_label(title, 20 if not _mobile_layout else 16, Color(1.0, 0.95, 0.72)))
	var b := _label(body, 15 if not _mobile_layout else 12, Color(0.88, 0.95, 0.99))
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(b)
	return p


func _action_card(title: String, body: String, accent: Color, callback: Callable) -> Panel:
	var p := _card(124, Color(accent.r * 0.20 + 0.06, accent.g * 0.16 + 0.06, accent.b * 0.16 + 0.08, 0.98), accent)
	var box := _card_box(p, 16)
	box.add_child(_label(title, 20 if not _mobile_layout else 16, Color(1.0, 0.98, 1.0)))
	var b := _label(body, 14 if not _mobile_layout else 11, Color(0.88, 0.95, 0.99))
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(b)
	box.add_child(_label("点击进入", 13 if not _mobile_layout else 11, Color(1.0, 0.90, 0.66)))
	_attach_card_button(p, callback)
	return p


func _preview_frame(texture: TextureRect, size: Vector2) -> Panel:
	var p := Panel.new()
	p.custom_minimum_size = size
	p.add_theme_stylebox_override("panel", _panel_style(Color(0.13, 0.16, 0.22, 0.98), Color(0.34, 0.48, 0.58, 0.82), 16, 4))
	texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	texture.offset_left = 8; texture.offset_top = 8; texture.offset_right = -8; texture.offset_bottom = -8
	p.add_child(texture)
	return p


func _attach_card_button(panel: Control, callback: Callable) -> void:
	var b := Button.new()
	b.flat = true
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.set_anchors_preset(Control.PRESET_FULL_RECT)
	b.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	b.pressed.connect(callback)
	panel.add_child(b)


func _apply_primary_button_style(button: Button, accent: Color, border: Color) -> void:
	button.add_theme_stylebox_override("normal", _panel_style(Color(accent.r * 0.72, accent.g * 0.74, accent.b * 0.78, 0.98), border, 16, 8))
	button.add_theme_stylebox_override("hover", _panel_style(Color(accent.r * 0.84, accent.g * 0.86, accent.b * 0.90, 0.98), Color(1, 1, 1, 0.96), 16, 10))
	button.add_theme_stylebox_override("pressed", _panel_style(Color(accent.r * 0.58, accent.g * 0.60, accent.b * 0.64, 0.98), border, 16, 6))
	button.add_theme_color_override("font_color", Color(0.98, 0.99, 1.0))


func _apply_secondary_button_style(button: Button) -> void:
	var border := Color(0.42, 0.62, 0.72, 0.86)
	button.add_theme_stylebox_override("normal", _panel_style(Color(0.10, 0.14, 0.18, 0.98), border, 16, 6))
	button.add_theme_stylebox_override("hover", _panel_style(Color(0.14, 0.18, 0.22, 0.98), Color(1, 1, 1, 0.94), 16, 8))
	button.add_theme_stylebox_override("pressed", _panel_style(Color(0.08, 0.12, 0.16, 0.98), border, 16, 4))
	button.add_theme_color_override("font_color", Color(0.94, 0.97, 1.0))


func _panel_style(fill_color: Color, border_color: Color, radius: int = 18, shadow: int = 6) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = fill_color; s.border_color = border_color; s.shadow_color = Color(0.01, 0.02, 0.03, 0.26); s.shadow_size = shadow
	s.border_width_left = 2; s.border_width_top = 2; s.border_width_right = 2; s.border_width_bottom = 2
	s.corner_radius_top_left = radius; s.corner_radius_top_right = radius; s.corner_radius_bottom_left = radius; s.corner_radius_bottom_right = radius
	return s


func _label(text: String, font_size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text; l.modulate = color
	l.add_theme_font_override("font", UI_FONT); l.add_theme_font_size_override("font_size", font_size)
	return l


func _button(text: String, font_size: int) -> Button:
	var b := Button.new()
	b.text = text; b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.add_theme_font_override("font", UI_FONT); b.add_theme_font_size_override("font_size", font_size)
	return b


func _preview() -> TextureRect:
	var t := TextureRect.new()
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	return t


func _page_tip_v2() -> String:
	match _page:
		MenuPage.SELECT:
			match _select_step:
				SelectFlowStep.CHARACTER:
					return "第 1 步先选角色。"
				SelectFlowStep.MAP:
					return "第 2 步选择地图。"
				_:
					return "第 3 步选择模式并开始。"
		MenuPage.HISTORY:
			return "查看累计战绩、地图纪录和最近战斗。"
		MenuPage.SETTINGS:
			return "调整基础选项，当前支持总音量。"
		_:
			return "开始游戏、查看历史成就，或进入设置。"


func _best_kill_text(map_id: String) -> String:
	return str(int(_map_best_kills.get(map_id, 0))) if _map_best_kills.has(map_id) else "暂无"


func _format_time(seconds: float) -> String:
	var s := maxi(int(floor(seconds)), 0)
	return "%02d:%02d" % [int(s / 60), s % 60]


func _format_time_or_empty(seconds: float) -> String:
	return "暂无" if seconds <= 0.0 else _format_time(seconds)


func _map_fill(map_info: Dictionary) -> Color:
	var p: Dictionary = map_info.get("palette", {})
	return p.get("ground_mid", Color(0.10, 0.14, 0.18)).lightened(0.04)


func _map_border(map_info: Dictionary) -> Color:
	var p: Dictionary = map_info.get("palette", {})
	return p.get("line_color", Color(0.34, 0.46, 0.56)).lightened(0.24)


func _map_accent(map_info: Dictionary) -> Color:
	var p: Dictionary = map_info.get("palette", {})
	return p.get("accent_color", Color(0.72, 0.88, 1.0, 0.18)).lightened(0.28)


func _mode_accent(mode_info: Dictionary) -> Color:
	return mode_info.get("accent", Color(0.72, 0.88, 1.0))


func _has_map_id(map_id: String) -> bool:
	for v in _map_definitions:
		if String(v.get("id", "")) == map_id: return true
	return false


func _has_character_id(character_id: String) -> bool:
	for v in _character_definitions:
		if String(v.get("id", "")) == character_id: return true
	return false


func _has_mode_id(mode_id: String) -> bool:
	for v in RUN_MODE_DEFINITIONS:
		if String(v.get("id", "")) == mode_id:
			return true
	return false


func _sanitize_mode_id(mode_id: String) -> String:
	return mode_id if _has_mode_id(mode_id) else _first_mode_id()


func _first_map_id() -> String:
	return String(_map_definitions[0].get("id", "")) if not _map_definitions.is_empty() else ""


func _first_character_id() -> String:
	return String(_character_definitions[0].get("id", "")) if not _character_definitions.is_empty() else ""


func _first_mode_id() -> String:
	return String(RUN_MODE_DEFINITIONS[0].get("id", "normal"))
