extends RefCounted

class_name StateMachine

var _state_changed_handlers : Dictionary = {} # StringName : Callable

var state : StringName :
	set = go_state


func go_state(p_state:StringName) -> Error:
	if p_state not in _state_changed_handlers:
		return ERR_DOES_NOT_EXIST
	
	state = p_state
	(_state_changed_handlers[state] as Callable).call()
	return OK


# handler ::= func() (no parameters)
func handle_state(p_state:StringName, handler:Callable) -> Error:
	if p_state in _state_changed_handlers:
		return ERR_ALREADY_EXISTS
	
	_state_changed_handlers[p_state] = handler
	return OK
