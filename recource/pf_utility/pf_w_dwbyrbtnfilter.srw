forward
global type pf_w_dwbyrbtnfilter from window
end type
type p_delete from pf_u_imagebutton within pf_w_dwbyrbtnfilter
end type
type p_close from pf_u_imagebutton within pf_w_dwbyrbtnfilter
end type
type p_ok from pf_u_imagebutton within pf_w_dwbyrbtnfilter
end type
type p_add from pf_u_imagebutton within pf_w_dwbyrbtnfilter
end type
type dw_criteria from fw_u_dwo within pf_w_dwbyrbtnfilter
end type
type dw_child from fw_u_dwo within pf_w_dwbyrbtnfilter
end type
end forward

global type pf_w_dwbyrbtnfilter from window
integer width = 2039
integer height = 708
windowtype windowtype = response!
event pfe_postopen ( )
p_delete p_delete
p_close p_close
p_ok p_ok
p_add p_add
dw_criteria dw_criteria
dw_child dw_child
end type
global pf_w_dwbyrbtnfilter pf_w_dwbyrbtnfilter

type variables
fw_u_dwo		idw_target
fw_s_parent		istr_parent

long				il_normal_height
long				il_extended_height

end variables

event pfe_postopen();String		ls_column, ls_dropdownlist, ls_text
Long		ll_cnter, ll_columncnt, nInsRow,ll_pos

ll_columncnt = long(idw_target.describe('DataWindow.Column.Count'))
if ll_columncnt < 1 then return

for ll_cnter = 1 to ll_columncnt
	ls_column = idw_target.Describe('#' + String(ll_cnter) + '.Name')
	ls_text = idw_target.Describe(ls_column + "_t.Text")
	if ls_text = '!' or ls_text = '?' or ls_text = '' then continue
	
	ls_text = fw_f_replaceall(ls_text, '~r', '')
	ls_text = fw_f_replaceall(ls_text, '~n', '')
	ls_text = fw_f_replaceall(ls_text, '"', '')
	ls_text = fw_f_replaceall(ls_text, '~~', '')
		
	ls_dropdownlist += ls_text + '~t' + ls_column + '/'
next

dw_criteria.modify("Column_Name.Values='" + ls_dropdownlist + "'")
dw_criteria.insertrow(0)

end event

on pf_w_dwbyrbtnfilter.create
this.p_delete=create p_delete
this.p_close=create p_close
this.p_ok=create p_ok
this.p_add=create p_add
this.dw_criteria=create dw_criteria
this.dw_child=create dw_child
this.Control[]={this.p_delete,&
this.p_close,&
this.p_ok,&
this.p_add,&
this.dw_criteria,&
this.dw_child}
end on

on pf_w_dwbyrbtnfilter.destroy
destroy(this.p_delete)
destroy(this.p_close)
destroy(this.p_ok)
destroy(this.p_add)
destroy(this.dw_criteria)
destroy(this.dw_child)
end on

event open;istr_parent = message.powerobjectparm

If not isvalid(istr_parent) Then
	messagebox('Notice(pf_w_popmenufilter)', 'There is no parameter variable value.')
	Close(this)
	Return
End If
idw_target = istr_parent.dw_obj

il_normal_height = this.height
il_extended_height = il_normal_height + PixelsToUnits(230, YPixelsToUnits!)

fw_f_getiehandlebyposition(This)

Post Event pfe_postopen()
end event

type p_delete from pf_u_imagebutton within pf_w_dwbyrbtnfilter
integer x = 265
integer y = 576
integer width = 229
integer height = 96
integer taborder = 40
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_delete.jpg"
end type

event clicked;call super::clicked;long ll_row

dw_criteria.deleterow(0)
ll_row = dw_criteria.getrow()
if ll_row > 0 then
	dw_criteria.scrolltorow(ll_row)
end if

dw_child.reset()
parent.height = il_normal_height

end event

type p_close from pf_u_imagebutton within pf_w_dwbyrbtnfilter
integer x = 1751
integer y = 576
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;Close(Parent)
end event

type p_ok from pf_u_imagebutton within pf_w_dwbyrbtnfilter
integer x = 1513
integer y = 576
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

event clicked;call super::clicked;long ll_row, ll_rowcnt
string ls_column, ls_operator, ls_value, ls_join
string ls_coltype, ls_filter

if dw_criteria.accepttext() = -1 then return

ll_rowcnt = dw_criteria.rowcount()
for ll_row = 1 to ll_rowcnt
	ls_column = dw_criteria.getitemstring(ll_row, 'column_name')
	if pf_f_isemptystring(ls_column) then continue

	ls_operator = dw_criteria.getitemstring(ll_row, 'operator')
	if pf_f_isemptystring(ls_operator) then continue
	
	ls_value = dw_criteria.getitemstring(ll_row, 'value')
	if pf_f_isemptystring(ls_value) then continue
	
	// make filter criteria
	if len(ls_filter) > 0 then
		ls_filter += '~r~n' + ls_join + ' '
	end if
	
	ls_coltype = idw_target.describe(ls_column + ".ColType")
	choose case ls_coltype
		case 'date'
			ls_filter += 'string(' + ls_column + ', ~'yyyy.mm.dd~')'
			ls_value = '~'' + ls_value + '~''
		case 'datetime', 'timestamp'
			ls_filter += 'string(' + ls_column + ', ~'yyyy.mm.dd hh:mm:ss~')'
			ls_value = '~'' + ls_value + '~''
		case 'time'
			ls_filter += 'string(' + ls_column + ', ~'hh:mm:ss~')'
			ls_value = '~'' + ls_value + '~''
		case 'number'
			ls_filter += ls_column
			ls_value = ls_value
		case else
			ls_filter += ls_column
			if ls_operator = 'like' and pos(ls_value, '%') = 0 then
				ls_value = '~'%' + ls_value + '%~''
			else
				ls_value = '~'' + ls_value + '~''
			end if
	end choose
	
	ls_filter += ' ' + ls_operator + ' ' + ls_value
	ls_join =  dw_criteria.getitemstring(ll_row, 'join')
next

// Reset Filter
idw_target.setfilter('')
idw_target.filter()

// Set Filter
if idw_target.setfilter(ls_filter) = 1 then
	idw_target.filter()
	idw_target.groupcalc()
	if idw_target.rowcount() = 0 then
		messagebox('Check', 'No data found.')
		idw_target.setfilter('')
		idw_target.filter()
	end if
end if

close(parent)
end event

type p_add from pf_u_imagebutton within pf_w_dwbyrbtnfilter
integer x = 27
integer y = 576
integer width = 229
integer height = 96
integer taborder = 40
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_add.jpg"
end type

event clicked;call super::clicked;long ll_newrow

ll_newrow = dw_criteria.insertrow(0)
dw_criteria.scrolltorow(ll_newrow)
dw_criteria.setrow(ll_newrow)

dw_child.reset()
parent.height = il_normal_height

end event

type dw_criteria from fw_u_dwo within pf_w_dwbyrbtnfilter
integer x = 27
integer y = 28
integer width = 1961
integer height = 528
string dataobject = "pf_d_dwbyrbtnfilter"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;this.setrow(row)

end event

event rowfocuschanged;this.event itemchanged(currentrow, this.object.column_name, this.getitemstring(currentrow, 'column_name'))

end event

event itemchanged;choose case dwo.name
	case 'column_name'
		string ls_dataobject, ls_datacolumn, ls_dispcolumn, ls_values
		string ls_rows[], ls_items[]
		long ll_cnter, ll_rowcnt, ll_newrow
		datawindowchild ldwc_dddw
		
		choose case idw_target.describe(data + ".Edit.Style")
			case 'dddw'
				if idw_target.getchild(string(data), ldwc_dddw) = -1 then return 0
				
				ls_dataobject = idw_target.describe(data + ".DDDW.Name")
				if ls_dataobject = '!' or ls_dataobject = '?' or ls_dataobject = '' then return 0
				
				ls_datacolumn = idw_target.describe(data + ".DDDW.DataColumn")
				if ls_datacolumn = '!' or ls_datacolumn = '?' or ls_datacolumn = '' then return 0
				
				ls_dispcolumn = idw_target.describe(data + ".DDDW.DisplayColumn")
				if ls_dispcolumn = '!' or ls_dispcolumn = '?' or ls_dispcolumn = '' then return 0
				
				dw_child.dataobject = ls_dataobject
				ldwc_dddw.rowscopy(1, ldwc_dddw.rowcount(), primary!, dw_child, 1, primary!)
				parent.height = il_extended_height
				
			case 'ddlb', 'radiobuttons'
				ls_values = idw_target.describe(string(data) + ".Values")
				ll_rowcnt = fw_f_obj2array(ls_values, '/', ls_rows[])
				dw_child.dataobject = 'pf_d_popmenufilter_ddlb'
				for ll_cnter = 1 to ll_rowcnt
					if fw_f_obj2array(ls_rows[ll_cnter], '~t', ls_items) >= 2 then
						ll_newrow = dw_child.insertrow(0)
						dw_child.setitem(ll_newrow, 'dispvalue', ls_items[1])
						dw_child.setitem(ll_newrow, 'datavalue', ls_items[2])
					end if
				next
				parent.height = il_extended_height
				
			case 'checkbox'
				dw_child.dataobject = 'pf_d_popmenufilter_ddlb'
				
				ll_newrow = dw_child.insertrow(0)
				dw_child.setitem(ll_newrow, 'datavalue', idw_target.describe(string(data) + ".CheckBox.On"))
				dw_child.setitem(ll_newrow, 'dispvalue', 'DataValue for On')
				
				ll_newrow = dw_child.insertrow(0)
				dw_child.setitem(ll_newrow, 'datavalue', idw_target.describe(string(data) + ".CheckBox.Off"))
				dw_child.setitem(ll_newrow, 'dispvalue', 'DataValue for Off')
				
				if len(idw_target.describe(string(data) + ".CheckBox.Other")) > 0 then
					ll_newrow = dw_child.insertrow(0)
					dw_child.setitem(ll_newrow, 'datavalue', idw_target.describe(string(data) + ".CheckBox.Other"))
					dw_child.setitem(ll_newrow, 'dispvalue', 'DataValue for Other')
				end if
				parent.height = il_extended_height

			case else
				dw_child.reset()
				parent.height = il_normal_height
		end choose
end choose

end event

type dw_child from fw_u_dwo within pf_w_dwbyrbtnfilter
integer x = 27
integer y = 740
integer width = 1961
integer height = 828
integer taborder = 50
boolean bringtotop = true
string title = "Select item listed below"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;if row = 0 then return

long ll_row

ll_row = dw_criteria.getrow()
dw_criteria.setitem(ll_row, 'value', this.getitemstring(row, 1))
parent.height = il_normal_height

end event

event clicked;//IF row > 0 THEN
//	dw_criteria.SetItem(dw_criteria.GetRow(), 'value', This.GetItemString(row, "sub_code"))
////	dw_child.ReSet()
////	Parent.height = il_normal_height
//END IF
end event

