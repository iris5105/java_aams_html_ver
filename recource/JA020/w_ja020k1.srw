forward
global type w_ja020k1 from wt_vertole
end type
end forward

global type w_ja020k1 from wt_vertole
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
end type
global w_ja020k1 w_ja020k1

type variables

end variables

on w_ja020k1.create
int iCurrent
call super::create
end on

on w_ja020k1.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja020k1
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja020k1
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja020k1
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja020k1
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja020k1
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja020k1
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja020k1
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja020k1
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja020k1
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja020k1
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja020k1
end type

type uo_navi from wt_vertole`uo_navi within w_ja020k1
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja020k1
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja020k1
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja020k1
end type

type p_close from wt_vertole`p_close within w_ja020k1
end type

type p_excel from wt_vertole`p_excel within w_ja020k1
end type

type p_print from wt_vertole`p_print within w_ja020k1
end type

type p_delete from wt_vertole`p_delete within w_ja020k1
end type

type p_update from wt_vertole`p_update within w_ja020k1
end type

type p_input from wt_vertole`p_input within w_ja020k1
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja020k1
end type

type p_clear from wt_vertole`p_clear within w_ja020k1
end type

type p_copy from wt_vertole`p_copy within w_ja020k1
end type

type dw_c from wt_vertole`dw_c within w_ja020k1
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertole`btn_update within w_ja020k1
end type

type st_count from wt_vertole`st_count within w_ja020k1
end type

type dw_list from wt_vertole`dw_list within w_ja020k1
boolean visible = true
boolean enabled = true
string dataobject = "d_uzm0hy"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mg_cd', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'series_gb', gaa.corp_gr, '', 1, "")
end event

type st_move from wt_vertole`st_move within w_ja020k1
end type

type ole_rd from wt_vertole`ole_rd within w_ja020k1
boolean eb_onepage = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;DATETIME	ldt, ldt_f, ldt_t, ldt_1f, ldt_1t, ldt_2f, ldt_2t, ldt_3f, ldt_3t
STRING	ls_fund_cd, ls_gugan, ls_g, ls_g1, ls_g2, ls_g3

DEC	ldc_m3_gu, ldc_g3_gu

ldt        = dw_c.object.ymd [1]
ls_fund_cd = dw_list.object.fund_cd [iRow]
ls_gugan   = dw_list.object.gugan [iRow]

SELECT gu.m3_fymd
	  , gu.m3_tymd
	  , gu.g3b_fymd
	  , gu.g3b_tymd
	  , gu.b3_fymd
	  , gu.b3_tymd
	  , '평균비율구간 : ' || TO_CHAR(gu.m3_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.m3_tymd,'yyyy.mm.dd')
	  , '평균비율구간 : ' || TO_CHAR(gu.g3b_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.g3b_tymd,'yyyy.mm.dd')
	  , '평균비율구간 : ' || TO_CHAR(gu.b3_fymd,'yyyy.mm.dd') || ' - ' || TO_CHAR(gu.b3_tymd,'yyyy.mm.dd')
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

ldt_1f    = SQLCA.getitemdatetime (1)
ldt_1t    = SQLCA.getitemdatetime (2)
ldt_2f    = SQLCA.getitemdatetime (3)
ldt_2t    = SQLCA.getitemdatetime (4)
ldt_3f    = SQLCA.getitemdatetime (5)
ldt_3t    = SQLCA.getitemdatetime (6)
ls_g1     = SQLCA.GETITEMSTRING (7)
ls_g2     = SQLCA.GETITEMSTRING (8)
ls_g3     = SQLCA.GETITEMSTRING (9)
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
		ls_g  = ls_g1
	END IF
	UF_FILEOPEN ('rd_ja020k1w.mrd', &
					 'fund_cd[' + ls_fund_cd + '] ' + &
					 'gugan[' + ls_g + '] ' + &
					 'fymd[' + STRING (ldt_f, 'yyyymmdd') + '] ' + &
					 'tymd[' + STRING (ldt_t, 'yyyymmdd') + ']')
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
	UF_FILEOPEN ('rd_ja020k2w.mrd', &
					 'fund_cd[' + ls_fund_cd + '] ' + &
					 'gugan[' + ls_g + '] ' + &
					 'fymd[' + STRING (ldt_f, 'yyyymmdd') + '] ' + &
					 'tymd[' + STRING (ldt_t, 'yyyymmdd') + ']')
ELSE
	ldt_f = ldt_3f
	ldt_t = ldt_3t
	ls_g  = ls_g3
	UF_FILEOPEN ('rd_ja020k3w.mrd', &
					 'fund_cd[' + ls_fund_cd + '] ' + &
					 'gugan[' + ls_g + '] ' + &
					 'fymd[' + STRING (ldt_f, 'yyyymmdd') + '] ' + &
					 'tymd[' + STRING (ldt_t, 'yyyymmdd') + ']')
END IF

end event

type rb_onepage from wt_vertole`rb_onepage within w_ja020k1
end type

