forward
global type wt_vertshare from w_winpage
end type
type dw_list from u_dw within wt_vertshare
end type
type dw_master from u_dw within wt_vertshare
end type
type st_move from pf_u_splitbar_vertical within wt_vertshare
end type
end forward

global type wt_vertshare from w_winpage
dw_list dw_list
dw_master dw_master
st_move st_move
end type
global wt_vertshare wt_vertshare

type variables

end variables

forward prototypes
public subroutine of_initbutton_after ()
end prototypes

public subroutine of_initbutton_after ();// (입력,복사,삭제)버튼 비활성화시 자동 초기화
IF	NOT gnv_authorbtn.ib_inpbtn_yn	Then
	dw_list.eb_new_false = TRUE
	dw_master.eb_new_false = TRUE
End IF
IF	NOT gnv_authorbtn.ib_cpybtn_yn	Then
	dw_list.eb_copy_false = TRUE
	dw_master.eb_copy_false = TRUE
End IF
IF	NOT gnv_authorbtn.ib_delbtn_yn	Then
	dw_list.eb_delete_false = TRUE
	dw_master.eb_delete_false = TRUE
End IF
end subroutine

on wt_vertshare.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_master=create dw_master
this.st_move=create st_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.st_move
end on

on wt_vertshare.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.dw_master)
destroy(this.st_move)
end on

event wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
IF dw_c.dataobject>'' And ib_manageData   Then
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

event wue_lastopen;call super::wue_lastopen;IF dw_list.ShareData (dw_master)<1 THEN MessageBox ('공유 실패', '자료공유에 실패하였습니다.', StopSign!)
dw_list.post event ue_dddw_retrieve ()
IF	eb_direct_retrieve	Then
	p_retrieve.post event clicked ()
Else
	dw_list.uf_clear ()
End IF
end event

event wue_update;IF dw_master.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_modified ()	Then
	IF	uf_updateCommit (dw_list)=-1 THEN RETURN -1
End IF
RETURN 1
end event

type lb_dirlist from w_winpage`lb_dirlist within wt_vertshare
end type

type ln_templeft from w_winpage`ln_templeft within wt_vertshare
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_vertshare
end type

type ln_temptop from w_winpage`ln_temptop within wt_vertshare
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_vertshare
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_vertshare
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_vertshare
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_vertshare
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_vertshare
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_vertshare
end type

type ln_tempright from w_winpage`ln_tempright within wt_vertshare
end type

type uo_navi from w_winpage`uo_navi within wt_vertshare
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_vertshare
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_vertshare
end type

type st_top_rect from w_winpage`st_top_rect within wt_vertshare
end type

type p_close from w_winpage`p_close within wt_vertshare
end type

type p_excel from w_winpage`p_excel within wt_vertshare
end type

type p_print from w_winpage`p_print within wt_vertshare
end type

type p_delete from w_winpage`p_delete within wt_vertshare
end type

type p_update from w_winpage`p_update within wt_vertshare
end type

type p_input from w_winpage`p_input within wt_vertshare
end type

type p_retrieve from w_winpage`p_retrieve within wt_vertshare
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

IF	p_clear.visible=false	Then
	IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
	dw_list.of_setdestroy2filter('')
	dw_list.of_setdestroy2sort('')
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
   dw_list.uf_protect (0, dw_list.ia_protect [1]) ; dw_master.uf_protect (0, dw_master.ia_protect [1])
Else
   dw_list.uf_protect (0, dw_list.ia_protect [2]) ; dw_master.uf_protect (0, dw_master.ia_protect [2])
End IF
dw_list.Enabled = FALSE ; dw_list.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within wt_vertshare
end type

type p_copy from w_winpage`p_copy within wt_vertshare
end type

type dw_c from w_winpage`dw_c within wt_vertshare
end type

type btn_update from w_winpage`btn_update within wt_vertshare
end type

type st_count from w_winpage`st_count within wt_vertshare
end type

type dw_list from u_dw within wt_vertshare
integer x = 50
integer y = 348
integer width = 2789
integer height = 2416
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletobottom = true
boolean ibsetlist4excelclip = true
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
dw_master.Enabled = TRUE ; dw_master.uf_setrange (false)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow
dw_master.scrolltorow (currentrow)
RETURN 0
end event

event losefocus;//
end event

event ue_insert;call super::ue_insert;IF AncestorReturnVALUE=-1 THEN RETURN -1
dw_Master.POST SetFocus ()
RETURN AncestorReturnVALUE
end event

event ue_copyrow;call super::ue_copyrow;dw_master.scrolltorow (dw_list.getrow())
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;//<임시> 데이터 입력 후 바로 입력버튼을 누르면 현재 편집하고 있는 자료가 사라집니다
dw_master.accepttext()
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
               dw_master.setcolumn (ls_col_nm)
					dw_master.post setfocus ()
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
dw_master.post setfocus ()
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type dw_master from u_dw within wt_vertshare
integer x = 2866
integer y = 348
integer width = 2565
integer height = 2416
integer taborder = 12
boolean bringtotop = true
string title = "상세 수정 화면"
boolean scaletoright = true
boolean scaletobottom = true
boolean setbringtotop = true
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean eb_null_line = false
end type

event ue_copyrow;AcceptText ()
RETURN dw_List.EVENT ue_copyrow ()
end event

event ue_delete;AcceptText ()
RETURN dw_List.EVENT ue_delete ()
end event

event ue_insert;AcceptText ()
RETURN dw_List.EVENT ue_insert (row)
end event

event resize;IF	dec (Describe("DataWindow.Detail.Height"))<height THEN MODIFY ("DataWindow.Detail.Height='" + string (height) + "'")
call super::resize
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;dw_list.scrolltorow (currentrow)
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

event constructor;IF f_notnull (dw_list.is_encrypts) THEN is_encrypts = dw_list.is_encrypts
uf_date_nation (is_date_nation)
call super::constructor
end event

event retrieveend;call fw_u_dwo::retrieveend
end event

event updatestart;//
end event

type st_move from pf_u_splitbar_vertical within wt_vertshare
integer x = 2843
integer y = 348
integer height = 2416
boolean setcondcolor = true
string leftdragobject = "dw_list"
string rightdragobject = "dw_master"
end type

event constructor;call super::constructor;IF	dw_master.zoominout THEN ii_rightmargin += PixelsToUnits(12, XPixelsToUnits!)
end event

