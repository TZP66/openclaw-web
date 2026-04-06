extends RefCounted
class_name SvgModelLibrary

const RASTER_SCALE := 2.0

const CHARACTER_MODELS := {
	"caster": {
		"id": "caster",
		"game_height": 88.0,
		"game_offset": Vector2(0.0, -8.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='82' r='46' fill='#5ecff3' opacity='0.14'/>
<circle cx='80' cy='82' r='36' fill='none' stroke='#b5f5ff' stroke-width='4' opacity='0.35'/>
<path d='M80 20L116 52L122 116Q80 146 38 116L44 52Z' fill='#2a77b8' stroke='#0d2a46' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 40L105 58L108 110Q80 130 52 110L55 58Z' fill='#133b65' opacity='0.92'/>
<path d='M64 28Q80 10 96 28L92 48Q80 40 68 48Z' fill='#174a78'/>
<circle cx='80' cy='40' r='14' fill='#f4c4a1' stroke='#2b1621' stroke-width='4'/>
<path d='M67 33Q80 20 93 33' fill='none' stroke='#10253b' stroke-width='6' stroke-linecap='round'/>
<path d='M58 68L42 112' stroke='#18314f' stroke-width='8' stroke-linecap='round'/>
<path d='M102 68L116 108' stroke='#18314f' stroke-width='8' stroke-linecap='round'/>
<rect x='118' y='42' width='8' height='68' rx='4' fill='#7a4a2d' transform='rotate(14 122 76)'/>
<circle cx='130' cy='34' r='10' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>
<circle cx='130' cy='34' r='18' fill='none' stroke='#ffe377' stroke-width='4' opacity='0.34'/>
<path d='M66 86L94 86' stroke='#ffd56b' stroke-width='6' stroke-linecap='round'/>
<circle cx='74' cy='40' r='2.8' fill='#1a0f14'/>
<circle cx='86' cy='40' r='2.8' fill='#1a0f14'/>
</svg>""",
	},
	"blade": {
		"id": "blade",
		"game_height": 92.0,
		"game_offset": Vector2(0.0, -8.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M80 22L110 48L112 118Q80 146 48 118L50 48Z' fill='#2a3343' stroke='#101723' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 44L100 60L102 110Q80 126 58 110L60 60Z' fill='#11161f'/>
<circle cx='80' cy='38' r='14' fill='#edc1a0' stroke='#241219' stroke-width='4'/>
<path d='M66 30Q80 16 94 30' fill='none' stroke='#6f4237' stroke-width='6' stroke-linecap='round'/>
<path d='M54 62L40 108' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<path d='M106 60L118 106' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<path d='M52 56L66 44L80 54L66 70Z' fill='#4b566c' stroke='#0f141d' stroke-width='4' stroke-linejoin='round'/>
<path d='M108 58L96 46L82 56L96 72Z' fill='#3c4558' stroke='#0f141d' stroke-width='4' stroke-linejoin='round'/>
<path d='M66 84L95 84' stroke='#ff7a5c' stroke-width='6' stroke-linecap='round'/>
<path d='M108 38L94 80' stroke='#463128' stroke-width='7' stroke-linecap='round'/>
<path d='M92 30L108 22L142 70L126 78Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>
<path d='M96 42L112 34' stroke='#ffffff' stroke-width='4' stroke-linecap='round' opacity='0.48'/>
<circle cx='74' cy='38' r='2.8' fill='#180f14'/>
<circle cx='86' cy='38' r='2.8' fill='#180f14'/>
</svg>""",
	},
	"thunder": {
		"id": "thunder",
		"game_height": 92.0,
		"game_offset": Vector2(0.0, -8.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='44' fill='#66c8ff' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#d6f6ff' stroke-width='4' opacity='0.30'/>
<path d='M80 22L110 50L114 120Q80 146 46 120L50 50Z' fill='#20385c' stroke='#0d1a2c' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L102 60L104 110Q80 128 56 110L58 60Z' fill='#0f1d33'/>
<circle cx='80' cy='38' r='14' fill='#f2c4a3' stroke='#24141c' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#dfefff' stroke-width='6' stroke-linecap='round'/>
<path d='M54 62L42 106' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<path d='M106 60L118 104' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<path d='M62 84L98 84' stroke='#8bd8ff' stroke-width='6' stroke-linecap='round'/>
<path d='M114 34L102 58L118 60L104 88' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M48 56L64 44L80 54L64 72Z' fill='#4d6896' stroke='#10203a' stroke-width='4' stroke-linejoin='round'/>
<path d='M112 56L96 44L80 54L96 72Z' fill='#39517a' stroke='#10203a' stroke-width='4' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.8' fill='#140f14'/>
<circle cx='86' cy='38' r='2.8' fill='#140f14'/>
</svg>""",
	},
}

const ENEMY_MODELS := {
	"wisp": {
		"id": "wisp",
		"game_height": 62.0,
		"game_offset": Vector2(0.0, -4.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='74' r='42' fill='#9ce7ff' opacity='0.16'/>
<path d='M80 24Q118 28 118 70Q118 116 80 136Q42 116 42 70Q42 28 80 24Z' fill='#8d3656' stroke='#2f0e1b' stroke-width='6' stroke-linejoin='round'/>
<path d='M60 112Q80 126 100 112' fill='none' stroke='#c85a82' stroke-width='6' stroke-linecap='round'/>
<circle cx='80' cy='76' r='20' fill='#f6f0d0' stroke='#2f0e1b' stroke-width='5'/>
<circle cx='80' cy='76' r='8' fill='#11151a'/>
<circle cx='80' cy='76' r='3.5' fill='#71e4ff'/>
<path d='M58 56Q80 40 102 56' fill='none' stroke='#f9b7cf' stroke-width='5' stroke-linecap='round'/>
</svg>""",
	},
	"lancer": {
		"id": "lancer",
		"game_height": 74.0,
		"game_offset": Vector2(0.0, -8.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M80 28L110 54L114 118Q80 144 46 118L50 54Z' fill='#2c5d90' stroke='#10263e' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 40L101 58L104 108Q80 126 56 108L59 58Z' fill='#173553'/>
<circle cx='80' cy='40' r='14' fill='#cfdae7' stroke='#10263e' stroke-width='5'/>
<path d='M70 18L80 8L90 18V34H70Z' fill='#d5ebff' stroke='#10263e' stroke-width='5' stroke-linejoin='round'/>
<path d='M56 60L40 110' stroke='#183049' stroke-width='8' stroke-linecap='round'/>
<path d='M104 60L116 110' stroke='#183049' stroke-width='8' stroke-linecap='round'/>
<path d='M112 20L126 16L142 94L128 98Z' fill='#dff2ff' stroke='#365d82' stroke-width='4' stroke-linejoin='round'/>
<path d='M122 10L144 20L124 30Z' fill='#f5f7fb' stroke='#365d82' stroke-width='4' stroke-linejoin='round'/>
<path d='M48 54L62 44L64 74L48 82L38 66Z' fill='#81b9e8' stroke='#173553' stroke-width='4' stroke-linejoin='round'/>
<circle cx='75' cy='40' r='2.4' fill='#0e141c'/>
<circle cx='85' cy='40' r='2.4' fill='#0e141c'/>
</svg>""",
	},
	"brute": {
		"id": "brute",
		"game_height": 82.0,
		"game_offset": Vector2(0.0, -4.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M44 60Q52 34 80 34Q108 34 116 60L124 118Q102 140 80 140Q58 140 36 118Z' fill='#6d3428' stroke='#2a120f' stroke-width='6' stroke-linejoin='round'/>
<rect x='52' y='56' width='56' height='54' rx='12' fill='#3f1c16'/>
<circle cx='80' cy='36' r='16' fill='#f1bf9f' stroke='#2a120f' stroke-width='5'/>
<path d='M62 22L70 10L80 24L90 10L98 22' fill='none' stroke='#b05834' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M38 66L20 112' stroke='#4b2319' stroke-width='12' stroke-linecap='round'/>
<path d='M122 66L138 112' stroke='#4b2319' stroke-width='12' stroke-linecap='round'/>
<path d='M24 112L44 122' stroke='#c8733a' stroke-width='12' stroke-linecap='round'/>
<path d='M126 62L144 48' stroke='#3b2a22' stroke-width='8' stroke-linecap='round'/>
<rect x='134' y='30' width='12' height='48' rx='4' fill='#c98742' transform='rotate(18 140 54)'/>
<rect x='126' y='18' width='30' height='22' rx='5' fill='#dda45a' stroke='#4b2319' stroke-width='4' transform='rotate(18 141 29)'/>
<circle cx='74' cy='36' r='3' fill='#140d0f'/>
<circle cx='86' cy='36' r='3' fill='#140d0f'/>
</svg>""",
	},
	"embermage": {
		"id": "embermage",
		"game_height": 76.0,
		"game_offset": Vector2(0.0, -8.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M80 26L110 54L116 120Q80 146 44 120L50 54Z' fill='#7b2d1f' stroke='#2a120f' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L100 60L104 108Q80 128 56 108L60 60Z' fill='#34150f'/>
<circle cx='80' cy='40' r='14' fill='#f2c39b' stroke='#2a120f' stroke-width='4'/>
<path d='M68 22L74 8L82 20L88 6L94 22' fill='none' stroke='#ffb254' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M54 64L42 108' stroke='#411b14' stroke-width='8' stroke-linecap='round'/>
<path d='M106 62L116 104' stroke='#411b14' stroke-width='8' stroke-linecap='round'/>
<circle cx='124' cy='56' r='16' fill='#ff9a2f' stroke='#5a2516' stroke-width='5'/>
<path d='M118 66Q124 44 132 60Q132 80 120 88' fill='none' stroke='#ffe07b' stroke-width='5' stroke-linecap='round'/>
<path d='M62 86L98 86' stroke='#ffcf63' stroke-width='6' stroke-linecap='round'/>
<circle cx='75' cy='40' r='2.6' fill='#130d0f'/>
<circle cx='85' cy='40' r='2.6' fill='#130d0f'/>
</svg>""",
	},
	"seer": {
		"id": "seer",
		"game_height": 74.0,
		"game_offset": Vector2(0.0, -8.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='82' r='44' fill='#927cff' opacity='0.16'/>
<path d='M80 20L108 50L114 118Q80 144 46 118L52 50Z' fill='#4f2a67' stroke='#1e1128' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 38L100 56L104 108Q80 126 56 108L60 56Z' fill='#261433'/>
<path d='M68 26Q80 12 92 26L88 46Q80 38 72 46Z' fill='#6c3d8f'/>
<circle cx='80' cy='40' r='12' fill='#e4d9ff' stroke='#1e1128' stroke-width='4'/>
<path d='M64 64Q80 54 96 64' fill='none' stroke='#bb9bff' stroke-width='5' stroke-linecap='round'/>
<path d='M54 62L42 106' stroke='#281633' stroke-width='8' stroke-linecap='round'/>
<path d='M106 62L118 106' stroke='#281633' stroke-width='8' stroke-linecap='round'/>
<path d='M122 28L128 96' stroke='#6f57b8' stroke-width='6' stroke-linecap='round'/>
<circle cx='128' cy='24' r='9' fill='#cbb7ff' stroke='#2a1740' stroke-width='4'/>
<circle cx='80' cy='40' r='3.6' fill='#5b45c8'/>
</svg>""",
	},
	"mireling": {
		"id": "mireling",
		"game_height": 84.0,
		"game_offset": Vector2(0.0, -2.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M36 86Q38 48 80 42Q122 48 124 86Q122 130 80 136Q38 130 36 86Z' fill='#2a5a34' stroke='#102316' stroke-width='6' stroke-linejoin='round'/>
<ellipse cx='80' cy='86' rx='28' ry='24' fill='#17311d'/>
<path d='M54 58L42 38L62 48' fill='none' stroke='#80c469' stroke-width='8' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M106 58L118 38L98 48' fill='none' stroke='#80c469' stroke-width='8' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='62' cy='78' r='10' fill='#9ce07d' stroke='#17311d' stroke-width='4'/>
<circle cx='98' cy='78' r='10' fill='#9ce07d' stroke='#17311d' stroke-width='4'/>
<circle cx='62' cy='78' r='3.4' fill='#0c1510'/>
<circle cx='98' cy='78' r='3.4' fill='#0c1510'/>
<path d='M64 104Q80 116 96 104' fill='none' stroke='#80c469' stroke-width='6' stroke-linecap='round'/>
<path d='M44 108L28 124' stroke='#17311d' stroke-width='10' stroke-linecap='round'/>
<path d='M116 108L132 124' stroke='#17311d' stroke-width='10' stroke-linecap='round'/>
<path d='M32 124L46 128' stroke='#9ce07d' stroke-width='8' stroke-linecap='round'/>
<path d='M128 124L114 128' stroke='#9ce07d' stroke-width='8' stroke-linecap='round'/>
</svg>""",
	},
	"storm_archon": {
		"id": "storm_archon",
		"game_height": 146.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='82' r='52' fill='#7fe0ff' opacity='0.12'/>
<circle cx='80' cy='82' r='44' fill='none' stroke='#d9fbff' stroke-width='5' opacity='0.34'/>
<path d='M80 16L98 46L124 52L108 76L114 112L80 98L46 112L52 76L36 52L62 46Z' fill='#2e679e' stroke='#0d243c' stroke-width='6' stroke-linejoin='round'/>
<circle cx='80' cy='74' r='24' fill='#d7f8ff' stroke='#0d243c' stroke-width='5'/>
<path d='M52 66L14 44L30 82L16 118L56 96' fill='#b7eeff' stroke='#2268a0' stroke-width='5' stroke-linejoin='round'/>
<path d='M108 66L146 44L130 82L144 118L104 96' fill='#b7eeff' stroke='#2268a0' stroke-width='5' stroke-linejoin='round'/>
<path d='M64 120L56 146L80 130L104 146L96 120' fill='#5bc7ff' stroke='#14507e' stroke-width='5' stroke-linejoin='round'/>
<path d='M72 74L80 58L88 74L80 90Z' fill='#1aa6ff' stroke='#0d243c' stroke-width='4' stroke-linejoin='round'/>
<circle cx='74' cy='74' r='3.2' fill='#10223a'/>
<circle cx='86' cy='74' r='3.2' fill='#10223a'/>
</svg>""",
	},
	"forge_tyrant": {
		"id": "forge_tyrant",
		"game_height": 152.0,
		"game_offset": Vector2(0.0, -4.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<rect x='20' y='88' width='120' height='34' rx='14' fill='#231816' stroke='#080606' stroke-width='6'/>
<rect x='34' y='62' width='92' height='42' rx='12' fill='#7a3625' stroke='#28110d' stroke-width='6'/>
<rect x='52' y='34' width='56' height='34' rx='10' fill='#c96d3c' stroke='#4b1f16' stroke-width='6'/>
<rect x='62' y='44' width='36' height='18' rx='6' fill='#ffd06a' stroke='#7a3625' stroke-width='4'/>
<path d='M94 50L142 28L146 44L104 64Z' fill='#c96d3c' stroke='#4b1f16' stroke-width='6' stroke-linejoin='round'/>
<path d='M18 72L34 62L42 80L26 88Z' fill='#d68a4b' stroke='#4b1f16' stroke-width='5' stroke-linejoin='round'/>
<circle cx='46' cy='106' r='12' fill='#47312b'/>
<circle cx='70' cy='106' r='12' fill='#47312b'/>
<circle cx='94' cy='106' r='12' fill='#47312b'/>
<circle cx='118' cy='106' r='12' fill='#47312b'/>
<path d='M80 48L86 58L80 68L74 58Z' fill='#ff8d2c'/>
<path d='M74 26L80 12L86 26' fill='none' stroke='#ffd06a' stroke-width='6' stroke-linecap='round'/>
</svg>""",
	},
	"void_matriarch": {
		"id": "void_matriarch",
		"game_height": 148.0,
		"game_offset": Vector2(0.0, -8.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='80' r='52' fill='#a48fff' opacity='0.10'/>
<path d='M80 26Q106 34 116 58Q124 82 116 108Q106 132 80 140Q54 132 44 108Q36 82 44 58Q54 34 80 26Z' fill='#35204d' stroke='#140d1f' stroke-width='6' stroke-linejoin='round'/>
<circle cx='80' cy='82' r='28' fill='#d4c8ff' stroke='#28183c' stroke-width='5'/>
<ellipse cx='80' cy='82' rx='14' ry='9' fill='#261737'/>
<circle cx='80' cy='82' r='5' fill='#8a6cff'/>
<path d='M52 54Q30 34 20 50Q20 70 46 76' fill='none' stroke='#6f58b6' stroke-width='8' stroke-linecap='round'/>
<path d='M108 54Q130 34 140 50Q140 70 114 76' fill='none' stroke='#6f58b6' stroke-width='8' stroke-linecap='round'/>
<path d='M60 120Q42 140 52 152Q68 156 76 134' fill='none' stroke='#8a6cff' stroke-width='8' stroke-linecap='round'/>
<path d='M100 120Q118 140 108 152Q92 156 84 134' fill='none' stroke='#8a6cff' stroke-width='8' stroke-linecap='round'/>
<path d='M80 20L92 8L96 28' fill='none' stroke='#c6b7ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M68 46Q80 32 92 46' fill='none' stroke='#c6b7ff' stroke-width='5' stroke-linecap='round'/>
</svg>""",
	},
}

static var _texture_cache: Dictionary = {}


static func get_character_model(character_id: String) -> Dictionary:
	return _clone_model(CHARACTER_MODELS.get(character_id, CHARACTER_MODELS["caster"]))


static func get_enemy_model(archetype: String) -> Dictionary:
	return _clone_model(ENEMY_MODELS.get(archetype, ENEMY_MODELS["wisp"]))


static func get_character_texture(character_id: String, raster_scale: float = RASTER_SCALE) -> Texture2D:
	return _rasterize_model(get_character_model(character_id), raster_scale)


static func get_enemy_texture(archetype: String, raster_scale: float = RASTER_SCALE) -> Texture2D:
	return _rasterize_model(get_enemy_model(archetype), raster_scale)


static func get_character_ids() -> Array[String]:
	return CHARACTER_MODELS.keys()


static func get_enemy_ids() -> Array[String]:
	return ENEMY_MODELS.keys()


static func _clone_model(model_info_variant) -> Dictionary:
	var model_info: Dictionary = model_info_variant
	return model_info.duplicate(true)


static func _rasterize_model(model_info: Dictionary, raster_scale: float) -> Texture2D:
	var model_id := String(model_info.get("id", "model"))
	var cache_key := "%s@%.2f" % [model_id, raster_scale]
	if _texture_cache.has(cache_key):
		return _texture_cache[cache_key]

	var svg_source := String(model_info.get("svg", ""))
	if svg_source.is_empty():
		push_warning("Missing SVG source for model %s" % model_id)
		return null

	var image := Image.new()
	var error := image.load_svg_from_string(svg_source, raster_scale)
	if error != OK:
		push_warning("Failed to rasterize SVG model %s: %s" % [model_id, error_string(error)])
		return null

	var texture := ImageTexture.create_from_image(image)
	_texture_cache[cache_key] = texture
	return texture
