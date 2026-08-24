forward
global type w_sys from window
end type
type dw_sys_3 from datawindow within w_sys
end type
type dw_sys_2 from datawindow within w_sys
end type
type dw_sys_0 from datawindow within w_sys
end type
type dw_sys_1 from datawindow within w_sys
end type
type st_temp from statictext within w_sys
end type
end forward

global type w_sys from window
boolean visible = false
integer width = 2757
integer height = 748
boolean titlebar = true
string title = "Untitled"
long backcolor = 67108864
string icon = "AppIcon!"
dw_sys_3 dw_sys_3
dw_sys_2 dw_sys_2
dw_sys_0 dw_sys_0
dw_sys_1 dw_sys_1
st_temp st_temp
end type
global w_sys w_sys

forward prototypes
public function long wf_get_col_height_font (integer ai_col_width, string str, string font_name, boolean font_italic, integer font_underline, integer font_weight, integer font_size, integer units)
public function DataWindow wf_get_dw (integer ai_units)
end prototypes

public function long wf_get_col_height_font (integer ai_col_width, string str, string font_name, boolean font_italic, integer font_underline, integer font_weight, integer font_size, integer units);string ls_val
integer ret = 0
DataWindow ldw
ldw = wf_get_dw(units)

ldw.object.str_col.Height = 0
ldw.object.str_col.Width = ai_col_width
ldw.object.DataWindow.Detail.Height = 0

ldw.object.str_col.Font.Face = font_name //??? ??????
ldw.object.str_col.Font.Italic = font_italic
if font_underline = 0 then
	ldw.object.str_col.Font.Underline = false
else
	ldw.object.str_col.Font.Underline = true
end if
ldw.object.str_col.Font.Weight = font_weight
ldw.object.str_col.Font.Height = -abs(font_size)

ldw.object.str_col[1] = str
ret = long(ldw.Describe("evaluate('rowheight()', 1)"))
ret = PixelsToUnits(UnitsToPixels(ret, YUnitsToPixels!), YPixelsToUnits!) + 7

return ret
end function

public function DataWindow wf_get_dw (integer ai_units);choose case ai_units
	case 0
		return dw_sys_0
	case 1
		return dw_sys_1
	case 2
		return dw_sys_2
	case 3
		return dw_sys_3
	case else
		return dw_sys_0		
end choose

end function

on w_sys.create
this.dw_sys_3=create dw_sys_3
this.dw_sys_2=create dw_sys_2
this.dw_sys_0=create dw_sys_0
this.dw_sys_1=create dw_sys_1
this.st_temp=create st_temp
this.Control[]={this.dw_sys_3,&
this.dw_sys_2,&
this.dw_sys_0,&
this.dw_sys_1,&
this.st_temp}
end on

on w_sys.destroy
destroy(this.dw_sys_3)
destroy(this.dw_sys_2)
destroy(this.dw_sys_0)
destroy(this.dw_sys_1)
destroy(this.st_temp)
end on

event open;integer li_ret
string ls_syntax

// PB Units
ls_syntax = &
'	release 12.6;~r~n' + &
'	datawindow(units=0 processing=0)~r~n' + &
'	summary(height=0 color="536870912" )~r~n' + &
'	footer(height=0 color="536870912" )~r~n' + &
'	detail(height=0 color="536870912"  height.autosize=yes)~r~n' + &
'	table(column=(type=char(32000) updatewhereclause=yes name=str_col dbname="str_col" )~r~n' + &
'	 )~r~n' + &
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="5" y="4" height="76" width="302" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autohscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = dw_sys_0.Create(ls_syntax)
if li_ret = 1 then
	if dw_sys_0.RowCount() = 0 then
		dw_sys_0.InsertRow(0)
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
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="1" y="1" height="19" width="66" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autohscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = dw_sys_1.Create(ls_syntax)
if li_ret = 1 then
	if dw_sys_1.RowCount() = 0 then
		dw_sys_1.InsertRow(0)
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
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="10" y="10" height="197" width="687" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autohscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = dw_sys_2.Create(ls_syntax)
if li_ret = 1 then
	if dw_sys_2.RowCount() = 0 then
		dw_sys_2.InsertRow(0)
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
'	column(band=detail id=1 alignment="0" tabsequence=10 border="0" color="33554432" x="26" y="27" height="502" width="1746" format="[general]" name=str_col visible="1" height.autosize=yes edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autohscroll=yes edit.imemode=0  font.face="Arial" font.height="-10" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912")'
li_ret = dw_sys_3.Create(ls_syntax)
if li_ret = 1 then
	if dw_sys_3.RowCount() = 0 then
		dw_sys_3.InsertRow(0)
	end if
end if

end event

type dw_sys_3 from datawindow within w_sys
integer y = 392
integer width = 2629
integer height = 112
integer taborder = 20
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sys_2 from datawindow within w_sys
integer y = 268
integer width = 2629
integer height = 112
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sys_0 from datawindow within w_sys
integer y = 20
integer width = 2629
integer height = 112
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sys_1 from datawindow within w_sys
integer y = 144
integer width = 2629
integer height = 112
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_temp from statictext within w_sys
boolean visible = false
integer x = 1015
integer y = 208
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "0"
boolean focusrectangle = false
end type

