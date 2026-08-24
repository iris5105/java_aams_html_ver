forward
global type w_ja031d from wt_list
end type
end forward

global type w_ja031d from wt_list
string is_init_value = "J61"
end type
global w_ja031d w_ja031d

type variables

end variables

on w_ja031d.create
int iCurrent
call super::create
end on

on w_ja031d.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja031d
end type

type ln_templeft from wt_list`ln_templeft within w_ja031d
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja031d
end type

type ln_temptop from wt_list`ln_temptop within w_ja031d
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja031d
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja031d
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja031d
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja031d
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja031d
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja031d
end type

type ln_tempright from wt_list`ln_tempright within w_ja031d
end type

type uo_navi from wt_list`uo_navi within w_ja031d
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja031d
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja031d
end type

type st_top_rect from wt_list`st_top_rect within w_ja031d
end type

type p_close from wt_list`p_close within w_ja031d
end type

type p_excel from wt_list`p_excel within w_ja031d
end type

type p_print from wt_list`p_print within w_ja031d
end type

type p_delete from wt_list`p_delete within w_ja031d
end type

type p_update from wt_list`p_update within w_ja031d
end type

type p_input from wt_list`p_input within w_ja031d
end type

type p_retrieve from wt_list`p_retrieve within w_ja031d
end type

type p_clear from wt_list`p_clear within w_ja031d
end type

type p_copy from wt_list`p_copy within w_ja031d
end type

type dw_c from wt_list`dw_c within w_ja031d
string tag = "전부매도시 매매좌수를 더블클릭 / 매수분 좌수보정도 H61 매수확정(선급수수료) 거래이용"
string title = "영업일자@거래코드"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031D'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    sjt5sg t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   tr_ymd     = :rs_ymd
  AND   tr_cd      IN ( select tr_cd
                          from szx1pt t1
                        where  obj_id = 'W_JA031D' )
  AND   ROWNUM = 1;
  li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja031d
end type

type st_count from wt_list`st_count within w_ja031d
end type

type dw_list from wt_list`dw_list within w_ja031d
string dataobject = "d_ja031d"
end type

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow, lRowCount, dSeq_no

lRowCount = rowcount ()
IF lRowCount=0 THEN RETURN

FOR  lRow = 1  TO  lRowCount
   IF f_num (Object.tr_jwa [lRow])=0 And Object.tr_ymd [lRow]=Object.gijunga_ymd [lRow] And f_nvl (Object.tasa_seolj_ymd [lRow],Object.gijunga_ymd [lRow])<>Object.tr_ymd [lRow] Then
      f_messageBox ("I000", string (lRow) + " 행에서 매매좌수 오류")
      RETURN 1
   End IF
NEXT

DateTime ldt_tr_ymd

STRING	ls_tr_cd

ldt_tr_ymd = dw_c.object.ymd [1]
ls_tr_cd = dw_c.object.dddw [1]

SELECT  NVL(MAX(seq_no),0)
  INTO  :dSeq_no
FROM    sjt5sg t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.tr_ymd  = :ldt_tr_ymd
  AND   t1.tr_cd   = :ls_tr_cd;
  dSeq_no = SQLCA.getitemnumber (1)

FOR  lRow = 1  TO  lRowCount
   IF GetItemStatus (lRow, 0, Primary!)=NewModified! THEN
      dSeq_no ++
      Object.seq_no [lRow] = dSeq_no
   End IF
NEXT
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt_gijunga_ymd

STRING	ls_jm_cd, ls_fund_cd, ls_tasa_fund_cd, ls_sutak_cd, ls_sutak_nm

DEC	ldc_unit, ldc_gijun_ga, ldc_ggijun_ga

IF f_notnull (Object.tasa_jm_cd [row]) OR dwo.name='tasa_jm_cd'   Then
   IF dwo.name='tasa_jm_cd'   Then
      ls_jm_cd = data
   Else
      ls_jm_cd = Object.tasa_jm_cd [row]
   End IF

   SELECT  NVL(trans_unit,1000)
         , tasa_fund_cd
     INTO  :ldc_unit
         , :ls_tasa_fund_cd
   FROM    sjm0sc t1
   WHERE   t1.corp_gr    = :gaa.corp_gr
     AND   t1.tasa_jm_cd = :ls_jm_cd;
	  ldc_unit        = SQLCA.getitemnumber (1)
	  ls_tasa_fund_cd = SQLCA.getitemstring (2)
   IF SQLCA.sqlcode ()<>0  Then
      RETURN uf_itemerr (row, dwo.name, '타사종목(' + ls_jm_cd + ') 거래단위를 확인하십시오.')
   End IF

   ls_fund_cd = Object.fund_cd [row]
   IF dwo.name='gijunga_ymd'  Then
//      IF datetime (date (MidA (data,1,10)))<idt_workdate Then
//         RETURN uf_itemerr (row, dwo.name, '작업일 이전입니다.')
//      End IF
      ldt_gijunga_ymd = datetime (date (MidA (data,1,10)))
   Else
      ldt_gijunga_ymd = Object.gijunga_ymd [row]
   End IF

   SELECT  dang_gijun_ga
         , dang_ggijun_ga
     INTO  :ldc_gijun_ga
         , :ldc_ggijun_ga
   FROM    sjt0sc t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.ymd     = :ldt_gijunga_ymd
     AND   t1.jm_cd   = :data;

   IF SQLCA.sqlcode ()=0  Then
		ldc_gijun_ga	= SQLCA.getitemnumber (1)
		ldc_ggijun_ga	= SQLCA.getitemnumber (2)
	Else
		ldc_gijun_ga	= 1000
		ldc_ggijun_ga	= 1000
   End IF

   IF ldc_gijun_ga>0 THEN Object.gijunga [row] = ldc_gijun_ga
   IF ldc_ggijun_ga>0 THEN Object.ggijunga [row] = ldc_ggijun_ga
   IF dw_c.object.dddw [1]='H61' Then
      Object.susu [row] = 0
      Object.xx_fund_cd [row] = f_getcodename (SQLCA, 'fund_cd', 1, Object.fund_cd [row], gaa.corp_gr)
      Object.xx_tr_co_cd [row] = f_getcodename (SQLCA, 'tr_co_cd', 1, Object.tr_co_cd [row], gaa.corp_gr)
   End IF
End IF

CHOOSE CASE dwo.name
   CASE 'fund_cd'
      SELECT  t1.mg_cd
            , t2.tr_co_nm
        INTO  :ls_sutak_cd
            , :ls_sutak_nm
      FROM    szm0ia t1
            , szx2mm t2
      WHERE   t1.corp_gr  = :gaa.corp_gr
        AND   t1.fund_cd  = :data
        AND   t2.corp_gr  = t1.corp_gr
        AND   t2.tr_co_cd = t1.mg_cd;
		  
		ls_sutak_cd = SQLCA.getitemstring (1)
		ls_sutak_nm = SQLCA.getitemstring (2)

      Object.tr_co_cd [row] = ls_sutak_cd
      Object.xx_tr_co_cd [row] = ls_sutak_nm
   CASE 'gijunga_ymd'
      // 기준가 적용전
      IF datetime (date (MidA (data,1,10)))>idt_workdate Then
         Object.gijunga [row] = null_dc
         Object.ggijunga [row] = null_dc
         Object.tr_jwa [row] = null_dc
         Object.gtr_jwa [row] = null_dc
         Object.upd_jwa [row] = null_s
      Else
         object.upd_jwa [row] = gnv_vari.is_user_id
      End IF
   CASE 'tr_jwa'
      IF dec (data)=0   Then
         Object.upd_jwa [row] = null_s
         RETURN
      End IF
      Object.tr_aek [row] = truncate (dec (data) * Object.gijunga [row] / ldc_unit,0)
      object.upd_jwa [row] = gnv_vari.is_user_id
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string(dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('gijunga_ymd', string(dw_c.object.ymd [1]))

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'tasa_jm_cd'
      IF LEFT (dw_c.object.dddw [1],1)='K'   Then
         rs_where = "tasa_jm_cd in (select tasa_jm_cd from sjm5sm where corp_gr='" + gaa.corp_gr + "' and ymd='" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and fund_cd='" + Object.fund_cd [getrow ()] + "')"
      ElseIF LEFT (dw_c.object.dddw [1],1)='H'  Then
         rs_where = "t1.tr_ymd < '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and gijunga_ymd = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "'"
         RETURN 2
      Else
         rs_where = "haeji_gb='1'"
      End IF
END CHOOSE
RETURN 1
end event

event dw_list::doubleclicked;call super::doubleclicked;DateTime   ldt_gijunga_ymd

DEC	ldc_jwa, ldc_gjwa
DEC	ldc_unit, ldc_gijun_ga, ldc_ggijun_ga

STRING	ls_jm_cd, ls_fund_cd, ls_tasa_fund_cd

ls_fund_cd = Object.fund_cd [row]
ls_jm_cd = Object.tasa_jm_cd [row]
ldt_gijunga_ymd = Object.gijunga_ymd [row]

CHOOSE CASE dwo.name
   CASE 'tasa_jm_cd'
      SELECT  NVL(trans_unit,1000)
            , tasa_fund_cd
        INTO  :ldc_unit
            , :ls_tasa_fund_cd
      FROM    sjm0sc t1
      WHERE   t1.corp_gr    = :gaa.corp_gr
        AND   t1.tasa_jm_cd = :ls_jm_cd;
      IF SQLCA.sqlcode ()<>0 THEN RETURN

		ldc_unit        = SQLCA.getitemnumber (1)
		ls_tasa_fund_cd = SQLCA.getitemstring (2)

      SELECT  dang_gijun_ga
            , dang_ggijun_ga
        INTO  :ldc_gijun_ga
            , :ldc_ggijun_ga
      FROM    sjt0sc t1
      WHERE   t1.corp_gr = :gaa.corp_gr
        AND   t1.ymd     = :ldt_gijunga_ymd
        AND   t1.jm_cd   = :ls_jm_cd;
		  ldc_gijun_ga     = SQLCA.getitemnumber (1)
		  ldc_ggijun_ga    = SQLCA.getitemnumber (2)
      IF SQLCA.sqlcode ()<>0  Then
         SELECT  gijun_ga
               , ggijun_ga
           INTO  :ldc_gijun_ga
               , :ldc_ggijun_ga
         FROM    pzm1ti t1
         WHERE   t1.ymd          = :ldt_gijunga_ymd
           AND   t1.tasa_fund_cd = :ls_tasa_fund_cd;
			  ldc_gijun_ga     = SQLCA.getitemnumber (1)
			  ldc_ggijun_ga    = SQLCA.getitemnumber (2)
      End IF

      IF ldc_gijun_ga>0 THEN Object.gijunga [row] = ldc_gijun_ga
      IF ldc_ggijun_ga>0 THEN Object.ggijunga [row] = ldc_ggijun_ga

      IF dw_c.object.dddw [1]='J61' Then
         IF f_num (Object.ggijunga [row])<>0 THEN Object.gtr_jwa [row] = round (Object.tr_aek [row] / Object.ggijunga [row] * ldc_unit,0)
      Else
         SELECT  NVL(bfil_jwa,0) + nvl(up_jwa,0)
               , NVL(gbfil_jwa,0) + nvl(gup_jwa,0)
           INTO  :ldc_jwa
               , :ldc_gjwa
         FROM    sjm5sm t1
         WHERE   t1.corp_gr    = :gaa.corp_gr
           AND   t1.ymd        = :ldt_gijunga_ymd
           AND   t1.fund_cd    = :ls_fund_cd
           AND   t1.tasa_jm_cd = :ls_jm_cd;
			  ldc_jwa     = SQLCA.getitemnumber (1)
			  ldc_gjwa    = SQLCA.getitemnumber (2)

         Object.gtr_jwa [row] = round (ldc_gjwa / ldc_jwa * Object.tr_jwa [row],0)
      End IF
   CASE 'tr_jwa'
      IF dw_c.object.dddw [1]='K61' Then
         SELECT  NVL(bfil_jwa,0) + nvl(up_jwa,0)
               , NVL(gbfil_jwa,0) + nvl(gup_jwa,0)
           INTO  :ldc_jwa
               , :ldc_gjwa
         FROM    sjm5sm t1
         WHERE   t1.corp_gr    = :gaa.corp_gr
           AND   t1.ymd        = :ldt_gijunga_ymd
           AND   t1.fund_cd    = :ls_fund_cd
           AND   t1.tasa_jm_cd = :ls_jm_cd;
			  ldc_jwa     = SQLCA.getitemnumber (1)
			  ldc_gjwa    = SQLCA.getitemnumber (2)

         Object.tr_jwa [row] = ldc_jwa
         Object.gtr_jwa [row] = ldc_gjwa
         object.upd_jwa [row] = gnv_vari.is_user_id

         f_messageBox ('INFO', '전부매도인지 확인하십시오.')
      End IF
END CHOOSE
end event

event dw_list::itemchanged_next;call super::itemchanged_next;IF f_null (Object.tasa_jm_cd [row]) THEN RETURN

DateTime ldt_gijunga_ymd, ldt_org_tr_ymd

DEC	ldc_tr_aek, ldc_unit, ldc_jwa, ldc_gjwa, ldc_org_seq_no

STRING	ls_jm_cd, ls_fund_cd, ls_tr_co_cd

ls_jm_cd = Object.tasa_jm_cd [row]
ls_fund_cd = Object.fund_cd [row]
ls_tr_co_cd = Object.tr_co_cd [row]
ldt_gijunga_ymd = Object.gijunga_ymd [row]
ldt_org_tr_ymd = Object.org_tr_ymd [row]
ldc_org_seq_no = Object.org_seq_no [row]

SELECT  NVL(trans_unit,1000)
  INTO  :ldc_unit
FROM    sjm0sc t1
WHERE   t1.corp_gr    = :gaa.corp_gr
  AND   t1.tasa_jm_cd = :ls_jm_cd;
  ldc_unit = SQLCA.getitemnumber (1)
IF SQLCA.SQLCode()<>0 THEN f_messageBox ('ERR', '타사종목 거래단위를 확인하십시오.')

IF dw_c.object.dddw [1]='J61' Then
   IF f_num (Object.ggijunga [row])<>0 THEN Object.gtr_jwa [row] = round (Object.tr_aek [row] / Object.ggijunga [row] * ldc_unit,0)

ElseIF dw_c.object.dddw [1]='H61'   Then
   SELECT  tr_aek
     INTO  :ldc_tr_aek
   FROM    sjt5sg t1
   WHERE   t1.corp_gr    = :gaa.corp_gr
     AND   t1.tr_ymd     = :ldt_org_tr_ymd
     AND   t1.tr_cd      = 'J61'
     AND   t1.fund_cd    = :ls_fund_cd
     AND   t1.tr_co_cd   = :ls_tr_co_cd
     AND   t1.tasa_jm_cd = :ls_jm_cd
     AND   t1.seq_no     = :ldc_org_seq_no;
	  ldc_tr_aek = SQLCA.getitemnumber (1)

   Object.tr_aek [row] = ldc_tr_aek - Object.susu [row]
   Object.gtr_jwa [row] = round ((ldc_tr_aek - Object.susu [row]) / Object.ggijunga [row] * ldc_unit,0)
Else
   SELECT  NVL(bfil_jwa,0) + nvl(up_jwa,0)
         , NVL(gbfil_jwa,0) + nvl(gup_jwa,0)
     INTO  :ldc_jwa
         , :ldc_gjwa
   FROM    sjm5sm t1
   WHERE   t1.corp_gr    = :gaa.corp_gr
     AND   t1.ymd        = :ldt_gijunga_ymd
     AND   t1.fund_cd    = :ls_fund_cd
     AND   t1.tasa_jm_cd = :ls_jm_cd;
	  ldc_jwa     = SQLCA.getitemnumber (1)
	  ldc_gjwa    = SQLCA.getitemnumber (2)

   Object.gtr_jwa [row] = round (ldc_gjwa / ldc_jwa * Object.tr_jwa [row],0)
End IF
end event

