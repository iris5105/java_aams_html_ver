forward
global type u_ja990f_t1 from utt_listdetail
end type
end forward

global type u_ja990f_t1 from utt_listdetail
string text = "분개유형/시장구분"
end type
global u_ja990f_t1 u_ja990f_t1

type variables
STRING	is_tr_cd
end variables

on u_ja990f_t1.create
call super::create
end on

on u_ja990f_t1.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja990f_t1
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja990f_t1
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja990f_t1
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja990f_t1
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja990f_t1
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja990f_t1
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja990f_t1
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja990f_t1
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja990f_t1
string dataobject = "d_ja990f_t1a"
boolean ibsetlist4subbtn = true
boolean eb_range_delcopy = true
boolean eb_null_line = false
string is_resize_column = "xx_jeokyo_cd"
end type

event dw_pagelist::itemchanged;call super::itemchanged;LONG	lRow

CHOOSE CASE dwo.name
   CASE "row_no"
      IF mod(dec(data),2)=0	Then
			SetItem (row, 'chadae_gb', 'C') 
      Else
			SetItem (row, 'chadae_gb', 'D')
		End IF

   CASE "gwamok"
      IF f_null (Object.chadae_gb [row])  Then
         IF mod(dec(Object.row_no [row]),2)=0	Then
				SetItem (row, 'chadae_gb', 'C') 
         ELSE                               
				SetItem (row, 'chadae_gb', 'D')
			End IF
      End IF

   CASE 'upmu_gb'
      FOR  lRow = (row + 1)  TO  rowcount ()
         IF f_nvl (Object.upmu_gb [lRow],dwo.primary [row])=dwo.primary [row] THEN Object.upmu_gb [lRow] = data
      NEXT

   CASE 'jasan_gb'
      FOR  lRow = (row + 1)  TO  rowcount ()
         IF f_nvl (Object.jasan_gb [lRow],dwo.primary [row])=dwo.primary [row] THEN Object.jasan_gb [lRow] = data
      NEXT

   CASE 'jeokyo_cd'
      FOR  lRow = (row + 1)  TO  rowcount ()
         IF f_nvl (Object.jeokyo_cd [lRow],dwo.primary [row])=dwo.primary [row] THEN Object.jeokyo_cd [lRow] = data
      NEXT
END CHOOSE
end event

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'upmu_gb', gaa.corp_gr, '', 1, '')
end event

event dw_pagelist::doubleclicked;IF rowcount ()=0 OR row=0 THEN RETURN
::Clipboard (string (dwo.primary [row]) )   // ClipBoard에 복사처리
IF gaa.admin THEN gw_mdi.setmicrohelp (string (dwo.primary [row]) + '...ClipBoard에 복사 ' + dataobject)
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;IF AncestorReturnVALUE=1 THEN RETURN 1

uf_setColumn ('tr_cd', is_tr_cd)
uf_setColumn ('jeokyo_cd', is_tr_cd)
IF tRow=0   Then
   uf_setColumn ('upmu_gb', '1')
   uf_setColumn ('row_no', '1')

   POST SetColumn ('jasan_gb')
Else
   uf_setColumn ('upmu_gb', Object.upmu_gb [tRow])
   uf_setColumn ('row_no', string(dec(Object.row_no [tRow]) + 1))
   uf_setColumn ('jasan_gb', Object.jasan_gb [tRow])

   POST SetColumn ('gwamok')
End IF

RETURN 0
end event

event dw_pagelist::ue_delete;IF	rowcount ()=0 THEN RETURN -1
IF	eb_Range_DelCopy=FALSE And uf_getrange ()	Then
	f_messageBox ('RANG', '삭제')
	RETURN -1
End IF
IF f_messageBox ('W003',iw_parent.dynamic of_getpgmnm ())=2 THEN RETURN -1	// delete Cancel

IF EVENT ue_deletestart ()=1 THEN RETURN -1

LONG	ll_FirstRow, ll_DeleteCount = 0, lRow

Enabled = FALSE

ll_FirstRow = GetSelectedRow (0) ; IF  ll_FirstRow=0  THEN ll_FirstRow = GetRow ()
lRow	= ll_FirstRow
DO
	ll_DeleteCount ++
	EVENT ue_deleterow (lRow)
	IF	DeleteRow (lRow)=-1	Then
		f_messageBox ('D000', iw_parent.dynamic of_getpgmnm ())
		RETURN -1
	End IF
	lRow = GetSelectedRow (lRow - 1)
LOOP UNTIL  lRow = 0
IF ll_FirstRow>rowcount () THEN ll_FirstRow = rowcount ()

uf_setrow (ll_FirstRow, true)

POST SetFocus ()

RETURN	ll_DeleteCount
end event

event dw_pagelist::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE	GetColumnName()
	CASE 'gwamok'
		IF	LEFT (Object.gwamok [tRow],1)='[' THEN RETURN 2
END CHOOSE
RETURN 1	// 순번
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja990f_t1
string dataobject = "d_ja990f_t1b"
end type

event dw_pagedetail::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'danc_gb', gaa.corp_gr, '', 2, '')
end event

event dw_pagedetail::doubleclicked;IF rowcount ()=0 THEN RETURN
::Clipboard (string (dwo.primary [row]) )   // ClipBoard에 복사처리
IF gaa.admin THEN gw_mdi.setmicrohelp (string (dwo.primary [row]) + '...ClipBoard에 복사 ' + dataobject)
end event

event dw_pagedetail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_cd', is_tr_cd)

RETURN 0
end event

type st_move from utt_listdetail`st_move within u_ja990f_t1
end type

