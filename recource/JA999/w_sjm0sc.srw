forward
global type w_sjm0sc from wt_list
end type
end forward

global type w_sjm0sc from wt_list
integer ii_dddw_width = 800
end type
global w_sjm0sc w_sjm0sc

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' })
f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '', 1, "substrb (company_name,1,1) != '*'")
dw_c.object.dddw [1] = gaa.corp_gr
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (dw_c.object.dddw [1])
end event

on w_sjm0sc.create
int iCurrent
call super::create
end on

on w_sjm0sc.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_sjm0sc
end type

type ln_templeft from wt_list`ln_templeft within w_sjm0sc
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_sjm0sc
end type

type ln_temptop from wt_list`ln_temptop within w_sjm0sc
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_sjm0sc
end type

type ln_tempstart from wt_list`ln_tempstart within w_sjm0sc
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_sjm0sc
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_sjm0sc
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_sjm0sc
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_sjm0sc
end type

type ln_tempright from wt_list`ln_tempright within w_sjm0sc
end type

type uo_navi from wt_list`uo_navi within w_sjm0sc
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_sjm0sc
end type

type st_windelaytime from wt_list`st_windelaytime within w_sjm0sc
end type

type st_top_rect from wt_list`st_top_rect within w_sjm0sc
end type

type p_close from wt_list`p_close within w_sjm0sc
end type

type p_excel from wt_list`p_excel within w_sjm0sc
end type

type p_print from wt_list`p_print within w_sjm0sc
end type

type p_delete from wt_list`p_delete within w_sjm0sc
end type

type p_update from wt_list`p_update within w_sjm0sc
end type

type p_input from wt_list`p_input within w_sjm0sc
end type

type p_retrieve from wt_list`p_retrieve within w_sjm0sc
end type

type p_clear from wt_list`p_clear within w_sjm0sc
end type

type p_copy from wt_list`p_copy within w_sjm0sc
end type

type dw_c from wt_list`dw_c within w_sjm0sc
string title = "자문(운용)사"
string dataobject = "dc_ymd_dddw"
end type

type btn_update from wt_list`btn_update within w_sjm0sc
end type

type st_count from wt_list`st_count within w_sjm0sc
end type

type dw_list from wt_list`dw_list within w_sjm0sc
string dataobject = "d_sjm0sc"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'type_gb', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'dist_calc', gaa.corp_gr, '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

STRING	aJm_cd []

SetNull (aJm_cd [1])
SetNull (aJm_cd [2])

CHOOSE CASE dwo.name
   CASE "tasa_cd"
      SELECT  TO_CHAR(:data,'fm00000')
        INTO  :aJm_cd[1]
      FROM    dual;

		aJm_cd[1] = SQLCA.getitemstring (1)

      SELECT  TO_CHAR(nvl(max(seq_no) + 1,1),'fm0000')
        INTO  :aJm_cd[2]
      FROM    sjm0sc t1
      WHERE   t1.corp_gr = :gaa.corp_gr
        AND   t1.tasa_cd = :data;
		  
		aJm_cd[2] = SQLCA.getitemstring (1)
		  
   CASE "tasa_fund_cd"
      FOR  ll = 1  TO  rowcount ()
         IF row<>ll And Object.tasa_fund_cd [ll]=data Then
            SelectRow (ll, TRUE)
            RETURN uf_itemerr (row, dwo.name, string (ll)+'행에 동일한 타사펀드코드가 존재합니다.')
         End IF
      NEXT
END CHOOSE

IF f_notnull (aJm_cd [1]) AND f_notnull (aJm_cd [2]) And f_null (Object.tasa_jm_cd [row]) Then
   Object.seq_no [row] = dec (aJm_cd [2])
   Object.tasa_jm_cd [row] = 'KR5' + aJm_cd [1] + aJm_cd [2]
End IF
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('type_gb', '3')
uf_setcolumn ('dist_calc', '1')
uf_setcolumn ('haeji_gb', '1')
uf_setcolumn ('sintak_gigan', '12')
uf_setcolumn ('trans_unit', '1000')
uf_setcolumn ('fst_gijun_ga', '1000')

POST SetColumn ('tasa_cd')

RETURN 0
end event

