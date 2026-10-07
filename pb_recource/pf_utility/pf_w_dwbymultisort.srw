forward
global type pf_w_dwbymultisort from window
end type
type p_cancel from pf_u_imagebutton within pf_w_dwbymultisort
end type
type p_ok from pf_u_imagebutton within pf_w_dwbymultisort
end type
type dw_criteria from fw_u_dwo within pf_w_dwbymultisort
end type
end forward

global type pf_w_dwbymultisort from window
integer width = 1897
integer height = 1288
boolean titlebar = true
string title = "정렬"
boolean controlmenu = true
windowtype windowtype = response!
event pfe_postopen ( )
p_cancel p_cancel
p_ok p_ok
dw_criteria dw_criteria
end type
global pf_w_dwbymultisort pf_w_dwbymultisort

type variables
DataWindow		idw_target
fw_s_parent		istr_parent
end variables

event pfe_postopen();long ll_cnter, ll_columncnt, nInsRow,ll_pos
string ls_column, ls_dropdownlist, ls_text

ll_columncnt = long(idw_target.describe('DataWindow.Column.Count'))
if ll_columncnt < 1 then return

ls_dropdownlist = ' ' + '~t' + ' ' + '/'
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
dw_criteria.modify("sort_column.Values='" + ls_dropdownlist + "'")
for ll_cnter = 1 to 10
	dw_criteria.insertrow(0)
next
end event

on pf_w_dwbymultisort.create
this.p_cancel=create p_cancel
this.p_ok=create p_ok
this.dw_criteria=create dw_criteria
this.Control[]={this.p_cancel,&
this.p_ok,&
this.dw_criteria}
end on

on pf_w_dwbymultisort.destroy
destroy(this.p_cancel)
destroy(this.p_ok)
destroy(this.dw_criteria)
end on

event open;istr_parent = message.powerobjectparm

If not isvalid(istr_parent) Then
	messagebox('Notice(pf_w_popmenufilter)', 'There is no parameter variable value.')
	Close(this)
	Return
End If
idw_target = istr_parent.dw_obj

fw_f_getiehandlebyposition(This)

Post Event pfe_postopen()
end event

type p_cancel from pf_u_imagebutton within pf_w_dwbymultisort
integer x = 1632
integer y = 40
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

event clicked;call super::clicked;Close(parent)
end event

type p_ok from pf_u_imagebutton within pf_w_dwbymultisort
integer x = 1394
integer y = 40
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

event clicked;call super::clicked;integer li_colcnt, i
string ls_column, ls_text, ls_sortorder
string ls_sortcriteria
long ll_pos, ll_rowcnt, ll_sort

// SortOrder 표시 (△,  ▽ ) 초기화
li_colcnt = integer(idw_target.describe("Datawindow.Column.Count"))
for i = 1 to li_colcnt
	ls_column = idw_target.describe("#" + string(i) + ".Name")
	ls_text = idw_target.describe(ls_column + "_t.Text")
	ls_text = fw_f_replaceall(ls_text, "~"", "")
	
	ll_pos = pos(ls_text, '△')
	if ll_pos = 0 then ll_pos = pos(ls_text, '▽')

	if ll_pos > 0 then
		ls_text = mid(ls_text, 1, ll_pos - 1)
		idw_target.modify(ls_column + "_t.Text='" + ls_text + "'")
	end if
next

ll_rowcnt = dw_criteria.rowcount()
for i = 1 to ll_rowcnt
	ls_column = dw_criteria.getitemstring(i, 'sort_column')
	if pf_f_isemptystring(ls_column) then continue
	
	ls_sortorder = dw_criteria.getitemstring(i, 'sort_gb')
	if ls_sortorder = 'N' then continue

	if pf_f_isemptystring(ls_sortorder) then
		ls_sortorder = 'A'
	end if
	
	ls_text = idw_target.describe(ls_column + "_t.Text")
	ls_text = fw_f_replaceall(ls_text, "~"", "")
	
	ll_sort ++
	choose case ls_sortorder
		case 'A'
			ls_text += '△' + string(ll_sort)
		case 'D'
			ls_text += '▽' + string(ll_sort)
		case else
			continue
	end choose
	
	idw_target.modify(ls_column + "_t.Text='" + ls_text + "'")
	
	if len(ls_sortcriteria) > 0 then
		ls_sortcriteria += ", "
	end if
	
	ls_sortcriteria += ls_column + ' ' + ls_sortorder
next

idw_target.modify("DataWindow.Sparse=''") 
idw_target.setsort(ls_sortcriteria)
idw_target.sort()
idw_target.groupcalc()

//messagebox('ls_sortcriteria', ls_sortcriteria)

Close(Parent)

end event

type dw_criteria from fw_u_dwo within pf_w_dwbymultisort
integer x = 18
integer y = 156
integer width = 1842
integer height = 1024
string dataobject = "pf_d_dwbymultisort"
boolean livescroll = false
end type

event clicked;setrow(row)
end event

event itemchanged;if dwo.name = 'sort_column' then
	if len(trim(data)) > 0 then
		this.object.sort_gb[row] = 'A'
	else
		this.object.sort_gb[row] = 'N'
	end if
end if

end event

