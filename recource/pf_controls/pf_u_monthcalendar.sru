forward
global type pf_u_monthcalendar from monthcalendar
end type
end forward

global type pf_u_monthcalendar from monthcalendar
integer width = 1006
integer height = 648
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long titletextcolor = 134217742
long trailingtextcolor = 67108864
long monthbackcolor = 1073741824
long titlebackcolor = 134217741
weekday firstdayofweek = sunday!
integer maxselectcount = 31
integer scrollrate = 1
boolean todaysection = true
boolean todaycircle = true
borderstyle borderstyle = stylelowered!
event type boolean oue_components ( )
event mousemove pbm_mousemove
event oue_mouseover ( )
event oue_mouseleave ( )
event oue_postopen ( )
event timer pbm_timer
end type
global pf_u_monthcalendar pf_u_monthcalendar

type variables
private:
	window iw_parent
	pf_n_timing inv_timer
	
	boolean ib_mouseover
	pf_s_point istr_point

public:
	powerobject ipo_referencedobject[]

	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables

forward prototypes
public function string of_thisname ()
end prototypes

event type boolean oue_components();return true

end event

event mousemove;if ib_mouseover = false then
	ib_mouseover = true
	this.event oue_mouseover()
	inv_timer.of_start()
end if

end event

event timer;if gnv_extfunc.GetCursorPos(istr_point) then
	if gnv_extfunc.ScreenToClient(handle(this), istr_point) then
		if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(this.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(this.height, yunitstopixels!) then
		else
			ib_mouseover = false
			inv_timer.stop()
			this.post event oue_mouseleave()
		end if
	end if
end if

end event

public function string of_thisname ();return 'pf_u_monthcalendar'

end function

on pf_u_monthcalendar.create
end on

on pf_u_monthcalendar.destroy
end on

event constructor;// get parent window
iw_parent = fw_f_obj4parentwindow(this)

// properties monitor
inv_timer = create pf_n_timing
inv_timer.of_initialize(this)

// postopen event
this.post event oue_postopen()

end event

