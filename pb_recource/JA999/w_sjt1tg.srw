forward
global type w_sjt1tg from wt_list
end type
type cb_3 from pf_u_commandbutton within w_sjt1tg
end type
type cb_other from pf_u_commandbutton within w_sjt1tg
end type
end forward

global type w_sjt1tg from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
cb_3 cb_3
cb_other cb_other
end type
global w_sjt1tg w_sjt1tg

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (dw_c.object.ymd [1])
cb_other.of_setEnabled(ib_managedata)
cb_3.of_setEnabled(FALSE)
cb_3.of_setEnabled(ib_managedata)
end event

on w_sjt1tg.create
int iCurrent
call super::create
this.cb_3=create cb_3
this.cb_other=create cb_other
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_other
end on

on w_sjt1tg.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.cb_other)
end on

event wue_clear;call super::wue_clear;cb_other.of_setEnabled(FALSE)
cb_3.of_setEnabled(FALSE)
end event

event open;icmdbutton = { cb_other, cb_3 }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_sjt1tg
end type

type ln_templeft from wt_list`ln_templeft within w_sjt1tg
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_sjt1tg
end type

type ln_temptop from wt_list`ln_temptop within w_sjt1tg
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_sjt1tg
end type

type ln_tempstart from wt_list`ln_tempstart within w_sjt1tg
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_sjt1tg
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_sjt1tg
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_sjt1tg
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_sjt1tg
end type

type ln_tempright from wt_list`ln_tempright within w_sjt1tg
end type

type uo_navi from wt_list`uo_navi within w_sjt1tg
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_sjt1tg
end type

type st_windelaytime from wt_list`st_windelaytime within w_sjt1tg
end type

type st_top_rect from wt_list`st_top_rect within w_sjt1tg
end type

type p_close from wt_list`p_close within w_sjt1tg
end type

type p_excel from wt_list`p_excel within w_sjt1tg
end type

type p_print from wt_list`p_print within w_sjt1tg
end type

type p_delete from wt_list`p_delete within w_sjt1tg
end type

type p_update from wt_list`p_update within w_sjt1tg
end type

type p_input from wt_list`p_input within w_sjt1tg
end type

type p_retrieve from wt_list`p_retrieve within w_sjt1tg
end type

type p_clear from wt_list`p_clear within w_sjt1tg
end type

type p_copy from wt_list`p_copy within w_sjt1tg
end type

type dw_c from wt_list`dw_c within w_sjt1tg
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (object.ymd [1]>=idt_workdate OR gaa.aams)
RETURN TRUE
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'ymd'
      ib_managedata = (datetime (date (mid (data,1,10)))>=idt_workdate OR gaa.aams)
END CHOOSE
end event

type btn_update from wt_list`btn_update within w_sjt1tg
end type

type st_count from wt_list`st_count within w_sjt1tg
end type

type dw_list from wt_list`dw_list within w_sjt1tg
string dataobject = "d_sjt1tg"
boolean eb_null_line = false
string is_resize_column = "bigo"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('ymd', string(dw_c.object.ymd [1]))

POST SetColumn ('sj_cd')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'close'
      Object.change [row] = dec (data) - f_num (Object.preclose [row])
END CHOOSE
end event

type cb_3 from pf_u_commandbutton within w_sjt1tg
integer x = 2757
integer y = 16
integer width = 631
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "신규(결제지수)생성"
end type

event clicked;STRING	ls_sj_cd, ls_sj_nm, ls_koscom_cd, ls_sqlsyntax	

LONG	ll, lR, lj

DEC	ldc_preclose, ldc_close

DateTime ldt_ymd, ldt_junil_ymd, ldt_iu_dt

aDS_jTier	lds_jtier

ldt_ymd = dw_c.object.ymd [1]
ldt_junil_ymd = datetime (RelativeDate (date (ldt_ymd), -1))

ls_sqlsyntax = " SELECT DISTINCT t2.sj_cd " + &
               "      , t2.sj_nm " + &
               "      , t2.koscom_cd " + &
               "      , NVL(t3.CLOSE,0) " + &
               "      , now() " + &
               " FROM   ssm0km t1 " + &
               "      , ssx0kj t2 " + &
               "             LEFT OUTER JOIN sjt1tg t3 " + &
               "               ON  t3.ymd       = '" + string (ldt_junil_ymd,'yyyy.mm.dd') + "' " + &
               "               And t3.koscom_cd = t2.sj_cd " + &
               " WHERE  t1.corp_gr = '" + gaa.corp_gr + "' "  + &
               "   AND  t1.ymd     = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " + &
               "   AND  t2.corp_gr = t1.corp_gr " + &
               "   AND  t2.sj_cd   = t1.sj_cd " + &
               "   AND  t2.lsy_ymd > '" + string (ldt_junil_ymd,'yyyy.mm.dd') + "' "  + &
               " ORDER BY t2.sj_cd "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lj = 1  TO  lR
   ls_sj_cd     = lds_jtier.getitemString (lj, 1)
   ls_sj_nm     = lds_jtier.getitemString (lj, 2)
   ls_koscom_cd = lds_jtier.getitemString (lj, 3)
   ldc_preclose = lds_jtier.getitemnumber (lj, 4)
   ldt_iu_dt    = lds_jtier.getitemdatetime (lj, 5)

   ll = dw_list.FIND ("sj_cd='" + ls_sj_cd + "'", 1, dw_list.rowcount ())
   IF ll=0  Then
      ll = dw_list.insertrow (0)
      dw_list.object.ymd [ll] = ldt_ymd
      dw_list.object.sj_cd [ll] = ls_sj_cd
      dw_list.object.xx_sj_cd [ll] = ls_sj_nm
      dw_list.object.preclose [ll] = ldc_preclose
      dw_list.object.bigo [ll] = '신규 생성종목'
   End IF

   IF f_null (ls_koscom_cd)   Then
      SELECT  CLOSE
            , preclose
        INTO  :ldc_close
            , :ldc_preclose
      FROM    sjt1tg t1
      WHERE   ymd       = :ldt_ymd
        AND   koscom_cd = SUBSTR(:ls_sj_cd,4,8);
		  ldc_close    = SQLCA.getitemnumber (1)
		  ldc_preclose = SQLCA.getitemnumber (2)
		
      IF SQLCA.sqlcode ()=0   Then
         IF ldc_close<>f_num (dw_list.object.CLOSE [ll]) OR ldc_preclose<>f_num (dw_list.object.preclose [ll]) Then
            dw_list.object.bigo [ll] = f_ntrim (dw_list.object.CLOSE [ll],0,2) + ' --> ' + f_ntrim (ldc_close,0,2)
            dw_list.object.CLOSE [ll] = ldc_close
            dw_list.object.change [ll] = dw_list.object.CLOSE [ll] - dw_list.object.preclose [ll]
            dw_list.object.preclose [ll] = ldc_preclose
         End IF
      End IF
   End IF
NEXT

// 주식 결제지수
ls_sqlsyntax = "   SELECT  DISTINCT t2.sj_cd " &
             + "         , t2.sj_nm " &
             + "   FROM    ssx0kj t1 " &
             + "         , ssx0kj t2 " &
             + "   WHERE   t1.corp_gr = '" + gaa.corp_gr + "' " &
             + "     AND   t1.lsy_ymd = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " &
             + "     AND   t1.jasan   != 'XX' " &
             + "     AND   t2.corp_gr = t1.corp_gr " &
             + "     AND   t2.sj_gb   = '0' " &
             + "     AND   t2.jasan   = t1.jasan "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lj = 1  TO  lR
   ls_sj_cd = lds_jtier.getitemString (lj, 1)
   ls_sj_nm = lds_jtier.getitemString (lj, 2)

   ll = dw_list.FIND ("sj_cd='" + ls_sj_cd + "'", 1, dw_list.rowcount ())
   IF ll=0  Then
      ll = dw_list.insertrow (0)
      dw_list.object.ymd [ll] = dw_c.object.ymd [1]
      dw_list.object.sj_cd [ll] = ls_sj_cd
      dw_list.object.xx_sj_cd [ll] = ls_sj_nm
      dw_list.object.preclose [ll] = 0
      dw_list.object.bigo [ll] = '신규생성 주식 결제지수'
   End IF
NEXT

// 국고채 결제지수
ls_sqlsyntax = "   SELECT  DISTINCT t2.sj_cd " &
             + "         , t2.sj_nm " &
             + "   FROM    ssx0kj t1 " &
             + "         , ssx0kj t2 " &
             + "   WHERE   t1.corp_gr     = '" + gaa.corp_gr + "' " &
             + "     AND   t1.lsy_ymd - 1 = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " &
             + "     AND   t1.jasan       = 'XX' " &
             + "     AND   t2.corp_gr     = t1.corp_gr " &
             + "     AND   t2.sj_gb       = '0' " &
             + "     AND   t2.jasan       = t1.jasan "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lj = 1  TO  lR
   ls_sj_cd = lds_jtier.getitemString (lj, 1)
   ls_sj_nm = lds_jtier.getitemString (lj, 2)

   ll = dw_list.FIND ("sj_cd='" + ls_sj_cd + "'", 1, dw_list.rowcount ())
   IF ll=0  Then
      ll = dw_list.insertrow (0)
      dw_list.object.ymd [ll] = dw_c.object.ymd [1]
      dw_list.object.sj_cd [ll] = ls_sj_cd
      dw_list.object.xx_sj_cd [ll] = ls_sj_nm
      dw_list.object.preclose [ll] = 0
      dw_list.object.bigo [ll] = '신규생성 국고채 결제지수'
   End IF
NEXT
end event

type cb_other from pf_u_commandbutton within w_sjt1tg
integer x = 2231
integer y = 16
integer width = 512
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "엑셀종가IMPORT"
end type

event clicked;OLEObject   obj_excel, lSheet

LONG	ret, r = 0, lRC, lRow, lCnt

// Create the oleobject variable obj_excel
obj_excel = CREATE OLEObject

// Connect to Excel and check the return code
ret = obj_excel.ConnectToObject ("", "excel.application")   // 현재 실행되어 있는 엑셀 Connect
IF ret<0 Then
   f_messageBox ('XLS1', string (ret))
   RETURN 0
End IF

obj_excel.Application.Visible = TRUE
obj_excel.windowstate = 3

lSheet = obj_excel.Application.ActiveSheet
lRC = lSheet.UsedRange.Rows.Count

lCnt = dw_list.rowcount ()

st_count.visible = true
DO WHILE TRUE
   r ++
   IF lRC<r THEN EXIT
   f_st_count (st_count, '종가 IMPORT : ', r, lRC)

   lRow = dw_list.FIND ("mid(sj_cd,4,8)='" + string (lSheet.cells (r,1).Value) + "'", 1, lCnt)
   IF lRow>0   Then
      IF f_num (dw_list.object.CLOSE [lRow])<>f_num (lSheet.cells (r,3).Value) OR f_num (dw_list.object.preclose [lRow])<>f_num (dec (lSheet.cells (r,3).Value) - dec (lSheet.cells (r,4).Value))  Then
         dw_list.object.bigo [lRow] = f_ntrim (dec (dw_list.object.CLOSE [lRow]),15,2) + ' --> ' + f_ntrim (dec (lSheet.cells (r,3).Value),13,2)
         dw_list.object.CLOSE [lRow] = dec (lSheet.cells (r,3).Value)
         dw_list.object.preclose [lRow] = dec (lSheet.cells (r,3).Value) - dec (lSheet.cells (r,4).Value)
         dw_list.object.change [lRow] = dec (lSheet.cells (r,4).Value)
         dw_list.object.spot_price [lRow] = dec (lSheet.cells (r,8).Value)
         dw_list.object.calc_price [lRow] = dec (lSheet.cells (r,9).Value)
         dw_list.object.volume [lRow] = dec (lSheet.cells (r,10).Value)
         dw_list.object.value [lRow] = dec (lSheet.cells (r,11).Value)
      Else
         dw_list.object.bigo [lRow] = '종가 변동이 없습니다.'
      End IF
   End IF
LOOP
st_count.visible = false

f_messageBox ('INFO', '엑셀에서 종가 IMPORT를 완료 했습니다.')

// clean up
obj_excel.DisConnectObject ()
DESTROY obj_excel
end event

