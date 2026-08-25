forward
global type w_ja990k from wt_list
end type
end forward

global type w_ja990k from wt_list
boolean eb_direct_retrieve = true
end type
global w_ja990k w_ja990k

event wue_retrieve;call super::wue_retrieve;dw_list.SetFilter ("lsy_ymd >= date('" + string (idt_workdate, 'yyyy.mm.dd') + "') OR isNull (lsy_ymd)")
dw_list.retrieve (gaa.corp_gr)
end event

on w_ja990k.create
int iCurrent
call super::create
end on

on w_ja990k.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja990k
end type

type ln_templeft from wt_list`ln_templeft within w_ja990k
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja990k
end type

type ln_temptop from wt_list`ln_temptop within w_ja990k
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja990k
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja990k
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja990k
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja990k
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja990k
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja990k
end type

type ln_tempright from wt_list`ln_tempright within w_ja990k
end type

type uo_navi from wt_list`uo_navi within w_ja990k
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja990k
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja990k
end type

type st_top_rect from wt_list`st_top_rect within w_ja990k
end type

type p_close from wt_list`p_close within w_ja990k
end type

type p_excel from wt_list`p_excel within w_ja990k
end type

type p_print from wt_list`p_print within w_ja990k
end type

type p_delete from wt_list`p_delete within w_ja990k
end type

type p_update from wt_list`p_update within w_ja990k
end type

type p_input from wt_list`p_input within w_ja990k
end type

type p_retrieve from wt_list`p_retrieve within w_ja990k
end type

type p_clear from wt_list`p_clear within w_ja990k
end type

type p_copy from wt_list`p_copy within w_ja990k
end type

type dw_c from wt_list`dw_c within w_ja990k
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_list`btn_update within w_ja990k
end type

type st_count from wt_list`st_count within w_ja990k
end type

type dw_list from wt_list`dw_list within w_ja990k
integer y = 156
integer height = 2608
string dataobject = "d_ja990k1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	sSj_cd, sSj_cd1, sSj_Gb, sY, sM, sJ_Nm, sj_Nm1, sj_Nm2, sJ_Nm3
STRING	ls_koscom_cd, ls_jasan

DEC	ldc_close

DateTime ldt_lsy_ymd, ldt_chk_ymd

CHOOSE CASE dwo.name
   CASE 'sj_gb'
      CHOOSE CASE data
         CASE '0'
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = null_dc
            Object.lsy_ymd [row] = null_dt
         CASE '1'
            Object.hangsa_ga [row] = null_dc
            IF Object.jasan_gb [row]='06' Then
               Object.unit_aek [row] = 250000
            Else
               Object.unit_aek [row] = 10000
            End IF
         CASE '2','3'
            Object.unit_aek [row] = 250000
      END CHOOSE

      ls_jasan = Object.jasan [row]
      CHOOSE CASE ls_jasan
         CASE 'XX'   // 국고채금리
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = 1000000
            Object.koscom_cd [row] = null_s
         CASE 'X1'   // 통안채금리
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = 2000000
            Object.koscom_cd [row] = null_s
         CASE 'KQ'   // KOSDAQ50
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = 200000
            Object.koscom_cd [row] = null_s
         CASE Else   // 개별주식
            SELECT  sebu_cd_enm
              INTO  :ls_koscom_cd
            FROM    szx0gr t1
            WHERE   t1.gr_cd               = 'A6'
              AND   t1.sebu_cd             = :ls_jasan
              AND   LENGTH(t1.sebu_cd_enm) = 6;
				
				ls_koscom_cd = SQLCA.getitemstring (1)
				
            IF SQLCA.SQLCode()=0   Then
               SELECT  NVL(preclose,0)
                 INTO  :ldc_close
               FROM    sjt1tg t1
               WHERE   t1.ymd       = :idt_workdate
                 AND   t1.koscom_cd = :ls_koscom_cd;
					
					ldc_close = SQLCA.getitemnumber (1)
					
               IF SQLCA.SQLCode()=0   Then
                  Object.unit_aek [row] = 10
                  Object.koscom_cd [row] = ls_koscom_cd
               Else
                  Object.koscom_cd [row] = null_s
               End IF
            Else
               Object.koscom_cd [row] = null_s
            End IF
      END CHOOSE

   CASE 'jasan'
      CHOOSE CASE data
         CASE '01' to '09'
            CHOOSE CASE Object.sj_gb [row]
               CASE '0'
                  Object.hangsa_ga [row] = null_dc
                  Object.unit_aek [row] = null_dc
                  Object.koscom_cd [row] = null_s
               CASE '1'
                  Object.hangsa_ga [row] = null_dc
                  IF data='06'   Then
                     Object.unit_aek [row] = 10000
                  Else
                     Object.unit_aek [row] = 250000
                  End IF
                  Object.koscom_cd [row] = null_s
               CASE '2','3'
                  Object.unit_aek [row] = 250000
                  Object.koscom_cd [row] = null_s
            END CHOOSE
         CASE 'XX'   // 국고채금리
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = 1000000
            Object.koscom_cd [row] = null_s
         CASE 'X1'   // 통안채금리
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = 2000000
            Object.koscom_cd [row] = null_s
         CASE 'KQ'   // KOSDAQ50
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = 200000
            Object.koscom_cd [row] = null_s
         CASE '75','76' // USD,JPY
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row] = 10000
            Object.koscom_cd [row] = null_s
         CASE Else   // 개별주식
            SELECT  sebu_cd_enm
              INTO  :ls_koscom_cd
            FROM    szx0gr t1
            WHERE   t1.gr_cd               = 'A6'
              AND   t1.sebu_cd             = :data
              AND   LENGTH(t1.sebu_cd_enm) = 6;
				
				ls_koscom_cd = SQLCA.getitemstring (1)
				
            IF SQLCA.SQLCode()=0   Then
               SELECT  NVL(preclose,0)
                 INTO  :ldc_close
               FROM    sjt1tg t1
               WHERE   t1.ymd       = :idt_workdate
                 AND   t1.koscom_cd = :ls_koscom_cd;
					
					ldc_close = SQLCA.getitemnumber (1)
					
               IF SQLCA.SQLCode()=0   Then
                  Object.unit_aek [row] = 10
                  Object.koscom_cd [row] = ls_koscom_cd
               Else
                  Object.koscom_cd [row] = null_s
               End IF
            Else
               Object.koscom_cd [row] = null_s
            End IF
      END CHOOSE

   CASE 'lsy_ymd'
      ldt_lsy_ymd = DateTime (Date (MidA (data,1,10)))

      IF ldt_lsy_ymd<idt_workdate   Then
         RETURN uf_itemerr (row, 'lsy_ymd', '작업일전의 최종결제일은 입력할 수 없습니다.')
      End IF

      IF Object.sj_gb [row]='1' and  PosA ('75,76', string (object.jasan [row]))=0  Then
         IF PosA ('03,06,09,12',string (ldt_lsy_ymd,'mm'))=0   Then
            RETURN uf_itemerr (row, 'lsy_ymd', '선물 최종결제월은 3,6,9,12월만 가능합니다.')
         End IF
      End IF

      CHOOSE CASE Object.jasan [row]
         CASE '75', '76'
            SELECT  next_day(trunc(:ldt_lsy_ymd,'mm') - 1, '월') + 16
              INTO  :ldt_chk_ymd
            FROM    dual;

				ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd<>ldt_chk_ymd   Then
               f_messageBox ('I001', '셋째주 수요일이 아닙니다.' + string (ldt_chk_ymd))
            End IF
         CASE 'XX', 'X1'
            SELECT  next_day(trunc(:ldt_lsy_ymd,'mm') - 1, '수') + 14
              INTO  :ldt_chk_ymd
            FROM    dual;

				ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd<>ldt_chk_ymd   Then
               f_messageBox ('I001', '셋째주 수요일이 아닙니다.')
            End IF
         CASE Else
            IF f_notnull (Object.koscom_cd [row])  Then
               SELECT  next_day(trunc(:ldt_lsy_ymd,'mm'), '목') + 7
                 INTO  :ldt_chk_ymd
               FROM    dual;

					ldt_chk_ymd = SQLCA.getitemdatetime (1)

               IF ldt_lsy_ymd<>ldt_chk_ymd   Then
                  f_messageBox ('I001', '둘째주 목요일이 아닙니다.')
               End IF
            End IF
      END CHOOSE
END CHOOSE

Object.sj_cd [row] = null_s
Object.sj_nm [row] = null_s

Accepttext ()

sSj_cd = 'KR4' + Object.sj_gb [row] + Object.jasan [row]

sY = string (object.lsy_ymd [row], 'yyyy')
SELECT  ss_dae_cd
  INTO  :sY
FROM    szx0ym t1
WHERE   t1.ymd_gb = 'Y'
  AND   t1.ymd_id = :sY;

sY = SQLCA.getitemstring (1)

sM = string (object.lsy_ymd [row], 'mm' )
CHOOSE CASE sM
   CASE '10'
      sM =  'A'
   CASE '11'
      sM =  'B'
   CASE '12'
      sM =  'C'
   CASE Else
      sM =  MidA (sM, 2, 1)
END CHOOSE

CHOOSE CASE Object.sj_gb [row]
   CASE '0'
      sSj_cd = sSj_cd + '00000'
   CASE '1'
      sSj_cd = sSj_cd + sY + sM + '000'
   CASE Else
      Object.seq [row] = RightA ('000'+string (truncate (f_num (Object.hangsa_ga [row]),0)),3)
      sSj_cd = sSj_cd + sY + sM + Object.seq [row]
END CHOOSE

Object.sj_cd [row] = f_jm_check (sSj_cd)

IF LenA (sSj_cd)>=11 THEN
   ls_jasan = Object.jasan [row]
   CHOOSE CASE ls_jasan
      CASE '75','76' // USD,JPY
         SetTabOrder ('sj_cd',5)
   END CHOOSE

   sSj_cd1 = MidA (sSj_cd,5,2)  //선물옵션 대상 상품명을 가져오기 위한 코드 (A6)
   SELECT  sebu_cd_nm
     INTO  :sJ_Nm1
   FROM    szx0gr t1
   WHERE   t1.gr_cd   = 'A6'
     AND   t1.sebu_cd = :sSj_cd1;

	sJ_Nm1 = SQLCA.getitemstring (1)

   sSj_Gb = Object.sj_gb [row]
   SELECT  sebu_cd_nm
     INTO  :sJ_Nm2
   FROM    szx0gr t1
   WHERE   t1.gr_cd   = 'A7'
     AND   t1.sebu_cd = :sSj_Gb;

	sJ_Nm2 = SQLCA.getitemstring (1)

   sJ_Nm3 = string (object.lsy_ymd [row], "yymm")

   sJ_Nm = sJ_Nm1 + sJ_Nm2 + sJ_Nm3
   IF match (object.sj_gb [row],'[2,3]')  Then
      sJ_Nm = sJ_Nm + '(' + string (Object.hangsa_ga [row],'0.00') + ')'
   ElseIF Object.sj_gb [row]='0' THEN
      sJ_Nm = sJ_Nm1 + sJ_Nm2
   End IF

   Object.sj_nm [row] = sJ_Nm
End IF
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'sj_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'gyul_gigan', gaa.corp_gr, '', 1, '')
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('sj_gb', '1')
uf_setColumn ('jasan', '01')
uf_setColumn ('unit_aek', '250000')
uf_setColumn ('seq', '000')

POST SetColumn ('lsy_ymd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF gaa.aams OR GETITEMSTATUS (ROW, 0, PRIMARY!)=NEWMODIFIED!   Then
   f_setprotect (THIS, FALSE, { 'sj_gb', 'jasan', 'unit_gb' })
   Object.p_visible [row] = 1
ELSE
   f_setprotect (THIS, TRUE, { 'sj_gb', 'jasan', 'unit_gb' })
   Object.p_visible [row] = 1
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow

FOR  lRow = 1  TO  rowcount ()
   IF f_null (Object.sj_nm [lRow])  Then
      f_messageBox ("I000", string (lRow) + " 행에서 선물종목명 오류")
      RETURN 1
   End IF
   IF f_null (Object.sj_gb [lRow])  Then
      f_messageBox ("I000", string (lRow) + " 행에서 선물종목구분 오류")
      RETURN 1
   End IF
   IF Object.sj_gb [lRow]<>'0'   Then
      IF isNull (Object.lsy_ymd [lRow])   Then
         f_messageBox ("I000", string (lRow) + " 행에서 최종결제일 오류")
         RETURN 1
      End IF
      IF Object.sj_gb [lRow]<>'1'   Then
         IF f_num (Object.hangsa_ga [lRow])=0   Then
            f_messageBox ("I000", string (lRow) + " 행에서 행사가격 오류")
            RETURN 1
         End IF
      End IF
      IF f_num (Object.unit_aek [lRow])=0 Then
         f_messageBox ("I000", string (lRow) + " 행에서 단위승수 오류")
         RETURN 1
      End IF
   End IF
NEXT
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE	GetColumnName()
	CASE 'jasan'
		rs_where = "sebu_num<>2"
END CHOOSE
RETURN 1
end event

