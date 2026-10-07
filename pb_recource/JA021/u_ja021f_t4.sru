forward
global type u_ja021f_t4 from utt_listdetail
end type
end forward

global type u_ja021f_t4 from utt_listdetail
end type
global u_ja021f_t4 u_ja021f_t4

on u_ja021f_t4.create
call super::create
end on

on u_ja021f_t4.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja021f_t4
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja021f_t4
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja021f_t4
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja021f_t4
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja021f_t4
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja021f_t4
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja021f_t4
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja021f_t4
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja021f_t4
string dataobject = "d_ja021f_t41"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'jeungj_mth', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'baej_mth', gaa.corp_gr, '', 1, "substr(sebu_cd,2,1)<>'0'")
end event

event dw_pagelist::ue_protect;call super::ue_protect;IF Object.tr_ymd [row]>=iu_wpage.idt_workdate OR GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified! Then
   uf_protect (row, ia_protect [1])
Else
   uf_protect (row, ia_protect [2])
End IF
end event

event dw_pagelist::itemchanged;call super::itemchanged;STRING	ls_f_value

DATETIME	ldt_f_param1

IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE "tr_ymd"
      IF datetime (date (MidA (data,1,10)))<iu_wpage.idt_workdate Then
         RETURN uf_itemerr (row, 'tr_ymd', '공시적용일이 작업일보다 같거나 커야 합니다.')
      End IF
		
		ldt_f_param1 = datetime(date(MidA(data,1,10)))

		SELECT F_STOCK( :ldt_f_param1 )
		  INTO :ls_f_value
		FROM   DUAL;
		ls_f_value = SQLCA.getitemstring (1)
		
      IF ls_f_value='1'   Then
         RETURN uf_itemerr (row, 'tr_ymd', '휴장일을 입력하셨습니다.')
      End IF
END CHOOSE
end event

event dw_pagelist::retrieverow;call super::retrieverow;IF f_null (Object.tr_ymd [row]) Then
   Object.tr_cd [row] = 'G36'
   Object.balh_co [row] = Object.jk_balh_co [row]
   Object.jeungj_mth [row] = Object.jk_jeungj_mth [row]
   Object.baej_mth [row] = Object.jk_baej_mth [row]
   Object.balh_ga [row] = Object.jk_balh_ga [row]
   Object.jekyng_rt [row] = Object.jk_jekyng_rt [row]
   Object.woos_jekyng_rt [row] = Object.jk_woos_jekyng_rt [row]
   Object.baed_gisan_ymd [row] = Object.jk_baed_gisan_ymd [row]
   Object.cheng_ymd [row] = Object.jk_cheng_ymd [row]
   Object.krak_ymd [row] = Object.jk_krak_ymd [row]
   Object.baej_gijun_ymd [row] = Object.jk_baej_gijun_ymd [row]
   Object.jukm_nabib_ymd [row] = Object.jk_jukm_nabib_ymd [row]
   Object.sinj_jaew [row] = Object.jk_sinj_jaew [row]
   Object.ilban_balh_jusu [row] = Object.jk_ilban_balh_jusu [row]
   Object.woos_balh_jusu [row] = Object.jk_woos_balh_jusu [row]
   SetItemStatus (row, 0, Primary!, New!)
   SetItemStatus (row, 0, Primary!, NotModified!)
End IF
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
IF f_notnull (Object.tr_ymd [row]) And f_notnull (Object.balh_co [row]) Then
   RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.tr_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
   gnv_rolemenu.of_setopensheet('00941')
End IF
end event

event dw_pagelist::itemchanged_next;call super::itemchanged_next;STRING	ls_balh_co, ls_baej_mth

IF name='balh_co' Then
   SELECT  '33'
     INTO  :ls_baej_mth
   FROM    sjm0jj t1
   WHERE   t1.balh_co       = :ls_balh_co
     AND   t1.woos_ilban_gb != '0';
	  ls_baej_mth = SQLCA.getitemstring (1)
	
   IF SQLCA.sqlcode ()=100 THEN ls_baej_mth = '11'

   Object.baej_mth [row] = ls_baej_mth
End IF

IF Object.baej_mth [row]<>'33'   Then
   Object.woos_balh_ga [row] = null_dc
   Object.woos_jekyng_rt [row] = null_dc
   Object.woos_balh_jusu [row] = null_dc
End IF
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja021f_t4
string dataobject = "d_ja021f_t42"
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;IF gaa.aams   Then
   retrieve ('%', dw_pagelist.object.tr_ymd [tRow], dw_pagelist.object.balh_co [tRow], dw_pagelist.object.jeungj_mth [tRow])
Else
   retrieve (gaa.corp_gr, dw_pagelist.object.tr_ymd [tRow], dw_pagelist.object.balh_co [tRow], dw_pagelist.object.jeungj_mth [tRow])
End IF
end event

type st_move from utt_listdetail`st_move within u_ja021f_t4
end type

