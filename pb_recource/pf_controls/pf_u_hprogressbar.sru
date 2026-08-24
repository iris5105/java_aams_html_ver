forward
global type pf_u_hprogressbar from datawindow
end type
end forward

global type pf_u_hprogressbar from datawindow
integer width = 1477
integer height = 76
string dataobject = "pf_d_hscrollbar"
boolean border = false
borderstyle borderstyle = stylelowered!
event type boolean oue_components ( )
end type
global pf_u_hprogressbar pf_u_hprogressbar

type variables
constant integer MINPOSITION = 0
constant integer MAXPOSITION = 100

public:
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables

forward prototypes
public subroutine of_setposition (long al_position)
public subroutine of_setminposition (long al_position)
public subroutine of_setmaxposition (long al_position)
public function string of_thisname ()
end prototypes

event type boolean oue_components();return true

end event

public subroutine of_setposition (long al_position);this.setitem(1, "cur_pos", al_position)
this.setredraw(true)

end subroutine

public subroutine of_setminposition (long al_position);this.setitem(1, "min_pos", al_position)

end subroutine

public subroutine of_setmaxposition (long al_position);this.setitem(1, "max_pos", al_position)

end subroutine

public function string of_thisname ();return 'pf_u_hprogressbar'

end function

on pf_u_hprogressbar.create
end on

on pf_u_hprogressbar.destroy
end on

event constructor;string ls_modify
long ll_xpos, ll_ypos, ll_width, ll_height

ll_width = long(this.describe("c_percent.width"))
ll_height = long(this.describe("c_percent.height"))
ll_xpos = (this.width - ll_width) / 2
ll_ypos = (this.height - ll_height) / 2

ls_modify = "t_background.width = " + string(this.width) + "~r~n"
ls_modify += "t_background.height = " + string(this.height) + "~r~n"
ls_modify += "t_percent.height = " + string(this.height) + "~r~n"
ls_modify += "c_percent.x = " + string(ll_xpos) + "~r~n"
ls_modify += "c_percent.y = " + string(ll_ypos) + "~r~n"
ls_modify += "datawindow.header.height = " + string(this.height) + "~r~n"

this.modify(ls_modify)

this.insertrow(0)
this.setitem(1, 'max_width', this.width)

of_setminposition(MINPOSITION)
of_setmaxposition(MAXPOSITION)

end event

