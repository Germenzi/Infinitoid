extends Node

class_name GameState

const GAME_STARTING_STATE : StringName = &"GAME_STARTING_STATE"
const LAUNCHING_BALL_STATE : StringName = &"LAUNCHING_BALL_STATE"
const CONTROLLING_BALL_STATE : StringName = &"CONTROLLING_BALL_STATE"

@export_category("Ball")
@export_range(2.0, 200.0)
var initial_ball_radius : float = 15.0

@export_range(10.0, 1_000.0)
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

@export
var platform_color : Color = Color.GREEN

var playing_area_rect : Rect2 

var state_machine : StateMachine = StateMachine.new()

var platform_speed : float
var platform_rect : Rect2

var ball_velocity : Vector2 
var ball_radius : float
var ball_position : Vector2


func _enter_tree() -> void:
	ball_velocity = Vector2.RIGHT * initial_ball_speed
	ball_radius = initial_ball_radius
	
	platform_speed = initial_platform_speed
	platform_rect = Rect2(Vector2.ZERO, initial_platform_size)
	
	playing_area_rect = Rect2(Vector2.ZERO, get_tree().root.size)
