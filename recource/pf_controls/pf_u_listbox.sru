forward
global type pf_u_listbox from listbox
end type
end forward

global type pf_u_listbox from listbox
integer width = 549
integer height = 476
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
borderstyle borderstyle = stylelowered!
event type boolean oue_components ( )
end type
global pf_u_listbox pf_u_listbox

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

public function string of_thisname ();return 'pf_u_listbox'

end function

on pf_u_listbox.create
end on

on pf_u_listbox.destroy
end on

