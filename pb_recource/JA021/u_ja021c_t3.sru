forward
global type u_ja021c_t3 from utt_listdetail
end type
end forward

global type u_ja021c_t3 from utt_listdetail
end type
global u_ja021c_t3 u_ja021c_t3

type variables

end variables

on u_ja021c_t3.create
call super::create
end on

on u_ja021c_t3.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja021c_t3
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja021c_t3
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja021c_t3
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja021c_t3
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja021c_t3
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja021c_t3
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja021c_t3
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja021c_t3
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja021c_t3
string dataobject = "d_ja021c_t31"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'baed_mth', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'baej_mth', gaa.corp_gr, '', 1, "")
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;iu_wpage.tab_string [1] = Object.balh_co [currentrow]
RETURN 0
end event

event dw_pagelist::retrieverow;call super::retrieverow;IF F_NULL (Object.tr_cd [row]) And Object.bk_tr_ymd [row]>=iu_wpage.idt_workdate  THEN
   Object.CORP_GR [row]  = gaa.corp_gr
   Object.balh_co [row]  = Object.bk_balh_co [row]
   Object.tr_cd [row]    = 'G23'
   Object.baed_mth [row] = Object.bk_baed_mth [row]
   Object.baej_mth [row] = Object.bk_baej_mth [row]
   Object.brok_ymd [row] = Object.bk_brok_ymd [row]
   SetItemStatus (ROW, 0, PRIMARY!, NEW!)
   SetItemStatus (ROW, 0, PRIMARY!, NotModified!)
END IF
end event

event dw_pagelist::ue_protect;call super::ue_protect;IF Object.tr_ymd [row]>=iu_wpage.idt_workdate OR GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified! Then
   uf_protect (row, ia_protect [1])
Else
   uf_protect (row, ia_protect [2])
End IF
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.bk_brok_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
gnv_rolemenu.of_setopensheet('00941')
end event

event dw_pagelist::itemchanged_next;call super::itemchanged_next;DEC   ldc_aekm

STRING   ls_balh_co

ls_balh_co = Object.balh_co [row]

IF NAME='ilban_aek' OR NAME='woos_aek' THEN
   SELECT aekm
     INTO :ldc_aekm
     FROM SJX0JB t1
    WHERE balh_co = :ls_balh_co;
   ldc_aekm = SQLCA.GETITEMNUMBER (1)

   IF SQLCA.sqlcode ( )=0   THEN
      IF NOT (F_NVL (Object.baed_mth [row],'2')='2' OR isNull (Object.baej_mth [row])) AND ldc_aekm>0 THEN
         IF PosA ('13',LEFT (Object.baej_mth [row],1))>0 THEN
            SetItem (ROW, "cash_ilban_per", Object.ilban_aek [row] / ldc_aekm * 100.)
            SetItem (ROW, "cash_ilban_rt", Object.ilban_aek [row] / ldc_aekm)
         END IF
         IF PosA ('23',LEFT (Object.baej_mth [row],1))>0 THEN
            SetItem (ROW, "cash_woos_per", Object.woos_aek [row] / ldc_aekm * 100.)
            SetItem (ROW, "cash_woos_rt", Object.woos_aek [row] / ldc_aekm)
         END IF
      END IF
   END IF
END IF

Object.cash_ilban_rt [row] = Object.cash_ilban_per [row] / 100.
Object.cash_woos_rt [row]  = Object.cash_woos_per [row] / 100.
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja021c_t3
string dataobject = "d_ja021c_t32"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;IF	gaa.aams	Then
	retrieve ('%', dw_pagelist.object.tr_ymd [tRow], dw_pagelist.object.balh_co [tRow])
Else
	retrieve (gaa.corp_gr, dw_pagelist.object.tr_ymd [tRow], dw_pagelist.object.balh_co [tRow])
End IF
end event

type st_move from utt_listdetail`st_move within u_ja021c_t3
end type

