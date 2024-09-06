extends Node

class_name GameState

const GAME_STARTING_STATE : StringName = &"GAME_STARTING_STATE"
const LAUNCHING_BALL_STATE : StringName = &"LAUNCHING_BALL_STATE"
const CONTROLLING_BALL_STATE : StringName = &"CONTROLLING_BALL_STATE"
const WAITING_FOR_DAMAGE_STATE : StringName = &"WAITING_FOR_DAMAGE_STATE"

var speed_factor : float = 1.05
var new_blocks_spawning : bool = true

var state_machine : StateMachine = StateMachine.new()

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
	new_blocks_spawning = level_config.new_blocks_spawning
	speed_factor = level_config.speed_factor
	
	var csv_lines := level_config.initial_level_structure.split("\n")
	print(csv_lines)
	for i:int in len(csv_lines):
		var blocks_hp : Array[int] = []
		blocks_hp.append_array(Array(csv_lines[i].split(",")).map(func(x:String): return int(x)))
		print(blocks_hp)
		
		for j:int in min(GlobalSettings.game_config.block_column_count, len(blocks_hp)):
			if blocks_hp[j] == 0:
				continue
			blocks.append(ArcanoidBlock.new(
				Rect2(
				Vector2(GlobalSettings.game_config.first_row_offset, GlobalSettings.game_config.top_row_gap) + \
					(GlobalSettings.game_config.block_size+Vector2(GlobalSettings.game_config.blocks_columns_gap, GlobalSettings.game_config.block_rows_gap))*Vector2(j, i), 
				GlobalSettings.game_config.block_size), blocks_hp[j]))



func _enter_tree() -> void:
	ball_radius = GlobalSettings.game_config.initial_ball_radius
	platform_rect = ArcanoidRect.new(Rect2(Vector2.ZERO, GlobalSettings.game_config.initial_platform_size))
	health = GlobalSettings.game_config.maximum_health
	score = 0
