forward
global type u_ja990a_t1 from utt_vertdetail
end type
type ole_rd from u_rd within u_ja990a_t1
end type
type cbx_1 from pf_u_checkbox within u_ja990a_t1
end type
end forward

global type u_ja990a_t1 from utt_vertdetail
string text = "회사별그룹코드"
ole_rd ole_rd
cbx_1 cbx_1
end type
global u_ja990a_t1 u_ja990a_t1

on u_ja990a_t1.create
int iCurrent
call super::create
this.ole_rd=create ole_rd
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_rd
this.Control[iCurrent+2]=this.cbx_1
end on

on u_ja990a_t1.destroy
call super::destroy
destroy(this.ole_rd)
destroy(this.cbx_1)
end on

type ln_temptop from utt_vertdetail`ln_temptop within u_ja990a_t1
end type

type ln_tempstart from utt_vertdetail`ln_tempstart within u_ja990a_t1
end type

type ln_templeft from utt_vertdetail`ln_templeft within u_ja990a_t1
end type

type ln_cond_start from utt_vertdetail`ln_cond_start within u_ja990a_t1
end type

type ln_tempright from utt_vertdetail`ln_tempright within u_ja990a_t1
end type

type ln_cond1_yline from utt_vertdetail`ln_cond1_yline within u_ja990a_t1
end type

type ln_dw1_yline from utt_vertdetail`ln_dw1_yline within u_ja990a_t1
end type

type ln_tempbutton from utt_vertdetail`ln_tempbutton within u_ja990a_t1
end type

type dw_pagelist from utt_vertdetail`dw_pagelist within u_ja990a_t1
string dataobject = "d_ja990a_t1a"
end type

event dw_pagelist::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow, lRowCount

CHOOSE CASE dwo.name
   CASE 'gr_cd'
      lRowCount = dw_pageDetail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_pageDetail.object.gr_cd [lRow] = data
      NEXT
END CHOOSE
end event

event dw_pagelist::ue_print;LONG	lRow

STRING	ls_gr_cd

IF	cbx_1.checked	Then
	ole_rd.eb_directprint = false
Else
	ole_rd.eb_directprint = true
End IF
IF uf_getrange () Then
   lRow = GetSelectedRow (0) ; ls_gr_cd = ''
   DO WHILE (lRow > 0)
      IF ls_gr_cd<>''   Then ls_gr_cd = ls_gr_cd + ","
      ls_gr_cd = ls_gr_cd + "'" + Object.gr_cd [lRow] + "'"
      lRow = GetSelectedRow (lRow)
   LOOP
   ole_rd.uf_fileopen ('rd_szx0gr_corp.mrd', "gr_cd[" + ls_gr_cd + "]")
	IF	cbx_1.checked THEN ole_rd.uf_pdf (gaa.pdf + '회사별그룹코드.pdf')
Else
   dw_pageDetail.TriggerEvent ('ue_print')
End IF
IF	cbx_1.checked THEN gnv_extfunc.of_shellexecute (gaa.pdf)
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;IF AncestorReturnVALUE=1 THEN RETURN 1

uf_setColumn ('corp_gr', '0000')
uf_setColumn ('sebu_cd', '.')

POST SetColumn ('gr_cd')

RETURN 0
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.name='sebu_cd_nm' THEN ::Clipboard (Object.sebu_cd_nm [row]+'{'+Object.gr_cd [row]+'}' )
end event

type dw_pagedetail from utt_vertdetail`dw_pagedetail within u_ja990a_t1
string dataobject = "d_ja990a_t1b"
string is_resize_column = "sebu_cd_enm"
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;retrieve (dw_pageList.object.gr_cd [tRow])
end event

event dw_pagedetail::ue_print;ole_rd.uf_fileopen ('rd_szx0gr_corp.mrd', "gr_cd['" + dw_pageList.object.gr_cd [tRow] + "']")
end event

event dw_pagedetail::ue_insertstart;call super::ue_insertstart;IF tRow=0 THEN RETURN 1
uf_setColumn ('corp_gr', gaa.corp_gr)
uf_setColumn ('gr_cd', dw_pageList.object.gr_cd [tRow])

POST SetColumn ('sebu_cd')

RETURN 0
end event

event dw_pagedetail::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'corp_gr', gaa.corp_gr, "", 1, "")
end event

event dw_pagedetail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

STRING	ls_corp_gr, ls_fund_nm

CHOOSE CASE dwo.name
   CASE 'corp_gr'
      FOR  ll = row + 1  TO  rowcount ()
         IF Object.corp_gr [ll]=dwo.primary [row] THEN Object.corp_gr [ll] = data
      NEXT
   CASE 'sebu_cd'
      IF dw_pageList.object.gr_cd [tRow]='MC'   Then
         ls_corp_gr = Object.corp_gr [row]

         SELECT  fund_nm
           INTO  :ls_fund_nm
         FROM    szm0ia t1
         WHERE   t1.corp_gr = :ls_corp_gr
           AND   t1.fund_cd = :data;
			
			ls_fund_nm = SQLCA.getitemstring (1)
			
         IF SQLCA.SQLCode()=0 THEN Object.sebu_cd_nm [row] = ls_fund_nm
      End IF
END CHOOSE
end event

type st_move from utt_vertdetail`st_move within u_ja990a_t1
boolean leftmaxsizefixed = true
string rightdragobject = "dw_pagedetail;cbx_1"
end type

type ole_rd from u_rd within u_ja990a_t1
boolean visible = false
integer x = 1993
integer y = 588
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string binarykey = "u_ja990a_t1.udo"
boolean eb_directprint = true
end type

type cbx_1 from pf_u_checkbox within u_ja990a_t1
integer x = 2011
integer y = 24
integer width = 457
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "PDF"
boolean setsheetcolor = true
end type

