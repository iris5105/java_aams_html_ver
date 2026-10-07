forward
global type w_bzinsa01_01 from w_window1st5ncn
end type
type tv_dept from pf_u_treeview within w_bzinsa01_01
end type
type dw_dept from fw_u_dwo within w_bzinsa01_01
end type
type uo_title1 from fw_u_dw2title within w_bzinsa01_01
end type
end forward

global type w_bzinsa01_01 from w_window1st5ncn
string title = "조직관리"
tv_dept tv_dept
dw_dept dw_dept
uo_title1 uo_title1
end type
global w_bzinsa01_01 w_bzinsa01_01

type variables
long				il_parent, il_handle
boolean			ib_redraw = false

ads_jTier			ids_dept
treeviewitem		itvi_Source
treeviewitem		itvi_item, itvi_parent

end variables

forward prototypes
public function integer of_set_pgm_fullmenu ()
public subroutine of_treeviewitem_move (long al_curr_handle, string as_direction)
public function integer of_expand_treeviewitem (long al_handle)
public function integer of_collapse_treeviewitem (long al_handle)
end prototypes

public function integer of_set_pgm_fullmenu ();ads_jTier		lds_menu
long			ll_rowcnt, ll_handle, i
long			ll_level, ll_parent[]
string			ls_pgm_no, ls_pgm_id, ls_pgm_nm, ls_root_dept, ls_sys_id
treeviewitem	ltvi_item
s_empl		lstr_data

tv_dept.setredraw(false)

ll_handle = tv_dept.finditem(roottreeitem!, 0)
do while ll_handle > 0
	tv_dept.deleteitem(ll_handle)
	ll_handle = tv_dept.finditem(roottreeitem!, ll_handle)
loop
ls_sys_id = 'GZ'
ls_root_dept = '2000000'
ll_rowcnt = ids_dept.retrieve(ls_sys_id, ls_root_dept, gnv_vari.is_lang_type)

ll_parent[1] = 0

for i = 1 to ll_rowcnt
	lstr_data.dept_cd		= ids_dept.getitemstring(i, 'dept_cd')
	lstr_data.dept_nm		= ids_dept.getitemstring(i, 'dept_nm')
	lstr_data.dept_parent	= ids_dept.getitemstring(i, 'dept_parent')

	ltvi_item.data = lstr_data
	ltvi_item.label = lstr_data.dept_nm
	If Pos(lstr_data.dept_cd, '000000') > 0 Then
		ltvi_item.PictureIndex = 7
		ltvi_item.SelectedPictureIndex = 8
	Else
		ltvi_item.PictureIndex = 1
		ltvi_item.SelectedPictureIndex = 2
	End If
		
	if ids_dept.getitemnumber(i, 'child_cnt') > 0 then
		ltvi_item.Children = true
	else
		ltvi_item.Children = false
	end if
	
	ll_level = ids_dept.getitemnumber(i, 'level_no')
	ll_handle = tv_dept.InsertItemLast(ll_parent[ll_level], ltvi_item)
	ll_parent[ll_level + 1] = ll_handle	
next

// child item이 없는 node삭제
long ll_tvi, ll_nochild[]

ll_rowcnt = 0
ll_tvi = tv_dept.FindItem(RootTreeItem!, 0)

do while ll_tvi > 0
	tv_dept.getitem(ll_tvi, ltvi_item)
	if ltvi_item.pictureindex = 3 then
		if tv_dept.FindItem(ChildTreeItem!, ll_tvi) = -1 then
			ll_rowcnt ++
			ll_nochild[ll_rowcnt] = ll_tvi
		end if
	end if
	ll_tvi = tv_dept.FindItem(NextVisibleTreeItem!, ll_tvi)
loop

for i = 1 to upperbound(ll_nochild)
	tv_dept.deleteitem(ll_nochild[i])
next

//전체  메뉴 펼치기
long ll_root[]

ll_rowcnt = 0
ll_tvi = tv_dept.FindItem(RootTreeItem!, 0)
do while ll_tvi > 0
	ll_rowcnt ++
	ll_root[ll_rowcnt] = ll_tvi
	ll_tvi = tv_dept.FindItem(NextVisibleTreeItem!, ll_tvi)
loop

for i = 1 to ll_rowcnt
	tv_dept.expandall(ll_root[i])
next

if upperbound(ll_root) > 0 then
	tv_dept.post selectitem(ll_root[1])
end if
tv_dept.setredraw(true)

return ll_rowcnt

end function

public subroutine of_treeviewitem_move (long al_curr_handle, string as_direction);long ll_prev_handle
long ll_next_handle
long ll_new_handle
long ll_parent_handle

tv_dept.setredraw(false)
tv_dept.post setredraw(true)

treeviewitem ltvi_curr_item
treeviewitem ltvi_prev_item
treeviewitem ltvi_next_item
treeviewitem ltvi_parent_item

if tv_dept.getitem(al_curr_handle, ltvi_curr_item) = -1 then return
if ltvi_curr_item.PictureIndex > 2 then
	ltvi_curr_item.expanded = false
//	ltvi_curr_item.expandedonce = false
//	ltvi_curr_item.children = true
end if

choose case as_direction
//	case 'left'
//		ll_parent_handle = tv_dept.finditem(ParentTreeItem!, al_curr_handle)
//		if ll_parent_handle = -1 then return
//		
//		tv_dept.getitem(ll_parent_handle, ltvi_parent_item)
//		if ltvi_parent_item.level = 1 then return
//		
//		ll_prev_handle = tv_dept.finditem(PreviousTreeItem!, ll_parent_handle)
//		if ll_prev_handle = -1 then
//			ll_parent_handle = tv_dept.finditem(ParentTreeItem!, ll_parent_handle)
//			ll_new_handle = tv_dept.insertitemfirst(ll_parent_handle, ltvi_curr_item)
//		else
//			ll_parent_handle = tv_dept.finditem(ParentTreeItem!, ll_prev_handle)
//			ll_new_handle = tv_dept.insertitem(ll_parent_handle, ll_prev_handle, ltvi_curr_item)
//		end if
//		
//		tv_dept.deleteitem(al_curr_handle)
//		tv_dept.post selectitem(ll_new_handle)
		
	case 'upper'
		ll_prev_handle = tv_dept.finditem(PreviousTreeItem!, al_curr_handle)
		if ll_prev_handle = -1 then return
		
		ll_prev_handle = tv_dept.finditem(PreviousTreeItem!, ll_prev_handle)
		if ll_prev_handle = -1 then
			ll_parent_handle = tv_dept.finditem(ParentTreeItem!, al_curr_handle)
			ll_new_handle = tv_dept.insertitemfirst(ll_parent_handle, ltvi_curr_item)
		else
			ll_parent_handle = tv_dept.finditem(ParentTreeItem!, ll_prev_handle)
			ll_new_handle = tv_dept.insertitem(ll_parent_handle, ll_prev_handle, ltvi_curr_item)
		end if
		
		// 폴더면 하위 아이템 이동
		if ltvi_curr_item.PictureIndex > 2 then
			tv_dept.of_movechildren(al_curr_handle, ll_new_handle)
		end if
		
		tv_dept.deleteitem(al_curr_handle)
		tv_dept.post selectitem(ll_new_handle)
		
	case 'lower'
		ll_next_handle = tv_dept.finditem(NextTreeItem!, al_curr_handle)
		if ll_next_handle = -1 then return
		
		ll_parent_handle = tv_dept.finditem(ParentTreeItem!, ll_next_handle)
		ll_new_handle = tv_dept.insertitem(ll_parent_handle, ll_next_handle, ltvi_curr_item)
		
		// 폴더면 하위 아이템 이동
		if ltvi_curr_item.PictureIndex > 2 then
			tv_dept.of_movechildren(al_curr_handle, ll_new_handle)
		end if

		tv_dept.deleteitem(al_curr_handle)
		tv_dept.post selectitem(ll_new_handle)
		
//	case 'right'
//		ll_next_handle = tv_dept.finditem(NextTreeItem!, al_curr_handle)
//		do while ll_next_handle > 0
//			tv_dept.getitem(ll_next_handle, ltvi_next_item)
//			if ltvi_next_item.pictureindex = 3 then
//				ll_new_handle = tv_dept.insertitemfirst(ll_next_handle, ltvi_curr_item)
//				tv_dept.deleteitem(al_curr_handle)
//				tv_dept.post selectitem(ll_new_handle)
//				exit
//			end if
//			ll_next_handle = tv_dept.finditem(NextTreeItem!, ll_next_handle)
//		loop
end choose

//if ltvi_curr_item.PictureIndex = 3 then
//	tv_dept.expanditem(ll_new_handle)
//end if

// pf_pgm_mst 테이블 parent_pgm 수정
string ls_pgm_no
string ls_parent_pgm
string ls_errtext

ll_parent_handle = tv_dept.finditem(ParentTreeItem!, ll_new_handle)
tv_dept.getitem(ll_parent_handle, ltvi_parent_item)

ls_pgm_no = string(ltvi_curr_item.data)
ls_parent_pgm = string(ltvi_parent_item.data)

update	fw_pgm_mst
set		parent_pgm = :ls_parent_pgm,
		tree_level = :ltvi_parent_item.level + 1
where	sys_id = :gnv_vari.is_sys_id
and		pgm_no = :ls_pgm_no;

// pf_pgm_mst 테이블 sort_order 수정
long ll_child_handle
long ll_sort_order
treeviewitem ltvi_child_item

ll_child_handle = tv_dept.finditem(ChildTreeItem!, ll_parent_handle)
do while ll_child_handle > 0
	tv_dept.getitem(ll_child_handle, ltvi_child_item)
	ls_pgm_no = string(ltvi_child_item.data)
	ll_sort_order ++
	
	update	fw_pgm_mst
	set			sort_order = :ll_sort_order
	where	sys_id = :gnv_vari.is_sys_id
	and		pgm_no = :ls_pgm_no;
	
	ll_child_handle = tv_dept.finditem(NextTreeItem!, ll_child_handle)
loop

commitJ()
return

end subroutine

public function integer of_expand_treeviewitem (long al_handle);// Expand TreeViewItem
long ll_rc

ll_rc = tv_dept.ExpandAll(al_handle)
tv_dept.SetFirstVisible(al_handle)

return ll_rc

end function

public function integer of_collapse_treeviewitem (long al_handle);return tv_dept.CollapseItem(al_handle)
end function

on w_bzinsa01_01.create
int iCurrent
call super::create
this.tv_dept=create tv_dept
this.dw_dept=create dw_dept
this.uo_title1=create uo_title1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_dept
this.Control[iCurrent+2]=this.dw_dept
this.Control[iCurrent+3]=this.uo_title1
end on

on w_bzinsa01_01.destroy
call super::destroy
destroy(this.tv_dept)
destroy(this.dw_dept)
destroy(this.uo_title1)
end on

event wue_retrieve;call super::wue_retrieve;of_set_pgm_fullmenu()
end event

event wue_postopen;call super::wue_postopen;Post Event wue_retrieve2ready()
end event

event wue_update;call super::wue_update;if of_update({dw_dept}) >= 0 then
	return 0
else
	return -1
end if
end event

event wue_clear;call super::wue_clear;ids_dept = Create ads_jTier
ids_dept.dataobject = 'd_bzinsa01_01_ds1_spc'
ids_dept.settransobject(sqlca)

dw_dept.settransobject(sqlca)

end event

type ln_templeft from w_window1st5ncn`ln_templeft within w_bzinsa01_01
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_bzinsa01_01
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_bzinsa01_01
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_bzinsa01_01
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_bzinsa01_01
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_bzinsa01_01
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_bzinsa01_01
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_bzinsa01_01
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_bzinsa01_01
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_bzinsa01_01
end type

type uo_navi from w_window1st5ncn`uo_navi within w_bzinsa01_01
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_bzinsa01_01
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_bzinsa01_01
end type

type p_close from w_window1st5ncn`p_close within w_bzinsa01_01
end type

type p_excel from w_window1st5ncn`p_excel within w_bzinsa01_01
end type

type p_print from w_window1st5ncn`p_print within w_bzinsa01_01
end type

type p_delete from w_window1st5ncn`p_delete within w_bzinsa01_01
end type

type p_update from w_window1st5ncn`p_update within w_bzinsa01_01
end type

type p_input from w_window1st5ncn`p_input within w_bzinsa01_01
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_bzinsa01_01
end type

type p_clear from w_window1st5ncn`p_clear within w_bzinsa01_01
end type

type tv_dept from pf_u_treeview within w_bzinsa01_01
integer x = 50
integer y = 244
integer width = 1806
integer height = 2520
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 20132659
boolean disabledragdrop = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif","..\img\mainframe\u_treemenu\lvl4close.gif","..\img\mainframe\u_treemenu\lvl4open.gif","..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event selectionchanged;String		ls_dept_cd, ls_sys_id
Long		ll_handle

treeviewitem		ltvi_item
s_empl			lstr_data

ll_handle = newhandle
this.getitem(ll_handle, ltvi_item)
lstr_data = ltvi_item.data
ls_dept_cd = lstr_data.dept_cd
ls_sys_id = 'GZ'
dw_dept.retrieve(ls_sys_id, ls_dept_cd)
return 0
end event

type dw_dept from fw_u_dwo within w_bzinsa01_01
integer x = 1879
integer y = 244
integer width = 3552
integer height = 2520
integer taborder = 20
string title = "조직상세"
string dataobject = "d_bzinsa01_01_1"
richtexttoolbaractivation richtexttoolbaractivation = richtexttoolbaractivationalways!
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

event clicked;call super::clicked;IF row = 0 THEN return

Choose Case dwo.name
	Case 'p_emp_id'
		pf_n_hashtable	lnv_data
		lnv_data = Create pf_n_hashtable
		lnv_data.of_put('title', '직원 조회')
		
		openwithparm(w_bzemp_pop1, lnv_data)
		lnv_data = Message.PowerObjectparm
		
		IF IsValid(lnv_data) THEN
			dw_dept.setitem(1, 'emp_id',lnv_data.of_getString('user_id'))
			dw_dept.setitem(1, 'emp_knm',lnv_data.of_getString('user_nm')) 
		else
			dw_dept.setitem(1, 'emp_id','')
			dw_dept.setitem(1, 'emp_knm','') 
		END IF
End Choose
end event

type uo_title1 from fw_u_dw2title within w_bzinsa01_01
integer x = 50
integer y = 164
integer taborder = 100
boolean bringtotop = true
string istitletext = "조직"
end type

on uo_title1.destroy
call fw_u_dw2title::destroy
end on

