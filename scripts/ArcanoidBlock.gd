extends ArcanoidRect

class_name ArcanoidBlock

var hp : int


func _init(p_rect:Rect2i, p_hp:int) -> void:
	super(p_rect)
	hp = p_hp
