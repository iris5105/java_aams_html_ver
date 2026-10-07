forward
global type fw_w_pgm_help_ent_view from w_response1st
end type
type dw_list from fw_u_dwo within fw_w_pgm_help_ent_view
end type
type p_close from pf_u_imagebutton within fw_w_pgm_help_ent_view
end type
type rte_content from pf_u_richtextedit within fw_w_pgm_help_ent_view
end type
type st_4 from statictext within fw_w_pgm_help_ent_view
end type
type p_1 from picture within fw_w_pgm_help_ent_view
end type
type rr_border from roundrectangle within fw_w_pgm_help_ent_view
end type
type st_3 from statictext within fw_w_pgm_help_ent_view
end type
type st_5 from statictext within fw_w_pgm_help_ent_view
end type
type st_2 from statictext within fw_w_pgm_help_ent_view
end type
type st_1 from statictext within fw_w_pgm_help_ent_view
end type
type st_6 from statictext within fw_w_pgm_help_ent_view
end type
end forward

global type fw_w_pgm_help_ent_view from w_response1st
integer width = 3369
integer height = 2484
string title = "프로그램 도움말 등록"
dw_list dw_list
p_close p_close
rte_content rte_content
st_4 st_4
p_1 p_1
rr_border rr_border
st_3 st_3
st_5 st_5
st_2 st_2
st_1 st_1
st_6 st_6
end type
global fw_w_pgm_help_ent_view fw_w_pgm_help_ent_view

type variables
blob ib_content

n_menu inv_param

end variables

on fw_w_pgm_help_ent_view.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.p_close=create p_close
this.rte_content=create rte_content
this.st_4=create st_4
this.p_1=create p_1
this.rr_border=create rr_border
this.st_3=create st_3
this.st_5=create st_5
this.st_2=create st_2
this.st_1=create st_1
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.rte_content
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.rr_border
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_6
end on

on fw_w_pgm_help_ent_view.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.p_close)
destroy(this.rte_content)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.rr_border)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_6)
end on

event open;call super::open;if not isvalid(message.powerobjectparm) then
	messagebox('Notice', '잘못된 윈도우 호출입니다')
	post close(this)
	return
end if

if message.powerobjectparm.classname() <> 'n_menu' then
	messagebox('Notice', '잘못된 윈도우 호출입니다')
	post close(this)
	return
end if

inv_param = message.powerobjectparm

dw_list.settransobject(sqlca)
dw_list.retrieve(gnv_vari.is_sys_id, inv_param.is_pgm_no)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_pgm_help_ent_view
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_pgm_help_ent_view
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_pgm_help_ent_view
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_pgm_help_ent_view
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_pgm_help_ent_view
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_pgm_help_ent_view
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_pgm_help_ent_view
end type

type dw_list from fw_u_dwo within fw_w_pgm_help_ent_view
boolean visible = false
integer x = 2679
integer y = 152
integer width = 663
integer height = 100
integer taborder = 50
boolean enabled = false
string title = "편집히스토리"
string dataobject = "fw_d_pgm_help_ent_02"
end type

event rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 then Return

string		ls_pgm_no
long		ll_help_seq

ls_pgm_no = this.getitemstring(currentrow, 'pgm_no')
ll_help_seq = this.getitemnumber(currentrow, 'help_seq')

selectblob	help_content
into		:ib_content
from		fw_pgm_help
where	sys_id = :gnv_vari.is_sys_id
and		pgm_no = :ls_pgm_no
and		help_seq = :ll_help_seq;

//ib_content = mo_.hex2blob(SQLCA.is_hexfile)

rte_content.SelectTextAll()
rte_content.Cut()   //Clear()
rte_content.statusbar = false
rte_content.toolbar = false
rte_content.displayonly = true
If rte_content.visible = false then rte_content.visible = true
rte_content.pastertf(string(ib_content))
rte_content.scrolltorow(1)



end event

type p_close from pf_u_imagebutton within fw_w_pgm_help_ent_view
integer x = 3099
integer y = 28
integer width = 229
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;close(parent)

end event

type rte_content from pf_u_richtextedit within fw_w_pgm_help_ent_view
boolean visible = false
integer x = 78
integer y = 252
integer width = 3227
integer height = 2084
integer taborder = 40
boolean bringtotop = true
boolean init_vscrollbar = true
boolean init_wordwrap = true
boolean init_displayonly = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean scaletoright = true
boolean scaletobottom = true
end type

type st_4 from statictext within fw_w_pgm_help_ent_view
integer x = 87
integer y = 160
integer width = 411
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
string text = "도움말"
boolean focusrectangle = false
end type

type p_1 from picture within fw_w_pgm_help_ent_view
integer x = 59
integer y = 160
integer width = 9
integer height = 56
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_icon4comm\menu_delimiter.jpg"
boolean focusrectangle = false
end type

type rr_border from roundrectangle within fw_w_pgm_help_ent_view
long linecolor = 268435456
integer linethickness = 4
long fillcolor = 1073741824
integer x = 50
integer y = 228
integer width = 3278
integer height = 2132
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_3 from statictext within fw_w_pgm_help_ent_view
integer x = 393
integer y = 1168
integer width = 2597
integer height = 172
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 268435456
boolean focusrectangle = false
end type

type st_5 from statictext within fw_w_pgm_help_ent_view
integer x = 393
integer y = 980
integer width = 2597
integer height = 172
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 268435456
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within fw_w_pgm_help_ent_view
integer x = 393
integer y = 776
integer width = 2597
integer height = 172
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 268435456
string text = "등록된 도움말이 없습니다"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within fw_w_pgm_help_ent_view
integer x = 393
integer y = 576
integer width = 2597
integer height = 172
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 268435456
boolean focusrectangle = false
end type

type st_6 from statictext within fw_w_pgm_help_ent_view
integer x = 398
integer y = 1404
integer width = 2597
integer height = 108
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 268435456
boolean focusrectangle = false
end type

