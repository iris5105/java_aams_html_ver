forward
global type w_ja035j from wt_list
end type
end forward

global type w_ja035j from wt_list
boolean eb_direct_retrieve = true
string is_date_nation = "US"
end type
global w_ja035j w_ja035j

on w_ja035j.create
int iCurrent
call super::create
end on

on w_ja035j.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035j
end type

type ln_templeft from wt_list`ln_templeft within w_ja035j
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035j
end type

type ln_temptop from wt_list`ln_temptop within w_ja035j
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035j
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035j
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035j
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035j
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035j
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035j
end type

type ln_tempright from wt_list`ln_tempright within w_ja035j
end type

type uo_navi from wt_list`uo_navi within w_ja035j
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035j
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035j
end type

type st_top_rect from wt_list`st_top_rect within w_ja035j
end type

type p_close from wt_list`p_close within w_ja035j
end type

type p_excel from wt_list`p_excel within w_ja035j
end type

type p_print from wt_list`p_print within w_ja035j
end type

type p_delete from wt_list`p_delete within w_ja035j
end type

type p_update from wt_list`p_update within w_ja035j
end type

type p_input from wt_list`p_input within w_ja035j
end type

type p_retrieve from wt_list`p_retrieve within w_ja035j
end type

type p_clear from wt_list`p_clear within w_ja035j
end type

type p_copy from wt_list`p_copy within w_ja035j
end type

type dw_c from wt_list`dw_c within w_ja035j
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] >= idt_workdate)
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    syt0ys t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.ymd     = :rs_ymd
  AND   ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035j
end type

type st_count from wt_list`st_count within w_ja035j
end type

type dw_list from wt_list`dw_list within w_ja035j
string dataobject = "d_ja035j"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow

DATETIME	ldt

STRING	ls_cur, ls_jm_cd

ls_cur = Object.currency [row]

CHOOSE CASE DWO.NAME
   CASE 'gyulje_gb'
      IF Object.tr_cd [row] = 'G33' Then
         RETURN uf_itemerr (ROW, 'gyulje_gb', '유상납입은 2913 해외 주식권리등록에서 납입후 상장처리 해야 합니다.')
      END IF
      IF data = 'N'  Then
         IF Object.jm_cd [row]<>Object.gyulje_jm_cd [row] THEN Object.gyulje_jm_cd [row] = null_s
      ELSE
         Object.gyulje_ymd [row] = dw_c.object.ymd [1]
         IF POS ('J51,K51',Object.tr_cd [row]) = 0 AND f_null (Object.gyulje_jm_cd [row]) Then
            SELECT jm_cd
              INTO :ls_jm_cd
              FROM SYM0YA t1
             WHERE t1.CORP_GR   = :gaa.CORP_GR
               AND t1.currency  = :ls_cur
               AND t1.gyulje_jm = 'Y'
               AND t1.jasan_gb  = '5' ;
            IF SQLCA.SQLCode()=0 AND data='Y' THEN Object.gyulje_jm_cd [row] = SQLCA.GETITEMSTRING (1)
         END IF
      END IF
   CASE 'gyulje_jm_cd'
      ldt = Object.gyulje_ymd [row]
      FOR  lRow = (ROW + 1)  TO  rowcount ()
         IF Object.gyulje_ymd [lRow]=ldt AND Object.currency [lRow]=ls_cur THEN Object.gyulje_jm_cd [lRow] = data
      NEXT
END CHOOSE
end event

