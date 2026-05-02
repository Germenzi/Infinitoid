extends Node

signal game_scale_changed

var game_scale : float = 1.0 :
	set(v):
		game_scale = v
		game_scale_changed.emit()

var game_config : GameConfig = preload("res://resources/main_game_config.tres")

var games_played : int = 0

var lang :String

func _ready() -> void:
	if !WebBus.is_init:
		await WebBus.inited
	
	WebBus.ready()
	lang = WebBus.get_language()
