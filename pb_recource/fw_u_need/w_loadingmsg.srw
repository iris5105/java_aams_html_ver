forward
global type w_loadingmsg from window
end type
type st_msg from statictext within w_loadingmsg
end type
type st_1 from statictext within w_loadingmsg
end type
end forward

global type w_loadingmsg from window
integer x = 654
integer y = 928
integer width = 2395
integer height = 236
boolean enabled = false
windowtype windowtype = popup!
long backcolor = 32897791
boolean center = true
st_msg st_msg
st_1 st_1
end type
global w_loadingmsg w_loadingmsg

on w_loadingmsg.create
this.st_msg=create st_msg
this.st_1=create st_1
this.Control[]={this.st_msg,&
this.st_1}
end on

on w_loadingmsg.destroy
destroy(this.st_msg)
destroy(this.st_1)
end on

type st_msg from statictext within w_loadingmsg
integer x = 27
integer y = 32
integer width = 2345
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22830172
long backcolor = 32897791
boolean enabled = false
string text = "실행중입니다."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_loadingmsg
integer x = 27
integer y = 128
integer width = 2345
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22830172
long backcolor = 32897791
boolean enabled = false
string text = "잠시만 기다려 주십시요...."
alignment alignment = center!
boolean focusrectangle = false
end type

