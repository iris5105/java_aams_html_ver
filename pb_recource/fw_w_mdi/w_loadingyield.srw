forward
global type w_loadingyield from window
end type
type cb_stop from commandbutton within w_loadingyield
end type
type st_2 from statictext within w_loadingyield
end type
type st_1 from statictext within w_loadingyield
end type
type dw_1 from datawindow within w_loadingyield
end type
end forward

global type w_loadingyield from window
integer width = 846
integer height = 960
windowtype windowtype = popup!
boolean palettewindow = true
boolean center = true
cb_stop cb_stop
st_2 st_2
st_1 st_1
dw_1 dw_1
end type
global w_loadingyield w_loadingyield

type variables
Time	iTime
end variables

on w_loadingyield.create
this.cb_stop=create cb_stop
this.st_2=create st_2
this.st_1=create st_1
this.dw_1=create dw_1
this.Control[]={this.cb_stop,&
this.st_2,&
this.st_1,&
this.dw_1}
end on

on w_loadingyield.destroy
destroy(this.cb_stop)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_1)
end on

event open;st_1.backcolor = 553648127
st_2.backcolor = 536870912
iTime = Now ()
end event

event mousemove;Send (handle(THIS),274,61458,0)
end event

type cb_stop from commandbutton within w_loadingyield
integer x = 142
integer y = 788
integer width = 539
integer height = 116
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "처리중지"
end type

event clicked;f_loadingyield ('stop')
end event

type st_2 from statictext within w_loadingyield
integer x = 416
integer y = 680
integer width = 338
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
long bordercolor = 67108864
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_1 from statictext within w_loadingyield
integer x = 64
integer y = 680
integer width = 302
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 67108864
boolean enabled = false
long bordercolor = 67108864
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_loadingyield
integer width = 832
integer height = 944
integer taborder = 10
boolean enabled = false
string dataobject = "d_loadingyield"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

