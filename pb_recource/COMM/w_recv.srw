forward
global type w_recv from w_response1st
end type
type hpb from hprogressbar within w_recv
end type
type st_t_name from pf_u_statictext within w_recv
end type
type st_f_name from pf_u_statictext within w_recv
end type
type st_2 from pf_u_statictext within w_recv
end type
type st_1 from pf_u_statictext within w_recv
end type
type st_t_ip from pf_u_statictext within w_recv
end type
type st_f_ip from pf_u_statictext within w_recv
end type
type st_t from pf_u_statictext within w_recv
end type
type st_f from pf_u_statictext within w_recv
end type
type cb_1 from pf_u_commandbutton within w_recv
end type
type st_recv from pf_u_statictext within w_recv
end type
end forward

global type w_recv from w_response1st
integer x = 1056
integer y = 484
integer width = 1330
integer height = 644
long backcolor = 79741120
event ue_open ( )
hpb hpb
st_t_name st_t_name
st_f_name st_f_name
st_2 st_2
st_1 st_1
st_t_ip st_t_ip
st_f_ip st_f_ip
st_t st_t
st_f st_f
cb_1 cb_1
st_recv st_recv
end type
global w_recv w_recv

type prototypes

end prototypes

type variables
INT   li_close = 1

end variables

event ue_open();//uo_wininet  wininet

STRING	ls_result

//wininet = message.PowerObjectParm
//st_f_ip.text = wininet.ftp.ip
//st_f_name.text = wininet.ftp.host_file_name
//st_t_ip.text = 'c:\down'
//st_t_name.text = wininet.ftp.local_file_name
//
//wininet.ihpb       = hpb
//wininet.ist_Text   = st_recv
//
//IF  wininet.uf_FTP_Connect ()>0   Then
// ls_result = wininet.uf_FTP_ReadFile ()
// IF LenA (ls_result)>0   Then
//    f_messageBox ('ERR', ls_result + '~r~n(' + wininet.ftp.local_file_name + ') 파일이 없습니다.')
//    li_Close = -1
// End IF
//Else
// li_Close = -1
//End IF

CloseWithReturn (THIS, li_Close)

end event

on w_recv.create
int iCurrent
call super::create
this.hpb=create hpb
this.st_t_name=create st_t_name
this.st_f_name=create st_f_name
this.st_2=create st_2
this.st_1=create st_1
this.st_t_ip=create st_t_ip
this.st_f_ip=create st_f_ip
this.st_t=create st_t
this.st_f=create st_f
this.cb_1=create cb_1
this.st_recv=create st_recv
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb
this.Control[iCurrent+2]=this.st_t_name
this.Control[iCurrent+3]=this.st_f_name
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_t_ip
this.Control[iCurrent+7]=this.st_f_ip
this.Control[iCurrent+8]=this.st_t
this.Control[iCurrent+9]=this.st_f
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.st_recv
end on

on w_recv.destroy
call super::destroy
destroy(this.hpb)
destroy(this.st_t_name)
destroy(this.st_f_name)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_t_ip)
destroy(this.st_f_ip)
destroy(this.st_t)
destroy(this.st_f)
destroy(this.cb_1)
destroy(this.st_recv)
end on

event open;call super::open;PostEvent ('ue_Open')
end event

type hpb from hprogressbar within w_recv
integer x = 55
integer y = 328
integer width = 1216
integer height = 84
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_t_name from pf_u_statictext within w_recv
integer x = 306
integer y = 252
integer width = 987
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long textcolor = 32768
long backcolor = 67108864
end type

type st_f_name from pf_u_statictext within w_recv
integer x = 306
integer y = 96
integer width = 987
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long textcolor = 128
long backcolor = 67108864
end type

type st_2 from pf_u_statictext within w_recv
integer x = 18
integer y = 252
integer width = 270
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long backcolor = 67108864
string text = "Filename"
alignment alignment = right!
end type

type st_1 from pf_u_statictext within w_recv
integer x = 18
integer y = 96
integer width = 270
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long backcolor = 67108864
string text = "Filename"
alignment alignment = right!
end type

type st_t_ip from pf_u_statictext within w_recv
integer x = 306
integer y = 188
integer width = 987
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long textcolor = 32768
long backcolor = 67108864
string text = "load directory"
end type

type st_f_ip from pf_u_statictext within w_recv
integer x = 306
integer y = 32
integer width = 987
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long textcolor = 128
long backcolor = 67108864
string text = "ip address"
end type

type st_t from pf_u_statictext within w_recv
integer x = 18
integer y = 188
integer width = 270
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long backcolor = 67108864
string text = "To"
alignment alignment = right!
end type

type st_f from pf_u_statictext within w_recv
integer x = 18
integer y = 32
integer width = 270
integer height = 52
integer textsize = -9
fontcharset fontcharset = hangeul!
string facename = "굴림"
long backcolor = 67108864
string text = "From"
alignment alignment = right!
end type

type cb_1 from pf_u_commandbutton within w_recv
integer x = 987
integer y = 432
integer width = 297
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
string facename = "굴림"
string text = "작업 취소"
end type

event clicked;li_Close = -1
end event

type st_recv from pf_u_statictext within w_recv
integer x = 27
integer y = 448
integer width = 951
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
alignment alignment = center!
end type

