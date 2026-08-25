forward
global type w_fx_rep from wt_vertdetail
end type
type cb_excel from pf_u_commandbutton within w_fx_rep
end type
type cb_run from pf_u_commandbutton within w_fx_rep
end type
end forward

global type w_fx_rep from wt_vertdetail
cb_excel cb_excel
cb_run cb_run
end type
global w_fx_rep w_fx_rep

type variables
LONG	ii_detail_count
end variables

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_fx_rep.create
int iCurrent
call super::create
this.cb_excel=create cb_excel
this.cb_run=create cb_run
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_excel
this.Control[iCurrent+2]=this.cb_run
end on

on w_fx_rep.destroy
call super::destroy
destroy(this.cb_excel)
destroy(this.cb_run)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = f_gijunga_ymd ('-')
end event

event wue_clear;call super::wue_clear;cb_run.of_setenabled (FALSE)
cb_excel.of_setenabled (FALSE)
end event

event open;icmdbutton = { cb_run, cb_excel }
call super::open
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_fx_rep
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_fx_rep
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_fx_rep
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_fx_rep
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_fx_rep
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_fx_rep
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_fx_rep
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_fx_rep
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_fx_rep
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_fx_rep
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_fx_rep
end type

type uo_navi from wt_vertdetail`uo_navi within w_fx_rep
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_fx_rep
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_fx_rep
end type

type p_close from wt_vertdetail`p_close within w_fx_rep
end type

type p_excel from wt_vertdetail`p_excel within w_fx_rep
end type

type p_print from wt_vertdetail`p_print within w_fx_rep
end type

type p_delete from wt_vertdetail`p_delete within w_fx_rep
end type

type p_update from wt_vertdetail`p_update within w_fx_rep
end type

type p_input from wt_vertdetail`p_input within w_fx_rep
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_fx_rep
end type

type p_clear from wt_vertdetail`p_clear within w_fx_rep
end type

type p_copy from wt_vertdetail`p_copy within w_fx_rep
end type

type dw_c from wt_vertdetail`dw_c within w_fx_rep
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertdetail`btn_update within w_fx_rep
end type

type st_count from wt_vertdetail`st_count within w_fx_rep
end type

type dw_list from wt_vertdetail`dw_list within w_fx_rep
string dataobject = "d_fx_rep"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_list::doubleclicked;str_parameter  sp
//CHOOSE CASE dwo.name
//   CASE 'cnt','per'
//      sp.str [1] = Object.layout_id [row]
//      OpenWithParm (w_popup_ksd_layout, sp)
//      RETURN
//   CASE 'data_scd'
//      sp.str [1] = Object.layout_id [row]
//      OpenWithParm (w_popup_ksd_layout, sp)
//      RETURN
//END CHOOSE
CALL SUPER::doubleclicked
end event

event dw_list::retrieveend;call super::retrieveend;cb_run.of_setenabled (TRUE)
cb_excel.of_setenabled (TRUE)
end event

type dw_detail from wt_vertdetail`dw_detail within w_fx_rep
string dataobject = "d_fx_rep_upd"
string is_receivetype = "xml"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_detail::ue_insertstart;call super::ue_insertstart;ii_detail_count ++
uf_setColumn ('ymd', string(dw_c.object.ymd [1]))
uf_setColumn ('rpt_id', dw_list.object.data_cd [iRow] + dw_list.object.data_scd [iRow])
uf_setColumn ('seq', string (ii_detail_count))
uf_setcolumn ('ip_user', gnv_vari.is_user_id)

POST SetColumn ('seq')

RETURN 0
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;STRING	ls_tr_code, ls_select, ls_header, ls_format, ls_len, ls_layout_id, ls_edit, ls_updatetable
STRING	ls_keycolumn, ls_updatecolumn

LONG	ll_syntax_count

str_dw_base	ldw

ls_tr_code = dw_List.object.data_cd [iRow] + dw_List.object.data_scd [iRow]
ls_layout_id = dw_list.object.layout_id [iRow]

SELECT  sql_select
      , setupdatetable 
      , setkeycolumn 
      , setupdatecolumn 
  INTO  :ls_select
      , :ls_updatetable
		, :ls_keycolumn
		, :ls_updatecolumn
FROM    ksd_sql t1
WHERE   tr_code = :ls_tr_code;

ls_select       = SQLCA.getitemstring (1)
ls_updatetable  = SQLCA.getitemstring (2)
ls_keycolumn    = SQLCA.getitemstring (3)
ls_updatecolumn = SQLCA.getitemstring (4)
ls_select = f_replace (ls_select, 'SELECT', 'SELECT rowid,')

ls_select += " FROM zzexcel WHERE corp_gr = '" + gaa.corp_gr + "' and ymd = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and rpt_id = '" + ls_tr_code + "' ORDER BY seq"

SELECT  LISTAGG (col_nm,'|') WITHIN GROUP (ORDER BY t1.col_seq)
      , LISTAGG (nvl(col_format,' '),'|') WITHIN GROUP (ORDER BY t1.col_seq)
      , LISTAGG (nvl(col_len,0),'|') WITHIN GROUP (ORDER BY t1.col_seq)
      , LISTAGG (CASE WHEN substr (nvl(col_id2,''), 1, 3)='xx_' THEN '0' ELSE '1' END,'|') WITHIN GROUP (ORDER BY t1.col_seq)
  INTO  :ls_header
      , :ls_format
      , :ls_len
      , :ls_edit
FROM    ksd_layout t1
WHERE   t1.layout_id = :ls_layout_id;

ls_header = 'rowid|corp_gr|ymd|rpt_id|^순번|ip_user|ip_ymd|' + SQLCA.getitemstring (1)
ls_format = ' | | | | | | |' + SQLCA.getitemstring (2)
ls_len    = '-1|-1|-1|-1|2|-1|-1|' + SQLCA.getitemstring (3)
ls_edit   = '0|0|0|0|1|0|0|' + SQLCA.getitemstring (4)

f_get_array (ls_header, '|', ldw.header_text)
f_get_array (ls_format, '|', ldw.column_format)
f_get_array (ls_len   , '|', ldw.column_width)
f_get_array (ls_edit  , '|', ldw.column_edit)

dw_detail.setupdatetable (ls_updatetable)
dw_detail.setkeycolumn (ls_keycolumn)
dw_detail.setupdatecolumn (ls_updatecolumn)

ll_syntax_count = SQLCA.SQL2DW( ls_select, dw_detail, ldw)
IF LenA (SQLCA.sqlerrtext())>0   Then
   messagebox ("sqlselect error ...", SQLCA.sqlerrtext())
   RETURN
End IF

ii_detail_count = ll_syntax_count

uf_retrieveend ('', ll_syntax_count, eb_null_line)
end event

event dw_detail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

object.ip_user [row] = gnv_vari.is_user_id
Object.ip_ymd [row] = f_sysdate ('')

RETURN 0
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;STRING	ls_id, ls_col_id, ls_col_nm, ls_cd_key

ls_col_id = UPPER (GetColumnName ())

ls_id = 'FX' + dw_List.object.data_scd [iRow]

SELECT  col_nm
      , col_cd_key
  INTO  :ls_col_nm
      , :ls_cd_key
FROM    ksd1layout t1
WHERE   layout_id = :ls_id
  AND   col_id    = :ls_col_id;
  ls_col_nm = SQLCA.getitemstring (1)
  ls_cd_key = SQLCA.getitemstring (2)

IF f_notnull (ls_cd_key)   Then
   rs_where = "gr_cd = '" + ls_cd_key + "'"
   rs_addrow = 'FENCODE' + ls_col_nm + '@' + ls_col_nm + '명'
End IF
RETURN 1 // 순번
end event

type st_move from wt_vertdetail`st_move within w_fx_rep
end type

type cb_excel from pf_u_commandbutton within w_fx_rep
integer x = 2702
integer y = 16
integer width = 649
integer taborder = 60
boolean bringtotop = true
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "외환보고(FX)->엑셀"
end type

event clicked;STRING	ls_file, ls_name, ls_col_id, ls_temp, ls_sqlsyntax

LONG	ll_list, ll_sheet, ll, lj, lm, r, c, lR

Datetime	ldt, ldt_last, ldt_open

oleobject	obj_excel, lSheet

aDS_jTier	lds_jtier

ldt = dw_c.object.ymd [1]

SELECT  LAST_DAY (:ldt)
      , f_open_ymd (last_day (:ldt), '-')
  INTO  :ldt_last
      , :ldt_open
FROM    dual;
ldt_last = SQLCA.getitemdatetime (1)
ldt_open = SQLCA.getitemdatetime (2)

obj_excel = CREATE oleobject
IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.excel  + 'FX_' + gaa.corp_gr + '(' + string (dw_c.object.ymd [1],'yyyymmdd') + ').xlsx'
IF FileExists (ls_file) Then
   IF NOT FileDelete (ls_file)   Then
      f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
      RETURN
   End IF
End IF

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.Visible = TRUE
obj_excel.Application.CutCopyMode = FALSE
obj_excel.windowstate = 3

obj_excel.workbooks.open (gnv_vari.basepath + '\fx통합.xlsx', 0, FALSE)   // 읽기전용

ll_sheet = obj_excel.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기
FOR ll = 1  TO  ll_sheet
   lSheet = obj_excel.Application.Workbooks (1).worksheets (ll)
   ls_name = lSheet.name
   lSheet.Activate

   ll_list = dw_list.FIND ("data_scd='" + MID (ls_name,3,4) + "'", 1, dw_list.rowcount ())
   IF ll_list>0   Then
      dw_list.uf_setrow (ll_list, TRUE)
		ii_detail_count = dw_detail.rowcount()

      IF NOT (ldt=ldt_last OR ldt=ldt_open) And dw_list.object.per [ll_list]='월'   Then
         // 일자료에서 월 sheet 삭제
         lSheet.Delete
         ll --
         ll_sheet --
      Else
         CHOOSE CASE dw_list.object.data_scd [ll_list]
            CASE'7600'
               FOR  lj = 1  TO  ii_detail_count
                     lSheet.cells (dw_detail.object.n02 [lj], dw_detail.object.n03 [lj]).value = string (dw_detail.object.n01 [lj])
               NEXT

            CASE '4812','5480'
               // list형이 아니므로 별도 자료 발생시 처리 예정
               IF  ii_detail_count > 0  then
                     f_messageBox ('프로그램 미반영 확인', ' 4812/5480프로그램 미개발 상태입니다(IT확인).')
               End IF
            CASE ELSE
               SELECT  NVL(max(r),2)
                 INTO  :r
               FROM    ksd1layout t1
               WHERE   t1.layout_id = :ls_name;
					r = SQLCA.getitemnumber (1)
					
               ls_sqlsyntax = " SELECT  col_id " &
                            + "       , c " &
                            + " FROM    ksd1layout " &
                            + " WHERE   layout_id = '" + ls_name + "' " &
                            + "   AND   nvl (c, 0)>0 " &
                            + " ORDER BY c "
					
					lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')
					
               FOR  lj = 1  TO  ii_detail_count
						FOR  lm = 1  TO  lR
							ls_col_id = lds_jtier.getitemString (lm, 1)
							c         = lds_jtier.getitemnumber (lm, 2)
							
							ls_temp = string (dw_detail.describe (ls_col_id + '.coltype'))
							IF POS (ls_temp, 'char')=1 Then
								ls_temp = string (dw_detail.getitemstring (lj, ls_col_id))
							ElseIF POS (ls_temp, 'number')=1	Then
								ls_temp = string (dw_detail.getitemnumber (lj, ls_col_id))
							ELseIF POS (ls_temp, 'date')=1	Then
								ls_temp = string (dw_detail.getitemdatetime (lj, ls_col_id))
							Else
								ls_temp = string (dw_detail.getitemstring (lj, ls_col_id))
							End IF
							lSheet.cells (r, c).value = ls_temp
						NEXT
                  r ++
               NEXT
         END CHOOSE
      End IF
   Else
      lSheet.Delete
   End IF
NEXT

TRY
   obj_excel.activeworkbook.SaveAS (ls_file)
   f_messageBox ('INFO', '외환보고(FX) 엑셀생성 작업이 완료 되었습니다.~r~n~r~n('+ls_file+') 에서 자료를 확인하십시오.')
CATCH (runtimeerror er)
   f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
END TRY

obj_excel.DisConnectObject ()
DESTROY obj_excel
end event

type cb_run from pf_u_commandbutton within w_fx_rep
integer x = 2231
integer y = 16
integer width = 457
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "자료생성"
end type

event clicked;STRING	w_msg, ls_sr_err_msg, la_args[]

LONG	ll, ll_list

Datetime	ldt, ldt_last, ldt_open

BOOLEAN	lb_msg=TRUE

ldt = dw_c.object.ymd [1]

SELECT  LAST_DAY (:ldt)
      , f_open_ymd (last_day (:ldt), '-')
  INTO  :ldt_last
      , :ldt_open
FROM    dual;
ldt_last = SQLCA.getitemdatetime (1)
ldt_open = SQLCA.getitemdatetime (2)

ll_list = dw_list.rowcount ()
FOR ll = 1  TO  ll_list
   dw_list.uf_setrow (ll, TRUE)
   IF NOT (ldt=ldt_last OR ldt=ldt_open) And dw_list.object.per [ll]='월'  Then
      IF lb_msg THEN f_messageBox ('INFO', '월자료는 월 마지막 영업일에만 생성')
      lb_msg = FALSE
   Else
      w_msg = SPACE (200)
      IF ii_detail_count>0 Then
         IF f_messageBox ('INFO2', '생성된 자료가 있습니다.~r~n자료를 다시 생성 하시겠습니까?')=1  Then
            la_args[1] = gaa.corp_gr
            la_args[2] = string(dw_c.object.ymd[1],'yyyymmdd')
            la_args[3] = 'SR_FX'+dw_list.object.data_scd[ll]
            la_args[4] = 'ref'
				SQLCA.singleconnection ()
            SQLCA.SP_CALL( THIS, 'SR_FX_EXEC ( ?, ?, ?, ? )', la_args[], ls_sr_err_msg )
				w_msg      = f_nvl (SQLCA.getitemplsql (1), 'N')
            IF w_msg<>'Y' THEN f_messageBox ('ERR', w_msg)
         End IF
      Else
         la_args[1] = gaa.corp_gr
         la_args[2] = string(dw_c.object.ymd[1],'yyyymmdd')
         la_args[3] = 'SR_FX'+dw_list.object.data_scd[ll]
         la_args[4] = 'ref'
			SQLCA.singleconnection ()
         SQLCA.SP_CALL( THIS, 'SR_FX_EXEC ( ?, ?, ?, ? )', la_args[], ls_sr_err_msg )
			w_msg      = f_nvl (SQLCA.getitemplsql (1), 'N')
         IF w_msg<>'Y'  Then
            f_messageBox ('ERR', w_msg)
            EXIT
         End IF
      End IF
   End IF
NEXT
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

