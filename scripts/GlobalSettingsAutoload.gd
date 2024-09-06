extends Node

signal game_scale_changed

var game_scale : float = 1.0 :
	set(v):
		game_scale = v
		game_scale_changed.emit()

var game_config : GameConfig = preload("res://resources/main_game_config.tres")

var current_level : LevelConfig = preload("res://resources/level1.tres")
