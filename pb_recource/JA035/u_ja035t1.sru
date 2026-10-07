forward
global type u_ja035t1 from utt_vertshare
end type
end forward

global type u_ja035t1 from utt_vertshare
string text = "외화파생(9)"
end type
global u_ja035t1 u_ja035t1

on u_ja035t1.create
call super::create
end on

on u_ja035t1.destroy
call super::destroy
end on

type ln_temptop from utt_vertshare`ln_temptop within u_ja035t1
end type

type ln_tempstart from utt_vertshare`ln_tempstart within u_ja035t1
end type

type ln_templeft from utt_vertshare`ln_templeft within u_ja035t1
end type

type ln_cond_start from utt_vertshare`ln_cond_start within u_ja035t1
end type

type ln_tempright from utt_vertshare`ln_tempright within u_ja035t1
end type

type ln_cond1_yline from utt_vertshare`ln_cond1_yline within u_ja035t1
end type

type ln_dw1_yline from utt_vertshare`ln_dw1_yline within u_ja035t1
end type

type ln_tempbutton from utt_vertshare`ln_tempbutton within u_ja035t1
end type

type dw_pagelist from utt_vertshare`dw_pagelist within u_ja035t1
string dataobject = "d_ja035t1a"
boolean hscrollbar = true
string setlist4fontpointcolor = "siga_agent=1=c;siga_agent=2=c;siga_agent=3=c"
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;uf_dddwctl ('balh_nation | nation_cd', dw_pageMaster, 'balh_nation', gaa.corp_gr, '', 1, "")
uf_dddwctl ('currency', dw_pageMaster, 'currency', gaa.corp_gr, '', 1, "")
uf_dddwctl ('jasan_attr', dw_pageMaster, 'jasan_attr', gaa.corp_gr, '', 1, "")
uf_dddwctl ('siga_agent', dw_pageMaster, 'siga_agent', gaa.corp_gr, '', 1, "")
uf_dddwctl ('change_currency | currency', dw_pageMaster, 'change_currency', gaa.corp_gr, '', 1, "")
uf_dddwctl ('fen0118', dw_pageMaster, 'fen0118', gaa.corp_gr, '', 1, "")
f_dddwctl (dw_pagemaster, 'stock_gb', gaa.corp_gr, '', 2, '')

uf_dddwctl ('sj_gb', dw_pageMaster, 'sj_gb', gaa.corp_gr, '', 1, "")
uf_dddwctl ('jasan', dw_pageMaster, 'jasan', gaa.corp_gr, '', 1, "sebu_num=2")
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setColumn ('seq_no', '1')
uf_setColumn ('jasan_gb', '9')
uf_setColumn ('sj_gubun', '1')
uf_setColumn ('js_jongryu', '1')
uf_setColumn ('siga_agent', 'B')
uf_setColumn ('unit_aek', '100')

dw_pagemaster.POST SetColumn ('jm_cd')

RETURN 0
end event

event dw_pagelist::ue_protect;call super::ue_protect;IF getitemstatus (row, 0, primary!)=new! or getitemstatus (row, 0, primary!)=newmodified! OR gaa.aams   Then
//   f_setprotect (THIS, FALSE, { 'balh_nation','jm_cd','jm_nm','currency' })
   f_setprotect (dw_pageMaster, FALSE, { 'balh_nation','jm_cd','jm_nm','currency' })
Else
//   f_setprotect (THIS, TRUE, { 'balh_nation','jm_cd','jm_nm','currency' })
   f_setprotect (dw_pageMaster, TRUE, { 'balh_nation','jm_cd','jm_nm','currency' })
End IF
end event

type dw_pagemaster from utt_vertshare`dw_pagemaster within u_ja035t1
string dataobject = "d_ja035t1b"
end type

event dw_pagemaster::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt_lsy_ymd, ldt_chk_ymd
STRING	ls_code

CHOOSE CASE DWO.NAME
   CASE 'jm_cd'
      IF POS (data,':') > 0   Then
         ls_code               = LEFT (data, POS (data, ':') - 1)
         Object.stock_gb [row] = ls_code

         SELECT SEBU_CD_EFNM
           INTO :ls_code
           FROM SZX0GR t1
          WHERE t1.gr_cd   = 'Q0'
            AND t1.sebu_cd = :ls_code ;
         IF SQLCA.SQLCode () = 0 Then
            ls_code                  = SQLCA.GETITEMSTRING (1)
            Object.balh_nation [row] = ls_code

            SELECT currency
              INTO :ls_code
              FROM SZX0WA t1
             WHERE t1.nation_cd = :ls_code ;
            IF SQLCA.sqlcode ()=0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
         END IF

         IF f_null (Object.sedol [row]) THEN Object.sedol [row] = MID (data, POS (data,':') + 1)
         IF f_null (Object.blbg_tckr [row])  THEN Object.blbg_tckr [row] = MID (data, POS (data,':') + 1)
      END IF
   CASE 'balh_nation'
      IF f_null (Object.currency [row])   Then
         SELECT currency
           INTO :ls_code
           FROM SZX0WA t1
          WHERE t1.nation_cd = :data ;
         IF SQLCA.sqlcode ()=0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
      END IF
   CASE 'currency'
      IF f_null (Object.balh_nation [row])   Then
         SELECT nation_cd
           INTO :ls_code
           FROM SZX0WA t1
          WHERE t1.currency = :data ;
         IF SQLCA.SQLCode ()=0 THEN Object.balh_nation [row] = SQLCA.GETITEMSTRING (1)
      END IF
   CASE 'sj_gb'
      CHOOSE CASE data
         CASE '0'
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row]  = null_dc
            Object.lsy_ymd [row]   = null_dt
         CASE '1'
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row]  = 100
         CASE '2', '3'
            Object.unit_aek [row] = 100
      END CHOOSE
   CASE 'lsy_ymd'
      ldt_lsy_ymd = DATETIME (DATE (MidA (data,1,10)))

      IF ldt_lsy_ymd < iu_wpage.idt_workdate Then
         RETURN uf_itemerr (ROW, 'lsy_ymd', '작업일전의 최종결제일은 입력할 수 없습니다.')
      END IF

      IF Object.sj_gb [row] = '1' AND PosA ('75,76', STRING (object.jasan [row])) = 0  Then
         IF PosA ('03,06,09,12',STRING (ldt_lsy_ymd,'mm')) = 0 Then
            RETURN uf_itemerr (ROW, 'lsy_ymd', '선물 최종결제월은 3,6,9,12월만 가능합니다.')
         END IF
      END IF

      CHOOSE CASE Object.jasan [row]
         CASE '75', '76'
             SELECT next_day(trunc(:ldt_lsy_ymd,'mm') - 1,'월') + 16 INTO :ldt_chk_ymd FROM DUAL;
            ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd <> ldt_chk_ymd Then
               F_MESSAGEBOX ('I001', '셋째주 수요일이 아닙니다.' + STRING (ldt_chk_ymd))
            END IF
         CASE '01' TO '79'
             SELECT next_day(trunc(:ldt_lsy_ymd,'mm'), '목') + 7 INTO :ldt_chk_ymd FROM DUAL;
            ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd <> ldt_chk_ymd Then
               F_MESSAGEBOX ('I001', '둘째주 목요일이 아닙니다.')
            END IF
         CASE 'XX', 'X1'
             SELECT next_day(trunc(:ldt_lsy_ymd,'mm') - 1,'수') + 14 INTO :ldt_chk_ymd FROM DUAL;
            ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd <> ldt_chk_ymd Then
               F_MESSAGEBOX ('I001', '셋째주 수요일이 아닙니다.')
            END IF
      END CHOOSE
END CHOOSE
end event

type st_move from utt_vertshare`st_move within u_ja035t1
boolean rightmaxsizefixed = true
end type

