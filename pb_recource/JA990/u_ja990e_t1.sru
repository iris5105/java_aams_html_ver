forward
global type u_ja990e_t1 from utt_vertdetail
end type
end forward

global type u_ja990e_t1 from utt_vertdetail
string text = "계정관리"
end type
global u_ja990e_t1 u_ja990e_t1

on u_ja990e_t1.create
call super::create
end on

on u_ja990e_t1.destroy
call super::destroy
end on

type ln_temptop from utt_vertdetail`ln_temptop within u_ja990e_t1
end type

type ln_tempstart from utt_vertdetail`ln_tempstart within u_ja990e_t1
end type

type ln_templeft from utt_vertdetail`ln_templeft within u_ja990e_t1
end type

type ln_cond_start from utt_vertdetail`ln_cond_start within u_ja990e_t1
end type

type ln_tempright from utt_vertdetail`ln_tempright within u_ja990e_t1
end type

type ln_cond1_yline from utt_vertdetail`ln_cond1_yline within u_ja990e_t1
end type

type ln_dw1_yline from utt_vertdetail`ln_dw1_yline within u_ja990e_t1
end type

type ln_tempbutton from utt_vertdetail`ln_tempbutton within u_ja990e_t1
end type

type dw_pagelist from utt_vertdetail`dw_pagelist within u_ja990e_t1
string dataobject = "d_ja990e_t1a"
boolean hscrollbar = true
string setlist4rowpointcolor = "inp_gb=2=a;inp_gb=3=a"
end type

event dw_pagelist::itemchanged;call super::itemchanged;LONG	lRowCount, lRow

CHOOSE CASE dwo.name
   CASE 'gwamok_fnm'
      Object.gwamok_nm [row] = data
   CASE 'gwamok'
      lRowCount = dw_pageDetail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_pageDetail.object.szx0gm_gwamok [lRow] = data
      NEXT
END CHOOSE
end event

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'gwamok_gb', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'tax_gb', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'inp_gb', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'gwamok_gg', gaa.corp_gr, ',,', 1, '')

end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('krw_format', '#,###')
uf_setcolumn ('num_format', '#,###.##')

POST SetColumn ('gwamok')

RETURN 0
end event

event dw_pagelist::updateend;call super::updateend;LONG	ll, ll_count

STRING	ls_old, ls_new

ll_count = rowcount ()
FOR  ll = 1  TO  ll_count
   IF GetItemStatus (ll, 'gwamok', Primary!)=DataModified!  Then
      ls_old = GetItemstring (ll, 'gwamok', Primary!, TRUE)
      ls_new = Object.gwamok [ll]

      // 판매사별 보수내역 코드변경
      UPDATE  skt5bg
         SET  gwamok = :ls_new
      WHERE   gwamok = :ls_old;

      // 보수율 코드변경
      UPDATE  szx0bz
         SET  gwamok = :ls_new
      WHERE   gwamok = :ls_old;

      // 계정 계산식 코드변경
      UPDATE  szx0cc
         SET  hab_gwamok = :ls_new
      WHERE   hab_gwamok = :ls_old;

      // 자가진단 점검 상대계정 코드변경
      UPDATE  szx0ck
         SET  gwamok = :ls_new
      WHERE   gwamok = :ls_old;

      // 거래코드별 분개유형 코드변경
      UPDATE  szx0ga
         SET  gwamok = :ls_new
      WHERE   gwamok = :ls_old;

      // 보고서별 계정과목 코드변경
      UPDATE  szx0we
         SET  gwamok = :ls_new
      WHERE   gwamok = :ls_old;
   End IF
NEXT
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'gwamok'
      STRING	ls_gwamok, ls_nm, ls1, ls2, ls3, ls_sqlsyntax

		LONG		lR, lj
		
		aDS_jTier	lds_jtier

      ls_gwamok = Object.gwamok [row]
      ls_nm = Object.gwamok_fnm [row]

      IF POS ('B0101,D0101,D0204,D0205,D0206',ls_gwamok)>0  Then
         IF f_messageBox ('RUN',ls_nm + ' 합산계정 재 생성')=2 THEN RETURN

         DO WHILE dw_pageDetail.rowcount ()>0
            dw_pageDetail.deleterow (0)
         LOOP

         // 비거주자과표 제외 20210201 yjs
         ls_sqlsyntax = " SELECT  gwamok " &
							 + "       , gwamok_gb " &
							 + "       , tax_gb " &
							 + " FROM    szx0gm t1 " &
							 + " WHERE   (gwamok_gb in ('4','5') OR gwamok Between 'A0201' And 'A0399') " &
							 + "   AND   gwamok != 'A0252' " &
							 + " ORDER BY  gwamok "

         lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

         FOR  lj = 1  TO  lR
				ls1 = lds_jtier.getitemString (lj, 1)
				ls2 = lds_jtier.getitemString (lj, 2)
				ls3 = lds_jtier.getitemString (lj, 3)

            IF POS ('B0101,D0101',ls_gwamok)>0 And ls2='9' And (ls3='1' OR ls3='2') Then
               IF POS ('A0251,A02C4',ls1)=0  Then
                  dw_pageDetail.EVENT ue_insert (1)
                  dw_pageDetail.object.gwamok [1] = ls1
                  dw_pageDetail.object.yonsan [1] = 1
               End IF
            ElseIF (POS ('D0204,D0206',ls_gwamok)>0 And ls3='1') OR (ls_gwamok='D0205' And ls3='2')   Then
               dw_pageDetail.EVENT ue_insert (1)
               dw_pageDetail.object.gwamok [1] = ls1
               dw_pageDetail.object.yonsan [1] = IIF (ls2='4',-1,1)
            End IF
         NEXT
			
         IF POS ('B0101,D0101',ls_gwamok)>0  Then
            dw_pageDetail.EVENT ue_insert (1)
            dw_pageDetail.object.gwamok [1] = '10000'
            dw_pageDetail.object.yonsan [1] = 1
            dw_pageDetail.EVENT ue_insert (1)
            dw_pageDetail.object.gwamok [1] = '20000'
            dw_pageDetail.object.yonsan [1] = -1
         ElseIF ls_gwamok='D0205'   Then   // 총액 - 과표 계정들
            // 집합투자증권 평가손익은 총액으로 해당없음으로 등록되어 있으므로
//            dw_pageDetail.EVENT ue_insert (1)
//            dw_pageDetail.object.gwamok [1] = 'A0208'
//            dw_pageDetail.object.yonsan [1] = 1
            dw_pageDetail.EVENT ue_insert (1)
            dw_pageDetail.object.gwamok [1] = 'A0251'
            dw_pageDetail.object.yonsan [1] = -1
            dw_pageDetail.EVENT ue_insert (1)
            dw_pageDetail.object.gwamok [1] = 'A02C4'
            dw_pageDetail.object.yonsan [1] = -1
         Else
            IF ls_gwamok='D0206' Then
               dw_pageDetail.EVENT ue_insert (1)
               dw_pageDetail.object.gwamok [1] = 'D0211'
               dw_pageDetail.object.yonsan [1] = 1
            End IF
         End IF

      ElseIF ls_gwamok='B0421'   Then
         IF f_messageBox ('RUN',ls_nm + ' 합산계정 재 생성')=2 THEN RETURN

         DO WHILE dw_pageDetail.rowcount ()>0
            dw_pageDetail.deleterow (0)
         LOOP

         ls_sqlsyntax = " SELECT  gwamok " &
							 + "       , gwamok_gb " &
							 + " FROM    szx0gm t1 " &
							 + " WHERE   SUBSTR(gwamok,1,3) in ( select SUBSTR (hab_gwamok,1,3) " &
							 + "                                   from szx0cc t1 " &
							 + "                                 where  gwamok = 'B0411' ) " &
							 + "   AND   tax_gb             = '1' " &
							 + " ORDER BY  gwamok "

         lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

         FOR  lj = 1  TO  lR
				ls1 = lds_jtier.getitemString (lj, 1)
				ls2 = lds_jtier.getitemString (lj, 2)			

            dw_pageDetail.EVENT ue_insert (1)
            IF ls2='4'  Then
               dw_pageDetail.object.gwamok [1] = ls1
               dw_pageDetail.object.yonsan [1] = -1
            Else
               dw_pageDetail.object.gwamok [1] = ls1
               dw_pageDetail.object.yonsan [1] = 1
            End IF
         NEXT

      ElseIF ls_gwamok='B0422'   Then
         IF f_messageBox ('RUN',ls_nm + ' 합산계정 재 생성')=2 THEN RETURN

         DO WHILE dw_pageDetail.rowcount ()>0
            dw_pageDetail.deleterow (0)
         LOOP

         ls_sqlsyntax = " SELECT  gwamok " &
							 + "       , gwamok_gb " &
							 + " FROM    szx0gm t1 " &
							 + " WHERE   REGEXP_LIKE (gwamok, '[5|6][9]') " &
							 + "   AND   tax_gb      = '1' " &
							 + " ORDER BY  gwamok "

         lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

         FOR  lj = 1  TO  lR
				ls1 = lds_jtier.getitemString (lj, 1)
				ls2 = lds_jtier.getitemString (lj, 2)

            dw_pageDetail.EVENT ue_insert (1)
            IF ls2='4'  Then
               dw_pageDetail.object.gwamok [1] = ls1
               dw_pageDetail.object.yonsan [1] = -1
            Else
               dw_pageDetail.object.gwamok [1] = ls1
               dw_pageDetail.object.yonsan [1] = 1
            End IF
         NEXT

         ls_sqlsyntax = " SELECT  gwamok " &
							 + " FROM    szx0gm t1 " &
							 + " WHERE   gwamok IN ( select hab_gwamok " &
							 + "                       from szx0cc t1 " &
							 + "                     where  gwamok IN ('90102','90103') ) " &
							 + "   AND   tax_gb = '1' " &
							 + " ORDER BY  gwamok "

         lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

         FOR  lj = 1  TO  lR
				ls1 = lds_jtier.getitemString (lj, 1)

            dw_pageDetail.EVENT ue_insert (1)
            dw_pageDetail.object.gwamok [1] = ls1
            dw_pageDetail.object.yonsan [1] = 1
        	NEXT
			
      End IF
   CASE 'gwamok_fnm','gwamok_enm','gwamok_nm'
      str_parameter  sp

      sp.dt [1] = iu_wpage.idt_workdate

      sp.str [1] = gaa.fund_cd
      sp.str [2] = Object.gwamok [row]
      sp.str [3] = Object.gwamok_nm [row]
      sp.str [4] = gaa.corp_gr

      OpenwithParm (w_ja050_popup, sp)
END CHOOSE
end event

event dw_pagelist::constructor;call super::constructor;Modify ("datawindow.grid.columnmove=yes")
end event

type dw_pagedetail from utt_vertdetail`dw_pagedetail within u_ja990e_t1
string dataobject = "d_ja990e_t1b"
boolean hscrollbar = false
end type

event dw_pagedetail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('szx0gm_gwamok', dw_pageList.object.gwamok [tRow])
IF rowcount ()=0  Then
   uf_setcolumn ('yonsan', '1')
Else
   uf_setcolumn ('yonsan', string (Object.yonsan [getrow ()]))
End IF

POST SetColumn ('gwamok')

RETURN 0
end event

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;retrieve (dw_pageList.object.gwamok [tRow] )
end event

event dw_pagedetail::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'gwamok'
      IF dw_pageList.object.gwamok_gb [tRow]='9'   Then
         RETURN 9
      Else
         rs_where = "(gwamok like substr('" + dw_pageList.object.gwamok [tRow] + "',1,2) || '%' OR gwamok = substr('" + dw_pageList.object.gwamok [tRow] + "',1,1) || '0000')"
         RETURN 8
      End IF
      RETURN 9
END CHOOSE
RETURN 1
end event

type st_move from utt_vertdetail`st_move within u_ja990e_t1
boolean rightmaxsizefixed = true
end type

