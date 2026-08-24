forward
global type fw_w_dime1 from w_window1st5ncn
end type
type tv_favor from pf_u_treeview within fw_w_dime1
end type
type cbx_role_expand from pf_u_checkbox within fw_w_dime1
end type
type uo_favor_tvtitle from fw_u_dw2title within fw_w_dime1
end type
type st_v1 from pf_u_splitbar_vertical within fw_w_dime1
end type
type tv_role from pf_u_treeview within fw_w_dime1
end type
type uo_role_title from fw_u_dw2title within fw_w_dime1
end type
type st_v2 from pf_u_splitbar_vertical within fw_w_dime1
end type
type dw_favor from u_dw within fw_w_dime1
end type
type dw_1 from u_dw within fw_w_dime1
end type
end forward

global type fw_w_dime1 from w_window1st5ncn
string title = "디멘션등"
boolean ibconfirmupdate4closequery = true
boolean ibconfirmupdate4message = false
tv_favor tv_favor
cbx_role_expand cbx_role_expand
uo_favor_tvtitle uo_favor_tvtitle
st_v1 st_v1
tv_role tv_role
uo_role_title uo_role_title
st_v2 st_v2
dw_favor dw_favor
dw_1 dw_1
end type
global fw_w_dime1 fw_w_dime1

type variables
ads_jTier ids_user_favor
ads_jTier ids_user_role

treeviewitem   itvi_item, itvi_parent

BOOLEAN	ib_redraw = FALSE
LONG	il_parent, il_handle, il_root
LONG	il_dragsource, il_dragparent, il_droptarget
STRING	is_corp_gr, is_login, is_login_nm, is_updatable='0'

treeviewitem   itvi_src

// role tv
BOOLEAN	ib_role_redraw = FALSE
BOOLEAN	ib_updatable = TRUE
LONG	il_role_dragsource

treeviewitem   itvi_role_src
end variables

forward prototypes
public function integer of_favor_retrieve ()
public subroutine of_favor_itemmove (long al_curr_handle, string as_direction)
public function integer of_role_retrieve ()
public subroutine uf_sort_order (long al_parent)
public subroutine uf_deleteall (long al_handle)
end prototypes

public function integer of_favor_retrieve ();LONG	ll_rowcnt, ll_handle, i, ll_roothndl
LONG	ll_treelevel
treeviewitem ltvi_item

ll_handle = tv_favor.finditem(roottreeitem!, 0)
DO WHILE ll_handle > 0
   tv_favor.deleteitem(ll_handle)
   ll_handle = tv_favor.finditem(roottreeitem!, ll_handle)
LOOP

ids_user_favor.retrieve (gnv_vari.is_sys_id, is_login, is_login_nm, 'ROOT', gnv_vari.is_lang_type)

ids_user_favor.setfilter ("parent_pgm='UPROOT'")
ids_user_favor.filter ()
ll_rowcnt = ids_user_favor.rowcount ()

for i = 1 to ll_rowcnt
   ltvi_item.data  = ids_user_favor.getitemstring(i, 'pgm_no')
   ltvi_item.label = ids_user_favor.getitemstring(i, 'favor_nm')
   ll_treelevel    = ids_user_favor.getitemnumber(i, 'tree_level')

   CHOOSE CASE ids_user_favor.getitemstring(i, 'pgm_kind_code')
      CASE 'M'
         CHOOSE CASE ll_treelevel
            CASE 1
               ltvi_item.pictureindex = 1
               ltvi_item.Selectedpictureindex = 2
            CASE 2
               ltvi_item.pictureindex = 3
               ltvi_item.Selectedpictureindex = 4
         END CHOOSE
      CASE 'P'
         ltvi_item.pictureindex = 5
         ltvi_item.Selectedpictureindex = 6
   END CHOOSE

   ltvi_item.children = (ids_user_favor.getitemnumber(i, 'child_cnt') > 0)

   ll_handle = tv_favor.InsertItemLast(0, ltvi_item)
next

// expand top level items only
ll_handle = tv_favor.finditem(roottreeitem!, 0)
ll_roothndl = ll_handle
DO WHILE ll_handle > 0
   tv_favor.expandall(ll_handle)
   ll_handle = tv_favor.finditem(NextTreeItem!, ll_handle)
LOOP

tv_favor.SetFirstVisible(ll_roothndl)
tv_favor.POST selectitem(ll_roothndl)

RETURN ll_rowcnt

end function

public subroutine of_favor_itemmove (long al_curr_handle, string as_direction);STRING	ls_sqlerrtext
LONG	ll_prev_handle, ll_next_handle, ll_new_handle, ll_parent_handle

tv_favor.setredraw (FALSE)
tv_favor.post setredraw (TRUE)

treeviewitem ltvi_curr_item
treeviewitem ltvi_prev_item
treeviewitem ltvi_next_item
treeviewitem ltvi_parent_item

IF tv_favor.getitem(al_curr_handle, ltvi_curr_item)=-1   THEN RETURN
IF ltvi_curr_item.pictureindex>2 Then
   ltvi_curr_item.expanded = FALSE
End IF

CHOOSE CASE as_direction
   CASE 'upper'
      ll_prev_handle = tv_favor.finditem(PreviousTreeItem!, al_curr_handle)
      IF ll_prev_handle=-1 THEN RETURN

      ll_prev_handle = tv_favor.finditem(PreviousTreeItem!, ll_prev_handle)
      IF ll_prev_handle=-1 Then
         ll_parent_handle = tv_favor.finditem(ParentTreeItem!, al_curr_handle)
         ll_new_handle = tv_favor.insertitemfirst(ll_parent_handle, ltvi_curr_item)
      Else
         ll_parent_handle = tv_favor.finditem(ParentTreeItem!, ll_prev_handle)
         ll_new_handle = tv_favor.insertitem(ll_parent_handle, ll_prev_handle, ltvi_curr_item)
      End IF

      // 폴더면 하위 아이템 이동
      IF ltvi_curr_item.pictureindex>2 Then
         tv_favor.of_movechildren(al_curr_handle, ll_new_handle)
      End IF

      tv_favor.deleteitem(al_curr_handle)
      tv_favor.POST selectitem(ll_new_handle)

   CASE 'lower'
      ll_next_handle = tv_favor.finditem(NextTreeItem!, al_curr_handle)
      IF ll_next_handle=-1 THEN RETURN

      ll_parent_handle = tv_favor.finditem(ParentTreeItem!, ll_next_handle)
      ll_new_handle = tv_favor.insertitem(ll_parent_handle, ll_next_handle, ltvi_curr_item)

      // 폴더면 하위 아이템 이동
      IF ltvi_curr_item.pictureindex>2 Then
         tv_favor.of_movechildren(al_curr_handle, ll_new_handle)
      End IF

      tv_favor.deleteitem(al_curr_handle)
      tv_favor.POST selectitem(ll_new_handle)
END CHOOSE

// pf_pgm_mst 테이블 parent_pgm 수정
STRING	ls_pgm_no, ls_parent_pgm

ll_parent_handle = tv_favor.finditem(ParentTreeItem!, ll_new_handle)
tv_favor.getitem(ll_parent_handle, ltvi_parent_item)

ls_pgm_no = string(ltvi_curr_item.data)
ls_parent_pgm = string(ltvi_parent_item.data)

UPDATE  fw_user_favor
   SET  parent_pgm = :ls_parent_pgm
      , tree_level = :ltvi_parent_item.level + 1
WHERE   sys_id  = :gnv_vari.is_sys_id
  AND   user_id = :is_login
  AND   pgm_no  = :ls_pgm_no;

IF SQLCA.sqlcode ()<>0  Then
   ls_sqlerrtext = SQLCA.sqlerrtext ()
   rollbackJ()
   messagebox('error : ' + '순번 변경 오류' + string(SQLCA.sqlcode()), ls_sqlerrtext)
   RETURN
End IF

// pf_pgm_mst 테이블 sort_order 수정
LONG	ll_child_handle
LONG	ll_sort_order
treeviewitem ltvi_child_item

ll_child_handle = tv_favor.finditem(ChildTreeItem!, ll_parent_handle)
DO WHILE ll_child_handle > 0
   tv_favor.getitem(ll_child_handle, ltvi_child_item)
   ls_pgm_no = string(ltvi_child_item.data)
   ll_sort_order ++

   UPDATE  fw_user_favor
      SET  sort_order = :ll_sort_order
   WHERE   sys_id  = :gnv_vari.is_sys_id
     AND   user_id = :is_login
     AND   pgm_no  = :ls_pgm_no;

   IF SQLCA.sqlcode ()<>0  Then
      ls_sqlerrtext = SQLCA.sqlerrtext ()
      rollbackJ()
      messagebox('error : ' + '순번 변경 오류' + string(SQLCA.sqlcode()), ls_sqlerrtext)
      RETURN
   End IF

   ll_child_handle = tv_favor.finditem(NextTreeItem!, ll_child_handle)
LOOP
commitJ ()

RETURN

end subroutine

public function integer of_role_retrieve ();LONG	ll_rowcnt, ll_handle, i, ll_roothndl

treeviewitem   ltvi_item

f_loadingrd (TRUE)
POST f_loadingrd (FALSE)

// 완전히 초기화 시켜야 재사용가능
ids_user_role = CREATE ads_jTier
ids_user_role.dataobject = 'fw_d_fullrollmenu_spc'
ids_user_role.settransobject(SQLCA)

CHOOSE CASE is_login
	CASE gaa.login, '%'
		// 사용자 메뉴 role과 같음
		ids_user_role = gnv_rolemenu.ids_fullmenudata
	CASE ELSE
		ids_user_role.retrieve(gnv_vari.is_sys_id, gnv_vari.is_login_dt, gnv_vari.is_lang_type, &
						is_login, '', '', '', '', '', '', '', gnv_rolemenu.is_platform_type)
END CHOOSE

ids_user_role.setfilter ("parent_pgm='ROOT'")
ids_user_role.filter ()

ll_handle = tv_role.finditem(roottreeitem!, 0)
DO WHILE ll_handle > 0
   tv_role.deleteitem(ll_handle)
   ll_handle = tv_role.finditem(roottreeitem!, ll_handle)
LOOP

ll_rowcnt = ids_user_role.rowcount ()

FOR  i = 1  TO  ll_rowcnt
   ltvi_item.data = ids_user_role.getitemstring(i, 'pgm_no')
   ltvi_item.label = ids_user_role.getitemstring(i, 'pgm_nm')

   CHOOSE CASE ids_user_role.getitemstring(i, 'pgm_kc')
	//CHOOSE CASE ids_user_role.getitemstring(i, 'pgm_kind_code')
      CASE 'M'
         IF ltvi_item.data='00000'  Then
            ltvi_item.PictureIndex = 1
            ltvi_item.SelectedPictureIndex = 2
         Else
            ltvi_item.label += ' (' + ids_user_role.getitemstring(i, 'pgm_no') + ')'
            ltvi_item.PictureIndex = 3
            ltvi_item.SelectedPictureIndex = 4
         End IF
      CASE 'P'
         IF f_notnull (ids_user_role.getitemstring(i, 'pgm_id')) THEN ltvi_item.label += ' (' + ids_user_role.getitemstring(i, 'pgm_id') + ')'
         ltvi_item.PictureIndex = 5
         ltvi_item.SelectedPictureIndex = 6
   END CHOOSE

   ltvi_item.Children = (ids_user_role.getitemstring(i, 'pgm_kc')='M')
   ll_handle = tv_role.InsertItemLast(0, ltvi_item)
NEXT

ll_handle = tv_role.finditem(roottreeitem!, 0)
ll_roothndl = ll_handle
DO WHILE ll_handle > 0
	IF cbx_role_expand.checked	Then
	   tv_role.expandall(ll_handle)
	Else
	   tv_role.expanditem(ll_handle)
	End IF
   ll_handle = tv_role.finditem(NextTreeItem!, ll_handle)
LOOP

tv_role.SetFirstVisible(ll_roothndl)
tv_role.POST selectitem(ll_roothndl)

RETURN ll_rowcnt
end function

public subroutine uf_sort_order (long al_parent);LONG	ll_sort, ll_temp

treeviewitem	ltvi_temp

STRING	ls_pgm_no, ls_parent_pgm

tv_favor.getitem (al_parent, ltvi_temp)
ls_parent_pgm = ltvi_temp.data
ll_sort = 1
DO WHILE TRUE
	IF ll_sort = 1 Then
		ll_temp = tv_favor.finditem (ChildTreeItem!, al_parent)
	Else
		ll_temp = tv_favor.finditem (NextTreeItem!, ll_temp)
	End IF
	IF ll_temp = -1 THEN EXIT
	tv_favor.getitem (ll_temp, ltvi_temp)
	ls_pgm_no = ltvi_temp.data
	
	UPDATE  fw_user_favor
		SET  sort_order = :ll_sort
	 WHERE  sys_id     = :gnv_vari.is_sys_id
		AND  user_id    = :is_login
		AND  parent_pgm = :ls_parent_pgm
		AND  pgm_no     = :ls_pgm_no;
	
	ll_sort ++
LOOP
end subroutine

public subroutine uf_deleteall (long al_handle);LONG	ll_cnt, ll, ll_child_handle

treeviewitem ltvi_item

STRING	ls_pgm_no

tv_favor.getitem (al_handle, ltvi_item)

ls_pgm_no = string (ltvi_item.data)

SELECT  count(*)
  INTO  :ll_cnt
FROM    fw_user_favor
WHERE   sys_id     = :gnv_vari.is_sys_id
  AND   user_id    = :is_login
  AND   parent_pgm = :ls_pgm_no;
  
ll_cnt = SQLCA.getitemnumber (1)

IF ll_cnt>0	Then
	FOR  ll = 1  TO  ll_cnt
		 IF ll = 1 Then
			ll_child_handle = tv_favor.finditem (ChildTreeItem!, al_handle)
		Else
			ll_child_handle = tv_favor.finditem (NextTreeItem!, ll_child_handle)
		End IF
		 uf_deleteall (ll_child_handle)
	NEXT
End IF
	
DELETE  fw_user_favor
WHERE   sys_id  = :gnv_vari.is_sys_id
  AND   user_id = :is_login
  AND   pgm_no  = :ls_pgm_no;
  
tv_favor.post deleteitem (al_handle)
end subroutine

on fw_w_dime1.create
int iCurrent
call super::create
this.tv_favor=create tv_favor
this.cbx_role_expand=create cbx_role_expand
this.uo_favor_tvtitle=create uo_favor_tvtitle
this.st_v1=create st_v1
this.tv_role=create tv_role
this.uo_role_title=create uo_role_title
this.st_v2=create st_v2
this.dw_favor=create dw_favor
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_favor
this.Control[iCurrent+2]=this.cbx_role_expand
this.Control[iCurrent+3]=this.uo_favor_tvtitle
this.Control[iCurrent+4]=this.st_v1
this.Control[iCurrent+5]=this.tv_role
this.Control[iCurrent+6]=this.uo_role_title
this.Control[iCurrent+7]=this.st_v2
this.Control[iCurrent+8]=this.dw_favor
this.Control[iCurrent+9]=this.dw_1
end on

on fw_w_dime1.destroy
call super::destroy
destroy(this.tv_favor)
destroy(this.cbx_role_expand)
destroy(this.uo_favor_tvtitle)
destroy(this.st_v1)
destroy(this.tv_role)
destroy(this.uo_role_title)
destroy(this.st_v2)
destroy(this.dw_favor)
destroy(this.dw_1)
end on

event wue_delete;IF is_updatable<>'2'	Then
	messageBox ('ERR', '권한이 없습니다')
	RETURN -1
End IF

STRING	ls_sqlerrtext
STRING	ls_pgm_no, ls_favor_nm
LONG	ll_child_cnt

IF dw_favor.rowcount ()=0  THEN RETURN -1

CHOOSE CASE dw_favor.getitemstatus(1, 0, primary!)
   CASE new!, newmodified!
      IF messagebox('Notice', '현재 편집중인 내용을 삭제하시겠습니까?', Question!, YesNo!, 2)=1 Then
         dw_favor.deleterow (1)
      End IF
   CASE ELSE
      ls_pgm_no = dw_favor.getitemstring(1, 'pgm_no')
      ls_favor_nm = dw_favor.getitemstring(1, 'favor_nm')

      IF NOT isvalid(itvi_item)  Then
         messagebox('Notice', '현재 선택된 항목이 없습니다')
         RETURN -1
      End IF

      IF itvi_item.pictureindex<=4   Then
         SELECT  count(1)
           INTO  :ll_child_cnt
         FROM    fw_user_favor t1
         WHERE   sys_id     = :gnv_vari.is_sys_id
           AND   user_id    = :is_login
           AND   parent_pgm = :ls_pgm_no;
			  
			ll_child_cnt = SQLCA.getitemnumber (1)

         IF ll_child_cnt>0 Then
		      IF messagebox('Notice', '하위 항목이 모두 삭제됩니다.~r~n진행하시겠습니까?', Question!, YesNo!, 2)=1 Then
					f_loadingrd (TRUE)
					uf_deleteall (il_handle)
					dw_favor.deleterow (1)
					f_loadingrd (FALSE)
					
					commitJ ()
					
					fw_f_message('U01', '', '')
					of_ship4var2event('ibrowchanged2event', TRUE)
					
					RETURN 1
				Else
					RETURN -1
				End IF
			End IF
		End IF
		
		IF messagebox('Notice', '선택하신 ' + ls_favor_nm + '[' + ls_pgm_no + '] 항목을 삭제하시겠습니까?', Question!, YesNo!, 2)=1   Then
			dw_favor.deleterow (1)
			tv_favor.POST deleteitem(il_handle)

			DELETE  fw_user_favor
			WHERE   sys_id  = :gnv_vari.is_sys_id
			  AND   user_id = :is_login
			  AND   pgm_no  = :ls_pgm_no;

			IF SQLCA.sqlcode ()<>0  Then
				ls_sqlerrtext = SQLCA.sqlerrtext ()
				rollbackJ ()
				MessageBox('Error : ' + '자료 삭제 실패했습니다!!' + string(SQLCA.sqlcode()), ls_sqlErrText)
				RETURN -1
			End IF

			commitJ ()
			
			fw_f_message('U01', '', '')
			of_ship4var2event('ibrowchanged2event', TRUE)
		End IF
END CHOOSE

RETURN 1
end event

event wue_update;IF dw_favor.uf_ismodified()	Then
	of_update({dw_favor})
End IF

RETURN 0
end event

event wue_input;// 항목추가
IF is_updatable<>'2'	Then
	messageBox ('ERR', '권한이 없습니다')
	RETURN -1
End IF

of_confirmupdate4rowchanged()

LONG	ll_sort_order, ll_root
STRING	ls_parent_pgm, ls_parent_favor_nm, ls_pgm_no

treeviewitem	ltvi_root, ltvi_item

ll_root = tv_favor.finditem (RootTreeItem!, il_handle)
tv_favor.getitem (ll_root, ltvi_root)

CHOOSE CASE itvi_item.pictureindex
	CASE 1, 3
	CASE 5
		Messagebox('Notice', '화면은 생성할 수 없습니다. 우측화면에서 드래그해 주십시요.')
		RETURN -1
	CASE ELSE
		Messagebox('Notice', '생성할 수 없습니다.')
		RETURN -1
END CHOOSE
dw_favor.reset()
dw_favor.insertrow (0)

ls_parent_pgm = 'ROOT'
ls_parent_favor_nm = ltvi_root.label

IF fw_f_nvls(ls_parent_pgm, '')=''  Then
	Messagebox('Notice', '먼저 상위 폴더를 선택하세요')
	RETURN -1
End IF

dw_favor.setitem(1, 'parent_pgm', ls_parent_pgm)
dw_favor.setitem(1, 'parent_favor_nm', ls_parent_favor_nm)

SELECT  max(sort_order)
  INTO  :ll_sort_order
FROM    fw_user_favor t1
WHERE   sys_id     = :gnv_vari.is_sys_id
  AND   user_id    = :is_login
  AND   parent_pgm = :ls_parent_pgm;

ll_sort_order = SQLCA.getitemnumber (1)

IF isnull(ll_sort_order)   THEN ll_sort_order = 0
ll_sort_order += 1

IF is_login='%' THEN dw_favor.setitem(1, 'use_yn', 'Y')

dw_favor.setitem(1, 'sys_id', gnv_vari.is_sys_id)
dw_favor.setitem(1, 'sort_order', ll_sort_order)
dw_favor.setitem(1, 'pgm_kind_code', 'M')
dw_favor.setitem(1, 'tree_level', 2)
dw_favor.setitem(1, 'editable', '2')
dw_favor.setitemstatus(1, 0, primary!, notmodified!)

dw_favor.setfocus()

RETURN 1
end event

event wue_retrieve;call super::wue_retrieve;of_favor_retrieve()
POST of_role_retrieve()
end event

event open;call super::open;ids_user_favor = CREATE ads_jTier
ids_user_favor.dataobject = 'fw_d_dime1_ds2'
ids_user_favor.settransobject(SQLCA)

ids_user_role = CREATE ads_jTier
ids_user_role.dataobject = 'fw_d_fullrollmenu_spc'
ids_user_role.settransobject(SQLCA)
end event

event wue_lastopen;call super::wue_lastopen;is_corp_gr = iif (gaa.aams, '2200', gaa.corp_gr)
is_login = gaa.login
is_login_nm = gnv_vari.is_user_nm
is_updatable = '2'

POST EVENT wue_retrieve ()
end event

event wue_postopen;call super::wue_postopen;STRING	ls_values=''

ls_values += gnv_vari.is_user_nm + '~t' + gaa.login
IF gaa.aams And gaa.corp_gr<>'2200'	THEN ls_values += '/한국펀드서비스~t1700'
ls_values += '/' + gaa.corp_nm + '~t' + gaa.corp_gr
ls_values += '/공통 디멘젼~t%'

dw_1.insertrow (0)
dw_1.modify ("type.values='" + ls_values + "'")
dw_1.object.type [1] = gaa.login
end event

event close;call super::close;gw_mdi.uf_refresh_dimension ()
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_dime1
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_dime1
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_dime1
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_dime1
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_dime1
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_dime1
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_dime1
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_dime1
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_dime1
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_dime1
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_dime1
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_dime1
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_dime1
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_dime1
end type

type st_top_rect from w_window1st5ncn`st_top_rect within fw_w_dime1
end type

type p_close from w_window1st5ncn`p_close within fw_w_dime1
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_dime1
end type

type p_print from w_window1st5ncn`p_print within fw_w_dime1
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_dime1
end type

type p_update from w_window1st5ncn`p_update within fw_w_dime1
end type

type p_input from w_window1st5ncn`p_input within fw_w_dime1
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_dime1
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_dime1
end type

type tv_favor from pf_u_treeview within fw_w_dime1
integer x = 50
integer y = 696
integer width = 2025
integer height = 2068
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
borderstyle borderstyle = stylebox!
boolean disabledragdrop = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif","..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif"}
boolean scaletobottom = true
end type

event itemexpanding;call super::itemexpanding;STRING	ls_pgm_no

LONG	ll_rowcnt, ll_child, i, ll_treelevel

treeviewitem ltvi_item

this.getitem(handle, ltvi_item)
IF ltvi_item.ExpandedOnce and not ib_redraw  THEN RETURN 0
IF this.finditem(ChildTreeItem!, handle) > 0 THEN RETURN 0

IF ltvi_item.Children   Then
   DO WHILE  DeleteItem (FindItem (ChildTreeItem!, handle))>0
   LOOP
End IF

ls_pgm_no = ltvi_item.data

ids_user_favor.setfilter ("parent_pgm='" + ls_pgm_no + "'")
ids_user_favor.filter ()
ll_rowcnt = ids_user_favor.rowcount ()

FOR i = 1 TO ll_rowcnt
   ltvi_item.data  = ids_user_favor.getitemstring(i, 'pgm_no')
   ltvi_item.label = ids_user_favor.getitemstring(i, 'favor_nm')
   ll_treelevel    = ids_user_favor.getitemnumber(i, 'tree_level')

   CHOOSE CASE ids_user_favor.getitemstring(i, 'pgm_kind_code')
      CASE 'M'
         CHOOSE CASE ll_treelevel
            CASE 1
               ltvi_item.pictureindex = 1
               ltvi_item.Selectedpictureindex = 2
            CASE 2
               ltvi_item.pictureindex = 3
               ltvi_item.Selectedpictureindex = 4
         END CHOOSE
      CASE 'P'
         ltvi_item.pictureindex = 5
         ltvi_item.Selectedpictureindex = 6
   END CHOOSE

   IF ids_user_favor.getitemnumber(i, 'child_cnt')>0  Then
      ltvi_item.Children = TRUE
   Else
      ltvi_item.Children = FALSE
   End IF

   ltvi_item.HasFocus = FALSE
   ltvi_item.selected = FALSE

   ll_child = this.InsertItemLast(handle, ltvi_item)
NEXT

ib_redraw = FALSE
end event

event selectionchanged;call super::selectionchanged;STRING	ls_pgm_no

DRAG (END!)
SetDropHighlight(0)

of_confirmupdate4rowchanged()

il_handle = newhandle
getitem(il_handle, itvi_item)

il_root = finditem(RootTreeItem!, il_handle)
CHOOSE CASE itvi_item.pictureindex
   CASE 1, 3
      il_parent = il_handle
      itvi_parent = itvi_item
   CASE ELSE
      il_parent = finditem(ParentTreeItem!, il_handle)
      getitem(il_parent, itvi_parent)
END CHOOSE

ls_pgm_no = itvi_item.data
dw_favor.retrieve (gnv_vari.is_sys_id, is_corp_gr, is_login, ls_pgm_no)

IF itvi_item.pictureindex=1	Then
	dw_favor.setitem (1, 'pgm_no', 'ROOT')
	dw_favor.setitem (1, 'pgm_kind_code', 'M')
	dw_favor.setitem (1, 'parent_pgm', 'UPROOT')
	dw_favor.setitem (1, 'parent_favor_nm', '최상위')
	dw_favor.setitem (1, 'favor_nm', string (itvi_item.label))
	dw_favor.setitem (1, 'tree_level', 1)
	dw_favor.setitem (1, 'sort_order', 1)
	dw_favor.setitem (1, 'editable', '0')
	dw_favor.setitemstatus (1, 0, primary!, notmodified!)
End IF

RETURN 0

end event

event key;IF keyflags=2 Then
   CHOOSE CASE key
      CASE KeyUpArrow!
         of_favor_itemmove(il_handle, 'upper')
      CASE KeyDownArrow!
         of_favor_itemmove(il_handle, 'lower')
   END CHOOSE
End IF

CHOOSE CASE key
   CASE KeyDelete!
      p_delete.POST EVENT clicked()
   CASE KeyInsert!
      p_input.POST EVENT clicked()
END CHOOSE

RETURN 1

end event

event begindrag;call super::begindrag;// 드래그될 아이템과 그 부모아이템을 보관 합니다
il_dragsource = handle
il_role_dragsource = 0
getitem(il_dragsource, itvi_src)
IF itvi_src.pictureindex<5 And is_updatable='2'	Then
	il_dragsource= 0
	DRAG (END!)
	RETURN
End IF
il_dragparent = FindItem(ParentTreeItem!, handle)

end event

event dragdrop;call super::dragdrop;LONG	ll_newitem, ll_dragsource, ll_moveitem, ll_targethandle, ll_cnt, ll_temp, ll_sort

TreeViewItem ltvi_Source, ltvi_Target, ltvi_Parent, ltvi_NewItem, ltvi_targetfolder, ltvi_temp

STRING	ls_folder

STRING	ls_parent_pgm, ls_pgm_no

pf_u_treeview  ltv

IF il_dragsource=0   Then
   ltv = tv_role
   ll_dragsource = il_role_dragsource
Else
   ltv = THIS
   ll_dragsource = il_dragsource
End IF

IF ltv.getitem(ll_dragsource, ltvi_Source)=-1 THEN RETURN
IF THIS.getitem(il_droptarget, ltvi_Target)=-1 THEN RETURN

// 메뉴 변경 사용자 확인
IF THIS.getitem(il_dragparent, ltvi_Parent)=-1  Then
   ltvi_Parent.Label = 'UPROOT'
End IF


IF ltvi_Target.pictureindex=3	Then
   ls_folder = '1'
   ltvi_targetfolder = ltvi_Target
   ll_targethandle = il_droptarget
   ls_parent_pgm = string (ltvi_Target.data)
ElseIF ltvi_Target.pictureindex=5	Then
   ls_folder = '2'
   ll_targethandle = FindItem(ParentTreeItem!, il_droptarget)
   getitem (ll_targethandle, ltvi_targetfolder)
   ls_parent_pgm = string (ltvi_targetfolder.data)
Else //UPROOT
   ls_folder = '0'
   ltvi_targetfolder = ltvi_targetfolder
   RETURN
End IF

setredraw(FALSE)
POST setredraw(TRUE)

// 타겟메뉴 펼침
IF ltvi_Target.expanded=FALSE Then
   expanditem(il_droptarget)
End IF

// <개발>
// 1. 같은폴더내 단순 이동인지
// 2. 해당 폴더에 이미 7개가 들어있는지
// 3. 추가인 경우 디멘젼에 이미 해당 파일이 있는지

//단순 SORT 변경
IF ll_targethandle=il_dragparent And il_dragsource>0  Then
   f_loadingrd (TRUE)
   IF ls_folder='1'  Then
      ll_newitem = InsertItemFirst(ll_targethandle, ltvi_source)
   ElseIF ls_folder='2' Then
      ll_newitem = insertitem(ll_targethandle, handle, ltvi_Source)
   End IF
   IF il_dragsource>0 THEN deleteitem(ll_dragsource)
   selectitem(ll_newitem)
   uf_sort_order (ll_targethandle)
   commitJ ()
   f_loadingrd (FALSE)
   event selectionchanged (il_dragsource, ll_newitem)
   RETURN
End IF

//이미 7개가 들어있는지
SELECT  count (*)
  INTO  :ll_cnt
FROM    fw_user_favor t1
WHERE   sys_id     = :gnv_vari.is_sys_id
  AND   user_id    = :is_login
  AND   parent_pgm = :ls_parent_pgm;

ll_cnt = SQLCA.getitemnumber (1)

IF ll_cnt>=7   Then
   f_messageBox ('ERR', '디멘젼은 폴더당 7개 까지만 등록가능합니다.')
   RETURN
Else
   //새로 추가시 중복된 아이템 있는지 확인필요
   IF il_role_dragsource>0 Then
      ls_pgm_no = string (ltvi_source.data)
      SELECT  pgm_no
        INTO  :ls_pgm_no
      FROM    fw_user_favor t1
      WHERE   sys_id  = :gnv_vari.is_sys_id
        AND   user_id = :is_login
        AND   pgm_no  = :ls_pgm_no;

			ls_pgm_no = SQLCA.getitemstring (1)

         IF SQLCA.sqlcode()=0 Then
         f_messageBox ('ERR', '이미 등록되어 있는 화면입니다.')
         RETURN
         End IF
   End IF

   // 폴더이동
   f_loadingrd (TRUE)
   SetNull(ltvi_Source.ItemHandle)
   IF ls_folder='1'  Then
      ll_newitem = InsertItemFirst(ll_targethandle, ltvi_source)
   ElseIF ls_folder='2' Then
      ll_newitem = insertitem(ll_targethandle, handle, ltvi_Source)
   End IF
   getitem(ll_newitem, ltvi_newitem)

   IF il_dragsource>0   Then
      of_movechildren(ll_dragsource, ll_NewItem)
      deleteitem(ll_dragsource)
   End IF

   STRING	ls_dragparent_pgm

   ls_pgm_no = string (ltvi_newitem.data)
   IF il_role_dragsource>0 Then
      INSERT INTO  fw_user_favor (
                     sys_id                           /* _1: */
                   , user_id                          /* _2: */
                   , pgm_no                           /* _3: */
                   , pgm_kind_code                    /* _4: */
                   , parent_pgm                       /* _5: */
                   , sort_order                       /* _6: */
                   , reg_id                           /* _7: */
                   , reg_dt                           /* _8: */
                   , tree_level )                     /* _9: */
      VALUES ( :gnv_vari.is_sys_id                        /* _1: */
             , :is_login                                  /* _2: */
             , :ls_pgm_no                                 /* _3: */
             , 'P'                                        /* _4: */
             , :ls_parent_pgm                             /* _5: */
             , 1                                          /* _6: */
             , :is_corp_gr || '_' || :gnv_vari.is_user_id  /* _7: */
             , now()                                    /* _8: */
             , 3                                          /* _9: */
             );
   Else
      ls_dragparent_pgm = string (ltvi_Parent.data)
      //이동 및 순번
      UPDATE  fw_user_favor
         SET  parent_pgm = :ls_parent_pgm
      WHERE   sys_id     = :gnv_vari.is_sys_id
        AND   user_id    = :is_login
        AND   parent_pgm = :ls_dragparent_pgm
        AND   pgm_no     = :ls_pgm_no;
   End IF

   uf_sort_order (ll_targethandle)

   // 하이라이트 취소
   SetDropHighlight(0)
   selectitem (ll_newitem)
   commitJ ()
   f_loadingrd (FALSE)
   event selectionchanged (il_dragsource, ll_newitem)
   RETURN
End IF
end event

event dragwithin;call super::dragwithin;LONG	ll_Parent, ll_dragsource, ll_getitem
TreeViewItem ltvi_Over

BOOLEAN	lb_role

IF il_dragsource = 0	Then
	lb_role = TRUE
	ll_dragsource = il_role_dragsource
Else
	lb_role = FALSE
	ll_dragsource = il_dragsource
End IF

// 부모 노드는 선택 안 함
//IF lb_role = FALSE Then
//	IF handle=il_dragparent THEN RETURN
//End IF

ll_getitem = GetItem(handle, ltvi_Over)

IF ll_getitem = -1	Then
		SetDropHighlight(0)
		il_droptarget = 0
		RETURN
End IF

// 타겟은 폴더만 선택 가능
IF ltvi_Over.pictureindex >= 3	Then
	il_droptarget = handle
	SetDropHighlight(il_droptarget)
Else
   SetDropHighlight(0)
   il_droptarget = 0
   RETURN
End IF

// 타겟과 소스가 동일
IF ll_dragsource=handle And lb_role=FALSE Then
   SetDropHighlight(0)
   il_droptarget = 0
   RETURN
End IF

// 폴더는 자신의 하위 노드로 이동 불가
//IF itvi_src.pictureindex>2 Then
//   ll_Parent = FindItem(ParentTreeItem!, handle)
//   DO WHILE ll_Parent > 0
//      IF ll_Parent=ll_dragsource And lb_role=FALSE Then
//         SetDropHighlight(0)
//         il_droptarget = 0
//         RETURN
//      End IF
//      ll_Parent = FindItem(ParentTreeItem!, ll_Parent)
//   LOOP
//End IF

// MouseOver 하이라이트 처리
//il_droptarget = handle
//SetDropHighlight(il_droptarget)
end event

type cbx_role_expand from pf_u_checkbox within fw_w_dime1
integer x = 5093
integer y = 168
integer width = 338
integer height = 76
boolean bringtotop = true
long textcolor = 19737901
string text = "열린 메뉴"
boolean setsheetcolor = true
boolean fixedtoright = true
end type

event clicked;call super::clicked;POST of_role_retrieve()
end event

type uo_favor_tvtitle from fw_u_dw2title within fw_w_dime1
integer x = 50
integer y = 164
integer width = 512
integer taborder = 90
boolean bringtotop = true
string istitletext = "디멘션 메뉴"
end type

on uo_favor_tvtitle.destroy
call fw_u_dw2title::destroy
end on

type st_v1 from pf_u_splitbar_vertical within fw_w_dime1
integer x = 2075
integer y = 244
integer width = 23
integer height = 2520
boolean bringtotop = true
boolean setcondcolor = true
string leftdragobject = "tv_favor;uo_favor_tvtitle;dw_1"
string rightdragobject = "dw_favor"
end type

type tv_role from pf_u_treeview within fw_w_dime1
integer x = 5010
integer y = 244
integer width = 421
integer height = 2520
integer taborder = 20
boolean dragauto = true
boolean bringtotop = true
borderstyle borderstyle = stylebox!
boolean disabledragdrop = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif","..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif"}
boolean scaletoright = true
boolean scaletobottom = true
end type

event itemexpanding;call super::itemexpanding;treeviewitem ltvi_item

STRING	ls_pgm_no

LONG	ll_rowcnt, ll_child, i

this.getitem(handle, ltvi_item)
IF ltvi_item.Children   Then
   DO WHILE  DeleteItem (FindItem (ChildTreeItem!, handle))>0
   LOOP
End IF

ls_pgm_no = ltvi_item.data

ids_user_role.setfilter ("parent_pgm='" + ls_pgm_no + "'")
ids_user_role.filter ()
ids_user_role.setsort ("sort_order asc")
ids_user_role.sort ()

ll_rowcnt = ids_user_role.rowcount ()

for i = 1 to ll_rowcnt
   ltvi_item.data = ids_user_role.getitemstring(i, 'pgm_no')
   ltvi_item.label = ids_user_role.getitemstring(i, 'pgm_nm')

   CHOOSE CASE ids_user_role.getitemstring(i, 'pgm_kc')
	//CHOOSE CASE ids_user_role.getitemstring(i, 'pgm_kind_code')
      CASE 'M'
         IF ltvi_item.data='00000'  Then
            ltvi_item.PictureIndex = 1
            ltvi_item.SelectedPictureIndex = 2
         Else
            ltvi_item.PictureIndex = 3
            ltvi_item.SelectedPictureIndex = 4
         End IF
      CASE 'P'
         ltvi_item.PictureIndex = 5
         ltvi_item.SelectedPictureIndex = 6
   END CHOOSE

   IF ids_user_role.getitemstring(i, 'pgm_kc')='M' Then
	//IF ids_user_role.getitemstring(i, 'pgm_kind_code')='M' Then
      ltvi_item.Children = TRUE
   else
      ltvi_item.Children = FALSE
   End IF

   ltvi_item.HasFocus = FALSE
   ltvi_item.selected = FALSE

   ll_child = this.InsertItemLast(handle, ltvi_item)
next
end event

event begindrag;call super::begindrag;il_role_dragsource = handle
il_dragsource = 0
getitem(il_role_dragsource, itvi_src)
IF itvi_src.pictureindex<5 And is_updatable='2'	Then
	il_role_dragsource = 0 
	DRAG (END!)
	RETURN
End IF
ib_role_redraw = TRUE
end event

type uo_role_title from fw_u_dw2title within fw_w_dime1
integer x = 5010
integer y = 164
integer width = 421
integer taborder = 100
boolean bringtotop = true
string istitletext = "사용자 메뉴"
end type

on uo_role_title.destroy
call fw_u_dw2title::destroy
end on

type st_v2 from pf_u_splitbar_vertical within fw_w_dime1
integer x = 4987
integer y = 244
integer width = 23
integer height = 2520
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
string leftdragobject = "dw_favor"
string rightdragobject = "tv_role"
end type

event move;call super::move;uo_role_title.x = this.x + this.width
end event

type dw_favor from u_dw within fw_w_dime1
integer x = 2098
integer y = 156
integer width = 2889
integer height = 2608
integer taborder = 20
string title = "프로그램 상세"
string dataobject = "fw_d_dime1_1"
boolean scaletobottom = true
boolean ibtitle4datawindow = true
end type

event oue_setupdatecheck;call super::oue_setupdatecheck;STRING	ls_pgm_kind_code, ls_pgm_id, ls_favor_nm, ls_parent_pgm

ls_pgm_kind_code = dw_favor.getitemstring(1, 'pgm_kind_code')
IF isnull(ls_pgm_kind_code) or len(TRIM(ls_pgm_kind_code))=0   Then
   messagebox('Notice', '폴더/프로그램 구분을 입력하세요')
   RETURN -1
End IF

ls_favor_nm = dw_favor.getitemstring(1, 'favor_nm')
IF isnull(ls_favor_nm) or len(TRIM(ls_favor_nm))=0 Then
   messagebox('Notice', '프로그램 명칭을 입력하세요')
   RETURN -1
End IF

ls_parent_pgm = dw_favor.getitemstring(1, 'parent_pgm')
IF isnull(ls_parent_pgm) or len(TRIM(ls_parent_pgm))=0   Then
   messagebox('Notice', '먼저 상위메뉴를 선택 하세요')
   RETURN -1
End IF

RETURN 1

end event

event updatestart;call super::updatestart;string   ls_pgm_no, ls_favor_nm, ls_pgm_kind_code, ls_new_pgm_no
IF AncestorReturnValue=1 THEN RETURN 1
LONG	ll_rcnt, ll_row, ll_nowseq = 0
dwitemstatus    ldwstatus

LONG	ll_newhandle
treeviewitem ltvi_item

ll_rcnt = rowcount ()

DO WHILE ll_row <= ll_rcnt
   ll_row = getnextmodified(ll_row, Primary!)
   IF ll_row>0 Then
      ldwstatus = getitemstatus(ll_row, 0, Primary!)

      ls_pgm_kind_code = getitemstring(ll_row, 'pgm_kind_code')
      ls_pgm_no = getitemstring(ll_row, 'pgm_no')
      ls_favor_nm = getitemstring(ll_row, 'favor_nm')

      CHOOSE CASE ldwstatus
         CASE NewModified!
            ll_nowseq += 1

            IF ls_pgm_kind_code='M' Then
               SELECT  'FVR' || TRIM(to_char(nvl(to_number(substr(max(la.pgm_no),4,2)) + :ll_nowseq,1),'00'))
                 INTO  :ls_pgm_no
               FROM    fw_user_favor la
               WHERE   la.sys_id  = :gnv_vari.is_sys_id
                 AND   la.user_id = :is_login
                 AND   la.pgm_no  LIKE 'FVR%';

					ls_pgm_no = SQLCA.getitemstring (1)

               IF SQLCA.sqlcode ()<>0  Then
                  messagebox("error", "favor_nm를 생성하지 못했습니다. ")
                  RETURN 1
               End IF
            End IF

            setItem(ll_row, 'sys_id', gnv_vari.is_sys_id)
            setItem(ll_row, 'user_id', is_login)
            setItem(ll_row, 'pgm_no', ls_pgm_no)

            setItem(ll_row, 'reg_id', is_corp_gr + '_' + gnv_vari.is_user_id)
            setItem(ll_row, 'reg_dt', f_sysdate_str (null_s))
            setItem(ll_row, 'upd_id', is_corp_gr + '_' + gnv_vari.is_user_id)
            setItem(ll_row, 'upd_dt', f_sysdate_str (null_s))

            // TreeView Item 생성
            ltvi_item.data = ls_pgm_no
            ltvi_item.label = ls_favor_nm

            CHOOSE CASE ls_pgm_kind_code
               CASE 'M' //2단계만 있기 때문에 parent level은 고려할 필요 없음
						ltvi_item.PictureIndex = 3
						ltvi_item.SelectedPictureIndex = 4
						ltvi_item.Children = FALSE
						ltvi_item.expandedonce = TRUE
               CASE 'P'
                  ltvi_item.PictureIndex = 5
                  ltvi_item.SelectedPictureIndex = 6
                  ltvi_item.Children = FALSE
            END CHOOSE

            ltvi_item.HasFocus = FALSE
            ltvi_item.selected = FALSE

            ll_newhandle = tv_favor.InsertItemLast(il_root, ltvi_item)
            IF itvi_parent.Expanded=FALSE Then
               itvi_parent.ExpandedOnce = TRUE
               tv_favor.ExpandItem(il_root)
            End IF

         CASE DataModified!
            setItem(ll_row, 'upd_id', is_corp_gr + '_' + gnv_vari.is_user_id)
            setItem(ll_row, 'upd_dt', f_sysdate_str (null_s))

            tv_favor.getitem(il_handle, ltvi_item)
            ltvi_item.label = ls_favor_nm
            tv_favor.setitem(il_handle, ltvi_item)
      END CHOOSE
   ELSE
      ll_row = ll_rcnt + 1
   End IF
LOOP

end event

event retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
tv_favor.post setfocus()
end event

event itemchanged;call super::itemchanged;STRING	ls_pgm_no, ls_seq, ls_temp

LONG	ll_seq

IF dwo.name='sopen'	Then
	messageBox ('', data)
	IF data = 'Y'	Then
		UPDATE  fw_user_favor
			SET  sopen = ''
		WHERE   sys_id  = :gnv_vari.is_sys_id
		  AND   user_id = :is_login;
		  
		ls_pgm_no = object.pgm_no [row]
		
		UPDATE  fw_user_favor
			SET  sopen = 'Y'
		WHERE   sys_id  = :gnv_vari.is_sys_id
		  AND   user_id = :is_login
		  AND   pgm_no  = :ls_pgm_no;
	Else
		data = ''
		UPDATE  fw_user_favor
			SET  sopen = ''
		WHERE   sys_id  = :gnv_vari.is_sys_id
		  AND   user_id = :is_login;
	End IF
ElseIF dwo.name='use_yn'	Then
	f_loadingrd (TRUE)
	SELECT  to_char (substr (pgm_no, 7))
	  INTO  :ll_seq
	FROM    fw_user_favor
	WHERE   substr (pgm_no, 1, 6) = 'DELETE';
	
	ll_seq = long (f_nvl (SQLCA.getitemstring (1), '0'))
	ls_pgm_no = object.pgm_no [row]
						
	SELECT  ''
	  INTO  :ls_temp
	FROM    fw_user_favor
	WHERE   sys_id     = :gnv_vari.is_sys_id
	  AND   user_id    = :is_corp_gr
	  AND   substr (pgm_no, 1, 6) = 'DELETE'
	  AND   parent_pgm = :ls_pgm_no;
	
	ll_seq ++
	ls_seq = 'DELETE' + string (ll_seq)
	
	//취소시 없으면 삭제내역 추가
	//체크시 있으면 삭제내역 삭제
	IF SQLCA.sqlcode ()=0	Then
		//있음
		IF data='Y'	Then
			DELETE  fw_user_favor
			WHERE   sys_id     = :gnv_vari.is_sys_id
			  AND   user_id    = :is_corp_gr
			  AND   substr (pgm_no, 1, 6) = 'DELETE'
			  AND   parent_pgm = :ls_pgm_no;
		End IF
	Else
		IF data='N'	Then
			ls_temp = is_corp_gr + '_' + gnv_vari.is_user_id
			INSERT INTO fw_user_favor
					( sys_id
					, user_id
					, pgm_no
					, parent_pgm
					, reg_id
					, reg_dt
					)
			VALUES
					( :gnv_vari.is_sys_id
					, :is_corp_gr
					, :ls_seq
					, :ls_pgm_no
					, :ls_temp
					, now()
					);
		End IF
	End IF
	f_loadingrd (FALSE)
End IF
end event

event itemchanged_next;call super::itemchanged_next;IF name='use_yn'	Then
	setitemstatus (row, 'use_yn', primary!, notmodified!)
End IF
end event

event retrieverow;call super::retrieverow;object.editable [row] = is_updatable
setitemstatus (row, 0 ,primary!, notmodified!)
end event

type dw_1 from u_dw within fw_w_dime1
integer x = 50
integer y = 248
integer width = 2025
integer height = 424
integer taborder = 30
boolean bringtotop = true
boolean enabled = true
string dataobject = "fw_d_dime1_c"
end type

event itemchanged;call super::itemchanged;IF dwo.name = 'type'	Then
	is_login = data
	f_visible (dw_favor, FALSE, 'sopen_t')
	CHOOSE CASE data
		CASE gaa.login
			is_login_nm = gnv_vari.is_user_nm
			is_updatable = '2'
			f_visible (dw_favor, TRUE, 'sopen_t')
		CASE '2200'
			is_login_nm = '한국펀드서비스'
			is_updatable = '2'
		CASE gaa.corp_gr
			is_login_nm = gaa.corp_nm
			is_updatable = '2'
		CASE '%'
			is_login_nm = '공통 디멘젼'
			IF gaa.aams	Then
				IF gaa.login='yjs1992@hitel.net'	Then
					is_updatable = '2'
				Else
					is_updatable = '0'
				End IF
			ElseIF gaa.admin	Then
				is_updatable = '1'
			Else
				is_updatable = '0'
			End IF
	END CHOOSE
End IF

event wue_retrieve ()
end event

