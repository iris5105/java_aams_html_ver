forward
global type wt_listdetail from w_winpage
end type
type dw_list from u_dw within wt_listdetail
end type
type dw_detail from u_dw within wt_listdetail
end type
type st_move from pf_u_splitbar_horizontal within wt_listdetail
end type
end forward

global type wt_listdetail from w_winpage
dw_list dw_list
dw_detail dw_detail
st_move st_move
end type
global wt_listdetail wt_listdetail

type variables
BOOLEAN	detail_retrieve = true
end variables

forward prototypes
public subroutine of_initbutton_after ()
end prototypes

public subroutine of_initbutton_after ();// (입력,복사,삭제)버튼 비활성화시 자동 초기화
IF	NOT gnv_authorbtn.ib_inpbtn_yn THEN dw_list.eb_new_false = TRUE
IF	NOT gnv_authorbtn.ib_cpybtn_yn THEN dw_list.eb_copy_false = TRUE
IF	NOT gnv_authorbtn.ib_delbtn_yn THEN dw_list.eb_delete_false = TRUE
end subroutine

on wt_listdetail.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.st_move=create st_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_move
end on

on wt_listdetail.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.st_move)
end on

event ue_wpage_modified;IF	dw_List.uf_isModified ()=FALSE And dw_Detail.uf_isModified ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
IF	dw_c.dataobject>'' And ib_manageData	Then
	dw_detail.uf_clear ()
	dw_list.uf_clear ()
	
	p_retrieve.of_setenabled (true)
	EVENT ue_setdisabled ()

	IF	dw_c.describe ('p_visible.type')='column' THEN dw_c.setitem (1, 'p_visible', 1)
	dw_c.Enabled = TRUE
	dw_c.SetFocus () ; f_selectText (dw_c)
	RETURN
End IF
IF	eb_direct_retrieve THEN p_retrieve.POST EVENT clicked ()
end event

event wue_lastopen;call super::wue_lastopen;dw_list.post event ue_dddw_retrieve ()
dw_detail.post event ue_dddw_retrieve ()
IF	eb_direct_retrieve	Then
	p_retrieve.post event clicked ()
Else
	dw_list.uf_clear ()
	dw_detail.uf_clear ()
End IF
IF	f_nvl (dw_detail.title,'none')='none' THEN dw_detail.title = inv_menu.is_pgm_nm + f_nvl (dw_detail.title,' 상세')
end event

event ue_setenabled;call super::ue_setenabled;IF	dw_detail.ibsetlist4subbtn	Then
	IF dw_list.rowcount ()>0	Then
		dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
		dw_detail.of_dw2subbtn ({'p_input'}, (dw_detail.enabled And dw_detail.eb_new_false=FALSE And ib_managedata))
		dw_detail.of_dw2subbtn ({'p_copy'}, (dw_detail.enabled And dw_detail.eb_copy_false=FALSE And ib_managedata))
		dw_detail.of_dw2subbtn ({'p_delete'}, (dw_detail.enabled And dw_detail.eb_delete_false=FALSE And ib_managedata))
	Else
		dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
	End IF
End IF
end event

event wue_update;IF	dw_list.AcceptText ()=-1 OR dw_detail.AcceptText ()=-1	Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF	EVENT ue_wpage_modified ()	Then
	IF	uf_UpdateCommit (dw_list, dw_detail)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event ue_wpage_updatetable;IF	dw_List.uf_isupdatetable ()=FALSE And dw_Detail.uf_isupdatetable ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

type lb_dirlist from w_winpage`lb_dirlist within wt_listdetail
end type

type ln_templeft from w_winpage`ln_templeft within wt_listdetail
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_listdetail
end type

type ln_temptop from w_winpage`ln_temptop within wt_listdetail
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_listdetail
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_listdetail
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_listdetail
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_listdetail
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_listdetail
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_listdetail
end type

type ln_tempright from w_winpage`ln_tempright within wt_listdetail
end type

type uo_navi from w_winpage`uo_navi within wt_listdetail
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_listdetail
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_listdetail
end type

type st_top_rect from w_winpage`st_top_rect within wt_listdetail
end type

type p_close from w_winpage`p_close within wt_listdetail
end type

type p_excel from w_winpage`p_excel within wt_listdetail
end type

type p_print from w_winpage`p_print within wt_listdetail
end type

type p_delete from w_winpage`p_delete within wt_listdetail
end type

type p_update from w_winpage`p_update within wt_listdetail
end type

type p_input from w_winpage`p_input within wt_listdetail
end type

type p_retrieve from w_winpage`p_retrieve within wt_listdetail
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

IF	p_clear.visible=false	Then
	IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
	dw_list.of_setdestroy2filter('')
	dw_list.of_setdestroy2sort('')
	dw_detail.of_setdestroy2filter('')
	dw_detail.of_setdestroy2sort('')
End IF

IF	dw_c.EVENT ue_valid ()=FALSE	Then
   dw_c.SetFocus ()
   RETURN
End IF

IF	ib_managedata	Then
	IF	dw_c.describe ('p_visible.type')='column' THEN dw_c.setitem (1, 'p_visible', 0)
	dw_c.Enabled = FALSE
	IF	p_clear.visible	Then
		p_clear.of_setenabled (true)
		of_setenabled (false)
	End IF
   dw_List.uf_protect (0, dw_List.ia_protect [1]) ; dw_Detail.uf_protect (0, dw_Detail.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2]) ; dw_Detail.uf_protect (0, dw_Detail.ia_protect [2])
End IF

dw_Detail.uf_reset (TRUE)
dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within wt_listdetail
end type

type p_copy from w_winpage`p_copy within wt_listdetail
end type

type dw_c from w_winpage`dw_c within wt_listdetail
end type

type btn_update from w_winpage`btn_update within wt_listdetail
end type

type st_count from w_winpage`st_count within wt_listdetail
end type

type dw_list from u_dw within wt_listdetail
integer x = 50
integer y = 348
integer width = 5381
integer height = 1092
integer taborder = 30
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;IF	rowcount=0 THEN dw_Detail.uf_retrieveend ('detail', 0, FALSE)
uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow
IF	detail_retrieve	Then
	uf_enabled (eb_rowchangewait, false)
	dw_detail.setredraw (false)
	dw_detail.uf_reset ()
	dw_detail.event ue_retrieve ()
	dw_detail.setredraw (true)
	uf_enabled (eb_rowchangewait, true)
End IF
RETURN 0
end event

event rowfocuschanging_return;IF dw_detail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF dw_detail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_copystart;IF dw_detail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_copyrow;call super::ue_copyrow;IF AncestorReturnVALUE=-1 THEN RETURN -1

LONG	lRow, lRowCount

lRowCount = dw_Detail.rowcount ()
IF	lRowCount>0	Then
   IF	f_messageBox ('W014','')=1	Then
      FOR  lRow = 1  TO  lRowCount
         dw_Detail.SetItemStatus (lRow, 0, Primary!, New!)
         dw_Detail.SetItemStatus (lRow, 0, Primary!, NotModified!)
      NEXT
   Else
      dw_Detail.uf_reset ()
   End IF
End IF

RETURN 0
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event ue_delete;IF	rowcount ()=0 THEN RETURN -1
IF	uf_getrange ()	Then
	f_messageBox ('RANG','삭제')
	RETURN -1
End IF
IF	f_MessageBox ('W004', dw_Detail.Tag)=2 THEN RETURN 0	// delete Cancel

IF EVENT ue_deletestart ()=1 THEN RETURN -1
IF	dw_Detail.uf_deleteall ()=-1 THEN RETURN -1

enabled = false
EVENT ue_deleterow (iRow)
IF	deleterow (iRow)=-1	Then
	f_messageBox ('D000', TAG+'(no rollback)')
	RETURN -1
End IF
IF	iRow>rowcount () THEN iRow = rowcount ()
IF	iRow=0	Then
	IF	dw_detail.ibsetlist4subbtn THEN dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
Else
	uf_setrow (iRow, true)
	POST SetFocus ()
End IF
RETURN 1
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type dw_detail from u_dw within wt_listdetail
integer x = 50
integer y = 1476
integer width = 5381
integer height = 1288
integer taborder = 20
boolean bringtotop = true
string title = "상세자료"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
boolean ibsetlist4excelclip = true
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('detail', rowcount, eb_null_line)
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type st_move from pf_u_splitbar_horizontal within wt_listdetail
integer x = 50
integer y = 1448
integer width = 5381
boolean setcondcolor = true
string topdragobject = "dw_list"
string bottomdragobject = "dw_detail"
end type

