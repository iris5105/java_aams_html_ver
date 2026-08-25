forward
global type w_ja050a from wt_vertole
end type
end forward

global type w_ja050a from wt_vertole
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
end type
global w_ja050a w_ja050a

type variables

end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = f_gijunga_ymd ('')
end event

on w_ja050a.create
int iCurrent
call super::create
end on

on w_ja050a.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_List.retrieve (gaa.corp_gr, '%', dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_List.enabled THEN dw_List.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja050a
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja050a
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja050a
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja050a
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja050a
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja050a
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja050a
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja050a
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja050a
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja050a
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja050a
end type

type uo_navi from wt_vertole`uo_navi within w_ja050a
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja050a
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja050a
end type

type p_close from wt_vertole`p_close within w_ja050a
end type

type p_excel from wt_vertole`p_excel within w_ja050a
end type

type p_print from wt_vertole`p_print within w_ja050a
end type

type p_delete from wt_vertole`p_delete within w_ja050a
end type

type p_update from wt_vertole`p_update within w_ja050a
end type

type p_input from wt_vertole`p_input within w_ja050a
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja050a
end type

type p_clear from wt_vertole`p_clear within w_ja050a
end type

type p_copy from wt_vertole`p_copy within w_ja050a
end type

type dw_c from wt_vertole`dw_c within w_ja050a
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertole`btn_update within w_ja050a
end type

type st_count from wt_vertole`st_count within w_ja050a
end type

type dw_list from wt_vertole`dw_list within w_ja050a
boolean visible = true
string dataobject = "d_ja050a1"
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mg_cd', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'work_gb', gaa.corp_gr, '', 1, '')
end event

event dw_list::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'fund_cd','fund_nm'
      str_parameter  sp

      sp.dt [1] = dw_c.object.ymd [1]

      sp.str [1] = dw_List.object.fund_cd [row]
      sp.str [2] = dw_List.object.fund_nm [row]

      OpenwithParm (w_ac_popup, sp)
END CHOOSE
end event

type st_move from wt_vertole`st_move within w_ja050a
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja050a
boolean eb_onepage = true
boolean eb_openpagerd = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;uf_fileopen ('rd_ja050a.mrd', &
                  'ymd[' + string (dw_c.object.ymd [1],'yyyymmdd') + '] ' + &
                  'fund_cd[' + dw_List.object.fund_cd [row] + '] ' + &
                  'work_gb[' + f_nvl (dw_list.object.work_gb [row], 'A') + ']')

end event

type rb_onepage from wt_vertole`rb_onepage within w_ja050a
end type

