forward
global type ez_w_http_up_state from window
end type
type st_size_sum from statictext within ez_w_http_up_state
end type
type st_total_sum from statictext within ez_w_http_up_state
end type
type st_3 from statictext within ez_w_http_up_state
end type
type st_8 from statictext within ez_w_http_up_state
end type
type hpb_file from hprogressbar within ez_w_http_up_state
end type
type st_1 from statictext within ez_w_http_up_state
end type
type st_total from statictext within ez_w_http_up_state
end type
type st_size from statictext within ez_w_http_up_state
end type
type hpb_total from hprogressbar within ez_w_http_up_state
end type
type st_9 from statictext within ez_w_http_up_state
end type
type p_loading from picture within ez_w_http_up_state
end type
type cb_close from commandbutton within ez_w_http_up_state
end type
type st_msg from statictext within ez_w_http_up_state
end type
type st_title from statictext within ez_w_http_up_state
end type
type dw_list from fw_u_dwo within ez_w_http_up_state
end type
end forward

global type ez_w_http_up_state from window
boolean visible = false
integer width = 1824
integer height = 1812
boolean titlebar = true
string title = "up state"
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 16777215
boolean center = true
st_size_sum st_size_sum
st_total_sum st_total_sum
st_3 st_3
st_8 st_8
hpb_file hpb_file
st_1 st_1
st_total st_total
st_size st_size
hpb_total hpb_total
st_9 st_9
p_loading p_loading
cb_close cb_close
st_msg st_msg
st_title st_title
dw_list dw_list
end type
global ez_w_http_up_state ez_w_http_up_state

type variables
public:
	boolean ib_cancel

end variables

on ez_w_http_up_state.create
this.st_size_sum=create st_size_sum
this.st_total_sum=create st_total_sum
this.st_3=create st_3
this.st_8=create st_8
this.hpb_file=create hpb_file
this.st_1=create st_1
this.st_total=create st_total
this.st_size=create st_size
this.hpb_total=create hpb_total
this.st_9=create st_9
this.p_loading=create p_loading
this.cb_close=create cb_close
this.st_msg=create st_msg
this.st_title=create st_title
this.dw_list=create dw_list
this.Control[]={this.st_size_sum,&
this.st_total_sum,&
this.st_3,&
this.st_8,&
this.hpb_file,&
this.st_1,&
this.st_total,&
this.st_size,&
this.hpb_total,&
this.st_9,&
this.p_loading,&
this.cb_close,&
this.st_msg,&
this.st_title,&
this.dw_list}
end on

on ez_w_http_up_state.destroy
destroy(this.st_size_sum)
destroy(this.st_total_sum)
destroy(this.st_3)
destroy(this.st_8)
destroy(this.hpb_file)
destroy(this.st_1)
destroy(this.st_total)
destroy(this.st_size)
destroy(this.hpb_total)
destroy(this.st_9)
destroy(this.p_loading)
destroy(this.cb_close)
destroy(this.st_msg)
destroy(this.st_title)
destroy(this.dw_list)
end on

event activate;// CurrentDirectory 변경여부 확인, 디폴트 폴더로 원복처리
if appeongetclienttype() = 'PB' then
	if getcurrentdirectory() <> gnv_vari.basepath then
		changedirectory(gnv_vari.basepath)
	end if
end if

end event

type st_size_sum from statictext within ez_w_http_up_state
integer x = 256
integer y = 508
integer width = 343
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20066866
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type st_total_sum from statictext within ez_w_http_up_state
integer x = 672
integer y = 508
integer width = 343
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20066866
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within ez_w_http_up_state
integer x = 594
integer y = 508
integer width = 82
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20066866
long backcolor = 16777215
string text = "/"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_8 from statictext within ez_w_http_up_state
integer x = 37
integer y = 204
integer width = 229
integer height = 80
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217856
long backcolor = 16777215
string text = "file"
boolean focusrectangle = false
end type

type hpb_file from hprogressbar within ez_w_http_up_state
integer x = 32
integer y = 296
integer width = 983
integer height = 152
unsignedinteger minposition = 1
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_1 from statictext within ez_w_http_up_state
integer x = 599
integer y = 212
integer width = 82
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20066866
long backcolor = 16777215
string text = "/"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_total from statictext within ez_w_http_up_state
integer x = 677
integer y = 212
integer width = 343
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20066866
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type st_size from statictext within ez_w_http_up_state
integer x = 261
integer y = 212
integer width = 343
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20066866
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_total from hprogressbar within ez_w_http_up_state
integer x = 32
integer y = 592
integer width = 983
integer height = 152
unsignedinteger minposition = 1
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_9 from statictext within ez_w_http_up_state
integer x = 37
integer y = 508
integer width = 229
integer height = 76
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217856
long backcolor = 16777215
string text = "total"
boolean focusrectangle = false
end type

type p_loading from picture within ez_w_http_up_state
integer x = 1061
integer y = 172
integer width = 731
integer height = 640
string picturename = "..\img\mainframe\loading\loading4.gif"
boolean focusrectangle = false
end type

type cb_close from commandbutton within ez_w_http_up_state
boolean visible = false
integer x = 1518
integer y = 1780
integer width = 274
integer height = 108
integer taborder = 10
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "close"
end type

event clicked;choose case this.text
	case 'Close'
		close(parent)
	case 'Cancel'
		ib_cancel = true
		close(parent)
end choose

end event

type st_msg from statictext within ez_w_http_up_state
integer x = 23
integer y = 1632
integer width = 1769
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8421376
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_title from statictext within ez_w_http_up_state
integer x = 32
integer y = 24
integer width = 1760
integer height = 108
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 16777215
string text = "sync server upload progress state"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_list from fw_u_dwo within ez_w_http_up_state
integer x = 23
integer y = 844
integer width = 1769
integer height = 780
integer taborder = 10
string dataobject = "ez_d_http_up_state_1"
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;ez_f_delaytime(50)
end event

