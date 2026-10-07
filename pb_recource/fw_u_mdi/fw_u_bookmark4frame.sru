forward
global type fw_u_bookmark4frame from u_ancestor
end type
type dw_menu from fw_u_dwo within fw_u_bookmark4frame
end type
end forward

global type fw_u_bookmark4frame from u_ancestor
integer width = 1202
integer height = 2500
event oue_menuclicked ( string as_pgm_no,  string as_pgm_id,  string as_pgm_nm,  string as_parameter1,  string as_parameter2,  string as_parameter3 )
event oue_refreshmenu ( )
event oue_nomouseover ( )
dw_menu dw_menu
end type
global fw_u_bookmark4frame fw_u_bookmark4frame

type variables
public:
	String	ToolTipdwo = ''
	Integer	menudepth = 2
	pf_n_propertywatcher		inv_propmon

end variables

forward prototypes
public function string of_thisname ()
public function integer of_rename_favorite (string as_pgm_no, string as_pgm_nm)
public subroutine of_setpgmexpression (string as_pgm_no)
public function integer of_drawleftmenu (string as_login)
public function integer of_del_favorite (string as_pgm_no, string as_pgm_nm)
end prototypes

event oue_refreshmenu();this.of_drawleftmenu(gaa.login)
end event

event oue_nomouseover();this.visible = false
this.border = false
inv_propmon.of_unregister('nomouseover')
inv_propmon.of_stop()

end event

public function string of_thisname ();return 'fw_u_bookmark4frame'

end function

public function integer of_rename_favorite (string as_pgm_no, string as_pgm_nm);n_menu lnv_menu
lnv_menu = create n_menu

lnv_menu.is_pgm_no = as_pgm_no
lnv_menu.is_pgm_nm = as_pgm_nm

openwithparm(fw_w_bookmark_re, lnv_menu)

If message.stringparm = 'OK' Then This.Event oue_refreshmenu()

return 1
end function

public subroutine of_setpgmexpression (string as_pgm_no);//bgcolorrow clear
Long		ll_find

dw_menu.SetRedRaw( false )

If as_pgm_no = '' Then
	dw_menu.Object.bgcolorrow.Expression = string(0)
	dw_menu.SetRedRaw( true )
	Return
End If

ll_find = dw_menu.Find("pgm_no='" + as_pgm_no + "'", 1, dw_menu.rowcount())

If ll_find > 0 Then
	dw_menu.Object.bgcolorrow.Expression = string(ll_find)
Else
	dw_menu.Object.bgcolorrow.Expression = string(0)
End If

dw_menu.SetRedRaw( true )
end subroutine

public function integer of_drawleftmenu (string as_login);STRING	ls_like

LONG	ll_ret

ll_ret = dw_menu.retrieve (gnv_vari.is_sys_id, as_login)

dw_menu.modify("DataWindow.Color= '" + String(gnv_vari.mdi2xpmenubackcolor) + "'")
dw_menu.modify("DataWindow.Tree.Level.1.Color= '" + String(gnv_vari.mdi2xpmenu4treelevelcolor) + "'")
dw_menu.modify("DataWindow.Detail.Color= '" + String(gnv_vari.mdi2xpmenudetailcolor) + "'")
/* to-be dw img position resize */
dw_menu.event resize(0, dw_menu.Width, dw_menu.Height)
Return ll_ret

end function

public function integer of_del_favorite (string as_pgm_no, string as_pgm_nm);IF	f_null (as_pgm_no) THEN RETURN -1

IF messagebox('Notice', 'Your choice [' + as_pgm_nm + '] Are you sure you want to delete your dimension items?', Question!, YesNo!, 2)<>1 THEN RETURN 0

DELETE  fw_user_favor
WHERE   sys_id  = :gnv_vari.is_sys_id
  AND   user_id = :gaa.login
  AND   pgm_no  = :as_pgm_no;
IF SQLCA.sqlcode ()=0   Then
   commitJ ()
else
   rollbackJ ()
   messagebox('Notice', 'There was an error deleting your dimension entry!~r~n' + SQLCA.sqlerrtext())
   RETURN -1
End IF

POST of_drawleftmenu(gaa.login)

RETURN 1
end function

on fw_u_bookmark4frame.create
int iCurrent
call super::create
this.dw_menu=create dw_menu
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_menu
end on

on fw_u_bookmark4frame.destroy
call super::destroy
destroy(this.dw_menu)
end on

event constructor;call super::constructor;dw_menu.dataobject = 'fw_d_bookmark4frame2lvl'
dw_menu.settransobject(sqlca)

end event

event resize;call super::resize;dw_menu.x = -100
dw_menu.y = 0
dw_menu.width = this.width + 100
dw_menu.height = this.height

end event

event destructor;call super::destructor;If isvalid(inv_propmon) Then
	inv_propmon.of_stop()
	Destroy inv_propmon
End If
end event

event oue_postopen;call super::oue_postopen;// register porps watcher
inv_propmon = create pf_n_propertywatcher
inv_propmon.of_registerparent(this)
inv_propmon.of_setvisibletime(2500)

end event

type dw_menu from fw_u_dwo within fw_u_bookmark4frame
event mousemove pbm_dwnmousemove
integer width = 1202
integer height = 2480
integer taborder = 10
string dataobject = "fw_d_bookmark4frame2lvl"
boolean vscrollbar = true
boolean border = false
end type

event mousemove;String	ls_tooltipyn, ls_obj, ls_rowdata, ls_errmsg

If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname())

ls_obj = fw_f_nvls(lower(dwo.name), 'datawindow')
If ls_obj = 'datawindow' Then Return
ls_tooltipyn = This.Describe(ls_obj + ".Tooltip.Enabled")
If fw_f_nvls(ls_tooltipyn, '') <> '1' Then Return
iF lower(This.Describe(ls_obj + ".Type"))='column'	Then
	If ToolTipdwo = ls_obj + 'book' + string(row) Then Return
	gnv_handle.of_exe4tooltip(This, ls_obj, ls_obj, 'column', '', '00', row, 0, 0)
	ToolTipdwo = ls_obj + 'book' + string(row)
End If
end event

event clicked;String	ls_level, ls_data, ls_parameter1, ls_parameter2, ls_parameter3

Long	ll_row, ll_level

Choose Case row
	Case 0
		this.setRedRaw(false)
		ls_data 	= this.GetBandAtPointer()
		ls_level	= LEFT(ls_data, Pos(ls_data, "~t") - 1)
		ll_row 	= Long(Mid(ls_data, Pos(ls_data, "~t") + Len("~t")))
		ll_level	= Long(Mid(ls_level, LastPos(ls_level, ".") + Len(".")))

		IF IsExpanded(ll_Row, ll_level) THEN
			this.Collapse(ll_row, ll_level)
		ELSE
			this.Expand(ll_row, ll_level)
		END IF
		/* to-be xpmenupoint */
		n_menu	lnvo_m
		gw_mdi.of_setdynamicevent('fw_u_sheettab4frame', 'of_setpgmexpression', lnvo_m)
		
		this.setRedRaw(true)
	Case Is > 0
		/* to-be expression band color 처리 column */
		This.Object.bgcolorrow.Expression = string(row)
		//If This.Object.bgcolor_yn[row] = 'N' Then This.Object.bgcolor_yn[row] = 'Y'
		//If This.Object.bgcolor_yn.Expression = "'N'" Then This.Object.bgcolor_yn.Expression = "'Y'"

		string ls_pgm_no, ls_pgm_id, ls_pgm_nm

		ls_pgm_no = this.getitemstring(row, 'pgm_no')

		If gnv_rolemenu.of_getmenudata('self', ls_pgm_no) =  0 Then
			Messagebox('Notice', '이 프로그램을 사용할 권한이 없습니다')
			Return
		End If

		ls_pgm_id		= gnv_rolemenu.of_getpgmid(ls_pgm_no)
		ls_pgm_nm		= gnv_rolemenu.of_getpgmnm(ls_pgm_no)
		ls_parameter1	= gnv_rolemenu.of_getpgmparameter(ls_pgm_no, '1')
		ls_parameter2	= gnv_rolemenu.of_getpgmparameter(ls_pgm_no, '2')
		ls_parameter3	= gnv_rolemenu.of_getpgmparameter(ls_pgm_no, '3')

		Parent.post event oue_menuclicked(ls_pgm_no, ls_pgm_id, ls_pgm_nm, ls_parameter1, ls_parameter2, ls_parameter3)		
End CHoose

end event

event rbuttondown;if row = 0 then return

// 즐겨찾기 메뉴
fw_m_mdibookmark lm_popup
string ls_pgm_no, ls_favor_nm

ls_pgm_no = this.getitemstring(row, 'pgm_no')
ls_favor_nm = this.getitemstring(row, 'favor_nm')

lm_popup = create fw_m_mdibookmark
lm_popup.of_setparent(parent, ls_pgm_no, ls_favor_nm)
lm_popup.m_favorite.PopMenu(PointerX(iw_parent), PointerY(iw_parent))
end event

event resize;call super::resize;long ll_img1xpos, ll_img2xpos
long ll_img1width, ll_img2width
string ls_syntax
string ls_error

ls_error = This.Describe("p_lvl1right.Width")
Choose Case ls_error
	Case '?', '!'
		Return
End Choose
ll_img1width = long(this.describe("p_lvl1right.width"))
ll_img1xpos = this.width - ll_img1width - PixelstoUnits(20, XPixelsToUnits!)
ls_syntax = "p_lvl1right.x='" + string(ll_img1xpos) + "'~r~n"
ls_syntax += "p_lvl1button.x='" + string(ll_img1xpos) + "'~r~n"

ls_error = this.modify(ls_syntax)
if ls_error <> '' then
	messagebox(this.classname() + '.resize()', ls_error)
end if

end event

