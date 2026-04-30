extends Node

class_name GameState

var speed_factor : float = 1.05
var new_blocks_spawning : bool = true

var playing_area_ball_collide_rect : ArcanoidRect :
	get:
		return ArcanoidRect.new(Rect2(
			Vector2.ZERO, GlobalSettings.game_config.playing_area_size
		).grow(-ball_radius*2))

var platform_speed : float
var platform_rect : ArcanoidRect

var ball_velocity : Vector2 
var ball_radius : float
var ball_position : Vector2

var blocks : Array[ArcanoidBlock] = []
var blocks_spawn_count : int

var health : int
var score : int


func load_level_config(level_config:LevelConfig) -> void:
	platform_speed = level_config.initial_platform_speed
	ball_velocity = Vector2.RIGHT * level_config.initial_ball_speed
	blocks_spawn_count = level_config.initial_block_spawn_amount
	speed_factor = level_config.speed_factor
	
	blocks.append(ArcanoidBlock.new(
		Rect2(
		Vector2(GlobalSettings.game_config.first_row_offset, GlobalSettings.game_config.top_row_gap) + \
			(GlobalSettings.game_config.block_size + Vector2(GlobalSettings.game_config.blocks_columns_gap, 0)) 
				* Vector2(randi() % GlobalSettings.game_config.block_column_count, 0), 
		GlobalSettings.game_config.block_size), 1))



func _enter_tree() -> void:
	ball_radius = GlobalSettings.game_config.initial_ball_radius
	platform_rect = ArcanoidRect.new(Rect2(Vector2.ZERO, GlobalSettings.game_config.initial_platform_size))
	health = GlobalSettings.game_config.maximum_health
	score = 0
