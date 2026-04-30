@tool
extends Control

class_name StarsJourneyBackground

@export var star_count : int = 10 :
	set(v):
		star_count = v
		regenerate_stars()


@export var star_size : float = 20.0

@export var texture : Texture2D

@export var viewer_nearing_factor : float = 2.0 :
	set(v):
		viewer_nearing_factor = v
		regenerate_stars()
		
@export var star_spawn_distance : float = 10.0:
	set(v):
		star_spawn_distance = v
		regenerate_stars()
	
@export var flying_speed_factor : float = 1.0

@export var star_min_radius_factor : float = 3.0 :
	set(v):
		star_min_radius_factor = v
		regenerate_stars()
	
@export var star_max_radius_factor : float = 5.0 :
	set(v):
		star_max_radius_factor = v
		regenerate_stars()

@export var star_radius_distribution_power : float = 1.0 :
	set(v):
		star_radius_distribution_power = v
		regenerate_stars()

var _stars_multimesh : MultiMesh = MultiMesh.new()

func _init():
	var mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	# Вершины (прямоугольник)
	var vertices = PackedVector2Array([
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(0, 1)
	])
	
	var uvs = PackedVector2Array([
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(0, 1)
	])
	
	var indices = PackedInt32Array([0, 1, 2, 0, 2, 3])
	
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	_stars_multimesh.mesh = mesh
	_stars_multimesh.transform_format = MultiMesh.TRANSFORM_2D
	_stars_multimesh.use_custom_data = true
	
	regenerate_stars()


func regenerate_stars() -> void:
	_stars_multimesh.instance_count = star_count
	_stars_multimesh.visible_instance_count = star_count
	for i:int in range(_stars_multimesh.instance_count):
		regenerate_star(i, true)


func regenerate_star(i:int, init:bool=false) -> void:
	var star_pos : Vector3 = generate_star(init)
	set_star_pos(i, star_pos)


func get_star_pos(i:int) -> Vector3:
	var star_data : Color = _stars_multimesh.get_instance_custom_data(i)
	return Vector3(star_data.r, star_data.g, star_data.b)


func set_star_pos(i:int, pos:Vector3) -> void:
	_stars_multimesh.set_instance_custom_data(i, Color(pos.x, pos.y, pos.z) )


func _process(delta: float) -> void:
	for i:int in range(_stars_multimesh.instance_count):
		var star_pos : Vector3 = get_star_pos(i)
		if star_pos.z - flying_speed_factor*delta < 0.0:
			regenerate_star(i)
		else:
			star_pos.z -= flying_speed_factor*delta
			set_star_pos(i, star_pos)
	
	queue_redraw()


func generate_star(init:bool=false) -> Vector3:
	var radius : float = lerp(star_min_radius_factor, star_max_radius_factor, randf()**star_radius_distribution_power)
	
	var plane_pos : Vector2 = Vector2.RIGHT.rotated(2*PI*randf())*radius
	
	var z : float = star_spawn_distance
	if init:
		z *= randf()
	
	return Vector3(plane_pos.x, plane_pos.y, z)


func _draw():
	var factor_rect : Rect2 = Rect2(Vector2.ZERO, Vector2.ONE)
	for i:int in range(_stars_multimesh.instance_count):
		var star : Vector3 = get_star_pos(i)
		var scale_factor : float = viewer_nearing_factor / (viewer_nearing_factor + star.z)
		var factor_pos : Vector2 = scale_factor*Vector2(star.x, star.y)*0.5
		
		factor_pos += Vector2(0.5, 0.5)
		
		if not factor_rect.has_point(factor_pos):
			regenerate_star(i)
			scale_factor = viewer_nearing_factor / (viewer_nearing_factor + star.z)
			factor_pos = scale_factor*Vector2(star.x, star.y)*0.5
			factor_pos += Vector2(0.5, 0.5)
		
		var pos : Vector2 = size*factor_pos
		var screen_star_size : float = star_size*scale_factor
		
		_stars_multimesh.set_instance_transform_2d(i,
			Transform2D.IDENTITY.scaled(Vector2(screen_star_size, screen_star_size)).translated(pos)
		)
		
	draw_multimesh(_stars_multimesh, texture)
