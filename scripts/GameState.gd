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
var block_hp_spawn_rate : Dictionary[int, float] = {}

var health : int
var score : int :
	set(v):
		score = v
		_on_score_changed()
	get:
		return score


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
	
	block_hp_spawn_rate[1] = 1.0


func _enter_tree() -> void:
	ball_radius = GlobalSettings.game_config.initial_ball_radius
	platform_rect = ArcanoidRect.new(Rect2(Vector2.ZERO, GlobalSettings.game_config.initial_platform_size))
	health = GlobalSettings.game_config.maximum_health
	score = 0


func _on_score_changed() -> void:
	const NEW_BLOCKS_BEIGN_AT_SCORE : int = 10
	const ADD_ANOTHER_SPAWN_BLOCK_SCORE_RATE : int = 30
	
	var need_new_block : bool = (score - NEW_BLOCKS_BEIGN_AT_SCORE) % ADD_ANOTHER_SPAWN_BLOCK_SCORE_RATE == 0
	if need_new_block:
		blocks_spawn_count = min(blocks_spawn_count + 1, GlobalSettings.game_config.block_column_count)
	
	const NEW_HP_BEGIN_AT_SCORE : int = 20
	const NEW_HP_SCORE_RATE : int = 30
	
	var need_new_hp : bool = (score - NEW_HP_BEGIN_AT_SCORE) % NEW_HP_SCORE_RATE == 0
	if need_new_hp:
		@warning_ignore("integer_division")
		var step : int =  (score - NEW_HP_BEGIN_AT_SCORE) / NEW_HP_SCORE_RATE + 1
		if step > 4:
			return
		
		block_hp_spawn_rate = {}
		match step:
			1:
				block_hp_spawn_rate[1] = 0.8
				block_hp_spawn_rate[2] = 0.2
			2:
				block_hp_spawn_rate[1] = 0.7
				block_hp_spawn_rate[2] = 0.2
				block_hp_spawn_rate[3] = 0.1
			3:
				block_hp_spawn_rate[1] = 0.6
				block_hp_spawn_rate[2] = 0.2
				block_hp_spawn_rate[3] = 0.15
				block_hp_spawn_rate[4] = 0.05
			4:
				block_hp_spawn_rate[1] = 0.4
				block_hp_spawn_rate[2] = 0.3
				block_hp_spawn_rate[3] = 0.15
				block_hp_spawn_rate[4] = 0.1
				block_hp_spawn_rate[5] = 0.05
