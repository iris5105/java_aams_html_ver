forward
global type w_response_s from w_response1st
end type
type dw_view from u_dw within w_response_s
end type
end forward

global type w_response_s from w_response1st
integer height = 2124
event wue_ok ( )
event type boolean ue_wpage_modified ( )
event type boolean ue_wpage_updatetable ( )
dw_view dw_view
end type
global w_response_s w_response_s

type variables
BOOLEAN  ib_auto_size = FALSE

Private:
	LONG	il_width_max
end variables

forward prototypes
public subroutine uf_constructor ()
end prototypes

event type boolean ue_wpage_modified();RETURN FALSE
end event

event type boolean ue_wpage_updatetable();RETURN FALSE
end event

public subroutine uf_constructor ();BOOLEAN  lb_fund_cd = FALSE

LONG  lCol, lColCnt, lRow = 0, ll_column = 3

STRING   ls_col, ls_tag, ls_seq, ls_sort [], ls_fcolumn, ls_lang

il_width_max = 0
lColCnt = long (dw_view.object.DataWindow.Column.Count)
FOR  lCol = 1  TO  lColCnt
   ls_col = '#' + string (lCol)
   IF dw_view.describe (ls_col+".Band")='detail' And dw_view.describe (ls_col+".Visible")='1' And long (dw_view.describe (ls_col+".Width"))>0   Then
		ll_column ++
      il_width_max = MAX(UnitsToPixels (long (dw_view.describe (ls_col+".X"))+long (dw_view.describe (ls_col+".Width")) + 3, XUnitsToPixels!), il_width_max)
      ls_seq = dw_view.describe (ls_col+'.TabSequence') + ' '
      ls_tag = f_replace (dw_view.describe (ls_col+'.Tag'),'KEY','')
      IF PosA (ls_tag,',')>0 THEN ls_tag = MidA (ls_tag, 1, PosA (ls_tag, ',') - 1)
      IF PosA (ls_tag,'(한)')>0  Then
         ls_lang = '한'
         ls_tag = f_replace (ls_tag,'(한)','')
      Else
         ls_lang = '영'
      End IF
   End IF
NEXT
il_width_max += ll_column * PixelsToUnits (2, XPixelsToUnits!)	// 컬럼간 간격 추가
IF	VScrollBar THEN il_width_max = pixelstounits (UnitsToPixels (il_width_max + 72, XUnitsToPixels!), XPixelsToUnits!)
end subroutine

on w_response_s.create
int iCurrent
call super::create
this.dw_view=create dw_view
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_view
end on

on w_response_s.destroy
call super::destroy
destroy(this.dw_view)
end on

event open;call super::open;dw_view.settransobject (sqlca)
dw_view.POST EVENT ue_Retrieve ()
dw_view.POST SetFocus ()
end event

event wue_postopen;call super::wue_postopen;//<임시> 팝업창에서 서브버튼을 사용하는 경우 초기화합니다, 길이조절 추가 20210402
IF dw_view.ibsetlist4subbtn	Then
	LONG	ll_dwheightminus1value
	
	ll_dwheightminus1value = dw_view.dynamic of_dwheightminus1value()
	IF ll_dwheightminus1value>0 Then
		dw_view.height -= ll_dwheightminus1value
		dw_view.y += ll_dwheightminus1value
	End IF
	
	dw_view.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
	dw_view.of_dw2subbtn ({'p_input'}, (dw_view.enabled And dw_view.eb_new_false=FALSE))
	dw_view.of_dw2subbtn ({'p_copy'}, (dw_view.enabled And dw_view.eb_copy_false=FALSE))
	dw_view.of_dw2subbtn ({'p_delete'}, (dw_view.enabled And dw_view.eb_delete_false=FALSE))
End IF
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_response_s
end type

type ln_tempstart from w_response1st`ln_tempstart within w_response_s
end type

type ln_templeft from w_response1st`ln_templeft within w_response_s
end type

type ln_cond_start from w_response1st`ln_cond_start within w_response_s
end type

type ln_tempright from w_response1st`ln_tempright within w_response_s
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_response_s
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_response_s
end type

type dw_view from u_dw within w_response_s
event ue_retrieve ( )
integer x = 50
integer y = 24
integer width = 3520
integer height = 1996
integer taborder = 10
boolean enabled = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean eb_fund_default_change = false
boolean eb_null_line = false
end type

event doubleclicked;// ClipBoard에 복사처리
TRY
	IF f_notnull (dwo) And row>0 THEN ::Clipboard (string (dwo.primary [row]))
CATCH (runtimeerror er)
   RETURN
END TRY
end event

event losefocus;call super::losefocus;AcceptText ()
end event

event rowfocuschanged;call super::rowfocuschanged;IF currentrow=0 THEN RETURN
SelectRow (0, FALSE)
IF POS ('18',describe ('DataWindow.Processing'))>0 THEN SelectRow (currentrow, TRUE)
end event

event oue_keydown;call super::oue_keydown;IF key=KeyEscape! THEN CLOSE (Parent)
STRING	ls_seq
IF keyflags=2  Then
   CHOOSE CASE key
      CASE KeyS!, KeyT!
			SELECT  '(' || f_n0 (seqval ('excel_seq'), 3) || ')'
			  INTO  :ls_seq
			FROM    dual;
			
			ls_seq = SQLCA.getitemstring (1)
			
			IF	f_nvl (lower (title),'none')='none'	Then
				f_xlsx (THIS, '__' + dataobject + ls_seq, dataobject, '', '', '', '')
			Else
				f_xlsx (THIS, '__' + dataobject + ls_seq, title, '', '', '', '')
			End IF			
      CASE KeyM!
         OPEN (w_memo)
   END CHOOSE
End IF
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('detail', rowcount, eb_null_line)
end event

