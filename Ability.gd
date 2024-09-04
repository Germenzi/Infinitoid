extends Node

class_name Ability

@export_range(0.1, 10.0)
var time_capacity : float = 1.0

@export_range(0.01, 2.0)
var time_remains_recovery_scale : float = 1.0

var relative_balance : float :
	get:
		return _time_remains / time_capacity

var _time_remains : float
var _active : bool = false

func _ready() -> void:
	_time_remains = time_capacity


func _process(delta: float) -> void:
	if _active:
		if _time_remains-delta < 0.0:
			_time_remains = 0.0
			deactivate()
		else:
			_time_remains -= delta
	else:
		_time_remains = min(_time_remains+delta*time_remains_recovery_scale, time_capacity)


func activate() -> void:
	if is_active():
		return
	
	print("Activated: %s" % name)
	_active = true
	_on_activated()


func deactivate() -> void:
	if not is_active():
		return
	
	print("Deactivated: %s" % name)
	_active = false
	_on_deactivated()


func is_active() -> bool:
	return _active


# virtual
func _on_activated() -> void:
	pass

# virtual
func _on_deactivated() -> void:
	pass
