forward
global type w_ja032d from wt_listdetail
end type
type cb_cre from pf_u_commandbutton within w_ja032d
end type
type dw_status from u_dw within w_ja032d
end type
type st_1 from pf_u_splitbar_vertical within w_ja032d
end type
type dw_data from u_dw within w_ja032d
end type
type cb_kse from pf_u_commandbutton within w_ja032d
end type
type cb_1302 from pf_u_commandbutton within w_ja032d
end type
type cb_1716 from pf_u_commandbutton within w_ja032d
end type
type cb_all from pf_u_commandbutton within w_ja032d
end type
end forward

global type w_ja032d from wt_listdetail
boolean eb_rowchangewait = true
boolean eb_direct_retrieve = true
string is_date_nation = "US"
boolean ib_managedata = false
cb_cre cb_cre
dw_status dw_status
st_1 st_1
dw_data dw_data
cb_kse cb_kse
cb_1302 cb_1302
cb_1716 cb_1716
cb_all cb_all
end type
global w_ja032d w_ja032d

type variables
ads_jtier	ids

STRING	is_table, is_company, is_snm

LONG	il_ds, il_data
end variables

forward prototypes
public subroutine wf_data (long row)
end prototypes

public subroutine wf_data (long row);LONG	ll

ANY	la_data []

dw_status.object.cur_row [1] = row
dw_status.object.all_row [1] = il_ds
IF	il_ds=0 THEN RETURN

la_data = ids.object.data [row]
FOR  ll = 1  TO  il_data
	dw_data.object.col_val [ll] = string (la_data [ll])
NEXT
end subroutine

on w_ja032d.create
int iCurrent
call super::create
this.cb_cre=create cb_cre
this.dw_status=create dw_status
this.st_1=create st_1
this.dw_data=create dw_data
this.cb_kse=create cb_kse
this.cb_1302=create cb_1302
this.cb_1716=create cb_1716
this.cb_all=create cb_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cre
this.Control[iCurrent+2]=this.dw_status
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_data
this.Control[iCurrent+5]=this.cb_kse
this.Control[iCurrent+6]=this.cb_1302
this.Control[iCurrent+7]=this.cb_1716
this.Control[iCurrent+8]=this.cb_all
end on

on w_ja032d.destroy
call super::destroy
destroy(this.cb_cre)
destroy(this.dw_status)
destroy(this.st_1)
destroy(this.dw_data)
destroy(this.cb_kse)
destroy(this.cb_1302)
destroy(this.cb_1716)
destroy(this.cb_all)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate

DATETIME ldt_ymd

SELECT F_OPEN_YMD (now ( ),'-1') INTO :ldt_ymd FROM DUAL;

ldt_ymd = SQLCA.GETITEMDATETIME (1)

cb_cre.enabled = (idt_workdate = ldt_ymd)

cb_kse.VISIBLE  = gaa.admin
cb_1302.VISIBLE = gaa.admin
cb_1716.VISIBLE = gaa.admin
cb_all.VISIBLE  = gaa.admin
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (dw_c.object.ymd [1])
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja032d
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja032d
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja032d
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja032d
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja032d
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja032d
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja032d
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja032d
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja032d
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja032d
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja032d
end type

type uo_navi from wt_listdetail`uo_navi within w_ja032d
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja032d
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja032d
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja032d
end type

type p_close from wt_listdetail`p_close within w_ja032d
end type

type p_excel from wt_listdetail`p_excel within w_ja032d
end type

type p_print from wt_listdetail`p_print within w_ja032d
end type

type p_delete from wt_listdetail`p_delete within w_ja032d
end type

type p_update from wt_listdetail`p_update within w_ja032d
end type

type p_input from wt_listdetail`p_input within w_ja032d
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja032d
end type

event p_retrieve::clicked;IF	iRow>0	Then
	is_company = dw_list.object.company [iRow]
	is_snm     = dw_list.object.snm [iRow]
End IF
call super::clicked
end event

type p_clear from wt_listdetail`p_clear within w_ja032d
end type

type p_copy from wt_listdetail`p_copy within w_ja032d
end type

type dw_c from wt_listdetail`dw_c within w_ja032d
string title = "요청일자"
string dataobject = "dc_ymd"
end type

event dw_c::itemchanged;call super::itemchanged;DATETIME	ldt_us_ymd, ldt_ymd

SELECT f_open_us (now (),'-1')
     , f_open_ymd (now (),'-')
  INTO :ldt_us_ymd
     , :ldt_ymd
  FROM DUAL ;

ldt_us_ymd = SQLCA.GETITEMDATETIME (1)
ldt_ymd    = SQLCA.GETITEMDATETIME (2)

IF DWO.NAME='ymd' Then
   cb_cre.enabled = (DATETIME (DATE (MID (data,1,10)))=ldt_us_ymd)
   cb_kse.enabled = (DATETIME (DATE (MID (data,1,10)))=ldt_ymd)
END IF
end event

type btn_update from wt_listdetail`btn_update within w_ja032d
end type

type st_count from wt_listdetail`st_count within w_ja032d
end type

type dw_list from wt_listdetail`dw_list within w_ja032d
integer width = 3131
string dataobject = "d_ja032d1"
boolean scaletoright = false
boolean eb_null_line = false
end type

event dw_list::retrieveend;IF	f_notnull (is_company) THEN is_find = "company='" + is_company + "' and snm='" + is_snm + "'"
call super::retrieveend
end event

event dw_list::ue_protect;call super::ue_protect; uf_protect (row, ia_protect [1])
end event

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;IF	Object.subtable [currentrow]>''	Then
	f_dddwctl (THIS, 'qtable | dual', '', Object.subtable [currentrow] + ','  + Object.subtable [currentrow] + ',,'  + Object.tablename [currentrow] + ',' + Object.tablename [currentrow] + ",", 1, "")
Else
	f_dddwctl (THIS, 'qtable | dual', '', Object.tablename [currentrow] + ',' + Object.tablename [currentrow] + ",", 1, "")
End IF
RETURN 0
end event

event dw_list::itemchanged_next;call super::itemchanged_next;IF	name='qtable'	Then
	dw_detail.setredraw (false)
	dw_detail.uf_reset ()
	dw_detail.event ue_retrieve ()
	dw_detail.setredraw (true)
	uf_enabled (eb_rowchangewait, true)
End IF
end event

type dw_detail from wt_listdetail`dw_detail within w_ja032d
integer y = 1472
integer width = 3131
integer height = 1292
string dataobject = "d_ja032d2"
boolean scaletoright = false
string islist4subbtnauth = "0010001001"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.company [iRow], dw_list.object.url [iRow], dw_list.object.dt [iRow])
end event

event dw_detail::rowfocuschanged_if;call super::rowfocuschanged_if;LONG	lr

lr = currentrow
is_table = dw_list.object.qtable [iRow]

STRING	ls_select

LONG	ll

dw_status.retrieve (Object.api_key [lr])
il_data = dw_data.retrieve (is_table)
IF	il_data=0 THEN RETURN 0

ls_select = 'select '
FOR  ll = 1  TO  il_data
	IF	ll=1	Then
		ls_select += dw_data.object.column_name [ll]
	Else
		ls_select += ', ' + dw_data.object.column_name [ll]
	End IF
NEXT
ls_select += " from " + is_table + " where api_key='" + Object.api_key [lr] + "'"

dw_status.object.api_key [1] = Object.api_key [lr]

il_ds = SQLCA.sql2ds (parent.classname(), ls_Select, ids, 'xml')
IF il_ds < 0 THEN
   messagebox ("sqlselect error==>", SQLCA.sqlErrText())
   RETURN 1
ElseIF il_ds<2	Then
	dw_status.of_dw2subbtn ({'p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
Else
	dw_status.of_dw2subbtn ({'p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
END IF
dw_status.of_dw2subbtn ({'p_excel'}, true)
wf_data (1)

RETURN 0
end event

type st_move from wt_listdetail`st_move within w_ja032d
integer width = 3141
boolean scaletoright = false
end type

type cb_cre from pf_u_commandbutton within w_ja032d
integer x = 1339
integer y = 192
integer width = 457
integer taborder = 110
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "한투파생시가"
unsignedlong mouseoverfontcolor = 65535
end type

event clicked;STRING	la_args [], w_msg = SPACE (200)

la_args [1] = gaa.CORP_GR
la_args [2] = STRING (dw_c.object.ymd[1], 'yyyymmdd')
la_args [3] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'SR_JA032D ( ?, ?, ? )', la_args[], w_msg)

w_msg = f_nvl (SQLCA.GETITEMPLSQL (1), 'N')

F_MESSAGEBOX ('SP00', w_msg + ' 요청완료!!!')
end event

type dw_status from u_dw within w_ja032d
integer x = 3218
integer y = 348
integer width = 2213
integer height = 468
integer taborder = 40
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_ja032d3"
boolean scaletoright = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0010001111"
end type

event oue_subbtn_nextpage;call super::oue_subbtn_nextpage;IF	Object.cur_row [1]<il_ds THEN wf_data (dec (Object.cur_row [1]) + 1)
end event

event oue_subbtn_priorpage;call super::oue_subbtn_priorpage;IF	Object.cur_row [1]>1 THEN wf_data (dec (Object.cur_row [1]) - 1)
end event

event oue_subbtn_lastpage;call super::oue_subbtn_lastpage;wf_data (il_ds)
end event

event oue_subbtn_firstpage;call super::oue_subbtn_firstpage;wf_data (1)
end event

event oue_subbtn_excel;STRING	ls_seq

SELECT '(' || f_n0 (seqval ('excel_seq'),3) || ')' INTO :ls_seq FROM DUAL;

ls_seq = SQLCA.GETITEMSTRING (1)

f_xlsx (dw_data, '__' + dw_data.dataobject + ls_seq, dw_data.dataobject, '', '', '', '')
end event

type st_1 from pf_u_splitbar_vertical within w_ja032d
integer x = 3191
integer y = 348
integer height = 2416
boolean bringtotop = true
boolean setcondcolor = true
boolean leftmaxsizefixed = true
string leftdragobject = "dw_list;st_move;dw_detail"
string rightdragobject = "dw_status;dw_data"
end type

event constructor;call super::constructor;IF	dw_detail.zoominout THEN ii_rightmargin += PixelsToUnits(12, XPixelsToUnits!)
end event

type dw_data from u_dw within w_ja032d
integer x = 3218
integer y = 832
integer width = 2213
integer height = 1932
integer taborder = 20
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_ja032d4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
string is_resize_column = "col_val"
end type

event doubleclicked;call super::doubleclicked;IF dwo.name='comments' THEN f_gr_cd (gaa.corp_gr, Object.comments [row])
end event

type cb_kse from pf_u_commandbutton within w_ja032d
boolean visible = false
integer x = 2263
integer y = 192
integer width = 457
integer taborder = 120
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "국내주식요청"
unsignedlong mouseoverfontcolor = 65535
end type

event clicked;//f_messagebox ('INFO', '월요인 경우는 종목정보 요청')

STRING	la_args [], w_msg = SPACE (200)

la_args [1] = gaa.CORP_GR
la_args [2] = f_sysdate_str ('yyyymmdd')
la_args [3] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'API_KSE ( ?, ?, ? )', la_args[], w_msg)

w_msg = f_nvl (SQLCA.GETITEMPLSQL (1), 'N')

F_MESSAGEBOX ('SP00', w_msg + ' 요청완료!!!')
end event

type cb_1302 from pf_u_commandbutton within w_ja032d
boolean visible = false
integer x = 2725
integer y = 192
integer width = 457
integer taborder = 120
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "해외주식신규"
unsignedlong mouseoverfontcolor = 65535
end type

event clicked;STRING	la_args [], w_msg = SPACE (200)

la_args [1] = gaa.CORP_GR
la_args [2] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'API_13_02 ( ?, ? )', la_args[], w_msg)

w_msg = f_nvl (SQLCA.GETITEMPLSQL (1), 'N')

F_MESSAGEBOX ('SP00', w_msg + ' 요청완료!!!')
end event

type cb_1716 from pf_u_commandbutton within w_ja032d
boolean visible = false
integer x = 1801
integer y = 192
integer width = 457
integer taborder = 120
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "한투파생종가"
unsignedlong mouseoverfontcolor = 65535
end type

event clicked;STRING	la_args [], w_msg = SPACE (200)

la_args [1] = gaa.CORP_GR
la_args [2] = STRING (dw_c.object.ymd[1], 'yyyymmdd')
la_args [3] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'API_17_16 ( ?, ?, ? )', la_args[], w_msg)

w_msg = f_nvl (SQLCA.GETITEMPLSQL (1), 'N')

F_MESSAGEBOX ('SP00', w_msg + ' 요청완료!!!')
end event

type cb_all from pf_u_commandbutton within w_ja032d
boolean visible = false
integer x = 3186
integer y = 192
integer width = 457
integer taborder = 130
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "해외일괄재신청"
unsignedlong mouseoverfontcolor = 65535
end type

event clicked;STRING	la_args [], w_msg = SPACE (200)

la_args [1] = gaa.CORP_GR
la_args [2] = STRING (dw_c.object.ymd[1], 'yyyymmdd')
la_args [3] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'NEW_13_02 ( ?, ?, ? )', la_args[], w_msg)

w_msg = f_nvl (SQLCA.GETITEMPLSQL (1), 'N')

F_MESSAGEBOX ('SP00', w_msg + ' 요청완료!!!')
end event

