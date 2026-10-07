forward
global type w_dimension_mst from wt_treelistdetail
end type
type ddlb_1 from pf_u_dropdownlistbox within w_dimension_mst
end type
type st_1 from pf_u_statictext within w_dimension_mst
end type
type cbx_1 from pf_u_checkbox within w_dimension_mst
end type
end forward

global type w_dimension_mst from wt_treelistdetail
boolean eb_direct_retrieve = true
ddlb_1 ddlb_1
st_1 st_1
cbx_1 cbx_1
end type
global w_dimension_mst w_dimension_mst

type variables
ads_jTier	ids_fullmenu

LONG	il_DragSource, drag_row=-1, drag_obj

BOOLEAN	lb_syncronized=FALSE, ib_base_dimension=FALSE

DRAGOBJECT	id_source

STRING	is_user_id
end variables

on w_dimension_mst.create
int iCurrent
call super::create
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_1
end on

on w_dimension_mst.destroy
call super::destroy
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.cbx_1)
end on

event wue_retrieve;call super::wue_retrieve;drag_row = -1
dw_detail.reset ()
dw_list.retrieve (is_user_id, iif (ddlb_1.of_getselectedindex()=3,'%',is_user_id), iif (ib_base_dimension, 1, 0))
end event

event wue_lastopen;call super::wue_lastopen;long	ll_rowcnt, ll_handle, i, ll_roothndl

treeviewitem	ltvi_item

is_user_id = gaa.login

ids_fullmenu = gnv_rolemenu.ids_fullmenudata

ids_fullmenu.setfilter ("parent_pgm='ROOT'")
ids_fullmenu.filter ()

ll_handle = tv_tree.finditem(roottreeitem!, 0)
do while ll_handle > 0
	tv_tree.deleteitem(ll_handle)
	ll_handle = tv_tree.finditem(roottreeitem!, ll_handle)
loop

ll_rowcnt = ids_fullmenu.rowcount ()

FOR  i = 1  TO  ll_rowcnt
	ltvi_item.data = ids_fullmenu.getitemstring(i, 'pgm_no')
	ltvi_item.label = ids_fullmenu.getitemstring(i, 'pgm_nm')
	
	Choose Case ids_fullmenu.getitemstring(i, 'pgm_kc')
		Case 'M'
			If ltvi_item.data = '00000' Then
				ltvi_item.PictureIndex = 1
				ltvi_item.SelectedPictureIndex = 2
			Else
				ltvi_item.label += ' (' + ids_fullmenu.getitemstring(i, 'pgm_no') + ')'
				ltvi_item.PictureIndex = 3
				ltvi_item.SelectedPictureIndex = 4				
			End If
		Case 'P'
			IF	f_notnull (ids_fullmenu.getitemstring(i, 'pgm_id')) THEN ltvi_item.label += ' (' + ids_fullmenu.getitemstring(i, 'pgm_id') + ')'
			ltvi_item.PictureIndex = 5
			ltvi_item.SelectedPictureIndex = 6
	End Choose

	ltvi_item.Children = (ids_fullmenu.getitemstring(i, 'pgm_kc')='M')//(ids_fullmenu.getitemnumber(i, 'child_cnt') > 0)

	ll_handle = tv_tree.InsertItemLast(0, ltvi_item)
NEXT

ll_handle = tv_tree.finditem(roottreeitem!, 0)
ll_roothndl = ll_handle
DO WHILE ll_handle > 0
	tv_tree.expanditem(ll_handle)
	ll_handle = tv_tree.finditem(NextTreeItem!, ll_handle)
LOOP

tv_tree.SetFirstVisible(ll_roothndl)
tv_tree.Post selectitem(ll_roothndl)
end event

event wue_postopen;call super::wue_postopen;ddlb_1.visible = gaa.admin
st_1.visible = gaa.admin

ddlb_1.selectitem (1)
end event

event resize;call super::resize;ddlb_1.x = st_vmove.x + st_vmove.width + 10
st_1.x = ddlb_1.x + ddlb_1.width + 30
ddlb_1.y = dw_list.y - 120
st_1.y = ddlb_1.y + 10
cbx_1.x = st_1.x + st_1.width + 30
cbx_1.y = ddlb_1.y + 10
end event

event close;call super::close;gw_mdi.uf_refresh_dimension ()
end event

type lb_dirlist from wt_treelistdetail`lb_dirlist within w_dimension_mst
end type

type ln_templeft from wt_treelistdetail`ln_templeft within w_dimension_mst
end type

type ln_tempbuttom from wt_treelistdetail`ln_tempbuttom within w_dimension_mst
end type

type ln_temptop from wt_treelistdetail`ln_temptop within w_dimension_mst
end type

type ln_tempbutton from wt_treelistdetail`ln_tempbutton within w_dimension_mst
end type

type ln_tempstart from wt_treelistdetail`ln_tempstart within w_dimension_mst
end type

type ln_cond1_yline from wt_treelistdetail`ln_cond1_yline within w_dimension_mst
end type

type ln_dw1_yline from wt_treelistdetail`ln_dw1_yline within w_dimension_mst
end type

type ln_cond2_yline from wt_treelistdetail`ln_cond2_yline within w_dimension_mst
end type

type ln_dw2_yline from wt_treelistdetail`ln_dw2_yline within w_dimension_mst
end type

type ln_tempright from wt_treelistdetail`ln_tempright within w_dimension_mst
end type

type uo_navi from wt_treelistdetail`uo_navi within w_dimension_mst
end type

type ln_temptop_shadow from wt_treelistdetail`ln_temptop_shadow within w_dimension_mst
end type

type st_windelaytime from wt_treelistdetail`st_windelaytime within w_dimension_mst
end type

type st_top_rect from wt_treelistdetail`st_top_rect within w_dimension_mst
end type

type p_close from wt_treelistdetail`p_close within w_dimension_mst
end type

type p_excel from wt_treelistdetail`p_excel within w_dimension_mst
end type

type p_print from wt_treelistdetail`p_print within w_dimension_mst
end type

type p_delete from wt_treelistdetail`p_delete within w_dimension_mst
end type

type p_update from wt_treelistdetail`p_update within w_dimension_mst
end type

type p_input from wt_treelistdetail`p_input within w_dimension_mst
end type

type p_retrieve from wt_treelistdetail`p_retrieve within w_dimension_mst
end type

type p_clear from wt_treelistdetail`p_clear within w_dimension_mst
end type

type p_copy from wt_treelistdetail`p_copy within w_dimension_mst
end type

type dw_c from wt_treelistdetail`dw_c within w_dimension_mst
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_treelistdetail`btn_update within w_dimension_mst
end type

type st_count from wt_treelistdetail`st_count within w_dimension_mst
end type

type dw_list from wt_treelistdetail`dw_list within w_dimension_mst
integer y = 268
integer height = 1176
string dragicon = "..\img\ICAM\up_down.ico"
string dataobject = "d_dimension_mst_list"
boolean eb_copy_false = true
boolean eb_null_line = false
end type

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	ll_seq=0, ll, ll_cseq, ll_csort, ll_sort

FOR  ll = 1  TO  dw_list.rowcount()
	ll_cseq = long(string (mid(dw_list.object.pgm_no [ll], 4)))
	IF ll_cseq=0 THEN ll_cseq=long(string (mid(dw_list.object.pgm_no [ll], 5)))
	ll_csort = dw_list.object.sort_order [ll]
	IF ll_cseq>ll_seq THEN ll_seq=ll_cseq
	IF ll_csort>ll_sort THEN ll_sort=ll_csort
NEXT

ll_seq += 1

uf_setcolumn ('sys_id'        , 'SY')
uf_setcolumn ('user_id'       , iif (ddlb_1.of_getselectedindex()=3,'%',is_user_id))
uf_setcolumn ('pgm_no'        , 'FVR' + string (ll_seq, '00'))
uf_setcolumn ('pgm_kind_code' , 'M')
uf_setcolumn ('parent_pgm'    , 'ROOT')
uf_setcolumn ('sort_order'    , string (ll_sort + 1))
uf_setcolumn ('use_yn'        , 'Y')
uf_setcolumn ('editable'      , '0')

RETURN 0
end event

event dw_list::clicked;IF row=0 THEN RETURN

IF ib_base_dimension Then
	call super::clicked
Else
	IF dwo.name <> 'favor_desc' And NOT ib_base_dimension	And dwo.name<>'use_yn' and dwo.name <> 'sopen' 	Then
		selectRow (0, FALSE)
		selectRow (row, TRUE)
		drag_obj = 1
		drag_row = row
		DRAG (Begin!)
	End IF
End IF
end event

event dw_list::dragwithin;call super::dragwithin;//<임시> 드래그 동작이 이상하여 수정하였습니다
IF drag_obj<>1 THEN RETURN
IF row=0 or lb_syncronized or row>rowcount() THEN RETURN
lb_syncronized = TRUE
setredraw (FALSE)

IF drag_row<>row  Then
   IF drag_row<row   Then
      RowsMove (drag_row, drag_row, Primary!, THIS, row + 1, Primary!)
   Else
      RowsMove (drag_row, drag_row, Primary!, THIS, row, Primary!)
   End IF
   SelectRow (0, FALSE)
   SelectRow (row, TRUE)
   drag_row = row
	id_source = source
End IF

setredraw (TRUE)
lb_syncronized = FALSE
end event

event dw_list::dragdrop;call super::dragdrop;IF drag_obj = 1 Then
	setrow (drag_row)
	iRow = drag_row
	drag_row = -1
		
	LONG	ll
	
	FOR ll = 1 TO rowcount ()
		IF object.sort_order [ll] <> ll THEN object.sort_order [ll] = ll
	NEXT
	
	event rowfocuschanged_if (iRow)
ElseIF drag_obj = 2 Then
	dwobject ldwo
	ldwo = CREATE dwobject
	
	dw_detail.event dragdrop (id_source, drag_row, ldwo)
End IF
end event

event dw_list::rowfocuschanged_if;IF drag_row = -1 Then
	call super::rowfocuschanged_if
Else
	RETURN 1
End IF
end event

event dw_list::itemchanged;call super::itemchanged;LONG	ll, ll_cur_row, ll_data

IF dwo.name = 'sort_order' Then
	ll_data = long (data)
	ll_cur_row = FIND ('sort_order=' + string (ll_data), 0, rowcount())
	IF ll_cur_row > 0 Then
		FOR ll = ll_cur_row TO rowcount ()
			IF ll = row THEN CONTINUE
			IF object.sort_order [ll] = ll_data Then
				ll_data += 1
				object.sort_order [ll] = ll_data
			Else
				EXIT
			End IF
		NEXT
	End IF
	
	setsort ('sort_order asc')
	sort ()
ElseIF dwo.name = 'sopen' Then
	FOR ll = 1 TO dw_list.rowcount()
		IF ll=row THEN CONTINUE
		dw_list.object.sopen [ll] = ''
	NEXT
End IF
end event

event dw_list::updatestart;call super::updatestart;LONG	ll=0, ll_seq

STRING	ls_corp_gr, ls_pgm_no, ls_temp, ls_seq

//날짜입력
IF ib_base_dimension=FALSE Then
	DO WHILE ll <= rowcount()
		ll = dw_list.GetNextModified(ll, Primary!)
		IF ll>0 Then
			IF getitemstatus (ll, 0 , Primary!)=NewModified!	Then
				dw_list.object.reg_id [ll] = iif (gaa.aams, '2200', gaa.corp_gr) + '_' + gnv_vari.is_user_id
				dw_list.object.reg_dt [ll] = f_sysdate_str(null_s)
			ElseIF getitemstatus (ll, 0 , Primary!)=DataModified!	Then
				dw_list.object.upd_id [ll] = iif (gaa.aams, '2200', gaa.corp_gr) + '_' + gnv_vari.is_user_id
				dw_list.object.upd_dt [ll] = f_sysdate_str(null_s)
			End IF
		Else
			EXIT
		End IF
	LOOP
End IF

IF ddlb_1.of_getselectedindex()=3 Then
	IF gaa.aams	Then
		ls_corp_gr = '2200'
	Else
		ls_corp_gr = gaa.corp_gr
	End IF

	SELECT  to_char (substr (pgm_no, 7))
	  INTO  :ls_seq
	FROM    fw_user_favor
	WHERE   substr (pgm_no, 1, 6) = 'DELETE';
			
	ll_seq = long (f_nvl (SQLCA.getitemstring (1), '0'))
	DO WHILE ll <= rowcount()
		ll = dw_list.GetNextModified(ll, Primary!)
		IF ll > 0 Then
			ls_pgm_no = dw_list.object.pgm_no [ll]
									
			SELECT  ''
			  INTO  :ls_temp
			FROM    fw_user_favor
			WHERE   sys_id     = :gnv_vari.is_sys_id
			  AND   user_id    = :ls_corp_gr
			  AND   substr (pgm_no, 1, 6) = 'DELETE'
			  AND   parent_pgm = :ls_pgm_no;
			
			ll_seq ++
			ls_seq = 'DELETE' + string (ll_seq)
			
			//취소시 없으면 삭제내역 추가
			//체크시 있으면 삭제내역 삭제
			IF SQLCA.sqlcode ()=0	Then
				//있음
				IF dw_list.object.use_yn [ll]='Y'	Then
					DELETE  fw_user_favor
					WHERE   sys_id     = :gnv_vari.is_sys_id
					  AND   user_id    = :ls_corp_gr
			        AND   substr (pgm_no, 1, 6) = 'DELETE'
					  AND   parent_pgm = :ls_pgm_no;
				End IF
			Else
				IF dw_list.object.use_yn [ll]='N'	Then
					ls_temp = iif (gaa.aams, '2200', gaa.corp_gr) + '_' + gnv_vari.is_user_id
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
							, :ls_corp_gr
							, :ls_seq
							, :ls_pgm_no
							, :ls_temp
							, now()
							);
				End IF
			End IF
		Else
			EXIT
		End IF
	LOOP
End IF
end event

type dw_detail from wt_treelistdetail`dw_detail within w_dimension_mst
string dragicon = "..\img\ICAM\up_down.ico"
string dataobject = "d_dimension_mst_detail"
boolean eb_new_false = true
boolean eb_copy_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;dw_detail.retrieve ('SY', iif (ddlb_1.of_getselectedindex()=3,'%',is_user_id), dw_list.object.pgm_no [iRow], iif (ib_base_dimension, 1, 0))
end event

event dw_detail::dragdrop;call super::dragdrop;IF drag_obj=0 Then
	//드래그 종료
	treeviewitem ltvi_item
	
	LONG	ll_row
	
	STRING	ls_pgm_go, ls_pgm_nm, ls_pgm_no, ls_user_id
	
	tv_tree.getitem (il_DragSource, ltvi_item)
	
	il_DragSource = -1
	
	IF ltvi_item.PictureIndex = 5 And NOT ib_base_dimension And iRow>0	Then
		IF dw_detail.rowcount()>=7 And ddlb_1.of_getselectedindex()=1 Then
			f_messagebox ('ERR', '즐겨찾기는 7개까지만 등록가능합니다.')
			RETURN
		End IF
		
		ls_pgm_go  = f_nvl (MID (ltvi_item.label, 1, 4), '....')
		ls_pgm_nm  = MID (ltvi_item.label, 6)
		ls_pgm_no  = string (ltvi_item.data)
		ls_user_id = iif (ddlb_1.of_getselectedindex()=3,'%',is_user_id)
		
		IF dw_detail.FIND ("pgm_no='" + string (ltvi_item.data) + "'", 1, dw_detail.rowcount ())>0 Then
			messageBox ('ERR', '이미 등록되어 있는 화면입니다.', StopSign!)
			RETURN
		Else
			SELECT  ''
			  INTO  :ls_pgm_go
			FROM    fw_user_favor
			WHERE   sys_id  = :gnv_vari.is_sys_id
			  AND   user_id = :ls_user_id
			  AND   pgm_no  = :ls_pgm_no;
			
			IF SQLCA.sqlcode()=0 Then
				messageBox ('ERR', '이미 등록되어 있는 화면입니다.', StopSign!)
				RETURN
			End IF
		End IF
		
		ll_row = event ue_insert(0)
		dw_detail.object.pgm_no [ll_row] = ls_pgm_no
		dw_detail.object.pgm_go [ll_row] = ls_pgm_go
		dw_detail.object.pgm_nm [ll_row] = ls_pgm_nm
	End IF
ElseIF drag_obj=1 Then
	dwobject ldwo
	ldwo = CREATE dwobject
	
	dw_list.event dragdrop (id_source, drag_row, ldwo)
ElseIf drag_obj=2	Then
	LONG	ll
	
	FOR ll = 1 TO rowcount ()
		IF object.sort_order [ll] <> ll THEN object.sort_order [ll] = ll
	NEXT
	
	uf_setrow (drag_row, TRUE)
End IF
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;LONG	ll, ll_seq=0

drag_row = -1

FOR ll = 1 TO rowcount ()
	IF object.sort_order [ll]>ll_seq THEN ll_seq = object.sort_order [ll]
NEXT

ll_seq += 1

uf_setcolumn ('sys_id'        , 'SY')
uf_setcolumn ('user_id'       , iif (ddlb_1.of_getselectedindex()=3,'%',is_user_id))
uf_setcolumn ('pgm_kind_code' , 'P')
uf_setcolumn ('parent_pgm'    , string (dw_list.object.pgm_no [iRow]))
uf_setcolumn ('sort_order'    , string (ll_seq))

RETURN 0
end event

event dw_detail::clicked;IF row=0 THEN RETURN


IF ib_base_dimension Then
	call super::clicked
Else
	selectRow (0, FALSE)
	selectRow (row, TRUE)
	drag_row = row
	drag_obj = 2
	DRAG (Begin!)
End IF
end event

event dw_detail::dragwithin;call super::dragwithin;//<임시> 드래그 동작이 이상하여 수정하였습니다
IF drag_obj<>2 THEN RETURN
IF row=0 or lb_syncronized or row>rowcount() THEN RETURN
lb_syncronized = TRUE
setredraw (FALSE)

IF drag_row<>row  Then
   IF drag_row<row   Then
      RowsMove (drag_row, drag_row, Primary!, THIS, row + 1, Primary!)
   Else
      RowsMove (drag_row, drag_row, Primary!, THIS, row, Primary!)
   End IF
   SelectRow (0, FALSE)
   SelectRow (row, TRUE)
   drag_row = row
	id_source = source
End IF

setredraw (TRUE)
lb_syncronized = FALSE
end event

event dw_detail::itemchanged;call super::itemchanged;LONG	ll, ll_cur_row, ll_data

IF dwo.name = 'sort_order' Then
	ll_data = long (data)
	ll_cur_row = FIND ('sort_order=' + string (ll_data), 0, rowcount())
	IF ll_cur_row > 0 Then
		FOR ll = ll_cur_row TO rowcount ()
			IF ll = row THEN CONTINUE
			IF object.sort_order [ll] = ll_data Then
				ll_data += 1
				object.sort_order [ll] = ll_data
			Else
				EXIT
			End IF
		NEXT
	End IF
	
	setsort ('sort_order asc')
	sort ()
End IF
end event

event dw_detail::ue_deletestart;call super::ue_deletestart;drag_row = -1
RETURN AncestorReturnValue
end event

event dw_detail::updatestart;call super::updatestart;LONG	ll

//날짜입력
DO WHILE ll <= rowcount()
	ll = dw_detail.GetNextModified(ll, Primary!)
	IF ll>0 Then
		IF getitemstatus (ll, 0 , Primary!)=NewModified!	Then
			dw_detail.object.reg_id [ll] = iif (gaa.aams, '2200', gaa.corp_gr) + '_' + gnv_vari.is_user_id
			dw_detail.object.reg_dt [ll] = f_sysdate_str(null_s)
		ElseIF getitemstatus (ll, 0 , Primary!)=DataModified!	Then
			dw_detail.object.upd_id [ll] = iif (gaa.aams, '2200', gaa.corp_gr) + '_' + gnv_vari.is_user_id
			dw_detail.object.upd_dt [ll] = f_sysdate_str(null_s)
		End IF
	Else
		EXIT
	End IF
LOOP
end event

type st_hmove from wt_treelistdetail`st_hmove within w_dimension_mst
end type

type st_3 from wt_treelistdetail`st_3 within w_dimension_mst
integer y = 156
string text = "화면리스트"
end type

type p_2 from wt_treelistdetail`p_2 within w_dimension_mst
integer y = 164
end type

type tv_tree from wt_treelistdetail`tv_tree within w_dimension_mst
integer y = 236
integer height = 2528
boolean dragauto = true
borderstyle borderstyle = stylebox!
boolean linesatroot = false
boolean disabledragdrop = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif","..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif"}
end type

event tv_tree::itemexpanding;call super::itemexpanding;treeviewitem ltvi_item

STRING	ls_pgm_no

LONG	ll_rowcnt, ll_child, i

this.getitem(handle, ltvi_item)
IF ltvi_item.Children   Then
   DO WHILE  DeleteItem (FindItem (ChildTreeItem!, handle))>0
   LOOP
End IF

ls_pgm_no = ltvi_item.data

ids_fullmenu.setfilter ("parent_pgm='" + ls_pgm_no + "'")
ids_fullmenu.filter ()
ll_rowcnt = ids_fullmenu.rowcount ()

for i = 1 to ll_rowcnt
   ltvi_item.data = ids_fullmenu.getitemstring(i, 'pgm_no')
   ltvi_item.label = ids_fullmenu.getitemstring(i, 'pgm_nm')

   choose CASE ids_fullmenu.getitemstring(i, 'pgm_kc')
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
   end choose
	
   IF ids_fullmenu.getitemstring(i, 'pgm_kc')='M' Then
      ltvi_item.Children = TRUE
   else
      ltvi_item.Children = FALSE
   End IF

   ltvi_item.HasFocus = FALSE
   ltvi_item.selected = FALSE

   ll_child = this.InsertItemLast(handle, ltvi_item)
next
end event

event tv_tree::selectionchanged;//
end event

event tv_tree::selectionchanging;//
end event

event tv_tree::begindrag;call super::begindrag;drag_obj=0
il_DragSource = handle
end event

event tv_tree::itemexpanded;//
end event

event tv_tree::itemcollapsed;//
end event

event tv_tree::dragdrop;call super::dragdrop;dwobject ldwo
ldwo = CREATE dwobject

CHOOSE CASE drag_obj
	CASE 1
		dw_list.event dragdrop (id_source, drag_row, ldwo)
	CASE 2
		dw_detail.event dragdrop (id_source, drag_row, ldwo)
END CHOOSE
end event

event tv_tree::doubleclicked;call super::doubleclicked;treeviewitem ltvi_item

LONG	ll_row

STRING	ls_pgm_go, ls_pgm_nm, ls_pgm_no, ls_user_id

tv_tree.getitem (handle, ltvi_item)

il_DragSource = -1

IF ltvi_item.PictureIndex = 5 And NOT ib_base_dimension And iRow>0	Then
	IF dw_detail.rowcount()>=7 And ddlb_1.of_getselectedindex()=1 Then
		f_messagebox ('ERR', '즐겨찾기는 7개까지만 등록가능합니다.')
		RETURN
	End IF
	
	ls_pgm_go = f_nvl (MID (ltvi_item.label, 1, 4), '....')
	ls_pgm_nm = MID (ltvi_item.label, 6)
	ls_pgm_no = string (ltvi_item.data)
	ls_user_id = iif (ddlb_1.of_getselectedindex()=3,'%',is_user_id)
	
	IF dw_detail.FIND ("pgm_no='" + string (ltvi_item.data) + "'", 1, dw_detail.rowcount ())>0 Then
		messageBox ('ERR', '이미 등록되어 있는 화면입니다.', StopSign!)
		RETURN
	Else
		SELECT  ''
		  INTO  :ls_pgm_go
		FROM    fw_user_favor
		WHERE   sys_id  = :gnv_vari.is_sys_id
		  AND   user_id = :ls_user_id
		  AND   pgm_no  = :ls_pgm_no;
		
		IF SQLCA.sqlcode()=0 Then
			messageBox ('ERR', '이미 등록되어 있는 화면입니다.', StopSign!)
			RETURN
		End IF
	End IF
	
	ll_row = dw_detail.event ue_insert(0)
	dw_detail.object.pgm_no [ll_row] = ls_pgm_no
	dw_detail.object.pgm_go [ll_row] = ls_pgm_go
	dw_detail.object.pgm_nm [ll_row] = ls_pgm_nm
End IF
end event

type st_vmove from wt_treelistdetail`st_vmove within w_dimension_mst
integer y = 268
integer height = 2496
end type

event st_vmove::oue_split4resize;call super::oue_split4resize;ddlb_1.x = st_vmove.x + st_vmove.width + 10
st_1.x = ddlb_1.x + ddlb_1.width + 30
end event

type ddlb_1 from pf_u_dropdownlistbox within w_dimension_mst
integer x = 2158
integer y = 232
integer width = 608
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
boolean sorted = false
string item[] = {"유저즐겨찾기 관리","회사즐겨찾기 관리","전체즐겨찾기 관리"}
integer ii_selectedindex = 1
boolean setbringtotop = true
end type

event selectionchanged;IF ii_selectedindex=index THEN RETURN -1

IF event ue_wpage_modified() Then
	LONG	ll
	ll = messageBox ('INFO', '변경사항이 있습니다. 저장하시겠습니까?',Question!, YesNoCancel!)
	IF ll = 1 Then
		event wue_update()
	ElseIF ll = 3 Then
		RETURN -1
	End IF
End IF

ii_selectedindex = index

ib_base_dimension = FALSE
cbx_1.visible = FALSE
IF ii_selectedindex=2 Then
	IF gaa.aams Then
		cbx_1.visible = TRUE
		IF cbx_1.Checked	Then
			is_user_id = gaa.corp_gr
			st_1.TEXT = '(' + is_user_id + ' ' + gaa.corp_nm + ')'
		Else
			is_user_id = '2200'
			st_1.TEXT = '(' + is_user_id + ' 한국펀드서비스)'
			
		End IF
	Else
		is_user_id = gaa.corp_gr
		st_1.TEXT = '(' + is_user_id + ' ' + gaa.corp_nm + ')'
	End IF
ElseIF ii_selectedindex=3 Then
	
	IF gaa.aams Then
		is_user_id = '2200'
	Else
		is_user_id = gaa.corp_gr
	End IF
	
	IF gaa.login='yjs1992@hitel.net' And gaa.aams	Then
		st_1.TEXT = '전체즐겨찾기 편집모드'
	Else
		ib_base_dimension = TRUE
		st_1.TEXT = ''
	End IF
Else
	is_user_id = gaa.login
	st_1.TEXT = ''
End IF

dw_list.setredraw (FALSE)

IF ii_selectedindex=3 Then
	f_visible (dw_list, TRUE, 'use_yn_t')
Else
	f_visible (dw_list, FALSE, 'use_yn_t')
End IF

IF ib_base_dimension or ii_selectedindex<>1 Then
	f_visible (dw_list, FALSE, 'sopen_t')
Else
	f_visible (dw_list, TRUE, 'sopen_t')
End IF

event wue_retrieve ()
end event

type st_1 from pf_u_statictext within w_dimension_mst
integer x = 2779
integer y = 240
integer width = 1330
boolean bringtotop = true
boolean setbringtotop = true
end type

type cbx_1 from pf_u_checkbox within w_dimension_mst
boolean visible = false
integer x = 4123
integer y = 232
integer width = 603
boolean bringtotop = true
string text = "접속회사작업"
boolean setbringtotop = true
end type

event clicked;call super::clicked;IF Checked	Then
	is_user_id = gaa.corp_gr
	st_1.TEXT = '(' + is_user_id + ' ' + gaa.corp_nm + ')'
Else
	is_user_id = '2200'
	st_1.TEXT = '(' + is_user_id + ' 한국펀드서비스)'
End IF

event wue_retrieve ()
end event

