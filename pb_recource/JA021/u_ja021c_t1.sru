forward
global type u_ja021c_t1 from utt_listdetail
end type
end forward

global type u_ja021c_t1 from utt_listdetail
end type
global u_ja021c_t1 u_ja021c_t1

on u_ja021c_t1.create
call super::create
end on

on u_ja021c_t1.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja021c_t1
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja021c_t1
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja021c_t1
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja021c_t1
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja021c_t1
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja021c_t1
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja021c_t1
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja021c_t1
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja021c_t1
string dataobject = "d_ja021c_t1"
boolean eb_always_1_insert = true
boolean eb_copy_false = true
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'baed_mth', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'baej_mth', gaa.corp_gr, '', 1, "")
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;iu_wpage.tab_string [1] = Object.balh_co [currentrow]
RETURN 0
end event

event dw_pagelist::ue_protect;call super::ue_protect;IF Object.tr_ymd [row]>=iu_wpage.idt_workdate OR GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified! Then
   uf_protect (row, ia_protect [1])
Else
   uf_protect (row, ia_protect [2])
End IF
end event

event dw_pagelist::ue_deletestart;call super::ue_deletestart;IF Object.tr_ymd [tRow]<iu_wpage.idt_workdate  Then
   f_messageBox ('ERR', '중간배당일이 지난 자료는 삭제 할 수 없습니다.')
   RETURN 1
End IF
RETURN 0
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
IF f_notnull (Object.tr_ymd [row]) And f_notnull (Object.balh_co [row]) Then
	RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.tr_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
   gnv_rolemenu.of_setopensheet('00941')
End IF
end event

event dw_pagelist::itemfocuschanged;call super::itemfocuschanged;CHOOSE CASE DWO.NAME
   CASE 'baej_mth'
      IF Object.baed_mth [row]='1'  THEN
         F_DDDW_FILTER (THIS, 'baej_mth', "mid(cd,2,1)='0'")
      ELSE
         F_DDDW_FILTER (THIS, 'baej_mth', "mid(cd,2,1)<>'0'")
      END IF
END CHOOSE
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (iu_wpage.idt_workdate))
uf_setColumn ('tr_cd', 'G15')
uf_setColumn ('brok_ymd', string (iu_wpage.idt_workdate))

POST SetColumn ("balh_co")

RETURN 0
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

Object.cash_ilban_rt [row]  = Object.cash_ilban_per [row] / 100.
Object.cash_woos_rt [row]   = Object.cash_woos_per [row] / 100.
Object.stock_woos_rt [row]  = Object.stock_woos_per [row] / 100.
Object.stock_ilban_rt [row] = Object.stock_ilban_per [row] / 100.
end event

event dw_pagelist::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING   ls_balh_co, ls_baej_mth

CHOOSE CASE DWO.NAME
   CASE 'baed_mth'
      ls_balh_co = Object.balh_co [row]

		SELECT NVL(MAX('3'),'1')
		  INTO :ls_baej_mth
		  FROM SJM0JJ t1
		 WHERE t1.balh_co       = :ls_balh_co
			AND t1.woos_ilban_gb <> '0';
	
		ls_baej_mth = SQLCA.GETITEMSTRING (1)

      IF data='1' THEN Object.baej_mth [row] = ls_baej_mth + '0' ELSE Object.baej_mth [row] = ls_baej_mth + ls_baej_mth
      IF data='1' THEN
         SetItem (ROW, "stock_ilban_rt", null_dc)
         SetItem (ROW, "stock_woos_rt" , null_dc)
         SetItem (ROW, "stock_ilban_per", null_dc)
         SetItem (ROW, "stock_woos_per", null_dc)
      END IF

   CASE 'baej_mth'
      IF LeftA (data,1)='1'   THEN
         SetItem (ROW, "stock_woos_rt", null_dc)
         SetItem (ROW, "cash_woos_rt" , null_dc)
         SetItem (ROW, "stock_woos_per", null_dc)
         SetItem (ROW, "cash_woos_per", null_dc)

      ELSEIF LeftA (data,1)='2'  THEN
         SetItem (ROW, "stock_ilban_rt", null_dc)
         SetItem (ROW, "cash_ilban_rt" , null_dc)
         SetItem (ROW, "stock_ilban_per", null_dc)
         SetItem (ROW, "cash_ilban_per", null_dc)
      END IF

	CASE 'tr_ymd'
      IF Object.brok_ymd [row]>DATETIME (DATE (MID (data,1,10)))  THEN
         RETURN uf_itemerr (ROW, DWO.NAME, '중간배당일은 권리락일 이거나 이후여야 합니다.')
      END IF

   CASE 'brok_ymd'
      IF Object.tr_ymd [row]<DATETIME (DATE (MID (data,1,10))) THEN
         RETURN uf_itemerr (ROW, DWO.NAME, '중간배당일이 권리락일 이전 입니다.')
      END IF
END CHOOSE
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja021c_t1
string dataobject = "d_ja021c_t22"
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

type st_move from utt_listdetail`st_move within u_ja021c_t1
end type

