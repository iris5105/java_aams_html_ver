forward
global type fw_w_bookmark from w_response1st
end type
type cb_1 from pf_u_commandbutton within fw_w_bookmark
end type
type dw_favor from fw_u_dwo within fw_w_bookmark
end type
type p_cancel from pf_u_imagebutton within fw_w_bookmark
end type
type p_ok from pf_u_imagebutton within fw_w_bookmark
end type
type st_2 from pf_u_statictext within fw_w_bookmark
end type
type st_1 from pf_u_statictext within fw_w_bookmark
end type
type st_title from pf_u_statictext within fw_w_bookmark
end type
type p_icon from pf_u_picture within fw_w_bookmark
end type
type cb_2 from pf_u_commandbutton within fw_w_bookmark
end type
end forward

global type fw_w_bookmark from w_response1st
integer width = 2181
integer height = 1068
string title = "Add to Dimension"
cb_1 cb_1
dw_favor dw_favor
p_cancel p_cancel
p_ok p_ok
st_2 st_2
st_1 st_1
st_title st_title
p_icon p_icon
cb_2 cb_2
end type
global fw_w_bookmark fw_w_bookmark

type variables
datawindowchild idwc_1
end variables

on fw_w_bookmark.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_favor=create dw_favor
this.p_cancel=create p_cancel
this.p_ok=create p_ok
this.st_2=create st_2
this.st_1=create st_1
this.st_title=create st_title
this.p_icon=create p_icon
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_favor
this.Control[iCurrent+3]=this.p_cancel
this.Control[iCurrent+4]=this.p_ok
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.p_icon
this.Control[iCurrent+9]=this.cb_2
end on

on fw_w_bookmark.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.dw_favor)
destroy(this.p_cancel)
destroy(this.p_ok)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_title)
destroy(this.p_icon)
destroy(this.cb_2)
end on

event open;call super::open;If not isvalid(message.powerobjectparm) Then
	messagebox('Notice', 'There is no parameter variable value.')
	Close(this)
	Return
End If

If classname(message.powerobjectparm) <> 'n_menu' Then
	messagebox('Notice', 'Invalid object parameter.')
	Close(this)
	Return
End If

inv_menu = message.powerobjectparm
dw_favor.Modify("parent_pgm.dddw.Name='fw_dddw_bookmark_1'")
dw_favor.settransobject(sqlca)
fw_f_setdddw (dw_favor, 'parent_pgm', {gnv_vari.is_sys_id, gaa.login})

dw_favor.getchild('parent_pgm', idwc_1)
idwc_1.insertrow(1)
idwc_1.setitem(1, 'pgm_no', 'ROOT')
idwc_1.setitem(1, 'favor_nm', 'Folder (Not Selectable)')

dw_favor.insertrow(0)
dw_favor.setitem(1, 'sys_id', gnv_vari.is_sys_id)
dw_favor.setitem(1, 'user_id', gaa.login)
dw_favor.setitem(1, 'pgm_no', inv_menu.is_pgm_no)
dw_favor.setitem(1, 'pgm_kind_code', 'P')
dw_favor.setitem(1, 'parent_pgm', 'ROOT')

dw_favor.setcolumn('favor_nm')
dw_favor.setfocus()

end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_bookmark
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_bookmark
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_bookmark
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_bookmark
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_bookmark
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_bookmark
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_bookmark
end type

type cb_1 from pf_u_commandbutton within fw_w_bookmark
integer x = 1737
integer y = 580
integer width = 379
integer height = 104
integer taborder = 20
string text = "폴더생성"
end type

event clicked;call super::clicked;STRING	ls_input, ls_pgm_no, ls_max_seq

IF pf_f_inputdialog('Create folder', 'Enter the name of the new folder to be created', ls_input)=0 Then RETURN
IF isnull(ls_input) or len(TRIM(ls_input))=0 Then RETURN

fw_n_dso lds_favor

LONG	ll_new

lds_favor = CREATE fw_n_dso
lds_favor.dataobject = 'fw_d_bookmark_ds1'
lds_favor.settransobject(SQLCA)

ll_new = lds_favor.insertrow (0)
lds_favor.setitem(ll_new, 'sys_id', gnv_vari.is_sys_id)
lds_favor.setitem(ll_new, 'user_id', gaa.login)

SELECT  max(substr(pgm_no,4,2))
  INTO  :ls_max_seq
FROM    fw_user_favor t1
WHERE   sys_id        = :gnv_vari.is_sys_id
  AND   user_id       = :gaa.login
  AND   pgm_kind_code = 'M'
  AND   pgm_no        LIKE 'FVR%';

ls_max_seq = SQLCA.getitemstring (1)
IF isnull(ls_max_seq) THEN ls_max_seq = '0'
ls_pgm_no = 'FVR' + string(long(ls_max_seq) + 1, '00')

lds_favor.setitem(ll_new, 'pgm_no', ls_pgm_no)
lds_favor.setitem(ll_new, 'favor_nm', ls_input)
lds_favor.setitem(ll_new, 'pgm_kind_code', 'M')
lds_favor.setitem(ll_new, 'parent_pgm', 'ROOT')
lds_favor.setitem(ll_new, 'sort_order', long(ls_max_seq) + 1)

datawindowchild ldwc_1

IF lds_favor.update ()=1 then
   commitJ ()
   IF dw_favor.getchild('parent_pgm', ldwc_1)=1 Then
      ll_new = ldwc_1.insertrow (0)
      ldwc_1.setitem(ll_new, 'pgm_no', ls_pgm_no)
      ldwc_1.setitem(ll_new, 'favor_nm', ls_input)

      dw_favor.setitem(1, 'parent_pgm', ls_pgm_no)
   End IF
else
   rollbackJ ()
   messagebox('Notice', 'Folder creation failed!!~r~n' + lds_favor.istr_dberror.sqlerrtext)
End IF
end event

type dw_favor from fw_u_dwo within fw_w_bookmark
integer x = 128
integer y = 444
integer width = 1966
integer height = 276
integer taborder = 10
string dataobject = "fw_d_bookmark_1"
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'favor_nm'
		pf_f_togglekoreng('k')
	Case Else 
		pf_f_togglekoreng('e')
End Choose
end event

type p_cancel from pf_u_imagebutton within fw_w_bookmark
integer x = 1883
integer y = 844
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

event clicked;call super::clicked;closewithreturn(parent, 'Cancel')

end event

type p_ok from pf_u_imagebutton within fw_w_bookmark
integer x = 1646
integer y = 844
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_add.jpg"
end type

event clicked;call super::clicked;STRING	ls_parent_pgm, ls_pgm_no

LONG	ll_sort_order, ll_cnter

ls_parent_pgm = dw_favor.getitemstring(1, 'parent_pgm')
ls_pgm_no = dw_favor.getitemstring(1, 'pgm_no')
IF ls_parent_pgm='ROOT' Then
   Messagebox('Check', 'You need to create a new folder first.')
   RETURN
End IF

SELECT  count(1)
  INTO  :ll_cnter
FROM    fw_user_favor t1
WHERE   sys_id  = :gnv_vari.is_sys_id
  AND   user_id = :gaa.login
  AND   pgm_no  = :ls_pgm_no;

ll_cnter = SQLCA.getitemnumber (1)
IF ll_cnter>0  Then
   messagebox('Notice', "This program has already been added to Dimension.")
   closewithreturn(parent, 'Cancel')
   RETURN
End IF

//5개 제한
SELECT  count(1)
  INTO  :ll_cnter
FROM    fw_user_favor t1
WHERE   sys_id     = :gnv_vari.is_sys_id
  AND   user_id    = :gaa.login
  AND   parent_pgm = :ls_parent_pgm;

ll_cnter = SQLCA.getitemnumber (1)
IF ll_cnter>=7  Then
   messagebox('알림', "즐겨찾기은 폴더당 7개까지만 등록가능합니다.")
   RETURN
End IF


SELECT  max(sort_order)
  INTO  :ll_sort_order
FROM    fw_user_favor t1
WHERE   sys_id     = :gnv_vari.is_sys_id
  AND   user_id    = :gaa.login
  AND   parent_pgm = :ls_parent_pgm;

ll_sort_order = SQLCA.getitemnumber (1)
IF isnull(ll_sort_order) THEN ll_sort_order = 0
dw_favor.setitem(1, 'sort_order', ll_sort_order + 1)

IF dw_favor.update ()=1 then
   commitJ ()
   messagebox('Notice', 'Dimension Completed')
else
   rollbackJ ()
   choose CASE dw_favor.istr_dberror.sqldbcode
      CASE 1
         messagebox('Notice', "This program has already been added to Dimension.")
         closewithreturn(parent, 'Cancel')
         RETURN
      CASE ELSE
         messagebox('Notice', "Dimension Addition failure!~r~n" + dw_favor.istr_dberror.sqlerrtext)
         closewithreturn(parent, 'Cancel')
         RETURN
   end choose
End IF

IF isnull(parent) Then RETURN
closewithreturn(parent, 'OK')
end event

type st_2 from pf_u_statictext within fw_w_bookmark
integer x = 434
integer y = 304
integer width = 1751
integer height = 84
integer textsize = -12
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 19737901
string text = "즐겨찾기은 왼쪽 별모양아이콘을 통해 사용합니다"
end type

type st_1 from pf_u_statictext within fw_w_bookmark
integer x = 434
integer y = 192
integer width = 1568
integer height = 84
integer textsize = -12
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 19737901
string text = "현재 프로그램을 즐겨찾기에 추가합니다"
end type

type st_title from pf_u_statictext within fw_w_bookmark
integer x = 434
integer y = 64
integer width = 645
integer height = 96
integer textsize = -12
integer weight = 700
long textcolor = 25123896
string text = "즐겨찾기 추가"
alignment alignment = center!
end type

type p_icon from pf_u_picture within fw_w_bookmark
integer x = 5
integer y = 72
integer width = 411
integer height = 360
string picturename = "..\img\mainframe\bookmark\bookmark.jpg"
end type

type cb_2 from pf_u_commandbutton within fw_w_bookmark
integer x = 1737
integer y = 692
integer width = 379
integer height = 104
integer taborder = 30
boolean bringtotop = true
string text = "폴더삭제"
end type

event clicked;call super::clicked;STRING	ls_input

INTEGER	li_net, li_rtn

IF dw_favor.Object.parent_pgm[1]='ROOT'   Then
   Messagebox('Check', 'You can not delete the default folder.')
   RETURN
End IF

ls_input = dw_favor.getitemstring(1, "parent_pgm" )
IF isnull(ls_input) or len(TRIM(ls_input))=0 Then RETURN

Choose CASE ls_input
   CASE '00000' // 즐겨찾기 Root부터 삭제 (전체삭제)
      li_net = messagebox('info', "Are you sure you want to delete the entire dimension?", Exclamation!, OKCancel!, 2)
      IF li_net=1 Then
			DELETE  fw_user_favor
			WHERE   sys_id  = :gnv_vari.is_sys_id
			  AND   user_id = :gaa.login;
      End IF
   CASE Else
      li_rtn = messagebox('info', "If there is a submenu, it will be deleted including subfolders. ~r~n Are you sure you want to delete?", Exclamation!, OKCancel!, 2)
      IF li_rtn=1 Then
			// 하위 메뉴 존재시 하위메뉴 삭제
			DELETE  fw_user_favor
			WHERE   sys_id     = :gnv_vari.is_sys_id
			  AND   user_id    = :gaa.login
			  AND   parent_pgm = :ls_input;
			// 해당 폴더 삭제
			DELETE  fw_user_favor
			WHERE   sys_id  = :gnv_vari.is_sys_id
			  AND   user_id = :gaa.login
			  AND   pgm_no  = :ls_input;
      End IF
End Choose

IF li_net<>2 or li_rtn<>2  Then
   IF SQLCA.sqlcode()<>0   Then
      rollbackJ ()
      messagebox('Notice', 'Failed to delete folder!!~r~n' + SQLCA.sqlerrtext())
   else
      commitJ ()
      messagebox('Notice', 'Folder deleted successfully')

      idwc_1.reset ()
      fw_f_setdddw (dw_favor, 'parent_pgm', {gnv_vari.is_sys_id, gaa.login})
      idwc_1.insertrow (1)
      idwc_1.setitem(1, 'pgm_no', 'ROOT')
      idwc_1.setitem(1, 'favor_nm', 'Dimension')
      dw_favor.setitem(1, 'parent_pgm', 'ROOT')
   End IF
End IF
end event

