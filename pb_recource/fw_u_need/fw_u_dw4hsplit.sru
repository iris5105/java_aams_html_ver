forward
global type fw_u_dw4hsplit from u_ancestor
end type
type dw_sub from fw_u_dwo within fw_u_dw4hsplit
end type
type dw_main from fw_u_dwo within fw_u_dw4hsplit
end type
type st_vertical from statictext within fw_u_dw4hsplit
end type
type st_verticalcenter from statictext within fw_u_dw4hsplit
end type
end forward

global type fw_u_dw4hsplit from u_ancestor
integer width = 1221
integer height = 596
long backcolor = 16777215
event type long dw_clicked ( integer xpos,  integer ypos,  long row,  dwobject dwo )
event type long dw_dberror ( long sqldbcode,  string sqlerrtext,  string sqlsyntax,  dwbuffer buffer,  long row )
event type long dw_getfocus ( )
event type long dw_itemerror ( long row,  dwobject dwo,  string data )
event type long dw_itemfocuschanged ( long row,  dwobject dwo )
event type long dw_rowfocuschanged ( long currentrow )
event type long dw_buttonclicked ( long row,  long actionreturncode,  dwobject dwo )
event type long dw_doubleclicked ( integer xpos,  integer ypos,  long row,  dwobject dwo )
event type long dw_editchanged ( long row,  dwobject dwo,  string data )
event type long dw_itemchanged ( long row,  dwobject dwo,  string data )
event type long dw_losefocus ( )
event type long dw_sqlpreview ( sqlpreviewfunction request,  sqlpreviewtype sqltype,  string sqlsyntax,  dwbuffer buffer,  long row )
event type long dw_retrieveend ( long rowcount )
event ue_dw_sync ( string as_obj )
event oue_setproperty4design ( )
event oue_setproperty4resize ( )
event oue_setobjskip4column ( )
event oue_setposition4obj ( )
dw_sub dw_sub
dw_main dw_main
st_vertical st_vertical
st_verticalcenter st_verticalcenter
end type
global fw_u_dw4hsplit fw_u_dw4hsplit

type variables
CONSTANT LONG SpliteVerticalBarColor		= rgb(0,128,255)
CONSTANT LONG SpliteCenterBarColor		= rgb(0,128,255)//rgb(192,0,0)
CONSTANT LONG SpliteMouseDownColor		= rgb(0,128,255) //rgb(192,0,0)
CONSTANT LONG SpliteBarHiddenColor		= 0 //Bar hidden color to match the window background

CONSTANT LONG SpliteCenterBarHeightInit	= 0 //24
CONSTANT LONG SpliteVerticalBarHeight		= 76
CONSTANT LONG SpliteCenterBarWidth		= 9
CONSTANT LONG SpliteVerticalBarWidth		= 9
CONSTANT LONG SpliteBarThickness			= 11

Private :
	// The following are used for the resizing service
	Long			hsplit4value = 0
	boolean		ib_debug=False	//Debug mode
	long			il_hiddencolor=0	//Bar hidden color to match the window background
	integer			ii_barthickness=11	//Bar Thickness
	integer			ii_windowborder=25	//Window border to be used on all sides
	dragobject		idrg_Vertical[2]	//Reference to the vertical controls on the window
	
	Long			ildwZoom = 0 /* DataWindow Zoom variable */

Public:	
	// fw_u_dwo Properties	
	fw_u_dwo	idw_current
	fw_u_dwo	idw_hsplit4parent
	
	String				synchsplit4dw		= ''
	String				synchsplit4obj		= ''
	boolean			objskip4column	= False
end variables

forward prototypes
public subroutine setdataobject (string as_dataobject)
public function integer settransobject (ref transaction ag_trans)
public subroutine sethsplit4value (integer ai_x)
public subroutine of_hscrollbar ()
public function long of_getdwomaxwidth ()
public subroutine of_setdeisgn ()
public function string of_thisname ()
public subroutine of_resize (long al_index, long al_x, long al_y, long al_width, long al_height)
public subroutine of_objpos (long al_pointerx, long al_width, long al_height)
public subroutine of_zoom (long al_zoom)
public subroutine of_bringtotop ()
public function datawindow of_getsynchsplit4dw ()
end prototypes

event type long dw_clicked(integer xpos, integer ypos, long row, dwobject dwo);If row < 1 Then Return 0

idw_hsplit4parent.Event clicked( xpos, ypos, row, dwo )

Return 0
end event

event type long dw_dberror(long sqldbcode, string sqlerrtext, string sqlsyntax, dwbuffer buffer, long row);
Return 0
end event

event type long dw_getfocus();
Return 0
end event

event type long dw_itemerror(long row, dwobject dwo, string data);
return 0
end event

event type long dw_itemfocuschanged(long row, dwobject dwo);If row < 1 Then Return 0

idw_hsplit4parent.Event itemfocuschanged( row, dwo )

Return 0
end event

event type long dw_rowfocuschanged(long currentrow);If currentrow < 1 Then Return 0

idw_hsplit4parent.Event rowfocuschanged( currentrow )

return 0
end event

event type long dw_buttonclicked(long row, long actionreturncode, dwobject dwo);
Return 0
end event

event type long dw_doubleclicked(integer xpos, integer ypos, long row, dwobject dwo);If row < 1 Then Return 0

idw_hsplit4parent.Event doubleclicked( xpos, ypos, row, dwo )

return 0
end event

event type long dw_editchanged(long row, dwobject dwo, string data);If row < 1 Then Return 0

idw_hsplit4parent.Event editchanged( row, dwo, data )

Return 0
end event

event type long dw_itemchanged(long row, dwobject dwo, string data);If row < 1 Then Return 0

idw_hsplit4parent.Event itemchanged( row, dwo, data )

return 0
end event

event type long dw_losefocus();Return 0
end event

event type long dw_sqlpreview(sqlpreviewfunction request, sqlpreviewtype sqltype, string sqlsyntax, dwbuffer buffer, long row);
return 0
end event

event type long dw_retrieveend(long rowcount);If rowcount < 1 Then Return 0

idw_hsplit4parent.Event retrieveend( rowcount )

Return 0
end event

event ue_dw_sync(string as_obj);String		ls_syntax, ls_designstyle
String		ls_column, ls_xpos
Long		ll_hsplit4pos

iw_parent.SetRedRaw( false )
This.of_resize( 0, 0, 0, 0, 0) /* dw resize init */
//This.SetDataObject(idw_hsplit4parent.dataobject)

ls_xpos = idw_hsplit4parent.Describe(as_obj + ".X")
Choose Case ls_xpos
	Case '?', '!'
		Messagebox('Check', 'Column Name Check')
		Return
End Choose

ls_syntax = idw_hsplit4parent.Describe("DataWindow.Syntax")
If dw_main.Create( ls_syntax ) = 1 Then dw_sub.Create( ls_syntax )

idw_hsplit4parent.ShareData(dw_main)
dw_main.ShareData(dw_sub)

If idw_hsplit4parent.rowcount() > 0 Then dw_main.Event rowfocuschanged( 1 )

hsplit4value		= Long(ls_xpos) + Long(idw_hsplit4parent.Describe(as_obj + ".Width"))
ll_hsplit4pos	= hsplit4value

ls_designstyle	= idw_hsplit4parent.Dynamic of_getdesignstyle()
gnv_extfunc.biznode1te(143, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)

iw_parent.SetRedRaw( True )
end event

event oue_setproperty4design();dw_main.ibdesign4role				=	idw_hsplit4parent.ibdesign4role
dw_main.applydesign					=	idw_hsplit4parent.applydesign
dw_main.useborder						=	idw_hsplit4parent.useborder
dw_main.ibdesign4cond				=	idw_hsplit4parent.ibdesign4cond
dw_main.ibtitle4datawindow			=	idw_hsplit4parent.ibtitle4datawindow
dw_main.setbringtotop				=	idw_hsplit4parent.setbringtotop
//dw_main.zoominout					=	idw_hsplit4parent.zoominout
//dw_main.setfocusdw					=	idw_hsplit4parent.setfocusdw
dw_main.setedittoken					=	idw_hsplit4parent.setedittoken
dw_main.ibsettooltiphelp			=	idw_hsplit4parent.ibsettooltiphelp
dw_main.ibsettooltipdata			=	idw_hsplit4parent.ibsettooltipdata
dw_main.designcache					=	idw_hsplit4parent.designcache
dw_main.cacheuseborder				=	idw_hsplit4parent.cacheuseborder
//dw_main.ibsetlist4sort				=	idw_hsplit4parent.ibsetlist4sort
dw_main.ibsetlist4subbtn			=	idw_hsplit4parent.ibsetlist4subbtn
dw_main.ibsetlist4tabudesign		=	idw_hsplit4parent.ibsetlist4tabudesign
dw_main.ibsetlist4excelclip		=	idw_hsplit4parent.ibsetlist4excelclip
//dw_main.ibsetlist4filter2uo		=	idw_hsplit4parent.ibsetlist4filter2uo
dw_main.ibsetlist4hsplitscroll	=	idw_hsplit4parent.ibsetlist4hsplitscroll
dw_main.ibsetlist4singleselect	=  idw_hsplit4parent.ibsetlist4singleselect
dw_main.ibsetlist4multiselect		=	idw_hsplit4parent.ibsetlist4multiselect
dw_main.ibsetlist4alrowcolor		=	idw_hsplit4parent.ibsetlist4alrowcolor
dw_main.setlist4rowpointcolor		=	idw_hsplit4parent.setlist4rowpointcolor

dw_sub.ibdesign4role				=	idw_hsplit4parent.ibdesign4role
dw_sub.applydesign				=	idw_hsplit4parent.applydesign
dw_sub.useborder					=	idw_hsplit4parent.useborder
dw_sub.ibdesign4cond				=	idw_hsplit4parent.ibdesign4cond
dw_sub.ibtitle4datawindow		=	idw_hsplit4parent.ibtitle4datawindow
dw_sub.setbringtotop				=	idw_hsplit4parent.setbringtotop
dw_sub.zoominout					=	idw_hsplit4parent.zoominout
//dw_sub.setfocusdw				=	idw_hsplit4parent.setfocusdw
dw_sub.setedittoken				=	idw_hsplit4parent.setedittoken
dw_sub.ibsettooltiphelp			=	idw_hsplit4parent.ibsettooltiphelp
dw_sub.ibsettooltipdata			=	idw_hsplit4parent.ibsettooltipdata
dw_sub.designcache				=	idw_hsplit4parent.designcache
dw_sub.cacheuseborder			=	idw_hsplit4parent.cacheuseborder
//dw_sub.ibsetlist4sort			=	idw_hsplit4parent.ibsetlist4sort
dw_sub.ibsetlist4subbtn			=	idw_hsplit4parent.ibsetlist4subbtn
dw_sub.ibsetlist4tabudesign	=	idw_hsplit4parent.ibsetlist4tabudesign
dw_sub.ibsetlist4excelclip		=	idw_hsplit4parent.ibsetlist4excelclip
//dw_sub.ibsetlist4filter2uo		=	idw_hsplit4parent.ibsetlist4filter2uo
dw_sub.ibsetlist4hsplitscroll	=	idw_hsplit4parent.ibsetlist4hsplitscroll
dw_sub.ibsetlist4singleselect	=  idw_hsplit4parent.ibsetlist4singleselect
dw_sub.ibsetlist4multiselect	=	idw_hsplit4parent.ibsetlist4multiselect
dw_sub.ibsetlist4alrowcolor	=	idw_hsplit4parent.ibsetlist4alrowcolor
dw_sub.setlist4rowpointcolor	=	idw_hsplit4parent.setlist4rowpointcolor
end event

event oue_setproperty4resize();This.FixedToRight				= idw_hsplit4parent.FixedToRight
This.FixedToBottom			= idw_hsplit4parent.FixedToBottom
This.ScaleToRight				= idw_hsplit4parent.ScaleToRight
This.ScaleToBottom			= idw_hsplit4parent.ScaleToBottom
end event

event oue_setobjskip4column();String		ls_temp, ls_objs[]
String		ls_objtype, ls_band, ls_designstyle, ls_dwsynasis
String		ls_syntax, ls_error
Long		ll_objcnt, i, ll_j = 0
Long		ll_xpos, ll_width

If objskip4column = false Then Return
If fw_f_nvll(hsplit4value, 0) < 10 Then Return

ls_temp		= idw_hsplit4parent.Describe("Datawindow.Objects")
ll_objcnt	= fw_f_obj2array(ls_temp, "~t", ls_objs[])
ll_xpos		= 0
ll_width		= 0
ls_syntax	= ''

for i = 1 to ll_objcnt
	ls_objtype = idw_hsplit4parent.describe(ls_objs[i] + ".Type")
	ls_band = idw_hsplit4parent.Describe(ls_objs[i] + ".Band")
	
	//If not (ls_objtype = "column" or ls_objtype = "text" or ls_objtype = "compute") Then Continue
	// 화면에 위치 하지 않는 컨트롤 제외
	If ls_band = "?" or ls_band = "!" Then Continue	
	If fw_f_rtnbackgrobjchk(ls_objs[i]) = -1 Then Continue
	
	ll_xpos	= Long(idw_hsplit4parent.Describe(ls_objs[i] + ".x"))
	If hsplit4value - Long(pixelstounits(2, XPixelsToUnits!)) < ll_xpos Then
		ll_xpos = ll_xpos - hsplit4value
		ll_xpos = Long(UnitsToPixels(ll_xpos, XUnitsToPixels!))
		If ll_xpos < 1 Then ll_xpos = 0
		ls_syntax += ls_objs[i] +  ".X='" + String(Long(PixelsToUnits(ll_xpos, XPixelsToUnits!))) + "'~r~n"		
	Else
		ls_syntax += ls_objs[i] +  ".Visible='0'~r~n"
		ls_syntax += ls_objs[i] +  ".Width='0'~r~n"
	End If
Next

If fw_f_nvls(ls_syntax, '') <> '' Then
	ls_error = dw_main.Modify( ls_syntax )
	If fw_f_nvls(ls_error, '') <> '' Then
		::clipboard(ls_Syntax)
		Messagebox('Error', 'Visibleobject Modify False')
		Return
	End If
End If

gnv_extfunc.biznode1te(144, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)
end event

event oue_setposition4obj();Long	ll_hsplit4pos
If ildwZoom <> 0 Then
	ll_hsplit4pos = hsplit4value * (abs(ildwZoom) / 100)
	of_zoom( ildwZoom )
Else
	This.of_objpos(hsplit4value, This.Width, This.Height)
End If

dw_main.Event oue_dwowidthchanged()
end event

public subroutine setdataobject (string as_dataobject);iw_parent.SetRedRaw( false )
dw_main.of_setdataobject(as_dataobject)
dw_sub.of_setdataobject(as_dataobject)
iw_parent.SetRedRaw( true )
end subroutine

public function integer settransobject (ref transaction ag_trans);return dw_main.SetTransObject(ag_trans)
end function

public subroutine sethsplit4value (integer ai_x);If ai_x > 0 Then hsplit4value = ai_x
end subroutine

public subroutine of_hscrollbar ();Choose Case dw_main.hscrollbar
	Case True
		dw_sub.hscrollbar = true
	Case False
		dw_sub.hscrollbar = false
End Choose
end subroutine

public function long of_getdwomaxwidth ();string ls_object, ls_objarr[]
long i, ll_objcnt
long ll_objpos, ll_maxpos

ls_object = dw_main.describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
for i = 1 to ll_objcnt
	If fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 Then Continue
	if dw_main.describe(ls_objarr[i] + ".Band") = 'header' then
		if dw_main.describe(ls_objarr[i] + ".Visible") = '1' then
			ll_objpos = long(dw_main.describe(ls_objarr[i] + ".X")) + long(dw_main.describe(ls_objarr[i] + ".Width"))
			if ll_maxpos < ll_objpos then
				ll_maxpos = ll_objpos
			end if
		end if
	end if
next

return ll_maxpos

end function

public subroutine of_setdeisgn ();dw_sub.Event oue_dataobjectchanged( )
dw_main.Event oue_dataobjectchanged( )
end subroutine

public function string of_thisname ();return 'fw_u_dw4hsplit'

end function

public subroutine of_resize (long al_index, long al_x, long al_y, long al_width, long al_height);/*  userobject init Size value */
Choose Case al_index
	Case 0
		This.x			= idw_hsplit4parent.x - Long(pixelstounits(1, XPixelsToUnits!))
		This.y			= idw_hsplit4parent.y - Long(pixelstounits(1, YPixelsToUnits!))
		This.width	= idw_hsplit4parent.width + Long(pixelstounits(2, XPixelsToUnits!))
		This.Height	= idw_hsplit4parent.height + Long(pixelstounits(2, YPixelsToUnits!))
		
		of_objpos( 0, 0, 0 )
	Case 1
		If hsplit4value > 0 Then
			This.of_objpos( hsplit4value, al_width, al_height )
		Else
			of_objpos( 0, 0, 0 )
		End If
End Choose
end subroutine

public subroutine of_objpos (long al_pointerx, long al_width, long al_height);If NOT IsValid(idw_hsplit4parent) Then Return

Integer	li_Cnt, li_X, li_Y, li_HHeight, li_HWidth
Long		ll_Width, ll_Height
Long		ll_mainx

IF al_PointerX > 0 AND al_PointerX < al_Width THEN
	// Split Bar 움직였을 경우. 범위가 UserObject 안에 있는 경우.
	// Height 변화 없이 전체적으로 Width 만 조절.
	//st_verticalcenter.width	= Long(PixelsToUnits(UnitsToPixels(st_verticalcenter.width, XUnitsToPixels!), XPixelsToUnits!))
	
	// st_vertical
	st_verticalcenter.x			= al_pointerx
	st_verticalcenter.Height	= al_Height - SpliteVerticalBarHeight
	st_verticalcenter.Hide()
	
	st_vertical.x					= st_verticalcenter.x
	st_vertical.y					= st_verticalcenter.y
	st_vertical.Width			= st_verticalcenter.Width
	st_vertical.Height			= This.Height
	
	dw_sub.Width	= st_vertical.x
	dw_sub.Height	= al_Height - Long(PixelsToUnits(2, YPixelsToUnits!))
	dw_sub.of_setvisible( True )
	//dw_main.Resize ( al_width - dw_main.x, dw_sub.Height)
	//ll_mainx	= Long(PixelsToUnits(UnitsToPixels(st_verticalcenter.x + st_verticalcenter.Width, XUnitsToPixels!), XPixelsToUnits!))
	ll_mainx = (st_verticalcenter.x + st_verticalcenter.Width) - Long(PixelsToUnits(1,XPixelsToUnits!))
	dw_main.x = ll_mainx //Move (ll_mainx, 0 )
	dw_main.y = dw_sub.y
	dw_main.Width	= al_width - dw_main.x - Long(PixelsToUnits(1,XPixelsToUnits!))
	dw_main.Height	= dw_sub.Height
	st_vertical.show()
Else
	// 초기 값. 크기 조절.
	dw_main.x = Long(PixelsToUnits(1, XPixelsToUnits!))
	dw_main.y = Long(PixelsToUnits(1, YPixelsToUnits!))
	dw_main.Width	= This.Width - Long(PixelsToUnits(2, XPixelsToUnits!))
	dw_main.Height	= This.Height - Long(PixelsToUnits(2, YPixelsToUnits!))
	dw_sub.x			= dw_main.x
	dw_sub.y			= dw_main.y
	dw_sub.Width		= 0
	dw_sub.Height		= dw_main.Height
	
	st_vertical.x			= dw_main.x 
	st_verticalcenter.x	= dw_main.x
	
	st_verticalcenter.Height	= dw_main.Height - SpliteVerticalBarHeight
	st_vertical.y					= st_verticalcenter.Height
	
	st_vertical.Width	= SpliteVerticalBarWidth
	st_vertical.Height	= SpliteVerticalBarHeight
		
	//idw_hsplit4parent.of_setvisible( False )
	dw_sub.of_setvisible( False )
	st_verticalcenter.Visible	= False
	st_vertical.Visible			= False
END IF

This.Post of_hscrollbar()
end subroutine

public subroutine of_zoom (long al_zoom);dw_main.Object.DataWindow.Zoom	= al_zoom
dw_sub.Object.DataWindow.Zoom		= al_zoom

ildwZoom = al_zoom /* instance variable */
	
If fw_f_nvll(hsplit4value, 0) <> 0 Then
	Long		ll_hsplit4pos
	ll_hsplit4pos = hsplit4value * (abs(ildwZoom) / 100)
	This.Post of_objpos(ll_hsplit4pos, This.Width, This.Height)
End If
end subroutine

public subroutine of_bringtotop ();st_vertical.bringtotop = True
end subroutine

public function datawindow of_getsynchsplit4dw ();// 윈도우 오브젝트에서 참조되는 DW의 레퍼런스를 리턴합니다
// 리턴값: 참조 DW 레퍼런스
DataWindow ldw_object

ldw_object = iw_parent.dynamic of_getrefdw2obj(synchsplit4dw)

Return ldw_object

end function

on fw_u_dw4hsplit.create
int iCurrent
call super::create
this.dw_sub=create dw_sub
this.dw_main=create dw_main
this.st_vertical=create st_vertical
this.st_verticalcenter=create st_verticalcenter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sub
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.st_vertical
this.Control[iCurrent+4]=this.st_verticalcenter
end on

on fw_u_dw4hsplit.destroy
call super::destroy
destroy(this.dw_sub)
destroy(this.dw_main)
destroy(this.st_vertical)
destroy(this.st_verticalcenter)
end on

event resize;call super::resize;This.of_resize(1, This.x, This.y, NewWidth, NewHeight)
end event

event constructor;// Get Parent Window
iw_parent = fw_f_obj4parentwindow(this)

// 참조탭 구하기
If synchsplit4dw = '' Then
	messagebox('Notice', '참조할 DataWindow 명칭을 입력하세요')
	Return
End If

idw_hsplit4parent = of_getsynchsplit4dw()
If not isvalid(idw_hsplit4parent) Then
	messagebox('Notice', '참조할 DataWindow 명칭을 찾을 수 없습니다')
	Return
End If

If idw_hsplit4parent.ibsetlist4hsplitscroll = false Then
	messagebox('Notice', 'Hsplit 사용 유무가 꺼짐으로 되어있습니다.')
	Return
End If

idw_hsplit4parent.of_sethsplitobj(This)

gnv_extfunc.biznode1te(141, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)

gnv_extfunc.biznode1te(142, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)

//This.of_resize( 0, 0, 0, 0, 0) /* dw resize init */

This.SetDataObject(idw_hsplit4parent.dataobject)

idw_current = dw_main /* idw_current init */

// PostOpen 이벤트 호출
This.Post event oue_postopen()

end event

event destructor;call super::destructor;Destroy idw_current
Destroy idw_hsplit4parent
end event

event oue_postopen;call super::oue_postopen;If fw_f_nvls(synchsplit4obj, '') <> '' Then This.Post Event ue_dw_sync(synchsplit4obj)
end event

type dw_sub from fw_u_dwo within fw_u_dw4hsplit
integer width = 1221
integer height = 592
integer taborder = 10
boolean bringtotop = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
integer ii_mouseover = 0
end type

event buttonclicked;call super::buttonclicked;Return (Parent.Event dw_buttonclicked( row, actionreturncode, dwo ))
end event

event clicked;call super::clicked;Return (Parent.Event dw_clicked( xpos, ypos, row, dwo ))
end event

event dberror;call super::dberror;Return (Parent.Event dw_dberror( sqldbcode, sqlerrtext, sqlsyntax, buffer, row ))
end event

event doubleclicked;call super::doubleclicked;Return (Parent.Event dw_doubleclicked( xpos, ypos, row, dwo ))
end event

event editchanged;call super::editchanged;Return (Parent.Event dw_editchanged( row, dwo, data ))
end event

event getfocus;call super::getfocus;idw_current = this

Return (Parent.Event dw_getfocus( ))
end event

event itemchanged;call super::itemchanged;Return (Parent.Event dw_itemchanged( row, dwo, data ))
end event

event itemerror;call super::itemerror;Return (Parent.Event dw_itemerror( row, dwo, data ))
end event

event itemfocuschanged;call super::itemfocuschanged;Return (Parent.Event dw_itemfocuschanged( row, dwo ))
end event

event losefocus;call super::losefocus;Return (Parent.Event dw_losefocus( ))
end event

event retrieveend;call super::retrieveend;Return ( Parent.Event dw_retrieveend( rowcount ) )
end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

dw_main.ScrollToRow( currentrow )

Return (Parent.Event dw_rowfocuschanged( currentrow ))
end event

event scrollvertical;call super::scrollvertical;dw_main.Object.datawindow.verticalscrollposition = scrollpos
end event

event sqlpreview;call super::sqlpreview;Return (Parent.Event dw_sqlpreview( request, sqltype, sqlsyntax, buffer, row ))
end event

event mousemove;call super::mousemove;//dw_main.Event losefocus()
end event

event scrollhorizontal;//
end event

type dw_main from fw_u_dwo within fw_u_dw4hsplit
integer width = 1221
integer height = 592
integer taborder = 10
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
integer ii_mouseover = 0
end type

event scrollvertical;call super::scrollvertical;dw_sub.Object.datawindow.verticalscrollposition = scrollpos
end event

event buttonclicked;call super::buttonclicked;Return (Parent.Event dw_buttonclicked( row, actionreturncode, dwo ))
end event

event clicked;call super::clicked;Return (Parent.Event dw_clicked( xpos, ypos, row, dwo ))

end event

event doubleclicked;call super::doubleclicked;Return (Parent.Event dw_doubleclicked( xpos, ypos, row, dwo ))
end event

event editchanged;call super::editchanged;Return (Parent.Event dw_editchanged( row, dwo, data ))
end event

event getfocus;call super::getfocus;idw_current = this

Return (Parent.Event dw_getfocus( ))
end event

event itemchanged;call super::itemchanged;Return (Parent.Event dw_itemchanged( row, dwo, data ))
end event

event itemerror;call super::itemerror;Return (Parent.Event dw_itemerror( row, dwo, data ))
end event

event itemfocuschanged;call super::itemfocuschanged;Return (Parent.Event dw_itemfocuschanged( row, dwo ))
end event

event losefocus;call super::losefocus;Return (Parent.Event dw_losefocus( ))
end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

dw_sub.ScrollToRow( currentrow )

dw_sub.SelectRow( 0, false )
dw_sub.SelectRow( currentrow, true )


Return (Parent.Event dw_rowfocuschanged( currentrow ))
end event

event sqlpreview;call super::sqlpreview;Return (Parent.Event dw_sqlpreview( request, sqltype, sqlsyntax, buffer, row ))
end event

event retrieveend;call super::retrieveend;Return ( Parent.Event dw_retrieveend( rowcount ) )
end event

event dberror;call super::dberror;Return (Parent.Event dw_dberror( sqldbcode, sqlerrtext, sqlsyntax, buffer, row ))
end event

event mousemove;call super::mousemove;//dw_sub.Event losefocus()
end event

event scrollhorizontal;//
end event

type st_vertical from statictext within fw_u_dw4hsplit
event mouseup pbm_lbuttonup
event mousemove pbm_mousemove
event mousedown pbm_lbuttondown
integer y = 532
integer width = 9
integer height = 68
string dragicon = "Exclamation!"
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "..\img\controls\u_splitbar_vertical\splitv.cur"
long textcolor = 33521664
long backcolor = 33521664
long bordercolor = 268435456
boolean focusrectangle = false
end type

event mouseup;of_objpos( Parent.PointerX(), Parent.Width, Parent.Height )
st_verticalcenter.BackColor = SpliteVerticalBarColor
st_vertical.BackColor = SpliteVerticalBarColor

Post of_bringtotop()
end event

event mousemove;If KeyDown(keyLeftButton!) Then
	// Original Color
	st_verticalcenter.BackColor = SpliteCenterBarColor
	st_vertical.BackColor = SpliteVerticalBarColor

	st_verticalcenter.X = Parent.PointerX()
	st_vertical.X = Parent.PointerX()
End If
end event

event mousedown;st_verticalcenter.Visible = True

st_vertical.BackColor				= SpliteMouseDownColor
st_verticalcenter.BackColor		= SpliteMouseDownColor

end event

type st_verticalcenter from statictext within fw_u_dw4hsplit
integer width = 9
integer height = 592
string dragicon = "Exclamation!"
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "..\img\controls\u_splitbar_vertical\splitv.cur"
long textcolor = 33521664
long backcolor = 33521664
long bordercolor = 268435456
boolean focusrectangle = false
end type

