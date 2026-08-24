forward
global type fw_n_animate from nonvisualobject
end type
end forward

global type fw_n_animate from nonvisualobject
end type
global fw_n_animate fw_n_animate

type prototypes
Function boolean AnimateWindow(ulong lhWnd, long lTm, long lFlags) Library 'user32.dll'

end prototypes

type variables
// 스크롤 방향
Constant Integer TopDown = 1		// 위에서 아래로
Constant Integer LeftToRight = 2	// 좌에서 우로
Constant Integer RightToLeft = 3	// 우에서 좌로
Constant Integer BottomUp = 4		// 아래에서 위로

// 스크롤 시간
Constant Long ANIMATE_TIME = 200

// 스크롤 대상 오브젝트
PowerObject ipo_Target
//DragObject ipo_Target

// 기본 스크롤 방향
Integer ii_direction = TopDown

end variables

forward prototypes
public function long of_getanimateflag (boolean ab_hide)
public function boolean of_hide ()
public function boolean of_show ()
public function long of_getanimateflag (integer ai_direction, boolean ab_hide)
public function boolean of_hide (readonly powerobject lpo_target)
public function boolean of_hide (readonly powerobject lpo_target, integer ai_direction)
public subroutine of_initialize (readonly powerobject apo_target)
public subroutine of_initialize (readonly powerobject apo_target, integer ai_direction)
public function boolean of_show (readonly powerobject lpo_target, integer ai_direction)
public function boolean of_show (readonly powerobject lpo_target)
end prototypes

public function long of_getanimateflag (boolean ab_hide);return this.of_getanimateflag(ii_Direction, ab_hide)

end function

public function boolean of_hide ();return this.of_hide(ipo_target, ii_direction)

end function

public function boolean of_show ();return this.of_show(ipo_target, ii_direction)

end function

public function long of_getanimateflag (integer ai_direction, boolean ab_hide);// Animate the window from left to right
Constant Long AW_HOR_POSITIVE = 1
// Animate the window from right to left
Constant Long AW_HOR_NEGATIVE = 2 
// Animate the window from top to bottom
Constant Long AW_VER_POSITIVE = 4 
// Animate the window from bottom to
Constant Long AW_VER_NEGATIVE = 8
// Makes the window appear to collapse inward
Constant Long AW_CENTER = 16
// Hides the window
Constant Long AW_HIDE = 65536
// Activates the window
Constant Long AW_ACTIVATE = 131072
// Uses slide animation
Constant Long AW_SLIDE = 262144
// Uses a fade effect
Constant Long AW_BLEND = 524288

Long ll_rv

CHOOSE CASE ai_Direction
	CASE TopDown
		IF ab_hide THEN
			ll_rv = AW_SLIDE + AW_VER_NEGATIVE + AW_HIDE
		ELSE
			ll_rv = AW_SLIDE + AW_VER_POSITIVE + AW_ACTIVATE
		END IF
	CASE LeftToRight
		IF ab_hide THEN
			ll_rv = AW_SLIDE + AW_HOR_NEGATIVE + AW_HIDE
		ELSE
			ll_rv = AW_SLIDE + AW_HOR_POSITIVE + AW_ACTIVATE
		END IF
	CASE RightToLeft
		IF ab_hide THEN
			ll_rv = AW_SLIDE + AW_HOR_POSITIVE + AW_HIDE
		ELSE
			ll_rv = AW_SLIDE + AW_HOR_NEGATIVE + AW_ACTIVATE
		END IF
	CASE BottomUp
		IF ab_hide THEN
			ll_rv = AW_SLIDE + AW_VER_POSITIVE + AW_HIDE
		ELSE
			ll_rv = AW_SLIDE + AW_VER_NEGATIVE + AW_ACTIVATE
		END IF
END CHOOSE

RETURN ll_rv
end function

public function boolean of_hide (readonly powerobject lpo_target);return this.of_hide(lpo_target, ii_direction)

end function

public function boolean of_hide (readonly powerobject lpo_target, integer ai_direction);Long	ll_Handle
Boolean lb_retval

setnull(lb_retval)
if not isvalid(lpo_target) then
	messagebox('Notice(pf_n_animate.of_hide)', '대상 오브젝트가 선언되지 않았습니다')
	return lb_retval
end if
if not isvalid(lpo_target) then return lb_retval
ll_Handle = Handle(lpo_target)
AnimateWindow(ll_Handle, ANIMATE_TIME, of_GetAnimateFlag(ai_direction, True)) 
//lpo_target.SetRedraw(True)

//lb_retval = lpo_target.visible
Return lb_retval

end function

public subroutine of_initialize (readonly powerobject apo_target);// 대상 오브젝트 설정
ipo_target = apo_target

end subroutine

public subroutine of_initialize (readonly powerobject apo_target, integer ai_direction);// 대상 오브젝트 설정
ipo_target = apo_target

// 스크롤 방향설정
ii_direction = ai_direction

end subroutine

public function boolean of_show (readonly powerobject lpo_target, integer ai_direction);Long ll_handle
Boolean lb_retval

setnull(lb_retval)
if not isvalid(lpo_target) then
	messagebox('Notice(pf_n_animate.of_show)', '대상 오브젝트가 선언되지 않았습니다')
	return lb_retval
end if

ll_handle = Handle(lpo_target)
AnimateWindow(ll_Handle, ANIMATE_TIME, of_GetAnimateFlag(ai_direction, False))
//lpo_target.SetRedraw(True)

//lb_retval = lpo_target.visible
Return lb_retval

end function

public function boolean of_show (readonly powerobject lpo_target);return this.of_show(lpo_target, ii_direction)

end function

on fw_n_animate.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_animate.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

