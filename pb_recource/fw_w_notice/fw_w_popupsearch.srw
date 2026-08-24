forward
global type fw_w_popupsearch from w_response1st
end type
type p_close from pf_u_imagebutton within fw_w_popupsearch
end type
type p_select from pf_u_imagebutton within fw_w_popupsearch
end type
type p_search from pf_u_imagebutton within fw_w_popupsearch
end type
type dw_list from fw_u_dwo within fw_w_popupsearch
end type
type dw_cond from fw_u_dwo within fw_w_popupsearch
end type
end forward

global type fw_w_popupsearch from w_response1st
integer width = 2391
integer height = 2080
p_close p_close
p_select p_select
p_search p_search
dw_list dw_list
dw_cond dw_cond
end type
global fw_w_popupsearch fw_w_popupsearch

type variables
fw_s_popupsearch istr_search

end variables

on fw_w_popupsearch.create
int iCurrent
call super::create
this.p_close=create p_close
this.p_select=create p_select
this.p_search=create p_search
this.dw_list=create dw_list
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_close
this.Control[iCurrent+2]=this.p_select
this.Control[iCurrent+3]=this.p_search
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.dw_cond
end on

on fw_w_popupsearch.destroy
call super::destroy
destroy(this.p_close)
destroy(this.p_select)
destroy(this.p_search)
destroy(this.dw_list)
destroy(this.dw_cond)
end on

event open;call super::open;// get parameter
istr_search = message.powerobjectparm
if not isvalid(istr_search) then
	messagebox('Notice', '잘못된 윈도우 호출입니다')
	close(this)
	return
end if

end event

event wue_postopen;call super::wue_postopen;// 윈도우 타이틀 설정
this.title = istr_search.window_title

// 조회조건용 DataObject와 TransactionObject 를 설정 합니다
//dw_cond.defaultvaluesoninsertrow = istr_search.condition_defaultvalues
//dw_cond.of_setdataobject(istr_search.condition_dwobject)
//if isvalid(istr_search.transaction_object) then
//	dw_cond.settransobject(istr_search.transaction_object)
//end if

//// 리스트용 DataObject와 TransactionObject 를 설정 합니다
//dw_list.retrievalarguments = istr_search.list_arguments
//dw_list.of_setdataobject(istr_search.list_dwobject)
//if isvalid(istr_search.transaction_object) then
//	dw_list.settransobject(istr_search.transaction_object)
//end if

// 데이터 조회 시작
if istr_search.auto_retrieve = true then
	p_search.event clicked()
end if

// SetFocus
dw_cond.setfocus()
dw_cond.setcolumn(1)

// 데이터가 한 건 조회된 경우 자동 선택 & 리턴 합니다
if dw_list.rowcount() = 1 then
	p_select.event clicked()
end if

end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_popupsearch
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_popupsearch
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_popupsearch
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_popupsearch
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_popupsearch
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_popupsearch
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_popupsearch
end type

type p_close from pf_u_imagebutton within fw_w_popupsearch
integer x = 2117
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;istr_search.data_selected = false
closewithreturn(parent, istr_search)

end event

type p_select from pf_u_imagebutton within fw_w_popupsearch
integer x = 1879
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_select.jpg"
string referencedobject = "parent"
string onclickcallevent = "ue_selected"
end type

event clicked;call super::clicked;long ll_row

if not isvalid(istr_search) then return

ll_row = dw_list.getrow()
if ll_row = 0 then
	messagebox('Notice', '선택할 수 있는 자료가 없습니다')
	return
end if

integer i, li_itemcnt

li_itemcnt = upperbound(istr_search.getitem_column)
if li_itemcnt = 0 then
	messagebox('Notice', '값을 구해올 컬럼명을 pf_s_popupsearch.getitem_column[] 멤버변수에 추가하세요')
	return
end if

for i = 1 to li_itemcnt
	choose case left(dw_list.describe(istr_search.getitem_column[i] + ".ColType"), 5)
		case '!', '?'
			messagebox('Notice', '[' + istr_search.getitem_column[i] + '] 컬럼명을 찾을 수 없습니다')
			return
		case 'char('
			istr_search.column_value[i] = dw_list.getitemstring(ll_row, istr_search.getitem_column[i])
		case 'date'
			istr_search.column_value[i] = string(dw_list.getitemdate(ll_row, istr_search.getitem_column[i]), 'YYYYMMDD')
		case 'time'
			istr_search.column_value[i] = string(dw_list.getitemtime(ll_row, istr_search.getitem_column[i]), 'hhmmss')
		case 'datet', 'times'
			istr_search.column_value[i] = string(dw_list.getitemdatetime(ll_row, istr_search.getitem_column[i]), 'YYYYMMDDhhmmss')
		case 'decim'
			istr_search.column_value[i] = string(dw_list.getitemdecimal(ll_row, istr_search.getitem_column[i]))
		case 'int', 'long', 'numbe', 'real', 'ulong'
			istr_search.column_value[i] = string(dw_list.getitemnumber(ll_row, istr_search.getitem_column[i]))
	end choose
next

istr_search.data_selected = true
closewithreturn(parent, istr_search)

end event

type p_search from pf_u_imagebutton within fw_w_popupsearch
integer x = 1641
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_lookup.jpg"
string referencedobject = "dw_list"
string datawindowaction = "retrieve"
end type

type dw_list from fw_u_dwo within fw_w_popupsearch
integer x = 50
integer y = 340
integer width = 2295
integer height = 1620
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;if row > 0 then
	p_select.event clicked()
end if

end event

type dw_cond from fw_u_dwo within fw_w_popupsearch
integer x = 50
integer y = 156
integer width = 2295
integer height = 156
integer taborder = 10
boolean bringtotop = true
boolean livescroll = false
boolean ibdesign4cond = true
end type

