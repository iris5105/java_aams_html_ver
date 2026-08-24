forward
global type w_pgm_mst from w_window1st5ncn
end type
type tv_fullmenu from pf_u_treeview within w_pgm_mst
end type
type dw_pgm from u_dw within w_pgm_mst
end type
type uo_1 from fw_u_dw2title within w_pgm_mst
end type
end forward

global type w_pgm_mst from w_window1st5ncn
string title = "프로그램 정보관리"
boolean ibconfirmupdate4closequery = true
boolean ibconfirmupdate4message = false
tv_fullmenu tv_fullmenu
dw_pgm dw_pgm
uo_1 uo_1
end type
global w_pgm_mst w_pgm_mst

type variables
ads_jTier	ids_fullmenu

treeviewitem	itvi_item

BOOLEAN	ib_open = true
LONG	il_tree = 0, il_next []
end variables

on w_pgm_mst.create
int iCurrent
call super::create
this.tv_fullmenu=create tv_fullmenu
this.dw_pgm=create dw_pgm
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_fullmenu
this.Control[iCurrent+2]=this.dw_pgm
this.Control[iCurrent+3]=this.uo_1
end on

on w_pgm_mst.destroy
call super::destroy
destroy(this.tv_fullmenu)
destroy(this.dw_pgm)
destroy(this.uo_1)
end on

event wue_update;INT	li_ret
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

event wue_retrieve;call super::wue_retrieve;LONG	ll_rowcnt, ll_handle, i

ids_fullmenu = create ads_jTier
ids_fullmenu.dataobject = 'd_pgm_mst_ds1'
ids_fullmenu.settransobject (sqlca)

ll_rowcnt = ids_fullmenu.retrieve (gnv_vari.is_lang_type, gnv_vari.is_sys_id, 'ROOT')
for i = 1 to ll_rowcnt
	itvi_item.data = ids_fullmenu.getitemstring(i, 'pgm_no')
	itvi_item.label = ids_fullmenu.getitemstring(i, 'pgm_nm')
	
   choose CASE ids_fullmenu.getitemstring(i, 'pgm_kind_code')
      CASE 'M'
			choose case ids_fullmenu.getitemnumber(i, 'tree_level')
				case 1
					itvi_item.PictureIndex = 1
					itvi_item.SelectedPictureIndex = 2
				case 2
					itvi_item.label += ' (' + ids_fullmenu.getitemstring(1, 'pgm_no') + ')'
					itvi_item.PictureIndex = 3
					itvi_item.SelectedPictureIndex = 4
				case 3
					itvi_item.label += ' (' + ids_fullmenu.getitemstring(1, 'pgm_no') + ')'
					itvi_item.PictureIndex = 5
					itvi_item.SelectedPictureIndex = 6
			end choose
      CASE 'P'
         //IF	f_notnull (ids_fullmenu.getitemstring(i, 'pgm_id')) THEN itvi_item.label += ' (' + ids_fullmenu.getitemstring(i, 'pgm_id') + ')'
			itvi_item.PictureIndex = 7
			itvi_item.SelectedPictureIndex = 8
   end choose
	itvi_item.children = true
	ll_handle = tv_fullmenu.InsertItemLast(0, itvi_item)
	tv_fullmenu.expandall (ll_handle)
next

//IF	ll_rowcnt=1	Then
//	itvi_item.data = ids_fullmenu.getitemstring(1, 'pgm_no')
//	itvi_item.label = ids_fullmenu.getitemstring(1, 'pgm_nm')
//	If itvi_item.data = '00000' Then
//		itvi_item.PictureIndex = 1
//		itvi_item.SelectedPictureIndex = 2
//	Else
//		itvi_item.label += ' (' + ids_fullmenu.getitemstring(1, 'pgm_no') + ')'
//		itvi_item.PictureIndex = 3
//		itvi_item.SelectedPictureIndex = 4				
//	End If
//	itvi_item.children = true
//	ll_handle = tv_fullmenu.InsertItemLast (0, itvi_item)
//	tv_fullmenu.expandall (ll_handle)
//End IF
ib_open = false

// scroll back to top
tv_fullmenu.SetFirstVisible (1)
end event

event wue_postopen;call super::wue_postopen;post event wue_retrieve ()
f_dddwctl (dw_pgm, 'parent_pgm', gaa.corp_gr, '', 1, '')
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within w_pgm_mst
end type

type ln_templeft from w_window1st5ncn`ln_templeft within w_pgm_mst
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_pgm_mst
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_pgm_mst
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_pgm_mst
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_pgm_mst
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_pgm_mst
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_pgm_mst
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_pgm_mst
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_pgm_mst
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_pgm_mst
end type

type uo_navi from w_window1st5ncn`uo_navi within w_pgm_mst
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_pgm_mst
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_pgm_mst
end type

type st_top_rect from w_window1st5ncn`st_top_rect within w_pgm_mst
end type

type p_close from w_window1st5ncn`p_close within w_pgm_mst
end type

type p_excel from w_window1st5ncn`p_excel within w_pgm_mst
end type

type p_print from w_window1st5ncn`p_print within w_pgm_mst
end type

type p_delete from w_window1st5ncn`p_delete within w_pgm_mst
end type

type p_update from w_window1st5ncn`p_update within w_pgm_mst
end type

type p_input from w_window1st5ncn`p_input within w_pgm_mst
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_pgm_mst
end type

type p_clear from w_window1st5ncn`p_clear within w_pgm_mst
end type

type tv_fullmenu from pf_u_treeview within w_pgm_mst
integer x = 50
integer y = 244
integer width = 1819
integer height = 2520
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 20132659
borderstyle borderstyle = stylebox!
boolean tooltips = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl.1.cl.jpg","..\img\mainframe\u_treemenu\lvl.1.op.jpg","..\img\mainframe\u_treemenu\lvl.3.cl.jpg","..\img\mainframe\u_treemenu\lvl.3.op.jpg","..\img\mainframe\u_treemenu\lvl.5.cl.jpg","..\img\mainframe\u_treemenu\lvl.5.op.jpg",""}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event itemexpanding;call super::itemexpanding;LONG	ll, ll_row

handle = handle
this.getitem(handle, itvi_item)
DO WHILE  DeleteItem (FindItem (ChildTreeItem!, handle))>0
LOOP

ll_row = ids_fullmenu.retrieve (gnv_vari.is_lang_type, gnv_vari.is_sys_id, itvi_item.data)

FOR  ll = 1  TO  ll_row
   itvi_item.data = ids_fullmenu.getitemstring(ll, 'pgm_no')
   itvi_item.label = ids_fullmenu.getitemstring(ll, 'pgm_nm') + '(' + ids_fullmenu.getitemstring(ll, 'pgm_no') + ')'
	
   choose CASE ids_fullmenu.getitemstring(ll, 'pgm_kind_code')
      CASE 'M'
			choose case ids_fullmenu.getitemnumber(ll, 'tree_level')
				case 1
					itvi_item.PictureIndex = 1
					itvi_item.SelectedPictureIndex = 2
				case 2
					itvi_item.PictureIndex = 3
					itvi_item.SelectedPictureIndex = 4
				case 3
					itvi_item.PictureIndex = 5
					itvi_item.SelectedPictureIndex = 6
			end choose
      CASE 'P'
			itvi_item.PictureIndex = 7
			itvi_item.SelectedPictureIndex = 8
   end choose

   itvi_item.Children = (ids_fullmenu.getitemnumber(ll, 'tree_level') < 3)
   itvi_item.HasFocus = FALSE
   itvi_item.selected = FALSE
	this.InsertItemLast(handle, itvi_item)
NEXT
end event

event selectionchanged;call super::selectionchanged;IF	oldhandle>0	Then
	// 전 선택항목 처리
	itvi_item.selected = false
	itvi_item.bold = false
	this.setitem (oldhandle, itvi_item)

	of_confirmupdate4rowchanged()
End IF

// 현 선택항목 처리
this.getitem(newhandle, itvi_item)
itvi_item.selected = true
itvi_item.bold = true
this.setitem (newhandle, itvi_item)

dw_pgm.retrieve (gnv_vari.is_sys_id, itvi_item.data)
dw_pgm.event rowfocuschanged (1)

post setfocus ()
end event

event clicked;call super::clicked;treeviewitem	ltvi_item

this.getitem(handle, ltvi_item)
choose case ltvi_item.SelectedPictureIndex
	case 5, 6
		dw_pgm.accepttext ()
	case else
		f_messageBox ('ERR', '메뉴항목 입니다')
		RETURN 1
end choose
end event

type dw_pgm from u_dw within w_pgm_mst
integer x = 1879
integer y = 156
integer width = 3552
integer height = 2608
integer taborder = 20
string title = "프로그램 상세"
string dataobject = "d_pgm_mst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibtitle4datawindow = true
string setlist4rowpointcolor = "tree_line=Y=a"
end type

event itemchanged;call super::itemchanged;LONG	ll
choose CASE dwo.name
   CASE 'parent_pgm'
      Object.sort_order [row] = 99
   CASE 'sort_order'
		FOR  ll = 1  TO  rowcount ()
			IF row=ll OR Object.sort_order [ll]>=99 THEN continue
			IF Object.sort_order [ll]>=dec (data) THEN Object.sort_order [ll] = Object.sort_order [ll] + 1
		NEXT
   CASE 'io_type'
      Choose CASE data
         CASE '01'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_search_hover.jpg')
         CASE '02'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_add_hover.jpg')
         CASE '03'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_exec_hover.jpg')
         CASE '04'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_setting_hover.jpg')
         CASE '05'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_print_rd_hover.jpg')
         CASE '10'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_ftp_hover.jpg')
         CASE '11'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_chart_hover.jpg')
         CASE '12'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_excel_hover.jpg')
			Case '13'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_fundnet_hover.jpg')
      End Choose
end choose
end event

event rowfocuschanged;call super::rowfocuschanged;treeviewitem	tvi_item

STRING	ls_sqlsyntax

LONG	ll, lb, lR, ll_handle

aDS_jTier	lDS

ls_sqlsyntax = " SELECT  parent_pgm " &
				 + " FROM    fw_pgm_mst " &
				 + " WHERE   sys_id = 'SY' " &
				 + "   AND   pgm_id IN (select pgm_id from fw_pgm_mst where sys_id='SY' and pgm_no='" + f_nvl (f_nvl (getitemstring (currentrow, 'pgm_no'),''),'') + "') "
lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lDS, 'xml')
IF	lR<2 THEN RETURN

FOR  ll = 1  TO  il_tree
	ll_handle = tv_fullmenu.finditem (ChildTreeItem!, il_next [ll])
	DO WHILE ll_handle > 0
		tv_fullmenu.getitem (ll_handle, tvi_item)
		tvi_item.bold = false
		FOR  lb = 1  TO  lR
			IF	lDS.getitemstring (lb, 1)=tvi_item.data THEN tvi_item.bold = true
		NEXT
		tv_fullmenu.setitem (ll_handle, tvi_item)
		ll_handle = tv_fullmenu.finditem (NextTreeItem!, ll_handle)
	LOOP
NEXT
gw_mdi.setmicrohelp (f_ntrim (lR,0,0) + '개 메뉴에 등록되어 있습니다.')
end event

event doubleclicked;LONG	ll
CHOOSE CASE dwo.name
	CASE 'sort_order_t'
		FOR  ll = 1  TO  rowcount ()
			Object.sort_order [ll] = ll
		NEXT
		RETURN
	CASE 'pgm_go','pgm_id'
		gnv_rolemenu.of_setopensheet (Object.pgm_no [row])
		RETURN
END CHOOSE
call super::doubleclicked
end event

event retrieveend;call fw_u_dwo::retrieveend
uf_retrieveend ('', rowcount, eb_null_line)
end event

type uo_1 from fw_u_dw2title within w_pgm_mst
integer x = 50
integer y = 156
integer taborder = 90
boolean bringtotop = true
string istitletext = "전체 프로그램 메뉴"
end type

on uo_1.destroy
call fw_u_dw2title::destroy
end on

