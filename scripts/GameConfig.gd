extends Resource

class_name GameConfig

@export_range(1, 10000)
var maximum_health : int = 3

@export
var playing_area_size : Vector2 = Vector2(800, 500)

@export
var playing_area_rect_color : Color = Color.WHITE

@export_category("Ball")
@export_range(2.0, 200.0)
var initial_ball_radius : float = 15.0

@export_subgroup("Draw")
@export_range(1.0, 10.0)
var ball_draw_width : float = 2.0

@export
var ball_color : Color = Color.GREEN


@export_category("Platform")
@export
var initial_platform_size : Vector2 = Vector2(100.0, 20.0)

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

@export_range(0.0, 10000.0)
var blocks_deadline_height : float = 400.0

@export_range(0.0, 100.0)
var top_row_gap : float = 50.0

@export_subgroup("Draw")
@export_range(1.0, 10.0)
var block_draw_width : float = 2.0

@export
var deadline_color : Color = Color(Color.RED, 0.3)

@export
var blocks_colors : Array[Color] = [
	Color.RED, # 1 hp
	Color.YELLOW, # 2 hp
	Color.CHOCOLATE, # 3 hp
	Color.CORAL, # 4 hp
	Color.CORNFLOWER_BLUE, # 5 hp
	Color.AZURE, # 6 hp
]

@export
var platform_color : Color = Color.GREEN

var block_column_count : int :
	get:
		return floor(playing_area_size.x / (block_size.x+blocks_columns_gap))

var first_row_offset : float :
	get:
		return (playing_area_size.x-block_column_count*(block_size.x+blocks_columns_gap)+blocks_columns_gap)/2.0
