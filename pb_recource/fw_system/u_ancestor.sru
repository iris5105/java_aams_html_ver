forward
global type u_ancestor from userobject
end type
end forward

global type u_ancestor from userobject
integer width = 1134
integer height = 572
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event oue_postopen ( )
event resize pbm_size
event mousemove pbm_mousemove
event type boolean oue_components ( )
end type
global u_ancestor u_ancestor

type variables
// - Common return value constants:
constant integer SUCCESS = 1
constant integer FAILURE = -1
constant integer NO_ACTION = 0

// - Continue/Prevent return value constants:
constant integer CONTINUE_ACTION = 1
constant integer PREVENT_ACTION = 0

Protected:
	window iw_parent

	pf_n_resize inv_resize
	fw_u_dwo		idw_target
	fw_n_style	inv_dwdesign
Public:
	boolean	SetMainFrameColor	= False
	boolean	SetSheetColor		= False
	boolean	SetCondColor		= False
	boolean	SetFreeFormColor	= False
	boolean	i----------------------------------------------------line01/* empty Object */
	boolean	FixedToRight
	boolean	FixedToBottom
	boolean	ScaleToRight
	boolean	ScaleToBottom
	boolean	i----------------------------------------------------line02/* empty Object */

end variables

forward prototypes
public function string of_thisname ()
public function integer of_setresize (boolean ab_switch)
public subroutine of_setbgcolor ()
public subroutine of_setpgmexpression (string as_pgm_no)
public subroutine of_initparent (window aw_parent, fw_u_dwo adw_datawindow, fw_n_style anv_style)
end prototypes

event resize;If IsValid (inv_resize) Then inv_resize.Event pfc_Resize (sizetype, newwidth, newheight)
end event

event mousemove;If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname())
end event

event type boolean oue_components();Return true

end event

public function string of_thisname ();return 'u_ancestor'

end function

public function integer of_setresize (boolean ab_switch);integer	li_rc

// Check arguments
if IsNull (ab_switch) then
	return -1
end if

if ab_Switch then
	if not IsValid (inv_resize) then
		inv_resize = create pf_n_resize
		inv_resize.of_SetOrigSize(this.width, this.height)
		inv_resize.of_AutoResizeRegister(this)
		li_rc = 1
	end if
else
	if IsValid (inv_resize) then
		destroy inv_resize
		li_rc = 1
	end if
end If

return li_rc

end function

public subroutine of_setbgcolor ();If SetMainFrameColor	= True Then fw_f_setcontrolbackcolor(This, gnv_vari.framebackcolor)
If SetSheetColor		= True Then fw_f_setcontrolbackcolor(This, gnv_vari.sheetbackcolor)
If SetCondColor		= True Then fw_f_setcontrolbackcolor(This, gnv_vari.setcondbackcolor)
If SetFreeFormColor	= True Then fw_f_setcontrolbackcolor(This, gnv_vari.setfreebackcolor)
end subroutine

public subroutine of_setpgmexpression (string as_pgm_no);
end subroutine

public subroutine of_initparent (window aw_parent, fw_u_dwo adw_datawindow, fw_n_style anv_style);// parent datawindow / window 등록
iw_parent		= aw_parent
idw_target		= adw_datawindow
inv_dwdesign	= anv_style
end subroutine

on u_ancestor.create
end on

on u_ancestor.destroy
end on

event constructor;// Get Parent Window
iw_parent = fw_f_obj4parentwindow(this)

// Resize 설정
of_setresize(true)

// Arrange Controls
event resize(0, this.width, this.height)

This.of_setbgcolor() /* to-be */

// PostOpen 이벤트 호출
Post Event oue_postopen()

end event

