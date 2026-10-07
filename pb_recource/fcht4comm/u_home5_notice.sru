forward
global type u_home5_notice from u_ancestor
end type
type p_right from pf_u_imagebutton within u_home5_notice
end type
type p_left from pf_u_imagebutton within u_home5_notice
end type
type p_confirm from pf_u_imagebutton within u_home5_notice
end type
type dw_list from fw_u_dwo within u_home5_notice
end type
type p_input from pf_u_imagebutton within u_home5_notice
end type
type dw_mast from fw_u_dwo within u_home5_notice
end type
type p_refresh from pf_u_imagebutton within u_home5_notice
end type
type ln_1 from line within u_home5_notice
end type
end forward

global type u_home5_notice from u_ancestor
integer width = 1979
integer height = 592
long backcolor = 16777215
event oue_retrieve ( )
p_right p_right
p_left p_left
p_confirm p_confirm
dw_list dw_list
p_input p_input
dw_mast dw_mast
p_refresh p_refresh
ln_1 ln_1
end type
global u_home5_notice u_home5_notice

type variables
string	is_board_no = '0000001', ia_board_list []

datawindowchild	idwc_dddw
end variables

forward prototypes
public function long of_rowcount ()
end prototypes

event oue_retrieve();STRING	ls_today

ls_today = f_sysdate_str ('yyyymmddHH24miss')

dw_list.retrieve(gnv_vari.is_sys_id, is_board_no, ls_today, iif (gaa.aams, '2200', gaa.corp_gr), gnv_vari.is_user_id)
end event

public function long of_rowcount ();return dw_list.rowcount ()
end function

on u_home5_notice.create
int iCurrent
call super::create
this.p_right=create p_right
this.p_left=create p_left
this.p_confirm=create p_confirm
this.dw_list=create dw_list
this.p_input=create p_input
this.dw_mast=create dw_mast
this.p_refresh=create p_refresh
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_right
this.Control[iCurrent+2]=this.p_left
this.Control[iCurrent+3]=this.p_confirm
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.p_input
this.Control[iCurrent+6]=this.dw_mast
this.Control[iCurrent+7]=this.p_refresh
this.Control[iCurrent+8]=this.ln_1
end on

on u_home5_notice.destroy
call super::destroy
destroy(this.p_right)
destroy(this.p_left)
destroy(this.p_confirm)
destroy(this.dw_list)
destroy(this.p_input)
destroy(this.dw_mast)
destroy(this.p_refresh)
destroy(this.ln_1)
end on

event oue_postopen;call super::oue_postopen;dw_mast.settransobject(sqlca)
dw_list.settransobject(sqlca)

ads_jTier	lds_fullmenu

LONG	ll_x

// 권한검색 후 권한이 있으면 추가
gnv_rolemenu.ids_fullmenudata.setfilter("")
gnv_rolemenu.ids_fullmenudata.filter()
ia_board_list [1] = '0000001' //전체공지
IF gnv_rolemenu.ids_fullmenudata.FIND ("pgm_no='00024'", 1, gnv_rolemenu.ids_fullmenudata.rowcount())>0 THEN ia_board_list [upperbound (ia_board_list) + 1] = '0000002' //회사공지
IF gnv_rolemenu.ids_fullmenudata.FIND ("pgm_no='00850'", 1, gnv_rolemenu.ids_fullmenudata.rowcount())>0 THEN ia_board_list [upperbound (ia_board_list) + 1] = '0000011' //IT개선사항

//권한이 하나인경우 이동버튼 삭제
IF upperbound (ia_board_list)<=1	Then
	p_left.visible = FALSE
	p_right.visible = FALSE
	ll_x = p_right.x - p_refresh.x
	p_refresh.x += ll_x
	p_confirm.x += ll_x
	p_input.x += ll_x
End IF

IF gaa.aams	Then
	p_input.visible = TRUE
	p_confirm.visible = TRUE
Else
	IF is_board_no<>'0000001'	Then
		p_input.visible = TRUE
		p_confirm.visible = TRUE
	End IF
End IF

IF dw_mast.retrieve(gnv_vari.is_sys_id, is_board_no)=0	THEN dw_mast.object.board_desc [1] = '공지사항'
end event

event resize;call super::resize;dw_list.width = newwidth - 29
dw_list.height = newheight - dw_list.y - pixelstounits(1, ypixelstounits!)

//p_refresh.x = dw_list.x + dw_list.width - p_refresh.width
//p_confirm.x = dw_list.x + dw_list.width - p_refresh.width - p_confirm.width - PixelsToUnits(1, xpixelstounits!)
//p_input.x = dw_list.x + dw_list.width - p_refresh.width - p_confirm.width - p_input.width - PixelsToUnits(2, xpixelstounits!)
end event

type p_right from pf_u_imagebutton within u_home5_notice
integer x = 1865
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_right.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;LONG	ll

DATETIME ldtm_today

FOR ll = 1 TO upperbound (ia_board_list)
	IF is_board_no = ia_board_list [ll]	Then
		IF ll = upperbound (ia_board_list) - 1 Then
			enabled = FALSE
			p_left.enabled = TRUE
			is_board_no = ia_board_list [ll + 1]
		ElseIF ll = 1	Then
			enabled = TRUE
			p_left.enabled = TRUE
			is_board_no = ia_board_list [ll + 1]
		Else
			enabled = TRUE
			p_left.enabled = TRUE
			is_board_no = ia_board_list [ll + 1]
		End IF
		EXIT
	End IF
NEXT

//일반회사는 회사공지에만 입력 및 로그조회가 가능하도록
IF NOT gaa.aams	Then
	IF is_board_no<>'0000001'	Then
		p_input.visible = TRUE
		p_confirm.visible = TRUE
	Else
		p_input.visible = FALSE
		p_confirm.visible = FALSE
	End IF
End IF

ldtm_today = fw_f_getymdhh24miss4d()

dw_mast.retrieve(gnv_vari.is_sys_id, is_board_no)
dw_list.retrieve(gnv_vari.is_sys_id, is_board_no, ldtm_today, iif (gaa.aams, '2200', gaa.corp_gr), gnv_vari.is_user_id)
end event

type p_left from pf_u_imagebutton within u_home5_notice
integer x = 1751
integer width = 110
integer height = 96
boolean bringtotop = true
boolean enabled = false
string picturename = "..\img\controls\u_icon4btn\btn_left.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;LONG	ll

DATETIME ldtm_today

FOR ll = 1 TO upperbound (ia_board_list)
	IF is_board_no = ia_board_list [ll]	Then
		IF ll = 2 Then
			enabled = FALSE
			p_right.enabled = TRUE
			is_board_no = ia_board_list [ll - 1]
		ElseIF ll = upperbound (ia_board_list)	Then
			enabled = TRUE
			p_right.enabled = TRUE
			is_board_no = ia_board_list [ll - 1]
		Else
			enabled = TRUE
			p_right.enabled = TRUE
			is_board_no = ia_board_list [ll - 1]
		End IF
	End IF
NEXT

//일반회사는 회사공지에만 입력 및 로그조회가 가능하도록
IF NOT gaa.aams	Then
	IF is_board_no<>'0000001'	Then
		p_input.visible = TRUE
		p_confirm.visible = TRUE
	Else
		p_input.visible = FALSE
		p_confirm.visible = FALSE
	End IF
End IF

ldtm_today = fw_f_getymdhh24miss4d()

dw_mast.retrieve(gnv_vari.is_sys_id, is_board_no)
dw_list.retrieve(gnv_vari.is_sys_id, is_board_no, ldtm_today, iif (gaa.aams, '2200', gaa.corp_gr), gnv_vari.is_user_id)
end event

type p_confirm from pf_u_imagebutton within u_home5_notice
boolean visible = false
integer x = 1522
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\iconbtn_search2.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;CHOOSE CASE is_board_no
	CASE '0000001'
		gnv_rolemenu.of_setopensheet('00025')
	CASE '0000002'
		gnv_rolemenu.of_setopensheet('00026')
	CASE '0000011'
		gnv_rolemenu.of_setopensheet('00851')
END CHOOSE
end event

type dw_list from fw_u_dwo within u_home5_notice
integer x = 9
integer y = 104
integer width = 1966
integer height = 496
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_home5_notice_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean ibdesign4role = false
boolean applydesign = true
boolean ibsetlist4clearselect = true
boolean ibsetlist4singleselect = false
string setlist4fontpointcolor = "read_yn=N=b"
string setlist4backcolor = "255,255,255"
end type

event doubleclicked;call super::doubleclicked;if row = 0 then return

string	ls_rowid, ls_log_yn

ls_rowid = this.getitemstring(row, 'row_id')
ls_log_yn = f_nvl (dw_mast.getitemstring(1, 'make_log_yn'),'N')

openwithparm (fw_w_notice_view, ls_rowid + '~t' + ls_log_yn)

end event

type p_input from pf_u_imagebutton within u_home5_notice
boolean visible = false
integer x = 1408
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_plus.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;CHOOSE CASE is_board_no
	CASE '0000001'
		gnv_rolemenu.of_setopensheet('00023')
	CASE '0000002'
		gnv_rolemenu.of_setopensheet('00024')
	CASE '0000011'
		gnv_rolemenu.of_setopensheet('00850')
END CHOOSE
end event

type dw_mast from fw_u_dwo within u_home5_notice
integer width = 1307
integer height = 96
integer taborder = 10
string dataobject = "d_home5_notice_0"
boolean border = false
boolean livescroll = false
boolean scaletoright = true
end type

type p_refresh from pf_u_imagebutton within u_home5_notice
integer x = 1637
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\iconbtn_reset2.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;Parent.Post event oue_retrieve()
end event

type ln_1 from line within u_home5_notice
long linecolor = 134217738
integer linethickness = 4
integer beginx = -5
integer beginy = 100
integer endx = 1984
integer endy = 100
end type

