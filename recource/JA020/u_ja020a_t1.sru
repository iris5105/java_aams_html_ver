forward
global type u_ja020a_t1 from utt_vertshare
end type
end forward

global type u_ja020a_t1 from utt_vertshare
integer width = 4361
string text = "기본정보"
string ts_find = "jc_join=~'~'"
end type
global u_ja020a_t1 u_ja020a_t1

type variables
STRING	gs_corp_gr
end variables

on u_ja020a_t1.create
call super::create
end on

on u_ja020a_t1.destroy
call super::destroy
end on

type ln_temptop from utt_vertshare`ln_temptop within u_ja020a_t1
end type

type ln_tempstart from utt_vertshare`ln_tempstart within u_ja020a_t1
end type

type ln_templeft from utt_vertshare`ln_templeft within u_ja020a_t1
end type

type ln_cond_start from utt_vertshare`ln_cond_start within u_ja020a_t1
end type

type ln_tempright from utt_vertshare`ln_tempright within u_ja020a_t1
end type

type ln_cond1_yline from utt_vertshare`ln_cond1_yline within u_ja020a_t1
end type

type ln_dw1_yline from utt_vertshare`ln_dw1_yline within u_ja020a_t1
end type

type ln_tempbutton from utt_vertshare`ln_tempbutton within u_ja020a_t1
end type

type dw_pagelist from utt_vertshare`dw_pagelist within u_ja020a_t1
string dataobject = "d_ja020a_t1a"
boolean hscrollbar = true
boolean eb_always_1_insert = true
end type

event dw_pagelist::ue_insertstart;call super::ue_insertstart;STRING	jc_join

SELECT  f_n0(seqval ('join_seq'))
  INTO  :jc_join
FROM    dual;
jc_join = SQLCA.getitemstring (1)

uf_SetColumn ('ymd', string (iu_wpage.idt_workdate))
uf_SetColumn ('jc_join', jc_join)
uf_SetColumn ('cy_gb', '1')
uf_setcolumn ('upd_user',gnv_vari.is_user_id)

dw_pageMaster.POST SetColumn ('ymd')

RETURN 0
end event

event dw_pagelist::ue_deletestart;call super::ue_deletestart;LONG	ll, ll_count

STRING	ls_jc_join

ls_jc_join = Object.jc_join [tRow]

SELECT COUNT (*)
  INTO :ll_count
  FROM SJG1FC t1
 WHERE t1.jc_join = :ls_jc_join ;

ll_count = SQLCA.GETITEMNUMBER (1)

IF ll_count > 0   Then
   F_MESSAGEBOX ('ERR', '신청 또는 청약자료가 있습니다.~r~n삭제 할 수 없습니다.')
   RETURN 1
END IF

RETURN 0
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;iu_wpage.tab_string [1] = Object.jc_join [currentrow]
parent.dynamic EVENT ue_parent_event ()
RETURN 0
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
IF f_notnull (Object.sj_ymd [row]) And f_notnull (Object.balh_co [row]) Then
   RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.sj_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
   gnv_rolemenu.of_setopensheet('00941')
End IF
end event

type dw_pagemaster from utt_vertshare`dw_pagemaster within u_ja020a_t1
integer width = 2373
string dataobject = "d_ja020a_t1b"
end type

event dw_pagemaster::constructor;call super::constructor;IF NOT gaa.aams THEN MODIFY ("jc_join.visible='0'")
end event

event dw_pagemaster::itemchanged_next;call super::itemchanged_next;STRING	ls_old, ls_balh_co, ls_jm_cd, ls_jm_nm

CHOOSE CASE name
   CASE 'balh_co'
      ls_old  = GetItemstring (row, 'xx_balh_co', Primary!, TRUE)
      IF f_notnull (ls_old) THEN Object.xx_balh_co [row] = ls_old

      ls_balh_co = Object.balh_co [row]

      SELECT  jm_cd
            , jj_nm
        INTO  :ls_jm_cd
            , :ls_jm_nm
      FROM    sjm0jj t1
      WHERE   t1.balh_co  = :ls_balh_co
        AND   t1.danc_gb  = 'B'
        AND   REGEXP_LIKE (jj_nm, '공모');
		  ls_jm_cd = SQLCA.getitemstring (1)
		  ls_jm_nm = SQLCA.getitemstring (2)
      IF SQLCA.sqlcode ()<>0  Then
         f_messageBox ('INFO', '청약종목을 단축식별자 비상장(B)로 등록하십시오.')
      Else
         Object.cy_jm_cd [row] = ls_jm_cd
         Object.xx_cy_jm_cd [row] = ls_jm_nm
      End IF

      SELECT  jm_cd
            , jj_nm
        INTO  :ls_jm_cd
            , :ls_jm_nm
      FROM    sjm0jj t1
      WHERE   t1.balh_co = :ls_balh_co
        AND   t1.danc_gb IN ('A','C','D','G');
		  ls_jm_cd = SQLCA.getitemstring (1)
		  ls_jm_nm = SQLCA.getitemstring (2)
      IF SQLCA.sqlcode ()<>0  Then
         f_messageBox ('INFO', '상장예정종목을 등록하십시오.')
      Else
         Object.sj_jm_cd [row] = ls_jm_cd
         Object.xx_sj_jm_cd [row] = ls_jm_nm
      End IF
   CASE 'tot_g_jusu','tot_g_danga'
      Object.tot_g_aek [row] = f_num (Object.tot_g_jusu [row]) * f_num (Object.tot_g_danga [row])
END CHOOSE
end event

event dw_pagemaster::buttonup;STRING   ls_ret, ls_data

CHOOSE CASE dwo.name
	CASE 'p_xx_balh_co','p_xx_cy_jm_cd','p_xx_sj_jm_cd'
		call fw_u_dwo::buttonup
		setcolumn (MID (string (dwo.name),6))
		IF	dwo.name='p_xx_balh_co' THEN gaa.getcode.is_SearchDefault = Object.xx_balh_co [row]
		ls_ret = gaa.getcode.EVENT ue_getcode (row, THIS, gs_corp_gr)
		IF F_NOTNULL(ls_ret) THEN
         ls_data = string (gaa.getcode.codesearch_select_data[1])
         SetText (ls_data)
         ACCEPTTEXT ( )   // ItemChanged 이벤트발생
      END IF
		RETURN
END CHOOSE

call super::buttonup
end event

event dw_pagemaster::rbuttondown;If NOT Isvalid(dwo)              THEN RETURN
If string(dwo.name)='datawindow' THEN RETURN // 데이터윈도우 빈 공백 클릭됨

STRING	ls_protect, ls_ret

CHOOSE CASE dwo.name
	CASE 'balh_co','cy_jm_cd','sj_jm_cd'
		ls_protect = dwo.Protect
		IF	isNumber (ls_protect)=FALSE THEN ls_protect = describe ("Evaluate(~"" + RightA(ls_protect, LenA(ls_protect) - PosA(ls_protect,"~t")) + ", " + string (row)+")")
		uf_setrow (row, false)
		IF	ls_protect='0' And (dec (dwo.TabSequence)>0)	Then
			setcolumn (string (dwo.name))
			IF	describe ('xx_' + dwo.name + '.type')='column'	Then	// 코드찾기가 필요한 컬럼인지 확인한다.
				IF	dwo.name='bahl_co' THEN gaa.getcode.is_SearchDefault = Object.xx_balh_co [row]
				ls_ret = gaa.getcode.EVENT ue_getcode (row, THIS, gs_corp_gr)
				IF	NOT f_null (ls_ret)	Then
					dwo.primary [row] = ls_ret
					event itemchanged (row, dwo, ls_ret)
				End IF
				RETURN
			End IF
		End IF
		call fw_u_dwo::rbuttondown
	CASE ELSE
		call super::rbuttondown
END CHOOSE
end event

event dw_pagemaster::ue_protect;call super::ue_protect;IF	Object.p_visible [row]=1 OR gaa.admin	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

event dw_pagemaster::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'tr_co_cd'
      rs_where = "tr_gb='1' and used='1'"
END CHOOSE
RETURN 1
end event

event dw_pagemaster::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1

STRING	ls_nm

LONG	ll

CHOOSE CASE dwo.name
   CASE 'xx_balh_co'
		FOR  ll = 1  TO  rowcount ()
			IF	ll<>row And Object.xx_balh_co [row] = data	Then
				RETURN uf_itemerr (row, dwo.name, '동일한 종목이 등록되어 있습니다.')
			End IF
		NEXT
END CHOOSE
end event

type st_move from utt_vertshare`st_move within u_ja020a_t1
end type

