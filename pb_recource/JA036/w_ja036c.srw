forward
global type w_ja036c from wt_list
end type
end forward

global type w_ja036c from wt_list
boolean eb_direct_retrieve = true
end type
global w_ja036c w_ja036c

on w_ja036c.create
int iCurrent
call super::create
end on

on w_ja036c.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja036c
end type

type ln_templeft from wt_list`ln_templeft within w_ja036c
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja036c
end type

type ln_temptop from wt_list`ln_temptop within w_ja036c
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja036c
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja036c
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja036c
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja036c
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja036c
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja036c
end type

type ln_tempright from wt_list`ln_tempright within w_ja036c
end type

type uo_navi from wt_list`uo_navi within w_ja036c
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja036c
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja036c
end type

type st_top_rect from wt_list`st_top_rect within w_ja036c
end type

type p_close from wt_list`p_close within w_ja036c
end type

type p_excel from wt_list`p_excel within w_ja036c
end type

type p_print from wt_list`p_print within w_ja036c
end type

type p_delete from wt_list`p_delete within w_ja036c
end type

type p_update from wt_list`p_update within w_ja036c
end type

type p_input from wt_list`p_input within w_ja036c
end type

type p_retrieve from wt_list`p_retrieve within w_ja036c
end type

type p_clear from wt_list`p_clear within w_ja036c
end type

type p_copy from wt_list`p_copy within w_ja036c
end type

type dw_c from wt_list`dw_c within w_ja036c
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] >= idt_workdate)
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    syt0ys t1
WHERE   t1.corp_gr    = :gaa.corp_gr
  AND   t1.ymd        = :rs_ymd
  AND   t1.tr_cd      = 'G33'
  AND   t1.gyulje_ymd = :rs_ymd
  AND   ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja036c
end type

type st_count from wt_list`st_count within w_ja036c
end type

type dw_list from wt_list`dw_list within w_ja036c
string dataobject = "d_ja036c"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_currency, ls_jm_cd

ls_currency = Object.currency [row]

CHOOSE CASE dwo.name
   CASE 'gyulje_gb'
      IF data='N' Then
         IF Object.jm_cd [row]<>Object.gyulje_jm_cd [row] THEN Object.gyulje_jm_cd [row] = null_s
      Else
         Object.gyulje_ymd [row] = dw_c.object.ymd [1]
         IF f_null (Object.gyulje_jm_cd [row])  Then
            SELECT  jm_cd
              INTO  :ls_jm_cd
            FROM    sym0ya t1
            WHERE   t1.corp_gr   = :gaa.corp_gr
              AND   t1.currency  = :ls_currency
              AND   t1.gyulje_jm = 'Y'
              AND   t1.jasan_gb  = '5';
				  
				ls_jm_cd = SQLCA.getitemstring (1)
				  
            IF (SQLCA.SQLCode()=0) And (data='Y') THEN Object.gyulje_jm_cd [row] = ls_jm_cd
         End IF
      End IF
END CHOOSE
end event

