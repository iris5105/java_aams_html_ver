forward
global type w_loadingpage from window
end type
type p_1 from picture within w_loadingpage
end type
end forward

global type w_loadingpage from window
integer width = 274
integer height = 240
boolean border = false
windowtype windowtype = popup!
boolean palettewindow = true
boolean center = true
p_1 p_1
end type
global w_loadingpage w_loadingpage

type variables

end variables
on w_loadingpage.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_loadingpage.destroy
destroy(this.p_1)
end on

type p_1 from picture within w_loadingpage
integer width = 274
integer height = 240
boolean originalsize = true
string picturename = "..\img\mainframe\loading\loading9.gif"
boolean focusrectangle = false
end type

