forward
global type w_ja990f from wt_tabvert
end type
type tabpage_1 from u_ja990f_t1 within tab_subpage
end type
type tabpage_1 from u_ja990f_t1 within tab_subpage
end type
type dw_1 from u_dw within w_ja990f
end type
type ole_rd from u_rd within w_ja990f
end type
end forward

global type w_ja990f from wt_tabvert
boolean eb_direct_retrieve = true
dw_1 dw_1
ole_rd ole_rd
end type
global w_ja990f w_ja990f

on w_ja990f.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.ole_rd=create ole_rd
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.ole_rd
end on

on w_ja990f.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.ole_rd)
end on

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve ()
dw_1.retrieve ()
end event

event wue_postopen;call super::wue_postopen;dw_1.SetTransObject(SQLCA)
f_dddwctl (dw_1, 'jeokyo_gr', gaa.corp_gr, '', 1, "")
end event

event wue_clear;call super::wue_clear;dw_1.uf_setrange (false)
end event

event resize;CALL w_winpage::resize

dw_List.Height = (Height - dw_list.y - 185) / 2

dw_1.X = dw_list.x
dw_1.Y = dw_List.Height + dw_list.y + 100
dw_1.width = dw_list.width
dw_1.Height = Height - 185 - dw_1.Y
end event

event ue_wpage_modified;BOOLEAN  lb_update

INT   lControl, lTab

lControl = UpperBound (tab_subpage.Control [])
FOR  lTab=1  TO  lControl
   IF tab_subpage.Control [lTab].DYNAMIC EVENT ue_subpage_modified () THEN lb_update = TRUE
NEXT

RETURN	(dw_list.uf_ismodified () OR dw_1.uf_ismodified () OR lb_update)
end event

event wue_update;call super::wue_update;RETURN uf_updateCommit (dw_1)
end event

event ue_setenabled;call super::ue_setenabled;dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage','p_input','p_copy','p_delete'}, true)
end event

type lb_dirlist from wt_tabvert`lb_dirlist within w_ja990f
end type

type ln_templeft from wt_tabvert`ln_templeft within w_ja990f
end type

type ln_tempbuttom from wt_tabvert`ln_tempbuttom within w_ja990f
end type

type ln_temptop from wt_tabvert`ln_temptop within w_ja990f
end type

type ln_tempbutton from wt_tabvert`ln_tempbutton within w_ja990f
end type

type ln_tempstart from wt_tabvert`ln_tempstart within w_ja990f
end type

type ln_cond1_yline from wt_tabvert`ln_cond1_yline within w_ja990f
end type

type ln_dw1_yline from wt_tabvert`ln_dw1_yline within w_ja990f
end type

type ln_cond2_yline from wt_tabvert`ln_cond2_yline within w_ja990f
end type

type ln_dw2_yline from wt_tabvert`ln_dw2_yline within w_ja990f
end type

type ln_tempright from wt_tabvert`ln_tempright within w_ja990f
end type

type uo_navi from wt_tabvert`uo_navi within w_ja990f
end type

type ln_temptop_shadow from wt_tabvert`ln_temptop_shadow within w_ja990f
end type

type st_windelaytime from wt_tabvert`st_windelaytime within w_ja990f
end type

type st_top_rect from wt_tabvert`st_top_rect within w_ja990f
end type

type p_close from wt_tabvert`p_close within w_ja990f
end type

type p_excel from wt_tabvert`p_excel within w_ja990f
end type

type p_print from wt_tabvert`p_print within w_ja990f
end type

type p_delete from wt_tabvert`p_delete within w_ja990f
end type

type p_update from wt_tabvert`p_update within w_ja990f
end type

type p_input from wt_tabvert`p_input within w_ja990f
end type

type p_retrieve from wt_tabvert`p_retrieve within w_ja990f
end type

type p_clear from wt_tabvert`p_clear within w_ja990f
end type

type p_copy from wt_tabvert`p_copy within w_ja990f
end type

type dw_c from wt_tabvert`dw_c within w_ja990f
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_tabvert`btn_update within w_ja990f
end type

type st_count from wt_tabvert`st_count within w_ja990f
end type

type tab_subpage from wt_tabvert`tab_subpage within w_ja990f
integer y = 156
integer height = 2608
tabpage_1 tabpage_1
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
call super::create
this.Control[]={this.tabpage_1}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
end on

type dw_list from wt_tabvert`dw_list within w_ja990f
integer y = 156
integer height = 1992
string dataobject = "d_ja990f1"
boolean hscrollbar = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tr_dr_gb', gaa.corp_gr, '', 1, '')
end event

event dw_list::ue_print;LONG	lRow

STRING	ls_tr_cd

IF uf_getrange () Then
   lRow = GetSelectedRow(0) ; ls_tr_cd = ''
   DO WHILE (lRow > 0)
      IF ls_tr_cd<>'' THEN ls_tr_cd = ls_tr_cd + ","
      ls_tr_cd = ls_tr_cd + "'" + Object.tr_cd [lRow] + "'"
      lRow = GetSelectedRow (lRow)
   LOOP
   ole_rd.uf_fileopen ('rd_szx0ga.mrd', "tr_cd[" + ls_tr_cd + "]" )
Else
   ole_rd.uf_fileopen ('rd_szx0ga.mrd', "tr_cd['" + Object.tr_cd [iRow] + "']" )
End IF

end event

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;tab_subpage.tabpage_1.is_tr_cd = Object.tr_cd [currentrow]
RETURN 0
end event

event dw_list::ue_insertstart;call super::ue_insertstart;POST SetColumn ('tr_cd')
RETURN 0
end event

type uo_tab from wt_tabvert`uo_tab within w_ja990f
end type

type st_tab_move from wt_tabvert`st_tab_move within w_ja990f
integer y = 156
boolean leftmaxsizefixed = true
string leftdragobject = "dw_list;dw_1"
end type

type tabpage_1 from u_ja990f_t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 3049
integer height = 2480
string text = "거래코드별 분개유형과 시장구분"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   dw_pageList.retrieve (dw_list.object.tr_cd [iRow] )
   dw_pageDetail.retrieve (dw_list.object.tr_cd [iRow] )
End IF
RETURN 0
end event

event ue_subpage_initall;call super::ue_subpage_initall;LONG	lRow, lRowCount

CHOOSE CASE name
   CASE 'tr_cd'
      lRowCount = dw_pageList.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_pageList.object.tr_cd [lRow] = data
      NEXT

      lRowCount = dw_pageDetail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_pageDetail.object.tr_cd [lRow] = data
      NEXT
END CHOOSE
end event

event ue_subpage_copyall;call super::ue_subpage_copyall;//
end event

event ue_subpage_deleteall;call super::ue_subpage_deleteall;dw_pageList.uf_deleteall ()
dw_pageDetail.uf_deleteall ()
end event

type dw_1 from u_dw within w_ja990f
integer x = 50
integer y = 2164
integer width = 2267
integer taborder = 30
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_ja990f2"
boolean vscrollbar = true
boolean livescroll = true
boolean ibsetlist4subbtn = true
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

type ole_rd from u_rd within w_ja990f
boolean visible = false
integer x = 3570
integer y = 1432
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string binarykey = "w_ja990f.win"
boolean eb_directprint = true
end type

