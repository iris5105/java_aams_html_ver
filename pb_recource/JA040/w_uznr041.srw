forward
global type w_uznr041 from wt_vertole
end type
end forward

global type w_uznr041 from wt_vertole
boolean eb_direct_retrieve = true
end type
global w_uznr041 w_uznr041

type variables

end variables

on w_uznr041.create
int iCurrent
call super::create
end on

on w_uznr041.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;STRING	ls_select

is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = f_gijunga_ymd ('')
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_uznr041
end type

type ln_templeft from wt_vertole`ln_templeft within w_uznr041
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_uznr041
end type

type ln_temptop from wt_vertole`ln_temptop within w_uznr041
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_uznr041
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_uznr041
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_uznr041
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_uznr041
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_uznr041
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_uznr041
end type

type ln_tempright from wt_vertole`ln_tempright within w_uznr041
end type

type uo_navi from wt_vertole`uo_navi within w_uznr041
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_uznr041
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_uznr041
end type

type p_close from wt_vertole`p_close within w_uznr041
end type

type p_excel from wt_vertole`p_excel within w_uznr041
end type

type p_print from wt_vertole`p_print within w_uznr041
end type

type p_delete from wt_vertole`p_delete within w_uznr041
end type

type p_update from wt_vertole`p_update within w_uznr041
end type

type p_input from wt_vertole`p_input within w_uznr041
end type

type p_retrieve from wt_vertole`p_retrieve within w_uznr041
end type

type p_clear from wt_vertole`p_clear within w_uznr041
end type

type p_copy from wt_vertole`p_copy within w_uznr041
end type

type dw_c from wt_vertole`dw_c within w_uznr041
string title = "기준일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_getdate;INT   li_rtn

SELECT sign(count(*))
  INTO :li_rtn
FROM   aams.skt0bu_mc t1
WHERE  corp_gr = :gaa.corp_gr
  AND  tr_ymd  = :rs_ymd;

li_rtn = SQLCA.getitemnumber (1)

RETURN li_rtn
end event

type btn_update from wt_vertole`btn_update within w_uznr041
end type

type st_count from wt_vertole`st_count within w_uznr041
end type

type dw_list from wt_vertole`dw_list within w_uznr041
boolean visible = true
string dataobject = "d_uznr041_1"
boolean eb_null_line = false
end type

type st_move from wt_vertole`st_move within w_uznr041
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_uznr041
boolean eb_onepage = true
integer ii_pagetype = 2
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;IF dw_list.object.fund_currency [row]='KRW'  Then
   uf_fileopen ('rd_uznr040_krw.mrd', &
                     'ymd[' + string (dw_c.object.ymd [1],'yyyymmdd') + '] ' + &
                     'fund_cd[' + dw_list.object.fund_cd [row] + '] ' + &
                     'work_gb[' + f_nvl (dw_list.object.work_gb [row], 'A') + ']')
Else
   uf_fileopen ('rd_uznr040.mrd', &
                     'ymd[' + string (dw_c.object.ymd [1],'yyyymmdd') + '] ' + &
                     'fund_cd[' + dw_list.object.fund_cd [row] + '] ' + &
                     'fund_currency[' + dw_list.object.fund_currency [row] + '] ' + &
                     'work_gb[' + f_nvl (dw_list.object.work_gb [row], 'A') + ']')
End IF

end event

type rb_onepage from wt_vertole`rb_onepage within w_uznr041
end type

