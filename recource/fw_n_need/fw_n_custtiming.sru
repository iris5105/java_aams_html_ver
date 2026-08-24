forward
global type fw_n_custtiming from timing
end type
end forward

global type fw_n_custtiming from timing
event oue_parentevent ( readonly powerobject apo_parent,  readonly string as_event )
end type
global fw_n_custtiming fw_n_custtiming

type variables
Protected:
	powerobject	ipo
	string	is_event
end variables
event oue_parentevent(readonly powerobject apo_parent, readonly string as_event);ipo = apo_parent
is_event = as_event
end event

on fw_n_custtiming.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_custtiming.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event timer;IF ISVALID(ipo) THEN
	ipo.TriggerEvent(is_event)
END IF
end event

