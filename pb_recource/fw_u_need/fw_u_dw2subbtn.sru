forward
global type fw_u_dw2subbtn from u_ancestor
end type
type p_delete from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_copy from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_input from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_excel from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_load from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_save from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_firstpage from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_priorpage from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_nextpage from pf_u_imagebutton within fw_u_dw2subbtn
end type
type p_lastpage from pf_u_imagebutton within fw_u_dw2subbtn
end type
end forward

global type fw_u_dw2subbtn from u_ancestor
integer width = 997
integer height = 84
long backcolor = 553648127
boolean setsheetcolor = true
p_delete p_delete
p_copy p_copy
p_input p_input
p_excel p_excel
p_load p_load
p_save p_save
p_firstpage p_firstpage
p_priorpage p_priorpage
p_nextpage p_nextpage
p_lastpage p_lastpage
end type
global fw_u_dw2subbtn fw_u_dw2subbtn

type variables
n_menu		inv_menu
string			iswindowtype
boolean		ibconfirmlogs4stats
end variables

forward prototypes
public function string of_thisname ()
public subroutine of_setbuttonauth (string as_auth)
end prototypes

public function string of_thisname ();return 'fw_u_dw2subbtn'
end function

public subroutine of_setbuttonauth (string as_auth);CONSTANT INT BUTTON_COUNT = 10
CONSTANT INT BUTTON_GAP = 8

INT	i, li_visiblecnt = 0
long	ll_xpos

picture  lp_visible[]

this.setredraw(false)
this.post setredraw(true)

// 초기화.
p_save.visible = false
p_load.visible = false
p_excel.visible = false
p_input.visible = false
p_copy.visible = false
p_delete.visible = false
p_firstpage.visible = false
p_priorpage.visible = false
p_nextpage.visible = false
p_lastpage.visible = false

FOR i = 1 TO BUTTON_COUNT
	IF	Mid(as_auth, i, 1) = '1'	Then
		li_visiblecnt ++
		Choose Case i
			Case 1
				p_save.Visible = true
				lp_visible[li_visiblecnt] = p_save
			Case 2
				p_load.Visible = true				
				lp_visible[li_visiblecnt] = p_load
			Case 3
				p_excel.Visible = true
				lp_visible[li_visiblecnt] = p_excel
			Case 4
				p_input.Visible = true
				lp_visible[li_visiblecnt] = p_input
			Case 5
				p_copy.Visible = true
				lp_visible[li_visiblecnt] = p_copy
			Case 6
				p_delete.Visible = true
				lp_visible[li_visiblecnt] = p_delete
			Case 7
				p_firstpage.Visible = true
				lp_visible[li_visiblecnt] = p_firstpage
			Case 8
				p_priorpage.Visible = true
				lp_visible[li_visiblecnt] = p_priorpage
			Case 9
				p_nextpage.Visible = true
				lp_visible[li_visiblecnt] = p_nextpage
			Case 10
				p_lastpage.Visible = true
				lp_visible[li_visiblecnt] = p_lastpage
		END Choose
	END IF
NEXT

ll_xpos = this.Width
for i = li_visiblecnt to 1 step -1
	If i = li_visiblecnt Then
		lp_visible[i].x = ll_xpos - lp_visible[i].width
	Else
		lp_visible[i].x = ll_xpos - lp_visible[i].width - BUTTON_GAP
	End If
	ll_xpos = lp_visible[i].x
next
this.setredraw(true)
return
end subroutine

on fw_u_dw2subbtn.create
int iCurrent
call super::create
this.p_delete=create p_delete
this.p_copy=create p_copy
this.p_input=create p_input
this.p_excel=create p_excel
this.p_load=create p_load
this.p_save=create p_save
this.p_firstpage=create p_firstpage
this.p_priorpage=create p_priorpage
this.p_nextpage=create p_nextpage
this.p_lastpage=create p_lastpage
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_delete
this.Control[iCurrent+2]=this.p_copy
this.Control[iCurrent+3]=this.p_input
this.Control[iCurrent+4]=this.p_excel
this.Control[iCurrent+5]=this.p_load
this.Control[iCurrent+6]=this.p_save
this.Control[iCurrent+7]=this.p_firstpage
this.Control[iCurrent+8]=this.p_priorpage
this.Control[iCurrent+9]=this.p_nextpage
this.Control[iCurrent+10]=this.p_lastpage
end on

on fw_u_dw2subbtn.destroy
call super::destroy
destroy(this.p_delete)
destroy(this.p_copy)
destroy(this.p_input)
destroy(this.p_excel)
destroy(this.p_load)
destroy(this.p_save)
destroy(this.p_firstpage)
destroy(this.p_priorpage)
destroy(this.p_nextpage)
destroy(this.p_lastpage)
end on

event resize;//
end event

event constructor;call super::constructor;//idw_target = message.PowerObjectParm
end event

event oue_components;// ancestor override
Return false
end event

type p_delete from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 503
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_del.jpg"
end type

event clicked;call super::clicked;ibconfirmlogs4stats = iw_parent.dynamic of_getconfirmlogs4stats()
if ibconfirmlogs4stats then
	iswindowtype = iw_parent.dynamic of_getwindowtype()
	inv_menu = iw_parent.dynamic of_getwindowmenu()
	fw_f_setlog4pgm('sy1001011', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, iswindowtype, '', iswindowtype + ' / ' + idw_target.classname() + ' subbtn')
end if
idw_target.PostEvent("oue_subbtn_delete")
end event

type p_copy from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 402
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_copy.jpg"
end type

event clicked;call super::clicked;idw_target.PostEvent("oue_subbtn_copy")
end event

type p_input from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 302
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_add.jpg"
end type

event clicked;call super::clicked;ibconfirmlogs4stats = iw_parent.dynamic of_getconfirmlogs4stats()
if ibconfirmlogs4stats then
	iswindowtype = iw_parent.dynamic of_getwindowtype()
	inv_menu = iw_parent.dynamic of_getwindowmenu()
	fw_f_setlog4pgm('sy1001007', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, iswindowtype, '', iswindowtype + ' / ' + idw_target.classname() + ' subbtn')
end if
idw_target.PostEvent("oue_subbtn_input")
end event

type p_excel from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 201
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_exel.jpg"
end type

event clicked;call super::clicked;ibconfirmlogs4stats = iw_parent.dynamic of_getconfirmlogs4stats()
if ibconfirmlogs4stats then
	iswindowtype = iw_parent.dynamic of_getwindowtype()
	inv_menu = iw_parent.dynamic of_getwindowmenu()
	fw_f_setlog4pgm('sy1001013', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, iswindowtype, '', iswindowtype + ' / ' + idw_target.classname() + ' subbtn')
end if
idw_target.PostEvent("oue_subbtn_excel")
end event

type p_load from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 101
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_download.jpg"
end type

event clicked;call super::clicked;ibconfirmlogs4stats = iw_parent.dynamic of_getconfirmlogs4stats()
if ibconfirmlogs4stats then
	iswindowtype = iw_parent.dynamic of_getwindowtype()
	inv_menu = iw_parent.dynamic of_getwindowmenu()
	fw_f_setlog4pgm('sy1001006', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, iswindowtype, '', iswindowtype + ' / ' + idw_target.classname() + ' subbtn')
end if
idw_target.PostEvent("oue_subbtn_load")
end event

type p_save from pf_u_imagebutton within fw_u_dw2subbtn
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_save.jpg"
end type

event clicked;call super::clicked;ibconfirmlogs4stats = iw_parent.dynamic of_getconfirmlogs4stats()
if ibconfirmlogs4stats then
	iswindowtype = iw_parent.dynamic of_getwindowtype()
	inv_menu = iw_parent.dynamic of_getwindowmenu()
	fw_f_setlog4pgm('sy1001010', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, iswindowtype, '', iswindowtype + ' / ' + idw_target.classname() + ' subbtn')
end if
idw_target.PostEvent("oue_subbtn_save")
end event

type p_firstpage from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 603
integer width = 91
integer height = 80
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_first.jpg"
end type

event clicked;call super::clicked;idw_target.PostEvent("oue_subbtn_firstpage")
end event

type p_priorpage from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 704
integer width = 91
integer height = 80
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_prev.jpg"
end type

event clicked;call super::clicked;idw_target.PostEvent("oue_subbtn_priorpage")
end event

type p_nextpage from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 805
integer width = 91
integer height = 80
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_next.jpg"
end type

event clicked;call super::clicked;idw_target.PostEvent("oue_subbtn_nextpage")
end event

type p_lastpage from pf_u_imagebutton within fw_u_dw2subbtn
integer x = 905
integer width = 91
integer height = 80
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_end.jpg"
end type

event clicked;call super::clicked;idw_target.PostEvent("oue_subbtn_lastpage")
end event

