extends RefCounted
class_name SvgEffectLibrary

const RASTER_SCALE := 2.0

const EFFECT_TEMPLATES := {
	"impact_burst": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='108' fill='{PRIMARY}' opacity='0.10'/>
<circle cx='128' cy='128' r='82' fill='none' stroke='{ACCENT}' stroke-width='12' opacity='0.34'/>
<circle cx='128' cy='128' r='48' fill='{SECONDARY}' opacity='0.94'/>
<circle cx='128' cy='128' r='24' fill='{ACCENT}' opacity='0.78'/>
<polygon points='128,10 144,68 128,56 112,68' fill='{ACCENT}' opacity='0.88'/>
<polygon points='210,46 190,104 182,84 164,78' fill='{ACCENT}' opacity='0.82'/>
<polygon points='246,128 188,144 200,128 188,112' fill='{ACCENT}' opacity='0.88'/>
<polygon points='210,210 164,178 184,172 190,152' fill='{ACCENT}' opacity='0.82'/>
<polygon points='128,246 112,188 128,200 144,188' fill='{ACCENT}' opacity='0.88'/>
<polygon points='46,210 66,152 74,172 92,178' fill='{ACCENT}' opacity='0.82'/>
<polygon points='10,128 68,112 56,128 68,144' fill='{ACCENT}' opacity='0.88'/>
<polygon points='46,46 92,78 72,84 66,104' fill='{ACCENT}' opacity='0.82'/>
</svg>""",
	"impact_ring": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='104' fill='none' stroke='{PRIMARY}' stroke-width='20' opacity='0.16'/>
<circle cx='128' cy='128' r='92' fill='none' stroke='{SECONDARY}' stroke-width='8' opacity='0.92'/>
<circle cx='128' cy='128' r='66' fill='none' stroke='{ACCENT}' stroke-width='6' opacity='0.42'/>
<polygon points='128,34 140,58 128,52 116,58' fill='{ACCENT}' opacity='0.72'/>
<polygon points='222,128 198,140 204,128 198,116' fill='{ACCENT}' opacity='0.72'/>
<polygon points='128,222 116,198 128,204 140,198' fill='{ACCENT}' opacity='0.72'/>
<polygon points='34,128 58,116 52,128 58,140' fill='{ACCENT}' opacity='0.72'/>
</svg>""",
	"impact_core": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='90' fill='{PRIMARY}' opacity='0.10'/>
<circle cx='128' cy='128' r='56' fill='{SECONDARY}' opacity='0.94'/>
<circle cx='128' cy='128' r='28' fill='{ACCENT}' opacity='0.84'/>
<path d='M128 44L140 92L128 84L116 92Z' fill='{ACCENT}' opacity='0.68'/>
<path d='M212 128L164 140L172 128L164 116Z' fill='{ACCENT}' opacity='0.68'/>
<path d='M128 212L116 164L128 172L140 164Z' fill='{ACCENT}' opacity='0.68'/>
<path d='M44 128L92 116L84 128L92 140Z' fill='{ACCENT}' opacity='0.68'/>
</svg>""",
	"slash_arc": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<path d='M34 188C74 134 120 90 180 54C198 44 218 36 236 30C220 64 202 94 176 126C144 164 106 196 60 218L34 188Z' fill='{PRIMARY}' opacity='0.74'/>
<path d='M52 180C94 118 146 76 224 40' fill='none' stroke='{SECONDARY}' stroke-width='18' stroke-linecap='round' opacity='0.94'/>
<path d='M84 182C124 128 170 92 212 74' fill='none' stroke='{ACCENT}' stroke-width='8' stroke-linecap='round' opacity='0.88'/>
<polygon points='190,56 246,24 220,92' fill='{ACCENT}' opacity='0.92'/>
</svg>""",
	"slash_edge": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<path d='M62 176C112 116 156 82 220 52' fill='none' stroke='{SECONDARY}' stroke-width='14' stroke-linecap='round' opacity='0.92'/>
<path d='M92 182C136 132 176 102 212 88' fill='none' stroke='{ACCENT}' stroke-width='7' stroke-linecap='round' opacity='0.86'/>
<polygon points='200,64 238,42 220,88' fill='{ACCENT}' opacity='0.88'/>
</svg>""",
	"slash_flare": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='188' cy='86' r='42' fill='{PRIMARY}' opacity='0.18'/>
<path d='M126 116L188 54L250 116L188 92Z' fill='{ACCENT}' opacity='0.90'/>
<circle cx='188' cy='86' r='18' fill='{SECONDARY}' opacity='0.92'/>
</svg>""",
	"step_ring": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='104' fill='none' stroke='{PRIMARY}' stroke-width='26' opacity='0.14'/>
<circle cx='128' cy='128' r='96' fill='none' stroke='{SECONDARY}' stroke-width='12' opacity='0.92'/>
<circle cx='128' cy='128' r='66' fill='none' stroke='{ACCENT}' stroke-width='6' opacity='0.38'/>
<circle cx='128' cy='128' r='34' fill='{SECONDARY}' opacity='0.10'/>
<polygon points='128,28 138,48 128,60 118,48' fill='{ACCENT}' opacity='0.76'/>
<polygon points='208,48 214,70 198,76 188,60' fill='{ACCENT}' opacity='0.76'/>
<polygon points='228,128 208,138 196,128 208,118' fill='{ACCENT}' opacity='0.76'/>
<polygon points='208,208 188,196 198,180 214,186' fill='{ACCENT}' opacity='0.76'/>
<polygon points='128,228 118,208 128,196 138,208' fill='{ACCENT}' opacity='0.76'/>
<polygon points='48,208 42,186 58,180 68,196' fill='{ACCENT}' opacity='0.76'/>
<polygon points='28,128 48,118 60,128 48,138' fill='{ACCENT}' opacity='0.76'/>
<polygon points='48,48 68,60 58,76 42,70' fill='{ACCENT}' opacity='0.76'/>
</svg>""",
	"step_glyph": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='72' fill='{PRIMARY}' opacity='0.10'/>
<circle cx='128' cy='128' r='48' fill='none' stroke='{SECONDARY}' stroke-width='10' opacity='0.84'/>
<path d='M128 54L154 100L128 90L102 100Z' fill='{ACCENT}' opacity='0.84'/>
<path d='M202 128L156 154L166 128L156 102Z' fill='{ACCENT}' opacity='0.84'/>
<path d='M128 202L102 156L128 166L154 156Z' fill='{ACCENT}' opacity='0.84'/>
<path d='M54 128L100 102L90 128L100 154Z' fill='{ACCENT}' opacity='0.84'/>
</svg>""",
	"projectile_orb": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='102' fill='{PRIMARY}' opacity='0.12'/>
<circle cx='128' cy='128' r='64' fill='{PRIMARY}' opacity='0.94'/>
<circle cx='128' cy='128' r='30' fill='{ACCENT}' opacity='0.80'/>
<path d='M128 44L144 82L128 74L112 82Z' fill='{SECONDARY}' opacity='0.90'/>
<path d='M212 128L174 144L182 128L174 112Z' fill='{SECONDARY}' opacity='0.90'/>
<path d='M128 212L112 174L128 182L144 174Z' fill='{SECONDARY}' opacity='0.90'/>
<path d='M44 128L82 112L74 128L82 144Z' fill='{SECONDARY}' opacity='0.90'/>
</svg>""",
	"projectile_orb_ring": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='104' fill='none' stroke='{SECONDARY}' stroke-width='12' opacity='0.88'/>
<circle cx='128' cy='128' r='78' fill='none' stroke='{ACCENT}' stroke-width='6' opacity='0.52'/>
<circle cx='128' cy='24' r='10' fill='{ACCENT}' opacity='0.94'/>
<circle cx='232' cy='128' r='10' fill='{ACCENT}' opacity='0.94'/>
<circle cx='128' cy='232' r='10' fill='{ACCENT}' opacity='0.94'/>
<circle cx='24' cy='128' r='10' fill='{ACCENT}' opacity='0.94'/>
</svg>""",
	"projectile_blade_wave": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<path d='M18 128C72 98 124 74 182 42L236 34L194 92L236 154L180 146C126 118 72 98 18 128Z' fill='{PRIMARY}' opacity='0.82'/>
<path d='M40 128C94 104 142 86 204 56' fill='none' stroke='{SECONDARY}' stroke-width='16' stroke-linecap='round' opacity='0.92'/>
<path d='M78 128C126 112 164 100 200 82' fill='none' stroke='{ACCENT}' stroke-width='7' stroke-linecap='round' opacity='0.86'/>
<polygon points='194,60 250,28 220,96' fill='{ACCENT}' opacity='0.88'/>
</svg>""",
	"projectile_blade_wave_glow": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<path d='M10 128C74 88 122 70 204 30' fill='none' stroke='{SECONDARY}' stroke-width='26' stroke-linecap='round' opacity='0.28'/>
<path d='M24 128C84 96 134 78 212 42' fill='none' stroke='{ACCENT}' stroke-width='10' stroke-linecap='round' opacity='0.72'/>
</svg>""",
	"projectile_flame_fan": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<path d='M128 236C116 212 103 194 90 180C68 156 50 144 34 136C44 114 56 94 72 78C88 62 106 48 128 36C150 48 168 62 184 78C200 94 212 114 222 136C206 144 188 156 166 180C153 194 140 212 128 236Z' fill='{PRIMARY}' opacity='0.86'/>
<path d='M128 224C118 198 107 180 96 166C80 146 64 134 50 126C60 108 72 92 88 78C100 68 114 58 128 50C142 58 156 68 168 78C184 92 196 108 206 126C192 134 176 146 160 166C149 180 138 198 128 224Z' fill='{SECONDARY}' opacity='0.78'/>
<path d='M128 212C120 190 112 172 104 160C92 142 80 130 68 122C76 108 88 94 102 82C110 76 118 70 128 64C138 70 146 76 154 82C168 94 180 108 188 122C176 130 164 142 152 160C144 172 136 190 128 212Z' fill='{ACCENT}' opacity='0.72'/>
<path d='M78 90C82 64 96 60 102 84C108 50 122 46 128 78C134 40 150 40 154 78C162 48 176 54 178 88C190 64 206 72 202 102C216 86 228 98 216 116' fill='none' stroke='{PRIMARY}' stroke-width='14' stroke-linecap='round' stroke-linejoin='round' opacity='0.98'/>
<path d='M58 122C62 96 76 94 82 118C88 82 100 82 106 108C112 72 124 74 128 98C132 70 146 74 150 102C158 76 170 80 174 108C182 86 196 92 198 118' fill='none' stroke='{SECONDARY}' stroke-width='10' stroke-linecap='round' stroke-linejoin='round' opacity='0.92'/>
<path d='M128 228L128 62' stroke='{ACCENT}' stroke-width='5' stroke-linecap='round' opacity='0.92'/>
<path d='M128 228L102 92' stroke='{ACCENT}' stroke-width='4' stroke-linecap='round' opacity='0.64'/>
<path d='M128 228L154 92' stroke='{ACCENT}' stroke-width='4' stroke-linecap='round' opacity='0.64'/>
<path d='M128 228L82 116' stroke='{ACCENT}' stroke-width='3' stroke-linecap='round' opacity='0.54'/>
<path d='M128 228L174 116' stroke='{ACCENT}' stroke-width='3' stroke-linecap='round' opacity='0.54'/>
<circle cx='128' cy='228' r='10' fill='{ACCENT}' opacity='0.94'/>
</svg>""",
	"projectile_flame_fan_glow": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<path d='M128 236C110 198 92 172 72 152C54 134 36 122 22 116C34 82 56 54 88 38C100 16 116 18 128 40C140 18 156 16 168 38C200 54 222 82 234 116C220 122 202 134 184 152C164 172 146 198 128 236Z' fill='{SECONDARY}' opacity='0.18'/>
<path d='M128 224C110 180 90 150 64 126' fill='none' stroke='{SECONDARY}' stroke-width='14' stroke-linecap='round' opacity='0.42'/>
<path d='M128 224C146 180 166 150 192 126' fill='none' stroke='{SECONDARY}' stroke-width='14' stroke-linecap='round' opacity='0.42'/>
<path d='M128 222C128 166 128 112 128 48' fill='none' stroke='{ACCENT}' stroke-width='10' stroke-linecap='round' opacity='0.46'/>
</svg>""",
	"satellite_arcane": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='94' fill='{PRIMARY}' opacity='0.12'/>
<circle cx='128' cy='128' r='52' fill='{PRIMARY}' opacity='0.96'/>
<circle cx='128' cy='128' r='24' fill='{ACCENT}' opacity='0.84'/>
<circle cx='128' cy='44' r='14' fill='{SECONDARY}' opacity='0.90'/>
<circle cx='198' cy='168' r='12' fill='{SECONDARY}' opacity='0.90'/>
<circle cx='58' cy='168' r='12' fill='{SECONDARY}' opacity='0.90'/>
</svg>""",
	"satellite_arcane_ring": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='104' fill='none' stroke='{SECONDARY}' stroke-width='10' opacity='0.90'/>
<circle cx='128' cy='128' r='74' fill='none' stroke='{ACCENT}' stroke-width='6' opacity='0.44'/>
<polygon points='128,24 140,48 128,60 116,48' fill='{ACCENT}' opacity='0.84'/>
<polygon points='226,128 202,140 190,128 202,116' fill='{ACCENT}' opacity='0.84'/>
<polygon points='128,232 116,208 128,196 140,208' fill='{ACCENT}' opacity='0.84'/>
<polygon points='30,128 54,116 66,128 54,140' fill='{ACCENT}' opacity='0.84'/>
</svg>""",
	"satellite_blade": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='98' fill='{PRIMARY}' opacity='0.12'/>
<path d='M128 26L156 92L146 156L128 220L110 156L100 92Z' fill='{PRIMARY}' opacity='0.96'/>
<path d='M128 42L144 92L128 160L112 92Z' fill='{ACCENT}' opacity='0.78'/>
<rect x='82' y='136' width='92' height='18' rx='8' fill='{SECONDARY}' opacity='0.96'/>
<rect x='118' y='146' width='20' height='68' rx='8' fill='#593a28' opacity='0.92'/>
<circle cx='128' cy='220' r='12' fill='{SECONDARY}' opacity='0.84'/>
</svg>""",
	"satellite_blade_glow": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='110' fill='{SECONDARY}' opacity='0.12'/>
<circle cx='128' cy='128' r='92' fill='none' stroke='{ACCENT}' stroke-width='8' opacity='0.46'/>
<path d='M128 20L164 88' stroke='{ACCENT}' stroke-width='10' stroke-linecap='round' opacity='0.44'/>
</svg>""",
	"meteor_warning_ring": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='108' fill='{SECONDARY}' opacity='0.12'/>
<circle cx='128' cy='128' r='96' fill='none' stroke='{PRIMARY}' stroke-width='10' opacity='0.90'/>
<circle cx='128' cy='128' r='64' fill='none' stroke='{ACCENT}' stroke-width='6' opacity='0.46'/>
<polygon points='128,18 140,44 128,58 116,44' fill='{ACCENT}' opacity='0.84'/>
<polygon points='238,128 212,140 198,128 212,116' fill='{ACCENT}' opacity='0.84'/>
<polygon points='128,238 116,212 128,198 140,212' fill='{ACCENT}' opacity='0.84'/>
<polygon points='18,128 44,116 58,128 44,140' fill='{ACCENT}' opacity='0.84'/>
</svg>""",
	"meteor_warning_core": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='72' fill='{PRIMARY}' opacity='0.10'/>
<path d='M128 54L146 96L128 86L110 96Z' fill='{ACCENT}' opacity='0.72'/>
<path d='M202 128L160 146L170 128L160 110Z' fill='{ACCENT}' opacity='0.72'/>
<path d='M128 202L110 160L128 170L146 160Z' fill='{ACCENT}' opacity='0.72'/>
<path d='M54 128L96 110L86 128L96 146Z' fill='{ACCENT}' opacity='0.72'/>
</svg>""",
	"meteor_body": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<path d='M56 214L112 132L196 56L168 138Z' fill='{PRIMARY}' opacity='0.34'/>
<path d='M92 196L138 126L208 64L180 140Z' fill='{ACCENT}' opacity='0.44'/>
<circle cx='178' cy='78' r='34' fill='{ACCENT}' opacity='0.88'/>
<circle cx='178' cy='78' r='24' fill='{SECONDARY}' opacity='0.94'/>
<circle cx='178' cy='78' r='10' fill='{ACCENT}' opacity='0.96'/>
</svg>""",
	"poison_puff": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='112' cy='118' r='68' fill='{PRIMARY}' opacity='0.42'/>
<circle cx='154' cy='110' r='54' fill='{PRIMARY}' opacity='0.36'/>
<circle cx='138' cy='154' r='62' fill='{PRIMARY}' opacity='0.34'/>
<circle cx='96' cy='162' r='48' fill='{SECONDARY}' opacity='0.46'/>
<circle cx='166' cy='150' r='32' fill='{SECONDARY}' opacity='0.52'/>
<circle cx='118' cy='104' r='18' fill='{ACCENT}' opacity='0.20'/>
</svg>""",
	"poison_core": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='82' fill='{PRIMARY}' opacity='0.18'/>
<circle cx='128' cy='128' r='46' fill='{SECONDARY}' opacity='0.42'/>
<circle cx='128' cy='128' r='20' fill='{ACCENT}' opacity='0.22'/>
</svg>""",
	"poison_ring": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'>
<circle cx='128' cy='128' r='104' fill='none' stroke='{PRIMARY}' stroke-width='12' opacity='0.46'/>
<circle cx='128' cy='128' r='78' fill='none' stroke='{SECONDARY}' stroke-width='6' opacity='0.34'/>
<polygon points='128,34 140,56 128,72 116,56' fill='{ACCENT}' opacity='0.44'/>
<polygon points='222,128 200,140 184,128 200,116' fill='{ACCENT}' opacity='0.44'/>
<polygon points='128,222 116,200 128,184 140,200' fill='{ACCENT}' opacity='0.44'/>
<polygon points='34,128 56,116 72,128 56,140' fill='{ACCENT}' opacity='0.44'/>
</svg>""",
}

static var _texture_cache: Dictionary = {}


static func get_texture(
	effect_id: String,
	primary_color: Color,
	secondary_color: Color,
	accent_color: Color = Color(1.0, 1.0, 1.0)
) -> Texture2D:
	var template := String(EFFECT_TEMPLATES.get(effect_id, ""))
	if template.is_empty():
		push_warning("Missing SVG effect template %s" % effect_id)
		return null

	var primary_hex := _color_to_hex(primary_color)
	var secondary_hex := _color_to_hex(secondary_color)
	var accent_hex := _color_to_hex(accent_color)
	var cache_key := "%s|%s|%s|%s" % [effect_id, primary_hex, secondary_hex, accent_hex]
	if _texture_cache.has(cache_key):
		return _texture_cache[cache_key]

	var svg_source := template
	svg_source = svg_source.replace("{PRIMARY}", primary_hex)
	svg_source = svg_source.replace("{SECONDARY}", secondary_hex)
	svg_source = svg_source.replace("{ACCENT}", accent_hex)

	var image := Image.new()
	var error := image.load_svg_from_string(svg_source, RASTER_SCALE)
	if error != OK:
		push_warning("Failed to rasterize SVG effect %s: %s" % [effect_id, error_string(error)])
		return null

	var texture := ImageTexture.create_from_image(image)
	_texture_cache[cache_key] = texture
	return texture


static func create_sprite(name: String, texture: Texture2D, z_index_value: int = 0) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = name
	sprite.centered = true
	sprite.texture = texture
	sprite.z_index = z_index_value
	return sprite


static func set_sprite_diameter(sprite: Sprite2D, diameter: float) -> void:
	set_sprite_size(sprite, Vector2.ONE * maxf(diameter, 0.001))


static func set_sprite_size(sprite: Sprite2D, target_size: Vector2) -> void:
	if sprite == null or sprite.texture == null:
		return
	var texture_size := sprite.texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return
	var safe_size := Vector2(maxf(absf(target_size.x), 0.001), maxf(absf(target_size.y), 0.001))
	sprite.scale = Vector2(safe_size.x / texture_size.x, safe_size.y / texture_size.y)


static func _color_to_hex(color: Color) -> String:
	return "#%s%s%s" % [
		_channel_to_hex(color.r),
		_channel_to_hex(color.g),
		_channel_to_hex(color.b),
	]


static func _channel_to_hex(value: float) -> String:
	return "%02x" % int(round(clampf(value, 0.0, 1.0) * 255.0))
