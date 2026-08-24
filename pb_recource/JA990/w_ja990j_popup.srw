forward
global type w_ja990j_popup from w_response_s
end type
type cb_1 from pf_u_commandbutton within w_ja990j_popup
end type
type gb_1 from groupbox within w_ja990j_popup
end type
type dw_1 from u_dw within w_ja990j_popup
end type
end forward

global type w_ja990j_popup from w_response_s
integer x = 704
integer y = 536
integer width = 1787
integer height = 2948
string title = "휴일 생성"
event type boolean ue_tabpage_modified ( )
cb_1 cb_1
gb_1 gb_1
dw_1 dw_1
end type
global w_ja990j_popup w_ja990j_popup

type variables
STRING	is_nation_cd
end variables

event type boolean ue_tabpage_modified();RETURN FALSE
end event

on w_ja990j_popup.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.gb_1=create gb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_ja990j_popup.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.dw_1)
end on

event wue_postopen;call super::wue_postopen;is_nation_cd = Message.StringParm

DATETIME	ldt_f_value

dw_1.insertrow (0)

SELECT F_WORKDATE( :gaa.corp_gr, 0 )
  INTO :ldt_f_value
FROM   DUAL;
ldt_f_value = SQLCA.getitemdatetime (1)

dw_1.object.yyyy [1] = ldt_f_value

dw_view.SetTransObject (SQLCA)
dw_view.TriggerEvent ('ue_dddw_retrieve')

dw_1.bringtotop = TRUE
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_ja990j_popup
end type

type ln_tempstart from w_response_s`ln_tempstart within w_ja990j_popup
end type

type ln_templeft from w_response_s`ln_templeft within w_ja990j_popup
end type

type ln_cond_start from w_response_s`ln_cond_start within w_ja990j_popup
end type

type ln_tempright from w_response_s`ln_tempright within w_ja990j_popup
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_ja990j_popup
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_ja990j_popup
end type

type dw_view from w_response_s`dw_view within w_ja990j_popup
integer y = 284
integer width = 1687
integer height = 2544
integer taborder = 20
string dataobject = "d_ja990j_p1"
end type

event dw_view::ue_retrieve;call super::ue_retrieve;retrieve (is_nation_cd, string (dw_1.object.yyyy [1],'yyyy'))
end event

event dw_view::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'nation_cd', gaa.corp_gr, '', 1, '')
end event

type cb_1 from pf_u_commandbutton within w_ja990j_popup
integer x = 105
integer y = 100
integer width = 457
integer height = 92
integer taborder = 40
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "생성(&E)"
boolean default = true
end type

event clicked;LONG	lRowCount, lRow
DATE	dFr_ymd, dTo_ymd

dw_view.TriggerEvent ('ue_retrieve')

lRowCount = dw_view.rowcount ()

IF	is_nation_cd='KR'	Then
	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".01.01'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.01.01')))
		dw_view.SetItem (lRow, 'holi_nm', '신정')
	End IF

	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".03.01'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.03.01')))
		dw_view.SetItem (lRow, 'holi_nm', '삼일절')
	End IF

	//2006년부터 휴일제외 - 4.5 식목일

	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".05.01'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.05.01')))
		dw_view.SetItem (lRow, 'holi_nm', '근로자의날')
	End IF

	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".05.05'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.05.05')))
		dw_view.SetItem (lRow, 'holi_nm', '어린이날')
	End IF

	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".06.06'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.06.06')))
		dw_view.SetItem (lRow, 'holi_nm', '현충일')
	End IF

	// 2008년부터 휴일제외 - 7.17 제헌절
	// 2026년부터 휴일
	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".07.17'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.07.17')))
		dw_view.SetItem (lRow, 'holi_nm', '제헌절')
	End IF

	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".08.15'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.08.15')))
		dw_view.SetItem (lRow, 'holi_nm', '광복절')
	End IF

	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".10.03'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.10.03')))
		dw_view.SetItem (lRow, 'holi_nm', '개천절')
	End IF

	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".10.09'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
		dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.10.09')))
		dw_view.SetItem (lRow, 'holi_nm', '한글날')
	End IF
End IF

lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dw_1.object.yyyy [1], 'yyyy') + ".12.25'", 1, lRowCount)
IF lRow=0	Then
   lRow = dw_view.insertrow (0)
   dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
   dw_view.SetItem (lRow, 'holi_ymd', DateTime (Date (string (dw_1.object.yyyy [1], 'yyyy') + '.12.25')))
   dw_view.SetItem (lRow, 'holi_nm', '성탄절')
End IF

lRowCount = dw_view.rowcount ()

dFr_ymd = Date (string (dw_1.object.yyyy [1], 'yyyy') + '.01.01')
dTo_ymd = Date (string (dw_1.object.yyyy [1], 'yyyy') + '.12.31')

DO UNTIL String (dFr_ymd,'ddd')='Sat'
   dFr_ymd = RelativeDate (dFr_ymd, 1)
LOOP

DO UNTIL dTo_ymd<dFr_ymd
	// 2002.7.1부터 5일근무로 인한 토요휴무처리
	lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dFr_ymd,'yyyy.mm.dd') + "'", 1, lRowCount)
	IF lRow=0	Then
		lRow = dw_view.insertrow (0)
	   dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
		dw_view.SetItem (lRow, 'holi_ymd', DateTime (dFr_ymd))
		dw_view.SetItem (lRow, 'holi_nm',  '토요휴무')
	End IF

   dFr_ymd = RelativeDate (dFr_ymd, 1)
   lRow = dw_view.Find ("string(holi_ymd,'yyyy.mm.dd')='" + string (dFr_ymd,'yyyy.mm.dd') + "'", 1, lRowCount)
   IF lRow=0	Then
      lRow = dw_view.insertrow (0)
	   dw_view.SetItem (lRow, 'nation_cd', is_nation_cd)
      dw_view.SetItem (lRow, 'holi_ymd', DateTime (dFr_ymd))
      dw_view.SetItem (lRow, 'holi_nm',  '일요일')
   End IF
   dFr_ymd = RelativeDate (dFr_ymd, 6)
LOOP

IF dw_view.update ()<>1	tHEN
	rollbackJ ()
	RETURN
END IF
commitJ ()
end event

type gb_1 from groupbox within w_ja990j_popup
integer x = 50
integer y = 24
integer width = 1271
integer height = 220
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
boolean enabled = false
string text = "작업조건"
end type

type dw_1 from u_dw within w_ja990j_popup
integer x = 576
integer y = 60
integer width = 736
integer height = 172
integer taborder = 10
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_ja990j_p"
boolean border = false
end type

