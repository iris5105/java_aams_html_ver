forward
global type fw_u_board from u_ancestor
end type
type p_confirm from pf_u_imagebutton within fw_u_board
end type
type dw_list from fw_u_dwo within fw_u_board
end type
type p_input from pf_u_imagebutton within fw_u_board
end type
type dw_mast from fw_u_dwo within fw_u_board
end type
type p_refresh from pf_u_imagebutton within fw_u_board
end type
end forward

global type fw_u_board from u_ancestor
integer width = 2679
integer height = 548
long backcolor = 32238571
event oue_retrieve ( )
p_confirm p_confirm
dw_list dw_list
p_input p_input
dw_mast dw_mast
p_refresh p_refresh
end type
global fw_u_board fw_u_board

type variables
string	is_board_no = '0000001'

datawindowchild	idwc_dddw
end variables

event oue_retrieve();Long		ll_rtn, ll_row
datetime	ldtm_today

dw_list.AcceptText()

ldtm_today	= fw_f_getymdhh24miss4d()
ll_row = dw_list.Getrow()

dw_list.reset()
If gaa.admin OR gaa.aams OR is_board_no = '0000001'	Then
	// 전체 공지
	ll_rtn = dw_list.retrieve(gnv_vari.is_sys_id, is_board_no, ldtm_today, gnv_vari.is_user_id)
Else
	// 회사별 공지.
	ll_rtn = dw_list.retrieve(gnv_vari.is_sys_id, is_board_no, ldtm_today, gnv_vari.is_user_id)
End If
end event

on fw_u_board.create
int iCurrent
call super::create
this.p_confirm=create p_confirm
this.dw_list=create dw_list
this.p_input=create p_input
this.dw_mast=create dw_mast
this.p_refresh=create p_refresh
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_confirm
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.p_input
this.Control[iCurrent+4]=this.dw_mast
this.Control[iCurrent+5]=this.p_refresh
end on

on fw_u_board.destroy
call super::destroy
destroy(this.p_confirm)
destroy(this.dw_list)
destroy(this.p_input)
destroy(this.dw_mast)
destroy(this.p_refresh)
end on

event resize;call super::resize;dw_list.x = 5
dw_list.width	= newwidth - dw_list.x * 2
dw_list.height	= newheight - dw_list.y - pixelstounits(1, ypixelstounits!)

p_refresh.x = dw_list.x + dw_list.width - p_refresh.width
p_confirm.x = dw_list.x + dw_list.width - p_refresh.width - p_confirm.width - PixelsToUnits(1, xpixelstounits!)
p_input.x = dw_list.x + dw_list.width - p_refresh.width - p_confirm.width - p_input.width - PixelsToUnits(2, xpixelstounits!)
end event

event oue_postopen;call super::oue_postopen;dw_mast.settransobject(sqlca)
dw_list.settransobject(sqlca)

if dw_mast.retrieve(gnv_vari.is_sys_id, is_board_no) = 0 then
	messagebox('Notice', 'board_no 속성을 확인하세요')
	//close(parent)
end if

this.event oue_retrieve()

end event

type p_confirm from pf_u_imagebutton within fw_u_board
integer x = 2450
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\iconbtn_search2.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;Choose Case is_board_no
	Case '0000001','0000011'
		fw_f_setopensheet('00025')
	Case '0000002'
		fw_f_setopensheet('00026')
End Choose
end event

type dw_list from fw_u_dwo within fw_u_board
integer x = 5
integer y = 100
integer width = 2670
integer height = 444
integer taborder = 10
boolean bringtotop = true
string dataobject = "fw_d_uboard_ora1"
boolean vscrollbar = true
boolean livescroll = false
boolean ibsettransobject = true
boolean ibdesign4role = false
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4clearselect = true
string setlist4fontpointcolor = "read_yn=N=d"
end type

event doubleclicked;call super::doubleclicked;if row = 0 then return

string	ls_rowid, ls_log_yn

ls_rowid = this.getitemstring(row, 'row_id')
ls_log_yn = f_nvl (dw_mast.getitemstring(1, 'make_log_yn'),'N')

openwithparm(fw_w_notice_view, ls_rowid + '~t' + ls_log_yn)
end event

type p_input from pf_u_imagebutton within fw_u_board
integer x = 2336
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_plus.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;Choose Case is_board_no
	Case '0000001','0000011'
		fw_f_setopensheet('00023')
	Case '0000002'
		fw_f_setopensheet('00024')
End Choose
end event

type dw_mast from fw_u_dwo within fw_u_board
integer x = 9
integer width = 2309
integer height = 96
integer taborder = 10
string dataobject = "fw_d_uboard_0"
boolean border = false
boolean livescroll = false
boolean scaletoright = true
end type

type p_refresh from pf_u_imagebutton within fw_u_board
integer x = 2565
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\iconbtn_reset2.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;Parent.Post event oue_retrieve()
end event

