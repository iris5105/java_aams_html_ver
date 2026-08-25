forward
global type pf_n_timing from timing
end type
end forward

global type pf_n_timing from timing
end type
global pf_n_timing pf_n_timing

type variables
//CONSTANT DOUBLE DEFAULT_TIMING_INTERVAL = 0.2
CONSTANT DOUBLE DEFAULT_TIMING_INTERVAL = 0.1

private:
	dragobject ido_parent

end variables

forward prototypes
public subroutine of_initialize (readonly dragobject ado_parent)
public function string of_thisname ()
public function integer of_start ()
public function integer of_start (long al_interval)
end prototypes

public subroutine of_initialize (readonly dragobject ado_parent);ido_parent = ado_parent

end subroutine

public function string of_thisname ();return 'pf_n_timing'

end function

public function integer of_start ();return this.start(DEFAULT_TIMING_INTERVAL)

end function

public function integer of_start (long al_interval);return this.start(al_interval)

end function

on pf_n_timing.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_timing.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;if this.running = true then
	this.stop()
end if

end event

event timer;if isvalid(ido_parent) then
	ido_parent.postevent('timer')
end if

end event

