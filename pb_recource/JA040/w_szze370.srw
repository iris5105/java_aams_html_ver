forward
global type w_szze370 from wt_list
end type
type cb_xls from pf_u_commandbutton within w_szze370
end type
type cb_sjm0sm from pf_u_commandbutton within w_szze370
end type
end forward

global type w_szze370 from wt_list
cb_xls cb_xls
cb_sjm0sm cb_sjm0sm
end type
global w_szze370 w_szze370

type variables

end variables

on w_szze370.create
int iCurrent
call super::create
this.cb_xls=create cb_xls
this.cb_sjm0sm=create cb_sjm0sm
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_xls
this.Control[iCurrent+2]=this.cb_sjm0sm
end on

on w_szze370.destroy
call super::destroy
destroy(this.cb_xls)
destroy(this.cb_sjm0sm)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], dw_c.object.work_gb [1], &
                           dw_c.object.fund_cd [1], dw_c.object.upmu_gb [1], &
                           dw_c.object.tr_cd [1], dw_c.object.seq_no [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.seq_no [1] = 0
end event

event open;icmdbutton = { cb_xls, cb_sjm0sm }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_szze370
end type

type ln_templeft from wt_list`ln_templeft within w_szze370
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_szze370
end type

type ln_temptop from wt_list`ln_temptop within w_szze370
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_szze370
end type

type ln_tempstart from wt_list`ln_tempstart within w_szze370
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_szze370
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_szze370
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_szze370
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_szze370
end type

type ln_tempright from wt_list`ln_tempright within w_szze370
end type

type uo_navi from wt_list`uo_navi within w_szze370
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_szze370
end type

type st_windelaytime from wt_list`st_windelaytime within w_szze370
end type

type st_top_rect from wt_list`st_top_rect within w_szze370
end type

type p_close from wt_list`p_close within w_szze370
end type

type p_excel from wt_list`p_excel within w_szze370
end type

type p_print from wt_list`p_print within w_szze370
end type

type p_delete from wt_list`p_delete within w_szze370
end type

type p_update from wt_list`p_update within w_szze370
end type

type p_input from wt_list`p_input within w_szze370
end type

type p_retrieve from wt_list`p_retrieve within w_szze370
end type

type p_clear from wt_list`p_clear within w_szze370
end type

type p_copy from wt_list`p_copy within w_szze370
end type

type dw_c from wt_list`dw_c within w_szze370
string dataobject = "d_szze370_1"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;dw_c.object.work_gb [1] = F_DDDWCTL (THIS, 'work_gb', gaa.corp_gr, '', 1, '')
dw_c.object.upmu_gb [1] = F_DDDWCTL (THIS, 'upmu_gb', gaa.corp_gr, '', 1, '')
end event

event dw_c::ue_valid;call super::ue_valid;IF f_null (Object.tr_cd [1])  Then
   f_messageBox ('I000','거래코드를 입력하십시오.')
   SetColumn ('tr_cd')
   RETURN FALSE
End IF

IF f_null (Object.fund_cd [1])   Then
   f_messageBox ('I000','펀드코드를 입력하십시오.')
   SetColumn ('fund_cd')
   RETURN FALSE
End IF

IF gaa.Admin OR gaa.aams   Then
   ib_managedata = TRUE
Else
   ib_managedata = (dw_c.object.tr_ymd [1] >= uf_initdate ('inputdate'))
End IF

IF dw_c.object.seq_no [1]=0   Then
   DateTime dTr_ymd

   STRING	sWork_gb, sFund_cd, sUpmu_gb, sTr_cd

   LONG	lSeq_no

   dTr_ymd  = dw_c.object.tr_ymd [1]
   sWork_gb = dw_c.object.work_gb [1]
   sFund_cd = dw_c.object.fund_cd [1]
   sUpmu_gb = dw_c.object.upmu_gb [1]
   sTr_cd   = dw_c.object.tr_cd [1]

   SELECT  NVL(MAX(t1.seq_no),0)
     INTO  :lSeq_no
   FROM    aams.skt0bu t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.tr_ymd  = :dTr_ymd
     AND   t1.tr_cd   = :sTr_cd
     AND   t1.fund_cd = :sFund_cd
     AND   t1.work_gb = :sWork_gb
     AND   t1.upmu_gb = :sUpmu_gb;
	  lSeq_no = SQLCA.getitemnumber (1)

   lSeq_no ++
   dw_c.object.seq_no [1] = lSeq_no
End IF

RETURN TRUE
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_Where = "(haeji_ymd is null or haeji_ymd >= '" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "')"
      RETURN 60
END CHOOSE
RETURN 1
end event

event dw_c::ue_getdate;INT   li_rtn

SELECT sign(count(*))
  INTO :li_rtn
FROM   aams.skt0bu t1
WHERE  corp_gr   = :gaa.corp_gr
  AND  tr_ymd    = :rs_ymd
  AND  proc_step = 9;

li_rtn = SQLCA.getitemnumber (1)

RETURN li_rtn
end event

type btn_update from wt_list`btn_update within w_szze370
end type

type st_count from wt_list`st_count within w_szze370
end type

type dw_list from wt_list`dw_list within w_szze370
string dataobject = "d_szze370_2"
boolean eb_copy_false = true
string is_resize_column = "bigo"
end type

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1
IF rowcount ()=0 THEN RETURN

IF (dw_list.object.d_sum [1] - dw_list.object.c_sum [1])<>0 Then
   f_messagebox ("I000", "대차 금액차이 오류")
   RETURN 1
End IF
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'jasan_gb', gaa.corp_gr, '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

CHOOSE CASE dwo.name
   CASE 'd_aek'
      IF dec (data)<>0 THEN
         SetItem (row, "c_aek", 0)
         SetItem (row, "chadae_gb", 'D')
         SetItem (row, "aek", dec (data))
      End IF
   CASE 'c_aek'
      IF dec (data)<>0 THEN
         SetItem (row, "d_aek", 0)
         SetItem (row, "chadae_gb", 'C')
         SetItem (row, "aek", dec (data))
      End IF
   CASE 'bigo'
      uf_SetColumn ('bigo', data)
      FOR  ll = 1  TO  rowcount ()
         IF f_null (Object.bigo [ll]) THEN Object.bigo [ll] = data
      NEXT
END CHOOSE
end event

event dw_list::retrieverow;call super::retrieverow;IF Object.chadae_gb [row]='D' THEN
   Object.d_aek [row] = Object.aek [row]
   Object.c_aek [row] = 0
ElseIF Object.chadae_gb [row]='C' THEN
   Object.d_aek [row] = 0
   Object.c_aek [row] = Object.aek [row]
End IF
f_dw_resetstatus (THIS, row, {'c_aek','d_aek'})
end event

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	lFind

uf_SetColumn ('tr_ymd',  string (dw_c.object.tr_ymd [1]))
uf_SetColumn ('work_gb', dw_c.object.work_gb [1])
uf_SetColumn ('fund_cd', dw_c.object.fund_cd [1])
uf_SetColumn ('upmu_gb', dw_c.object.upmu_gb [1])
uf_SetColumn ('tr_cd',   dw_c.object.tr_cd [1])
uf_SetColumn ('jeokyo_cd',  dw_c.object.tr_cd [1])
uf_SetColumn ('xx_jeokyo_cd',  dw_c.object.xx_tr_cd [1])
uf_SetColumn ('seq_no',  string (dw_c.object.seq_no [1]))
uf_SetColumn ('chasu',  '0')
uf_SetColumn ('proc_step',  '9')
uf_SetColumn ('fund_currency', dw_c.object.fund_currency [1])

INT   iRow_no = 0

lFind =  Find ('row_no > ' + string (iRow_no), 1, rowcount ())
DO UNTIL lFind = 0
   iRow_no = GetItemNumber (lFind, 'row_no')
   lFind = Find ('row_no > ' + string (iRow_no), lFind, rowcount () + 1)
LOOP
iRow_no ++
uf_SetColumn ('row_no', string (iRow_no))

POST SetColumn ('gwamok')

RETURN 0
end event

event dw_list::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'd_aek'
      Object.d_aek [row] = f_num (Object.c_sum [1]) - f_num (Object.d_sum [1])
      Object.chadae_gb [row] = 'D'
      Object.aek [row] = Object.d_aek [row]
   CASE 'c_aek'
      Object.c_aek [row] = f_num (Object.d_sum [1]) - f_num (Object.c_sum [1])
      Object.chadae_gb [row] = 'C'
      Object.aek [row] = Object.c_aek [row]
END CHOOSE
end event

event dw_list::ue_setcodesearch;CHOOSE CASE	GetColumnName()
	CASE 'gwamok'
		RETURN 9
END CHOOSE
RETURN 1
end event

type cb_xls from pf_u_commandbutton within w_szze370
integer x = 2231
integer y = 16
integer width = 411
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "원장IMPORT"
end type

event clicked;ads_jTier   lds

oleobject   xlApp, lSheet

Datetime ldt_tr_ymd, ldt_max

LONG	ll_title = 1, ll_sheet, lPos, ll, lm, lj, lRC, lR

STRING	ls_title, ls_work_gb, ls_upmu_gb, ls_fund_cd, ls_sqlsyntax, ls_samu_gwamok, ls_gwamok, ls_chadae_gb

DEC	ldc_row_no, ldc_dr, ldc_cr, ldc_aek, ldc_com

lds = CREATE ads_jTier

ldt_tr_ymd = dw_c.object.tr_ymd [1]
ls_work_gb = dw_c.object.work_gb [1]
ls_upmu_gb = dw_c.object.upmu_gb [1]

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

// Connect to Excel and check the return code
IF xlApp.ConnectToObject ("", "excel.application")<0  Then  // 현재 실행되어 있는 엑셀 Connect
   f_messageBox ('XLS1', 'IMPORT할 자료를 엑셀로 읽어 들이십시오.')
   RETURN
End IF

// Make Excel visible
xlApp.Application.Visible = TRUE
xlApp.Application.ScreenUpdating = TRUE

ls_title = xlApp.Application.caption   // 엑셀 실행 Title
//lPos = POS (ls_title,'_')
//IF lPos>0   Then
//   ls_title = TRIM (MID (ls_title, lPos + 1))
//	ls_title = MID (ls_title, 1, POS (ls_title, '.') - 1)
//   IF string (ldt_tr_ymd,'mmdd')<>RIGHT (ls_title,4)  Then
//      messagebox ('INFO', '자료 일자를 왁인하십시오.' + ls_title)
//      RETURN
//   End IF
//End IF

f_loadingyield ('start')

st_count.visible = TRUE
ll_sheet = xlApp.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기
FOR  ll = 1  TO  ll_sheet
   IF f_loadingyield ('exit') THEN EXIT

   lSheet = xlApp.Application.Workbooks (1).worksheets (ll)
   lSheet.Activate
   lRC = lSheet.UsedRange.Rows.Count
//   IF lRC>5000 THEN lRC = lSheet.Cells (65536, 1).End (3).Row

   ls_fund_cd = lSheet.name
   f_microhelp (ls_fund_cd + ' 자료 업로드 중...')

   SELECT max(ymd)
     INTO :ldt_max
   FROM   aams.skm0ag t1
   WHERE  t1.corp_gr = :gaa.corp_gr
     AND  t1.ymd     Between  add_months (:ldt_tr_ymd, -12) And :ldt_tr_ymd - 1
     AND  t1.work_gb = :ls_work_gb
     AND  t1.fund_cd = :ls_fund_cd;

   IF SQLCA.sqlcode ()=0   Then
      ldt_max = SQLCA.getitemdatetime (1)

      INSERT INTO aams.skm0ag
       select corp_gr         /* _1: */
           , :ldt_tr_ymd      /* _2: */
           , :ls_work_gb      /* _3: */
           , fund_cd          /* _4: */
           , gwamok           /* _5: */
           , chadae_gb        /* _6: */
           , CASE WHEN chadae_gb='D' THEN NVL(junj,0) + nvl(dr_aek,0) - nvl(cr_aek,0)
                                     ELSE NVL(junj,0) - nvl(dr_aek,0) + nvl(cr_aek,0)
             END              /* _7: */
           , CASE WHEN chadae_gb='D' THEN NVL(junj,0) + nvl(dr_aek,0) - nvl(cr_aek,0)
                                     ELSE 0
             END * -1         /* _8: */
           , CASE WHEN chadae_gb='C' THEN NVL(junj,0) - nvl(dr_aek,0) + nvl(cr_aek,0)
                                     ELSE 0
             END * -1         /* _9: */
           , fund_currency    /* _10: */
        from aams.skm0ag t1
       where t1.corp_gr = :gaa.corp_gr
         and t1.ymd     = :ldt_max
         and t1.work_gb = :ls_work_gb
         and t1.fund_cd = :ls_fund_cd;

      commitJ ()
   Else
      ldt_max = ldt_tr_ymd
   End IF

   ldc_row_no = 0
   FOR  lm = 2  TO  lRC
      IF f_loadingyield ('exit') THEN EXIT
      f_st_count (st_count, ls_fund_cd + ' : ', lm, lRC)

      ls_samu_gwamok = string (lSheet.cells (lm, 5).Value)
      ldc_dr         = f_num (lSheet.cells (lm, 2).Value)
      ldc_cr         = f_num (lSheet.cells (lm, 9).Value)
      IF ldc_dr=0 And ldc_cr=0 THEN CONTINUE
      IF ldc_dr=0 Then
         ls_chadae_gb = 'C'
         ldc_aek      = ldc_cr
      Else
         ls_chadae_gb = 'D'
         ldc_aek      = ldc_dr
      End IF

      ls_sqlsyntax = " SELECT t1.gwamok " + &
                     "      , gm.gwamok_gb " + &
                     "      , decode (instr(samu_gwamok_nm,'-1'), 0, 1, -1) " + &
                     " FROM   aams.SZX0GM_SAMU t1 " + &
                     "      , aams.SZX0GM gm " + &
                     " WHERE  t1.samu        = '80003' " + &
                     "   AND  t1.samu_gwamok = '" + ls_samu_gwamok + "' " + &
                     "   AND  gm.gwamok      = t1.gwamok " + &
                     " ORDER BY  1 desc "
      lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds, 'sqlm')
      IF lR=0  Then
         lSheet.cells (lm, 6).Value = lSheet.cells (lm, 6).Value + '(PASS)'
      Else
         lSheet.cells (lm, 6).Value = 'ok'
         FOR  lj = 1  TO  lR
            ldc_row_no ++

            ls_gwamok = lds.getitemstring (lj, 1)
            ldc_com   = f_num (lds.getitemstring (lj, 3))
            IF lds.getitemstring (lj,2)='9'  Then
               IF ldt_max<ldt_tr_ymd   Then
                  UPDATE aams.skm0ag
                     SET dr_aek = NVL(dr_aek,0) + (:ldc_aek * :ldc_com)
                  WHERE  corp_gr = :gaa.corp_gr
                    AND  fund_cd = :ls_fund_cd
                    AND  ymd     = :ldt_tr_ymd
                    AND  work_gb = :ls_work_gb
                    AND  gwamok  = :ls_gwamok;
                  IF SQLCA.sqlnrows ()=0  Then
                     INSERT INTO aams.skm0ag
                     VALUES ( :gaa.corp_gr           /* _1: */
                            , :ldt_tr_ymd            /* _2: */
                            , :ls_work_gb            /* _3: */
                            , :ls_fund_cd            /* _4: */
                            , :ls_gwamok             /* _5: */
                            , 'D'                    /* _6: */
                            , 0                      /* _7: */
                            , :ldc_aek * :ldc_com    /* _8: */
                            , 0                      /* _9: */
                            , 'KRW'                  /* _10: */
                            );
                  End IF
               Else
                  UPDATE aams.skm0ag
                     SET dr_aek = NVL(dr_aek,0) + (:ldc_aek * :ldc_com)
                  WHERE  corp_gr = :gaa.corp_gr
                    AND  fund_cd = :ls_fund_cd
                    AND  ymd     = :ldt_tr_ymd
                    AND  work_gb = :ls_work_gb
                    AND  gwamok  = :ls_gwamok;
                  IF SQLCA.sqlnrows ()=0  Then
                     INSERT INTO aams.skm0ag
                     VALUES ( :gaa.corp_gr           /* _1: */
                            , :ldt_tr_ymd            /* _2: */
                            , :ls_work_gb            /* _3: */
                            , :ls_fund_cd            /* _4: */
                            , :ls_gwamok             /* _5: */
                            , 'D'                    /* _6: */
                            , 0                      /* _7: */
                            , :ldc_aek * :ldc_com    /* _8: */
                            , 0                      /* _9: */
                            , 'KRW'                  /* _10: */
                            );
                  End IF
               End IF
            Else
               INSERT INTO aams.skt0bu
               VALUES ( :gaa.corp_gr           /* _1: */
                      , :ldt_tr_ymd            /* _2: */
                      , :ls_work_gb            /* _3: */
                      , :ls_fund_cd            /* _4: */
                      , :ls_upmu_gb            /* _5: */
                      , 'Z99'                  /* _6: */
                      , ''                     /* _7: */
                      , 1                      /* _8: */
                      , 1                      /* _9: */
                      , :ldc_row_no            /* _10: */
                      , :ls_chadae_gb          /* _11: */
                      , :ls_gwamok             /* _12: */
                      , :ldc_aek * :ldc_com    /* _13: */
                      , 'Z99'                  /* _14: */
                      , 9                      /* _15: */
                      , '  '                   /* _16: */
                      , 'KRW'                  /* _17: */
                      );
               End IF
         NEXT
      End IF
   NEXT
NEXT
commitJ ()

f_loadingyield ('stop')
st_count.visible = FALSE

xlApp.DisConnectObject ()
DESTROY xlApp

messagebox ('작업완료', '총계정원장 IMPORT를 완료 했습니다.')
end event

type cb_sjm0sm from pf_u_commandbutton within w_szze370
integer x = 2656
integer y = 16
integer width = 571
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "모펀드잔고IMPORT"
end type

event clicked;oleobject   xlApp, lSheet

Datetime ldt_tr_ymd

LONG	ll_sheet, ll, lRC, lm

STRING	ls_fund_cd, ls_mo_fund_cd

DEC	ldc_jwa, ldc_aek, ldc_sonik, ldc_gaek, ldc_gsonik

ldt_tr_ymd = dw_c.object.tr_ymd [1]

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

// Connect to Excel and check the return code
IF xlApp.ConnectToObject ("", "excel.application")<0  Then  // 현재 실행되어 있는 엑셀 Connect
   f_messageBox ('XLS1', 'IMPORT할 자료를 엑셀로 읽어 들이십시오.')
   RETURN
End IF

// Make Excel visible
xlApp.Application.Visible = TRUE
xlApp.Application.ScreenUpdating = TRUE

f_loadingyield ('start')

st_count.visible = TRUE
ll_sheet = xlApp.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기
FOR  ll = 1  TO  ll_sheet
   IF f_loadingyield ('exit') THEN EXIT

   lSheet = xlApp.Application.Workbooks (1).worksheets (ll) ; lSheet.Activate
   lRC = lSheet.UsedRange.Rows.Count

   IF POS (string (lSheet.cells (5, 1).Value),string (ldt_tr_ymd,'yyyy.mm.dd'))=0   Then
		f_loadingyield ('stop')
      messagebox ('자료기준일 확인',string (lSheet.cells (5, 1).Value))
      RETURN
   End IF

   FOR  lm = 12  TO  lRC  STEP 4
      ls_fund_cd    = string (lSheet.cells (lm, 1).Value)
      ls_mo_fund_cd = string (lSheet.cells (lm, 4).Value)
		IF	f_null (ls_mo_fund_cd) THEN EXIT

   	f_microhelp (ls_fund_cd + ' 자료 업로드 중...')
	
      ldc_jwa     = f_num (lSheet.cells (lm, 7).Value)
      ldc_aek     = f_num (lSheet.cells (lm, 8).Value)
      ldc_sonik   = f_num (lSheet.cells (lm,10).Value)
      ldc_gaek    = f_num (lSheet.cells (lm + 1, 8).Value)
      ldc_gsonik  = f_num (lSheet.cells (lm + 1,10).Value)

      INSERT INTO aams.sjm0sm (
                     corp_gr       /* _1: */
                   , ymd           /* _2: */
                   , fund_cd       /* _3: */
                   , mo_fund_cd    /* _4: */
                   , bfil_jwa      /* _5: */
                   , bfil_aek      /* _6: */
                   , sonik         /* _7: */
                   , gbfil_aek     /* _8: */
                   , gsonik )      /* _9: */
      VALUES ( :gaa.corp_gr      /* _1: */
             , :ldt_tr_ymd       /* _2: */
             , :ls_fund_cd       /* _3: */
             , :ls_mo_fund_cd    /* _4: */
             , :ldc_jwa          /* _5: */
             , :ldc_aek          /* _6: */
             , :ldc_sonik        /* _7: */
             , :ldc_gaek         /* _8: */
             , :ldc_gsonik       /* _9: */
             );
   NEXT
NEXT
commitJ ()

f_loadingyield ('stop')
st_count.visible = FALSE

xlApp.DisConnectObject ()
DESTROY xlApp

messagebox ('작업완료', '수익증권 보유현황 IMPORT를 완료 했습니다.')
end event

