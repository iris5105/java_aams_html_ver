forward
global type fw_u_dw4filter from u_ancestor
end type
type dw_filter from fw_u_dwo within fw_u_dw4filter
end type
type dw_reference from fw_u_dwo within fw_u_dw4filter
end type
end forward

global type fw_u_dw4filter from u_ancestor
integer width = 302
integer height = 96
long backcolor = 16777215
string text = ""
borderstyle borderstyle = stylelowered!
event oue_syncretrieveend ( )
event oue_syncretrievestart ( )
event oue_datasync ( )
event oue_syncxpos ( string as_event,  long al_xpos )
event oue_filterapply ( )
event oue_filtercreate ( )
event oue_filterinit ( )
event oue_initsize ( )
event oue_setdddw ( )
dw_filter dw_filter
dw_reference dw_reference
end type
global fw_u_dw4filter fw_u_dw4filter

type variables
Private:
	Long		il_i				= 0
	Long		ilsrollxpos		= 0
	String	isresultstring[]
	Long		ilresultcnt		= 0
	String	isdwsynasis		= ''
	Boolean	ibsetstart		= False
	DataWindowChild	idwc_dddw

Public:
	fw_u_dwo	idw_filter4parent
	String	ReferenceObject	= ''
	String	SetfalseColumn		= ''
	String	defaultfilter		= ''
	Boolean	SetString				= True
	Boolean	SetNumber				= True
	Boolean	Set255WidthLimited	= True

	Long		iluserobjheight		= 0
	Long		ilheight4datawindow	= 0

	Long		DataWindowColor				= RGB(235,235,235)
	Long		GitaColumnBackgroundColor	= RGB(128,128,128)
end variables

forward prototypes
public function datawindow of_getreferenceoj ()
public function string of_referenceobject ()
public function string of_thisname ()
public function string of_filtertruenumber (string as_syntax, string as_dwoname, string as_editstyle, string as_objtype, long al_xpos)
public subroutine of_dddwposition (datawindow adw_dw, datawindowchild adwc_dddw, string as_obj)
public subroutine of_dddwdelrow (datawindowchild adwc_dddw, string as_obj)
public function integer of_dddwcreate (datawindow adw_dw, string as_obj)
public subroutine of_setclicked2filter (long xpos, long ypos, long row, string as_obj)
public function string of_filtertruechar (string as_syntax, string as_objnm, string as_editstyle, string as_objtype, long al_xpos)
public function string of_filterfalse (string as_syntax, string as_objnm, string as_objtype)
public subroutine of_initprocess (long al_row, string as_obj)
end prototypes

event oue_syncretrieveend();gnv_extfunc.biznode1te(138, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)

gnv_extfunc.biznode1te(137, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)

Long ll_scrollpos
ll_scrollpos = idw_filter4parent.Dynamic of_getscrollpos()
If ilsrollxpos = ll_scrollpos Then ilsrollxpos = 0
This.Event oue_syncxpos('this', ll_scrollpos)
end event

event oue_syncretrievestart();gnv_extfunc.biznode1te(139, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)
end event

event oue_datasync();// Data sync
String	ls_dwsyntobe, ls_designstyle

dw_filter.Reset()
ls_designstyle = idw_filter4parent.Dynamic of_getdesignstyle()	
If IsNull(dw_reference.DataObject) or dw_reference.DataObject = '' Then
	dw_reference.DataObject = idw_filter4parent.DataObject
	isdwsynasis		= idw_filter4parent.Describe("DataWindow.Syntax")
	If ls_designstyle	= 'grid' Then isdwsynasis = fw_f_replaceall(isdwsynasis, 'processing=1', 'processing=0') /* grid check */
	If dw_reference.Create( isdwsynasis ) = 1 Then dw_filter.create( isdwsynasis )
Else /* 2번째 부터 dw_filter는  dw_reference syntax를 적용한다 */
	ls_dwsyntobe	= idw_filter4parent.Describe("DataWindow.Syntax")
	If ls_designstyle = 'grid' Then ls_dwsyntobe = fw_f_replaceall(ls_dwsyntobe, 'processing=1', 'processing=0') /* grid check */
	dw_filter.create( ls_dwsyntobe )
	If isdwsynasis <> ls_dwsyntobe Then
		ilsrollxpos	= 0
		isdwsynasis = ls_dwsyntobe
	End If
End If

If idw_filter4parent.rowcount() > 0 Then dw_reference.Object.Data = idw_filter4parent.Object.Data
end event

event oue_syncxpos(string as_event, long al_xpos);String		ls_syntax, ls_error
String		ls_object[]
String		ls_objtype, ls_band, ls_coltype
Long		ll_objectcnt, ll_xpos, ll_ypos, ll_ii, ll_xpossroll

ls_syntax = '' /* init */

idw_filter4parent.of_getobjectsignup(ls_object[])
ll_objectcnt = upperbound(ls_object[])
For ll_ii = 1 to ll_objectcnt
	ls_band = dw_filter.describe(ls_object[ll_ii] + ".Band")
	If (ls_band = '?' or ls_band = '!') or ls_band <> "detail" Then Continue
	If as_event = 'resize' Then
		ll_xpos	= Long(idw_filter4parent.Describe(ls_object[ll_ii] + ".x")) - PixelsToUnits(1, XPixelsToUnits!)
		ll_ypos	= Long(idw_filter4parent.Describe(ls_object[ll_ii] + ".y"))
		ilsrollxpos = 0
		ls_syntax += ls_object[ll_ii] + ".X='" + String(ll_xpos) + "'~r~n"
	Else
		ll_xpos	= Long(dw_filter.Describe(ls_object[ll_ii] + ".x"))
		ll_ypos	= Long(dw_filter.Describe(ls_object[ll_ii] + ".y"))
		ll_xpossroll = ll_xpos + ilsrollxpos - al_xpos
		ls_syntax += ls_object[ll_ii] + ".X='" + String(ll_xpossroll) + "'~r~n"
	End If
Next
ilsrollxpos = al_xpos
//gw_mdi.setmicrohelp(string(ilsrollxpos) +  '/' + string(al_xpos))
ls_error = dw_filter.modify( ls_syntax )
If fw_f_nvls(ls_error, '') <> '' Then
	::clipboard(ls_syntax)
	Messagebox('Error', 'Column apply Modify 실패')
	Return
End If
end event

event oue_filterapply();string		ls_object, ls_objarr[]
String		ls_syntax
String		ls_data, ls_band, ls_objtype, ls_coltype, ls_editstyle
long		i, ll_objcnt
long		ll_objpos, ll_bandheight, ll_ypos

/* filter init */
ls_syntax = ''
idw_filter4parent.SetFilter(ls_syntax)
idw_filter4parent.Filter()
idw_filter4parent.GroupCalc ( )
Yield ( )
ls_object = dw_filter.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
For i = 1 to ll_objcnt
	If Pos(ls_objarr[i], '_rect') > 0 Then Continue
	ls_band = dw_filter.describe(ls_objarr[i] + ".Band")
	ls_objtype = dw_filter.describe(ls_objarr[i] + ".Type")
	ls_coltype = dw_filter.describe(ls_objarr[i] + ".Coltype")
	If not(ls_band = 'detail') Then Continue
	If ls_objtype = 'compute' Then Continue
	Choose Case left(ls_coltype, 5)
		Case 'char('
			ls_data = dw_filter.GetItemString(1, ls_objarr[i])
			If fw_f_nvls(ls_data, '') <> '' Then
				If fw_f_nvls(ls_syntax, '') <> '' Then ls_syntax += ' and '
				ls_syntax += "(" + ls_objarr[i] + " like '%"+ ls_data + "%') "
			End If
		Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'		
			ls_data = String(dw_filter.GetItemNumber(1, ls_objarr[i]))
			If fw_f_nvls(ls_data, '0') <> '0' Then
				If fw_f_nvls(ls_syntax, '') <> '' Then ls_syntax += ' and '
				ls_syntax += "(" + ls_objarr[i] + " = "+ ls_data + ") "
			End If
	End Choose	
Next

If fw_f_nvls(ls_syntax, '') <> '' Then
	IF	f_null (defaultfilter)	Then
		idw_filter4parent.SetFilter (ls_syntax)
	Else
		idw_filter4parent.SetFilter ('(' + defaultfilter + ') and ' + ls_syntax)
	End IF
	idw_filter4parent.Filter()
	idw_filter4parent.GroupCalc ( )
End If
end event

event oue_filtercreate();String		ls_objarr[]
String		ls_objects
String		ls_objtype, ls_band, ls_editstyle, ls_autoheihtgb4col
String		ls_autoheihtgb4band
String		ls_syntax2 = '', ls_syntax1 = '', ls_error
long		i, ll_objcnt
long		ll_objpos, ll_xpos, ll_width, ll_bandheight, ll_ypos
Boolean	lb_flag = false

ls_syntax2 = "DataWindow.Header.Height='0'~r~n"
ls_syntax2 += "DataWindow.Summary.Height='0'~r~n"
ls_syntax2 += "DataWindow.Footer.Height='0'~r~n"
ls_syntax2 += "DataWindow.Detail.Height='" + String(ilheight4datawindow) + "'~r~n"
ls_syntax2 += "DataWindow.Detail.Color='" + String(DataWindowColor) + "'~r~n"
ls_autoheihtgb4band = dw_filter.Describe("DataWindow.Header.Height.AutoSize") + dw_filter.Describe("DataWindow.Detail.Height.AutoSize")

If Pos(lower(ls_autoheihtgb4band), 'yes') > 0 Then
	ls_error = dw_filter.modify( ls_syntax2 )
	If fw_f_nvls(ls_error, '') <> '' Then
		::clipboard(ls_syntax2)
		Messagebox('Error', 'filter 생성 실패' + ls_error)
		Return
	End If
	Messagebox('Check', 'band AutoSize 또는 column AutoHeight가 선택시 지원하지 않습니다.')
	Return
End If
/* main processing */
ls_objects	= dw_filter.Describe("Datawindow.Objects")
ll_objcnt	= fw_f_obj2array(ls_objects, '~t', ls_objarr[])
/* SetfalseColumn temp update */
String		ls_falseobjarr[]
Long		ll_falseobjcnt, ii
ll_falseobjcnt = fw_f_obj2array(SetfalseColumn, ';', ls_falseobjarr[])

for i = 1 to ll_objcnt	
	ls_objtype	= dw_filter.describe(ls_objarr[i] + ".Type")
	ls_editstyle	= dw_filter.describe(ls_objarr[i] + ".Edit.Style")
	ls_band		= dw_filter.describe(ls_objarr[i] + ".Band")

	If ls_band = "?" or ls_band = "!" Then Continue // 화면에 위치 하지 않는 컨트롤 제외
	/* to-be controls YPosition이 해당 band 밑에 있으면 Continue */
	ll_bandheight	= Long(dw_filter.describe("DataWindow." + ls_band + ".Height"))
	ll_xpos	= Long(dw_filter.Describe(ls_objarr[i] + ".X"))
	ll_ypos	= Long(dw_filter.describe(ls_objarr[i] + ".Y"))
	ll_width	= Long(dw_filter.Describe(ls_objarr[i] + ".Width"))
	ls_autoheihtgb4col	= dw_filter.describe(ls_objarr[i] + ".Height.AutoSize")
	Choose Case ls_objtype
		Case 'column', 'compute'
			//
		Case Else
			ls_syntax1 += "Destroy " + ls_objarr[i] + "~r~n"
			Continue
//			ls_syntax2 += ls_objarr[i] + ".X='" + String(ll_xpos * -10) + "'~r~n"
//			ls_syntax2 += ls_objarr[i] + ".Y='" + String(ll_bandheight + Pixelstounits(25, YPixelsToUnits!)) + "'~r~n"
	End Choose
//	If fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 Then
//		ls_syntax2 += ls_objarr[i] + ".Visible='0'~r~n"
//		Continue
//	End If
	ls_syntax2 += ls_objarr[i] + ".X='" + String(ll_xpos - Pixelstounits(1, XPixelsToUnits!)) + "'~r~n"
	ls_syntax2 += ls_objarr[i] + ".Width='" + String(ll_width + Pixelstounits(1, XPixelsToUnits!)) + "'~r~n"
	ls_syntax2 += ls_objarr[i] + ".Background.Mode='0'~r~n"
	ls_syntax2 += ls_objarr[i] + ".Width='" + String(ll_width + Pixelstounits(1, XPixelsToUnits!)) + "'~r~n"
	ls_syntax2 += ls_objarr[i] + ".Border='0'~r~n"
	
	Choose Case ls_editstyle
		Case 'radiobuttons', 'checkbox'
			ls_syntax2 += ls_objarr[i] + ".Height='" + String(Pixelstounits(19, YPixelsToUnits!)) + "'~r~n"
			ls_syntax2 += ls_objarr[i] + ".Y='12'~r~n"
		Case Else
			ls_syntax2 += ls_objarr[i] + ".Height='" + String(Pixelstounits(22, YPixelsToUnits!)) + "'~r~n"
			ls_syntax2 += ls_objarr[i] + ".Y='0'~r~n"
	End Choose
	If lower(ls_autoheihtgb4col) = 'yes' Then ls_syntax2 += ls_objarr[i] + ".Height.AutoSize=No~r~n"
	lb_flag = false /* init */
	If ll_falseobjcnt > 0 or fw_f_nvls(SetfalseColumn, '') <> '' Then
		FOR ii = 1 To ll_falseobjcnt
			If ls_objarr[i] = ls_falseobjarr[ii] Then
				ls_syntax2 += of_filterfalse(ls_syntax2, ls_objarr[i], ls_objtype)
				lb_flag = true
				Exit
			End If
		Next
		If lb_flag Then Continue
	End If
	
	/* initial value check & init */
	Choose Case dw_filter.Describe(ls_objarr[i] + ".Initial")
		Case '!', '?'
			//pass
		Case Else
			ls_syntax2 += ls_objarr[i] + ".Initial=''~r~n"
	End Choose
	/* format value check & init */
	Choose Case dw_filter.Describe(ls_objarr[i] + ".Format")
		Case '!', '?'
			//pass
		Case Else
			ls_syntax2 += ls_objarr[i] + ".Format='[general]'~r~n"
	End Choose
	
	If ls_objtype = "compute" or ls_objtype = "text" Then
		ls_syntax2 += of_filterfalse(ls_syntax2, ls_objarr[i], ls_objtype)
		Continue
	End If
	
	ls_editstyle = dw_filter.Describe(ls_objarr[i] + ".Edit.Style")
	Choose Case left(dw_filter.Describe(ls_objarr[i] + ".Coltype"), 5)
		Case 'char('
			If SetString = True Then
				ls_syntax2 += of_filtertruechar(ls_syntax2, ls_objarr[i], ls_editstyle, ls_objtype, ll_xpos)
			Else
				ls_syntax2 += of_filterfalse(ls_syntax2, ls_objarr[i], ls_objtype)
			End If
		Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
			If SetNumber = True Then
				ls_syntax2 += of_filtertruenumber(ls_syntax2, ls_objarr[i], ls_editstyle, ls_objtype, ll_xpos)
			Else
				ls_syntax2 += of_filterfalse(ls_syntax2, ls_objarr[i], ls_objtype)
			End If
		Case Else
			ls_syntax2 += of_filterfalse(ls_syntax2, ls_objarr[i], ls_objtype)
	End Choose
Next

ls_error = dw_filter.modify( ls_syntax1 )
If fw_f_nvls(ls_error, '') <> '' Then
	::clipboard(ls_syntax2)
	Messagebox('Error', 'destroy false' + ls_error)
	Return
End If

ls_error = dw_filter.modify( ls_syntax2 )
If fw_f_nvls(ls_error, '') <> '' Then
	::clipboard(ls_syntax2)
	Messagebox('Error', 'filter 생성 실패' + ls_error)
	Return
End If

dw_filter.Insertrow(0)
end event

event oue_filterinit();string		ls_object, ls_objarr[]
String		ls_data, ls_filter, ls_band
long		i, ll_objcnt
long		ll_objpos, ll_xpos, ll_width, ll_bandheight, ll_ypos

ls_object = dw_filter.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
For i = 1 to ll_objcnt
	If dw_filter.Describe(ls_objarr[i] + ".Band") = 'detail' Then
		/* to-be controls YPosition이 해당 band 밑에 있으면 Continue */
		ls_band		= dw_filter.Describe(ls_objarr[i] + ".Band")
		ll_bandheight	= Long(dw_filter.describe("DataWindow." + ls_band + ".Height"))
		ll_ypos		= Long(dw_filter.describe(ls_objarr[i] + ".Y"))	
		If ll_bandheight <= ll_ypos Then Continue
		
		Choose Case left(dw_filter.Describe(ls_objarr[i] + ".Coltype"), 5)
			Case 'char('
				dw_filter.SetItem(1, ls_objarr[i], '')
			Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
				dw_filter.SetItem(1, ls_objarr[i], 0)
		End Choose	
	End If
Next

/* filter init */
idw_filter4parent.SetFilter (defaultfilter)
idw_filter4parent.Filter()
idw_filter4parent.GroupCalc ( )
end event

event oue_initsize();If NOT IsValid(idw_filter4parent) Then Return
This.height		= Long(PixelsToUnits(24, YPixelsToUnits!))
iluserobjheight	= This.height
iluserobjheight	= Round(iluserobjheight * (Long(gnv_vari.mswindowrate) / 100), 0)

This.width	= idw_filter4parent.width + Long(pixelstounits(2, XPixelsToUnits!))
This.x		= idw_filter4parent.x - Long(PixelsToUnits(1, XPixelsToUnits!))
This.y		= idw_filter4parent.y - iluserobjheight// - Long(Pixelstounits(1, YPixelsToUnits!))
This.scaletoright		= idw_filter4parent.scaletoright
This.scaletobottom	= false
This.fixedtobottom	= idw_filter4parent.fixedtobottom
This.fixedtoright		= false
This.fixedtobottom	= idw_filter4parent.fixedtobottom
/* dw_filter position */
dw_filter.x				= Long(PixelsToUnits(1, XPixelsToUnits!))
dw_filter.y				= Long(PixelsToUnits(1, YPixelsToUnits!))
ilheight4datawindow	= iluserobjheight - Long(Pixelstounits(2, YPixelsToUnits!))
dw_filter.height			= ilheight4datawindow
dw_filter.width			= idw_filter4parent.width
end event

event oue_setdddw();//fw_f_setdddw (dw_filter, idwc_dddw, column명('code'), {'*'}) -> arg가 없을때 ( AUTO retrieve )
//fw_f_setdddw (dw_filter, idwc_dddw, column명('code'), {'A', 'B','C'}) -> arg가 있을때
end event

public function datawindow of_getreferenceoj ();// 윈도우 오브젝트에서 참조되는 DW의 레퍼런스를 리턴합니다
// 리턴값: 참조 DW 레퍼런스
DataWindow ldw_object

ldw_object = iw_parent.dynamic of_getrefdw2obj(ReferenceObject)

Return ldw_object

end function

public function string of_referenceobject ();Return fw_f_nvls(referenceobject, '')
end function

public function string of_thisname ();return 'fw_u_dw4filter'

end function

public function string of_filtertruenumber (string as_syntax, string as_dwoname, string as_editstyle, string as_objtype, long al_xpos);String		ls_syntax

ls_syntax = '' /* init */

Choose Case as_editstyle
	Case 'edit', 'editmask'
		Choose Case as_editstyle
			Case 'edit'
				ls_syntax += as_dwoname + ".Edit.AutoSelect='Yes'~r~n"
				ls_syntax += as_dwoname + ".Edit.FocusRectangle='No'~r~n"
		End Choose
		If al_xpos = 0 Then al_xpos = 1
		If as_objtype = 'column' Then ls_syntax += as_dwoname + ".TabSequence='" + string(al_xpos) + "'~r~n"
		ls_syntax += as_dwoname + ".Background.Color='" + string(gnv_vari.editablecolbgcolor) + "'~r~n"
	Case Else //, 'editmask' 'checkbox', 'radiobutton'
		ls_syntax += of_filterfalse(as_syntax, as_dwoname, as_objtype)
End Choose

Return ls_syntax
end function

public subroutine of_dddwposition (datawindow adw_dw, datawindowchild adwc_dddw, string as_obj);String		ls_syntax, ls_error
String		ls_object, ls_objarr[]
String		ls_objtype, ls_band
Long		i, ll_objcnt
Long		ll_objpos, ll_xpos, ll_width

/* dddwposition 진행 */
idw_filter4parent.of_getobjectsignup(ls_objarr[])
ll_objcnt = upperbound(ls_objarr[])
for i = 1 to ll_objcnt
	If fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 Then Continue
	ls_objtype	= adwc_dddw.Describe(ls_objarr[i] + ".Type")
	ls_band		= adwc_dddw.Describe(ls_objarr[i] + ".Band")
	
	//If not (ls_objtype = "column" or ls_objtype = "compute") Then Continue
	If ls_band = "?" or ls_band = "!" Then Continue // 화면에 위치 하지 않는 컨트롤 제외
	ll_width		= Long(adw_dw.describe(ls_objarr[i] + ".Width"))
	
	If Pos(ls_objarr[i], as_obj) = 0 Then
		ls_syntax += ls_objarr[i] + ".Width='0'/rn"
		ls_syntax += ls_objarr[i] + ".Visible='0'/rn"
		Continue
	End If
	
	ls_syntax += ls_objarr[i] + ".Background.Color='1073741824'/rn"
	ls_syntax += ls_objarr[i] + ".X='0'/rn"
	ls_syntax += ls_objarr[i] + ".Y='12'/rn"
	ls_syntax += ls_objarr[i] + ".Alignment='0'/rn"
	ls_syntax += ls_objarr[i] + ".Border='0'/rn"
	ls_syntax += ls_objarr[i] + ".Height='" + String(PixelsToUnits(19, YPixelsToUnits!)) + "'/rn"
	ls_syntax += ls_objarr[i] + ".Width='" + String(Long(PixelsToUnits((ll_width * 2), XPixelsToUnits!))) + "'/rn"
Next
gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01	= "DataWindow.Color='" + string(gnv_vari.setlist4backcolor) + "'"
gnv_extfunc.istr_node4value.cstr02	= "DataWindow.Header.Height='0'"
gnv_extfunc.istr_node4value.cstr03	= "DataWindow.Detail.Height='96'"
gnv_extfunc.istr_node4value.cstr04	= "DataWindow.Summary.Height='0'"
gnv_extfunc.istr_node4value.cstr05	= "DataWindow.Footer.Height='0'"
gnv_extfunc.istr_node4value.cstr07	= ls_syntax
gnv_extfunc.biznode11te(110, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

ls_error = adwc_dddw.modify( gnv_extfunc.istr_node4value.cstr10 )
If fw_f_nvls(ls_error, '') <> '' Then
	::clipboard(ls_syntax)
	Messagebox('Error', 'Column dddw 생성 실패1' + ls_error)
	return
End If
end subroutine

public subroutine of_dddwdelrow (datawindowchild adwc_dddw, string as_obj);String		ls_coltype, ls_data, ls_value
Long			ll_data, ll_value, ll_i, ll_rowcnt

adwc_dddw.SetSort(as_obj + ' D')
adwc_dddw.Sort()
ls_coltype	= left(adwc_dddw.Describe(as_obj + ".Coltype"), 5)
ll_rowcnt	= adwc_dddw.RowCount()
Choose Case ls_coltype
	Case 'char('
		For ll_i = ll_rowcnt To 1 Step -1
			If ll_i = ll_rowcnt Then
				ls_data = adwc_dddw.GetItemString(ll_i, as_obj)
			ELSE
				ls_value = adwc_dddw.GetItemString(ll_i, as_obj)
				If ls_data = ls_value or fw_f_nvls(ls_value, '') = '' Then
					adwc_dddw.DeleteRow(ll_i)
				Else
					ls_data = adwc_dddw.GetItemString(ll_i, as_obj)
				End If
			End If
//			ls_data = fw_f_replaceall(ls_data, '"', '')
//			ls_data = fw_f_replaceall(ls_data, "'", "")
//			adwc_dddw.SetItem(ll_i, as_obj, ls_data)
//			IF	Pos(ls_data, '~r') > 0 or Pos(ls_data, '~n') > 0 Then
//				Messagebox('Check', '여러줄이 있는 데이터는 지원하지 않습니다.')
//				Return
//			End If
		Next
	Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
		For ll_i = ll_rowcnt To 1 Step -1
			If ll_i = ll_rowcnt Then
				ll_data = adwc_dddw.GetItemNumber(ll_i, as_obj)
			ELSE
				ll_value = adwc_dddw.GetItemNumber(ll_i, as_obj)
				If ll_data = ll_value or fw_f_nvll(ll_value, 0) = 0 Then
					adwc_dddw.DeleteRow(ll_i)
				Else
					ll_data = adwc_dddw.GetItemNumber(ll_i, as_obj)
				End If
			End If
		Next		
End Choose
//ilresultcnt++
//isresultstring[ilresultcnt] = as_obj
//of_dddwposition(dw_filter, adwc_dddw, as_obj)
end subroutine

public function integer of_dddwcreate (datawindow adw_dw, string as_obj);string		ls_syntax = ''
string		ls_dddwobj, ls_coltype
string		ls_error
long		ll_rtn, ll_rowcnt, ll_i, ll_j, ll_find
string		ls_data
dec{2}		ldc_data
Datawindowchild ldwc_dddw

ls_dddwobj	= string(dw_reference.DataObject)
gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01	= as_obj
gnv_extfunc.istr_node4value.cstr02	= ls_dddwobj
gnv_extfunc.istr_node4value.cstr03	= '150'
gnv_extfunc.istr_node4value.cstr04	= '150'
gnv_extfunc.biznode11te(109, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
						
ls_syntax += gnv_extfunc.istr_node4value.cstr09
ls_coltype = left(adw_dw.Describe(as_obj + ".Coltype"), 5)
Choose Case ls_coltype
	Case 'char('
		ls_syntax += gnv_extfunc.istr_node4value.cstr06
	Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
		ls_syntax += gnv_extfunc.istr_node4value.cstr07
End Choose
ls_syntax += gnv_extfunc.istr_node4value.cstr10

ls_error = adw_dw.modify( ls_syntax )
If fw_f_nvls(ls_error, '') <> '' Then
	::clipboard(ls_syntax)
	Messagebox('Error', 'dddw of_dddwcreate Modify 1 등록 실패')
	Return -1
End If
adw_dw.GetChild(as_obj, ldwc_dddw)
If IsValid( ldwc_dddw ) Then
	ll_rowcnt = dw_reference.RowCount()
	For ll_i = 1 To ll_rowcnt
		Choose Case ls_coltype
			Case 'char('
				ls_data = dw_reference.getitemstring(ll_i, as_obj)
				ll_find = ldwc_dddw.find(as_obj + '="' + ls_data + '"', 1, ldwc_dddw.rowcount())
				If ll_find = 0 Then
					ll_j++
					ldwc_dddw.insertrow(0)
					ldwc_dddw.setitem(ll_j, as_obj, ls_data)
				End If
			Case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
				ldc_data = dw_reference.getitemdecimal(ll_i, as_obj)
				ll_find = ldwc_dddw.find(as_obj + '=' + string(ldc_data), 1, ldwc_dddw.rowcount())
				If ll_find = 0 Then
					ll_j++
					ldwc_dddw.insertrow(0)
					ldwc_dddw.setitem(ll_j, as_obj, ldc_data)
				End If
		End Choose
	Next
	ldwc_dddw.SetSort(as_obj + ' A')
	ldwc_dddw.Sort()
	ilresultcnt++
	isresultstring[ilresultcnt] = as_obj
	of_dddwposition(dw_filter, ldwc_dddw, as_obj)
Else
	Messagebox('Error', 'dddw 자료등록 실패')
	Return -1
End If	

Return 1
end function

public subroutine of_setclicked2filter (long xpos, long ypos, long row, string as_obj);If row < 1 Then Return
String		ls_coltype, ls_editstyle
Long		ll_width

ls_editstyle	= dw_filter.Describe(as_obj + ".Edit.Style")
If ls_editstyle = '?' or ls_editstyle = '!' Then Return
Choose Case ls_editstyle
	Case 'ddlb', 'editmask', 'radiobuttons', 'checkbox'
		//
	Case 'dddw'
		Event oue_setdddw()
	Case Else
		ls_coltype	= left(dw_filter.describe(as_obj + ".Coltype"), 5)
		ll_width		= Long(dw_filter.describe(as_obj + ".Width"))
		Choose Case ls_coltype
			Case 'char(', 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
				Choose Case Set255WidthLimited
					Case True
						If Long(UnitsToPixels(ll_width, XUnitsToPixels!)) > 55 Then of_dddwcreate(dw_filter, as_obj)
					Case False
						of_dddwcreate(dw_filter, as_obj)
				End Choose
		End Choose
End Choose
end subroutine

public function string of_filtertruechar (string as_syntax, string as_objnm, string as_editstyle, string as_objtype, long al_xpos);String		ls_syntax

ls_syntax = '' /* init */
Choose Case lower(as_editstyle)
	Case 'edit', 'ddlb', 'dddw', 'radiobuttons', 'checkbox'
		Choose Case as_editstyle
			Case 'edit'
				ls_syntax += as_objnm + ".Edit.AutoSelect='Yes'~r~n"
				ls_syntax += as_objnm + ".Edit.FocusRectangle='No'~r~n"
			Case 'ddlb'
				ls_syntax += as_objnm + ".DDLB.AllowEdit='Yes'~r~n"
			Case 'dddw'
				ls_syntax += as_objnm + ".DDDW.AllowEdit='Yes'~r~n"
			Case 'dddw'
				ls_syntax += as_objnm + ".DDDW.AllowEdit='Yes'~r~n"
		End Choose
		If al_xpos = 0 Then al_xpos = 1
		If as_objtype = 'column' Then ls_syntax += as_objnm + ".TabSequence='" + string(al_xpos) + "'~r~n"
		ls_syntax += as_objnm + ".Background.Color='" + string(gnv_vari.editablecolbgcolor) + "'~r~n"
	Case Else
		ls_syntax += of_filterfalse(as_syntax, as_objnm, as_objtype)
End Choose

Return ls_syntax
end function

public function string of_filterfalse (string as_syntax, string as_objnm, string as_objtype);String		ls_syntax

ls_syntax = '' /* init */

If as_objtype = 'column' Then ls_syntax += as_objnm + ".TabSequence='0'~r~n"

ls_syntax += as_objnm + ".Color='" + string(gnv_vari.disabledcolbgcolor) + "'~r~n"
ls_syntax += as_objnm + ".Background.Color='" + string(gnv_vari.disabledcolbgcolor) + "'~r~n"

Return ls_syntax
end function

public subroutine of_initprocess (long al_row, string as_obj);If fw_f_nm4dwo(dw_filter, as_obj) <> 'datawindow' Then
	If ilresultcnt > 0 Then
		for il_i = 1 to ilresultcnt
			If as_obj = isresultstring[il_i] Then return
		next
	End If
	of_setclicked2filter(0, 0, al_row, as_obj)
	gnv_extfunc.biznode1te(145, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
	This.TriggerEvent(gnv_extfunc.is_nodevalue)
End If
end subroutine

on fw_u_dw4filter.create
int iCurrent
call super::create
this.dw_filter=create dw_filter
this.dw_reference=create dw_reference
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_filter
this.Control[iCurrent+2]=this.dw_reference
end on

on fw_u_dw4filter.destroy
call super::destroy
destroy(this.dw_filter)
destroy(this.dw_reference)
end on

event constructor;call super::constructor;// 참조탭 구하기
If ReferenceObject = '' Then
	messagebox('Notice', '참조할 DataWindow 명칭을 입력하세요')
	Return
End If
idw_filter4parent = of_getreferenceoj()
If not isvalid(idw_filter4parent) Then
	messagebox('Notice', '참조할 DataWindow 명칭을 찾을 수 없습니다')
	Return
End If

idw_filter4parent.of_setfilterobj(This)

gnv_extfunc.biznode1te(140, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.PostEvent(gnv_extfunc.is_nodevalue)
end event

event destructor;call super::destructor;Destroy idw_filter4parent
end event

type dw_filter from fw_u_dwo within fw_u_dw4filter
integer width = 302
integer height = 96
integer taborder = 10
boolean bringtotop = true
string dataobject = "fw_d_dw4filter1"
boolean livescroll = false
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean setedittoken = true
end type

event itemchanged;call super::itemchanged;If row < 1 Then Return
gnv_extfunc.biznode1te(136, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
Parent.PostEvent(gnv_extfunc.is_nodevalue)
end event

event itemfocuschanged;of_initprocess(row, string(dwo.name))
end event

event itemerror;Return 2
end event

event mousemove;//
end event

event clicked;call super::clicked;of_initprocess(row, string(dwo.name))
end event

type dw_reference from fw_u_dwo within fw_u_dw4filter
boolean visible = false
integer x = 27
integer y = 132
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
end type

