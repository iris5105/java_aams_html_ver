forward
global type w_fw_obj_no_assign from w_window1st1ncn
end type
type dw_no from fw_u_dwo within w_fw_obj_no_assign
end type
type st_1 from pf_u_splitbar_vertical within w_fw_obj_no_assign
end type
type tv_fullmenu from pf_u_treeview within w_fw_obj_no_assign
end type
type uo_1 from fw_u_dw2title within w_fw_obj_no_assign
end type
end forward

global type w_fw_obj_no_assign from w_window1st1ncn
dw_no dw_no
st_1 st_1
tv_fullmenu tv_fullmenu
uo_1 uo_1
end type
global w_fw_obj_no_assign w_fw_obj_no_assign

type variables
treeviewitem   itvi_item

ads_jTier	ids_fullmenu

STRING	ia_pgm []

LONG	il_handle = 0
end variables

on w_fw_obj_no_assign.create
int iCurrent
call super::create
this.dw_no=create dw_no
this.st_1=create st_1
this.tv_fullmenu=create tv_fullmenu
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_no
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.tv_fullmenu
this.Control[iCurrent+4]=this.uo_1
end on

on w_fw_obj_no_assign.destroy
call super::destroy
destroy(this.dw_no)
destroy(this.st_1)
destroy(this.tv_fullmenu)
destroy(this.uo_1)
end on

event open;call super::open;ids_fullmenu = CREATE ads_jTier
ids_fullmenu.dataobject = 'd_fw_obj_no_assign_ds'
ids_fullmenu.settransobject(SQLCA)
end event

event wue_retrieve;call super::wue_retrieve;dw_no.setredraw (false)
dw_no.retrieve ()
dw_no.setredraw (true)

LONG	ll, ll_rowcnt, ll_handle, ll_level, ll_parent []

tv_fullmenu.setredraw (false)

//ll_handle = 1
//DO WHILE ll_handle > 0
//   tv_fullmenu.deleteitem (ll_handle)
//   ll_handle = tv_fullmenu.finditem(roottreeitem!, ll_handle)
//loop

ll_parent [1] = 0
ll_rowcnt = ids_fullmenu.retrieve (gnv_vari.is_sys_id, 'ROOT')
for ll = 1 to ll_rowcnt
	itvi_item.data = ids_fullmenu.getitemstring(ll, 'pgm_no')
	itvi_item.label = ids_fullmenu.getitemstring(ll, 'pgm_nm')
	
   choose CASE ids_fullmenu.getitemstring(ll, 'pgm_kind_code')
      CASE 'M'
         
			choose case ids_fullmenu.getitemnumber(ll, 'tree_level')
				case 1
					itvi_item.PictureIndex = 1
					itvi_item.SelectedPictureIndex = 2
				case 2
					itvi_item.data = '~t' + ids_fullmenu.object.pgm_no [ll] + '~t' + ids_fullmenu.object.pgm_id [ll] + '~t' + ids_fullmenu.object.pgm_nm [ll]
					itvi_item.label = ids_fullmenu.object.pgm_nm [ll]

					itvi_item.PictureIndex = 3
					itvi_item.SelectedPictureIndex = 4
				case 3
					itvi_item.data = '~t' + ids_fullmenu.object.pgm_no [ll] + '~t' + ids_fullmenu.object.pgm_id [ll] + '~t' + ids_fullmenu.object.pgm_nm [ll]
					itvi_item.label = ids_fullmenu.object.pgm_nm [ll]
					
					itvi_item.PictureIndex = 5
					itvi_item.SelectedPictureIndex = 6
			end choose
      CASE 'P'
         itvi_item.data = f_nvl (ids_fullmenu.object.pgm_go [ll],'....') + '~t' + ids_fullmenu.object.pgm_no [ll] + '~t' + ids_fullmenu.object.pgm_id [ll] + '~t' + ids_fullmenu.object.pgm_nm [ll]
         itvi_item.label = f_nvl (ids_fullmenu.object.pgm_go [ll],'....') + ' ' + ids_fullmenu.object.pgm_nm [ll] + ' (' + ids_fullmenu.object.pgm_id [ll] + ')'
			itvi_item.PictureIndex = 7
			itvi_item.SelectedPictureIndex = 8
   end choose
   itvi_item.children = (ids_fullmenu.object.child_cnt [ll] > 0)

   itvi_item.HasFocus = FALSE
   itvi_item.selected = FALSE

   ll_level = ids_fullmenu.object.tree_level [ll]
   ll_handle = tv_fullmenu.InsertItemLast (ll_parent [ll_level], itvi_item)
   IF ids_fullmenu.object.pgm_kind_code [ll]='M' THEN ll_parent[ll_level + 1] = ll_handle
next
//FOR  ll = 1  TO  ll_rowcnt
//	CHOOSE CASE ids_fullmenu.object.pgm_kind_code [ll]
//      CASE 'M'
//         itvi_item.data = '~t' + ids_fullmenu.object.pgm_no [ll] + '~t' + ids_fullmenu.object.pgm_id [ll] + '~t' + ids_fullmenu.object.pgm_nm [ll]
//         itvi_item.label = ids_fullmenu.object.pgm_nm [ll]
//         itvi_item.PictureIndex = 3
//         itvi_item.SelectedPictureIndex = 4
//      CASE 'P'
//         itvi_item.data = f_nvl (ids_fullmenu.object.pgm_go [ll],'....') + '~t' + ids_fullmenu.object.pgm_no [ll] + '~t' + ids_fullmenu.object.pgm_id [ll] + '~t' + ids_fullmenu.object.pgm_nm [ll]
//         itvi_item.label = f_nvl (ids_fullmenu.object.pgm_go [ll],'....') + ' ' + ids_fullmenu.object.pgm_nm [ll] + ' (' + ids_fullmenu.object.pgm_id [ll] + ')'
//         itvi_item.PictureIndex = 5
//         itvi_item.SelectedPictureIndex = 6
//	END CHOOSE
//   itvi_item.children = (ids_fullmenu.object.child_cnt [ll]>0)
//
//   itvi_item.HasFocus = FALSE
//   itvi_item.selected = FALSE
//
//   ll_level = ids_fullmenu.object.tree_level [ll]
//   ll_handle = tv_fullmenu.InsertItemLast (ll_parent [ll_level], itvi_item)
//   IF ids_fullmenu.object.pgm_kind_code [ll]='M' THEN ll_parent[ll_level + 1] = ll_handle
//NEXT
tv_fullmenu.ExpandAll (1)

// scroll back to top
tv_fullmenu.SetFirstVisible (1)
tv_fullmenu.POST selectitem(5)
tv_fullmenu.POST setfocus ()

tv_fullmenu.setredraw (TRUE)
end event

event wue_lastopen;call super::wue_lastopen;p_retrieve.post event clicked()
end event

type lb_dirlist from w_window1st1ncn`lb_dirlist within w_fw_obj_no_assign
end type

type ln_templeft from w_window1st1ncn`ln_templeft within w_fw_obj_no_assign
integer beginx = 59
integer endx = 59
end type

type ln_tempbuttom from w_window1st1ncn`ln_tempbuttom within w_fw_obj_no_assign
end type

type ln_temptop from w_window1st1ncn`ln_temptop within w_fw_obj_no_assign
end type

type ln_tempbutton from w_window1st1ncn`ln_tempbutton within w_fw_obj_no_assign
end type

type ln_tempstart from w_window1st1ncn`ln_tempstart within w_fw_obj_no_assign
end type

type ln_cond1_yline from w_window1st1ncn`ln_cond1_yline within w_fw_obj_no_assign
end type

type ln_dw1_yline from w_window1st1ncn`ln_dw1_yline within w_fw_obj_no_assign
end type

type ln_cond2_yline from w_window1st1ncn`ln_cond2_yline within w_fw_obj_no_assign
end type

type ln_dw2_yline from w_window1st1ncn`ln_dw2_yline within w_fw_obj_no_assign
end type

type ln_tempright from w_window1st1ncn`ln_tempright within w_fw_obj_no_assign
end type

type uo_navi from w_window1st1ncn`uo_navi within w_fw_obj_no_assign
end type

type ln_temptop_shadow from w_window1st1ncn`ln_temptop_shadow within w_fw_obj_no_assign
end type

type st_windelaytime from w_window1st1ncn`st_windelaytime within w_fw_obj_no_assign
end type

type st_top_rect from w_window1st1ncn`st_top_rect within w_fw_obj_no_assign
end type

type p_close from w_window1st1ncn`p_close within w_fw_obj_no_assign
end type

type p_excel from w_window1st1ncn`p_excel within w_fw_obj_no_assign
end type

type p_print from w_window1st1ncn`p_print within w_fw_obj_no_assign
end type

type p_delete from w_window1st1ncn`p_delete within w_fw_obj_no_assign
end type

type p_update from w_window1st1ncn`p_update within w_fw_obj_no_assign
end type

type p_input from w_window1st1ncn`p_input within w_fw_obj_no_assign
end type

type p_retrieve from w_window1st1ncn`p_retrieve within w_fw_obj_no_assign
end type

type p_clear from w_window1st1ncn`p_clear within w_fw_obj_no_assign
end type

type p_copy from w_window1st1ncn`p_copy within w_fw_obj_no_assign
end type

type dw_no from fw_u_dwo within w_fw_obj_no_assign
integer x = 2752
integer y = 156
integer width = 2679
integer height = 2608
integer taborder = 10
boolean bringtotop = true
string title = "화면번호 지정현황"
string dataobject = "d_fw_obj_no_assign"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

event oue_postopen;call super::oue_postopen;dw_no.SetTransObject (SQLCA)
end event

event clicked;call super::clicked;STRING	ls_col, ls_go, ls_id, ls_no

IF	LEFT (dwo.name,10)='obj_check_' OR LEFT (dwo.name,7)='pgm_go_'	Then
	IF	LEFT (dwo.name,10)='obj_check_'	Then
		ls_col = MID (dwo.name,11)
	Else
		ls_col = MID (dwo.name,8)
	End IF
	ls_go = getitemstring (row, 'pgm_go_' + ls_col)
	ls_id = getitemstring (row, 'pgm_id_' + ls_col)
	ls_no = getitemstring (row, 'pgm_no_' + ls_col)

//	messagebox(ls_go, ls_no + ' ' + ls_id)

	IF	f_nvl (ls_no,'null')=ia_pgm [2]	Then
		ia_pgm [1] = '....'
		setitem (row, 'obj_check_' + ls_col, 'N')
		setitem (row, 'pgm_no_' + ls_col, null_s)
		setitem (row, 'pgm_id_' + ls_col, null_s)
		itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
		itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4] + ' (' + ia_pgm [3] + ')'
		tv_fullmenu.setitem (il_handle, itvi_item)
	Else
		IF	ia_pgm [1]='....' And f_null (ls_id)	Then
			setitem (row, 'obj_check_' + ls_col, 'Y')
			setitem (row, 'pgm_no_' + ls_col, ia_pgm [2])
			setitem (row, 'pgm_id_' + ls_col, ia_pgm [3])
			ia_pgm [1] = ls_go
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4] + ' (' + ia_pgm [3] + ')'
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
//			f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
			LONG	ll_tvi
			treeviewitem   ltvi_item
			ll_tvi = tv_fullmenu.FindItem (RootTreeItem!, 0)
			DO WHILE ll_tvi > 0
				tv_fullmenu.getitem (ll_tvi, ltvi_item)
				IF	LEFT (ltvi_item.data,4)=ls_go	Then
					tv_fullmenu.setfocus()
					tv_fullmenu.selectitem (ll_tvi)
					EXIT
				End If
				ll_tvi = tv_fullmenu.FindItem(NextVisibleTreeItem!, ll_tvi)
			LOOP
			RETURN
		End IF
	End IF
	IF ia_pgm [1]='....' Then
		UPDATE  fw_pgm_mst
			SET  pgm_go = :null_s
		WHERE   pgm_no = :ia_pgm[2];
	Else
		UPDATE  fw_pgm_mst
			SET  pgm_go = :ia_pgm [1]
		WHERE   pgm_no = :ia_pgm[2];
	End IF
	update (true, true)
	commitJ ()
End IF
end event

event oue_keydown;call super::oue_keydown;LONG lRow

STRING   ls_num

CHOOSE CASE key
   CASE Key0!, KeyNumpad0!
      ls_num = '0'
   CASE Key1!, KeyNumpad1!
      ls_num = '1'
   CASE Key2!, KeyNumpad2!
      ls_num = '2'
   CASE Key3!, KeyNumpad3!
      ls_num = '3'
   CASE Key4!, KeyNumpad4!
      ls_num = '4'
   CASE Key5!, KeyNumpad5!
      ls_num = '5'
   CASE Key6!, KeyNumpad6!
      ls_num = '6'
   CASE Key7!, KeyNumpad7!
      ls_num = '7'
   CASE Key8!, KeyNumpad8!
      ls_num = '8'
   CASE Key9!, KeyNumpad9!
      ls_num = '9'
   CASE Else
      RETURN
END CHOOSE

IF f_notnull (ls_num)   Then
   lRow = FIND ("pgm_go='" + ls_num + "000'", 1, 10000)
   TITLE = '화면번호 지정현황(' + ls_num + '000)'
	of_settitle4datawindow ()
	IF lRow>0   Then
		setrow (lRow)
		scrolltorow (lRow)
	End IF
End IF
end event

type st_1 from pf_u_splitbar_vertical within w_fw_obj_no_assign
integer x = 2725
integer y = 160
integer width = 23
integer height = 2604
boolean bringtotop = true
boolean setsheetcolor = true
boolean scaletobottom = false
string leftdragobject = "tv_fullmenu"
string rightdragobject = "dw_no"
end type

type tv_fullmenu from pf_u_treeview within w_fw_obj_no_assign
integer x = 59
integer y = 244
integer width = 2656
integer height = 2520
integer taborder = 20
boolean bringtotop = true
long textcolor = 19737901
boolean linesatroot = true
string picturename[] = {"..\img\mainframe\u_treemenu\lvl.1.cl.jpg","..\img\mainframe\u_treemenu\lvl.1.op.jpg","..\img\mainframe\u_treemenu\lvl.3.cl.jpg","..\img\mainframe\u_treemenu\lvl.3.op.jpg","..\img\mainframe\u_treemenu\lvl.5.cl.jpg","..\img\mainframe\u_treemenu\lvl.5.op.jpg","..\img\mainframe\u_treemenu\lvl.9.cl.jpg","..\img\mainframe\u_treemenu\lvl.9.op.jpg"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event selectionchanged;LONG	ll

il_handle = newhandle
IF	getitem(il_handle, itvi_item)>0	Then
	itvi_item.bold = true
	setitem (il_handle, itvi_item)
	f_get_array (string (itvi_item.data), '~t', ia_pgm)	// 화면번호,pgm_no,pgm_id,pgm_nm
	IF	upperbound(ia_pgm) > 3 and ia_pgm [1]<>'menu' And ia_pgm [1]<>'....'	Then
		ll = dw_no.find ("pgm_no='" + ia_pgm [2] + "'", 1, 10000)
		IF	ll>0	Then
			dw_no.setrow (ll)
			dw_no.scrolltorow (ll)
		End IF
	End IF
End IF
end event

event selectionchanging;call super::selectionchanging;IF	il_handle>0	Then
	itvi_item.bold = false
	itvi_item.selected = false
	tv_fullmenu.setitem (il_handle, itvi_item)
End IF
end event

type uo_1 from fw_u_dw2title within w_fw_obj_no_assign
integer x = 50
integer y = 156
integer taborder = 20
boolean bringtotop = true
string istitletext = "전체 프로그램 메뉴"
end type

on uo_1.destroy
call fw_u_dw2title::destroy
end on

