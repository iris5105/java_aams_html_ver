forward
global type w_shm0hj from wt_listdetail
end type
type cb_ija from pf_u_commandbutton within w_shm0hj
end type
end forward

global type w_shm0hj from wt_listdetail
string is_init_value = "ZS"
cb_ija cb_ija
end type
global w_shm0hj w_shm0hj

type variables

end variables

forward prototypes
public subroutine uf_com (long arg_row)
end prototypes

public subroutine uf_com (long arg_row);IF f_null (dw_list.object.balh_ymd [arg_row]) OR f_null (dw_list.object.sanghw_ymd [arg_row]) OR &
   f_null (dw_list.object.aekm [arg_row]) OR f_null (dw_list.object.pyom_iyul [arg_row]) Then RETURN

   DEC	ldc_aekm, ldc_sung_cost, ldc_misu_ija, ldc_iyul, ldc_dd1, ldc_dd2, ldc_chui_aek, ldc_tr_aek
   DEC	ldc_sunn_tax, ldc_sanghw_aek

   DATETIME	ldt_meib_ymd, ldt_balh_ymd, ldt_sanghw_ymd

   LONG	ll_f_value

   ldt_meib_ymd   = dw_list.object.meib_ymd [arg_row]
   ldt_balh_ymd   = dw_list.object.balh_ymd [arg_row]
   ldt_sanghw_ymd = dw_list.object.sanghw_ymd [arg_row]
   ldc_aekm       = dw_list.object.aekm [arg_row]
   IF POS ('ZS,ZF',dw_list.object.cash_cd [arg_row]) = 0 Then
      ldc_iyul = dw_list.object.pyom_iyul [arg_row]
   ELSE
      ldc_iyul = dw_list.object.meib_suik_rt [arg_row]
   END IF

SELECT f_days(:ldt_balh_ymd,:ldt_meib_ymd)
     , f_days(:ldt_balh_ymd,:ldt_sanghw_ymd)
  INTO :ldc_dd1
     , :ldc_dd2
  FROM DUAL ;

ldc_dd1 = SQLCA.GETITEMNUMBER (1)
ldc_dd2 = SQLCA.GETITEMNUMBER (2)

// 현금자산종류별로 취득가,매매가,상환금액을 계산
ldc_sung_cost = truncate (ldc_aekm * ldc_iyul * ldc_dd1 / 365,0)
ldc_misu_ija  = truncate (ldc_aekm * ldc_iyul * ldc_dd2 / 365,0)

CHOOSE CASE dw_list.object.cash_cd [arg_row]
   CASE '70'   // RP예금
      ldc_misu_ija   = 0
      ldc_sung_cost  = 0
      ldc_chui_aek   = ldc_aekm
      ldc_tr_aek     = ldc_aekm
      ldc_sanghw_aek = ldc_aekm
   CASE '80', '71', '72'  // 콜론/RP매입/RP매도
      ldc_chui_aek   = ldc_aekm
      ldc_tr_aek     = ldc_aekm + ldc_sung_cost
      ldc_sanghw_aek = ldc_aekm + ldc_misu_ija
   CASE '50'
      ldc_misu_ija  = truncate (ldc_aekm * ldc_iyul * ldc_dd2 / 365,0)
      ldc_chui_aek  = ldc_aekm
      ldc_sung_cost = truncate (ldc_aekm * ldc_iyul * ldc_dd1 / 365,0)
   CASE ELSE // '10','20','DC'
      IF STRING (dw_list.object.sanghw_ymd [arg_row],'yyyymmdd') = '20991231' Then
         ldc_misu_ija   = 0
         ldc_sung_cost  = 0
         ldc_sanghw_aek = ldc_aekm
         ldc_chui_aek   = ldc_aekm
         ldc_tr_aek     = ldc_aekm
      ELSE
         ldc_chui_aek = ldc_aekm - ldc_misu_ija
         IF dw_list.object.sunhu_tax_gb [arg_row] = '1'  Then  // 선과세
             SELECT F_TAX_RT('2',:ldt_balh_ymd) INTO :ll_f_value FROM DUAL;
            ll_f_value = SQLCA.GETITEMNUMBER (1)

            ldc_sunn_tax = truncate ((ldc_misu_ija - ldc_sung_cost) * ll_f_value / 10,0) * 10;
            IF dw_list.object.tax_offer_gb [arg_row] = '1'  Then
               ldc_tr_aek = ldc_chui_aek + ldc_sung_cost
            ELSE
               ldc_tr_aek = ldc_chui_aek + ldc_sung_cost + ldc_sunn_tax
            END IF
         ELSE
            ldc_tr_aek = ldc_chui_aek + ldc_sung_cost;
         END IF
         IF dw_list.object.sunhu_gb [arg_row] = '1'   Then // 선취
            ldc_sanghw_aek = ldc_aekm
            ldc_chui_aek   = ldc_aekm
            ldc_tr_aek     = ldc_chui_aek - ldc_misu_ija

         ELSEIF dw_list.object.sunhu_gb [arg_row] = '2'  Then   // 후취
            ldc_sanghw_aek = ldc_aekm + ldc_misu_ija
            ldc_chui_aek   = ldc_aekm
            ldc_tr_aek     = ldc_chui_aek + ldc_sung_cost + ldc_sunn_tax
         ELSE
            ldc_sanghw_aek = ldc_aekm
         END IF
      END IF
END CHOOSE

dw_list.object.chui_aek [arg_row]   = ldc_tr_aek + f_num (dw_list.object.susu_ga [arg_row])  // ldc_chui_aek + f_num (dw_list.object.susu_ga [arg_row])
dw_list.object.sanghw_aek [arg_row] = ldc_sanghw_aek
dw_list.object.tr_aek [arg_row]     = ldc_tr_aek
dw_list.object.sung_cost [arg_row]  = ldc_sung_cost                                          // 자문 경과이자는 선급비용 계산하지 않음 --> PROC0510에서 SHT0HG 생성시 0 으로 처리(SHM1J 경과이자 생성을 위해)
end subroutine

on w_shm0hj.create
int iCurrent
call super::create
this.cb_ija=create cb_ija
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ija
end on

on w_shm0hj.destroy
call super::destroy
destroy(this.cb_ija)
end on

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.dddw [1])
cb_ija.of_setenabled(TRUE)
end event

event wue_postopen;call super::wue_postopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event open;icmdbutton = { cb_ija }
call super::open
end event

event wue_clear;call super::wue_clear;cb_ija.of_setenabled(FALSE)
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_shm0hj
end type

type ln_templeft from wt_listdetail`ln_templeft within w_shm0hj
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_shm0hj
end type

type ln_temptop from wt_listdetail`ln_temptop within w_shm0hj
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_shm0hj
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_shm0hj
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_shm0hj
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_shm0hj
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_shm0hj
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_shm0hj
end type

type ln_tempright from wt_listdetail`ln_tempright within w_shm0hj
end type

type uo_navi from wt_listdetail`uo_navi within w_shm0hj
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_shm0hj
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_shm0hj
end type

type st_top_rect from wt_listdetail`st_top_rect within w_shm0hj
end type

type p_close from wt_listdetail`p_close within w_shm0hj
end type

type p_excel from wt_listdetail`p_excel within w_shm0hj
end type

type p_print from wt_listdetail`p_print within w_shm0hj
end type

type p_delete from wt_listdetail`p_delete within w_shm0hj
end type

type p_update from wt_listdetail`p_update within w_shm0hj
end type

type p_input from wt_listdetail`p_input within w_shm0hj
end type

type p_retrieve from wt_listdetail`p_retrieve within w_shm0hj
end type

type p_clear from wt_listdetail`p_clear within w_shm0hj
end type

type p_copy from wt_listdetail`p_copy within w_shm0hj
end type

type dw_c from wt_listdetail`dw_c within w_shm0hj
string title = "발행일@현금종류"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '%,전체,', 5, "sebu_cd<>'90'")
end event

type btn_update from wt_listdetail`btn_update within w_shm0hj
end type

type st_count from wt_listdetail`st_count within w_shm0hj
end type

type dw_list from wt_listdetail`dw_list within w_shm0hj
string dataobject = "d_shm0hj"
boolean eb_always_1_insert = true
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'cash_cd', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'sunhu_gb', gaa.corp_gr, '', 2, '')
F_DDDWCTL (THIS, 'sunhu_tax_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'pg_cd', gaa.corp_gr, ',,', 2, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll_gigan

STRING	sMsg, ls_sr_err_msg, la_args[]

DEC	ld_susu_ga, ll

CHOOSE CASE dwo.name
   CASE 'aekm','pyom_iyul_per','sanghw_ymd','balh_ymd'
      Object.sanghw_aek [row] = 0
      Object.chui_aek [row] = 0
      Object.tr_aek [row] = 0
END CHOOSE

CHOOSE CASE dwo.name
   CASE 'cash_cd'
		Object.offer_co_cd [row] = null_s
		Object.ksd_jm_cd [row]   = null_s
		Object.pg_cd [row]       = null_s

      CHOOSE CASE data
         CASE '20'
            Object.bojng_gb [row] = '1'
            CHOOSE CASE gaa.corp_gr
               CASE '2402'
                  Object.sanghw_ymd [row] = DATETIME (DATE ('2099-12-31'))
            END CHOOSE
      END CHOOSE
      CHOOSE CASE data
         CASE '10'
            Object.sunhu_tax_gb [row] = '1'
         CASE Else
            Object.sunhu_tax_gb [row] = '2'
      END CHOOSE
      CHOOSE CASE data
         CASE '10','DC'
            Object.sunhu_gb [row] = '1'
         CASE 'ZF','ZS'
            Object.sunhu_gb [row] = '3'
				Object.pg_cd [row] = '0211'
         CASE Else
            Object.sunhu_gb [row] = '2'
      END CHOOSE
   CASE 'meib_ymd'
      Object.balh_ymd [row] = DATETIME (DATE (MID (data,1,10)))
      IF Object.cash_cd [row]='20'  Then
         CHOOSE CASE gaa.corp_gr
            CASE '2402'
               Object.sanghw_ymd [row] = DATETIME (DATE ('2099-12-31'))
         END CHOOSE
      End IF
   CASE 'pyom_iyul_per'
      Object.pyom_iyul [row] = dec (data) / 100.0
      Object.meib_suik_rt [row] = dec (data) / 100.0
   CASE 'ija_yy_su'
      Object.tot_ija_gugan [row] = dec (data) * Object.yy_ija_hoicha [row]
   CASE 'yy_ija_hoicha'
      Object.tot_ija_gugan [row] = dec (data) * Object.ija_yy_su [row]
END CHOOSE
end event

event dw_list::itemchanged_next;call super::itemchanged_next;LONG	ll, ija_yy_su

STRING	ls_cd, ls_yy, ls_mm, ls_dd, ls_jm_cd, ls_ksd_cd
DateTime ldt_balh, ldt_sanghw

CHOOSE CASE name
   CASE 'hj_nm','balh_ymd'
      IF POS ('ZS,ZF',Object.cash_cd [row])>0 And POS (Object.hj_nm [row], string(Object.balh_ymd [row],'yyyymmdd')+'-')>0	Then
			ldt_balh = Object.balh_ymd [row]
         ls_dd = MID (Object.hj_nm [row], POS (Object.hj_nm [row], string(Object.balh_ymd [row],'yyyymmdd')+'-') + 9)
         ls_dd = LEFT (ls_dd, POS (ls_dd,'-') - 1)
			IF	f_num (ls_dd)>0	Then
				SELECT :ldt_balh + :ls_dd
				  INTO :ldt_sanghw
				  FROM DUAL;

	         Object.sanghw_ymd [row] = SQLCA.getitemdatetime (1)
			End IF
      End IF
END CHOOSE

IF	f_null (Object.offer_co_cd [row])	Then
	IF	Object.cash_cd [row]='20' And f_notnull (Object.fund_cd [row])	Then
		ls_cd = Object.fund_cd [row]

		SELECT comp_cd
		  INTO :ls_cd
		  FROM SZM0IA ia
			  , SZX2MM mm
		 WHERE ia.corp_gr  = :gaa.corp_gr
			AND ia.fund_cd  = :ls_cd
			AND mm.corp_gr  = ia.corp_gr
			AND mm.tr_co_cd = ia.mg_cd;

		ls_cd = SQLCA.getitemstring (1)
		Object.offer_co_cd [row] = ls_cd

	ElseIF POS ('ZS,ZF',Object.cash_cd [row])>0 And f_notnull (Object.ksd_jm_cd [row])	Then
		Object.offer_co_cd [row] = MID (Object.ksd_jm_cd [row],5,5)
	End IF
End IF

IF f_null (Object.balh_ymd [row]) OR f_null (Object.sanghw_ymd [row]) THEN RETURN

CHOOSE CASE name
   CASE 'hj_nm','fund_cd','meib_ymd','balh_ymd','sanghw_ymd'  // 이자년수
      ldt_balh = Object.balh_ymd [row]
      ldt_sanghw = Object.sanghw_ymd [row]

      SELECT trunc(months_between(:ldt_sanghw + 1,:ldt_balh) / 12 + .9)
        INTO :ija_yy_su
        FROM DUAL;

      ija_yy_su = SQLCA.getitemnumber (1)

      Object.ija_yy_su [row] = ija_yy_su

		IF	POS ('ZS,ZF',Object.cash_cd [row])>0 OR string (Object.sanghw_ymd [row],'yyyymmdd')='20991231'	Then
			Object.yy_ija_hoicha [row] = 1
		Else
			Object.yy_ija_hoicha [row] = 12
		End IF
		Object.tot_ija_gugan [row] = Object.ija_yy_su [row] * Object.yy_ija_hoicha [row]
END CHOOSE

IF POS ('hj_nm,aekm,pyom_iyul_per,sanghw_ymd,balh_ymd',name)>0 THEN uf_com (row)

ls_cd = Object.cash_cd [row]
ls_yy = f_get_id_dae ('Y', string (Object.balh_ymd [row], 'yyyy'))
ls_mm = f_get_id_dae ('M', string (Object.balh_ymd [row], 'mm'))
ls_dd = f_get_id_dae ('D', string (Object.balh_ymd [row], 'dd'))

ls_jm_cd = 'KR9'+ ls_yy +  ls_mm + string (Object.balh_ymd [row],'dd') + ls_cd + '___'

IF ls_cd='90'  Then
   ls_ksd_cd = null_s
Else
   SELECT 'KRZ' || sebu_cd_efnm || '_____' || :ls_yy || :ls_mm || :ls_dd
     INTO :ls_ksd_cd
     FROM SZX0GR t1
    WHERE t1.gr_cd   = '02'
      AND t1.sebu_cd = :ls_cd;

   ls_ksd_cd = SQLCA.getitemstring (1)
End IF

CHOOSE CASE dw_list.object.cash_cd [row]
   CASE '50'
      f_dddwctl (dw_list, 'yegum_ija_jigub_gb', gaa.corp_gr, '', 1, '')
      dw_List.uf_setColumn ('yegum_ija_jigub_gb', '1')
   CASE 'AA'
      f_dddwctl (dw_list, 'yegum_ija_jigub_gb | ija_jigub_gb', gaa.corp_gr, '', 1, '')
      dw_List.uf_setColumn ('yegum_ija_jigub_gb', '7')
   CASE Else
      dw_List.uf_setColumn ('yegum_ija_jigub_gb', '')
END CHOOSE

SELECT NVL(MAX(SUBSTR(JM_CD,10,2)),0) + 1
  INTO :ll
  FROM SHM0HJ t1
 WHERE t1.corp_gr = :gaa.corp_gr
   AND t1.jm_cd   LIKE :ls_jm_cd;

ll = SQLCA.getitemnumber (1)

IF f_null (Object.jm_cd [row]) OR GetItemStatus (row, 0, Primary!)=NewModified! Then
   Object.jm_cd [row] = f_jm_check (LEFT (ls_jm_cd,9) + string (ll,'00'))
End IF

//IF f_null (Object.ksd_jm_cd [row]) And f_notnull (Object.ksd_jm5 [row]) And f_notnull (Object.ksd_jm8 [row])   Then
//   ls_ksd_cd = REPLACE (ls_ksd_cd, 5, 3, Object.ksd_jm5 [row])
//   ls_ksd_cd = REPLACE (ls_ksd_cd, 8, 2, RIGHT ('0' + Object.ksd_jm8 [row], 2))
//   Object.ksd_jm_cd [row] = ls_ksd_cd
//End IF
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF	uf_update ()=FALSE THEN RETURN 1

uf_setColumn ('sunhu_tax_gb',  '2')
IF	dw_c.object.dddw [1]='%'	Then
	uf_setColumn ('cash_cd', 'ZS')
	uf_setColumn ('sunhu_gb', '3')
Else
	uf_setColumn ('cash_cd', dw_c.object.dddw [1])
	CHOOSE CASE dw_c.object.dddw [1]
		CASE '20'
			uf_setColumn ('bojng_gb', '1')
	END CHOOSE
	CHOOSE CASE dw_c.object.dddw [1] //선후취구분
		CASE '10','20','DC'
			uf_setColumn ('sunhu_gb', '1')
		CASE 'ZS','ZF'
			uf_setColumn ('sunhu_gb', '3')
		CASE Else
			uf_setColumn ('sunhu_gb', '2')
	END CHOOSE
End IF
uf_setColumn ('meib_mk_gb', '1')
uf_setColumn ('meib_ymd', string(dw_c.object.ymd [1]))
uf_setColumn ('balh_ymd', string(dw_c.object.ymd [1]))
uf_setColumn ('sanghw_ymd', '2099.12.31')
uf_setColumn ('ksd_jm8', '1')
uf_setColumn ('cd_jigub_gb', '1')
uf_setColumn ('yy_ija_hoicha', '1')
uf_setColumn ('tax_offer_gb', '2')
uf_setColumn ('daeyeo_gb', '0')

POST SetColumn ('cash_cd')

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'tr_co_cd'
      IF dw_c.object.dddw [1]='50' THEN rs_where = "tr_gb in ('1','2','5') and used='1'" &
      ELSE                              rs_where = "comp_cd is not null and used='1'"
   CASE 'bojng_cd'
      rs_where = "used='1'"
END CHOOSE
RETURN 1
end event

event dw_list::updateend;call super::updateend;LONG	ll

STRING	ls_cd, ls_msg, la_args[]

FOR  ll = 1  TO  rowsdeleted
   ls_cd = GetItemstring (ll, 'jm_cd', Delete!, TRUE)
   DELETE  sht0hg
   WHERE   corp_gr = :gaa.corp_gr
     AND   jm_cd   = :ls_cd;
NEXT
la_args[1] = gaa.corp_gr
FOR  ll = 1  TO  rowcount ()
	IF GetItemStatus (ll, 0, Primary!)=New! OR GetItemStatus (ll, 0, Primary!)=NewModified! OR GetItemStatus (ll, 0, Primary!)=DataModified!	Then
		la_args[2] = Object.jm_cd [ll]
		la_args[3] = 'ok'

		SQLCA.singleconnection ()
		SQLCA.SP_CALL (THIS, 'SR_SHJ0IG ( ?, ?, ? )', la_args[], ls_msg)
	End IF
NEXT
end event

event dw_list::ue_protect;call super::ue_protect;IF GETITEMSTATUS (ROW, 0, PRIMARY!)=NEW! OR GETITEMSTATUS (ROW, 0, PRIMARY!)=NEWMODIFIED! Then
   uf_protect (ROW, ia_protect [1])
   Object.p_visible [row] = 1

ELSEIF STRING (Object.meib_ymd [row],'yyyymmdd') >= STRING (uf_initdate ('inputdate'),'yyyymmdd')  Then
   uf_protect (ROW, ia_protect [1])
ELSE
   uf_protect (ROW, ia_protect [2])
   IF Object.sanghw_ymd [row]>idt_workdate   Then
      f_setprotect (THIS, false, {'ksd_jm_cd'})
      POST setcolumn ('ksd_jm_cd')
   END IF
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

event dw_list::clicked;call super::clicked;f_microhelp (string(row))
end event

type dw_detail from wt_listdetail`dw_detail within w_shm0hj
string dataobject = "d_shj0ig"
string islist4subbtnauth = "0010011001"
end type

event dw_detail::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'gugan_ilsu_t'
      LONG	ll
      FOR  ll = 1  TO  rowcount ()
         IF f_num (Object.fix_ija_aek [ll])=0   Then
            Object.gugan_ija [ll] = dw_list.object.pyom_iyul [dw_list.getrow ()] / 365 * Object.gugan_ilsu [ll]
         Else
            Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
         End IF
      NEXT
      RETURN
   CASE 'gugan_ilsu'
      IF f_num (Object.fix_ija_aek [row])=0  Then
         Object.gugan_ija [row] = dw_list.object.pyom_iyul [dw_list.getrow ()] / 365 * Object.gugan_ilsu [row]
      Else
         Object.gugan_ija [row] = Object.fix_ija_aek [row] / dw_list.object.chui_aek [iRow]
      End IF
      RETURN
END CHOOSE
CALL super::doubleclicked
end event

event dw_detail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

Datetime	ldt_bf, ldt, ldt_f_param1, ldt_f_param2

LONG	ll, ll_mm, ll_dd, ll_f_value

CHOOSE CASE dwo.name
   CASE 'bf_ija_ymd'
		ldt_f_param1 = datetime(date(MID(data,1,10)))
		ldt_f_param2 = Object.af_ija_ymd[row]
		SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2 )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)
		
      Object.gugan_ilsu [row] = ll_f_value
   CASE 'af_ija_ymd'
      ldt_bf = Object.bf_ija_ymd [row]
      ldt = datetime (date (MID (data,1,10)))

      IF f_num (Object.platform_fee [row])>0 THEN Object.platform_ymd [row] = ldt

      SELECT  round(months_between(:ldt, :ldt_bf))
        INTO  :ll_mm
      FROM    dual;
		
		ll_mm = SQLCA.getitemnumber (1)
		
      IF ll_mm=0 THEN ll_mm = 1

		SELECT F_DAYS( :ldt_bf, :ldt )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)

      Object.gugan_ilsu [row] = ll_f_value
      IF f_num (Object.fix_ija_aek [row])=0  Then
         Object.gugan_ija [row] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [row]
      Else
         Object.gugan_ija [row] = Object.fix_ija_aek [row] / dw_list.object.chui_aek [iRow]
      End IF

      FOR  ll = row + 1  TO  rowcount ()
			Object.ip_user [ll] = 'ymd_com'
         Object.ip_ymd [ll] = f_sysdate('')
         Object.bf_ija_ymd [ll] = ldt
         IF ll<= (dw_list.object.now_ija_hoicha [iRow] + 1) Then
				
				ldt_f_param1 = Object.bf_ija_ymd[ll]
				ldt_f_param2 = Object.af_ija_ymd[ll]
				SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2  )
				  INTO :ll_f_value
				FROM   DUAL;
				ll_f_value = SQLCA.getitemnumber (1)
				
            ll_dd = ll_f_value
            Object.gugan_ilsu [ll] = ll_dd
            IF f_num (Object.fix_ija_aek [ll])=0   Then
               Object.gugan_ija [ll] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [ll]
            Else
               Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
            End IF
            EXIT
         Else
            Object.af_ija_ymd [ll] = f_add_months (ldt, ll_mm, null_dt)
				
				ldt_f_param1 = Object.bf_ija_ymd[ll]
				ldt_f_param2 = Object.af_ija_ymd[ll]
				SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2 )
				  INTO :ll_f_value
				FROM   DUAL;
				ll_f_value = SQLCA.getitemnumber (1)
				
            ll_dd = ll_f_value
            IF Object.af_ija_ymd [ll]>=dw_list.object.sanghw_ymd [iRow] Then
               Object.af_ija_ymd [ll] = dw_list.object.sanghw_ymd [iRow]
					
					ldt_f_param1 =  Object.bf_ija_ymd[ll]
					ldt_f_param2 =  Object.af_ija_ymd[ll]
					SELECT F_DAYS( :ldt_f_param1 , :ldt_f_param2 )
					  INTO :ll_f_value
					FROM   DUAL;
					ll_f_value = SQLCA.getitemnumber (1)
					
               Object.gugan_ilsu [ll] = ll_f_value
               IF f_num (Object.fix_ija_aek [ll])=0   Then
                  Object.gugan_ija [ll] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [ll]
               Else
                  Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
               End IF
               EXIT
            End IF
            Object.gugan_ilsu [ll] = ll_dd
            IF f_num (Object.fix_ija_aek [ll])=0   Then
               Object.gugan_ija [ll] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [ll]
            Else
               Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
            End IF
            ldt = Object.af_ija_ymd [ll]
         End IF
      NEXT
   CASE 'platform_fee'
      IF f_null (data)  Then
         Object.platform_ymd [row] = null_dt
      Else
         Object.platform_ymd [row] = Object.af_ija_ymd [row]
      End IF
   CASE 'fix_ija_aek'
      Object.gugan_ija [row] = dec (data) / dw_list.object.chui_aek [iRow]
END CHOOSE

object.ip_user [row] = gnv_vari.is_user_id
Object.ip_ymd [row] = f_sysdate('')
end event

event dw_detail::ue_insert;call super::ue_insert;LONG	ll

FOR  ll = 1  TO  rowcount ()
   Object.gugan_no [ll] = ll
NEXT

RETURN   AncestorReturnVALUE
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('jm_cd', dw_list.object.jm_cd [iRow])
RETURN 0
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.jm_cd [iRow], dw_list.object.now_ija_hoicha [iRow])
end event

event dw_detail::ue_protect;call super::ue_protect;IF	string (dw_list.object.meib_ymd [iRow],'yyyymmdd')>=string (idt_workdate,'yyyymmdd')	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

type st_move from wt_listdetail`st_move within w_shm0hj
end type

type cb_ija from pf_u_commandbutton within w_shm0hj
integer x = 2281
integer y = 12
integer width = 494
integer height = 104
integer taborder = 110
boolean bringtotop = true
string text = "구간이자생성"
end type

event clicked;call super::clicked;STRING	ls_jm_cd, ls_msg, la_args[]

IF dw_detail.rowcount ()=0 Then
   IF f_messageBox ('RUN', '구간이자 생성')=2 THEN RETURN
Else
   IF f_messageBox ('RUN', '구간이자 재생성(기존구간 삭제)')=2 THEN RETURN
End IF

dw_detail.reset ()
la_args[1] = gaa.corp_gr
la_args[2] = dw_list.object.jm_cd [dw_list.getrow ()]
la_args[3] = 'ok'
SQLCA.singleconnection ()
SQLCA.SP_CALL( THIS, 'SR_SHJ0IG ( ?, ?, ? )', la_args[], ls_msg )

dw_detail.postevent ('ue_retrieve')
end event

