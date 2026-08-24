forward
global type utt_vertdetail from u_subpage
end type
type dw_pagelist from u_dw within utt_vertdetail
end type
type dw_pagedetail from u_dw within utt_vertdetail
end type
type st_move from pf_u_splitbar_vertical within utt_vertdetail
end type
end forward

global type utt_vertdetail from u_subpage
dw_pagelist dw_pagelist
dw_pagedetail dw_pagedetail
st_move st_move
end type
global utt_vertdetail utt_vertdetail

type variables
BOOLEAN	detail_retrieve = true
end variables

forward prototypes
public subroutine of_initparent (window aw_parent, fw_u_dwo adw_datawindow, fw_n_style anv_style)
public subroutine wf_setenabled ()
end prototypes

public subroutine of_initparent (window aw_parent, fw_u_dwo adw_datawindow, fw_n_style anv_style);// parent datawindow / window 등록
iw_parent	 = aw_parent
idw_target	 = adw_datawindow
inv_dwdesign = anv_style
// (입력,복사,삭제)버튼 비활성화시 자동 초기화
IF	NOT gnv_authorbtn.ib_inpbtn_yn THEN dw_pagelist.eb_new_false = TRUE
IF	NOT gnv_authorbtn.ib_cpybtn_yn THEN dw_pagelist.eb_copy_false = TRUE
IF	NOT gnv_authorbtn.ib_delbtn_yn THEN dw_pagelist.eb_delete_false = TRUE
end subroutine

public subroutine wf_setenabled ();IF	isValid (iu_wpage)	Then
	iu_wpage.wf_setenabled ()
	IF dw_pagelist.ibsetlist4subbtn	Then
		dw_pagelist.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
		dw_pagelist.of_dw2subbtn ({'p_input'}, (dw_pagelist.enabled And dw_pagelist.eb_new_false=FALSE And iu_wpage.ib_managedata))
		dw_pagelist.of_dw2subbtn ({'p_copy'}, (dw_pagelist.enabled And dw_pagelist.eb_copy_false=FALSE And iu_wpage.ib_managedata))
		dw_pagelist.of_dw2subbtn ({'p_delete'}, (dw_pagelist.enabled And dw_pagelist.eb_delete_false=FALSE And iu_wpage.ib_managedata))
	End iF
	IF	dw_pagedetail.ibsetlist4subbtn Then
		IF dw_pagelist.rowcount ()>0	Then
			dw_pagedetail.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
			dw_pagedetail.of_dw2subbtn ({'p_input'}, (dw_pagedetail.enabled And dw_pagedetail.eb_new_false=FALSE And iu_wpage.ib_managedata))
			dw_pagedetail.of_dw2subbtn ({'p_copy'}, (dw_pagedetail.enabled And dw_pagedetail.eb_copy_false=FALSE And iu_wpage.ib_managedata))
			dw_pagedetail.of_dw2subbtn ({'p_delete'}, (dw_pagedetail.enabled And dw_pagedetail.eb_delete_false=FALSE And iu_wpage.ib_managedata))
		Else
			dw_pagedetail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
		End IF
	End IF
End IF
end subroutine

event ue_subpage_initall;IF NOT tbTabpageSelected THEN EVENT ue_subpage_selected ()   // 처음 선택되었다. 자료 재 조회가 필요하다.
end event

event ue_subpage_copyall;IF NOT tbTabpageSelected THEN EVENT ue_subpage_selected ()  // 처음 선택되었다. 자료 재 조회가 필요하다.

LONG	lRowCount, lRow

lRowCount = dw_pageList.rowcount ()
IF lRowCount>0 Then
   IF f_messageBox ('W019', iu_wpage.inv_menu.is_pgm_nm)=1  Then
      FOR  lRow = 1  TO  lRowCount
         dw_pageList.SetItemStatus (lRow, 0, Primary!, New!)
         dw_pageList.SetItemStatus (lRow, 0, Primary!, NotModified!)
      NEXT
   Else
      dw_pageList.reset ()
   End IF
End IF

lRowCount = dw_pageDetail.rowcount ()
IF lRowCount>0 Then
   IF f_messageBox ('W019', iu_wpage.inv_menu.is_pgm_nm)=1  Then
      FOR  lRow = 1  TO  lRowCount
         dw_pageDetail.SetItemStatus (lRow, 0, Primary!, New!)
         dw_pageDetail.SetItemStatus (lRow, 0, Primary!, NotModified!)
      NEXT
   Else
      dw_pageDetail.reset ()
   End IF
End IF
end event

on utt_vertdetail.create
int iCurrent
call super::create
this.dw_pagelist=create dw_pagelist
this.dw_pagedetail=create dw_pagedetail
this.st_move=create st_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pagelist
this.Control[iCurrent+2]=this.dw_pagedetail
this.Control[iCurrent+3]=this.st_move
end on

on utt_vertdetail.destroy
call super::destroy
destroy(this.dw_pagelist)
destroy(this.dw_pagedetail)
destroy(this.st_move)
end on

event ue_subpage_reset;call super::ue_subpage_reset;dw_pagedetail.uf_clear ()
dw_pagelist.uf_clear ()
end event

event ue_subpage_update;IF dw_pagelist.AcceptText ()=-1 OR dw_pagedetail.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_subpage_Modified ()  Then
   IF	uf_updatenocommit (dw_pagedetail, dw_pagelist)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1   Then
   dw_pagelist.Enabled = FALSE
   IF iu_wpage.ib_managedata  Then
      dw_pagelist.uf_protect (0, dw_pagelist.ia_protect [1]) ; dw_pagedetail.uf_protect (0, dw_pagedetail.ia_protect [1])
   Else
      dw_pagelist.uf_protect (0, dw_pagelist.ia_protect [2]) ; dw_pagedetail.uf_protect (0, dw_pagedetail.ia_protect [2])
   End IF
   dw_pagedetail.uf_reset (TRUE)
   dw_pagelist.uf_reset (TRUE)
	dw_pagedetail.of_setdestroy2filter('')
	dw_pagedetail.of_setdestroy2sort('')
	dw_pagelist.of_setdestroy2filter('')
	dw_pagelist.of_setdestroy2sort('')
	//<임시> 탭화면 오픈중 죽는경우 
	IF	iu_wpage.eb_retrievewait THEN f_loadingpage (false)
End IF
RETURN   AncestorReturnVALUE
end event

event ue_subpage_deleteall;call super::ue_subpage_deleteall;FOR  tRow = dw_pagelist.rowcount ()  TO  1  STEP -1
   dw_pagedetail.EVENT ue_retrieve ()
   dw_pagedetail.uf_deleteall ()
   dw_pagelist.deleterow (tRow)
NEXT
end event

event ue_subpage_modified;IF dw_pageList.uf_isModified ()=FALSE And dw_pageDetail.uf_isModified ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_input;call super::wue_input;dw_pagelist.EVENT ue_insert (0)
end event

event wue_delete;call super::wue_delete;dw_pagelist.EVENT ue_delete ()
end event

event wue_copy;dw_pagelist.EVENT ue_copyrow ()
end event

event wue_saveas;call super::wue_saveas;STRING	ls_seq

SELECT  '(' || f_n0 (seqval ('excel_seq'), 3) || ')'
  INTO  :ls_seq
FROM    dual;

ls_seq = SQLCA.getitemstring (1)

IF f_nvl (lower (dw_pagelist.title),'none')='none' Then
   f_xlsx (dw_pagelist, '__' + dw_pagelist.dataobject + ls_seq, dw_pagelist.dataobject, '', '', '', '')
Else
   f_xlsx (dw_pagelist, '__' + dw_pagelist.dataobject + ls_seq, dw_pagelist.title, '', '', '', '')
End IF
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;dw_pagelist.post event ue_dddw_retrieve ()
dw_pagedetail.post event ue_dddw_retrieve ()
end event

event resize;long ll_dwheightminus1value

dw_pagelist.height = this.height - Long(PixelsToUnits(10, XPixelsToUnits!))
ll_dwheightminus1value = dw_pagelist.dynamic of_dwheightminus1value()
if ll_dwheightminus1value>0 then dw_pagelist.height -= ll_dwheightminus1value

st_move.height = dw_pagelist.height

dw_pagedetail.width	= this.width - dw_pagelist.x - dw_pagelist.width - st_move.width - Long(PixelsToUnits(10, XPixelsToUnits!))
//<임시> pagelist에 서브버튼이 있는경우 서브버튼 길이만큼 추가로 줄어듭니다
// 테스트 화면 : 2699 / tab2
//dw_pagedetail.height	= dw_pagelist.height
dw_pagedetail.height = this.height - Long(PixelsToUnits(10, XPixelsToUnits!))
ll_dwheightminus1value = dw_pagedetail.dynamic of_dwheightminus1value()
if ll_dwheightminus1value>0 then dw_pagedetail.height -= ll_dwheightminus1value
end event

event ue_subpage_open;call super::ue_subpage_open;dw_pagelist.insertrow (0)
dw_pagedetail.insertrow (0)
end event

event ue_activate;call super::ue_activate;dw_pagelist.setfocus ()
end event

event ue_subpage_updatetable;IF dw_pageList.uf_isupdatetable ()=FALSE And dw_pageDetail.uf_isupdatetable ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

type ln_temptop from u_subpage`ln_temptop within utt_vertdetail
end type

type ln_tempstart from u_subpage`ln_tempstart within utt_vertdetail
end type

type ln_templeft from u_subpage`ln_templeft within utt_vertdetail
end type

type ln_cond_start from u_subpage`ln_cond_start within utt_vertdetail
end type

type ln_tempright from u_subpage`ln_tempright within utt_vertdetail
end type

type ln_cond1_yline from u_subpage`ln_cond1_yline within utt_vertdetail
end type

type ln_dw1_yline from u_subpage`ln_dw1_yline within utt_vertdetail
end type

type ln_tempbutton from u_subpage`ln_tempbutton within utt_vertdetail
end type

type dw_pagelist from u_dw within utt_vertdetail
integer x = 18
integer y = 24
integer width = 1911
integer height = 2816
integer taborder = 30
boolean bringtotop = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletobottom = true
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;IF rowcount =0 THEN dw_pageDetail.uf_retrieveend ('detail', 0, FALSE)
uf_retrieveend (ts_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;tRow = currentrow
IF	detail_retrieve	Then
	uf_enabled (tb_rowchangewait, false)
	dw_pagedetail.setredraw (false)
	dw_pagedetail.uf_reset ()
	dw_pagedetail.event ue_retrieve ()
	dw_pagedetail.setredraw (true)
	uf_enabled (tb_rowchangewait, true)
End IF
RETURN 0
end event

event rowfocuschanging_return;IF dw_pagedetail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_copystart;call super::ue_copystart;IF dw_pagedetail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF dw_pagedetail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_copyrow;call super::ue_copyrow;IF AncestorReturnVALUE=-1 THEN RETURN -1

LONG	lRow, lRowCount

lRowCount=dw_pagedetail.rowcount ()
IF lRowCount>0 Then
   IF f_messageBox ('W014','')=1 Then
      FOR  lRow = 1  TO  lRowCount
         dw_pagedetail.SetItemStatus (lRow, 0, Primary!, New!)
         dw_pagedetail.SetItemStatus (lRow, 0, Primary!, NotModified!)
      NEXT
   Else
      dw_pagedetail.uf_reset ()
   End IF
End IF

RETURN 0
end event

event retrievestart;call super::retrievestart;tRow = 0
end event

event ue_delete;IF rowcount ()=0 THEN RETURN -1
IF uf_getrange () Then
   f_messageBox ('RANG','삭제')
   RETURN -1
End IF
IF f_MessageBox ('W004', dw_pageDetail.Tag)=2 THEN RETURN 0 // delete Cancel

IF EVENT ue_deletestart ()=1 THEN RETURN -1
IF dw_pageDetail.uf_deleteall ()=-1 THEN RETURN -1

enabled = false
event ue_deleterow (tRow)
IF deleterow (tRow)=-1  Then
   f_messageBox ('D000', TAG+'(no rollback)')
   RETURN -1
End IF
IF tRow>rowcount () THEN tRow = rowcount ()
IF	tRow=0	Then
	IF	dw_pagedetail.ibsetlist4subbtn THEN dw_pagedetail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
Else
	uf_setrow (tRow, true)
	POST SetFocus ()
End IF

RETURN 1
end event

event ue_update;parent.EVENT ue_subpage_update ()
end event

type dw_pagedetail from u_dw within utt_vertdetail
integer x = 1966
integer y = 24
integer width = 1641
integer height = 2816
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

event ue_update;parent.EVENT ue_subpage_update ()
end event

type st_move from pf_u_splitbar_vertical within utt_vertdetail
integer x = 1938
integer y = 24
integer height = 2816
boolean setcondcolor = true
string leftdragobject = "dw_pagelist"
string rightdragobject = "dw_pagedetail"
end type

