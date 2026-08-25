forward
global type w_ja020c from wt_list
end type
end forward

global type w_ja020c from wt_list
string is_init_value = "F11"
end type
global w_ja020c w_ja020c

type variables
DEC	idc_danga
end variables

on w_ja020c.create
int iCurrent
call super::create
end on

on w_ja020c.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.baed_gisan_ymd [1] = idt_workdate
dw_c.object.dddw [1] = 'F11'
dw_c.object.p_visible [1] = 1

F_DDDWCTL (dw_c, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020C'")	// u_sjue110
F_DDDWCTL (dw_c, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='F11'")
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
IF	dw_c.object.dddw [1]='F57'	Then
	dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1], '%')

ElseIF f_null (dw_c.object.xx_jm_cd [1])	Then
	dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1], '%')
Else
	IF dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1], dw_c.object.xx_jm_cd [1])>0 THEN RETURN
	IF ib_manageData=FALSE THEN RETURN

	STRING	p_msg=SPACE(200), la_args[]

	LONG	lRow

	la_args[1] = gaa.corp_gr
	la_args[2] = STRING(dw_c.object.ymd[1], 'yyyy.mm.dd')
	la_args[3] = ia_value[1]
	la_args[4] = dw_c.object.koscom_cd[1]
	la_args[5] = dw_c.object.xx_jm_cd[1]
	la_args[6] = null_s
	la_args[7] = 'ref'
	SQLCA.singleconnection ()
	SQLCA.SP_CALL( THIS, 'SR_JA021C ( ?, ?, ?, ?, ?, ?, ? )', la_args[], p_msg )
	p_msg = f_nvl (SQLCA.getitemplsql (1), 'N')
	IF SQLCA.sqlcode()=-1  Then
		f_messageBox ('ORA0', '')  //서버의 물리적 오류 입니다.
		RETURN
	End IF

	lRow = dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1], dw_c.object.xx_jm_cd [1])
	IF lRow>0 THEN dw_List.SetItemStatus (1, 0, Primary!, DataModified!)
End IF
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja020c
end type

type ln_templeft from wt_list`ln_templeft within w_ja020c
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja020c
end type

type ln_temptop from wt_list`ln_temptop within w_ja020c
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja020c
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja020c
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja020c
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja020c
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja020c
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja020c
end type

type ln_tempright from wt_list`ln_tempright within w_ja020c
end type

type uo_navi from wt_list`uo_navi within w_ja020c
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja020c
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja020c
end type

type st_top_rect from wt_list`st_top_rect within w_ja020c
end type

type p_close from wt_list`p_close within w_ja020c
end type

type p_excel from wt_list`p_excel within w_ja020c
end type

type p_print from wt_list`p_print within w_ja020c
end type

type p_delete from wt_list`p_delete within w_ja020c
end type

type p_update from wt_list`p_update within w_ja020c
end type

type p_input from wt_list`p_input within w_ja020c
end type

type p_retrieve from wt_list`p_retrieve within w_ja020c
end type

type p_clear from wt_list`p_clear within w_ja020c
end type

type p_copy from wt_list`p_copy within w_ja020c
end type

type dw_c from wt_list`dw_c within w_ja020c
string dataobject = "d_ja020c"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'ymd'
      IF datetime (date (MidA (data,1,10)))>=uf_initdate ('inputdate')  Then
         ib_manageData = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020C'")		// u_sjue110
         Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='"+Object.dddw [1]+"'")
      Else
         ib_manageData = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020C' and szx0gc.tr_cd in (select tr_cd from sjt0fs where corp_gr=':corp_gr' and tr_ymd='"+MidA (data, 1, 10)+"')")
      End IF
		f_visible (THIS, ib_managedata, 'danc_gb')
      Object.koscom_cd [1] = null_s
      Object.xx_koscom_cd [1] = null_s
      Object.xx_jm_cd [1] = null_s

   CASE 'dddw'
      IF ib_manageData THEN Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='"+data+"'")
      Object.koscom_cd [1] = null_s
      Object.xx_koscom_cd [1] = null_s
      Object.xx_jm_cd [1] = null_s

   CASE 'danc_gb'  // 시장구분
      Object.koscom_cd [1] = null_s
      Object.xx_koscom_cd [1] = null_s
      Object.xx_jm_cd [1] = null_s
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020C'")
Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='F11'")
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'koscom_cd'
      IF ib_manageData  Then
			IF	POS (Object.dddw [1],'F11,F12,F13,F14')>0	Then
	         rs_Where = "balh_co in (select balh_co from sjt0bm where corp_gr='" + gaa.corp_gr + "' and nvl(sury_ymd,'" + string (idt_workdate,'yyyy.mm.dd') + "')='" + string (idt_workdate,'yyyy.mm.dd') + "') And danc_gb in ('A','C','D')"
			End IF
      Else
         rs_Where = "jm_cd in (select jm_cd from sjt0fs where tr_ymd='" + string (Object.ymd [1],'yyyy.mm.dd') + "' and tr_cd='" + Object.dddw [1] + "')"
      End IF
      RETURN 2
END CHOOSE
RETURN 1
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (dw_c.object.ymd [1]>=uf_initdate ('inputdate') OR gaa.aams)
IF f_null (Object.koscom_cd [1]) And Object.dddw [1]<>'F57' THEN ib_manageData = FALSE
RETURN TRUE

end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SJT0FS t1
 WHERE t1.corp_gr = :gaa.corp_gr
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (select tr_cd
                        from SZX1PT ta
                       where ta.obj_id = 'W_JA020C')
   AND ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja020c
end type

type st_count from wt_list`st_count within w_ja020c
end type

type dw_list from wt_list`dw_list within w_ja020c
string dataobject = "d_ja020c1"
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt_tr_ymd

ldt_tr_ymd = dw_c.object.ymd [1]
CHOOSE CASE dwo.name
	CASE 'fund_cd'
		IF	dw_c.object.dddw [1]='F57' THEN Object.jm_cd [row] = data
   CASE 'danga'
         Object.sury_aek [row] = f_num (Object.xx_boyu_jusu [row]) * f_num (data)
   CASE 'sury_aek'
		IF	f_num (Object.xx_boyu_jusu [row])>0 THEN Object.danga [row] = f_num (data) / f_num (Object.xx_boyu_jusu [row])
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('koscom_cd', dw_c.object.koscom_cd [1])
uf_setColumn ('jm_cd', dw_c.object.xx_jm_cd [1])
uf_setColumn ('danga', string (idc_danga))

POST SetColumn ("sury_aek")

RETURN 0
end event

event dw_list::retrieveend;call super::retrieveend;IF rowcount>0 THEN idc_danga = Object.danga [1]
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE "fund_cd"
		IF	dw_c.object.dddw [1]<>'F57'	Then
         rs_where = "t1.ymd='" + string (dw_c.object.baed_gisan_ymd [1],'yyyy.mm.dd') + "' and t1.jm_cd='" + dw_c.object.xx_jm_cd [1] + "'" + " and t1.fund_cd like 'M1V1%' "
         RETURN 10
		End IF
END CHOOSE
RETURN 1
end event

