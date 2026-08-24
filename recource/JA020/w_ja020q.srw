forward
global type w_ja020q from wt_tablist
end type
type tabpage_1 from u_ja020q within tab_subpage
end type
type tabpage_1 from u_ja020q within tab_subpage
end type
type tabpage_2 from u_ja020q within tab_subpage
end type
type tabpage_2 from u_ja020q within tab_subpage
end type
type tabpage_3 from u_ja020q within tab_subpage
end type
type tabpage_3 from u_ja020q within tab_subpage
end type
type tabpage_4 from u_ja020q within tab_subpage
end type
type tabpage_4 from u_ja020q within tab_subpage
end type
type cb_1 from pf_u_commandbutton within w_ja020q
end type
type cb_2426 from pf_u_commandbutton within w_ja020q
end type
end forward

global type w_ja020q from wt_tablist
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
boolean ib_managedata = false
cb_1 cb_1
cb_2426 cb_2426
end type
global w_ja020q w_ja020q

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

SELECT :idt_workdate - 1
  INTO :ldt
  FROM DUAL;

dw_c.object.ymd [1] = SQLCA.getitemdatetime (1)
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_ja020q.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2426=create cb_2426
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2426
end on

on w_ja020q.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2426)
end on

type lb_dirlist from wt_tablist`lb_dirlist within w_ja020q
end type

type ln_templeft from wt_tablist`ln_templeft within w_ja020q
end type

type ln_tempbuttom from wt_tablist`ln_tempbuttom within w_ja020q
end type

type ln_temptop from wt_tablist`ln_temptop within w_ja020q
end type

type ln_tempbutton from wt_tablist`ln_tempbutton within w_ja020q
end type

type ln_tempstart from wt_tablist`ln_tempstart within w_ja020q
end type

type ln_cond1_yline from wt_tablist`ln_cond1_yline within w_ja020q
end type

type ln_dw1_yline from wt_tablist`ln_dw1_yline within w_ja020q
end type

type ln_cond2_yline from wt_tablist`ln_cond2_yline within w_ja020q
end type

type ln_dw2_yline from wt_tablist`ln_dw2_yline within w_ja020q
end type

type ln_tempright from wt_tablist`ln_tempright within w_ja020q
end type

type uo_navi from wt_tablist`uo_navi within w_ja020q
end type

type ln_temptop_shadow from wt_tablist`ln_temptop_shadow within w_ja020q
end type

type st_windelaytime from wt_tablist`st_windelaytime within w_ja020q
end type

type st_top_rect from wt_tablist`st_top_rect within w_ja020q
end type

type p_close from wt_tablist`p_close within w_ja020q
end type

type p_excel from wt_tablist`p_excel within w_ja020q
end type

type p_print from wt_tablist`p_print within w_ja020q
end type

type p_delete from wt_tablist`p_delete within w_ja020q
end type

type p_update from wt_tablist`p_update within w_ja020q
end type

type p_input from wt_tablist`p_input within w_ja020q
end type

type p_retrieve from wt_tablist`p_retrieve within w_ja020q
end type

type p_clear from wt_tablist`p_clear within w_ja020q
end type

type p_copy from wt_tablist`p_copy within w_ja020q
end type

type dw_c from wt_tablist`dw_c within w_ja020q
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_tablist`btn_update within w_ja020q
end type

type st_count from wt_tablist`st_count within w_ja020q
end type

type tab_subpage from wt_tablist`tab_subpage within w_ja020q
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type dw_list from wt_tablist`dw_list within w_ja020q
string dataobject = "d_uzm0hy"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mg_cd', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'series_gb', gaa.corp_gr, '', 1, "")
end event

event dw_list::rowfocuschanged;call fw_u_dwo::rowfocuschanged
IF currentrow=0 OR NOT enabled OR uf_getrange () THEN RETURN
f_loadingrd (true)
iRow = currentrow // POST로 CALL 하는 경우 현재 row 처리키 위해 반드시 필요
POST EVENT rowfocuschanged_if (currentrow)
event ue_protect (currentrow)
parent.dynamic post wf_setenabled ()
end event

type uo_tab from wt_tablist`uo_tab within w_ja020q
end type

type st_tab_move from wt_tablist`st_tab_move within w_ja020q
end type

type tabpage_1 from u_ja020q within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 1100
string text = "비율보고구간"
long tabbackcolor = 33554432
long picturemaskcolor = 134217858
end type

event ue_subpage_selected;call super::ue_subpage_selected;DATETIME	ldt, ldt_f, ldt_t, ldt_1f, ldt_1t, ldt_2f, ldt_2t, ldt_3f, ldt_3t
STRING	ls_fund_cd, ls_gugan, ls_g, ls_g1, ls_g2, ls_g3

DEC	ldc_m3_gu, ldc_g3_gu

IF AncestorReturnVALUE = 1 Then
   ldt        = dw_c.object.ymd [1]
   ls_fund_cd = dw_list.object.fund_cd [iRow]
   ls_gugan   = dw_list.object.gugan [iRow]
   
   SELECT gu.s3_fymd
        , gu.s3_tymd
        , gu.g3b_fymd
        , gu.g3b_tymd
        , gu.b3_fymd
        , gu.b3_tymd
        , '평균비율구간 : ' || TO_CHAR(gu.s3_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.s3_tymd,'yyyy.mm.dd') || ' ( ' || gu.s3_ilsu || ' 일)'
        , '평균비율구간 : ' || TO_CHAR(gu.g3b_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.g3b_tymd,'yyyy.mm.dd') || ' ( ' || gu.g3b_ilsu || ' 일)'
        , '평균비율구간 : ' || TO_CHAR(gu.b3_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.b3_tymd,'yyyy.mm.dd') || ' ( ' || gu.b3_ilsu || ' 일)'
        , gu.m3_gu
        , gu.g3_gu
     INTO :ldt_1f
        , :ldt_1t
        , :ldt_2f
        , :ldt_2t
        , :ldt_3f
        , :ldt_3t
        , :ls_g1
        , :ls_g2
        , :ls_g3
        , :ldc_m3_gu
        , :ldc_g3_gu
     FROM TABLE (F_GUGAN(:gaa.CORP_GR, :ls_fund_cd, :ldt)) gu ; 

   ldt_1f = SQLCA.getitemdatetime (1)
   ldt_1t = SQLCA.getitemdatetime (2)
   ldt_2f = SQLCA.getitemdatetime (3)
   ldt_2t = SQLCA.getitemdatetime (4)
   ldt_3f = SQLCA.getitemdatetime (5)
   ldt_3t = SQLCA.getitemdatetime (6)
   ls_g1  = SQLCA.GETITEMSTRING (7)
   ls_g2  = SQLCA.GETITEMSTRING (8)
   ls_g3  = SQLCA.GETITEMSTRING (9)
   ldc_m3_gu = SQLCA.GETITEMNUMBER (10)
   ldc_g3_gu = SQLCA.GETITEMNUMBER (11)

   IF ls_gugan = '1' Then
      IF ldc_m3_gu <= 2 Then
         ldt_f = ldt
         ldt_t = ldt
         ls_g  = '설정 후 3개월 미경과 구간 : ' + STRING (ldt, 'yyyy.mm.dd')
      ELSEIF ldc_m3_gu = 999  Then
         ldt_f = ldt
         ldt_t = ldt
         ls_g  = '만기3개월 미만 충족구간'
      ELSE
         ldt_f = ldt_1f
         ldt_t = ldt_1t
         ls_g  =  ls_g1
      END IF
   ELSEIF ls_gugan = '2'   Then
      IF ldc_g3_gu = 1  Then
         ldt_f = ldt
         ldt_t = ldt
         ls_g  = '설정 후 분기 3개월 미경과 구간 : ' + STRING (ldt, 'yyyy.mm.dd')
      ELSEIF ldc_g3_gu = 999  Then
         ldt_f = ldt_2f
         ldt_t = ldt_2t
         ls_g  = '만기전 3개월 제외구간 : ' + STRING (ldt_f, 'yyyy.mm.dd') + ' - ' + STRING (ldt_t, 'yyyy.mm.dd')
      ELSE
         ldt_f = ldt_2f
         ldt_t = ldt_2t
         ls_g  = ls_g2
      END IF
   ELSE
      ldt_f = ldt_3f
      ldt_t = ldt_3t
      ls_g  =  ls_g3
   END IF

   ole_rd.UF_FILEOPEN ('rd_ja020q.mrd', &
                       'fund_cd[' + ls_fund_cd + '] ' + &
                       'gugan[' + ls_g + '] ' + &
                       'fymd[' + STRING (ldt_f, 'yyyy.mm.dd') + '] ' + &
                       'tymd[' + STRING (ldt_t, 'yyyy.mm.dd') + ']')
END IF
RETURN 1
end event

type tabpage_2 from u_ja020q within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 1100
string text = "금투협구간"
end type

event ue_subpage_selected;call super::ue_subpage_selected;DATETIME	ldt, ldt_f, ldt_t, ldt_1f, ldt_1t, ldt_2f, ldt_2t, ldt_3f, ldt_3t
STRING	ls_fund_cd, ls_gugan, ls_g, ls_g1, ls_g2, ls_g3

DEC	ldc_m3_gu, ldc_g3_gu

IF AncestorReturnVALUE = 1 Then
   ldt        = dw_c.object.ymd [1]
   ls_fund_cd = dw_list.object.fund_cd [iRow]
   ls_gugan   = dw_list.object.gugan [iRow]

   SELECT gu.m3_fymd
        , gu.m3_tymd
        , gu.g3b_fymd
        , gu.g3b_tymd
        , gu.b3_fymd
        , gu.b3_tymd
        , '평균비율구간 : ' || TO_CHAR(gu.m3_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.m3_tymd,'yyyy.mm.dd') || ' ( ' || gu.m3_ilsu || ' 일)'
        , '평균비율구간 : ' || TO_CHAR(gu.g3b_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.g3b_tymd,'yyyy.mm.dd') || ' ( ' || gu.g3b_ilsu || ' 일)'
        , '평균비율구간 : ' || TO_CHAR(gu.b3_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.b3_tymd,'yyyy.mm.dd') || ' ( ' || gu.b3_ilsu || ' 일)'
        , gu.m3_gu
        , gu.g3_gu
     INTO :ldt_1f
        , :ldt_1t
        , :ldt_2f
        , :ldt_2t
        , :ldt_3f
        , :ldt_3t
        , :ls_g1
        , :ls_g2
        , :ls_g3
        , :ldc_m3_gu
        , :ldc_g3_gu
     FROM TABLE (F_GUGAN(:gaa.CORP_GR, :ls_fund_cd, :ldt)) gu ; 

   ldt_1f = SQLCA.getitemdatetime (1)
   ldt_1t = SQLCA.getitemdatetime (2)
   ldt_2f = SQLCA.getitemdatetime (3)
   ldt_2t = SQLCA.getitemdatetime (4)
   ldt_3f = SQLCA.getitemdatetime (5)
   ldt_3t = SQLCA.getitemdatetime (6)
   ls_g1  = SQLCA.GETITEMSTRING (7)
   ls_g2  = SQLCA.GETITEMSTRING (8)
   ls_g3  = SQLCA.GETITEMSTRING (9)
   ldc_m3_gu = SQLCA.GETITEMNUMBER (10)
   ldc_g3_gu = SQLCA.GETITEMNUMBER (11)

   IF ls_gugan = '1' Then
      IF ldc_m3_gu <= 2 Then
         ldt_f = ldt
         ldt_t = ldt
         ls_g  = '설정 후 3개월 미경과 구간 : ' + STRING (ldt, 'yyyy.mm.dd')
//      ELSEIF ldc_m3_gu = 999  Then
//         ldt_f = ldt
//         ldt_t = ldt
//         ls_g  = '만기3개월 미만 충족구간'
      ELSE
         ldt_f = ldt_1f
         ldt_t = ldt_1t
         ls_g  =  ls_g1
      END IF
   ELSEIF ls_gugan = '2'   Then
      IF ldc_g3_gu = 1  Then
         ldt_f = ldt
         ldt_t = ldt
         ls_g  = '설정 후 분기 3개월 미경과 구간 : ' + STRING (ldt, 'yyyy.mm.dd')
      ELSEIF ldc_g3_gu = 999  Then
         ldt_f = ldt_3f
         ldt_t = ldt_3t
         ls_g  = ls_g3
      ELSE
         ldt_f = ldt_3f
         ldt_t = ldt_3t
         ls_g  =  ls_g3
      END IF
   ELSE
      ldt_f = ldt_3f
      ldt_t = ldt_3t
      ls_g  =  ls_g3
   END IF

	IF	string (ldt_t,'yyyymm')>='202506'	Then
		// 비율도 평균으로
		ole_rd.UF_FILEOPEN ('rd_ja020q_202506.mrd', &
								  'fund_cd[' + ls_fund_cd + '] ' + &
								  'gugan[' + ls_g + '] ' + &
								  'fymd[' + STRING (ldt_f, 'yyyy.mm.dd') + '] ' + &
								  'tymd[' + STRING (ldt_t, 'yyyy.mm.dd') + ']')
	Else
		ole_rd.UF_FILEOPEN ('rd_ja020q.mrd', &
								  'fund_cd[' + ls_fund_cd + '] ' + &
								  'gugan[' + ls_g + '] ' + &
								  'fymd[' + STRING (ldt_f, 'yyyy.mm.dd') + '] ' + &
								  'tymd[' + STRING (ldt_t, 'yyyy.mm.dd') + ']')
	End IF
END IF
RETURN 1
end event

type tabpage_3 from u_ja020q within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 1100
string text = "주금납입능력(3개월)"
end type

event ue_subpage_selected;call super::ue_subpage_selected;DATETIME	ldt, ldt_f
STRING	ls_fund_cd, ls_g

IF AncestorReturnVALUE = 1 Then
   ldt        = dw_c.object.ymd [1]
   ls_fund_cd = dw_list.object.fund_cd [iRow]
   
   SELECT add_months (:ldt, -3) + 1
        , '3개월구간 : ' || TO_CHAR(add_months (:ldt, -3) + 1,'yyyy.mm.dd') || ' - ' || TO_CHAR(:ldt,'yyyy.mm.dd')
     INTO :ldt_f
        , :ls_g
     FROM DUAL;

   ldt_f = SQLCA.getitemdatetime (1)
   ls_g  = SQLCA.GETITEMSTRING (2)

   ole_rd.UF_FILEOPEN ('rd_ja020q.mrd', &
                       'fund_cd[' + ls_fund_cd + '] ' + &
                       'gugan[' + ls_g + '] ' + &
                       'fymd[' + STRING (ldt_f, 'yyyy.mm.dd') + '] ' + &
                       'tymd[' + STRING (ldt, 'yyyy.mm.dd') + ']')
END IF
RETURN 1
end event

type tabpage_4 from u_ja020q within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 1100
string text = "전구간"
end type

event ue_subpage_selected;call super::ue_subpage_selected;DATETIME	ldt, ldt_f
STRING	ls_fund_cd, ls_g

IF AncestorReturnVALUE = 1 Then
   ldt        = dw_c.object.ymd [1]
   ls_fund_cd = dw_list.object.fund_cd [iRow]
   
   SELECT FST_SEOLJ_YMD
        , '전구간 : ' || TO_CHAR(FST_SEOLJ_YMD,'yyyy.mm.dd') || ' - ' || TO_CHAR(:ldt,'yyyy.mm.dd')
     INTO :ldt_f
        , :ls_g
     FROM SZM0IA t1
    WHERE t1.CORP_GR = :gaa.CORP_GR
      AND t1.fund_cd = :ls_fund_cd ;

   ldt_f = SQLCA.getitemdatetime (1)
   ls_g  = SQLCA.GETITEMSTRING (2)

   ole_rd.UF_FILEOPEN ('rd_ja020q.mrd', &
                       'fund_cd[' + ls_fund_cd + '] ' + &
                       'gugan[' + ls_g + '] ' + &
                       'fymd[' + STRING (ldt_f, 'yyyy.mm.dd') + '] ' + &
                       'tymd[' + STRING (ldt, 'yyyy.mm.dd') + ']')
END IF
RETURN 1
end event

type cb_1 from pf_u_commandbutton within w_ja020q
integer x = 2281
integer y = 16
integer width = 562
integer taborder = 100
boolean bringtotop = true
string text = "기존엑셀IMPORT"
end type

event clicked;call super::clicked;oleobject   ole_xls, lSheet

BOOLEAN	lb_pass
DATETIME ldt_ymd
STRING	ls_title, ls_fund_cd, ls_column

LONG	ll, lc, lRC, POS []
DEC	ldc_amt []

// Create the oleobject variable ole_xls
ole_xls = CREATE OLEObject

// Connect to Excel and check the return code
IF ole_xls.ConnectToObject ("", "excel.application")<0   Then  // 현재 실행되어 있는 엑셀 Connect
   f_messageBox ('XLS1', 'IMPORT할 자료를 엑셀로 읽어 들이십시오.')
   RETURN
End IF

// Make Excel visible
ole_xls.Application.Visible = TRUE
ole_xls.Application.ScreenUpdating = TRUE

ls_title = ole_xls.Application.caption   // 엑셀 실행 Title

lSheet = ole_xls.Application.ActiveSheet
ls_fund_cd = lSheet.name

st_count.visible = TRUE

lRC = lSheet.UsedRange.Rows.Count

// title 점검
POS = {0,0,0,0,0,0,0,0,0,0,0}
FOR  ll = 1  TO  20
   f_st_count (st_count, '수요예측자료 IMPORT(title) : ', ll, lRC)
   FOR  lc = 1  TO  50
      ls_column = f_replace (STRING (lSheet.cells (ll,lc).Value),' ','')
      ls_column = f_replace (ls_column,'~r','')
      ls_column = f_replace (ls_column,'~n','')
      CHOOSE CASE ls_column
         CASE '브레이크'
            EXIT
         CASE 'bond_s'        // 전단채
            POS [1] = lc
         CASE 'bond_under'    // 비우량채권
            POS [2] = lc
         CASE 'bond_a'        // 우량채권
            POS [3] = lc
         CASE 'bond_s_under'  // 전단채+비우량채
            POS [4] = lc
         CASE 'stock_d'       // 코넥스
            POS [5] = lc
         CASE 'stock_tot'     // 주식합계
            POS [6] = lc
         CASE 'cash'          // 예금
            POS [7] = lc
         CASE 'total'         // 총자산
            POS [8] = lc
         CASE 'nav'           // 순자산
            POS [9] = lc
         CASE 'wonbon'        // 원본액
            POS [10] = lc
      END CHOOSE
   NEXT
   IF ls_column='브레이크' THEN EXIT
NEXT
FOR  ll = 1  TO  11
   IF POS [ll]=0  Then
      CHOOSE CASE ll
         CASE 1
            messagebox ('1', '잔단채 항목 타이틀이 없습니다.')
         CASE 2
            messagebox ('2', '비우량채권 항목 타이틀이 없습니다.')
         CASE 3
            messagebox ('3', '우량채권 항목 타이틀이 없습니다.')
         CASE 4
            messagebox ('4', '전단채+비우량채 항목 타이틀이 없습니다.')
         CASE 5
            messagebox ('5', '코넥스 항목 타이틀이 없습니다.')
         CASE 6
            messagebox ('6', '주식합계 항목 타이틀이 없습니다.')
         CASE 7
            messagebox ('7', '예금 항목 타이틀이 없습니다.')
         CASE 8
            messagebox ('8', '총자산 항목 타이틀이 없습니다.')
         CASE 9
            messagebox ('9', '순자산 항목 타이틀이 없습니다.')
         CASE 10
            messagebox ('10', '원본액 항목 타이틀이 없습니다.')
      END CHOOSE
   End IF
NEXT

f_loadingyield ('start')

FOR  ll = ll  TO  lRC
   IF f_loadingyield ('exit') THEN EXIT
   f_st_count (st_count, '수요예측자료 IMPORT(data) : ', ll, lRC)
   ldt_ymd = DATETIME (DATE (STRING (lSheet.cells (ll,2).Value)))
   IF f_null (ldt_ymd) THEN CONTINUE
   IF ldt_ymd=dw_c.object.ymd [1] THEN EXIT
   FOR  lc = 1  TO  11
      IF POS [lc]=0  Then
         ldc_amt [lc] = 0
      Else
         ldc_amt [lc] = f_num (lSheet.cells (ll, POS [lc]).Value)
      End IF
   NEXT
   IF NOT lb_pass Then
      // 최초 작업시 삭제처리
      DELETE FROM UZM0HY tt
       WHERE corp_gr = :gaa.corp_gr
         AND fund_cd = :ls_fund_cd;
      lb_pass = TRUE
   End IF
   INSERT INTO UZM0HY tt
       ( corp_gr       /* _1- */
       , ymd           /* _2- */
       , fund_cd       /* _3- */
       , bond_s        /* _4- */
       , bond_under    /* _5- */
       , bond_a        /* _6- */
       , bond_b        /* _7- */
       , bond_s_under  /* _8- */
       , stock_d       /* _9- */
       , stock_a       /* _10- */
       , stock_tot     /* _11- */
       , deposit_tday  /* _12- */
       , total_asset   /* _13- */
       , nav           /* _14- */
       , invest_amt    /* _15- */
       , ip_user       /* _16- */
       )
   VALUES ( :gaa.corp_gr               /* _1- */
          , :ldt_ymd                   /* _2- */
          , :ls_fund_cd                /* _3- */
          , :ldc_amt[1]                /* _4-bond_s */
          , :ldc_amt[2]                /* _5-bond_under */
          , :ldc_amt[3]                /* _6-bond_a */
          , :ldc_amt[2] + :ldc_amt[3]  /* _7-bond_b */
          , :ldc_amt[4]                /* _8-bond_s_under */
          , :ldc_amt[5]                /* _9-stock_d */
          , :ldc_amt[6] - :ldc_amt[5]  /* _10- */
          , :ldc_amt[6]                /* _11-stock_tot */
          , :ldc_amt[7]                /* _12-cash */
          , :ldc_amt[8]                /* _13-total */
          , :ldc_amt[9]                /* _14-nav */
          , :ldc_amt[10]               /* _15-wonbon */
          , 'LOAD'                     /* _16- */
          );
NEXT
commitJ ()

f_loadingyield ('stop')

st_count.visible = FALSE

ole_xls.DisConnectObject ()
DESTROY ole_xls

messagebox ('작업완료', 'IMPORT 완료')
end event

type cb_2426 from pf_u_commandbutton within w_ja020q
boolean visible = false
integer x = 2176
integer y = 180
integer width = 507
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "2426 IMPORT"
end type

event clicked;call super::clicked;oleobject   ole_xls, lSheet

DATETIME ldt_ymd
STRING	ls_title, ls_fund_cd

LONG	ll, lc, lRC
DEC	ldc_amt

// Create the oleobject variable ole_xls
ole_xls = CREATE OLEObject

// Connect to Excel and check the return code
IF ole_xls.ConnectToObject ("", "excel.application")<0 THEN // 현재 실행되어 있는 엑셀 Connect
   F_MESSAGEBOX ('XLS1', '2426 IMPORT할 자료를 엑셀로 읽어 들이십시오.')
   RETURN
End IF

// Make Excel visible
ole_xls.Application.Visible = TRUE
ole_xls.Application.ScreenUpdating = TRUE

ls_title = ole_xls.Application.caption   // 엑셀 실행 Title

lSheet = ole_xls.Application.ActiveSheet
ls_fund_cd = lSheet.name

st_count.visible = TRUE

lRC = lSheet.UsedRange.Rows.Count

F_LOADINGYIELD ('start')

FOR  ll = 5  TO  61
   IF F_LOADINGYIELD ('exit') THEN EXIT
   F_ST_COUNT (st_count, '수요예측자료 IMPORT(data) : ', ll, lRC)

   ldt_ymd = DATETIME (DATE (STRING (lSheet.cells (ll,2).Value)))
   ldc_amt = F_NUM (lSheet.cells (ll,6).Value)

   UPDATE UZM0HY
      SET total_asset = :ldc_amt
        , ip_user     = 'LOAD'
    WHERE corp_gr = '2402'
      AND ymd     = :ldt_ymd
      AND fund_cd = '2426';
NEXT
commitJ ()

F_LOADINGYIELD ('stop')

st_count.visible = FALSE

ole_xls.DisConnectObject ()
DESTROY ole_xls

messagebox ('작업완료', '2426 IMPORT 완료')
end event

