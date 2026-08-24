forward
global type w_ja010e from wt_list
end type
type cb_del from pf_u_commandbutton within w_ja010e
end type
type cb_load from pf_u_commandbutton within w_ja010e
end type
type cb_2 from pf_u_commandbutton within w_ja010e
end type
type cb_excel from pf_u_commandbutton within w_ja010e
end type
type cb_1 from pf_u_commandbutton within w_ja010e
end type
type cb_new from pf_u_commandbutton within w_ja010e
end type
type cb_2402 from pf_u_commandbutton within w_ja010e
end type
end forward

global type w_ja010e from wt_list
boolean eb_retrievewait = true
string is_find = "fund_cd=~'~'"
string is_init_value = "00010"
cb_del cb_del
cb_load cb_load
cb_2 cb_2
cb_excel cb_excel
cb_1 cb_1
cb_new cb_new
cb_2402 cb_2402
end type
global w_ja010e w_ja010e

type variables
str_parameter  sp

ads_jTier	ids_fund, ids_jj

LONG	il_fund, il_jj

STRING	is_tr_co_cd
end variables

forward prototypes
public subroutine wf_load ()
public subroutine wf_2203 ()
end prototypes

public subroutine wf_load ();LONG	ll, lf, ll_rowcount

STRING	ls_data = '', ls_file, ls_tr_co_cd, ls_tr_cd, ls_fund_cd, ls_jm_cd

DateTime	ldt_tr_ymd

DEC	ldc_offer_no

ldt_tr_ymd  = dw_c.object.ymd [1]
ls_tr_co_cd = dw_c.object.dddw [1]

sp.dt [1]  = ldt_tr_ymd
sp.str [1] = ls_tr_co_cd
sp.str [2] = dw_c.describe ("Evaluate('LookupDisplay(dddw)', 1)")

OpenWithParm (w_import_sjt1jg, sp)
sp = Message.PowerObjectParm

f_loadingretrieve (TRUE)

st_count.visible = true
f_st_count (st_count, 'LOAD한 자료를 저장하고 있습니다.(' + string (sp.long [1]) + ')', 0, 0)
FOR  ll = 1  TO  sp.long [1]
	IF	f_notnull (sp.str [ll])	Then
		IF	ls_data=''	Then
			ls_data = sp.str [ll]
		Else
			ls_data += '~r~n' + sp.str [ll]
		End IF
	End IF
NEXT
IF	f_notnull (ls_data)	Then
	ls_file = gaa.temp + 'w_import_load.txt'
	FileDelete (ls_file)
	lf = FILEOPEN (ls_file, TextMode!, Write!, LockWrite!, Replace!, EncodingUTF8!)
	FileWriteEX (lf, ls_data) ; FileClose (lf)
	dw_list.reset ()
	dw_list.setredraw (false)
	ll_rowcount = dw_list.importfile (ls_file, 1)
	FOR  ll = ll_rowcount  TO  1  STEP -1
		ls_tr_cd     = dw_list.object.tr_cd [ll]
		ls_fund_cd   = dw_list.object.fund_cd [ll]
		ls_jm_cd     = dw_list.object.xx_jm_cd [ll]
		ldc_offer_no = dw_list.object.offer_no [ll]

		SELECT  rowidtochar (rowid)
		  INTO  :ls_data
		FROM    sjt1jg
		WHERE   corp_gr  = :gaa.corp_gr
		  AND   tr_ymd   = :ldt_tr_ymd
		  AND   tr_cd    = :ls_tr_cd
		  AND   fund_cd  = :ls_fund_cd
		  AND   jm_cd    = :ls_jm_cd
		  AND   tr_co_cd = :ls_tr_co_cd
		  AND   offer_no = :ldc_offer_no;
		IF	SQLCA.sqlcode ()=0	Then
			f_st_count (st_count, 'LOAD한 자료 저장중 중복자료~r~n삭제 : ' + ls_fund_cd + ' ' + ls_jm_cd, 0, 0)
			dw_list.deleterow (ll)
		Else
			EXIT
		End IF
	NEXT
	dw_list.update ()
	st_count.visible = false
	p_retrieve.postevent ('clicked')
End IF

f_loadingretrieve (FALSE)
end subroutine

public subroutine wf_2203 ();OLEObject  obj_excel, lSheet

LONG	ret, ll, ll_rowcount

STRING	ls_path, ls_name
STRING	ls_acct_no, ls_db_no = '!@#$', ls_fund_cd, ls_jm_cd

DateTime ldt

DEC	ldc_jusu, ldc_danga, ldc_aek, ldc_siga

obj_excel = CREATE OLEObject

ldt = dw_c.object.ymd [1]

IF GetFileOpenName ("주식잔고 엑셀파일 선택", ls_path, ls_name, 'XLS', "Excel Files (*.xls;*.xlsx;*.csv),*.xls;*.xlsx;*.csv", gaa.excel, 2)<>1 THEN RETURN

ret = obj_excel.ConnectToNewObject ("excel.application")
IF ret<0 Then
   f_messageBox ('XLS1', string(ret))
   RETURN
End IF
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기
obj_excel.windowstate = 2

//ll_sheet = obj_excel.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기
lSheet = obj_excel.Application.Workbooks (1).worksheets (1)
lSheet.Activate

st_count.visible = TRUE
f_st_count (st_count, '주식잔고를 점검하고 있습니다.', 0, 0)

ll_rowcount = lSheet.UsedRange.Rows.Count
FOR ll = 3  TO  ll_rowcount  STEP 2
   IF ll>ll_rowcount THEN EXIT
   ls_acct_no = string(lSheet.cells(ll + 1,4).Value)
   ls_jm_cd   = string(lSheet.cells(ll,7).Value)
   ldc_jusu   = dec(lSheet.cells(ll,8).Value)
   ldc_danga  = dec(lSheet.cells(ll + 1,8).Value)
   ldc_aek    = dec(lSheet.cells(ll,9).Value)
   ldc_siga   = dec(lSheet.cells(ll + 1,10).Value)

   f_st_count (st_count, ls_jm_cd, ll, ll_rowcount)

   IF ls_db_no<>ls_acct_no Then
      SELECT fund_cd
        INTO :ls_fund_cd
      FROM   szm0ia ia
      WHERE  ia.corp_gr = :gaa.corp_gr
        AND  REPLACE(to_decrypts (enc_acct_no), '-') = :ls_acct_no;
      IF SQLCA.sqlcode ()<>0 THEN CONTINUE

      ls_fund_cd = SQLCA.getitemstring (1)
      ls_db_no   = ls_acct_no
   End IF

   INSERT INTO SJM0JM_MAP
   VALUES ( :gaa.corp_gr    /* _1: */
          , :ldt            /* _2: */
          , :ls_fund_cd     /* _3: */
          , :ls_jm_cd       /* _4: */
          , :ldc_jusu       /* _5: */
          , :ldc_aek        /* _6: */
          , :ldc_siga       /* _7: */
          );
NEXT
commitJ ()
st_count.visible = FALSE

obj_excel.DisConnectObject ()
DESTROY obj_excel

ChangeDirectory (gnv_vari.basepath)
f_messageBox ('INFO', '점검용 주식잔고 생성(SJM0JM_MAP)이 완료되었습니다.')
end subroutine

on w_ja010e.create
int iCurrent
call super::create
this.cb_del=create cb_del
this.cb_load=create cb_load
this.cb_2=create cb_2
this.cb_excel=create cb_excel
this.cb_1=create cb_1
this.cb_new=create cb_new
this.cb_2402=create cb_2402
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_del
this.Control[iCurrent+2]=this.cb_load
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_excel
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_new
this.Control[iCurrent+7]=this.cb_2402
end on

on w_ja010e.destroy
call super::destroy
destroy(this.cb_del)
destroy(this.cb_load)
destroy(this.cb_2)
destroy(this.cb_excel)
destroy(this.cb_1)
destroy(this.cb_new)
destroy(this.cb_2402)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
CHOOSE CASE gaa.corp_gr
	CASE '2201','2202'
		cb_load.enabled = (POS ('00010,00020,00030,00056',dw_c.object.dddw [1])>0)
	CASE '2203'
		cb_load.enabled = TRUE
	CASE '2402'
		IF	gaa.admin	Then
			cb_2402.visible = TRUE
			cb_2402.enabled = TRUE
		End IF
END CHOOSE
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
is_find = "fund_cd='" + gaa.fund_cd + "'"
is_tr_co_cd = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.dddw [1])
cb_load.enabled = false
end event

event wue_clear;call super::wue_clear;CHOOSE CASE gaa.corp_gr
	CASE '2201','2202'
		cb_load.enabled = (POS ('00010,00020,00030,00056',dw_c.object.dddw [1])>0)
	CASE '2203'
		cb_load.enabled = TRUE
END CHOOSE
cb_del.enabled  = TRUE
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event wue_postopen;call super::wue_postopen;ids_fund = CREATE ads_jTier
ids_jj   = CREATE ads_jTier

STRING	ls_sqlsyntax

ls_sqlsyntax = " SELECT jj_nm " + &
               "      , koscom_cd " + &
               "      , jm_cd " + &
               "      , danc_gb " + &
               " FROM   sjm0jj t1 " + &
               " WHERE  danc_gb IN ('A','C','D') "

il_jj = SQLCA.sql2ds (classname(), ls_sqlsyntax, ids_jj, 'sqlm')

ls_sqlsyntax = " SELECT REPLACE(to_decrypts (t1.enc_acct_no), '-', '') " + &
               "      , t1.mg_cd " + &
               "      , t1.fund_cd " + &
               "      , t1.enc_acct_no " + &
               " FROM   szm0ia t1 " + &
               " WHERE  t1.corp_gr = '" + gaa.corp_gr + "' " + &
               "   AND  t1.haeji_ymd is null "

il_fund = SQLCA.sql2ds (classname(), ls_sqlsyntax, ids_fund, 'sqlm')
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja010e
end type

type ln_templeft from wt_list`ln_templeft within w_ja010e
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja010e
end type

type ln_temptop from wt_list`ln_temptop within w_ja010e
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja010e
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja010e
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja010e
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja010e
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja010e
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja010e
end type

type ln_tempright from wt_list`ln_tempright within w_ja010e
end type

type uo_navi from wt_list`uo_navi within w_ja010e
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja010e
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja010e
end type

type st_top_rect from wt_list`st_top_rect within w_ja010e
end type

type p_close from wt_list`p_close within w_ja010e
end type

type p_excel from wt_list`p_excel within w_ja010e
end type

type p_print from wt_list`p_print within w_ja010e
end type

type p_delete from wt_list`p_delete within w_ja010e
end type

type p_update from wt_list`p_update within w_ja010e
end type

type p_input from wt_list`p_input within w_ja010e
end type

type p_retrieve from wt_list`p_retrieve within w_ja010e
end type

type p_clear from wt_list`p_clear within w_ja010e
end type

type p_copy from wt_list`p_copy within w_ja010e
end type

type dw_c from wt_list`dw_c within w_ja010e
string title = "매매일자@매매증권사"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | tr_co_cd', gaa.corp_gr, '%,전체,', 1, "tr_gb='1'")
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
IF dwo.name='ymd' Then
   cb_del.Enabled = (DateTime (Date (MID(data,1,10))) = idt_workdate)
End IF
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

STRING	ls_tr_co_cd

ls_tr_co_cd = Object.dddw [1]

SELECT 1
  INTO :li_ret
  FROM SJT1JG t1
 WHERE t1.corp_gr  = :gaa.corp_gr
   AND t1.tr_ymd   = :rs_ymd
   AND t1.tr_co_cd LIKE :ls_tr_co_cd
   AND ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja010e
end type

type st_count from wt_list`st_count within w_ja010e
end type

type dw_list from wt_list`dw_list within w_ja010e
string dataobject = "d_ja010e1"
boolean eb_null_line = false
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('tr_ymd', string(dw_c.object.ymd [1]))
uf_setcolumn ('susu', '0')
uf_setcolumn ('tax', '0')
IF	iRow>0	Then
	uf_setcolumn ('tr_cd', Object.tr_cd [iRow])
	uf_setcolumn ('tr_co_cd', Object.tr_co_cd [rowcount ()])
	uf_setcolumn ('offer_no', string (Object.offer_no [rowcount ()] + 1))
	IF	f_notnull (Object.fund_cd [iRow])	Then
		uf_setcolumn ('fund_cd', Object.fund_cd [iRow])
		uf_setcolumn ('xx_fund_cd', Object.xx_fund_cd [iRow])
		uf_setcolumn ('xx_acct_no', Object.xx_acct_no [iRow])
		uf_setcolumn ('enc_acct_no', Object.enc_acct_no [iRow])
	
		POST setColumn ('koscom_cd')
	Else
		POST setColumn ('fund_cd')
	End IF
Else
	uf_setcolumn ('offer_no', '1')
	uf_setcolumn ('tr_cd', 'J')
	uf_setcolumn ('tr_co_cd', is_tr_co_cd)
	POST setColumn ('fund_cd')
End IF
IF	dw_c.object.ymd [1]<idt_workdate THEN uf_setcolumn ('sudo_ymd', string (dw_c.object.ymd [1]))

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'koscom_cd'
      rs_where = "danc_gb in ('A','B','C','D','G') And jj_nm NOT LIKE '%공모%'"
   CASE 'fund_cd'
		IF	dw_c.object.dddw [1]='%'	Then
	      rs_where = "mg_cd like '%'"
		Else
	      rs_where = "mg_cd='" + dw_c.object.dddw [1] + "'"
		End IF
END CHOOSE
RETURN 1
end event

event dw_list::itemchanged_next;call super::itemchanged_next;DateTime ldt_ymd

STRING	ls_fund_cd, ls_acct, ls_enc_acct, ls_koscom

DEC	ldc_prc

ldt_ymd = dw_c.object.ymd [1]

CHOOSE CASE name
   CASE 'fund_cd'
      ls_fund_cd = Object.fund_cd [row]

      SELECT TO_DECRYPTS (enc_acct_no)
           , enc_acct_no
			  , mg_cd
        INTO :ls_acct
           , :ls_enc_acct
			  , :is_tr_co_cd
      FROM   szm0ia t1
      WHERE  t1.corp_gr = :gaa.corp_gr
        AND  t1.fund_cd = :ls_fund_cd;

      Object.xx_acct_no [row]  = SQLCA.getitemstring (1)
      Object.enc_acct_no [row] = SQLCA.getitemstring (2)
      is_tr_co_cd = SQLCA.getitemstring (3)
      Object.load_time  [row]  = f_sysdate ('')
		Object.tr_co_cd [row] = is_tr_co_cd

		IF	dw_c.object.ymd [1]<idt_workdate THEN Object.sudo_ymd [row] = dw_c.object.ymd [1]

	CASE 'danga'
		Object.tr_aek [row] = Object.tr_jusu [row] * Object.danga [row]

	CASE 'koscom_cd','tr_jusu'
      IF Object.tr_cd [row]='F'  Then
         ls_koscom = Object.koscom_cd [row]

         SELECT close
           INTO :ldc_prc
         FROM   sjt0tg t1
         WHERE  corp_gr = :gaa.corp_gr
			and ymd = f_open_ymd(:ldt_ymd, '-1')
           AND  koscom_cd = :ls_koscom;
         IF SQLCA.sqlcode ()=0   Then
            Object.danga [row] = SQLCA.getitemnumber (1)
            Object.tr_aek [row] = Object.tr_jusu [row] * SQLCA.getitemnumber (1)
			Else
				SELECT close
				  INTO :ldc_prc
				FROM   sjt1tg t1
				WHERE  ymd = f_open_ymd(:ldt_ymd, '-1')
				  AND  koscom_cd = :ls_koscom;
				IF SQLCA.sqlcode ()=0   Then
	            Object.danga [row] = SQLCA.getitemnumber (1)
					Object.tr_aek [row] = Object.tr_jusu [row] * SQLCA.getitemnumber (1)
				End IF
         End IF

//         SELECT curr_prc
//           INTO :ldc_prc
//         FROM   fincatch_2 t1
//         WHERE  op_dt     = f_open_ymd(:ldt_ymd, '-1')
//           AND  koscom_cd = :ls_koscom;
//         IF SQLCA.sqlcode ()=0   Then
//            Object.tr_aek [row] = Object.tr_jusu [row] * SQLCA.getitemnumber (1)
//         End IF
      End IF
END CHOOSE
end event

event dw_list::retrieveend;call super::retrieveend;DEC	ll_count

STRING	ls_ymd

ls_ymd = string (dw_c.object.ymd [1], 'yyyymmdd')

IF	dw_c.object.dddw [1]='%'	Then
	SELECT count (*)
	  INTO :ll_count
	FROM   FINCATCH_1 t1
	WHERE  t1.corp_gr = :gaa.corp_gr
	  AND  op_dt      = :ls_ymd;

	ll_count = SQLCA.getitemdecimal (1)
	IF	ll_count>0 THEN messagebox ('체결', f_ntrim(ll_count,0,0) + '건 체결 자료확인')

	SELECT count (*)
	  INTO :ll_count
	FROM   FINCATCH_2 t1
	WHERE  op_dt = :ls_ymd;

	ll_count = SQLCA.getitemdecimal (1)
	IF	ll_count>0 THEN messagebox ('종가', f_ntrim(ll_count,0,0) + '건 종가 자료확인')
End IF
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tr_co_cd', gaa.corp_gr, '', 1, '')
end event

type cb_del from pf_u_commandbutton within w_ja010e
integer x = 3058
integer y = 192
integer width = 457
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "일괄삭제"
end type

event clicked;DateTime  ldt

STRING	ls_cd

ldt = dw_c.object.ymd [1]
ls_cd = dw_c.object.dddw [1]

DELETE  sjt1jg
WHERE   corp_gr  = :gaa.corp_gr
  AND   tr_ymd   = :ldt
  AND   tr_co_cd = :ls_cd
  AND   enc_acct_no is not null;

commitJ ()

f_messageBox ('INFO', '자료가 모두 삭제되었습니다.~r~n재 LOAD 하시면 됩니다.~r~n입력한 자료는 삭제에서 제외되었습니다.')
end event

type cb_load from pf_u_commandbutton within w_ja010e
integer x = 2656
integer y = 192
integer width = 389
integer taborder = 90
boolean bringtotop = true
string text = "체결등록"
end type

event clicked;call super::clicked;CHOOSE CASE gaa.corp_gr
	CASE '2201','2202'
		IF POS ('00010,00020,00030,00056',dw_c.object.dddw [1])=0   Then
			f_messageBox ('I000', 'Load Format이 등록되어 있지않은 증권사 입니다.~r~n개발 의뢰하십시오.')
		Else
			wf_load ()
		End IF
	CASE '2203'
		wf_load ()
END CHOOSE
end event

type cb_2 from pf_u_commandbutton within w_ja010e
boolean visible = false
integer x = 4242
integer y = 188
integer width = 389
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "FTP LOAD"
end type

event clicked;call super::clicked;DEC	ldc_count

STRING	ls_date, ls_qkey, ls_ymd, ls_local, ls_file, ls_remote

ls_ymd = string (dw_c.object.ymd [1],'yyyymmdd')

SELECT count(*)
     , min(to_char(send_date,'yyyymmddhh24miss'))
  INTO :ldc_count
     , :ls_date
FROM   sftp_q t1
WHERE  SFTP_KEY LIKE 'r'||:gaa.corp_gr||:ls_ymd;

ldc_count = SQLCA.getitemdecimal (1)
ls_date   = SQLCA.getitemstring (2)

IF ldc_count>0 And ls_date<>''   Then
   IF f_messagebox ('INFO2', '체결, 종가자료를 다시 받으시겠습니까?')=2 THEN RETURN
   DELETE sftp_q
   WHERE  SFTP_KEY LIKE 'r'||:gaa.corp_gr||:ls_ymd;
End IF

ls_qkey = 'r' + gaa.corp_gr + ls_ymd + '1' + f_sysdate_str ('yyyymmddhh24miss')

ls_local = '/home/aams/recv'
ls_file = '02203_FI10001_' + ls_ymd + '.txt'
ls_remote = '/data/fincatch/' + ls_ymd

INSERT INTO sftp_q
VALUES ( :ls_qkey           /* _1: */
       , :ls_ymd            /* _2: */
       , 'r'                /* _3: */
       , '183.111.67.26'    /* _4: */
       , '22'               /* _5: */
       , 'aams'             /* _6: */
       , 'aams1!'           /* _7: */
       , :ls_local          /* _8: */
       , :ls_file           /* _9: */
       , :ls_remote         /* _10: */
       , '0'                /* _11: */
       , NULL               /* _12: */
       , NULL               /* _13: */
       , NULL               /* _14: */
       );

INSERT INTO ftp_qlog
VALUES ( :ls_qkey                                   /* _1: */
       , :gaa.corp_gr                               /* _2: */
       , TO_DATE(:ls_ymd,'yyyymmdd')                /* _3: */
       , 'SFTP'                                     /* _4: */
       , '0,0,0,0'                                  /* _5: */
       , :gnv_vari.is_user_nm                       /* _6: */
       , :gaa.corp_nm || ' 핀케치 체결자료 수신'    /* _7: */
       , :ls_file                                   /* _8: */
       , 'sjt1jg'                                   /* _9: */
       , '주문체결LOAD'                             /* _10: */
       , :gnv_vari.is_ipaddress                     /* _11: */
       );

ls_qkey = 'r' + gaa.corp_gr + ls_ymd + '2a' + f_sysdate_str ('yyyymmddhh24miss')
ls_file = '0800060000_FF10106_' + ls_ymd + '.txt'

INSERT INTO sftp_q
VALUES ( :ls_qkey           /* _1: */
       , :ls_ymd            /* _2: */
       , 'r'                /* _3: */
       , '183.111.67.26'    /* _4: */
       , '22'               /* _5: */
       , 'aams'             /* _6: */
       , 'aams1!'           /* _7: */
       , :ls_local          /* _8: */
       , :ls_file           /* _9: */
       , :ls_remote         /* _10: */
       , '0'                /* _11: */
       , NULL               /* _12: */
       , NULL               /* _13: */
       , NULL               /* _14: */
       );

ls_qkey = 'r' + gaa.corp_gr + ls_ymd + '2b' + f_sysdate_str ('yyyymmddhh24miss')
ls_file = '0800060000_FF10106_' + ls_ymd + '_type2.txt'

INSERT INTO sftp_q
VALUES ( :ls_qkey           /* _1: */
       , :ls_ymd            /* _2: */
       , 'r'                /* _3: */
       , '183.111.67.26'    /* _4: */
       , '22'               /* _5: */
       , 'aams'             /* _6: */
       , 'aams1!'           /* _7: */
       , :ls_local          /* _8: */
       , :ls_file           /* _9: */
       , :ls_remote         /* _10: */
       , '0'                /* _11: */
       , NULL               /* _12: */
       , NULL               /* _13: */
       , NULL               /* _14: */
       );

INSERT INTO ftp_qlog
VALUES ( :ls_qkey                       /* _1: */
       , :gaa.corp_gr                   /* _2: */
       , TO_DATE(:ls_ymd,'yyyymmdd')    /* _3: */
       , 'SFTP'                         /* _4: */
       , '0,0,0,0'                      /* _5: */
       , :gnv_vari.is_user_nm           /* _6: */
       , '핀케치 종가자료 수신'         /* _7: */
       , :ls_file                       /* _8: */
       , 'sjt1jg'                       /* _9: */
       , '종가자료LOAD'                 /* _10: */
       , :gnv_vari.is_ipaddress         /* _11: */
       );

commitJ ();

f_messageBox ('INFO', '핀케치 체결자료 수신 대기자료 생성을 완료했습니다.')
end event

type cb_excel from pf_u_commandbutton within w_ja010e
boolean visible = false
integer x = 4626
integer y = 196
integer width = 503
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string text = "잔고점검LOAD"
end type

event clicked;call super::clicked;CHOOSE CASE gaa.corp_gr
	CASE '2203'
		wf_2203 ()
END CHOOSE
end event

type cb_1 from pf_u_commandbutton within w_ja010e
boolean visible = false
integer x = 5170
integer y = 180
integer width = 334
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "FTP"
end type

event clicked;call super::clicked;DEC   ldc_count

STRING   ls_date, ls_qkey, ls_ymd, ls_local, ls_file, ls_remote

ls_ymd = STRING (dw_c.object.ymd [1],'yyyymmdd')

SELECT COUNT(*)
     , MIN(TO_CHAR(send_date,'yyyymmddhh24miss'))
  INTO :ldc_count
     , :ls_date
  FROM SFTP_Q t1
 WHERE SFTP_KEY LIKE 'r'||:gaa.CORP_GR||:ls_ymd ;

ldc_count = SQLCA.GETITEMDECIMAL (1)
ls_date   = SQLCA.GETITEMSTRING (2)

ls_qkey = 'r' + gaa.CORP_GR + ls_ymd + '1' + f_sysdate_str ('yyyymmddhh24miss')

ls_local  = '/home/aams/work/l_dir'
ls_file   = 'aams.txt'
ls_remote = '/work/r_dir'

INSERT INTO FTP_Q
VALUES ( :ls_qkey           /* _1- */
       , :ls_ymd            /* _2- */
       , 'r'                /* _3- */
       , '175.197.131.230'  /* _4- */
       , '21'               /* _5- */
       , 'aams'             /* _6- */
       , 'aams'             /* _7- */
       , :ls_local          /* _8- */
       , :ls_file           /* _9- */
       , :ls_remote         /* _10- */
       , '0'                /* _11- */
       , NULL               /* _12- */
       , NULL               /* _13- */
       , NULL               /* _14- */
       ) ;

commitJ ( );
end event

type cb_new from pf_u_commandbutton within w_ja010e
integer x = 2254
integer y = 192
integer width = 389
integer taborder = 40
boolean bringtotop = true
string text = "NEW체결"
end type

event clicked;call super::clicked;OLEObject   obj_1

DATETIME ldt
STRING	ls_tr_co_cd

LONG	li_num, ll_row

ldt = dw_c.object.ymd [1]
ls_tr_co_cd = dw_c.object.dddw [1]

IF POS ('00010,00020,00030',ls_tr_co_cd)=0 THEN
   F_MESSAGEBOX ('I000', 'Load Format이 등록되어 있지않은 증권사 입니다.~r~n개발 의뢰하십시오.')
   RETURN
End IF

obj_1 = CREATE oleobject
IF obj_1.ConnectToNewObject ('excel.application')<>0 THEN // 엑셀실행
   F_MESSAGEBOX ('XLS1', '')
   RETURN
End IF
obj_1.Application.displayalerts = TRUE
obj_1.Application.Visible = TRUE
obj_1.Application.ScreenUpdating = TRUE

obj_1.WorkBooks.OPEN (gaa.pbr + 'kernel\통합 문서1.xlsm', 0, TRUE)

CHOOSE CASE ls_tr_co_cd
   CASE '00010'   // NH투자증권
      obj_1.Application.Run ("'통합 문서1.xlsm'!sjt1jg_00010")
   CASE '00020'   // 미래에셋증권
      obj_1.Application.Run ("'통합 문서1.xlsm'!sjt1jg_00020")
   CASE '00030'   // 신영증권
      obj_1.Application.Run ("'통합 문서1.xlsm'!sjt1jg_00030")
END CHOOSE

STRING	ls_rec, ls_tr_cd, ls_koscom, ls_nm, ls_acct
STRING	ls_jm_cd, ls_danc, ls_fund_cd, ls_enc_acct, ls_err = ''

DEC	ldc_tr_no, ldc_jusu, ldc_aek, lFIND

F_LOADINGRETRIEVE (TRUE)

li_num = FileOpen ("c:\up\SJT1JG.txt", LineMode!, Read!, Shared!)
st_count.visible = TRUE
DO UNTIL FileReadEx (li_num, ls_rec) = -100
   ls_tr_cd  = F_GET_TOKEN (ls_rec, ',')
   ls_koscom = F_GET_TOKEN (ls_rec, ',') ; ls_koscom = RIGHT ('00000' + ls_koscom,6)
   ls_nm     = F_GET_TOKEN (ls_rec, ',')
   ldc_tr_no = dec(F_GET_TOKEN (ls_rec, ','))
   ldc_jusu  = dec(F_GET_TOKEN (ls_rec, ','))
   ldc_aek   = dec(F_GET_TOKEN (ls_rec, ','))
   ls_acct   = F_GET_TOKEN (ls_rec, ',')

   IF ls_tr_co_cd='00020' THEN
      lFIND = ids_jj.FIND ("#1='" + ls_nm + "'", 1, il_jj)
   ELSE
      lFIND = ids_jj.FIND ("#2='" + ls_koscom + "'", 1, il_jj)
   End IF
   IF lFIND=0 THEN
      ls_err = ls_err + ls_rec + ' ' + ls_koscom + ':' + ls_nm + ' - 종목확인~r~n'
      CONTINUE
   End IF
   ls_jm_cd = ids_jj.getitemstring (lFIND, 3)
   ls_danc  = ids_jj.getitemstring (lFIND, 4)

   lFIND = ids_fund.FIND ("#2='" + ls_tr_co_cd + "' And #1='" + F_REPLACE (ls_acct,'-','') + "'", 1, il_fund)
   IF lFIND=0 THEN
      lFIND = ids_fund.FIND ("#2='" + ls_tr_co_cd + "' And #1='0" + F_REPLACE (ls_acct,'-','') + "'", 1, il_fund)
      IF lFIND=0 THEN
         ls_err = ls_err + ls_rec + ' ' + ls_acct + ' - 계좌확인~r~n'
         CONTINUE
      End IF
   End IF
   ls_fund_cd  = ids_fund.getitemstring (lFIND, 3)
   ls_enc_acct = ids_fund.getitemstring (lFIND, 4)

   ll_row ++
   F_ST_COUNT (st_count, '체결내역 LOAD', ll_row, 0)

   INSERT  INTO SJT1JG tt
       ( CORP_GR      /* _1- */
       , TR_YMD       /* _2- */
       , TR_CD        /* _3- */
       , FUND_CD      /* _4- */
       , TR_CO_CD     /* _5- */
       , JM_CD        /* _6- */
       , OFFER_NO     /* _7- */
       , TR_JUSU      /* _8- */
       , TR_AEK       /* _9- */
       , ENC_ACCT_NO  /* _10- */
       , KOSCOM_CD    /* _11- */
       , DANC_GB      /* _12- */
       , SUDO_YMD     /* _13- */
       , LOAD_TIME    /* _14- */
       , LOAD_USER    /* _15- */
       )
   VALUES ( :gaa.corp_gr           /* _1- */
          , :ldt                   /* _2- */
          , :ls_tr_cd              /* _3- */
          , :ls_fund_cd            /* _4- */
          , :ls_tr_co_cd           /* _5- */
          , :ls_jm_cd              /* _6- */
          , :ldc_tr_no             /* _7- */
          , :ldc_jusu              /* _8- */
          , :ldc_aek               /* _9- */
          , :ls_enc_acct           /* _10- */
          , :ls_koscom             /* _11- */
          , :ls_danc               /* _12- */
          , F_OPEN_YMD(:ldt,'+2')  /* _13- */
          , now()                  /* _14- */
          , 'JA010E'               /* _15- */
          );
   IF SQLCA.sqlcode ()<>0 THEN
      CONTINUE
//    f_messageBox ('ERR', ls_fund_cd)
   End IF
   IF ll_row=truncate(ll_row/500,0)*500 THEN commitJ()
LOOP
FileClose (li_num)

F_LOADINGRETRIEVE (FALSE)

IF F_NOTNULL (ls_err) THEN
   ::clipboard (ls_err)
   F_MESSAGEBOX ('ERR', '(클립보드에 복사되었습니다.)~r~n' + ls_err)
End IF

st_count.visible = FALSE

DESTROY obj_1

p_retrieve.postevent ('clicked')
end event

type cb_2402 from pf_u_commandbutton within w_ja010e
integer x = 3529
integer y = 192
integer width = 503
integer taborder = 110
boolean bringtotop = true
string text = "잔고LOAD"
end type

event clicked;call super::clicked;ads_jTier   lds

OLEOBJECT   xlApp, lSheet

STRING	ls_fund_cd, ls_acct, ls_enc_acct, ls_koscom, ls_jm_cd, ls_danc_gb
DATETIME	ldt_ymd

LONG	ll, ll_sheet, lm, lRC, lRow
DEC	ldc_jusu, ldc_aek

lds = CREATE ads_jTier

ldt_ymd = dw_c.object.ymd [1]

// Create the oleobject variable xlapp
xlApp = CREATE OLEOBJECT

// Connect to Excel and check the return code
IF xlApp.ConnectToObject ("", "excel.application") < 0   Then  // 현재 실행되어 있는 엑셀 Connect
   F_MESSAGEBOX ('XLS1', 'LOAD할 자료를 엑셀로 읽어 들이십시오.')
   RETURN
END IF

xlApp.Application.VISIBLE        = TRUE
xlApp.Application.ScreenUpdating = TRUE

st_count.VISIBLE = TRUE
ll_sheet         = xlApp.Application.Workbooks (1).worksheets.COUNT  // Sheet의 갯수 읽기
MESSAGEBOX ('sheet', STRING (ll_sheet) + '개 시트를 LOAD 합니다.')

f_loadingyield ('start')

FOR  ll = 1  TO  ll_sheet
   IF f_loadingyield ('exit') THEN EXIT

   lSheet = xlApp.Application.Workbooks (1).worksheets (ll)
   lSheet.Activate
   lRC = lSheet.UsedRange.Rows.COUNT

   ls_fund_cd = lSheet.NAME
   f_microhelp (ls_fund_cd + ' 자료 업로드 중...')

   SELECT TO_DECRYPTS (enc_acct_no)
        , enc_acct_no
        , mg_cd
     INTO :ls_acct
        , :ls_enc_acct
        , :is_tr_co_cd
     FROM SZM0IA t1
    WHERE t1.fund_cd = :ls_fund_cd
      AND t1.CORP_GR = :gaa.CORP_GR ;

   ls_acct     = SQLCA.GETITEMSTRING (1)
   ls_enc_acct = SQLCA.GETITEMSTRING (2)
   is_tr_co_cd = SQLCA.GETITEMSTRING (3)

   IF SQLCA.sqlcode () <> 0   Then
      EXIT
   END IF

   FOR  lm = 2  TO  lRC
      IF STRING (lSheet.cells (lm, 1).VALUE)<>'주식' THEN EXIT

      IF STRING (lSheet.cells (1, 2).VALUE) = '종목번호' Then
         ls_koscom = MID (STRING (lSheet.cells (lm, 2).VALUE), 2)
         ldc_jusu  = f_num (lSheet.cells (lm, 5).VALUE)
         ldc_aek   = f_num (lSheet.cells (lm, 8).VALUE)

      ELSEIF STRING (lSheet.cells (1, 3).VALUE) = '종목번호'   Then
         ls_koscom = TRIM (STRING (lSheet.cells (lm, 3).VALUE))
         ldc_jusu  = f_num (lSheet.cells (lm, 5).VALUE)
         ldc_aek   = f_num (lSheet.cells (lm, 8).VALUE)
      END IF

      SELECT jm_cd
           , danc_gb
        INTO :ls_jm_cd
           , :ls_danc_gb
        FROM SJM0JJ t1
       WHERE koscom_cd = :ls_koscom
         AND danc_gb   IN ('A','C') ;
      IF SQLCA.sqlcode () <> 0   Then
         EXIT
      END IF

      ls_jm_cd   = SQLCA.GETITEMSTRING (1)
      ls_danc_gb = SQLCA.GETITEMSTRING (2)

      lRow = dw_list.EVENT ue_insert (0)
      
      dw_list.object.tr_cd [lRow]       = 'F'
      dw_list.object.fund_cd [lRow]     = ls_fund_cd
      dw_list.object.xx_acct_no [lRow]  = ls_acct
      dw_list.object.enc_acct_no [lRow] = ls_enc_acct
      dw_list.object.koscom_cd [lRow]   = ls_koscom
      dw_list.object.xx_jm_cd [lRow]    = ls_jm_cd
      dw_list.object.danc_gb [lRow]     = ls_danc_gb
      dw_list.object.tr_jusu [lRow]     = ldc_jusu
      dw_list.object.tr_aek [lRow]      = ldc_aek
   NEXT
NEXT

f_loadingyield ('stop')
st_count.VISIBLE = FALSE

xlApp.DISCONNECTOBJECT ()
DESTROY xlApp

MESSAGEBOX ('작업완료', 'LOAD를 완료 했습니다.')
end event

