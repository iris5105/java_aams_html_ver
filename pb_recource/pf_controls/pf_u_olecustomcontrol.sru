forward
global type pf_u_olecustomcontrol from olecustomcontrol
end type
end forward

global type pf_u_olecustomcontrol from olecustomcontrol
integer width = 402
integer height = 400
boolean border = false
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "pf_u_olecustomcontrol.udo"
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
event type boolean oue_components ( )
end type
global pf_u_olecustomcontrol pf_u_olecustomcontrol

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

public function string of_thisname ();return 'pf_u_olecustomcontrol'

end function

on pf_u_olecustomcontrol.create
end on

on pf_u_olecustomcontrol.destroy
end on

