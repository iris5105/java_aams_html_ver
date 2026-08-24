forward
global type u_ja990d_t2 from utt_listdetail
end type
end forward

global type u_ja990d_t2 from utt_listdetail
string text = "신주인수권"
end type
global u_ja990d_t2 u_ja990d_t2

on u_ja990d_t2.create
call super::create
end on

on u_ja990d_t2.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja990d_t2
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja990d_t2
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja990d_t2
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja990d_t2
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja990d_t2
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja990d_t2
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja990d_t2
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja990d_t2
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja990d_t2
string dataobject = "d_ja990d_t2"
end type

event dw_pagelist::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

STRING	aJm_cd [], sJm_cd

CHOOSE CASE DWO.NAME
   CASE 'jm_cd'
      SELECT jm_cd
        INTO :sJm_cd
        FROM SJM0JJ t1
       WHERE t1.jm_cd = :data ;

      IF SQLCA.sqlcode () = 0 Then
         RETURN uf_itemerr (ROW, STRING (DWO.NAME), '이미 등록된 종목 입니다.')
      END IF

   CASE 'balh_co', 'woos_ilban_gb', 'chg_gb', 'new_old_gb'
      aJm_cd [1] = object.xx_balh_nation [row]
      aJm_cd [2] = 'A'
      IF DWO.NAME = 'balh_co' Then
         aJm_cd [3] = data
         IF f_null (Object.jj_fnm [row]) THEN Object.jj_fnm [row] = Object.xx_balh_co [row]
         IF f_null (Object.jj_nm [row]) THEN Object.jj_nm [row] = Object.xx_balh_co [row]
      ELSE
         aJm_cd [3] = Object.balh_co [row]
      END IF
      IF DWO.NAME = 'woos_ilban_gb' Then
         aJm_cd [4] = data
      ELSE
         aJm_cd [4] = Object.woos_ilban_gb [row]
      END IF
      IF DWO.NAME = 'chg_gb'  Then
         aJm_cd [5] = data
      ELSE
         aJm_cd [5] = Object.chg_gb [row]
      END IF
      IF DWO.NAME = 'new_old_gb' Then
         aJm_cd [6] = data
      ELSE
         aJm_cd [6] = Object.new_old_gb [row]
      END IF
      sJm_cd = aJm_cd [1] + aJm_cd [2] + aJm_cd [3] + aJm_cd [4] + aJm_cd [5] + aJm_cd [6]
      SetItem (ROW, "jm_cd", f_jm_check (sJm_cd))
END CHOOSE

IF GETITEMSTATUS (ROW, 0, PRIMARY!)=NEW! OR GETITEMSTATUS (ROW, 0, PRIMARY!)=NEWMODIFIED! THEN RETURN

ll = dw_pageDetail.insertrow (0)

dw_pageDetail.object.jm_cd [ll]      = Object.jm_cd [row]
dw_pageDetail.object.chg_column [ll] = STRING (DWO.NAME)
dw_pageDetail.object.ymd [ll]        = f_sysdate ('')
dw_pageDetail.object.bf_data [ll]    = STRING (DWO.primary [row])
dw_pageDetail.object.af_data [ll]    = data
dw_pagedetail.object.upd_user [ll]   = gnv_vari.is_user_id
end event

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'woos_ilban_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'chg_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'new_old_gb', gaa.corp_gr, '', 1, '')
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setColumn ('danc_gb', 'X')
uf_setColumn ('woos_ilban_gb', '0')
uf_setColumn ('chg_gb', '0')
uf_setColumn ('chg_rt', '1')
uf_setColumn ('new_old_gb', '0')
uf_setColumn ('kweonri_ymd', string (iu_wpage.idt_workdate))
uf_setColumn ('under', 'N')

SetColumn ('balh_co')

RETURN 0
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja990d_t2
string dataobject = "d_ja990d_t1c"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;retrieve (dw_pageList.object.jm_cd [tRow])
end event

event dw_pagedetail::oue_postopen;call super::oue_postopen;eb_delete_false = NOT (gaa.admin OR gaa.aams)
end event

type st_move from utt_listdetail`st_move within u_ja990d_t2
end type

