forward
global type w_loadingfind from window
end type
type p_1 from picture within w_loadingfind
end type
end forward

global type w_loadingfind from window
integer width = 274
integer height = 240
boolean border = false
windowtype windowtype = popup!
boolean palettewindow = true
boolean center = true
p_1 p_1
end type
global w_loadingfind w_loadingfind

type variables

end variables
on w_loadingfind.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_loadingfind.destroy
destroy(this.p_1)
end on

type p_1 from picture within w_loadingfind
integer width = 274
integer height = 240
boolean originalsize = true
string picturename = "..\img\mainframe\loading\loadingfind.gif"
boolean focusrectangle = false
end type

