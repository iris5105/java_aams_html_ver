forward
global type pf_u_listview from listview
end type
end forward

global type pf_u_listview from listview
integer width = 549
integer height = 476
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
borderstyle borderstyle = stylelowered!
long largepicturemaskcolor = 536870912
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event type boolean oue_components ( )
end type
global pf_u_listview pf_u_listview

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

public function string of_thisname ();return 'pf_u_listview'

end function

on pf_u_listview.create
end on

on pf_u_listview.destroy
end on

event constructor;// pb listview control flickers on windows xp when resizing .
// set listview extended style to LVS_EX_DOUBLEBUFFER could solve it.

//LVM_FIRST = 4096
//LVM_SETEXTENDEDLISTVIEWSTYLE = (LVM_FIRST + 54)
//LVS_EX_DOUBLEBUFFER    = 65536
Send(handle(this), 4096+54, 65536, 65536)

end event

