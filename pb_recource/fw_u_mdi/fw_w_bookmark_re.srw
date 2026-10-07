forward
global type fw_w_bookmark_re from w_response1st
end type
type cb_new from pf_u_commandbutton within fw_w_bookmark_re
end type
type dw_bookmark from fw_u_dwo within fw_w_bookmark_re
end type
type p_cancel from pf_u_imagebutton within fw_w_bookmark_re
end type
type p_ok from pf_u_imagebutton within fw_w_bookmark_re
end type
type st_2 from pf_u_statictext within fw_w_bookmark_re
end type
type st_1 from pf_u_statictext within fw_w_bookmark_re
end type
type st_title from pf_u_statictext within fw_w_bookmark_re
end type
type p_icon from pf_u_picture within fw_w_bookmark_re
end type
end forward

global type fw_w_bookmark_re from w_response1st
integer width = 2336
integer height = 984
string title = "Dimension Rename"
cb_new cb_new
dw_bookmark dw_bookmark
p_cancel p_cancel
p_ok p_ok
st_2 st_2
st_1 st_1
st_title st_title
p_icon p_icon
end type
global fw_w_bookmark_re fw_w_bookmark_re

type variables

end variables

on fw_w_bookmark_re.create
int iCurrent
call super::create
this.cb_new=create cb_new
this.dw_bookmark=create dw_bookmark
this.p_cancel=create p_cancel
this.p_ok=create p_ok
this.st_2=create st_2
this.st_1=create st_1
this.st_title=create st_title
this.p_icon=create p_icon
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new
this.Control[iCurrent+2]=this.dw_bookmark
this.Control[iCurrent+3]=this.p_cancel
this.Control[iCurrent+4]=this.p_ok
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.p_icon
end on

on fw_w_bookmark_re.destroy
call super::destroy
destroy(this.cb_new)
destroy(this.dw_bookmark)
destroy(this.p_cancel)
destroy(this.p_ok)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_title)
destroy(this.p_icon)
end on

event open;call super::open;long	ll_rowcnt, ll_found, ll_rtn

If not isvalid(message.powerobjectparm) Then
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
dw_bookmark.ModIfy("parent_pgm.dddw.Name='fw_dddw_bookmark_1'")
dw_bookmark.Settransobject(sqlca)

datawindowchild ldwc_1
dw_bookmark.getchild('parent_pgm', ldwc_1)
fw_f_setdddw (dw_bookmark, 'parent_pgm', {gnv_vari.is_sys_id, gaa.login})

ldwc_1.insertrow(1)
ldwc_1.Setitem(1, 'pgm_no', 'ROOT')
ldwc_1.Setitem(1, 'favor_nm', 'Folder (Not Selectable)')

ll_rowcnt = dw_bookmark.Retrieve(gnv_vari.is_sys_id, gaa.login, inv_menu.is_pgm_no)

dw_bookmark.Setcolumn('favor_nm')
dw_bookmark.Setfocus()
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_bookmark_re
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_bookmark_re
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_bookmark_re
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_bookmark_re
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_bookmark_re
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_bookmark_re
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_bookmark_re
end type

type cb_new from pf_u_commandbutton within fw_w_bookmark_re
integer x = 1883
integer y = 580
integer width = 379
integer height = 104
integer taborder = 20
string text = "New Folder"
end type

event clicked;call super::clicked;STRING	ls_input

IF pf_f_inputdialog('Create folder', 'Enter the name of the new folder to be created', ls_input)=0 Then RETURN
IF isnull(ls_input) or len(TRIM(ls_input))=0 Then RETURN

fw_n_dso lds_favor
LONG	ll_new
STRING	ls_pgm_no, ls_max_seq

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

ls_pgm_no = 'FVR' + string(long(ls_max_seq) + 1, '00')

lds_favor.setitem(ll_new, 'pgm_no', ls_pgm_no)
lds_favor.setitem(ll_new, 'favor_nm', ls_input)
lds_favor.setitem(ll_new, 'pgm_kind_code', 'M')
lds_favor.setitem(ll_new, 'parent_pgm', 'ROOT')
lds_favor.setitem(ll_new, 'sort_order', long(ls_max_seq) + 1)

datawindowchild ldwc_1

IF lds_favor.update ()=1 then
   commitJ ()
   IF dw_bookmark.getchild('parent_pgm', ldwc_1)=1 Then
      ll_new = ldwc_1.insertrow (0)
      ldwc_1.setitem(ll_new, 'pgm_no', ls_pgm_no)
      ldwc_1.setitem(ll_new, 'favor_nm', ls_input)

      dw_bookmark.setitem(1, 'parent_pgm', ls_pgm_no)
   End IF
else
   rollbackJ ()
   messagebox('Notice', 'Folder creation failed!!~r~n' + lds_favor.istr_dberror.sqlerrtext)
End IF
end event

type dw_bookmark from fw_u_dwo within fw_w_bookmark_re
integer x = 274
integer y = 444
integer width = 1989
integer height = 276
integer taborder = 10
string dataobject = "fw_d_bookmark_re_1"
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'favor_nm'
		pf_f_togglekoreng('k')
	Case Else 
		pf_f_togglekoreng('e')
End Choose
end event

type p_cancel from pf_u_imagebutton within fw_w_bookmark_re
integer x = 2030
integer y = 776
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

event clicked;call super::clicked;closewithreturn(parent, 'Cancel')

end event

type p_ok from pf_u_imagebutton within fw_w_bookmark_re
integer x = 1792
integer y = 776
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

event clicked;call super::clicked;STRING	ls_parent_pgm, ls_pgm_no, ls_before_parent_pgm
LONG	ll_sort_order, ll_cnter

ls_parent_pgm  = dw_bookmark.getitemstring(1, 'parent_pgm')
ls_pgm_no      = dw_bookmark.getitemstring(1, 'pgm_no')

IF ls_parent_pgm='ROOT' Then
   Messagebox('Check', 'Dimension folder can not be specified.')
   RETURN
End IF

SELECT  count(1)
  INTO  :ll_cnter
FROM    fw_user_favor t1
WHERE   sys_id  = :gnv_vari.is_sys_id
  AND   user_id = :gaa.login
  AND   pgm_no  = :ls_pgm_no;

ll_cnter = SQLCA.getitemnumber (1)
IF ll_cnter<1  Then
   messagebox('Notice', "This program is not registered as a dimension.")
   closewithReturn(parent, 'Cancel')
   RETURN
End IF

// 즐겨찾기 폴더 변경 시에만 순번 Update
ls_before_parent_pgm = dw_bookmark.GetItemString(1, 'parent_pgm', Primary!, TRUE)

IF ls_before_parent_pgm<>ls_parent_pgm Then
   SELECT  max(sort_order)
     INTO  :ll_sort_order
   FROM    fw_user_favor t1
   WHERE   sys_id     = :gnv_vari.is_sys_id
	  AND   user_id    = :gaa.login
     AND   parent_pgm = :ls_parent_pgm;

	ll_sort_order = SQLCA.getitemnumber (1)
   IF isnull(ll_sort_order)   Then ll_sort_order = 0
   dw_bookmark.setitem(1, 'sort_order', ll_sort_order + 1)
End IF

IF dw_bookmark.update ()=1 Then
   commitJ ()
   Messagebox('Notice', 'Dimension Change completed')
else
   rollbackJ ()
	messagebox('Notice', "Dimension Change failed![" + string(dw_bookmark.istr_dberror.sqldbcode) + "]~r~n" + dw_bookmark.istr_dberror.sqlerrtext)
	closewithReturn(parent, 'Cancel')
	RETURN
End IF

IF isnull(parent) Then RETURN

gw_mdi.p_bookmark.post event Clicked()

ClosewithReturn(parent, 'OK')
end event

type st_2 from pf_u_statictext within fw_w_bookmark_re
integer x = 434
integer y = 300
integer width = 1723
integer textsize = -12
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 20132659
string text = "Please enter a name and location to change."
end type

type st_1 from pf_u_statictext within fw_w_bookmark_re
integer x = 434
integer y = 192
integer width = 1874
integer textsize = -12
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 20132659
string text = "You can change the name and location of this dimension."
end type

type st_title from pf_u_statictext within fw_w_bookmark_re
integer x = 434
integer y = 64
integer width = 731
integer height = 96
integer textsize = -12
integer weight = 700
long textcolor = 25123896
string text = "Dimension Rename"
end type

type p_icon from pf_u_picture within fw_w_bookmark_re
integer x = 5
integer y = 72
integer width = 411
integer height = 360
boolean bringtotop = true
string picturename = "..\img\mainframe\bookmark\bookmark.jpg"
end type

