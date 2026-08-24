forward
global type fw_w_filter4dwo1 from window
end type
type dw_a from fw_u_dwo within fw_w_filter4dwo1
end type
end forward

global type fw_w_filter4dwo1 from window
integer width = 1481
integer height = 884
windowtype windowtype = child!
long backcolor = 16777215
event wue_postopen ( )
dw_a dw_a
end type
global fw_w_filter4dwo1 fw_w_filter4dwo1

type prototypes

end prototypes

type variables
fw_s_filter4dwo1	istr_filter

window		iw_parent
fw_u_dwo		iwo_parent
DWObject		idwobj

string	isobj = ''
string	isobj2tag = ''
end variables

forward prototypes
public subroutine of_highlightcolumn ()
public function string of_getload4style (datawindow adw_target)
public subroutine of_setfilter2apply1 ()
public subroutine of_setfilter2apply2 ()
end prototypes

event wue_postopen();string	ls_coltype, ls_data
long		ll_rowcnt, ll_i, ll_j, ll_find
dec{2}	ldc_data

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = isobj2tag
gnv_extfunc.biznode11te(118, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

isobj = gnv_extfunc.istr_node4value.cstr08
If lastpos(isobj, gnv_extfunc.istr_node4value.cstr06) > 0 Then
	isobj = left(isobj, len(isobj) - 2)
End If
ls_coltype = left(istr_filter.dw_data.Describe(isobj + ".Coltype"), 5)
ll_rowcnt = istr_filter.dw_data.RowCount()
Choose Case ls_coltype
	Case 'char('
		For ll_i = 1 To ll_rowcnt
			ls_data = istr_filter.dw_data.getitemstring(ll_i, isobj)
			ll_find = dw_a.find(gnv_extfunc.istr_node4value.cstr10 + ls_data + gnv_extfunc.istr_node4value.cstr09, 1, dw_a.rowcount())
			If ll_find = 0 and fw_f_nvls(ls_data, '') <> '' Then
				ll_j = dw_a.insertrow(0)
				dw_a.object.c_name1 [ll_j] = ls_data
			End If
			IF ll_j>7 THEN EXIT
		Next
	Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
		For ll_i = 1 To ll_rowcnt
			ldc_data = istr_filter.dw_data.getitemdecimal(ll_i, isobj)
			ll_find = dw_a.find(gnv_extfunc.istr_node4value.cstr10 + string(ldc_data) + gnv_extfunc.istr_node4value.cstr11, 1, dw_a.rowcount())
			If ll_find = 0 and fw_f_nvll(ldc_data, 0) <> 0 Then
				ll_j = dw_a.insertrow(0)
				dw_a.object.c_name1 [ll_j] = string (ldc_data)
			End If
			IF ll_j>7 THEN EXIT
		Next
End Choose

dw_a.setsort(isobj + ' A')
dw_a.sort()

dw_a.post setfocus()
end event

public subroutine of_highlightcolumn ();
end subroutine

public function string of_getload4style (datawindow adw_target);// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

string ls_processing, ls_style

ls_processing = adw_target.describe("datawindow.processing")
choose case long(ls_processing)
	case 0
		//freeform인 경우 : detail band height가 dw control의 height의 2.5배 미만(만약 Header가 있는경우를 대비)
		long ll_detailheight, ll_dwcontrolheight, ll_headerheight
		
		ll_headerheight = long(adw_target.describe("Datawindow.Header.Height"))
		ll_detailheight = long(adw_target.describe("Datawindow.Detail.Height"))
		ll_dwcontrolheight = adw_target.Height
		
		if ll_headerheight > pixelstounits(10, ypixelstounits!) then
			ls_style = "tabular"
		elseif ll_detailheight * 2.2 < ll_dwcontrolheight then
			ls_style = "tabular"
		else
			ls_style = "freeform"
		end if
	case 1
		ls_style = 'grid'
	case 2
		ls_style = 'label'
	case 3
		ls_style = 'graph'
	case 4
		ls_style = 'crosstab'
	case 5
		ls_style = 'composite'
	case 6
		ls_style = 'ole'
	case 7
		ls_style = 'richText'
	case 8
		ls_style = 'treevew'
	case 9
		ls_style = 'treeviewwithgrid'
	Case Else
		ls_style = 'etc'
end choose

return ls_style
end function

public subroutine of_setfilter2apply1 ();string	ls_data, ls_lcheck
long		ll_i, ll_rowcnt, ll_ascnt, ll_tocnt

dw_a.AcceptText()

// 기존 filter clear yjs
istr_filter.dw_data.of_setdestroy2filter('')

ll_ascnt = upperbound(istr_filter.dw_data.ischeck2filter[])
ll_rowcnt = dw_a.rowcount()
for ll_i = 1 to ll_rowcnt
	If dw_a.object.c_check [ll_i] = 'Y' Then
		ls_data = dw_a.getitemstring(ll_i, 'c_name1')
		ls_lcheck = dw_a.getitemstring(ll_i, 'c_lcheck')
		istr_filter.dw_data.ischeck2filter[ll_ascnt + 1] += ';' + string(ll_i)
		istr_filter.dw_data.islcheck2filter[ll_ascnt + 1] += ';' + ls_lcheck
		istr_filter.dw_data.istext2filter[ll_ascnt + 1] +=  ';' + ls_data
	End If
next
ll_tocnt = upperbound(istr_filter.dw_data.ischeck2filter[])
If ll_tocnt > ll_ascnt Then
	istr_filter.dw_data.isobj2filter[ll_tocnt] = isobj
	istr_filter.dw_data.ischeck2filter[ll_tocnt] = mid(istr_filter.dw_data.ischeck2filter[ll_tocnt], 2)
	istr_filter.dw_data.islcheck2filter[ll_tocnt] = mid(istr_filter.dw_data.islcheck2filter[ll_tocnt], 2)
	istr_filter.dw_data.istext2filter[ll_tocnt] = mid(istr_filter.dw_data.istext2filter[ll_tocnt], 2)
	post of_setfilter2apply2()
End If
end subroutine

public subroutine of_setfilter2apply2 ();string	ls_findtext[], ls_likecheck[]
string	ls_syntax = '', ls_error
string	ls_coltype, ls_status = 'N', ls_filterstring = ''
long		ll_i, ll_j, ll_objcnt1, ll_objcnt2, ll_ypos, ll_temp

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.biznode11te(117, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

ll_objcnt1 = upperbound(istr_filter.dw_data.ischeck2filter[])
if ll_objcnt1 = 0 then return

//istr_filter.dw_data.SetFilter(ls_syntax)
//istr_filter.dw_data.Filter()
//istr_filter.dw_data.GroupCalc ( )

ls_syntax = gnv_extfunc.istr_node4value.cstr06
for ll_i = 1 to ll_objcnt1
	if ll_i > 1 then ls_status = 'Y'
	ls_coltype = istr_filter.dw_data.describe(istr_filter.dw_data.isobj2filter[ll_i] + ".Coltype")
	ll_temp = fw_f_obj2array(istr_filter.dw_data.islcheck2filter[ll_i], ';', ls_likecheck[])
	ll_temp = fw_f_obj2array(istr_filter.dw_data.istext2filter[ll_i], ';', ls_findtext[])
	ll_objcnt2 = upperbound(ls_findtext[])
	for ll_j = 1 to ll_objcnt2
		if ls_syntax <> '(' then
			if ls_status = 'Y' then
				ls_syntax += gnv_extfunc.istr_node4value.cstr10
			Else
				ls_syntax += gnv_extfunc.istr_node4value.cstr13
			end if
		end if
		Choose Case left(ls_coltype, 5)
			Case 'char('
				if ls_likecheck[ll_j] = gnv_extfunc.istr_node4value.cstr11 Then
					ls_syntax += "(" + istr_filter.dw_data.isobj2filter[ll_i] + gnv_extfunc.istr_node4value.cstr07 + ls_findtext[ll_j] + gnv_extfunc.istr_node4value.cstr09
				Else
					ls_syntax += "(" + istr_filter.dw_data.isobj2filter[ll_i] + gnv_extfunc.istr_node4value.cstr14 + ls_findtext[ll_j] + "')"
				end if
			Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
				ls_syntax += "(" + istr_filter.dw_data.isobj2filter[ll_i] + gnv_extfunc.istr_node4value.cstr16 + ls_findtext[ll_j] +")"
		End Choose
		ls_status = gnv_extfunc.istr_node4value.cstr12
		if ll_i = ll_objcnt1 then
			if ll_j = ll_objcnt2 then
				ls_filterstring += ls_findtext[ll_j]
			else
				ls_filterstring += ls_findtext[ll_j] + ' / '
			end if
		end if
	next
	ls_syntax += gnv_extfunc.istr_node4value.cstr08
next

if fw_f_nvls(ls_syntax, '') <> '' then
	istr_filter.dw_data.SetFilter(ls_syntax)
	istr_filter.dw_data.Filter ( )
	istr_filter.dw_data.GroupCalc ( )
	istr_filter.dw_data.event rowfocuschanged (1)
end if

if not(istr_filter.dw_data.describe(isobj + '_filter.Type') = gnv_extfunc.istr_node4value.cstr15) then
	gnv_extfunc.of_setinitializationapi()
	gnv_extfunc.istr_node4value.cstr01	= isobj
	gnv_extfunc.istr_node4value.cstr02	= string(gnv_vari.filter2sign4color)
	gnv_extfunc.istr_node4value.cstr03	= ls_filterstring
	gnv_extfunc.istr_node4value.cstr04	= isobj
	gnv_extfunc.istr_node4value.cstr05	= string(PixelsToUnits(30, XPixelsToUnits!))
	//ll_ypos = UnitsToPixels(long(istr_filter.dw_data.describe(isobj + "_t.height")) * (1 / 10), YUnitsToPixels!)
	gnv_extfunc.istr_node4value.cstr06	= string(0) //string(PixelsToUnits(0, YPixelsToUnits!))
	gnv_extfunc.biznode11te(116, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
	ls_syntax = gnv_extfunc.istr_node4value.cstr09
	ls_error = istr_filter.dw_data.modify(ls_syntax)
	if ls_error <> '' then
		::clipboard(istr_filter.dw_data.classname() + "~r~n" + ls_syntax)
		messagebox("filter sign", istr_filter.dw_data.classname() + " syntax Creation Failure!!~r~n" + ls_error)
	end if
end if

post close(this)
end subroutine

on fw_w_filter4dwo1.create
this.dw_a=create dw_a
this.Control[]={this.dw_a}
end on

on fw_w_filter4dwo1.destroy
destroy(this.dw_a)
end on

event open;istr_filter = message.powerobjectparm
If not isvalid(istr_filter) Then
	Messagebox('Notice(fw_w_filter4dwo1)', '잘못된 오브젝트 호출입니다')
	Return
End If

iw_parent = istr_filter.w_obj
If isvalid(istr_filter.dw_data) Then
	iwo_parent	= istr_filter.dw_data
	idwobj		= istr_filter.anyobj1
	isobj2tag	= istr_filter.as_tag
End If

powerobject lpo_parent

Long	ll_xpos, ll_ypos

// 부모 컨트롤의 X, Y 좌표를 구합니다.
lpo_parent = iwo_parent.getparent()
Do While isvalid(lpo_parent)
	Choose Case lpo_parent.typeof()
		Case tab!
			tab ltab
			ltab = lpo_parent
			ll_xpos += ltab.x
			ll_ypos += ltab.y
		Case userobject!
			userobject luo
			luo = lpo_parent
			ll_xpos += luo.x
			ll_ypos += luo.y
		Case window!
			String	ls_type
			ls_type = fw_f_nvls(iw_parent.Dynamic of_getwindowtype(), '')
			If Pos(ls_type, 'main') > 0 Then
				ll_xpos += gw_mdi.st_mdiclient.x
				ll_ypos += gw_mdi.st_mdiclient.y
			End If
			Exit
	End Choose
	lpo_parent = lpo_parent.getparent()
Loop

If Not isvalid(iw_parent) Then
	messagebox('Notice(fw_w_filter4dwo1)', '부모 윈도우를 찾을 수 없습니다.')
	return
End If

// 오브젝트의 타입에 따라 위치를 조절합니다.
Choose Case iwo_parent.typeof()
	Case datawindow!
		datawindow ldw_parent
		ldw_parent = iwo_parent
		If This.of_getload4style(ldw_parent)  = 'freeform' Then
			If ldw_parent.titlebar = true Then
				ll_xpos += ldw_parent.x + Long(idwobj.x) + Pixelstounits(3, YPixelstounits!)
				ll_ypos += ldw_parent.y + Long(idwobj.y) + Long(idwobj.height) + Pixelstounits(29, YPixelstounits!)
			Else
				ll_xpos += ldw_parent.x + Long(idwobj.x)
				ll_ypos += ldw_parent.y + Long(idwobj.y) + Long(idwobj.height) + Pixelstounits(2, YPixelstounits!)
			End If
		Else
			ll_xpos += Long(istr_filter.dw_data.x) + Long(idwobj.x) - Pixelstounits(2, XPixelstounits!)
			ll_ypos += Long(istr_filter.dw_data.y) + (Long(idwobj.height) / 2) + ldw_parent.pointery()
		End If
End Choose

If ll_xpos + This.width > gw_mdi.width Then
	Choose Case iwo_parent.typeof()
		Case datawindow!
			ll_xpos -= This.width - Long(idwobj.width)
	End Choose
End If

If ll_ypos + This.height > iw_parent.workspaceheight() Then
	If ldw_parent.titlebar = true Then
		ll_ypos -= (This.height + Pixelstounits(27, YPixelstounits!))
	Else
		ll_ypos -= This.height
	End If
End If

This.x = ll_xpos
This.y = ll_ypos

If gnv_vari.getclienttype='WEB' Then This.Height -= pixelstounits(2, ypixelstounits!)

post event wue_postopen( )
end event

type dw_a from fw_u_dwo within fw_w_filter4dwo1
integer width = 1472
integer height = 876
integer taborder = 10
string dataobject = "fw_d_dw4filter3"
boolean livescroll = false
boolean applydesign = true
boolean useborder = true
boolean setedittoken = true
string setlist4headercolor = "128,128,128"
end type

event losefocus;// 포커스 잃는 경우 종료
post close(parent)

end event

event clicked;Choose Case string(dwo.name)
	Case 'p_filter'
		post of_setfilter2apply1()
	Case 'p_reset'
		istr_filter.dw_data.of_setdestroy2filter('')
		istr_filter.dw_data.event rowfocuschanged (1)
		post close(parent)
End Choose
end event

event oue_keydown;call super::oue_keydown;CHOOSE CASE key
	CASE KeyEscape!
		post close (parent)
	CASE KeyEnter!
		post of_setfilter2apply1()
END CHOOSE
end event

event itemchanged;call super::itemchanged;long	ll_i, ll_rowcnt
choose case dwo.name
	case 'c_lcheck'
		if data = 'Y' then
			this.object.c_check [row] = 'Y'
			ll_rowcnt = this.rowcount()
			for ll_i = 1 to ll_rowcnt
				if ll_i = row then continue
				this.object.c_lcheck [ll_i] = 'N'
				this.object.c_check [ll_i] = 'N'
			next
		end if
	case 'c_check'
		if data = 'Y' then
			ll_rowcnt = this.rowcount()
			for ll_i = 1 to ll_rowcnt
				if ll_i = row then continue
				this.object.c_lcheck [ll_i] = 'N'
			next
		end if
end choose
end event

