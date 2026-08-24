forward
global type fw_u_statebar4frame from u_ancestor
end type
type dw_statebar from fw_u_dwo within fw_u_statebar4frame
end type
end forward

global type fw_u_statebar4frame from u_ancestor
integer width = 5445
integer height = 104
long backcolor = 79741120
event type long oue_timer ( )
event oue_setwindowname ( string as_windowid )
event oue_setmessage ( string as_message )
dw_statebar dw_statebar
end type
global fw_u_statebar4frame fw_u_statebar4frame

type prototypes
FUNCTION long ShellExecuteW(ulong hWnd, string Operation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.dll"

end prototypes

type variables
private:
	
	int						iiv_Timer = 0

	datetime				ldtm_local

	datetime				idtm_starttime
	long					il_startcpu
end variables

forward prototypes
public subroutine of_setmessage (string as_message)
public subroutine of_setwindowname (string as_windowname)
public subroutine of_setclock (string as_clock)
public function integer of_printwindow ()
public subroutine of_changecolor (string as_color)
public subroutine of_showhelp ()
public subroutine of_setstarttime ()
public function integer of_setresize (boolean ab_switch)
public function string of_thisname ()
end prototypes

event type long oue_timer();datetime	ldtm_now
long		ll_nowcpu

ll_nowcpu = cpu()
//ldtm_now = inv_datetime.of_relativedatetime(idtm_starttime, (ll_nowcpu - il_startcpu) / 1000)
this.of_setclock(string(ldtm_now, 'YYYY-MM-DD hh:mm:ss'))
return 0

end event

event oue_setwindowname(string as_windowid);This.of_setwindowname(as_windowid)
end event

event oue_setmessage(string as_message);This.of_setmessage(as_message)

end event

public subroutine of_setmessage (string as_message);dw_statebar.setitem(1, 'msg_txt', as_message)
window	lw_sheet
lw_sheet = gw_mdi.GetActiveSheet( )
dw_statebar.setitem(1, 'pgm_id', lw_sheet.classname())
end subroutine

public subroutine of_setwindowname (string as_windowname);dw_statebar.setitem(1, 'pgm_id', as_windowname)

end subroutine

public subroutine of_setclock (string as_clock);dw_statebar.setitem(1, 'st_clock', as_clock)

end subroutine

public function integer of_printwindow ();Window	lw_toPrint
pf_n_screencapture ln_capture
Blob		lb_WinImg
String		ls_filename
Long		ll_rc

//lw_toPrint = iw_Parent.GetActiveSheet()
IF Not IsValid(lw_toPrint) THEN
	MessageBox('Notice', '인쇄 할 수 있는 윈도우가 존재하지 않습니다.')
	Return -1
END IF

// 화면 캡쳐
lb_WinImg = ln_capture.of_WindowCapture(lw_toPrint, False)
IF Len(lb_WinImg) = 0 THEN
	MessageBox('Notice', '윈도우를 캡쳐실패로 화면을 인쇄할 수 없습니다.')
	Return -2
END IF

// BMP 파일 저장
ls_filename = ln_capture.of_getTempPath() + "\" + lw_toPrint.ClassName() + "_" + String(today(), 'yyyymmddhhmmss') + ".bmp"

Sleep(0.2)

IF ln_capture.of_writeBlob(ls_filename, lb_WinImg) < 0 THEN
	MessageBox('Notice', '윈도우 캡쳐파일을 저장할 수 없습니다.')
	Return -3
END IF


Return ll_rc

end function

public subroutine of_changecolor (string as_color);
end subroutine

public subroutine of_showhelp ();//window	lw_active
//
//lw_active = iw_Parent.GetActiveSheet()
//if not isvalid(lw_active) then return
//
//openwithparm(w_popup_help, lw_active.classname(), iw_parent)

end subroutine

public subroutine of_setstarttime ();//idtm_starttime = f_get_localtime('gniscn/n_dw')
il_startcpu = cpu()

end subroutine

public function integer of_setresize (boolean ab_switch);integer	li_rc

// Check arguments
if IsNull (ab_switch) then
	return -1
end if

if ab_Switch then
	if not IsValid (inv_resize) then
		inv_resize = create pf_n_resize
		inv_resize.of_SetOrigSize(4375, 104)
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

public function string of_thisname ();return 'fw_u_statebar4frame'

end function

on fw_u_statebar4frame.create
int iCurrent
call super::create
this.dw_statebar=create dw_statebar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_statebar
end on

on fw_u_statebar4frame.destroy
call super::destroy
destroy(this.dw_statebar)
end on

event resize;call super::resize;// Set Resize
Long	ll_x, ll_x2, ll_wkWidth

dw_statebar.x = 0
dw_statebar.y = 0
dw_statebar.Width = newwidth
dw_statebar.Height = newheight

ll_wkwidth = newwidth
dw_statebar.modify("p_background.width=" + string(ll_wkwidth))

ll_x = ll_wkWidth - long(dw_statebar.describe("pgm_id.width")) - pixelstounits(10, xpixelstounits!)
dw_statebar.modify("pgm_id.x=" + string(ll_x))

ll_x = ll_x - long(dw_statebar.describe("p_pgm_icon.width")) - PixelsToUnits(10, XPixelsToUnits!)
dw_statebar.modify("p_pgm_icon.x=" + string(ll_x))

//ll_x2 = PixelsToUnits(10, XPixelsToUnits!) 
//dw_statebar.modify("p_msg_icon.x=" + string(ll_x2))

ll_x2 = ll_x2 + long(dw_statebar.describe("p_msg_icon.width"))  + PixelsToUnits(10, XPixelsToUnits!)
dw_statebar.modify("msg_txt.x=" + string(ll_x2))
dw_statebar.modify("msg_txt.width=" + String(ll_x - ll_x2))

end event

event oue_postopen;call super::oue_postopen;dw_statebar.modify("p_background.y=-4")
dw_statebar.insertrow(0)

// 지역(DB) 시간 설정
//this.of_setstarttime()

// 타이머 설정
//inv_timer = Create n_Timing
//inv_timer.event ue_setparent(This, 'ue_timer')
//inv_timer.Start(1)

end event

type dw_statebar from fw_u_dwo within fw_u_statebar4frame
integer width = 5445
integer height = 104
integer taborder = 10
string dataobject = "fw_d_statebar4frame"
boolean border = false
boolean livescroll = false
boolean scaletoright = true
end type

event clicked;//String		ls_excel
//Window	lw_toExcel
//
//CHOOSE CASE dwo.name
//	CASE 'p_excel'
//		IF RegistryGet("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\excel.exe", "", RegString!, ls_excel) = 1 THEN
//			Run(ls_excel)
//		ELSE
//			Run("excel.exe")
//		END IF
//		
////		lw_toExcel = iw_Parent.GetActiveSheet()
////		IF Not IsValid(lw_toExcel) THEN
////			MessageBox('Notice', '엑셀저장 할 수 있는 윈도우가 존재하지 않습니다.')
////			Return -1
////		END IF
////		
////		lw_toExcel.dynamic event ue_excel()
//		
//	CASE 'p_calc'
//		Run("calc.exe")
//		
//	CASE 'p_print'
//		Parent.of_PrintWindow()
//		
//	CASE 'p_help'
//		Parent.of_ShowHelp()
//END CHOOSE
//
//Return 0
//
end event

event resize;call super::resize;//// Set Resize
//Long	ll_x, ll_x2, ll_wkWidth
//
//ll_wkwidth = newwidth
//dw_msg.modify("p_background.width=" + string(ll_wkwidth))
//
//ll_x = ll_wkWidth - long(dw_msg.describe("pgm_id.width")) - pixelstounits(10, xpixelstounits!)
//dw_msg.modify("pgm_id.x=" + string(ll_x))
//
//ll_x = ll_x - long(dw_msg.describe("p_pgm_icon.width")) - PixelsToUnits(10, XPixelsToUnits!)
//dw_msg.modify("p_pgm_icon.x=" + string(ll_x))
//
////ll_x2 = PixelsToUnits(10, XPixelsToUnits!) 
////dw_msg.modify("p_msg_icon.x=" + string(ll_x2))
//
//ll_x2 = ll_x2 + long(dw_msg.describe("p_msg_icon.width"))  + PixelsToUnits(10, XPixelsToUnits!)
//dw_msg.modify("msg_txt.x=" + string(ll_x2))
//dw_msg.modify("msg_txt.width=" + String(ll_x - ll_x2))

end event

