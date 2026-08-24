forward
global type u_ja990e_t2 from utt_vertdetail
end type
end forward

global type u_ja990e_t2 from utt_vertdetail
string text = "보고서별 계정과목"
end type
global u_ja990e_t2 u_ja990e_t2

on u_ja990e_t2.create
call super::create
end on

on u_ja990e_t2.destroy
call super::destroy
end on

type ln_temptop from utt_vertdetail`ln_temptop within u_ja990e_t2
end type

type ln_tempstart from utt_vertdetail`ln_tempstart within u_ja990e_t2
end type

type ln_templeft from utt_vertdetail`ln_templeft within u_ja990e_t2
end type

type ln_cond_start from utt_vertdetail`ln_cond_start within u_ja990e_t2
end type

type ln_tempright from utt_vertdetail`ln_tempright within u_ja990e_t2
end type

type ln_cond1_yline from utt_vertdetail`ln_cond1_yline within u_ja990e_t2
end type

type ln_dw1_yline from utt_vertdetail`ln_dw1_yline within u_ja990e_t2
end type

type ln_tempbutton from utt_vertdetail`ln_tempbutton within u_ja990e_t2
end type

type dw_pagelist from utt_vertdetail`dw_pagelist within u_ja990e_t2
string dataobject = "d_ja990e_t2a"
end type

event dw_pagelist::itemchanged;call super::itemchanged;LONG	lRowCount, lRow

CHOOSE CASE dwo.name
   CASE 'pgm_id'
      lRowCount = dw_pageDetail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_pageDetail.object.pgm_id [lRow] = data
      NEXT
END CHOOSE
end event

type dw_pagedetail from utt_vertdetail`dw_pagedetail within u_ja990e_t2
string dataobject = "d_ja990e_t2b"
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;retrieve (dw_pageList.object.pgm_id [tRow] )
end event

event dw_pagedetail::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'gwamok'
      RETURN 9
END CHOOSE

RETURN 1
end event

event dw_pagedetail::itemchanged;LONG	ll

CHOOSE CASE dwo.name
   CASE 'gwamok'
      IF data='-' OR data='--' OR data='---' THEN RETURN

   CASE 'seq_no'
      FOR  ll = (row + 1)  TO  rowcount ()
         IF Object.seq_no [ll]=Object.seq_no [row] THEN Object.seq_no [ll] = dec (data) ELSE EXIT
      NEXT
      RETURN
END CHOOSE

CALL super::itemchanged
end event

event dw_pagedetail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('pgm_id', dw_pageList.object.pgm_id [tRow])

LONG	lRow

lRow = getRow ()
IF lRow>0 THEN
   uf_setColumn ('seq_no', string(object.seq_no [lRow]))
   uf_setColumn ('yonsan', string(object.yonsan [lRow]))
   uf_setColumn ('desc_nm', object.desc_nm [lRow])

   POST SetColumn ("gwamok")
Else
   uf_setColumn ('seq_no', '1')
   uf_setColumn ('yonsan', '1')

   POST SetColumn ("seq_no")
End IF

RETURN 0
end event

type st_move from utt_vertdetail`st_move within u_ja990e_t2
boolean rightmaxsizefixed = true
end type

