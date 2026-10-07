forward
global type w_scm1sm from wt_list
end type
type cb_1 from pf_u_commandbutton within w_scm1sm
end type
end forward

global type w_scm1sm from wt_list
cb_1 cb_1
end type
global w_scm1sm w_scm1sm

on w_scm1sm.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_scm1sm.destroy
call super::destroy
destroy(this.cb_1)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
cb_1.enabled = true
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_clear;call super::wue_clear;cb_1.enabled = false
end event

type lb_dirlist from wt_list`lb_dirlist within w_scm1sm
end type

type ln_templeft from wt_list`ln_templeft within w_scm1sm
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_scm1sm
end type

type ln_temptop from wt_list`ln_temptop within w_scm1sm
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_scm1sm
end type

type ln_tempstart from wt_list`ln_tempstart within w_scm1sm
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_scm1sm
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_scm1sm
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_scm1sm
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_scm1sm
end type

type ln_tempright from wt_list`ln_tempright within w_scm1sm
end type

type uo_navi from wt_list`uo_navi within w_scm1sm
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_scm1sm
end type

type st_windelaytime from wt_list`st_windelaytime within w_scm1sm
end type

type st_top_rect from wt_list`st_top_rect within w_scm1sm
end type

type p_close from wt_list`p_close within w_scm1sm
end type

type p_excel from wt_list`p_excel within w_scm1sm
end type

type p_print from wt_list`p_print within w_scm1sm
end type

type p_delete from wt_list`p_delete within w_scm1sm
end type

type p_update from wt_list`p_update within w_scm1sm
end type

type p_input from wt_list`p_input within w_scm1sm
end type

type p_retrieve from wt_list`p_retrieve within w_scm1sm
end type

type p_clear from wt_list`p_clear within w_scm1sm
end type

type p_copy from wt_list`p_copy within w_scm1sm
end type

type dw_c from wt_list`dw_c within w_scm1sm
string title = "종가일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_list`btn_update within w_scm1sm
end type

type st_count from wt_list`st_count within w_scm1sm
end type

type dw_list from wt_list`dw_list within w_scm1sm
string dataobject = "d_scm1sm"
boolean eb_null_line = false
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('ymd', string (idt_workdate))

post setcolumn ('as_cj_cd')

RETURN 0
end event

event dw_list::retrieveend;call super::retrieveend;ads_jTier	lds_jj

STRING	ls_sqlsyntax

LONG	ll, ll_find, ll_jj, ll_row

lds_jj = CREATE ads_jTier

ls_sqlsyntax = " SELECT DISTINCT t1.jm_cd " + &
               "      , f_jm_nm(t1.corp_gr,t1.jm_cd) " + &
               "      , NVL(sm.danga,0) " + &
               " FROM   scm0cm t1 " + &
               "             LEFT OUTER JOIN scm1sm sm " + &
               "               ON  sm.corp_gr = t1.corp_gr " + &
               "               And sm.ymd     = f_open_ymd(t1.ymd,'-1') " + &
               "               And sm.jm_cd   = t1.jm_cd " + &
               " WHERE  t1.corp_gr = '" + gaa.corp_gr + "' " + &
               "   AND  t1.ymd     = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' " + &
               " ORDER BY 1 "

ll_jj = SQLCA.sql2ds (classname(), ls_sqlsyntax, lds_jj, 'xml')

ll_row = rowcount

FOR  ll = 1  TO  ll_jj
	ll_find = dw_list.FIND ("jm_cd='" + lds_jj.getitemstring (ll, 1) + "'", 1, ll_row)
	IF	ll_find=0	Then
		dw_list.insertrow (1)
		dw_list.object.corp_gr [1]  = gaa.corp_gr
		dw_list.object.ymd [1]      = dw_c.object.ymd [1]
		dw_list.object.jm_cd [1]    = lds_jj.getitemstring (ll, 1)
		dw_list.object.as_cj_cd [1] = lds_jj.getitemstring (ll, 1)
		dw_list.object.cj_nm [1]    = lds_jj.getitemstring (ll, 2)
		dw_list.object.danga [1]    = lds_jj.getitemdecimal (ll, 3)
		ll_row ++
	End IF
NEXT
end event

type cb_1 from pf_u_commandbutton within w_scm1sm
integer x = 1193
integer y = 188
integer width = 389
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string text = "종가LOAD"
end type

event clicked;call super::clicked;OLEObject   xlapp, xlsub

LONG	ret, r = 1, ll

STRING	ls_path, ls_name, ls_jm_cd

// Create the oleobject variable xlapp
xlApp = Create OLEObject

IF GetFileOpenName ("종가 엑셀파일 선택", ls_path, ls_name, 'XLS', "Excel Files (*.xls;*.xlsx;*.csv),*.xls;*.xlsx;*.csv", gaa.excel, 2)<>1 THEN RETURN

ret = xlApp.ConnectToNewObject ("excel.application")
IF ret<0 Then
   f_messageBox ('XLS1', string(ret))
   RETURN
End IF
xlApp.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기
xlApp.Application.Visible = false
xlApp.windowstate = 2
xlsub = xlApp.Application.ActiveSheet

f_loadingchart (TRUE)

dw_list.setfocus ()

DO WHILE TRUE
	r ++
   ls_jm_cd = TRIM (STRING (xlsub.cells (r,4).Value))
	IF	f_null (ls_jm_cd) THEN EXIT

   ll = dw_list.FIND ("jm_cd = '" + ls_jm_cd + "'", 1, dw_list.rowcount ())
   IF ll>0	Then
		dw_list.setrow (ll)
		dw_list.scrolltorow (ll)
		dw_list.object.danga [ll] = DEC (xlsub.cells (r,7).value)
   End IF
LOOP

f_loadingchart (FALSE)

f_messageBox ('INFO', '종가 Load가 완료되었습니다.')
end event

