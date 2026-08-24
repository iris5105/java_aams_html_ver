forward
global type n_dwr_height from nonvisualobject
end type
end forward

global type n_dwr_height from nonvisualobject
end type
global n_dwr_height n_dwr_height

type variables
ads_jTier ids_sys0
ads_jTier ids_sys1
ads_jTier ids_sys2
ads_jTier ids_sys3
end variables

forward prototypes
public function ads_jTier of_get_ds (integer ai_units)
public function long of_get_col_height_font (integer ai_col_width, string str, string font_name, boolean font_italic, integer font_underline, integer font_weight, integer font_size, integer units)
end prototypes

public function ads_jTier of_get_ds (integer ai_units);choose case ai_units
	case 0
		return ids_sys0
	case 1
		return ids_sys1
	case 2
		return ids_sys2
	case 3
		return ids_sys3
	case else
		return ids_sys0		
end choose

end function

public function long of_get_col_height_font (integer ai_col_width, string str, string font_name, boolean font_italic, integer font_underline, integer font_weight, integer font_size, integer units);string ls_val
integer ret = 0
ads_jTier lds
lds = of_get_ds(units)

lds.object.str_col[1] = str

lds.object.str_col.Height = 0
lds.object.str_col.Width = ai_col_width
lds.object.DataWindow.Detail.Height = 0

lds.object.str_col.Font.Face = font_name
lds.object.str_col.Font.Italic = font_italic
if font_underline = 0 then
	lds.object.str_col.Font.Underline = false
else
	lds.object.str_col.Font.Underline = true
end if
lds.object.str_col.Font.Weight = font_weight
lds.object.str_col.Font.Height = -abs(font_size)

ret = long(lds.Describe("evaluate('rowheight()', 1)"))
ret = PixelsToUnits(UnitsToPixels(ret, YUnitsToPixels!), YPixelsToUnits!) + 7

return ret
end function

on n_dwr_height.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_height.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;integer li_ret
string ls_syntax

ids_sys0 = create ads_jTier
ids_sys1 = create ads_jTier
ids_sys2 = create ads_jTier
ids_sys3 = create ads_jTier

// PB Units
ls_syntax = &
'	release 12.6;~r~n' + &
'	datawindow(units=0 processing=0)~r~n' + &
'	summary(height=0 color="536870912" )~r~n' + &
'	footer(height=0 color="536870912" )~r~n' + &
'	detail(height=0 color="536870912"  height.autosize=yes)~r~n' + &
'	table(column=(type=char(32000) updatewhereclause=yes name=str_col dbname="str_col" )~r~n' + &
'	 )~r~n' + &
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="5" y="4" height="76" width="302" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autovscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = ids_sys0.Create(ls_syntax)
if li_ret = 1 then
	if ids_sys0.RowCount() = 0 then
		ids_sys0.InsertRow(0)
	end if
end if

// Pixels
ls_syntax = &
'	release 12.6;~r~n' + &
'	datawindow(units=1 processing=0)~r~n' + &
'	summary(height=0 color="536870912" )~r~n' + &
'	footer(height=0 color="536870912" )~r~n' + &
'	detail(height=0 color="536870912"  height.autosize=yes)~r~n' + &
'	table(column=(type=char(32000) updatewhereclause=yes name=str_col dbname="str_col" )~r~n' + &
'	 )~r~n' + &
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="1" y="1" height="19" width="66" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autovscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = ids_sys1.Create(ls_syntax)
if li_ret = 1 then
	if ids_sys1.RowCount() = 0 then
		ids_sys1.InsertRow(0)
	end if
end if

// Inches
ls_syntax = &
'	release 12.6;~r~n' + &
'	datawindow(units=2 processing=0)~r~n' + &
'	summary(height=0 color="536870912" )~r~n' + &
'	footer(height=0 color="536870912" )~r~n' + &
'	detail(height=0 color="536870912"  height.autosize=yes)~r~n' + &
'	table(column=(type=char(32000) updatewhereclause=yes name=str_col dbname="str_col" )~r~n' + &
'	 )~r~n' + &
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="10" y="10" height="197" width="687" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autovscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = ids_sys2.Create(ls_syntax)
if li_ret = 1 then
	if ids_sys2.RowCount() = 0 then
		ids_sys2.InsertRow(0)
	end if
end if

// Centimeters
ls_syntax = &
'	release 12.6;~r~n' + &
'	datawindow(units=3 processing=0)~r~n' + &
'	summary(height=0 color="536870912" )~r~n' + &
'	footer(height=0 color="536870912" )~r~n' + &
'	detail(height=0 color="536870912"  height.autosize=yes)~r~n' + &
'	table(column=(type=char(32000) updatewhereclause=yes name=str_col dbname="str_col" )~r~n' + &
'	 )~r~n' + &
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="26" y="27" height="502" width="1746" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autovscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = ids_sys3.Create(ls_syntax)
if li_ret = 1 then
	if ids_sys3.RowCount() = 0 then
		ids_sys3.InsertRow(0)
	end if
end if
end event

