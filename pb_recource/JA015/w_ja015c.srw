forward
global type w_ja015c from wt_listdetail
end type
end forward

global type w_ja015c from wt_listdetail
string is_init_value = "1"
end type
global w_ja015c w_ja015c

type variables

end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.dddw [1], uf_initdate ('inputdate'))
end event

on w_ja015c.create
int iCurrent
call super::create
end on

on w_ja015c.destroy
call super::destroy
end on

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja015c
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja015c
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja015c
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja015c
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja015c
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja015c
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja015c
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja015c
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja015c
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja015c
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja015c
end type

type uo_navi from wt_listdetail`uo_navi within w_ja015c
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja015c
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja015c
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja015c
end type

type p_close from wt_listdetail`p_close within w_ja015c
end type

type p_excel from wt_listdetail`p_excel within w_ja015c
end type

type p_print from wt_listdetail`p_print within w_ja015c
end type

type p_delete from wt_listdetail`p_delete within w_ja015c
end type

type p_update from wt_listdetail`p_update within w_ja015c
end type

type p_input from wt_listdetail`p_input within w_ja015c
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja015c
end type

type p_clear from wt_listdetail`p_clear within w_ja015c
end type

type p_copy from wt_listdetail`p_copy within w_ja015c
end type

type dw_c from wt_listdetail`dw_c within w_ja015c
string title = "종목구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', gaa.corp_gr, "0,전단채,,1,사모사채,", 1, "")
end event

event dw_c::ue_valid;call super::ue_valid;ia_value [1] = dw_c.object.dddw [1]
dw_Detail.uf_dataobject ('d_ja015c2'+Object.dddw [1], FALSE)
RETURN TRUE
end event

type btn_update from wt_listdetail`btn_update within w_ja015c
end type

type st_count from wt_listdetail`st_count within w_ja015c
end type

type dw_list from wt_listdetail`dw_list within w_ja015c
string dataobject = "d_ja015c1"
boolean eb_always_1_insert = true
string is_encrypts = "enc_pb_tel,enc_acct_no"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt

LONG	ll, lR, lj

DEC	ldc_aekm

STRING	ls_jm_nm, ls_mg_cd, ls_mg_jj_nm, ls_pb_nm, ls_enc_pb_tel, ls_pb_tel, ls_nm, ls_no, ls_code, ls_sqlsyntax

aDS_jTier	lds_jtier

CHOOSE CASE dwo.name
   CASE 'ymd'
      IF dw_c.object.dddw [1]='0' And dw_detail.rowcount ()=0  Then
         IF f_messageBox ('I002','기준일 만기 롤오버자료를 생성하시겠습니까?')=1 Then
            ldt = datetime (date (MID (data,1,10)))
            ls_sqlsyntax = "               SELECT  t1.hj_nm " &
                         + "                     , NVL(t2.bfil_aekm,0) + nvl(t2.meib_aekm,0) - nvl(t2.medo_aekm,0) " &
                         + "                     , t4.mg_cd " &
                         + "                     , t4.fund_cd " &
                         + "                     , t4.fund_nm " &
                         + "                     , TO_DECRYPTS(t4.enc_acct_no) " &
                         + "               FROM    shm0hj t1 " &
                         + "                     , shm0hm t2 " &
                         + "                     , szm0ia t4 " &
                         + "               WHERE   t1.corp_gr      = '" + gaa.corp_gr + "' " &
                         + "                 AND   t1.sanghw_ymd   = '" + string (ldt,'yyyy.mm.dd') + "' " &
                         + "                 AND   t1.cash_cd      IN ('ZS','ZF') " &
                         + "                 AND   t2.corp_gr      = t1.corp_gr " &
                         + "                 AND   t2.ymd          = '" + string (idt_workdate,'yyyy.mm.dd') + "' " &
                         + "                 AND   t2.jm_cd        = t1.jm_cd " &
                         + "                 AND   t4.corp_gr      = t1.corp_gr " &
                         + "                 AND   t4.fund_cd      = t2.fund_cd " &
                         + "               ORDER BY  t4.mg_cd " &
                         + "                       , t2.fund_cd "

            lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

            FOR  lj = 1  TO  lR
					ls_jm_nm      = lds_jtier.getitemString (lj, 1)
					ldc_aekm      = lds_jtier.getitemnumber (lj, 2)
					ls_mg_cd      = lds_jtier.getitemString (lj, 3)
					ls_mg_jj_nm   = lds_jtier.getitemString (lj, 4)
					ls_pb_nm      = lds_jtier.getitemString (lj, 5)
					ls_enc_pb_tel = lds_jtier.getitemString (lj, 6)
					ls_pb_tel     = lds_jtier.getitemString (lj, 7)
					ls_code       = lds_jtier.getitemString (lj, 8)
					ls_nm         = lds_jtier.getitemString (lj, 9)
					ls_no         = lds_jtier.getitemString (lj, 10)

               ll = dw_detail.insertrow (0)
               dw_detail.object.corp_gr [ll] = gaa.corp_gr
               dw_detail.object.ymd [ll] = ldt
               dw_detail.object.jm_gu [ll] = '0'
               dw_detail.object.jm_nm [ll] = dw_List.object.jm_nm [iRow]
               dw_detail.object.gb [ll] = '1'
               dw_detail.object.seq [ll] = ll
               dw_detail.object.mg_cd [ll] = ls_mg_cd
               dw_detail.object.mg_jj_nm [ll] = ls_mg_jj_nm
               dw_detail.object.pb_nm [ll] = ls_pb_nm
               dw_detail.object.pb_tel [ll] = ls_pb_tel
               dw_detail.object.enc_pb_tel [ll] = ls_enc_pb_tel
               dw_detail.object.xx_acct_no [ll] = ls_nm
               dw_detail.object.acct_no [ll] = ls_no
               dw_detail.object.aekm [ll] = ldc_aekm
               dw_detail.object.bigo [ll] = ls_jm_nm + ' 만기'
               dw_detail.object.dec_yn [ll] = '0'
               dw_detail.object.fund_cd [ll] = ls_code
  				NEXT
            RETURN
         End IF
      End IF
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.ymd [ll] = datetime (date (MID (data,1,10)))
      NEXT
   CASE 'jm_nm'
      FOR  ll = 1  TO  rowcount ()
         IF ll<>row And Object.ymd [ll]=Object.ymd [row] And Object.jm_nm [ll]=data Then
            RETURN uf_itemerr (row, dwo.name, '동일 종목이 있습니다.')
         End IF
      NEXT
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.jm_nm [ll] = data
      NEXT
   CASE 'jm_cd'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.jm_cd [ll] = data
      NEXT
   CASE 'pre_per'
      IF f_messageBox ('I002','선취수수료율을 일괄 적용 하시겠습니까?')=1  Then
         FOR  ll = 1  TO  dw_detail.rowcount ()
            dw_detail.object.pre_per [ll] = dec (data)
         NEXT
      Else
         FOR  ll = 1  TO  dw_detail.rowcount ()
            IF f_num (dw_detail.object.pre_per [ll])=0 THEN dw_detail.object.pre_per [ll] = dec (data)
         NEXT
      End IF
   CASE 'balh_gyumo'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.balh_gyumo [ll] = dec (data)
      NEXT
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;IF Object.ymd [row]>=uf_initdate ('inputdate') OR Object.p_visible [row]=1	Then
   uf_protect (row, ia_protect [1], TRUE, FALSE, TRUE)
Else
   uf_protect (row, ia_protect [2], TRUE, FALSE, FALSE)
End IF
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF dw_c.object.dddw [1]='1' THEN uf_setcolumn ('ymd', string (idt_workdate))
RETURN 0
end event

type dw_detail from wt_listdetail`dw_detail within w_ja015c
string dataobject = "d_ja015c20"
string islist4subbtnauth = "0011110000"
string is_resize_column = "bigo"
string is_encrypts = "enc_pb_tel,enc_acct_no"
end type

event dw_detail::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_co_cd', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'mg_cd', gaa.corp_gr, '', 1, '')
//F_DDDWCTL (THIS, 'unyong_sabun', gaa.corp_gr, '', 2, "eymd is null")
end event

event dw_detail::itemchanged;LONG	ll

STRING	ls_ret

CHOOSE CASE dwo.name
   CASE 'gb'
      IF data='1' THEN Object.priority [row] = 0
   CASE 'dec_yn'
      IF dw_c.object.dddw [1]='0'   Then
         CHOOSE CASE data
            CASE '1'
               Object.rollover_aekm [row] = Object.aekm [row]
            CASE Else
               Object.rollover_aekm [row] = null_dc
         END CHOOSE
      End IF
   CASE 'mg_cd'
      IF f_null (data)  Then
         Object.xx_mg_cd [row] = null_s
         Object.pb_nm [row] = null_s
         Object.pb_tel [row] = null_s
      Else
         dwo.primary [row] = data
         ls_ret = gaa.getcode.EVENT ue_getcode (row, THIS, gaa.corp_gr)
         IF ls_ret<>''  Then
            dwo.primary [row] = ls_ret
            gaa.getcode.EVENT ue_setcodeName (THIS, row, 'mg_cd', ls_ret, dwo.primary [row], gaa.corp_gr)
            Send(handle(THIS),256,9,0) // TAB
         End IF
      End IF
   CASE 'tr_co_cd'
      FOR  ll = 1  TO  rowcount ()
         IF f_null (Object.tr_co_cd [ll]) THEN Object.tr_co_cd [ll] = data
      NEXT
   CASE 'meib_ymd'
      FOR  ll = 1  TO  rowcount ()
         IF f_null (Object.meib_ymd [ll]) THEN Object.meib_ymd [ll] = datetime (date (MID (data,1,10)))
      NEXT
   CASE 'sanghw_ymd'
      FOR  ll = 1  TO  rowcount ()
         IF f_null (Object.sanghw_ymd [ll]) THEN Object.sanghw_ymd [ll] = datetime (date (MID (data,1,10)))
      NEXT
END CHOOSE

IF dwo.name<>'mg_cd'	Then
	call super::itemchanged
End IF
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('ymd', string (dw_List.object.ymd [iRow]))
uf_setColumn ('jm_gu', dw_c.object.dddw [1])
uf_setColumn ('jm_nm', dw_List.object.jm_nm [iRow])
uf_setColumn ('balh_gyumo', string (dw_List.object.balh_gyumo [iRow]))
uf_setColumn ('gb', '2')
uf_setColumn ('con_yn', 'N')
uf_setColumn ('dep_yn', 'N')
IF dw_c.object.dddw [1]='0'   Then
   uf_setColumn ('dec_yn', '0')
Else
   uf_setColumn ('dec_yn', 'N')
End IF

// updatestart 에서 생성
uf_setColumn ('seq', '0')
uf_setColumn ('priority', '0')

RETURN 0
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_List.object.ymd [iRow], dw_c.object.dddw [1], dw_List.object.jm_nm [iRow])
end event

event dw_detail::rowfocuschanged_if;call super::rowfocuschanged_if;f_dddw_filter (THIS, 'pb_nm', "fkey='" + f_nvl (Object.mg_cd [currentrow],' ') + "'")
f_dddw_filter (THIS, 'mg_jj_nm', "fkey='" + f_nvl (Object.mg_cd [currentrow],' ') + "'")
RETURN 0
end event

event dw_detail::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

DEC	ll_seq = 0, ldc_priority = 0

STRING	ls_jm_gu, ls_nm

DateTime ldt

ldt = dw_List.object.ymd [iRow]
ls_jm_gu = dw_c.object.dddw [1]
ls_nm = dw_List.object.jm_nm [iRow]

FOR  ll = 1  TO  rowcount ()
   IF Object.seq [ll]=0 Then
		SELECT  seqval ('scm0df_seq')
		  INTO  :ll_seq
		FROM    dual;
		ll_seq = SQLCA.getitemnumber (1)
		Object.seq [ll] = ll_seq
   End IF
   IF Object.gb [ll]='2' And Object.priority [ll]=0   Then
      IF ldc_priority=0 Then
         SELECT  NVL(max(priority),0)
           INTO  :ldc_priority
         FROM    scm0df t1
         WHERE   t1.corp_gr = :gaa.corp_gr
           AND   t1.ymd     = :ldt
           AND   t1.jm_gu   = :ls_jm_gu
           AND   t1.jm_nm   = :ls_nm
           AND   t1.gb      = '2';
			ldc_priority = SQLCA.getitemnumber (1)
      End IF
      ldc_priority ++
      Object.priority [ll] = ldc_priority
   End IF
NEXT
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'mg_cd'
      IF f_notnull (Object.mg_cd [getrow ()]) THEN rs_where = "mg_cd='" + Object.mg_cd [getrow ()] + "'"
   CASE 'acct_no'
	   rs_where = "(t1.close_ymd is null OR t1.close_ymd>'" + string (dw_List.object.ymd [iRow],'yyyy.mm.dd') + "')"
		IF f_notnull (dw_detail.object.mg_cd [getrow ()])    THEN rs_where += " AND t2.mg_cd = '" + string (dw_detail.object.mg_cd [getrow ()]) + "'"
END CHOOSE
RETURN 2 // 순번
end event

event dw_detail::rbuttondown;STRING	ls_ret
CHOOSE CASE dwo.name
   CASE 'mg_cd'
      uf_setrow (row, FALSE)
      SetColumn (string (dwo.name))
      ls_ret = gaa.getcode.EVENT ue_getcode (row, THIS, gaa.corp_gr)
      IF ls_ret<>''  Then
         dwo.primary [row] = ls_ret
         gaa.getcode.EVENT ue_setcodeName (THIS, row, 'mg_cd', ls_ret, dwo.primary [row], gaa.corp_gr)
         Send(handle(THIS),256,9,0) // TAB
      End IF
      RETURN
END CHOOSE
call super::rbuttondown
end event

event dw_detail::ue_protect;call super::ue_protect;IF dw_list.object.p_visible [iRow]=1	Then
	uf_protect (row, ia_protect [1], TRUE, TRUE, TRUE)
Else
   uf_protect (row, ia_protect [2], FALSE, FALSE, FALSE)
End IF
end event

type st_move from wt_listdetail`st_move within w_ja015c
end type

