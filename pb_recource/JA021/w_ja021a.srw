forward
global type w_ja021a from wt_listdetail
end type
end forward

global type w_ja021a from wt_listdetail
integer ii_dddw_width2 = 800
string is_init_value = "G10"
end type
global w_ja021a w_ja021a

type variables
DateTime idt_gyul_ymd
end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
IF	gaa.aams	Then
	dw_c.object.dddw2 [1] = '%'
Else
	dw_c.object.dddw2 [1] = gaa.corp_gr
End IF
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (dw_c.object.dddw2 [1], dw_c.object.ymd [1], ia_value [1], idt_workdate)
end event

on w_ja021a.create
int iCurrent
call super::create
end on

on w_ja021a.destroy
call super::destroy
end on

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja021a
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja021a
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja021a
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja021a
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja021a
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja021a
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja021a
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja021a
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja021a
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja021a
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja021a
end type

type uo_navi from wt_listdetail`uo_navi within w_ja021a
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja021a
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja021a
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja021a
end type

type p_close from wt_listdetail`p_close within w_ja021a
end type

type p_excel from wt_listdetail`p_excel within w_ja021a
end type

type p_print from wt_listdetail`p_print within w_ja021a
end type

type p_delete from wt_listdetail`p_delete within w_ja021a
end type

type p_update from wt_listdetail`p_update within w_ja021a
end type

type p_input from wt_listdetail`p_input within w_ja021a
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja021a
end type

type p_clear from wt_listdetail`p_clear within w_ja021a
end type

type p_copy from wt_listdetail`p_copy within w_ja021a
end type

type dw_c from wt_listdetail`dw_c within w_ja021a
string tag = "예상배당 기준변경에 따라 일괄생성 없이 등록처리"
string title = "공시적용일@거래코드@배당적용대상"
string dataobject = "dc_ymd_dddw2"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt
STRING	ls_ret

CHOOSE CASE DWO.NAME
   CASE 'ymd'
      ldt = DATETIME (DATE (MidA (data,1,10)))

      SELECT F_STOCK(:ldt) INTO :ls_ret FROM DUAL;
      IF SQLCA.GETITEMSTRING (1) = '1' Then
         RETURN uf_itemerror ('ymd', '휴장일을 입력하셨습니다.')
      END IF
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA021A'")
F_DDDWCTL (THIS, 'dddw2 | dual', gaa.corp_gr, '%,전운용사적용,,' + gaa.corp_gr + ',' + gaa.corp_nm + ',', 1, '')
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SJT0BK t1
 WHERE t1.CORP_GR IN ('%', :gaa.CORP_GR)
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   = 'G10'
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1]>=idt_workdate OR gaa.aams)
RETURN TRUE
end event

type btn_update from wt_listdetail`btn_update within w_ja021a
end type

type st_count from wt_listdetail`st_count within w_ja021a
end type

type dw_list from wt_listdetail`dw_list within w_ja021a
string dataobject = "d_ja021a1"
boolean eb_null_line = false
end type

event dw_list::itemfocuschanged;call super::itemfocuschanged;CHOOSE CASE DWO.NAME
   CASE 'baej_mth'
      IF Object.baed_mth [row] = '1'   Then
         f_dddw_filter (THIS, 'baej_mth', "mid(cd,2,1)='0'")
      ELSE
         f_dddw_filter (THIS, 'baej_mth', "mid(cd,2,1)<>'0'")
      END IF
END CHOOSE
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'baed_mth', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'baej_mth', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('corp_gr', dw_c.object.dddw2 [1])
uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('brok_ymd', string (dw_c.object.ymd [1]))

POST SetColumn ("balh_co")

RETURN 0
end event

event dw_list::itemchanged_next;call super::itemchanged_next;STRING	ls_balh_co

DEC	ldc_aekm

ls_balh_co = Object.balh_co [row]

IF NAME = 'ilban_aek' OR NAME = 'woos_aek'   Then
   SELECT aekm
     INTO :ldc_aekm
     FROM SJX0JB t1
    WHERE balh_co = :ls_balh_co ;
   IF SQLCA.sqlcode () = 0 Then
      ldc_aekm = SQLCA.GETITEMNUMBER (1)
      IF NOT (f_nvl (Object.baed_mth [row],'2') = '2' OR isNull (Object.baej_mth [row])) AND ldc_aekm > 0   Then
         IF POS ('13',LEFT (Object.baej_mth [row],1))>0 THEN SetItem (ROW, "cash_ilban_per", Object.ilban_aek [row] / ldc_aekm * 100.)
         IF POS ('23',LEFT (Object.baej_mth [row],1))>0 THEN SetItem (ROW, "cash_woos_per", Object.woos_aek [row] / ldc_aekm * 100.)
      END IF
   END IF
END IF

Object.cash_ilban_rt [row]  = Object.cash_ilban_per [row] / 100.
Object.cash_woos_rt [row]   = Object.cash_woos_per [row] / 100.
Object.stock_ilban_rt [row] = Object.stock_ilban_per [row] / 100.
Object.stock_woos_rt [row]  = Object.stock_woos_per [row] / 100.
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_balh_co, ls_baej_mth

CHOOSE CASE DWO.NAME
   CASE 'baed_mth'
      ls_balh_co = Object.balh_co [row]

      SELECT NVL(MAX('3'), '1')
        INTO :ls_baej_mth
        FROM SJM0JJ t1
       WHERE t1.balh_co       = :ls_balh_co
         AND t1.woos_ilban_gb <> '0' ;

      ls_baej_mth = SQLCA.GETITEMSTRING (1)

      IF data='1' THEN Object.baej_mth [row] = ls_baej_mth + '0' ELSE Object.baej_mth [row] = ls_baej_mth + ls_baej_mth
      IF data = '1'  Then
         SetItem (ROW, "stock_ilban_rt", null_dc)
         SetItem (ROW, "stock_woos_rt", null_dc)
         SetItem (ROW, "stock_ilban_per", null_dc)
         SetItem (ROW, "stock_woos_per", null_dc)
      END IF

   CASE 'baej_mth'
      IF LEFT (data,1) = '1'  Then
         SetItem (ROW, "stock_woos_rt", null_dc)
         SetItem (ROW, "cash_woos_rt", null_dc)
         SetItem (ROW, "stock_woos_per", null_dc)
         SetItem (ROW, "cash_woos_per", null_dc)

      ELSEIF LEFT (data,1) = '2' Then
         SetItem (ROW, "stock_ilban_rt", null_dc)
         SetItem (ROW, "cash_ilban_rt", null_dc)
         SetItem (ROW, "stock_ilban_per", null_dc)
         SetItem (ROW, "cash_ilban_per", null_dc)
      END IF
END CHOOSE
end event

type dw_detail from wt_listdetail`dw_detail within w_ja021a
string dataobject = "d_ja021a2"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_c.object.dddw2 [1], dw_c.object.ymd [1], dw_c.object.dddw [1], dw_list.object.balh_co [iRow], idt_workdate)
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'jj_cd'
      rs_where = "balh_co = '" + dw_list.object.balh_co [iRow] + "' and woos_ilban_gb != '0'"
END CHOOSE

RETURN 1
end event

event dw_detail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_balh_co

DEC	ld_aekm

CHOOSE CASE DWO.NAME
   CASE 'baed_aek'
      ls_balh_co = dw_list.object.balh_co [iRow]

      SELECT aekm
        INTO :ld_aekm
        FROM SJX0JB t1
       WHERE balh_co = :ls_balh_co ;
      ld_aekm = SQLCA.GETITEMNUMBER (1)
      IF SQLCA.sqlcode () = 0 Then
         IF ld_aekm = 0 Then
            SetItem (ROW, 'cash_rt', null_dc)
            SetItem (ROW, 'stock_rt', null_dc)
            SetItem (ROW, 'cash_per', null_dc)
            SetItem (ROW, 'stock_per', null_dc)
         ELSE
            SetItem (ROW, 'cash_per', dec (data) / ld_aekm * 100.)
            SetItem (ROW, 'cash_rt', dec (data) / ld_aekm)
         END IF
      END IF

   CASE 'cash_per'
      SetItem (ROW, 'cash_rt', dec (data) / 100.)
   CASE 'stock_per'
      SetItem (ROW, 'stock_rt', dec (data) / 100.)
END CHOOSE
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('corp_gr', dw_c.object.dddw2 [1])
uf_setColumn ('ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('balh_co', dw_list.object.balh_co [iRow])

POST SetColumn ("jj_cd")

RETURN 0
end event

type st_move from wt_listdetail`st_move within w_ja021a
end type

