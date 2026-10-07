forward
global type u_ja021c_t2 from utt_list
end type
end forward

global type u_ja021c_t2 from utt_list
end type
global u_ja021c_t2 u_ja021c_t2

type variables

end variables

on u_ja021c_t2.create
call super::create
end on

on u_ja021c_t2.destroy
call super::destroy
end on

type ln_temptop from utt_list`ln_temptop within u_ja021c_t2
end type

type ln_tempstart from utt_list`ln_tempstart within u_ja021c_t2
end type

type ln_templeft from utt_list`ln_templeft within u_ja021c_t2
end type

type ln_cond_start from utt_list`ln_cond_start within u_ja021c_t2
end type

type ln_tempright from utt_list`ln_tempright within u_ja021c_t2
end type

type ln_cond1_yline from utt_list`ln_cond1_yline within u_ja021c_t2
end type

type ln_dw1_yline from utt_list`ln_dw1_yline within u_ja021c_t2
end type

type ln_tempbutton from utt_list`ln_tempbutton within u_ja021c_t2
end type

type dw_pagelist from utt_list`dw_pagelist within u_ja021c_t2
string dataobject = "d_ja021c_t1"
boolean eb_always_1_insert = true
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'baed_mth', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'baej_mth', gaa.corp_gr, '', 1, "")
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;iu_wpage.tab_string [1] = Object.balh_co [currentrow]
RETURN 0
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.tr_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
gnv_rolemenu.of_setopensheet('00941')
end event

event dw_pagelist::ue_protect;call super::ue_protect;IF Object.tr_ymd [row]>=iu_wpage.idt_workdate OR GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified! Then
   uf_protect (row, ia_protect [1], TRUE, FALSE, TRUE)
Else
   uf_protect (row, ia_protect [2], TRUE, FALSE, FALSE)
End IF
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('tr_ymd', string (iu_wpage.idt_workdate))
uf_setcolumn ('tr_cd', 'G15')
uf_setcolumn ('xx_corp_gr', gaa.corp_nm)

RETURN 0
end event

event dw_pagelist::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DEC   ldc_cash_ilban_rt, ldc_cash_woos_rt, ldc_stock_ilban_rt, ldc_stock_woos_rt, ldc_ilban_aek, ldc_woos_aek

DATETIME ldt, ldt_brok_ymd, ldt_baed_gisan_ymd

STRING   ls_baed_mth, ls_baej_mth

ldt = Object.tr_ymd [row]

CHOOSE CASE DWO.NAME
   CASE 'balh_co'
      SELECT baed_mth
           , baej_mth
           , cash_ilban_rt
           , cash_woos_rt
           , stock_ilban_rt
           , stock_woos_rt
           , brok_ymd
           , baed_gisan_ymd
           , ilban_aek
           , woos_aek
        INTO :ls_baed_mth
           , :ls_baej_mth
           , :ldc_cash_ilban_rt
           , :ldc_cash_woos_rt
           , :ldc_stock_ilban_rt
           , :ldc_stock_woos_rt
           , :ldt_brok_ymd
           , :ldt_baed_gisan_ymd
           , :ldc_ilban_aek
           , :ldc_woos_aek
        FROM (SELECT t1.*
                   , ROW_NUMBER( ) OVER (PARTITION BY TR_CD, BALH_CO, BAED_MTH, BAEJ_MTH
                                             ORDER BY CASE WHEN CORP_GR=:gaa.CORP_GR THEN 1
                                                           WHEN CORP_GR='%'          THEN 2
                                                                                     ELSE 3 END)  AS rnk
                FROM SJT0BK t1  /* 발행기관별 배당권리 내역 */
               WHERE t1.TR_CD   = 'G15'
                 AND t1.BALH_CO = :data
                 AND t1.TR_YMD  <= :ldt
                 AND t1.CORP_GR IN (:gaa.CORP_GR, '%')
           )
       WHERE rnk = 1;
      IF SQLCA.sqlcode ( )<>0  THEN
         RETURN uf_itemerr (ROW, 'balh_co', '앞에서 중간배당을 입력 후 운용사별 작업을 하십시오.')
      END IF
      ls_baed_mth        = SQLCA.GETITEMSTRING (1)
      ls_baej_mth        = SQLCA.GETITEMSTRING (2)
      ldc_cash_ilban_rt  = SQLCA.GETITEMNUMBER (3)
      ldc_cash_woos_rt   = SQLCA.GETITEMNUMBER (4)
      ldc_stock_ilban_rt = SQLCA.GETITEMNUMBER (5)
      ldc_stock_woos_rt  = SQLCA.GETITEMNUMBER (6)
      ldt_brok_ymd       = SQLCA.GETITEMDATETIME (7)
      ldt_baed_gisan_ymd = SQLCA.GETITEMDATETIME (8)
      ldc_ilban_aek      = SQLCA.GETITEMNUMBER (9)
      ldc_woos_aek       = SQLCA.GETITEMNUMBER (10)

      Object.baed_mth [row]        = ls_baed_mth
      Object.baej_mth [row]        = ls_baej_mth
      Object.cash_ilban_rt [row]   = ldc_cash_ilban_rt
      Object.cash_woos_rt [row]    = ldc_cash_woos_rt
      Object.stock_ilban_rt [row]  = ldc_stock_ilban_rt
      Object.stock_woos_rt [row]   = ldc_stock_woos_rt
      Object.brok_ymd [row]        = ldt_brok_ymd
      Object.baed_gisan_ymd [row]  = ldt_baed_gisan_ymd
      Object.ilban_aek [row]       = ldc_ilban_aek
      Object.woos_aek [row]        = ldc_woos_aek
      Object.cash_ilban_per [row]  = ldc_cash_ilban_rt * 100.
      Object.cash_woos_per [row]   = ldc_cash_woos_rt * 100.
      Object.stock_ilban_per [row] = ldc_stock_ilban_rt * 100.
      Object.stock_woos_per [row]  = ldc_stock_woos_rt * 100.

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

event dw_pagelist::itemchanged_next;call super::itemchanged_next;STRING	ls_balh_co

DEC	ldc_aekm

ls_balh_co = Object.balh_co [row]

IF name='ilban_aek' OR name='woos_aek' Then
   SELECT  aekm
     INTO  :ldc_aekm
   FROM    sjx0jb t1
   WHERE   balh_co = :ls_balh_co;
	ldc_aekm = SQLCA.getitemnumber (1)
   IF SQLCA.sqlcode ()=0   Then
      IF Object.baed_mth [row]<>'2' And ldc_aekm>0 Then
         IF PosA ('13',LEFT (Object.baej_mth [row],1))>0 Then
            SetItem (row, "cash_ilban_per", Object.ilban_aek [row] / ldc_aekm * 100.)
            SetItem (row, "cash_ilban_rt", Object.ilban_aek [row] / ldc_aekm)
         End IF
         IF PosA ('23',LEFT (Object.baej_mth [row],1))>0 Then
            SetItem (row, "cash_woos_per", Object.woos_aek [row] / ldc_aekm * 100.)
            SetItem (row, "cash_woos_rt", Object.woos_aek [row] / ldc_aekm)
         End IF
      End IF
   End IF
End IF

Object.cash_ilban_rt [row] = Object.cash_ilban_per [row] / 100.
Object.cash_woos_rt [row] = Object.cash_woos_per [row] / 100.
Object.stock_woos_rt [row] = Object.stock_woos_per [row] / 100.
Object.stock_ilban_rt [row] = Object.stock_ilban_per [row] / 100.
end event

event dw_pagelist::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE getcolumnname()
	CASE 'corp_gr'
		rs_where = "corp_gr = '" + gaa.corp_gr + "'"
END CHOOSE
RETURN 1
end event

