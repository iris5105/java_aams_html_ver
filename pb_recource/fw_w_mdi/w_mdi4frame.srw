forward
global type w_mdi4frame from window
end type
type mdi_1 from mdiclient within w_mdi4frame
end type
type st_mdiclient from pf_u_statictext within w_mdi4frame
end type
end forward

global type w_mdi4frame from window
integer width = 4014
integer height = 2908
boolean titlebar = true
string title = "penta"
string menuname = "m_empty"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdi!
string icon = "AppIcon!"
boolean toolbarvisible = false
boolean center = true
event wue_postopen ( )
mdi_1 mdi_1
st_mdiclient st_mdiclient
end type
global w_mdi4frame w_mdi4frame

type variables
// 공통 리턴값 상수
constant integer SUCCESS = 1
constant integer FAILURE = -1
constant integer NO_ACTION = 0

// 계속/중지 리턴값 상수
constant integer CONTINUE_ACTION = 1
constant integer PREVENT_ACTION = 0

private:
   BOOLEAN	ib_resize = FALSE

protected:
   pf_n_resize inv_resize

   window   iw_mwindow, iw_mchild, iw_mgetactivesheet

Public:
   /* to-be topmenu variable */
   STRING	is_obj4topmenu
   STRING	is_obj4submenu
end variables

forward prototypes
public function integer of_setresize (boolean ab_switch)
public function string of_thisname ()
public subroutine of_setmdiclientborder (integer ai_borderstyle)
public function integer of_checkactivesheetstate ()
public function windowobject of_getwindowobjectbyname (string as_objname)
public subroutine of_ctlssetredraw (boolean ab_boolean)
public function long of_setdynamicevent (string as_objectname, string as_eventname, n_menu anvo_menudata)
public subroutine of_setmenu4top (string as_gb, string as_menu)
public subroutine of_opensheetwithparm (string as_window, long al_arg)
public subroutine of_opensheetwithparm (string as_window, string as_arg)
public subroutine of_opensheetwithparm (string as_window, structure astr_arg)
end prototypes

event wue_postopen();ib_resize = true
st_mdiclient.BringToTop = False

fw_f_setparentwindowinit() /* gnv_vari.iwparent clear */

fw_f_messageclear() /* messageparm clear */

end event

public function integer of_setresize (boolean ab_switch);integer	li_rc

// Check arguments
if IsNull (ab_switch) then
	return -1
end if

if ab_Switch then
	if not IsValid (inv_resize) then
		inv_resize = create pf_n_resize
		inv_resize.of_SetOrigSize(This.Width, This.Height) //(This.WorkSpaceWidth(), This.WorkSpaceHeight())
		inv_resize.of_SetMinSize(PixelsToUnits(1024, XPixelsToUnits!), PixelsToUnits(768, YPixelsToUnits!))
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

public function string of_thisname ();return 'w_mdiancestor'

end function

public subroutine of_setmdiclientborder (integer ai_borderstyle);// setmdiclientborder
gnv_extfunc.biz_setmdiclientborder(handle(mdi_1), ai_borderstyle)

end subroutine

public function integer of_checkactivesheetstate ();// Sheet 윈도우 Open시 Close(This) 명령이 수행되면 WindowState가 Maximized -> Normal 상태로 변경됨
// 상태 체크 후 원래대로 Maximized 처리
window lw_activesheet
string mtext

lw_activesheet = This.GetActiveSheet()
IF IsValid(lw_activesheet) THEN
	IF lw_activesheet.windowstate <> Maximized! THEN
		lw_activesheet.windowstate = Maximized!
	END IF
END IF

Return 0

end function

public function windowobject of_getwindowobjectbyname (string as_objname);// 윈도우가 포함하고있는 컨트롤 중에 as_objname과 동일한
// 명칭을 가지는 오브젝트를 리턴합니다.

integer i, li_cnter
windowobject lwo_ret

li_cnter  = upperbound(this.control)
for  i  = 1 to  li_cnter
	if  this.control[i].classname() = as_objname  then
		lwo_ret = this.control[i]
		exit
	end  if
next

return lwo_ret

end function

public subroutine of_ctlssetredraw (boolean ab_boolean);
end subroutine

public function long of_setdynamicevent (string as_objectname, string as_eventname, n_menu anvo_menudata);Return 1

end function

public subroutine of_setmenu4top (string as_gb, string as_menu); Choose Case as_gb
	Case '01'
		is_obj4topmenu = as_menu
	Case '02'
		is_obj4submenu = as_menu
End Choose
end subroutine

public subroutine of_opensheetwithparm (string as_window, long al_arg);window	lw_window
If fw_f_nvls(as_window, '') <> '' Then fw_f_closewindow(as_window)
OpenSheetWithParm(lw_window, al_arg, as_window, this, 0, Original!)
end subroutine

public subroutine of_opensheetwithparm (string as_window, string as_arg);window	lw_window
If fw_f_nvls(as_window, '') <> '' Then fw_f_closewindow(as_window)
OpenSheetWithParm(lw_window, as_arg, as_window, this, 0, Original!)

end subroutine

public subroutine of_opensheetwithparm (string as_window, structure astr_arg);window	lw_window
If fw_f_nvls(as_window, '') <> '' Then fw_f_closewindow(as_window)
OpenSheetWithParm(lw_window, astr_arg, as_window, this, 0, Original!)


end subroutine

on w_mdi4frame.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.st_mdiclient)
end on

event open;// MDI Client 설정
mdi_1.backcolor = rgb(255, 255, 255)
mdi_1.move(st_mdiclient.x, st_mdiclient.y)
this.of_setmdiclientborder(3)

// System Color 설정
fw_s_syscolor lstr_param
lstr_param.highlight = gnv_vari.setclearselectcolor
lstr_param.highlighttext = RGB(45,45,45)
lstr_param.btnface = RGB(210,210,210)
long tmp
tmp = gnv_extfunc.biz_setdefaultsystemcolor()
tmp = gnv_extfunc.of_setsyscolor(lstr_param)
ib_resize = false
this.of_setresize(true)

this.post event wue_postopen()

end event

event resize;If IsValid (inv_resize) Then inv_resize.Event pfc_Resize (sizetype, newwidth, newheight)
end event

on w_mdi4frame.create
if this.MenuName = "m_empty" then this.MenuID = create m_empty
this.mdi_1=create mdi_1
this.st_mdiclient=create st_mdiclient
this.Control[]={this.mdi_1,&
this.st_mdiclient}
end on

type mdi_1 from mdiclient within w_mdi4frame
long BackColor=268435456
end type

type st_mdiclient from pf_u_statictext within w_mdi4frame
event resize pbm_size
integer x = 133
integer y = 480
integer width = 3721
integer height = 2176
long bordercolor = 10789024
boolean setsheetcolor = true
boolean scaletoright = true
boolean scaletobottom = true
end type

event resize;mdi_1.width = this.width
mdi_1.height = this.height
end event

event move;call super::move;mdi_1.x = xpos
mdi_1.y = ypos
end event

