extends RefCounted
class_name SvgModelLibrary

const RASTER_SCALE := 2.0

const CHARACTER_MODELS := {
	"caster": {
		"id": "caster",
		"game_height": 98.0,
		"game_offset": Vector2(0.0, -12.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='78' cy='78' r='46' fill='#5ecff3' opacity='0.12'/>
<circle cx='78' cy='78' r='34' fill='none' stroke='#b8f6ff' stroke-width='4' opacity='0.34'/>
<path d='M78 14L96 26L102 48L116 64L122 126Q78 154 34 126L40 64L54 48L60 26Z' fill='#246ea9' stroke='#0b2338' stroke-width='6' stroke-linejoin='round'/>
<path d='M78 40L96 56L102 112Q78 132 54 112L60 56Z' fill='#102c49' opacity='0.96'/>
<path d='M66 20L78 6L90 20L88 36Q78 28 68 36Z' fill='#1a4978' stroke='#0b2338' stroke-width='4' stroke-linejoin='round'/>
<path d='M52 48L34 70L44 82L58 60Z' fill='#2f8bcb' opacity='0.74'/>
<path d='M104 48L122 70L112 82L98 60Z' fill='#2f8bcb' opacity='0.74'/>
<circle cx='78' cy='38' r='13' fill='#f3c4a1' stroke='#2b1621' stroke-width='4'/>
<path d='M66 30Q78 18 90 30' fill='none' stroke='#10253b' stroke-width='6' stroke-linecap='round'/>
<path d='M54 72L40 116' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<path d='M100 72L110 108' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<rect x='120' y='10' width='8' height='106' rx='4' fill='#7b4d2c' transform='rotate(6 124 63)'/>
<circle cx='128' cy='12' r='11' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>
<circle cx='128' cy='12' r='20' fill='none' stroke='#ffe377' stroke-width='4' opacity='0.34'/>
<path d='M64 92L92 92' stroke='#ffd56b' stroke-width='6' stroke-linecap='round'/>
<circle cx='72' cy='38' r='2.6' fill='#190f14'/>
<circle cx='84' cy='38' r='2.6' fill='#190f14'/>
</svg>""",
	},
	"blade": {
		"id": "blade",
		"game_height": 98.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M72 24L110 46L118 116Q84 146 46 126L42 68L56 44Z' fill='#2a3343' stroke='#101723' stroke-width='6' stroke-linejoin='round'/>
<path d='M72 44L98 56L104 108Q82 124 58 112L54 62Z' fill='#11161f'/>
<path d='M42 44L64 34L74 54L52 64L34 56Z' fill='#4b566c' stroke='#111820' stroke-width='4' stroke-linejoin='round'/>
<path d='M98 46L116 54L120 78L96 72Z' fill='#3c4558' stroke='#111820' stroke-width='4' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='14' fill='#edc1a0' stroke='#241219' stroke-width='4'/>
<path d='M60 28Q74 14 88 28' fill='none' stroke='#6f4237' stroke-width='6' stroke-linecap='round'/>
<path d='M52 70L34 112' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<path d='M100 68L112 106' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<path d='M88 36L100 66' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M98 24L118 14L150 72L128 82Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>
<path d='M102 34L118 26' stroke='#ffffff' stroke-width='4' stroke-linecap='round' opacity='0.5'/>
<path d='M60 88L92 88' stroke='#ff7a5c' stroke-width='6' stroke-linecap='round'/>
<path d='M44 120L74 132L110 122' fill='none' stroke='#ff9b70' stroke-width='6' stroke-linecap='round'/>
<circle cx='68' cy='38' r='2.6' fill='#180f14'/>
<circle cx='80' cy='38' r='2.6' fill='#180f14'/>
</svg>""",
	},
	"thunder": {
		"id": "thunder",
		"game_height": 96.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='44' fill='#66c8ff' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#d6f6ff' stroke-width='4' opacity='0.3'/>
<path d='M80 22L108 42L118 68L112 122Q80 146 48 122L42 70L54 44Z' fill='#20385c' stroke='#0d1a2c' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L100 56L102 110Q80 128 58 112L56 58Z' fill='#0f1d33'/>
<circle cx='80' cy='38' r='14' fill='#f2c4a3' stroke='#24141c' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#dfefff' stroke-width='6' stroke-linecap='round'/>
<path d='M48 48L70 34L76 58L54 72L38 60Z' fill='#5377ac' stroke='#10203a' stroke-width='4' stroke-linejoin='round'/>
<path d='M104 38L126 48L118 78L98 72Z' fill='#39517a' stroke='#10203a' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 72L44 108' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<path d='M106 64L122 96' stroke='#16243a' stroke-width='9' stroke-linecap='round'/>
<path d='M116 26L104 44L122 48L108 70L124 74L112 96' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M54 118L76 130L66 144' fill='none' stroke='#83d7ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M104 116L84 130L94 144' fill='none' stroke='#83d7ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M62 90L98 90' stroke='#8bd8ff' stroke-width='6' stroke-linecap='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
	},
	"alchemist": {
		"id": "alchemist",
		"game_height": 98.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='78' cy='84' r='44' fill='#a7dd68' opacity='0.14'/>
<circle cx='78' cy='82' r='34' fill='none' stroke='#eef8bf' stroke-width='4' opacity='0.3'/>
<path d='M78 24L104 44L112 70L108 122Q78 146 48 124L44 68L56 44Z' fill='#365028' stroke='#162514' stroke-width='6' stroke-linejoin='round'/>
<path d='M78 42L98 58L100 110Q78 128 56 112L58 58Z' fill='#172313'/>
<circle cx='76' cy='38' r='13' fill='#f2c4a3' stroke='#24141c' stroke-width='4'/>
<path d='M64 28Q76 14 88 28' fill='none' stroke='#d7f4ac' stroke-width='6' stroke-linecap='round'/>
<rect x='34' y='48' width='22' height='38' rx='8' fill='#c6eb62' stroke='#28401c' stroke-width='4'/>
<path d='M46 86L48 110' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M56 64Q78 58 102 74' fill='none' stroke='#8bc84b' stroke-width='5' stroke-linecap='round'/>
<path d='M52 72L44 108' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<path d='M102 70L114 102' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<path d='M108 34L126 46L120 74L98 68L100 40Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round'/>
<path d='M118 44L136 44L130 66L112 66Z' fill='none' stroke='#f5ffd2' stroke-width='4' stroke-linejoin='round'/>
<circle cx='62' cy='112' r='6' fill='#d1f06d' stroke='#28401c' stroke-width='3'/>
<circle cx='74' cy='118' r='5' fill='#d1f06d' stroke='#28401c' stroke-width='3'/>
<path d='M60 90L94 90' stroke='#dced84' stroke-width='6' stroke-linecap='round'/>
<circle cx='70' cy='38' r='2.6' fill='#140f14'/>
<circle cx='82' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
	},
	"ranger": {
		"id": "ranger",
		"game_height": 98.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='44' fill='#f0d778' opacity='0.12'/>
<path d='M80 24L104 44L110 70L106 122Q80 146 48 124L46 66L58 42Z' fill='#42513a' stroke='#162016' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 58L100 110Q80 128 58 114L60 58Z' fill='#1b2419'/>
<circle cx='80' cy='38' r='13' fill='#efc3a1' stroke='#24141b' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#f7ebb0' stroke-width='6' stroke-linecap='round'/>
<path d='M50 48L70 34L74 58L54 72L40 62Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M52 72L40 108' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<path d='M102 70L112 106' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<path d='M116 18Q144 42 138 88' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M108 28Q128 46 124 82' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M66 90L98 90' stroke='#f2d265' stroke-width='6' stroke-linecap='round'/>
<path d='M68 118L54 140L76 132' fill='none' stroke='#d9c45f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M92 118L106 140L84 132' fill='none' stroke='#d9c45f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M44 48L34 32L52 38' fill='none' stroke='#f6e48f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
	},
	"warden": {
		"id": "warden",
		"game_height": 102.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='46' fill='#74edd0' opacity='0.12'/>
<circle cx='80' cy='82' r='36' fill='none' stroke='#d7fff4' stroke-width='4' opacity='0.3'/>
<path d='M80 24L102 42L112 70L112 122Q80 148 48 122L48 70L58 42Z' fill='#244f4b' stroke='#102624' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 56L100 110Q80 128 60 112L60 58Z' fill='#102725'/>
<rect x='28' y='44' width='34' height='52' rx='12' fill='#b8fff2' stroke='#28524d' stroke-width='4'/>
<path d='M40 56L50 84' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='44' cy='70' r='9' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.7'/>
<circle cx='80' cy='38' r='13' fill='#f1c4a3' stroke='#24141c' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#d4fff2' stroke-width='6' stroke-linecap='round'/>
<path d='M56 72L48 108' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<path d='M104 70L116 104' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<path d='M112 20L134 30L130 60L108 56Z' fill='#8ff5de' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<circle cx='124' cy='28' r='12' fill='none' stroke='#d8fff6' stroke-width='4' opacity='0.62'/>
<path d='M64 92L98 92' stroke='#8ff5de' stroke-width='6' stroke-linecap='round'/>
<path d='M62 116L62 140' stroke='#56d9be' stroke-width='6' stroke-linecap='round'/>
<path d='M96 116L96 140' stroke='#56d9be' stroke-width='6' stroke-linecap='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
	},
	"blood_hunter": {
		"id": "blood_hunter",
		"game_height": 102.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='46' fill='#d94d58' opacity='0.14'/>
<circle cx='80' cy='82' r='36' fill='none' stroke='#ffd6d8' stroke-width='4' opacity='0.28'/>
<path d='M80 24L104 42L114 72L110 124Q80 150 46 124L46 72L56 44Z' fill='#5a1e26' stroke='#230c11' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 44L100 58L102 112Q80 130 58 114L60 58Z' fill='#2a0f14'/>
<circle cx='80' cy='38' r='13' fill='#f1c4a3' stroke='#261218' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#ffd6d8' stroke-width='6' stroke-linecap='round'/>
<path d='M54 72L44 110' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<path d='M106 70L118 104' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<path d='M102 26L122 14L148 70L126 82Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>
<path d='M106 34L122 26' stroke='#ffffff' stroke-width='4' stroke-linecap='round' opacity='0.55'/>
<path d='M44 52L68 44L74 64L48 72Z' fill='#8c3942' stroke='#2a0f14' stroke-width='4' stroke-linejoin='round'/>
<path d='M62 92L98 92' stroke='#f16f7d' stroke-width='6' stroke-linecap='round'/>
<path d='M58 118L50 138L72 132' fill='none' stroke='#b74a55' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M98 118L106 138L86 132' fill='none' stroke='#b74a55' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
	},
	"grave_caller": {
		"id": "grave_caller",
		"game_height": 104.0,
		"game_offset": Vector2(0.0, -12.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='46' fill='#8ec3ad' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#dcfff1' stroke-width='4' opacity='0.26'/>
<path d='M80 20L104 40L114 70L112 126Q80 152 44 124L46 70L56 40Z' fill='#2f3f3a' stroke='#121b18' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 56L102 110Q80 130 58 114L58 56Z' fill='#16211e'/>
<circle cx='80' cy='38' r='12' fill='#ebc3a0' stroke='#271419' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#dff9ec' stroke-width='6' stroke-linecap='round'/>
<path d='M56 74L46 112' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<path d='M104 70L116 104' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<path d='M110 24L132 30L126 62L104 56Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>
<circle cx='122' cy='30' r='12' fill='none' stroke='#dcfff1' stroke-width='4' opacity='0.68'/>
<path d='M40 120Q80 96 120 120' fill='none' stroke='#8ec3ad' stroke-width='5' stroke-linecap='round'/>
<path d='M62 94L98 94' stroke='#9ad9c2' stroke-width='6' stroke-linecap='round'/>
<path d='M56 118L48 140L70 134' fill='none' stroke='#5b7d72' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M100 118L108 140L88 134' fill='none' stroke='#5b7d72' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
	},
	"illusionist": {
		"id": "illusionist",
		"game_height": 100.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='46' fill='#6a7cff' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#d9ddff' stroke-width='4' opacity='0.28'/>
<path d='M80 24L104 42L112 70L110 124Q80 148 46 124L48 70L58 42Z' fill='#2f3369' stroke='#141735' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 58L100 112Q80 130 58 114L60 58Z' fill='#151a3d'/>
<circle cx='80' cy='38' r='13' fill='#efc4a1' stroke='#24141b' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#e6e9ff' stroke-width='6' stroke-linecap='round'/>
<path d='M54 72L44 110' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<path d='M106 70L118 104' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<path d='M108 22L130 30L126 60L104 56Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>
<circle cx='122' cy='30' r='12' fill='none' stroke='#d9ddff' stroke-width='4' opacity='0.66'/>
<path d='M44 58Q80 44 116 58' fill='none' stroke='#9ea8ff' stroke-width='4' stroke-linecap='round' opacity='0.62'/>
<path d='M62 94L98 94' stroke='#9ea8ff' stroke-width='6' stroke-linecap='round'/>
<path d='M58 118L48 138L70 132' fill='none' stroke='#626fce' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M98 118L108 138L88 132' fill='none' stroke='#626fce' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
	},
}

const CHARACTER_SPLIT_MODELS := {
	"ranger": {
		"id": "ranger_split",
		"model_center": Vector2(80.0, 80.0),
		"parts": {
			"base": {
				"id": "ranger_split_base",
				"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='44' fill='#f0d778' opacity='0.12'/>
<path d='M80 24L104 44L110 70L106 122Q80 146 48 124L46 66L58 42Z' fill='#42513a' stroke='#162016' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 58L100 110Q80 128 58 114L60 58Z' fill='#1b2419'/>
<path d='M62 44L82 36L102 44L100 60L80 72L60 60Z' fill='#5d6f4d' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M96 30L112 24L122 42L116 92L96 98L90 48Z' fill='#6e4c2a' stroke='#2f2416' stroke-width='4' stroke-linejoin='round'/>
<path d='M106 32L116 38L112 48' fill='none' stroke='#f7e79f' stroke-width='4' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M108 48L118 54L112 66' fill='none' stroke='#f7e79f' stroke-width='4' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='80' cy='38' r='13' fill='#efc3a1' stroke='#24141b' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#f7ebb0' stroke-width='6' stroke-linecap='round'/>
<path d='M70 52L92 52' stroke='#f2d265' stroke-width='5' stroke-linecap='round'/>
<path d='M66 90L98 90' stroke='#f2d265' stroke-width='6' stroke-linecap='round'/>
<path d='M68 118L54 140L76 132' fill='none' stroke='#d9c45f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M92 118L106 140L84 132' fill='none' stroke='#d9c45f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M52 42L42 26L58 32' fill='none' stroke='#f6e48f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</svg>""",
			},
			"back_arm": {
				"id": "ranger_split_back_arm",
				"anchor": Vector2(58.0, 66.0),
				"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M78 78L64 84L52 100L60 118L78 106L88 88Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M86 84L74 98L64 116' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='62' cy='118' r='6' fill='#efc3a1' stroke='#24141b' stroke-width='3'/>
<path d='M60 116L36 108' stroke='#d9c45f' stroke-width='4' stroke-linecap='round'/>
<path d='M36 108L22 98L26 116' fill='none' stroke='#f7e79f' stroke-width='4' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M76 82L88 76L92 88L84 94Z' fill='#4d5d42' stroke='#24311e' stroke-width='3' stroke-linejoin='round'/>
</svg>""",
			},
			"front_arm_weapon": {
				"id": "ranger_split_front_arm_weapon",
				"anchor": Vector2(100.0, 66.0),
				"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M80 78L94 82L108 96L102 116L84 108L72 88Z' fill='#92a774' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M80 84L96 96L108 114' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='110' cy='116' r='6' fill='#efc3a1' stroke='#24141b' stroke-width='3'/>
<path d='M118 56Q146 82 138 124' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M110 62Q128 82 122 116' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M134 46L150 40L142 62L126 58Z' fill='#d8c86a' stroke='#6e4c2a' stroke-width='3' stroke-linejoin='round'/>
<path d='M134 132L150 140L130 146L126 130Z' fill='#d8c86a' stroke='#6e4c2a' stroke-width='3' stroke-linejoin='round'/>
<path d='M108 116L128 118' stroke='#f2d265' stroke-width='4' stroke-linecap='round'/>
</svg>""",
			},
		},
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
		"game_height": 80.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M60 48L96 36L114 54L110 118Q82 138 50 118L44 72Z' fill='#2c5d90' stroke='#10263e' stroke-width='6' stroke-linejoin='round'/>
<path d='M66 60L94 52L98 106Q82 118 60 108L56 74Z' fill='#173553'/>
<circle cx='74' cy='42' r='13' fill='#cfdae7' stroke='#10263e' stroke-width='5'/>
<path d='M64 20L74 8L84 18L84 34L66 36Z' fill='#d5ebff' stroke='#10263e' stroke-width='5' stroke-linejoin='round'/>
<path d='M52 66L36 110' stroke='#183049' stroke-width='8' stroke-linecap='round'/>
<path d='M94 66L106 108' stroke='#183049' stroke-width='8' stroke-linecap='round'/>
<path d='M94 34L126 24L150 82L126 90Z' fill='#dff2ff' stroke='#365d82' stroke-width='4' stroke-linejoin='round'/>
<path d='M126 16L152 26L126 38Z' fill='#f5f7fb' stroke='#365d82' stroke-width='4' stroke-linejoin='round'/>
<path d='M42 58L58 48L60 74L42 84L30 70Z' fill='#81b9e8' stroke='#173553' stroke-width='4' stroke-linejoin='round'/>
<path d='M46 120L82 132L108 122' fill='none' stroke='#85c5ff' stroke-width='5' stroke-linecap='round'/>
<circle cx='70' cy='42' r='2.4' fill='#0e141c'/>
<circle cx='80' cy='42' r='2.4' fill='#0e141c'/>
</svg>""",
	},
	"brute": {
		"id": "brute",
		"game_height": 88.0,
		"game_offset": Vector2(0.0, -4.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M42 62Q46 34 76 34Q104 34 116 56L124 118Q102 142 78 142Q52 140 38 118Z' fill='#6d3428' stroke='#2a120f' stroke-width='6' stroke-linejoin='round'/>
<path d='M48 56L84 48L100 64L96 114L54 114L42 86Z' fill='#3f1c16'/>
<circle cx='78' cy='36' r='16' fill='#f1bf9f' stroke='#2a120f' stroke-width='5'/>
<path d='M60 22L68 10L78 24L88 10L96 22' fill='none' stroke='#b05834' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M36 62L18 120' stroke='#4b2319' stroke-width='14' stroke-linecap='round'/>
<path d='M116 70L128 108' stroke='#4b2319' stroke-width='9' stroke-linecap='round'/>
<path d='M20 122L48 132' stroke='#c8733a' stroke-width='12' stroke-linecap='round'/>
<path d='M128 60L148 44' stroke='#3b2a22' stroke-width='8' stroke-linecap='round'/>
<rect x='126' y='18' width='28' height='26' rx='6' fill='#dda45a' stroke='#4b2319' stroke-width='4' transform='rotate(18 140 31)'/>
<rect x='132' y='34' width='12' height='52' rx='4' fill='#c98742' transform='rotate(18 138 60)'/>
<path d='M52 42L36 58L46 84L66 76' fill='#8a4830' stroke='#2a120f' stroke-width='4' stroke-linejoin='round'/>
<circle cx='72' cy='36' r='3' fill='#140d0f'/>
<circle cx='84' cy='36' r='3' fill='#140d0f'/>
</svg>""",
	},
	"embermage": {
		"id": "embermage",
		"game_height": 82.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M80 24L108 48L114 68L120 118Q80 148 40 120L46 68L54 50Z' fill='#7b2d1f' stroke='#2a120f' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 58L102 104Q80 126 56 112L58 58Z' fill='#34150f'/>
<path d='M56 112L70 126L86 118L100 130' fill='none' stroke='#a44726' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='80' cy='40' r='14' fill='#f2c39b' stroke='#2a120f' stroke-width='4'/>
<path d='M68 22L74 8L82 20L88 6L94 22' fill='none' stroke='#ffb254' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M54 66L42 108' stroke='#411b14' stroke-width='8' stroke-linecap='round'/>
<path d='M104 64L114 100' stroke='#411b14' stroke-width='8' stroke-linecap='round'/>
<path d='M112 34L126 30L138 44L134 68L116 72L106 56Z' fill='#ff9a2f' stroke='#5a2516' stroke-width='5' stroke-linejoin='round'/>
<path d='M118 66Q126 40 136 58Q136 82 120 92' fill='none' stroke='#ffe07b' stroke-width='5' stroke-linecap='round'/>
<path d='M64 88L98 88' stroke='#ffcf63' stroke-width='6' stroke-linecap='round'/>
<path d='M70 46L84 54L76 68' fill='none' stroke='#ffdc8a' stroke-width='4' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='75' cy='40' r='2.6' fill='#130d0f'/>
<circle cx='85' cy='40' r='2.6' fill='#130d0f'/>
</svg>""",
	},
	"seer": {
		"id": "seer",
		"game_height": 86.0,
		"game_offset": Vector2(0.0, -12.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='82' r='44' fill='#927cff' opacity='0.16'/>
<path d='M80 14L98 30L104 54L110 120Q80 150 50 120L56 54L62 30Z' fill='#4f2a67' stroke='#1e1128' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 30L94 48L98 108Q80 126 62 110L66 48Z' fill='#261433'/>
<path d='M70 22Q80 10 90 22L88 40Q80 34 72 40Z' fill='#6c3d8f'/>
<circle cx='80' cy='38' r='11' fill='#e4d9ff' stroke='#1e1128' stroke-width='4'/>
<circle cx='80' cy='38' r='4.2' fill='#5b45c8'/>
<path d='M64 66Q80 56 96 66' fill='none' stroke='#bb9bff' stroke-width='5' stroke-linecap='round'/>
<path d='M58 64L46 108' stroke='#281633' stroke-width='8' stroke-linecap='round'/>
<path d='M102 64L112 108' stroke='#281633' stroke-width='8' stroke-linecap='round'/>
<path d='M122 18L128 98' stroke='#6f57b8' stroke-width='6' stroke-linecap='round'/>
<circle cx='128' cy='14' r='12' fill='#cbb7ff' stroke='#2a1740' stroke-width='4'/>
<circle cx='128' cy='14' r='4.5' fill='#7b62ff'/>
<path d='M60 118L72 140L84 120L96 142' fill='none' stroke='#8d76ea' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
</svg>""",
	},
	"mireling": {
		"id": "mireling",
		"game_height": 76.0,
		"game_offset": Vector2(0.0, 0.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<path d='M24 98Q24 66 46 56Q68 44 100 46Q128 48 138 68Q146 84 136 104Q124 126 94 130Q58 132 34 120Q22 114 24 98Z' fill='#2a5a34' stroke='#102316' stroke-width='6' stroke-linejoin='round'/>
<ellipse cx='82' cy='98' rx='38' ry='18' fill='#17311d'/>
<path d='M42 70L28 58L52 58' fill='none' stroke='#80c469' stroke-width='8' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M116 70L132 58L108 58' fill='none' stroke='#80c469' stroke-width='8' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='62' cy='86' r='11' fill='#9ce07d' stroke='#17311d' stroke-width='4'/>
<circle cx='102' cy='88' r='11' fill='#9ce07d' stroke='#17311d' stroke-width='4'/>
<circle cx='62' cy='86' r='3.4' fill='#0c1510'/>
<circle cx='102' cy='88' r='3.4' fill='#0c1510'/>
<path d='M62 110Q82 120 104 108' fill='none' stroke='#80c469' stroke-width='6' stroke-linecap='round'/>
<path d='M34 112L18 124' stroke='#17311d' stroke-width='10' stroke-linecap='round'/>
<path d='M126 112L142 124' stroke='#17311d' stroke-width='10' stroke-linecap='round'/>
<path d='M18 124L40 128' stroke='#9ce07d' stroke-width='8' stroke-linecap='round'/>
<path d='M142 124L120 128' stroke='#9ce07d' stroke-width='8' stroke-linecap='round'/>
</svg>""",
	},
	"storm_archon": {
		"id": "storm_archon",
		"game_height": 150.0,
		"game_offset": Vector2(0.0, -12.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='82' r='52' fill='#7fe0ff' opacity='0.12'/>
<circle cx='80' cy='82' r='44' fill='none' stroke='#d9fbff' stroke-width='5' opacity='0.34'/>
<path d='M80 14L96 38L120 46L106 68L110 106L80 96L50 106L54 68L40 46L64 38Z' fill='#2e679e' stroke='#0d243c' stroke-width='6' stroke-linejoin='round'/>
<circle cx='80' cy='72' r='23' fill='#d7f8ff' stroke='#0d243c' stroke-width='5'/>
<path d='M54 62L16 36L28 82L12 122L54 94L68 70' fill='#b7eeff' stroke='#2268a0' stroke-width='5' stroke-linejoin='round'/>
<path d='M106 62L144 36L132 82L148 122L106 94L92 70' fill='#b7eeff' stroke='#2268a0' stroke-width='5' stroke-linejoin='round'/>
<path d='M62 118L54 148L80 130L106 148L98 118' fill='#5bc7ff' stroke='#14507e' stroke-width='5' stroke-linejoin='round'/>
<path d='M68 52L80 34L92 52L84 72H76Z' fill='#1aa6ff' stroke='#0d243c' stroke-width='4' stroke-linejoin='round'/>
<circle cx='74' cy='72' r='3.2' fill='#10223a'/>
<circle cx='86' cy='72' r='3.2' fill='#10223a'/>
</svg>""",
	},
	"forge_tyrant": {
		"id": "forge_tyrant",
		"game_height": 154.0,
		"game_offset": Vector2(0.0, -6.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<rect x='22' y='90' width='116' height='34' rx='14' fill='#231816' stroke='#080606' stroke-width='6'/>
<rect x='34' y='62' width='92' height='44' rx='12' fill='#7a3625' stroke='#28110d' stroke-width='6'/>
<rect x='52' y='30' width='56' height='36' rx='10' fill='#c96d3c' stroke='#4b1f16' stroke-width='6'/>
<rect x='60' y='40' width='40' height='20' rx='6' fill='#ffd06a' stroke='#7a3625' stroke-width='4'/>
<path d='M98 48L146 24L148 44L104 64Z' fill='#c96d3c' stroke='#4b1f16' stroke-width='6' stroke-linejoin='round'/>
<path d='M14 74L34 60L44 82L22 92Z' fill='#d68a4b' stroke='#4b1f16' stroke-width='5' stroke-linejoin='round'/>
<rect x='42' y='98' width='18' height='20' rx='8' fill='#47312b'/>
<rect x='66' y='98' width='18' height='20' rx='8' fill='#47312b'/>
<rect x='90' y='98' width='18' height='20' rx='8' fill='#47312b'/>
<rect x='114' y='98' width='18' height='20' rx='8' fill='#47312b'/>
<path d='M72 44L80 54L72 66' fill='none' stroke='#ff8d2c' stroke-width='6' stroke-linecap='round'/>
<path d='M88 44L80 54L88 66' fill='none' stroke='#ff8d2c' stroke-width='6' stroke-linecap='round'/>
<path d='M74 24L80 10L86 24' fill='none' stroke='#ffd06a' stroke-width='6' stroke-linecap='round'/>
</svg>""",
	},
	"void_matriarch": {
		"id": "void_matriarch",
		"game_height": 150.0,
		"game_offset": Vector2(0.0, -10.0),
		"svg": """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='80' r='52' fill='#a48fff' opacity='0.1'/>
<path d='M80 22Q108 30 118 56Q126 82 118 110Q108 136 80 144Q52 136 42 110Q34 82 42 56Q52 30 80 22Z' fill='#35204d' stroke='#140d1f' stroke-width='6' stroke-linejoin='round'/>
<ellipse cx='80' cy='82' rx='30' ry='26' fill='#d4c8ff' stroke='#28183c' stroke-width='5'/>
<ellipse cx='80' cy='82' rx='16' ry='10' fill='#261737'/>
<circle cx='80' cy='82' r='5' fill='#8a6cff'/>
<path d='M50 54Q26 30 20 48Q20 74 48 78' fill='none' stroke='#6f58b6' stroke-width='8' stroke-linecap='round'/>
<path d='M110 54Q134 30 140 48Q140 74 112 78' fill='none' stroke='#6f58b6' stroke-width='8' stroke-linecap='round'/>
<path d='M60 118Q42 140 52 152Q68 156 76 134' fill='none' stroke='#8a6cff' stroke-width='8' stroke-linecap='round'/>
<path d='M100 118Q118 140 108 152Q92 156 84 134' fill='none' stroke='#8a6cff' stroke-width='8' stroke-linecap='round'/>
<path d='M72 22L80 8L88 22' fill='none' stroke='#c6b7ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M64 48Q80 34 96 48' fill='none' stroke='#c6b7ff' stroke-width='5' stroke-linecap='round'/>
</svg>""",
	},
}

static var _texture_cache: Dictionary = {}


static func get_character_model(character_id: String) -> Dictionary:
	return _clone_model(CHARACTER_MODELS.get(character_id, CHARACTER_MODELS["caster"]))


static func has_character_split_model(character_id: String) -> bool:
	return CHARACTER_SPLIT_MODELS.has(character_id)


static func get_character_split_model(character_id: String) -> Dictionary:
	if not CHARACTER_SPLIT_MODELS.has(character_id):
		return {}
	return _clone_model(CHARACTER_SPLIT_MODELS[character_id])


static func has_character_frame_animation(character_id: String) -> bool:
	return CHARACTER_MODELS.has(character_id)


static func get_character_animation_frame_count(character_id: String, animation_id: String) -> int:
	match character_id:
		"caster":
			match animation_id:
				"move":
					return 2
				"cast_arc":
					return 3
				"chain_cast":
					return 3
				"nova_cast":
					return 3
				"storm_cast":
					return 3
				"idle":
					return 1
		"blade":
			match animation_id:
				"move":
					return 2
				"slash":
					return 3
				"mooncut":
					return 3
				"dash_cut":
					return 3
				"idle":
					return 1
		"thunder":
			match animation_id:
				"move":
					return 2
				"orb_throw":
					return 4
				"idle":
					return 1
		"alchemist":
			match animation_id:
				"move":
					return 2
				"throw_flask":
					return 3
				"catalyst_burst":
					return 3
				"idle":
					return 1
		"ranger":
			match animation_id:
				"move":
					return 2
				"draw_shot":
					return 4
				"glaive_throw":
					return 3
				"trail_dash":
					return 3
				"idle":
					return 1
		"warden":
			match animation_id:
				"move":
					return 2
				"brace_cast":
					return 3
				"brace_pulse":
					return 3
				"idle":
					return 1
		"blood_hunter":
			match animation_id:
				"move":
					return 2
				"blood_draw":
					return 3
				"blood_dash":
					return 3
				"idle":
					return 1
		"grave_caller":
			match animation_id:
				"move":
					return 2
				"dirge_cast":
					return 3
				"grave_toll":
					return 3
				"idle":
					return 1
		"illusionist":
			match animation_id:
				"move":
					return 2
				"mirror_cast":
					return 3
				"swap_step":
					return 3
				"idle":
					return 1
	return 0


static func get_character_animation_texture(
	character_id: String,
	animation_id: String,
	frame_index: int,
	raster_scale: float = RASTER_SCALE
) -> Texture2D:
	if not has_character_frame_animation(character_id):
		return get_character_texture(character_id, raster_scale)

	var resolved_animation := animation_id
	if get_character_animation_frame_count(character_id, resolved_animation) <= 0:
		resolved_animation = "idle"

	var frame_count := get_character_animation_frame_count(character_id, resolved_animation)
	if frame_count <= 0:
		return get_character_texture(character_id, raster_scale)

	var resolved_frame := clampi(frame_index, 0, frame_count - 1)
	var svg_source := _build_character_animation_svg(character_id, resolved_animation, resolved_frame)
	if svg_source.is_empty():
		return get_character_texture(character_id, raster_scale)

	var cache_id := "%s_anim_%s_%d" % [character_id, resolved_animation, resolved_frame]
	return _rasterize_svg(svg_source, cache_id, raster_scale)


static func get_enemy_model(archetype: String) -> Dictionary:
	return _clone_model(ENEMY_MODELS.get(archetype, ENEMY_MODELS["wisp"]))


static func get_character_texture(character_id: String, raster_scale: float = RASTER_SCALE) -> Texture2D:
	return _rasterize_model(get_character_model(character_id), raster_scale)


static func get_character_part_texture(character_id: String, part_id: String, raster_scale: float = RASTER_SCALE) -> Texture2D:
	var split_model := get_character_split_model(character_id)
	if split_model.is_empty():
		return null

	var parts: Dictionary = split_model.get("parts", {})
	var part_info: Dictionary = parts.get(part_id, {})
	if part_info.is_empty():
		return null

	var cache_id := String(part_info.get("id", "%s_%s" % [character_id, part_id]))
	return _rasterize_svg(String(part_info.get("svg", "")), cache_id, raster_scale)


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
	var svg_source := String(model_info.get("svg", ""))
	return _rasterize_svg(svg_source, model_id, raster_scale)


static func _rasterize_svg(svg_source: String, cache_id: String, raster_scale: float) -> Texture2D:
	var cache_key := "%s@%.2f" % [cache_id, raster_scale]
	if _texture_cache.has(cache_key):
		return _texture_cache[cache_key]
	if svg_source.is_empty():
		push_warning("Missing SVG source for model %s" % cache_id)
		return null

	var image := Image.new()
	var error := image.load_svg_from_string(svg_source, raster_scale)
	if error != OK:
		push_warning("Failed to rasterize SVG model %s: %s" % [cache_id, error_string(error)])
		return null

	var texture := ImageTexture.create_from_image(image)
	_texture_cache[cache_key] = texture
	return texture


static func _build_character_animation_svg(character_id: String, animation_id: String, frame_index: int) -> String:
	match character_id:
		"caster":
			return _build_caster_animation_svg(animation_id, frame_index)
		"blade":
			return _build_blade_animation_svg(animation_id, frame_index)
		"thunder":
			return _build_thunder_animation_svg(animation_id, frame_index)
		"alchemist":
			return _build_alchemist_animation_svg(animation_id, frame_index)
		"ranger":
			return _build_ranger_animation_svg(animation_id, frame_index)
		"warden":
			return _build_warden_animation_svg(animation_id, frame_index)
		"blood_hunter":
			return _build_blood_hunter_animation_svg(animation_id, frame_index)
		"grave_caller":
			return _build_grave_caller_animation_svg(animation_id, frame_index)
		"illusionist":
			return _build_illusionist_animation_svg(animation_id, frame_index)
	return ""


static func _build_ranger_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"draw_shot":
			pose_id = "draw_%d" % clampi(frame_index, 0, 3)
		"glaive_throw":
			pose_id = "glaive_%d" % clampi(frame_index, 0, 2)
		"trail_dash":
			pose_id = "trail_%d" % clampi(frame_index, 0, 2)
	return _build_ranger_pose_svg(pose_id)


static func _build_ranger_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var back_arm_svg := ""
	var front_arm_svg := ""
	var bow_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			back_arm_svg = """<path d='M50 48L70 34L74 58L54 72L40 62Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M52 72L40 108' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='108' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M102 70L112 106' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='112' cy='106' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M116 18Q144 42 138 88' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M108 28Q128 46 124 82' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M116 20L124 82L138 88' fill='none' stroke='#f7f3e4' stroke-width='2.4' stroke-linecap='round' opacity='0.65'/>"""
		"move_0":
			body_transform = "rotate(-4 80 86)"
			back_arm_svg = """<path d='M48 50L68 38L72 60L54 74L40 66Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 72L48 102' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='48' cy='102' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M102 68L118 98' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='98' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M120 20Q144 48 134 92' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M112 30Q128 52 120 86' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M120 22L120 86L134 92' fill='none' stroke='#f7f3e4' stroke-width='2.4' stroke-linecap='round' opacity='0.6'/>"""
		"move_1":
			body_transform = "rotate(4 80 86)"
			back_arm_svg = """<path d='M52 46L70 34L74 58L58 72L44 60Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 74L38 110' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='38' cy='110' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 72L108 112' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='108' cy='112' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M112 16Q140 40 140 86' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M104 26Q126 44 126 80' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M112 18L126 80L140 86' fill='none' stroke='#f7f3e4' stroke-width='2.4' stroke-linecap='round' opacity='0.6'/>"""
		"draw_0":
			body_transform = "rotate(-6 80 84)"
			back_arm_svg = """<path d='M50 48L68 36L72 58L56 74L42 64Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M56 72Q48 68 48 56' fill='none' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='48' cy='56' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 70Q112 74 118 86' fill='none' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='86' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M122 16Q148 52 134 114' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M113 22Q128 54 118 104' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M124 18L48 56L134 114' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M50 56L118 84' stroke='#f2d265' stroke-width='4' stroke-linecap='round'/>
<path d='M114 84L126 80L118 90Z' fill='#d8c86a' stroke='#6e4c2a' stroke-width='2' stroke-linejoin='round'/>"""
		"draw_1":
			body_transform = "rotate(-10 80 84)"
			back_arm_svg = """<path d='M50 48L68 36L72 58L56 74L42 64Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M56 72Q44 66 42 50' fill='none' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='50' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 70Q116 74 120 84' fill='none' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='120' cy='84' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M126 14Q152 54 136 120' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M116 18Q132 56 120 108' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M126 16L42 50L136 120' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M44 50L120 82' stroke='#f2d265' stroke-width='4' stroke-linecap='round'/>
<path d='M116 82L130 78L122 88Z' fill='#d8c86a' stroke='#6e4c2a' stroke-width='2' stroke-linejoin='round'/>"""
		"draw_2":
			body_transform = "rotate(6 82 84)"
			back_arm_svg = """<path d='M50 48L68 36L72 58L56 74L42 64Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M56 72Q68 76 76 92' fill='none' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='76' cy='92' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 70L122 82' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='122' cy='82' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M118 18Q146 48 136 92' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M110 26Q130 48 124 84' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M118 20L124 84L136 92' fill='none' stroke='#f7f3e4' stroke-width='2.4' stroke-linecap='round' opacity='0.72'/>"""
			extra_svg = """<path d='M126 82L152 74' stroke='#f2d265' stroke-width='4' stroke-linecap='round'/>
<path d='M148 70L158 74L148 78' fill='#d8c86a' stroke='#6e4c2a' stroke-width='2' stroke-linejoin='round'/>
<path d='M118 78L132 82' stroke='#f7f3e4' stroke-width='3' stroke-linecap='round' opacity='0.7'/>"""
		"draw_3":
			body_transform = "rotate(2 80 84)"
			back_arm_svg = """<path d='M50 48L70 34L74 58L54 72L40 62Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 72L46 98' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='98' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 70L116 94' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='116' cy='94' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M116 18Q142 42 138 88' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M108 28Q128 46 124 82' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>
<path d='M116 20L124 82L138 88' fill='none' stroke='#f7f3e4' stroke-width='2.4' stroke-linecap='round' opacity='0.65'/>"""
		"glaive_0":
			body_transform = "rotate(-12 80 84)"
			back_arm_svg = """<path d='M50 48L70 34L74 58L54 72L40 62Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M52 72L42 100' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='100' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 68Q110 56 118 42' fill='none' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='42' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M114 22Q138 44 134 88' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M106 32Q124 48 122 82' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>"""
			extra_svg = """<path d='M118 22Q132 10 146 24Q134 28 126 42Q126 30 118 22Z' fill='#d9c45f' stroke='#6e4c2a' stroke-width='3' stroke-linejoin='round'/>
<path d='M126 24L138 18' stroke='#f7ebb0' stroke-width='3' stroke-linecap='round'/>"""
		"glaive_1":
			body_transform = "rotate(10 82 84)"
			back_arm_svg = """<path d='M50 48L70 34L74 58L54 72L40 62Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M52 72L38 86' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='38' cy='86' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 70Q118 68 128 56' fill='none' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='128' cy='56' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M110 24Q134 46 132 86' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M104 34Q122 50 120 80' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>"""
			extra_svg = """<path d='M136 44Q150 32 156 46Q144 52 138 64Q142 54 136 44Z' fill='#d9c45f' stroke='#6e4c2a' stroke-width='3' stroke-linejoin='round'/>
<path d='M126 50L144 46' stroke='#f7ebb0' stroke-width='3' stroke-linecap='round'/>
<path d='M120 54L136 58' stroke='#d9c45f' stroke-width='3' stroke-linecap='round' opacity='0.7'/>"""
		"glaive_2":
			body_transform = "rotate(2 80 84)"
			back_arm_svg = """<path d='M50 48L70 34L74 58L54 72L40 62Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 72L42 104' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='104' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 70L118 92' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='92' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M112 20Q138 42 136 86' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M104 30Q124 46 122 80' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>"""
			extra_svg = """<path d='M132 46L148 40' stroke='#d9c45f' stroke-width='4' stroke-linecap='round' opacity='0.65'/>"""
		"trail_0":
			body_transform = "translate(0 8) rotate(-10 80 92)"
			back_arm_svg = """<path d='M50 50L70 36L74 60L56 74L42 64Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 74L38 94' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='38' cy='94' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 72L92 100' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='92' cy='100' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M98 20Q128 42 120 88' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M92 30Q112 48 110 82' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>"""
			extra_svg = """<path d='M24 88L50 84' stroke='#d9c45f' stroke-width='4' stroke-linecap='round' opacity='0.65'/>
<path d='M18 98L42 96' stroke='#f7ebb0' stroke-width='3' stroke-linecap='round' opacity='0.55'/>"""
		"trail_1":
			body_transform = "translate(-10 10) rotate(-20 78 96)"
			back_arm_svg = """<path d='M50 50L70 36L74 60L56 74L42 64Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 74L32 86' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='32' cy='86' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 72L80 96' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='80' cy='96' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M92 18Q118 36 112 82' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M86 28Q104 42 102 76' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>"""
			extra_svg = """<path d='M12 84L46 80' stroke='#d9c45f' stroke-width='5' stroke-linecap='round' opacity='0.7'/>
<path d='M8 96L38 94' stroke='#f7ebb0' stroke-width='3' stroke-linecap='round' opacity='0.6'/>
<path d='M4 106L30 108' stroke='#d9c45f' stroke-width='3' stroke-linecap='round' opacity='0.45'/>"""
		"trail_2":
			body_transform = "translate(2 4) rotate(8 82 88)"
			back_arm_svg = """<path d='M50 48L70 34L74 58L54 72L40 62Z' fill='#7f9368' stroke='#24311e' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 72L44 108' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='108' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M100 70L118 98' stroke='#182116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='98' r='4.2' fill='#efc3a1' stroke='#24141b' stroke-width='2.4'/>"""
			bow_svg = """<path d='M116 20Q140 44 136 88' fill='none' stroke='#6e4c2a' stroke-width='8' stroke-linecap='round'/>
<path d='M108 30Q126 48 122 82' fill='none' stroke='#f7f3e4' stroke-width='4' stroke-linecap='round'/>"""
			extra_svg = """<path d='M30 94L52 92' stroke='#d9c45f' stroke-width='3' stroke-linecap='round' opacity='0.4'/>"""
		_:
			return _build_ranger_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<path d='M80 24L104 44L110 70L106 122Q80 146 48 124L46 66L58 42Z' fill='#42513a' stroke='#162016' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 58L100 110Q80 128 58 114L60 58Z' fill='#1b2419'/>
<path d='M92 34L108 24L122 44L116 92L96 100L88 50Z' fill='#6e4c2a' stroke='#2f2416' stroke-width='4' stroke-linejoin='round'/>
<path d='M104 34L116 40L112 52' fill='none' stroke='#f6e48f' stroke-width='4' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M106 50L118 58L112 70' fill='none' stroke='#f6e48f' stroke-width='4' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='80' cy='38' r='13' fill='#efc3a1' stroke='#24141b' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#f7ebb0' stroke-width='6' stroke-linecap='round'/>
<path d='M66 90L98 90' stroke='#f2d265' stroke-width='6' stroke-linecap='round'/>
<path d='M68 118L54 140L76 132' fill='none' stroke='#d9c45f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M92 118L106 140L84 132' fill='none' stroke='#d9c45f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M44 48L34 32L52 38' fill='none' stroke='#f6e48f' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<circle cx='80' cy='84' r='44' fill='#f0d778' opacity='0.12'/>
%s
%s
%s
%s
%s
</svg>""" % [back_arm_svg, body_svg, front_arm_svg, bow_svg, extra_svg]


static func _build_caster_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"cast_arc", "chain_cast":
			match clampi(frame_index, 0, 2):
				0:
					pose_id = "cast_windup"
				1:
					pose_id = "cast_release"
				_:
					pose_id = "cast_recover"
		"nova_cast":
			match clampi(frame_index, 0, 2):
				0:
					pose_id = "nova_compress"
				1:
					pose_id = "nova_burst"
				_:
					pose_id = "nova_falloff"
		"storm_cast":
			match clampi(frame_index, 0, 2):
				0:
					pose_id = "storm_raise"
				1:
					pose_id = "storm_channel"
				_:
					pose_id = "storm_release"
	return _build_caster_pose_svg(pose_id)


static func _build_caster_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var back_fx_svg := ""
	var left_arm_svg := ""
	var right_arm_staff_svg := ""
	var front_fx_svg := ""

	match pose_id:
		"idle":
			back_fx_svg = """<ellipse cx='78' cy='84' rx='24' ry='12' fill='#5ecff3' opacity='0.10'/>"""
			left_arm_svg = """<path d='M54 70L40 118' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='118' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 68L112 106' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='112' cy='106' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='122' y='2' width='9' height='118' rx='4' fill='#7b4d2c' transform='rotate(2 126 61)'/>
<circle cx='128' cy='4' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>
<circle cx='128' cy='4' r='22' fill='none' stroke='#ffe377' stroke-width='4' opacity='0.24'/>"""
			front_fx_svg = """<circle cx='90' cy='66' r='6' fill='#b8f6ff' opacity='0.18'/>"""
		"move_0":
			body_transform = "translate(-1 0) rotate(-5 78 84)"
			left_arm_svg = """<path d='M52 70L36 112' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='36' cy='112' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M100 66L118 100' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='100' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='126' y='10' width='9' height='112' rx='4' fill='#7b4d2c' transform='rotate(14 130 66)'/>
<circle cx='140' cy='12' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M86 70L102 76' stroke='#b8f6ff' stroke-width='3' stroke-linecap='round' opacity='0.26'/>"""
		"move_1":
			body_transform = "translate(1 0) rotate(4 78 84)"
			left_arm_svg = """<path d='M56 72L46 118' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='118' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M96 68L108 106' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='108' cy='106' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='116' y='-2' width='9' height='118' rx='4' fill='#7b4d2c' transform='rotate(-8 120 57)'/>
<circle cx='118' cy='0' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M82 72L96 78' stroke='#b8f6ff' stroke-width='3' stroke-linecap='round' opacity='0.28'/>"""
		"cast_windup":
			body_transform = "translate(-2 0) rotate(-9 78 82)"
			left_arm_svg = """<path d='M58 72Q52 58 60 48' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='60' cy='48' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 70Q112 54 124 36' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='124' cy='36' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='118' y='-14' width='9' height='124' rx='4' fill='#7b4d2c' transform='rotate(28 122 48)'/>
<circle cx='146' cy='-8' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>
<circle cx='146' cy='-8' r='20' fill='none' stroke='#b8f6ff' stroke-width='4' opacity='0.22'/>"""
			front_fx_svg = """<path d='M64 52Q74 46 84 52' fill='none' stroke='#d8fbff' stroke-width='3' stroke-linecap='round'/>
<circle cx='70' cy='54' r='9' fill='#5ecff3' opacity='0.28'/>
<circle cx='70' cy='54' r='4' fill='#d8fbff' opacity='0.6'/>"""
		"cast_release":
			body_transform = "translate(2 0) rotate(7 82 84)"
			left_arm_svg = """<path d='M58 72Q74 68 92 60' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='92' cy='60' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 70Q118 74 136 74' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='136' cy='74' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='114' y='20' width='9' height='110' rx='4' fill='#7b4d2c' transform='rotate(62 118 75)'/>
<circle cx='154' cy='52' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M100 60Q124 46 154 56' fill='none' stroke='#d8fbff' stroke-width='6' stroke-linecap='round'/>
<circle cx='138' cy='54' r='8' fill='#b8f6ff' opacity='0.42'/>
<circle cx='150' cy='56' r='6' fill='#b8f6ff' opacity='0.28'/>
<circle cx='160' cy='60' r='5' fill='#b8f6ff' opacity='0.18'/>"""
		"cast_recover":
			body_transform = "translate(0 0) rotate(2 80 84)"
			left_arm_svg = """<path d='M56 72Q64 86 74 96' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='74' cy='96' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 70Q112 76 126 74' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='126' cy='74' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='118' y='6' width='9' height='116' rx='4' fill='#7b4d2c' transform='rotate(16 122 64)'/>
<circle cx='136' cy='10' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M126 70L146 64' stroke='#d8fbff' stroke-width='4' stroke-linecap='round' opacity='0.35'/>"""
		"nova_compress":
			body_transform = "translate(0 0) scale(0.96 0.94)"
			back_fx_svg = """<circle cx='80' cy='84' r='18' fill='none' stroke='#b8f6ff' stroke-width='4' opacity='0.22'/>"""
			left_arm_svg = """<path d='M60 72Q66 80 74 82' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='74' cy='82' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M96 72Q90 80 84 82' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='84' cy='82' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='100' y='10' width='9' height='108' rx='4' fill='#7b4d2c' transform='rotate(18 104 64)'/>
<circle cx='118' cy='18' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<circle cx='80' cy='82' r='12' fill='#5ecff3' opacity='0.30'/>
<circle cx='80' cy='82' r='5' fill='#d8fbff' opacity='0.72'/>"""
		"nova_burst":
			body_transform = "translate(0 -2) rotate(0 80 84)"
			back_fx_svg = """<circle cx='80' cy='84' r='34' fill='none' stroke='#d8fbff' stroke-width='5' opacity='0.52'/>
<circle cx='80' cy='84' r='22' fill='none' stroke='#b8f6ff' stroke-width='4' opacity='0.34'/>"""
			left_arm_svg = """<path d='M58 72Q38 82 18 84' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='18' cy='84' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 72Q118 82 142 84' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='142' cy='84' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='114' y='4' width='9' height='116' rx='4' fill='#7b4d2c' transform='rotate(78 118 62)'/>
<circle cx='162' cy='44' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M34 84L126 84' stroke='#ffffff' stroke-width='5' stroke-linecap='round' opacity='0.54'/>
<circle cx='80' cy='84' r='14' fill='#5ecff3' opacity='0.18'/>"""
		"nova_falloff":
			body_transform = "translate(0 0) rotate(2 80 84)"
			back_fx_svg = """<circle cx='80' cy='84' r='38' fill='none' stroke='#d8fbff' stroke-width='4' opacity='0.22'/>"""
			left_arm_svg = """<path d='M58 72Q48 90 40 102' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='102' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 72Q114 90 128 102' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='128' cy='102' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='116' y='10' width='9' height='112' rx='4' fill='#7b4d2c' transform='rotate(24 120 66)'/>
<circle cx='138' cy='14' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M44 90L116 90' stroke='#b8f6ff' stroke-width='4' stroke-linecap='round' opacity='0.32'/>"""
		"storm_raise":
			body_transform = "translate(0 -2) rotate(-6 80 82)"
			back_fx_svg = """<ellipse cx='96' cy='18' rx='18' ry='10' fill='none' stroke='#b8f6ff' stroke-width='4' opacity='0.30'/>"""
			left_arm_svg = """<path d='M58 72Q44 48 42 28' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='28' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 70Q108 44 110 18' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='110' cy='18' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='110' y='-22' width='9' height='132' rx='4' fill='#7b4d2c' transform='rotate(10 114 44)'/>
<circle cx='126' cy='-20' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M124 -8L114 12L130 16L118 34' fill='none' stroke='#eefaff' stroke-width='5' stroke-linecap='round' stroke-linejoin='round'/>"""
		"storm_channel":
			body_transform = "translate(0 -4)"
			back_fx_svg = """<circle cx='88' cy='24' r='26' fill='none' stroke='#d8fbff' stroke-width='5' opacity='0.34'/>
<path d='M108 -6L98 18L112 24L100 48L116 54L104 76' fill='none' stroke='#eefaff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>"""
			left_arm_svg = """<path d='M58 72Q44 54 36 34' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='36' cy='34' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 70Q108 40 108 8' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='108' cy='8' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='110' y='-34' width='9' height='144' rx='4' fill='#7b4d2c'/>
<circle cx='114' cy='-34' r='13' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>
<circle cx='114' cy='-34' r='24' fill='none' stroke='#b8f6ff' stroke-width='4' opacity='0.32'/>"""
			front_fx_svg = """<path d='M108 -16L118 -2L110 12L122 24' fill='none' stroke='#eefaff' stroke-width='5' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='114' cy='-34' r='8' fill='#d8fbff' opacity='0.4'/>"""
		"storm_release":
			body_transform = "translate(2 0) rotate(10 82 84)"
			back_fx_svg = """<path d='M114 8L104 32L118 38L102 64L120 70L108 96' fill='none' stroke='#eefaff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round' opacity='0.66'/>"""
			left_arm_svg = """<path d='M58 72Q44 92 38 110' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='38' cy='110' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>"""
			right_arm_staff_svg = """<path d='M98 72Q122 78 142 84' fill='none' stroke='#16304a' stroke-width='8' stroke-linecap='round'/>
<circle cx='142' cy='84' r='4.4' fill='#f3c4a1' stroke='#2b1621' stroke-width='2.4'/>
<rect x='114' y='-4' width='9' height='126' rx='4' fill='#7b4d2c' transform='rotate(58 118 59)'/>
<circle cx='154' cy='22' r='12' fill='#ffe377' stroke='#0d2a46' stroke-width='4'/>"""
			front_fx_svg = """<path d='M146 24L138 58' stroke='#eefaff' stroke-width='6' stroke-linecap='round'/>
<circle cx='136' cy='94' r='14' fill='none' stroke='#b8f6ff' stroke-width='4' opacity='0.40'/>"""
		_:
			return _build_caster_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<circle cx='78' cy='80' r='46' fill='#5ecff3' opacity='0.12'/>
<path d='M78 10L98 24L104 46L118 62L122 126Q78 154 34 126L38 62L52 46L58 24Z' fill='#246ea9' stroke='#0b2338' stroke-width='6' stroke-linejoin='round'/>
<path d='M78 38L98 54L102 112Q78 132 54 112L58 54Z' fill='#102c49' opacity='0.96'/>
<path d='M64 18L78 2L92 18L88 36Q78 30 68 36Z' fill='#173f69' stroke='#0b2338' stroke-width='4' stroke-linejoin='round'/>
<path d='M50 50L34 70L44 82L58 60Z' fill='#2f8bcb' opacity='0.78'/>
<path d='M106 48L122 68L112 82L98 60Z' fill='#2f8bcb' opacity='0.78'/>
<path d='M62 118L78 140L94 118' fill='none' stroke='#3ca6e0' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='78' cy='38' r='13' fill='#f3c4a1' stroke='#2b1621' stroke-width='4'/>
<path d='M66 30Q78 18 90 30' fill='none' stroke='#10253b' stroke-width='6' stroke-linecap='round'/>
<path d='M62 92L94 92' stroke='#ffd56b' stroke-width='6' stroke-linecap='round'/>
<circle cx='72' cy='38' r='2.6' fill='#190f14'/>
<circle cx='84' cy='38' r='2.6' fill='#190f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [back_fx_svg, left_arm_svg, body_svg, right_arm_staff_svg, front_fx_svg]


static func _build_blade_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"slash":
			pose_id = "slash_%d" % clampi(frame_index, 0, 2)
		"mooncut":
			pose_id = "moon_%d" % clampi(frame_index, 0, 2)
		"dash_cut":
			pose_id = "dash_%d" % clampi(frame_index, 0, 2)
	return _build_blade_pose_svg(pose_id)


static func _build_blade_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var back_arm_svg := ""
	var front_arm_svg := ""
	var weapon_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			body_transform = "translate(-4 6) rotate(-10 76 96)"
			back_arm_svg = """<path d='M54 78L32 114' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='32' cy='114' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 46L108 74' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M108 74L118 102' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='118' cy='102' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M116 102L126 84' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M120 84L158 18L160 28L128 94Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>
<path d='M128 32L146 60' stroke='#ffffff' stroke-width='4' stroke-linecap='round' opacity='0.45'/>"""
			extra_svg = """<path d='M38 124L58 132' stroke='#ff9b70' stroke-width='5' stroke-linecap='round' opacity='0.34'/>"""
		"move_0":
			body_transform = "translate(-6 8) rotate(-14 74 100)"
			back_arm_svg = """<path d='M54 78L30 108' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='30' cy='108' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 46L110 70' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M110 70L122 96' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='122' cy='96' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M120 96L128 78' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M124 78L158 16L160 26L132 88Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>"""
		"move_1":
			body_transform = "translate(-1 4) rotate(-4 80 92)"
			back_arm_svg = """<path d='M58 78L40 118' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='40' cy='118' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M90 48L104 80' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M104 80L112 112' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='112' cy='112' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M110 110L124 96' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M120 96L156 40L160 50L128 104Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>"""
		"slash_0":
			body_transform = "translate(-8 10) rotate(-20 72 98)"
			back_arm_svg = """<path d='M56 80L34 96' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='34' cy='96' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 46Q108 30 122 18' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M122 18Q132 10 140 6' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='140' cy='6' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M138 6L146 0' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M142 0L160 2L160 34L136 16Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>
<path d='M142 8L156 16' stroke='#ffffff' stroke-width='4' stroke-linecap='round' opacity='0.45'/>"""
		"slash_1":
			body_transform = "translate(4 12) rotate(12 84 98)"
			back_arm_svg = """<path d='M52 82L30 92' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='30' cy='92' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q116 54 138 58' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M138 58Q148 60 156 58' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='156' cy='58' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M150 58L160 56' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M144 50L160 42L160 74L142 68Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>
<path d='M98 28Q130 40 160 96' fill='none' stroke='#ffb9a3' stroke-width='8' stroke-linecap='round' opacity='0.62'/>"""
			extra_svg = """<path d='M92 36Q126 50 154 106' fill='none' stroke='#ffd4c4' stroke-width='4' stroke-linecap='round' opacity='0.46'/>"""
		"slash_2":
			body_transform = "translate(2 8) rotate(4 82 94)"
			back_arm_svg = """<path d='M54 78L34 116' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='34' cy='116' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q106 72 120 92' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M120 92Q128 102 134 108' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='134' cy='108' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M132 108L142 116' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M128 102L160 122L150 138L122 112Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>
<path d='M136 112L154 124' stroke='#ffffff' stroke-width='4' stroke-linecap='round' opacity='0.42'/>"""
		"moon_0":
			body_transform = "translate(-10 10) rotate(-22 72 98)"
			back_arm_svg = """<path d='M56 80L36 92' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='36' cy='92' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q108 36 120 28' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M120 28Q134 18 146 12' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='146' cy='12' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M144 12L154 4' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M140 6L160 8L160 40L138 24Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M56 112Q92 82 132 14' fill='none' stroke='#ffcfb8' stroke-width='5' stroke-linecap='round' opacity='0.36'/>"""
		"moon_1":
			body_transform = "translate(0 6) rotate(2 80 92)"
			back_arm_svg = """<path d='M54 80L26 88' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='26' cy='88' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q116 52 144 48' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M144 48Q152 46 160 40' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>"""
			weapon_svg = """<path d='M146 44L156 40' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M140 34L160 18L160 60L138 56Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>
<path d='M16 118Q80 -8 160 28' fill='none' stroke='#ffd8c7' stroke-width='8' stroke-linecap='round' opacity='0.58'/>"""
			extra_svg = """<path d='M26 122Q84 4 156 36' fill='none' stroke='#ffb98f' stroke-width='4' stroke-linecap='round' opacity='0.45'/>"""
		"moon_2":
			body_transform = "translate(2 6) rotate(8 82 92)"
			back_arm_svg = """<path d='M54 78L36 114' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='36' cy='114' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q110 64 124 80' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M124 80Q134 90 144 94' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='144' cy='94' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M142 94L150 100' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M138 86L160 98L152 120L134 104Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>"""
		"dash_0":
			body_transform = "translate(-10 14) rotate(-24 70 102)"
			back_arm_svg = """<path d='M56 82L26 88' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='26' cy='88' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q118 40 140 34' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M140 34Q150 32 160 30' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>"""
			weapon_svg = """<path d='M150 30L160 28' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M138 22L160 16L160 42L138 40Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M0 92L54 82' stroke='#ffb9a3' stroke-width='6' stroke-linecap='round' opacity='0.46'/>"""
		"dash_1":
			body_transform = "translate(-18 12) rotate(-30 66 100)"
			back_arm_svg = """<path d='M56 82L18 84' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='18' cy='84' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q124 38 150 34' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M150 34Q156 32 160 30' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>"""
			weapon_svg = """<path d='M150 30L160 28' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M136 20L160 12L160 46L136 42Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M0 88L58 80' stroke='#ffb9a3' stroke-width='7' stroke-linecap='round' opacity='0.64'/>
<path d='M0 102L42 98' stroke='#ff9b70' stroke-width='4' stroke-linecap='round' opacity='0.46'/>
<path d='M22 110L72 92' stroke='#ffd4c4' stroke-width='3' stroke-linecap='round' opacity='0.34'/>"""
		"dash_2":
			body_transform = "translate(-2 8) rotate(2 80 94)"
			back_arm_svg = """<path d='M54 78L34 116' stroke='#1a202c' stroke-width='10' stroke-linecap='round'/>
<circle cx='34' cy='116' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M92 48Q108 72 120 90' fill='none' stroke='#5b3828' stroke-width='8' stroke-linecap='round'/>
<path d='M120 90Q128 100 136 106' fill='none' stroke='#1a202c' stroke-width='9' stroke-linecap='round'/>
<circle cx='136' cy='106' r='4.4' fill='#edc1a0' stroke='#241219' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M134 106L146 114' stroke='#5b3828' stroke-width='7' stroke-linecap='round'/>
<path d='M128 100L160 122L150 138L122 110Z' fill='#dfe8f3' stroke='#536174' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M16 112L82 94' stroke='#ffcfb8' stroke-width='4' stroke-linecap='round' opacity='0.34'/>"""
		_:
			return _build_blade_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<ellipse cx='78' cy='100' rx='34' ry='16' fill='#ff8f73' opacity='0.12'/>
<path d='M72 24L112 44L122 78L108 122Q78 150 40 128L42 72L58 42Z' fill='#2a3343' stroke='#101723' stroke-width='6' stroke-linejoin='round'/>
<path d='M72 46L98 58L102 110Q80 126 54 114L56 60Z' fill='#11161f'/>
<path d='M40 46L70 30L84 58L52 74L30 62Z' fill='#4b566c' stroke='#111820' stroke-width='4' stroke-linejoin='round'/>
<path d='M96 42L126 50L128 80L96 74Z' fill='#374154' stroke='#111820' stroke-width='4' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='14' fill='#edc1a0' stroke='#241219' stroke-width='4'/>
<path d='M58 28Q74 10 92 26' fill='none' stroke='#6f4237' stroke-width='6' stroke-linecap='round'/>
<path d='M54 90L102 88' stroke='#ff7a5c' stroke-width='6' stroke-linecap='round'/>
<path d='M46 120L72 136L112 122' fill='none' stroke='#ff9b70' stroke-width='6' stroke-linecap='round'/>
<path d='M52 114L38 132' stroke='#ffb38a' stroke-width='5' stroke-linecap='round'/>
<circle cx='68' cy='38' r='2.6' fill='#180f14'/>
<circle cx='80' cy='38' r='2.6' fill='#180f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [back_arm_svg, body_svg, front_arm_svg, weapon_svg, extra_svg]


static func _build_thunder_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"orb_throw":
			pose_id = "orb_%d" % clampi(frame_index, 0, 3)
	return _build_thunder_pose_svg(pose_id)


static func _build_thunder_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var left_arm_svg := ""
	var right_arm_svg := ""
	var lightning_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			body_transform = "translate(0 2)"
			left_arm_svg = """<path d='M52 76L42 110' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='110' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 62L124 92' stroke='#16243a' stroke-width='10' stroke-linecap='round'/>
<path d='M124 92L130 104' stroke='#10203a' stroke-width='11' stroke-linecap='round'/>
<circle cx='130' cy='104' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			lightning_svg = """<path d='M120 18L110 38L128 42L116 64L134 68L122 92' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='126' cy='58' r='9' fill='#8bd8ff' opacity='0.22'/>"""
		"move_0":
			body_transform = "translate(-2 2) rotate(-6 78 86)"
			left_arm_svg = """<path d='M50 78L40 108' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='108' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M108 60L128 86' stroke='#16243a' stroke-width='10' stroke-linecap='round'/>
<path d='M128 86L136 98' stroke='#10203a' stroke-width='11' stroke-linecap='round'/>
<circle cx='136' cy='98' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			lightning_svg = """<path d='M124 18L112 38L130 42L118 66L136 70L124 92' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>"""
		"move_1":
			body_transform = "translate(2 2) rotate(4 82 86)"
			left_arm_svg = """<path d='M56 74L48 112' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<circle cx='48' cy='112' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 64L118 98' stroke='#16243a' stroke-width='10' stroke-linecap='round'/>
<path d='M118 98L122 110' stroke='#10203a' stroke-width='11' stroke-linecap='round'/>
<circle cx='122' cy='110' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			lightning_svg = """<path d='M116 18L106 38L124 42L112 66L128 72L118 94' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>"""
		"orb_0":
			body_transform = "translate(-4 0) rotate(-10 78 84)"
			left_arm_svg = """<path d='M54 76Q44 62 40 48' fill='none' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='48' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 62Q122 48 136 32' fill='none' stroke='#16243a' stroke-width='10' stroke-linecap='round'/>
<path d='M136 32L144 24' stroke='#10203a' stroke-width='11' stroke-linecap='round'/>
<circle cx='144' cy='24' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			lightning_svg = """<path d='M118 22L108 38L124 42L114 58L132 60L126 76' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M136 22L128 36L142 38L134 52' fill='none' stroke='#8bd8ff' stroke-width='5' stroke-linecap='round' stroke-linejoin='round' opacity='0.8'/>"""
			extra_svg = """<circle cx='146' cy='22' r='12' fill='#8bd8ff' opacity='0.30'/>
<circle cx='146' cy='22' r='18' fill='none' stroke='#d6f6ff' stroke-width='3' opacity='0.26'/>"""
		"orb_1":
			body_transform = "translate(-2 -2) rotate(-4 82 82)"
			left_arm_svg = """<path d='M54 76Q42 62 42 46' fill='none' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='46' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 62Q126 54 144 44' fill='none' stroke='#16243a' stroke-width='10' stroke-linecap='round'/>
<path d='M144 44L152 38' stroke='#10203a' stroke-width='11' stroke-linecap='round'/>
<circle cx='152' cy='38' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			lightning_svg = """<path d='M122 22L110 38L128 42L116 60L134 64L122 82' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M142 36L132 50L148 54L138 66' fill='none' stroke='#8bd8ff' stroke-width='5' stroke-linecap='round' stroke-linejoin='round' opacity='0.85'/>"""
			extra_svg = """<circle cx='152' cy='38' r='14' fill='#8bd8ff' opacity='0.38'/>
<circle cx='152' cy='38' r='22' fill='none' stroke='#d6f6ff' stroke-width='4' opacity='0.30'/>
<path d='M142 30L160 44L144 56' fill='none' stroke='#eefaff' stroke-width='4' stroke-linecap='round' stroke-linejoin='round'/>"""
		"orb_2":
			body_transform = "translate(4 4) rotate(10 84 90)"
			left_arm_svg = """<path d='M54 76Q48 90 44 104' fill='none' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='104' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 62Q126 70 140 70' fill='none' stroke='#16243a' stroke-width='10' stroke-linecap='round'/>
<path d='M140 70L146 68' stroke='#10203a' stroke-width='11' stroke-linecap='round'/>
<circle cx='146' cy='68' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			lightning_svg = """<path d='M120 24L108 42L126 46L114 66L132 70L120 92' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M144 66L152 56L148 68L160 62' fill='none' stroke='#eefaff' stroke-width='5' stroke-linecap='round' stroke-linejoin='round'/>"""
			extra_svg = """<circle cx='158' cy='62' r='12' fill='#8bd8ff' opacity='0.36'/>
<circle cx='158' cy='62' r='20' fill='none' stroke='#d6f6ff' stroke-width='4' opacity='0.28'/>
<path d='M144 68L156 62' stroke='#8bd8ff' stroke-width='5' stroke-linecap='round' opacity='0.70'/>"""
		"orb_3":
			body_transform = "translate(1 4) rotate(2 80 88)"
			left_arm_svg = """<path d='M54 76L44 110' stroke='#16243a' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='110' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 62Q118 84 126 100' fill='none' stroke='#16243a' stroke-width='10' stroke-linecap='round'/>
<path d='M126 100L130 112' stroke='#10203a' stroke-width='11' stroke-linecap='round'/>
<circle cx='130' cy='112' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			lightning_svg = """<path d='M118 24L108 42L124 46L114 64L130 68L120 88' fill='none' stroke='#eefaff' stroke-width='7' stroke-linecap='round' stroke-linejoin='round' opacity='0.82'/>"""
			extra_svg = """<path d='M142 70L160 58' stroke='#8bd8ff' stroke-width='5' stroke-linecap='round' opacity='0.40'/>
<path d='M148 76L160 70' stroke='#eefaff' stroke-width='3' stroke-linecap='round' opacity='0.28'/>"""
		_:
			return _build_thunder_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<circle cx='80' cy='84' r='46' fill='#66c8ff' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#d6f6ff' stroke-width='4' opacity='0.24'/>
<path d='M80 22L102 38L124 68L118 122Q82 148 44 124L40 70L54 44Z' fill='#20385c' stroke='#0d1a2c' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 54L102 110Q80 128 56 114L54 58Z' fill='#0f1d33'/>
<circle cx='80' cy='38' r='14' fill='#f2c4a3' stroke='#24141c' stroke-width='4'/>
<path d='M66 28Q80 12 94 28' fill='none' stroke='#dfefff' stroke-width='6' stroke-linecap='round'/>
<path d='M46 48L70 34L78 58L56 74L36 62Z' fill='#5377ac' stroke='#10203a' stroke-width='4' stroke-linejoin='round'/>
<path d='M98 32L134 44L128 86L92 78Z' fill='#4a96ff' stroke='#10203a' stroke-width='4' stroke-linejoin='round'/>
<path d='M94 82L122 94L104 124L82 114Z' fill='#162c4a' stroke='#10203a' stroke-width='4' stroke-linejoin='round'/>
<path d='M54 118L72 130L58 146' fill='none' stroke='#83d7ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M104 116L84 130L100 144L88 154' fill='none' stroke='#83d7ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M62 90L98 90' stroke='#8bd8ff' stroke-width='6' stroke-linecap='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [left_arm_svg, body_svg, right_arm_svg, lightning_svg, extra_svg]


static func _build_alchemist_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"throw_flask":
			pose_id = "flask_%d" % clampi(frame_index, 0, 2)
		"catalyst_burst":
			pose_id = "catalyst_%d" % clampi(frame_index, 0, 2)
	return _build_alchemist_pose_svg(pose_id)


static func _build_alchemist_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var left_arm_svg := ""
	var right_arm_svg := ""
	var device_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			body_transform = "translate(-2 2)"
			left_arm_svg = """<path d='M52 74L42 108' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='108' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 70L116 100' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='116' cy='100' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M94 78Q112 72 126 82' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M120 72L142 78L136 96L112 92L108 78Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round'/>
<path d='M132 78L148 78L142 90L126 92Z' fill='none' stroke='#f5ffd2' stroke-width='4' stroke-linejoin='round'/>"""
		"move_0":
			body_transform = "translate(-4 2) rotate(-4 76 86)"
			left_arm_svg = """<path d='M50 76L40 106' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='106' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 68L120 94' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='120' cy='94' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M96 76Q114 70 128 80' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M122 70L144 78L138 94L114 90L110 76Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round'/>"""
		"move_1":
			body_transform = "translate(1 2) rotate(4 80 86)"
			left_arm_svg = """<path d='M56 72L46 110' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='110' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M100 72L112 104' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='112' cy='104' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M92 80Q108 72 122 84' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M116 74L138 80L132 98L110 94L104 80Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round'/>"""
		"flask_0":
			body_transform = "translate(-6 0) rotate(-8 76 84)"
			left_arm_svg = """<path d='M54 74Q44 60 40 48' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='48' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 70Q116 54 128 40' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='128' cy='40' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M92 78Q106 70 116 72' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M120 36L134 36L140 50L130 62L116 56L114 42Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round'/>
<circle cx='128' cy='48' r='11' fill='none' stroke='#f5ffd2' stroke-width='3' opacity='0.42'/>"""
		"flask_1":
			body_transform = "translate(2 2) rotate(4 80 84)"
			left_arm_svg = """<path d='M54 74Q44 58 42 46' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='46' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 70Q122 66 138 58' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='138' cy='58' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M92 80Q108 74 118 80' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M140 54L154 48L160 60L146 70L136 64Z' fill='#d1f06d' stroke='#28401c' stroke-width='3' stroke-linejoin='round'/>
<circle cx='148' cy='60' r='12' fill='none' stroke='#f5ffd2' stroke-width='3' opacity='0.46'/>
<path d='M138 58L148 46' stroke='#eef8bf' stroke-width='4' stroke-linecap='round' opacity='0.60'/>"""
		"flask_2":
			body_transform = "translate(0 4) rotate(2 80 88)"
			left_arm_svg = """<path d='M54 74L44 108' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='108' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 70Q114 88 126 98' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='126' cy='98' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M94 80Q108 76 118 84' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M132 70L148 72L142 86L126 86Z' fill='none' stroke='#d1f06d' stroke-width='4' stroke-linejoin='round' opacity='0.70'/>"""
			extra_svg = """<path d='M142 78L156 82' stroke='#d1f06d' stroke-width='4' stroke-linecap='round' opacity='0.55'/>"""
		"catalyst_0":
			body_transform = "translate(-2 0) rotate(-4 78 84)"
			left_arm_svg = """<path d='M54 74Q40 80 28 80' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='28' cy='80' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 70Q116 78 130 80' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='130' cy='80' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M94 78Q110 74 124 82' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M118 72L140 78L136 96L112 92L108 78Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round'/>
<circle cx='78' cy='88' r='18' fill='none' stroke='#eef8bf' stroke-width='4' opacity='0.32'/>"""
		"catalyst_1":
			body_transform = "translate(0 0)"
			left_arm_svg = """<path d='M54 74Q34 84 18 86' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='18' cy='86' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 70Q122 84 142 86' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='142' cy='86' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M92 80Q110 74 126 84' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M118 72L142 80L136 100L110 94L106 78Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<circle cx='80' cy='88' r='30' fill='none' stroke='#eef8bf' stroke-width='5' opacity='0.56'/>
<circle cx='80' cy='88' r='14' fill='#a7dd68' opacity='0.20'/>
<path d='M44 60L56 54' stroke='#f5ffd2' stroke-width='4' stroke-linecap='round' opacity='0.58'/>
<path d='M114 54L126 48' stroke='#f5ffd2' stroke-width='4' stroke-linecap='round' opacity='0.58'/>"""
		"catalyst_2":
			body_transform = "translate(2 2) rotate(2 80 86)"
			left_arm_svg = """<path d='M54 74Q42 92 38 110' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='38' cy='110' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 70Q118 92 132 106' fill='none' stroke='#162414' stroke-width='8' stroke-linecap='round'/>
<circle cx='132' cy='106' r='4.4' fill='#f2c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M94 82Q110 78 122 88' fill='none' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<path d='M118 76L138 82L132 98L112 94Z' fill='#d1f06d' stroke='#28401c' stroke-width='4' stroke-linejoin='round' opacity='0.88'/>"""
			extra_svg = """<path d='M54 88L110 88' stroke='#eef8bf' stroke-width='4' stroke-linecap='round' opacity='0.66'/>
<circle cx='52' cy='98' r='7' fill='#a7dd68' opacity='0.18'/>
<circle cx='112' cy='96' r='8' fill='#a7dd68' opacity='0.18'/>"""
		_:
			return _build_alchemist_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<circle cx='78' cy='84' r='44' fill='#a7dd68' opacity='0.14'/>
<circle cx='78' cy='82' r='34' fill='none' stroke='#eef8bf' stroke-width='4' opacity='0.24'/>
<path d='M78 24L102 44L112 70L108 122Q78 148 46 124L42 68L54 44Z' fill='#365028' stroke='#162514' stroke-width='6' stroke-linejoin='round'/>
<path d='M78 42L98 58L100 110Q78 128 56 114L58 58Z' fill='#172313'/>
<circle cx='76' cy='38' r='13' fill='#f2c4a3' stroke='#24141c' stroke-width='4'/>
<path d='M64 28Q76 12 90 28' fill='none' stroke='#d7f4ac' stroke-width='6' stroke-linecap='round'/>
<rect x='26' y='42' width='30' height='56' rx='10' fill='#c6eb62' stroke='#28401c' stroke-width='4'/>
<circle cx='42' cy='56' r='10' fill='none' stroke='#f5ffd2' stroke-width='4' opacity='0.70'/>
<path d='M52 78Q76 54 106 74' fill='none' stroke='#8bc84b' stroke-width='6' stroke-linecap='round'/>
<path d='M46 98L48 116' stroke='#28401c' stroke-width='5' stroke-linecap='round'/>
<circle cx='62' cy='112' r='6' fill='#d1f06d' stroke='#28401c' stroke-width='3'/>
<circle cx='76' cy='120' r='5' fill='#d1f06d' stroke='#28401c' stroke-width='3'/>
<path d='M60 90L94 90' stroke='#dced84' stroke-width='6' stroke-linecap='round'/>
<circle cx='70' cy='38' r='2.6' fill='#140f14'/>
<circle cx='82' cy='38' r='2.6' fill='#140f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [left_arm_svg, body_svg, right_arm_svg, device_svg, extra_svg]


static func _build_blood_hunter_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"blood_draw":
			pose_id = "draw_%d" % clampi(frame_index, 0, 2)
		"blood_dash":
			pose_id = "dash_%d" % clampi(frame_index, 0, 2)
	return _build_blood_hunter_pose_svg(pose_id)


static func _build_blood_hunter_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var back_arm_svg := ""
	var front_arm_svg := ""
	var weapon_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			back_arm_svg = """<path d='M54 72L44 110' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='110' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 70L118 104' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='104' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M104 26L124 14L150 72L128 84Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>
<path d='M108 34L124 26' stroke='#ffffff' stroke-width='4' stroke-linecap='round' opacity='0.55'/>"""
		"move_0":
			body_transform = "translate(-3 1) rotate(-5 76 88)"
			back_arm_svg = """<path d='M52 74L40 106' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='106' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 68L122 96' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='122' cy='96' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M108 20L130 12L154 66L132 80Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
		"move_1":
			body_transform = "translate(2 1) rotate(5 82 88)"
			back_arm_svg = """<path d='M56 72L48 112' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='48' cy='112' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M104 72L114 108' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='114' cy='108' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M100 26L122 16L144 74L124 86Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
		"draw_0":
			body_transform = "translate(-5 0) rotate(-10 76 84)"
			back_arm_svg = """<path d='M54 72Q46 60 44 48' fill='none' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='48' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 70Q122 58 136 52' fill='none' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='136' cy='52' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M102 16L126 8L154 70L130 80Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M114 54Q132 46 152 52' fill='none' stroke='#f16f7d' stroke-width='5' stroke-linecap='round' opacity='0.72'/>"""
		"draw_1":
			body_transform = "translate(0 -1) rotate(3 80 84)"
			back_arm_svg = """<path d='M54 72Q70 70 86 64' fill='none' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='86' cy='64' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 70Q128 70 148 74' fill='none' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='148' cy='74' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M118 24L142 20L160 78L136 88Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M124 74Q144 84 160 96' fill='none' stroke='#f16f7d' stroke-width='5' stroke-linecap='round' opacity='0.72'/>"""
		"draw_2":
			body_transform = "translate(2 1) rotate(6 82 86)"
			back_arm_svg = """<path d='M54 72L46 108' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='108' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 70L118 102' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='102' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M108 24L130 16L154 74L132 86Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
		"dash_0":
			body_transform = "translate(-10 4) rotate(-18 70 88)"
			back_arm_svg = """<path d='M56 74L34 100' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='34' cy='100' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 70L132 82' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='132' cy='82' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M120 22L148 20L160 58L136 80Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M26 106L60 84L94 80' fill='none' stroke='#f16f7d' stroke-width='6' stroke-linecap='round' opacity='0.72'/>"""
		"dash_1":
			body_transform = "translate(4 6) rotate(12 86 92)"
			back_arm_svg = """<path d='M56 74L30 86' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='30' cy='86' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 70Q128 86 152 96' fill='none' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='152' cy='96' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M124 40L154 52L160 88L136 96Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M44 84L94 94L142 110' fill='none' stroke='#f16f7d' stroke-width='6' stroke-linecap='round' opacity='0.72'/>"""
		"dash_2":
			body_transform = "translate(1 2) rotate(2 80 88)"
			back_arm_svg = """<path d='M54 72L44 110' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='110' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			front_arm_svg = """<path d='M106 70L118 104' stroke='#221116' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='104' r='4.4' fill='#f1c4a3' stroke='#261218' stroke-width='2.4'/>"""
			weapon_svg = """<path d='M104 26L124 14L150 72L128 84Z' fill='#f0f3f7' stroke='#5d626b' stroke-width='4' stroke-linejoin='round'/>"""
		_:
			return _build_blood_hunter_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<circle cx='80' cy='84' r='46' fill='#d94d58' opacity='0.14'/>
<circle cx='80' cy='82' r='36' fill='none' stroke='#ffd6d8' stroke-width='4' opacity='0.24'/>
<path d='M80 24L104 42L114 72L110 124Q80 150 46 124L46 72L56 44Z' fill='#5a1e26' stroke='#230c11' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 44L100 58L102 112Q80 130 58 114L60 58Z' fill='#2a0f14'/>
<circle cx='80' cy='38' r='13' fill='#f1c4a3' stroke='#261218' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#ffd6d8' stroke-width='6' stroke-linecap='round'/>
<path d='M44 52L68 44L74 64L48 72Z' fill='#8c3942' stroke='#2a0f14' stroke-width='4' stroke-linejoin='round'/>
<path d='M62 92L98 92' stroke='#f16f7d' stroke-width='6' stroke-linecap='round'/>
<path d='M58 118L50 138L72 132' fill='none' stroke='#b74a55' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M98 118L106 138L88 132' fill='none' stroke='#b74a55' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [back_arm_svg, body_svg, front_arm_svg, weapon_svg, extra_svg]


static func _build_grave_caller_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"dirge_cast":
			pose_id = "dirge_%d" % clampi(frame_index, 0, 2)
		"grave_toll":
			pose_id = "toll_%d" % clampi(frame_index, 0, 2)
	return _build_grave_caller_pose_svg(pose_id)


static func _build_grave_caller_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var left_arm_svg := ""
	var right_arm_svg := ""
	var relic_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			left_arm_svg = """<path d='M56 74L46 112' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='112' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70L116 104' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='116' cy='104' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M108 24L132 30L126 62L104 56Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>
<circle cx='122' cy='30' r='12' fill='none' stroke='#dcfff1' stroke-width='4' opacity='0.68'/>"""
		"move_0":
			body_transform = "translate(-3 1) rotate(-4 77 88)"
			left_arm_svg = """<path d='M54 76L42 106' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='106' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 68L120 96' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='120' cy='96' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M110 26L132 32L126 62L106 56Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>"""
		"move_1":
			body_transform = "translate(2 1) rotate(4 82 88)"
			left_arm_svg = """<path d='M58 74L50 110' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='50' cy='110' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 72L114 106' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='114' cy='106' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M106 22L128 30L124 60L102 54Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>"""
		"dirge_0":
			body_transform = "translate(-2 0) rotate(-6 78 84)"
			left_arm_svg = """<path d='M56 74Q48 62 44 48' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='48' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q116 58 128 50' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='128' cy='50' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M106 18L134 24L128 62L102 56Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M42 46Q58 36 74 42' fill='none' stroke='#dcfff1' stroke-width='4' stroke-linecap='round' opacity='0.72'/>"""
		"dirge_1":
			body_transform = "translate(0 -1)"
			left_arm_svg = """<path d='M56 74Q38 82 20 84' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='20' cy='84' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q124 82 146 84' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='146' cy='84' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M108 20L136 26L130 64L104 58Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<circle cx='80' cy='86' r='28' fill='none' stroke='#dcfff1' stroke-width='5' opacity='0.58'/>
<path d='M56 86L104 86' stroke='#9ad9c2' stroke-width='5' stroke-linecap='round' opacity='0.68'/>"""
		"dirge_2":
			body_transform = "translate(2 1) rotate(3 82 86)"
			left_arm_svg = """<path d='M56 74L46 110' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='110' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70L118 102' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='102' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M108 24L132 30L126 62L104 56Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>"""
		"toll_0":
			body_transform = "translate(-4 2) rotate(-8 76 88)"
			left_arm_svg = """<path d='M56 74Q42 78 30 82' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='30' cy='82' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q122 70 138 72' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='138' cy='72' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M110 20L138 26L132 64L106 58Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>
<circle cx='124' cy='74' r='14' fill='none' stroke='#dcfff1' stroke-width='4' opacity='0.58'/>"""
		"toll_1":
			body_transform = "translate(0 2)"
			left_arm_svg = """<path d='M56 74Q36 88 20 98' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='20' cy='98' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q126 88 150 100' fill='none' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='150' cy='100' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M110 24L136 30L130 64L106 58Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<circle cx='80' cy='90' r='34' fill='none' stroke='#dcfff1' stroke-width='5' opacity='0.52'/>
<circle cx='80' cy='90' r='16' fill='#8ec3ad' opacity='0.18'/>"""
		"toll_2":
			body_transform = "translate(2 2) rotate(2 82 88)"
			left_arm_svg = """<path d='M56 74L46 112' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='112' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70L116 104' stroke='#15201d' stroke-width='8' stroke-linecap='round'/>
<circle cx='116' cy='104' r='4.4' fill='#ebc3a0' stroke='#271419' stroke-width='2.4'/>"""
			relic_svg = """<path d='M108 24L132 30L126 62L104 56Z' fill='#9ad9c2' stroke='#2a4a3f' stroke-width='4' stroke-linejoin='round'/>"""
		_:
			return _build_grave_caller_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<circle cx='80' cy='84' r='46' fill='#8ec3ad' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#dcfff1' stroke-width='4' opacity='0.24'/>
<path d='M80 20L104 40L114 70L112 126Q80 152 44 124L46 70L56 40Z' fill='#2f3f3a' stroke='#121b18' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 56L102 110Q80 130 58 114L58 56Z' fill='#16211e'/>
<circle cx='80' cy='38' r='12' fill='#ebc3a0' stroke='#271419' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#dff9ec' stroke-width='6' stroke-linecap='round'/>
<path d='M40 120Q80 96 120 120' fill='none' stroke='#8ec3ad' stroke-width='5' stroke-linecap='round'/>
<path d='M62 94L98 94' stroke='#9ad9c2' stroke-width='6' stroke-linecap='round'/>
<path d='M56 118L48 140L70 134' fill='none' stroke='#5b7d72' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M100 118L108 140L88 134' fill='none' stroke='#5b7d72' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [left_arm_svg, body_svg, right_arm_svg, relic_svg, extra_svg]


static func _build_illusionist_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"mirror_cast":
			pose_id = "mirror_%d" % clampi(frame_index, 0, 2)
		"swap_step":
			pose_id = "swap_%d" % clampi(frame_index, 0, 2)
	return _build_illusionist_pose_svg(pose_id)


static func _build_illusionist_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var left_arm_svg := ""
	var right_arm_svg := ""
	var mirror_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			left_arm_svg = """<path d='M54 72L44 110' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='110' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 70L118 104' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='104' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M108 22L130 30L126 60L104 56Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>
<circle cx='122' cy='30' r='12' fill='none' stroke='#d9ddff' stroke-width='4' opacity='0.66'/>"""
		"move_0":
			body_transform = "translate(-3 1) rotate(-5 77 88)"
			left_arm_svg = """<path d='M52 74L40 106' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='106' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 68L122 96' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='122' cy='96' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M110 24L130 30L126 60L106 56Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
		"move_1":
			body_transform = "translate(2 1) rotate(5 82 88)"
			left_arm_svg = """<path d='M56 72L48 112' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='48' cy='112' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 72L114 108' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='114' cy='108' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M106 20L128 28L124 58L102 54Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
		"mirror_0":
			body_transform = "translate(-2 0) rotate(-6 78 84)"
			left_arm_svg = """<path d='M56 74Q48 62 42 50' fill='none' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='50' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 70Q118 58 130 50' fill='none' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='130' cy='50' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M108 18L136 26L130 64L104 58Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M44 52Q60 38 76 42' fill='none' stroke='#d9ddff' stroke-width='4' stroke-linecap='round' opacity='0.72'/>"""
		"mirror_1":
			body_transform = "translate(0 -1)"
			left_arm_svg = """<path d='M56 74Q34 80 18 82' fill='none' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='18' cy='82' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 70Q128 80 150 82' fill='none' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='150' cy='82' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M110 20L138 28L132 66L106 60Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<circle cx='80' cy='86' r='30' fill='none' stroke='#d9ddff' stroke-width='5' opacity='0.58'/>
<path d='M48 86L112 86' stroke='#9ea8ff' stroke-width='5' stroke-linecap='round' opacity='0.68'/>"""
		"mirror_2":
			body_transform = "translate(2 1) rotate(3 82 86)"
			left_arm_svg = """<path d='M56 72L46 110' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='110' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 70L118 102' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='102' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M108 22L130 30L126 60L104 56Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
		"swap_0":
			body_transform = "translate(-8 3) rotate(-14 72 88)"
			left_arm_svg = """<path d='M56 74L30 96' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='30' cy='96' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 70L132 82' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='132' cy='82' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M114 26L138 34L132 62L108 58Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M22 102L54 84L88 82' fill='none' stroke='#9ea8ff' stroke-width='6' stroke-linecap='round' opacity='0.74'/>"""
		"swap_1":
			body_transform = "translate(6 5) rotate(12 88 92)"
			left_arm_svg = """<path d='M56 74L28 86' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='28' cy='86' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 70Q128 86 154 98' fill='none' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='154' cy='98' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M116 30L142 40L136 66L110 60Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M42 84L96 96L146 110' fill='none' stroke='#9ea8ff' stroke-width='6' stroke-linecap='round' opacity='0.74'/>"""
		"swap_2":
			body_transform = "translate(1 2) rotate(2 80 88)"
			left_arm_svg = """<path d='M54 72L44 110' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='110' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 70L118 104' stroke='#151a32' stroke-width='8' stroke-linecap='round'/>
<circle cx='118' cy='104' r='4.4' fill='#efc4a1' stroke='#24141b' stroke-width='2.4'/>"""
			mirror_svg = """<path d='M108 22L130 30L126 60L104 56Z' fill='#aeb8ff' stroke='#364091' stroke-width='4' stroke-linejoin='round'/>"""
		_:
			return _build_illusionist_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<circle cx='80' cy='84' r='46' fill='#6a7cff' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#d9ddff' stroke-width='4' opacity='0.24'/>
<path d='M80 24L104 42L112 70L110 124Q80 148 46 124L48 70L58 42Z' fill='#2f3369' stroke='#141735' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 42L98 58L100 112Q80 130 58 114L60 58Z' fill='#151a3d'/>
<circle cx='80' cy='38' r='13' fill='#efc4a1' stroke='#24141b' stroke-width='4'/>
<path d='M66 28Q80 14 94 28' fill='none' stroke='#e6e9ff' stroke-width='6' stroke-linecap='round'/>
<path d='M44 58Q80 44 116 58' fill='none' stroke='#9ea8ff' stroke-width='4' stroke-linecap='round' opacity='0.62'/>
<path d='M62 94L98 94' stroke='#9ea8ff' stroke-width='6' stroke-linecap='round'/>
<path d='M58 118L48 138L70 132' fill='none' stroke='#626fce' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<path d='M98 118L108 138L88 132' fill='none' stroke='#626fce' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [left_arm_svg, body_svg, right_arm_svg, mirror_svg, extra_svg]


static func _build_warden_animation_svg(animation_id: String, frame_index: int) -> String:
	var pose_id := "idle"
	match animation_id:
		"move":
			pose_id = "move_%d" % clampi(frame_index, 0, 1)
		"brace_cast":
			pose_id = "cast_%d" % clampi(frame_index, 0, 2)
		"brace_pulse":
			pose_id = "pulse_%d" % clampi(frame_index, 0, 2)
	return _build_warden_pose_svg(pose_id)


static func _build_warden_pose_svg(pose_id: String) -> String:
	var body_transform := "translate(0 0)"
	var left_arm_svg := ""
	var right_arm_svg := ""
	var device_svg := ""
	var extra_svg := ""

	match pose_id:
		"idle":
			body_transform = "translate(0 2)"
			left_arm_svg = """<path d='M56 74L46 106' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='106' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70L116 102' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='116' cy='102' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M10 32L60 32L72 56L64 116L18 122L6 88L8 48Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M22 48L40 104' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='34' cy='74' r='12' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.76'/>
<path d='M110 24L140 30L134 68L102 60Z' fill='#8ff5de' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<circle cx='126' cy='34' r='14' fill='none' stroke='#d8fff6' stroke-width='4' opacity='0.62'/>"""
		"move_0":
			body_transform = "translate(-2 2) rotate(-2 78 88)"
			left_arm_svg = """<path d='M54 76L44 104' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='44' cy='104' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M106 68L120 98' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='120' cy='98' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M10 34L60 34L70 56L62 114L18 120L8 88L8 50Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M22 50L38 102' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<path d='M112 26L140 32L134 66L104 60Z' fill='#8ff5de' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>"""
		"move_1":
			body_transform = "translate(2 2) rotate(2 82 88)"
			left_arm_svg = """<path d='M58 74L50 108' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='50' cy='108' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M102 72L114 104' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='114' cy='104' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M12 32L62 32L72 56L64 118L20 122L10 90L10 48Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M24 48L42 102' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<path d='M108 22L138 30L132 68L102 60Z' fill='#8ff5de' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>"""
		"cast_0":
			body_transform = "translate(-2 2) rotate(-2 78 88)"
			left_arm_svg = """<path d='M56 74Q46 64 38 56' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='38' cy='56' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q118 62 130 56' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='130' cy='56' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M8 38L60 38L72 62L62 122L16 126L4 92L6 50Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M20 54L38 108' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='34' cy='80' r='12' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.80'/>
<path d='M112 22L142 30L136 70L104 62Z' fill='#8ff5de' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>"""
			extra_svg = """<path d='M128 54L148 54' stroke='#d8fff6' stroke-width='4' stroke-linecap='round' opacity='0.74'/>"""
		"cast_1":
			body_transform = "translate(0 2)"
			left_arm_svg = """<path d='M56 74Q42 68 26 68' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='26' cy='68' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q122 70 142 70' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='142' cy='70' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M4 34L62 34L76 58L66 122L16 126L0 92L2 48Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M20 50L40 112' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='34' cy='80' r='14' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.82'/>
<path d='M112 22L142 30L136 70L104 62Z' fill='#8ff5de' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<circle cx='126' cy='34' r='16' fill='none' stroke='#d8fff6' stroke-width='4' opacity='0.72'/>"""
			extra_svg = """<path d='M134 70L158 70' stroke='#d8fff6' stroke-width='4' stroke-linecap='round'/>
<circle cx='158' cy='70' r='8' fill='#8ff5de' opacity='0.30'/>"""
		"cast_2":
			body_transform = "translate(1 4)"
			left_arm_svg = """<path d='M56 74Q46 92 42 108' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='42' cy='108' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q118 88 132 100' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='132' cy='100' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M10 38L60 38L70 60L62 118L18 122L6 90L6 52Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M22 54L40 104' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='34' cy='78' r='12' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.74'/>
<path d='M110 24L138 30L132 66L104 60Z' fill='#8ff5de' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>"""
		"pulse_0":
			body_transform = "translate(-2 4)"
			left_arm_svg = """<path d='M56 74Q48 84 40 92' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='40' cy='92' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q114 84 122 94' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='122' cy='94' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M6 36L60 36L74 60L64 122L16 126L0 92L2 50Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M18 52L38 110' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='32' cy='80' r='12' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.76'/>"""
			extra_svg = """<circle cx='34' cy='80' r='24' fill='none' stroke='#8ff5de' stroke-width='4' opacity='0.34'/>"""
		"pulse_1":
			body_transform = "translate(0 4)"
			left_arm_svg = """<path d='M56 74Q42 88 28 96' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='28' cy='96' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70Q120 88 136 96' fill='none' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='136' cy='96' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M0 34L62 34L78 58L66 124L14 128L-2 92L0 48Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M18 50L40 114' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='32' cy='82' r='14' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.82'/>"""
			extra_svg = """<circle cx='32' cy='82' r='34' fill='none' stroke='#8ff5de' stroke-width='5' opacity='0.58'/>
<circle cx='32' cy='82' r='16' fill='#74edd0' opacity='0.18'/>
<path d='M48 82L88 82' stroke='#d8fff6' stroke-width='5' stroke-linecap='round' opacity='0.64'/>"""
		"pulse_2":
			body_transform = "translate(2 4)"
			left_arm_svg = """<path d='M56 74L46 110' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='46' cy='110' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			right_arm_svg = """<path d='M104 70L116 104' stroke='#112322' stroke-width='8' stroke-linecap='round'/>
<circle cx='116' cy='104' r='4.4' fill='#f1c4a3' stroke='#24141c' stroke-width='2.4'/>"""
			device_svg = """<path d='M8 38L58 38L70 60L62 118L18 122L4 90L6 52Z' fill='#b8fff2' stroke='#28524d' stroke-width='4' stroke-linejoin='round'/>
<path d='M22 54L40 104' stroke='#56d9be' stroke-width='4' stroke-linecap='round'/>
<circle cx='34' cy='80' r='12' fill='none' stroke='#e8fff8' stroke-width='4' opacity='0.72'/>"""
			extra_svg = """<path d='M40 82L112 82' stroke='#8ff5de' stroke-width='4' stroke-linecap='round' opacity='0.62'/>"""
		_:
			return _build_warden_pose_svg("idle")

	var body_svg := """<g transform='%s'>
<ellipse cx='80' cy='96' rx='38' ry='18' fill='#74edd0' opacity='0.12'/>
<circle cx='80' cy='82' r='34' fill='none' stroke='#d7fff4' stroke-width='4' opacity='0.24'/>
<path d='M80 28L102 42L112 70L114 122Q80 148 44 122L46 70L58 42Z' fill='#244f4b' stroke='#102624' stroke-width='6' stroke-linejoin='round'/>
<path d='M80 44L98 56L100 110Q80 128 60 114L60 58Z' fill='#102725'/>
<circle cx='80' cy='38' r='12' fill='#f1c4a3' stroke='#24141c' stroke-width='4'/>
<path d='M66 28Q80 12 94 28' fill='none' stroke='#d4fff2' stroke-width='6' stroke-linecap='round'/>
<rect x='58' y='76' width='44' height='18' rx='8' fill='#8ff5de' opacity='0.16'/>
<path d='M62 118L56 142' stroke='#56d9be' stroke-width='6' stroke-linecap='round'/>
<path d='M98 118L102 142' stroke='#56d9be' stroke-width='6' stroke-linecap='round'/>
<path d='M62 96L100 96' stroke='#8ff5de' stroke-width='6' stroke-linecap='round'/>
<circle cx='74' cy='38' r='2.6' fill='#140f14'/>
<circle cx='86' cy='38' r='2.6' fill='#140f14'/>
</g>""" % body_transform

	return """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
%s
%s
%s
%s
%s
</svg>""" % [left_arm_svg, body_svg, right_arm_svg, device_svg, extra_svg]
