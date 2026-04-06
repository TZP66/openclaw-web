extends CanvasLayer
class_name GameHud

signal upgrade_selected(index)
signal restart_requested
signal pause_requested
signal pause_resume_requested
signal pause_suicide_requested
signal pause_exit_requested
signal move_vector_changed(vector)

const UI_FONT := preload("res://assets/fonts/NotoSansSC-VF.ttf")
const SKILL_SLOT_SCRIPT: GDScript = preload("res://scripts/skill_slot_display.gd")

var _mobile_layout: bool = false
var _portrait_layout: bool = false
var _stats_label: Label
var _skill_panel: ColorRect
var _skill_slots: Array = []
var _message_label: Label
var _upgrade_panel: ColorRect
var _upgrade_title: Label
var _upgrade_cards: Array[Button] = []
var _pause_panel: ColorRect
var _pause_title: Label
var _pause_subtitle: Label
var _pause_continue_button: Button
var _pause_suicide_button: Button
var _pause_exit_button: Button
var _pause_button: Button
var _result_panel: ColorRect
var _result_title: Label
var _result_subtitle: Label
var _result_button: Button
var _touch_root: Control
var _move_joystick: Control
var _hp_fill: ColorRect
var _xp_fill: ColorRect
var _hp_value_label: Label
var _xp_value_label: Label
var _hp_fill_width: float = 280.0
var _xp_fill_width: float = 320.0
var _xp_fill_height: float = 14.0

var _has_run_stats: bool = false
var _current_level: int = 1
var _current_health: int = 0
var _current_max_health: int = 1
var _current_xp_ratio: float = 0.0
var _current_time_text: String = "00:00"
var _current_kills: int = 0
var _current_threat_text: String = ""
var _current_spell_lines: Array[String] = []
var _current_skill_entries: Array[Dictionary] = []

var _message_text: String = ""
var _message_color: Color = Color(0.98, 0.90, 0.40)
var _upgrade_choices_state: Array[Dictionary] = []
var _upgrade_visible: bool = false
var _pause_visible: bool = false
var _pause_endless_mode: bool = false
var _result_visible: bool = false
var _result_title_text: String = ""
var _result_subtitle_text: String = ""
var _result_button_text: String = "返回选图"
var _touch_controls_requested: bool = false
var _pause_button_requested: bool = false


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_sync_layout_flags()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_build_ui()


func set_run_stats(level: int, health: int, max_health: int, xp_ratio: float, time_text: String, kills: int, threat_text: String, spell_lines: Array, skill_entries: Array = []) -> void:
	_has_run_stats = true
	_current_level = level
	_current_health = health
	_current_max_health = max_health
	_current_xp_ratio = xp_ratio
	_current_time_text = time_text
	_current_kills = kills
	_current_threat_text = threat_text
	_current_spell_lines.clear()
	for line_variant in spell_lines:
		_current_spell_lines.append(String(line_variant))
	_current_skill_entries.clear()
	for skill_variant in skill_entries:
		var skill_entry: Dictionary = skill_variant
		_current_skill_entries.append(skill_entry.duplicate(true))
	_apply_run_stats()


func set_message(text: String, color: Color = Color(0.98, 0.90, 0.40)) -> void:
	_message_text = text
	_message_color = color
	if _message_label == null:
		return
	_message_label.text = text
	_message_label.modulate = color
	_message_label.visible = not text.is_empty()


func show_upgrade_choices(choices: Array[Dictionary]) -> void:
	_upgrade_choices_state.clear()
	for choice_variant in choices:
		var choice: Dictionary = choice_variant
		_upgrade_choices_state.append(choice.duplicate(true))
	_upgrade_visible = true
	_apply_upgrade_state()


func hide_upgrade_choices() -> void:
	_upgrade_visible = false
	if _upgrade_panel != null:
		_upgrade_panel.visible = false


func show_pause_menu(endless_mode: bool = false) -> void:
	_pause_visible = true
	_pause_endless_mode = endless_mode
	if _pause_panel != null:
		_apply_pause_menu_mode()
		_pause_panel.visible = true


func hide_pause_menu() -> void:
	_pause_visible = false
	if _pause_panel != null:
		_pause_panel.visible = false


func show_result(title: String, subtitle: String, button_text: String = "返回选图") -> void:
	_result_title_text = title
	_result_subtitle_text = subtitle
	_result_button_text = button_text
	_result_visible = true
	_apply_result_state()


func hide_result() -> void:
	_result_visible = false
	if _result_panel != null:
		_result_panel.visible = false


func set_touch_controls_visible(visible_state: bool) -> void:
	_touch_controls_requested = visible_state
	if _touch_root == null:
		return
	_touch_root.visible = _mobile_layout and visible_state
	if _move_joystick != null and is_instance_valid(_move_joystick):
		_move_joystick.visible = _touch_root.visible
	if not _touch_root.visible:
		_release_touch_actions()


func set_pause_button_visible(visible_state: bool) -> void:
	_pause_button_requested = visible_state
	if _pause_button == null:
		return
	_pause_button.visible = visible_state


func _on_viewport_size_changed() -> void:
	_sync_layout_flags()
	_rebuild_ui()


func _sync_layout_flags() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	_mobile_layout = RuntimeLayout.is_touch_layout(viewport_size)
	_portrait_layout = RuntimeLayout.is_portrait(viewport_size)


func _rebuild_ui() -> void:
	_release_touch_actions()
	for child in get_children():
		remove_child(child)
		child.queue_free()
	_reset_ui_references()
	_build_ui()
	_restore_ui_state()


func _reset_ui_references() -> void:
	_stats_label = null
	_skill_panel = null
	_skill_slots.clear()
	_message_label = null
	_upgrade_panel = null
	_upgrade_title = null
	_upgrade_cards.clear()
	_pause_panel = null
	_pause_title = null
	_pause_subtitle = null
	_pause_continue_button = null
	_pause_suicide_button = null
	_pause_exit_button = null
	_pause_button = null
	_result_panel = null
	_result_title = null
	_result_subtitle = null
	_result_button = null
	_touch_root = null
	_move_joystick = null
	_hp_fill = null
	_xp_fill = null
	_hp_value_label = null
	_xp_value_label = null


func _restore_ui_state() -> void:
	if _has_run_stats:
		_apply_run_stats()
	set_message(_message_text, _message_color)
	_apply_upgrade_state()
	if _pause_visible:
		show_pause_menu(_pause_endless_mode)
	else:
		hide_pause_menu()
	_apply_result_state()
	set_pause_button_visible(_pause_button_requested)
	set_touch_controls_visible(_touch_controls_requested)


func _apply_run_stats() -> void:
	if _stats_label == null or _hp_fill == null or _xp_fill == null:
		return
	_stats_label.text = "等级 %d   生命 %d/%d   击败 %d   时间 %s\n%s" % [_current_level, _current_health, _current_max_health, _current_kills, _current_time_text, _current_threat_text]
	_apply_skill_entries()
	_hp_fill.size.x = _hp_fill_width * clampf(float(_current_health) / float(max(_current_max_health, 1)), 0.0, 1.0)
	_xp_fill.size = Vector2(_xp_fill_width * clampf(_current_xp_ratio, 0.0, 1.0), _xp_fill_height)
	if _hp_value_label != null:
		_hp_value_label.text = "%d/%d" % [_current_health, _current_max_health]
	if _xp_value_label != null:
		_xp_value_label.text = "Lv.%d  %d%%" % [_current_level, int(round(_current_xp_ratio * 100.0))]


func _apply_skill_entries() -> void:
	if _skill_slots.is_empty():
		return

	for index in range(_skill_slots.size()):
		var slot = _skill_slots[index]
		if index < _current_skill_entries.size():
			slot.set_skill_data(_current_skill_entries[index])
		else:
			slot.set_skill_data({})


func _apply_upgrade_state() -> void:
	if _upgrade_panel == null:
		return
	_upgrade_panel.visible = _upgrade_visible
	for index in range(_upgrade_cards.size()):
		var button := _upgrade_cards[index]
		if not _upgrade_visible or index >= _upgrade_choices_state.size():
			button.visible = false
			button.disabled = true
			continue
		var choice: Dictionary = _upgrade_choices_state[index]
		button.text = "%d. %s\n%s" % [index + 1, String(choice.get("title", "强化")), String(choice.get("desc", ""))]
		button.visible = true
		button.disabled = false
	return
	if _upgrade_panel == null:
		return
	_upgrade_panel.visible = _upgrade_visible
	for index in range(_upgrade_cards.size()):
		var button := _upgrade_cards[index]
		if not _upgrade_visible or index >= _upgrade_choices_state.size():
			button.visible = false
			button.disabled = true
			continue

		var choice: Dictionary = _upgrade_choices_state[index]
		button.text = "%d. %s\n%s" % [index + 1, String(choice.get("title", "强化")), String(choice.get("desc", ""))]
		button.visible = true
		button.disabled = false


func _apply_result_state() -> void:
	if _result_panel == null:
		return
	_result_panel.visible = _result_visible
	if not _result_visible:
		return
	_result_title.text = _result_title_text
	_result_subtitle.text = _result_subtitle_text
	_result_button.text = _result_button_text


func _apply_pause_menu_mode() -> void:
	if _pause_subtitle == null:
		return
	if _pause_endless_mode:
		_pause_subtitle.text = "无尽模式不会正常通关，只能继续战斗，或在这里主动结束本局。"
	else:
		_pause_subtitle.text = "继续战斗，或返回选图。"
	if _pause_suicide_button != null:
		_pause_suicide_button.visible = _pause_endless_mode
	if _pause_exit_button != null:
		_pause_exit_button.visible = not _pause_endless_mode


func _build_ui() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var mobile_landscape := _mobile_layout and not _portrait_layout
	var side_margin := 14.0
	var top_margin := 14.0
	var pause_button_size := Vector2(90.0, 36.0)
	var top_panel_size := Vector2(480.0, 172.0)

	if _mobile_layout:
		side_margin = 10.0
		top_margin = 8.0 if mobile_landscape else 10.0
		pause_button_size = Vector2(84.0, 32.0) if mobile_landscape else Vector2(76.0, 32.0)
		top_panel_size = Vector2(viewport_size.x - side_margin * 2.0, 124.0) if mobile_landscape else Vector2(viewport_size.x - side_margin * 2.0, 156.0)

	var top_panel := ColorRect.new()
	top_panel.color = Color(0.02, 0.03, 0.05, 0.72)
	top_panel.position = Vector2(side_margin, top_margin)
	top_panel.size = top_panel_size
	add_child(top_panel)

	_pause_button = _make_button("暂停", 18 if mobile_landscape else (16 if _mobile_layout else 20))
	_pause_button.position = Vector2(top_panel.position.x + top_panel.size.x - pause_button_size.x - 10.0, top_panel.position.y + 8.0)
	_pause_button.size = pause_button_size
	_pause_button.pressed.connect(_on_pause_button_pressed)
	_pause_button.visible = false
	add_child(_pause_button)

	_stats_label = _make_label(15 if _mobile_layout else 22, Color(0.94, 0.96, 0.98))
	if mobile_landscape:
		_stats_label.add_theme_font_size_override("font_size", 14)
	_stats_label.position = top_panel.position + Vector2(14.0, 10.0)
	_stats_label.size = Vector2(top_panel.size.x - 28.0, top_panel.size.y - (78.0 if mobile_landscape else 98.0))
	if _mobile_layout:
		_stats_label.size.x -= pause_button_size.x + 12.0
	_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_stats_label)

	var bar_label_width := 42.0 if _mobile_layout else 48.0
	var bar_value_width := 70.0 if mobile_landscape else (76.0 if _mobile_layout else 92.0)
	var hp_bar_height := 10.0 if mobile_landscape else (12.0 if _mobile_layout else 14.0)
	var xp_bar_height := 14.0 if mobile_landscape else (16.0 if _mobile_layout else 20.0)
	var bars_left := top_panel.position.x + 14.0
	var bars_right_padding := 14.0
	var bar_start_x := bars_left + bar_label_width + 10.0
	var hp_bar_width := maxf(86.0, top_panel.position.x + top_panel.size.x - bar_start_x - bar_value_width - bars_right_padding)
	var xp_bar_width := top_panel.size.x - 28.0
	var hp_row_y := top_panel.position.y + top_panel.size.y - (56.0 if mobile_landscape else (72.0 if _mobile_layout else 82.0))
	var xp_header_y := hp_row_y + hp_bar_height + (6.0 if mobile_landscape else 8.0)
	var xp_bar_y := xp_header_y + 18.0

	var hp_caption := _make_label(13 if _mobile_layout else 16, Color(1.0, 0.84, 0.82))
	hp_caption.text = "HP"
	hp_caption.position = Vector2(bars_left, hp_row_y - 2.0)
	hp_caption.size = Vector2(bar_label_width, 18.0)
	add_child(hp_caption)

	var hp_back := ColorRect.new()
	hp_back.color = Color(0.18, 0.08, 0.10, 0.92)
	hp_back.position = Vector2(bar_start_x, hp_row_y)
	hp_back.size = Vector2(hp_bar_width, hp_bar_height)
	_hp_fill_width = hp_back.size.x
	add_child(hp_back)

	_hp_fill = ColorRect.new()
	_hp_fill.color = Color(0.98, 0.38, 0.34, 0.94)
	_hp_fill.position = hp_back.position
	_hp_fill.size = hp_back.size
	add_child(_hp_fill)

	_hp_value_label = _make_label(12 if _mobile_layout else 15, Color(1.0, 0.92, 0.92), HORIZONTAL_ALIGNMENT_RIGHT)
	_hp_value_label.position = Vector2(hp_back.position.x + hp_back.size.x + 8.0, hp_row_y - 4.0)
	_hp_value_label.size = Vector2(bar_value_width, 20.0)
	add_child(_hp_value_label)

	var xp_caption := _make_label(13 if _mobile_layout else 17, Color(0.82, 0.96, 1.0))
	xp_caption.text = "升级进度"
	xp_caption.position = Vector2(bars_left, xp_header_y - 2.0)
	xp_caption.size = Vector2(96.0 if _mobile_layout else 120.0, 20.0)
	add_child(xp_caption)

	var xp_back := ColorRect.new()
	xp_back.color = Color(0.07, 0.12, 0.18, 0.96)
	xp_back.position = Vector2(bars_left, xp_bar_y)
	xp_back.size = Vector2(xp_bar_width, xp_bar_height)
	_xp_fill_width = xp_back.size.x
	_xp_fill_height = xp_back.size.y
	add_child(xp_back)

	_xp_fill = ColorRect.new()
	_xp_fill.color = Color(0.30, 0.86, 1.0, 0.96)
	_xp_fill.position = xp_back.position
	_xp_fill.size = Vector2.ZERO
	add_child(_xp_fill)

	_xp_value_label = _make_label(12 if _mobile_layout else 15, Color(0.88, 0.98, 1.0), HORIZONTAL_ALIGNMENT_RIGHT)
	_xp_value_label.position = Vector2(top_panel.position.x + top_panel.size.x - 130.0, xp_header_y - 2.0)
	_xp_value_label.size = Vector2(116.0, 20.0)
	add_child(_xp_value_label)

	var spell_panel_position := Vector2(side_margin, viewport_size.y - 134.0)
	var spell_panel_size := Vector2(468.0, 118.0)
	if _mobile_layout:
		if mobile_landscape:
			spell_panel_size = Vector2(minf(340.0, viewport_size.x * 0.36), 92.0)
			spell_panel_position = Vector2(viewport_size.x - side_margin - spell_panel_size.x, viewport_size.y - side_margin - spell_panel_size.y)
		else:
			spell_panel_size = Vector2(viewport_size.x - side_margin * 2.0, 94.0)
			spell_panel_position = Vector2(side_margin, top_panel.position.y + top_panel.size.y + 12.0)

	_skill_panel = ColorRect.new()
	_skill_panel.color = Color(0.02, 0.03, 0.05, 0.60)
	_skill_panel.position = spell_panel_position
	_skill_panel.size = spell_panel_size
	add_child(_skill_panel)

	var slot_gap: float = 8.0 if _mobile_layout else 10.0
	var slot_padding: float = 10.0
	var slot_size: float = floor((spell_panel_size.x - slot_padding * 2.0 - slot_gap * 3.0) / 4.0)
	slot_size = minf(slot_size, spell_panel_size.y - 14.0)
	var slot_y: float = (spell_panel_size.y - slot_size) * 0.5
	for index in range(4):
		var slot = SKILL_SLOT_SCRIPT.new()
		slot.position = Vector2(slot_padding + float(index) * (slot_size + slot_gap), slot_y)
		slot.size = Vector2(slot_size, slot_size)
		_skill_panel.add_child(slot)
		_skill_slots.append(slot)

	var message_width := 840.0
	var message_y := 20.0
	if _mobile_layout:
		message_width = minf(viewport_size.x - 24.0, 360.0 if not mobile_landscape else 420.0)
		message_y = top_panel.position.y + top_panel.size.y + 8.0
	_message_label = _make_label(20 if _mobile_layout else 30, Color(0.98, 0.90, 0.40), HORIZONTAL_ALIGNMENT_CENTER)
	_message_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_message_label.position = Vector2(-message_width * 0.5, message_y)
	_message_label.size = Vector2(message_width, 60.0 if _mobile_layout else 76.0)
	_message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_message_label.visible = false
	add_child(_message_label)

	var modal_size := Vector2(minf(viewport_size.x - 120.0, 1020.0), minf(viewport_size.y - 140.0, 520.0))
	if _mobile_layout:
		if mobile_landscape:
			modal_size = Vector2(viewport_size.x - 36.0, minf(viewport_size.y - 28.0, 330.0))
		else:
			modal_size = Vector2(viewport_size.x - 28.0, viewport_size.y - 36.0)

	_upgrade_panel = ColorRect.new()
	_upgrade_panel.color = Color(0.03, 0.05, 0.07, 0.95)
	_upgrade_panel.position = (viewport_size - modal_size) * 0.5
	_upgrade_panel.size = modal_size
	_upgrade_panel.visible = false
	add_child(_upgrade_panel)

	_upgrade_title = _make_label(22 if _mobile_layout else 30, Color(0.98, 0.94, 0.54), HORIZONTAL_ALIGNMENT_CENTER)
	_upgrade_title.position = Vector2(24.0, 18.0)
	_upgrade_title.size = Vector2(_upgrade_panel.size.x - 48.0, 56.0)
	_upgrade_title.text = "选择一项强化"
	_upgrade_panel.add_child(_upgrade_title)

	for index in range(3):
		var button := _make_button("", 17 if _mobile_layout else 22)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
		button.clip_text = false
		button.pressed.connect(_on_upgrade_button_pressed.bind(index))
		if _mobile_layout and not mobile_landscape:
			button.position = Vector2(18.0, 84.0 + float(index) * 154.0)
			button.size = Vector2(_upgrade_panel.size.x - 36.0, 132.0)
		else:
			button.position = Vector2(24.0 + float(index) * ((_upgrade_panel.size.x - 78.0) / 3.0), 96.0)
			button.size = Vector2((_upgrade_panel.size.x - 96.0) / 3.0, _upgrade_panel.size.y - 128.0)
		_upgrade_panel.add_child(button)
		_upgrade_cards.append(button)

	var pause_size := Vector2(minf(viewport_size.x - 180.0, 540.0), 300.0)
	if _mobile_layout:
		pause_size = Vector2(minf(viewport_size.x - 36.0, 560.0), 250.0 if mobile_landscape else 278.0)

	_pause_panel = ColorRect.new()
	_pause_panel.color = Color(0.03, 0.05, 0.07, 0.95)
	_pause_panel.position = (viewport_size - pause_size) * 0.5
	_pause_panel.size = pause_size
	_pause_panel.visible = false
	add_child(_pause_panel)

	_pause_title = _make_label(28 if _mobile_layout else 40, Color(1.0, 0.93, 0.54), HORIZONTAL_ALIGNMENT_CENTER)
	_pause_title.position = Vector2(24.0, 26.0)
	_pause_title.size = Vector2(_pause_panel.size.x - 48.0, 48.0)
	_pause_title.text = "已暂停"
	_pause_panel.add_child(_pause_title)

	_pause_subtitle = _make_label(17 if _mobile_layout else 24, Color(0.88, 0.94, 0.98), HORIZONTAL_ALIGNMENT_CENTER)
	_pause_subtitle.position = Vector2(24.0, 80.0)
	_pause_subtitle.size = Vector2(_pause_panel.size.x - 48.0, 56.0)
	_pause_subtitle.text = "继续战斗，或返回选图。"
	_pause_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_pause_panel.add_child(_pause_subtitle)

	_pause_continue_button = _make_button("继续战斗", 18 if _mobile_layout else 24)
	_pause_continue_button.position = Vector2((_pause_panel.size.x - 220.0) * 0.5, 152.0 if mobile_landscape else 170.0)
	_pause_continue_button.size = Vector2(220.0, 50.0)
	_pause_continue_button.pressed.connect(_on_pause_continue_pressed)
	_pause_panel.add_child(_pause_continue_button)

	_pause_suicide_button = _make_button("主动结束本局", 18 if _mobile_layout else 24)
	_pause_suicide_button.position = Vector2((_pause_panel.size.x - 220.0) * 0.5, 208.0 if mobile_landscape else 228.0)
	_pause_suicide_button.size = Vector2(220.0, 50.0)
	_pause_suicide_button.pressed.connect(_on_pause_suicide_pressed)
	_pause_suicide_button.visible = false
	_pause_panel.add_child(_pause_suicide_button)

	_pause_exit_button = _make_button("返回选图", 18 if _mobile_layout else 24)
	_pause_exit_button.position = Vector2((_pause_panel.size.x - 220.0) * 0.5, 208.0 if mobile_landscape else 228.0)
	_pause_exit_button.size = Vector2(220.0, 50.0)
	_pause_exit_button.pressed.connect(_on_pause_exit_pressed)
	_pause_panel.add_child(_pause_exit_button)

	_result_panel = ColorRect.new()
	_result_panel.color = Color(0.03, 0.05, 0.07, 0.95)
	if _mobile_layout:
		_result_panel.size = Vector2(minf(viewport_size.x - 36.0, 620.0), 284.0 if mobile_landscape else 334.0)
	else:
		_result_panel.size = Vector2(pause_size.x + 90.0, pause_size.y + 22.0)
	_result_panel.position = (viewport_size - _result_panel.size) * 0.5
	_result_panel.visible = false
	add_child(_result_panel)

	_result_title = _make_label(28 if _mobile_layout else 40, Color(1.0, 0.93, 0.54), HORIZONTAL_ALIGNMENT_CENTER)
	_result_title.position = Vector2(34.0, 28.0)
	_result_title.size = Vector2(_result_panel.size.x - 68.0, 48.0)
	_result_panel.add_child(_result_title)

	_result_subtitle = _make_label(17 if _mobile_layout else 24, Color(0.88, 0.94, 0.98), HORIZONTAL_ALIGNMENT_CENTER)
	_result_subtitle.position = Vector2(28.0, 86.0)
	_result_subtitle.size = Vector2(_result_panel.size.x - 56.0, 128.0 if mobile_landscape else 144.0)
	_result_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_panel.add_child(_result_subtitle)

	_result_button = _make_button("返回选图", 18 if _mobile_layout else 24)
	_result_button.position = Vector2((_result_panel.size.x - 240.0) * 0.5, _result_panel.size.y - 70.0)
	_result_button.size = Vector2(240.0, 50.0)
	_result_button.pressed.connect(_on_restart_button_pressed)
	_result_panel.add_child(_result_button)

	_apply_pause_menu_mode()
	_build_touch_controls()


func _build_touch_controls() -> void:
	_touch_root = Control.new()
	_touch_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_touch_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_touch_root.visible = false
	add_child(_touch_root)


func _make_label(font_size: int, color: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.modulate = color
	label.horizontal_alignment = alignment
	label.add_theme_font_override("font", UI_FONT)
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _make_button(text: String, font_size: int) -> Button:
	var button := Button.new()
	button.text = text
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	button.clip_text = false
	button.add_theme_font_override("font", UI_FONT)
	button.add_theme_font_size_override("font_size", font_size)
	return button


func _on_upgrade_button_pressed(index: int) -> void:
	upgrade_selected.emit(index)


func _on_restart_button_pressed() -> void:
	restart_requested.emit()


func _on_pause_button_pressed() -> void:
	pause_requested.emit()


func _on_pause_continue_pressed() -> void:
	pause_resume_requested.emit()


func _on_pause_suicide_pressed() -> void:
	pause_suicide_requested.emit()


func _on_pause_exit_pressed() -> void:
	pause_exit_requested.emit()


func _on_move_vector_changed(vector: Vector2) -> void:
	move_vector_changed.emit(vector)


func _release_touch_actions() -> void:
	if _move_joystick != null and is_instance_valid(_move_joystick):
		_move_joystick.force_release()
	for action in ["move_left", "move_right", "move_up", "move_down"]:
		Input.action_release(action)
