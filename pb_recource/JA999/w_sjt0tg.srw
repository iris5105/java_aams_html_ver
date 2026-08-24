forward
global type w_sjt0tg from wt_list
end type
type cb_1 from pf_u_commandbutton within w_sjt0tg
end type
end forward

global type w_sjt0tg from wt_list
cb_1 cb_1
end type
global w_sjt0tg w_sjt0tg

on w_sjt0tg.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_sjt0tg.destroy
call super::destroy
destroy(this.cb_1)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
cb_1.enabled = true
end event

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

SELECT HYUN_YMD
  INTO :ldt
  FROM SZX0AA aa
 WHERE aa.CORP_GR = :gaa.corp_gr;

ldt = SQLCA.getitemdatetime (1)

dw_c.object.ymd [1] = ldt
end event

event wue_clear;call super::wue_clear;cb_1.enabled = false
end event

type lb_dirlist from wt_list`lb_dirlist within w_sjt0tg
end type

type ln_templeft from wt_list`ln_templeft within w_sjt0tg
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_sjt0tg
end type

type ln_temptop from wt_list`ln_temptop within w_sjt0tg
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_sjt0tg
end type

type ln_tempstart from wt_list`ln_tempstart within w_sjt0tg
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_sjt0tg
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_sjt0tg
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_sjt0tg
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_sjt0tg
end type

type ln_tempright from wt_list`ln_tempright within w_sjt0tg
end type

type uo_navi from wt_list`uo_navi within w_sjt0tg
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_sjt0tg
end type

type st_windelaytime from wt_list`st_windelaytime within w_sjt0tg
end type

type st_top_rect from wt_list`st_top_rect within w_sjt0tg
end type

type p_close from wt_list`p_close within w_sjt0tg
end type

type p_excel from wt_list`p_excel within w_sjt0tg
end type

type p_print from wt_list`p_print within w_sjt0tg
end type

type p_delete from wt_list`p_delete within w_sjt0tg
end type

type p_update from wt_list`p_update within w_sjt0tg
end type

type p_input from wt_list`p_input within w_sjt0tg
end type

type p_retrieve from wt_list`p_retrieve within w_sjt0tg
end type

type p_clear from wt_list`p_clear within w_sjt0tg
end type

type p_copy from wt_list`p_copy within w_sjt0tg
end type

type dw_c from wt_list`dw_c within w_sjt0tg
string title = "종가일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_list`btn_update within w_sjt0tg
end type

type st_count from wt_list`st_count within w_sjt0tg
end type

type dw_list from wt_list`dw_list within w_sjt0tg
string dataobject = "d_sjt0tg"
boolean eb_null_line = false
end type

event dw_list::itemchanged_next;call super::itemchanged_next;Object.change [row] = Object.close [row] - Object.preclose [row]
Object.mod_dt [row] = f_sysdate ('')
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('ymd', string (idt_workdate))

post setcolumn ('koscom_cd')

RETURN 0
end event

event dw_list::retrieveend;call super::retrieveend;ads_jTier   lds_jj

STRING	ls_sqlsyntax, ls_ymd, ls_koscom_cd

LONG	ll, ll_find, ll_jj, ll_row

DEC	ldc_jonga, ldc_volume, ldc_value, ldc_preclose, ldc_change, ldc_aekm, ldc_sangj_jusu

ls_ymd = string (dw_c.object.ymd [1],'yyyymmdd')

lds_jj = CREATE ads_jTier

ls_sqlsyntax = " SELECT DISTINCT t1.koscom_cd " &
             + "      , f_koscom_nm(t1.corp_gr,t1.koscom_cd) " &
             + "      , NVL(tg.close,0) " &
             + " FROM   sjm0jm t1 " &
             + "             LEFT OUTER JOIN sjt0tg tg " &
             + "               ON  tg.corp_gr   = t1.corp_gr " &
             + "               And tg.ymd       = f_open_ymd(t1.ymd,'-1') " &
             + "               And tg.koscom_cd = t1.koscom_cd " &
             + " WHERE  t1.corp_gr = '" + gaa.corp_gr + "' " &
             + "   AND  t1.ymd     = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' " &
             + " ORDER BY 1 "

ll_jj = SQLCA.sql2ds (classname(), ls_sqlsyntax, lds_jj, 'xml')

ll_row = rowcount

FOR  ll = 1  TO  ll_jj
   ls_koscom_cd = lds_jj.getitemstring (ll, 1)
   ll_find = dw_list.FIND ("koscom_cd='" + ls_koscom_cd + "'", 1, ll_row)
   IF ll_find=0   Then
      ll_find = 1
      dw_list.insertrow (1)
      dw_list.object.corp_gr [1]      = gaa.corp_gr
      dw_list.object.ymd [1]          = dw_c.object.ymd [1]
      dw_list.object.koscom_cd [1]    = ls_koscom_cd
      dw_list.object.xx_koscom_cd [1] = lds_jj.getitemstring (ll, 2)
      dw_list.object.CLOSE [1]        = lds_jj.getitemdecimal (ll, 3)
      dw_list.object.preclose [1]     = lds_jj.getitemdecimal (ll, 3)
      ll_row ++
   End IF

   SELECT curr_prc
        , tr_qty
        , tr_prc
        , pd_close_prc
        , fluc * decode(fluc_tp,'-',-1,1)
        , face_prc
        , list_qty
     INTO :ldc_jonga
        , :ldc_volume
        , :ldc_value
        , :ldc_preclose
        , :ldc_change
        , :ldc_aekm
        , :ldc_sangj_jusu
   FROM   FINCATCH_2 t1
   WHERE  t1.op_dt     = :ls_ymd
     AND  t1.koscom_cd = :ls_koscom_cd;
   IF SQLCA.sqlcode()=0 Then
      dw_list.object.CLOSE [ll_find]      = SQLCA.getitemdecimal(1)
      dw_list.object.volume [ll_find]     = SQLCA.getitemdecimal(2)
      dw_list.object.value [ll_find]      = SQLCA.getitemdecimal(3)
      dw_list.object.preclose [ll_find]   = SQLCA.getitemdecimal(4)
      dw_list.object.change [ll_find]     = SQLCA.getitemdecimal(5)
      dw_list.object.aekm [ll_find]       = SQLCA.getitemdecimal(6)
      dw_list.object.sangj_jusu [ll_find] = SQLCA.getitemdecimal(7)
   End IF
NEXT
end event

type cb_1 from pf_u_commandbutton within w_sjt0tg
integer x = 1193
integer y = 188
integer width = 389
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string text = "종가LOAD"
end type

event clicked;call super::clicked;OLEObject   xlapp, xlsub

LONG	ret, r = 1, ll

STRING	ls_path, ls_name, ls_koscom_cd

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

ls_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gaa.excel)
IF GetFileOpenName ("종가 엑셀파일 선택", ls_path, ls_name, 'XLS', "Excel Files (*.xls;*.xlsx;*.csv),*.xls;*.xlsx;*.csv", ls_path, 2)<>1 THEN RETURN
SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', f_replace (ls_path,ls_name,''))

ret = xlApp.ConnectToNewObject ("excel.application")
IF ret<0 Then
   f_messageBox ('XLS1', string(ret))
   RETURN
End IF
xlApp.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기
xlApp.Application.Visible = FALSE
xlApp.windowstate = 2
xlsub = xlApp.Application.ActiveSheet

f_loadingchart (TRUE)

dw_list.setfocus ()

DO WHILE TRUE
   r ++
   CHOOSE CASE gaa.corp_gr
      CASE '2201'
         ls_koscom_cd = TRIM (string (xlsub.cells (r,4).Value))
      CASE '2202'
         ls_koscom_cd = TRIM (string (xlsub.cells (r,1).Value))
      CASE '2203'
         ls_koscom_cd = TRIM (string (xlsub.cells (r,2).Value))
   END CHOOSE
   IF f_null (ls_koscom_cd) THEN EXIT

   ll = dw_list.FIND ("koscom_cd = '" + ls_koscom_cd + "'", 1, dw_list.rowcount ())
   IF ll>0  Then
      dw_list.setrow (ll)
      dw_list.scrolltorow (ll)
		CHOOSE CASE gaa.corp_gr
			CASE '2201'
				dw_list.object.CLOSE [ll] = dec (xlsub.cells (r,6).value)
				dw_list.object.volume [ll] = dec (xlsub.cells (r,10).value)
				dw_list.object.value [ll] = dec (xlsub.cells (r,20).value) * 1000000
			CASE '2202'
				dw_list.object.CLOSE [ll]  = dec (xlsub.cells (r,9).value)
				dw_list.object.mod_dt [ll] = f_sysdate ('')
		END CHOOSE
      dw_list.object.change [ll] = dw_list.object.CLOSE [ll] - dw_list.object.preclose [ll]
   End IF
LOOP

f_loadingchart (FALSE)

f_messageBox ('INFO', '종가 Load가 완료되었습니다.')
end event

