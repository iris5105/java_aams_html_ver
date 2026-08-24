forward
global type w_ja010a from wt_listdetail
end type
end forward

global type w_ja010a from wt_listdetail
boolean eb_direct_retrieve = true
string is_find = "corp_gr=~'~'"
end type
global w_ja010a w_ja010a

on w_ja010a.create
int iCurrent
call super::create
end on

on w_ja010a.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;is_find = "corp_gr='" + gaa.corp_gr + "'"
dw_list.retrieve ()
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja010a
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja010a
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja010a
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja010a
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja010a
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja010a
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja010a
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja010a
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja010a
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja010a
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja010a
end type

type uo_navi from wt_listdetail`uo_navi within w_ja010a
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja010a
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja010a
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja010a
end type

type p_close from wt_listdetail`p_close within w_ja010a
end type

type p_excel from wt_listdetail`p_excel within w_ja010a
end type

type p_print from wt_listdetail`p_print within w_ja010a
end type

type p_delete from wt_listdetail`p_delete within w_ja010a
end type

type p_update from wt_listdetail`p_update within w_ja010a
end type

type p_input from wt_listdetail`p_input within w_ja010a
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja010a
end type

type p_clear from wt_listdetail`p_clear within w_ja010a
end type

type p_copy from wt_listdetail`p_copy within w_ja010a
end type

type dw_c from wt_listdetail`dw_c within w_ja010a
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_listdetail`btn_update within w_ja010a
end type

type st_count from wt_listdetail`st_count within w_ja010a
end type

type dw_list from wt_listdetail`dw_list within w_ja010a
integer y = 156
integer height = 1284
string dataobject = "d_ja010a1"
string icon = "AppRectangle!"
boolean ibsettooltiphelp = true
string is_resize_column = "bigo"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;STRING	ls_corp_gr

ls_corp_gr = string (idt_workdate,'yy') + '01'

SELECT  NVL(max(corp_gr) + 1,:ls_corp_gr)
  INTO  :ls_corp_gr
FROM    szx0aa t1
WHERE   t1.corp_gr >= :ls_corp_gr;

ls_corp_gr = SQLCA.getitemstring (1)

uf_setcolumn ('corp_gr', ls_corp_gr)
uf_setcolumn ('company_name', '신규생성회사명')
uf_setcolumn ('symd', string (idt_workdate))
uf_setcolumn ('fund_length', 'yy1230')
uf_setcolumn ('deposit_dd', '5')
uf_setcolumn ('customer_gr', '자문회사')

POST SetColumn ('company_name')

RETURN 0
end event

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

STRING	ls_corp_gr

BOOLEAN	lb = FALSE

FOR  ll = 1  TO  rowcount ()
   IF GETITEMSTATUS (ll, 0, PRIMARY!) = NEWMODIFIED!  Then
      lb = TRUE
      EXIT
   END IF
NEXT

IF NOT lb THEN RETURN

IF F_MESSAGEBOX ('INFO2', '회사 신규생성 작업을 시작합니다.')=2 THEN RETURN 1

FOR  ll = 1  TO  rowcount ()
   IF GETITEMSTATUS (ll, 0, PRIMARY!) = NEWMODIFIED!  Then
      ls_corp_gr = Object.CORP_GR [ll]

      // 수수료 계산을 위한 회사 초기자료
      INSERT INTO SZX2MM
        SELECT :ls_corp_gr   /* _1- */
             , tr_co_cd      /* _2- */
             , tr_co_nm      /* _3- */
             , tr_gb         /* _4- */
             , fss_tr_co_cd  /* _5- */
             , comp_cd       /* _6- */
             , bank_cd       /* _7- */
             , used          /* _8- */
             , cut_gb        /* _9- */
             , NULL          /* _10- */
             , map           /* _11- */
             , NULL          /* _12- */
             , NULL          /* _13- */
             , NULL          /* _14- */
             , NULL          /* _15- */
             , ksd_ref       /* _16- */
             , tax_rt        /* _17- */
             , fen0317       /* _18- */
             , fen0080       /* _19- */
          FROM SZX2MM t1
         WHERE t1.CORP_GR LIKE '2402'
           AND t1.tr_gb   IN ('1','5','9')
           AND t1.used    = '1' ;
      IF SQLCA.sqlcode () <> 0   Then
         MESSAGEBOX ('SZX2MM INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
      END IF

      INSERT INTO SZX0SE
        SELECT :ls_corp_gr      /* _1- */
             , SERIES_G1        /* _2- */
             , SERIES_G2        /* _3- */
             , SERIES_GB        /* _4- */
             , SERIES_NM        /* _5- */
             , RET_SUSU         /* _6- */
             , RET_SUSU_GB      /* _7- */
             , FUTURES_INCLUDE  /* _8- */
             , USED             /* _9- */
             , RE_SEOLJ_YEAR    /* _10- */
             , SINTAK_GIGAN     /* _11- */
             , BOSU_GIGAN       /* _13- */
             , MOKPYO_SUIK_PER  /* _14- */
             , PRE_BASIC        /* _15- */
             , BASIC_PER        /* _16- */
             , SUCCESS_PER      /* _17- */
             , MAGAM_USED       /* _18- */
             , DP_USED          /* _19- */
             , JY_FA_CD         /* _20- */
             , BM_GR            /* _21- */
             , GUGAN            /* _22- */
             , BIGO             /* _23- */
             , GA               /* _24- */
          FROM SZX0SE h1
         WHERE CORP_GR   = '2402'
           AND SERIES_G1 = '1' ;
      IF SQLCA.sqlcode () <> 0   Then
         MESSAGEBOX ('SZX0SE INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
      END IF

		INSERT INTO SZX1GR
		  SELECT :ls_corp_gr   /* _1- */
				 , GR_CD         /* _2- */
				 , SEBU_CD       /* _3- */
				 , SEBU_CD_NM    /* _4- */
				 , SEBU_CD_EFNM  /* _5- */
				 , SEBU_CD_ENM   /* _6- */
				 , SEBU_NUM      /* _7- */
				 , FYMD          /* _8- */
				 , TYMD          /* _9- */
			 FROM SZX1GR h1
			WHERE CORP_GR = '2402'
			  AND GR_CD   = 'TX' ;
				IF SQLCA.sqlcode () <> 0   Then
					MESSAGEBOX ('SZX1GR INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
				END IF

      INSERT INTO FW_USER_MST
          ( sys_id      /* _1- */
          , CORP_GR     /* _2- */
          , enc_e_mail  /* _3- */
          , user_id     /* _4- */
          )
      VALUES ( 'SY'            /* _1- */
             , :ls_corp_gr     /* _2- */
             , 'AAAAAAAAAAA='  /* _3- */
             , '001'           /* _4- */
             ) ;
      IF SQLCA.sqlcode () <> 0   Then
         MESSAGEBOX ('szx0se INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
      END IF
   END IF
NEXT

F_MESSAGEBOX ('INFO', '회사 신규생성 작업을 완료 했습니다.')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN

DATETIME	ldt, j1date, i2date, i3date

CHOOSE CASE DWO.NAME
   CASE 'hyun_ymd'
      ldt = DATETIME (DATE (MID (data,1,10)))

      SELECT F_OPEN_YMD(:ldt,'-')
           , F_OPEN_YMD(:ldt,'-1')
           , F_OPEN_YMD(:ldt,'+1')
        INTO :ldt
           , :j1date
           , :i2date
        FROM DUAL ;
      IF SQLCA.getitemdatetime (1) <> ldt Then
         RETURN uf_itemerr (ROW, DWO.NAME, '영업일을 입력해야 합니다.')
      END IF
		gnv_vari.of_setprofile ("login.corp.aams.dt", STRING (ldt, 'yyyy.mm.dd'))
      j1date = SQLCA.getitemdatetime (2)
      i2date = SQLCA.getitemdatetime (3)

       SELECT F_OPEN_YMD(:i2date,'+1') INTO :i3date FROM DUAL;
      i3date = SQLCA.getitemdatetime (1)

      SetItem (ROW,'junyong_ymd',j1date)
      SetItem (ROW,'ikyong_ymd',i2date)
      SetItem (ROW,'thikyong_ymd',i3date)
END CHOOSE
end event

type dw_detail from wt_listdetail`dw_detail within w_ja010a
string dataobject = "d_ja010a2"
string is_resize_column = "juso"
end type

event dw_detail::buttonup;call super::buttonup;STRING	ls_path, ls_local, ls_corp_gr, ls_blob_err, ls_fname

Datetime	ldt

LONG	lf, ll_blob

BLOB	lb_pdf

BOOLEAN	lb_return

CHOOSE CASE dwo.name
	CASE 'p_fname_save'
		uf_setrow (row, false)
		IF GetFileOpenName ("계약서 (스캔)PDF 선택", ls_path, ls_local, 'PDF', "PDF Files,*.pdf", gaa.pdf, 2)<>1 THEN RETURN

		IF uf_Update ()=FALSE THEN RETURN

		ls_corp_gr = Object.corp_gr [row]
		ldt = Object.ymd [row]

		lb_pdf = BLOB(" ")

		Object.fname [row] = '계약서.pdf'
		filedelete (ls_path + '.zip')
		IF	mo_.zip (ls_path, ls_path + '.zip', 'f')<>0	Then
			f_messagebox ('압축실패!','자료를 다시 LOAD하십시오.')
			RETURN
		Else
			SQLCA.setupdateBLOB_file (ls_path + '.zip')
			Object.org_fname [row] = ls_local
		End IF

		UPDATEBLOB  szx0ab
			SET  pdf = :lb_pdf
		WHERE   corp_gr = :ls_corp_gr
		  AND   ymd     = :ldt;

		filedelete (ls_path + '.zip')

	CASE 'p_fname_open'
      ls_corp_gr = Object.corp_gr [row]
		ls_fname = Object.fname [row]
      ldt = Object.ymd [row]

      SELECTBLOB  pdf
        INTO  :lb_pdf
      FROM    szx0ab  t1
      WHERE   corp_gr = :ls_corp_gr
        AND   ymd     = :ldt;
      IF SQLCA.sqlcode ()<>0  Then
         f_messageBox ('I002', ls_fname + ' 계약서 파일이 없습니다.')
         RETURN
      End IF

		enabled = false

      ls_fname = Object.company_name [row] + '(' + string (Object.ymd [row],'yyyy.mm.dd') + ') 계약서.pdf'

		IF	f_notnull (Object.org_fname [row])	Then
			filedelete (gaa.temp + ls_fname + '.zip')
			filedelete (gaa.temp + Object.org_fname [row])
			lb_return = mo_.hex2file (gaa.temp + ls_fname + '.zip', SQLCA.is_Hexfile)
			IF	lb_return	Then
				/* 압축풀기... */
				mo_.unzip (gaa.temp + ls_fname + '.zip', gaa.temp)
				filedelete (gaa.temp + ls_fname + '.zip')
			End IF
			ls_fname = Object.org_fname [row]
		Else
	      filedelete (gaa.temp + ls_fname)
			lb_return = mo_.Hex2File (gaa.temp + ls_fname, SQLCA.is_HexFile)
		End IF
		IF	NOT lb_return THEN f_messageBox ('ERR', '파일생성오류')

		ShellExecute (HANDLE (gw_mdi), 'open', ls_fname, '', gaa.temp, 1)

		enabled = true
END CHOOSE
end event

event dw_detail::doubleclicked;call super::doubleclicked;STRING	ls_path, ls_local, ls_corp_gr, ls_fname

Datetime	ldt

BLOB	lb_pdf

IF	dwo.name='fname'	Then
	IF f_notnull (Object.fname [row])   Then
		uf_setrow (row, false)
		IF f_messageBox ('I002','계약서를 변경하시겠습니까?')=2 THEN RETURN
	Else
		RETURN
	End IF		

	IF GetFileOpenName ("계약서 (스캔)PDF 선택", ls_path, ls_local, 'PDF', "PDF Files,*.pdf", gaa.pdf, 2)<>1 THEN RETURN

	IF uf_Update ()=FALSE THEN RETURN

	ls_corp_gr = Object.corp_gr [row]
	ldt        = Object.ymd [row]
	lb_pdf     = BLOB(" ")
	
	filedelete (ls_path + '.zip')
	IF	mo_.zip (ls_path, ls_path + '.zip', 'f')<>0	Then
		f_messagebox ('압축실패!','자료를 다시 LOAD하십시오.')
		RETURN
	Else
		SQLCA.setupdateBLOB_file (ls_path + '.zip')
		Object.org_fname [row] = ls_local
	End IF

	UPDATEBLOB  szx0ab
		SET  pdf = :lb_pdf
	WHERE   corp_gr = :ls_corp_gr
	  AND   ymd     = :ldt;
	IF SQLCA.sqlcode ()=0 THEN Object.fname [row] = '계약서.pdf'

	filedelete (ls_path + '.zip')
End IF
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_SetColumn ('corp_gr', dw_list.object.corp_gr [iRow])
uf_SetColumn ('ymd', string (idt_workdate))
uf_SetColumn ('company_name', dw_list.object.company_name [iRow])

POST SetColumn ('ymd')

RETURN 0
end event

event dw_detail::ue_protect;call super::ue_protect;IF row=1 THEN Modify (ia_protect [1]) ELSE Modify (ia_protect [2])
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.corp_gr [iRow])
end event

type st_move from wt_listdetail`st_move within w_ja010a
end type

