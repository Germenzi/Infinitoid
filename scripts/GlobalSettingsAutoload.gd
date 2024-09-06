extends Node

signal game_scale_changed

var game_scale : float = 1.0 :
	set(v):
		game_scale = v
		game_scale_changed.emit()
