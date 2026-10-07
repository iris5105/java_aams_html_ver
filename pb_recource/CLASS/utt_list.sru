forward
global type utt_list from u_subpage
end type
type dw_pagelist from u_dw within utt_list
end type
end forward

global type utt_list from u_subpage
dw_pagelist dw_pagelist
end type
global utt_list utt_list

type variables

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
	End IF
End IF
end subroutine

event ue_subpage_initall;IF NOT tbTabpageSelected THEN EVENT ue_subpage_selected ()   // 처음 선택되었다. 자료 재 조회가 필요하다.
end event

event ue_subpage_copyall;IF NOT tbTabpageSelected THEN EVENT ue_subpage_selected ()   // 처음 선택되었다. 자료 재 조회가 필요하다.

LONG	lRowCount, lRow

lRowCount = dw_pageList.rowcount ()
IF lRowCount>0 Then
   IF f_messageBox ('W019', TEXT)=1 Then
      FOR  lRow = 1  TO  lRowCount
         dw_pageList.SetItemStatus (lRow, 0, Primary!, New!)
         dw_pageList.SetItemStatus (lRow, 0, Primary!, NotModified!)
      NEXT
   Else
      dw_pageList.reset ()
   End IF
End IF
end event

on utt_list.create
int iCurrent
call super::create
this.dw_pagelist=create dw_pagelist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pagelist
end on

on utt_list.destroy
call super::destroy
destroy(this.dw_pagelist)
end on

event ue_subpage_reset;call super::ue_subpage_reset;dw_pagelist.uf_clear ()
end event

event ue_subpage_update;IF dw_pagelist.AcceptText ()=-1  Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_subpage_modified ()  Then
   IF dw_pagelist.uf_update ()=FALSE THEN RETURN -1
End IF
RETURN 1
end event

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1   Then
   dw_pagelist.enabled = FALSE
   IF iu_wpage.ib_managedata THEN dw_pagelist.uf_protect (0, dw_pagelist.ia_protect [1]) &
   Else                           dw_pagelist.uf_protect (0, dw_pagelist.ia_protect [2])
   dw_pagelist.uf_reset (TRUE)
	dw_pagelist.of_setdestroy2filter('')
	dw_pagelist.of_setdestroy2sort('')
	//<임시> 탭화면 오픈중 죽는경우 
	IF	iu_wpage.eb_retrievewait THEN f_loadingpage (true)
End IF
RETURN   AncestorReturnVALUE
end event

event ue_subpage_deleteall;call super::ue_subpage_deleteall;IF NOT tbTabpageSelected THEN EVENT ue_subpage_selected ()   // 처음 선택되었다. 자료 재 조회가 필요하다.
dw_pageList.uf_deleteall ()
end event

event ue_subpage_modified;RETURN dw_pageList.uf_isModified ()
end event

event wue_input;call super::wue_input;dw_pagelist.EVENT ue_insert (0)
end event

event wue_copy;dw_pagelist.EVENT ue_copyrow ()
end event

event wue_delete;call super::wue_delete;dw_pagelist.event ue_delete ()
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
end event

event resize;long ll_dwheightminus1value

dw_pagelist.width  = this.width - Long(PixelsToUnits(10, XPixelsToUnits!))
dw_pagelist.height = this.height - Long(PixelsToUnits(10, XPixelsToUnits!))
ll_dwheightminus1value = dw_pagelist.dynamic of_dwheightminus1value()
if ll_dwheightminus1value>0 then	dw_pagelist.height -= ll_dwheightminus1value
end event

event ue_subpage_open;call super::ue_subpage_open;dw_pageList.insertrow (0)
end event

event ue_activate;call super::ue_activate;dw_pagelist.setfocus ()
end event

event ue_subpage_updatetable;RETURN dw_pageList.uf_isupdatetable ()
end event

type ln_temptop from u_subpage`ln_temptop within utt_list
end type

type ln_tempstart from u_subpage`ln_tempstart within utt_list
end type

type ln_templeft from u_subpage`ln_templeft within utt_list
end type

type ln_cond_start from u_subpage`ln_cond_start within utt_list
end type

type ln_tempright from u_subpage`ln_tempright within utt_list
end type

type ln_cond1_yline from u_subpage`ln_cond1_yline within utt_list
end type

type ln_dw1_yline from u_subpage`ln_dw1_yline within utt_list
end type

type ln_tempbutton from u_subpage`ln_tempbutton within utt_list
end type

type dw_pagelist from u_dw within utt_list
integer x = 18
integer y = 24
integer width = 3589
integer height = 2816
integer taborder = 10
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4excelclip = true
end type

event retrieveend;call super::retrieveend;uf_retrieveend (ts_find, rowcount, eb_null_line)
end event

event ue_update;parent.EVENT ue_subpage_update ()
end event

event retrievestart;call super::retrievestart;tRow = 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;tRow = currentrow
RETURN 0
end event

