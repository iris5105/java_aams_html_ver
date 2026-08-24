forward
global type n_loadingyield from timing
end type
end forward

global type n_loadingyield from timing
end type
global n_loadingyield n_loadingyield

type variables

end variables

forward prototypes
public function integer uf_start ()
end prototypes

public function integer uf_start ();OPEN (w_loadingyield)
w_loadingyield.y += 500
RETURN	start(1)
end function

on n_loadingyield.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_loadingyield.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event timer;w_loadingyield.st_1.text = '(' + string (w_loadingyield.iTime, 'hh:mm:ss') + ')'

LONG	ll_ss

STRING	ls_ss

ll_ss = SecondsAfter (w_loadingyield.iTime, now ())
IF	truncate (ll_ss/60,0)=0	Then
	ls_ss = string (ll_ss) + '초'
Else
	IF	ll_ss = truncate (ll_ss/60,0) * 60	Then
		ls_ss = string (truncate (ll_ss/60,0)) + '분'
	Else
		ls_ss = string (truncate (ll_ss/60,0)) + '분' + string (ll_ss - truncate (ll_ss/60,0) * 60) + '초'
	End IF
End IF

w_loadingyield.st_2.text = ls_ss + '경과'
end event

