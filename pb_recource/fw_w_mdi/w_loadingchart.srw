forward
global type w_loadingchart from window
end type
type p_1 from picture within w_loadingchart
end type
end forward

global type w_loadingchart from window
integer width = 274
integer height = 240
boolean border = false
windowtype windowtype = popup!
long backcolor = 16777215
boolean palettewindow = true
boolean center = true
p_1 p_1
end type
global w_loadingchart w_loadingchart

type variables

end variables
on w_loadingchart.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_loadingchart.destroy
destroy(this.p_1)
end on

type p_1 from picture within w_loadingchart
integer width = 274
integer height = 240
integer transparency = 10
boolean originalsize = true
string picturename = "..\img\mainframe\loading\loadingchart.gif"
boolean focusrectangle = false
end type

