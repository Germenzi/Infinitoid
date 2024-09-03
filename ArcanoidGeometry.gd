extends Object

class_name ArcanoidGeometry

##CCD - continuous collision detection. Checking collisions only by rect sides 
##(if ball is inside rect, no collision detected) [br]
##Returns array where:[br]
##[0] - is collision detected[br]
##[1] - collision time parameter (between 0.0 and 1.0)[br]
##[2] - rect collision side[br]
static func ccd_circle_box(circle_begin:Vector2, circle_end:Vector2, circle_radius:float, rect:Rect2, banned_sides:Array=[]) -> Array:
	const NO_INTERSECTION_RESULT : Array = [false, 0.0, SIDE_TOP]
	
	var ball_aabb : Rect2 = Rect2(circle_begin, circle_end-circle_begin).abs()
	
	var rect_ball_collide : Rect2 = rect.abs().grow(circle_radius)
	
	if not ball_aabb.intersects(rect_ball_collide):
		return NO_INTERSECTION_RESULT.duplicate()
	
	var rect_ball_collide_points : Array[Vector2] = [ # clockwise rect points
		rect_ball_collide.position, 
		rect_ball_collide.position + Vector2(rect_ball_collide.size.x, 0),
		rect_ball_collide.end,
		rect_ball_collide.position + Vector2(0, rect_ball_collide.size.y),
	]
	
	var intersection_time : float = 2.0
	var rect_collision_side : int
	var circle_segment_length : float = (circle_end-circle_begin).length()
	
	for i:int in len(rect_ball_collide_points):
		if (SIDE_TOP+i)%4 in banned_sides: continue
		var seg_begin : Vector2 = rect_ball_collide_points[i]
		var seg_end : Vector2 = rect_ball_collide_points[(i+1)%len(rect_ball_collide_points)]
		
		var point : Variant = Geometry2D.segment_intersects_segment(seg_begin, seg_end, circle_begin, circle_end)
		if point == null: continue
		
		var time : float = (point-circle_begin).length() / circle_segment_length
		if time < intersection_time:
			intersection_time = time
			rect_collision_side = (SIDE_TOP+i)%4
	
	if intersection_time <= 1.0:
		return [true, intersection_time, rect_collision_side]
	else:
		return NO_INTERSECTION_RESULT.duplicate()
