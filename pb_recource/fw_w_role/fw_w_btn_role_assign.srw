forward
global type fw_w_btn_role_assign from w_window1st5ncn
end type
type dw_rolepgm from fw_u_dwo within fw_w_btn_role_assign
end type
type st_1 from pf_u_splitbar_vertical within fw_w_btn_role_assign
end type
type tv_fullmenu from pf_u_treeview within fw_w_btn_role_assign
end type
type uo_title1 from fw_u_dw2title within fw_w_btn_role_assign
end type
end forward

global type fw_w_btn_role_assign from w_window1st5ncn
boolean ibconfirmupdate4closequery = true
dw_rolepgm dw_rolepgm
st_1 st_1
tv_fullmenu tv_fullmenu
uo_title1 uo_title1
end type
global fw_w_btn_role_assign fw_w_btn_role_assign

type variables
n_authority	inv_authority
treeview		itv_fullmenu

ads_jTier	ids_fullmenu

fw_m_roletree im_roletree

long il_fullmenu_hndl
end variables

forward prototypes
public function integer of_set_pgm_fullmenu ()
end prototypes

public function integer of_set_pgm_fullmenu ();long	ll_rowcnt, ll_handle, i, ll_level, ll_parent[]

ads_jTier lds_menu

treeviewitem ltvi_item

itv_fullmenu.setredraw (false)

ll_handle = itv_fullmenu.finditem(roottreeitem!, 0)
do while ll_handle > 0
	itv_fullmenu.deleteitem(ll_handle)
	ll_handle = itv_fullmenu.finditem(roottreeitem!, ll_handle)
loop

ll_parent [1] = 0
ll_rowcnt = ids_fullmenu.retrieve(gnv_vari.is_sys_id, 'ROOT', gnv_vari.is_lang_type)
for i = 1 to ll_rowcnt
	ltvi_item.data = ids_fullmenu.getitemstring (i, 'pgm_no')
	ltvi_item.label = ids_fullmenu.getitemstring (i, 'pgm_nm')
	choose case ids_fullmenu.getitemstring (i, 'pgm_kind_code')
		case 'M'
			ltvi_item.PictureIndex = 3
			ltvi_item.SelectedPictureIndex = 4
		case 'P'
			ltvi_item.label = f_nvl (ids_fullmenu.getitemstring(i, 'pgm_go'),'....') + ' ' + ltvi_item.label + ' (' + ids_fullmenu.getitemstring(i, 'pgm_id') + ')'
			ltvi_item.PictureIndex = 1
			ltvi_item.SelectedPictureIndex = 2
	end choose
	ltvi_item.Children = (ids_fullmenu.getitemnumber(i, 'child_cnt') > 0)

	ltvi_item.HasFocus = false
	ltvi_item.selected = false

	ll_level = ids_fullmenu.getitemnumber (i, 'level_no')
	ll_handle = itv_fullmenu.InsertItemLast (ll_parent[ll_level], ltvi_item)
	if ids_fullmenu.getitemstring (i, 'pgm_kind_code') = 'M' then
		ll_parent[ll_level + 1] = ll_handle
	end if
next
ll_handle = tv_fullmenu.finditem(roottreeitem!, 0)
ll_parent [1] = ll_handle
itv_fullmenu.ExpandAll (ll_parent[2])

// scroll back to top
tv_fullmenu.SetFirstVisible (ll_parent[1])
tv_fullmenu.Post selectitem (ll_parent[1])
tv_fullmenu.Post setfocus ()

itv_fullmenu.setredraw (true)

return ll_rowcnt
end function

on fw_w_btn_role_assign.create
int iCurrent
call super::create
this.dw_rolepgm=create dw_rolepgm
this.st_1=create st_1
this.tv_fullmenu=create tv_fullmenu
this.uo_title1=create uo_title1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rolepgm
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.tv_fullmenu
this.Control[iCurrent+4]=this.uo_title1
end on

on fw_w_btn_role_assign.destroy
call super::destroy
destroy(this.dw_rolepgm)
destroy(this.st_1)
destroy(this.tv_fullmenu)
destroy(this.uo_title1)
end on

event open;call super::open;inv_authority = Create n_authority

itv_fullmenu = tv_fullmenu

ids_fullmenu = create ads_jTier
ids_fullmenu.dataobject = 'fw_d_btn_role_assign_ds1_ora'
ids_fullmenu.settransobject(sqlca)

im_roletree = create fw_m_roletree
end event

event wue_postopen;call super::wue_postopen;p_retrieve.post event clicked()
end event

event wue_retrieve;call super::wue_retrieve;of_set_pgm_fullmenu()
end event

event wue_update;call super::wue_update;if of_update({dw_rolepgm}) >= 0 then
	return 0
else
	return -1
end if
end event

event wue_confirmupdate4close;call super::wue_confirmupdate4close;Return 0
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_btn_role_assign
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_btn_role_assign
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_btn_role_assign
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_btn_role_assign
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_btn_role_assign
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_btn_role_assign
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_btn_role_assign
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_btn_role_assign
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_btn_role_assign
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_btn_role_assign
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_btn_role_assign
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_btn_role_assign
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_btn_role_assign
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_btn_role_assign
end type

type st_top_rect from w_window1st5ncn`st_top_rect within fw_w_btn_role_assign
end type

type p_close from w_window1st5ncn`p_close within fw_w_btn_role_assign
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_btn_role_assign
end type

type p_print from w_window1st5ncn`p_print within fw_w_btn_role_assign
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_btn_role_assign
end type

type p_update from w_window1st5ncn`p_update within fw_w_btn_role_assign
end type

type p_input from w_window1st5ncn`p_input within fw_w_btn_role_assign
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_btn_role_assign
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_btn_role_assign
end type

type dw_rolepgm from fw_u_dwo within fw_w_btn_role_assign
integer x = 1499
integer y = 156
integer width = 3931
integer height = 2608
integer taborder = 10
boolean bringtotop = true
string title = "공통 버튼 권한"
string dataobject = "fw_d_btn_role_assign_1"
boolean hscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setedittoken = true
end type

event itemchanged;call super::itemchanged;post event itemchanged_next (row, dwo.name)
end event

event itemchanged_next;call super::itemchanged_next;IF RIGHT (name,3)='_yn' Then
   IF name='update_auth_yn'   Then
      Object.cancel_auth_yn [row] = Object.update_auth_yn [row]
      Object.input_auth_yn [row] = Object.update_auth_yn [row]
      Object.ext1_auth_yn [row] = Object.update_auth_yn [row]
      Object.delete_auth_yn [row] = Object.update_auth_yn [row]
   End IF
   Object.comm_btn_auth_yn [row] = 'Y'
End IF
end event

event clicked;call super::clicked;LONG		ll
STRING	ls_col, ls_yn

IF	RIGHT (dwo.name,2)='_t'	Then
	ls_col = LEFT (dwo.name, LEN(string (dwo.name)) - 2)
	ls_yn = 'N'
	FOR  ll = 1  TO  rowcount ()
		IF	getitemstring (ll, ls_col)='Y'	Then
			ls_yn = 'Y'
			EXIT
		End IF
	NEXT
	FOR  ll = 1  TO  rowcount ()
		setitem (ll, ls_col, IIF (ls_yn='N','Y','N'))
	NEXT
End IF
end event

event doubleclicked;call super::doubleclicked;LONG	ll

IF	dwo.name='role_no'	Then
	IF	f_messageBox ('I002', Object.role_nm [row] + ' 권한으로 맞추겠습니다.')=1	Then
		FOR  ll = 1  TO  rowcount ()
			IF	ll<>row	Then
				Object.cancel_auth_yn [ll] = Object.cancel_auth_yn [row]
				Object.retrieve_auth_yn [ll] = Object.retrieve_auth_yn [row]
				Object.input_auth_yn [ll] = Object.input_auth_yn [row]
				Object.ext1_auth_yn [ll] = Object.ext1_auth_yn [row]
				Object.update_auth_yn [ll] = Object.update_auth_yn [row]
				Object.delete_auth_yn [ll] = Object.delete_auth_yn [row]
				Object.print_auth_yn [ll] = Object.print_auth_yn [row]
				Object.excel_auth_yn [ll] = Object.excel_auth_yn [row]
			End IF
		NEXT
	End IF
End IF
end event

type st_1 from pf_u_splitbar_vertical within fw_w_btn_role_assign
integer x = 1467
integer y = 244
integer width = 23
integer height = 2520
boolean bringtotop = true
boolean setsheetcolor = true
string leftdragobject = "tv_fullmenu"
string rightdragobject = "dw_rolepgm"
end type

type tv_fullmenu from pf_u_treeview within fw_w_btn_role_assign
integer x = 50
integer y = 244
integer width = 1413
integer height = 2520
integer taborder = 20
boolean bringtotop = true
long textcolor = 19737901
boolean linesatroot = true
string picturename[] = {"..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif","Custom039!","Open!"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event rightclicked;call super::rightclicked;treeviewitem ltvi_item

if this.getitem(handle, ltvi_item) = -1 then return

choose case ltvi_item.PictureIndex
	case 3, 4
		il_fullmenu_hndl = handle
		im_roletree.popmenu(iw_parent.pointerx(), iw_parent.pointery())
	case 1, 2
end choose
end event

event selectionchanged;treeviewitem ltvi_item
string ls_pgm_no

of_confirmupdate4rowchanged()

if this.getitem(newhandle, ltvi_item) > 0 then
	ls_pgm_no = ltvi_item.data
	dw_rolepgm.setredraw (false)
	dw_rolepgm.reset()
	dw_rolepgm.retrieve(gnv_vari.is_sys_id, ls_pgm_no)
	dw_rolepgm.setredraw (true)
end if
end event

type uo_title1 from fw_u_dw2title within fw_w_btn_role_assign
integer x = 46
integer y = 156
integer taborder = 30
boolean bringtotop = true
string istitletext = "전체 프로그램 메뉴"
end type

on uo_title1.destroy
call fw_u_dw2title::destroy
end on

