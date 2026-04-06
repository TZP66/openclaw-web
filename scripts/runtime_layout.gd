extends RefCounted
class_name RuntimeLayout

const MOBILE_BREAKPOINT := 900.0


static func is_touch_layout(viewport_size: Vector2) -> bool:
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		return true
	if _has_web_touch_capability():
		return true
	return viewport_size.x < MOBILE_BREAKPOINT


static func is_portrait(viewport_size: Vector2) -> bool:
	return viewport_size.y >= viewport_size.x


static func _has_web_touch_capability() -> bool:
	if not OS.has_feature("web"):
		return false

	return bool(JavaScriptBridge.eval("""
		(function () {
			var userAgent = navigator.userAgent || '';
			var coarsePointer = window.matchMedia && (
				window.matchMedia('(pointer: coarse)').matches ||
				window.matchMedia('(any-pointer: coarse)').matches
			);
			return (navigator.maxTouchPoints || 0) > 0 ||
				('ontouchstart' in window) ||
				coarsePointer ||
				/Android|iPhone|iPad|iPod|Mobile/i.test(userAgent);
		})()
	""", true))
