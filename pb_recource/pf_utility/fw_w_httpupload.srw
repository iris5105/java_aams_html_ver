forward
global type fw_w_httpupload from window
end type
type dw_2 from u_dw within fw_w_httpupload
end type
type dw_1 from u_dw within fw_w_httpupload
end type
type cb_close from pf_u_commandbutton within fw_w_httpupload
end type
type st_4 from pf_u_statictext within fw_w_httpupload
end type
type st_2 from pf_u_statictext within fw_w_httpupload
end type
type hpb_file from hprogressbar within fw_w_httpupload
end type
type st_msg from pf_u_statictext within fw_w_httpupload
end type
type hpb_total from hprogressbar within fw_w_httpupload
end type
type st_title from pf_u_statictext within fw_w_httpupload
end type
type dw_filelist from fw_u_dwo within fw_w_httpupload
end type
end forward

global type fw_w_httpupload from window
integer width = 1637
integer height = 1692
boolean titlebar = true
string title = "HTTP File Transfer"
boolean minbox = true
windowtype windowtype = popup!
boolean center = true
dw_2 dw_2
dw_1 dw_1
cb_close cb_close
st_4 st_4
st_2 st_2
hpb_file hpb_file
st_msg st_msg
hpb_total hpb_total
st_title st_title
dw_filelist dw_filelist
end type
global fw_w_httpupload fw_w_httpupload

type variables
public:
	boolean ib_cancel

end variables

on fw_w_httpupload.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.cb_close=create cb_close
this.st_4=create st_4
this.st_2=create st_2
this.hpb_file=create hpb_file
this.st_msg=create st_msg
this.hpb_total=create hpb_total
this.st_title=create st_title
this.dw_filelist=create dw_filelist
this.Control[]={this.dw_2,&
this.dw_1,&
this.cb_close,&
this.st_4,&
this.st_2,&
this.hpb_file,&
this.st_msg,&
this.hpb_total,&
this.st_title,&
this.dw_filelist}
end on

on fw_w_httpupload.destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.cb_close)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.hpb_file)
destroy(this.st_msg)
destroy(this.hpb_total)
destroy(this.st_title)
destroy(this.dw_filelist)
end on

event activate;// CurrentDirectory 변경여부 확인, 디폴트 폴더로 원복처리
if appeongetclienttype() = 'PB' then
	if getcurrentdirectory() <> gnv_vari.basepath then
		changedirectory(gnv_vari.basepath)
	end if
end if

end event

type dw_2 from u_dw within fw_w_httpupload
boolean visible = false
integer x = 832
integer y = 312
integer width = 754
integer height = 64
integer taborder = 20
string dataobject = "fw_d_httpprogress"
boolean border = false
boolean ibdesign4role = false
boolean applydesign = false
boolean useborder = false
boolean setfocusdw = false
boolean setedittoken = false
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean eb_fund_default_change = false
boolean eb_range_delcopy = false
end type

type dw_1 from u_dw within fw_w_httpupload
boolean visible = false
integer x = 832
integer y = 164
integer width = 754
integer height = 64
integer taborder = 20
string dataobject = "fw_d_httpprogress"
boolean border = false
boolean ibdesign4role = false
boolean applydesign = false
boolean useborder = false
boolean setfocusdw = false
boolean setedittoken = false
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean eb_fund_default_change = false
boolean eb_range_delcopy = false
end type

type cb_close from pf_u_commandbutton within fw_w_httpupload
integer x = 1312
integer y = 24
integer width = 274
integer height = 108
integer taborder = 10
integer textsize = -9
integer weight = 400
string text = "Close"
end type

event clicked;choose case this.text
	case 'Close'
		close(parent)
	case 'Cancel'
		ib_cancel = true
		close(parent)
end choose

end event

type st_4 from pf_u_statictext within fw_w_httpupload
integer x = 37
integer y = 160
integer height = 64
integer textsize = -9
long textcolor = 20066866
string text = "File Progress"
boolean setsheetcolor = true
end type

type st_2 from pf_u_statictext within fw_w_httpupload
integer x = 37
integer y = 308
integer width = 475
integer height = 64
integer textsize = -9
long textcolor = 20066866
string text = "Total Progress"
boolean setsheetcolor = true
end type

type hpb_file from hprogressbar within fw_w_httpupload
integer x = 32
integer y = 228
integer width = 1554
integer height = 68
unsignedinteger minposition = 1
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_msg from pf_u_statictext within fw_w_httpupload
integer x = 32
integer y = 1508
integer width = 1554
integer textsize = -9
long textcolor = 20066866
long backcolor = 32896501
boolean border = true
boolean setcondcolor = true
end type

type hpb_total from hprogressbar within fw_w_httpupload
integer x = 32
integer y = 376
integer width = 1554
integer height = 68
unsignedinteger minposition = 1
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_title from pf_u_statictext within fw_w_httpupload
integer x = 32
integer y = 24
integer width = 1554
integer height = 108
integer textsize = -14
fontcharset fontcharset = hangeul!
long textcolor = 20066866
long backcolor = 32896501
string text = "파일 UPLOAD 현황"
alignment alignment = center!
end type

type dw_filelist from fw_u_dwo within fw_w_httpupload
integer x = 32
integer y = 468
integer width = 1554
integer height = 1020
integer taborder = 10
string dataobject = "fw_d_httptransfer"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
end type

