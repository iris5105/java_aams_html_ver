forward
global type pf_u_hscrollbar from hscrollbar
end type
end forward

global type pf_u_hscrollbar from hscrollbar
integer width = 311
integer height = 68
event type boolean oue_components ( )
end type
global pf_u_hscrollbar pf_u_hscrollbar

type variables
public:
	boolean	i----------------------------------------------------line0	/* empty Object */
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

public function string of_thisname ();return 'pf_u_hscrollbar'

end function

on pf_u_hscrollbar.create
end on

on pf_u_hscrollbar.destroy
end on

