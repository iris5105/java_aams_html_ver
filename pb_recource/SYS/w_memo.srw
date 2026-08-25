forward
global type w_memo from w_response1st1ncn
end type
type rte_function from pf_u_richtextedit within w_memo
end type
type rte_1 from pf_u_richtextedit within w_memo
end type
type dw_memo from fw_u_dwo within w_memo
end type
end forward

global type w_memo from w_response1st1ncn
integer height = 2924
string title = "메모입력"
boolean controlmenu = true
string icon = "Information!"
boolean center = true
rte_function rte_function
rte_1 rte_1
dw_memo dw_memo
end type
global w_memo w_memo

type variables
ads_jTier	ids1, ids2, ids3, ids4

BOOLEAN	ib_update = FALSE

STRING	is_user, is_text

DateTime idt_dt

INT   iStep = 0, iR [] = {1,1,1,1}
end variables

forward prototypes
public subroutine wf_setrow (fw_u_dwo dw, integer row)
end prototypes

public subroutine wf_setrow (fw_u_dwo dw, integer row);IF dw.GetRow ()=row  Then  // rowfocuschanged가 일어나지 않으므로
   dw.EVENT rowfocuschanged (row)
Else
   dw.SetRow (row)
End IF
end subroutine

on w_memo.create
int iCurrent
call super::create
this.rte_function=create rte_function
this.rte_1=create rte_1
this.dw_memo=create dw_memo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rte_function
this.Control[iCurrent+2]=this.rte_1
this.Control[iCurrent+3]=this.dw_memo
end on

on w_memo.destroy
call super::destroy
destroy(this.rte_function)
destroy(this.rte_1)
destroy(this.dw_memo)
end on

event close;IF ib_update THEN EVENT wue_update ()
dw_memo.UPDATE ()
commitJ ()
end event

event key;IF key=KeyEscape! THEN CLOSE (THIS)
end event

event wue_postopen;call super::wue_postopen;ids1 = CREATE ads_jTier
ids2 = CREATE ads_jTier
ids3 = CREATE ads_jTier
ids4 = CREATE ads_jTier

ids1.DataObject = '머리글'
ids2.DataObject = '머리글'
ids3.DataObject = '머리글'
ids4.DataObject = '머리글'

IF gds1.ShareData (ids1)<1 THEN MessageBox ('머리글 1단계 공유 실패', '머리글 1단계 자료공유에 실패하였습니다.', StopSign!)
IF gds2.ShareData (ids2)<1 THEN MessageBox ('머리글 2단계 공유 실패', '머리글 2단계 자료공유에 실패하였습니다.', StopSign!)
IF gds3.ShareData (ids3)<1 THEN MessageBox ('머리글 3단계 공유 실패', '머리글 3단계 자료공유에 실패하였습니다.', StopSign!)
IF gds4.ShareData (ids4)<1 THEN MessageBox ('머리글 4단계 공유 실패', '머리글 4단계 자료공유에 실패하였습니다.', StopSign!)

f_memo ('function memo', rte_function)

SetRedraw (FALSE)

STRING	ls_select

LONG	lRow, lRowCount, ll

lRowCount = dw_MEMO.retrieve ('%')
IF lRowCount>0 Then
   lRow = dw_MEMO.Find ("title='해야 할 일'", 1, lRowCount)
   IF lRow=0 THEN lRow = 1
   dw_MEMO.SetRow (lRow)
   dw_MEMO.ScrollToRow (lRow)
End IF
dw_MEMO.SetFocus ()
dw_MEMO.SetColumn ('title')

POST SetRedraw (TRUE)
end event

event wue_update;call super::wue_update;BLOB	lb_text
STRING	ls_blob_err
LONG	ll_blob

lb_text = blob (rte_1.CopyRTF (FALSE))
ll_blob = mo_.blob2hex(lb_text, SQLCA.is_updateblob, ls_blob_err)

UPDATEBLOB  MEMO
   SET   text = :lb_text
WHERE dt       = :idt_dt
  AND cre_user = :is_user;
IF SQLCA.sqlcode ()<>0  Then
   f_messageBox ('SQLCA', 'UPDATEBLOB memo ERROR')
   RETURN -1
End IF

ib_update = FALSE

RETURN 1
end event

type ln_tempbutton from w_response1st1ncn`ln_tempbutton within w_memo
end type

type ln_tempstart from w_response1st1ncn`ln_tempstart within w_memo
end type

type ln_templeft from w_response1st1ncn`ln_templeft within w_memo
end type

type ln_cond_start from w_response1st1ncn`ln_cond_start within w_memo
end type

type ln_tempright from w_response1st1ncn`ln_tempright within w_memo
end type

type ln_cond1_yline from w_response1st1ncn`ln_cond1_yline within w_memo
end type

type ln_dw1_yline from w_response1st1ncn`ln_dw1_yline within w_memo
end type

type p_print from w_response1st1ncn`p_print within w_memo
integer x = 2574
end type

type p_delete from w_response1st1ncn`p_delete within w_memo
integer x = 1001
end type

type p_new from w_response1st1ncn`p_new within w_memo
integer x = 526
end type

type p_close from w_response1st1ncn`p_close within w_memo
boolean visible = true
end type

type p_cancel from w_response1st1ncn`p_cancel within w_memo
integer x = 1769
end type

type p_ok from w_response1st1ncn`p_ok within w_memo
integer x = 2811
end type

type p_preview from w_response1st1ncn`p_preview within w_memo
integer x = 2263
end type

type p_update from w_response1st1ncn`p_update within w_memo
boolean visible = true
integer x = 3104
end type

type p_excel from w_response1st1ncn`p_excel within w_memo
integer x = 763
end type

type p_clear from w_response1st1ncn`p_clear within w_memo
integer x = 288
end type

type p_modify from w_response1st1ncn`p_modify within w_memo
integer x = 1550
end type

type p_retrieve from w_response1st1ncn`p_retrieve within w_memo
integer x = 50
end type

type p_tempsave from w_response1st1ncn`p_tempsave within w_memo
integer x = 1239
end type

type p_collect from w_response1st1ncn`p_collect within w_memo
integer x = 2025
end type

type p_select from w_response1st1ncn`p_select within w_memo
end type

type p_find from w_response1st1ncn`p_find within w_memo
end type

type p_execu from w_response1st1ncn`p_execu within w_memo
end type

type p_enroll from w_response1st1ncn`p_enroll within w_memo
end type

type rte_function from pf_u_richtextedit within w_memo
integer x = 3223
integer y = 168
integer width = 347
integer height = 1096
integer taborder = 20
integer textsize = -9
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
long init_backcolor = 16777215
boolean init_displayonly = true
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

type rte_1 from pf_u_richtextedit within w_memo
integer x = 50
integer y = 1268
integer width = 3520
integer height = 1548
integer taborder = 20
fontpitch fontpitch = fixed!
string facename = "D2Coding"
boolean init_vscrollbar = true
boolean init_wordwrap = true
boolean init_tabbar = true
boolean init_toolbar = true
boolean init_popmenu = true
borderstyle borderstyle = stylebox!
end type

event key;STRING  ls = '■ㆍ∴※…√⇒◈●⊙◇▷‥☞±=【】「」『』《》〔〕〈〉'
STRING   ls_text, ls1

ls_text = TRIM (SelectedText ()) ; ls1 = Right (ls_text, 1)

IF DisplayOnly THEN RETURN

ib_update = TRUE

IF key=KeySpaceBar!  Then
   IF POS (ls, ls1)>0 And iStep>0   Then
      CHOOSE CASE iStep
         CASE 1
            ReplaceText (ids1.object.c [iR [1]])
            ids1.object.t [iR [1]] = ids1.object.t [iR [1]] + 1
            ids1.object.u [iR [1]] = ids1.object.u [iR [1]] + 1
            ids1.Sort ()
         CASE 2
            ReplaceText ('  ' + ids2.object.c [iR [2]])
            ids2.object.t [iR [2]] = ids2.object.t [iR [2]] + 1
            ids2.object.u [iR [2]] = ids2.object.u [iR [2]] + 1
            ids2.Sort ()
         CASE 3
            ReplaceText ('      ' + ids3.object.c [iR [3]])
            ids3.object.t [iR [3]] = ids3.object.t [iR [3]] + 1
            ids3.object.u [iR [3]] = ids3.object.u [iR [3]] + 1
            ids3.Sort ()
         CASE 4
            ReplaceText ('         ' + ids4.object.c [iR [4]])
            ids4.object.t [iR [4]] = ids4.object.t [iR [4]] + 1
            ids4.object.u [iR [4]] = ids4.object.u [iR [4]] + 1
            ids4.Sort ()
      END CHOOSE
      iStep = 0 ; iR [] = {1,1,1,1}
      pf_f_togglekoreng ('k')
   End IF
ElseIF key=KeyEscape! THEN
   IF POS (ls, ls1)=0   Then
      CLOSE (PARENT)
   Else
      ReplaceText ('')
   End IF
   RETURN
End IF

IF keyflags=2  Then
   CHOOSE CASE key
      CASE KeyY!
         SelectTextLine ()
         Clear ()
         RETURN
      CASE KeyZ!
         IF CanUndo ()  Then
            Undo ()
         Else
            PasteRTF (is_text )
            MessageBox ('Stop', 'Nothing to undo.')
         End IF
         RETURN
   END CHOOSE
End IF

IF NOT (keyflags=2 And &
   (key=KeyHome! OR key=KeyEnd! OR key=KeyUpArrow! OR key=KeyDownArrow! OR key=KeyRightArrow! OR key=KeyAdd! OR key=KeyLeftArrow! OR key=KeySubtract!)) THEN RETURN
IF f_null (ls_text)  Then
   iStep = 0 ; iR [] = {1,1,1,1}
Else
   IF POS (ls, ls1)=0 THEN RETURN
End IF

CHOOSE CASE key
   CASE KeyRightArrow!, KeyAdd!
      IF iStep<4 THEN iStep ++
   CASE KeyLeftArrow!, KeySubtract!
      IF iStep>1 THEN iStep --
   CASE KeyUpArrow!
      IF iStep=0 THEN iStep = 1
      IF iR [iStep]>1 THEN iR [iStep] --
   CASE KeyDownArrow!
      IF iStep=0 THEN iStep = 1
      IF iR [iStep]<22 THEN iR [iStep] ++
   CASE KeyHome!
      IF iStep=0 THEN iStep = 1
      iR [iStep] = 1
   CASE KeyEnd!
      IF iStep=0 THEN iStep = 1
      iR [iStep] = 22
END CHOOSE

CHOOSE CASE iStep
   CASE 1
      ReplaceText (ids1.object.c [iR [1]])
      SelectText (SelectedLine (), SelectedColumn () - 1, SelectedLine (), SelectedColumn () - Len (string (ids1.object.c [iR [1]])))
   CASE 2
      ReplaceText ('  ' + ids2.object.c [iR [2]])
      SelectText (SelectedLine (), SelectedColumn () - 3, SelectedLine (), SelectedColumn () - 1)
   CASE 3
      ReplaceText ('      ' + ids3.object.c [iR [3]])
      SelectText (SelectedLine (), SelectedColumn () - 7, SelectedLine (), SelectedColumn () - 1)
   CASE 4
      ReplaceText ('         ' + ids4.object.c [iR [4]])
      SelectText (SelectedLine (), SelectedColumn () - 10, SelectedLine (), SelectedColumn () - 1)
END CHOOSE

RETURN 1
end event

type dw_memo from fw_u_dwo within w_memo
integer x = 50
integer y = 156
integer width = 3163
integer height = 1104
integer taborder = 10
string dataobject = "d_memo"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
end type

event rowfocuschanged;call super::rowfocuschanged;STRING	ls_blob_err
LONG	ll_blob

IF currentrow=0 OR NOT Enabled THEN RETURN
IF ib_update THEN Parent.EVENT wue_update ()

Parent.SetRedraw (FALSE)

is_user = Object.cre_user [currentrow]
idt_dt  = Object.dt [currentrow]

BLOB  lb_text

SELECTBLOB  text
  INTO  :lb_text
FROM    memo t1
WHERE   t1.dt       = :idt_dt
  AND   t1.cre_user = :is_user;

ll_blob = mo_.hex2blob(SQLCA.is_hexfile, lb_text, ls_blob_err)

rte_1.SelectTextAll () ; rte_1.Clear ()
IF f_notnull (lb_text)  Then
   is_text = string (lb_text)
Else
   is_text = ''
End IF
rte_1.PasteRTF (is_text)
rte_1.scrolltorow (1)
//rte_1.Scroll (rte_1.LineCount () * -1)

//IF Object.cre_user [currentrow]<>gnv_vari.is_user_id  Then
//   rte_1.DisplayOnly = TRUE
//Else
   rte_1.DisplayOnly = FALSE
//End IF
IF rte_1.DisplayOnly THEN rte_1.BackColor = 15790320 &
Else                      rte_1.BackColor = rgb (240,255,255)

SelectRow (0, FALSE)
SelectRow (currentrow, TRUE)

Parent.SetRedraw (TRUE)
end event

event clicked;call super::clicked;IF row<>0 THEN SetRow (row)
end event

event retrieveend;call super::retrieveend;Enabled = TRUE
end event

event oue_keydown;call super::oue_keydown;LONG lRow, lRowCount

IF key=KeyF5!  Then
   UPDATE (TRUE,TRUE)
   reset ()
   retrieve ('%')
   SetColumn ('title')
End IF

IF keyflags<>2 THEN RETURN // CTRL

CHOOSE CASE key
   CASE KeyI!, KeyA!
      STRING   ls_title

      Parent.SetRedraw (FALSE)
      IF ib_update THEN Parent.EVENT wue_update ()
      lRow = insertrow (0)
      Object.dt [lRow] = f_sysdate ('')
      Object.cre_user [lRow] = gnv_vari.is_user_id
      Object.priority [lRow] = '2'
      ls_title = string (Object.dt [lRow]) + gnv_vari.is_user_id
      Object.title [lRow] = ls_title
      UPDATE (TRUE, TRUE)

      lRowCount = retrieve ('%')
      lRow = FIND ("title='" + ls_title + "'", 1, lRowCount)
		IF	lRow>0	Then
	      Object.title [lRow] = null_s
   	   wf_setrow (THIS, lRow)
		End IF
      SetColumn ('title')
      Parent.POST SetRedraw (TRUE)

   CASE KeyD!
      lRow = GetRow ()
//      IF NOT gaa.admin And gnv_vari.is_user_id<>Object.cre_user [lRow]   Then
//         f_messageBox ('ERR', '작성자(' + string (Object.cre_user [lRow]) +')만 삭제할 수 있습니다.')
//         RETURN
//      End IF
      IF f_messageBox ('W003', '메모')=2 THEN RETURN
      ib_update = FALSE
      Parent.SetRedraw (FALSE)
      deleterow (lRow )
      wf_setrow (THIS, lRow)
      Parent.POST SetRedraw (TRUE)
END CHOOSE
end event

event doubleclicked;call super::doubleclicked;IF	row=0	THEN RETURN

STRING	ls_text, la_text [], la_s []

LONG	ll, lj

IF	POS (Object.title [row],'encrypt')>0	Then
	rte_1.SelectTextAll () ; rte_1.copy () ; ls_text = clipBoard ()
	lj = f_get_array (ls_text, '~r~n', la_text)
	ls_text = ''
	FOR  ll = 1  TO  lj
		IF	f_null (la_text [ll])	Then
			ls_text += '~r~n'
		Else
			IF	LEFT (Object.title [row],2)='회사'	Then
				IF	LEFT (la_text [ll],1)='['	Then
					ls_text += la_text [ll] + '~r~n'
				Else
					f_get_array (la_text [ll], ' ', la_s)
					ls_text += la_s [1] + ' ' + la_s [2] + SPACE (40 - LenA (la_s [1] + la_s [2])) + la_s [1] + ' ' + la_s [2] + '~r~n'
				End IF
			Else
				f_get_array (la_text [ll], '=', la_s)
				ls_text += la_s [1] + '=' + la_s [2] + '=' + la_s [2] + '~r~n'
			End IF
		End IF
	NEXT
	rte_1.SelectTextAll ()
	rte_1.ReplaceText (ls_text)
   rte_1.Scroll (rte_1.LineCount () * -1 )
	Object.dt [row] = f_sysdate ('')
Else
	IF	Object.cre_user [row]=gnv_vari.is_user_id	Then
		Parent.PostEvent("wue_update")
		Parent.SetRedraw (FALSE)
		Object.dt [row] = f_sysdate ('')
		is_user = Object.cre_user [row]
		idt_dt  = Object.dt [row]
	
		UPDATE (TRUE, TRUE)
	
		reset ()
		lj = retrieve (gnv_vari.is_user_id)
		ll = FIND ("cre_user='" + is_user + "'", 1, lj)
		SetRow (ll)
		ScrollToRow (ll)
		SetColumn ('title')
		Parent.POST SetRedraw (TRUE)
	End IF
End IF
end event

