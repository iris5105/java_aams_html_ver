forward
global type w_ja010d from wt_list
end type
end forward

global type w_ja010d from wt_list
end type
global w_ja010d w_ja010d

type variables

end variables

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

on w_ja010d.create
int iCurrent
call super::create
end on

on w_ja010d.destroy
call super::destroy
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event wue_update;call super::wue_update;IF AncestorReturnVALUE=1   Then
   IF dw_c.object.ymd [1]<idt_workdate And dw_c.object.ymd [1]>=uf_initdate ('inputdate') Then
      DateTime ldt

      ldt = dw_c.object.ymd [1]

      UPDATE szx0aa
         SET GIJUNGA_YMD = :ldt
      WHERE  corp_gr = :gaa.corp_gr;
   End IF
End IF
RETURN AncestorReturnVALUE
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja010d
end type

type ln_templeft from wt_list`ln_templeft within w_ja010d
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja010d
end type

type ln_temptop from wt_list`ln_temptop within w_ja010d
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja010d
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja010d
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja010d
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja010d
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja010d
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja010d
end type

type ln_tempright from wt_list`ln_tempright within w_ja010d
end type

type uo_navi from wt_list`uo_navi within w_ja010d
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja010d
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja010d
end type

type st_top_rect from wt_list`st_top_rect within w_ja010d
end type

type p_close from wt_list`p_close within w_ja010d
end type

type p_excel from wt_list`p_excel within w_ja010d
end type

type p_print from wt_list`p_print within w_ja010d
end type

type p_delete from wt_list`p_delete within w_ja010d
end type

type p_update from wt_list`p_update within w_ja010d
end type

type p_input from wt_list`p_input within w_ja010d
end type

type p_retrieve from wt_list`p_retrieve within w_ja010d
end type

type p_clear from wt_list`p_clear within w_ja010d
end type

type p_copy from wt_list`p_copy within w_ja010d
end type

type dw_c from wt_list`dw_c within w_ja010d
string tag = "7영업일전 입.출금은 등록을 의뢰 하십시오."
string title = "입.출금일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_getdate;call super::ue_getdate;INT  li = 0

SELECT 1
  INTO :li
  FROM SZT0IO t1
 WHERE CORP_GR = :gaa.CORP_GR
   AND tr_ymd  = :rs_ymd
   AND ROWNUM = 1 ;

li = SQLCA.GETITEMNUMBER (1)

RETURN li
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1]>=uf_initdate ('inputdate') or gaa.admin)
RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja010d
end type

type st_count from wt_list`st_count within w_ja010d
end type

type dw_list from wt_list`dw_list within w_ja010d
string dataobject = "d_ja010d1"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string(dw_c.object.ymd [1]))

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'fund_cd'
      rs_where = "haeji_ymd is null"
END CHOOSE
RETURN 1 // 순번
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

STRING	ls_fund_cd
DATETIME	ldt

LONG	ll, lRC

CHOOSE CASE DWO.NAME
   CASE 'fund_cd'
      lRC = ROWCOUNT ()
      FOR ll = 1  TO  lRC
         IF Object.fund_cd [ll] = data AND ll <> ROW  Then
            RETURN uf_itemerr (ROW, DWO.NAME, '이미 거래가 입력된 고객입니다.~r~n(입금과 출금을 동시에 입력하시면 됩니다.')
         END IF
      NEXT
   CASE 'in_aek'
      ls_fund_cd = Object.fund_cd [row]

      SELECT fst_seolj_ymd
        INTO :ldt
        FROM SZM0IA t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.fund_cd = :ls_fund_cd ;

      IF SQLCA.getitemdatetime (1) = dw_c.object.ymd [1] Then
         RETURN uf_itemerr (ROW, DWO.NAME, '신규설정금액은 계좌정보(#1011) 등록시 계좌잔액에 입력하십시오.')
      END IF
END CHOOSE
end event

