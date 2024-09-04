extends Node

class_name GameState

const GAME_STARTING_STATE : StringName = &"GAME_STARTING_STATE"
const LAUNCHING_BALL_STATE : StringName = &"LAUNCHING_BALL_STATE"
const CONTROLLING_BALL_STATE : StringName = &"CONTROLLING_BALL_STATE"
const WAITING_FOR_DAMAGE_STATE : StringName = &"WAITING_FOR_DAMAGE_STATE"

@export_range(1.0, 1.5)
var speed_factor : float = 1.05

@export_range(1, 10000)
var maximum_health : int = 3

@export
var playing_area_size : Vector2 = Vector2(800, 500)

@export
var playing_area_rect_color : Color = Color.WHITE

@export_category("Ball")
@export_range(2.0, 200.0)
var initial_ball_radius : float = 15.0

@export_range(10.0, 10_000.0)
var initial_ball_speed : float = 200.0

@export_subgroup("Draw")
@export_range(1.0, 10.0)
var ball_draw_width : float = 2.0

@export
var ball_color : Color = Color.GREEN


@export_category("Platform")
@export
var initial_platform_size : Vector2 = Vector2(100.0, 20.0)

@export_range(10.0, 1_000.0)
var initial_platform_speed : float = 200.0

@export_range(0.0, 1000.0)
var platform_height : float = 100.0

@export_subgroup("Draw")
@export_range(1.0, 10.0)
var platform_draw_width : float = 2.0

@export_category("Block")
@export
var block_size : Vector2 = Vector2(100.0, 20.0)

@export_range(0.0, 100.0)
var block_rows_gap : float = 4.0

@export_range(0.0, 100.0)
var blocks_columns_gap : float = 4.0

@export_range(1, 1000)
var initial_block_spawn_amount : int = 1

@export_range(1, 100)
var initial_block_rows : int = 5

@export_range(0.0, 10000.0)
var blocks_deadline_height : float = 400.0

@export_range(0.0, 100.0)
var top_row_gap : float = 50.0

@export_subgroup("Draw")
@export_range(1.0, 10.0)
var block_draw_width : float = 2.0

@export
var block_color : Color = Color.RED

@export
var platform_color : Color = Color.GREEN

var state_machine : StateMachine = StateMachine.new()

var platform_speed : float
var platform_rect : Rect2

var ball_velocity : Vector2 
var ball_radius : float
var ball_position : Vector2

var blocks_columns : int
var blocks : Array[Rect2] = []
var blocks_spawn_count : int

var health : int
var score : int

func _enter_tree() -> void:
	ball_velocity = Vector2.RIGHT * initial_ball_speed
	ball_radius = initial_ball_radius
	
	platform_speed = initial_platform_speed
	platform_rect = Rect2(Vector2.ZERO, initial_platform_size)
	
	blocks_columns = playing_area_size.x / (block_size.x + blocks_columns_gap)
	blocks_spawn_count = initial_block_spawn_amount
	
	health = maximum_health
	score = 0
