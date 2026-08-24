forward
global type utt_vertshare from u_subpage
end type
type dw_pagelist from u_dw within utt_vertshare
end type
type dw_pagemaster from u_dw within utt_vertshare
end type
type st_move from pf_u_splitbar_vertical within utt_vertshare
end type
end forward

global type utt_vertshare from u_subpage
dw_pagelist dw_pagelist
dw_pagemaster dw_pagemaster
st_move st_move
end type
global utt_vertshare utt_vertshare

forward prototypes
public subroutine of_initparent (window aw_parent, fw_u_dwo adw_datawindow, fw_n_style anv_style)
public subroutine wf_setenabled ()
end prototypes

public subroutine of_initparent (window aw_parent, fw_u_dwo adw_datawindow, fw_n_style anv_style);// parent datawindow / window 등록
iw_parent	 = aw_parent
idw_target	 = adw_datawindow
inv_dwdesign = anv_style
// (입력,복사,삭제)버튼 비활성화시 자동 초기화
IF	NOT gnv_authorbtn.ib_inpbtn_yn	Then
	dw_pagelist.eb_new_false = TRUE
	dw_pagemaster.eb_new_false = TRUE
End IF
IF	NOT gnv_authorbtn.ib_cpybtn_yn	Then
	dw_pagelist.eb_copy_false = TRUE
	dw_pagemaster.eb_copy_false = TRUE
End IF
IF	NOT gnv_authorbtn.ib_delbtn_yn	Then
	dw_pagelist.eb_delete_false = TRUE
	dw_pagemaster.eb_delete_false = TRUE
End IF
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
   IF f_messageBox ('W019', iu_wpage.inv_menu.is_pgm_nm)=1  Then
      FOR  lRow = 1  TO  lRowCount
         dw_pageList.SetItemStatus (lRow, 0, Primary!, New!)
         dw_pageList.SetItemStatus (lRow, 0, Primary!, NotModified!)
      NEXT
   Else
      dw_pageList.reset ()
   End IF
End IF
end event

on utt_vertshare.create
int iCurrent
call super::create
this.dw_pagelist=create dw_pagelist
this.dw_pagemaster=create dw_pagemaster
this.st_move=create st_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pagelist
this.Control[iCurrent+2]=this.dw_pagemaster
this.Control[iCurrent+3]=this.st_move
end on

on utt_vertshare.destroy
call super::destroy
destroy(this.dw_pagelist)
destroy(this.dw_pagemaster)
destroy(this.st_move)
end on

event ue_subpage_reset;call super::ue_subpage_reset;dw_pagelist.uf_clear ()
end event

event ue_subpage_update;IF dw_pagelist.AcceptText ()=-1  Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_subpage_Modified ()  Then
   IF dw_pagelist.uf_update ()=FALSE THEN RETURN -1
End IF
RETURN 1
end event

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1   Then
   dw_pagelist.Enabled = FALSE
   IF iu_wpage.ib_managedata  Then
      dw_pagelist.uf_protect (0, dw_pagelist.ia_protect [1]) ; dw_pagemaster.uf_protect (0, dw_pagemaster.ia_protect [1])
   Else
      dw_pagelist.uf_protect (0, dw_pagelist.ia_protect [2]) ; dw_pagemaster.uf_protect (0, dw_pagemaster.ia_protect [2])
   End IF
   dw_pagelist.uf_reset (TRUE)
	dw_pagelist.of_setdestroy2filter('')
	dw_pagelist.of_setdestroy2sort('')
	//<임시> 탭화면 오픈중 죽는경우 
	IF	iu_wpage.eb_retrievewait THEN f_loadingpage (false)
End IF
RETURN   AncestorReturnVALUE
end event

event ue_subpage_deleteall;call super::ue_subpage_deleteall;IF NOT tbTabpageSelected THEN EVENT ue_subpage_selected ()   // 처음 선택되었다. 자료 재 조회가 필요하다.
dw_pageList.uf_deleteall ()
end event

event ue_subpage_modified;dw_pagemaster.AcceptText ()
RETURN dw_pagelist.uf_isModified ()
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
end event

event resize;long ll_dwheightminus1value

dw_pagelist.height   = this.height - Long(PixelsToUnits(10, XPixelsToUnits!))
dw_pagemaster.height	= dw_pagelist.height
st_move.height       = dw_pagelist.height

ll_dwheightminus1value = dw_pagelist.dynamic of_dwheightminus1value()
if ll_dwheightminus1value>0 then dw_pagelist.height -= ll_dwheightminus1value

dw_pagemaster.width	= this.width - dw_pagelist.x - dw_pagelist.width - st_move.width - Long(PixelsToUnits(10, XPixelsToUnits!))
ll_dwheightminus1value = dw_pagemaster.dynamic of_dwheightminus1value()
if ll_dwheightminus1value>0 then dw_pagemaster.height -= ll_dwheightminus1value
end event

event ue_subpage_open;call super::ue_subpage_open;IF dw_pagelist.ShareData (dw_pagemaster)<1 THEN MessageBox ('공유 실패', '자료공유에 실패하였습니다.', StopSign!)
dw_pagelist.insertrow (0)
end event

event ue_activate;call super::ue_activate;dw_pagelist.setfocus ()
end event

event ue_subpage_updatetable;RETURN dw_pageList.uf_isupdatetable ()
end event

type ln_temptop from u_subpage`ln_temptop within utt_vertshare
end type

type ln_tempstart from u_subpage`ln_tempstart within utt_vertshare
integer beginy = 28
integer endy = 28
end type

type ln_templeft from u_subpage`ln_templeft within utt_vertshare
end type

type ln_cond_start from u_subpage`ln_cond_start within utt_vertshare
integer beginy = 28
integer endy = 28
end type

type ln_tempright from u_subpage`ln_tempright within utt_vertshare
end type

type ln_cond1_yline from u_subpage`ln_cond1_yline within utt_vertshare
end type

type ln_dw1_yline from u_subpage`ln_dw1_yline within utt_vertshare
end type

type ln_tempbutton from u_subpage`ln_tempbutton within utt_vertshare
end type

type dw_pagelist from u_dw within utt_vertshare
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

event retrieveend;call super::retrieveend;dw_pageMaster.Enabled = TRUE ; dw_pageMaster.uf_setrange (false)
uf_retrieveend (ts_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;tRow = currentrow
dw_pagemaster.scrolltorow (currentrow)
RETURN 0
end event

event retrievestart;call super::retrievestart;tRow = 0
end event

event ue_update;parent.EVENT ue_subpage_update ()
end event

event ue_insert;call super::ue_insert;IF AncestorReturnVALUE=-1 THEN RETURN -1
dw_pageMaster.POST SetFocus ()
RETURN AncestorReturnVALUE
end event

event ue_copyrow;call super::ue_copyrow;dw_pagemaster.scrolltorow (dw_pagelist.getrow())
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;//<임시> 데이터 입력 후 바로 입력버튼을 누르면 현재 편집하고 있는 자료가 사라집니다
dw_pagemaster.accepttext()
RETURN 0
end event

event updatestart;LONG  ll, lColCnt, lCol

STRING   ls_col_nm, ls_tag

lColCnt = integer (Object.datawindow.Column.Count)
FOR  ll = 1  TO  rowcount ()
   IF GetItemStatus (ll, 0, Primary!)=DataModified! OR GetItemStatus (ll, 0, Primary!)=NewModified!   Then
      FOR  lCol = 1  TO  lColCnt
         ls_col_nm = describe ('#' + string (lCol) + ".Name")
         ls_tag = describe (ls_col_nm+".Tag") ; ls_tag = f_replace (ls_tag, '(한)', '') // filter에서 한,영 입력모드 변환용
         IF PosA (ls_tag,'KEY')>0   Then
            IF f_null (Object.Data [ll, lCol])  Then
               SetRow (ll)
               ScrollToRow (ll)
               dw_pagemaster.setcolumn (ls_col_nm)
					dw_pagemaster.post setfocus ()
               RETURN 1
            End IF
         End IF
      NEXT
   End IF
NEXT

call super::updatestart
RETURN AncestorReturnValue
end event

event rowfocuschanged;call super::rowfocuschanged;IF	AncestorReturnValue=1 THEN RETURN 1
dw_pagemaster.post setfocus ()
end event

type dw_pagemaster from u_dw within utt_vertshare
integer x = 1966
integer y = 24
integer width = 1641
integer height = 2816
integer taborder = 20
boolean bringtotop = true
string title = "상세자료"
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean eb_null_line = false
end type

event ue_update;parent.EVENT ue_subpage_update ()
end event

event losefocus;call super::losefocus;dw_pageList.EVENT losefocus ()
end event

event rowfocuschanging;//
end event

event ue_copyrow;AcceptText ()
RETURN dw_pageList.EVENT ue_copyrow ()
end event

event ue_delete;AcceptText ()
RETURN dw_pageList.EVENT ue_delete ()
end event

event ue_insert;AcceptText ()
RETURN dw_pageList.EVENT ue_insert (row)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;dw_pagelist.scrolltorow (currentrow)
RETURN 0
end event

event oue_keydown;call super::oue_keydown;CHOOSE CASE key
   CASE KeyUpArrow!, KeyDownArrow!
      RETURN 1
   CASE KeyEnter!
      IF keyflags=0  Then
         send (Handle (THIS),256,9,0)  //TAB키로 처리
         RETURN 1    //입력된 값을 무시
      End IF
END CHOOSE
end event

event other;call super::other;CONSTANT integer WM_MOUSEWHEEL = 522
IF	message.number = WM_MOUSEWHEEL	Then
	message.processed = true
	return 1
End IF
end event

event constructor;IF f_notnull (dw_pagelist.is_encrypts) THEN is_encrypts = dw_pagelist.is_encrypts
call super::constructor
end event

event retrieveend;call fw_u_dwo::retrieveend
end event

event updatestart;//
end event

type st_move from pf_u_splitbar_vertical within utt_vertshare
integer x = 1938
integer y = 24
integer height = 2816
boolean setcondcolor = true
string leftdragobject = "dw_pagelist"
string rightdragobject = "dw_pagemaster"
end type

