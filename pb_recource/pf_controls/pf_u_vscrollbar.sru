forward
global type pf_u_vscrollbar from vscrollbar
end type
end forward

global type pf_u_vscrollbar from vscrollbar
integer width = 78
integer height = 272
event type boolean oue_components ( )
end type
global pf_u_vscrollbar pf_u_vscrollbar

type variables
public:
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables

forward prototypes
public function string of_thisname ()
end prototypes

event type boolean oue_components();return true

end event

public function string of_thisname ();return 'pf_u_vscrollbar'

end function

on pf_u_vscrollbar.create
end on

on pf_u_vscrollbar.destroy
end on

