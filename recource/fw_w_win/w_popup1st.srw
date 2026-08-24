forward
global type w_popup1st from window
end type
type ln_tempbutton from line within w_popup1st
end type
type ln_tempstart from line within w_popup1st
end type
type ln_templeft from line within w_popup1st
end type
type ln_cond_start from line within w_popup1st
end type
type ln_tempright from line within w_popup1st
end type
type ln_cond1_yline from line within w_popup1st
end type
type ln_dw1_yline from line within w_popup1st
end type
end forward

global type w_popup1st from window
integer width = 3611
integer height = 2108
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
string icon = "AppIcon!"
boolean center = true
event pfe_postopen ( )
event pfe_openafter ( )
ln_tempbutton ln_tempbutton
ln_tempstart ln_tempstart
ln_templeft ln_templeft
ln_cond_start ln_cond_start
ln_tempright ln_tempright
ln_cond1_yline ln_cond1_yline
ln_dw1_yline ln_dw1_yline
end type
global w_popup1st w_popup1st

type variables
// 공통 리턴값 상수
constant integer SUCCESS = 1
constant integer FAILURE = -1
constant integer NO_ACTION = 0

// 계속/중지 리턴값 상수
constant integer CONTINUE_ACTION = 1
constant integer PREVENT_ACTION = 0

private:
	windowobject		iwo_control[]
	pf_n_buttonrole	inv_auth

public:
	window	iw_parent
	n_menu	inv_menu

end variables

forward prototypes
public function string of_thisname ()
public subroutine of_getcontrols (graphicobject a_control, ref graphicobject a_controls[])
public function windowobject of_getwindowobjectbyname (string as_objname)
public function string of_getpgmno ()
public function integer of_setauthority (boolean ab_switch)
public subroutine of_getwindowobjects (ref windowobject awo_object[])
public function string of_getpgmnm ()
public subroutine wf_setenabled ()
end prototypes

event pfe_postopen();Post Event pfe_openafter()
end event

event pfe_openafter();//pfe_openafter
end event

public function string of_thisname ();return 'w_popup1st'
end function

public subroutine of_getcontrols (graphicobject a_control, ref graphicobject a_controls[]);// 윈도우의 컨트롤을 배열형태로 구합니다. Tab, UserObject 컨트롤과 그 안에 위치한 컨트롤을 포함합니다.
// a_controls[] 는 반드시 초기화된 상태로 호출해야 합니다. 이 함수는 Recursive 형태로 구동되기 때문에 내부적으로 초기화하지 않습니다.

window	lw_current
tab		ltab_current
userobject	luo_current
long	ll_previous_elements, ll_total_elements, i

ll_previous_elements = UpperBound(a_controls)

choose case a_control.TypeOf()
	case Window!
		lw_current = a_control
		for i = 1 to UpperBound(lw_current.Control)
			a_controls[UpperBound(a_controls) + 1] = lw_current.Control[i]
		next
	case Tab!
		ltab_current = a_control
		for i = 1 to UpperBound(ltab_current.Control)
			a_controls[UpperBound(a_controls) + 1] = ltab_current.Control[i]
		next
	case UserObject!
		luo_current = a_control
		for i = 1 to UpperBound(luo_current.Control)
			a_controls[UpperBound(a_controls) + 1] = luo_current.Control[i]
		next
	case else
		return
end choose

ll_total_elements = UpperBound(a_controls)

for i = ll_previous_elements + 1 to ll_total_elements
	choose case a_controls[i].TypeOf()
		case Window!, Tab!, UserObject!
			this.of_getcontrols(a_controls[i], a_controls)
	end choose
next
end subroutine

public function windowobject of_getwindowobjectbyname (string as_objname);// 윈도우가 포함하고있는 컨트롤 중에 as_objname과 동일한
// 명칭을 가지는 오브젝트를 리턴합니다.

integer	i, li_cnter
windowobject	lwo_ret

li_cnter  = upperbound(iwo_control)
for  i  = 1 to  li_cnter
	if  iwo_control[i].classname() = as_objname  then
		lwo_ret = iwo_control[i]
		exit
	end  if
next

return lwo_ret

end function

public function string of_getpgmno ();if isvalid(inv_menu) then
	return inv_menu.is_pgm_no
else
	return ''
end if
end function

public function integer of_setauthority (boolean ab_switch);integer	li_rc

// Check arguments
if IsNull (ab_switch) then
	return -1
end if

if ab_Switch then
	if not IsValid (inv_auth) then
		inv_auth = create pf_n_buttonrole
		inv_auth.of_registerparent(this)
	end if
else
	if IsValid (inv_auth) then
		destroy inv_auth
		li_rc = 1
	end if
end If

return li_rc

end function

public subroutine of_getwindowobjects (ref windowobject awo_object[]);// get window controls
if upperbound(iwo_control) = 0 then
	this.of_getcontrols(this, awo_object[])
end if
end subroutine

public function string of_getpgmnm ();if isvalid(inv_menu) then
	return inv_menu.is_pgm_nm
else
	return ''
end if
end function

public subroutine wf_setenabled ();
end subroutine

on w_popup1st.create
this.ln_tempbutton=create ln_tempbutton
this.ln_tempstart=create ln_tempstart
this.ln_templeft=create ln_templeft
this.ln_cond_start=create ln_cond_start
this.ln_tempright=create ln_tempright
this.ln_cond1_yline=create ln_cond1_yline
this.ln_dw1_yline=create ln_dw1_yline
this.Control[]={this.ln_tempbutton,&
this.ln_tempstart,&
this.ln_templeft,&
this.ln_cond_start,&
this.ln_tempright,&
this.ln_cond1_yline,&
this.ln_dw1_yline}
end on

on w_popup1st.destroy
destroy(this.ln_tempbutton)
destroy(this.ln_tempstart)
destroy(this.ln_templeft)
destroy(this.ln_cond_start)
destroy(this.ln_tempright)
destroy(this.ln_cond1_yline)
destroy(this.ln_dw1_yline)
end on

event open;// get pgm_no of this window
inv_menu = create n_menu

if gnv_rolemenu.of_getmenudata_by_pgmid(upper(this.classname()), inv_menu) = 0 then
	inv_menu.is_pgm_id = this.classname()
	
	if len(trim(this.title)) > 0 then
		inv_menu.is_pgm_nm = this.title
	else
		inv_menu.is_pgm_nm = this.classname()
	end if
end if

// Call Post Open Event
Post Event pfe_postopen()
end event

type ln_tempbutton from line within w_popup1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 32
integer endx = 4722
integer endy = 32
end type

type ln_tempstart from line within w_popup1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 140
integer endx = 4722
integer endy = 140
end type

type ln_templeft from line within w_popup1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 37
integer endx = 37
integer endy = 3140
end type

type ln_cond_start from line within w_popup1st
boolean visible = false
long linecolor = 255
integer linethickness = 4
integer beginy = 168
integer endx = 4722
integer endy = 168
end type

type ln_tempright from line within w_popup1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 3566
integer endx = 3566
integer endy = 3140
end type

type ln_cond1_yline from line within w_popup1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 320
integer endx = 4873
integer endy = 320
end type

type ln_dw1_yline from line within w_popup1st
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 348
integer endx = 4873
integer endy = 348
end type

