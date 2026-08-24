forward
global type u_ja990g_t1 from utt_vertdetail
end type
end forward

global type u_ja990g_t1 from utt_vertdetail
string text = "프로그램별 거래코드"
end type
global u_ja990g_t1 u_ja990g_t1

on u_ja990g_t1.create
call super::create
end on

on u_ja990g_t1.destroy
call super::destroy
end on

type ln_temptop from utt_vertdetail`ln_temptop within u_ja990g_t1
end type

type ln_tempstart from utt_vertdetail`ln_tempstart within u_ja990g_t1
end type

type ln_templeft from utt_vertdetail`ln_templeft within u_ja990g_t1
end type

type ln_cond_start from utt_vertdetail`ln_cond_start within u_ja990g_t1
end type

type ln_tempright from utt_vertdetail`ln_tempright within u_ja990g_t1
end type

type ln_cond1_yline from utt_vertdetail`ln_cond1_yline within u_ja990g_t1
end type

type ln_dw1_yline from utt_vertdetail`ln_dw1_yline within u_ja990g_t1
end type

type ln_tempbutton from utt_vertdetail`ln_tempbutton within u_ja990g_t1
end type

type dw_pagelist from utt_vertdetail`dw_pagelist within u_ja990g_t1
string dataobject = "d_ja990g_t1a"
end type

event dw_pagelist::itemchanged;call super::itemchanged;LONG	lRowCount, lRow

CHOOSE CASE dwo.name
   CASE 'obj_id'
      lRowCount = dw_pageDetail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_pageDetail.object.obj_id [lRow] = data
      NEXT
END CHOOSE
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;POST SetColumn ('obj_id')

RETURN 0
end event

type dw_pagedetail from utt_vertdetail`dw_pagedetail within u_ja990g_t1
string dataobject = "d_ja990g_t1b"
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;retrieve (dw_pageList.object.obj_id [tRow] )
end event

event dw_pagedetail::ue_insertstart;call super::ue_insertstart;uf_SetColumn ('obj_id', dw_pageList.object.obj_id [tRow])

SetColumn ('tr_cd')

RETURN 0
end event

type st_move from utt_vertdetail`st_move within u_ja990g_t1
end type

