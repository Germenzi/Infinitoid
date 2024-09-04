extends Control

class_name AbilityListEntry

var ability_info : AbilityInfo

func build(p_ability_name:String, p_number:int, p_texture:Texture) -> void:
	set_ability_name(p_ability_name)
	set_ability_number(p_number)
	set_ability_texture(p_texture)


func set_ability_name(p_ability_name:String) -> void:
	_do_set_ability_name(p_ability_name)


func set_ability_number(p_number:int) -> void:
	_do_set_ability_number(p_number)


func set_ability_texture(p_texture:Texture) -> void:
	_do_set_ability_texture(p_texture)


func set_mark_as_selecting(mark:bool) -> void:
	_do_set_mark_as_selecting(mark)


func set_mark_as_selected(mark:bool) -> void:
	_do_set_mark_as_selected(mark)


# virtual
func _do_set_ability_name(p_ability_name:String) -> void:
	pass


# virtual
func _do_set_ability_number(p_number:int) -> void:
	pass


# virtual
func _do_set_ability_texture(p_texture:Texture) -> void:
	pass


# virtual
func _do_set_mark_as_selecting(mark:bool) -> void:
	pass


# virtual
func _do_set_mark_as_selected(mark:bool) -> void:
	pass
