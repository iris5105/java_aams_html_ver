forward
global type w_ja010f from wt_list
end type
type cb_load from pf_u_commandbutton within w_ja010f
end type
type dw_xlsx from u_dw within w_ja010f
end type
end forward

global type w_ja010f from wt_list
string is_find = "fund_cd=~'~'"
string is_init_value = "00005"
cb_load cb_load
dw_xlsx dw_xlsx
end type
global w_ja010f w_ja010f

forward prototypes
public subroutine wf_load ()
public subroutine wf_2203 ()
public subroutine wf_2402 ()
end prototypes

public subroutine wf_load ();IF dw_c.object.dddw [1]='%' THEN
   F_MESSAGEBOX ('I000', '개별 증권사를 선택하십시오.')
   RETURN
End IF
IF POS ('00010,00020,00050,00056',dw_c.object.dddw [1])=0 THEN
   F_MESSAGEBOX ('I000', 'Load Format이 등록되어 있지않은 증권사 입니다.~r~n개발 의뢰하십시오.')
   RETURN
End IF

OLEObject  obj_excel, lSheet

LONG	ret, lr, ll_rowcount

STRING	ls_path, ls_name, ls_tr_co_cd, ls_fund, ls_nm, ls_no, ls_msg = ''
STRING	ls_corp_gr, ls_enc_acct_no, ls_title

DATETIME ldt

DEC	ldc_t0, ldc_t1, ldc_t2, ldc_stock, ldc_rp, ldc_tot

obj_excel = CREATE OLEObject

ldt = dw_c.object.ymd [1]
ls_tr_co_cd = dw_c.object.dddw [1]

IF GetFileOpenName ("예수금 엑셀파일 선택", ls_path, ls_name, 'XLS', "Excel Files (*.xls;*.xlsx;*.csv),*.xls;*.xlsx;*.csv", gaa.excel, 2)<>1 THEN RETURN

F_LOADINGRETRIEVE (TRUE)

st_count.visible = TRUE

ls_title = dw_c.describe ("Evaluate('LookupDisplay(dddw)', 1)") + ' 예수금 LOAD중 입니다.~r~n'

ret = obj_excel.ConnectToNewObject ("excel.application")
IF ret<0 THEN
   F_MESSAGEBOX ('XLS1', STRING(ret))
   RETURN
End IF
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기
obj_excel.windowstate = 2

lSheet = obj_excel.Application.ActiveSheet
ll_rowcount = lSheet.UsedRange.Rows.Count

CHOOSE CASE ls_tr_co_cd
   CASE '00010','00020','00050','00056'  // NH, 대우, 한투, 하나
      lr = 2
END CHOOSE
DO WHILE TRUE
   IF F_NULL (lSheet.cells(lr,1).Value) THEN EXIT

   CHOOSE CASE ls_tr_co_cd
      CASE '00010'   // NH
         ls_no = lSheet.cells(lr,1).Value
      CASE '00020'   // 대우
         ls_no = TRIM(STRING(lSheet.cells(lr,2).Value))
      CASE '00050'   // 한투
         ls_no = TRIM(STRING(lSheet.cells(lr,2).Value))
      CASE '00056'   // 한나
         ls_no = TRIM(STRING(lSheet.cells(lr,1).Value))
   END CHOOSE

   F_ST_COUNT (st_count, ls_title + ls_no + ' 계좌 LOAD : ', lr, ll_rowcount)

   SELECT t1.fund_cd
        , t1.enc_acct_no
     INTO :ls_fund
        , :ls_enc_acct_no
     FROM SZM0IA t1
    WHERE t1.corp_gr     = :gaa.corp_gr
      AND t1.mg_cd       = :ls_tr_co_cd
      AND t1.enc_acct_no = TO_ENCRYPTS(:ls_no)
      AND t1.haeji_ymd IS NULL;
   IF SQLCA.sqlcode ()<>0 THEN
      lSheet.cells(lr,8).Value = '(계좌확인)'
      ls_msg = '등록되지 않은 계좌가 있습니다.~r~n엑셀 Sheet를 확인 하십시오.'
      lr ++
      CONTINUE
   End IF

   ls_fund        = SQLCA.getitemstring (1)
   ls_enc_acct_no = SQLCA.getitemstring (2)

   SELECT corp_gr
     INTO :ls_corp_gr
     FROM SHT0YE t1
    WHERE t1.corp_gr     = :gaa.corp_gr
      AND t1.tr_ymd      = :ldt
      AND t1.fund_cd     = :ls_fund
      AND t1.tr_co_cd    = :ls_tr_co_cd
      AND t1.enc_acct_no = :ls_enc_acct_no;
   IF SQLCA.sqlcode ()<>0 THEN
      ls_corp_gr = ''
   ELSE
      ls_corp_gr = SQLCA.getitemstring (1)
   End IF

   CHOOSE CASE ls_tr_co_cd
      CASE '00010'   // NH
         ldc_t0    = 0
         ldc_t1    = 0
         ldc_t2    = dec(lSheet.cells(lr,4).Value)
         ldc_stock = dec(lSheet.cells(lr,5).Value)
         ldc_rp    = 0
         ldc_tot   = dec(lSheet.cells(lr,6).Value)

         lSheet.cells(lr,2).Value = ' '
         lSheet.cells(lr,3).Value = ' '
         lSheet.cells(lr,4).Value = ' '
         lSheet.cells(lr,5).Value = ' '
         lSheet.cells(lr,6).Value = ' '
         lSheet.cells(lr,7).Value = ' '

      CASE '00020'   // 대우
         ldc_t0    = dec(lSheet.cells(lr,5).Value)
         ldc_t1    = dec(lSheet.cells(lr,6).Value)
         ldc_t2    = dec(lSheet.cells(lr,7).Value)
         ldc_stock = dec(lSheet.cells(lr,8).Value)
         ldc_rp    = dec(lSheet.cells(lr,12).Value)
         ldc_tot   = dec(lSheet.cells(lr,13).Value)

         lSheet.cells(lr,04).Value = ' '
         lSheet.cells(lr,05).Value = ' '
         lSheet.cells(lr,06).Value = ' '
         lSheet.cells(lr,07).Value = ' '
         lSheet.cells(lr,08).Value = ' '
         lSheet.cells(lr,09).Value = ' '
         lSheet.cells(lr,10).Value = ' '
         lSheet.cells(lr,11).Value = ' '
         lSheet.cells(lr,12).Value = ' '
         lSheet.cells(lr,13).Value = ' '

      CASE '00050'   // 한국투자증권
         ldc_t0    = dec(lSheet.cells(lr,4).Value)
         ldc_t1    = dec(lSheet.cells(lr,5).Value)
         ldc_t2    = dec(lSheet.cells(lr,6).Value)
         ldc_stock = dec(lSheet.cells(lr,7).Value)
         ldc_rp    = 0
         ldc_tot   = dec(lSheet.cells(lr,8).Value)

         lSheet.cells(lr,04).Value = ' '
         lSheet.cells(lr,05).Value = ' '
         lSheet.cells(lr,06).Value = ' '
         lSheet.cells(lr,07).Value = ' '
         lSheet.cells(lr,08).Value = ' '

      CASE '00056'   // 하나
         ldc_t0    = dec(lSheet.cells(lr,3).Value)
         ldc_t1    = dec(lSheet.cells(lr,4).Value)
         ldc_t2    = dec(lSheet.cells(lr,5).Value)
         ldc_stock = dec(lSheet.cells(lr,6).Value)
         ldc_rp    = 0
         ldc_tot   = dec(lSheet.cells(lr,8).Value)

         lSheet.cells(lr,04).Value = ' '
         lSheet.cells(lr,05).Value = ' '
         lSheet.cells(lr,06).Value = ' '
         lSheet.cells(lr,07).Value = ' '
         lSheet.cells(lr,08).Value = ' '
   END CHOOSE

   IF F_NOTNULL (ls_corp_gr) THEN
      UPDATE SHT0YE tt
         SET t0_aek     = :ldc_t0
           , t1_aek     = :ldc_t1
           , t2_aek     = :ldc_t2
           , stock_aek  = :ldc_stock
           , rp_aek     = :ldc_rp
           , tot_aek    = :ldc_tot
           , bigo       = 'w_ja010f'
       WHERE corp_gr     = :gaa.corp_gr
         AND tr_ymd      = :ldt
         AND fund_cd     = :ls_fund
         AND tr_co_cd    = :ls_tr_co_cd
         AND enc_acct_no = :ls_enc_acct_no;
   ELSE
      INSERT  INTO SHT0YE tt
          ( CORP_GR      /* _1- */
          , TR_YMD       /* _2- */
          , FUND_CD      /* _3- */
          , TR_CO_CD     /* _4- */
          , ENC_ACCT_NO  /* _5- */
          , T0_AEK       /* _6- */
          , T1_AEK       /* _7- */
          , T2_AEK       /* _8- */
          , STOCK_AEK    /* _9- */
          , BOND_AEK     /* _10- */
          , RP_AEK       /* _11- */
          , CASH_AEK     /* _12- */
          , TOT_AEK      /* _13- */
          , BIGO         /* _14- */
          , LOAD_DT      /* _15- */
          , FUND_AEK     /* _16- */
          )
      VALUES ( :gaa.corp_gr     /* _1- */
             , :ldt             /* _2- */
             , :ls_fund         /* _3- */
             , :ls_tr_co_cd     /* _4- */
             , :ls_enc_acct_no  /* _5- */
             , :ldc_t0          /* _6- */
             , :ldc_t1          /* _7- */
             , :ldc_t2          /* _8- */
             , :ldc_stock       /* _9- */
             , 0                /* _10- */
             , :ldc_rp          /* _11- */
             , 0                /* _12- */
             , :ldc_tot         /* _13- */
             , 'w_ja010f'       /* _14- */
             , now()            /* _15- */
             , 0                /* _16- */
             );
   End IF
   commitJ ()
   IF SQLCA.sqlcode ()<>0 THEN
      messagebox ('예수금 LOAD', SQLCA.sqlerrtext ())
      EXIT
   End IF
   lr ++
LOOP

F_LOADINGRETRIEVE (FALSE)

ChangeDirectory (gnv_vari.basepath)
F_MESSAGEBOX ('INFO', '예수금 Load가 완료되었습니다.~r~n~r~n'+ls_msg)

st_count.visible = FALSE

p_retrieve.EVENT clicked ()
end subroutine

public subroutine wf_2203 ();OLEObject  obj_excel, lSheet

LONG	ret, ll, ll_rowcount

STRING	ls_path, ls_name
STRING	ls_acct_no, ls_fund_cd, ls_mg_cd, ls_no, ls_rowid

DATETIME ldt

DEC	ldc_tot, ldc_t0, ldc_t2, ldc_stock, ldc_bond

obj_excel = CREATE OLEObject

ldt = dw_c.object.ymd [1]

IF GetFileOpenName ("예수금 엑셀파일 선택", ls_path, ls_name, 'XLS', "Excel Files (*.xls;*.xlsx;*.csv),*.xls;*.xlsx;*.csv", gaa.excel, 2)<>1 THEN RETURN

ret = obj_excel.ConnectToNewObject ("excel.application")
IF ret<0 THEN
   F_MESSAGEBOX ('XLS1', STRING(ret))
   RETURN
End IF
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기
obj_excel.windowstate = 2

//ll_sheet = obj_excel.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기
lSheet = obj_excel.Application.Workbooks (1).worksheets (1)
lSheet.Activate

ll_rowcount = lSheet.UsedRange.Rows.Count
IF lSheet.cells(1,2).Value='관리번호' THEN
   FOR ll = 2  TO  ll_rowcount
      ls_fund_cd = STRING(lSheet.cells(ll,2).Value)
      ls_acct_no = F_REPLACE(STRING(lSheet.cells(ll,11).Value),'-','')
      ldc_tot    = dec(lSheet.cells(ll,10).Value)
      ldc_t0     = dec(lSheet.cells(ll,4).Value)
      ldc_t2     = 0
      ldc_stock  = dec(lSheet.cells(ll,7).Value)
      ldc_bond   = dec(lSheet.cells(ll,8).Value)

      IF F_NULL (ls_acct_no) THEN
         SELECT fund_cd
              , mg_cd
              , enc_acct_no
           INTO :ls_fund_cd
              , :ls_mg_cd
              , :ls_no
           FROM SZM0IA ia
          WHERE ia.corp_gr = :gaa.corp_gr
            AND ia.fund_cd = :ls_fund_cd;
      ELSE
         SELECT fund_cd
              , mg_cd
              , enc_acct_no
           INTO :ls_fund_cd
              , :ls_mg_cd
              , :ls_no
           FROM SZM0IA ia
          WHERE ia.corp_gr = :gaa.corp_gr
            AND REPLACE(TO_DECRYPTS (enc_acct_no),'-')  = :ls_acct_no;
      End IF
      IF SQLCA.sqlcode ()<>0 THEN CONTINUE

      ls_fund_cd = SQLCA.getitemstring (1)
      ls_mg_cd   = SQLCA.getitemstring (2)
      ls_no      = SQLCA.getitemstring (3)

      SELECT rowidtochar (ROWID)
        INTO :ls_rowid
        FROM SHT0YE t1
       WHERE t1.corp_gr = :gaa.corp_gr
         AND t1.tr_ymd  = :ldt
         AND t1.fund_cd = :ls_fund_cd;
      IF SQLCA.sqlcode ()<>0 THEN
         ls_rowid = ''
      ELSE
         ls_rowid = SQLCA.getitemstring (1)
      End IF

      IF F_NOTNULL (ls_rowid) THEN
         UPDATE SHT0YE tt
            SET t0_aek     = :ldc_t0
              , t2_aek     = :ldc_t2
              , stock_aek  = :ldc_stock
              , bond_aek   = :ldc_bond
              , tot_aek    = :ldc_tot
          WHERE ROWID = :ls_rowid;
      ELSE
         INSERT  INTO SHT0YE tt
             ( CORP_GR      /* _1- */
             , TR_YMD       /* _2- */
             , FUND_CD      /* _3- */
             , TR_CO_CD     /* _4- */
             , ENC_ACCT_NO  /* _5- */
             , T0_AEK       /* _6- */
             , T1_AEK       /* _7- */
             , T2_AEK       /* _8- */
             , STOCK_AEK    /* _9- */
             , BOND_AEK     /* _10- */
             , RP_AEK       /* _11- */
             , CASH_AEK     /* _12- */
             , TOT_AEK      /* _13- */
             , BIGO         /* _14- */
             , LOAD_DT      /* _15- */
             , FUND_AEK     /* _16- */
             )
         VALUES ( :gaa.corp_gr  /* _1- */
                , :ldt          /* _2- */
                , :ls_fund_cd   /* _3- */
                , :ls_mg_cd     /* _4- */
                , :ls_no        /* _5- */
                , :ldc_t0       /* _6- */
                , 0             /* _7- */
                , :ldc_t2       /* _8- */
                , :ldc_stock    /* _9- */
                , :ldc_bond     /* _10- */
                , 0             /* _11- */
                , 0             /* _12- */
                , :ldc_tot      /* _13- */
                , 'w_ja010f'    /* _14- */
                , now()         /* _15- */
                , 0             /* _16- */
                );
      End IF
      commitJ ()
   NEXT
ELSE
   FOR ll = 3  TO  ll_rowcount  STEP 2
      ls_acct_no = STRING(lSheet.cells(ll + 1,4).Value)
      ldc_tot    = dec(lSheet.cells(ll,5).Value)
      ldc_t0     = dec(lSheet.cells(ll,6).Value)
      ldc_t2     = dec(lSheet.cells(ll + 1,6).Value)
      ldc_stock  = dec(lSheet.cells(ll,8).Value)
      ldc_bond   = dec(lSheet.cells(ll + 1,8).Value)

      SELECT fund_cd
           , mg_cd
           , enc_acct_no
        INTO :ls_fund_cd
           , :ls_mg_cd
           , :ls_no
        FROM SZM0IA ia
       WHERE ia.corp_gr = :gaa.corp_gr
         AND REPLACE(TO_DECRYPTS (enc_acct_no),'-')  = :ls_acct_no;
      IF SQLCA.sqlcode ()<>0 THEN CONTINUE

      ls_fund_cd = SQLCA.getitemstring (1)
      ls_mg_cd   = SQLCA.getitemstring (2)
      ls_no      = SQLCA.getitemstring (3)

      SELECT rowidtochar (ROWID)
        INTO :ls_rowid
        FROM SHT0YE t1
       WHERE t1.corp_gr = :gaa.corp_gr
         AND t1.tr_ymd  = :ldt
         AND t1.fund_cd = :ls_fund_cd;
      IF SQLCA.sqlcode ()<>0 THEN
         ls_rowid = ''
      ELSE
         ls_rowid = SQLCA.getitemstring (1)
      End IF

      IF F_NOTNULL (ls_rowid) THEN
         UPDATE SHT0YE tt
            SET t0_aek     = :ldc_t0
              , t2_aek     = :ldc_t2
              , stock_aek  = :ldc_stock
              , bond_aek   = :ldc_bond
              , tot_aek    = :ldc_tot
          WHERE ROWID = :ls_rowid;
      ELSE
         INSERT  INTO SHT0YE tt
             ( CORP_GR      /* _1- */
             , TR_YMD       /* _2- */
             , FUND_CD      /* _3- */
             , TR_CO_CD     /* _4- */
             , ENC_ACCT_NO  /* _5- */
             , T0_AEK       /* _6- */
             , T1_AEK       /* _7- */
             , T2_AEK       /* _8- */
             , STOCK_AEK    /* _9- */
             , BOND_AEK     /* _10- */
             , RP_AEK       /* _11- */
             , CASH_AEK     /* _12- */
             , TOT_AEK      /* _13- */
             , BIGO         /* _14- */
             , LOAD_DT      /* _15- */
             , FUND_AEK     /* _16- */
             )
         VALUES ( :gaa.corp_gr  /* _1- */
                , :ldt          /* _2- */
                , :ls_fund_cd   /* _3- */
                , :ls_mg_cd     /* _4- */
                , :ls_no        /* _5- */
                , :ldc_t0       /* _6- */
                , 0             /* _7- */
                , :ldc_t2       /* _8- */
                , :ldc_stock    /* _9- */
                , :ldc_bond     /* _10- */
                , 0             /* _11- */
                , 0             /* _12- */
                , :ldc_tot      /* _13- */
                , 'w_ja010f'    /* _14- */
                , now()         /* _15- */
                , 0             /* _16- */
                );
      End IF
      commitJ ()
   NEXT
End IF
obj_excel.DisConnectObject ()
DESTROY obj_excel

ChangeDirectory (gnv_vari.basepath)
F_MESSAGEBOX ('INFO', '예수금 Load가 완료되었습니다.')

p_retrieve.EVENT clicked ()
end subroutine

public subroutine wf_2402 ();OLEObject  lXls, lSheet

DATETIME ldt_sysdate, ldt
STRING	ls_path, ls_file, ls_xls, ls_msg, ls_temp, ls_fund_cd, ls_mg_cd, ls_enc_acct, ls_rowid

LONG	ll, lm, lRow, lc []
INT   li_con
DEC	ldc_t2

ls_path = profilestring (gaa.config, "DIR value", classname() + 'dir', gaa.excel)
IF GetFileOpenName ("예수금 엑셀파일 선택(단일파일)", ls_path, ls_file, "#1024", " 예수금 LOAD 자료,*#1024*.*, 엑셀,*.xls;*.xlsx;*.csv", ls_path,18)<>1 THEN RETURN

SetProfileString (gaa.config, "DIR value", classname() + 'dir', LEFT (ls_path, LASTPOS (ls_path,'\')))

ldt = dw_c.object.ymd [1]
ldt_sysdate = F_SYSDATE ('')

lXls = CREATE OLEObject

li_con = lXls.ConnectToNewObject ("excel.application")
IF li_con<>0 THEN
   CHOOSE CASE li_con
      CASE -1
         ls_msg = "Invalid Call: the argument is the Object property of a control~r~n"
      CASE -2
         ls_msg = "Class name not found~r~n"
      CASE -3
         ls_msg = "Object could not be created~r~n"
      CASE -4
         ls_msg = "ould not connect to object~r~n"
      CASE -9
         ls_msg = "Other error~r~n"
      CASE -15
         ls_msg = "MTS is not loaded on this computer~r~n"
      CASE -16
         ls_msg = "Invalid Call: this function not applicable~r~n"
      CASE ELSE
         ls_msg = "If any argument's value is NULL, ConnectToNewObject returns NULL.~r~n"
   END CHOOSE
   DESTROY lXls
   MessageBox("ERROR","엑셀 프로그램을 실행할 수 없습니다.~r~n" + ls_msg, StopSign!)
   RETURN
End IF

F_LOADINGRETRIEVE (TRUE)

lXls.WorkBooks.OPEN (ls_path)
lXls.Application.Visible = FALSE

lSheet = lXls.Application.Workbooks (1).worksheets (1)
lSheet.Activate

ls_xls = gaa.temp + '(' + gaa.corp_gr + ')' + STRING (ldt,'yyyymmdd') + '.csv'
IF FileExists (ls_xls) THEN FileDelete (ls_xls)
lXls.Application.Workbooks(1).Worksheets(1).Saveas (ls_xls, 6)
lXls.WorkBooks(1).saved = TRUE
lXls.WorkBooks.close ()
lXls.Application.Quit
lXls.DisConnectObject ()

DESTROY lXls

dw_xlsx.reset ()
lRow = dw_xlsx.importfile (CSV!, ls_xls, 1)

// 1-관리번호, 2-D+2잔액
lc = {0,0}
FOR  lm = 1  TO  10
   ls_temp = F_REPLACE (STRING (dw_xlsx.object.data [1,lm]), ' ', '')
   IF ls_temp='관리번호' THEN
      lc[1] = lm
   ElseIF POS (ls_temp,'D+2')>0 THEN
      lc[2] = lm
   End IF
NEXT

FOR  lm = 2 TO  lRow
   ls_fund_cd = STRING (dw_xlsx.object.data [lm,lc [1]])
   ldc_t2     = dec (dw_xlsx.object.data [lm,lc [2]])

   SELECT mg_cd
        , enc_acct_no
     INTO :ls_mg_cd
        , :ls_enc_acct
     FROM SZM0IA ia
    WHERE ia.corp_gr = :gaa.corp_gr
      AND ia.fund_cd = :ls_fund_cd;
   IF SQLCA.sqlcode ()<>0 THEN CONTINUE

   ls_mg_cd    = SQLCA.getitemstring (1)
   ls_enc_acct = SQLCA.getitemstring (2)

   SELECT rowidtochar (ROWID)
     INTO :ls_rowid
     FROM SHT0YE t1
    WHERE t1.corp_gr = :gaa.corp_gr
      AND t1.tr_ymd  = :ldt
      AND t1.fund_cd = :ls_fund_cd;
   IF SQLCA.sqlcode ()<>0 THEN
      ls_rowid = ''
   ELSE
      ls_rowid = SQLCA.getitemstring (1)
   End IF

   IF F_NOTNULL (ls_rowid) THEN
      UPDATE SHT0YE tt
         SET t0_aek  = 0
           , t2_aek  = :ldc_t2
           , bigo    = 'w_ja010f'
       WHERE ROWID = :ls_rowid;
   ELSE
      INSERT  INTO SHT0YE tt
          ( CORP_GR      /* _1- */
          , TR_YMD       /* _2- */
          , FUND_CD      /* _3- */
          , TR_CO_CD     /* _4- */
          , ENC_ACCT_NO  /* _5- */
          , T0_AEK       /* _6- */
          , T1_AEK       /* _7- */
          , T2_AEK       /* _8- */
          , STOCK_AEK    /* _9- */
          , BOND_AEK     /* _10- */
          , RP_AEK       /* _11- */
          , CASH_AEK     /* _12- */
          , TOT_AEK      /* _13- */
          , BIGO         /* _14- */
          , LOAD_DT      /* _15- */
          , FUND_AEK     /* _16- */
          )
      VALUES ( :gaa.corp_gr  /* _1- */
             , :ldt          /* _2- */
             , :ls_fund_cd   /* _3- */
             , :ls_mg_cd     /* _4- */
             , :ls_enc_acct  /* _5- */
             , 0             /* _6- */
             , 0             /* _7- */
             , :ldc_t2       /* _8- */
             , 0             /* _9- */
             , 0             /* _10- */
             , 0             /* _11- */
             , 0             /* _12- */
             , 0             /* _13- */
             , 'w_ja010f'    /* _14- */
             , now()         /* _15- */
             , 0             /* _16- */
             );
   End IF
   commitJ ()
NEXT

ChangeDirectory (gnv_vari.basepath)
F_MESSAGEBOX ('INFO', '예수금 Load가 완료되었습니다.')

p_retrieve.EVENT clicked ()
end subroutine

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

IF	gaa.corp_gr='2402'	Then
	SELECT JUNYONG_YMD
	  INTO :ldt
	  FROM SZX0AA aa
	 WHERE aa.corp_gr = :gaa.corp_gr;

	dw_c.object.ymd [1] = SQLCA.getitemdatetime (1)
Else
	dw_c.object.ymd [1] = idt_workdate
End IF
dw_c.object.dddw [1] = ia_value [1]
end event

on w_ja010f.create
int iCurrent
call super::create
this.cb_load=create cb_load
this.dw_xlsx=create dw_xlsx
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_load
this.Control[iCurrent+2]=this.dw_xlsx
end on

on w_ja010f.destroy
call super::destroy
destroy(this.cb_load)
destroy(this.dw_xlsx)
end on

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.dddw [1])
cb_load.enabled = false
end event

event wue_clear;call super::wue_clear;cb_load.enabled = true
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja010f
end type

type ln_templeft from wt_list`ln_templeft within w_ja010f
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja010f
end type

type ln_temptop from wt_list`ln_temptop within w_ja010f
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja010f
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja010f
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja010f
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja010f
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja010f
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja010f
end type

type ln_tempright from wt_list`ln_tempright within w_ja010f
end type

type uo_navi from wt_list`uo_navi within w_ja010f
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja010f
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja010f
end type

type st_top_rect from wt_list`st_top_rect within w_ja010f
end type

type p_close from wt_list`p_close within w_ja010f
end type

type p_excel from wt_list`p_excel within w_ja010f
end type

type p_print from wt_list`p_print within w_ja010f
end type

type p_delete from wt_list`p_delete within w_ja010f
end type

type p_update from wt_list`p_update within w_ja010f
end type

type p_input from wt_list`p_input within w_ja010f
end type

type p_retrieve from wt_list`p_retrieve within w_ja010f
end type

type p_clear from wt_list`p_clear within w_ja010f
end type

type p_copy from wt_list`p_copy within w_ja010f
end type

type dw_c from wt_list`dw_c within w_ja010f
string tag = "                             * 수요예측자료 엑셀LOAD시 등록된 예금자료 기준으로 처리"
string title = "LOAD일자@증권사"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw | tr_co_cd', gaa.corp_gr, '%,전체,', 1, "tr_gb='1'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li = 0

SELECT 1
  INTO :li
  FROM SHT0YE t1
 WHERE corp_gr = :gaa.corp_gr
   AND tr_ymd  = :rs_ymd
   AND ROWNUM = 1;

li = SQLCA.getitemnumber (1)

RETURN li
end event

type btn_update from wt_list`btn_update within w_ja010f
end type

type st_count from wt_list`st_count within w_ja010f
end type

type dw_list from wt_list`dw_list within w_ja010f
string dataobject = "d_ja010f1"
boolean eb_null_line = false
string is_encrypts = "enc_acct_no"
end type

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'fund_cd'
      rs_where = "mg_cd like '" + dw_c.object.dddw [1] + "'"
END CHOOSE
RETURN 1 // 순번

end event

event dw_list::retrieveend;call super::retrieveend;IF	dw_c.object.dddw [1]='%' THEN RETURN
CHOOSE CASE gaa.corp_gr
	CASE '2201','2202'
		IF POS ('00010,00020,00050',dw_c.object.dddw [1])>0 OR rowcount>0 THEN RETURN   // NH,대우,한투는 Load
END CHOOSE

STRING	ls_sqlsyntax, ls_fund_cd, ls_acct, ls_enc_acct

DateTime	ldt_tr_ymd

LONG	lR, lj


ldt_tr_ymd = dw_c.object.ymd [1]

ls_sqlsyntax = " SELECT fund_cd " + &
               "      , fund_nm " + &
               " FROM   szm0ia t1 " + &
               " WHERE  corp_gr   = '" + gaa.corp_gr + "' " + &
               "   AND  mg_cd     = '" + dw_c.object.dddw [1] + "' " + &
               "   AND  haeji_ymd is null " + &
               "   AND  fund_cd   not in ( select fund_cd " + &
               "                            from sht0ye ta " + &
               "                           where ta.corp_gr = '" + gaa.corp_gr + "' " + &
               "                             and ta.tr_ymd  = '" + string (ldt_tr_ymd,'yyyy.mm.dd') + "' ) " + &
               " ORDER BY  fund_cd DESC "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, gds, 'xml')

FOR  lj = 1  TO  lR
   insertrow (1)
   Object.corp_gr [1] = gaa.corp_gr
   object.tr_ymd [1] = ldt_tr_ymd
   Object.fund_cd [1] = gds.getitemstring (lj, 1)
   Object.xx_fund_cd [1] = gds.getitemstring (lj, 2)
   Object.xx_mg_cd [1] = dw_c.object.dddw [1]
   Object.bigo [1] = 'w_ja010f'

   ls_fund_cd = Object.fund_cd [1]

   SELECT TO_DECRYPTS (enc_acct_no)
        , enc_acct_no
     INTO :ls_acct
        , :ls_enc_acct
   FROM   szm0ia t1
   WHERE  t1.corp_gr = :gaa.corp_gr
     AND  t1.fund_cd = :ls_fund_cd;

   Object.acct_no [1]     = SQLCA.getitemstring (1)
   Object.enc_acct_no [1] = SQLCA.getitemstring (2)
NEXT
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string(dw_c.object.ymd [1]))
uf_setColumn ('bigo', 'w_ja010f')

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF	dwo.name='dddw' THEN cb_load.enabled = (POS ('00010,00020,00050',data)>0)
end event

event dw_list::itemchanged_next;call super::itemchanged_next;STRING	ls_fund_cd, ls_acct, ls_enc_acct

DateTime ldt_tr_ymd

IF name='fund_cd' Then
   ldt_tr_ymd = dw_c.object.ymd [1]
   ls_fund_cd = Object.fund_cd [row]

   SELECT TO_DECRYPTS (enc_acct_no)
        , enc_acct_no
     INTO :ls_acct
        , :ls_enc_acct
   FROM   szm0ia t1
   WHERE  t1.corp_gr = :gaa.corp_gr
     AND  t1.fund_cd = :ls_fund_cd;

   Object.acct_no [row]     = SQLCA.getitemstring (1)
   Object.enc_acct_no [row] = SQLCA.getitemstring (2)
End IF

Object.tot_aek [row] = f_num (Object.stock_aek [row]) + f_num (Object.bond_aek [row]) + f_num (Object.rp_aek [row])
end event

type cb_load from pf_u_commandbutton within w_ja010f
integer x = 2158
integer y = 188
integer width = 503
integer taborder = 90
boolean bringtotop = true
string text = "예수금LOAD"
end type

event clicked;call super::clicked;CHOOSE CASE gaa.corp_gr
	CASE '2201','2202'
		wf_load ()
	CASE '2203'
		wf_2203 ()
	CASE '2402'
		wf_2402 ()
END CHOOSE
end event

type dw_xlsx from u_dw within w_ja010f
boolean visible = false
integer x = 1737
integer y = 960
integer width = 3689
integer height = 1892
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_xlsx"
end type

