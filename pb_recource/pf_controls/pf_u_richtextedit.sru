forward
global type pf_u_richtextedit from richtextedit
end type
end forward

global type pf_u_richtextedit from richtextedit
integer width = 457
integer height = 132
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
borderstyle borderstyle = stylelowered!
event type boolean oue_components ( )
end type
global pf_u_richtextedit pf_u_richtextedit

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

public function string of_thisname ();return 'pf_u_richtextedit'

end function

on pf_u_richtextedit.create
end on

on pf_u_richtextedit.destroy
end on

