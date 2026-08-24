forward
global type w_loadingopen from window
end type
type p_1 from picture within w_loadingopen
end type
end forward

global type w_loadingopen from window
integer width = 731
integer height = 640
boolean border = false
windowtype windowtype = popup!
boolean palettewindow = true
boolean center = true
p_1 p_1
end type
global w_loadingopen w_loadingopen

type variables

end variables

on w_loadingopen.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_loadingopen.destroy
destroy(this.p_1)
end on

event mousemove;Send (handle(THIS),274,61458,0)
end event

type p_1 from picture within w_loadingopen
integer width = 731
integer height = 640
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\mainframe\loading\loading4.gif"
boolean focusrectangle = false
end type

