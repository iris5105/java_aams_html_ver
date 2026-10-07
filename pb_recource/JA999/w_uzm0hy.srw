forward
global type w_uzm0hy from wt_listole
end type
type cb_1 from pf_u_commandbutton within w_uzm0hy
end type
type cbx_3mon from pf_u_checkbox within w_uzm0hy
end type
end forward

global type w_uzm0hy from wt_listole
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
cb_1 cb_1
cbx_3mon cbx_3mon
end type
global w_uzm0hy w_uzm0hy

event open;icmdbutton = { cb_1 }
cb_1.of_setvisible (gaa.admin)
call super::open
end event

event wue_lastopen;call super::wue_lastopen;IF	gaa.admin THEN cbx_3mon.visible = true
dw_c.object.ymd [1] = f_gijunga_ymd ('')
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_uzm0hy.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cbx_3mon=create cbx_3mon
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_3mon
end on

on w_uzm0hy.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cbx_3mon)
end on

type lb_dirlist from wt_listole`lb_dirlist within w_uzm0hy
end type

type ln_templeft from wt_listole`ln_templeft within w_uzm0hy
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_uzm0hy
end type

type ln_temptop from wt_listole`ln_temptop within w_uzm0hy
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_uzm0hy
end type

type ln_tempstart from wt_listole`ln_tempstart within w_uzm0hy
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_uzm0hy
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_uzm0hy
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_uzm0hy
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_uzm0hy
end type

type ln_tempright from wt_listole`ln_tempright within w_uzm0hy
end type

type uo_navi from wt_listole`uo_navi within w_uzm0hy
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_uzm0hy
end type

type st_windelaytime from wt_listole`st_windelaytime within w_uzm0hy
end type

type st_top_rect from wt_listole`st_top_rect within w_uzm0hy
end type

type p_close from wt_listole`p_close within w_uzm0hy
end type

type p_excel from wt_listole`p_excel within w_uzm0hy
end type

type p_print from wt_listole`p_print within w_uzm0hy
end type

type p_delete from wt_listole`p_delete within w_uzm0hy
end type

type p_update from wt_listole`p_update within w_uzm0hy
end type

type p_input from wt_listole`p_input within w_uzm0hy
end type

type p_retrieve from wt_listole`p_retrieve within w_uzm0hy
end type

type p_clear from wt_listole`p_clear within w_uzm0hy
end type

type p_copy from wt_listole`p_copy within w_uzm0hy
end type

type dw_c from wt_listole`dw_c within w_uzm0hy
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listole`btn_update within w_uzm0hy
end type

type st_count from wt_listole`st_count within w_uzm0hy
end type

type dw_list from wt_listole`dw_list within w_uzm0hy
boolean visible = true
boolean enabled = true
string dataobject = "d_uzm0hy"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mg_cd', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'series_gb', gaa.corp_gr, '', 1, "")
end event

type st_move from wt_listole`st_move within w_uzm0hy
end type

type ole_rd from wt_listole`ole_rd within w_uzm0hy
boolean eb_openpagerd = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;uf_fileopen ('rd_uzm0hy.mrd', &
                           'fund_cd[' + dw_list.object.fund_cd [row] + '] ' + &
                           'ymd[' + STRING (dw_c.object.ymd [1],'yyyymmdd') + ']' )
end event

type rb_onepage from wt_listole`rb_onepage within w_uzm0hy
end type

type cb_1 from pf_u_commandbutton within w_uzm0hy
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

type cbx_3mon from pf_u_checkbox within w_uzm0hy
integer x = 1394
integer y = 200
integer width = 594
boolean bringtotop = true
string text = "3개월평잔(admin)"
boolean setcondcolor = true
end type

