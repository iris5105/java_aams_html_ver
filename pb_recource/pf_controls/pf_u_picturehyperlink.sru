forward
global type pf_u_picturehyperlink from picturehyperlink
end type
end forward

global type pf_u_picturehyperlink from picturehyperlink
integer width = 320
integer height = 168
string pointer = "HyperLink!"
boolean originalsize = true
boolean focusrectangle = false
event type boolean oue_components ( )
end type
global pf_u_picturehyperlink pf_u_picturehyperlink

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

public function string of_thisname ();return 'pf_u_picturehyperlink'

end function

on pf_u_picturehyperlink.create
end on

on pf_u_picturehyperlink.destroy
end on

