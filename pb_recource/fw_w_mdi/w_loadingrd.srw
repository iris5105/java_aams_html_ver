forward
global type w_loadingrd from window
end type
type p_1 from picture within w_loadingrd
end type
end forward

global type w_loadingrd from window
integer width = 315
integer height = 280
boolean border = false
windowtype windowtype = popup!
boolean palettewindow = true
boolean center = true
p_1 p_1
end type
global w_loadingrd w_loadingrd

type variables

end variables
on w_loadingrd.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_loadingrd.destroy
destroy(this.p_1)
end on

type p_1 from picture within w_loadingrd
integer x = 18
integer y = 20
integer width = 274
integer height = 240
boolean originalsize = true
string picturename = "..\img\mainframe\loading\loading6.gif"
boolean focusrectangle = false
end type

