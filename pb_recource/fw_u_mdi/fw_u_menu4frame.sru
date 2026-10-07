forward
global type fw_u_menu4frame from u_ancestor
end type
type dw_menu from fw_u_dwo within fw_u_menu4frame
end type
end forward

global type fw_u_menu4frame from u_ancestor
integer width = 1202
integer height = 2500
event oue_menuclicked ( string as_pgm_no,  string as_pgm_id,  string as_pgm_nm,  string as_parameter1,  string as_parameter2,  string as_parameter3 )
event oue_nomouseover ( )
dw_menu dw_menu
end type
global fw_u_menu4frame fw_u_menu4frame

type variables
private:
	String	is_parent_pgm	= ''
	String	ToolTipdwo		= ''
	LONG		il_expanding_row = 0, il_expanding_grouplevel

public:
	pf_n_propertywatcher	inv_propmon

	integer	MenuDepth = 2

	// Header Band Attributes
	boolean	DisplayHeaderBand		= true
	long		HeaderBandHeight		= 150
	long		HeaderBandBackColor	= RGB(120,112,101)
	string	HeaderFontFace			= '맑은 고딕'
	long		HeaderFontSize			= -12
	long		HeaderFontWeight		= 700
	long		HeaderFontColor		= RGB(255,255,255)

	// Group#1 Band Attributes
	long		Group#1BandHeight		= PixelstoUnits(36, YPixelsToUnits!)
	long		Group#1BandBackColor	= RGB(239,236,221)
	string	Group#1IconFileName	= ''
	string	Group#1FontFace		= '맑은 고딕'
	long		Group#1FontSize		= -10
	long		Group#1FontWeight		= 700
	long		Group#1FontColor		= RGB(100,100,100)

	// Group#2 Band Attributes
	long		Group#2BandHeight	= PixelstoUnits(38, YPixelsToUnits!)
	long		Group#2BandBackColor	= RGB(180,174,161)
	string	Group#2IconFileName	= ''
	string	Group#2FontFace		= '맑은 고딕'
	long		Group#2FontSize		= -11
	long		Group#2FontWeight		= 700
	long		Group#2FontColor		= RGB(125,125,125)
	
	// Detail Band Attributes
	long		DetailBandHeight		= PixelstoUnits(22, YPixelsToUnits!)
	long		DetailBandBackColor	= RGB(255,255,255)
	string	DetailIconFileName	= '..\img\mainframe\u_mdi_xpmenu\xpmenu_icon4.jpg'
	string	DetailFontFace			= '맑은 고딕'
	long		DetailFontSize			= -9
	long		DetailFontWeight		= 700
	long		DetailFontColor		= RGB(150,150,150)
end variables

forward prototypes
public function string of_thisname ()
public function integer of_add_favorite (string as_pgm_no, string as_pgm_nm)
public function integer of_drawmenu (string as_parent_pgm)
public function integer of_initializemenu ()
public function string of_parentpgmno ()
public subroutine of_setpgmexpression (string as_pgm_no)
public function integer of_setmenudepth (integer ai_menudepth)
end prototypes

event oue_nomouseover();this.visible = false
this.border = false
inv_propmon.of_unregister('nomouseover')
inv_propmon.of_stop()
end event

public function string of_thisname ();return 'fw_u_menu4frame'

end function

public function integer of_add_favorite (string as_pgm_no, string as_pgm_nm);n_menu	lnv_menu

lnv_menu = create n_menu
lnv_menu.is_pgm_no = as_pgm_no
lnv_menu.is_pgm_nm = as_pgm_nm

OpenWithParm(fw_w_bookmark, lnv_menu)
If message.stringparm = 'OK' Then
	n_menu	lnvo_m
	gw_mdi.Dynamic of_setdynamicevent('fw_u_bookmark4frame', 'oue_refreshmenu', lnvo_m)
End If

return 1
end function

public function integer of_drawmenu (string as_parent_pgm);LONG	ll_menucnt, ll_xpos, ll_ypos, ll_menugap, ll_textwidth, ll_textheight, i
LONG	ll_bgxpos, ll_bgwidth
STRING	ls_pgm_no, ls_pgm_id, ls_pgm_nm, ls_pgm_icon

pf_n_syntaxbuffer lnv_syntax
pf_s_size lstr_textsize, lstr_imgsize

setpointer(hourglass!)

dw_menu.setredraw(FALSE)
dw_menu.POST setredraw(TRUE)

// 데이터윈도우 초기화
dw_menu.dataobject = dw_menu.dataobject

// 데이터윈도우 Syntax 작성
lnv_syntax = CREATE pf_n_syntaxbuffer

// Parent PgmNo 가 없는 경우 Default 값 처리(=최상단 메뉴)
IF isnull(as_parent_pgm) or as_parent_pgm='' Then
   as_parent_pgm = '00000'
   ls_pgm_nm = 'ROOT'
else
   ls_pgm_nm = gnv_rolemenu.of_getpgmnm (as_parent_pgm)
End IF

SELECT  count (*)
  INTO  :MenuDepth
FROM    fw_pgm_mst t1
WHERE   parent_pgm = :as_parent_pgm;

MenuDepth = SQLCA.getitemnumber (1)
IF	MenuDepth>2 THEN MenuDepth = 2

of_setmenudepth (menudepth)

// DEPTH에 맞춰서 데이터를 표시한다
dw_menu.reset()

dw_menu.SetTransObject(SQLCA )
dw_menu.retrieve (gnv_vari.is_sys_id, gnv_vari.is_lang_type, gnv_vari.role_no[], as_parent_pgm, gnv_vari.is_login_dt)
dw_menu.Modify("DataWindow.Color='" + string(gnv_vari.mdi2xpmenubackcolor) + "'")
dw_menu.Modify("DataWindow.Tree.Level.1.Color='" + string(gnv_vari.mdi2xpmenu4treelevelcolor) + "'")
dw_menu.Modify("DataWindow.Detail.Color='" + string(gnv_vari.mdi2xpmenudetailcolor) + "'")
/* to-be dw img position resize */
dw_menu.EVENT resize(0, dw_menu.Width, dw_menu.Height)
dw_menu.groupcalc()

Choose CASE menudepth
   CASE 1
      dw_menu.POST expandall()
   CASE 2
      dw_menu.collapseall()
      dw_menu.expand(1, 1)
   CASE 3
      dw_menu.collapseall()
//    dw_menu.CollapseLevel (1)
//    dw_menu.post expandall()
//    dw_menu.post expandlevel(2)
End Choose

is_parent_pgm = as_parent_pgm

RETURN 1
end function

public function integer of_initializemenu ();dw_menu.dataobject = dw_menu.dataobject
return 0
end function

public function string of_parentpgmno ();Return is_parent_pgm
end function

public subroutine of_setpgmexpression (string as_pgm_no);If dw_menu.dataobject = '' Then Return
If dw_menu.rowcount() < 1  Then Return

dw_menu.setredraw (false)
If as_pgm_no = '' Then
	dw_menu.Object.bgcolorrow.expression = string(0)
	dw_menu.setredraw (true)
	Return
End If

LONG	ll_find, ll_sort_order, ll, ll_parent_row=0, ll_find_sort

ll_find = dw_menu.Find("pgm_no='" + as_pgm_no + "'", 1, dw_menu.rowcount())

//<임시> parent찾아서 expand 확인 및 expanding 20210909
IF ll_find>0	Then
	ll_sort_order = long (dw_menu.object.sort_order_lv1 [ll_find]) - 1
	FOR ll = 1 TO ll_sort_order
		ll_find_sort = dw_menu.FIND ("sort_order_lv1=" + string (ll), 1, dw_menu.rowcount())
		IF ll_find_sort>0	THEN ll_parent_row += dw_menu.object.parent_row [ll_find_sort]
	NEXT
	ll_parent_row += 1
	IF NOT dw_menu.IsExpanded(ll_parent_row, 1) THEN dw_menu.expand (ll_parent_row, 1)
End IF

If ll_find > 0 Then
	dw_menu.Object.bgcolorrow.expression = string(ll_find)
Else
	dw_menu.Object.bgcolorrow.expression = string(0)
End If
dw_menu.setredraw( true )
end subroutine

public function integer of_setmenudepth (integer ai_menudepth);menudepth = ai_menudepth
choose case menudepth
	case 1
		dw_menu.dataobject = 'fw_d_menu4frame_1lvl'
	case 2
		dw_menu.dataobject = 'fw_d_menu4frame_2lvl'
	case 3
		dw_menu.dataobject = 'fw_d_menu4frame_3lvl'
	case else
		dw_menu.dataobject = ''
		messagebox('Notice', 'XP Style menu can only display up to 3 Depth.')
		Return -1
end choose
Return 1
end function

on fw_u_menu4frame.create
int iCurrent
call super::create
this.dw_menu=create dw_menu
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_menu
end on

on fw_u_menu4frame.destroy
call super::destroy
destroy(this.dw_menu)
end on

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

// set default menu depth
//This.of_setmenudepth(menudepth)
end event

type dw_menu from fw_u_dwo within fw_u_menu4frame
event mousemove pbm_dwnmousemove
integer width = 1202
integer height = 2472
integer taborder = 10
string dataobject = "fw_d_menu4frame_2lvl"
boolean vscrollbar = true
boolean border = false
end type

event mousemove;If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname())

String	ls_tooltipyn, ls_obj, ls_rowdata, ls_syntax, ls_errmsg

ls_obj = fw_f_nvls(lower(dwo.name), 'datawindow')
If fw_f_nvls(ls_obj, '') = 'datawindow' Then Return
ls_tooltipyn = This.Describe(ls_obj + ".Tooltip.Enabled")
If fw_f_nvls(ls_tooltipyn, '') <> '1' Then Return
If This.Describe(ls_obj + ".Type")='column'	Then
	If ToolTipdwo = ls_obj + 'menu' + string(row) Then Return
	gnv_handle.of_exe4tooltip(This, ls_obj, ls_obj, 'column', '', '00', row, 0, 0)
	ToolTipdwo = ls_obj + 'menu' + string(row)
End If
end event

event clicked;If gw_mdi.of_lock4processing() = -1 Then Return

String	ls_level, ls_data
String	ls_parameter1, ls_parameter2, ls_parameter3
Long		ll_row, ll_level

Choose Case row
	Case 0
		IF	MenuDepth<>2 THEN RETURN
		This.setRedRaw(false)

		ls_data 	= This.GetBandAtPointer()
		ls_level	= LEFT(ls_data, Pos(ls_data, "~t") - 1)
		ll_row 	= Long(Mid(ls_data, Pos(ls_data, "~t") + Len("~t")))
		ll_level	= Long(Mid(ls_level, LastPos(ls_level, ".") + Len(".")))

		If IsExpanded(ll_Row, ll_level) THEN
			This.Collapse(ll_row, ll_level)
		ELSE
			IF	il_expanding_row > 0 And ll_Row > il_expanding_row THEN Collapse(il_expanding_row, il_expanding_grouplevel)
			This.Expand(ll_row, ll_level)
		END If
		/* to-be xpmenupoint */
		n_menu	lnvo_m
		gw_mdi.Dynamic of_setdynamicevent('fw_u_bookmark4frame', 'oue_refreshmenu', lnvo_m)

		This.setRedRaw(true)		
	Case Is > 0
		/* to-be expression band color 처리 Expression */
		This.Object.bgcolorrow.Expression = string(row)
		//If This.Object.bgcolor_yn[row] = 'N' Then This.Object.bgcolor_yn[row] = 'Y'
		//If This.Object.bgcolor_yn.Expression = "0" Then This.Object.bgcolor_yn.Expression = string(row)
		
		string ls_pgm_no, ls_pgm_id, ls_pgm_nm
		
		ls_pgm_no = This.getitemstring(row, 'pgm_no')
		ls_pgm_id = This.getitemstring(row, 'pgm_id')
		ls_pgm_nm = This.getitemstring(row, 'pgm_nm')
		ls_parameter1 = This.getitemstring(row, 'parameter1')
		ls_parameter2 = This.getitemstring(row, 'parameter2')
		ls_parameter3 = This.getitemstring(row, 'parameter3')
		
		If fw_f_nvls(ls_parameter1, '') = '' Then ls_parameter1 = ''
		If fw_f_nvls(ls_parameter2, '') = '' Then ls_parameter2 = ''
		If fw_f_nvls(ls_parameter3, '') = '' Then ls_parameter3 = ''
		Parent.Post Event oue_menuclicked(ls_pgm_no, ls_pgm_id, ls_pgm_nm, ls_parameter1, ls_parameter2, ls_parameter3)
End CHoose
end event

event rbuttondown;if row = 0 then return

// 즐겨찾기 추가
fw_m_mdibookmark	lm_popup

string	ls_pgm_no, ls_pgm_nm

ls_pgm_no = this.getitemstring(row, 'pgm_no')
ls_pgm_nm = this.getitemstring(row, 'pgm_nm')

lm_popup = create fw_m_mdibookmark
lm_popup.of_setparent(parent, ls_pgm_no, ls_pgm_nm)
lm_popup.m_xpmenu.PopMenu(PointerX(iw_parent), PointerY(iw_parent))
end event

event resize;long		ll_img1xpos, ll_img2xpos, ll_img1width, ll_img2width
string	ls_syntax, ls_error

ls_error = This.Describe("p_lvl1right.Width")
Choose Case ls_error
	Case '?', '!'
		Return
End Choose
ll_img1width = Long(this.describe("p_lvl1right.Width"))
ll_img1xpos = this.width - ll_img1width - PixelstoUnits(20, XPixelsToUnits!)
ls_syntax = "p_lvl1right.x='" + string(ll_img1xpos) + "'~r~n"
ls_syntax += "p_lvl1button.x='" + string(ll_img1xpos) + "'~r~n"

ls_error = This.Describe("p_lvl2right.Width")
If Not(ls_error = '!' or ls_error = '?') Then 
	ll_img2width = long(this.describe("p_lvl2right.width"))
	ll_img2xpos = this.width - ll_img2width - PixelstoUnits(20, XPixelsToUnits!)
	ls_syntax += "p_lvl2right.x='" + string(ll_img2xpos) + "'~r~n"
	ls_syntax += "p_lvl2button.x='" + string(ll_img2xpos) + "'~r~n"
End If
ls_error = this.modify(ls_syntax)
if ls_error <> '' then
	messagebox(this.classname() + '.resize()', ls_error)
end if
end event

event expanding;il_expanding_row = row
il_expanding_grouplevel = grouplevel
if grouplevel <> 2 then return 0
if this.getitemstring(row, 'expanded_once') = 'Y' then return 0
return 0
end event

