forward
global type pf_u_editmask from editmask
end type
end forward

global type pf_u_editmask from editmask
integer width = 402
integer height = 88
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
borderstyle borderstyle = stylelowered!
event type boolean oue_components ( )
event oue_lastopen ( )
event oue_postopen ( )
event oue_keydown pbm_keydown
end type
global pf_u_editmask pf_u_editmask

type variables
Protected:

Public:
	boolean	i----------------------------------------------------line0 /* empty Object */
	window		iw_parent
	
	boolean	FixedToRight
	boolean	FixedToBottom
	boolean	ScaleToRight
	boolean	ScaleToBottom
	boolean	i----------------------------------------------------line1	/* empty Object */
	boolean	ibbelong2cond			= False
	boolean	SetBringToTop			= False
	boolean	i----------------------------------------------------line2	/* empty Object */

end variables

forward prototypes
public function string of_thisname ()
end prototypes

event type boolean oue_components();return true

end event

event oue_lastopen();If SetBringToTop = True Then This.BringtoTop = True
end event

event oue_postopen();// call oue_lastopen event
This.Post Event oue_lastopen()
end event

event oue_keydown;Choose Case key
	Case  KeyAdd! // +를 누르면 역방향으로 컬럼이 움직인다.
		gnv_extfunc.keybd_event(16,0,0,0) // shift가 눌렸다.
		gnv_extfunc.keybd_event(9,0,0,0)  // tab이 눌렸다.
		gnv_extfunc.keybd_event(16,0,2,0) // shift가 띄어졌다. (생략 불가능)
		gnv_extfunc.keybd_event(9,0,2,0)  // tab이 띄어졌다. (생략가능)　
	Case KeyEnter! // Enter를 누르면 앞으로 컬럼이 움직인다.
		gnv_extfunc.keybd_event(9,0,0,0) // tab이 눌렸다.
		gnv_extfunc.keybd_event(9,0,2,0) // tab이 띄어졌다. (생략가능)
		return 1
End Choose
end event

public function string of_thisname ();return 'pf_u_editmask'

end function

on pf_u_editmask.create
end on

on pf_u_editmask.destroy
end on

event constructor;// get parent window
iw_parent = fw_f_obj4parentwindow(this)

// call oue_postopen event
This.Post Event oue_postopen()
end event

event getfocus;If ibbelong2cond = True Then
	This.backcolor = gnv_vari.setcolfocusbackcolor
	iw_parent.dynamic of_setedittoken44('dw_cond')
End If
end event

event losefocus;If ibbelong2cond = True Then
	this.backcolor = gnv_vari.editablecolbgcolor
End If
end event

