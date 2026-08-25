forward
global type w_ja035q from wt_list
end type
end forward

global type w_ja035q from wt_list
string is_date_nation = "US"
boolean ib_managedata = false
end type
global w_ja035q w_ja035q

on w_ja035q.create
int iCurrent
call super::create
end on

on w_ja035q.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], idt_workdate)
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035q
end type

type ln_templeft from wt_list`ln_templeft within w_ja035q
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035q
end type

type ln_temptop from wt_list`ln_temptop within w_ja035q
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035q
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035q
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035q
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035q
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035q
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035q
end type

type ln_tempright from wt_list`ln_tempright within w_ja035q
end type

type uo_navi from wt_list`uo_navi within w_ja035q
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035q
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035q
end type

type st_top_rect from wt_list`st_top_rect within w_ja035q
end type

type p_close from wt_list`p_close within w_ja035q
end type

type p_excel from wt_list`p_excel within w_ja035q
end type

type p_print from wt_list`p_print within w_ja035q
end type

type p_delete from wt_list`p_delete within w_ja035q
end type

type p_update from wt_list`p_update within w_ja035q
end type

type p_input from wt_list`p_input within w_ja035q
end type

type p_retrieve from wt_list`p_retrieve within w_ja035q
end type

type p_clear from wt_list`p_clear within w_ja035q
end type

type p_copy from wt_list`p_copy within w_ja035q
end type

type dw_c from wt_list`dw_c within w_ja035q
string title = "처리일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0MC t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035q
end type

type st_count from wt_list`st_count within w_ja035q
end type

type dw_list from wt_list`dw_list within w_ja035q
string dataobject = "d_ja035q"
boolean eb_new_false = true
boolean eb_copy_false = true
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow

STRING	ls_fund, ls_trustee, ls_tr_cd

ls_fund    = Object.fund_cd [row]
ls_trustee = Object.trustee [row]
ls_tr_cd   = Object.tr_cd [row]

lRow = FIND ("fund_cd='" + ls_fund + "' and trustee='" + ls_trustee + "' and tr_cd='" + ls_tr_cd + "'", 1, ROW - 1)
CHOOSE CASE DWO.NAME
   CASE 'bfil_aek'
      IF lRow > 0 Then
         Object.dw_aek [lRow] = Object.dw_aek [lRow] + ((Object.bfil_aek [lRow] + Object.up_aek [lRow] - Object.dw_aek [lRow]) - dec (data))
      END IF
   CASE 'won_bfil_aek'
      IF lRow > 0 Then
         Object.won_dw_aek [lRow] = Object.won_dw_aek [lRow] + ((Object.won_bfil_aek [lRow] + Object.won_up_aek [lRow] - Object.won_dw_aek [lRow]) - dec (data))
      END IF
END CHOOSE
end event

