extends Resource

class_name LevelConfig

@export_range(1.0, 1.5)
var speed_factor : float = 1.05

@export
var new_blocks_spawning : bool = true

@export_range(10.0, 10_000.0)
var initial_ball_speed : float = 200.0

@export_range(10.0, 1_000.0)
var initial_platform_speed : float = 200.0

@export_range(1, 1000)
var initial_block_spawn_amount : int = 1

@export_multiline
var initial_level_structure : String = ""
