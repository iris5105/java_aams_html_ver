forward
global type u_ja990d_t1 from utt_vertshare
end type
type dw_1 from fw_u_dwo within u_ja990d_t1
end type
type st_1 from pf_u_splitbar_horizontal within u_ja990d_t1
end type
end forward

global type u_ja990d_t1 from utt_vertshare
integer width = 3657
string text = "주식종목"
dw_1 dw_1
st_1 st_1
end type
global u_ja990d_t1 u_ja990d_t1

on u_ja990d_t1.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on u_ja990d_t1.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.st_1)
end on

event oue_postopen;call super::oue_postopen;dw_1.SetTransObject (SQLCA)
end event

type ln_temptop from utt_vertshare`ln_temptop within u_ja990d_t1
end type

type ln_tempstart from utt_vertshare`ln_tempstart within u_ja990d_t1
end type

type ln_templeft from utt_vertshare`ln_templeft within u_ja990d_t1
end type

type ln_cond_start from utt_vertshare`ln_cond_start within u_ja990d_t1
end type

type ln_tempright from utt_vertshare`ln_tempright within u_ja990d_t1
end type

type ln_cond1_yline from utt_vertshare`ln_cond1_yline within u_ja990d_t1
end type

type ln_dw1_yline from utt_vertshare`ln_dw1_yline within u_ja990d_t1
end type

type ln_tempbutton from utt_vertshare`ln_tempbutton within u_ja990d_t1
end type

type dw_pagelist from utt_vertshare`dw_pagelist within u_ja990d_t1
integer height = 2148
string dataobject = "d_ja990d_t1a"
boolean hscrollbar = true
boolean scaletobottom = false
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;uf_dddwctl ('woos_ilban_gb', dw_pageMaster, 'woos_ilban_gb', gaa.CORP_GR, '', 1, '')
uf_dddwctl ('chg_gb'       , dw_pageMaster, 'chg_gb'       , gaa.CORP_GR, '', 1, '')
uf_dddwctl ('new_old_gb'   , dw_pageMaster, 'new_old_gb'   , gaa.CORP_GR, '', 1, '')
uf_dddwctl ('danc_gb'      , dw_pageMaster, 'danc_gb'      , gaa.CORP_GR, '', 2, '')
uf_dddwctl ('capsize'      , dw_pageMaster, 'capsize'      , gaa.CORP_GR, '', 1, '')
uf_dddwctl ('kospigubun'   , dw_pageMaster, 'kospigubun'   , gaa.CORP_GR, '', 1, '')
uf_dddwctl ('under'        , dw_pageMaster, 'under'        , gaa.CORP_GR, '', 1, '')
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setColumn ('xx_balh_nation', 'KR')
uf_setColumn ('woos_ilban_gb', '0')
uf_setColumn ('chg_gb', '0')
uf_setColumn ('new_old_gb', '0')
uf_setColumn ('kweonri_ymd', string (iu_wpage.idt_workdate))
uf_setColumn ('upj_cd', 'A99')
uf_setColumn ('xx_upj_cd', f_getcodename (SQLCA, 'upj_cd', 1, 'A99', gaa.corp_gr))
uf_setColumn ('under', 'N')

RETURN 0
end event

event dw_pagelist::ue_insert;call super::ue_insert;dw_pageMaster.POST SetColumn ('balh_co')
RETURN row
end event

event dw_pagelist::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

STRING	ls_koscom_cd

FOR  ll = 1  TO  rowcount ()
   IF GETITEMSTATUS (ll, 0, PRIMARY!) = NEWMODIFIED!  Then
      // 종가를 위한 코드생성
      ls_koscom_cd = Object.koscom_cd [ll]

      SELECT koscom_cd
        INTO :ls_koscom_cd
        FROM SJT1TG t1
       WHERE t1.ymd       = :iu_wpage.idt_workdate
         AND t1.koscom_cd = :ls_koscom_cd ;
      IF SQLCA.SQLCode() <> 0 Then
         INSERT INTO SJT1TG
             ( ymd
             , koscom_cd
             )
         VALUES ( :iu_wpage.idt_workdate
                , :ls_koscom_cd
                ) ;
         IF SQLCA.sqlcode () <> 0   Then
            MESSAGEBOX ('sjt1tg INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
            RETURN 1
         END IF
      END IF
   END IF
NEXT

dw_1.UPDATE ()
commitJ ()
end event

event dw_pagelist::rowfocuschanging_return;call super::rowfocuschanging_return;dw_1.update ()
commitJ ()
RETURN 0
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;dw_1.retrieve (Object.jm_cd [currentrow])
RETURN 0
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'jm_cd'
      OpenwithParm (w_popup_sjm0jj_history, string (Object.jm_cd [row]))
END CHOOSE
end event

type dw_pagemaster from utt_vertshare`dw_pagemaster within u_ja990d_t1
integer height = 2148
string dataobject = "d_ja990d_t1b"
boolean scaletobottom = false
end type

event dw_pagemaster::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_sosok

CHOOSE CASE dwo.name
   CASE 'jm_cd'   // 해외종목 국내상장
      SELECT  jm_cd
        INTO  :ls_sosok
      FROM    sjm0jj t1
      WHERE   t1.jm_cd = :data;

      IF SQLCA.sqlcode ()=0	Then
         RETURN uf_itemerr (row, string (dwo.name), '이미 등록된 주식종목 입니다.')
      End IF

      IF f_null (Object.balh_co [row]) Then
         Object.balh_co [row] = MID (data,4,5)
         Object.xx_balh_co [row] = MID (data,4,5)
         Object.koscom_cd [row] = MID (data,4,5) + '0'
      End IF

   CASE 'balh_co'
		SELECT  sosok_gb
		  INTO  :ls_sosok
		FROM    sjx0jb t1
		WHERE   t1.balh_co = :data;

		ls_sosok = SQLCA.getitemstring (1)
		CHOOSE CASE ls_sosok
			CASE '1' TO '9'
				Object.danc_gb [row] = 'A'
			CASE Else
				Object.danc_gb [row] = ls_sosok
		END CHOOSE
		Object.koscom_cd [row] = data + Object.woos_ilban_gb [row]
		IF f_null (Object.jj_fnm [row]) THEN Object.jj_fnm [row] = Object.xx_balh_co [row]
		IF f_null (Object.jj_nm [row])  THEN Object.jj_nm [row] = Object.xx_balh_co [row]

	CASE "jj_nm"   // 종목명
      Object.jj_fnm [row] = data
END CHOOSE
end event

event dw_pagemaster::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'jm_cd'
      OpenwithParm (w_popup_sjm0jj_history, string (Object.jm_cd [row]))
END CHOOSE
end event

event dw_pagemaster::itemchanged_next;call super::itemchanged_next;IF f_notnull (Object.deposit [row]) AND NAME = 'deposit' Then
   IF Object.danc_gb [row] <> 'B'   Then
      F_MESSAGEBOX ('INFO', '비상장 종목만 선택 할 수 있습니다.')
      Object.deposit [row] = null_s
   END IF
END IF
IF Object.xx_balh_nation [row]<>'KR' AND Object.balh_co [row]=Object.xx_balh_co [row] THEN RETURN  // 해외종목 국내상장

STRING	aJm_cd [], sJm_cd, ls_sosok

CHOOSE CASE NAME
   CASE 'danc_gb', 'balh_co', 'woos_ilban_gb', 'chg_gb', 'new_old_gb', 'deposit'
      aJm_cd [1] = object.xx_balh_nation [row]
      aJm_cd [3] = Object.balh_co [row]

      SELECT sosok_gb
        INTO :ls_sosok
        FROM SJX0JB t1
       WHERE t1.balh_co = :aJm_cd[3] ;

      ls_sosok = SQLCA.GETITEMSTRING (1)

      CHOOSE CASE Object.danc_gb [row]
         CASE 'A', 'C', 'D'
            IF ls_sosok = '8' Then  // 해외DR
               aJm_cd [2] = '8'
            ELSE
               aJm_cd [2] = '7'
            END IF
         CASE 'X'
            aJm_cd [2] = 'A'
         CASE ELSE
            IF Object.deposit [row] = 'Y' Then
               aJm_cd [2] = '7'
            ELSE
               aJm_cd [2] = Object.danc_gb [row]
            END IF
      END CHOOSE

      aJm_cd [4]         = Object.woos_ilban_gb [row]
      aJm_cd [5]         = Object.chg_gb [row]
      aJm_cd [6]         = Object.new_old_gb [row]
      sJm_cd             = aJm_cd [1] + aJm_cd [2] + aJm_cd [3] + aJm_cd [4] + aJm_cd [5] + aJm_cd [6]
      Object.jm_cd [row] = f_jm_check (sJm_cd)
END CHOOSE
end event

type st_move from utt_vertshare`st_move within u_ja990d_t1
integer height = 2148
boolean scaletobottom = false
boolean rightmaxsizefixed = true
end type

type dw_1 from fw_u_dwo within u_ja990d_t1
integer x = 18
integer y = 2196
integer width = 3589
integer height = 644
integer taborder = 22
boolean bringtotop = true
string dataobject = "d_ja990d_t1c"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
end type

type st_1 from pf_u_splitbar_horizontal within u_ja990d_t1
integer x = 18
integer y = 2176
integer width = 3589
boolean bringtotop = true
integer weight = 700
boolean setcondcolor = true
string topdragobject = "dw_pagelist;st_move;dw_pagemaster"
string bottomdragobject = "dw_1"
end type

