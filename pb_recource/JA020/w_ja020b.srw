forward
global type w_ja020b from wt_list
end type
end forward

global type w_ja020b from wt_list
string is_init_value = "1"
end type
global w_ja020b w_ja020b

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.danc_gb [1] = 'B'
dw_c.object.dddw [1] = 'F46'
dw_c.object.susu_per [1] = dec (ia_value [1])
dw_c.object.cheng_type [1] = '2'
dw_c.object.sury_ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = string (dw_c.object.susu_per [1])
dw_list.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], dw_c.object.dddw [1], dw_c.object.xx_jm_cd [1])
end event

on w_ja020b.create
int iCurrent
call super::create
end on

on w_ja020b.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja020b
end type

type ln_templeft from wt_list`ln_templeft within w_ja020b
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja020b
end type

type ln_temptop from wt_list`ln_temptop within w_ja020b
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja020b
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja020b
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja020b
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja020b
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja020b
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja020b
end type

type ln_tempright from wt_list`ln_tempright within w_ja020b
end type

type uo_navi from wt_list`uo_navi within w_ja020b
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja020b
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja020b
end type

type st_top_rect from wt_list`st_top_rect within w_ja020b
end type

type p_close from wt_list`p_close within w_ja020b
end type

type p_excel from wt_list`p_excel within w_ja020b
end type

type p_print from wt_list`p_print within w_ja020b
end type

type p_delete from wt_list`p_delete within w_ja020b
end type

type p_update from wt_list`p_update within w_ja020b
end type

type p_input from wt_list`p_input within w_ja020b
end type

type p_retrieve from wt_list`p_retrieve within w_ja020b
end type

type p_clear from wt_list`p_clear within w_ja020b
end type

type p_copy from wt_list`p_copy within w_ja020b
end type

type dw_c from wt_list`dw_c within w_ja020b
integer height = 456
string dataobject = "d_ja020b"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

STRING	ls_f_value

DATETIME ldt_f_param1

CHOOSE CASE dwo.name
   CASE 'tr_ymd'
      IF DateTime (Date (MidA (data,1,10)))>=idt_workdate   Then
         ib_manageData = TRUE
         Object.tr_co_cd.Protect = 0
      Else
         ib_manageData = FALSE
         Object.tr_co_cd.Protect = 1
      End IF
      Object.danc_gb_t.Visible = ib_manageData
      Object.danc_gb.Visible = ib_manageData
      Object.koscom_cd [1] = null_s
      Object.xx_koscom_cd [1] = null_s
      Object.xx_jm_cd [1] = null_s
      Object.xx_balh_ga [1] = 0
      Object.lock_end [1] = null_dt

   CASE 'danc_gb'  // 시장구분
      Object.koscom_cd [1] = null_s
      Object.xx_koscom_cd [1] = null_s
      Object.xx_jm_cd [1] = null_s
      Object.xx_balh_ga [1] = 0
      Object.lock_end [1] = null_dt

   CASE 'cheng_type'
      CHOOSE CASE data
         CASE '1'
            IF f_notnull (dw_list.object.fund_cd [1]) Then
               FOR  ll = 1  TO  dw_list.rowcount ()
                  dw_list.object.sury_ymd [ll] = null_dt
               NEXT
            End IF
         CASE '2'
            IF f_notnull (dw_list.object.fund_cd [1]) Then
               FOR  ll = 1  TO  dw_list.rowcount ()
                  dw_list.object.sury_ymd [ll] = Object.sury_ymd [1]
               NEXT
            End IF
      END CHOOSE

   CASE 'sury_ymd'
		
		ldt_f_param1 = datetime(date(MidA(data,1,10)))
		SELECT F_STOCK( :ldt_f_param1 )
		  INTO :ls_f_value
		FROM   DUAL;
		ls_f_value = SQLCA.getitemstring (1)
		
      IF ls_f_value='1'   Then
         RETURN uf_itemerror ('sury_ymd', '휴장일을 입력하셨습니다.')
      End IF
      IF datetime (date (MidA (data,1,10)))<idt_workdate Then
         RETURN uf_itemerror ('sury_ymd', '납입일자는 작업일자와 같거나 커야 합니다.')
      End IF
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020B'")
F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='F46'")
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'koscom_cd'
      IF ib_manageData  Then
         rs_Where = "danc_gb='" + Object.danc_gb [1] + "'"
      Else
         rs_Where = "danc_gb='" + Object.danc_gb [1] + "' and koscom_cd in (select koscom_cd from sjt0cy where corp_gr='" + gaa.corp_gr + "' and tr_ymd='" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "' and tr_cd='" + Object.dddw [1] + "')"
      End IF
      RETURN 2
   CASE 'tr_co_cd'
      IF ib_manageData THEN rs_Where = "tr_gb IN ('1','2') and used='1'"
END CHOOSE

RETURN 1
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SJT0CY t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT h1
                       WHERE obj_id = 'W_SJA020B')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

event dw_c::ue_valid;call super::ue_valid;IF f_null (Object.koscom_cd [1]) Then
   f_messageBox ('ERR', '단축코드를 입력하십시오.')
   RETURN FALSE
End IF
RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja020b
end type

type st_count from wt_list`st_count within w_ja020b
end type

type dw_list from wt_list`dw_list within w_ja020b
integer y = 652
integer height = 2108
string dataobject = "d_ja020b1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DEC	ldc_aek

STRING	ls_sutak_cd

CHOOSE CASE dwo.name
   CASE 'fund_cd'
      SELECT  mg_cd
        INTO  :ls_sutak_cd
      FROM    szm0ia t1
      WHERE   t1.corp_gr = :gaa.corp_gr
        AND   t1.fund_cd = :data;

		ls_sutak_cd = SQLCA.getitemstring (1)

      Object.sutak_cd [row] = ls_sutak_cd
   CASE "cheng_jusu"
      ldc_aek = dec (data) * dw_c.object.xx_balh_ga [1]
      Object.cheng_aek [row] = ldc_aek
      IF f_num (dw_c.object.susu_per [1])>0  Then
         Object.susu [row] = truncate (ldc_aek * dw_c.object.susu_per [1] / 100,0)
      Else
         Object.susu [row] = 0
      End IF
END CHOOSE
end event

event dw_list::updateend;call super::updateend;//IF rowsinserted>0 OR rowsupdated>0   Then
//   STRING	ls_jm_cd
//
//   DateTime ldt_lock_end
//
//   ls_jm_cd = Object.jm_cd [1]
//   ldt_lock_end = Object.lock_end [1]
//
//   UPDATE  sjm0jj
//      SET  lock_end = :ldt_lock_end
//   WHERE   jm_cd = :ls_jm_cd;
//End IF
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_where = "haeji_ymd is null"
END CHOOSE
RETURN 1
end event

event dw_list::retrieveend;call super::retrieveend;IF rowcount>0 OR ib_manageData=FALSE   Then
   IF rowcount>0  Then
      dw_c.object.xx_balh_ga [1] = Object.danga [1]
      dw_c.object.lock_end [1] = Object.lock_end [1]
      dw_c.object.cheng_type [1] = Object.cheng_type [1]
      IF dw_c.object.cheng_type [1]='2' THEN dw_c.object.sury_ymd [1] = Object.sury_ymd [1]
   End IF
   RETURN
End IF

IF f_messageBox ('XLS0','')=2 THEN RETURN

OLEObject   xlapp, xlsub

LONG	ret, r, lRow

STRING	ls_fund_cd, ls_fund_nm

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

// Connect to Excel and check the return code
ret = xlApp.ConnectToObject ("", "excel.application")   // 현재 실행되어 있는 엑셀 Connect
IF ret<0 Then
   f_messageBox ('XLS1', string (ret))
   RETURN 0
End IF

// Make Excel visible
xlApp.Application.Visible = TRUE

xlsub = xlapp.Application.ActiveSheet

Reset ()
FOR  r = 9  TO  1000
   lRow = insertrow (0)

   ls_fund_cd = TRIM (string (xlsub.cells (r,2).Value))

   IF f_null (ls_fund_cd)  Then
      deleterow (lRow)
      EXIT
   End IF

   SELECT  fund_nm
     INTO  :ls_fund_nm
   FROM    szm0ia t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.fund_cd = :ls_fund_cd;
	
	ls_fund_nm = SQLCA.getitemstring (1)
	
   IF SQLCA.SQLCode()<>0  Then
      deleterow (lRow)
      CONTINUE
   End IF

   // 엑셀 DATA
   Object.fund_cd [lRow]      = ls_fund_cd
   Object.xx_fund_cd [lRow]   = ls_fund_nm
   Object.cheng_jusu [lRow]   = f_num (xlsub.cells (r,4).Value)
   Object.cheng_aek [lRow]    = f_num (xlsub.cells (r,5).Value)
   ScrollToRow (lRow)

   // 기본 DATA
   Object.corp_gr [lRow]      =  gaa.corp_gr
   Object.tr_ymd [lRow]       =  dw_c.object.tr_ymd [1]
   Object.tr_cd [lRow]        =  dw_c.object.dddw [1]
   Object.koscom_cd [lRow]    =  dw_c.object.koscom_cd [1]
   Object.jm_cd [lRow]        =  dw_c.object.xx_jm_cd [1]
   Object.danga [lRow]        =  dw_c.object.xx_balh_ga [1]
   Object.tr_co_cd [lRow]     =  dw_c.object.tr_co_cd [1]
   Object.lock_end [lRow]     =  dw_c.object.lock_end [1]
   Object.cheng_type [lRow]   = dw_c.object.cheng_type [1]
   IF dw_c.object.cheng_type [1]='2' THEN Object.sury_ymd[lRow] = dw_c.object.sury_ymd [1]
NEXT

// clean up
xlapp.DisConnectObject ()
DESTROY xlapp

xlsub.DisConnectObject ()
DESTROY xlsub
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.tr_ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('koscom_cd', dw_c.object.koscom_cd [1])
uf_setColumn ('jm_cd', dw_c.object.xx_jm_cd [1])
uf_setColumn ('tr_co_cd', dw_c.object.tr_co_cd [1])
uf_setColumn ('danga', string (dw_c.object.xx_balh_ga [1]))
uf_setColumn ('lock_end', string (dw_c.object.lock_end [1]))
uf_setColumn ('cheng_type', string (dw_c.object.cheng_type [1]))
IF dw_c.object.cheng_type [1]='2' THEN uf_setColumn ('sury_ymd', string (dw_c.object.sury_ymd [1]))
uf_setColumn ('type_trench', '00:')
uf_setColumn ('bs_type', '0')

POST SetColumn ("fund_cd")

RETURN 0
end event

