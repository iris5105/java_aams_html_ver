forward
global type u_ja021h_t4 from utt_listdetail
end type
end forward

global type u_ja021h_t4 from utt_listdetail
end type
global u_ja021h_t4 u_ja021h_t4

on u_ja021h_t4.create
call super::create
end on

on u_ja021h_t4.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja021h_t4
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja021h_t4
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja021h_t4
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja021h_t4
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja021h_t4
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja021h_t4
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja021h_t4
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja021h_t4
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja021h_t4
string dataobject = "d_ja021h_t41"
boolean eb_always_1_insert = true
boolean eb_copy_false = true
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'fr_danc_gb', gaa.corp_gr, '', 2, "sebu_cd in (select danc_gb from szx0gd where tr_cd in ('G00','G51','G53'))")
F_DDDWCTL (THIS, 'to_danc_gb', gaa.corp_gr, '', 2, "sebu_cd in ('A','B','C','D','G')")
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string(iu_wpage.idt_workdate))
uf_setColumn ('tr_cd', 'G53')

POST SetColumn ("tr_ymd")

RETURN 0
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
         RETURN uf_itemerr (row, 'tr_ymd', '변경일자가 작업일보다 같거나 커야 합니다.')
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

event dw_pagelist::ue_deletestart;call super::ue_deletestart;IF Object.tr_ymd [tRow]<iu_wpage.idt_workdate  Then
   f_messageBox ('ERR', '변경일이 지난 자료는 삭제 할 수 없습니다.')
   RETURN 1
End IF
RETURN 0
end event

event dw_pagelist::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fr_koscom_cd'
      rs_Where = "balh_co='" + Object.balh_co [tRow] + "'"
END CHOOSE
RETURN 1
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
IF f_notnull (Object.tr_ymd [row]) And f_notnull (Object.balh_co [row]) Then
   RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.tr_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
   gnv_rolemenu.of_setopensheet('00941')
End IF
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja021h_t4
string dataobject = "d_ja021h_td"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;IF gaa.aams   Then
   IF dw_pagelist.object.tr_ymd [tRow]>iu_wpage.idt_workdate   Then
      retrieve ('%', dw_pagelist.object.xx_fr_jm_cd [tRow], string (iu_wpage.idt_workdate,'yyyymmdd'))
   Else
      retrieve ('%', dw_pagelist.object.xx_fr_jm_cd [tRow], string (dw_pagelist.object.tr_ymd [tRow],'yyyymmdd'))
   End IF
Else
   IF dw_pagelist.object.tr_ymd [tRow]>iu_wpage.idt_workdate   Then
      retrieve (gaa.corp_gr, dw_pagelist.object.xx_fr_jm_cd [tRow], string (iu_wpage.idt_workdate,'yyyymmdd'))
   Else
      retrieve (gaa.corp_gr, dw_pagelist.object.xx_fr_jm_cd [tRow], string (dw_pagelist.object.tr_ymd [tRow],'yyyymmdd'))
   End IF
End IF
end event

type st_move from utt_listdetail`st_move within u_ja021h_t4
end type

