forward
global type fw_u_userinfo4frame from fw_u_dwo
end type
end forward

global type fw_u_userinfo4frame from fw_u_dwo
integer width = 1006
integer height = 188
string dataobject = "fw_d_userinfo4frame"
boolean border = false
boolean livescroll = false
boolean setbringtotop = true
end type
global fw_u_userinfo4frame fw_u_userinfo4frame

type variables
Public:
	String	istooltiproledwo	= ''
end variables

forward prototypes
public function string of_thisname ()
public subroutine of_settooltiphelp (dwobject dwo, string as_obj, long al_xpos, long al_ypos)
end prototypes

public function string of_thisname ();return 'pfu_mdi_userinfo'
end function

public subroutine of_settooltiphelp (dwobject dwo, string as_obj, long al_xpos, long al_ypos);String	ls_tooltipdesc, ls_type, ls_syntax, ls_errmsg

ls_type = This.Describe(as_obj + ".Type")
Choose Case ls_type
	Case 'column', 'text'
		If ls_type='column' and ibsettooltipdata = True Then Return
		If Pos(This.Describe("Evaluate('LookUpDisplay(role_nm) ', "+ string(1) + ")"), 'more')=0 Then Return
		If istooltiproledwo=as_obj + 'role' Then Return
		ls_tooltipdesc = This.Describe(as_obj + '.tooltip.tip') + This.Describe("Evaluate('LookUpDisplay(role_nmlist) ', "+ string(1) + ")")
		ls_tooltipdesc = gaa.jTier_dbname + ' ' + ls_tooltipdesc
		If fw_f_nvls(ls_tooltipdesc, '') <> '' Then
			ls_syntax = as_obj + '.tooltip.delay.initial="0"~r~n'
			ls_syntax += as_obj + '.tooltip.enabled="1"~r~n'
			ls_syntax += as_obj + '.tooltip.backcolor="32567536"~r~n'
			ls_syntax += as_obj + '.tooltip.icon="1"~r~n'
			ls_syntax += as_obj + '.tooltip.isbubble="1"~r~n'
			ls_syntax += as_obj + '.tooltip.textcolor="19737901"~r~n'
			ls_syntax += as_obj + '.tooltip.title="Role"~r~n'
			ls_syntax += as_obj + '.tooltip.tip="' + ls_tooltipdesc + '"'
			ls_errmsg = This.Modify(ls_syntax)
			If fw_f_nvls(ls_errmsg, '') <> '' then
				Messagebox('function TooltipHelp Error', ls_errmsg)
				Return
			End If
		End If
		istooltiproledwo = as_obj + 'role' 
End Choose
end subroutine

on fw_u_userinfo4frame.create
call super::create
end on

on fw_u_userinfo4frame.destroy
call super::destroy
end on

event oue_postopen;call super::oue_postopen;this.Bringtotop = True
end event

event mousemove;If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname())

STRING	ls_obj

ls_obj = fw_f_nvls(lower(dwo.name), 'datawindow')
If ls_obj='role_nm' And isValid(dwo) THEN of_settooltiphelp (dwo, ls_obj, xpos, ypos)
end event

