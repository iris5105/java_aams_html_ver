forward
global type w_ja036j2 from wt_vertdetail
end type
type cb_2 from pf_u_commandbutton within w_ja036j2
end type
type cb_kfs from pf_u_commandbutton within w_ja036j2
end type
type dw_xls from fw_u_dwo within w_ja036j2
end type
type cb_1 from pf_u_commandbutton within w_ja036j2
end type
end forward

global type w_ja036j2 from wt_vertdetail
boolean eb_direct_retrieve = true
cb_2 cb_2
cb_kfs cb_kfs
dw_xls dw_xls
cb_1 cb_1
end type
global w_ja036j2 w_ja036j2

type variables

end variables

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (dw_c.object.ymd [1])
end event

on w_ja036j2.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_kfs=create cb_kfs
this.dw_xls=create dw_xls
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_kfs
this.Control[iCurrent+3]=this.dw_xls
this.Control[iCurrent+4]=this.cb_1
end on

on w_ja036j2.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_kfs)
destroy(this.dw_xls)
destroy(this.cb_1)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event open;icmdbutton = { cb_2, cb_kfs }
IF	NOT gaa.admin THEN cb_kfs.of_setvisible (false)
call super::open
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja036j2
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja036j2
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja036j2
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja036j2
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja036j2
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja036j2
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja036j2
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja036j2
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja036j2
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja036j2
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja036j2
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja036j2
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja036j2
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja036j2
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja036j2
end type

type p_close from wt_vertdetail`p_close within w_ja036j2
end type

type p_excel from wt_vertdetail`p_excel within w_ja036j2
end type

type p_print from wt_vertdetail`p_print within w_ja036j2
end type

type p_delete from wt_vertdetail`p_delete within w_ja036j2
end type

type p_update from wt_vertdetail`p_update within w_ja036j2
end type

type p_input from wt_vertdetail`p_input within w_ja036j2
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja036j2
end type

type p_clear from wt_vertdetail`p_clear within w_ja036j2
end type

type p_copy from wt_vertdetail`p_copy within w_ja036j2
end type

type dw_c from wt_vertdetail`dw_c within w_ja036j2
string title = "기준일자"
string dataobject = "dc_ymd"
end type

event dw_c::constructor;DATETIME	ldt

SELECT MAX (gijun_ymd)
  INTO :ldt
  FROM SYX0HY t1
 WHERE gijun_ymd >= ADD_MONTHS(:idt_workdate,-1) ;
ldt = SQLCA.getitemdatetime (1)

TAG = '최종 UpLoad 일 : ' + STRING (ldt, 'yyyy.mm.dd')

call super::constructor
end event

type btn_update from wt_vertdetail`btn_update within w_ja036j2
end type

type st_count from wt_vertdetail`st_count within w_ja036j2
end type

type dw_list from wt_vertdetail`dw_list within w_ja036j2
string dataobject = "d_ja036j2a"
boolean eb_copy_false = true
end type

event dw_list::updateend;call super::updateend;DateTime  ldt

ldt = f_sysdate ('')

UPDATE  szx0dt
   SET  exchange_dt = :ldt
WHERE   corp_gr = :gaa.corp_gr;

dw_c.object.tag_Text.text = '최종 UpLoad 일시 : ' + string (ldt,'yyyy.mm.dd HH:mm:ss')
end event

event dw_list::ue_delete;RETURN u_dw::EVENT ue_delete ()
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('gijun_ymd', string (dw_c.object.ymd [1]))

POST SetColumn ('currency')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'gijun_rt'
      Object.trans_rt [row] = dec (data)
END CHOOSE
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja036j2
string dataobject = "d_ja036j2b"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_c.object.ymd [1], dw_list.object.currency [iRow])
end event

type st_move from wt_vertdetail`st_move within w_ja036j2
end type

type cb_2 from pf_u_commandbutton within w_ja036j2
integer x = 2231
integer y = 16
integer width = 430
integer taborder = 60
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "UPLOAD"
end type

event clicked;DATETIME	ldt

LONG	ll_ret, lRC, r = 3

STRING	ls_path, ls_fname, ls_cur, ls_cross_cur, ls_rowid

DEC	ldc_cross_rate, ldc_gijun_rt

OLEOBJECT  obj_excel, lSheet

ldt = dw_c.object.ymd [1]
// IF ldt<>idt_workdate Then
//   f_messageBox ('ERR','LOAD 할 환율 일자를 확인하십시오.')
//   RETURN
// End IF

dw_List.reset ()

IF GetFileOpenName ("환율 파일 선택", ls_path, ls_fname, 'XLS', "All Files (*.*),*.*", gaa.excel, 2)<>1 THEN RETURN

f_MicroHelp ('환율 자료 업로드 중...')

obj_excel = CREATE OLEOBJECT
ll_ret    = obj_excel.ConnectToNewObject ("excel.application")
IF ll_ret < 0  Then
   F_MESSAGEBOX ('XLS1', STRING (ll_ret))
   RETURN
END IF

obj_excel.Application.VISIBLE = TRUE
obj_excel.windowstate         = 1
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE)// 엑셀 읽기전용으로 열기

lSheet = obj_excel.Application.ActiveSheet
lRC    = lSheet.UsedRange.Rows.COUNT

st_count.VISIBLE = true
DO WHILE TRUE
   r ++
   IF lRC<r THEN EXIT
   f_st_count (st_count, ls_path + ' : ', r, lRC)

   ls_cur         = TRIM (STRING (lSheet.cells (r, 2).VALUE))
   ldc_cross_rate = dec (lSheet.cells (r, 3).VALUE)
   ls_cross_cur   = TRIM (STRING (lSheet.cells (r, 4).VALUE))
   ldc_gijun_rt   = dec (lSheet.cells (r, 5).VALUE)

   SELECT rowidtochar(ROWID)
     INTO :ls_rowid
     FROM SYX0HY t1
    WHERE t1.gijun_ymd = :ldt
      AND t1.currency  = :ls_cur ;
   IF SQLCA.sqlcode () = 0 Then
      ls_rowid = SQLCA.GETITEMSTRING (1)
      UPDATE SYX0HY
         SET gijun_rt        = :ldc_gijun_rt
           , trans_rt        = :ldc_gijun_rt
           , cross_rate      = :ldc_cross_rate
           , cross_currency  = :ls_cross_cur
           , ip_ymd          = sysdate
       WHERE ROWID = :ls_rowid ;
   ELSE
      INSERT INTO SYX0HY
      VALUES ( :ldt
             , :ls_cur
             , :ldc_gijun_rt
             , :ldc_gijun_rt
             , sysdate
             , :ldc_cross_rate
             , :ls_cross_cur
             ) ;
   END IF
LOOP

st_count.VISIBLE = false
commitJ ()

DESTROY lSheet
// obj_excel.Application.QUIT

DESTROY obj_excel

F_MESSAGEBOX ('INFO', '해외 환율LOAD를 완료 했습니다.')

Parent.EVENT wue_retrieve ()
end event

type cb_kfs from pf_u_commandbutton within w_ja036j2
integer x = 2674
integer y = 16
integer width = 457
integer taborder = 70
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "환율(KFS)"
end type

event clicked;aDS_jTier   lds_jtier

STRING	ls_sqlsyntax, ls_kap

DATETIME	ldt_f

 SELECT F_OPEN_YMD (MAX(gijun_ymd), '-2')
   INTO :ldt_f
   FROM SYX0HY t1
  WHERE gijun_rt > 0
    AND trans_rt > 0 ;

ldt_f = SQLCA.getitemdatetime (1)

DELETE FROM SYX0HY_LOAD;
commitJ ()

setJtier ('DBNAME', 'icam_main')
IF setJtier('URL', 'http://183.96.184.1:15700/jtier?') > 0  Then
   ls_sqlsyntax = " SELECT * " + &
                  "   FROM SYX0HY f1 " + &
                  "  WHERE gijun_ymd Between '" + string (ldt_f,'yyyymmdd') + "' AND '" + string (idt_workdate,'yyyymmdd') + "' "

   SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
   ls_kap = 'c:\temp\SYX0HY_LOAD(' + STRING (idt_workdate,'mmdd') + ').txt'
   lds_jtier.SaveAs (ls_kap, Text!, TRUE, EncodingUTF16LE!)
END IF

f_jtier_connect ()

IF FileExists (ls_kap)  Then
   dw_xls.dataobject = 'd_syx0hy_load'
   dw_xls.SETTRANSOBJECT (SQLCA)
   dw_xls.reset ()
   dw_xls.importfile (ls_kap, 2)
   dw_xls.UPDATE ()
END IF

DEC	ldc_kap

DELETE FROM SYX0HY
 WHERE gijun_ymd IN (SELECT gijun_ymd FROM SYX0HY_LOAD h1) ;

INSERT INTO SYX0HY
  SELECT * FROM SYX0HY_LOAD h1 ;

ldc_kap = SQLCA.sqlnrows ()

commitJ ()

F_MESSAGEBOX ('INFO', '환율(' + f_n#(ldc_kap, 0, 0) + ' 건) LOAD를 완료했습니다.')
end event

type dw_xls from fw_u_dwo within w_ja036j2
boolean visible = false
integer x = 2894
integer y = 664
integer width = 2903
integer height = 1704
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_syx0hy_load"
boolean livescroll = false
end type

type cb_1 from pf_u_commandbutton within w_ja036j2
integer x = 3159
integer y = 12
integer width = 457
integer taborder = 70
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "환율(KFS)"
end type

event clicked;aDS_jTier   lds_jtier

STRING	ls_sqlsyntax, ls_kap

DATETIME	ldt_f

setJtier ('DBNAME', 'icam_main')
IF setJtier('URL', 'http://183.96.184.1:15700/jtier?') > 0  Then
   ls_sqlsyntax = " SELECT * " + &
                  "   FROM  fw_pgm_mst " 

   SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
   ls_kap = 'c:\temp\FW_PGM_MST.txt'
   lds_jtier.SaveAs (ls_kap, Text!, TRUE, EncodingUTF16LE!)
END IF

commitJ ()

end event

