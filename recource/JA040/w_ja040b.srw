forward
global type w_ja040b from wt_listdetail
end type
end forward

global type w_ja040b from wt_listdetail
integer ii_dddw_position = 1
end type
global w_ja040b w_ja040b

on w_ja040b.create
int iCurrent
call super::create
end on

on w_ja040b.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;f_visible (dw_c, false, 'ymd_t')
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.rcd [1])
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja040b
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja040b
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja040b
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja040b
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja040b
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja040b
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja040b
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja040b
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja040b
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja040b
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja040b
end type

type uo_navi from wt_listdetail`uo_navi within w_ja040b
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja040b
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja040b
end type

type p_close from wt_listdetail`p_close within w_ja040b
end type

type p_excel from wt_listdetail`p_excel within w_ja040b
end type

type p_print from wt_listdetail`p_print within w_ja040b
end type

type p_delete from wt_listdetail`p_delete within w_ja040b
end type

type p_update from wt_listdetail`p_update within w_ja040b
end type

type p_input from wt_listdetail`p_input within w_ja040b
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja040b
end type

type p_clear from wt_listdetail`p_clear within w_ja040b
end type

type p_copy from wt_listdetail`p_copy within w_ja040b
end type

type dw_c from wt_listdetail`dw_c within w_ja040b
string title = "운용펀드@평가일자"
string dataobject = "dc_xx_ymd"
end type

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;rs_where = "(t1.fund_cd in (select mc_code from aams.tjm0aa where corp_gr='" + gaa.corp_gr + "') OR to_char (t1.fst_seolj_ymd,'yyyymm')='" + string (idt_workdate,'yyyymm') + "')"
RETURN 50
end event

type btn_update from wt_listdetail`btn_update within w_ja040b
end type

type st_count from wt_listdetail`st_count within w_ja040b
end type

type dw_list from wt_listdetail`dw_list within w_ja040b
string dataobject = "d_ja040b1"
boolean ibsetlist4excelclip = true
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('mc_code', string (dw_c.object.rcd [1]))
uf_setcolumn ('jm_seq', '1')
uf_setcolumn ('fst_meib_ymd', string (dw_c.object.ymd [1]))

setcolumn ('jm_cd')

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE	GetColumnName()
	CASE 'jm_cd'
		RETURN 98
END CHOOSE
RETURN 1
end event

event dw_list::ue_protect;call super::ue_protect;IF	Object.p_visible [row]=1	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

event dw_list::itemchanged_next;call super::itemchanged_next;STRING	ls_sqlsyntax

LONG	lR, lj

IF dw_detail.rowcount ()=0 Then
   IF f_notnull (Object.jm_cd [row]) And f_notnull (Object.fst_meib_ymd [row]) And f_notnull (Object.aekm [row]) And f_notnull (Object.chui_aek [row])   Then
      ls_sqlsyntax = " SELECT  t1.fund_cd " + &
                     "       , t1.fund_nm " + &
                     "       , t1.fund_enm " + &
                     " FROM    szm0fd t1 " + &
                     " WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " + &
                     "   AND   t1.mc_code  = '" + dw_c.object.rcd [1] + "' " + &
                     "   AND   t1.fund_cd != mc_code " + &
                     " ORDER BY  t1.fund_enm desc "

      lR = SQLCA.sql2ds (classname(), ls_sqlsyntax, gds, 'xml')
      FOR  lj = 1  TO  lR
         dw_detail.insertrow (1)
         dw_detail.object.corp_gr [1]     = gaa.corp_gr
         dw_detail.object.mc_code [1]     = dw_c.object.rcd [1]
         dw_detail.object.jm_cd [1]       = dw_list.object.jm_cd [row]
         dw_detail.object.jm_seq [1]      = dw_list.object.jm_seq [row]
         dw_detail.object.ymd [1]         = Object.fst_meib_ymd [row]
         dw_detail.object.fund_cd [1]     = gds.getitemstring (lj, 1)
         dw_detail.object.xx_fund_cd [1]  = gds.getitemstring (lj, 2)
         dw_detail.object.xx_fund_enm [1] = gds.getitemstring (lj, 3)
         IF dw_detail.object.xx_fund_enm [1]='2'   Then
            dw_detail.object.fund_per [1] = 20
         Else
            dw_detail.object.fund_per [1] = 80
         End IF
      NEXT
   End IF
Else
   CHOOSE CASE name
      CASE 'jm_cd','jm_seq','fst_meib_ymd'
         FOR  lj = 1  TO  dw_detail.rowcount ()
            dw_detail.object.jm_cd [lj] = dw_list.object.jm_cd [row]
            dw_detail.object.jm_seq [lj] = dw_list.object.jm_seq [row]
            dw_detail.object.ymd [lj] = Object.fst_meib_ymd [row]
         NEXT
      CASE 'medo_ymd','medo_aek','dan_aek'
         IF rowcount ()>=(row + 1)  Then
            Object.medo_ymd [row + 1] = Object.medo_ymd [row]
            Object.medo_aek [row + 1] = Object.medo_aek [row]
				IF f_notnull (Object.medo_ymd [row]) And f_num (Object.medo_aek [row])>0   Then
					uf_UpdateCommit (dw_list)
	
					STRING	sMsg, la_args[]
	
					sMsg = Space (200)
					la_args[1] = gaa.corp_gr
					la_args[2] = string (Object.ymd [row],'yyyymmdd')
					la_args[3] = Object.mc_code [row]
					la_args[4] = 'KRW'
					la_args[5] = '999'
					la_args[6] = string (Object.medo_ymd [row],'yyyymmdd')
					la_args[7] = 'ref'
					SQLCA.singleconnection ()
					SQLCA.SP_CALL(THIS, 'aams.SR_SKKP010_950_COM_JM ( ?, ?, ?, ?, ?, ?, ? )', la_args[], sMsg )
					sMsg = f_nvl (SQLCA.getitemplsql (1), 'N')
	
					dw_detail.setredraw (FALSE)
					dw_detail.uf_reset ()
					dw_detail.EVENT ue_retrieve ()
					dw_detail.setredraw (TRUE)
	
					DateTime ldt_ymd
	
					STRING	ls_mc_code, ls_jm_cd, ls_fund_cd
	
					DEC	ldc_jm_seq, ldc_B0311, ldc_B0308
	
					ls_mc_code = Object.mc_code [row]
					ls_jm_cd   = Object.jm_cd [row]
					ldc_jm_seq = Object.jm_seq [row]
					ls_fund_cd = Object.fund_cd [row]
					ldt_ymd    = Object.ymd [row]
	
					SELECT B0311
						  , B0308
					  INTO :ldc_B0311
						  , :ldc_B0308
					FROM   tjt0aa t1
					WHERE  t1.corp_gr = :gaa.corp_gr
					  AND  t1.ymd     = :ldt_ymd
					  AND  t1.fund_cd = :ls_fund_cd
					  AND  t1.jm_cd   = :ls_jm_cd
					  AND  t1.mc_code = :ls_mc_code
					  AND  t1.jm_seq  = :ldc_jm_seq;
	
					Object.B0311 [row] = SQLCA.getitemdecimal (1)
					Object.B0308 [row] = SQLCA.getitemdecimal (2)
	
					ls_fund_cd = Object.fund_cd [row + 1]
	
					SELECT B0311
						  , B0308
					  INTO :ldc_B0311
						  , :ldc_B0308
					FROM   tjt0aa t1
					WHERE  t1.corp_gr = :gaa.corp_gr
					  AND  t1.ymd     = :ldt_ymd
					  AND  t1.fund_cd = :ls_fund_cd
					  AND  t1.jm_cd   = :ls_jm_cd
					  AND  t1.mc_code = :ls_mc_code
					  AND  t1.jm_seq  = :ldc_jm_seq;
	
					Object.B0311 [row + 1] = SQLCA.getitemdecimal (1)
					Object.B0308 [row + 1] = SQLCA.getitemdecimal (2)
					
					f_messagebox ('INFO', '초과수익 배분비율은 1종이 ' + sMsg + '입니다.~r~n~r~n' + string (ldt_ymd,'yyyy.mm.dd') + '까지 계산된 기준금액으로 처리~r~n~r~n매도일 기준으로 기준금액, 초과수익이 변경될 수 있습니다.')
				End IF
			End IF
   END CHOOSE
End IF
end event

type dw_detail from wt_listdetail`dw_detail within w_ja040b
string dataobject = "d_ja040b2"
string setlist4rowpointcolor = "p_visible=1=a"
end type

event dw_detail::ue_protect;call super::ue_protect;IF	Object.p_visible [row]='1'	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('mc_code', string (dw_c.object.rcd [1]))
uf_setcolumn ('jm_cd', string (dw_list.object.jm_cd [iRow]))
uf_setcolumn ('jm_seq', string (dw_list.object.jm_seq [iRow]))
uf_setcolumn ('ymd', string (dw_list.object.fst_meib_ymd [iRow]))

setcolumn ('fund_cd')

RETURN 0
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;rs_where = "mc_code = '" + string (dw_c.object.rcd [1]) + "' And fund_cd != '" + string (dw_c.object.rcd [1]) + "'"
RETURN 7
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.rcd [1], dw_list.object.jm_cd [iRow], dw_list.object.jm_seq [iRow], dw_list.object.fst_meib_ymd [iRow])
end event

type st_move from wt_listdetail`st_move within w_ja040b
end type

