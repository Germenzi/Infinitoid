extends Object

class_name ArcanoidGeometry

class BallCollisionResult:
	extends RefCounted
	
	var collision_time : float
	var collided_rect_side : int
	
	func _init(p_time:float, p_rect_side:int) -> void:
		collision_time = p_time
		collided_rect_side = p_rect_side


class RectGroupBannedSides:
	extends RefCounted
	
	var _banned : Dictionary = {} # arcanoid rect : banned sides
	
	func get_banned_sides(rect:ArcanoidRect) -> Array[int]:
		var res : Array[int] = [] # for type-safety only
		for i:int in _banned.get(rect, []):
			res.append(i)
		return res
	
	func ban_side(rect:ArcanoidRect, side:int) -> void:
		if not _banned.has(rect):
			_banned[rect] = []
		(_banned[rect] as Array[int]).append(side)


class BallCollisionResultGroup:
	extends BallCollisionResult
	
	var collision_rect : ArcanoidRect
	
	func _init(p_time:float, p_rect_side:int, p_rect:ArcanoidRect) -> void:
		super(p_time, p_rect_side)
		collision_rect = p_rect


##CCD - continuous collision detection. Checking collisions only by rect sides 
##(if ball is inside rect, no collision detected) [br]
static func ccd_circle_box(circle_begin:Vector2, circle_end:Vector2, circle_radius:float, rect:ArcanoidRect, banned_sides:Array=[]) -> BallCollisionResult:
	var ball_aabb : Rect2 = Rect2(circle_begin, circle_end-circle_begin).abs()
	
	var rect_ball_collide : Rect2 = rect.rect.abs().grow(circle_radius)
	
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


static func ccd_circle_box_group(circle_begin:Vector2, circle_end:Vector2, 
	circle_radius:float, rect_group:Array[ArcanoidRect], 
	banned:RectGroupBannedSides=RectGroupBannedSides.new()) -> BallCollisionResultGroup:
	
		var earliest_collision : ArcanoidGeometry.BallCollisionResultGroup = null
		for rect:ArcanoidRect in rect_group:
			var ccd_res := ArcanoidGeometry.ccd_circle_box(
				circle_begin, circle_end, circle_radius,
				rect, banned.get_banned_sides(rect)) 
			
			if ccd_res == null: continue
			
			if earliest_collision == null or ccd_res.collision_time < earliest_collision.collision_time:
				earliest_collision = BallCollisionResultGroup.new(ccd_res.collision_time, ccd_res.collided_rect_side, rect)
		
		return earliest_collision
