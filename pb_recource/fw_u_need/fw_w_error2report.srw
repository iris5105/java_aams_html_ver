forward
global type fw_w_error2report from w_response1st
end type
type mle_msg from multilineedit within fw_w_error2report
end type
type p_icon from picture within fw_w_error2report
end type
type cb_yes from pf_u_commandbutton within fw_w_error2report
end type
type cb_no from pf_u_commandbutton within fw_w_error2report
end type
type gb_1 from groupbox within fw_w_error2report
end type
type ln_1 from line within fw_w_error2report
end type
type ln_2 from line within fw_w_error2report
end type
end forward

shared variables

end variables

global type fw_w_error2report from w_response1st
integer width = 3054
integer height = 2052
boolean controlmenu = false
mle_msg mle_msg
p_icon p_icon
cb_yes cb_yes
cb_no cb_no
gb_1 gb_1
ln_1 ln_1
ln_2 ln_2
end type
global fw_w_error2report fw_w_error2report

type prototypes

end prototypes

type variables
fw_s_msgbox	istr_msgbox
string		iserrormsg
end variables

on fw_w_error2report.destroy
call super::destroy
destroy(this.mle_msg)
destroy(this.p_icon)
destroy(this.cb_yes)
destroy(this.cb_no)
destroy(this.gb_1)
destroy(this.ln_1)
destroy(this.ln_2)
end on

on fw_w_error2report.create
int iCurrent
call super::create
this.mle_msg=create mle_msg
this.p_icon=create p_icon
this.cb_yes=create cb_yes
this.cb_no=create cb_no
this.gb_1=create gb_1
this.ln_1=create ln_1
this.ln_2=create ln_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_msg
this.Control[iCurrent+2]=this.p_icon
this.Control[iCurrent+3]=this.cb_yes
this.Control[iCurrent+4]=this.cb_no
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.ln_1
this.Control[iCurrent+7]=this.ln_2
end on

event wue_postopen;call super::wue_postopen;string		ls_ymd

mle_msg.text = iserrormsg
ls_ymd = fw_f_getymdhh24miss4s()

//gnv_vari.iserror2path1 = gnv_extfunc.of_getsystemtemppath() + ls_ymd + '.png'
//gnv_extfunc.biz_setcapture4pngw(handle(gw_mdi),  gnv_vari.iserror2path1)
//
//gnv_vari.iserror2path2 = gnv_extfunc.of_getsystemtemppath() + ls_ymd + '_msg.png'
//gnv_extfunc.biz_setcapture4pngw(handle(mle_msg),  gnv_vari.iserror2path2)
end event

event open;call super::open;iserrormsg = message.stringParm

If fw_f_nvls(iserrormsg, '') = '' Then
	CloseWithReturn( This, 'N' )
End If
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_error2report
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_error2report
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_error2report
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_error2report
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_error2report
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_error2report
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_error2report
end type

type mle_msg from multilineedit within fw_w_error2report
integer x = 562
integer y = 56
integer width = 2400
integer height = 1668
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
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type p_icon from picture within fw_w_error2report
integer x = 96
integer y = 68
integer width = 421
integer height = 372
string picturename = "..\img\commonuse\error.jpg"
boolean focusrectangle = false
end type

type cb_yes from pf_u_commandbutton within fw_w_error2report
integer x = 2405
integer y = 1788
integer width = 288
integer height = 136
integer taborder = 20
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "yes"
end type

event clicked;call super::clicked;CloseWithReturn( Parent, 'Y' )
end event

type cb_no from pf_u_commandbutton within fw_w_error2report
integer x = 2702
integer y = 1788
integer width = 288
integer height = 136
integer taborder = 30
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "no"
end type

event clicked;call super::clicked;CloseWithReturn( Parent, 'N' )
end event

type gb_1 from groupbox within fw_w_error2report
integer x = 50
integer y = 4
integer width = 2939
integer height = 1740
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

type ln_1 from line within fw_w_error2report
long linecolor = 15780518
integer linethickness = 8
integer beginx = 50
integer beginy = 1764
integer endx = 2981
integer endy = 1764
end type

type ln_2 from line within fw_w_error2report
long linecolor = 33512448
integer linethickness = 8
integer beginx = 50
integer beginy = 1772
integer endx = 2981
integer endy = 1772
end type

