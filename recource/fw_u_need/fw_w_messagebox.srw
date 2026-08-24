forward
global type fw_w_messagebox from w_response1st
end type
type mle_msg from multilineedit within fw_w_messagebox
end type
type p_icon from picture within fw_w_messagebox
end type
type p_ok from pf_u_imagebutton within fw_w_messagebox
end type
type p_close from pf_u_imagebutton within fw_w_messagebox
end type
type p_cancel from pf_u_imagebutton within fw_w_messagebox
end type
type gb_1 from groupbox within fw_w_messagebox
end type
type ln_1 from line within fw_w_messagebox
end type
type ln_2 from line within fw_w_messagebox
end type
end forward

shared variables

end variables

global type fw_w_messagebox from w_response1st
integer width = 2501
integer height = 716
boolean controlmenu = false
mle_msg mle_msg
p_icon p_icon
p_ok p_ok
p_close p_close
p_cancel p_cancel
gb_1 gb_1
ln_1 ln_1
ln_2 ln_2
end type
global fw_w_messagebox fw_w_messagebox

type prototypes

end prototypes

type variables
fw_s_msgbox	istr_msgbox
end variables

on fw_w_messagebox.destroy
call super::destroy
destroy(this.mle_msg)
destroy(this.p_icon)
destroy(this.p_ok)
destroy(this.p_close)
destroy(this.p_cancel)
destroy(this.gb_1)
destroy(this.ln_1)
destroy(this.ln_2)
end on

on fw_w_messagebox.create
int iCurrent
call super::create
this.mle_msg=create mle_msg
this.p_icon=create p_icon
this.p_ok=create p_ok
this.p_close=create p_close
this.p_cancel=create p_cancel
this.gb_1=create gb_1
this.ln_1=create ln_1
this.ln_2=create ln_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_msg
this.Control[iCurrent+2]=this.p_icon
this.Control[iCurrent+3]=this.p_ok
this.Control[iCurrent+4]=this.p_close
this.Control[iCurrent+5]=this.p_cancel
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.ln_1
this.Control[iCurrent+8]=this.ln_2
end on

event wue_postopen;call super::wue_postopen;This.title = istr_msgbox.title
This.mle_msg.text = istr_msgbox.content

//p_icon.picturename = '..\img\commonuse\question.png'
//p_icon.picturename = '..\img\commonuse\check.png'
end event

event open;call super::open;istr_msgbox = message.PowerObjectParm

If not isvalid(istr_msgbox) Then
	messagebox('Check', '구조체가 없습니다.')
	Close(this)
	Return
End If
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_messagebox
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_messagebox
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_messagebox
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_messagebox
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_messagebox
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_messagebox
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_messagebox
end type

type mle_msg from multilineedit within fw_w_messagebox
integer x = 512
integer y = 128
integer width = 1906
integer height = 308
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string pointer = "Arrow!"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type p_icon from picture within fw_w_messagebox
integer x = 78
integer y = 80
integer width = 402
integer height = 352
boolean originalsize = true
string picturename = "..\img\commonuse\check.jpg"
boolean focusrectangle = false
end type

type p_ok from pf_u_imagebutton within fw_w_messagebox
integer x = 1751
integer y = 508
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

event clicked;call super::clicked;CloseWithReturn( Parent, 1 )
end event

type p_close from pf_u_imagebutton within fw_w_messagebox
integer x = 2226
integer y = 508
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;CloseWithReturn( Parent, 3 )
end event

type p_cancel from pf_u_imagebutton within fw_w_messagebox
integer x = 1989
integer y = 508
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

event clicked;call super::clicked;CloseWithReturn( Parent, 2 )
end event

type gb_1 from groupbox within fw_w_messagebox
integer x = 50
integer y = 24
integer width = 2409
integer height = 448
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 16777215
borderstyle borderstyle = styleraised!
end type

type ln_1 from line within fw_w_messagebox
long linecolor = 15780518
integer linethickness = 8
integer beginx = 50
integer beginy = 476
integer endx = 2459
integer endy = 476
end type

type ln_2 from line within fw_w_messagebox
long linecolor = 33512448
integer linethickness = 8
integer beginx = 50
integer beginy = 484
integer endx = 2459
integer endy = 484
end type

