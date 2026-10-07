forward
global type w_loadingretrieve from window
end type
type p_1 from picture within w_loadingretrieve
end type
end forward

global type w_loadingretrieve from window
integer width = 274
integer height = 240
boolean border = false
windowtype windowtype = popup!
boolean palettewindow = true
boolean center = true
p_1 p_1
end type
global w_loadingretrieve w_loadingretrieve

type variables

end variables
on w_loadingretrieve.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_loadingretrieve.destroy
destroy(this.p_1)
end on

type p_1 from picture within w_loadingretrieve
integer width = 274
integer height = 240
boolean originalsize = true
string picturename = "..\img\mainframe\loading\loadingretrieve.gif"
boolean focusrectangle = false
end type

