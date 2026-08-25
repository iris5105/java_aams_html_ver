forward
global type fw_w_pgm_mst from w_window1st5ncn
end type
type tv_fullmenu from pf_u_treeview within fw_w_pgm_mst
end type
type cbx_expand from pf_u_checkbox within fw_w_pgm_mst
end type
type dw_pgm from fw_u_dwo within fw_w_pgm_mst
end type
type cb_1 from pf_u_commandbutton within fw_w_pgm_mst
end type
type uo_1 from fw_u_dw2title within fw_w_pgm_mst
end type
type cb_2 from commandbutton within fw_w_pgm_mst
end type
type cb_3 from commandbutton within fw_w_pgm_mst
end type
end forward

global type fw_w_pgm_mst from w_window1st5ncn
string title = "프로그램 정보관리"
boolean ibconfirmupdate4closequery = true
boolean ibconfirmupdate4message = false
event ue_menu_notify ( string as_menu_name )
tv_fullmenu tv_fullmenu
cbx_expand cbx_expand
dw_pgm dw_pgm
cb_1 cb_1
uo_1 uo_1
cb_2 cb_2
cb_3 cb_3
end type
global fw_w_pgm_mst fw_w_pgm_mst

type variables
ads_jTier			ids_fullmenu
fw_m_pgm_mst	im_pgm_mst
treeviewitem	itvi_item, itvi_parent
treeviewitem	itvi_Source

long	il_parent, il_handle, il_new
long	il_DragSource, il_DragParent, il_DropTarget
end variables

forward prototypes
public function integer of_set_pgm_fullmenu ()
public subroutine of_treeviewitem_move (long al_curr_handle, string as_direction)
public function integer of_expand_treeviewitem (long al_handle)
public function integer of_collapse_treeviewitem (long al_handle)
end prototypes

event ue_menu_notify(string as_menu_name);choose case as_menu_name
	case 'm_add'
		p_input.post event clicked()
	case 'm_delete'
		p_delete.post event clicked()
	case 'm_upper'
		of_treeviewitem_move(il_handle, 'upper')
	case 'm_lower'
		of_treeviewitem_move(il_handle, 'lower')
//	case 'm_left'
//		of_treeviewitem_move(il_handle, 'left')
//	case 'm_right'
//		of_treeviewitem_move(il_handle, 'right')
	case 'm_expand'
		of_expand_treeviewitem(il_handle)
	case 'm_collapse'
		of_collapse_treeviewitem(il_handle)
end choose
end event

public function integer of_set_pgm_fullmenu ();long	ll_rowcnt, ll_handle, i, ll_roothndl

treeviewitem	ltvi_item

tv_fullmenu.setredraw(false)
tv_fullmenu.post setredraw(true)

ll_handle = tv_fullmenu.finditem(roottreeitem!, 0)
do while ll_handle > 0
	tv_fullmenu.deleteitem(ll_handle)
	ll_handle = tv_fullmenu.finditem(roottreeitem!, ll_handle)
loop

ll_rowcnt = ids_fullmenu.retrieve(gnv_vari.is_lang_type, gnv_vari.is_sys_id, 'ROOT')

for i = 1 to ll_rowcnt
	ltvi_item.data = ids_fullmenu.getitemstring(i, 'pgm_no')
	ltvi_item.label = ids_fullmenu.getitemstring(i, 'pgm_nm')
	
   choose CASE ids_fullmenu.getitemstring(i, 'pgm_kind_code')
      CASE 'M'
			choose case ids_fullmenu.getitemnumber(i, 'tree_level')
				case 1
					ltvi_item.PictureIndex = 1
					ltvi_item.SelectedPictureIndex = 2
				case 2
					ltvi_item.PictureIndex = 3
					ltvi_item.SelectedPictureIndex = 4
				case 3
					ltvi_item.PictureIndex = 5
					ltvi_item.SelectedPictureIndex = 6
			end choose
      CASE 'P'
         IF	f_notnull (ids_fullmenu.getitemstring(i, 'pgm_id')) THEN ltvi_item.label += ' (' + ids_fullmenu.getitemstring(i, 'pgm_id') + ')'
			ltvi_item.PictureIndex = 7
			ltvi_item.SelectedPictureIndex = 8
   end choose
	
//	Choose Case ids_fullmenu.getitemstring(i, 'pgm_kind_code')
//		Case 'M'
//			If ltvi_item.data = '00000' Then
//				ltvi_item.PictureIndex = 1
//				ltvi_item.SelectedPictureIndex = 2
//			Else
//				ltvi_item.label += ' (' + ids_fullmenu.getitemstring(i, 'pgm_no') + ')'
//				ltvi_item.PictureIndex = 3
//				ltvi_item.SelectedPictureIndex = 4				
//			End If
//		Case 'P'
//			IF	f_notnull (ids_fullmenu.getitemstring(i, 'pgm_id')) THEN ltvi_item.label += ' (' + ids_fullmenu.getitemstring(i, 'pgm_id') + ')'
//			ltvi_item.PictureIndex = 5
//			ltvi_item.SelectedPictureIndex = 6
//	End Choose

	ltvi_item.Children = (ids_fullmenu.getitemnumber(i, 'child_cnt') > 0)

	ll_handle = tv_fullmenu.InsertItemLast(0, ltvi_item)
next

// expand top level items only
ll_handle = tv_fullmenu.finditem(roottreeitem!, 0)
ll_roothndl = ll_handle
do while ll_handle > 0
	if cbx_expand.checked = true then
		tv_fullmenu.expandall(ll_handle)
	else
		tv_fullmenu.expanditem(ll_handle)
	end if
	ll_handle = tv_fullmenu.finditem(NextTreeItem!, ll_handle)
loop

// scroll back to top
tv_fullmenu.SetFirstVisible(ll_roothndl)

// select first treeviewitem
tv_fullmenu.Post selectitem(ll_roothndl)

return ll_rowcnt
end function

public subroutine of_treeviewitem_move (long al_curr_handle, string as_direction);LONG	ll_prev_handle, ll_next_handle, ll_new_handle, ll_parent_handle

treeviewitem   ltvi_curr_item, ltvi_parent_item

IF tv_fullmenu.getitem(al_curr_handle, ltvi_curr_item)=-1   Then RETURN
IF ltvi_curr_item.PictureIndex>2 Then ltvi_curr_item.expanded = FALSE

choose CASE as_direction
   CASE 'upper'
      ll_prev_handle = tv_fullmenu.finditem(PreviousTreeItem!, al_curr_handle)
      IF ll_prev_handle=-1 Then RETURN

      ll_prev_handle = tv_fullmenu.finditem(PreviousTreeItem!, ll_prev_handle)
      IF ll_prev_handle=-1 Then
         ll_parent_handle = tv_fullmenu.finditem(ParentTreeItem!, al_curr_handle)
         ll_new_handle = tv_fullmenu.insertitemfirst(ll_parent_handle, ltvi_curr_item)
      else
         ll_parent_handle = tv_fullmenu.finditem(ParentTreeItem!, ll_prev_handle)
         ll_new_handle = tv_fullmenu.insertitem(ll_parent_handle, ll_prev_handle, ltvi_curr_item)
      End IF

      // 폴더면 하위 아이템 이동
      IF ltvi_curr_item.PictureIndex>2 Then
         tv_fullmenu.of_movechildren(al_curr_handle, ll_new_handle)
      End IF

      tv_fullmenu.deleteitem(al_curr_handle)
      tv_fullmenu.POST selectitem(ll_new_handle)

   CASE 'lower'
      ll_next_handle = tv_fullmenu.finditem(NextTreeItem!, al_curr_handle)
      IF ll_next_handle=-1 Then RETURN

      ll_parent_handle = tv_fullmenu.finditem(ParentTreeItem!, ll_next_handle)
      ll_new_handle = tv_fullmenu.insertitem(ll_parent_handle, ll_next_handle, ltvi_curr_item)

      // 폴더면 하위 아이템 이동
      IF ltvi_curr_item.PictureIndex>2 Then
         tv_fullmenu.of_movechildren(al_curr_handle, ll_new_handle)
      End IF

      tv_fullmenu.deleteitem(al_curr_handle)
      tv_fullmenu.POST selectitem(ll_new_handle)
end choose

// pf_pgm_mst 테이블 parent_pgm 수정
STRING	ls_pgm_no, ls_parent_pgm

ll_parent_handle = tv_fullmenu.finditem(ParentTreeItem!, ll_new_handle)
tv_fullmenu.getitem(ll_parent_handle, ltvi_parent_item)

ls_pgm_no = string(ltvi_curr_item.data)
ls_parent_pgm = string(ltvi_parent_item.data)

UPDATE  fw_pgm_mst
   SET  parent_pgm = :ls_parent_pgm
      , tree_level = :ltvi_parent_item.level + 1
WHERE   sys_id = :gnv_vari.is_sys_id
  AND   pgm_no = :ls_pgm_no;

// pf_pgm_mst 테이블 sort_order 수정
LONG	ll_child_handle, ll_sort_order

treeviewitem	ltvi_child_item

ll_child_handle = tv_fullmenu.finditem(ChildTreeItem!, ll_parent_handle)
DO WHILE ll_child_handle > 0
   tv_fullmenu.getitem(ll_child_handle, ltvi_child_item)
   ls_pgm_no = string(ltvi_child_item.data)
   ll_sort_order ++

   UPDATE  fw_pgm_mst
      SET  sort_order = :ll_sort_order
   WHERE   sys_id = :gnv_vari.is_sys_id
     AND   pgm_no = :ls_pgm_no;

   ll_child_handle = tv_fullmenu.finditem(NextTreeItem!, ll_child_handle)
loop

commitJ ()
end subroutine

public function integer of_expand_treeviewitem (long al_handle);// Expand TreeViewItem
long ll_rc

ll_rc = tv_fullmenu.ExpandAll(al_handle)
tv_fullmenu.SetFirstVisible(al_handle)

return ll_rc

end function

public function integer of_collapse_treeviewitem (long al_handle);return tv_fullmenu.CollapseItem(al_handle)
end function

on fw_w_pgm_mst.create
int iCurrent
call super::create
this.tv_fullmenu=create tv_fullmenu
this.cbx_expand=create cbx_expand
this.dw_pgm=create dw_pgm
this.cb_1=create cb_1
this.uo_1=create uo_1
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_fullmenu
this.Control[iCurrent+2]=this.cbx_expand
this.Control[iCurrent+3]=this.dw_pgm
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_3
end on

on fw_w_pgm_mst.destroy
call super::destroy
destroy(this.tv_fullmenu)
destroy(this.cbx_expand)
destroy(this.dw_pgm)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.cb_2)
destroy(this.cb_3)
end on

event wue_retrieve4lang;call super::wue_retrieve4lang;of_set_pgm_fullmenu()
end event

event wue_delete;STRING	ls_sqlerrtext
STRING	ls_pgm_no, ls_pgm_nm

LONG	ll_child_cnt

IF dw_pgm.rowcount ()=0 Then RETURN -1

Choose CASE dw_pgm.getitemstatus(1, 0, primary!)
   CASE new!, newmodified!
      IF messagebox('Notice', '현재 편집중인 내용을 삭제하시겠습니까?', Question!, YesNo!, 2)=1 Then
         dw_pgm.deleterow (1)
      End IF
   CASE ELSE
      ls_pgm_no = dw_pgm.getitemstring(1, 'pgm_no')
      ls_pgm_nm = dw_pgm.getitemstring(1, 'pgm_nm')

      IF not isvalid(itvi_item)  Then
         messagebox('Notice', '현재 선택된 항목이 없습니다')
         RETURN -1
      End IF

      IF itvi_item.PictureIndex=3   Then
         SELECT  count(1)
           INTO  :ll_child_cnt
         FROM    fw_pgm_mst
         WHERE   sys_id     = :gnv_vari.is_sys_id
           AND   parent_pgm = :ls_pgm_no;

         ll_child_cnt = SQLCA.getitemnumber (1)
         IF ll_child_cnt>0 Then
            messagebox('Notice', '하위 항목이 존재하기 때문에 삭제할 수 없습니다.~r~n먼저 하위 항목을 삭제해 주세요.')
            RETURN -1
         End IF
      End IF

      IF messagebox('Notice', '선택하신 ' + ls_pgm_nm + '[' + ls_pgm_no + '] 항목을 삭제하시겠습니까?', Question!, YesNo!, 2)=1  Then
         dw_pgm.deleterow (1)
         tv_fullmenu.POST deleteitem(il_handle)
         // fw_pgm_mst
         DELETE  fw_pgm_mst
         WHERE   sys_id = :gnv_vari.is_sys_id
           AND   pgm_no = :ls_pgm_no;

         // 삭제된 프로그램과 연계된 정보를 삭제합니다.
         DELETE  fw_role_pgm
         WHERE   sys_id = :gnv_vari.is_sys_id
           AND   pgm_no = :ls_pgm_no;

         DELETE  fw_user_favor
         WHERE   sys_id = :gnv_vari.is_sys_id
           AND   pgm_no = :ls_pgm_no;

         DELETE  fw_pgm_help
         WHERE   sys_id = :gnv_vari.is_sys_id
           AND   pgm_no = :ls_pgm_no;

         commitJ ()
         fw_f_message('U01', '', '')
         of_ship4var2event('ibrowchanged2event', TRUE)
      End IF
End Choose

RETURN 1
end event

event wue_update;INT   li_ret

dw_pgm.AcceptText()

STRING	ls_rowid, ls_maxlvl, ls_pgm_all, ls_pgm

li_ret = of_update ({dw_pgm})
IF li_ret >= 0 Then
   DECLARE PGM CURSOR FOR
      SELECT ROWID
           , CASE WHEN pgm_kind_code='M'
                  THEN SPF_FW_FULLROLLMENU_1SUB (sys_id, pgm_no)
                  ELSE 0
             END                                              AS maxlvl
           , SPF_FW_FULLROLLMENU_2SUB (sys_id, pgm_no,'KOR')  AS fullpgm_all
           , CASE WHEN pgm_kind_code='P' 
                  THEN SPF_FW_FULLROLLMENU_2SUB (sys_id, pgm_no,'KOR')
             END                                              AS fullpgm
        FROM FW_PGM_MST t1 ;

   OPEN PGM;

   DO WHILE TRUE
      FETCH  PGM  INTO :ls_rowid, :ls_maxlvl, :ls_pgm_all, :ls_pgm;
      IF SQLCA.SQLCODE <> 0 THEN EXIT

      UPDATE FW_PGM_MST
         SET maxlvl   = :ls_maxlvl
           , fullpgm  = :ls_pgm_all
           , fullpgm1 = CASE WHEN :ls_pgm IS NOT NULL THEN SUBSTR(:ls_pgm,1, INSTR(:ls_pgm,'tab',1,1) - 1) END
           , fullpgm2 = CASE WHEN :ls_pgm IS NOT NULL THEN SUBSTR(:ls_pgm, INSTR(:ls_pgm,'tab',1,1) + 3, LENGTH(:ls_pgm)) END
       WHERE ROWID = :ls_rowid ;
   LOOP
   commitJ ()

   CLOSE PGM;

   RETURN 0
ELSE
   RETURN -1
END IF
end event

event wue_retrieve;call super::wue_retrieve;of_set_pgm_fullmenu()
end event

event wue_input;// 항목추가
STRING	ls_parent_pgm, ls_parent_name

dw_pgm.reset()
dw_pgm.insertrow (0)

IF isvalid(itvi_parent) Then
   Choose CASE itvi_item.PictureIndex
      CASE 5, 6
         //
      CASE Else
         Messagebox('Notice', '메뉴 구성에서만 진행이 가능합니다.')
         RETURN -1
   End Choose

   ls_parent_pgm = string(itvi_parent.data)
   ls_parent_name = itvi_parent.label

   IF fw_f_nvls(ls_parent_pgm, '')=''  Then
      Messagebox('Notice', '먼저 상위 폴더를 선택하세요')
      RETURN -1
   End IF

	dw_pgm.setitem(1, 'parent_pgm', ls_parent_pgm)
	dw_pgm.setitem(1, 'parent_pgm_nm', ls_parent_name)
	dw_pgm.setitem(1, 'sort_order', '99')
	dw_pgm.setitem(1, 'pgm_kind_code', 'M')
	dw_pgm.setitem(1, 'pgm_use_yn', 'Y')
	dw_pgm.setitem(1, 'menu_use_yn', 'Y')
	dw_pgm.setitem(1, 'tree_line', 'N')
	dw_pgm.setitem(1, 'sys_id', gnv_vari.is_sys_id)
	dw_pgm.setitem(1, 'tree_level', string (itvi_item.level))
   dw_pgm.setitemstatus(1, 0, primary!, notmodIfied!)

   dw_pgm.setfocus()
End IF

RETURN 1
end event

event wue_lastinst;call super::wue_lastinst;ids_fullmenu = create ads_jTier
ids_fullmenu.dataobject = 'fw_d_pgm_mst_ds1'
ids_fullmenu.settransobject(sqlca)

im_pgm_mst = create fw_m_pgm_mst

post of_set_pgm_fullmenu()
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_pgm_mst
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_pgm_mst
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_pgm_mst
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_pgm_mst
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_pgm_mst
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_pgm_mst
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_pgm_mst
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_pgm_mst
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_pgm_mst
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_pgm_mst
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_pgm_mst
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_pgm_mst
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_pgm_mst
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_pgm_mst
end type

type st_top_rect from w_window1st5ncn`st_top_rect within fw_w_pgm_mst
end type

type p_close from w_window1st5ncn`p_close within fw_w_pgm_mst
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_pgm_mst
end type

type p_print from w_window1st5ncn`p_print within fw_w_pgm_mst
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_pgm_mst
end type

type p_update from w_window1st5ncn`p_update within fw_w_pgm_mst
end type

type p_input from w_window1st5ncn`p_input within fw_w_pgm_mst
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_pgm_mst
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_pgm_mst
end type

type tv_fullmenu from pf_u_treeview within fw_w_pgm_mst
integer x = 50
integer y = 244
integer width = 2528
integer height = 2520
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 20132659
borderstyle borderstyle = stylebox!
boolean disabledragdrop = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl.1.cl.jpg","..\img\mainframe\u_treemenu\lvl.1.op.jpg","..\img\mainframe\u_treemenu\lvl.3.cl.jpg","..\img\mainframe\u_treemenu\lvl.3.op.jpg","..\img\mainframe\u_treemenu\lvl.5.cl.jpg","..\img\mainframe\u_treemenu\lvl.5.op.jpg","..\img\mainframe\u_treemenu\lvl.9.cl.jpg","..\img\mainframe\u_treemenu\lvl.9.op.jpg"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event itemexpanding;treeviewitem ltvi_item

STRING	ls_pgm_no

LONG	ll_rowcnt, ll_child, i

this.getitem(handle, ltvi_item)
IF ltvi_item.Children   Then
   DO WHILE  DeleteItem (FindItem (ChildTreeItem!, handle))>0
   LOOP
End IF

ls_pgm_no = ltvi_item.data
ll_rowcnt = ids_fullmenu.retrieve (gnv_vari.is_lang_type, gnv_vari.is_sys_id, ls_pgm_no)

for i = 1 to ll_rowcnt
   ltvi_item.data = ids_fullmenu.getitemstring(i, 'pgm_no')
   ltvi_item.label = ids_fullmenu.getitemstring(i, 'pgm_nm')

   choose CASE ids_fullmenu.getitemstring(i, 'pgm_kind_code')
      CASE 'M'
			choose case ids_fullmenu.getitemnumber(i, 'tree_level')
				case 1
					ltvi_item.PictureIndex = 1
					ltvi_item.SelectedPictureIndex = 2
				case 2
					ltvi_item.PictureIndex = 3
					ltvi_item.SelectedPictureIndex = 4
				case 3
					ltvi_item.PictureIndex = 5
					ltvi_item.SelectedPictureIndex = 6
			end choose
					
//         ltvi_item.label += ' (' + ids_fullmenu.getitemstring(i, 'pgm_no') + ')'
//         IF ltvi_item.data='00000'  Then
//            ltvi_item.PictureIndex = 1
//            ltvi_item.SelectedPictureIndex = 2
//         Else
//            ltvi_item.PictureIndex = 3
//            ltvi_item.SelectedPictureIndex = 4
//         End IF
      CASE 'P'
         ltvi_item.label = f_nvl (ids_fullmenu.getitemstring(i, 'pgm_go'),'....') + ' ' + ltvi_item.label + ' | ' + ids_fullmenu.getitemstring(i, 'pgm_id')
         IF ids_fullmenu.getitemstring(i, 'pgm_use_yn')='N' Then
            ltvi_item.PictureIndex = 7
            ltvi_item.SelectedPictureIndex = 7
         ElseIF ids_fullmenu.getitemstring(i, 'menu_use_yn')='N'  Then
            ltvi_item.PictureIndex = 7
            ltvi_item.SelectedPictureIndex = 7
         else
            ltvi_item.PictureIndex = 7
            ltvi_item.SelectedPictureIndex = 8
         End IF
         ltvi_item.bold = (ids_fullmenu.getitemstring(i, 'tree_line')='Y')
   end choose

   IF ids_fullmenu.getitemnumber(i, 'child_cnt')>0 Then
      ltvi_item.Children = TRUE
   else
      ltvi_item.Children = FALSE
   End IF

   ltvi_item.HasFocus = FALSE
   ltvi_item.selected = FALSE

   ll_child = this.InsertItemLast(handle, ltvi_item)
next
end event

event rightclicked;treeviewitem ltvi_item

if this.selectitem(handle) = -1 then return
if this.getitem(handle, ltvi_item) = -1 then return

choose case ltvi_item.PictureIndex
	case 3, 4
		im_pgm_mst.m_add.enabled = true
	case 1, 2
		im_pgm_mst.m_add.enabled = false
end choose

im_pgm_mst.popmenu(iw_parent.pointerx(), iw_parent.pointery())
end event

event selectionchanged;string	ls_pgm_no

of_confirmupdate4rowchanged()

il_handle = newhandle
this.getitem(il_handle, itvi_item)

choose case itvi_item.PictureIndex
	case 1, 3
		il_parent = il_handle
		itvi_parent = itvi_item
	case else
		il_parent = this.finditem(ParentTreeItem!, il_handle)
		this.getitem(il_parent, itvi_parent)
end choose
ls_pgm_no = itvi_item.data
dw_pgm.retrieve (gnv_vari.is_sys_id, ls_pgm_no)

return 0
end event

event key;if keyflags = 2 then
	choose case key
		case KeyUpArrow!
			setredraw (false)
			of_treeviewitem_move(il_handle, 'upper')
			setredraw (true)
		case KeyDownArrow!
			setredraw (false)
			of_treeviewitem_move(il_handle, 'lower')
			setredraw (true)
	end choose
end if

choose case key
	case KeyDelete!
		p_delete.post event clicked()
	case KeyInsert!
		p_input.post event clicked()
end choose

return 1
end event

event begindrag;call super::begindrag;// 드래그될 아이템과 그 부모아이템을 보관 합니다
il_DragSource = handle
this.getitem(il_DragSource, itvi_Source)
il_DragParent = FindItem(ParentTreeItem!, handle)
end event

event dragdrop;call super::dragdrop;LONG	ll_newitem, ll_nextitem, ll, ll_child, ll_sort_order

STRING	ls_pgm_no, ls_new_no, ls_parent_pgm

TreeViewItem ltvi_Source, ltvi_Target, ltvi_Parent, ltvi_NewItem, ltvi_next, ltvi_child

IF this.getitem(il_DragSource, ltvi_Source)=-1  Then RETURN
IF this.getitem(il_DropTarget, ltvi_Target)=-1  Then RETURN

// 메뉴 변경 사용자 확인
IF this.getitem(il_DragParent, ltvi_Parent)=-1  Then
   ltvi_Parent.Label = 'ROOT'
End IF

IF ltvi_Source.PictureIndex=5 Then
   ll = messagebox('메뉴 변경', ltvi_Parent.Label + '의 [' + ltvi_Source.Label + '] 메뉴를 ' + ltvi_Target.Label + ' 하위로 이동(NO=복사)하시겠습니까?', Question!, YesNoCancel!, 3)
   IF ll=3  Then
      SetDropHighlight(0)
      il_DropTarget = 0
      RETURN
   End IF
Else
   ll = messagebox('메뉴 변경', ltvi_Parent.Label + '의 [' + ltvi_Source.Label + '] 메뉴를 ' + ltvi_Target.Label + ' 하위로 이동하시겠습니까?', Question!, YesNo!, 2)
   IF ll=2  Then
      SetDropHighlight(0)
      il_DropTarget = 0
      RETURN
   End IF
End IF

// 타겟메뉴 펼침
IF ltvi_Target.expanded=FALSE Then
   this.expanditem(il_DropTarget)
End IF

IF ll=1  Then
   // 신규 메뉴 생성
   SetNull(ltvi_Source.ItemHandle)
   ll_newitem = this.InsertItemFirst(il_DropTarget, ltvi_source)
   this.getitem(ll_newitem, ltvi_newitem)

   // 하위 메뉴 이동
   this.of_movechildren(il_DragSource, ll_NewItem)

   // 기존 메뉴 삭제
   this.deleteitem(il_DragSource)

   // 하이라이트 취소
   this.SetDropHighlight(0)

   // pf_pgm_mst 테이블 parent_pgm 수정
   ls_pgm_no = string(ltvi_Source.data)
   ls_parent_pgm = string(ltvi_Target.data)

   UPDATE  fw_pgm_mst
      SET  parent_pgm = :ls_parent_pgm
         , tree_level = :ltvi_Target.level + 1
         , sort_order = 99
   WHERE   sys_id = :gnv_vari.is_sys_id
     AND   pgm_no = :ls_pgm_no;

   // 하위 아이템 treelevel 수정
   IF ltvi_newitem.level<>ltvi_source.level  Then
      IF ltvi_newitem.pictureindex>2   Then
         this.expandall(ll_newitem)

         ll_nextitem = this.finditem(nextvisibletreeitem!, ll_newitem)
         DO WHILE ll_nextitem > 0
            this.getitem(ll_nextitem, ltvi_next)
            IF ltvi_next.level<=ltvi_newitem.level Then EXIT

            ls_pgm_no = string(ltvi_next.data)

            UPDATE  fw_pgm_mst
               SET  tree_level = :ltvi_next.level
            WHERE   sys_id = :gnv_vari.is_sys_id
              AND   pgm_no = :ls_pgm_no;

            ll_nextitem = this.finditem(nextvisibletreeitem!, ll_nextitem)
         loop
      End IF
   End IF

   // 옮겨진 메뉴 선택
   this.SelectItem(ll_NewItem)
Else
   // 신규 메뉴 생성
   SetNull(ltvi_Source.ItemHandle)
   ll_newitem = this.InsertItemLast(il_DropTarget, ltvi_source)
   this.getitem(ll_newitem, ltvi_newitem)

   // 하이라이트 취소
   this.SetDropHighlight(0)

   // pf_pgm_mst 테이블 parent_pgm 수정
   ls_pgm_no = string(ltvi_Source.data)
   ls_parent_pgm = string(ltvi_Target.data)

   SELECT  f_pgm_no
     INTO  :ls_new_no
   FROM    dual;

   ls_new_no = SQLCA.getitemstring (1)

   INSERT INTO  fw_pgm_mst (
                  sys_id                           /* _1: */
                , pgm_no                           /* _2: */
                , pgm_id                           /* _3: */
                , pgm_nm                           /* _4: */
                , pgm_enm                          /* _5: */
                , pgm_lnm                          /* _6: */
                , pgm_kind_code                    /* _7: */
                , pgm_icon                         /* _8: */
                , sort_order                       /* _9: */
                , parent_pgm                       /* _10: */
                , menu_use_yn                      /* _11: */
                , pgm_use_yn                       /* _12: */
                , url_link_yn                      /* _13: */
                , linked_url                       /* _14: */
                , pgm_desc                         /* _15: */
                , io_type                          /* _16: */
                , platform_type                    /* _17: */
                , tree_level                       /* _18: */
                , parameter1                       /* _19: */
                , parameter2                       /* _20: */
                , parameter3                       /* _21: */
                , reg_id                           /* _22: */
                , reg_dt )                         /* _23: */
    select sys_id                                   /* _1: */
         , :ls_new_no                               /* _2: */
         , pgm_id                                   /* _3: */
         , pgm_nm                                   /* _4: */
         , pgm_enm                                  /* _5: */
         , pgm_lnm                                  /* _6: */
         , pgm_kind_code                            /* _7: */
         , pgm_icon                                 /* _8: */
         , 99                                       /* _9: */
         , :ls_parent_pgm                           /* _10: */
         , menu_use_yn                              /* _11: */
         , pgm_use_yn                               /* _12: */
         , url_link_yn                              /* _13: */
         , linked_url                               /* _14: */
         , pgm_desc                                 /* _15: */
         , io_type                                  /* _16: */
         , platform_type                            /* _17: */
         , :ltvi_Target.level + 1                   /* _18: */
         , parameter1                               /* _19: */
         , parameter2                               /* _20: */
         , parameter3                               /* _21: */
         , :gnv_vari.is_user_nm                     /* _22: */
         , TO_CHAR (now(),'yyyymmddhh24miss')     /* _23: */
      from fw_pgm_mst t1
    where  sys_id = :gnv_vari.is_sys_id
      and  pgm_no = :ls_pgm_no;

   ltvi_newitem.data = ls_new_no
   ltvi_newitem.label = ltvi_Source.label
   ltvi_newitem.PictureIndex = 5
   ltvi_newitem.SelectedPictureIndex = 6
   ltvi_newitem.Children = FALSE
   ltvi_newitem.HasFocus = FALSE
   ltvi_newitem.selected = FALSE

   tv_fullmenu.setitem(ll_newitem, ltvi_newitem)

   messagebox ('복사완료', ltvi_Target.Label + ' 하위로 복사 완료 했습니다.')
   this.SelectItem(ll_NewItem)
End IF

commitJ ()
end event

event dragwithin;call super::dragwithin;long ll_Parent

TreeViewItem ltvi_Over

// 부모 노드는 선택 안 함
if handle = il_DragParent then return

If GetItem(handle, ltvi_Over) = -1 Then
	SetDropHighlight(0)
	il_DropTarget = 0
	Return
End If

// 타겟은 폴더만 선택 가능
if ltvi_Over.PictureIndex < 3 then
	SetDropHighlight(0)
	il_DropTarget = 0
	return
end if

// 타겟과 소스가 동일
if il_DragSource = handle then 
	SetDropHighlight(0)
	il_DropTarget = 0
	return
end if

// 폴더는 자신의 하위 노드로 이동 불가
if itvi_Source.PictureIndex > 2 then
	ll_Parent = FindItem(ParentTreeItem!, handle)
	do while ll_Parent > 0
		if ll_Parent = il_DragSource then
			SetDropHighlight(0)
			il_DropTarget = 0
			return
		end if
		ll_Parent = FindItem(ParentTreeItem!, ll_Parent)
	loop
end if

// MouseOver 하이라이트 처리
il_DropTarget = handle
SetDropHighlight(il_DropTarget)
end event

type cbx_expand from pf_u_checkbox within fw_w_pgm_mst
integer x = 2240
integer y = 160
integer width = 338
integer height = 76
boolean bringtotop = true
long textcolor = 19737901
string text = "열린 메뉴"
boolean setsheetcolor = true
end type

event clicked;call super::clicked;Post of_set_pgm_fullmenu()
end event

type dw_pgm from fw_u_dwo within fw_w_pgm_mst
integer x = 2592
integer y = 156
integer width = 2839
integer height = 2608
integer taborder = 20
string title = "프로그램 상세"
string dataobject = "fw_d_pgm_mst_1"
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibresize4objwidth = true
boolean ibtitle4datawindow = true
boolean setfocusdw = true
boolean setedittoken = true
end type

event itemchanged;call super::itemchanged;string	ls_platform_type

choose case dwo.name
	case 'pgm_kind_code'
		if	getitemstatus(row, 0, primary!)=new! or getitemstatus(row, 0, primary!)=newmodified!	then
			if	data='M'	then
				object.parent_pgm [row] = itvi_parent.data
				object.parent_pgm_nm [row] = itvi_parent.label
				object.tree_level [row] = itvi_item.level
			else
				object.parent_pgm [row] = itvi_item.data
				object.parent_pgm_nm [row] = itvi_item.label
				object.tree_level [row] = itvi_item.level + 1
			end if
		end if
	case 'menu_use_yn'
		if data = 'Y' then
			modify('pgm_nm.tabsequence="0"')
		else
			modify('pgm_nm.tabsequence="10"')
		end if
	case 'platform_type1'
		ls_platform_type = data + this.getitemstring(row, 'platform_type2') + this.getitemstring(row, 'platform_type3')
		this.setitem(row, 'platform_type', ls_platform_type)
	case 'platform_type2'
		ls_platform_type = this.getitemstring(row, 'platform_type1') + data + this.getitemstring(row, 'platform_type3')
		this.setitem(row, 'platform_type', ls_platform_type)
	case 'platform_type3'
		ls_platform_type = this.getitemstring(row, 'platform_type1') + this.getitemstring(row, 'platform_type2') + data
		this.setitem(row, 'platform_type', ls_platform_type)
	case 'io_type'
		Choose Case data
			Case '01'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_search_hover.jpg')
			Case '02'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_add_hover.jpg')
			Case '03'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_exec_hover.jpg')
			Case '04'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_setting_hover.jpg')
			Case '05'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_print_rd_hover.jpg')
			Case '10'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_ftp_hover.jpg')
			Case '11'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_chart_hover.jpg')
			Case '12'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_excel_hover.jpg')
			Case '13'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_fundnet_hover.jpg')
		End Choose
end choose
end event

event updatestart;call super::updatestart;// Primary Key 생성
STRING	ls_pgm_no

LONG	ll_role_cnt

treeviewitem ltvi_item

IF getitemstatus(1, 0, primary!)=newmodified!   Then
   SELECT f_pgm_no
     INTO :ls_pgm_no
     FROM DUAL t1;

   ls_pgm_no = SQLCA.getitemstring (1)

   setitem(1, 'pgm_no', ls_pgm_no)

   // TreeView Item 생성
   ltvi_item.data = ls_pgm_no
   ltvi_item.label = STRING (Object.pgm_nm [1])
   itvi_item.level = dec (Object.tree_level [1])
   ltvi_item.HasFocus = FALSE
   ltvi_item.selected = FALSE
   CHOOSE CASE Object.pgm_kind_code [1]
      CASE 'M'
         ltvi_item.label += ' (' + ls_pgm_no + ')'
         ltvi_item.PictureIndex = 3
         ltvi_item.SelectedPictureIndex = 4
         ltvi_item.Children = FALSE
         ltvi_item.expandedonce = TRUE
         il_new = tv_fullmenu.InsertItemLast(il_parent, ltvi_item)
      CASE 'P'
         ltvi_item.label = f_nvl (getitemstring(1, 'pgm_go'),'....') + ' ' + ltvi_item.label + ' | ' + getitemstring(1, 'pgm_id')
         ltvi_item.PictureIndex = 7
         ltvi_item.SelectedPictureIndex = 8
         ltvi_item.Children = FALSE
         ltvi_item.bold = (getitemstring(1, 'tree_line')='Y')
         il_new = tv_fullmenu.InsertItemLast(il_handle, ltvi_item)
   END CHOOSE

   SELECT COUNT(1)
     INTO :ll_role_cnt
     FROM FW_ROLE_PGM t1
    WHERE sys_id  = :gnv_vari.is_sys_id
      AND role_no = '00001'
      AND pgm_no  = :ls_pgm_no;

   ll_role_cnt = SQLCA.getitemnumber (1)
   IF ll_role_cnt=0  Then
      STRING	ls_now

      ls_now = fw_f_getymdhh24miss4s()

      INSERT  INTO FW_ROLE_PGM
          ( sys_id             /* _1- */
          , role_no            /* _2- */
          , pgm_no             /* _3- */
          , valid_dt_yn        /* _4- */
          , comm_btn_auth_yn   /* _5- */
          , retrieve_auth_yn   /* _6- */
          , input_auth_yn      /* _7- */
          , ext1_auth_yn       /* _8- */
          , delete_auth_yn     /* _9- */
          , update_auth_yn     /* _10- */
          , print_auth_yn      /* _11- */
          , execute_auth_yn    /* _12- */
          , cancel_auth_yn     /* _13- */
          , excel_auth_yn      /* _14- */
          , indiv_btn_auth_yn  /* _15- */
          , reg_dt             /* _16- */
          , reg_id             /* _17- */
          )
      VALUES ( :gnv_vari.is_sys_id   /* _1- */
             , '00001'               /* _2- */
             , :ls_pgm_no            /* _3- */
             , 'N'                   /* _4- */
             , 'N'                   /* _5- */
             , 'N'                   /* _6- */
             , 'N'                   /* _7- */
             , 'N'                   /* _8- */
             , 'N'                   /* _9- */
             , 'N'                   /* _10- */
             , 'N'                   /* _11- */
             , 'N'                   /* _12- */
             , 'N'                   /* _13- */
             , 'N'                   /* _14- */
             , 'N'                   /* _15- */
             , :ls_now               /* _16- */
             , :gnv_vari.is_user_id  /* _17- */
             );
      IF SQLCA.sqlcode ()<>0  Then
         messagebox('Notice', 'Updating data failed for the following reasons1~r~nSQLCODE: ' + STRING(SQLCA.sqldbcode) + '~r~nSQLERRTEXT: ' + SQLCA.sqlerrtext())
         rollbackJ ()
         RETURN iiUpdateStart
      End IF
   End IF
Else
   tv_fullmenu.getitem(il_handle, ltvi_item)
   CHOOSE CASE Object.pgm_kind_code [1]
      CASE 'M'
         ltvi_item.label = Object.pgm_nm [1] + ' (' + Object.pgm_no [1] + ')'
      CASE 'P'
         ltvi_item.label = f_nvl (Object.pgm_go [1],'....') + ' ' + Object.pgm_nm [1] + ' | ' + Object.pgm_id [1]
         ltvi_item.bold = (Object.tree_line [1] = 'Y')
   END CHOOSE
   tv_fullmenu.setitem(il_handle, ltvi_item)
End IF

// PGM_NO 가 변경된 경우 관련된 테이블을 모두 수정해 줍니다
STRING	ls_org_pgm_no, ls_new_pgm_no

CHOOSE CASE getitemstatus(1, 0, primary!)
   CASE datamodified!
      IF getitemstatus(1, 'pgm_no', primary!)=datamodified! Then
         ls_org_pgm_no = getitemstring(1, 'pgm_no', primary!, TRUE)
         ls_new_pgm_no = getitemstring(1, 'pgm_no', primary!, FALSE)

         IF len(ls_org_pgm_no)>0 and len(ls_new_pgm_no)>0 and ls_org_pgm_no<>ls_new_pgm_no   Then
            //fw_pgm_mst
            UPDATE FW_PGM_MST
               SET parent_pgm = :ls_new_pgm_no
             WHERE sys_id     = :gnv_vari.is_sys_id
               AND parent_pgm = :ls_org_pgm_no;

            //fw_role_pgm
            UPDATE FW_ROLE_PGM
               SET pgm_no = :ls_new_pgm_no
             WHERE sys_id = :gnv_vari.is_sys_id
               AND pgm_no = :ls_org_pgm_no;

            //fw_user_favor
            UPDATE FW_USER_FAVOR
               SET pgm_no = :ls_new_pgm_no
             WHERE sys_id = :gnv_vari.is_sys_id
               AND pgm_no = :ls_org_pgm_no;

            //fw_docu_mst
            UPDATE FW_DOCU_MST
               SET linked_pgm_no = :ls_new_pgm_no
             WHERE sys_id        = :gnv_vari.is_sys_id
               AND linked_pgm_no = :ls_org_pgm_no;

            //fw_pgm_help
            UPDATE FW_PGM_HELP
               SET pgm_no = :ls_new_pgm_no
             WHERE sys_id = :gnv_vari.is_sys_id
               AND pgm_no = :ls_org_pgm_no;

            tv_fullmenu.getitem(il_handle, ltvi_item)
            ltvi_item.data = ls_new_pgm_no
            tv_fullmenu.setitem(il_handle, ltvi_item)
         End IF
      End IF
END CHOOSE
end event

event oue_setupdatecheck;call super::oue_setupdatecheck;string	ls_pgm_kind_code, ls_pgm_id, ls_pgm_nm, ls_parent_pgm

ls_pgm_kind_code = dw_pgm.getitemstring(1, 'pgm_kind_code')
if isnull(ls_pgm_kind_code) or len(trim(ls_pgm_kind_code)) = 0 then
	messagebox('Notice', '폴더/프로그램 구분을 입력하세요')
	Return -1
end if

if ls_pgm_kind_code = 'P' then
	ls_pgm_id = dw_pgm.getitemstring(1, 'pgm_id')
	if isnull(ls_pgm_id) or len(trim(ls_pgm_id)) = 0 then
		messagebox('Notice', '프로그램ID 를 입력하세요')
		Return -1
	end if
end if

ls_pgm_nm = dw_pgm.getitemstring(1, 'pgm_nm')
if isnull(ls_pgm_nm) or len(trim(ls_pgm_nm)) = 0 then
	messagebox('Notice', '프로그램 명칭을 입력하세요')
	Return -1
end if

ls_parent_pgm = dw_pgm.getitemstring(1, 'parent_pgm')
if isnull(ls_parent_pgm) or len(trim(ls_parent_pgm)) = 0 then
	messagebox('Notice', '먼저 상위메뉴를 선택 하세요')
	Return -1
end if

Return 1
end event

type cb_1 from pf_u_commandbutton within fw_w_pgm_mst
integer x = 2245
integer y = 16
integer width = 370
integer height = 100
integer taborder = 10
boolean bringtotop = true
string text = "권한할당"
boolean fixedtoright = true
end type

event clicked;call super::clicked;STRING	ls_pgm_no, ls_retval

pf_n_hashtable lnv_parm

ls_pgm_no = dw_pgm.getitemstring(1, 'pgm_no')
IF isnull(ls_pgm_no) or len(ls_pgm_no)=0  Then
   messagebox('Notice', '먼저 프로그램 정보를 저장하세요')
   RETURN
End IF

openwithparm (pf_w_pgm_mst_role_pgm, ls_pgm_no)
end event

type uo_1 from fw_u_dw2title within fw_w_pgm_mst
integer x = 50
integer y = 156
integer taborder = 90
boolean bringtotop = true
string istitletext = "전체 프로그램 메뉴"
end type

on uo_1.destroy
call fw_u_dw2title::destroy
end on

type cb_2 from commandbutton within fw_w_pgm_mst
integer x = 2798
integer y = 16
integer width = 302
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "error"
end type

event clicked;dw_pgm.getitemstring(100, 'error')
end event

type cb_3 from commandbutton within fw_w_pgm_mst
integer x = 3127
integer y = 16
integer width = 325
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OBJECT"
end type

event clicked;IF	dw_pgm.object.pgm_kind_code [1]='P'	Then
	OpenWithParm (w_menu_object, dw_pgm)
	tv_fullmenu.event selectionchanged (il_handle, il_new)
Else
	messageBox ('ERR','프로그램만 선택 할 수 있습니다.')
End IF
dw_pgm.SetFocus ()
end event

