forward
global type w_ja036j1 from wt_list
end type
type cb_load from pf_u_commandbutton within w_ja036j1
end type
type cb_load2 from pf_u_commandbutton within w_ja036j1
end type
type cb_paste from pf_u_commandbutton within w_ja036j1
end type
end forward

global type w_ja036j1 from wt_list
cb_load cb_load
cb_load2 cb_load2
cb_paste cb_paste
end type
global w_ja036j1 w_ja036j1

type variables
STRING	ls_title, ls_pathname, ls_filename
BOOLEAN	ib_phase52

end variables

forward prototypes
public function string uf_ymdformat (string as_ymd)
end prototypes

public function string uf_ymdformat (string as_ymd);STRING	ls_ymd

IF POS (as_ymd, '-')>0 THEN
   ls_ymd = LEFT (f_replace (as_ymd,'-',''),8)
ElseIF POS (as_ymd, '.')>0 THEN
   ls_ymd = LEFT (f_replace (as_ymd,'.',''),8)
ElseIF POS (as_ymd, '/')>0 THEN
   ls_ymd = LEFT (f_replace (as_ymd,'/',''),8)
Else
   RETURN ls_ymd
End IF

RETURN ls_ymd
end function

on w_ja036j1.create
int iCurrent
call super::create
this.cb_load=create cb_load
this.cb_load2=create cb_load2
this.cb_paste=create cb_paste
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_load
this.Control[iCurrent+2]=this.cb_load2
this.Control[iCurrent+3]=this.cb_paste
end on

on w_ja036j1.destroy
call super::destroy
destroy(this.cb_load)
destroy(this.cb_load2)
destroy(this.cb_paste)
end on

event wue_retrieve;call super::wue_retrieve;cb_load.of_setEnabled(FALSE)
cb_paste.of_setEnabled(FALSE)
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_clear;call super::wue_clear;cb_load.of_setEnabled(TRUE)
cb_paste.of_setEnabled(TRUE)
end event

event open;icmdbutton = { cb_load, cb_load2, cb_paste }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja036j1
end type

type ln_templeft from wt_list`ln_templeft within w_ja036j1
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja036j1
end type

type ln_temptop from wt_list`ln_temptop within w_ja036j1
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja036j1
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja036j1
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja036j1
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja036j1
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja036j1
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja036j1
end type

type ln_tempright from wt_list`ln_tempright within w_ja036j1
end type

type uo_navi from wt_list`uo_navi within w_ja036j1
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja036j1
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja036j1
end type

type st_top_rect from wt_list`st_top_rect within w_ja036j1
end type

type p_close from wt_list`p_close within w_ja036j1
end type

type p_excel from wt_list`p_excel within w_ja036j1
end type

type p_print from wt_list`p_print within w_ja036j1
end type

type p_delete from wt_list`p_delete within w_ja036j1
end type

type p_update from wt_list`p_update within w_ja036j1
end type

type p_input from wt_list`p_input within w_ja036j1
end type

type p_retrieve from wt_list`p_retrieve within w_ja036j1
end type

type p_clear from wt_list`p_clear within w_ja036j1
end type

type p_copy from wt_list`p_copy within w_ja036j1
end type

type dw_c from wt_list`dw_c within w_ja036j1
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;IF Object.ymd [1]>=uf_initdate ('inputdate') OR gaa.admin THEN ib_manageData = TRUE ELSE ib_manageData = FALSE
RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja036j1
end type

type st_count from wt_list`st_count within w_ja036j1
end type

type dw_list from wt_list`dw_list within w_ja036j1
string dataobject = "d_ja036j1"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('ymd', string (dw_c.object.ymd [1]))

POST SetColumn ('yj_cd')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
Object.load_time [row] = f_sysdate ('')
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

type cb_load from pf_u_commandbutton within w_ja036j1
integer x = 2231
integer y = 16
integer width = 411
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "UPLOAD"
end type

event clicked;OLEObject   xlApp, lSheet

DateTime ldt_ymd

STRING	ls_jm_cd

DEC	ldc_jonga

LONG	ll, ll_cell, la_col []

ldt_ymd = dw_c.object.ymd [1]

IF f_messageBox ('I002',string (ldt_ymd,'yyyy.mm.dd')+'일 해외주식 종가를 LOAD 하시겠습니까?')=2 THEN RETURN

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

// Connect to Excel and check the return code
IF xlApp.ConnectToObject ("", "Excel.Application")<>0 Then  // 현재 실행되어 있는 엑셀 Connect
   f_messageBox ('XLS1', 'LOAD할 자료를 엑셀로 읽어 들이십시오.')
   RETURN
End IF

// Make Excel visible
xlApp.Application.Visible = TRUE
xlApp.Application.ScreenUpdating = TRUE
lSheet = xlApp.Application.ActiveSheet
ll_cell = lSheet.Cells (65536, 3).End (3).Row // Cell 최종 자료위치

FOR  ll = 1  TO  20
   CHOOSE CASE string (lSheet.cells (1,ll).Value)
      CASE '종목명'
         la_col [1] = ll
      CASE '현재가'
         la_col [2] = ll
      CASE '연결종목'
         la_col [3] = ll
   END CHOOSE
NEXT

st_count.visible = true
FOR  ll = 2  TO  ll_cell
   ldc_jonga = f_num (lSheet.cells (ll,la_col [2]).Value)
   ls_jm_cd = MID (TRIM (string (lSheet.cells (ll,la_col [3]).Value)),4)

   SELECT  jm_cd
     INTO  :ls_jm_cd
   FROM    sym0ya t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.jm_cd   = :ls_jm_cd;
   IF SQLCA.sqlcode ()=0   Then
	  ls_jm_cd = SQLCA.getitemstring (1)
      UPDATE  syt0lp
         SET  jonga     = :ldc_jonga
            , load_time = sysdate
      WHERE   corp_gr = :gaa.corp_gr
        AND   jm_cd   = :ls_jm_cd
        AND   ymd     = :ldt_ymd;
      IF SQLCA.sqlnrows()=0  Then
         INSERT INTO  syt0lp
         VALUES ( :gaa.corp_gr                             /* _1:운용(자문)사 */
                , :ldt_ymd                                   /* _2:금융기준일자 */
                , :ls_jm_cd                                  /* _3:종목코드 */
                , :ldc_jonga                                 /* _4:(액면)종가 */
                , 0                                          /* _5:단가 */
                , sysdate                                    /* _6: */
                , NULL                                       /* _7: */
                , 0                                          /* _8: */
                , NULL                                       /* _9: */
                , 0                                          /* _10: */
                , 0                                          /* _11: */
                , NULL                                       /* _12: */
                , NULL                                       /* _13: */
                , NULL                                       /* _14: */
                );
         IF SQLCA.SQLCode()<>0 THEN MessageBox ('syt0lp INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())//' '+string (ldc_jonga)+' '+string (ldt_ymd)+' '+ls_jm_cd)
      End IF
   Else
      f_messageBox ('ERR', ls_jm_cd+' 종목을 확인하십시오.')
   End IF
   f_st_count (st_count, ls_jm_cd + ' : ', ll, ll_cell)
NEXT

UPDATE  link_gr
   SET  syt0lp = sysdate
WHERE   corp_gr IN ( select copr_gr
                       from szx0aa ta
                     where  ta.data_file != 'KSD');

st_count.visible = false
commitJ ()

DESTROY lSheet
DESTROY xlApp

f_messageBox ('INFO', string (ldt_ymd,'yyyy.mm.dd')+'일 종가를 LOAD를 완료 했습니다.')

p_retrieve.POST EVENT clicked ()
end event

type cb_load2 from pf_u_commandbutton within w_ja036j1
boolean visible = false
integer x = 2656
integer y = 16
integer width = 475
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "과거자료LOAD"
end type

event clicked;// 종가 과거자료 엑셀 LOAD

OLEObject   xlApp, lSheet

DateTime ldt_ymd

STRING	la_jm_cd [20]

DEC	ldc_jonga

LONG	ll, lm, ll_col

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

// Connect to Excel and check the return code
IF xlApp.ConnectToObject ("", "excel.application")<0  Then  // 현재 실행되어 있는 엑셀 Connect
   f_messageBox ('XLS1', 'LOAD할 자료를 엑셀로 읽어 들이십시오.')
   RETURN
End IF

// Make Excel visible
xlApp.Application.Visible = TRUE
xlApp.Application.ScreenUpdating = TRUE

lSheet = xlApp.Application.ActiveSheet
ll_col = lSheet.UsedRange.Columns.Count
FOR  lm = 2  TO  2
   la_jm_cd [lm] = TRIM (string (lSheet.cells (1, lm).Value))
NEXT

st_count.visible = true
FOR  ll = 2  TO  100
   f_st_count (st_count, '', ll, 100)

   ldt_ymd = datetime (date (TRIM (string (lSheet.cells (ll, 1).Value))))
   FOR  lm = 2  TO  2
      ldc_jonga = dec (f_ntrim (lSheet.cells (ll, lm).Value,0,2))

      UPDATE  syt0lp
         SET  jonga = :ldc_jonga
      WHERE   corp_gr = :gaa.corp_gr
        AND   jm_cd   = :la_jm_cd[lm]
        AND   ymd     = :ldt_ymd;
      IF SQLCA.sqlcode ()<>0  Then
         messagebox (string (ldt_ymd,'yyyy.mm.dd')+'('+la_jm_cd [lm]+')'+f_ntrim (ldc_jonga,0,2), string (SQLCA.SQLCode())+'~r~n'+SQLCA.sqlerrtext())
         ::Clipboard (SQLCA.sqlerrtext())
         EXIT
      End IF
   NEXT
   IF SQLCA.sqlcode ()<>0 THEN EXIT
NEXT
st_count.visible = false
commitJ ()

DESTROY lSheet
DESTROY xlApp
end event

type cb_paste from pf_u_commandbutton within w_ja036j1
integer x = 3145
integer y = 16
integer width = 411
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "붙여넣기"
end type

event clicked;Datetime	ldt_ymd

LONG	ll, ll_count, ll_last

STRING	ls_clipboard, la_row[], la_data[], ls_jm_nm, ls_jm_cd

DEC	ldc_jonga

ls_clipboard = TRIM (ClipBoard ())
IF f_null (ls_clipboard) THEN RETURN

ldt_ymd = dw_c.object.ymd [1]

st_count.visible = true
ll_count = f_get_array (ls_clipboard, '~r~n', la_row)
FOR  ll = 1  TO  ll_count
   ll_last = f_get_array (la_row [ll], '~t', la_data)
   IF ll_last<10 THEN EXIT

   ls_jm_nm = la_data [2]
   IF f_null (ls_jm_nm) THEN EXIT
   ls_jm_cd = MID (la_data [ll_last],4)
   ldc_jonga = f_num (la_data [4])

   SELECT  jm_cd
     INTO  :ls_jm_cd
   FROM    sym0ya t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.jm_cd   = :ls_jm_cd;
   IF SQLCA.sqlcode ()=0   Then
	  ls_jm_cd = SQLCA.getitemstring (1)
      UPDATE  syt0lp
         SET  jonga     = :ldc_jonga
            , load_time = sysdate
      WHERE   corp_gr = :gaa.corp_gr
        AND   jm_cd   = :ls_jm_cd
        AND   ymd     = :ldt_ymd;
      IF SQLCA.sqlnrows()=0  Then
            INSERT INTO  syt0lp
            VALUES ( :gaa.corp_gr                             /* _1:운용(자문)사 */
                   , :ldt_ymd                                   /* _2:금융기준일자 */
                   , :ls_jm_cd                                  /* _3:종목코드 */
                   , :ldc_jonga                                 /* _4:(액면)종가 */
                   , 0                                          /* _5:단가 */
                   , sysdate                                    /* _6: */
                   , NULL                                       /* _7: */
                   , 0                                          /* _8: */
                   , NULL                                       /* _9: */
                   , 0                                          /* _10: */
                   , 0                                          /* _11: */
                   );
         IF SQLCA.SQLCode()<>0 THEN MessageBox ('syt0lp INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())
      End IF
   Else
      f_messageBox ('ERR', ls_jm_nm+' 종목을 확인하십시오.')
   End IF
   f_st_count (st_count, ls_jm_cd+ls_jm_nm + ' : ', ll, ll_count)
NEXT

UPDATE  link_gr
   SET  syt0lp = sysdate
WHERE   corp_gr IN ( select copr_gr
                       from szx0aa ta
                     where  ta.data_file != 'KSD');

st_count.visible = false
commitJ ()

f_messageBox ('INFO', string (ldt_ymd,'yyyy.mm.dd')+'일 종가를 LOAD를 완료 했습니다.')

p_retrieve.POST EVENT clicked ()
end event

