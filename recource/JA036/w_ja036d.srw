forward
global type w_ja036d from wt_list
end type
end forward

global type w_ja036d from wt_list
end type
global w_ja036d w_ja036d

on w_ja036d.create
int iCurrent
call super::create
end on

on w_ja036d.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja036d
end type

type ln_templeft from wt_list`ln_templeft within w_ja036d
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja036d
end type

type ln_temptop from wt_list`ln_temptop within w_ja036d
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja036d
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja036d
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja036d
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja036d
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja036d
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja036d
end type

type ln_tempright from wt_list`ln_tempright within w_ja036d
end type

type uo_navi from wt_list`uo_navi within w_ja036d
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja036d
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja036d
end type

type st_top_rect from wt_list`st_top_rect within w_ja036d
end type

type p_close from wt_list`p_close within w_ja036d
end type

type p_excel from wt_list`p_excel within w_ja036d
end type

type p_print from wt_list`p_print within w_ja036d
end type

type p_delete from wt_list`p_delete within w_ja036d
end type

type p_update from wt_list`p_update within w_ja036d
end type

type p_input from wt_list`p_input within w_ja036d
end type

type p_retrieve from wt_list`p_retrieve within w_ja036d
end type

type p_clear from wt_list`p_clear within w_ja036d
end type

type p_copy from wt_list`p_copy within w_ja036d
end type

type dw_c from wt_list`dw_c within w_ja036d
string tag = "(결산일자)"
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0TAX t1
 WHERE t1.CORP_GR     = :gaa.CORP_GR
   AND t1.request_ymd = :rs_ymd
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja036d
end type

type st_count from wt_list`st_count within w_ja036d
end type

type dw_list from wt_list`dw_list within w_ja036d
string dataobject = "d_ja036d"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'chk'
      IF data='1' Then
         Object.return_ymd [row] = idt_workdate
         Object.return_aek [row] = Object.request_aek [row]
      Else
         Object.return_ymd [row] = null_dt
         Object.return_aek [row] = null_dc
      End IF
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

