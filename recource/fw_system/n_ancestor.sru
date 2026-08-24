forward
global type n_ancestor from nonvisualobject
end type
end forward

global type n_ancestor from nonvisualobject
end type
global n_ancestor n_ancestor

type variables
// 계속/중지 리턴값 상수
constant integer CONTINUE_ACTION = 1
constant integer PREVENT_ACTION = 0

end variables

forward prototypes
public function string of_thisname ()
end prototypes

public function string of_thisname ();return 'n_ancestor'

end function

on n_ancestor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ancestor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

