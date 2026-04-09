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
const MAP_RULE_ZONE_SCRIPT := preload("res://scripts/map_rule_zone.gd")
const HUD_SCRIPT := preload("res://scripts/hud.gd")
const TITLE_SCREEN_SCRIPT := preload("res://scripts/title_screen.gd")
const AUDIO_SCRIPT := preload("res://scripts/game_audio.gd")
const HISTORY_SAVE_PATH := "user://run_records.cfg"
const DEFAULT_MASTER_VOLUME := 0.82
const MAX_RECENT_RUNS := 8
const RUN_MODE_NORMAL := "normal"
const RUN_MODE_HARD := "hard"
const RUN_MODE_ENDLESS := "endless"
const NORMAL_ENEMY_HEALTH_STEP := 1.0
const HARD_ENEMY_HEALTH_STEP := 1.5
const ENDLESS_ENEMY_HEALTH_STEP := 2.0
const MODE_BOSS_HEALTH_MULTIPLIER := 3.0
const MODE_BOSS_SHIELD_RATIO := 1.0 / 3.0
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
	{
		"id": "alchemist",
		"name": "炼金师",
		"title": "毒剂调配者",
		"summary": "依靠延时药剂、毒雾与催化反应控场，擅长把安全区变成持续压制区。",
		"detail": "初始技能为裂解瓶，后续可部署毒雾、喷射碎片，并把已铺开的毒区整段引爆。",
		"accent": Color(0.72, 0.92, 0.46),
	},
	{
		"id": "ranger",
		"name": "游侠",
		"title": "穿林猎手",
		"summary": "高机动远程角色，靠连射、散羽、回旋刃和穿林扫射不断拉扯战线。",
		"detail": "初始技能为穿针，移速更高、血量略低，适合边走边打和持续风筝。",
		"accent": Color(0.94, 0.84, 0.42),
	},
	{
		"id": "warden",
		"name": "守望者",
		"title": "共振壁垒",
		"summary": "使用脉冲、守卫与信标织出稳定火力网，适合守点和慢慢反压。",
		"detail": "初始技能为谐振脉冲，血量更高，后续可建立守卫环和中继信标。",
		"accent": Color(0.52, 0.96, 0.84),
	},
	{
		"id": "blood_hunter",
		"name": "血誓猎手",
		"title": "裂心追猎",
		"summary": "把残血与收割绑定在一起，靠烙印、血沼和穿心追猎不断滚节奏。",
		"detail": "初始技能为血誓箭，伤害会随缺失生命抬升；后续可补猎誓烙印、血潮沼与誓刃穿心。",
		"accent": Color(0.96, 0.28, 0.34),
	},
	{
		"id": "grave_caller",
		"name": "墓潮号手",
		"title": "尸钟调度者",
		"summary": "击杀会留下可调度的尸核，靠起灵、丧钟和合唱把残局变成下一轮火力。",
		"detail": "初始技能为挽歌，后续可起灵尸核、敲出丧钟脉冲，并把整片尸场拉成合唱线。",
		"accent": Color(0.62, 0.88, 0.78),
	},
	{
		"id": "illusionist",
		"name": "幻戏师",
		"title": "换幕操演者",
		"summary": "靠假身、镜射和换幕位移打乱怪潮路线，擅长用错位制造安全窗。",
		"detail": "初始技能为镜折弹，后续可留下残像、瞬换站位，并让多处假身同时开火。",
		"accent": Color(0.86, 0.72, 1.0),
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
	"flask": 7,
	"miasma": 4,
	"shardburst": 4,
	"catalyst": 4,
	"needle": 7,
	"volley": 4,
	"glaive": 4,
	"trail": 4,
	"pulse": 7,
	"ward": 4,
	"beacon": 4,
	"relay": 4,
	"oathshot": 7,
	"brand": 4,
	"bloodtrail": 4,
	"verdict": 4,
	"dirge": 7,
	"wake": 4,
	"toll": 4,
	"choir": 4,
	"mirrorbolt": 7,
	"afterimage": 4,
	"switchstep": 4,
	"prismdance": 4,
	"stride": 4,
	"vitality": 4,
	"focus": 4,
	"magnet": 4,
	"mastery": 4,
}
const CHARACTER_BUILD_PATHS := {
	"blade": [
		{
			"id": "blade_flame_wave",
			"name": "焰浪刀潮",
			"summary": "半圆挥击接火焰刀波推进，靠分裂与残月形成双波压线。",
			"focus": "优先补钢刃斩、残月斩和焰刃分裂。",
			"weights": {
				"slash": 3,
				"mooncut": 2,
				"mut_flame_split": 4,
				"mut_rend": 3,
				"focus": 1,
				"mastery": 1,
			},
		},
		{
			"id": "blade_execution",
			"name": "近身处决",
			"summary": "靠旋刀和踏空圆斩稳住贴脸，再用处决场清掉高压混编。",
			"focus": "优先补旋刀护环、踏空圆斩和处决场。",
			"weights": {
				"blade_ring": 3,
				"step_slash": 3,
				"mut_execution": 4,
				"vitality": 1,
				"stride": 1,
			},
		},
	],
	"thunder": [
		{
			"id": "thunder_chain",
			"name": "导电爆链",
			"summary": "连锁闪电和电荷爆裂做清场中继，超导回响负责滚雪球。",
			"focus": "优先补连锁闪电、电荷爆裂和超导回响。",
			"weights": {
				"chain": 3,
				"detonate": 3,
				"mut_supercell": 4,
				"mastery": 1,
				"magnet": 1,
			},
		},
		{
			"id": "thunder_domain",
			"name": "雷域审判",
			"summary": "用雷球领域定点锁场，再靠雷霆进化压终局。",
			"focus": "优先补雷球领域、雷霆进化和聚焦镜片。",
			"weights": {
				"storm_orb": 3,
				"ascension": 4,
				"focus": 2,
				"vitality": 1,
			},
		},
	],
	"alchemist": [
		{
			"id": "acid_bloom",
			"name": "腐蚀蒸腾",
			"summary": "用裂解瓶铺开毒雾，再靠催化反应把站场区域整段炸开。",
			"focus": "优先补裂解瓶、毒雾催化和聚焦镜片。",
			"weights": {
				"flask": 3,
				"miasma": 3,
				"catalyst": 3,
				"focus": 1,
				"mastery": 1,
			},
		},
		{
			"id": "glass_reaction",
			"name": "玻璃连爆",
			"summary": "利用碎片喷射和瓶爆做中距离压制，节奏更主动，更适合走打。",
			"focus": "优先补裂解瓶、碎片喷射、催化反应和机动属性。",
			"weights": {
				"flask": 2,
				"shardburst": 3,
				"catalyst": 3,
				"stride": 1,
				"mastery": 1,
			},
		},
	],
	"ranger": [
		{
			"id": "ranger_volley",
			"name": "穿林快弦",
			"summary": "用穿针和散羽稳住清线，再以扫线技能维持安全距离。",
			"focus": "优先补穿针、散羽齐射、穿林迹和步幅矩阵。",
			"weights": {
				"needle": 3,
				"volley": 3,
				"trail": 3,
				"stride": 2,
				"focus": 1,
			},
		},
		{
			"id": "ranger_hunt",
			"name": "回旋狩线",
			"summary": "以回旋刃处理关键目标，再靠穿林扫射撕开追兵阵型。",
			"focus": "优先补穿针、回旋刃、穿林迹和战斗精通。",
			"weights": {
				"needle": 2,
				"glaive": 3,
				"trail": 3,
				"mastery": 1,
				"focus": 1,
			},
		},
	],
	"warden": [
		{
			"id": "warden_bastion",
			"name": "共振壁垒",
			"summary": "以谐振脉冲和守卫环稳住近身，再用中继线补足站场压制。",
			"focus": "优先补谐振脉冲、守卫环、中继线和生命编织。",
			"weights": {
				"pulse": 3,
				"ward": 3,
				"relay": 3,
				"vitality": 1,
				"mastery": 1,
			},
		},
		{
			"id": "warden_signal",
			"name": "灯塔压场",
			"summary": "用信标把战区钉住，再让脉冲与中继线不断补压。",
			"focus": "优先补谐振脉冲、回声信标、中继线和聚焦镜片。",
			"weights": {
				"pulse": 2,
				"beacon": 3,
				"relay": 3,
				"focus": 1,
				"stride": 1,
			},
		},
	],
	"blood_hunter": [
		{
			"id": "hunter_execution",
			"name": "裂心追猎",
			"summary": "先用烙印锁定关键目标，再靠穿心斩线把整列敌人直接处决。",
			"focus": "优先补猎誓烙印、誓刃穿心和聚焦镜片。",
			"weights": {
				"brand": 3,
				"verdict": 3,
				"oathshot": 2,
				"focus": 1,
				"stride": 1,
			},
		},
		{
			"id": "hunter_tide",
			"name": "血潮回收",
			"summary": "用血誓箭和血沼把战场磨成回收区，越低血越像在压榨整张地图。",
			"focus": "优先补血誓箭、血潮沼、猎誓烙印和战斗精要。",
			"weights": {
				"oathshot": 3,
				"bloodtrail": 3,
				"brand": 2,
				"mastery": 1,
				"vitality": 1,
			},
		},
	],
	"grave_caller": [
		{
			"id": "grave_harvest",
			"name": "葬潮回收",
			"summary": "把击杀留下的尸核重新调度成下一波爆发，越打残局越厚。",
			"focus": "优先补起灵、丧钟、挽歌和战斗精要。",
			"weights": {
				"wake": 3,
				"toll": 3,
				"dirge": 2,
				"mastery": 1,
				"vitality": 1,
			},
		},
		{
			"id": "grave_choir",
			"name": "尸钟合唱",
			"summary": "让尸核同时起唱，远近火力会从多个落点同时压进来。",
			"focus": "优先补挽歌、合唱、起灵和聚焦镜片。",
			"weights": {
				"dirge": 3,
				"choir": 3,
				"wake": 2,
				"focus": 1,
				"magnet": 1,
			},
		},
	],
	"illusionist": [
		{
			"id": "illusion_mirror",
			"name": "镜廊齐射",
			"summary": "把残像变成多点火力源，让同一轮镜弹从多个位置同时开火。",
			"focus": "优先补镜折弹、残像、棱镜舞台和战斗精要。",
			"weights": {
				"mirrorbolt": 3,
				"afterimage": 3,
				"prismdance": 2,
				"mastery": 1,
				"focus": 1,
			},
		},
		{
			"id": "illusion_stage",
			"name": "换幕戏法",
			"summary": "不断换位和借假身转幕，把追兵和火线都导向错误方向。",
			"focus": "优先补残像、换幕步、棱镜舞台和步幅矩阵。",
			"weights": {
				"afterimage": 2,
				"switchstep": 3,
				"prismdance": 3,
				"stride": 1,
				"focus": 1,
			},
		},
	],
	"caster": [
		{
			"id": "caster_orbit",
			"name": "环轨新星",
			"summary": "环轨护体叠出近身安全区，再用新星爆发清空身边怪群。",
			"focus": "优先补环轨核心、新星爆发和轨道新星。",
			"weights": {
				"orbit": 3,
				"nova": 3,
				"mut_nova_orbit": 4,
				"vitality": 1,
			},
		},
		{
			"id": "caster_control",
			"name": "雷暴控场",
			"summary": "奥术箭负责收线，雷暴牵引和奇点负责压缩战场。",
			"focus": "优先补奥术箭、雷暴牵引和雷暴奇点。",
			"weights": {
				"bolt": 2,
				"storm": 3,
				"mut_singularity": 4,
				"focus": 1,
				"mastery": 1,
			},
		},
	],
}
const BUILD_ROUTE_TARGETS := {
	"bolt": 4,
	"orbit": 3,
	"nova": 3,
	"storm": 3,
	"slash": 4,
	"blade_ring": 3,
	"mooncut": 3,
	"step_slash": 3,
	"chain": 4,
	"detonate": 3,
	"storm_orb": 3,
	"ascension": 1,
	"flask": 4,
	"miasma": 3,
	"shardburst": 3,
	"catalyst": 3,
	"needle": 4,
	"volley": 3,
	"glaive": 3,
	"trail": 3,
	"pulse": 4,
	"ward": 3,
	"beacon": 3,
	"relay": 3,
	"oathshot": 4,
	"brand": 3,
	"bloodtrail": 3,
	"verdict": 3,
	"dirge": 4,
	"wake": 3,
	"toll": 3,
	"choir": 3,
	"mirrorbolt": 4,
	"afterimage": 3,
	"switchstep": 3,
	"prismdance": 3,
	"stride": 2,
	"vitality": 2,
	"focus": 2,
	"magnet": 2,
	"mastery": 2,
	"mut_flame_split": 1,
	"mut_rend": 1,
	"mut_execution": 1,
	"mut_nova_orbit": 1,
	"mut_singularity": 1,
	"mut_supercell": 1,
}
const ENDGAME_EVOLUTION_DEFINITIONS := {
	"blade_flame_wave": [
		{
			"key": "evo_blade_crimson_tide",
			"title": "终局分叉: 赤潮推进",
			"desc": "火焰刀气推进长度和宽度暴涨，分裂层数 +1，贯穿衰减底线抬到 55%。",
			"tags": ["终局", "火焰", "推进"],
			"combo": "把焰浪刀潮彻底做成正面推进波。",
			"accent": Color(1.0, 0.72, 0.42),
		},
		{
			"key": "evo_blade_pyre_forks",
			"title": "终局分叉: 焚线散华",
			"desc": "每次钢刃斩额外甩出两道斜向副刀潮，前场形成完整扇面火网。",
			"tags": ["终局", "火焰", "分叉"],
			"combo": "把单向推进改成扇面扫图。",
			"accent": Color(1.0, 0.84, 0.56),
		},
	],
	"blade_execution": [
		{
			"key": "evo_blade_execution_storm",
			"title": "终局分叉: 处决风暴",
			"desc": "踏空圆斩必定追加处决场，范围和伤害继续抬升，冷却进一步压低。",
			"tags": ["终局", "处决", "爆发"],
			"combo": "把近身处决路线变成连续处刑机器。",
			"accent": Color(1.0, 0.90, 0.62),
		},
		{
			"key": "evo_blade_ring_dominion",
			"title": "终局分叉: 旋刃领域",
			"desc": "旋刀数量、半径和伤害大幅提高，贴身区域会变成持续切割禁区。",
			"tags": ["终局", "旋刀", "领域"],
			"combo": "让站场路线真正拥有贴身领域。",
			"accent": Color(0.92, 0.96, 1.0),
		},
	],
	"thunder_chain": [
		{
			"key": "evo_thunder_arc_net",
			"title": "终局分叉: 电网追猎",
			"desc": "连锁闪电命中后会从末端再续出一轮迷你追击电链。",
			"tags": ["终局", "连锁", "追击"],
			"combo": "把导电爆链做成滚动扩散的整片电网。",
			"accent": Color(0.74, 0.92, 1.0),
		},
		{
			"key": "evo_thunder_blast_relay",
			"title": "终局分叉: 爆裂继电",
			"desc": "电荷爆裂半径更大，并固定触发缩小版雷暴追击。",
			"tags": ["终局", "爆裂", "雷暴"],
			"combo": "让爆点本身变成新的雷暴中继。",
			"accent": Color(0.92, 0.98, 1.0),
		},
	],
	"thunder_domain": [
		{
			"key": "evo_thunder_orb_overclock",
			"title": "终局分叉: 雷域过载",
			"desc": "雷球持续更久、脉冲更密、每次脉冲的连锁上限继续提高。",
			"tags": ["终局", "雷域", "过载"],
			"combo": "把雷球领域推成主场控图核心。",
			"accent": Color(0.82, 0.94, 1.0),
		},
		{
			"key": "evo_thunder_storm_core",
			"title": "终局分叉: 风暴核",
			"desc": "每次雷球脉冲都会追加一次缩小版雷暴打击，落点会自己清场。",
			"tags": ["终局", "雷域", "雷暴"],
			"combo": "让雷球领域自己生成雷暴核心。",
			"accent": Color(0.96, 0.96, 0.74),
		},
	],
	"caster_orbit": [
		{
			"key": "evo_caster_orbit_overload",
			"title": "终局分叉: 环轨过载",
			"desc": "环轨卫星数量、转速和伤害大幅提高，近身区域进入持续切割状态。",
			"tags": ["终局", "环轨", "护体"],
			"combo": "把环轨新星做成真正的近身绞盘。",
			"accent": Color(0.70, 0.98, 0.90),
		},
		{
			"key": "evo_caster_supernova_lattice",
			"title": "终局分叉: 超新星阵列",
			"desc": "新星投射物暴增，冷却压低，爆发密度和范围同步拉满。",
			"tags": ["终局", "新星", "爆发"],
			"combo": "让新星爆发成为一轮一轮的终局清屏。",
			"accent": Color(1.0, 0.84, 0.46),
		},
	],
	"caster_control": [
		{
			"key": "evo_caster_tempest_network",
			"title": "终局分叉: 风暴网络",
			"desc": "每次雷暴命中后都会再连出两段追击电链，专门收掉外围漏怪。",
			"tags": ["终局", "雷暴", "连锁"],
			"combo": "让控场路线在团控外补上远端追杀。",
			"accent": Color(0.80, 0.92, 1.0),
		},
		{
			"key": "evo_caster_singularity_prison",
			"title": "终局分叉: 奇点牢笼",
			"desc": "雷暴落点会追加延迟二段爆轰和更强牵引，把怪团直接锁死在原地。",
			"tags": ["终局", "奇点", "控场"],
			"combo": "把雷暴控场进化成完整的囚笼打法。",
			"accent": Color(0.88, 0.90, 1.0),
		},
	],
	"hunter_execution": [
		{
			"key": "evo_hunter_verdict_gallows",
			"title": "终局分叉: 绞决长廊",
			"desc": "誓刃穿心会追加两道交叉副刃，处决被烙印目标后大幅返还冷却。",
			"tags": ["终局", "处决", "血契"],
			"combo": "把裂心追猎推成一轮一轮的处决走廊。",
			"accent": Color(1.0, 0.78, 0.82),
		},
		{
			"key": "evo_hunter_blood_quarry",
			"title": "终局分叉: 血猎回声",
			"desc": "烙印击杀会朝周围目标自动再放出一轮血誓箭，并扩散次级烙印。",
			"tags": ["终局", "追猎", "收割"],
			"combo": "把单点收头滚成一片片连锁猎杀。",
			"accent": Color(0.98, 0.56, 0.62),
		},
	],
	"hunter_tide": [
		{
			"key": "evo_hunter_crimson_delta",
			"title": "终局分叉: 赤潮三角洲",
			"desc": "血潮沼半径更大、脉冲更密，被命中的敌人会被反复刻上烙印。",
			"tags": ["终局", "血潮", "铺场"],
			"combo": "把回收区扩成真正的整片血线交换场。",
			"accent": Color(0.92, 0.40, 0.46),
		},
		{
			"key": "evo_hunter_harvest_run",
			"title": "终局分叉: 收血奔袭",
			"desc": "烙印击杀会留下迷你血沼并追加追猎箭，越滚越快。",
			"tags": ["终局", "回收", "滚雪球"],
			"combo": "让血潮路线从慢磨变成高速连收。",
			"accent": Color(1.0, 0.68, 0.72),
		},
	],
	"grave_harvest": [
		{
			"key": "evo_grave_wake_engine",
			"title": "终局分叉: 回生引擎",
			"desc": "起灵与丧钟消耗的尸核会回生成弱化尸核，尸场循环不会断档。",
			"tags": ["终局", "尸核", "回生"],
			"combo": "把葬潮回收推成自我续航的尸核引擎。",
			"accent": Color(0.78, 0.98, 0.90),
		},
		{
			"key": "evo_grave_tide_bell",
			"title": "终局分叉: 丧钟潮线",
			"desc": "丧钟每次敲响都会额外放出追魂挽歌，并抬高尸核上限。",
			"tags": ["终局", "丧钟", "追魂"],
			"combo": "让控场钟声自己变成新一轮火力源。",
			"accent": Color(0.62, 0.94, 0.86),
		},
	],
	"grave_choir": [
		{
			"key": "evo_grave_cathedral",
			"title": "终局分叉: 尸钟圣堂",
			"desc": "尸钟合唱会借用全部尸核与本体同时齐射，合唱面积极大扩张。",
			"tags": ["终局", "合唱", "齐射"],
			"combo": "把尸钟合唱推成真正的多点炮阵。",
			"accent": Color(0.90, 1.0, 0.96),
		},
		{
			"key": "evo_grave_dirge_conductor",
			"title": "终局分叉: 挽歌指挥",
			"desc": "挽歌会借近身尸核继续分唱，尸核停留更久、数量更多。",
			"tags": ["终局", "挽歌", "调度"],
			"combo": "让指挥路线从平推变成层层续唱。",
			"accent": Color(0.74, 0.98, 0.92),
		},
	],
	"illusion_mirror": [
		{
			"key": "evo_illusion_kaleido_grid",
			"title": "终局分叉: 万华镜阵",
			"desc": "镜折弹和棱镜舞台会借用全部残像镜位，整张图会被拆成镜廊火网。",
			"tags": ["终局", "镜阵", "多点"],
			"combo": "把镜廊齐射推成满场镜位压制。",
			"accent": Color(0.92, 0.86, 1.0),
		},
		{
			"key": "evo_illusion_glass_bloom",
			"title": "终局分叉: 碎镜繁花",
			"desc": "镜折弹和棱镜舞台的弹体命中后会继续裂成次级镜片。",
			"tags": ["终局", "碎镜", "分裂"],
			"combo": "让镜射从整齐齐射变成密集繁花。",
			"accent": Color(0.98, 0.92, 1.0),
		},
	],
	"illusion_stage": [
		{
			"key": "evo_illusion_stage_heist",
			"title": "终局分叉: 换幕劫场",
			"desc": "换幕步在原地与落点都会留新残像，冷却明显缩短。",
			"tags": ["终局", "换位", "戏法"],
			"combo": "把换幕戏法推进成高频错位劫场。",
			"accent": Color(0.86, 0.78, 1.0),
		},
		{
			"key": "evo_illusion_prism_relay",
			"title": "终局分叉: 棱镜接力",
			"desc": "残像数量与持续时间暴涨，换位后会立刻追打一轮镜射。",
			"tags": ["终局", "残像", "接力"],
			"combo": "让舞台路线变成整场都在接力换幕。",
			"accent": Color(0.94, 0.88, 1.0),
		},
	],
}
const THREAT_PHASE_TIMES := [60.0, 180.0, 300.0, 420.0, 540.0]
const THREAT_PHASE_LABELS := [
	"00:00-01:00 清杂兵",
	"01:00-03:00 冲脸压迫",
	"03:00-05:00 精英压迫",
	"05:00-07:00 地图机制",
	"07:00-09:00 高压混编",
	"09:00+ 首领前夜",
]
const THREAT_PHASE_MESSAGES := [
	"杂兵潮正在成型，先稳住刷怪节奏。",
	"01:00 冲脸兵入场，开始用走位拆突进。",
	"03:00 第一次精英压迫开始，优先清高威胁目标。",
	"05:00 地图规则启动，战场会主动逼你换决策。",
	"07:00 高压混编开始，远程、控场和精英会一起压上来。",
	"09:00 首领前夜，准备迎接最后的高压混战。",
]
const ENDLESS_WORLD_MUTATIONS := [
	{
		"id": "stormfront",
		"name": "世界变异: 风暴前线",
		"summary": "敌群刷新更快，倍率提升。",
		"spawn_bonus": 0.55,
		"score_bonus": 0.25,
	},
	{
		"id": "hunters_mark",
		"name": "世界变异: 猎杀指令",
		"summary": "精英出现率大增，倍率继续上扬。",
		"elite_bonus": 0.08,
		"score_bonus": 0.22,
	},
	{
		"id": "hazard_bloom",
		"name": "世界变异: 灾厄扩散",
		"summary": "地图规则更频繁，危险也更值分。",
		"hazard_bonus": 0.22,
		"score_bonus": 0.20,
	},
	{
		"id": "predator_step",
		"name": "世界变异: 捕食步调",
		"summary": "敌人移动更快，压迫更强。",
		"speed_bonus": 0.12,
		"score_bonus": 0.18,
	},
	{
		"id": "titan_blood",
		"name": "世界变异: 泰坦血性",
		"summary": "敌人与首领更耐打，首领循环更快。",
		"health_bonus": 0.18,
		"boss_scale": 0.90,
		"score_bonus": 0.30,
	},
]
const MAP_DEFINITIONS := [
	{
		"id": "sky_ruins",
		"name": "天穹遗迹",
		"tagline": "断裂桥道与残柱把战场切成多条高速通路，适合边打边护送。",
		"description": "幽羽与枪骑会沿桥边夹击，你需要贴近浮空信标，把它一路护送到终点。",
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
			{"until": 220.0, "weights": {"wisp": 0.68, "lancer": 0.22, "seer": 0.10}},
			{"until": 360.0, "weights": {"wisp": 0.50, "lancer": 0.32, "seer": 0.18}},
			{"until": 500.0, "weights": {"wisp": 0.34, "lancer": 0.42, "seer": 0.24}},
			{"until": 999.0, "weights": {"wisp": 0.20, "lancer": 0.52, "seer": 0.28}},
		],
	},
	{
		"id": "ember_forge",
		"name": "余烬熔炉",
		"tagline": "炉墙与矿渣槽把战区压缩成沉重而狭长的走廊，逼你反复断路。",
		"description": "蛮铠与烬术师会逼你绕掩体转火，而你要穿切导热线，把整段热路彻底切断。",
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
			{"until": 260.0, "weights": {"brute": 0.66, "embermage": 0.34}},
			{"until": 420.0, "weights": {"brute": 0.52, "embermage": 0.48}},
			{"until": 560.0, "weights": {"brute": 0.40, "embermage": 0.60}},
			{"until": 999.0, "weights": {"brute": 0.28, "embermage": 0.72}},
		],
	},
	{
		"id": "void_marsh",
		"name": "虚沼祭坛",
		"tagline": "祭坛与芦苇滩会不断迫使你改线，适合把敌群诱进爆点。",
		"description": "先知与泥沼兽会拉扯节奏，而你要把敌群带进诱爆孢核，借整片沼泽反压。",
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
			{"until": 250.0, "weights": {"seer": 0.78, "mireling": 0.22}},
			{"until": 390.0, "weights": {"seer": 0.64, "mireling": 0.36}},
			{"until": 540.0, "weights": {"seer": 0.50, "mireling": 0.50}},
			{"until": 999.0, "weights": {"seer": 0.36, "mireling": 0.64}},
		],
	},
	{
		"id": "prism_archive",
		"name": "棱镜档案馆",
		"tagline": "折光书架、镜轨与晶簇会把战线切成明暗交错的细长通路，逼你站位连线。",
		"description": "折光侍从与棱镜哨会逼你不断换位，而你要把自己当中继，连起两端棱镜。",
		"intro": "档案馆的镜面正逐层亮起，折光轨道开始锁定你的路线。",
		"terrain_hint": "晶簇和档案架会制造斜角卡位，既能挡住追兵，也会切断你自己的直线火力。",
		"boss_name": "折光典狱官",
		"boss_archetype": "storm_archon",
		"boss_summon_type": "seer",
		"enemy_labels": ["折光侍从", "棱镜哨"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.10,
		"enemy_cap_bonus": 2,
		"hazard_type": "prism_lance",
		"hazard_interval": Vector2(4.8, 7.0),
		"palette": {
			"style_id": "prism_archive",
			"ground_dark": Color(0.04, 0.05, 0.08),
			"ground_mid": Color(0.10, 0.13, 0.20),
			"line_color": Color(0.28, 0.36, 0.46, 0.54),
			"rune_color": Color(0.56, 0.88, 1.0, 0.18),
			"ember_color": Color(0.92, 0.96, 1.0, 0.12),
			"accent_color": Color(0.78, 0.94, 1.0, 0.20),
		},
		"waves": [
			{"until": 110.0, "weights": {"seer": 0.66, "wisp": 0.34}},
			{"until": 250.0, "weights": {"seer": 0.48, "wisp": 0.34, "lancer": 0.18}},
			{"until": 420.0, "weights": {"seer": 0.36, "wisp": 0.30, "lancer": 0.34}},
			{"until": 560.0, "weights": {"seer": 0.28, "wisp": 0.22, "lancer": 0.50}},
			{"until": 999.0, "weights": {"seer": 0.24, "wisp": 0.16, "lancer": 0.60}},
		],
	},
	{
		"id": "clockwork_garden",
		"name": "钟庭花园",
		"tagline": "齿轨、花坛与钟架让整张地图更像会转动的机械迷宫，节点争夺尤其关键。",
		"description": "庭园守卫会逼你沿着齿轨位移，而园丁会不断把你赶离正在抢占的节点。",
		"intro": "花坛下的齿轨开始咬合，整座庭园正在重新校准步频。",
		"terrain_hint": "钟架和花坛会制造长短不一的窄口，适合拉扯，但会让转向失误变得更致命。",
		"boss_name": "齿轮园丁",
		"boss_archetype": "forge_tyrant",
		"boss_summon_type": "brute",
		"enemy_labels": ["庭园守卫", "齿轮仆役"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.08,
		"enemy_cap_bonus": 0,
		"hazard_type": "gear_sweep",
		"hazard_interval": Vector2(5.0, 7.8),
		"palette": {
			"style_id": "clockwork_garden",
			"ground_dark": Color(0.07, 0.08, 0.05),
			"ground_mid": Color(0.14, 0.16, 0.10),
			"line_color": Color(0.34, 0.30, 0.18, 0.52),
			"rune_color": Color(0.88, 0.72, 0.38, 0.16),
			"ember_color": Color(0.70, 0.84, 0.56, 0.14),
			"accent_color": Color(0.94, 0.82, 0.44, 0.18),
		},
		"waves": [
			{"until": 120.0, "weights": {"brute": 0.64, "lancer": 0.36}},
			{"until": 260.0, "weights": {"brute": 0.52, "lancer": 0.28, "embermage": 0.20}},
			{"until": 420.0, "weights": {"brute": 0.40, "lancer": 0.32, "embermage": 0.28}},
			{"until": 560.0, "weights": {"brute": 0.30, "lancer": 0.34, "embermage": 0.36}},
			{"until": 999.0, "weights": {"brute": 0.24, "lancer": 0.30, "embermage": 0.46}},
		],
	},
	{
		"id": "bridge_train",
		"name": "断桥列车",
		"tagline": "崩塌桥段和车顶框架把战场切成会移动的连续短节，你得边打边跨车。",
		"description": "列车正在断桥上硬冲，怪潮会从裂口和车侧同时登上来；你要顺着高亮车节连续跨过去，稳住整列车的步频。",
		"intro": "铁轨在断桥边缘剧烈震颤，整列战车正被迫以危险速度冲关。",
		"terrain_hint": "长轨和窄桥让战场更线性，适合前后拉扯，但一旦卡在断节口就会被双侧包夹。",
		"boss_name": "断轨督军",
		"boss_archetype": "forge_tyrant",
		"boss_summon_type": "lancer",
		"enemy_labels": ["攀桥枪骑", "断节重卫"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.16,
		"enemy_cap_bonus": 4,
		"hazard_type": "",
		"palette": {
			"style_id": "bridge_train",
			"ground_dark": Color(0.05, 0.06, 0.08),
			"ground_mid": Color(0.10, 0.12, 0.16),
			"line_color": Color(0.30, 0.34, 0.42, 0.56),
			"rune_color": Color(0.78, 0.88, 1.0, 0.14),
			"ember_color": Color(1.0, 0.78, 0.44, 0.14),
			"accent_color": Color(0.92, 0.96, 1.0, 0.18),
		},
		"waves": [
			{"until": 120.0, "weights": {"lancer": 0.72, "wisp": 0.28}},
			{"until": 260.0, "weights": {"lancer": 0.50, "wisp": 0.24, "brute": 0.26}},
			{"until": 420.0, "weights": {"lancer": 0.42, "brute": 0.34, "embermage": 0.24}},
			{"until": 560.0, "weights": {"lancer": 0.30, "brute": 0.38, "embermage": 0.32}},
			{"until": 999.0, "weights": {"lancer": 0.24, "brute": 0.42, "embermage": 0.34}},
		],
	},
	{
		"id": "black_fog_hunt",
		"name": "黑雾狩场",
		"tagline": "视野被雾带切碎，只有被重新点亮的猎灯能给你一点短暂主动权。",
		"description": "夜猎者会借雾贴近，你得尽快点亮猎灯；一旦失去光域，整片战场会立刻反向偏向怪群。",
		"intro": "黑雾已经吞掉远处边界，只剩零散灯火还在风里晃动。",
		"terrain_hint": "狩径很窄，雾带和灯架会不断打断视线，逼你在短距离里快速换位。",
		"boss_name": "雾棺牧主",
		"boss_archetype": "void_matriarch",
		"boss_summon_type": "seer",
		"enemy_labels": ["夜猎者", "雾灯侍"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.10,
		"enemy_cap_bonus": 1,
		"hazard_type": "",
		"palette": {
			"style_id": "black_fog_hunt",
			"ground_dark": Color(0.03, 0.04, 0.05),
			"ground_mid": Color(0.08, 0.10, 0.12),
			"line_color": Color(0.18, 0.24, 0.26, 0.42),
			"rune_color": Color(0.82, 0.66, 0.42, 0.12),
			"ember_color": Color(1.0, 0.80, 0.54, 0.12),
			"accent_color": Color(0.94, 0.84, 0.58, 0.18),
		},
		"waves": [
			{"until": 120.0, "weights": {"wisp": 0.76, "seer": 0.24}},
			{"until": 260.0, "weights": {"wisp": 0.48, "seer": 0.30, "lancer": 0.22}},
			{"until": 420.0, "weights": {"seer": 0.40, "wisp": 0.24, "lancer": 0.36}},
			{"until": 560.0, "weights": {"seer": 0.34, "lancer": 0.34, "mireling": 0.32}},
			{"until": 999.0, "weights": {"seer": 0.28, "mireling": 0.40, "lancer": 0.32}},
		],
	},
	{
		"id": "airship_breach",
		"name": "空艇裂甲",
		"tagline": "甲板被炮火撕成多块斜切板，风压和破口会持续把你的站位往外推。",
		"description": "裂风兵会顺着甲板长线压上来，而你要顶着风压封住破口，不让整层甲板继续失压。",
		"intro": "舰体外板被轰开后，整片甲板开始向外漏风。",
		"terrain_hint": "长甲板和裂口会制造大量斜角通道，直线火力很舒服，但横向回转会更难受。",
		"boss_name": "裂甲提督",
		"boss_archetype": "storm_archon",
		"boss_summon_type": "embermage",
		"enemy_labels": ["裂风枪骑", "甲板咒手"],
		"boss_time": 600.0,
		"spawn_rate_bonus": 0.14,
		"enemy_cap_bonus": 3,
		"hazard_type": "",
		"palette": {
			"style_id": "airship_breach",
			"ground_dark": Color(0.05, 0.07, 0.10),
			"ground_mid": Color(0.10, 0.14, 0.18),
			"line_color": Color(0.28, 0.36, 0.44, 0.52),
			"rune_color": Color(0.56, 0.78, 1.0, 0.14),
			"ember_color": Color(0.84, 0.90, 1.0, 0.12),
			"accent_color": Color(0.80, 0.92, 1.0, 0.18),
		},
		"waves": [
			{"until": 120.0, "weights": {"lancer": 0.58, "embermage": 0.42}},
			{"until": 260.0, "weights": {"lancer": 0.40, "embermage": 0.34, "wisp": 0.26}},
			{"until": 420.0, "weights": {"lancer": 0.32, "embermage": 0.40, "seer": 0.28}},
			{"until": 560.0, "weights": {"lancer": 0.24, "embermage": 0.42, "seer": 0.34}},
			{"until": 999.0, "weights": {"embermage": 0.44, "seer": 0.30, "lancer": 0.26}},
		],
	},
]
const CONTRACT_SPAWN_TIMES := [135.0, 300.0, 465.0]
const CONTRACT_DEFINITIONS := [
	{
		"id": "contract_crimson_clause",
		"title": "猩红条款",
		"desc": "生命上限 -2，但法术威力和得分倍率明显抬升。",
		"detail": "把容错换成稳定输出，是最直接的压血契约。",
		"accent": Color(0.96, 0.34, 0.40),
		"effects": {
			"max_health_penalty": 2,
			"spell_power_bonus": 0.18,
			"score_bonus": 0.18,
		},
	},
	{
		"id": "contract_clock_debt",
		"title": "时钟负债",
		"desc": "全技能冷却更紧，移速更快，但灾害与地图压迫也会更频繁。",
		"detail": "适合敢抢节奏、敢顶风险的构筑。",
		"accent": Color(0.74, 0.90, 1.0),
		"effects": {
			"cooldown_scale": 0.86,
			"speed_bonus": 0.10,
			"hazard_bonus": 0.18,
		},
	},
	{
		"id": "contract_grave_dividend",
		"title": "墓息分红",
		"desc": "经验和拾取范围上扬，但敌人整体生命也会更厚。",
		"detail": "把刷成长的效率推高，同时让清怪门槛更扎实。",
		"accent": Color(0.68, 0.96, 0.88),
		"effects": {
			"xp_bonus": 0.18,
			"pickup_bonus": 36.0,
			"enemy_health_bonus": 0.16,
		},
	},
	{
		"id": "contract_hunter_ledger",
		"title": "猎账本",
		"desc": "精英更常出现且额外带一层词缀，但会给出更高得分。",
		"detail": "适合想把局内压迫换成高收益的高手局。",
		"accent": Color(1.0, 0.82, 0.52),
		"effects": {
			"elite_spawn_bonus": 0.06,
			"elite_affix_bonus": 1,
			"score_bonus": 0.22,
		},
	},
	{
		"id": "contract_glass_stride",
		"title": "玻璃步频",
		"desc": "移速和经验收益更高，但生命上限再降 1 点。",
		"detail": "让风筝路线更凶，也更容易被一波带走。",
		"accent": Color(0.92, 0.92, 1.0),
		"effects": {
			"max_health_penalty": 1,
			"speed_bonus": 0.16,
			"xp_bonus": 0.12,
		},
	},
	{
		"id": "contract_void_margin",
		"title": "虚域保证金",
		"desc": "法术威力和冷却双抬升，但敌人也会更快、更硬。",
		"detail": "纯粹把整局拉成高压高速交换。",
		"accent": Color(0.84, 0.76, 1.0),
		"effects": {
			"spell_power_bonus": 0.14,
			"cooldown_scale": 0.92,
			"enemy_health_bonus": 0.10,
			"enemy_speed_bonus": 0.08,
		},
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
var _threat_phase: int = 0
var _pressure_wave_timer: float = 0.0
var _map_rule_active: bool = false
var _map_rule_timer: float = 0.0
var _ruins_altar_zone: MapRuleZone = null
var _ruins_altar_destination_zone: MapRuleZone = null
var _ruins_altar_progress: float = 0.0
var _ruins_escort_route_length: float = 0.0
var _ruins_altar_respawn_timer: float = 0.0
var _ruins_altar_buff_timer: float = 0.0
var _forge_core_zone: MapRuleZone = null
var _forge_cut_target_zone: MapRuleZone = null
var _forge_core_progress: float = 0.0
var _forge_core_respawn_timer: float = 0.0
var _forge_overdrive_timer: float = 0.0
var _forge_cut_crossings: int = 0
var _forge_cut_required_crossings: int = 0
var _forge_cut_cross_cooldown: float = 0.0
var _forge_cut_visual_timer: float = 0.0
var _void_pool_timer: float = 0.0
var _void_pools: Array[Dictionary] = []
var _void_spore_zone: MapRuleZone = null
var _void_spore_progress: float = 0.0
var _void_spore_respawn_timer: float = 0.0
var _void_spore_blessing_timer: float = 0.0
var _prism_focus_zone: MapRuleZone = null
var _prism_link_target_zone: MapRuleZone = null
var _prism_focus_progress: float = 0.0
var _prism_focus_respawn_timer: float = 0.0
var _prism_overcharge_timer: float = 0.0
var _prism_link_visual_timer: float = 0.0
var _clock_node_zone: MapRuleZone = null
var _clock_node_progress: float = 0.0
var _clock_node_respawn_timer: float = 0.0
var _clock_overdrive_timer: float = 0.0
var _train_car_zones: Array[MapRuleZone] = []
var _train_car_progress: float = 0.0
var _train_car_respawn_timer: float = 0.0
var _train_car_active_index: int = 0
var _train_rush_timer: float = 0.0
var _train_car_move_direction: Vector2 = Vector2.RIGHT
var _fog_brazier_zone: MapRuleZone = null
var _fog_brazier_progress: float = 0.0
var _fog_brazier_respawn_timer: float = 0.0
var _fog_light_timer: float = 0.0
var _fog_pulse_timer: float = 0.0
var _airship_breach_zone: MapRuleZone = null
var _airship_breach_progress: float = 0.0
var _airship_breach_respawn_timer: float = 0.0
var _airship_tailwind_timer: float = 0.0
var _airship_gust_timer: float = 0.0
var _airship_gust_direction: Vector2 = Vector2.RIGHT
var _boss_prelude_stage: int = 0
var _score: int = 0
var _score_bonus_multiplier: float = 0.0
var _pickup_heat_bonus: float = 0.0
var _pickup_heat_timer: float = 0.0
var _world_mutation_index: int = 0
var _next_world_mutation_time: float = 180.0
var _active_world_mutations: Array[String] = []
var _mode_scaling_minute: int = 0
var _last_spawned_enemy_health: int = 0
var _endless_spawn_bonus: float = 0.0
var _endless_elite_bonus: float = 0.0
var _endless_enemy_speed_bonus: float = 0.0
var _endless_enemy_health_bonus: float = 0.0
var _endless_hazard_bonus: float = 0.0
var _endless_boss_interval_scale: float = 1.0
var _contract_spawn_index: int = 0
var _contract_zone: MapRuleZone = null
var _contract_zone_progress: float = 0.0
var _choice_context: String = "upgrade"
var _choice_panel_title: String = "选择一项联动组件"
var _choice_panel_subtitle: String = ""
var _active_contract_ids: Array[String] = []
var _contract_spell_power_bonus: float = 0.0
var _contract_speed_bonus: float = 0.0
var _contract_xp_bonus: float = 0.0
var _contract_score_bonus: float = 0.0
var _contract_cooldown_scale: float = 1.0
var _contract_pickup_bonus: float = 0.0
var _contract_max_health_penalty: int = 0
var _contract_enemy_health_bonus: float = 0.0
var _contract_enemy_speed_bonus: float = 0.0
var _contract_elite_spawn_bonus: float = 0.0
var _contract_elite_affix_bonus: int = 0
var _contract_hazard_bonus: float = 0.0
var _train_break_index: int = -1
var _fog_fake_brazier_zone: MapRuleZone = null
var _fog_fake_brazier_progress: float = 0.0
var _airship_breach_drift_direction: Vector2 = Vector2.ZERO

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
var _nova_orbit_mutation: bool = false
var _storm_singularity_mutation: bool = false
var _chain_level: int = 1
var _detonate_level: int = 0
var _storm_orb_level: int = 0
var _ascension_level: int = 0
var _supercell_mutation: bool = false
var _flask_level: int = 1
var _miasma_level: int = 0
var _shardburst_level: int = 0
var _catalyst_level: int = 0
var _needle_level: int = 1
var _volley_level: int = 0
var _glaive_level: int = 0
var _trail_level: int = 0
var _pulse_level: int = 1
var _ward_level: int = 0
var _beacon_level: int = 0
var _relay_level: int = 0
var _oathshot_level: int = 1
var _brand_level: int = 0
var _bloodtrail_level: int = 0
var _verdict_level: int = 0
var _dirge_level: int = 1
var _wake_level: int = 0
var _toll_level: int = 0
var _choir_level: int = 0
var _mirrorbolt_level: int = 1
var _afterimage_level: int = 0
var _switchstep_level: int = 0
var _prismdance_level: int = 0

var _bolt_timer: float = 0.0
var _nova_timer: float = 1.4
var _storm_timer: float = 3.0
var _slash_timer: float = 0.0
var _mooncut_timer: float = 1.2
var _step_slash_timer: float = 2.4
var _chain_timer: float = 0.0
var _storm_orb_timer: float = 1.8
var _flask_timer: float = 0.0
var _miasma_timer: float = 1.0
var _shardburst_timer: float = 1.8
var _catalyst_timer: float = 3.0
var _needle_timer: float = 0.0
var _volley_timer: float = 1.0
var _glaive_timer: float = 1.8
var _trail_timer: float = 2.6
var _pulse_timer: float = 0.2
var _beacon_timer: float = 1.4
var _relay_timer: float = 2.0
var _oathshot_timer: float = 0.0
var _brand_timer: float = 1.2
var _bloodtrail_timer: float = 1.8
var _verdict_timer: float = 2.2
var _dirge_timer: float = 0.0
var _wake_timer: float = 1.4
var _toll_timer: float = 2.2
var _choir_timer: float = 2.6
var _mirrorbolt_timer: float = 0.0
var _afterimage_timer: float = 1.4
var _switchstep_timer: float = 2.4
var _prismdance_timer: float = 3.0
var _selected_endgame_branches: Dictionary = {}
var _touch_move_vector: Vector2 = Vector2.ZERO
var _touch_pointer_id: int = -1
var _touch_pointer_origin: Vector2 = Vector2.ZERO
var _touch_mouse_active: bool = false
var _player_previous_position: Vector2 = PLAYER_START
var _dot_damage_buffers: Dictionary = {}
var _thunder_orb_field: Node2D = null
var _alchemist_clouds: Array[PoisonCloudHazard] = []
var _warden_beacon_field: LightningOrbField = null
var _blood_marks: Dictionary = {}
var _blood_trails: Array[Dictionary] = []
var _grave_tokens: Array[Dictionary] = []
var _illusion_decoys: Array[Dictionary] = []

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

	_update_run_pacing(delta)
	_update_contract_points(delta)
	_update_special_character_state(delta)
	_update_spell_attacks(delta)
	_update_environment_hazards(delta)
	_update_boss_warning_and_prelude()

	if not _boss_spawned and _run_time >= _get_boss_spawn_time():
		_spawn_boss()

	_spawn_regular_enemies()

	if _cleanup_timer >= 1.25:
		_cleanup_timer = 0.0
		_cleanup_far_entities()

	if _hud_refresh_timer >= 0.12:
		_hud_refresh_timer = 0.0
		_update_hud()

	if _player != null and is_instance_valid(_player):
		_player_previous_position = _player.global_position


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
	_player_previous_position = PLAYER_START
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
	_player_previous_position = PLAYER_START
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
	_alchemist_clouds.clear()
	_warden_beacon_field = null
	_blood_marks.clear()
	_blood_trails.clear()
	_grave_tokens.clear()
	_illusion_decoys.clear()
	_ruins_altar_zone = null
	_ruins_altar_destination_zone = null
	_forge_core_zone = null
	_forge_cut_target_zone = null
	_void_pools.clear()
	_void_spore_zone = null
	_prism_focus_zone = null
	_prism_link_target_zone = null
	_clock_node_zone = null
	_train_car_zones.clear()
	_fog_brazier_zone = null
	_fog_fake_brazier_zone = null
	_airship_breach_zone = null
	_contract_zone = null
	if _player != null and is_instance_valid(_player):
		_player.set_move_speed_multiplier(1.0)


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
	_score = 0
	_score_bonus_multiplier = 0.0
	_pickup_heat_bonus = 0.0
	_pickup_heat_timer = 0.0
	_threat_phase = 0
	_pressure_wave_timer = 8.0
	_map_rule_active = false
	_map_rule_timer = 0.0
	_ruins_altar_progress = 0.0
	_ruins_escort_route_length = 0.0
	_ruins_altar_respawn_timer = 0.0
	_ruins_altar_buff_timer = 0.0
	_forge_core_progress = 0.0
	_forge_core_respawn_timer = 14.0
	_forge_overdrive_timer = 0.0
	_forge_cut_crossings = 0
	_forge_cut_required_crossings = 0
	_forge_cut_cross_cooldown = 0.0
	_forge_cut_visual_timer = 0.0
	_void_pool_timer = 6.0
	_void_pools.clear()
	_void_spore_progress = 0.0
	_void_spore_respawn_timer = 18.0
	_void_spore_blessing_timer = 0.0
	_prism_focus_progress = 0.0
	_prism_focus_respawn_timer = 12.0
	_prism_overcharge_timer = 0.0
	_prism_link_visual_timer = 0.0
	_clock_node_progress = 0.0
	_clock_node_respawn_timer = 12.0
	_clock_overdrive_timer = 0.0
	_train_car_progress = 0.0
	_train_car_respawn_timer = 10.0
	_train_car_active_index = 0
	_train_rush_timer = 0.0
	_train_car_zones.clear()
	_train_car_move_direction = Vector2.RIGHT
	_train_break_index = -1
	_fog_brazier_progress = 0.0
	_fog_brazier_respawn_timer = 10.0
	_fog_light_timer = 0.0
	_fog_pulse_timer = 1.6
	_fog_fake_brazier_progress = 0.0
	_airship_breach_progress = 0.0
	_airship_breach_respawn_timer = 12.0
	_airship_tailwind_timer = 0.0
	_airship_gust_timer = 2.2
	_airship_gust_direction = Vector2.RIGHT
	_airship_breach_drift_direction = Vector2.ZERO
	_player_previous_position = PLAYER_START
	_world_mutation_index = 0
	_next_world_mutation_time = 180.0
	_active_world_mutations.clear()
	_mode_scaling_minute = 0
	_last_spawned_enemy_health = 0
	_endless_spawn_bonus = 0.0
	_endless_elite_bonus = 0.0
	_endless_enemy_speed_bonus = 0.0
	_endless_enemy_health_bonus = 0.0
	_endless_hazard_bonus = 0.0
	_endless_boss_interval_scale = 1.0
	_contract_spawn_index = 0
	_contract_zone_progress = 0.0
	_choice_context = "upgrade"
	_choice_panel_title = "选择一项联动组件"
	_choice_panel_subtitle = ""
	_active_contract_ids.clear()
	_contract_spell_power_bonus = 0.0
	_contract_speed_bonus = 0.0
	_contract_xp_bonus = 0.0
	_contract_score_bonus = 0.0
	_contract_cooldown_scale = 1.0
	_contract_pickup_bonus = 0.0
	_contract_max_health_penalty = 0
	_contract_enemy_health_bonus = 0.0
	_contract_enemy_speed_bonus = 0.0
	_contract_elite_spawn_bonus = 0.0
	_contract_elite_affix_bonus = 0
	_contract_hazard_bonus = 0.0

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
	_nova_orbit_mutation = false
	_storm_singularity_mutation = false
	_chain_level = 1
	_detonate_level = 0
	_storm_orb_level = 0
	_ascension_level = 0
	_supercell_mutation = false
	_flask_level = 1
	_miasma_level = 0
	_shardburst_level = 0
	_catalyst_level = 0
	_needle_level = 1
	_volley_level = 0
	_glaive_level = 0
	_trail_level = 0
	_pulse_level = 1
	_ward_level = 0
	_beacon_level = 0
	_relay_level = 0
	_oathshot_level = 1
	_brand_level = 0
	_bloodtrail_level = 0
	_verdict_level = 0
	_dirge_level = 1
	_wake_level = 0
	_toll_level = 0
	_choir_level = 0
	_mirrorbolt_level = 1
	_afterimage_level = 0
	_switchstep_level = 0
	_prismdance_level = 0
	_blood_marks.clear()
	_blood_trails.clear()
	_grave_tokens.clear()
	_illusion_decoys.clear()

	_bolt_timer = 0.0
	_nova_timer = 1.4
	_storm_timer = 3.0
	_slash_timer = 0.0
	_mooncut_timer = 1.2
	_step_slash_timer = 2.4
	_chain_timer = 0.0
	_storm_orb_timer = 1.8
	_flask_timer = 0.0
	_miasma_timer = 1.0
	_shardburst_timer = 1.8
	_catalyst_timer = 3.0
	_needle_timer = 0.0
	_volley_timer = 1.0
	_glaive_timer = 1.8
	_trail_timer = 2.6
	_pulse_timer = 0.2
	_beacon_timer = 1.4
	_relay_timer = 2.0
	_oathshot_timer = 0.0
	_brand_timer = 1.2
	_bloodtrail_timer = 1.8
	_verdict_timer = 2.2
	_dirge_timer = 0.0
	_wake_timer = 1.4
	_toll_timer = 2.2
	_choir_timer = 2.6
	_mirrorbolt_timer = 0.0
	_afterimage_timer = 1.4
	_switchstep_timer = 2.4
	_prismdance_timer = 3.0
	_selected_endgame_branches.clear()
	_alchemist_clouds.clear()
	_warden_beacon_field = null

	_boss_spawned = false
	_boss_defeated = false
	_boss_warning_shown = false
	_boss_prelude_stage = 0
	_next_boss_spawn_time = _get_initial_boss_spawn_time()
	if _player != null and is_instance_valid(_player):
		_player.set_move_speed_multiplier(1.0)


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


func _update_run_pacing(delta: float) -> void:
	_update_pickup_heat(delta)
	_update_mode_health_scaling()
	_update_threat_phase(delta)
	_update_map_rule_state(delta)
	_update_endless_mutations()


func _update_boss_warning_and_prelude() -> void:
	if _boss_spawned or _boss_enemy != null:
		return

	var warning_time := _get_boss_warning_time()
	if not _boss_warning_shown and _run_time >= _get_boss_spawn_time() - warning_time:
		_boss_warning_shown = true
		_boss_prelude_stage = max(_boss_prelude_stage, 1)
		_show_message("首领预警：%s 即将降临，战场正在发生异动。" % _get_current_boss_name(), Color(1.0, 0.86, 0.54), 3.2)
		_trigger_boss_prelude(0)

	var finale_time := _get_boss_finale_prelude_time()
	if warning_time <= finale_time:
		return
	if _boss_warning_shown and _boss_prelude_stage < 2 and _run_time >= _get_boss_spawn_time() - finale_time:
		_boss_prelude_stage = 2
		_trigger_boss_prelude(1)


func _update_pickup_heat(delta: float) -> void:
	if _pickup_heat_timer > 0.0:
		_pickup_heat_timer = maxf(0.0, _pickup_heat_timer - delta)
	if _pickup_heat_timer <= 0.0 and _pickup_heat_bonus > 0.0:
		_pickup_heat_bonus = maxf(0.0, _pickup_heat_bonus - delta * 0.08)


func _update_mode_health_scaling() -> void:
	var current_minute := _get_mode_elapsed_minutes()
	if current_minute <= _mode_scaling_minute:
		return

	var step := _get_mode_enemy_health_step()
	for minute_step in range(_mode_scaling_minute + 1, current_minute + 1):
		if not is_equal_approx(step, 1.0):
			for enemy in _enemies:
				if enemy == null or not is_instance_valid(enemy) or enemy.is_boss():
					continue
				enemy.scale_vitality(step, false)
			if _last_spawned_enemy_health > 0:
				_last_spawned_enemy_health = max(1, int(round(float(_last_spawned_enemy_health) * step)))
			_show_message("%s强化: 小怪生命提升到 %.2fx。" % [_get_current_run_mode_name(), snappedf(_get_enemy_health_multiplier_for_minute(minute_step), 0.01)], Color(1.0, 0.76, 0.46), 2.2)

	_mode_scaling_minute = current_minute


func _get_mode_elapsed_minutes() -> int:
	return int(floor(_run_time / 60.0))


func _get_mode_enemy_health_step() -> float:
	match _current_run_mode_id:
		RUN_MODE_ENDLESS:
			return ENDLESS_ENEMY_HEALTH_STEP
		RUN_MODE_HARD:
			return HARD_ENEMY_HEALTH_STEP
		_:
			return NORMAL_ENEMY_HEALTH_STEP


func _get_enemy_health_multiplier() -> float:
	var mode_multiplier := _get_enemy_health_multiplier_for_minute(_get_mode_elapsed_minutes())
	return mode_multiplier * (1.0 + _contract_enemy_health_bonus)


func _get_enemy_health_multiplier_for_minute(minute: int) -> float:
	return pow(_get_mode_enemy_health_step(), float(max(minute, 0)))


func _get_boss_health_reference() -> int:
	if _last_spawned_enemy_health > 0:
		return _last_spawned_enemy_health

	var reference_health := 0
	for enemy in _enemies:
		if enemy == null or not is_instance_valid(enemy) or enemy.is_boss():
			continue
		reference_health = max(reference_health, enemy.max_health)
	if reference_health > 0:
		return reference_health

	var fallback_health := 64.0 * _get_enemy_health_multiplier()
	fallback_health *= 1.0 + _endless_enemy_health_bonus
	return max(48, int(round(fallback_health)))


func _update_threat_phase(delta: float) -> void:
	var next_phase := 0
	for threshold in THREAT_PHASE_TIMES:
		if _run_time >= threshold:
			next_phase += 1
	if next_phase > _threat_phase:
		for phase in range(_threat_phase + 1, next_phase + 1):
			_on_threat_phase_changed(phase)
	_threat_phase = next_phase

	if _threat_phase <= 0:
		return

	_pressure_wave_timer -= delta
	if _pressure_wave_timer > 0.0:
		return

	_spawn_pressure_wave(_threat_phase)
	_pressure_wave_timer = _get_pressure_wave_interval(_threat_phase)


func _on_threat_phase_changed(phase: int) -> void:
	if phase < THREAT_PHASE_MESSAGES.size():
		_show_message(THREAT_PHASE_MESSAGES[phase], Color(1.0, 0.92, 0.66), 3.0)
	if phase == 2:
		_spawn_pressure_wave(phase, true)
	elif phase == 3:
		_map_rule_active = true
		_map_rule_timer = 0.0
		_spawn_pressure_wave(phase, true)
	elif phase >= 4:
		_spawn_pressure_wave(phase, true)


func _get_pressure_wave_interval(phase: int) -> float:
	var interval := 10.5
	match phase:
		1:
			interval = 24.0
		2:
			interval = 18.0
		3:
			interval = 15.0
		4:
			interval = 12.5
		_:
			interval = 10.5
	if _is_hard_mode():
		interval *= 0.88
	elif _is_endless_mode():
		interval *= maxf(0.90, 1.0 - float(_active_world_mutations.size()) * 0.02)
	return interval


func _trigger_boss_prelude(stage: int) -> void:
	if _player == null or not is_instance_valid(_player):
		return

	match _selected_map_id:
		"ember_forge":
			_trigger_ember_forge_boss_prelude(stage)
		"void_marsh":
			_trigger_void_marsh_boss_prelude(stage)
		"prism_archive":
			_trigger_prism_archive_boss_prelude(stage)
		"clockwork_garden":
			_trigger_clockwork_garden_boss_prelude(stage)
		"bridge_train":
			_trigger_bridge_train_boss_prelude(stage)
		"black_fog_hunt":
			_trigger_black_fog_boss_prelude(stage)
		"airship_breach":
			_trigger_airship_breach_boss_prelude(stage)
		_:
			_trigger_sky_ruins_boss_prelude(stage)

	_spawn_boss_prelude_reinforcements(stage)
	_update_hud()


func _spawn_boss_prelude_reinforcements(stage: int) -> void:
	var roles: Array[String] = []
	match _selected_map_id:
		"ember_forge":
			roles = ["ranged", "fodder", "ranged", "elite"]
		"void_marsh":
			roles = ["control", "ranged", "control", "elite"]
		"prism_archive":
			roles = ["ranged", "control", "ranged", "elite"]
		"clockwork_garden":
			roles = ["fodder", "ranged", "elite", "fodder"]
		"bridge_train":
			roles = ["diver", "fodder", "ranged", "elite"]
		"black_fog_hunt":
			roles = ["control", "diver", "ranged", "elite"]
		"airship_breach":
			roles = ["ranged", "diver", "ranged", "elite"]
		_:
			roles = ["diver", "ranged", "control", "diver"]

	var spawn_count := 2 + stage
	if _mobile_layout:
		spawn_count = maxi(1, spawn_count - 1)

	for index in range(spawn_count):
		if _enemies.size() >= _get_active_enemy_cap():
			break
		var role := roles[index % roles.size()]
		var make_elite := stage > 0 and index == spawn_count - 1 and _threat_phase >= 4
		_spawn_role_enemy(role, make_elite)


func _trigger_sky_ruins_boss_prelude(stage: int) -> void:
	var center := _player.global_position
	var spacing := 116.0 + float(stage) * 16.0
	var positions: Array[Vector2] = [
		center,
		center + Vector2(spacing, 0.0),
		center + Vector2(-spacing, 0.0),
		center + Vector2(0.0, spacing),
		center + Vector2(0.0, -spacing),
	]
	if stage > 0:
		var diagonal := spacing * 0.74
		positions.append_array([
			center + Vector2(diagonal, diagonal),
			center + Vector2(diagonal, -diagonal),
			center + Vector2(-diagonal, diagonal),
			center + Vector2(-diagonal, -diagonal),
		])

	for blast_position in positions:
		_spawn_prelude_blast_marker(
			blast_position,
			60.0 + float(stage) * 6.0,
			0.10 + float(stage) * 0.02,
			180.0,
			0.76,
			Color(0.82, 0.94, 1.0),
			Color(0.28, 0.66, 1.0)
		)

	_show_message(
		"风暴前奏：裂空雷阵开始锁定，准备迎接 %s。" % _get_current_boss_name(),
		Color(0.84, 0.94, 1.0),
		2.6
	)


func _trigger_ember_forge_boss_prelude(stage: int) -> void:
	var center := _player.global_position + Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)) * _rng.randf_range(36.0, 96.0)
	var span := 440.0 + float(stage) * 40.0
	_spawn_forge_lane_warning(center + Vector2(-span, 0.0), center + Vector2(span, 0.0), 52.0 + float(stage) * 4.0, 0.78)
	if stage > 0:
		_spawn_forge_lane_warning(center + Vector2(0.0, -span), center + Vector2(0.0, span), 52.0 + float(stage) * 4.0, 0.78)
	else:
		_spawn_forge_lane_warning(center + Vector2(-span, -132.0), center + Vector2(span, -132.0), 48.0, 0.74)

	_show_message(
		"熔炉前奏：喷口正在校准火线，最后的压迫即将开始。",
		Color(1.0, 0.84, 0.56),
		2.6
	)


func _trigger_void_marsh_boss_prelude(stage: int) -> void:
	var center := _player.global_position
	var count := 3 + stage
	var ring_radius := 118.0 + float(stage) * 18.0
	for index in range(count):
		var angle := TAU * float(index) / float(count) + 0.35
		var kind := "pool" if index % 2 == 0 else "mud"
		_spawn_void_pool_at(center + Vector2.RIGHT.rotated(angle) * ring_radius, kind, 10.0 + float(stage) * 2.0)

	_show_message(
		"沼泽前奏：孢潮开始蔓延，%s 正在逼近。" % _get_current_boss_name(),
		Color(0.82, 0.96, 0.70),
		2.8
	)


func _trigger_prism_archive_boss_prelude(stage: int) -> void:
	var direction := _get_player_target_direction(960.0)
	var center := _player.global_position
	var span := 320.0 + float(stage) * 36.0
	_spawn_prism_lance_warning(center - direction * span, center + direction * span, 38.0 + float(stage) * 4.0, 0.74)
	if stage > 0:
		var side := direction.orthogonal()
		_spawn_prism_lance_warning(center - side * span, center + side * span, 38.0 + float(stage) * 4.0, 0.74)
	_show_message(
		"棱镜前奏：折光轨迹正在封锁走位，准备迎接 %s。"
		% _get_current_boss_name(),
		Color(0.86, 0.96, 1.0),
		2.6
	)


func _trigger_clockwork_garden_boss_prelude(stage: int) -> void:
	var center := _player.global_position
	_spawn_gear_sweep_warning(center, 3 + stage, 220.0 + float(stage) * 24.0, 38.0 + float(stage) * 3.0, 0.72)
	_show_message(
		"钟庭前奏：齿轨开始提速，%s 正在逼近。"
		% _get_current_boss_name(),
		Color(1.0, 0.90, 0.66),
		2.6
	)


func _trigger_bridge_train_boss_prelude(stage: int) -> void:
	if _train_car_zones.is_empty():
		_spawn_train_cars()
	var center := _player.global_position
	var spacing := 108.0 + float(stage) * 20.0
	for lane in range(3 + stage):
		var offset := (float(lane) - float(2 + stage) * 0.5) * spacing
		_spawn_prelude_blast_marker(center + Vector2(offset, 0.0), 54.0, 0.10 + float(stage) * 0.02, 180.0, 0.72, Color(0.88, 0.94, 1.0), Color(1.0, 0.76, 0.42))
	_show_message("列车前奏：断桥正在继续崩落，%s 已经逼近车头。", Color(0.92, 0.96, 1.0), 2.6)


func _trigger_black_fog_boss_prelude(stage: int) -> void:
	if _fog_brazier_zone == null or not is_instance_valid(_fog_brazier_zone):
		_spawn_black_fog_brazier()
	for index in range(3 + stage):
		var angle := TAU * float(index) / float(3 + stage)
		_spawn_prelude_blast_marker(_player.global_position + Vector2.RIGHT.rotated(angle) * (120.0 + float(stage) * 18.0), 52.0, 0.08 + float(stage) * 0.02, 170.0, 0.70, Color(0.40, 0.44, 0.52), Color(0.96, 0.82, 0.58))
	_show_message("黑雾前奏：灯火开始被压灭，%s 正从雾里逼近。", Color(0.92, 0.88, 0.74), 2.8)


func _trigger_airship_breach_boss_prelude(stage: int) -> void:
	if _airship_breach_zone == null or not is_instance_valid(_airship_breach_zone):
		_spawn_airship_breach()
	_trigger_airship_gust(_player.global_position, 180.0 + float(stage) * 32.0)
	if stage > 0:
		_trigger_airship_gust(_player.global_position + Vector2.RIGHT.rotated(PI * 0.5) * 90.0, 180.0 + float(stage) * 24.0)
	_show_message("空艇前奏：甲板再次失压，%s 正沿着裂线逼近。", Color(0.86, 0.94, 1.0), 2.6)


func _spawn_prelude_blast_marker(
	position: Vector2,
	radius: float,
	current_health_ratio: float,
	knockback: float,
	warning_duration: float,
	primary_color: Color,
	secondary_color: Color
) -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return

	var marker: MeteorHazard = METEOR_HAZARD_SCRIPT.new()
	marker.global_position = position
	marker.warning_duration = warning_duration
	marker.damage_radius = radius
	marker.current_health_ratio = current_health_ratio
	marker.knockback = knockback
	marker.primary_color = primary_color
	marker.secondary_color = secondary_color
	marker.impact.connect(_on_custom_hazard_marker_impact.bind(primary_color, secondary_color))
	_hazard_root.add_child(marker)


func _on_custom_hazard_marker_impact(
	position: Vector2,
	radius: float,
	current_health_ratio: float,
	knockback: float,
	primary_color: Color,
	secondary_color: Color
) -> void:
	_spawn_effect(position, radius * 1.12, primary_color, secondary_color, 0.34)
	_apply_area_current_health_damage(position, radius, current_health_ratio, knockback)
	_audio.play_enemy_shot(radius >= 90.0)


func _spawn_pressure_wave(phase: int, immediate: bool = false) -> void:
	if _enemies.size() >= _get_active_enemy_cap():
		return

	var pressure_roles: Array[String] = []
	var elite_roles: Array[String] = []
	match phase:
		1:
			pressure_roles = ["diver", "fodder", "ranged"]
		2:
			pressure_roles = ["diver", "ranged", "fodder", "ranged"]
			elite_roles = ["ranged", "diver"]
		3:
			pressure_roles = ["ranged", "control", "diver", "ranged"]
			elite_roles = ["ranged"]
		4:
			pressure_roles = ["diver", "ranged", "control", "ranged", "fodder"]
			elite_roles = ["ranged", "elite"]
		_:
			pressure_roles = ["diver", "ranged", "control", "elite", "ranged"]
			elite_roles = ["ranged", "elite"]

	var pack_size := 1 + phase
	if immediate:
		pack_size += 1
	if _is_hard_mode():
		pressure_roles.append("ranged")
		if phase >= 2:
			pressure_roles.append("control")
		pack_size += 1
	elif _is_endless_mode():
		pack_size += mini(2, int(_active_world_mutations.size() / 2))
		if _active_world_mutations.size() >= 2:
			elite_roles.append("elite")
	if _mobile_layout:
		pack_size = maxi(2, pack_size - 1)

	for index in range(pack_size):
		if _enemies.size() >= _get_active_enemy_cap():
			break
		var role := pressure_roles[index % pressure_roles.size()]
		var make_elite := not elite_roles.is_empty() and (immediate or phase >= 2) and index == 0
		if make_elite:
			role = elite_roles[min(index, elite_roles.size() - 1)]
		_spawn_role_enemy(role, make_elite)


func _spawn_role_enemy(role: String, force_elite: bool = false) -> void:
	var roster: Array[String] = _get_enemy_roster_for_role(role)
	if roster.is_empty():
		return
	var type_name := roster[_rng.randi_range(0, roster.size() - 1)]
	var is_elite := force_elite and type_name not in ["storm_archon", "forge_tyrant", "void_matriarch"]
	_spawn_enemy(type_name, is_elite, {"wave_rank": _get_wave_rank() + int(force_elite)})


func _roll_elite_affixes(type_name: String, wave_rank: int) -> Array[String]:
	var weighted_pool: Array[String] = []
	match type_name:
		"lancer":
			weighted_pool = ["hunter", "hunter", "dash", "dash", "deathburst", "splitter", "beacon"]
		"brute":
			weighted_pool = ["shielded", "shielded", "dash", "deathburst", "splitter", "hunter", "siphon"]
		"embermage":
			weighted_pool = ["shielded", "snare", "snare", "deathburst", "hunter", "splitter", "beacon"]
		"seer":
			weighted_pool = ["snare", "snare", "hunter", "shielded", "splitter", "deathburst", "beacon"]
		"mireling":
			weighted_pool = ["shielded", "splitter", "splitter", "snare", "hunter", "deathburst", "siphon"]
		_:
			weighted_pool = ["shielded", "splitter", "hunter", "snare", "deathburst", "dash", "siphon", "beacon"]

	var affix_count := 1
	if _run_time >= 240.0 or _threat_phase >= 3:
		affix_count = 2
	if _run_time >= 480.0 or (_is_hard_mode() and _run_time >= 360.0) or (_is_endless_mode() and _active_world_mutations.size() >= 2):
		affix_count = 3
	if wave_rank >= 14 and affix_count < 3:
		affix_count += 1
	affix_count += _contract_elite_affix_bonus
	if _mobile_layout:
		affix_count = mini(affix_count, 3 if _contract_elite_affix_bonus > 0 else 2)

	var result: Array[String] = []
	while result.size() < affix_count and not weighted_pool.is_empty():
		var pick_index := _rng.randi_range(0, weighted_pool.size() - 1)
		var affix_id := weighted_pool[pick_index]
		if not result.has(affix_id):
			result.append(affix_id)
		for pool_index in range(weighted_pool.size() - 1, -1, -1):
			if weighted_pool[pool_index] == affix_id:
				weighted_pool.remove_at(pool_index)
	return result


func _update_contract_points(delta: float) -> void:
	if _contract_zone != null and not is_instance_valid(_contract_zone):
		_contract_zone = null
		_contract_zone_progress = 0.0
	if _contract_spawn_index >= CONTRACT_SPAWN_TIMES.size():
		return
	if _boss_spawned or _boss_warning_shown:
		return
	if _contract_zone == null:
		if _run_time >= float(CONTRACT_SPAWN_TIMES[_contract_spawn_index]):
			_spawn_contract_zone()
		return
	if _player == null or not is_instance_valid(_player):
		return
	var inside := _is_player_in_rule_zone(_contract_zone, 12.0)
	_contract_zone.active = inside
	if inside:
		_contract_zone_progress = minf(1.0, _contract_zone_progress + delta * 0.52)
	else:
		_contract_zone_progress = maxf(0.0, _contract_zone_progress - delta * 0.10)
	_contract_zone.progress = _contract_zone_progress
	_contract_zone.sublabel = "读取 %.0f%%" % (_contract_zone_progress * 100.0)
	if _contract_zone_progress < 1.0:
		return
	var center := _contract_zone.global_position
	_contract_zone.queue_free()
	_contract_zone = null
	_contract_zone_progress = 0.0
	_contract_spawn_index += 1
	_spawn_effect(center, 96.0, Color(0.82, 0.92, 1.0), Color(0.36, 0.72, 1.0), 0.28)
	_open_contract_offer()


func _spawn_contract_zone() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root) or _player == null or not is_instance_valid(_player):
		return
	_contract_zone = MAP_RULE_ZONE_SCRIPT.new()
	_contract_zone.global_position = _pick_hazard_focus_position(120.0, 210.0)
	_contract_zone.radius = 74.0
	_contract_zone.primary_color = Color(0.24, 0.54, 0.78, 0.92)
	_contract_zone.secondary_color = Color(0.84, 0.96, 1.0, 0.82)
	_contract_zone.label = "契约点"
	_contract_zone.sublabel = "站入读取"
	_contract_zone.icon_style = "prism"
	_contract_zone.progress = 0.0
	_hazard_root.add_child(_contract_zone)
	_show_message("战场契约出现：站进契约点，换一层收益也换一层压力。", Color(0.82, 0.92, 1.0), 2.8)


func _open_contract_offer() -> void:
	if _state != GameState.PLAYING:
		return
	_choice_context = "contract"
	_choice_panel_title = "战场契约"
	_choice_panel_subtitle = "签下一条规则，后面的整局都会记账。"
	_upgrade_choices = _build_contract_choices()
	if _upgrade_choices.is_empty():
		_choice_context = "upgrade"
		_choice_panel_title = "选择一项联动组件"
		_choice_panel_subtitle = ""
		return
	_state = GameState.LEVEL_UP
	_hud.hide_pause_menu()
	_apply_choice_panel_context()
	_hud.show_upgrade_choices(_upgrade_choices)
	_hud.set_message("")
	_message_timer = 0.0
	_set_pause_state(true)


func _build_contract_choices() -> Array[Dictionary]:
	var pool: Array[Dictionary] = []
	for contract_variant in CONTRACT_DEFINITIONS:
		var contract: Dictionary = contract_variant
		var contract_id := String(contract.get("id", ""))
		if contract_id.is_empty() or _active_contract_ids.has(contract_id):
			continue
		pool.append({
			"key": contract_id,
			"title": String(contract.get("title", "契约")),
			"desc": String(contract.get("desc", "")),
			"detail": String(contract.get("detail", "")),
			"bucket": "contract",
			"accent": contract.get("accent", Color(0.82, 0.92, 1.0)),
		})
	var result: Array[Dictionary] = []
	while result.size() < 3 and not pool.is_empty():
		var pick_index := _rng.randi_range(0, pool.size() - 1)
		var choice: Dictionary = pool[pick_index]
		result.append(choice)
		pool.remove_at(pick_index)
	return result


func _find_contract_definition(contract_id: String) -> Dictionary:
	for contract_variant in CONTRACT_DEFINITIONS:
		var contract: Dictionary = contract_variant
		if String(contract.get("id", "")) == contract_id:
			return contract
	return {}


func _apply_contract_choice(index: int) -> void:
	if index < 0 or index >= _upgrade_choices.size():
		return
	var choice: Dictionary = _upgrade_choices[index]
	var contract_id := String(choice.get("key", ""))
	var definition := _find_contract_definition(contract_id)
	if definition.is_empty():
		return
	if _active_contract_ids.has(contract_id):
		return
	var effects: Dictionary = definition.get("effects", {})
	_active_contract_ids.append(contract_id)
	_contract_spell_power_bonus += float(effects.get("spell_power_bonus", 0.0))
	_contract_speed_bonus += float(effects.get("speed_bonus", 0.0))
	_contract_xp_bonus += float(effects.get("xp_bonus", 0.0))
	_contract_score_bonus += float(effects.get("score_bonus", 0.0))
	_contract_pickup_bonus += float(effects.get("pickup_bonus", 0.0))
	_contract_max_health_penalty += int(effects.get("max_health_penalty", 0))
	_contract_enemy_health_bonus += float(effects.get("enemy_health_bonus", 0.0))
	_contract_enemy_speed_bonus += float(effects.get("enemy_speed_bonus", 0.0))
	_contract_elite_spawn_bonus += float(effects.get("elite_spawn_bonus", 0.0))
	_contract_elite_affix_bonus += int(effects.get("elite_affix_bonus", 0))
	_contract_hazard_bonus += float(effects.get("hazard_bonus", 0.0))
	var cooldown_scale := float(effects.get("cooldown_scale", 1.0))
	if cooldown_scale > 0.0:
		_contract_cooldown_scale *= cooldown_scale
	_upgrade_choices.clear()
	_choice_context = "upgrade"
	_choice_panel_title = "选择一项联动组件"
	_choice_panel_subtitle = ""
	_apply_choice_panel_context()
	_hud.hide_upgrade_choices()
	_apply_player_build(false)
	_sync_satellites()
	_show_message("契约签订：%s" % String(definition.get("title", "战场契约")), definition.get("accent", Color(0.82, 0.92, 1.0)), 2.2)
	_update_character_hud_v2()
	_state = GameState.PLAYING
	_set_pause_state(false)


func _apply_choice_panel_context() -> void:
	if _hud == null or not is_instance_valid(_hud):
		return
	if _hud.has_method("set_upgrade_panel_context"):
		_hud.call("set_upgrade_panel_context", _choice_panel_title, _choice_panel_subtitle)
	elif _hud.has_method("set_upgrade_panel_title"):
		_hud.call("set_upgrade_panel_title", _choice_panel_title)


func _get_contract_summary() -> String:
	if _active_contract_ids.is_empty():
		return ""
	var labels: Array[String] = []
	for contract_id in _active_contract_ids:
		var definition := _find_contract_definition(contract_id)
		if definition.is_empty():
			continue
		labels.append(String(definition.get("title", contract_id)))
	return " / ".join(labels)


func _get_enemy_roster_for_role(role: String) -> Array[String]:
	match role:
		"diver":
			return ["lancer"]
		"ranged":
			return ["embermage", "seer"]
		"control":
			return ["seer", "mireling"]
		"elite":
			return ["brute", "mireling", "embermage", "seer"]
		_:
			return ["wisp", "brute"]


func _update_map_rule_state(delta: float) -> void:
	_tick_map_reward_timers(delta)
	if not _map_rule_active:
		if _player != null and is_instance_valid(_player):
			_player.set_move_speed_multiplier(1.0)
		return

	match _selected_map_id:
		"sky_ruins":
			_update_sky_ruins_rule(delta)
		"ember_forge":
			_update_ember_forge_rule(delta)
		"void_marsh":
			_update_void_marsh_rule(delta)
		"prism_archive":
			_update_prism_archive_rule(delta)
		"clockwork_garden":
			_update_clockwork_garden_rule(delta)
		"bridge_train":
			_update_bridge_train_rule(delta)
		"black_fog_hunt":
			_update_black_fog_rule(delta)
		"airship_breach":
			_update_airship_breach_rule(delta)


func _tick_map_reward_timers(delta: float) -> void:
	_ruins_altar_buff_timer = maxf(0.0, _ruins_altar_buff_timer - delta)
	_forge_overdrive_timer = maxf(0.0, _forge_overdrive_timer - delta)
	_void_spore_blessing_timer = maxf(0.0, _void_spore_blessing_timer - delta)
	_prism_overcharge_timer = maxf(0.0, _prism_overcharge_timer - delta)
	_clock_overdrive_timer = maxf(0.0, _clock_overdrive_timer - delta)
	_train_rush_timer = maxf(0.0, _train_rush_timer - delta)
	_fog_light_timer = maxf(0.0, _fog_light_timer - delta)
	_airship_tailwind_timer = maxf(0.0, _airship_tailwind_timer - delta)


func _update_endless_mutations() -> void:
	if not _is_endless_mode() or _run_time < _next_world_mutation_time:
		return
	_apply_next_world_mutation()
	_next_world_mutation_time += 180.0


func _update_special_character_state(delta: float) -> void:
	_update_blood_marks(delta)
	_update_blood_trails(delta)
	_update_grave_tokens(delta)
	_update_illusion_decoys(delta)


func _update_blood_marks(delta: float) -> void:
	var expired: Array = []
	for enemy_id_variant in _blood_marks.keys():
		var enemy_id := int(enemy_id_variant)
		var entry: Dictionary = _blood_marks.get(enemy_id_variant, {})
		var enemy := entry.get("enemy", null) as EnemySoldier
		if enemy == null or not is_instance_valid(enemy):
			expired.append(enemy_id_variant)
			continue
		entry["timer"] = float(entry.get("timer", 0.0)) - delta
		if float(entry.get("timer", 0.0)) <= 0.0:
			expired.append(enemy_id_variant)
			continue
		_blood_marks[enemy_id_variant] = entry
	for enemy_id_variant in expired:
		_blood_marks.erase(enemy_id_variant)


func _update_blood_trails(delta: float) -> void:
	for index in range(_blood_trails.size() - 1, -1, -1):
		var trail: Dictionary = _blood_trails[index]
		var node := trail.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			_blood_trails.remove_at(index)
			continue
		trail["lifetime"] = float(trail.get("lifetime", 0.0)) - delta
		trail["pulse_timer"] = float(trail.get("pulse_timer", 0.0)) - delta
		if float(trail.get("lifetime", 0.0)) <= 0.0:
			node.queue_free()
			_blood_trails.remove_at(index)
			continue
		var radius := float(trail.get("radius", node.radius))
		var pressure := _count_enemies_in_radius(node.global_position, radius + 12.0)
		node.active = pressure > 0
		node.sublabel = "收割区 x%d" % maxi(pressure, 1)
		if float(trail.get("pulse_timer", 0.0)) <= 0.0:
			var damage := int(trail.get("damage", 1))
			_damage_enemies_in_radius(node.global_position, radius, damage, 130.0, 5 + _bloodtrail_level)
			_burst_marked_enemies_in_radius(node.global_position, radius * 1.06, max(1, int(round(float(damage) * 0.55))), 120.0)
			if _has_endgame_evolution("evo_hunter_crimson_delta"):
				var marked_targets := _get_nearest_enemies(node.global_position, 4, radius + 26.0)
				for marked_enemy in marked_targets:
					if marked_enemy == null or not is_instance_valid(marked_enemy):
						continue
					_apply_blood_mark(marked_enemy, 3.6)
			trail["pulse_timer"] = float(trail.get("pulse_interval", 0.52))
			_spawn_effect(node.global_position, radius * 0.68, Color(0.94, 0.26, 0.34), Color(1.0, 0.80, 0.78), 0.16)
		_blood_trails[index] = trail


func _update_grave_tokens(delta: float) -> void:
	for index in range(_grave_tokens.size() - 1, -1, -1):
		var token: Dictionary = _grave_tokens[index]
		var node := token.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			_grave_tokens.remove_at(index)
			continue
		token["lifetime"] = float(token.get("lifetime", 0.0)) - delta
		if float(token.get("lifetime", 0.0)) <= 0.0:
			node.queue_free()
			_grave_tokens.remove_at(index)
			continue
		node.active = _player != null and is_instance_valid(_player) and node.global_position.distance_to(_player.global_position) <= node.radius + 56.0
		node.sublabel = "尸核 %d" % (index + 1)
		_grave_tokens[index] = token


func _update_illusion_decoys(delta: float) -> void:
	for index in range(_illusion_decoys.size() - 1, -1, -1):
		var decoy: Dictionary = _illusion_decoys[index]
		var node := decoy.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			_illusion_decoys.remove_at(index)
			continue
		decoy["lifetime"] = float(decoy.get("lifetime", 0.0)) - delta
		if float(decoy.get("lifetime", 0.0)) <= 0.0:
			node.queue_free()
			_illusion_decoys.remove_at(index)
			continue
		node.active = true
		node.sublabel = "残像火点"
		_illusion_decoys[index] = decoy


func _update_spell_attacks(delta: float) -> void:
	if _is_blade_character():
		_update_blade_attacks(delta)
		return
	elif _is_alchemist_character():
		_update_alchemist_attacks(delta)
		return
	elif _is_ranger_character():
		_update_ranger_attacks(delta)
		return
	elif _is_warden_character():
		_update_warden_attacks(delta)
		return
	elif _is_thunder_character():
		_update_thunder_attacks(delta)
		return
	elif _is_blood_hunter_character():
		_update_blood_hunter_attacks(delta)
		return
	elif _is_grave_caller_character():
		_update_grave_caller_attacks(delta)
		return
	elif _is_illusionist_character():
		_update_illusionist_attacks(delta)
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
		"prism_lance":
			_spawn_prism_lance_hazard()
		"gear_sweep":
			_spawn_gear_sweep_hazard()


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


func _spawn_rule_link_effect(
	start_position: Vector2,
	end_position: Vector2,
	thickness: float,
	primary_color: Color,
	secondary_color: Color,
	duration: float = 0.16
) -> void:
	if _effect_root == null or not is_instance_valid(_effect_root):
		return
	var effect: LightningChainEffect = LIGHTNING_CHAIN_EFFECT_SCRIPT.new()
	effect.thickness = thickness
	effect.duration = duration
	effect.primary_color = primary_color
	effect.secondary_color = secondary_color
	effect.configure_link(start_position, end_position, _rng.randi())
	_effect_root.add_child(effect)


func _is_player_in_rule_zone(zone: MapRuleZone, extra_radius: float = 0.0) -> bool:
	if zone == null or not is_instance_valid(zone):
		return false
	if _player == null or not is_instance_valid(_player):
		return false
	return _player.global_position.distance_to(zone.global_position) <= zone.radius + _player.get_body_radius() + extra_radius


func _is_player_on_link_route(start_position: Vector2, end_position: Vector2, width: float) -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var route := end_position - start_position
	var route_length_sq := route.length_squared()
	if route_length_sq <= 0.001:
		return false
	var player_position := _player.global_position
	var t := (player_position - start_position).dot(route) / route_length_sq
	if t < 0.14 or t > 0.86:
		return false
	return _distance_to_segment(player_position, start_position, end_position) <= width + _player.get_body_radius()


func _did_player_cross_route(start_position: Vector2, end_position: Vector2, width: float) -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var move_start := _player_previous_position
	var move_end := _player.global_position
	if move_start.distance_squared_to(move_end) <= 9.0:
		return false

	var route := end_position - start_position
	var route_length_sq := route.length_squared()
	if route_length_sq <= 0.001:
		return false

	var prev_distance := _distance_to_segment(move_start, start_position, end_position)
	var next_distance := _distance_to_segment(move_end, start_position, end_position)
	if minf(prev_distance, next_distance) > width:
		return false

	var prev_side := signf(route.cross(move_start - start_position))
	var next_side := signf(route.cross(move_end - start_position))
	if prev_side == 0.0 or next_side == 0.0:
		var midpoint_t := ((move_start + move_end) * 0.5 - start_position).dot(route) / route_length_sq
		return midpoint_t >= -0.08 and midpoint_t <= 1.08 and maxf(prev_distance, next_distance) > width * 0.5
	return prev_side != next_side


func _update_sky_ruins_rule(delta: float) -> void:
	if _ruins_altar_zone == null or not is_instance_valid(_ruins_altar_zone) or _ruins_altar_destination_zone == null or not is_instance_valid(_ruins_altar_destination_zone):
		_ruins_altar_respawn_timer = maxf(0.0, _ruins_altar_respawn_timer - delta)
		if _ruins_altar_respawn_timer <= 0.0:
			_spawn_ruins_altar()
		return

	var escorting := _is_player_in_rule_zone(_ruins_altar_zone, 18.0)
	_ruins_altar_zone.active = escorting
	_ruins_altar_destination_zone.active = escorting
	var nearby_pressure := _count_enemies_in_radius(_ruins_altar_zone.global_position, _ruins_altar_zone.radius * 1.28)
	if escorting:
		var pressure_slow := minf(0.46, float(nearby_pressure) * 0.028)
		var escort_speed := 92.0 * (1.0 - pressure_slow)
		_ruins_altar_zone.global_position = _ruins_altar_zone.global_position.move_toward(_ruins_altar_destination_zone.global_position, escort_speed * delta)

	var remaining_distance := _ruins_altar_zone.global_position.distance_to(_ruins_altar_destination_zone.global_position)
	_ruins_altar_progress = clampf(1.0 - remaining_distance / maxf(_ruins_escort_route_length, 1.0), 0.0, 1.0)
	_ruins_altar_zone.progress = _ruins_altar_progress
	_ruins_altar_destination_zone.progress = _ruins_altar_progress
	_ruins_altar_zone.sublabel = "贴近护送，当前 %.0f%%" % (_ruins_altar_progress * 100.0)
	_ruins_altar_destination_zone.sublabel = "终点接应"

	if remaining_distance > 28.0:
		return

	var center := _ruins_altar_destination_zone.global_position
	_spawn_effect(center, _ruins_altar_zone.radius * 1.10, Color(0.86, 0.96, 1.0), Color(0.38, 0.72, 1.0), 0.36)
	_damage_enemies_in_radius(center, _ruins_altar_zone.radius * 1.20, max(8, int(round(float(_get_wave_rank()) * 1.8))), 240.0, 8)
	_award_score(90 + _get_wave_rank() * 16)
	_ruins_altar_zone.queue_free()
	_ruins_altar_destination_zone.queue_free()
	_ruins_altar_zone = null
	_ruins_altar_destination_zone = null
	_ruins_altar_progress = 0.0
	_ruins_escort_route_length = 0.0
	_ruins_altar_respawn_timer = 34.0
	_ruins_altar_buff_timer = 22.0
	_show_message("护送完成：遗迹信标顺利抵达，22 秒内冷却与冲榜倍率同步提升。", Color(0.86, 0.96, 1.0), 2.8)


func _spawn_ruins_altar() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root) or _player == null or not is_instance_valid(_player):
		return
	var origin := _pick_hazard_focus_position(160.0, 240.0)
	var destination := origin + Vector2.RIGHT * 420.0
	for _attempt in range(18):
		var candidate := origin + Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)) * _rng.randf_range(360.0, 520.0)
		if not _is_position_blocked(candidate, 48.0):
			destination = candidate
			break

	_ruins_altar_zone = MAP_RULE_ZONE_SCRIPT.new()
	_ruins_altar_zone.global_position = origin
	_ruins_altar_zone.radius = 92.0
	_ruins_altar_zone.primary_color = Color(0.40, 0.76, 1.0, 0.92)
	_ruins_altar_zone.secondary_color = Color(0.92, 0.98, 1.0, 0.84)
	_ruins_altar_zone.label = "浮空信标"
	_ruins_altar_zone.sublabel = "贴近后护送前进"
	_ruins_altar_zone.icon_style = "altar"
	_ruins_altar_zone.progress = 0.0
	_hazard_root.add_child(_ruins_altar_zone)
	_ruins_altar_destination_zone = MAP_RULE_ZONE_SCRIPT.new()
	_ruins_altar_destination_zone.global_position = destination
	_ruins_altar_destination_zone.radius = 66.0
	_ruins_altar_destination_zone.primary_color = Color(0.78, 0.90, 1.0, 0.82)
	_ruins_altar_destination_zone.secondary_color = Color(0.96, 0.99, 1.0, 0.84)
	_ruins_altar_destination_zone.label = "护送终点"
	_ruins_altar_destination_zone.sublabel = "把信标送到这里"
	_ruins_altar_destination_zone.icon_style = "prism"
	_ruins_altar_destination_zone.progress = 0.0
	_hazard_root.add_child(_ruins_altar_destination_zone)
	_ruins_escort_route_length = maxf(origin.distance_to(destination), 1.0)
	_show_message("天空遗迹规则启动：贴近浮空信标，把它护送到终点。", Color(0.84, 0.94, 1.0), 2.8)


func _update_ember_forge_rule(delta: float) -> void:
	_update_forge_core_rule(delta)
	if _forge_overdrive_timer > 0.0:
		return
	_map_rule_timer += delta
	var interval := maxf(6.8, 11.0 - float(_threat_phase) * 0.8 - _endless_hazard_bonus * 8.0)
	if _map_rule_timer < interval:
		return
	_map_rule_timer = 0.0
	_trigger_forge_flame_pattern()


func _trigger_forge_flame_pattern() -> void:
	if _player == null or not is_instance_valid(_player):
		return
	var horizontal := _rng.randf() < 0.5
	var lane_count := 2 + int(_threat_phase >= 4)
	var spacing := 132.0 if horizontal else 148.0
	var base_center := _player.global_position + Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)) * _rng.randf_range(40.0, 120.0)
	for lane in range(lane_count):
		var lane_offset := (float(lane) - float(lane_count - 1) * 0.5) * spacing
		var start_position := base_center + (Vector2(-430.0, lane_offset) if horizontal else Vector2(lane_offset, -430.0))
		var end_position := base_center + (Vector2(430.0, lane_offset) if horizontal else Vector2(lane_offset, 430.0))
		_spawn_forge_lane_warning(start_position, end_position, 48.0 + float(_threat_phase) * 4.0, 0.82)

	_show_message("熔炉喷口开启: 观察火线，横移换位。", Color(1.0, 0.84, 0.56), 2.2)


func _spawn_forge_lane_warning(start_position: Vector2, end_position: Vector2, width: float, warning_duration: float) -> void:
	var segments := 6
	for index in range(segments):
		var t := float(index) / float(max(segments - 1, 1))
		var marker_position := start_position.lerp(end_position, t)
		var meteor: MeteorHazard = METEOR_HAZARD_SCRIPT.new()
		meteor.global_position = marker_position
		meteor.warning_duration = warning_duration
		meteor.linger_duration = 0.26
		meteor.damage_radius = width * 0.68
		meteor.current_health_ratio = 0.0
		meteor.knockback = 0.0
		meteor.impact.connect(_on_forge_lane_marker_impact)
		_hazard_root.add_child(meteor)

	var timer := get_tree().create_timer(warning_duration, false)
	timer.timeout.connect(_trigger_forge_lane_damage.bind(start_position, end_position, width))


func _on_forge_lane_marker_impact(position: Vector2, radius: float, _current_health_ratio: float, _knockback: float) -> void:
	_spawn_effect(position, radius * 1.16, Color(1.0, 0.82, 0.48), Color(0.96, 0.30, 0.16), 0.24)


func _trigger_forge_lane_damage(start_position: Vector2, end_position: Vector2, width: float) -> void:
	_apply_line_current_health_damage(start_position, end_position, width, 0.16, 260.0)
	for index in range(7):
		var t := float(index) / 6.0
		var effect_position := start_position.lerp(end_position, t)
		_spawn_effect(effect_position, width * 0.92, Color(1.0, 0.80, 0.44), Color(0.92, 0.24, 0.12), 0.20)
	_audio.play_enemy_shot(true)


func _update_forge_core_rule(delta: float) -> void:
	if _forge_core_zone == null or not is_instance_valid(_forge_core_zone) or _forge_cut_target_zone == null or not is_instance_valid(_forge_cut_target_zone):
		_forge_core_respawn_timer = maxf(0.0, _forge_core_respawn_timer - delta)
		if _forge_core_respawn_timer <= 0.0:
			_spawn_forge_core()
		return

	_forge_cut_cross_cooldown = maxf(0.0, _forge_cut_cross_cooldown - delta)
	_forge_cut_visual_timer = maxf(0.0, _forge_cut_visual_timer - delta)

	var route_start := _forge_core_zone.global_position
	var route_end := _forge_cut_target_zone.global_position
	if _forge_cut_visual_timer <= 0.0:
		_spawn_rule_link_effect(route_start, route_end, 6.2, Color(1.0, 0.76, 0.40), Color(0.96, 0.30, 0.16), 0.14)
		_forge_cut_visual_timer = 0.24

	var route_midpoint := route_start.lerp(route_end, 0.5)
	var player_near_route := _distance_to_segment(_player.global_position, route_start, route_end) <= 64.0 + _player.get_body_radius() if _player != null and is_instance_valid(_player) else false
	_forge_core_zone.active = player_near_route
	_forge_cut_target_zone.active = player_near_route
	if _forge_cut_cross_cooldown <= 0.0 and _did_player_cross_route(route_start, route_end, 54.0):
		_forge_cut_crossings += 1
		_forge_cut_cross_cooldown = 0.34
		_spawn_rule_link_effect(route_start, route_end, 9.4, Color(1.0, 0.90, 0.68), Color(1.0, 0.44, 0.20), 0.20)
		_show_message("断路进度 +1：继续穿切导热线。", Color(1.0, 0.88, 0.64), 1.2)

	_forge_cut_required_crossings = maxi(_forge_cut_required_crossings, 3)
	_forge_core_progress = clampf(float(_forge_cut_crossings) / float(_forge_cut_required_crossings), 0.0, 1.0)
	_forge_core_zone.progress = _forge_core_progress
	_forge_cut_target_zone.progress = _forge_core_progress
	_forge_core_zone.sublabel = "断路 %d/%d" % [_forge_cut_crossings, _forge_cut_required_crossings]
	_forge_cut_target_zone.sublabel = "来回穿过热路"

	if _forge_cut_crossings < _forge_cut_required_crossings:
		return

	_spawn_rule_link_effect(route_start, route_end, 12.0, Color(1.0, 0.94, 0.72), Color(1.0, 0.48, 0.22), 0.26)
	_spawn_effect(route_midpoint, 108.0, Color(1.0, 0.84, 0.48), Color(0.94, 0.28, 0.14), 0.34)
	_apply_line_current_health_damage(route_start, route_end, 74.0, 0.18, 260.0)
	_award_score(96 + _get_wave_rank() * 18)
	_forge_core_zone.queue_free()
	_forge_cut_target_zone.queue_free()
	_forge_core_zone = null
	_forge_cut_target_zone = null
	_forge_core_progress = 0.0
	_forge_core_respawn_timer = 32.0
	_forge_overdrive_timer = 20.0
	_forge_cut_crossings = 0
	_forge_cut_required_crossings = 0
	_forge_cut_cross_cooldown = 0.0
	_map_rule_timer = 0.0
	_show_message("断路成功：熔炉喷线短时熄火，20 秒内法术威力、冷却与倍率同步抬升。", Color(1.0, 0.90, 0.62), 2.8)


func _spawn_forge_core() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	var center := _pick_hazard_focus_position(150.0, 280.0)
	var direction := Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
	var half_span := _rng.randf_range(160.0, 220.0)
	var start_position := center - direction * half_span
	var end_position := center + direction * half_span
	for _attempt in range(12):
		center = _pick_hazard_focus_position(150.0, 280.0)
		direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		half_span = _rng.randf_range(160.0, 220.0)
		start_position = center - direction * half_span
		end_position = center + direction * half_span
		if not _is_position_blocked(start_position, 42.0) and not _is_position_blocked(end_position, 42.0):
			break

	_forge_core_zone = MAP_RULE_ZONE_SCRIPT.new()
	_forge_core_zone.global_position = start_position
	_forge_core_zone.radius = 68.0
	_forge_core_zone.primary_color = Color(1.0, 0.70, 0.30, 0.94)
	_forge_core_zone.secondary_color = Color(1.0, 0.92, 0.70, 0.86)
	_forge_core_zone.label = "断路阀"
	_forge_core_zone.sublabel = "穿切热路"
	_forge_core_zone.icon_style = "core"
	_forge_core_zone.progress = 0.0
	_hazard_root.add_child(_forge_core_zone)
	_forge_cut_target_zone = MAP_RULE_ZONE_SCRIPT.new()
	_forge_cut_target_zone.global_position = end_position
	_forge_cut_target_zone.radius = 68.0
	_forge_cut_target_zone.primary_color = Color(1.0, 0.62, 0.28, 0.92)
	_forge_cut_target_zone.secondary_color = Color(1.0, 0.92, 0.70, 0.84)
	_forge_cut_target_zone.label = "断路阀"
	_forge_cut_target_zone.sublabel = "来回穿切"
	_forge_cut_target_zone.icon_style = "core"
	_forge_cut_target_zone.progress = 0.0
	_hazard_root.add_child(_forge_cut_target_zone)
	_forge_cut_crossings = 0
	_forge_cut_required_crossings = 3 + int(_threat_phase >= 4)
	_forge_cut_cross_cooldown = 0.0
	_forge_cut_visual_timer = 0.0
	_show_message("余烬断路出现：反复穿过导热线，把整条热路切断。", Color(1.0, 0.86, 0.58), 2.6)


func _update_void_marsh_rule(delta: float) -> void:
	var player_speed_scale := 1.0
	_void_pool_timer -= delta
	if _void_pool_timer <= 0.0:
		_spawn_void_pool("mud" if _rng.randf() < 0.5 else "pool")
		_void_pool_timer = maxf(6.2, 10.4 - float(_threat_phase) * 0.7 - _endless_hazard_bonus * 7.0)

	for index in range(_void_pools.size() - 1, -1, -1):
		var pool: Dictionary = _void_pools[index]
		var node := pool.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			_void_pools.remove_at(index)
			continue

		pool["lifetime"] = float(pool.get("lifetime", 0.0)) - delta
		pool["pulse_timer"] = float(pool.get("pulse_timer", 0.0)) - delta
		if float(pool.get("lifetime", 0.0)) <= 0.0:
			node.queue_free()
			_void_pools.remove_at(index)
			continue

		var radius := float(pool.get("radius", 84.0))
		var center := node.global_position
		var player_inside := _player != null and is_instance_valid(_player) and center.distance_to(_player.global_position) <= radius + _player.get_body_radius()
		node.active = player_inside
		if String(pool.get("kind", "mud")) == "mud":
			if player_inside:
				player_speed_scale = minf(player_speed_scale, 0.64)
			node.sublabel = "减速泥潭"
		else:
			if float(pool.get("pulse_timer", 0.0)) <= 0.0:
				_apply_area_max_health_damage_over_time(center, radius, 0.006, 0.55, 80.0)
				pool["pulse_timer"] = 0.55
			if _should_trigger_void_pool(node, radius):
				_explode_void_pool(pool)
				_void_pools.remove_at(index)
				continue
			node.sublabel = "可引爆毒池"

		_void_pools[index] = pool

	_update_void_spore_rule(delta)

	if _player != null and is_instance_valid(_player):
		_player.set_move_speed_multiplier(player_speed_scale)


func _spawn_void_pool(kind: String) -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	_spawn_void_pool_at(_pick_hazard_focus_position(140.0, 300.0), kind)


func _spawn_void_pool_at(position: Vector2, kind: String, lifetime: float = -1.0) -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	var zone := MAP_RULE_ZONE_SCRIPT.new()
	zone.global_position = position
	zone.radius = 82.0 if kind == "mud" else 76.0
	zone.icon_style = kind
	zone.progress = -1.0
	if kind == "mud":
		zone.primary_color = Color(0.48, 0.72, 0.40, 0.90)
		zone.secondary_color = Color(0.86, 0.96, 0.82, 0.82)
		zone.label = "泥潭"
	else:
		zone.primary_color = Color(0.62, 0.88, 0.44, 0.92)
		zone.secondary_color = Color(0.84, 0.98, 0.70, 0.82)
		zone.label = "毒池"
	_hazard_root.add_child(zone)
	_void_pools.append({
		"node": zone,
		"kind": kind,
		"radius": zone.radius,
		"lifetime": lifetime if lifetime > 0.0 else (15.0 if kind == "mud" else 13.0),
		"pulse_timer": 0.55,
	})


func _update_void_spore_rule(delta: float) -> void:
	if _void_spore_zone == null or not is_instance_valid(_void_spore_zone):
		_void_spore_respawn_timer = maxf(0.0, _void_spore_respawn_timer - delta)
		if _void_spore_respawn_timer <= 0.0:
			_spawn_void_spore()
		return

	var radius := _void_spore_zone.radius
	var center := _void_spore_zone.global_position
	var nearby_enemies := _count_enemies_in_radius(center, radius * 1.06)
	var nearby_pools := _count_void_pools_in_radius(center, radius * 2.2)
	_void_spore_zone.active = nearby_enemies > 0
	if nearby_enemies > 0:
		var pressure_bonus := minf(0.70, float(max(nearby_enemies - 1, 0)) * 0.08 + float(nearby_pools) * 0.05)
		_void_spore_progress = minf(1.0, _void_spore_progress + delta * (0.14 + pressure_bonus))
	else:
		_void_spore_progress = maxf(0.0, _void_spore_progress - delta * 0.08)

	_void_spore_zone.progress = _void_spore_progress
	_void_spore_zone.sublabel = "把敌群引进来 %.0f%%" % (_void_spore_progress * 100.0)

	if _void_spore_progress < 1.0:
		return

	_clear_void_pools_in_radius(center, radius * 2.9)
	_damage_enemies_in_radius(center, radius * 1.36, max(9, int(round(float(_get_wave_rank()) * 1.8))), 180.0, 12)
	for index in range(5):
		var angle := TAU * float(index) / 5.0 + _rng.randf_range(-0.18, 0.18)
		_spawn_orb(center + Vector2.RIGHT.rotated(angle) * _rng.randf_range(14.0, 34.0), 2)
	if _player != null and is_instance_valid(_player):
		_player.heal(1)
	_award_score(104 + _get_wave_rank() * 16)
	_spawn_effect(center, radius * 1.18, Color(0.86, 0.98, 0.74), Color(0.26, 0.56, 0.22), 0.36)
	_void_spore_zone.queue_free()
	_void_spore_zone = null
	_void_spore_progress = 0.0
	_void_spore_respawn_timer = 30.0
	_void_spore_blessing_timer = 20.0
	_show_message("诱爆成功：孢核炸开整片沼泽，20 秒经验、得分与清场效率同步提高。", Color(0.86, 0.98, 0.74), 2.8)


func _spawn_void_spore() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	_void_spore_zone = MAP_RULE_ZONE_SCRIPT.new()
	_void_spore_zone.global_position = _pick_hazard_focus_position(150.0, 290.0)
	_void_spore_zone.radius = 86.0
	_void_spore_zone.primary_color = Color(0.64, 0.92, 0.48, 0.94)
	_void_spore_zone.secondary_color = Color(0.90, 0.98, 0.76, 0.86)
	_void_spore_zone.label = "诱爆孢核"
	_void_spore_zone.sublabel = "把敌群带进来"
	_void_spore_zone.icon_style = "spore"
	_void_spore_zone.progress = 0.0
	_hazard_root.add_child(_void_spore_zone)
	_show_message("诱爆孢核出现：把敌群带进范围内，等它自己炸开。", Color(0.82, 0.96, 0.72), 2.6)


func _update_prism_archive_rule(delta: float) -> void:
	if _prism_focus_zone == null or not is_instance_valid(_prism_focus_zone) or _prism_link_target_zone == null or not is_instance_valid(_prism_link_target_zone):
		_prism_focus_respawn_timer = maxf(0.0, _prism_focus_respawn_timer - delta)
		if _prism_focus_respawn_timer <= 0.0:
			_spawn_prism_focus()
		return

	_prism_link_visual_timer = maxf(0.0, _prism_link_visual_timer - delta)
	var route_start := _prism_focus_zone.global_position
	var route_end := _prism_link_target_zone.global_position
	var midpoint := route_start.lerp(route_end, 0.5)
	var linking := _is_player_on_link_route(route_start, route_end, 62.0)
	_prism_focus_zone.active = linking
	_prism_link_target_zone.active = linking
	var nearby_pressure := _count_enemies_in_radius(midpoint, 160.0)
	if linking:
		var pressure_bonus := minf(0.55, float(nearby_pressure) * 0.028)
		_prism_focus_progress = minf(1.0, _prism_focus_progress + delta * (0.26 + pressure_bonus))
		if _prism_link_visual_timer <= 0.0:
			_spawn_rule_link_effect(route_start, _player.global_position, 6.8, Color(0.82, 0.96, 1.0), Color(0.36, 0.64, 1.0), 0.14)
			_spawn_rule_link_effect(_player.global_position, route_end, 6.8, Color(0.82, 0.96, 1.0), Color(0.36, 0.64, 1.0), 0.14)
			_prism_link_visual_timer = 0.18
	else:
		_prism_focus_progress = maxf(0.0, _prism_focus_progress - delta * 0.12)

	_prism_focus_zone.progress = _prism_focus_progress
	_prism_link_target_zone.progress = _prism_focus_progress
	_prism_focus_zone.sublabel = "站在线路中段 %.0f%%" % (_prism_focus_progress * 100.0)
	_prism_link_target_zone.sublabel = "把自己当中继"
	if _prism_focus_progress < 1.0:
		return

	var center := midpoint
	var radius := _prism_focus_zone.radius
	var beam_damage: int = max(10, int(round(float(_get_wave_rank()) * 1.9)))
	var excluded: Array[EnemySoldier] = []
	_emit_chain_followup(center, excluded, 5, 210.0, beam_damage, 180.0, 4.6)
	_apply_line_current_health_damage(route_start, route_end, 72.0, 0.15, 220.0)
	_damage_enemies_in_radius(center, radius * 1.18, beam_damage, 180.0, 6)
	_award_score(102 + _get_wave_rank() * 16)
	_spawn_effect(center, radius * 1.12, Color(0.88, 0.98, 1.0), Color(0.42, 0.72, 1.0), 0.34)
	_prism_focus_zone.queue_free()
	_prism_link_target_zone.queue_free()
	_prism_focus_zone = null
	_prism_link_target_zone = null
	_prism_focus_progress = 0.0
	_prism_focus_respawn_timer = 30.0
	_prism_overcharge_timer = 20.0
	_prism_link_visual_timer = 0.0
	_show_message("连线完成：折光链路被拉满，20 秒内冷却、得分和技能强度同步提升。", Color(0.86, 0.96, 1.0), 2.8)


func _spawn_prism_focus() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	var center := _pick_hazard_focus_position(170.0, 310.0)
	var direction := Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
	var half_span := _rng.randf_range(128.0, 168.0)
	var start_position := center - direction * half_span
	var end_position := center + direction * half_span
	for _attempt in range(12):
		center = _pick_hazard_focus_position(170.0, 310.0)
		direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		half_span = _rng.randf_range(128.0, 168.0)
		start_position = center - direction * half_span
		end_position = center + direction * half_span
		if not _is_position_blocked(start_position, 44.0) and not _is_position_blocked(end_position, 44.0):
			break

	_prism_focus_zone = MAP_RULE_ZONE_SCRIPT.new()
	_prism_focus_zone.global_position = start_position
	_prism_focus_zone.radius = 72.0
	_prism_focus_zone.primary_color = Color(0.54, 0.88, 1.0, 0.94)
	_prism_focus_zone.secondary_color = Color(0.94, 0.98, 1.0, 0.88)
	_prism_focus_zone.label = "折光端点"
	_prism_focus_zone.sublabel = "准备连线"
	_prism_focus_zone.icon_style = "prism"
	_prism_focus_zone.progress = 0.0
	_hazard_root.add_child(_prism_focus_zone)
	_prism_link_target_zone = MAP_RULE_ZONE_SCRIPT.new()
	_prism_link_target_zone.global_position = end_position
	_prism_link_target_zone.radius = 72.0
	_prism_link_target_zone.primary_color = Color(0.54, 0.88, 1.0, 0.94)
	_prism_link_target_zone.secondary_color = Color(0.94, 0.98, 1.0, 0.88)
	_prism_link_target_zone.label = "折光端点"
	_prism_link_target_zone.sublabel = "站到线路中段"
	_prism_link_target_zone.icon_style = "prism"
	_prism_link_target_zone.progress = 0.0
	_hazard_root.add_child(_prism_link_target_zone)
	_prism_link_visual_timer = 0.0
	_show_message("折光端点出现：站到两端棱镜之间，把链路连起来。", Color(0.84, 0.96, 1.0), 2.6)


func _spawn_prism_lance_hazard() -> void:
	if _player == null or not is_instance_valid(_player):
		return
	var direction := _get_player_target_direction(960.0).rotated(_rng.randf_range(-0.36, 0.36))
	var center := _pick_hazard_focus_position(80.0, 180.0)
	var span := _rng.randf_range(300.0, 380.0)
	_spawn_prism_lance_warning(center - direction * span, center + direction * span, 34.0 + float(_threat_phase) * 2.0, 0.76)


func _spawn_prism_lance_warning(start_position: Vector2, end_position: Vector2, width: float, warning_duration: float) -> void:
	var segments := 5
	for index in range(segments):
		var t := float(index) / float(max(segments - 1, 1))
		var marker_position := start_position.lerp(end_position, t)
		var marker: MeteorHazard = METEOR_HAZARD_SCRIPT.new()
		marker.global_position = marker_position
		marker.warning_duration = warning_duration
		marker.linger_duration = 0.18
		marker.damage_radius = width * 0.62
		marker.current_health_ratio = 0.0
		marker.knockback = 0.0
		marker.primary_color = Color(0.84, 0.96, 1.0)
		marker.secondary_color = Color(0.46, 0.74, 1.0)
		marker.impact.connect(_on_prism_lance_marker_impact)
		_hazard_root.add_child(marker)
	var timer := get_tree().create_timer(warning_duration, false)
	timer.timeout.connect(_trigger_prism_lance_damage.bind(start_position, end_position, width))


func _on_prism_lance_marker_impact(position: Vector2, radius: float, _current_health_ratio: float, _knockback: float) -> void:
	_spawn_effect(position, radius * 1.14, Color(0.92, 0.98, 1.0), Color(0.42, 0.72, 1.0), 0.16)


func _trigger_prism_lance_damage(start_position: Vector2, end_position: Vector2, width: float) -> void:
	_apply_line_current_health_damage(start_position, end_position, width, 0.14, 240.0)
	for index in range(6):
		var t := float(index) / 5.0
		_spawn_effect(start_position.lerp(end_position, t), width * 0.90, Color(0.92, 0.98, 1.0), Color(0.42, 0.72, 1.0), 0.16)
	_audio.play_enemy_shot(true)


func _update_clockwork_garden_rule(delta: float) -> void:
	if _clock_node_zone == null or not is_instance_valid(_clock_node_zone):
		_clock_node_respawn_timer = maxf(0.0, _clock_node_respawn_timer - delta)
		if _clock_node_respawn_timer <= 0.0:
			_spawn_clock_node()
		return

	var radius := _clock_node_zone.radius
	var inside := _player != null and is_instance_valid(_player) and _player.global_position.distance_to(_clock_node_zone.global_position) <= radius + _player.get_body_radius()
	_clock_node_zone.active = inside
	var nearby_pressure := _count_enemies_in_radius(_clock_node_zone.global_position, radius * 1.26)
	if inside:
		var pressure_bonus := minf(0.50, float(nearby_pressure) * 0.022)
		_clock_node_progress = minf(1.0, _clock_node_progress + delta * (0.32 + pressure_bonus))
	else:
		_clock_node_progress = maxf(0.0, _clock_node_progress - delta * 0.12)

	_clock_node_zone.progress = _clock_node_progress
	_clock_node_zone.sublabel = "抢占中 %.0f%%" % (_clock_node_progress * 100.0)
	if _clock_node_progress < 1.0:
		return

	var center := _clock_node_zone.global_position
	_damage_enemies_in_radius(center, radius * 1.10, max(11, int(round(float(_get_wave_rank()) * 2.0))), 220.0, 7)
	_award_score(98 + _get_wave_rank() * 18)
	_spawn_effect(center, radius * 1.06, Color(1.0, 0.92, 0.72), Color(0.92, 0.70, 0.32), 0.32)
	_clock_node_zone.queue_free()
	_clock_node_zone = null
	_clock_node_progress = 0.0
	_clock_node_respawn_timer = 32.0
	_clock_overdrive_timer = 20.0
	_show_message("抢占成功：节点被你拿下，20 秒内移速、冷却和得分略有提升。", Color(1.0, 0.90, 0.66), 2.8)


func _spawn_clock_node() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	_clock_node_zone = MAP_RULE_ZONE_SCRIPT.new()
	_clock_node_zone.global_position = _pick_hazard_focus_position(160.0, 300.0)
	_clock_node_zone.radius = 90.0
	_clock_node_zone.primary_color = Color(0.96, 0.78, 0.34, 0.94)
	_clock_node_zone.secondary_color = Color(0.98, 0.96, 0.82, 0.86)
	_clock_node_zone.label = "抢占节点"
	_clock_node_zone.sublabel = "站稳并夺下节点"
	_clock_node_zone.icon_style = "gear"
	_clock_node_zone.progress = 0.0
	_hazard_root.add_child(_clock_node_zone)
	_show_message("抢占节点出现：站稳把它拿下，可换来一段短促超频。", Color(1.0, 0.88, 0.62), 2.6)


func _spawn_gear_sweep_hazard() -> void:
	if _player == null or not is_instance_valid(_player):
		return
	_spawn_gear_sweep_warning(_pick_hazard_focus_position(70.0, 170.0), 3 + int(_threat_phase >= 4), 240.0, 34.0 + float(_threat_phase) * 2.0, 0.74)


func _spawn_gear_sweep_warning(center: Vector2, spoke_count: int, radius: float, width: float, warning_duration: float) -> void:
	for spoke_index in range(spoke_count):
		var angle := TAU * float(spoke_index) / float(max(spoke_count, 1)) + 0.16
		var direction := Vector2.RIGHT.rotated(angle)
		var marker: MeteorHazard = METEOR_HAZARD_SCRIPT.new()
		marker.global_position = center + direction * radius * 0.42
		marker.warning_duration = warning_duration
		marker.linger_duration = 0.18
		marker.damage_radius = width * 0.68
		marker.current_health_ratio = 0.0
		marker.knockback = 0.0
		marker.primary_color = Color(1.0, 0.88, 0.54)
		marker.secondary_color = Color(0.94, 0.62, 0.26)
		marker.impact.connect(_on_gear_sweep_marker_impact)
		_hazard_root.add_child(marker)
	var timer := get_tree().create_timer(warning_duration, false)
	timer.timeout.connect(_trigger_gear_sweep_damage.bind(center, spoke_count, radius, width))


func _on_gear_sweep_marker_impact(position: Vector2, radius: float, _current_health_ratio: float, _knockback: float) -> void:
	_spawn_effect(position, radius * 1.10, Color(1.0, 0.92, 0.72), Color(0.92, 0.64, 0.24), 0.16)


func _trigger_gear_sweep_damage(center: Vector2, spoke_count: int, radius: float, width: float) -> void:
	for spoke_index in range(spoke_count):
		var angle := TAU * float(spoke_index) / float(max(spoke_count, 1)) + 0.16
		var direction := Vector2.RIGHT.rotated(angle)
		var end_position := center + direction * radius
		_apply_line_current_health_damage(center, end_position, width, 0.13, 250.0)
		for point_index in range(4):
			var t := float(point_index) / 3.0
			_spawn_effect(center.lerp(end_position, t), width * 0.82, Color(1.0, 0.92, 0.72), Color(0.92, 0.64, 0.24), 0.14)
	_audio.play_enemy_shot(true)


func _is_map_reversal_active() -> bool:
	return _run_time >= 240.0 or _threat_phase >= 3


func _update_bridge_train_rule(delta: float) -> void:
	if _player != null and is_instance_valid(_player):
		_player.set_move_speed_multiplier(1.12 if _train_rush_timer > 0.0 else 1.0)
	if _train_car_zones.is_empty():
		_train_car_respawn_timer = maxf(0.0, _train_car_respawn_timer - delta)
		if _train_car_respawn_timer <= 0.0:
			_spawn_train_cars()
		return

	var move_speed := 108.0 if _is_map_reversal_active() else 94.0
	var first_position := Vector2.ZERO
	var last_position := Vector2.ZERO
	for index in range(_train_car_zones.size()):
		var zone := _train_car_zones[index]
		if zone == null or not is_instance_valid(zone):
			_clear_train_car_zones()
			_train_car_respawn_timer = 10.0
			return
		zone.global_position += _train_car_move_direction * move_speed * delta
		zone.active = index == _train_car_active_index
		zone.progress = _train_car_progress
		if _train_break_index == index:
			zone.label = "断节 %d" % (index + 1)
			zone.sublabel = "诱爆陷阱"
			zone.primary_color = Color(0.90, 0.40, 0.36, 0.90)
			zone.secondary_color = Color(1.0, 0.90, 0.72, 0.82)
			zone.icon_style = "core"
		else:
			zone.label = "车节 %d" % (index + 1)
			zone.sublabel = "跳上这节" if index == _train_car_active_index else ("已稳住" if index < _train_car_active_index else "继续前跨")
			zone.primary_color = Color(0.88, 0.94, 1.0, 0.92)
			zone.secondary_color = Color(1.0, 0.80, 0.46, 0.86)
			zone.icon_style = "gear"
		if index == 0:
			first_position = zone.global_position
		last_position = zone.global_position

	if _train_car_active_index >= _train_car_zones.size():
		_spawn_rule_link_effect(first_position, last_position, 7.2, Color(0.92, 0.96, 1.0), Color(1.0, 0.80, 0.46), 0.20)
		_apply_line_damage(first_position, last_position, 82.0, max(12, int(round(float(_get_wave_rank()) * 2.1))), 240.0, 8)
		_award_score(110 + _get_wave_rank() * 18)
		_train_rush_timer = 22.0
		_show_message("跨车成功：整列车暂时稳住，22 秒内移速、冷却和得分一起抬升。", Color(0.94, 0.96, 1.0), 2.8)
		_clear_train_car_zones()
		_train_car_respawn_timer = 32.0
		_train_car_progress = 0.0
		return

	var current_zone := _train_car_zones[_train_car_active_index]
	if current_zone != null and is_instance_valid(current_zone) and _is_player_in_rule_zone(current_zone, 12.0):
		if _train_break_index == _train_car_active_index:
			var break_center := current_zone.global_position
			_spawn_effect(break_center, current_zone.radius * 1.24, Color(1.0, 0.70, 0.34), Color(0.92, 0.22, 0.16), 0.20)
			_apply_area_current_health_damage(break_center, current_zone.radius * 1.06, 0.12, 220.0)
			_spawn_prelude_blast_marker(break_center, current_zone.radius * 0.92, 0.10, 200.0, 0.58, Color(1.0, 0.86, 0.50), Color(0.92, 0.24, 0.16))
			_train_car_move_direction = -_train_car_move_direction
			_train_break_index = -1
			_train_car_active_index += 1
			_train_car_progress = clampf(float(_train_car_active_index) / float(max(_train_car_zones.size(), 1)), 0.0, 1.0)
			_show_message("断节诱爆：列车节奏反转，立刻追下一节。", Color(1.0, 0.84, 0.62), 1.8)
			return
		_spawn_effect(current_zone.global_position, current_zone.radius * 0.88, Color(0.90, 0.96, 1.0), Color(1.0, 0.78, 0.42), 0.14)
		_train_car_active_index += 1
		_train_car_progress = clampf(float(_train_car_active_index) / float(max(_train_car_zones.size(), 1)), 0.0, 1.0)
		if _train_car_active_index < _train_car_zones.size():
			_show_message("跨车成功：继续追前方车节。", Color(0.92, 0.96, 1.0), 1.2)
		return

	if _player != null and is_instance_valid(_player):
		var center := current_zone.global_position if current_zone != null and is_instance_valid(current_zone) else last_position
		if _player.global_position.distance_to(center) > 680.0:
			_clear_train_car_zones()
			_train_car_respawn_timer = 8.0
			_train_car_progress = 0.0
			_train_car_active_index = 0


func _spawn_train_cars() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	_clear_train_car_zones()
	_train_car_move_direction = Vector2.RIGHT.rotated(_rng.randf_range(-0.55, 0.55)).normalized()
	var side := _train_car_move_direction.orthogonal()
	var anchor := _pick_hazard_focus_position(180.0, 260.0) - _train_car_move_direction * 180.0
	var car_count := 4 if _is_map_reversal_active() else 3
	for index in range(car_count):
		var zone := MAP_RULE_ZONE_SCRIPT.new()
		zone.global_position = anchor + _train_car_move_direction * float(index) * 170.0 + side * (16.0 if index % 2 == 0 else -16.0)
		zone.radius = 62.0
		zone.primary_color = Color(0.88, 0.94, 1.0, 0.92)
		zone.secondary_color = Color(1.0, 0.80, 0.46, 0.86)
		zone.icon_style = "gear"
		zone.progress = 0.0
		zone.label = "车节 %d" % (index + 1)
		zone.sublabel = "连续跨车"
		_hazard_root.add_child(zone)
		_train_car_zones.append(zone)
	_train_break_index = -1
	if _is_map_reversal_active() and _train_car_zones.size() >= 3:
		_train_break_index = _rng.randi_range(1, _train_car_zones.size() - 2)
	_train_car_active_index = 0
	_train_car_progress = 0.0
	if _train_break_index >= 0:
		_show_message("列车规则反转：车节里混入断节陷阱，踩中会诱爆并反向。", Color(0.98, 0.90, 0.68), 2.8)
	else:
		_show_message("列车规则启动：顺着亮起的车节连续跨过去，别让整列车失步。", Color(0.92, 0.96, 1.0), 2.8)


func _clear_train_car_zones() -> void:
	for zone in _train_car_zones:
		if zone != null and is_instance_valid(zone):
			zone.queue_free()
	_train_car_zones.clear()
	_train_break_index = -1


func _update_black_fog_rule(delta: float) -> void:
	if _fog_light_timer <= 0.0:
		_fog_pulse_timer = maxf(0.0, _fog_pulse_timer - delta)
		if _fog_pulse_timer <= 0.0:
			_trigger_black_fog_pulse()
			_fog_pulse_timer = 3.2
	else:
		_fog_pulse_timer = 1.6

	if _is_map_reversal_active():
		_update_black_fog_fake_brazier(delta)

	if _fog_brazier_zone == null or not is_instance_valid(_fog_brazier_zone):
		_fog_brazier_respawn_timer = maxf(0.0, _fog_brazier_respawn_timer - delta)
		if _fog_brazier_respawn_timer <= 0.0:
			_spawn_black_fog_brazier()
	else:
		var inside := _is_player_in_rule_zone(_fog_brazier_zone, 10.0)
		_fog_brazier_zone.active = inside
		if inside:
			_fog_brazier_progress = minf(1.0, _fog_brazier_progress + delta * 0.40)
		else:
			_fog_brazier_progress = maxf(0.0, _fog_brazier_progress - delta * 0.08)
		_fog_brazier_zone.progress = _fog_brazier_progress
		_fog_brazier_zone.sublabel = "点亮 %.0f%%" % (_fog_brazier_progress * 100.0)
		if _fog_brazier_progress >= 1.0:
			var center := _fog_brazier_zone.global_position
			_spawn_effect(center, _fog_brazier_zone.radius * 1.12, Color(1.0, 0.86, 0.56), Color(1.0, 0.96, 0.86), 0.26)
			_damage_enemies_in_radius(center, _fog_brazier_zone.radius * 1.12, max(10, int(round(float(_get_wave_rank()) * 1.8))), 180.0, 6)
			_award_score(102 + _get_wave_rank() * 16)
			_fog_brazier_zone.queue_free()
			_fog_brazier_zone = null
			if _fog_fake_brazier_zone != null and is_instance_valid(_fog_fake_brazier_zone):
				_fog_fake_brazier_zone.queue_free()
				_fog_fake_brazier_zone = null
				_fog_fake_brazier_progress = 0.0
			_fog_brazier_progress = 0.0
			_fog_brazier_respawn_timer = 28.0
			_fog_light_timer = 24.0
			_show_message("猎灯点亮：24 秒内黑雾后退，经验、得分和移速同步回暖。", Color(1.0, 0.90, 0.62), 2.8)

	if _player != null and is_instance_valid(_player):
		if _fog_light_timer > 0.0:
			_player.set_move_speed_multiplier(1.08)
		else:
			_player.set_move_speed_multiplier(0.84)


func _update_black_fog_fake_brazier(delta: float) -> void:
	if _fog_fake_brazier_zone == null or not is_instance_valid(_fog_fake_brazier_zone):
		return
	var inside := _is_player_in_rule_zone(_fog_fake_brazier_zone, 10.0)
	_fog_fake_brazier_zone.active = inside
	if inside:
		_fog_fake_brazier_progress = minf(1.0, _fog_fake_brazier_progress + delta * 0.58)
	else:
		_fog_fake_brazier_progress = maxf(0.0, _fog_fake_brazier_progress - delta * 0.14)
	_fog_fake_brazier_zone.progress = _fog_fake_brazier_progress
	_fog_fake_brazier_zone.sublabel = "校准 %.0f%%" % (_fog_fake_brazier_progress * 100.0)
	if _fog_fake_brazier_progress < 1.0:
		return
	var center := _fog_fake_brazier_zone.global_position
	_spawn_effect(center, _fog_fake_brazier_zone.radius * 1.18, Color(0.92, 0.66, 0.44), Color(0.94, 0.24, 0.18), 0.24)
	_apply_area_current_health_damage(center, _fog_fake_brazier_zone.radius * 1.10, 0.11, 210.0)
	_spawn_prelude_blast_marker(center, _fog_fake_brazier_zone.radius * 0.84, 0.10, 210.0, 0.56, Color(1.0, 0.84, 0.54), Color(0.94, 0.24, 0.18))
	_fog_fake_brazier_zone.queue_free()
	_fog_fake_brazier_zone = null
	_fog_fake_brazier_progress = 0.0
	_fog_pulse_timer = minf(_fog_pulse_timer, 0.8)
	_show_message("误触伪灯：黑雾诱爆，优先找真正猎灯。", Color(0.98, 0.84, 0.62), 2.0)


func _spawn_black_fog_fake_brazier(anchor: Vector2) -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	if _fog_fake_brazier_zone != null and is_instance_valid(_fog_fake_brazier_zone):
		return
	var offset_dir := Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
	_fog_fake_brazier_zone = MAP_RULE_ZONE_SCRIPT.new()
	_fog_fake_brazier_zone.global_position = anchor + offset_dir * _rng.randf_range(120.0, 180.0)
	_fog_fake_brazier_zone.radius = 74.0
	_fog_fake_brazier_zone.primary_color = Color(0.92, 0.62, 0.36, 0.88)
	_fog_fake_brazier_zone.secondary_color = Color(1.0, 0.90, 0.76, 0.76)
	_fog_fake_brazier_zone.label = "伪猎灯"
	_fog_fake_brazier_zone.sublabel = "高亮异常"
	_fog_fake_brazier_zone.icon_style = "core"
	_fog_fake_brazier_zone.progress = 0.0
	_hazard_root.add_child(_fog_fake_brazier_zone)
	_fog_fake_brazier_progress = 0.0


func _spawn_black_fog_brazier() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	_fog_brazier_zone = MAP_RULE_ZONE_SCRIPT.new()
	_fog_brazier_zone.global_position = _pick_hazard_focus_position(150.0, 280.0)
	_fog_brazier_zone.radius = 78.0
	_fog_brazier_zone.primary_color = Color(1.0, 0.82, 0.50, 0.92)
	_fog_brazier_zone.secondary_color = Color(1.0, 0.96, 0.86, 0.84)
	_fog_brazier_zone.label = "猎灯"
	_fog_brazier_zone.sublabel = "站入点亮"
	_fog_brazier_zone.icon_style = "altar"
	_fog_brazier_zone.progress = 0.0
	_hazard_root.add_child(_fog_brazier_zone)
	if _is_map_reversal_active():
		_spawn_black_fog_fake_brazier(_fog_brazier_zone.global_position)
	_show_message("黑雾翻涌：尽快点亮猎灯，不然整张图会继续偏向怪群。", Color(1.0, 0.90, 0.62), 2.6)


func _trigger_black_fog_pulse() -> void:
	if _player == null or not is_instance_valid(_player):
		return
	var center := _player.global_position + Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)) * _rng.randf_range(70.0, 150.0)
	_spawn_prelude_blast_marker(center, 54.0, 0.10, 180.0, 0.70, Color(0.44, 0.48, 0.56), Color(0.96, 0.82, 0.56))
	if _message_timer <= 0.1:
		_show_message("失光：黑雾正在贴近，先找下一盏猎灯。", Color(0.92, 0.88, 0.74), 1.6)


func _update_airship_breach_rule(delta: float) -> void:
	if _airship_breach_zone == null or not is_instance_valid(_airship_breach_zone):
		_airship_breach_respawn_timer = maxf(0.0, _airship_breach_respawn_timer - delta)
		if _airship_breach_respawn_timer <= 0.0:
			_spawn_airship_breach()
		return

	if _is_map_reversal_active():
		if _airship_breach_drift_direction == Vector2.ZERO:
			_airship_breach_drift_direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)).normalized()
		var drift_speed := 34.0 + float(_threat_phase) * 4.0
		_airship_breach_zone.global_position += _airship_breach_drift_direction * drift_speed * delta
		if _player != null and is_instance_valid(_player):
			var separation := _airship_breach_zone.global_position - _player.global_position
			if separation.length() > 360.0:
				_airship_breach_drift_direction = (-separation).normalized()
	else:
		_airship_breach_drift_direction = Vector2.ZERO

	_airship_gust_timer = maxf(0.0, _airship_gust_timer - delta)
	if _airship_gust_timer <= 0.0:
		_trigger_airship_gust(_airship_breach_zone.global_position, _airship_breach_zone.radius + 168.0)
		_airship_gust_timer = maxf(2.1, 3.5 - float(_threat_phase) * 0.18)

	var inside := _is_player_in_rule_zone(_airship_breach_zone, 14.0)
	_airship_breach_zone.active = inside
	var nearby_pressure := _count_enemies_in_radius(_airship_breach_zone.global_position, _airship_breach_zone.radius * 1.22)
	if inside:
		var gain := 0.26 + minf(0.20, float(nearby_pressure) * 0.02)
		_airship_breach_progress = minf(1.0, _airship_breach_progress + delta * gain)
	else:
		_airship_breach_progress = maxf(0.0, _airship_breach_progress - delta * 0.10)
	_airship_breach_zone.progress = _airship_breach_progress
	_airship_breach_zone.sublabel = "逆风封舱 %.0f%%" % (_airship_breach_progress * 100.0) if _is_map_reversal_active() else ("封舱 %.0f%%" % (_airship_breach_progress * 100.0))

	if _airship_breach_progress < 1.0:
		return

	var center := _airship_breach_zone.global_position
	_spawn_effect(center, _airship_breach_zone.radius * 1.18, Color(0.82, 0.94, 1.0), Color(1.0, 0.94, 0.80), 0.28)
	_fire_airship_broadside(center)
	_award_score(108 + _get_wave_rank() * 18)
	_airship_tailwind_timer = 20.0
	_airship_breach_zone.queue_free()
	_airship_breach_zone = null
	_airship_breach_progress = 0.0
	_airship_breach_respawn_timer = 30.0
	_airship_gust_timer = 2.4
	_airship_breach_drift_direction = Vector2.ZERO
	_show_message("封舱成功：甲板暂时稳住，20 秒内法术威力、冷却和得分同步抬升。", Color(0.88, 0.96, 1.0), 2.8)


func _spawn_airship_breach() -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	_airship_breach_zone = MAP_RULE_ZONE_SCRIPT.new()
	_airship_breach_zone.global_position = _pick_hazard_focus_position(160.0, 280.0)
	_airship_breach_zone.radius = 82.0
	_airship_breach_zone.primary_color = Color(0.74, 0.90, 1.0, 0.92)
	_airship_breach_zone.secondary_color = Color(0.98, 0.96, 0.88, 0.84)
	_airship_breach_zone.label = "裂甲破口"
	_airship_breach_zone.sublabel = "顶住风压封舱"
	_airship_breach_zone.icon_style = "core"
	_airship_breach_zone.progress = 0.0
	_hazard_root.add_child(_airship_breach_zone)
	_airship_gust_direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)).normalized()
	_airship_breach_drift_direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU)).normalized() if _is_map_reversal_active() else Vector2.ZERO
	_show_message("空艇裂甲出现：顶住风压，把这道破口强行封住。", Color(0.86, 0.94, 1.0), 2.6)


func _trigger_airship_gust(center: Vector2, radius: float) -> void:
	if _is_map_reversal_active() and _airship_breach_drift_direction != Vector2.ZERO:
		_airship_gust_direction = (-_airship_breach_drift_direction).rotated(_rng.randf_range(-0.22, 0.22)).normalized()
	else:
		_airship_gust_direction = _airship_gust_direction.rotated(_rng.randf_range(-0.55, 0.55)).normalized()
	if _airship_gust_direction == Vector2.ZERO:
		_airship_gust_direction = Vector2.RIGHT
	var start_position := center - _airship_gust_direction.orthogonal() * radius
	var end_position := center + _airship_gust_direction.orthogonal() * radius
	_spawn_rule_link_effect(start_position, end_position, 6.0, Color(0.76, 0.90, 1.0), Color(0.98, 0.96, 0.88), 0.18)
	_apply_line_current_health_damage(start_position, end_position, 44.0, 0.10, 240.0)
	for index in range(5):
		var t := float(index) / 4.0
		_spawn_effect(start_position.lerp(end_position, t), 34.0, Color(0.78, 0.92, 1.0), Color(0.98, 0.96, 0.88), 0.12)


func _fire_airship_broadside(center: Vector2) -> void:
	var direction := _airship_gust_direction if _airship_gust_direction != Vector2.ZERO else Vector2.RIGHT
	var side := direction.orthogonal()
	for lane in range(3):
		var offset := (float(lane) - 1.0) * 96.0
		var start_position := center - direction * 340.0 + side * offset
		var end_position := center + direction * 340.0 + side * offset
		_spawn_rule_link_effect(start_position, end_position, 5.4, Color(0.86, 0.96, 1.0), Color(0.96, 0.86, 0.60), 0.18)
		_apply_line_damage(start_position, end_position, 32.0, max(12, int(round(float(_get_wave_rank()) * 2.0))), 240.0, 5)


func _count_void_pools_in_radius(center: Vector2, radius: float) -> int:
	var count := 0
	for pool_variant in _void_pools:
		var pool: Dictionary = pool_variant
		var node := pool.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			continue
		var pool_radius := float(pool.get("radius", 76.0))
		if center.distance_to(node.global_position) <= radius + pool_radius:
			count += 1
	return count


func _should_trigger_void_pool(node: MapRuleZone, radius: float) -> bool:
	for projectile_variant in _projectiles:
		var projectile: SpellProjectile = projectile_variant
		if projectile == null or not is_instance_valid(projectile):
			continue
		if projectile.global_position.distance_to(node.global_position) <= radius:
			return true
	return false


func _explode_void_pool(pool: Dictionary) -> void:
	var node := pool.get("node", null) as MapRuleZone
	if node == null or not is_instance_valid(node):
		return
	var center := node.global_position
	var radius := float(pool.get("radius", 76.0)) * 1.16
	_spawn_effect(center, radius * 1.08, Color(0.86, 0.98, 0.62), Color(0.24, 0.50, 0.18), 0.32)
	_apply_area_current_health_damage(center, radius, 0.14, 220.0)
	node.queue_free()


func _clear_void_pools_in_radius(center: Vector2, radius: float) -> void:
	for index in range(_void_pools.size() - 1, -1, -1):
		var pool: Dictionary = _void_pools[index]
		var node := pool.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			_void_pools.remove_at(index)
			continue
		var pool_radius := float(pool.get("radius", 76.0))
		if center.distance_to(node.global_position) > radius + pool_radius:
			continue
		if String(pool.get("kind", "")) == "pool":
			_explode_void_pool(pool)
		else:
			node.queue_free()
		_void_pools.remove_at(index)


func _trigger_void_pool_explosions(center: Vector2, radius: float) -> void:
	for index in range(_void_pools.size() - 1, -1, -1):
		var pool: Dictionary = _void_pools[index]
		if String(pool.get("kind", "")) != "pool":
			continue
		var node := pool.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			_void_pools.remove_at(index)
			continue
		var pool_radius := float(pool.get("radius", 76.0))
		if center.distance_to(node.global_position) <= radius + pool_radius:
			_explode_void_pool(pool)
			_void_pools.remove_at(index)


func _apply_next_world_mutation() -> void:
	var mutation: Dictionary = ENDLESS_WORLD_MUTATIONS[_world_mutation_index % ENDLESS_WORLD_MUTATIONS.size()]
	_world_mutation_index += 1
	_active_world_mutations.append(String(mutation.get("name", "世界变异")))
	_endless_spawn_bonus += float(mutation.get("spawn_bonus", 0.0))
	_endless_elite_bonus += float(mutation.get("elite_bonus", 0.0))
	_endless_enemy_speed_bonus += float(mutation.get("speed_bonus", 0.0))
	_endless_enemy_health_bonus += float(mutation.get("health_bonus", 0.0))
	_endless_hazard_bonus += float(mutation.get("hazard_bonus", 0.0))
	_endless_boss_interval_scale *= float(mutation.get("boss_scale", 1.0))
	_score_bonus_multiplier += float(mutation.get("score_bonus", 0.0))
	_show_message("%s: %s" % [String(mutation.get("name", "世界变异")), String(mutation.get("summary", ""))], Color(1.0, 0.92, 0.64), 3.0)


func _get_latest_world_mutation_name() -> String:
	if _active_world_mutations.is_empty():
		return "无"
	return _active_world_mutations[_active_world_mutations.size() - 1]


func _update_blood_hunter_attacks(delta: float) -> void:
	_oathshot_timer -= delta
	if _oathshot_timer <= 0.0:
		if _fire_oathshots():
			_oathshot_timer = _get_oathshot_cooldown()
		else:
			_oathshot_timer = 0.10

	if _brand_level > 0:
		_brand_timer -= delta
		if _brand_timer <= 0.0:
			if _cast_blood_brand():
				_brand_timer = _get_brand_cooldown()
			else:
				_brand_timer = 0.24

	if _bloodtrail_level > 0:
		_bloodtrail_timer -= delta
		if _bloodtrail_timer <= 0.0:
			if _cast_bloodtrail():
				_bloodtrail_timer = _get_bloodtrail_cooldown()
			else:
				_bloodtrail_timer = 0.24

	if _verdict_level > 0:
		_verdict_timer -= delta
		if _verdict_timer <= 0.0:
			if _cast_verdict():
				_verdict_timer = _get_verdict_cooldown()
			else:
				_verdict_timer = 0.20


func _fire_oathshots() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var targets := _get_nearest_enemies(_player.global_position, _get_oathshot_count(), 900.0)
	if targets.is_empty():
		return false
	var signature_direction := (targets[0].global_position - _player.global_position).normalized()
	_trigger_player_action_signature("blood_draw", 0.18, 0.94, signature_direction)
	for index in range(_get_oathshot_count()):
		var target: EnemySoldier = targets[min(index, targets.size() - 1)]
		if target == null or not is_instance_valid(target):
			continue
		var direction := (target.global_position - _player.global_position).normalized()
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT.rotated(_rng.randf_range(-0.18, 0.18))
		var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
		projectile.global_position = _player.global_position + direction * 24.0
		projectile.direction = direction
		projectile.damage = _get_oathshot_damage()
		projectile.speed = 860.0
		projectile.radius = 6.4
		projectile.pierce = _get_oathshot_pierce()
		projectile.max_distance = 860.0
		projectile.knockback = 170.0
		projectile.tint = Color(0.96, 0.28, 0.34)
		projectile.secondary_tint = Color(1.0, 0.82, 0.80, 0.42)
		projectile.homing_target = target
		projectile.homing_strength = 6.2
		_register_projectile(projectile)
	if signature_direction != Vector2.ZERO:
		_player.set_facing_direction(signature_direction)
	_audio.play_player_shot("rapid")
	return true


func _cast_blood_brand() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var targets := _get_nearest_enemies(_player.global_position, _get_brand_target_count(), 760.0)
	if targets.is_empty():
		return false
	var signature_direction := (targets[0].global_position - _player.global_position).normalized()
	_trigger_player_action_signature("blood_draw", 0.20, 0.86, signature_direction)
	for target_variant in targets:
		var target: EnemySoldier = target_variant
		if target == null or not is_instance_valid(target):
			continue
		_apply_blood_mark(target, 5.2 + float(_brand_level) * 1.1)
		target.take_damage(_get_brand_damage(), signature_direction * 90.0)
		_spawn_rule_link_effect(_player.global_position, target.global_position, 5.0, Color(0.92, 0.24, 0.32), Color(1.0, 0.82, 0.78), 0.18)
		_spawn_effect(target.global_position, 22.0, Color(0.96, 0.30, 0.36), Color(1.0, 0.82, 0.78), 0.12)
	_audio.play_player_shot("power")
	return true


func _cast_bloodtrail() -> bool:
	if _player == null or not is_instance_valid(_player) or _hazard_root == null or not is_instance_valid(_hazard_root):
		return false
	var forward := _player.get_facing_direction()
	if forward == Vector2.ZERO:
		forward = _get_player_target_direction(680.0)
	if forward == Vector2.ZERO:
		forward = Vector2.RIGHT
	var drop_position := _player_previous_position
	if drop_position.distance_to(_player.global_position) < 28.0:
		drop_position = _player.global_position + forward * 48.0
	_spawn_bloodtrail_zone(drop_position)
	_trigger_player_action_signature("blood_draw", 0.18, 0.72, forward)
	_audio.play_player_shot("spread")
	return true


func _cast_verdict() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var targets := _get_nearest_enemies(_player.global_position, 1, _get_verdict_range() + 80.0)
	if targets.is_empty():
		return false
	var primary_target := targets[0]
	if primary_target == null or not is_instance_valid(primary_target):
		return false
	var direction := (primary_target.global_position - _player.global_position).normalized()
	if direction == Vector2.ZERO:
		direction = _player.get_facing_direction()
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	var start_position := _player.global_position
	var end_position := start_position + direction * _get_verdict_range()
	_trigger_player_action_signature("blood_dash", 0.24, 1.06, direction)
	_player.set_facing_direction(direction)
	_spawn_rule_link_effect(start_position, end_position, _get_verdict_width() * 0.42, Color(0.98, 0.30, 0.34), Color(1.0, 0.92, 0.88), 0.18)
	_spawn_slash_effect(start_position + direction * (_get_verdict_range() * 0.34), direction, _get_verdict_width() * 1.6, 0.50)
	_apply_line_damage(start_position, end_position, _get_verdict_width(), _get_verdict_damage(), 260.0, 8)
	if _has_endgame_evolution("evo_hunter_verdict_gallows"):
		var side := direction.orthogonal()
		var side_damage: int = max(1, int(round(float(_get_verdict_damage()) * 0.66)))
		for sign in [-1, 1]:
			var offset_sign := float(sign)
			var side_start: Vector2 = start_position + side * 44.0 * offset_sign
			var side_end: Vector2 = side_start + direction * (_get_verdict_range() * 0.82)
			_spawn_rule_link_effect(side_start, side_end, _get_verdict_width() * 0.30, Color(0.98, 0.44, 0.42), Color(1.0, 0.86, 0.76), 0.16)
			_apply_line_damage(side_start, side_end, _get_verdict_width() * 0.80, side_damage, 210.0, 6)
	_burst_marked_enemies_in_radius(end_position, 92.0, max(1, int(round(float(_get_verdict_damage()) * 0.48))), 220.0)
	_audio.play_player_shot("power")
	return true


func _spawn_bloodtrail_zone(position: Vector2) -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	while _blood_trails.size() >= _get_bloodtrail_limit():
		var oldest: Dictionary = _blood_trails.pop_front()
		var oldest_node := oldest.get("node", null) as MapRuleZone
		if oldest_node != null and is_instance_valid(oldest_node):
			oldest_node.queue_free()
	var zone := MAP_RULE_ZONE_SCRIPT.new()
	zone.global_position = position
	zone.radius = _get_bloodtrail_radius()
	zone.primary_color = Color(0.94, 0.24, 0.32, 0.92)
	zone.secondary_color = Color(1.0, 0.86, 0.82, 0.82)
	zone.label = "血潮沼"
	zone.sublabel = "收割区"
	zone.icon_style = "pool"
	zone.progress = -1.0
	_hazard_root.add_child(zone)
	_blood_trails.append({
		"node": zone,
		"radius": zone.radius,
		"damage": _get_bloodtrail_damage(),
		"lifetime": _get_bloodtrail_duration(),
		"pulse_interval": 0.42 if _has_endgame_evolution("evo_hunter_crimson_delta") else 0.48,
		"pulse_timer": 0.24,
	})


func _apply_blood_mark(enemy: EnemySoldier, duration: float) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	_blood_marks[enemy.get_instance_id()] = {
		"enemy": enemy,
		"timer": duration,
	}


func _is_enemy_blood_marked(enemy: EnemySoldier) -> bool:
	if enemy == null or not is_instance_valid(enemy):
		return false
	return _blood_marks.has(enemy.get_instance_id())


func _burst_marked_enemies_in_radius(center: Vector2, radius: float, damage: int, knockback: float) -> int:
	if damage <= 0:
		return 0
	var hits := 0
	for enemy_id_variant in _blood_marks.keys():
		var entry: Dictionary = _blood_marks.get(enemy_id_variant, {})
		var enemy := entry.get("enemy", null) as EnemySoldier
		if enemy == null or not is_instance_valid(enemy):
			continue
		if center.distance_to(enemy.global_position) > radius + enemy.get_body_radius():
			continue
		var impulse := (enemy.global_position - center).normalized()
		if impulse == Vector2.ZERO:
			impulse = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		enemy.take_damage(damage, impulse * knockback)
		_spawn_effect(enemy.global_position, 26.0, Color(0.98, 0.34, 0.36), Color(1.0, 0.86, 0.82), 0.12)
		hits += 1
	return hits


func _consume_blood_mark(enemy: EnemySoldier) -> void:
	if enemy == null:
		return
	_blood_marks.erase(enemy.get_instance_id())


func _get_missing_health_ratio() -> float:
	if _player == null or not is_instance_valid(_player) or _player.max_health <= 0:
		return 0.0
	return clampf(1.0 - float(_player.health) / float(_player.max_health), 0.0, 1.0)


func _get_blood_bonus_multiplier() -> float:
	return 1.0 + _get_missing_health_ratio() * 0.55


func _get_brand_heal() -> int:
	return 1 + int(_brand_level >= 2) + int(_brand_level >= 4)


func _get_brand_burst_damage() -> int:
	return max(1, int(round((12.0 + float(_brand_level) * 4.0) * _get_spell_power_multiplier() * (1.0 + _get_missing_health_ratio() * 0.25))))


func _get_brand_burst_radius() -> float:
	return 68.0 + float(_brand_level) * 14.0


func _get_oathshot_count() -> int:
	var count := 1 + int(_oathshot_level >= 3) + int(_oathshot_level >= 6)
	if _has_endgame_evolution("evo_hunter_blood_quarry"):
		count += 1
	return count


func _get_oathshot_damage() -> int:
	var damage_multiplier := _get_blood_bonus_multiplier()
	if _has_endgame_evolution("evo_hunter_blood_quarry"):
		damage_multiplier *= 1.14
	return max(1, int(round((16.0 + float(_oathshot_level) * 4.0) * _get_spell_power_multiplier() * damage_multiplier)))


func _get_oathshot_cooldown() -> float:
	var cooldown := (0.84 - float(_oathshot_level) * 0.06) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_hunter_harvest_run"):
		cooldown *= 0.88
	return maxf(0.24, cooldown)


func _get_oathshot_pierce() -> int:
	var pierce := 1 + int(_oathshot_level >= 4) + int(_oathshot_level >= 7)
	if _has_endgame_evolution("evo_hunter_blood_quarry"):
		pierce += 1
	return pierce


func _get_brand_target_count() -> int:
	var count := 1 + _brand_level
	if _has_endgame_evolution("evo_hunter_blood_quarry"):
		count += 2
	return count


func _get_brand_damage() -> int:
	var damage := (8.0 + float(_brand_level) * 3.0) * _get_spell_power_multiplier() * (1.0 + _get_missing_health_ratio() * 0.25)
	if _has_endgame_evolution("evo_hunter_blood_quarry"):
		damage *= 1.18
	return max(1, int(round(damage)))


func _get_brand_cooldown() -> float:
	return maxf(1.0, (4.8 - float(_brand_level) * 0.40) * _get_cooldown_multiplier())


func _get_bloodtrail_radius() -> float:
	var radius := 74.0 + float(_bloodtrail_level) * 18.0
	if _has_endgame_evolution("evo_hunter_crimson_delta"):
		radius *= 1.24
	return radius


func _get_bloodtrail_damage() -> int:
	var damage := (10.0 + float(_bloodtrail_level) * 4.0) * _get_spell_power_multiplier() * (1.0 + _get_missing_health_ratio() * 0.20)
	if _has_endgame_evolution("evo_hunter_crimson_delta"):
		damage *= 1.20
	return max(1, int(round(damage)))


func _get_bloodtrail_cooldown() -> float:
	return maxf(1.3, (4.6 - float(_bloodtrail_level) * 0.36) * _get_cooldown_multiplier())


func _get_bloodtrail_duration() -> float:
	var duration := 5.2 + float(_bloodtrail_level) * 0.7
	if _has_endgame_evolution("evo_hunter_harvest_run"):
		duration += 2.0
	return duration


func _get_bloodtrail_limit() -> int:
	var limit := 1 + int(_bloodtrail_level >= 2) + int(_bloodtrail_level >= 4)
	if _has_endgame_evolution("evo_hunter_harvest_run"):
		limit += 1
	return limit


func _get_verdict_damage() -> int:
	var damage := (24.0 + float(_verdict_level) * 8.0) * _get_spell_power_multiplier() * (1.0 + _get_missing_health_ratio() * 0.70)
	if _has_endgame_evolution("evo_hunter_verdict_gallows"):
		damage *= 1.20
	return max(1, int(round(damage)))


func _get_verdict_cooldown() -> float:
	var cooldown := (5.2 - float(_verdict_level) * 0.44) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_hunter_verdict_gallows"):
		cooldown *= 0.82
	return maxf(1.2, cooldown)


func _get_verdict_range() -> float:
	var range_value := 240.0 + float(_verdict_level) * 44.0
	if _has_endgame_evolution("evo_hunter_verdict_gallows"):
		range_value += 76.0
	return range_value


func _get_verdict_width() -> float:
	var width := 34.0 + float(_verdict_level) * 4.0
	if _has_endgame_evolution("evo_hunter_verdict_gallows"):
		width *= 1.22
	return width


func _update_grave_caller_attacks(delta: float) -> void:
	_dirge_timer -= delta
	if _dirge_timer <= 0.0:
		if _cast_dirge():
			_dirge_timer = _get_dirge_cooldown()
		else:
			_dirge_timer = 0.10

	if _wake_level > 0:
		_wake_timer -= delta
		if _wake_timer <= 0.0:
			if _cast_wake():
				_wake_timer = _get_wake_cooldown()
			else:
				_wake_timer = 0.22

	if _toll_level > 0:
		_toll_timer -= delta
		if _toll_timer <= 0.0:
			if _cast_toll():
				_toll_timer = _get_toll_cooldown()
			else:
				_toll_timer = 0.24

	if _choir_level > 0:
		_choir_timer -= delta
		if _choir_timer <= 0.0:
			if _cast_choir():
				_choir_timer = _get_choir_cooldown()
			else:
				_choir_timer = 0.24


func _cast_dirge() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var origins: Array[Vector2] = [_player.global_position]
	var max_token_origins := 4 if _has_endgame_evolution("evo_grave_dirge_conductor") else 2
	var token_origins := _get_grave_token_positions(mini(_get_dirge_count() - 1, max_token_origins), 640.0)
	origins.append_array(token_origins)
	var targets := _get_nearest_enemies(_player.global_position, maxi(origins.size(), _get_dirge_count()), 880.0)
	if targets.is_empty():
		return false
	var signature_direction := (targets[0].global_position - _player.global_position).normalized()
	_trigger_player_action_signature("dirge_cast", 0.20, 0.92, signature_direction)
	for index in range(origins.size()):
		var origin := origins[index]
		var target := targets[min(index, targets.size() - 1)]
		if target == null or not is_instance_valid(target):
			continue
		var direction := (target.global_position - origin).normalized()
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT.rotated(_rng.randf_range(-0.16, 0.16))
		_spawn_dirge_projectile(origin, direction, target, _get_dirge_damage())
	_audio.play_player_shot("rapid")
	return true


func _cast_wake() -> bool:
	if _grave_tokens.is_empty():
		return false
	var consumed := _consume_grave_tokens(_get_wake_consume_count())
	if consumed.is_empty():
		return false
	var signature_direction := _get_player_target_direction(840.0)
	_trigger_player_action_signature("grave_toll", 0.22, 0.90, signature_direction)
	for token in consumed:
		var position: Vector2 = token.get("position", Vector2.ZERO)
		var target_list := _get_nearest_enemies(position, 1, 680.0)
		_spawn_effect(position, 52.0, Color(0.62, 0.88, 0.78), Color(0.90, 1.0, 0.94), 0.18)
		_damage_enemies_in_radius(position, 68.0, _get_wake_damage(), 170.0, 4)
		if not target_list.is_empty():
			var target := target_list[0]
			if target != null and is_instance_valid(target):
				var direction := (target.global_position - position).normalized()
				_spawn_dirge_projectile(position, direction, target, max(1, int(round(float(_get_wake_damage()) * 0.82))), 0.90)
	if _has_endgame_evolution("evo_grave_wake_engine"):
		for token in consumed:
			var recycled_position: Vector2 = token.get("position", Vector2.ZERO)
			_spawn_grave_token(recycled_position, 5.8, true)
	_audio.play_player_shot("spread")
	return true


func _cast_toll() -> bool:
	if _grave_tokens.is_empty():
		return false
	var pulse_count := mini(_grave_tokens.size(), _get_toll_pulse_count())
	if pulse_count <= 0:
		return false
	_trigger_player_action_signature("grave_toll", 0.20, 0.84, _get_player_target_direction(760.0))
	for index in range(pulse_count):
		var token: Dictionary = _grave_tokens[index]
		var node := token.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			continue
		_spawn_effect(node.global_position, _get_toll_radius() * 0.72, Color(0.60, 0.90, 0.82), Color(0.94, 1.0, 0.96), 0.14)
		_damage_enemies_in_radius(node.global_position, _get_toll_radius(), _get_toll_damage(), 150.0, 5)
		if _has_endgame_evolution("evo_grave_tide_bell"):
			var relay_targets := _get_nearest_enemies(node.global_position, 1, 760.0)
			if not relay_targets.is_empty():
				var relay_target := relay_targets[0]
				if relay_target != null and is_instance_valid(relay_target):
					var relay_direction := (relay_target.global_position - node.global_position).normalized()
					_spawn_dirge_projectile(node.global_position, relay_direction, relay_target, max(1, int(round(float(_get_toll_damage()) * 0.72))), 1.05)
		node.active = true
	_audio.play_player_shot("power")
	return true


func _cast_choir() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var consume_count := _get_choir_consume_count()
	if _has_endgame_evolution("evo_grave_cathedral"):
		consume_count = max(consume_count, _grave_tokens.size())
	var consumed := _consume_grave_tokens(consume_count)
	if consumed.is_empty():
		return false
	var recycled_positions: Array[Vector2] = []
	for token in consumed:
		recycled_positions.append(token.get("position", _player.global_position))
	if _has_endgame_evolution("evo_grave_cathedral"):
		consumed.append({"position": _player.global_position})
	var signature_direction := _get_player_target_direction(920.0)
	_trigger_player_action_signature("grave_toll", 0.24, 1.02, signature_direction)
	var targets := _get_nearest_enemies(_player.global_position, maxi(consumed.size(), 1), 920.0)
	for index in range(consumed.size()):
		var token: Dictionary = consumed[index]
		var origin: Vector2 = token.get("position", _player.global_position)
		var target := targets[min(index, max(targets.size() - 1, 0))] if not targets.is_empty() else null
		var base_direction := signature_direction
		if target != null and is_instance_valid(target):
			base_direction = (target.global_position - origin).normalized()
		for bolt_index in range(_get_choir_projectile_count()):
			var angle_offset := (float(bolt_index) - float(_get_choir_projectile_count() - 1) * 0.5) * 0.16
			var direction := base_direction.rotated(angle_offset)
			_spawn_dirge_projectile(origin, direction, target, _get_choir_damage(), 1.08)
		_spawn_rule_link_effect(origin, _player.global_position, 4.0, Color(0.62, 0.88, 0.80), Color(0.92, 0.98, 0.94), 0.16)
	if _has_endgame_evolution("evo_grave_wake_engine"):
		for recycled_position in recycled_positions:
			_spawn_grave_token(recycled_position, 4.8, true)
	_audio.play_player_shot("power")
	return true


func _spawn_grave_token(position: Vector2, lifetime_override: float = -1.0, recycled: bool = false) -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	while _grave_tokens.size() >= _get_grave_token_limit():
		var oldest: Dictionary = _grave_tokens.pop_front()
		var oldest_node := oldest.get("node", null) as MapRuleZone
		if oldest_node != null and is_instance_valid(oldest_node):
			oldest_node.queue_free()
	var zone := MAP_RULE_ZONE_SCRIPT.new()
	var token_radius := 34.0 if recycled else 42.0
	zone.global_position = position
	zone.radius = token_radius
	zone.primary_color = Color(0.56, 0.86, 0.74, 0.90) if recycled else Color(0.58, 0.88, 0.76, 0.90)
	zone.secondary_color = Color(0.88, 0.98, 0.94, 0.80) if recycled else Color(0.92, 1.0, 0.96, 0.82)
	zone.label = "余烬尸核" if recycled else "尸核"
	zone.sublabel = "回生" if recycled else "待起灵"
	zone.icon_style = "spore"
	zone.progress = -1.0
	_hazard_root.add_child(zone)
	var token_lifetime := lifetime_override if lifetime_override > 0.0 else 12.0 + float(_wake_level) * 2.0
	if _has_endgame_evolution("evo_grave_dirge_conductor"):
		token_lifetime += 2.0
	_grave_tokens.append({
		"node": zone,
		"position": position,
		"lifetime": token_lifetime,
	})


func _get_grave_token_positions(count: int, max_distance: float) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	if _player == null or not is_instance_valid(_player) or count <= 0:
		return positions
	var ranked: Array[Dictionary] = []
	for token in _grave_tokens:
		var node := token.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			continue
		var distance := node.global_position.distance_to(_player.global_position)
		if distance > max_distance:
			continue
		ranked.append({
			"position": node.global_position,
			"distance": distance,
		})
	ranked.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("distance", 0.0)) < float(b.get("distance", 0.0))
	)
	for index in range(mini(count, ranked.size())):
		positions.append(ranked[index].get("position", Vector2.ZERO))
	return positions


func _consume_grave_tokens(count: int) -> Array[Dictionary]:
	var consumed: Array[Dictionary] = []
	if count <= 0 or _player == null or not is_instance_valid(_player):
		return consumed
	var ranked: Array[Dictionary] = []
	for index in range(_grave_tokens.size()):
		var token: Dictionary = _grave_tokens[index]
		var node := token.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			continue
		ranked.append({
			"index": index,
			"distance": node.global_position.distance_to(_player.global_position),
		})
	ranked.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("distance", 0.0)) < float(b.get("distance", 0.0))
	)
	var taken_indices: Array[int] = []
	for rank in range(mini(count, ranked.size())):
		taken_indices.append(int(ranked[rank].get("index", -1)))
	taken_indices.sort()
	for offset in range(taken_indices.size() - 1, -1, -1):
		var source_index := taken_indices[offset]
		if source_index < 0 or source_index >= _grave_tokens.size():
			continue
		var token := _grave_tokens[source_index]
		var node := token.get("node", null) as MapRuleZone
		if node != null and is_instance_valid(node):
			token["position"] = node.global_position
			node.queue_free()
		consumed.append(token)
		_grave_tokens.remove_at(source_index)
	return consumed


func _spawn_dirge_projectile(origin: Vector2, direction: Vector2, target: EnemySoldier, damage: int, speed_scale: float = 1.0) -> void:
	var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
	projectile.global_position = origin
	projectile.direction = direction if direction != Vector2.ZERO else Vector2.RIGHT
	projectile.damage = damage
	projectile.speed = 620.0 * speed_scale
	projectile.radius = 7.6
	projectile.pierce = 1 + int(_dirge_level >= 5)
	projectile.max_distance = 760.0
	projectile.knockback = 150.0
	projectile.tint = Color(0.58, 0.88, 0.78)
	projectile.secondary_tint = Color(0.94, 1.0, 0.96, 0.40)
	projectile.homing_target = target
	projectile.homing_strength = 4.6
	_register_projectile(projectile)


func _get_dirge_count() -> int:
	var count := 1 + int(_dirge_level >= 3) + int(_dirge_level >= 6)
	if _has_endgame_evolution("evo_grave_dirge_conductor"):
		count += 1
	return count


func _get_dirge_damage() -> int:
	var damage := (14.0 + float(_dirge_level) * 4.0) * _get_spell_power_multiplier()
	if _has_endgame_evolution("evo_grave_dirge_conductor"):
		damage *= 1.16
	return max(1, int(round(damage)))


func _get_dirge_cooldown() -> float:
	return maxf(0.40, (0.96 - float(_dirge_level) * 0.08) * _get_cooldown_multiplier())


func _get_wake_damage() -> int:
	return max(1, int(round((18.0 + float(_wake_level) * 6.0) * _get_spell_power_multiplier())))


func _get_wake_cooldown() -> float:
	return maxf(1.2, (5.0 - float(_wake_level) * 0.42) * _get_cooldown_multiplier())


func _get_wake_consume_count() -> int:
	var count := 1 + int(_wake_level >= 2) + int(_wake_level >= 4)
	if _has_endgame_evolution("evo_grave_wake_engine"):
		count += 1
	return count


func _get_toll_damage() -> int:
	var damage := (16.0 + float(_toll_level) * 5.0) * _get_spell_power_multiplier()
	if _has_endgame_evolution("evo_grave_tide_bell"):
		damage *= 1.14
	return max(1, int(round(damage)))


func _get_toll_radius() -> float:
	var radius := 84.0 + float(_toll_level) * 18.0
	if _has_endgame_evolution("evo_grave_tide_bell"):
		radius += 36.0
	return radius


func _get_toll_cooldown() -> float:
	return maxf(1.6, (5.6 - float(_toll_level) * 0.44) * _get_cooldown_multiplier())


func _get_toll_pulse_count() -> int:
	var count := 1 + _toll_level
	if _has_endgame_evolution("evo_grave_tide_bell"):
		count += 2
	return count


func _get_choir_damage() -> int:
	var damage := (12.0 + float(_choir_level) * 4.0) * _get_spell_power_multiplier()
	if _has_endgame_evolution("evo_grave_cathedral"):
		damage *= 1.18
	return max(1, int(round(damage)))


func _get_choir_cooldown() -> float:
	var cooldown := (6.0 - float(_choir_level) * 0.46) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_grave_cathedral"):
		cooldown *= 0.86
	return maxf(1.3, cooldown)


func _get_choir_consume_count() -> int:
	return 1 + int(_choir_level >= 2) + int(_choir_level >= 4)


func _get_choir_projectile_count() -> int:
	var count := 2 + int(_choir_level >= 3)
	if _has_endgame_evolution("evo_grave_cathedral"):
		count += 2
	return count


func _get_grave_token_limit() -> int:
	var limit := 4 + _wake_level + int(_choir_level >= 2)
	if _has_endgame_evolution("evo_grave_tide_bell"):
		limit += 2
	return limit


func _update_illusionist_attacks(delta: float) -> void:
	_mirrorbolt_timer -= delta
	if _mirrorbolt_timer <= 0.0:
		if _fire_mirrorbolts():
			_mirrorbolt_timer = _get_mirrorbolt_cooldown()
		else:
			_mirrorbolt_timer = 0.10

	if _afterimage_level > 0:
		_afterimage_timer -= delta
		if _afterimage_timer <= 0.0:
			if _cast_afterimage():
				_afterimage_timer = _get_afterimage_cooldown()
			else:
				_afterimage_timer = 0.24

	if _switchstep_level > 0:
		_switchstep_timer -= delta
		if _switchstep_timer <= 0.0:
			if _cast_switchstep():
				_switchstep_timer = _get_switchstep_cooldown()
			else:
				_switchstep_timer = 0.24

	if _prismdance_level > 0:
		_prismdance_timer -= delta
		if _prismdance_timer <= 0.0:
			if _cast_prismdance():
				_prismdance_timer = _get_prismdance_cooldown()
			else:
				_prismdance_timer = 0.22


func _fire_mirrorbolts() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var origins: Array[Vector2] = [_player.global_position]
	for index in range(mini(_illusion_decoys.size(), _get_mirrorbolt_decoy_count())):
		var decoy: Dictionary = _illusion_decoys[index]
		var node := decoy.get("node", null) as MapRuleZone
		if node != null and is_instance_valid(node):
			origins.append(node.global_position)
	var targets := _get_nearest_enemies(_player.global_position, maxi(origins.size(), 1), 920.0)
	if targets.is_empty():
		return false
	var signature_direction := (targets[0].global_position - _player.global_position).normalized()
	_trigger_player_action_signature("mirror_cast", 0.20, 0.90, signature_direction)
	for index in range(origins.size()):
		var origin := origins[index]
		var target := targets[min(index, targets.size() - 1)]
		if target == null or not is_instance_valid(target):
			continue
		var direction := (target.global_position - origin).normalized()
		if direction == Vector2.ZERO:
			direction = signature_direction if signature_direction != Vector2.ZERO else Vector2.RIGHT
		var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
		projectile.global_position = origin
		projectile.direction = direction
		projectile.damage = _get_mirrorbolt_damage()
		projectile.speed = 820.0
		projectile.radius = 6.4
		projectile.pierce = 1 + int(_mirrorbolt_level >= 4)
		projectile.max_distance = 860.0
		projectile.knockback = 150.0
		projectile.tint = Color(0.86, 0.72, 1.0)
		projectile.secondary_tint = Color(0.96, 0.92, 1.0, 0.40)
		projectile.homing_target = target
		projectile.homing_strength = 5.0
		_register_projectile(projectile)
		if _has_endgame_evolution("evo_illusion_glass_bloom"):
			for sign in [-1.0, 1.0]:
				var shard: SpellProjectile = PROJECTILE_SCRIPT.new()
				shard.global_position = origin
				shard.direction = direction.rotated(0.17 * sign)
				shard.damage = max(1, int(round(float(_get_mirrorbolt_damage()) * 0.56)))
				shard.speed = 760.0
				shard.radius = 4.8
				shard.pierce = 1
				shard.max_distance = 680.0
				shard.knockback = 100.0
				shard.tint = Color(0.92, 0.84, 1.0)
				shard.secondary_tint = Color(0.98, 0.94, 1.0, 0.36)
				shard.homing_strength = 0.0
				_register_projectile(shard)
	_audio.play_player_shot("rapid")
	return true


func _cast_afterimage() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var position := _player_previous_position
	if position.distance_to(_player.global_position) < 24.0:
		position = _player.global_position - _player.get_facing_direction() * 36.0
	_spawn_illusion_decoy(position)
	return true


func _cast_switchstep() -> bool:
	if _player == null or not is_instance_valid(_player) or _illusion_decoys.is_empty():
		return false
	var selected_index := -1
	var best_distance := -1.0
	for index in range(_illusion_decoys.size()):
		var decoy: Dictionary = _illusion_decoys[index]
		var node := decoy.get("node", null) as MapRuleZone
		if node == null or not is_instance_valid(node):
			continue
		var distance := node.global_position.distance_to(_player.global_position)
		if distance > best_distance:
			best_distance = distance
			selected_index = index
	if selected_index < 0:
		return false
	var decoy_node := _illusion_decoys[selected_index].get("node", null) as MapRuleZone
	if decoy_node == null or not is_instance_valid(decoy_node):
		return false
	var old_position := _player.global_position
	var new_position := decoy_node.global_position
	_trigger_player_action_signature("swap_step", 0.22, 1.06, (new_position - old_position).normalized())
	_player.global_position = new_position
	_player_previous_position = new_position
	_spawn_effect(old_position, _get_switchstep_radius(), Color(0.88, 0.74, 1.0), Color(0.98, 0.94, 1.0), 0.18)
	_spawn_effect(new_position, _get_switchstep_radius(), Color(0.88, 0.74, 1.0), Color(0.98, 0.94, 1.0), 0.18)
	_damage_enemies_in_radius(old_position, _get_switchstep_radius(), _get_switchstep_damage(), 170.0, 5)
	_damage_enemies_in_radius(new_position, _get_switchstep_radius(), _get_switchstep_damage(), 170.0, 5)
	decoy_node.queue_free()
	_illusion_decoys.remove_at(selected_index)
	if _has_endgame_evolution("evo_illusion_stage_heist"):
		_spawn_illusion_decoy(old_position)
		_spawn_illusion_decoy(new_position)
	if _has_endgame_evolution("evo_illusion_prism_relay"):
		_fire_mirrorbolts()
	_audio.play_player_shot("power")
	return true


func _cast_prismdance() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var origins: Array[Vector2] = [_player.global_position]
	for index in range(mini(_illusion_decoys.size(), _get_prismdance_origin_count())):
		var decoy: Dictionary = _illusion_decoys[index]
		var node := decoy.get("node", null) as MapRuleZone
		if node != null and is_instance_valid(node):
			origins.append(node.global_position)
	if origins.size() <= 1 and _illusion_decoys.is_empty():
		return false
	var target_direction := _get_player_target_direction(940.0)
	if target_direction == Vector2.ZERO:
		target_direction = _player.get_facing_direction()
	if target_direction == Vector2.ZERO:
		target_direction = Vector2.RIGHT
	_trigger_player_action_signature("mirror_cast", 0.24, 1.02, target_direction)
	for origin in origins:
		for bolt_index in range(_get_prismdance_projectile_count()):
			var angle_offset := (float(bolt_index) - float(_get_prismdance_projectile_count() - 1) * 0.5) * 0.18
			var direction := target_direction.rotated(angle_offset)
			var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
			projectile.global_position = origin
			projectile.direction = direction
			projectile.damage = _get_prismdance_damage()
			projectile.speed = 720.0
			projectile.radius = 7.2
			projectile.pierce = 1 + int(_prismdance_level >= 3)
			projectile.max_distance = 780.0
			projectile.knockback = 160.0
			projectile.tint = Color(0.88, 0.76, 1.0)
			projectile.secondary_tint = Color(0.98, 0.94, 1.0, 0.42)
			projectile.homing_strength = 0.0
			_register_projectile(projectile)
		_spawn_rule_link_effect(_player.global_position, origin, 3.2, Color(0.82, 0.70, 1.0), Color(0.98, 0.92, 1.0), 0.14)
	_audio.play_player_shot("power")
	return true


func _spawn_illusion_decoy(position: Vector2) -> void:
	if _hazard_root == null or not is_instance_valid(_hazard_root):
		return
	while _illusion_decoys.size() >= _get_afterimage_limit():
		var oldest: Dictionary = _illusion_decoys.pop_front()
		var oldest_node := oldest.get("node", null) as MapRuleZone
		if oldest_node != null and is_instance_valid(oldest_node):
			oldest_node.queue_free()
	var zone := MAP_RULE_ZONE_SCRIPT.new()
	zone.global_position = position
	zone.radius = 40.0
	zone.primary_color = Color(0.84, 0.72, 1.0, 0.88)
	zone.secondary_color = Color(0.98, 0.94, 1.0, 0.82)
	zone.label = "残像"
	zone.sublabel = "镜射"
	zone.icon_style = "prism"
	zone.progress = -1.0
	_hazard_root.add_child(zone)
	_illusion_decoys.append({
		"node": zone,
		"lifetime": _get_afterimage_duration(),
	})
	_spawn_effect(position, 34.0, Color(0.84, 0.72, 1.0), Color(0.98, 0.94, 1.0), 0.14)


func _get_mirrorbolt_damage() -> int:
	var damage := (14.0 + float(_mirrorbolt_level) * 4.0) * _get_spell_power_multiplier()
	if _has_endgame_evolution("evo_illusion_kaleido_grid"):
		damage *= 1.16
	if _has_endgame_evolution("evo_illusion_glass_bloom"):
		damage *= 1.12
	return max(1, int(round(damage)))


func _get_mirrorbolt_cooldown() -> float:
	var cooldown := (0.92 - float(_mirrorbolt_level) * 0.08) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_illusion_prism_relay"):
		cooldown *= 0.90
	return maxf(0.28, cooldown)


func _get_mirrorbolt_decoy_count() -> int:
	var count := 1 + int(_mirrorbolt_level >= 4) + int(_mirrorbolt_level >= 7)
	if _has_endgame_evolution("evo_illusion_kaleido_grid"):
		count += 2
	return count


func _get_afterimage_cooldown() -> float:
	var cooldown := (5.2 - float(_afterimage_level) * 0.44) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_illusion_stage_heist"):
		cooldown *= 0.86
	return maxf(0.84, cooldown)


func _get_afterimage_limit() -> int:
	var limit := 1 + _afterimage_level
	if _has_endgame_evolution("evo_illusion_prism_relay"):
		limit += 2
	return limit


func _get_afterimage_duration() -> float:
	var duration := 4.6 + float(_afterimage_level) * 1.0
	if _has_endgame_evolution("evo_illusion_prism_relay"):
		duration += 2.4
	return duration


func _get_switchstep_damage() -> int:
	var damage := (18.0 + float(_switchstep_level) * 6.0) * _get_spell_power_multiplier()
	if _has_endgame_evolution("evo_illusion_stage_heist"):
		damage *= 1.14
	return max(1, int(round(damage)))


func _get_switchstep_radius() -> float:
	var radius := 76.0 + float(_switchstep_level) * 16.0
	if _has_endgame_evolution("evo_illusion_stage_heist"):
		radius += 24.0
	return radius


func _get_switchstep_cooldown() -> float:
	var cooldown := (5.4 - float(_switchstep_level) * 0.42) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_illusion_stage_heist"):
		cooldown *= 0.78
	return maxf(1.1, cooldown)


func _get_prismdance_damage() -> int:
	var damage := (10.0 + float(_prismdance_level) * 4.0) * _get_spell_power_multiplier()
	if _has_endgame_evolution("evo_illusion_kaleido_grid"):
		damage *= 1.14
	if _has_endgame_evolution("evo_illusion_glass_bloom"):
		damage *= 1.12
	return max(1, int(round(damage)))


func _get_prismdance_cooldown() -> float:
	var cooldown := (6.2 - float(_prismdance_level) * 0.46) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_illusion_prism_relay"):
		cooldown *= 0.86
	return maxf(1.3, cooldown)


func _get_prismdance_projectile_count() -> int:
	var count := 2 + int(_prismdance_level >= 3) + int(_prismdance_level >= 4)
	if _has_endgame_evolution("evo_illusion_glass_bloom"):
		count += 2
	return count


func _get_prismdance_origin_count() -> int:
	var count := 1 + int(_prismdance_level >= 2) + int(_prismdance_level >= 4)
	if _has_endgame_evolution("evo_illusion_kaleido_grid"):
		count += 2
	return count


func _fire_bolts() -> void:
	if _player == null or not is_instance_valid(_player):
		return

	var count := _get_bolt_count()
	var targets := _get_nearest_enemies(_player.global_position, count, 900.0)
	var signature_direction := _get_player_target_direction(900.0)
	_trigger_player_action_signature("cast_arc", 0.18, 0.86, signature_direction)
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

	_trigger_player_action_signature("nova_cast", 0.22, 0.98, _player.get_facing_direction())

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

	if _nova_orbit_mutation and not _satellites.is_empty():
		for satellite_variant in _satellites:
			var satellite: SpellSatellite = satellite_variant
			if satellite == null or not is_instance_valid(satellite):
				continue
			var direction := (satellite.global_position - _player.global_position).normalized()
			if direction == Vector2.ZERO:
				direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
			_spawn_nova_satellite_shard(satellite.global_position, direction)

	_trigger_void_pool_explosions(_player.global_position, 160.0)
	_spawn_effect(_player.global_position, 72.0, Color(0.98, 0.84, 0.42), Color(1.0, 0.40, 0.20), 0.34)
	_audio.play_player_shot("power")


func _cast_storm() -> void:
	if _player == null or not is_instance_valid(_player):
		return

	var targets := _get_nearest_enemies(_player.global_position, _get_storm_target_count(), 920.0)
	if targets.is_empty():
		return
	var signature_direction := (targets[0].global_position - _player.global_position).normalized()
	_trigger_player_action_signature("storm_cast", 0.24, 1.10, signature_direction)

	var storm_damage := _get_storm_damage()
	var has_tempest_network := _has_endgame_evolution("evo_caster_tempest_network")
	var has_singularity_prison := _has_endgame_evolution("evo_caster_singularity_prison")
	var splash_damage: int = max(1, int(round(float(storm_damage) * 0.42)))
	var singularity_radius := 132.0
	var singularity_force := 220.0
	var singularity_burst_radius := 64.0
	var singularity_burst_hits := 4
	if has_singularity_prison:
		singularity_radius += 48.0
		singularity_force += 120.0
		singularity_burst_radius = 86.0
		singularity_burst_hits = 6

	for target_variant in targets:
		var target: EnemySoldier = target_variant
		if target == null or not is_instance_valid(target):
			continue
		_spawn_effect(target.global_position, 56.0, Color(0.84, 0.94, 1.0), Color(0.26, 0.60, 1.0), 0.30)
		target.take_damage(storm_damage)
		if _storm_singularity_mutation or has_singularity_prison:
			_pull_enemies_toward_point(target.global_position, singularity_radius, singularity_force)
			_damage_enemies_in_radius(target.global_position, singularity_burst_radius, splash_damage, 180.0, singularity_burst_hits)
			if has_singularity_prison:
				_schedule_singularity_aftershock(
					target.global_position,
					max(1, int(round(float(storm_damage) * 0.62))),
					92.0
				)
		if has_tempest_network:
			var excluded: Array[EnemySoldier] = []
			excluded.append(target)
			_emit_chain_followup(
				target.global_position,
				excluded,
				2,
				_get_chain_bounce_range() * 0.82,
				max(1, int(round(float(storm_damage) * 0.54))),
				_get_chain_knockback() * 0.72,
				5.8
			)
		_trigger_void_pool_explosions(target.global_position, 72.0)

	_audio.play_player_shot("power")


func _schedule_singularity_aftershock(position: Vector2, damage: int, radius: float) -> void:
	if damage <= 0 or radius <= 0.0 or get_tree() == null:
		return
	var timer := get_tree().create_timer(0.36, false)
	timer.timeout.connect(_trigger_singularity_aftershock.bind(position, damage, radius))


func _trigger_singularity_aftershock(position: Vector2, damage: int, radius: float) -> void:
	if damage <= 0 or radius <= 0.0:
		return
	_spawn_effect(position, radius * 0.94, Color(0.90, 0.96, 1.0), Color(0.56, 0.62, 1.0), 0.24)
	_pull_enemies_toward_point(position, radius + 36.0, 260.0)
	_damage_enemies_in_radius(position, radius, damage, 260.0, 8)
	_trigger_void_pool_explosions(position, radius * 0.82)


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
	var signature_direction := facing if facing != Vector2.ZERO else _get_player_target_direction(_get_chain_initial_range())
	_trigger_player_action_signature("chain_cast", 0.18, 0.96, signature_direction)

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
		_trigger_void_pool_explosions(target_position, 36.0)
		hit_enemies.append(target)
		current_origin = target_position
		current_range = bounce_range

	if allow_thunder_strike and _ascension_level > 0 and not hit_enemies.is_empty() and _rng.randf() < _get_thunder_strike_proc_chance():
		var strike_index := _rng.randi_range(0, hit_enemies.size() - 1)
		var strike_target := hit_enemies[strike_index]
		if strike_target != null and is_instance_valid(strike_target):
			_trigger_thunder_strike(strike_target.global_position)

	if allow_thunder_strike and _has_endgame_evolution("evo_thunder_arc_net") and not hit_enemies.is_empty():
		_emit_chain_followup(
			hit_enemies[hit_enemies.size() - 1].global_position,
			hit_enemies,
			mini(3, max_targets),
			bounce_range * 0.84,
			max(1, int(round(float(damage) * 0.58))),
			knockback * 0.74,
			5.0
		)

	return hit_enemies


func _emit_chain_followup(origin: Vector2, excluded: Array[EnemySoldier], max_targets: int, bounce_range: float, damage: int, knockback: float, thickness: float = 5.6) -> Array[EnemySoldier]:
	var followup_hits: Array[EnemySoldier] = []
	if max_targets <= 0 or damage <= 0:
		return followup_hits

	var blocked: Array[EnemySoldier] = []
	for enemy_variant in excluded:
		var blocked_enemy: EnemySoldier = enemy_variant
		if blocked_enemy == null or not is_instance_valid(blocked_enemy):
			continue
		blocked.append(blocked_enemy)

	var current_origin := origin
	for bounce_index in range(max_targets):
		var target := _get_chain_target_from_origin(current_origin, blocked, bounce_range)
		if target == null:
			break
		var target_position := target.global_position
		_spawn_lightning_link_effect(current_origin, target_position, thickness)
		_spawn_effect(target_position, 12.0 if bounce_index == 0 else 10.0, Color(0.88, 0.98, 1.0), Color(0.40, 0.68, 1.0), 0.10)
		var impulse_direction := (target_position - current_origin).normalized()
		if impulse_direction == Vector2.ZERO:
			impulse_direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		target.take_damage(damage, impulse_direction * knockback)
		_trigger_void_pool_explosions(target_position, 24.0)
		followup_hits.append(target)
		blocked.append(target)
		current_origin = target_position

	return followup_hits


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
	_trigger_player_action_signature("orb_throw", 0.22, 1.04, throw_direction)
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
	var pulse_hits := _emit_chain_lightning(
		origin,
		_get_storm_orb_target_count(),
		_get_storm_orb_radius(),
		_get_chain_bounce_range(),
		_get_storm_orb_damage(),
		_get_chain_knockback() * 0.82,
		true
	)
	if _has_endgame_evolution("evo_thunder_storm_core"):
		var strike_position := origin
		if not pulse_hits.is_empty():
			var last_hit := pulse_hits[pulse_hits.size() - 1]
			if last_hit != null and is_instance_valid(last_hit):
				strike_position = last_hit.global_position
		_trigger_minor_thunder_strike(strike_position, 0.56, 0.72)


func _trigger_thunder_strike(position: Vector2) -> void:
	var strike_radius := _get_thunder_strike_radius()
	_spawn_lightning_link_effect(position + Vector2(0.0, -strike_radius * 2.4), position, 10.0)
	_spawn_effect(position, strike_radius, Color(0.92, 0.99, 1.0), Color(0.40, 0.68, 1.0), 0.18)
	_damage_enemies_in_radius(position, strike_radius, _get_thunder_strike_damage(), 280.0)


func _trigger_minor_thunder_strike(position: Vector2, damage_scale: float = 0.72, radius_scale: float = 0.78) -> void:
	var strike_radius := _get_thunder_strike_radius() * radius_scale
	var strike_damage: int = max(1, int(round(float(_get_thunder_strike_damage()) * damage_scale)))
	_spawn_lightning_link_effect(position + Vector2(0.0, -strike_radius * 2.0), position, 7.2)
	_spawn_effect(position, strike_radius, Color(0.90, 0.98, 1.0), Color(0.38, 0.68, 1.0), 0.14)
	_damage_enemies_in_radius(position, strike_radius, strike_damage, 240.0)
	_trigger_void_pool_explosions(position, strike_radius * 0.48)


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
	_trigger_void_pool_explosions(position, _get_detonate_radius() + 18.0)
	if _supercell_mutation:
		_emit_chain_lightning(
			position,
			3 + int(_storm_orb_level > 0),
			_get_detonate_radius() + 42.0,
			_get_chain_bounce_range() * 0.72,
			max(1, int(round(float(_get_chain_damage()) * 0.54))),
			_get_chain_knockback() * 0.76,
			false
		)
	if _has_endgame_evolution("evo_thunder_blast_relay"):
		_trigger_minor_thunder_strike(position, 0.82, 0.84)
		var relay_excluded := _get_nearest_enemies(position, _enemies.size(), _get_detonate_radius() + 16.0)
		_emit_chain_followup(
			position,
			relay_excluded,
			2 + int(_storm_orb_level > 0),
			_get_detonate_radius() + 82.0,
			max(1, int(round(float(_get_chain_damage()) * 0.48))),
			_get_chain_knockback() * 0.70,
			4.8
		)


func _spawn_lightning_link_effect(start_position: Vector2, end_position: Vector2, thickness: float = 8.0) -> void:
	if _effect_root == null or not is_instance_valid(_effect_root):
		return
	var effect = LIGHTNING_CHAIN_EFFECT_SCRIPT.new()
	effect.thickness = thickness
	effect.primary_color = Color(0.82, 0.96, 1.0)
	effect.secondary_color = Color(0.34, 0.62, 1.0)
	effect.configure_link(start_position, end_position, _rng.randi())
	_effect_root.add_child(effect)


func _get_player_target_direction(search_range: float = 720.0) -> Vector2:
	if _player == null or not is_instance_valid(_player):
		return Vector2.RIGHT

	var targets := _get_nearest_enemies(_player.global_position, 1, search_range)
	if not targets.is_empty():
		var target := targets[0]
		if target != null and is_instance_valid(target):
			var direction := (target.global_position - _player.global_position).normalized()
			if direction != Vector2.ZERO:
				return direction

	var facing := _player.get_facing_direction()
	if facing == Vector2.ZERO:
		facing = Vector2(_player.velocity.x, _player.velocity.y).normalized()
	if facing == Vector2.ZERO:
		facing = Vector2.RIGHT
	return facing.normalized()


func _get_player_target_position(search_range: float, fallback_distance: float = 220.0) -> Vector2:
	if _player == null or not is_instance_valid(_player):
		return PLAYER_START
	var targets := _get_nearest_enemies(_player.global_position, 1, search_range)
	if not targets.is_empty():
		var target := targets[0]
		if target != null and is_instance_valid(target):
			return target.global_position
	return _player.global_position + _get_player_target_direction(search_range) * fallback_distance


func _trigger_player_action_signature(signature_name: String, duration: float, strength: float = 1.0, direction: Vector2 = Vector2.ZERO) -> void:
	if _player == null or not is_instance_valid(_player):
		return
	_player.trigger_action_signature(signature_name, duration, strength, direction)


func _update_alchemist_attacks(delta: float) -> void:
	_flask_timer -= delta
	if _flask_timer <= 0.0:
		if _throw_alchemist_flasks():
			_flask_timer = _get_flask_cooldown()
		else:
			_flask_timer = 0.18

	if _miasma_level > 0:
		_miasma_timer -= delta
		if _miasma_timer <= 0.0:
			if _cast_alchemist_miasma():
				_miasma_timer = _get_miasma_cooldown()
			else:
				_miasma_timer = 0.28

	if _shardburst_level > 0:
		_shardburst_timer -= delta
		if _shardburst_timer <= 0.0:
			if _cast_alchemist_shardburst():
				_shardburst_timer = _get_shardburst_cooldown()
			else:
				_shardburst_timer = 0.24

	if _catalyst_level > 0:
		_catalyst_timer -= delta
		if _catalyst_timer <= 0.0:
			if _trigger_alchemist_catalyst():
				_catalyst_timer = _get_catalyst_cooldown()
			else:
				_catalyst_timer = 0.40


func _throw_alchemist_flasks() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	if _effect_root == null or not is_instance_valid(_effect_root):
		return false

	var count := _get_flask_count()
	var targets := _get_nearest_enemies(_player.global_position, count, 820.0)
	var base_direction := _get_player_target_direction(820.0)
	_player.set_facing_direction(base_direction)
	_trigger_player_action_signature("throw_flask", 0.24, 1.08, base_direction)
	for index in range(count):
		var target_position := _get_player_target_position(820.0, 180.0)
		if index < targets.size():
			var target := targets[index]
			if target != null and is_instance_valid(target):
				target_position = target.global_position
		var drift := base_direction.orthogonal() * (float(index) - float(count - 1) * 0.5) * 26.0
		var flask: MeteorHazard = METEOR_HAZARD_SCRIPT.new()
		flask.global_position = target_position + drift
		flask.warning_duration = _get_flask_warning_duration()
		flask.linger_duration = 0.20
		flask.damage_radius = _get_flask_radius()
		flask.current_health_ratio = 0.0
		flask.knockback = 210.0
		flask.primary_color = Color(0.92, 0.98, 0.58)
		flask.secondary_color = Color(0.36, 0.64, 0.22)
		flask.impact.connect(_on_alchemist_flask_impact.bind(_get_flask_damage()))
		_effect_root.add_child(flask)
		_spawn_effect(_player.global_position + base_direction * 18.0, 20.0, Color(0.92, 0.98, 0.74), Color(0.46, 0.72, 0.26), 0.14)

	_audio.play_player_shot("spread" if count > 1 else "rapid")
	return true


func _on_alchemist_flask_impact(position: Vector2, radius: float, _current_health_ratio: float, knockback: float, damage: int) -> void:
	_spawn_effect(position, radius * 1.04, Color(0.96, 0.98, 0.70), Color(0.42, 0.68, 0.22), 0.26)
	_damage_enemies_in_radius(position, radius, damage, knockback, 8)


func _prune_alchemist_clouds() -> void:
	for index in range(_alchemist_clouds.size() - 1, -1, -1):
		var cloud := _alchemist_clouds[index]
		if cloud == null or not is_instance_valid(cloud):
			_alchemist_clouds.remove_at(index)


func _cast_alchemist_miasma() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	if _effect_root == null or not is_instance_valid(_effect_root):
		return false

	_prune_alchemist_clouds()
	var signature_direction := _get_player_target_direction(_get_miasma_cast_range())
	_trigger_player_action_signature("throw_flask", 0.22, 0.92, signature_direction)
	var cloud: PoisonCloudHazard = POISON_CLOUD_SCRIPT.new()
	var target_position := _get_player_target_position(_get_miasma_cast_range(), 210.0)
	cloud.global_position = target_position
	cloud.velocity = Vector2.ZERO
	cloud.lifetime = _get_miasma_duration()
	cloud.damage_radius = _get_miasma_radius()
	cloud.max_health_ratio_per_second = 0.0
	cloud.knockback = 56.0
	cloud.pulse_interval = _get_miasma_pulse_interval()
	cloud.primary_color = Color(0.70, 0.96, 0.48)
	cloud.secondary_color = Color(0.20, 0.42, 0.16)
	cloud.pulse.connect(_on_alchemist_miasma_pulse.bind(_get_miasma_damage()))
	_effect_root.add_child(cloud)
	_alchemist_clouds.append(cloud)
	while _alchemist_clouds.size() > _get_miasma_limit():
		var oldest := _alchemist_clouds[0]
		_alchemist_clouds.remove_at(0)
		if oldest != null and is_instance_valid(oldest):
			oldest.queue_free()
	_spawn_effect(target_position, cloud.damage_radius * 0.24, Color(0.86, 0.98, 0.70), Color(0.28, 0.54, 0.20), 0.18)
	_audio.play_player_shot("power")
	return true


func _on_alchemist_miasma_pulse(position: Vector2, radius: float, _ratio_per_second: float, _elapsed_time: float, knockback: float, damage: int) -> void:
	_spawn_effect(position, minf(radius * 0.26, 40.0), Color(0.82, 0.96, 0.66), Color(0.22, 0.48, 0.18), 0.12)
	_damage_enemies_in_radius(position, radius, damage, knockback, 6)


func _cast_alchemist_shardburst() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var direction := _get_player_target_direction(860.0)
	_player.set_facing_direction(direction)
	_trigger_player_action_signature("throw_flask", 0.18, 0.84, direction)
	var count := _get_shardburst_count()
	var span := 0.34
	for index in range(count):
		var angle_offset := 0.0
		if count > 1:
			angle_offset = (float(index) - float(count - 1) * 0.5) * span / float(count - 1)
		_spawn_alchemist_shard(_player.global_position + direction * 18.0, direction.rotated(angle_offset))
	_audio.play_player_shot("spread")
	return true


func _spawn_alchemist_shard(origin: Vector2, direction: Vector2) -> void:
	if _projectile_root == null or not is_instance_valid(_projectile_root):
		return
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
	projectile.global_position = origin
	projectile.direction = direction.normalized()
	projectile.damage = _get_shardburst_damage()
	projectile.speed = 660.0
	projectile.radius = 7.0
	projectile.pierce = _get_shardburst_pierce()
	projectile.max_distance = 420.0
	projectile.knockback = 170.0
	projectile.tint = Color(0.90, 0.98, 0.74)
	projectile.secondary_tint = Color(0.58, 0.86, 0.34, 0.48)
	projectile.visual_style = "blade_wave"
	_register_projectile(projectile)


func _trigger_alchemist_catalyst() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	_prune_alchemist_clouds()
	_trigger_player_action_signature("catalyst_burst", 0.22, 1.02, _get_player_target_direction(640.0))
	var burst_positions: Array[Vector2] = []
	while burst_positions.size() < _get_catalyst_burst_count() and not _alchemist_clouds.is_empty():
		var cloud := _alchemist_clouds[0]
		_alchemist_clouds.remove_at(0)
		if cloud == null or not is_instance_valid(cloud):
			continue
		burst_positions.append(cloud.global_position)
		cloud.queue_free()
	if burst_positions.is_empty():
		burst_positions.append(_get_player_target_position(640.0, 180.0))
	for burst_position in burst_positions:
		_spawn_effect(burst_position, _get_catalyst_radius() * 0.94, Color(0.98, 0.98, 0.74), Color(0.62, 0.86, 0.28), 0.28)
		_damage_enemies_in_radius(burst_position, _get_catalyst_radius(), _get_catalyst_damage(), 240.0, 8)
	_audio.play_player_shot("power")
	return true


func _update_ranger_attacks(delta: float) -> void:
	_needle_timer -= delta
	if _needle_timer <= 0.0:
		if _fire_ranger_needles():
			_needle_timer = _get_needle_cooldown()
		else:
			_needle_timer = 0.12

	if _volley_level > 0:
		_volley_timer -= delta
		if _volley_timer <= 0.0:
			if _cast_ranger_volley():
				_volley_timer = _get_volley_cooldown()
			else:
				_volley_timer = 0.20

	if _glaive_level > 0:
		_glaive_timer -= delta
		if _glaive_timer <= 0.0:
			if _cast_ranger_glaive():
				_glaive_timer = _get_glaive_cooldown()
			else:
				_glaive_timer = 0.28

	if _trail_level > 0:
		_trail_timer -= delta
		if _trail_timer <= 0.0:
			if _cast_ranger_trail():
				_trail_timer = _get_trail_cooldown()
			else:
				_trail_timer = 0.32


func _spawn_ranger_arrow(
	origin: Vector2,
	direction: Vector2,
	damage: int,
	speed: float,
	radius: float,
	pierce: int,
	max_distance: float,
	tint: Color,
	secondary_tint: Color,
	visual_style: String = "blade_wave",
	homing_target: EnemySoldier = null,
	homing_strength: float = 0.0
) -> void:
	if _projectile_root == null or not is_instance_valid(_projectile_root):
		return
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
	projectile.global_position = origin
	projectile.direction = direction.normalized()
	projectile.damage = damage
	projectile.speed = speed
	projectile.radius = radius
	projectile.pierce = pierce
	projectile.max_distance = max_distance
	projectile.knockback = 180.0
	projectile.tint = tint
	projectile.secondary_tint = secondary_tint
	projectile.visual_style = visual_style
	if homing_target != null and is_instance_valid(homing_target):
		projectile.homing_target = homing_target
		projectile.homing_strength = homing_strength
	_register_projectile(projectile)


func _fire_ranger_needles() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var count := _get_needle_count()
	var targets := _get_nearest_enemies(_player.global_position, count, 960.0)
	var base_direction := _get_player_target_direction(960.0)
	_player.set_facing_direction(base_direction)
	_trigger_player_action_signature("draw_shot", 0.20, 0.94, base_direction)
	for index in range(count):
		var direction := base_direction
		if index < targets.size():
			var target := targets[index]
			if target != null and is_instance_valid(target):
				direction = (target.global_position - _player.global_position).normalized()
		_spawn_ranger_arrow(
			_player.global_position + direction * 18.0,
			direction,
			_get_needle_damage(),
			960.0,
			5.8,
			_get_needle_pierce(),
			960.0,
			Color(0.92, 0.86, 0.52),
			Color(0.88, 0.98, 0.76, 0.42)
		)
	_audio.play_player_shot("spread" if count > 1 else "rapid")
	return true


func _cast_ranger_volley() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var direction := _get_player_target_direction(900.0)
	_player.set_facing_direction(direction)
	_trigger_player_action_signature("draw_shot", 0.24, 1.08, direction)
	var count := _get_volley_count()
	var span := 0.58
	for index in range(count):
		var angle_offset := 0.0
		if count > 1:
			angle_offset = -span * 0.5 + span * float(index) / float(count - 1)
		_spawn_ranger_arrow(
			_player.global_position + direction * 16.0,
			direction.rotated(angle_offset),
			_get_volley_damage(),
			760.0,
			5.4,
			1,
			520.0,
			Color(0.98, 0.82, 0.46),
			Color(0.94, 0.98, 0.78, 0.36)
		)
	_audio.play_player_shot("spread")
	return true


func _cast_ranger_glaive() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var count := _get_glaive_count()
	var targets := _get_nearest_enemies(_player.global_position, count, 860.0)
	var base_direction := _get_player_target_direction(860.0)
	_player.set_facing_direction(base_direction)
	_trigger_player_action_signature("glaive_throw", 0.22, 1.02, base_direction)
	for index in range(count):
		var target: EnemySoldier = null
		var direction := base_direction
		if index < targets.size():
			target = targets[index]
			if target != null and is_instance_valid(target):
				direction = (target.global_position - _player.global_position).normalized()
		if count > 1:
			direction = direction.rotated((float(index) - float(count - 1) * 0.5) * 0.20)
		_spawn_ranger_arrow(
			_player.global_position + direction * 18.0,
			direction,
			_get_glaive_damage(),
			620.0,
			9.0,
			_get_glaive_pierce(),
			540.0,
			Color(0.84, 0.94, 0.62),
			Color(0.98, 0.96, 0.78, 0.52),
			"blade_wave",
			target,
			3.8
		)
	_audio.play_player_shot("power")
	return true


func _cast_ranger_trail() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var direction := Vector2(_player.velocity.x, _player.velocity.y).normalized()
	if direction == Vector2.ZERO:
		direction = _get_player_target_direction(860.0)
	_player.set_facing_direction(direction)
	_trigger_player_action_signature("trail_dash", 0.18, 0.96, direction)
	var length := _get_trail_length()
	var width := _get_trail_width()
	var line_count := 1 + int(_trail_level >= 3)
	var side_step := direction.orthogonal()
	for index in range(line_count):
		var offset := (float(index) - float(line_count - 1) * 0.5) * 34.0
		var start_position := _player.global_position + side_step * offset - direction * (length * 0.24)
		var end_position := _player.global_position + side_step * offset + direction * (length * 0.76)
		_apply_line_damage(start_position, end_position, width, _get_trail_damage(), 260.0, 8)
		for point_index in range(5):
			var t := float(point_index) / 4.0
			var effect_position := start_position.lerp(end_position, t)
			_spawn_effect(effect_position, width * 0.72, Color(0.98, 0.90, 0.60), Color(0.76, 0.92, 0.42), 0.12)
	_audio.play_player_shot("power")
	return true


func _update_warden_attacks(delta: float) -> void:
	_pulse_timer -= delta
	if _pulse_timer <= 0.0:
		if _cast_warden_pulse():
			_pulse_timer = _get_pulse_cooldown()
		else:
			_pulse_timer = 0.14

	if _beacon_level > 0:
		_beacon_timer -= delta
		if _beacon_timer <= 0.0:
			if _cast_warden_beacon():
				_beacon_timer = _get_beacon_cooldown()
			else:
				_beacon_timer = 0.30

	if _relay_level > 0:
		_relay_timer -= delta
		if _relay_timer <= 0.0:
			if _cast_warden_relay():
				_relay_timer = _get_relay_cooldown()
			else:
				_relay_timer = 0.24


func _cast_warden_pulse() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	_trigger_player_action_signature("brace_pulse", 0.22, 1.04, _player.get_facing_direction())
	var radius := _get_pulse_radius()
	var hit_total := _damage_enemies_in_radius(_player.global_position, radius, _get_pulse_damage(), 220.0, _get_pulse_hit_count())
	_spawn_effect(_player.global_position, radius * 0.92, Color(0.86, 0.98, 0.90), Color(0.28, 0.82, 0.64), 0.20)
	if hit_total <= 0:
		return false
	_audio.play_player_shot("power")
	return true


func _cast_warden_beacon() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	if _effect_root == null or not is_instance_valid(_effect_root):
		return false
	if _warden_beacon_field != null and is_instance_valid(_warden_beacon_field):
		_warden_beacon_field.queue_free()

	var field := LIGHTNING_ORB_FIELD_SCRIPT.new()
	field.global_position = _get_player_target_position(_get_beacon_cast_range(), 220.0)
	field.duration = _get_beacon_duration()
	field.radius = _get_beacon_radius()
	field.pulse_interval = _get_beacon_pulse_interval()
	field.primary_color = Color(0.36, 0.90, 0.76)
	field.secondary_color = Color(0.92, 0.98, 0.90)
	field.pulse_requested.connect(_on_warden_beacon_pulse)
	_effect_root.add_child(field)
	_warden_beacon_field = field
	var direction := (field.global_position - _player.global_position).normalized()
	if direction != Vector2.ZERO:
		_player.set_facing_direction(direction)
	_trigger_player_action_signature("brace_cast", 0.24, 0.96, direction)
	_spawn_effect(field.global_position, field.radius * 0.22, Color(0.88, 0.98, 0.92), Color(0.28, 0.82, 0.66), 0.18)
	_audio.play_player_shot("power")
	return true


func _on_warden_beacon_pulse(origin: Vector2) -> void:
	_spawn_effect(origin, _get_beacon_radius() * 0.28, Color(0.86, 0.98, 0.92), Color(0.28, 0.82, 0.64), 0.14)
	_damage_enemies_in_radius(origin, _get_beacon_radius(), _get_beacon_damage(), 170.0, _get_beacon_hit_count())


func _cast_warden_relay() -> bool:
	if _player == null or not is_instance_valid(_player):
		return false
	var segments: Array[Dictionary] = []
	if _warden_beacon_field != null and is_instance_valid(_warden_beacon_field):
		segments.append({
			"start": _player.global_position,
			"end": _warden_beacon_field.global_position,
		})
		for satellite_variant in _satellites:
			var satellite: SpellSatellite = satellite_variant
			if satellite == null or not is_instance_valid(satellite):
				continue
			segments.append({
				"start": satellite.global_position,
				"end": _warden_beacon_field.global_position,
			})
	else:
		var direction := _get_player_target_direction(760.0)
		var start_position := _player.global_position - direction * 22.0
		var end_position := _player.global_position + direction * _get_relay_length()
		segments.append({
			"start": start_position,
			"end": end_position,
		})
	if segments.is_empty():
		return false
	var signature_direction := _get_player_target_direction(760.0)
	_trigger_player_action_signature("brace_cast", 0.20, 0.90, signature_direction)

	var total_hits := 0
	for segment_variant in segments:
		var segment: Dictionary = segment_variant
		var start_position: Vector2 = segment.get("start", _player.global_position)
		var end_position: Vector2 = segment.get("end", _player.global_position)
		total_hits += _apply_line_damage(start_position, end_position, _get_relay_width(), _get_relay_damage(), 240.0, 8)
		for point_index in range(4):
			var t := float(point_index) / 3.0
			_spawn_effect(start_position.lerp(end_position, t), _get_relay_width() * 0.68, Color(0.88, 0.98, 0.92), Color(0.34, 0.88, 0.68), 0.10)
	if total_hits <= 0:
		return false
	_audio.play_player_shot("power")
	return true


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
	_trigger_player_action_signature("slash", 0.20, 1.12, direction)

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
	if _has_endgame_evolution("evo_blade_pyre_forks"):
		_spawn_slash_flame_wave(_player.global_position + direction * 14.0, direction.rotated(0.22), 0.76)
		_spawn_slash_flame_wave(_player.global_position + direction * 14.0, direction.rotated(-0.22), 0.76)
	_trigger_void_pool_explosions(_player.global_position + direction * _get_slash_range() * 0.48, _get_slash_range() * 0.70)

	if hit_count <= 0 and slash_wave == null:
		return false

	_audio.play_player_shot("spread" if hit_count > 1 else "rapid")
	return true


func _spawn_slash_flame_wave(origin: Vector2, direction: Vector2, damage_scale: float = 1.0) -> SpellProjectile:
	if _projectile_root == null or not is_instance_valid(_projectile_root):
		return null
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
	projectile.global_position = origin
	projectile.direction = direction.normalized()
	projectile.damage = max(1, int(round(float(_get_slash_wave_damage()) * damage_scale)))
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
	projectile.split_max_generations = 2 if _has_endgame_evolution("evo_blade_crimson_tide") else 1
	projectile.split_damage_scale = 0.68 if _has_endgame_evolution("evo_blade_crimson_tide") else 0.62
	projectile.split_speed_scale = 0.98
	projectile.split_range_scale = 0.76
	projectile.split_radius_scale = 0.82
	projectile.split_knockback_scale = 0.84
	projectile.split_child_pierce = 99
	projectile.damage_falloff_on_hit = true
	projectile.damage_falloff_factor = 0.80
	projectile.min_damage_multiplier = 0.55 if _has_endgame_evolution("evo_blade_crimson_tide") else 0.40
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
	_trigger_player_action_signature("mooncut", 0.22, 1.04, primary_direction)

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

	_trigger_void_pool_explosions(_player.global_position + primary_direction * 160.0, 120.0)
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


func _spawn_nova_satellite_shard(origin: Vector2, direction: Vector2) -> void:
	if _projectile_root == null or not is_instance_valid(_projectile_root):
		return
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	var projectile: SpellProjectile = PROJECTILE_SCRIPT.new()
	projectile.global_position = origin
	projectile.direction = direction.normalized()
	projectile.damage = max(1, int(round(float(_get_nova_damage()) * 0.55)))
	projectile.speed = 520.0
	projectile.radius = 8.0
	projectile.pierce = 1
	projectile.max_distance = 240.0
	projectile.knockback = 180.0
	projectile.tint = Color(1.0, 0.84, 0.48)
	projectile.secondary_tint = Color(0.98, 0.96, 0.74, 0.56)
	_register_projectile(projectile)


func _pull_enemies_toward_point(center: Vector2, radius: float, force: float) -> void:
	for enemy_variant in _enemies:
		var enemy: EnemySoldier = enemy_variant
		if enemy == null or not is_instance_valid(enemy):
			continue
		var distance := center.distance_to(enemy.global_position)
		if distance > radius + enemy.get_body_radius():
			continue
		var impulse := center - enemy.global_position
		if impulse == Vector2.ZERO:
			impulse = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
		enemy.apply_impulse(impulse.normalized() * force)


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
	_trigger_player_action_signature("dash_cut", 0.18, 1.18, direction)

	var radius := _get_step_slash_radius()
	var slash_center := start_position
	var hit_total := _damage_enemies_in_radius(slash_center, radius, _get_step_slash_damage(), _get_step_slash_knockback())
	if hit_total <= 0:
		target.take_damage(_get_step_slash_damage(), direction * _get_step_slash_knockback())
		hit_total = 1

	_spawn_step_slash_effect(slash_center, direction, radius)
	_spawn_effect(start_position, minf(radius * 0.36, 34.0), Color(1.0, 0.88, 0.70), Color(1.0, 0.56, 0.34), 0.16)
	if _execution_mutation or _has_endgame_evolution("evo_blade_execution_storm"):
		_trigger_execution_field(slash_center)
	_trigger_void_pool_explosions(slash_center, radius + 24.0)

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
		var elite_chance := minf(0.46, 0.04 + float(_get_wave_rank()) * 0.012 + float(max(_threat_phase - 1, 0)) * 0.018 + _endless_elite_bonus + _contract_elite_spawn_bonus)
		var is_elite := not _boss_spawned and _run_time >= 90.0 and _rng.randf() < elite_chance
		_spawn_enemy(enemy_type, is_elite)


func _spawn_enemy(type_name: String, is_elite: bool, options: Dictionary = {}) -> EnemySoldier:
	if _player == null or not is_instance_valid(_player):
		return null

	var enemy: EnemySoldier = ENEMY_SCRIPT.new()
	var enemy_options: Dictionary = options.duplicate(true)
	var spawn_position: Vector2 = options.get("spawn_position", _find_spawn_position(560.0, 980.0, 16.0))
	var wave_rank := int(options.get("wave_rank", _get_wave_rank()))
	if is_elite and not bool(enemy_options.get("boss", false)) and not enemy_options.has("elite_affixes"):
		enemy_options["elite_affixes"] = _roll_elite_affixes(type_name, wave_rank)
	enemy.global_position = spawn_position
	enemy.configure(type_name, wave_rank, is_elite, _player, enemy_options)
	var health_scale := 1.0 + _endless_enemy_health_bonus + (0.05 if _threat_phase >= 4 and not enemy.is_boss() else 0.0)
	if enemy.is_boss():
		var boss_health: int = max(1, int(round(float(_get_boss_health_reference()) * MODE_BOSS_HEALTH_MULTIPLIER)))
		enemy.max_health = boss_health
		enemy.health = boss_health
		enemy.set_shield(max(1, int(round(float(boss_health) * MODE_BOSS_SHIELD_RATIO))))
	else:
		health_scale *= _get_enemy_health_multiplier()
		enemy.max_health = max(1, int(round(float(enemy.max_health) * health_scale)))
		enemy.health = enemy.max_health
		_last_spawned_enemy_health = enemy.max_health
	var speed_scale := 1.0 + _endless_enemy_speed_bonus + _contract_enemy_speed_bonus + float(max(_threat_phase - 2, 0)) * 0.03
	if speed_scale != 1.0:
		enemy.speed *= speed_scale
	enemy.defeated.connect(_on_enemy_defeated)
	enemy.special_attack.connect(_on_enemy_special_attack)
	enemy.summon_requested.connect(_on_enemy_summon_requested)
	enemy.boss_phase_changed.connect(_on_boss_phase_changed)
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
	if _threat_phase >= 4 and _rng.randf() < 0.38:
		var late_role_pool: Array[String] = ["diver", "ranged", "ranged", "control", "fodder"]
		var role: String = late_role_pool[_rng.randi_range(0, late_role_pool.size() - 1)]
		var roster: Array[String] = _get_enemy_roster_for_role(role)
		if not roster.is_empty():
			return roster[_rng.randi_range(0, roster.size() - 1)]
	elif _threat_phase >= 2 and _rng.randf() < 0.26:
		var mid_role_pool: Array[String] = ["diver", "ranged", "control", "ranged"]
		var role: String = mid_role_pool[_rng.randi_range(0, mid_role_pool.size() - 1)]
		var roster: Array[String] = _get_enemy_roster_for_role(role)
		if not roster.is_empty():
			return roster[_rng.randi_range(0, roster.size() - 1)]

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
	var hazard_scale := maxf(0.46, 1.0 - _endless_hazard_bonus - _contract_hazard_bonus)
	var min_interval := maxf(1.8, base_range.x * lerpf(1.0, 0.76, intensity) * hazard_scale)
	var max_interval := maxf(min_interval + 0.2, base_range.y * lerpf(1.0, 0.82, intensity) * hazard_scale)
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


func _apply_line_current_health_damage(start_position: Vector2, end_position: Vector2, width: float, current_health_ratio: float, knockback: float) -> void:
	if current_health_ratio <= 0.0:
		return

	var actors: Array[Node] = []
	if _player != null and is_instance_valid(_player) and _player.is_alive():
		if _distance_to_segment(_player.global_position, start_position, end_position) <= width + _player.get_body_radius():
			actors.append(_player)

	for enemy_variant in _enemies:
		var enemy: EnemySoldier = enemy_variant
		if enemy == null or not is_instance_valid(enemy):
			continue
		if _distance_to_segment(enemy.global_position, start_position, end_position) <= width + enemy.get_body_radius():
			actors.append(enemy)

	for actor in actors:
		var damage := maxi(1, int(ceili(_get_actor_current_health(actor) * current_health_ratio)))
		var center := _get_actor_position(actor)
		_apply_damage_to_actor(actor, damage, knockback, center)


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


func _count_enemies_in_radius(center: Vector2, radius: float) -> int:
	var count := 0
	for enemy_variant in _enemies:
		var enemy: EnemySoldier = enemy_variant
		if enemy == null or not is_instance_valid(enemy):
			continue
		if center.distance_to(enemy.global_position) <= radius + enemy.get_body_radius():
			count += 1
	return count


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


func _get_actor_position(actor: Node) -> Vector2:
	if actor == null or not is_instance_valid(actor):
		return Vector2.ZERO
	if actor is Node2D:
		return (actor as Node2D).global_position
	return Vector2.ZERO


func _get_enemy_score_value(enemy: EnemySoldier) -> int:
	if enemy == null:
		return 0
	var base := 10 + _get_wave_rank() * 3
	if enemy.elite:
		base += 26
		base += enemy.get_elite_affix_count() * 8
	if enemy.is_boss():
		base += 180
	return base


func _award_score(base_points: int) -> void:
	if base_points <= 0:
		return
	_score += maxi(1, int(round(float(base_points) * _get_score_multiplier())))


func _get_score_multiplier() -> float:
	var multiplier := 1.0 + _score_bonus_multiplier + _pickup_heat_bonus + _contract_score_bonus
	multiplier += _get_low_health_score_bonus()
	if _ruins_altar_buff_timer > 0.0:
		multiplier += 0.25
	if _forge_overdrive_timer > 0.0:
		multiplier += 0.12
	if _void_spore_blessing_timer > 0.0:
		multiplier += 0.10
	if _prism_overcharge_timer > 0.0:
		multiplier += 0.10
	if _clock_overdrive_timer > 0.0:
		multiplier += 0.06
	if _train_rush_timer > 0.0:
		multiplier += 0.14
	if _fog_light_timer > 0.0:
		multiplier += 0.12
	if _airship_tailwind_timer > 0.0:
		multiplier += 0.12
	return maxf(1.0, multiplier)


func _get_low_health_score_bonus() -> float:
	if _player == null or not is_instance_valid(_player) or _player.max_health <= 0:
		return 0.0
	var health_ratio := float(_player.health) / float(_player.max_health)
	if health_ratio > 0.35:
		return 0.0
	var missing_ratio := clampf((0.35 - health_ratio) / 0.35, 0.0, 1.0)
	return lerpf(0.14, 0.40, missing_ratio)


func _handle_risky_pickup(position: Vector2, value: int) -> void:
	if _player == null or not is_instance_valid(_player):
		return
	var nearby_enemies := _count_enemies_in_radius(_player.global_position, 132.0)
	if nearby_enemies < 2:
		return
	_pickup_heat_bonus = minf(0.50, _pickup_heat_bonus + 0.04 + float(nearby_enemies - 2) * 0.02)
	_pickup_heat_timer = maxf(_pickup_heat_timer, 5.0)
	_award_score(8 + value * 4 + nearby_enemies * 5)
	if _message_timer <= 0.1:
		_show_message("贴脸拾取: 倍率升温，继续冒险能拿更多分。", Color(1.0, 0.92, 0.60), 1.4)


func _spawn_elite_cache(position: Vector2) -> void:
	_spawn_effect(position, 64.0, Color(1.0, 0.92, 0.64), Color(0.98, 0.54, 0.24), 0.30)
	for index in range(4):
		var angle := TAU * float(index) / 4.0 + _rng.randf_range(-0.2, 0.2)
		_spawn_orb(position + Vector2.RIGHT.rotated(angle) * _rng.randf_range(14.0, 32.0), 2)
	if _player != null and is_instance_valid(_player):
		_player.heal(1)
	_pickup_heat_bonus = minf(0.60, _pickup_heat_bonus + 0.10)
	_pickup_heat_timer = maxf(_pickup_heat_timer, 6.0)
	_award_score(54 + _get_wave_rank() * 5)
	_show_message("精英宝箱: 经验爆裂，倍率与续航同步抬升。", Color(1.0, 0.92, 0.64), 1.8)


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

	if _is_warden_character():
		var ward_count := _get_ward_count()
		for index in range(ward_count):
			var ward_satellite: SpellSatellite = SATELLITE_SCRIPT.new()
			ward_satellite.configure(
				_player,
				TAU * float(index) / float(max(ward_count, 1)),
				_get_ward_radius(),
				_get_ward_speed(),
				_get_ward_damage(),
				{
					"visual_style": "arcane",
					"primary_color": Color(0.44, 0.92, 0.78),
					"secondary_color": Color(0.92, 0.98, 0.90, 0.88),
					"body_radius": 11.0,
					"hit_interval": 0.20,
					"hit_knockback": 110.0,
				}
			)
			_satellite_root.add_child(ward_satellite)
			_satellites.append(ward_satellite)
		return
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
	_choice_context = "upgrade"
	_choice_panel_title = "选择一项联动组件"
	_choice_panel_subtitle = "补强当前构筑，或顺势转向下一条路线。"
	_upgrade_choices = _build_upgrade_choices()
	_hud.hide_pause_menu()
	_apply_choice_panel_context()
	_hud.show_upgrade_choices(_upgrade_choices)
	_hud.set_message("")
	_message_timer = 0.0
	_set_pause_state(true)


func _build_upgrade_choices() -> Array[Dictionary]:
	return _build_combo_upgrade_choices()

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
	elif _is_alchemist_character():
		_append_upgrade_candidate(candidates, "flask", _is_upgrade_available("flask", _flask_level), "裂解瓶 +1", "提升裂解瓶的数量、范围和伤害。")
		_append_upgrade_candidate(candidates, "miasma", _is_upgrade_available("miasma", _miasma_level), "毒雾", "部署持续停留的毒雾区域。")
		_append_upgrade_candidate(candidates, "shardburst", _is_upgrade_available("shardburst", _shardburst_level), "碎片喷射", "向前喷出扇形玻璃碎片。")
		_append_upgrade_candidate(candidates, "catalyst", _is_upgrade_available("catalyst", _catalyst_level), "催化反应", "引爆已铺开的毒雾，或在前场触发炼剂爆破。")
	elif _is_ranger_character():
		_append_upgrade_candidate(candidates, "needle", _is_upgrade_available("needle", _needle_level), "穿针 +1", "提升连射针矢的数量、伤害和穿透。")
		_append_upgrade_candidate(candidates, "volley", _is_upgrade_available("volley", _volley_level), "散羽齐射", "一次泼出整排箭雨清理追兵。")
		_append_upgrade_candidate(candidates, "glaive", _is_upgrade_available("glaive", _glaive_level), "回旋刀", "抛出会追踪敌人的回旋刀刃。")
		_append_upgrade_candidate(candidates, "trail", _is_upgrade_available("trail", _trail_level), "穿林迹", "沿移动方向扫出一条贯穿线。")
	elif _is_warden_character():
		_append_upgrade_candidate(candidates, "pulse", _is_upgrade_available("pulse", _pulse_level), "谐振脉冲 +1", "提高脉冲频率、半径和击退强度。")
		_append_upgrade_candidate(candidates, "ward", _is_upgrade_available("ward", _ward_level), "守卫环", "召出围绕自身旋转的守卫。")
		_append_upgrade_candidate(candidates, "beacon", _is_upgrade_available("beacon", _beacon_level), "回声信标", "在前场放下一座持续压制的信标。")
		_append_upgrade_candidate(candidates, "relay", _is_upgrade_available("relay", _relay_level), "中继线", "把自己、守卫和信标连成持续伤害线。")
	elif _is_blood_hunter_character():
		_append_upgrade_candidate(candidates, "oathshot", _is_upgrade_available("oathshot", _oathshot_level), "血誓箭 +1", "提高追猎箭数量、伤害和穿透，残血收益更高。")
		_append_upgrade_candidate(candidates, "brand", _is_upgrade_available("brand", _brand_level), "猎誓烙印", "给前场目标挂上烙印，收割时回血并炸裂。")
		_append_upgrade_candidate(candidates, "bloodtrail", _is_upgrade_available("bloodtrail", _bloodtrail_level), "血潮沼", "留下会反复脉冲的血沼磨掉追兵。")
		_append_upgrade_candidate(candidates, "verdict", _is_upgrade_available("verdict", _verdict_level), "誓刃穿心", "朝前切出一记长线处决，专杀被烙印的目标。")
	elif _is_grave_caller_character():
		_append_upgrade_candidate(candidates, "dirge", _is_upgrade_available("dirge", _dirge_level), "挽歌 +1", "提高挽歌弹数量和伤害。")
		_append_upgrade_candidate(candidates, "wake", _is_upgrade_available("wake", _wake_level), "起灵", "把尸核直接翻成新一轮爆发。")
		_append_upgrade_candidate(candidates, "toll", _is_upgrade_available("toll", _toll_level), "丧钟", "让场上的尸核同时敲出脉冲。")
		_append_upgrade_candidate(candidates, "choir", _is_upgrade_available("choir", _choir_level), "尸钟合唱", "调度多颗尸核同时向怪群合唱压进。")
	elif _is_illusionist_character():
		_append_upgrade_candidate(candidates, "mirrorbolt", _is_upgrade_available("mirrorbolt", _mirrorbolt_level), "镜折弹 +1", "提高镜折弹伤害、穿透和多点镜射频率。")
		_append_upgrade_candidate(candidates, "afterimage", _is_upgrade_available("afterimage", _afterimage_level), "残像", "留下更多、持续更久的残像作为火点。")
		_append_upgrade_candidate(candidates, "switchstep", _is_upgrade_available("switchstep", _switchstep_level), "换幕步", "和远端残像换位，同时在两端引爆。")
		_append_upgrade_candidate(candidates, "prismdance", _is_upgrade_available("prismdance", _prismdance_level), "棱镜舞台", "让本体和残像一起开火，织出镜廊火网。")
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


func _append_combo_upgrade_candidate(
	target: Array[Dictionary],
	key: String,
	enabled: bool,
	title: String,
	desc: String,
	tags: Array[String],
	combo: String,
	bucket: String,
	accent: Color
) -> void:
	if not enabled:
		return
	var candidate := {
		"key": key,
		"title": title,
		"desc": desc,
		"tags": tags.duplicate(),
		"combo": combo,
		"bucket": bucket,
		"accent": accent,
	}
	var route_info := _get_upgrade_route_info(key)
	if not route_info.is_empty():
		candidate["route"] = String(route_info.get("route", ""))
		candidate["route_hint"] = String(route_info.get("route_hint", ""))
	target.append(candidate)


func _build_combo_upgrade_choices() -> Array[Dictionary]:
	var candidates: Array[Dictionary] = []
	if _is_thunder_character():
		_append_combo_upgrade_candidate(candidates, "chain", _is_upgrade_available("chain", _chain_level), "连锁闪电 +1", "普通技能额外连锁 1 个目标，并继续拉长起跳与弹跳范围。", ["闪电", "连锁", "远程"], "和爆裂、雷球一起形成全屏导电链。", "skill", Color(0.44, 0.80, 1.0))
		_append_combo_upgrade_candidate(candidates, "detonate", _is_upgrade_available("detonate", _detonate_level), "电荷爆裂", "击败敌人后概率爆炸，越往后越适合当清场和连锁的中继点。", ["闪电", "击杀", "爆裂"], "击杀爆炸会把链路延展到下一片怪群。", "skill", Color(0.84, 0.96, 1.0))
		_append_combo_upgrade_candidate(candidates, "storm_orb", _is_upgrade_available("storm_orb", _storm_orb_level), "雷球领域", "抛出一颗持续 5 秒的雷球领域，持续电击附近敌人。", ["领域", "闪电", "召唤"], "用雷球定点锁场，再让连锁和爆裂接管残局。", "skill", Color(0.64, 0.88, 1.0))
		_append_combo_upgrade_candidate(candidates, "ascension", _ascension_level < 1, "雷霆进化", "连锁闪电额外 +5 链，闪电伤害暴涨，并解锁雷暴追击。", ["终局", "进化", "闪电"], "适合把整套闪电 build 推到终局清图。", "mutation", Color(0.98, 0.92, 0.68))
		_append_combo_upgrade_candidate(candidates, "mut_supercell", _chain_level >= 3 and _detonate_level >= 2 and _storm_orb_level >= 1 and not _supercell_mutation, "变异: 超导回响", "电荷爆裂会额外再放出一轮迷你连锁，让爆点继续滚雪球。", ["闪电", "爆裂", "变异"], "连锁闪电 + 击杀爆炸 + 雷球领域三件套完成闭环。", "mutation", Color(0.90, 0.96, 1.0))
	elif _is_blade_character():
		_append_combo_upgrade_candidate(candidates, "slash", _is_upgrade_available("slash", _slash_level), "钢刃斩 +1", "强化半圆挥击，并继续延长扇形火焰刀气的推进距离和覆盖宽度。", ["火焰", "近战", "刀气"], "刀气会穿透敌人并递减到 40%，越长越像推进波。", "skill", Color(1.0, 0.58, 0.34))
		_append_combo_upgrade_candidate(candidates, "blade_ring", _is_upgrade_available("blade_ring", _blade_ring_level), "旋刀护环", "增加或强化贴身旋刀，为近战 build 提供稳定护体。", ["近战", "护体", "旋刀"], "站场越稳，越能贪刀收完刀气后段。", "skill", Color(0.88, 0.94, 1.0))
		_append_combo_upgrade_candidate(candidates, "mooncut", _is_upgrade_available("mooncut", _mooncut_level), "残月斩", "向前抛出月牙刀波，补足中距离的斩线输出。", ["剑气", "中程", "穿透"], "和钢刃斩一起做双波清线。", "skill", Color(1.0, 0.70, 0.42))
		_append_combo_upgrade_candidate(candidates, "step_slash", _is_upgrade_available("step_slash", _step_slash_level), "踏空圆斩", "在脚下爆发圆斩，把贴脸敌人扫开并创造接刀空间。", ["近战", "爆发", "位移"], "适合保底清身位，再让刀气穿群。", "skill", Color(1.0, 0.86, 0.46))
		_append_combo_upgrade_candidate(candidates, "mut_flame_split", _slash_level >= 4 and _blade_ring_level >= 2 and not _flame_split_mutation, "变异: 焰刃分裂", "钢刃斩挥出的火焰刀气命中后会分裂为三道副刀气。", ["火焰", "分裂", "变异"], "火焰刀气 + 分裂 + 穿透衰减会直接改打法。", "mutation", Color(1.0, 0.88, 0.70))
		_append_combo_upgrade_candidate(candidates, "mut_rend", _mooncut_level >= 3 and not _rend_mutation, "变异: 裂月", "残月斩额外生成两道交叉刀波，前场覆盖更满。", ["剑气", "交叉", "变异"], "把残月从补刀技抬成主力清线技。", "mutation", Color(1.0, 0.80, 0.60))
		_append_combo_upgrade_candidate(candidates, "mut_execution", _step_slash_level >= 3 and _slash_level >= 4 and not _execution_mutation, "变异: 处决场", "踏空圆斩命中后会追加一次范围处决，专治贴脸混编。", ["近战", "终结", "变异"], "圆斩先稳住，再靠处决二次爆场。", "mutation", Color(1.0, 0.90, 0.70))
	elif _is_alchemist_character():
		_append_combo_upgrade_candidate(candidates, "flask", _is_upgrade_available("flask", _flask_level), "裂解瓶 +1", "缩短裂解瓶周转并提高爆破范围与伤害。", ["炼剂", "延时", "爆发"], "先用裂解瓶开团，再让毒雾和催化反应接住残局。", "skill", Color(0.82, 0.96, 0.54))
		_append_combo_upgrade_candidate(candidates, "miasma", _is_upgrade_available("miasma", _miasma_level), "毒雾铺设", "部署一团停留在原地的毒雾，持续压低近身敌人的血线。", ["毒雾", "控场", "持续"], "适合先铺地形，再逼敌人踏进处理区。", "skill", Color(0.68, 0.92, 0.46))
		_append_combo_upgrade_candidate(candidates, "shardburst", _is_upgrade_available("shardburst", _shardburst_level), "碎片喷射", "向前方喷出一排玻璃碎片，用中距离扇面补足清线。", ["扇面", "穿透", "中程"], "让炼金师不只靠区域技能，也能主动拆阵。", "skill", Color(0.92, 0.98, 0.74))
		_append_combo_upgrade_candidate(candidates, "catalyst", _is_upgrade_available("catalyst", _catalyst_level), "催化反应", "定时引爆已铺开的毒区；没有毒区时会直接在前场触发一次催化爆破。", ["炼剂", "联动", "爆发"], "毒雾越多，催化反应的交换价值越高。", "skill", Color(0.94, 0.98, 0.62))
	elif _is_ranger_character():
		_append_combo_upgrade_candidate(candidates, "needle", _is_upgrade_available("needle", _needle_level), "穿针 +1", "提高连射针矢的数量、伤害与穿透，让基础拉扯更稳定。", ["连射", "穿透", "远程"], "先把穿针补顺，游侠的整套节奏会更流畅。", "skill", Color(0.98, 0.86, 0.46))
		_append_combo_upgrade_candidate(candidates, "volley", _is_upgrade_available("volley", _volley_level), "散羽齐射", "一次泼出整排箭雨，适合清理扇面追兵。", ["扇面", "清线", "爆发"], "拿来补横向覆盖，避免只会处理单线目标。", "skill", Color(0.98, 0.90, 0.56))
		_append_combo_upgrade_candidate(candidates, "glaive", _is_upgrade_available("glaive", _glaive_level), "回旋刀", "抛出会追踪敌人的回旋刀刃，专门处理中高血目标。", ["追踪", "穿透", "狩猎"], "让游侠在走位时也能稳定点杀关键目标。", "skill", Color(0.86, 0.96, 0.66))
		_append_combo_upgrade_candidate(candidates, "trail", _is_upgrade_available("trail", _trail_level), "穿林迹", "沿自身移动方向扫出一条贯穿线，把追兵队形切开。", ["扫线", "位移", "压线"], "和高移速、散羽齐射非常契合。", "skill", Color(0.86, 0.98, 0.62))
	elif _is_warden_character():
		_append_combo_upgrade_candidate(candidates, "pulse", _is_upgrade_available("pulse", _pulse_level), "谐振脉冲 +1", "提高脉冲频率、半径与击退强度，稳住近身安全圈。", ["脉冲", "控场", "守点"], "先把基础脉冲补顺，整套守区节奏会更稳。", "skill", Color(0.52, 0.96, 0.82))
		_append_combo_upgrade_candidate(candidates, "ward", _is_upgrade_available("ward", _ward_level), "守卫环", "召出围绕自身旋转的守卫，用持续碰撞顶住贴脸敌人。", ["守卫", "护体", "持续"], "守点路线的核心组件。", "skill", Color(0.78, 0.98, 0.90))
		_append_combo_upgrade_candidate(candidates, "beacon", _is_upgrade_available("beacon", _beacon_level), "回声信标", "在前场放下一座脉冲信标，持续压制固定区域。", ["信标", "控区", "持续"], "适合和中继线一起把战场钉在前方。", "skill", Color(0.84, 0.98, 0.92))
		_append_combo_upgrade_candidate(candidates, "relay", _is_upgrade_available("relay", _relay_level), "中继线", "把自己、守卫和信标连成伤害线，对穿线目标持续施压。", ["直线", "联动", "站场"], "守卫越多，信标越稳，中继线越有压制感。", "skill", Color(0.92, 0.98, 0.94))
	elif _is_blood_hunter_character():
		_append_combo_upgrade_candidate(candidates, "oathshot", _is_upgrade_available("oathshot", _oathshot_level), "血誓箭 +1", "继续提高追猎箭的数量、伤害与穿透；生命越低，收益越夸张。", ["血契", "远程", "追猎"], "残血时会明显抬高整轮压线能力。", "skill", Color(0.96, 0.26, 0.34))
		_append_combo_upgrade_candidate(candidates, "brand", _is_upgrade_available("brand", _brand_level), "猎誓烙印", "给前场目标挂上烙印，被收掉时会直接回命并炸出补伤。", ["烙印", "收割", "续航"], "先贴烙印，再去穿心或拖进血沼。", "skill", Color(1.0, 0.68, 0.72))
		_append_combo_upgrade_candidate(candidates, "bloodtrail", _is_upgrade_available("bloodtrail", _bloodtrail_level), "血潮沼", "留下会反复脉冲的血沼，专门把追兵磨成回收区。", ["区域", "回收", "残血"], "适合边退边收，把地图刷成血线交换场。", "skill", Color(0.92, 0.40, 0.46))
		_append_combo_upgrade_candidate(candidates, "verdict", _is_upgrade_available("verdict", _verdict_level), "誓刃穿心", "朝前切出一记长线处决，把被烙印的目标直接穿掉。", ["斩线", "处决", "爆发"], "用来接烙印和残局收头最凶。", "skill", Color(1.0, 0.82, 0.84))
	elif _is_grave_caller_character():
		_append_combo_upgrade_candidate(candidates, "dirge", _is_upgrade_available("dirge", _dirge_level), "挽歌 +1", "持续提高挽歌弹的数量、伤害和收线密度。", ["尸核", "远程", "引子"], "先把挽歌补顺，尸核生成的节奏才够快。", "skill", Color(0.58, 0.88, 0.78))
		_append_combo_upgrade_candidate(candidates, "wake", _is_upgrade_available("wake", _wake_level), "起灵", "把尸核直接翻成下一波爆发，能把残局续成新一轮火力。", ["尸核", "回收", "爆发"], "先有尸核再起灵，越打越厚。", "skill", Color(0.82, 0.98, 0.92))
		_append_combo_upgrade_candidate(candidates, "toll", _is_upgrade_available("toll", _toll_level), "丧钟", "让场上的尸核同时敲出脉冲，压住怪潮再接挽歌。", ["脉冲", "控场", "尸核"], "适合把散落残局重新钉回一片。", "skill", Color(0.68, 0.96, 0.88))
		_append_combo_upgrade_candidate(candidates, "choir", _is_upgrade_available("choir", _choir_level), "尸钟合唱", "调度多颗尸核同时开火，从多点往同一片怪群合唱压进。", ["合唱", "多点", "齐射"], "是把尸核路线推成高峰值爆发的关键。", "skill", Color(0.92, 1.0, 0.96))
	elif _is_illusionist_character():
		_append_combo_upgrade_candidate(candidates, "mirrorbolt", _is_upgrade_available("mirrorbolt", _mirrorbolt_level), "镜折弹 +1", "提高镜折弹的伤害、穿透和多点镜射频率。", ["镜射", "远程", "假身"], "假身越多，这张卡越像全图齐射。", "skill", Color(0.86, 0.72, 1.0))
		_append_combo_upgrade_candidate(candidates, "afterimage", _is_upgrade_available("afterimage", _afterimage_level), "残像", "留下更多、持续更久的残像，把火点和换位口都铺开。", ["残像", "布点", "戏法"], "整套玩法的舞台基础。", "skill", Color(0.96, 0.88, 1.0))
		_append_combo_upgrade_candidate(candidates, "switchstep", _is_upgrade_available("switchstep", _switchstep_level), "换幕步", "和远端残像换位，同时在换出点和落点各炸一轮。", ["换位", "爆发", "脱身"], "最能把追兵带偏的一张牌。", "skill", Color(0.80, 0.72, 0.98))
		_append_combo_upgrade_candidate(candidates, "prismdance", _is_upgrade_available("prismdance", _prismdance_level), "棱镜舞台", "让本体和多处残像一起开火，把直线火力拆成镜廊火网。", ["多点", "舞台", "齐射"], "把单点风筝抬成整片镜场。", "skill", Color(0.98, 0.92, 1.0))
	else:
		_append_combo_upgrade_candidate(candidates, "bolt", _is_upgrade_available("bolt", _bolt_level), "奥术箭 +1", "继续增加数量、穿透和基础输出，让远程清线更稳定。", ["奥术", "远程", "穿透"], "环轨和雷暴会把漏掉的敌人补进奥术箭线路。", "skill", Color(0.44, 0.84, 1.0))
		_append_combo_upgrade_candidate(candidates, "orbit", _is_upgrade_available("orbit", _orbit_level), "环轨核心", "新增或强化环轨卫星，补出贴身护体层。", ["召唤", "护体", "轨道"], "适合搭配新星做近身爆发联动。", "skill", Color(0.42, 0.98, 0.90))
		_append_combo_upgrade_candidate(candidates, "nova", _is_upgrade_available("nova", _nova_level), "新星爆发", "释放一轮环形爆裂投射物，让法师也能硬切近圈。", ["奥术", "爆发", "范围"], "环轨越多，新星的爆发站位越自由。", "skill", Color(1.0, 0.80, 0.36))
		_append_combo_upgrade_candidate(candidates, "storm", _is_upgrade_available("storm", _storm_level), "雷暴牵引", "召唤雷暴锁定附近敌人，提供补刀和压制。", ["雷暴", "锁定", "控场"], "奥术箭收残，雷暴点关键目标。", "skill", Color(0.64, 0.80, 1.0))
		_append_combo_upgrade_candidate(candidates, "mut_nova_orbit", _orbit_level >= 2 and _nova_level >= 2 and not _nova_orbit_mutation, "变异: 轨道新星", "释放新星时，所有环轨卫星会同步抛出一轮小型爆裂。", ["奥术", "召唤", "变异"], "环轨核心 + 新星爆发会从自保 build 变成近身爆发 build。", "mutation", Color(1.0, 0.86, 0.52))
		_append_combo_upgrade_candidate(candidates, "mut_singularity", _storm_level >= 3 and _orbit_level >= 2 and not _storm_singularity_mutation, "变异: 雷暴奇点", "雷暴命中后会把周围敌人往落点拽，并追加一次小范围爆轰。", ["雷暴", "控场", "变异"], "雷暴牵引 + 环轨核心能把战场挤成可控团块。", "mutation", Color(0.80, 0.92, 1.0))

	_append_endgame_evolution_candidates(candidates)
	_append_combo_generic_upgrade_candidates(candidates)
	return _pick_combo_upgrade_choices(candidates)


func _append_combo_generic_upgrade_candidates(target: Array[Dictionary]) -> void:
	_append_combo_upgrade_candidate(target, "stride", _is_upgrade_available("stride", _stride_level), "步幅矩阵", "提高移速，方便抢祭坛、穿火线和贴脸拾取奖励。", ["机动", "节奏"], "高手向的换位组件。", "support", Color(0.78, 0.92, 1.0))
	_append_combo_upgrade_candidate(target, "vitality", _is_upgrade_available("vitality", _vitality_level), "生命织网", "提高生命上限，并给冒险换收益留更多容错空间。", ["生存", "续航"], "更敢压血线吃倍率。", "support", Color(0.92, 0.98, 0.84))
	_append_combo_upgrade_candidate(target, "focus", _is_upgrade_available("focus", _focus_level), "聚焦镜片", "缩短全部技能冷却，把联动循环压得更紧。", ["循环", "冷却"], "适合任何依赖技能接力的构筑。", "support", Color(0.88, 0.92, 1.0))
	_append_combo_upgrade_candidate(target, "magnet", _is_upgrade_available("magnet", _magnet_level), "磁引场", "扩大经验球吸附范围，更容易打出贴脸拾取和连升节奏。", ["拾取", "经济"], "想冲榜时价值很高。", "support", Color(1.0, 0.90, 0.64))
	_append_combo_upgrade_candidate(target, "mastery", _is_upgrade_available("mastery", _mastery_level), "战斗精要", "提高法术威力与经验收益，让核心联动更早成型。", ["成长", "收益"], "偏中后期的构筑加速器。", "support", Color(1.0, 0.82, 0.52))
	_append_combo_upgrade_candidate(target, "repair", true, "战地修复", "立即恢复 3 点生命，适合高压波次里强行续一口气。", ["应急", "续航"], "把残血倍率安全换成继续冲分。", "support", Color(0.96, 0.98, 0.88))
	_append_combo_upgrade_candidate(target, "cache", true, "战备缓存", "立即获得当前等级经验条的 35%，加速下一次联动成型。", ["经济", "节奏"], "想追关键变异时最直接。", "support", Color(1.0, 0.88, 0.58))


func _get_build_path_definitions() -> Array[Dictionary]:
	var definitions: Array[Dictionary] = []
	var path_variants = CHARACTER_BUILD_PATHS.get(_selected_character_id, [])
	if path_variants is Array:
		for path_variant in path_variants:
			var path: Dictionary = path_variant
			definitions.append(path)
	return definitions


func _get_build_path_definition_by_id(path_id: String) -> Dictionary:
	for path in _get_build_path_definitions():
		if String(path.get("id", "")) == path_id:
			return path
	return {}


func _get_endgame_evolution_definitions_for_route(route_id: String) -> Array[Dictionary]:
	var definitions: Array[Dictionary] = []
	var route_variants = ENDGAME_EVOLUTION_DEFINITIONS.get(route_id, [])
	if route_variants is Array:
		for route_variant in route_variants:
			var entry: Dictionary = route_variant
			definitions.append(entry)
	return definitions


func _get_endgame_evolution_definition(key: String) -> Dictionary:
	for route_id_variant in ENDGAME_EVOLUTION_DEFINITIONS.keys():
		var route_id := String(route_id_variant)
		for entry in _get_endgame_evolution_definitions_for_route(route_id):
			if String(entry.get("key", "")) == key:
				var resolved := entry.duplicate(true)
				resolved["route_id"] = route_id
				return resolved
	return {}


func _get_endgame_route_id_for_key(key: String) -> String:
	var definition := _get_endgame_evolution_definition(key)
	return String(definition.get("route_id", ""))


func _has_endgame_evolution(key: String) -> bool:
	return _selected_endgame_branches.values().has(key)


func _has_endgame_evolution_for_route(route_id: String) -> bool:
	return _selected_endgame_branches.has(route_id)


func _get_selected_endgame_evolution(route_id: String) -> String:
	return String(_selected_endgame_branches.get(route_id, ""))


func _is_endgame_route_ready(path: Dictionary) -> bool:
	if _run_time < 480.0:
		return false
	var route_id := String(path.get("id", ""))
	if route_id.is_empty() or _has_endgame_evolution_for_route(route_id):
		return false
	return int(path.get("score", 0)) >= 10


func _append_endgame_evolution_candidates(target: Array[Dictionary]) -> void:
	var snapshot := _get_build_focus_snapshot()
	var primary: Dictionary = snapshot.get("primary", {})
	if primary.is_empty() or not _is_endgame_route_ready(primary):
		return

	var route_id := String(primary.get("id", ""))
	for evolution in _get_endgame_evolution_definitions_for_route(route_id):
		_append_combo_upgrade_candidate(
			target,
			String(evolution.get("key", "")),
			not _has_endgame_evolution(String(evolution.get("key", ""))),
			String(evolution.get("title", "终局分叉")),
			String(evolution.get("desc", "")),
			evolution.get("tags", []),
			String(evolution.get("combo", "")),
			"endgame",
			evolution.get("accent", Color(1.0, 0.90, 0.64))
		)


func _get_upgrade_progress_value(key: String) -> int:
	match key:
		"bolt":
			return _bolt_level
		"orbit":
			return _orbit_level
		"nova":
			return _nova_level
		"storm":
			return _storm_level
		"slash":
			return _slash_level
		"blade_ring":
			return _blade_ring_level
		"mooncut":
			return _mooncut_level
		"step_slash":
			return _step_slash_level
		"chain":
			return _chain_level
		"detonate":
			return _detonate_level
		"storm_orb":
			return _storm_orb_level
		"ascension":
			return _ascension_level
		"flask":
			return _flask_level
		"miasma":
			return _miasma_level
		"shardburst":
			return _shardburst_level
		"catalyst":
			return _catalyst_level
		"needle":
			return _needle_level
		"volley":
			return _volley_level
		"glaive":
			return _glaive_level
		"trail":
			return _trail_level
		"pulse":
			return _pulse_level
		"ward":
			return _ward_level
		"beacon":
			return _beacon_level
		"relay":
			return _relay_level
		"oathshot":
			return _oathshot_level
		"brand":
			return _brand_level
		"bloodtrail":
			return _bloodtrail_level
		"verdict":
			return _verdict_level
		"dirge":
			return _dirge_level
		"wake":
			return _wake_level
		"toll":
			return _toll_level
		"choir":
			return _choir_level
		"mirrorbolt":
			return _mirrorbolt_level
		"afterimage":
			return _afterimage_level
		"switchstep":
			return _switchstep_level
		"prismdance":
			return _prismdance_level
		"stride":
			return _stride_level
		"vitality":
			return _vitality_level
		"focus":
			return _focus_level
		"magnet":
			return _magnet_level
		"mastery":
			return _mastery_level
		"mut_flame_split":
			return int(_flame_split_mutation)
		"mut_rend":
			return int(_rend_mutation)
		"mut_execution":
			return int(_execution_mutation)
		"mut_nova_orbit":
			return int(_nova_orbit_mutation)
		"mut_singularity":
			return int(_storm_singularity_mutation)
		"mut_supercell":
			return int(_supercell_mutation)
		_:
			return 0


func _get_upgrade_target_level(key: String) -> int:
	return int(BUILD_ROUTE_TARGETS.get(key, 1))


func _get_upgrade_short_label(key: String) -> String:
	match key:
		"bolt":
			return "奥术箭"
		"orbit":
			return "环轨核心"
		"nova":
			return "新星爆发"
		"storm":
			return "雷暴牵引"
		"slash":
			return "钢刃斩"
		"blade_ring":
			return "旋刀护环"
		"mooncut":
			return "残月斩"
		"step_slash":
			return "踏空圆斩"
		"chain":
			return "连锁闪电"
		"detonate":
			return "电荷爆裂"
		"storm_orb":
			return "雷球领域"
		"ascension":
			return "雷霆进化"
		"flask":
			return "裂解瓶"
		"miasma":
			return "毒雾"
		"shardburst":
			return "碎片喷射"
		"catalyst":
			return "催化反应"
		"needle":
			return "穿针"
		"volley":
			return "散羽齐射"
		"glaive":
			return "回旋刀"
		"trail":
			return "穿林迹"
		"pulse":
			return "谐振脉冲"
		"ward":
			return "守卫环"
		"beacon":
			return "信标"
		"relay":
			return "中继线"
		"oathshot":
			return "血誓箭"
		"brand":
			return "猎誓烙印"
		"bloodtrail":
			return "血潮沼"
		"verdict":
			return "誓刃穿心"
		"dirge":
			return "挽歌"
		"wake":
			return "起灵"
		"toll":
			return "丧钟"
		"choir":
			return "尸钟合唱"
		"mirrorbolt":
			return "镜折弹"
		"afterimage":
			return "残像"
		"switchstep":
			return "换幕步"
		"prismdance":
			return "棱镜舞台"
		"stride":
			return "步幅矩阵"
		"vitality":
			return "生命织网"
		"focus":
			return "聚焦镜片"
		"magnet":
			return "磁引场"
		"mastery":
			return "战斗精要"
		"mut_flame_split":
			return "焰刃分裂"
		"mut_rend":
			return "裂月"
		"mut_execution":
			return "处决场"
		"mut_nova_orbit":
			return "轨道新星"
		"mut_singularity":
			return "雷暴奇点"
		"mut_supercell":
			return "超导回响"
		"repair":
			return "战地修复"
		"cache":
			return "战备缓存"
		_:
			return key


func _get_upgrade_short_label_v2(key: String) -> String:
	match key:
		"flask":
			return "裂解瓶"
		"miasma":
			return "毒雾"
		"shardburst":
			return "碎片喷射"
		"catalyst":
			return "催化反应"
		"needle":
			return "穿针"
		"volley":
			return "散羽齐射"
		"glaive":
			return "回旋刀"
		"trail":
			return "穿林迹"
		"pulse":
			return "谐振脉冲"
		"ward":
			return "守卫环"
		"beacon":
			return "信标"
		"relay":
			return "中继线"
		"oathshot":
			return "血誓箭"
		"brand":
			return "猎誓烙印"
		"bloodtrail":
			return "血潮沼"
		"verdict":
			return "誓刃穿心"
		"dirge":
			return "挽歌"
		"wake":
			return "起灵"
		"toll":
			return "丧钟"
		"choir":
			return "尸钟合唱"
		"mirrorbolt":
			return "镜折弹"
		"afterimage":
			return "残像"
		"switchstep":
			return "换幕步"
		"prismdance":
			return "棱镜舞台"
		_:
			return _get_upgrade_short_label(key)


func _get_build_path_score(path: Dictionary) -> int:
	var score := 0
	var weights: Dictionary = path.get("weights", {})
	for key_variant in weights.keys():
		var key := String(key_variant)
		var weight := int(weights.get(key_variant, 0))
		score += _get_upgrade_progress_value(key) * weight
	return score


func _get_build_focus_snapshot() -> Dictionary:
	var primary: Dictionary = {}
	var secondary: Dictionary = {}
	for path in _get_build_path_definitions():
		var entry: Dictionary = path.duplicate(true)
		entry["score"] = _get_build_path_score(path)
		if primary.is_empty() or int(entry.get("score", 0)) > int(primary.get("score", -1)):
			secondary = primary
			primary = entry
		elif secondary.is_empty() or int(entry.get("score", 0)) > int(secondary.get("score", -1)):
			secondary = entry
	return {
		"primary": primary,
		"secondary": secondary,
	}


func _is_build_focus_locked(snapshot: Dictionary) -> bool:
	var primary: Dictionary = snapshot.get("primary", {})
	if primary.is_empty():
		return false
	var primary_score := int(primary.get("score", 0))
	if primary_score <= 0:
		return false
	var secondary: Dictionary = snapshot.get("secondary", {})
	if secondary.is_empty():
		return primary_score >= 3
	return primary_score >= 3 and primary_score - int(secondary.get("score", 0)) >= 2


func _get_ranked_build_paths(snapshot: Dictionary) -> Array[Dictionary]:
	var ranked: Array[Dictionary] = []
	var seen_ids: Array[String] = []
	for route_variant in [snapshot.get("primary", {}), snapshot.get("secondary", {})]:
		var route: Dictionary = route_variant
		var route_id := String(route.get("id", ""))
		if route_id.is_empty() or seen_ids.has(route_id):
			continue
		ranked.append(route)
		seen_ids.append(route_id)
	for path in _get_build_path_definitions():
		var route_id := String(path.get("id", ""))
		if seen_ids.has(route_id):
			continue
		ranked.append(path)
		seen_ids.append(route_id)
	return ranked


func _get_upgrade_route_ids(key: String) -> Array[String]:
	var route_ids: Array[String] = []
	var evolution_route_id := _get_endgame_route_id_for_key(key)
	if not evolution_route_id.is_empty():
		route_ids.append(evolution_route_id)
		return route_ids
	for path in _get_build_path_definitions():
		var weights: Dictionary = path.get("weights", {})
		if weights.has(key):
			route_ids.append(String(path.get("id", "")))
	return route_ids


func _get_candidate_route_ids(candidate: Dictionary) -> Array[String]:
	return _get_upgrade_route_ids(String(candidate.get("key", "")))


func _get_candidate_route_priority(candidate: Dictionary, route_id: String) -> int:
	if route_id.is_empty():
		return 0
	var key := String(candidate.get("key", ""))
	var bucket := String(candidate.get("bucket", "skill"))
	if bucket == "endgame":
		return 160 if _get_endgame_route_id_for_key(key) == route_id else 0

	var path := _get_build_path_definition_by_id(route_id)
	if path.is_empty():
		return 0
	var weights: Dictionary = path.get("weights", {})
	if not weights.has(key):
		return 0

	var current_level := _get_upgrade_progress_value(key)
	var target_level := _get_upgrade_target_level(key)
	var missing := maxi(target_level - current_level, 0)
	var bucket_bonus := 10
	match bucket:
		"mutation":
			bucket_bonus = 28
		"skill":
			bucket_bonus = 16
		"support":
			bucket_bonus = 8
	return int(weights.get(key, 0)) * 20 + missing * 6 + bucket_bonus + (6 if current_level == 0 else 0) - current_level * 2


func _get_general_candidate_priority(candidate: Dictionary, primary_id: String, secondary_id: String) -> int:
	var bucket := String(candidate.get("bucket", "skill"))
	var bucket_bonus := 48
	match bucket:
		"endgame":
			bucket_bonus = 120
		"mutation":
			bucket_bonus = 82
		"skill":
			bucket_bonus = 60
		"support":
			bucket_bonus = 42
	var route_ids := _get_candidate_route_ids(candidate)
	var shared_bonus := 0
	if not primary_id.is_empty() and not secondary_id.is_empty() and route_ids.has(primary_id) and route_ids.has(secondary_id):
		shared_bonus = 14
	elif route_ids.is_empty():
		shared_bonus = 4
	return bucket_bonus + _get_candidate_route_priority(candidate, primary_id) + int(_get_candidate_route_priority(candidate, secondary_id) / 2) + shared_bonus


func _pop_best_route_candidate(
	pool: Array[Dictionary],
	route_id: String,
	exclusive_only: bool = false,
	allow_shared: bool = true,
	allowed_buckets: Array[String] = []
) -> Dictionary:
	if route_id.is_empty():
		return {}
	var best_index := -1
	var best_score := -1
	for index in range(pool.size()):
		var candidate: Dictionary = pool[index]
		var bucket := String(candidate.get("bucket", "skill"))
		if not allowed_buckets.is_empty() and not allowed_buckets.has(bucket):
			continue
		var route_ids := _get_candidate_route_ids(candidate)
		if not route_ids.has(route_id):
			continue
		if exclusive_only and route_ids.size() != 1:
			continue
		if not allow_shared and route_ids.size() > 1:
			continue
		var score := _get_candidate_route_priority(candidate, route_id)
		score += 10 if route_ids.size() == 1 else 4
		if exclusive_only:
			score += 12
		if score > best_score:
			best_score = score
			best_index = index
	if best_index < 0:
		return {}
	var choice := pool[best_index]
	pool.remove_at(best_index)
	return choice


func _pop_best_shared_route_candidate(
	pool: Array[Dictionary],
	primary_id: String,
	secondary_id: String,
	allowed_buckets: Array[String] = []
) -> Dictionary:
	if primary_id.is_empty() or secondary_id.is_empty():
		return {}
	var best_index := -1
	var best_score := -1
	for index in range(pool.size()):
		var candidate: Dictionary = pool[index]
		var bucket := String(candidate.get("bucket", "skill"))
		if not allowed_buckets.is_empty() and not allowed_buckets.has(bucket):
			continue
		var route_ids := _get_candidate_route_ids(candidate)
		if not route_ids.has(primary_id) or not route_ids.has(secondary_id):
			continue
		var score := _get_candidate_route_priority(candidate, primary_id) + _get_candidate_route_priority(candidate, secondary_id) + 16
		if score > best_score:
			best_score = score
			best_index = index
	if best_index < 0:
		return {}
	var choice := pool[best_index]
	pool.remove_at(best_index)
	return choice


func _pop_best_support_candidate(pool: Array[Dictionary], primary_id: String, secondary_id: String) -> Dictionary:
	var best_index := -1
	var best_score := -1
	for index in range(pool.size()):
		var candidate: Dictionary = pool[index]
		if String(candidate.get("bucket", "skill")) != "support":
			continue
		var route_ids := _get_candidate_route_ids(candidate)
		var score := 42
		score += _get_candidate_route_priority(candidate, primary_id)
		score += int(_get_candidate_route_priority(candidate, secondary_id) / 2)
		if not route_ids.is_empty():
			score += 10 if route_ids.has(primary_id) else 0
			score += 6 if route_ids.has(secondary_id) else 0
		else:
			score += 4
		if score > best_score:
			best_score = score
			best_index = index
	if best_index < 0:
		return {}
	var choice := pool[best_index]
	pool.remove_at(best_index)
	return choice


func _pop_best_bucket_candidate(pool: Array[Dictionary], bucket_name: String, primary_id: String, secondary_id: String) -> Dictionary:
	var best_index := -1
	var best_score := -1
	for index in range(pool.size()):
		var candidate: Dictionary = pool[index]
		if String(candidate.get("bucket", "skill")) != bucket_name:
			continue
		var score := _get_general_candidate_priority(candidate, primary_id, secondary_id)
		if score > best_score:
			best_score = score
			best_index = index
	if best_index < 0:
		return {}
	var choice := pool[best_index]
	pool.remove_at(best_index)
	return choice


func _pop_best_general_candidate(pool: Array[Dictionary], primary_id: String, secondary_id: String) -> Dictionary:
	var best_index := -1
	var best_score := -1
	for index in range(pool.size()):
		var candidate: Dictionary = pool[index]
		var score := _get_general_candidate_priority(candidate, primary_id, secondary_id)
		if score > best_score:
			best_score = score
			best_index = index
	if best_index < 0:
		return {}
	var choice := pool[best_index]
	pool.remove_at(best_index)
	return choice


func _annotate_combo_choice_build_role(choice: Dictionary, snapshot: Dictionary) -> Dictionary:
	var annotated := choice.duplicate(true)
	var primary: Dictionary = snapshot.get("primary", {})
	var secondary: Dictionary = snapshot.get("secondary", {})
	var primary_id := String(primary.get("id", ""))
	var secondary_id := String(secondary.get("id", ""))
	var route_ids := _get_candidate_route_ids(annotated)
	var bucket := String(annotated.get("bucket", "skill"))
	var role := ""
	if bucket == "endgame":
		role = "终局分叉"
	elif route_ids.is_empty():
		role = "通用补强"
	elif not _is_build_focus_locked(snapshot):
		role = "开局通用件" if route_ids.size() > 1 else "开局定流派"
	else:
		var on_primary := route_ids.has(primary_id)
		var on_secondary := route_ids.has(secondary_id)
		if on_primary and on_secondary:
			role = "双路线通用"
		elif on_primary:
			role = "主路线推进"
		elif on_secondary:
			role = "副路线转向"
		else:
			role = "通用补强"
	if not role.is_empty():
		annotated["route_role"] = role
	return annotated


func _get_build_path_recommendations(path: Dictionary, count: int = 2) -> Array[String]:
	var weights: Dictionary = path.get("weights", {})
	var pending: Array[Dictionary] = []
	for key_variant in weights.keys():
		var key := String(key_variant)
		var current_level := _get_upgrade_progress_value(key)
		var target_level := _get_upgrade_target_level(key)
		var remaining: int = maxi(target_level - current_level, 0)
		if remaining <= 0:
			continue
		pending.append({
			"label": _get_upgrade_short_label_v2(key),
			"priority": remaining * int(weights.get(key_variant, 0)),
		})

	var result: Array[String] = []
	while result.size() < count and not pending.is_empty():
		var best_index := 0
		var best_priority := int(pending[0].get("priority", 0))
		for index in range(1, pending.size()):
			var priority := int(pending[index].get("priority", 0))
			if priority > best_priority:
				best_priority = priority
				best_index = index
		result.append(String(pending[best_index].get("label", "核心组件")))
		pending.remove_at(best_index)
	return result


func _get_upgrade_route_info(key: String) -> Dictionary:
	var evolution_route_id := _get_endgame_route_id_for_key(key)
	if not evolution_route_id.is_empty():
		var route_path := _get_build_path_definition_by_id(evolution_route_id)
		return {
			"route": String(route_path.get("name", "终局路线")),
			"route_hint": "8:00 后从该路线的两种终局形态里二选一。",
		}

	var related_paths: Array[Dictionary] = []
	for path in _get_build_path_definitions():
		var weights: Dictionary = path.get("weights", {})
		if weights.has(key):
			related_paths.append(path)

	if related_paths.is_empty():
		return {}

	if related_paths.size() == 1:
		var route_path: Dictionary = related_paths[0]
		var recommendations := _get_build_path_recommendations(route_path, 2)
		return {
			"route": String(route_path.get("name", "当前路线")),
			"route_hint": "核心件: %s" % (" / ".join(recommendations) if not recommendations.is_empty() else String(route_path.get("focus", ""))),
		}

	var route_names: Array[String] = []
	for path in related_paths:
		route_names.append(String(path.get("name", "当前路线")))
	return {
		"route": "双路线通用",
		"route_hint": "同时补 %s" % " / ".join(route_names),
	}


func _pick_combo_upgrade_choices(candidates: Array[Dictionary]) -> Array[Dictionary]:
	var snapshot := _get_build_focus_snapshot()
	var primary: Dictionary = snapshot.get("primary", {})
	var secondary: Dictionary = snapshot.get("secondary", {})
	var primary_id := String(primary.get("id", ""))
	var secondary_id := String(secondary.get("id", ""))
	var focus_locked := _is_build_focus_locked(snapshot)
	var working: Array[Dictionary] = []
	for candidate_variant in candidates:
		var candidate: Dictionary = candidate_variant.duplicate(true)
		working.append(candidate)

	var result: Array[Dictionary] = []
	var has_endgame := false
	for candidate in working:
		if String(candidate.get("bucket", "skill")) == "endgame":
			has_endgame = true
			break

	if has_endgame:
		var first_endgame := _pop_best_route_candidate(working, primary_id, false, true, ["endgame"])
		if first_endgame.is_empty():
			first_endgame = _pop_best_bucket_candidate(working, "endgame", primary_id, secondary_id)
		if not first_endgame.is_empty():
			result.append(first_endgame)

		var second_endgame := _pop_best_bucket_candidate(working, "endgame", primary_id, secondary_id)
		if not second_endgame.is_empty():
			result.append(second_endgame)

		var followup := _pop_best_route_candidate(working, primary_id, false, true, ["mutation", "skill", "support"])
		if followup.is_empty() and not secondary_id.is_empty():
			followup = _pop_best_route_candidate(working, secondary_id, false, true, ["mutation", "skill", "support"])
		if followup.is_empty():
			followup = _pop_best_support_candidate(working, primary_id, secondary_id)
		if followup.is_empty():
			followup = _pop_best_general_candidate(working, primary_id, secondary_id)
		if not followup.is_empty():
			result.append(followup)
	elif not focus_locked:
		var ranked_paths := _get_ranked_build_paths(snapshot)
		if ranked_paths.size() >= 1:
			var first_route_id := String(ranked_paths[0].get("id", ""))
			var first_route_pick := _pop_best_route_candidate(working, first_route_id, true, false, ["mutation", "skill"])
			if first_route_pick.is_empty():
				first_route_pick = _pop_best_route_candidate(working, first_route_id, false, true, ["mutation", "skill", "support"])
			if not first_route_pick.is_empty():
				result.append(first_route_pick)

		if ranked_paths.size() >= 2:
			var second_route_id := String(ranked_paths[1].get("id", ""))
			var second_route_pick := _pop_best_route_candidate(working, second_route_id, true, false, ["mutation", "skill"])
			if second_route_pick.is_empty():
				second_route_pick = _pop_best_route_candidate(working, second_route_id, false, true, ["mutation", "skill", "support"])
			if not second_route_pick.is_empty():
				result.append(second_route_pick)

			var bridge_pick := _pop_best_shared_route_candidate(working, String(ranked_paths[0].get("id", "")), second_route_id, ["skill", "support", "mutation"])
			if bridge_pick.is_empty():
				bridge_pick = _pop_best_support_candidate(working, String(ranked_paths[0].get("id", "")), second_route_id)
			if bridge_pick.is_empty():
				bridge_pick = _pop_best_general_candidate(working, String(ranked_paths[0].get("id", "")), second_route_id)
			if not bridge_pick.is_empty():
				result.append(bridge_pick)
	else:
		var primary_pick := _pop_best_route_candidate(working, primary_id, false, true, ["mutation", "skill", "support"])
		if primary_pick.is_empty():
			primary_pick = _pop_best_shared_route_candidate(working, primary_id, secondary_id, ["mutation", "skill", "support"])
		if primary_pick.is_empty():
			primary_pick = _pop_best_general_candidate(working, primary_id, secondary_id)
		if not primary_pick.is_empty():
			result.append(primary_pick)

		var pivot_pick: Dictionary = {}
		if not secondary_id.is_empty():
			pivot_pick = _pop_best_route_candidate(working, secondary_id, true, true, ["mutation", "skill", "support"])
			if pivot_pick.is_empty():
				pivot_pick = _pop_best_shared_route_candidate(working, primary_id, secondary_id, ["mutation", "skill", "support"])
		if pivot_pick.is_empty():
			pivot_pick = _pop_best_route_candidate(working, primary_id, false, true, ["mutation", "skill"])
		if pivot_pick.is_empty():
			pivot_pick = _pop_best_general_candidate(working, primary_id, secondary_id)
		if not pivot_pick.is_empty():
			result.append(pivot_pick)

		var support_pick := _pop_best_support_candidate(working, primary_id, secondary_id)
		if support_pick.is_empty() and not secondary_id.is_empty():
			support_pick = _pop_best_route_candidate(working, secondary_id, false, true, ["mutation", "skill", "support"])
		if support_pick.is_empty():
			support_pick = _pop_best_general_candidate(working, primary_id, secondary_id)
		if not support_pick.is_empty():
			result.append(support_pick)

	while result.size() < 3 and not working.is_empty():
		var fallback_choice := _pop_best_general_candidate(working, primary_id, secondary_id)
		if fallback_choice.is_empty():
			break
		result.append(fallback_choice)

	var finalized: Array[Dictionary] = []
	for choice_variant in result:
		var choice: Dictionary = choice_variant
		if choice.is_empty():
			continue
		finalized.append(_annotate_combo_choice_build_role(choice, snapshot))
	return finalized


func _pop_random_combo_upgrade(pool: Array[Dictionary]) -> Dictionary:
	var pick_index := _rng.randi_range(0, pool.size() - 1)
	var choice := pool[pick_index]
	pool.remove_at(pick_index)
	return choice


func _is_upgrade_available(key: String, current_level: int) -> bool:
	if _is_unbounded_upgrade_mode():
		return true
	return current_level < int(UPGRADE_LIMITS.get(key, current_level + 1))


func _apply_character_upgrade_choice(index: int) -> void:
	if index < 0 or index >= _upgrade_choices.size():
		return

	var choice: Dictionary = _upgrade_choices[index]
	var choice_key := String(choice.get("key", ""))
	var endgame_route_id := _get_endgame_route_id_for_key(choice_key)
	if not endgame_route_id.is_empty():
		_selected_endgame_branches[endgame_route_id] = choice_key
	else:
		match choice_key:
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
			"flask":
				_flask_level += 1
			"miasma":
				_miasma_level += 1
			"shardburst":
				_shardburst_level += 1
			"catalyst":
				_catalyst_level += 1
			"needle":
				_needle_level += 1
			"volley":
				_volley_level += 1
			"glaive":
				_glaive_level += 1
			"trail":
				_trail_level += 1
			"pulse":
				_pulse_level += 1
			"ward":
				_ward_level += 1
			"beacon":
				_beacon_level += 1
			"relay":
				_relay_level += 1
			"oathshot":
				_oathshot_level += 1
			"brand":
				_brand_level += 1
			"bloodtrail":
				_bloodtrail_level += 1
			"verdict":
				_verdict_level += 1
			"dirge":
				_dirge_level += 1
			"wake":
				_wake_level += 1
			"toll":
				_toll_level += 1
			"choir":
				_choir_level += 1
			"mirrorbolt":
				_mirrorbolt_level += 1
			"afterimage":
				_afterimage_level += 1
			"switchstep":
				_switchstep_level += 1
			"prismdance":
				_prismdance_level += 1
			"mut_flame_split":
				_flame_split_mutation = true
			"mut_rend":
				_rend_mutation = true
			"mut_execution":
				_execution_mutation = true
			"mut_nova_orbit":
				_nova_orbit_mutation = true
			"mut_singularity":
				_storm_singularity_mutation = true
			"mut_supercell":
				_supercell_mutation = true
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
	_update_character_hud_v2()

	_state = GameState.PLAYING
	_set_pause_state(false)
	if _experience >= _xp_to_next:
		_open_level_up()
	return


func _apply_upgrade_choice(index: int) -> void:
	if _choice_context == "contract":
		_apply_contract_choice(index)
		return
	_apply_character_upgrade_choice(index)


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


func _update_character_hud_v2() -> void:
	if _player == null or not is_instance_valid(_player):
		return

	var spell_lines := _get_build_info_lines()
	var skill_entries := _build_hud_skill_entries_v2()
	var threat_text := "%s   %s   倍率 x%.2f   得分 %d   %s" % [
		_get_objective_text(),
		_get_threat_phase_name(),
		_get_score_multiplier(),
		_score,
		_get_map_rule_status_text_v2(),
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


func _build_hud_skill_entries_v2() -> Array[Dictionary]:
	var entries := _build_hud_skill_entries()
	for index in range(entries.size()):
		var entry: Dictionary = entries[index]
		var icon_id := String(entry.get("icon_id", ""))
		var extra_tags := _get_skill_tags(icon_id)
		var tooltip := String(entry.get("tooltip", ""))
		if not extra_tags.is_empty():
			tooltip = "%s\n标签: %s" % [tooltip, " ".join(extra_tags)]
		var route_info := _get_upgrade_route_info(icon_id)
		if not route_info.is_empty():
			tooltip = "%s\n路线: %s" % [tooltip, String(route_info.get("route", ""))]
		entry["tooltip"] = tooltip
		entries[index] = entry
	return entries


func _build_hud_skill_entries() -> Array[Dictionary]:
	if _is_alchemist_character():
		return [
			_make_hud_skill_entry(
				"裂解瓶",
				"flask",
				_flask_level,
				true,
				false,
				maxf(_flask_timer, 0.0),
				_get_flask_cooldown(),
				Color(0.78, 0.96, 0.46),
				"裂解瓶 Lv.%d\n投掷数量 %d\n爆炸半径 %.0f，伤害 %d，冷却 %.1fs" % [_flask_level, _get_flask_count(), _get_flask_radius(), _get_flask_damage(), _get_flask_cooldown()],
				"x%d" % _get_flask_count() if _get_flask_count() > 1 else ""
			),
			_make_hud_skill_entry(
				"毒雾",
				"miasma",
				_miasma_level,
				_miasma_level > 0,
				false,
				maxf(_miasma_timer, 0.0),
				_get_miasma_cooldown(),
				Color(0.62, 0.90, 0.40),
				"毒雾 Lv.%d\n半径 %.0f，持续 %.1fs\n每跳伤害 %d，最多存在 %d 片，冷却 %.1fs" % [_miasma_level, _get_miasma_radius(), _get_miasma_duration(), _get_miasma_damage(), _get_miasma_limit(), _get_miasma_cooldown()],
				"x%d" % _get_miasma_limit()
			),
			_make_hud_skill_entry(
				"碎片喷射",
				"shardburst",
				_shardburst_level,
				_shardburst_level > 0,
				false,
				maxf(_shardburst_timer, 0.0),
				_get_shardburst_cooldown(),
				Color(0.98, 0.94, 0.82),
				"碎片喷射 Lv.%d\n碎片 %d，穿透 %d\n伤害 %d，冷却 %.1fs" % [_shardburst_level, _get_shardburst_count(), _get_shardburst_pierce(), _get_shardburst_damage(), _get_shardburst_cooldown()],
				"x%d" % _get_shardburst_count()
			),
			_make_hud_skill_entry(
				"催化反应",
				"catalyst",
				_catalyst_level,
				_catalyst_level > 0,
				false,
				maxf(_catalyst_timer, 0.0),
				_get_catalyst_cooldown(),
				Color(0.96, 0.86, 0.44),
				"催化反应 Lv.%d\n引爆已铺开的毒雾\n爆裂次数 %d，半径 %.0f，伤害 %d，冷却 %.1fs" % [_catalyst_level, _get_catalyst_burst_count(), _get_catalyst_radius(), _get_catalyst_damage(), _get_catalyst_cooldown()],
				"x%d" % _get_catalyst_burst_count()
			),
		]
	if _is_ranger_character():
		return [
			_make_hud_skill_entry(
				"穿针",
				"needle",
				_needle_level,
				true,
				false,
				maxf(_needle_timer, 0.0),
				_get_needle_cooldown(),
				Color(0.98, 0.86, 0.40),
				"穿针 Lv.%d\n连射数量 %d，穿透 %d\n伤害 %d，冷却 %.2fs" % [_needle_level, _get_needle_count(), _get_needle_pierce(), _get_needle_damage(), _get_needle_cooldown()],
				"x%d" % _get_needle_count() if _get_needle_count() > 1 else ""
			),
			_make_hud_skill_entry(
				"散羽齐射",
				"volley",
				_volley_level,
				_volley_level > 0,
				false,
				maxf(_volley_timer, 0.0),
				_get_volley_cooldown(),
				Color(1.0, 0.94, 0.74),
				"散羽齐射 Lv.%d\n箭矢 %d，单发伤害 %d，冷却 %.1fs" % [_volley_level, _get_volley_count(), _get_volley_damage(), _get_volley_cooldown()],
				"x%d" % _get_volley_count()
			),
			_make_hud_skill_entry(
				"回旋刀",
				"glaive",
				_glaive_level,
				_glaive_level > 0,
				false,
				maxf(_glaive_timer, 0.0),
				_get_glaive_cooldown(),
				Color(0.84, 0.94, 1.0),
				"回旋刀 Lv.%d\n数量 %d，穿透 %d\n伤害 %d，冷却 %.1fs" % [_glaive_level, _get_glaive_count(), _get_glaive_pierce(), _get_glaive_damage(), _get_glaive_cooldown()],
				"x%d" % _get_glaive_count() if _get_glaive_count() > 1 else ""
			),
			_make_hud_skill_entry(
				"穿林迹",
				"trail",
				_trail_level,
				_trail_level > 0,
				false,
				maxf(_trail_timer, 0.0),
				_get_trail_cooldown(),
				Color(0.76, 0.96, 0.72),
				"穿林迹 Lv.%d\n线宽 %.0f，长度 %.0f\n伤害 %d，冷却 %.1fs" % [_trail_level, _get_trail_width(), _get_trail_length(), _get_trail_damage(), _get_trail_cooldown()],
				"扫线"
			),
		]
	if _is_warden_character():
		return [
			_make_hud_skill_entry(
				"谐振脉冲",
				"pulse",
				_pulse_level,
				true,
				false,
				maxf(_pulse_timer, 0.0),
				_get_pulse_cooldown(),
				Color(0.58, 0.96, 0.90),
				"谐振脉冲 Lv.%d\n半径 %.0f，命中上限 %d\n伤害 %d，冷却 %.2fs" % [_pulse_level, _get_pulse_radius(), _get_pulse_hit_count(), _get_pulse_damage(), _get_pulse_cooldown()],
				"x%d" % _get_pulse_hit_count()
			),
			_make_hud_skill_entry(
				"守卫环",
				"ward",
				_ward_level,
				_ward_level > 0,
				true,
				0.0,
				0.0,
				Color(0.84, 0.98, 0.92),
				"守卫环 Lv.%d\n守卫数量 %d\n轨道半径 %.0f，转速 %.1f，碰撞伤害 %d" % [_ward_level, _get_ward_count(), _get_ward_radius(), _get_ward_speed(), _get_ward_damage()],
				"护体"
			),
			_make_hud_skill_entry(
				"信标",
				"beacon",
				_beacon_level,
				_beacon_level > 0,
				false,
				maxf(_beacon_timer, 0.0),
				_get_beacon_cooldown(),
				Color(0.72, 0.92, 1.0),
				"信标 Lv.%d\n半径 %.0f，持续 %.1fs\n每跳伤害 %d，命中上限 %d，冷却 %.1fs" % [_beacon_level, _get_beacon_radius(), _get_beacon_duration(), _get_beacon_damage(), _get_beacon_hit_count(), _get_beacon_cooldown()],
				"x%d" % _get_beacon_hit_count()
			),
			_make_hud_skill_entry(
				"中继线",
				"relay",
				_relay_level,
				_relay_level > 0,
				false,
				maxf(_relay_timer, 0.0),
				_get_relay_cooldown(),
				Color(0.92, 0.98, 1.0),
				"中继线 Lv.%d\n长度 %.0f，线宽 %.0f\n伤害 %d，冷却 %.1fs" % [_relay_level, _get_relay_length(), _get_relay_width(), _get_relay_damage(), _get_relay_cooldown()],
				"布线"
			),
		]
	if _is_blood_hunter_character():
		return [
			_make_hud_skill_entry(
				"血誓箭",
				"oathshot",
				_oathshot_level,
				true,
				false,
				maxf(_oathshot_timer, 0.0),
				_get_oathshot_cooldown(),
				Color(0.96, 0.28, 0.34),
				"血誓箭 Lv.%d\n箭数 %d，穿透 %d\n伤害 %d，当前残血倍率 x%.2f，冷却 %.2fs" % [_oathshot_level, _get_oathshot_count(), _get_oathshot_pierce(), _get_oathshot_damage(), _get_blood_bonus_multiplier(), _get_oathshot_cooldown()],
				"x%d" % _get_oathshot_count() if _get_oathshot_count() > 1 else ""
			),
			_make_hud_skill_entry(
				"猎誓烙印",
				"brand",
				_brand_level,
				_brand_level > 0,
				false,
				maxf(_brand_timer, 0.0),
				_get_brand_cooldown(),
				Color(1.0, 0.70, 0.74),
				"猎誓烙印 Lv.%d\n目标 %d，直伤 %d\n标记击杀回血 %d，并在周围炸裂一次，冷却 %.1fs" % [_brand_level, _get_brand_target_count(), _get_brand_damage(), _get_brand_heal(), _get_brand_cooldown()],
				"x%d" % _get_brand_target_count()
			),
			_make_hud_skill_entry(
				"血潮沼",
				"bloodtrail",
				_bloodtrail_level,
				_bloodtrail_level > 0,
				false,
				maxf(_bloodtrail_timer, 0.0),
				_get_bloodtrail_cooldown(),
				Color(0.92, 0.40, 0.46),
				"血潮沼 Lv.%d\n半径 %.0f，持续 %.1fs\n每跳伤害 %d，最多存在 %d 片，冷却 %.1fs" % [_bloodtrail_level, _get_bloodtrail_radius(), _get_bloodtrail_duration(), _get_bloodtrail_damage(), _get_bloodtrail_limit(), _get_bloodtrail_cooldown()],
				"x%d" % _get_bloodtrail_limit()
			),
			_make_hud_skill_entry(
				"誓刃穿心",
				"verdict",
				_verdict_level,
				_verdict_level > 0,
				false,
				maxf(_verdict_timer, 0.0),
				_get_verdict_cooldown(),
				Color(1.0, 0.84, 0.86),
				"誓刃穿心 Lv.%d\n距离 %.0f，线宽 %.0f\n伤害 %d，终点会引爆附近烙印目标，冷却 %.1fs" % [_verdict_level, _get_verdict_range(), _get_verdict_width(), _get_verdict_damage(), _get_verdict_cooldown()],
				"处决"
			),
		]
	if _is_grave_caller_character():
		return [
			_make_hud_skill_entry(
				"挽歌",
				"dirge",
				_dirge_level,
				true,
				false,
				maxf(_dirge_timer, 0.0),
				_get_dirge_cooldown(),
				Color(0.58, 0.88, 0.78),
				"挽歌 Lv.%d\n齐射数 %d，伤害 %d\n可用尸核上限 %d，冷却 %.2fs" % [_dirge_level, _get_dirge_count(), _get_dirge_damage(), _get_grave_token_limit(), _get_dirge_cooldown()],
				"x%d" % _get_dirge_count() if _get_dirge_count() > 1 else ""
			),
			_make_hud_skill_entry(
				"起灵",
				"wake",
				_wake_level,
				_wake_level > 0,
				false,
				maxf(_wake_timer, 0.0),
				_get_wake_cooldown(),
				Color(0.84, 0.98, 0.92),
				"起灵 Lv.%d\n消耗尸核 %d，爆裂伤害 %d\n会从尸核位置续出下一发挽歌，冷却 %.1fs" % [_wake_level, _get_wake_consume_count(), _get_wake_damage(), _get_wake_cooldown()],
				"核%d" % _get_wake_consume_count()
			),
			_make_hud_skill_entry(
				"丧钟",
				"toll",
				_toll_level,
				_toll_level > 0,
				false,
				maxf(_toll_timer, 0.0),
				_get_toll_cooldown(),
				Color(0.68, 0.96, 0.88),
				"丧钟 Lv.%d\n敲响尸核 %d 个\n半径 %.0f，伤害 %d，冷却 %.1fs" % [_toll_level, _get_toll_pulse_count(), _get_toll_radius(), _get_toll_damage(), _get_toll_cooldown()],
				"x%d" % _get_toll_pulse_count()
			),
			_make_hud_skill_entry(
				"尸钟合唱",
				"choir",
				_choir_level,
				_choir_level > 0,
				false,
				maxf(_choir_timer, 0.0),
				_get_choir_cooldown(),
				Color(0.92, 1.0, 0.96),
				"尸钟合唱 Lv.%d\n消耗尸核 %d，每核射出 %d 发\n单发伤害 %d，冷却 %.1fs" % [_choir_level, _get_choir_consume_count(), _get_choir_projectile_count(), _get_choir_damage(), _get_choir_cooldown()],
				"唱%d" % _get_choir_projectile_count()
			),
		]
	if _is_illusionist_character():
		return [
			_make_hud_skill_entry(
				"镜折弹",
				"mirrorbolt",
				_mirrorbolt_level,
				true,
				false,
				maxf(_mirrorbolt_timer, 0.0),
				_get_mirrorbolt_cooldown(),
				Color(0.86, 0.72, 1.0),
				"镜折弹 Lv.%d\n单发伤害 %d\n最多借用 %d 个残像镜位同时开火，冷却 %.2fs" % [_mirrorbolt_level, _get_mirrorbolt_damage(), _get_mirrorbolt_decoy_count(), _get_mirrorbolt_cooldown()],
				"镜%d" % _get_mirrorbolt_decoy_count()
			),
			_make_hud_skill_entry(
				"残像",
				"afterimage",
				_afterimage_level,
				_afterimage_level > 0,
				false,
				maxf(_afterimage_timer, 0.0),
				_get_afterimage_cooldown(),
				Color(0.96, 0.88, 1.0),
				"残像 Lv.%d\n最多存在 %d 个，持续 %.1fs\n当前场上残像 %d，冷却 %.1fs" % [_afterimage_level, _get_afterimage_limit(), _get_afterimage_duration(), _illusion_decoys.size(), _get_afterimage_cooldown()],
				"x%d" % _get_afterimage_limit()
			),
			_make_hud_skill_entry(
				"换幕步",
				"switchstep",
				_switchstep_level,
				_switchstep_level > 0,
				false,
				maxf(_switchstep_timer, 0.0),
				_get_switchstep_cooldown(),
				Color(0.80, 0.72, 0.98),
				"换幕步 Lv.%d\n换位爆炸半径 %.0f\n两端各造成 %d 伤害，冷却 %.1fs" % [_switchstep_level, _get_switchstep_radius(), _get_switchstep_damage(), _get_switchstep_cooldown()],
				"换位"
			),
			_make_hud_skill_entry(
				"棱镜舞台",
				"prismdance",
				_prismdance_level,
				_prismdance_level > 0,
				false,
				maxf(_prismdance_timer, 0.0),
				_get_prismdance_cooldown(),
				Color(0.98, 0.92, 1.0),
				"棱镜舞台 Lv.%d\n镜位来源 %d，每源发射 %d 发\n单发伤害 %d，冷却 %.1fs" % [_prismdance_level, _get_prismdance_origin_count(), _get_prismdance_projectile_count(), _get_prismdance_damage(), _get_prismdance_cooldown()],
				"舞台"
			),
		]
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


func _get_skill_tags(icon_id: String) -> Array[String]:
	match icon_id:
		"flask":
			return ["[投掷]", "[爆破]"]
		"miasma":
			return ["[毒雾]", "[控场]"]
		"shardburst":
			return ["[扇形]", "[穿透]"]
		"catalyst":
			return ["[引爆]", "[连锁]"]
		"needle":
			return ["[速射]", "[远程]"]
		"volley":
			return ["[散射]", "[风筝]"]
		"glaive":
			return ["[回旋]", "[追击]"]
		"trail":
			return ["[扫线]", "[走位]"]
		"pulse":
			return ["[脉冲]", "[近身]"]
		"ward":
			return ["[护体]", "[守点]"]
		"beacon":
			return ["[区域]", "[驻场]"]
		"relay":
			return ["[连线]", "[几何]"]
		"oathshot":
			return ["[血契]", "[追猎]"]
		"brand":
			return ["[烙印]", "[收割]"]
		"bloodtrail":
			return ["[区域]", "[换血]"]
		"verdict":
			return ["[斩线]", "[处决]"]
		"dirge":
			return ["[尸核]", "[远程]"]
		"wake":
			return ["[起灵]", "[回收]"]
		"toll":
			return ["[丧钟]", "[控场]"]
		"choir":
			return ["[合唱]", "[齐射]"]
		"mirrorbolt":
			return ["[镜射]", "[远程]"]
		"afterimage":
			return ["[残像]", "[布点]"]
		"switchstep":
			return ["[换位]", "[戏法]"]
		"prismdance":
			return ["[舞台]", "[多点]"]
		"chain":
			return ["[闪电]", "[连锁]"]
		"detonate":
			return ["[爆裂]", "[击杀]"]
		"storm_orb":
			return ["[领域]", "[召唤]"]
		"ascension":
			return ["[进化]", "[终局]"]
		"slash":
			return ["[火焰]", "[近战]"]
		"blade_ring":
			return ["[护体]", "[旋刀]"]
		"mooncut":
			return ["[剑气]", "[穿透]"]
		"step_slash":
			return ["[爆发]", "[位移]"]
		"orbit":
			return ["[召唤]", "[轨道]"]
		"nova":
			return ["[奥术]", "[爆发]"]
		"storm":
			return ["[雷暴]", "[锁定]"]
		_:
			return ["[奥术]", "[远程]"]


func _get_build_info_lines() -> Array[String]:
	var lines: Array[String] = []
	var snapshot := _get_build_focus_snapshot()
	var primary: Dictionary = snapshot.get("primary", {})
	var secondary: Dictionary = snapshot.get("secondary", {})
	var primary_score := int(primary.get("score", 0))
	var contract_summary := _get_contract_summary()
	if primary.is_empty() or primary_score <= 0:
		var paths := _get_build_path_definitions()
		if paths.size() >= 2:
			lines.append("待定流派: %s / %s" % [String(paths[0].get("name", "路线A")), String(paths[1].get("name", "路线B"))])
			lines.append("开局建议: 先拿路线专属核心，再补共享组件。")
		else:
			lines.append("构筑路线: 未定型")
		if not contract_summary.is_empty():
			lines.append("战场契约: %s" % contract_summary)
		return lines

	if not _is_build_focus_locked(snapshot):
		var leaning_line := "构筑倾向: %s" % String(primary.get("name", "当前路线"))
		if not secondary.is_empty():
			leaning_line += "   可转: %s" % String(secondary.get("name", "备选路线"))
		lines.append(leaning_line)
		var primary_recommendations := _get_build_path_recommendations(primary, 2)
		if not secondary.is_empty():
			var secondary_recommendations := _get_build_path_recommendations(secondary, 2)
			lines.append(
				"定型建议: %s -> %s   或   %s -> %s"
				% [
					String(primary.get("name", "当前路线")),
					" / ".join(primary_recommendations) if not primary_recommendations.is_empty() else String(primary.get("focus", "补足核心件")),
					String(secondary.get("name", "备选路线")),
					" / ".join(secondary_recommendations) if not secondary_recommendations.is_empty() else String(secondary.get("focus", "补足核心件")),
				]
			)
		else:
			lines.append("定型建议: %s" % (" / ".join(primary_recommendations) if not primary_recommendations.is_empty() else String(primary.get("focus", "补足核心件"))))
		if not contract_summary.is_empty():
			lines.append("战场契约: %s" % contract_summary)
		return lines

	var focus_line := "主路线: %s" % String(primary.get("name", "当前路线"))
	if not secondary.is_empty():
		focus_line += "   副路线: %s" % String(secondary.get("name", "副路线"))
	var endgame_summary := _get_endgame_evolution_summary()
	if not endgame_summary.is_empty():
		focus_line += "   终局: %s" % endgame_summary
	lines.append(focus_line)

	var primary_recommendations := _get_build_path_recommendations(primary, 2)
	var next_line := "下一步: %s" % (" / ".join(primary_recommendations) if not primary_recommendations.is_empty() else "继续补满核心等级，准备进入终局分叉。")
	if not secondary.is_empty():
		var secondary_recommendations := _get_build_path_recommendations(secondary, 2)
		if not secondary_recommendations.is_empty():
			next_line += "   转向口: %s" % " / ".join(secondary_recommendations)
	lines.append(next_line)
	if not contract_summary.is_empty():
		lines.append("战场契约: %s" % contract_summary)
	return lines


func _get_endgame_evolution_summary() -> String:
	if _selected_endgame_branches.is_empty():
		return ""
	var labels: Array[String] = []
	for route_id_variant in _selected_endgame_branches.keys():
		var route_id := String(route_id_variant)
		var key := String(_selected_endgame_branches.get(route_id_variant, ""))
		var route_path := _get_build_path_definition_by_id(route_id)
		var evolution := _get_endgame_evolution_definition(key)
		if evolution.is_empty():
			continue
		labels.append("%s-%s" % [String(route_path.get("name", "路线")), String(evolution.get("title", "终局"))])
	return " / ".join(labels)


func _get_build_tag_summary() -> String:
	var tags: Array[String] = []
	if _is_alchemist_character():
		tags = ["[毒剂]", "[铺场]", "[反应]"]
		if _miasma_level > 0:
			tags.append("[毒雾]")
		if _shardburst_level > 0:
			tags.append("[碎裂]")
		if _catalyst_level > 0:
			tags.append("[引爆]")
	elif _is_ranger_character():
		tags = ["[游射]", "[远程]", "[机动]"]
		if _volley_level > 0:
			tags.append("[散射]")
		if _glaive_level > 0:
			tags.append("[回旋]")
		if _trail_level > 0:
			tags.append("[扫线]")
	elif _is_warden_character():
		tags = ["[守点]", "[护体]", "[布场]"]
		if _ward_level > 0:
			tags.append("[守卫]")
		if _beacon_level > 0:
			tags.append("[信标]")
		if _relay_level > 0:
			tags.append("[连线]")
	elif _is_blood_hunter_character():
		tags = ["[血契]", "[收割]", "[换血]"]
		if _brand_level > 0:
			tags.append("[烙印]")
		if _bloodtrail_level > 0:
			tags.append("[血潮]")
		if _verdict_level > 0:
			tags.append("[处决]")
	elif _is_grave_caller_character():
		tags = ["[尸核]", "[回收]", "[调度]"]
		if _wake_level > 0:
			tags.append("[起灵]")
		if _toll_level > 0:
			tags.append("[丧钟]")
		if _choir_level > 0:
			tags.append("[合唱]")
	elif _is_illusionist_character():
		tags = ["[残像]", "[换位]", "[镜射]"]
		if _afterimage_level > 0:
			tags.append("[舞台]")
		if _switchstep_level > 0:
			tags.append("[戏法]")
		if _prismdance_level > 0:
			tags.append("[多点]")
	elif _is_thunder_character():
		tags = ["[闪电]", "[连锁]"]
		if _detonate_level > 0:
			tags.append("[爆裂]")
		if _storm_orb_level > 0:
			tags.append("[领域]")
		if _ascension_level > 0 or _supercell_mutation:
			tags.append("[终局]")
	elif _is_blade_character():
		tags = ["[火焰]", "[近战]", "[刀气]"]
		if _flame_split_mutation:
			tags.append("[分裂]")
		if _execution_mutation:
			tags.append("[处决]")
		if _rend_mutation:
			tags.append("[剑气]")
	else:
		tags = ["[奥术]", "[远程]"]
		if _orbit_level > 0:
			tags.append("[召唤]")
		if _nova_level > 0:
			tags.append("[爆发]")
		if _storm_level > 0:
			tags.append("[控场]")
		if _nova_orbit_mutation or _storm_singularity_mutation:
			tags.append("[变异]")
	if not _selected_endgame_branches.is_empty():
		tags.append("[终局分叉]")
	return "构筑标签: %s" % " ".join(tags)


func _get_threat_phase_name() -> String:
	return THREAT_PHASE_LABELS[min(_threat_phase, THREAT_PHASE_LABELS.size() - 1)]


func _get_map_rule_status_text() -> String:
	match _selected_map_id:
		"sky_ruins":
			if _ruins_altar_zone != null and is_instance_valid(_ruins_altar_zone) and _ruins_altar_destination_zone != null and is_instance_valid(_ruins_altar_destination_zone):
				return "护送 %.0f%%" % (_ruins_altar_progress * 100.0)
			if _ruins_altar_buff_timer > 0.0:
				return "护送加护 %.0fs" % _ruins_altar_buff_timer
			return "信标待发"
		"ember_forge":
			if _forge_core_zone != null and is_instance_valid(_forge_core_zone) and _forge_cut_target_zone != null and is_instance_valid(_forge_cut_target_zone):
				return "断路 %d/%d" % [_forge_cut_crossings, maxi(_forge_cut_required_crossings, 1)]
			if _forge_overdrive_timer > 0.0:
				return "喷线熄火 %.0fs" % _forge_overdrive_timer
			return "热路待切断" if _map_rule_active else "熔炉静默"
		"void_marsh":
			if _void_spore_zone != null and is_instance_valid(_void_spore_zone):
				return "诱爆 %.0f%%" % (_void_spore_progress * 100.0)
			if _void_spore_blessing_timer > 0.0:
				return "孢爆余势 %.0fs" % _void_spore_blessing_timer
			return "沼泽池 %d" % _void_pools.size() if _map_rule_active else "沼泽未沸腾"
		"bridge_train":
			if not _train_car_zones.is_empty():
				if _train_break_index >= 0 and _train_break_index < _train_car_zones.size():
					return "跨车 %d/%d 断节:%d" % [_train_car_active_index, _train_car_zones.size(), _train_break_index + 1]
				return "跨车 %d/%d" % [_train_car_active_index, _train_car_zones.size()]
			if _train_rush_timer > 0.0:
				return "列车稳速 %.0fs" % _train_rush_timer
			return "车节待现身"
		"black_fog_hunt":
			if _fog_fake_brazier_zone != null and is_instance_valid(_fog_fake_brazier_zone):
				return "伪灯 %.0f%%" % (_fog_fake_brazier_progress * 100.0)
			if _fog_brazier_zone != null and is_instance_valid(_fog_brazier_zone):
				return "点灯 %.0f%%" % (_fog_brazier_progress * 100.0)
			if _fog_light_timer > 0.0:
				return "光域 %.0fs" % _fog_light_timer
			return "黑雾逼近"
		"airship_breach":
			if _airship_breach_zone != null and is_instance_valid(_airship_breach_zone):
				if _airship_breach_drift_direction != Vector2.ZERO:
					return "逆风封舱 %.0f%%" % (_airship_breach_progress * 100.0)
				return "封舱 %.0f%%" % (_airship_breach_progress * 100.0)
			if _airship_tailwind_timer > 0.0:
				return "顺风炮列 %.0fs" % _airship_tailwind_timer
			return "裂口待封堵"
		_:
			return "规则平稳"


func _get_map_rule_status_text_v2() -> String:
	var map_status := ""
	match _selected_map_id:
		"prism_archive":
			if _prism_focus_zone != null and is_instance_valid(_prism_focus_zone) and _prism_link_target_zone != null and is_instance_valid(_prism_link_target_zone):
				map_status = "连线 %.0f%%" % (_prism_focus_progress * 100.0)
			elif _prism_overcharge_timer > 0.0:
				map_status = "棱镜过载 %.0fs" % _prism_overcharge_timer
			else:
				map_status = "折光链待连通"
		"clockwork_garden":
			if _clock_node_zone != null and is_instance_valid(_clock_node_zone):
				map_status = "抢占 %.0f%%" % (_clock_node_progress * 100.0)
			elif _clock_overdrive_timer > 0.0:
				map_status = "齿轮超频 %.0fs" % _clock_overdrive_timer
			else:
				map_status = "节点待抢占"
		_:
			map_status = _get_map_rule_status_text()

	if _contract_zone != null and is_instance_valid(_contract_zone):
		return "%s   契约 %.0f%%" % [map_status, _contract_zone_progress * 100.0]
	if _contract_spawn_index < CONTRACT_SPAWN_TIMES.size() and not _boss_spawned and not _boss_warning_shown:
		var remain := maxf(0.0, float(CONTRACT_SPAWN_TIMES[_contract_spawn_index]) - _run_time)
		if remain <= 60.0:
			return "%s   契约点 %.0fs" % [map_status, remain]
	if not _active_contract_ids.is_empty():
		return "%s   契约x%d" % [map_status, _active_contract_ids.size()]
	return map_status


func _update_hud() -> void:
	_update_character_hud_v2()
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
	var boss_phase_suffix := ""
	if _boss_enemy != null and is_instance_valid(_boss_enemy):
		var phase_index := _boss_enemy.get_boss_phase_index()
		if phase_index > 0:
			boss_phase_suffix = " P%d" % (phase_index + 1)
	if _is_endless_mode():
		if _boss_spawned and _boss_enemy != null and is_instance_valid(_boss_enemy):
			return "%s   无尽首领：%s%s" % [_get_current_map_name(), _get_current_boss_name(), boss_phase_suffix]
		var remaining_endless := maxf(0.0, _get_boss_spawn_time() - _run_time)
		return "%s   无尽模式   下次首领 %s" % [_get_current_map_name(), _format_time(remaining_endless)]
	if _boss_defeated:
		return "%s   %s   已肃清" % [_get_current_map_name(), _get_current_run_mode_name()]
	if _boss_spawned and _boss_enemy != null and is_instance_valid(_boss_enemy):
		return "%s   %s   首领：%s%s" % [_get_current_map_name(), _get_current_run_mode_name(), _get_current_boss_name(), boss_phase_suffix]
	var remaining := maxf(0.0, _get_boss_spawn_time() - _run_time)
	return "%s   %s   首领倒计时 %s" % [_get_current_map_name(), _get_current_run_mode_name(), _format_time(remaining)]


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
	var mode_label := _get_current_run_mode_name()
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
	elif _is_alchemist_character():
		base_speed = 238.0
	elif _is_ranger_character():
		base_speed = 258.0
	elif _is_warden_character():
		base_speed = 236.0
	elif _is_blood_hunter_character():
		base_speed = 252.0
	elif _is_grave_caller_character():
		base_speed = 232.0
	elif _is_illusionist_character():
		base_speed = 262.0
	if _clock_overdrive_timer > 0.0:
		base_speed += 26.0
	var final_speed := base_speed + float(_stride_level) * 22.0
	final_speed *= 1.0 + _contract_speed_bonus
	return final_speed


func _get_player_max_health() -> int:
	var base_health := 8
	if _is_blade_character():
		base_health = 10
	elif _is_thunder_character():
		base_health = 9
	elif _is_alchemist_character():
		base_health = 8
	elif _is_ranger_character():
		base_health = 7
	elif _is_warden_character():
		base_health = 11
	elif _is_blood_hunter_character():
		base_health = 9
	elif _is_grave_caller_character():
		base_health = 9
	elif _is_illusionist_character():
		base_health = 7
	return max(1, base_health + _vitality_level * 2 - _contract_max_health_penalty)


func _get_player_pickup_radius() -> float:
	var base_radius := 140.0
	if _is_blade_character():
		base_radius = 132.0
	elif _is_thunder_character():
		base_radius = 146.0
	elif _is_alchemist_character():
		base_radius = 150.0
	elif _is_ranger_character():
		base_radius = 144.0
	elif _is_warden_character():
		base_radius = 136.0
	elif _is_blood_hunter_character():
		base_radius = 138.0
	elif _is_grave_caller_character():
		base_radius = 156.0
	elif _is_illusionist_character():
		base_radius = 146.0
	return base_radius + float(_magnet_level) * 50.0 + _contract_pickup_bonus


func _get_spell_power_multiplier() -> float:
	var multiplier := 1.0 + float(_mastery_level) * 0.16
	if _ruins_altar_buff_timer > 0.0:
		multiplier += 0.12
	if _forge_overdrive_timer > 0.0:
		multiplier += 0.18
	if _void_spore_blessing_timer > 0.0:
		multiplier += 0.08
	if _prism_overcharge_timer > 0.0:
		multiplier += 0.12
	if _clock_overdrive_timer > 0.0:
		multiplier += 0.08
	if _airship_tailwind_timer > 0.0:
		multiplier += 0.16
	multiplier += _contract_spell_power_bonus
	return multiplier


func _get_xp_gain_multiplier() -> float:
	var multiplier := 1.0 + float(_mastery_level) * 0.10
	if _ruins_altar_buff_timer > 0.0:
		multiplier += 0.08
	if _void_spore_blessing_timer > 0.0:
		multiplier += 0.14
	if _prism_overcharge_timer > 0.0:
		multiplier += 0.08
	if _fog_light_timer > 0.0:
		multiplier += 0.14
	multiplier += _contract_xp_bonus
	return multiplier


func _get_cooldown_multiplier() -> float:
	var multiplier := 1.0 - float(_focus_level) * 0.08
	if _ruins_altar_buff_timer > 0.0:
		multiplier *= 0.88
	if _forge_overdrive_timer > 0.0:
		multiplier *= 0.90
	if _prism_overcharge_timer > 0.0:
		multiplier *= 0.92
	if _clock_overdrive_timer > 0.0:
		multiplier *= 0.90
	if _train_rush_timer > 0.0:
		multiplier *= 0.88
	if _airship_tailwind_timer > 0.0:
		multiplier *= 0.88
	multiplier *= _contract_cooldown_scale
	return maxf(0.50, multiplier)


func _get_extra_orbit_count_bonus() -> int:
	if _has_endgame_evolution("evo_caster_orbit_overload"):
		return 2
	if _has_endgame_evolution("evo_blade_ring_dominion"):
		return 2
	return 0


func _get_endgame_damage_multiplier(skill_group: String) -> float:
	var multiplier := 1.0
	match skill_group:
		"slash_wave":
			if _has_endgame_evolution("evo_blade_crimson_tide"):
				multiplier *= 1.28
			if _has_endgame_evolution("evo_blade_pyre_forks"):
				multiplier *= 1.10
		"blade_ring":
			if _has_endgame_evolution("evo_blade_ring_dominion"):
				multiplier *= 1.60
		"execution":
			if _has_endgame_evolution("evo_blade_execution_storm"):
				multiplier *= 1.34
		"nova":
			if _has_endgame_evolution("evo_caster_supernova_lattice"):
				multiplier *= 1.28
		"orbit":
			if _has_endgame_evolution("evo_caster_orbit_overload"):
				multiplier *= 1.55
		"storm":
			if _has_endgame_evolution("evo_caster_tempest_network"):
				multiplier *= 1.12
		_:
			pass
	return multiplier


func _get_extra_storm_targets_bonus() -> int:
	if _has_endgame_evolution("evo_caster_tempest_network"):
		return 2
	return 0


func _get_extra_nova_projectiles_bonus() -> int:
	if _has_endgame_evolution("evo_caster_supernova_lattice"):
		return 8
	return 0


func _get_extra_chain_targets_bonus() -> int:
	if _has_endgame_evolution("evo_thunder_arc_net"):
		return 1
	return 0


func _get_bolt_count() -> int:
	return 1 + int(_bolt_level / 2)


func _get_bolt_damage() -> int:
	return int(round((16.0 + float(_bolt_level - 1) * 5.0) * _get_spell_power_multiplier()))


func _get_bolt_pierce() -> int:
	return 1 + int((_bolt_level - 1) / 3)


func _get_bolt_cooldown() -> float:
	return maxf(0.18, (0.82 - float(_bolt_level - 1) * 0.06) * _get_cooldown_multiplier())


func _get_orbit_count() -> int:
	return _orbit_level + _get_extra_orbit_count_bonus()


func _get_orbit_damage() -> int:
	return int(round((10.0 + float(max(_orbit_level - 1, 0)) * 4.0) * _get_spell_power_multiplier() * _get_endgame_damage_multiplier("orbit")))


func _get_orbit_radius() -> float:
	var radius := 88.0 + float(max(_orbit_level - 1, 0)) * 12.0
	if _has_endgame_evolution("evo_blade_ring_dominion"):
		radius += 24.0
	if _has_endgame_evolution("evo_caster_orbit_overload"):
		radius += 18.0
	return radius


func _get_orbit_speed() -> float:
	var speed := 2.0 + float(_orbit_level) * 0.22
	if _has_endgame_evolution("evo_caster_orbit_overload"):
		speed *= 1.22
	return speed


func _get_nova_projectile_count() -> int:
	return 8 + _nova_level * 2 + _get_extra_nova_projectiles_bonus()


func _get_nova_damage() -> int:
	return int(round((20.0 + float(max(_nova_level - 1, 0)) * 7.0) * _get_spell_power_multiplier() * _get_endgame_damage_multiplier("nova")))


func _get_nova_cooldown() -> float:
	var cooldown := (5.6 - float(max(_nova_level - 1, 0)) * 0.45) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_caster_supernova_lattice"):
		cooldown *= 0.76
	return maxf(2.0, cooldown)


func _get_storm_target_count() -> int:
	return 2 + _storm_level + _get_extra_storm_targets_bonus()


func _get_storm_damage() -> int:
	return int(round((28.0 + float(max(_storm_level - 1, 0)) * 9.0) * _get_spell_power_multiplier() * _get_endgame_damage_multiplier("storm")))


func _get_storm_cooldown() -> float:
	return maxf(2.8, (6.0 - float(max(_storm_level - 1, 0)) * 0.48) * _get_cooldown_multiplier())


func _get_lightning_power_multiplier() -> float:
	return _get_spell_power_multiplier() * (3.0 if _ascension_level > 0 else 1.0)


func _get_chain_target_count() -> int:
	return 5 + max(_chain_level - 1, 0) + _get_ascension_chain_bonus() + _get_extra_chain_targets_bonus()


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
	var chance := 0.20 * float(_detonate_level)
	if _has_endgame_evolution("evo_thunder_blast_relay"):
		chance += 0.15
	return minf(chance, 0.90)


func _get_detonate_damage() -> int:
	return int(round((18.0 + float(max(_detonate_level - 1, 0)) * 12.0) * _get_lightning_power_multiplier()))


func _get_detonate_radius() -> float:
	var radius := 72.0 + float(max(_detonate_level - 1, 0)) * 18.0
	if _has_endgame_evolution("evo_thunder_blast_relay"):
		radius *= 1.28
	return radius


func _get_storm_orb_damage() -> int:
	return int(round((16.0 + float(max(_storm_orb_level - 1, 0)) * 8.0) * _get_lightning_power_multiplier()))


func _get_storm_orb_radius() -> float:
	return 132.0 + float(max(_storm_orb_level - 1, 0)) * 18.0


func _get_storm_orb_duration() -> float:
	return 8.0 if _has_endgame_evolution("evo_thunder_orb_overclock") else 5.0


func _get_storm_orb_cooldown() -> float:
	var cooldown := (7.2 - float(max(_storm_orb_level - 1, 0)) * 0.42) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_thunder_orb_overclock"):
		cooldown *= 0.82
	return maxf(2.6, cooldown)


func _get_storm_orb_pulse_interval() -> float:
	var interval := 0.72 - float(max(_storm_orb_level - 1, 0)) * 0.08
	if _has_endgame_evolution("evo_thunder_orb_overclock"):
		interval *= 0.68
	return maxf(0.22, interval)


func _get_storm_orb_target_count() -> int:
	var bonus := 0
	if _has_endgame_evolution("evo_thunder_orb_overclock"):
		bonus = 3
	return min(_get_chain_target_count(), 2 + _storm_orb_level * 2 + int(_ascension_level > 0) + bonus)


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
	return int(round((14.0 + float(max(_slash_level - 1, 0)) * 4.0) * _get_spell_power_multiplier() * _get_endgame_damage_multiplier("slash_wave")))


func _get_slash_wave_range() -> float:
	var range_value := 132.0 + float(max(_slash_level - 1, 0)) * 28.0
	if _has_endgame_evolution("evo_blade_crimson_tide"):
		range_value *= 1.48
	return range_value


func _get_slash_wave_radius() -> float:
	var radius := 14.0 + float(max(_slash_level - 1, 0)) * 1.8
	if _has_endgame_evolution("evo_blade_crimson_tide"):
		radius *= 1.24
	return radius


func _get_slash_wave_speed() -> float:
	var speed := 460.0 + float(max(_slash_level - 1, 0)) * 8.0
	if _has_endgame_evolution("evo_blade_crimson_tide"):
		speed *= 1.10
	return speed


func _get_slash_arc_span() -> float:
	return PI


func _get_slash_cooldown() -> float:
	return maxf(0.22, (0.76 - float(max(_slash_level - 1, 0)) * 0.05) * _get_cooldown_multiplier())


func _get_slash_knockback() -> float:
	return 220.0 + float(max(_slash_level - 1, 0)) * 14.0


func _get_blade_ring_count() -> int:
	return _blade_ring_level + _get_extra_orbit_count_bonus()


func _get_blade_ring_damage() -> int:
	return int(round((12.0 + float(max(_blade_ring_level - 1, 0)) * 5.0) * _get_spell_power_multiplier() * _get_endgame_damage_multiplier("blade_ring")))


func _get_blade_ring_radius() -> float:
	var radius := 74.0 + float(max(_blade_ring_level - 1, 0)) * 14.0
	if _has_endgame_evolution("evo_blade_ring_dominion"):
		radius += 28.0
	return radius


func _get_blade_ring_speed() -> float:
	var speed := 2.6 + float(_blade_ring_level) * 0.34
	if _has_endgame_evolution("evo_blade_ring_dominion"):
		speed *= 1.18
	return speed


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
	var cooldown := (6.4 - float(max(_step_slash_level - 1, 0)) * 0.50) * _get_cooldown_multiplier()
	if _has_endgame_evolution("evo_blade_execution_storm"):
		cooldown *= 0.72
	return maxf(2.2, cooldown)


func _get_step_slash_knockback() -> float:
	return 320.0 + float(max(_step_slash_level - 1, 0)) * 18.0


func _get_execution_radius() -> float:
	var radius := 92.0
	if _has_endgame_evolution("evo_blade_execution_storm"):
		radius *= 1.34
	return radius


func _get_execution_damage() -> int:
	return max(1, int(round(float(_get_step_slash_damage()) * 0.66 * _get_endgame_damage_multiplier("execution"))))


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


func _get_flask_count() -> int:
	return 1 + int(max(_flask_level - 1, 0) / 3)


func _get_flask_damage() -> int:
	return int(round((20.0 + float(max(_flask_level - 1, 0)) * 6.0) * _get_spell_power_multiplier()))


func _get_flask_radius() -> float:
	return 60.0 + float(max(_flask_level - 1, 0)) * 7.0


func _get_flask_warning_duration() -> float:
	return maxf(0.24, 0.50 - float(max(_flask_level - 1, 0)) * 0.02)


func _get_flask_cooldown() -> float:
	return maxf(0.50, (1.20 - float(max(_flask_level - 1, 0)) * 0.08) * _get_cooldown_multiplier())


func _get_miasma_damage() -> int:
	return int(round((6.0 + float(max(_miasma_level - 1, 0)) * 2.0) * _get_spell_power_multiplier()))


func _get_miasma_radius() -> float:
	return 88.0 + float(max(_miasma_level - 1, 0)) * 12.0


func _get_miasma_duration() -> float:
	return 4.6 + float(max(_miasma_level - 1, 0)) * 0.6


func _get_miasma_pulse_interval() -> float:
	return maxf(0.32, 0.72 - float(max(_miasma_level - 1, 0)) * 0.06)


func _get_miasma_cooldown() -> float:
	return maxf(3.2, (7.2 - float(max(_miasma_level - 1, 0)) * 0.45) * _get_cooldown_multiplier())


func _get_miasma_limit() -> int:
	return 1 + int(_miasma_level / 2)


func _get_miasma_cast_range() -> float:
	return 420.0 + float(max(_miasma_level - 1, 0)) * 20.0


func _get_shardburst_count() -> int:
	return 4 + _shardburst_level


func _get_shardburst_damage() -> int:
	return int(round((12.0 + float(max(_shardburst_level - 1, 0)) * 4.0) * _get_spell_power_multiplier()))


func _get_shardburst_pierce() -> int:
	return 1 + int(max(_shardburst_level - 1, 0) / 2)


func _get_shardburst_cooldown() -> float:
	return maxf(1.8, (4.8 - float(max(_shardburst_level - 1, 0)) * 0.36) * _get_cooldown_multiplier())


func _get_catalyst_burst_count() -> int:
	return 1 + int(_catalyst_level / 2)


func _get_catalyst_damage() -> int:
	return int(round((22.0 + float(max(_catalyst_level - 1, 0)) * 8.0) * _get_spell_power_multiplier()))


func _get_catalyst_radius() -> float:
	return 80.0 + float(max(_catalyst_level - 1, 0)) * 12.0


func _get_catalyst_cooldown() -> float:
	return maxf(3.0, (7.0 - float(max(_catalyst_level - 1, 0)) * 0.42) * _get_cooldown_multiplier())


func _get_needle_count() -> int:
	return 1 + int(_needle_level / 3)


func _get_needle_damage() -> int:
	return int(round((14.0 + float(max(_needle_level - 1, 0)) * 4.0) * _get_spell_power_multiplier()))


func _get_needle_pierce() -> int:
	return 1 + int(max(_needle_level - 1, 0) / 2)


func _get_needle_cooldown() -> float:
	return maxf(0.20, (0.54 - float(max(_needle_level - 1, 0)) * 0.04) * _get_cooldown_multiplier())


func _get_volley_count() -> int:
	return 4 + _volley_level


func _get_volley_damage() -> int:
	return int(round((10.0 + float(max(_volley_level - 1, 0)) * 3.0) * _get_spell_power_multiplier()))


func _get_volley_cooldown() -> float:
	return maxf(1.8, (4.6 - float(max(_volley_level - 1, 0)) * 0.32) * _get_cooldown_multiplier())


func _get_glaive_count() -> int:
	if _glaive_level <= 0:
		return 0
	return 1 + int(max(_glaive_level - 1, 0) / 2)


func _get_glaive_damage() -> int:
	return int(round((24.0 + float(max(_glaive_level - 1, 0)) * 7.0) * _get_spell_power_multiplier()))


func _get_glaive_pierce() -> int:
	return 2 + int(max(_glaive_level - 1, 0) / 2)


func _get_glaive_cooldown() -> float:
	return maxf(2.4, (5.8 - float(max(_glaive_level - 1, 0)) * 0.38) * _get_cooldown_multiplier())


func _get_trail_damage() -> int:
	return int(round((20.0 + float(max(_trail_level - 1, 0)) * 6.0) * _get_spell_power_multiplier()))


func _get_trail_width() -> float:
	return 24.0 + float(max(_trail_level - 1, 0)) * 4.0


func _get_trail_length() -> float:
	return 260.0 + float(max(_trail_level - 1, 0)) * 36.0


func _get_trail_cooldown() -> float:
	return maxf(2.6, (6.2 - float(max(_trail_level - 1, 0)) * 0.44) * _get_cooldown_multiplier())


func _get_pulse_radius() -> float:
	return 80.0 + float(max(_pulse_level - 1, 0)) * 12.0


func _get_pulse_damage() -> int:
	return int(round((16.0 + float(max(_pulse_level - 1, 0)) * 5.0) * _get_spell_power_multiplier()))


func _get_pulse_cooldown() -> float:
	return maxf(0.36, (1.02 - float(max(_pulse_level - 1, 0)) * 0.06) * _get_cooldown_multiplier())


func _get_pulse_hit_count() -> int:
	return 4 + int(_pulse_level / 2)


func _get_ward_count() -> int:
	return _ward_level


func _get_ward_damage() -> int:
	return int(round((10.0 + float(max(_ward_level - 1, 0)) * 4.0) * _get_spell_power_multiplier()))


func _get_ward_radius() -> float:
	return 84.0 + float(max(_ward_level - 1, 0)) * 14.0


func _get_ward_speed() -> float:
	return 2.2 + float(_ward_level) * 0.28


func _get_beacon_damage() -> int:
	return int(round((12.0 + float(max(_beacon_level - 1, 0)) * 4.0) * _get_spell_power_multiplier()))


func _get_beacon_radius() -> float:
	return 124.0 + float(max(_beacon_level - 1, 0)) * 16.0


func _get_beacon_duration() -> float:
	return 4.5 + float(max(_beacon_level - 1, 0)) * 0.6


func _get_beacon_pulse_interval() -> float:
	return maxf(0.34, 0.84 - float(max(_beacon_level - 1, 0)) * 0.06)


func _get_beacon_cooldown() -> float:
	return maxf(3.0, (7.0 - float(max(_beacon_level - 1, 0)) * 0.40) * _get_cooldown_multiplier())


func _get_beacon_hit_count() -> int:
	return 4 + _beacon_level


func _get_beacon_cast_range() -> float:
	return 420.0 + float(max(_beacon_level - 1, 0)) * 22.0


func _get_relay_damage() -> int:
	return int(round((18.0 + float(max(_relay_level - 1, 0)) * 7.0) * _get_spell_power_multiplier()))


func _get_relay_width() -> float:
	return 24.0 + float(max(_relay_level - 1, 0)) * 4.0


func _get_relay_length() -> float:
	return 280.0 + float(max(_relay_level - 1, 0)) * 36.0


func _get_relay_cooldown() -> float:
	return maxf(2.6, (6.0 - float(max(_relay_level - 1, 0)) * 0.40) * _get_cooldown_multiplier())


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
	if _is_alchemist_character():
		skill_lines = [
			"角色：炼金师",
			"初始技能：裂解瓶，延时落点爆开，清杂稳定。",
			"后续技能：毒雾、碎片喷射、催化反应，适合铺场后集中引爆。",
		]
	elif _is_ranger_character():
		skill_lines = [
			"角色：游侠",
			"初始技能：穿针，短冷却速射，适合边走边打。",
			"后续技能：散羽齐射、回旋刀、穿林迹，主打风筝和扫线。",
		]
	elif _is_warden_character():
		skill_lines = [
			"角色：守望者",
			"初始技能：谐振脉冲，近身脉冲压退敌群。",
			"后续技能：守卫环、信标、中继线，适合守点和区域反压。",
		]
	elif _is_blood_hunter_character():
		skill_lines = [
			"角色：血誓猎手",
			"初始技能：血誓箭，血线越低，整轮追猎火力越凶。",
			"后续技能：猎誓烙印、血潮沼、誓刃穿心，主打换血收割和残局处决。",
		]
	elif _is_grave_caller_character():
		skill_lines = [
			"角色：墓潮号手",
			"初始技能：挽歌，击杀会把战场慢慢变成可调度的尸核场。",
			"后续技能：起灵、丧钟、尸钟合唱，擅长把残局翻成下一轮火力。",
		]
	elif _is_illusionist_character():
		skill_lines = [
			"角色：幻戏师",
			"初始技能：镜折弹，会借残像和镜位把直线火力拆成多点镜射。",
			"后续技能：残像、换幕步、棱镜舞台，适合打错位和舞台式多点压制。",
		]
	elif _is_thunder_character():
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
	_handle_risky_pickup(orb.global_position, value)
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
	var was_marked := _is_enemy_blood_marked(enemy)
	_kills += 1
	_spawn_orb(enemy.global_position, experience_value)
	_award_score(_get_enemy_score_value(enemy))
	if enemy.elite and not enemy.is_boss():
		_spawn_elite_cache(enemy.global_position)
	if _is_thunder_character() and enemy != _boss_enemy:
		_try_trigger_detonate(enemy.global_position)
	if was_marked:
		var mark_center := enemy.global_position
		if _is_blood_hunter_character() and _player != null and is_instance_valid(_player):
			_player.heal(_get_brand_heal())
			_spawn_effect(mark_center, _get_brand_burst_radius() * 0.92, Color(0.98, 0.30, 0.34), Color(1.0, 0.88, 0.84), 0.18)
			_damage_enemies_in_radius(mark_center, _get_brand_burst_radius(), _get_brand_burst_damage(), 180.0, 5)
			if _has_endgame_evolution("evo_hunter_blood_quarry"):
				var chain_damage: int = max(1, int(round(float(_get_oathshot_damage()) * 0.55)))
				var chain_targets := _get_nearest_enemies(mark_center, 3, 320.0)
				for chain_target in chain_targets:
					if chain_target == null or not is_instance_valid(chain_target) or chain_target == enemy:
						continue
					var chain_direction := (chain_target.global_position - mark_center).normalized()
					if chain_direction == Vector2.ZERO:
						chain_direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
					_apply_blood_mark(chain_target, 3.4)
					chain_target.take_damage(chain_damage, chain_direction * 140.0)
					_spawn_rule_link_effect(mark_center, chain_target.global_position, 4.0, Color(0.96, 0.30, 0.34), Color(1.0, 0.86, 0.82), 0.14)
			if _has_endgame_evolution("evo_hunter_harvest_run"):
				_spawn_bloodtrail_zone(mark_center)
				_oathshot_timer = minf(_oathshot_timer, 0.18)
				_verdict_timer = minf(_verdict_timer, 0.90)
			if _has_endgame_evolution("evo_hunter_verdict_gallows"):
				_verdict_timer = minf(_verdict_timer, 0.62)
		_consume_blood_mark(enemy)
	if _is_grave_caller_character() and not enemy.is_boss():
		_spawn_grave_token(enemy.global_position)
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


func _on_boss_phase_changed(enemy: EnemySoldier, phase_index: int) -> void:
	if enemy == null or not is_instance_valid(enemy) or enemy != _boss_enemy:
		return

	_spawn_effect(
		enemy.global_position,
		118.0 + float(phase_index) * 18.0,
		Color(1.0, 0.92, 0.66),
		Color(0.96, 0.42, 0.22),
		0.44
	)
	if _hazard_root != null and is_instance_valid(_hazard_root):
		var surge_radius := 64.0 + float(phase_index) * 8.0
		_spawn_prelude_blast_marker(enemy.global_position, surge_radius, 0.08, 200.0 + float(phase_index) * 16.0, 0.48, Color(1.0, 0.88, 0.62), Color(0.94, 0.28, 0.18))
	_apply_area_current_health_damage(enemy.global_position, 84.0 + float(phase_index) * 12.0, 0.07 + float(phase_index) * 0.01, 200.0)
	_spawn_boss_phase_reinforcements(phase_index)

	var extra_text := "战场规则开始介入。"
	if _is_hard_mode():
		_trigger_hard_mode_boss_phase_pressure(phase_index)
		extra_text = "困难模式增援和地图压迫同步抬升。"
	elif _is_endless_mode():
		_trigger_endless_mode_boss_phase_pressure(phase_index)
		extra_text = "无尽倍率、精英链和下一轮首领节奏继续上扬。"
	else:
		_trigger_map_boss_phase_burst(phase_index, false)

	var form_title := _get_boss_form_shift_title(enemy, phase_index)
	_show_message("%s 进入%s · %s。%s" % [_get_current_boss_name(), _get_boss_phase_title(phase_index), form_title, extra_text], Color(1.0, 0.90, 0.64), 3.4)
	_update_hud()


func _get_boss_phase_title(phase_index: int) -> String:
	match phase_index:
		1:
			return "二阶段压迫"
		2:
			return "三阶段暴走"
		_:
			return "终局狂潮"


func _get_boss_form_shift_title(enemy: EnemySoldier, phase_index: int) -> String:
	if enemy == null:
		return "形态重构"
	match String(enemy.archetype):
		"storm_archon":
			return "风翼裂展" if phase_index >= 2 else "雷翼展开"
		"forge_tyrant":
			return "炉芯开裂" if phase_index >= 2 else "熔炉增压"
		"void_matriarch":
			return "瞳核分裂" if phase_index >= 2 else "触须延展"
		_:
			return "形态重构"


func _spawn_boss_phase_reinforcements(phase_index: int) -> void:
	var roles: Array[String] = []
	match _selected_map_id:
		"sky_ruins":
			roles = ["ranged", "diver", "ranged", "control"]
		"ember_forge":
			roles = ["ranged", "elite", "fodder", "ranged"]
		"void_marsh":
			roles = ["control", "ranged", "elite", "control"]
		"prism_archive":
			roles = ["ranged", "control", "ranged", "elite"]
		"clockwork_garden":
			roles = ["fodder", "ranged", "elite", "fodder"]
		"bridge_train":
			roles = ["diver", "fodder", "elite", "ranged"]
		"black_fog_hunt":
			roles = ["control", "diver", "ranged", "elite"]
		"airship_breach":
			roles = ["ranged", "diver", "ranged", "elite"]
		_:
			roles = ["ranged", "diver", "control"]

	var spawn_count := 1 + phase_index
	if _is_hard_mode():
		spawn_count += 1
	elif _is_endless_mode():
		spawn_count += int(phase_index >= 2)

	for index in range(spawn_count):
		if _enemies.size() >= _get_active_enemy_cap():
			break
		var role := roles[index % roles.size()]
		var make_elite := role == "elite" or (_is_endless_mode() and phase_index >= 2 and index == spawn_count - 1)
		_spawn_role_enemy(role, make_elite)


func _trigger_map_boss_phase_burst(phase_index: int, heavy_pressure: bool) -> void:
	match _selected_map_id:
		"sky_ruins":
			if (_ruins_altar_zone == null or not is_instance_valid(_ruins_altar_zone)) and _hazard_root != null and is_instance_valid(_hazard_root):
				_spawn_ruins_altar()
			if heavy_pressure or phase_index >= 2:
				_spawn_pressure_wave(max(_threat_phase, 2 + phase_index), true)
		"ember_forge":
			var burst_count := 1 + int(heavy_pressure)
			for _burst in range(burst_count):
				_trigger_forge_flame_pattern()
		"void_marsh":
			var pool_count := 1 + int(heavy_pressure or phase_index >= 2)
			for index in range(pool_count):
				_spawn_void_pool("pool" if index % 2 == 0 else "mud")
		"prism_archive":
			if (_prism_focus_zone == null or not is_instance_valid(_prism_focus_zone)) and _hazard_root != null and is_instance_valid(_hazard_root):
				_spawn_prism_focus()
			var prism_burst_count := 1 + int(heavy_pressure or phase_index >= 2)
			for _burst in range(prism_burst_count):
				_spawn_prism_lance_hazard()
		"clockwork_garden":
			if (_clock_node_zone == null or not is_instance_valid(_clock_node_zone)) and _hazard_root != null and is_instance_valid(_hazard_root):
				_spawn_clock_node()
			var gear_burst_count := 1 + int(heavy_pressure or phase_index >= 2)
			for _burst in range(gear_burst_count):
				_spawn_gear_sweep_hazard()
		"bridge_train":
			if _train_car_zones.is_empty():
				_spawn_train_cars()
			if heavy_pressure or phase_index >= 2:
				for burst_index in range(2 + int(heavy_pressure)):
					_spawn_prelude_blast_marker(_player.global_position + Vector2(float(burst_index - 1) * 110.0, 0.0), 50.0, 0.10, 180.0, 0.66, Color(0.88, 0.94, 1.0), Color(1.0, 0.78, 0.44))
		"black_fog_hunt":
			if _fog_brazier_zone == null or not is_instance_valid(_fog_brazier_zone):
				_spawn_black_fog_brazier()
			var fog_burst_count := 1 + int(heavy_pressure or phase_index >= 2)
			for _burst in range(fog_burst_count):
				_trigger_black_fog_pulse()
		"airship_breach":
			if _airship_breach_zone == null or not is_instance_valid(_airship_breach_zone):
				_spawn_airship_breach()
			var gust_count := 1 + int(heavy_pressure or phase_index >= 2)
			for _burst in range(gust_count):
				_trigger_airship_gust(_player.global_position, 180.0 + float(phase_index) * 18.0)


func _trigger_hard_mode_boss_phase_pressure(phase_index: int) -> void:
	_trigger_map_boss_phase_burst(phase_index, true)
	var pressure_roles := ["ranged", "control", "ranged", "diver"]
	var extra_count := 1 + phase_index
	for index in range(extra_count):
		if _enemies.size() >= _get_active_enemy_cap():
			break
		_spawn_role_enemy(pressure_roles[index % pressure_roles.size()], phase_index >= 2 and index == 0)


func _trigger_endless_mode_boss_phase_pressure(phase_index: int) -> void:
	_score_bonus_multiplier += 0.08 + float(phase_index) * 0.04
	_endless_elite_bonus += 0.01 + float(phase_index) * 0.01
	_endless_boss_interval_scale *= 0.97
	_award_score(120 + phase_index * 60)
	if phase_index >= 2:
		_trigger_map_boss_phase_burst(phase_index, false)


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
	match run_mode_id:
		RUN_MODE_ENDLESS:
			return RUN_MODE_ENDLESS
		RUN_MODE_HARD:
			return RUN_MODE_HARD
		_:
			return RUN_MODE_NORMAL


func _get_current_run_mode_name() -> String:
	match _current_run_mode_id:
		RUN_MODE_ENDLESS:
			return "无尽模式"
		RUN_MODE_HARD:
			return "困难模式"
		_:
			return "普通模式"


func _is_endless_mode() -> bool:
	return _current_run_mode_id == RUN_MODE_ENDLESS


func _is_hard_mode() -> bool:
	return _current_run_mode_id == RUN_MODE_HARD


func _is_unbounded_upgrade_mode() -> bool:
	return _is_endless_mode() or _is_hard_mode()


func _get_current_character_definition() -> Dictionary:
	return _get_character_definition(_selected_character_id)


func _get_current_character_name() -> String:
	return String(_get_current_character_definition().get("name", "角色"))


func _is_blade_character() -> bool:
	return _selected_character_id == "blade"


func _is_thunder_character() -> bool:
	return _selected_character_id == "thunder"


func _is_alchemist_character() -> bool:
	return _selected_character_id == "alchemist"


func _is_ranger_character() -> bool:
	return _selected_character_id == "ranger"


func _is_warden_character() -> bool:
	return _selected_character_id == "warden"


func _is_blood_hunter_character() -> bool:
	return _selected_character_id == "blood_hunter"


func _is_grave_caller_character() -> bool:
	return _selected_character_id == "grave_caller"


func _is_illusionist_character() -> bool:
	return _selected_character_id == "illusionist"


func _get_current_map_name() -> String:
	return String(_current_map.get("name", "未命名地图"))


func _get_current_boss_name() -> String:
	return String(_current_map.get("boss_name", "未知首领"))


func _get_boss_spawn_time() -> float:
	return _next_boss_spawn_time


func _get_initial_boss_spawn_time() -> float:
	return float(_current_map.get("boss_time", 600.0))


func _get_endless_boss_interval() -> float:
	return maxf(108.0, _get_initial_boss_spawn_time() * 0.35 * _endless_boss_interval_scale)


func _schedule_next_boss_spawn(delay: float = -1.0) -> void:
	var next_delay := delay
	if next_delay <= 0.0:
		next_delay = _get_endless_boss_interval()
	_next_boss_spawn_time = _run_time + next_delay
	_boss_warning_shown = false
	_boss_defeated = false
	_boss_prelude_stage = 0


func _get_boss_warning_time() -> float:
	if _is_endless_mode():
		return minf(45.0, maxf(18.0, _get_endless_boss_interval() * 0.42))
	return 60.0


func _get_boss_finale_prelude_time() -> float:
	return minf(20.0, _get_boss_warning_time() * 0.45)


func _get_active_enemy_cap() -> int:
	var map_cap := _max_enemy_count + int(_current_map.get("enemy_cap_bonus", 0))
	var opening_cap := 38 if _mobile_layout else 52
	var growth := mini(max(0, map_cap - opening_cap), int(_run_time / 14.0))
	var phase_bonus := _threat_phase * (3 if _mobile_layout else 4)
	var endless_bonus := int(round(_endless_spawn_bonus * 10.0))
	return clampi(opening_cap + growth + phase_bonus + endless_bonus, 24, max(24, map_cap + 28))


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
	threat_rate += float(_threat_phase) * 0.14
	threat_rate += _endless_spawn_bonus
	return threat_rate


func _format_enemy_label_list() -> String:
	var labels: Array[String] = []
	for label_variant in _current_map.get("enemy_labels", []):
		labels.append(String(label_variant))
	return "、".join(labels)


func _is_mobile_layout() -> bool:
	return RuntimeLayout.is_touch_layout(get_viewport_rect().size)





