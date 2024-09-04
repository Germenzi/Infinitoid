extends Object

class_name GameAbilitiesNamespace

enum Types {
	SLOWTIME,
	SHOW_BALL_TRAJECTORY,
	PLATFORM_ACCELERATION,
	PLATFORM_EXTENSION,
	MAGNETISM,
}

const ABILITY_FALLBACK_ICON : Texture = preload("res://icon.svg")
const ABILITY_UI_ENTRY_SCENE : PackedScene = preload("res://scenes/ability_list_ui_entry.tscn")
