extends Object

class_name ArcanoidGeometry

class BallCollisionResult:
	extends RefCounted
	
	var collision_time : float
	var collided_rect_side : int
	
	func _init(p_time:float, p_rect_side:int) -> void:
		collision_time = p_time
		collided_rect_side = p_rect_side


##CCD - continuous collision detection. Checking collisions only by rect sides 
##(if ball is inside rect, no collision detected) [br]
static func ccd_circle_box(circle_begin:Vector2, circle_end:Vector2, circle_radius:float, rect:Rect2, banned_sides:Array=[]) -> BallCollisionResult:
	var ball_aabb : Rect2 = Rect2(circle_begin, circle_end-circle_begin).abs()
	
	var rect_ball_collide : Rect2 = rect.abs().grow(circle_radius)
	
	if not ball_aabb.intersects(rect_ball_collide):
		return null
	
	var rect_ball_collide_points : Array[Vector2] = [ # clockwise rect points, respecting to SIDEs enum
		rect_ball_collide.position + Vector2(0, rect_ball_collide.size.y),
		rect_ball_collide.position, 
		rect_ball_collide.position + Vector2(rect_ball_collide.size.x, 0),
		rect_ball_collide.end,
	]
	
	var intersection_time : float = 2.0
	var rect_collision_side : int
	var circle_segment_length : float = (circle_end-circle_begin).length()
	
	for i:int in len(rect_ball_collide_points):
		if i in banned_sides: continue
		var seg_begin : Vector2 = rect_ball_collide_points[i]
		var seg_end : Vector2 = rect_ball_collide_points[(i+1)%len(rect_ball_collide_points)]
		
		var point : Variant = Geometry2D.segment_intersects_segment(seg_begin, seg_end, circle_begin, circle_end)
		if point == null: continue
		
		var time : float = ((point as Vector2)-circle_begin).length() / circle_segment_length
		if time < intersection_time:
			intersection_time = time
			rect_collision_side = i
	
	if intersection_time <= 1.0:
		return BallCollisionResult.new(intersection_time, rect_collision_side)
	else:
		return null
