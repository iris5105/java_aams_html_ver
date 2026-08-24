forward
global type w_ja035g from wt_list
end type
end forward

global type w_ja035g from wt_list
boolean eb_direct_retrieve = true
string is_date_nation = "US"
end type
global w_ja035g w_ja035g

on w_ja035g.create
int iCurrent
call super::create
end on

on w_ja035g.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035g
end type

type ln_templeft from wt_list`ln_templeft within w_ja035g
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035g
end type

type ln_temptop from wt_list`ln_temptop within w_ja035g
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035g
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035g
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035g
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035g
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035g
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035g
end type

type ln_tempright from wt_list`ln_tempright within w_ja035g
end type

type uo_navi from wt_list`uo_navi within w_ja035g
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035g
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035g
end type

type st_top_rect from wt_list`st_top_rect within w_ja035g
end type

type p_close from wt_list`p_close within w_ja035g
end type

type p_excel from wt_list`p_excel within w_ja035g
end type

type p_print from wt_list`p_print within w_ja035g
end type

type p_delete from wt_list`p_delete within w_ja035g
end type

type p_update from wt_list`p_update within w_ja035g
end type

type p_input from wt_list`p_input within w_ja035g
end type

type p_retrieve from wt_list`p_retrieve within w_ja035g
end type

type p_clear from wt_list`p_clear within w_ja035g
end type

type p_copy from wt_list`p_copy within w_ja035g
end type

type dw_c from wt_list`dw_c within w_ja035g
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (object.ymd [1]>=idt_workdate OR gaa.aams)
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    syt0yg_pyunga t1
      , syt0yg yg
WHERE   t1.corp_gr     = :gaa.corp_gr
  AND   t1.ymd         = :rs_ymd
  AND   yg.corp_gr     = t1.corp_gr
  AND   yg.tr_cd       not in ('G12','G17')
  AND   yg.pyunga_join = t1.pyunga_join
  AND   ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035g
end type

type st_count from wt_list`st_count within w_ja035g
end type

type dw_list from wt_list`dw_list within w_ja035g
string dataobject = "d_ja035g"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'chk'
      IF data='1' Then
         Object.churi_ymd [row] = dw_c.object.ymd [1]
         Object.churi_jusu [row] = Object.jusu [row]
      Else
         Object.churi_ymd [row] = null_dt
         Object.churi_jusu [row] = null_dc
      End IF
END CHOOSE
end event

event dw_list::updateend;call super::updateend;LONG	ll

STRING	ls_pyunga_join

FOR  ll = rowcount ()  TO  1  STEP -1
   IF GETITEMSTATUS (ll, 0, PRIMARY!) = DATAMODIFIED! Then
      ls_pyunga_join = Object.pyunga_join [ll]
      IF f_null (Object.churi_ymd [ll])   Then
         UPDATE SYT0YG
            SET churi_ymd = NULL
          WHERE CORP_GR     = :gaa.CORP_GR
            AND pyunga_join = :ls_pyunga_join ;
      ELSE
         UPDATE SYT0YG
            SET churi_ymd = :idt_workdate
          WHERE CORP_GR     = :gaa.CORP_GR
            AND pyunga_join = :ls_pyunga_join ;
      END IF
   END IF
NEXT
end event

