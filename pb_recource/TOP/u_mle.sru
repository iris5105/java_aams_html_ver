forward
global type u_mle from pf_u_multilineedit
end type
end forward

global type u_mle from pf_u_multilineedit
integer textsize = -10
long textcolor = 33554432
boolean enabled = false
boolean vscrollbar = true
boolean autovscroll = true
boolean hideselection = false
event ue_print ( )
event ue_update ( )
event key pbm_keydown
event type integer ue_blob_update ( integer row )
event key_post ( string arg_text )
event doubleclicked pbm_lbuttondblclk
end type
global u_mle u_mle

type variables
ads_jTier	ids1, ids2, ids3, ids4

BOOLEAN	ib_update = FALSE

LONG	iStep, iR []

STRING	is_search
end variables

forward prototypes
public subroutine uf_reset (boolean aboolean)
public subroutine uf_init (string ag_search, boolean ag_managedata)
end prototypes

event ue_update();Parent.TriggerEvent ('wue_update')
end event

event key;LONG	lPos

STRING	ls = '■ㆍ∴※…√⇒◈●⊙◇▷‥☞±=【】「」『』《》〔〕〈〉'
STRING	ls_text, ls1

lPos    = Position ()
ls_text = TRIM (SelectedText ())
ls1     = RIGHT (ls_text, 1)

IF DisplayOnly Then
   IF keyflags = 2 AND (key = KeyRightArrow! OR key = KeyLeftArrow!) Then
      ls_text = f_nvl (is_search, ls_text)
      IF NOT f_null (ls_text) Then
         IF key=KeyRightArrow! THEN lPos = POS (TEXT, ls_text, Position () + 1) ELSE lPos = LASTPOS (TEXT, ls_text, Position ())
         IF lPos>0             THEN SelectText (lPos, Len (ls_text))            ELSE SelectText (Position (), Len (ls_text))
         RETURN 1
      END IF
   END IF
   RETURN
END IF

ib_update = TRUE

IF keyflags = 2 AND key = KeyY!  Then
   SelectText (POS (TEXT, TextLine ()), Len (TextLine ()) + 1)
   clear ()
   RETURN
ELSEIF keyflags = 2 AND key = KeyZ! Then
   undo ()
   RETURN
END IF

IF key = KeySpaceBar!   Then
   IF POS (ls, ls1) > 0 AND iStep > 0  Then
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
      iStep = 0 ; iR [] = {1, 1, 1, 1}
      pf_f_togglekoreng ('k')
   END IF
ELSEIF key = KeyEscape! Then
   ReplaceText ('')
   RETURN
END IF

IF NOT (keyflags=2 AND (key=KeyHome! OR key=KeyEnd! OR key=KeyUpArrow! OR key=KeyDownArrow! OR key=KeyRightArrow! OR key=KeyAdd! OR key=KeyLeftArrow! OR key=KeySubtract!)) THEN RETURN
IF f_null (ls_text)  Then
   iStep = 0 ; iR [] = {1, 1, 1, 1}
ELSE
   IF POS (ls, ls1) = 0 Then
      IF keyflags = 2 AND (key = KeyRightArrow! OR key = KeyAdd! OR key = KeyLeftArrow! OR key = KeySubtract!) Then
         IF NOT f_null (ls_text) Then
            IF key=KeyRightArrow! OR key=KeyAdd! THEN lPos = POS (TEXT, ls_text, Position () + 1) ELSE lPos = LASTPOS (TEXT, ls_text, Position ())
            IF lPos>0                            THEN SelectText (lPos, Len (ls_text))            ELSE SelectText (Position (), Len (ls_text))
            RETURN 1
         END IF
      END IF
      RETURN
   END IF
END IF

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
      SelectText (lPos, Len (STRING (ids1.object.c [iR [1]])))
   CASE 2
      ReplaceText ('  ' + ids2.object.c [iR [2]])
      SelectText (lPos, 3)
   CASE 3
      ReplaceText ('      ' + ids3.object.c [iR [3]])
      SelectText (lPos, 7)
   CASE 4
      ReplaceText ('         ' + ids4.object.c [iR [4]])
      SelectText (lPos, 10)
END CHOOSE

RETURN 1
end event

public subroutine uf_reset (boolean aboolean);TEXT = ''
is_search = ''
ib_update = FALSE
DisplayOnly = TRUE
IF aboolean THEN backcolor = 15793151 ELSE Enabled = FALSE
end subroutine

public subroutine uf_init (string ag_search, boolean ag_managedata);TEXT = ''
is_search = ag_search
ib_update = FALSE
DisplayOnly = NOT ag_manageData
backcolor = IIF (displayOnly, 15793151, RGB (255,255,255))
Enabled = TRUE
end subroutine

on u_mle.create
call super::create
end on

on u_mle.destroy
call super::destroy
end on

event getfocus;backcolor = IIF (displayOnly, 15793151, RGB (255,255,255))
end event

event constructor;ids1 = CREATE ads_jTier
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
end event

event rbuttondown;IF NOT DisplayOnly And NOT ib_update THEN ib_update = TRUE
end event

event losefocus;call super::losefocus;backcolor = RGB (240, 255, 255)
end event

