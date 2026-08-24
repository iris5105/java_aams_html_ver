forward
global type w_ja030k from wt_list
end type
end forward

global type w_ja030k from wt_list
boolean eb_direct_retrieve = true
end type
global w_ja030k w_ja030k

on w_ja030k.create
int iCurrent
call super::create
end on

on w_ja030k.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

SELECT trunc (:idt_workdate, 'mm')
  INTO :ldt
  FROM DUAL;

dw_c.object.fymd [1] = SQLCA.getitemdatetime (1)
dw_c.object.tymd [1] = idt_workdate

CHOOSE CASE gaa.corp_gr
	CASE '2402'
		dw_list.uf_dataobject ('d_ja030k1_2402', FALSE)
	CASE ELSE
		dw_list.uf_dataobject ('d_ja030k1', FALSE)
END CHOOSE
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, string (dw_c.object.fymd [1],'yyyymmdd'), string (dw_c.object.tymd [1],'yyyymmdd'))
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja030k
end type

type ln_templeft from wt_list`ln_templeft within w_ja030k
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja030k
end type

type ln_temptop from wt_list`ln_temptop within w_ja030k
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja030k
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja030k
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja030k
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja030k
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja030k
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja030k
end type

type ln_tempright from wt_list`ln_tempright within w_ja030k
end type

type uo_navi from wt_list`uo_navi within w_ja030k
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja030k
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja030k
end type

type st_top_rect from wt_list`st_top_rect within w_ja030k
end type

type p_close from wt_list`p_close within w_ja030k
end type

type p_excel from wt_list`p_excel within w_ja030k
end type

type p_print from wt_list`p_print within w_ja030k
end type

type p_delete from wt_list`p_delete within w_ja030k
end type

type p_update from wt_list`p_update within w_ja030k
end type

type p_input from wt_list`p_input within w_ja030k
end type

type p_retrieve from wt_list`p_retrieve within w_ja030k
end type

type p_clear from wt_list`p_clear within w_ja030k
end type

type p_copy from wt_list`p_copy within w_ja030k
end type

type dw_c from wt_list`dw_c within w_ja030k
string title = "상환구간"
string dataobject = "dc_ftymd"
end type

type btn_update from wt_list`btn_update within w_ja030k
end type

type st_count from wt_list`st_count within w_ja030k
end type

type dw_list from wt_list`dw_list within w_ja030k
string dataobject = "d_ja030k1_2402"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;IF	gaa.corp_gr<>'2402' THEN rollbackJ ()
end event

event dw_list::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1

CHOOSE CASE dwo.name
	CASE 'misu_ija'
		IF	Object.sunhu_gb [row]='2'	Then
			Object.sury_aek [row] = f_num (Object.aekm [row]) + dec (data) - f_num (Object.ija_tax [row])
		Else
			Object.sury_aek [row] = f_num (Object.chui_aek [row]) + dec (data) - f_num (Object.ija_tax [row])
		End IF
	CASE 'ija_tax'
		IF	Object.sunhu_gb [row]='2'	Then
			Object.sury_aek [row] = f_num (Object.aekm [row]) + f_num (Object.misu_ija [row]) - dec (data)
		Else
			Object.sury_aek [row] = f_num (Object.chui_aek [row]) + f_num (Object.misu_ija [row]) - dec (data)
		End IF
END CHOOSE

Object.mod_user [row] = gnv_vari.is_user_nm
Object.mod_dt [row] = f_sysdate ('')
end event

