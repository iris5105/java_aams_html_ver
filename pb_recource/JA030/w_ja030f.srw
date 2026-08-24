forward
global type w_ja030f from wt_list
end type
end forward

global type w_ja030f from wt_list
end type
global w_ja030f w_ja030f

on w_ja030f.create
int iCurrent
call super::create
end on

on w_ja030f.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], 'J32')
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja030f
end type

type ln_templeft from wt_list`ln_templeft within w_ja030f
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja030f
end type

type ln_temptop from wt_list`ln_temptop within w_ja030f
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja030f
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja030f
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja030f
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja030f
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja030f
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja030f
end type

type ln_tempright from wt_list`ln_tempright within w_ja030f
end type

type uo_navi from wt_list`uo_navi within w_ja030f
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja030f
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja030f
end type

type st_top_rect from wt_list`st_top_rect within w_ja030f
end type

type p_close from wt_list`p_close within w_ja030f
end type

type p_excel from wt_list`p_excel within w_ja030f
end type

type p_print from wt_list`p_print within w_ja030f
end type

type p_delete from wt_list`p_delete within w_ja030f
end type

type p_update from wt_list`p_update within w_ja030f
end type

type p_input from wt_list`p_input within w_ja030f
end type

type p_retrieve from wt_list`p_retrieve within w_ja030f
end type

type p_clear from wt_list`p_clear within w_ja030f
end type

type p_copy from wt_list`p_copy within w_ja030f
end type

type dw_c from wt_list`dw_c within w_ja030f
string title = "매매일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SHT0HG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   = 'J32'
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN  li_ret
end event

event dw_c::ue_valid;call super::ue_valid;ib_manageData = (uf_initdate ('inputdate')<=Object.ymd[1] OR gaa.admin)
RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja030f
end type

type st_count from wt_list`st_count within w_ja030f
end type

type dw_list from wt_list`dw_list within w_ja030f
string dataobject = "d_ja030f"
boolean eb_range_delcopy = false
boolean eb_copy_false = true
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE dwo.name
      CASE 'aekm'
         Object.tr_aek [row] = Object.danga [row] / 10000 * dec (data)
      CASE 'danga'
         Object.tr_aek [row] = Object.aekm [row] * dec (data) / 10000
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('tr_cd', 'J32')

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
	CASE 'hj_cd'
		rs_Where = "balh_ymd < '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and sanghw_ymd > '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and fund_cd='" + Object.fund_cd [row] + "'"
END CHOOSE
RETURN 1
end event

