forward
global type fw_u_dwo from adw_jtier
end type
end forward

global type fw_u_dwo from adw_jtier
integer width = 686
integer height = 400
boolean livescroll = true
string is_receivetype = "xml"
event type boolean oue_components ( )
event mousemove pbm_dwnmousemove
event oue_mouseover ( long al_row,  dwobject ao_dwo )
event oue_mouseleave ( )
event oue_dataobjectchanged ( )
event move pbm_move
event oue_keydown pbm_dwnkey
event oue_setvisible ( boolean ab_visible )
event oue_syntaxmodified ( )
event oue_dwowidthchanged ( )
event timer pbm_timer
event oue_postopen ( )
event oue_setredraw ( boolean ab_boolean )
event oue_error4database ( long al_errorcode,  string as_errortext,  string as_syntax,  long al_row,  dwbuffer adwb_buffer )
event oue_bringtotop ( )
event oue_settransobject ( )
event oue_lastopen ( )
event buttonup pbm_dwnlbuttonup
event type integer deleterowstart ( long row )
event insertrowend ( long row )
event type integer insertrowstart ( long row )
event type integer oue_setupdatecheck ( )
event oue_setedittoken44 ( )
event oue_error4datawindow ( long al_errorcode,  string as_errortext,  string as_syntax,  long al_row )
event oue_subbtn_firstpage ( )
event oue_subbtn_nextpage ( )
event oue_subbtn_priorpage ( )
event oue_subbtn_lastpage ( )
event oue_subbtn_copy ( )
event oue_subbtn_excel ( )
event oue_subbtn_load ( )
event oue_subbtn_save ( )
event oue_subbtn_input ( )
event oue_subbtn_delete ( )
event itemchanged_next ( long row,  string name )
event ue_dddw_retrieve ( )
end type
global fw_u_dwo fw_u_dwo

type prototypes

end prototypes

type variables
// 공통 리턴값 상수
constant	integer SUCCESS = 1
constant	integer FAILURE = -1
constant	integer NO_ACTION = 0

// 계속/중지 리턴값 상수
constant integer CONTINUE_ACTION = 1
constant integer PREVENT_ACTION = 0

Private:
	fw_n_handle			inv_handle
	fw_u_dw2title		ivo_dw2title
	fw_u_dw2subbtn		ivo_dw2subbtn
	fw_u_dw2zoom		ivo_dw2zoom
	fw_u_dw4filter		ivo_dw4filter
	fw_u_dw4hsplit		ivo_dw4hsplit
	pf_s_point			istr_point

	String		isdesignstyle	= ''
	boolean		ib_isUpdatable	= false
	boolean		ibopening		= false
	long			il_mouseoverrow	= 0
	boolean		ib_mouseover
	String		is_mouseover
	integer		ii_mouseover	= -1

	integer		ii_beginxpos
	String		is_beginband

	/* to-be datawindow Variable; as-is syntax, Scrollpos, hsplit, as-is width height, ToolTip */
	String		isasissyntax4dwo	= ''	//instance
	String		isasisgrgb			= ''	//group gb
	String		isasisgrobj			= ''	//group obj
	Long			ilorgwidth			= 0
	Long			ilorgheight			= 0
	Long			il_xpos				= 0	//instance
	Long			il_ypos				= 0	//instance
	Long			ilscrollpos			= 0	// headerpointer, tooltiphelp, tooltipdata, scrollhorizontal
	Long			il_max4xpos			= 0
	Long			ilgetcurrent4row	= 0
	Long			il_hdledwtitle
	Long			il_hdleprintbutton
	Long			il_hdledwzoom
	Long			il_titlemargin2x	= PixelsToUnits(2, XPixelsToUnits!)
	Long			il_titlemargin2y	= PixelsToUnits(2, YPixelsToUnits!)
	Long			ilZoomXposMargin	= PixelsToUnits(12, XPixelsToUnits!)
	Long			ilZoomYposMargin	= PixelsToUnits(1, YPixelsToUnits!)

	String	isdberrorText = ''

	BOOLEAN	ib_range = FALSE	// 범위지정시 사용(clciked)

Protected:
	integer	iiUpdateStart = 0
	boolean	ibsetlist4filter2dwo		= false
	boolean	ibsetlist4filter2uo		= false
	boolean	ibsetlist4filtertip		= false
	boolean	ibsetlist4sort				= false
	boolean	ibsetlist4sorttip			= false
	
Public:
	window			iw_parent		// parent window
	fw_s_dberror	istr_dberror	// stored dberror information

	fw_n_style		inv_style
	fw_n_rowselect	inv_rowselect
	dwobject			idwo

	DATASTORE	ids_filter

	string	isobj2filter[], ischeck2filter[], islcheck2filter[], istext2filter[], isempty2filter[]
	string	isobj2sort[], isempty2sort[]

	boolean	i----------------------------------------------------line0	/* empty Object */
	// resize properties
	boolean	FixedToRight
	boolean	FixedToBottom
	boolean	ScaleToRight
	boolean	ScaleToBottom
	boolean	i----------------------------------------------------line1	/* empty Object */
	boolean	ibretrieve4defaultevent		= false
	boolean	ibconfirmupdate4rowchanged	= false
	string	isrowcheck4objupdate			= ''
	string	isrowcheck4objdelete			= ''
	boolean	ibrbtn4dwodefault				= false
	boolean	i----------------------------------------------------line2	/* empty Object */
	boolean	ibdesign4role		= true
	boolean	applydesign			= false
	boolean	useborder			= false
	boolean	ibresize4objwidth	= false
	boolean	ibdesign4cond		= false
	boolean	ibtitle4datawindow = false
	boolean	setbringtotop		= false
	boolean	zoominout			= false
	boolean	setfocusdw			= false
	boolean	setedittoken		= false
	boolean	ibsettooltiphelp	= false
	boolean	ibsettooltipdesc	= false
	boolean	ibsettooltipdata	= false
	boolean	designcache			= false
	boolean	cacheuseborder		= false
	boolean	i----------------------------------------------------line3	/* empty Object */
	boolean	ibsetlist4subbtn			= false
	string	islist4subbtnauth			= '0011111001'	/* 1:save, 2:load, 3:excel, 4:input, 5:copy, 6:delete, 7-10:first,prior,next,last */

	boolean	ibsetlist4excelclip		= false
	boolean	ibsetlist4clearselect	= false
	boolean	ibsetlist4singleselect	= true
	boolean	ibsetlist4multiselect	= false
	boolean	ibsetlist4alrowcolor		= true
	boolean	ibsetlist4mouseovercolor= true
	boolean	ibsetlist4hsplitscroll	= false
	boolean	ibsetlist4orgsizedesign	= false
	boolean	ibsetlist4tabudesign		= false
	string	setlist4fontpointcolor	= ''
	string	setlist4rowpointcolor	= ''
	string	setlist4backcolor			= ''
	string	setlist4headercolor		= ''
	string	setlist4summarycolor		= ''
	string	setlist4footercolor		= ''
	string	setlist4goupcolor1		= ''
	string	setlist4goupcolor2		= ''

	boolean	i----------------------------------------------------line4	/* empty Object */
	// 개발자 초기(Early) 설정값
	BOOLEAN	eb_fund_default_change = TRUE	// fund_cd 초기값 변경여부
	BOOLEAN	eb_Range_DelCopy = TRUE
	BOOLEAN	eb_Always_1_Insert = FALSE		// 항상 1 Row에 Insert
	BOOLEAN	eb_new_false = FALSE				// Inser, Append Disable
	BOOLEAN	eb_copy_false = FALSE			// Copy Disable
	BOOLEAN	eb_delete_false = FALSE			// Delete Disable
	BOOLEAN	eb_null_line = TRUE				// retrieve시 빈칸 입력여부
	// 우측 마지막 컬럼중 il_width_max크기와 맞게 재 설정할 컬럼(head_t, column 명이 같아야 함)
	STRING	is_resize_column
end variables

forward prototypes
public function string of_thisname ()
public function string of_getload4style ()
public function integer setposition (readonly string n, readonly string b, boolean t)
public function integer of_setdwrowselect (boolean ab_switch)
public function string of_getexpvalue (string as_exp, long al_row)
public function integer of_setbackgroundimage ()
public function string of_gettitle ()
public function string of_getlasterrortext ()
public function long of_getlasterrorcode ()
public subroutine of_setvisible (boolean ab_visible)
public function string of_getlastcolumnname ()
public function boolean of_isupdatable ()
public function integer of_addsearchcriteria ()
public function integer of_xlsxdircopya (string as_txtfile, string as_tempdir, string as_xlsxfile)
public function integer of_setdwdesign (boolean ab_applydesign, boolean ab_useborder)
public function integer of_setlist4subbtn ()
public subroutine of_setcolumnvisible (string as_column, integer ai_case)
public subroutine of_setbringtotop (boolean ab_boolean)
public function integer of_setzoomdw ()
public subroutine of_hsplitzoom (long al_now, long al_zoom)
public function boolean of_getdesigncache ()
public subroutine of_setdesigncache ()
public function long of_getscrollpos ()
public function string of_getdesignstyle ()
public function string of_getasissyntax ()
public function integer deleterow (long r)
public function long insertrow (long r)
public function string of_getsqlerrmsg ()
public subroutine of_getobjectsignup (ref string as_objs[])
public subroutine of_setexcel_saveas2st (boolean ab_boolean)
public subroutine of_setsaveas4excel (boolean ab_boolean)
public subroutine of_setsort_common (string as_sortgb)
public subroutine of_setgroup1st (string as_gb)
public subroutine of_setasissyntax (string asdwasissyntax)
public function boolean of_getdesign4role ()
public subroutine of_setcreatehandle ()
public subroutine of_setrbtnmenu (fw_m_dwrbutton am_menu)
public subroutine of_setfilterobj (fw_u_dw4filter au_dwbyfilter)
public subroutine of_setborderfocuscolor (boolean ab_boolean)
public subroutine of_setexcel_import1st ()
public function long of_getlist4goupcolor1 ()
public subroutine of_setdefault4dwo ()
public subroutine of_sethsplitobj (fw_u_dw4hsplit au_dw4hsplit)
public function integer of_settitle4datawindow ()
public function long of_getmax4xpos ()
public subroutine of_setdesignstyle (string as_style)
public function dwobject of_getdwobj ()
public function long of_getwidth4datawindow ()
public function long of_getcurrentrow ()
public function boolean of_getibsetlist4clearselect ()
public subroutine of_setcolumnvisible_1sub (string as_column, string as_gb)
public subroutine of_stc2off ()
public subroutine of_dw2subbtn (string as_btn_name[], boolean ab_enabled)
public function long of_getcolumnxpos2max ()
public function integer of_dwheightminus1value ()
public subroutine uf_resizecolumn ()
public function integer of_setdataobject (string as_dataobject)
public subroutine of_setdestroy2filter (string as_objtag)
public subroutine of_setdestroy2sort (string as_obj)
public subroutine uf_setrow (long row, boolean arg_rowfocuschanged)
public subroutine of_settitle4name (string arg_title)
public function boolean uf_filter ()
public function boolean uf_getrange ()
public subroutine uf_setrange (boolean ag_boolean)
end prototypes

event type boolean oue_components();Return True
end event

event mousemove;/* to-be design checking; dataobject 잘못 변경시 처리 */
If ApplyDesign = false Then
	If UseBorder = false Then
		If IsValid(inv_style) Then destroy inv_style
	End If
	Return
End If

/* to-be mouseovercolor -------------------------------------------------------*/
if ibsetlist4mouseovercolor = true then
	choose case il_mouseoverrow
		case 0, row
			//
		case else
			inv_handle.of_ibsetlist4mouseovercolor(row)
	end choose
	il_mouseoverrow = row
end if

string	ls_obj, ls_bandpointer
ls_obj = fw_f_nm4dwo(this, string(dwo.name))
if (ibsetlist4sort = true or ibsetlist4filter2dwo = true) and isvalid(inv_handle) and ls_obj <> 'datawindow' then
	ls_bandpointer = string(this.GetBandAtPointer())
	inv_handle.of_setsort_step2(true, ls_bandpointer, ls_obj, string(dwo.type), xpos, ypos)
end if
/* to-be ibsettooltiphelp -------------------------------------------------------*/
if ibsettooltiphelp= true and ls_obj <> 'datawindow' then
	inv_handle.of_ibsettooltiphelp(dwo, ls_obj, xpos, ypos)
end if
/* to-be ibsettooltipdata -------------------------------------------------------*/
if ibsettooltipdata= true and ls_obj <> 'datawindow' then
	inv_handle.of_ibsettooltipdata(dwo, ls_obj, row, xpos, ypos)
end if
/* to-be ibsettooltipdesc -------------------------------------------------------*/
if ibsettooltipdesc= true and ls_obj <> 'datawindow' then
	inv_handle.of_ibsettooltipdesc(dwo, ls_obj, row, xpos, ypos)
end if

/* to-be ibpush4message -------------------------------------------------------*/
//<임시> 조회가 많이되어 수정하였습니다.
IF secondsafter (gw_mdi.itmessagetime, now())>gw_mdi.ilmessagecycle	Then
	gw_mdi.itmessagetime = now()
	gw_mdi.of_set_message (TRUE)
End IF
end event

event oue_dataobjectchanged();if isValid(inv_style) 		then	destroy inv_style
if isValid(inv_rowselect)	then	destroy inv_rowselect
if isValid(inv_handle)		then	destroy inv_handle

if long(this.describe("datawindow.column.count")) = 0 then Return
if Not isValid(iw_parent) then iw_parent = fw_f_obj4parentwindow(this) // get parent window
isdesignstyle = Lower(of_getload4style()) // get dwobject presentation style
this.of_setcreatehandle()
this.of_setdwdesign(Applydesign, UseBorder) // use dw design service

if isValid(inv_style) then
	Choose Case isdesignstyle
		Case 'grid', 'tabular'
			if fw_f_nvls(setlist4fontpointcolor, '') <> '' then inv_style.of_setlist4fontpointcolor(setlist4fontpointcolor)
			if fw_f_nvls(setlist4rowpointcolor, '') <> '' then inv_style.of_setlist4rowpointcolor(setlist4rowpointcolor)
			/* datawindow backcolor, SetGoupColor1, SetGoupColor2, summary, footer */
			inv_style.of_setlist4backcolor(setlist4backcolor)
			inv_style.of_setlist4headercolor(setlist4headercolor)
			IF	applydesign=false	Then	// 출력화면으로 처리
				ibsetlist4clearselect = false
				ibsetlist4singleselect = false
				ibsetlist4multiselect = false
			End IF			
			inv_style.of_setlist4summarycolor(setlist4summarycolor)
			inv_style.of_setlist4footercolor(setlist4footercolor)
			inv_style.of_setlist4goupcolor1(setlist4goupcolor1)
			inv_style.of_setlist4goupcolor2(setlist4goupcolor2)
	End Choose	
	
	if designcache = true then
		this.of_setdesigncache()
	Else
		if applydesign = true then inv_style.of_applydesign()
	End if
	
	if this.titlebar = false and this.controlmenu = false then
		/* dataWindow Border Active */
		if UseBorder = true then inv_style.of_drawcustomborder()
		/* dataWindow Cache Border Active */
		if CacheUseBorder = true then inv_handle.of_setcacheborder()
	End if

	if ibresize4objwidth = true then
		inv_handle.of_setobjresize2define()
	End if
End if

// use dw row-select serivce
if ibsetlist4clearselect = false and (ibsetlist4multiselect = true or ibsetlist4singleselect = true) then this.of_setdwrowselect(true)
//if ibsetlist4multiselect = true or (ibsetlist4singleselect = true and ibsetlist4clearselect = false) then this.of_setdwrowselect(true)

this.post event oue_bringtotop() /* Bringto top; script design 후에 적용해도 정상 */

if ibtitle4datawindow = true then this.post of_settitle4datawindow() // draw datawindow title

if zoominout = true then this.post of_setzoomdw() //draw of_setzoomdw

if ibsetlist4subbtn = true then this.post of_setlist4subbtn() //draw ibsetlist4subbtn
end event

event move;If IsValid(inv_style) Then
	inv_style.of_move(xpos, ypos)
End If

If IsValid(ivo_dw2title) Then
	ivo_dw2title.x = xpos //- il_titlemargin2x
	ivo_dw2title.y = ypos - gnv_vari.il_dwheightminus1value
End If

If IsValid(ivo_dw2subbtn) Then ivo_dw2subbtn.y = ypos - gnv_vari.il_dwheightminus1value

/* zoom dw toolbar resize*/
If IsValid(ivo_dw2zoom) Then
	ivo_dw2zoom.x = xpos - ilZoomXposMargin
	ivo_dw2zoom.y = ypos - ilZoomYposMargin
End If
end event

event oue_keydown;// 클립보드 데이터를 데이터윈도우에 붙여넣기 합니다.
If ibsetlist4excelclip = false        Then return 0
If not (keyflags = 2 and key = KeyV!) Then return 0

string	ls_rows[], ls_fields[]
string	ls_data, ls_columnname

long	ll_rowcnt, ll_currrow
long	ll_fieldcnt, i, j

// get current row
ll_currrow = this.getrow()
If ll_currrow = 0 Then return 0

// get current column
ls_columnname = this.getcolumnname()
If ls_columnname = "" Then return 0

// get data from clipboard
ls_data = trim(::clipboard())
If len(ls_data) = 0 Then return 0

// parse the clipboard data into row
If right(ls_data, 2) = "~r~n" Then	ls_data = left(ls_data, len(ls_data) - 2)
If Pos(ls_data, "~r~n") < 1 Then Return

// parse the clipboard data into row
ll_rowcnt = fw_f_obj2array(ls_data, "~r~n", ls_rows[])
for i = 1 to ll_rowcnt	
	// parse the row data into field
	ll_fieldcnt = fw_f_obj2array(ls_rows[i], "~t", ls_fields[])
	for j = 1 to ll_fieldcnt
		// paste data
		ls_fields[j] = trim(ls_fields[j])
		this.settext(ls_fields[j])
		// move focus to the next column
		If j < ll_fieldcnt Then
			sEnd(handle(this), 256, 9, long(0,0))
		End If
	next
	
	// move focus to the next row
	If i < ll_rowcnt Then
		ll_currrow ++
		If ll_currrow > this.rowcount() Then
			this.insertrow(0)
		End If
		
		this.scrolltorow(ll_currrow)
		this.setrow(ll_currrow)
		this.setcolumn(ls_columnname)
	End If
next

return 1
end event

event oue_setvisible(boolean ab_visible);this.visible = ab_visible
If Isvalid(ivo_dw2title)	Then ivo_dw2title.visible = ab_visible
If Isvalid(ivo_dw2zoom)		Then ivo_dw2zoom.visible = ab_visible
If Isvalid(ivo_dw2subbtn)	Then ivo_dw2subbtn.visible = ab_visible
If Isvalid(ivo_dw4filter)	Then ivo_dw4filter.visible = ab_visible
If Isvalid(ivo_dw4hsplit)	Then ivo_dw4hsplit.visible = ab_visible
If Isvalid(inv_style)		Then inv_style.Post of_drawbordervisible(ab_visible)
end event

event oue_dwowidthchanged();If Isvalid(inv_handle) Then inv_handle.Event oue_dwowidthchanged(ilscrollpos)
end event

event oue_postopen();gnv_extfunc.biznode1te(124, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
this.triggerevent(gnv_extfunc.is_nodevalue)
gnv_extfunc.biznode1te(125, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
this.triggerevent(gnv_extfunc.is_nodevalue)
if fw_f_nvls(isasissyntax4dwo, '') = '' then isasissyntax4dwo = this.describe("DataWindow.Syntax") /* Check variable syntax, dwo, xpos, ypos position update */
this.post event oue_lastopen()

end event

event oue_setredraw(boolean ab_boolean);This.SetRedRaw ( ab_boolean )
end event

event oue_error4database(long al_errorcode, string as_errortext, string as_syntax, long al_row, dwbuffer adwb_buffer);STRING   ls_text, ls_errormsg

ls_text			= 'No changes made to database.'
isdberrorText	= mid (as_errortext, 1, Pos(as_errortext, ls_text) - 1)
ls_errormsg += string(gnv_vari.ilupdate4error2num) + "번째 datawindow에서 발생~r~n~r~n"
Choose Case al_errorcode
   Case 1
      Beep (1)
		//::clipboard (as_syntax)
		ls_errormsg += "데이터입력오류 : 키 부분에 발생~r~n"
		ls_errormsg += "문제 : 이미 사용한 키를 다시 사용 하였습니다.~r~n"
		ls_errormsg += "해결방안 : 다른 키값을 사용하시요.~r~n"
		ls_errormsg += "내역 : " + string (al_errorcode) + " " + as_errortext + "~r~n" + as_syntax
   Case -194
      Beep (1)
		//::clipboard (as_syntax)
		ls_errormsg += "데이터입력오류 : 해당정보 없습~r~n"
		ls_errormsg += "문제 : 해당값은 다른 테이블과 관련이 없습니다.~r~n"
		ls_errormsg += "해결방안 : 해당값을 확인후 수정하시오.~r~n"
		ls_errormsg += "내역 : " + string (al_errorcode) + " " + as_errortext + "~r~n" + as_syntax
   Case -195
      Beep (1)
		::clipboard (as_syntax)
		ls_errormsg += "데이터입력오류 : 값 오류~r~n"
		ls_errormsg += "문제 : 반드시 입력해야될 값이 있습니다.~r~n"
		ls_errormsg += "해결방안 : 반드시 입력해야될 값을 입력하시오.~r~n"
		ls_errormsg += "내역 : " + string (al_errorcode) + " " + as_errortext + "~r~n" + as_syntax
   Case -198
      Beep (1)
		//::clipboard (as_syntax)
		ls_errormsg += "데이터입력오류 : 해당정보 문제~r~n"
		ls_errormsg += "문제 : 키값이 변경되어 관련정보를 삭제할수 없습니다.~r~n"
		ls_errormsg += "해결방안 : 수정 완료후 다시 삭제하시오.~r~n"
		ls_errormsg += "내역 : " + string (al_errorcode) + " " + as_errortext + "~r~n" + as_syntax
   Case -209
      Beep (1)
		//::clipboard (as_syntax)
		ls_errormsg += "데이터오류 : 틀린값 존재~r~n"
		ls_errormsg += "문제 : 하나 또는 그이상의 틀린값이 존재합니다.~r~n해결방안: 확인후 정확한 값을 입력하시오.~r~n"
		ls_errormsg += "내역 : " + string (al_errorcode) + " " + as_errortext + "~r~n" + as_syntax
   Case Else
      Beep (1)
		//::clipboard (as_syntax)
		ls_errormsg += "데이터오류~r~n"
		ls_errormsg += "데이터베이스에 데이터 오류가 발생되었습니다.~r~n내용은 아래와 같습니다.~r~n"
		ls_errormsg += "sqldbcode : " + string (al_errorcode) + "~r~n~r~n" + as_errortext + "~r~n" + as_syntax + "~r~n"
		ls_errormsg += "관리자에게 연락하십시오"
      //POST CLOSE (gw_mdi)
End Choose

gnv_vari.iserror2window = iw_parent.classname()
fw_f_collect4error(ls_errormsg)
end event

event oue_bringtotop();of_SetBringtoTop(SetBringtoTop)
end event

event oue_settransobject();settransobject (SQLCA)
end event

event oue_lastopen();ibopening = false
end event

event buttonup;IF DESCRIBE (STRING (DWO.NAME) +  '.edit.style')='dddw' THEN f_dddwidth (THIS, STRING (DWO.NAME))
CHOOSE CASE isdesignstyle
   CASE 'grid','tabular'
      IF isdesignstyle='grid' AND fw_f_nm4dwo(this, STRING(DWO.NAME)) <> 'datawindow'  Then
         POST EVENT oue_dwowidthchanged()
      END IF
      IF (ibsetlist4sort=true OR ibsetlist4filter2dwo=true) AND IsValid(inv_handle) Then
         inv_handle.of_setsorthide()
         inv_handle.POST of_setsort_step2 (false, STRING(This.GetBandAtPointer()), STRING(DWO.NAME), STRING(DWO.type), xpos, ypos)
      END IF
END CHOOSE
end event

event type integer deleterowstart(long row);If fw_f_nvls(isrowcheck4objdelete, '') <> '' Then
	If iw_parent.dynamic of_getobjdwbyname(isrowcheck4objdelete) = -1 Then
		Messagebox("Error",  "Delete Row Check DataWindow가 맞지 않습니다.")
		Return -1
	Else
		If iw_parent.dynamic of_rtnmodifyrowbycheck('DEL') = -1 Then
			Return -1
		End If
	End If
End If
Return 1
end event

event type integer insertrowstart(long row);Return 1
end event

event type integer oue_setupdatecheck();Return 1
end event

event oue_setedittoken44();gnv_extfunc.biznode1te(147, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
inv_handle.TriggerEvent(gnv_extfunc.is_nodevalue)
end event

event oue_error4datawindow(long al_errorcode, string as_errortext, string as_syntax, long al_row);string	ls_errormsg = ''

ls_errormsg += "데이터윈도우 오류가 발생되었습니다.~r~n내용은 아래와 같습니다.~r~n"
ls_errormsg += string (al_errorcode) + "~r~n~r~n" + as_errortext + "~r~n" + as_syntax + "~r~n"
ls_errormsg += "관리자에게 연락하십시오"

gnv_vari.iserror2window = iw_parent.classname()
fw_f_collect4error(ls_errormsg)
end event

event oue_subbtn_firstpage();This.ScrollToRow(1)
end event

event oue_subbtn_nextpage();This.ScrollNextPage()
end event

event oue_subbtn_priorpage();This.ScrollPriorPage()
end event

event oue_subbtn_lastpage();This.ScrollToRow ( This.RowCount() )
end event

event itemchanged_next(long row, string name);Accepttext()
end event

event ue_dddw_retrieve();/*	Sample......	[WDDDWCTL TABLE]
	-	"DDDWID"		:	dddw에 사용될 Column Name [ | DB column 명]
	-	"추가컬럼"	:	'%,전체,key[,...]' 추가할 컬럼 (3개로 맞춰야 함)
	-	CORP_GR		:	회사코드
	-	SEQ			:	Sql_Col_nm의 중복을 막고자 Seq 번호를 부여하여 사용한다.
	-	"SQL_Where" :	추가 Where절 -> "grpcode='01' And subcode<>'.'")
	
f_dddwctl (THIS, 'DDDWID', corp_gr, "%,전체,", 1, "SQL_Where")
uf_dddwctl ('DDDWID', dw_2, 'DDDWID', corp_gr, "%,전체,", 1, "SQL_Where")   Share 처리
*/
end event

public function string of_thisname ();return 'fw_u_dwo'

end function

public function string of_getload4style ();// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

// 조회조건 Datawindow
If ibdesign4cond = true then 
	return 'cond'
End If

//as-is // Preview Datawindow
//Choose Case lower(this.describe("DataWindow.Print.Preview"))
//	Case 'yes', '1'
//		return 'PrintPreview'
//End Choose

string ls_processing, ls_style

ls_processing = this.describe("datawindow.processing")
Choose Case long(ls_processing)
	Case 0
		Choose Case ibsetlist4tabudesign
			Case True
				ls_style = "tabular"
			Case Else
				//FreeForm인 경우 : detail band height가 dw control의 height의 2.5배 미만(만약 Header가 있는경우를 대비)
				long ll_detailheight, ll_dwcontrolheight, ll_headerheight
				
				ll_headerheight = long(this.describe("Datawindow.Header.Height"))
				ll_detailheight = long(this.describe("Datawindow.Detail.Height"))
				ll_dwcontrolheight = This.Height
				
				If ll_headerheight > pixelstounits(10, ypixelstounits!) then
					ls_style = "tabular"
				ElseIf ll_detailheight * 2.2 < ll_dwcontrolheight then
					ls_style = "tabular"
				Else
					ls_style = "freeform"
				End If
		End Choose
	Case 1
		ls_style = 'grid'
	Case 2
		ls_style = 'label'
	Case 3
		ls_style = 'graph'
	Case 4
		ls_style = 'crosstab'
	Case 5
		ls_style = 'composite'
	Case 6
		ls_style = 'ole'
	Case 7
		ls_style = 'richtext'
	Case 8
		ls_style = 'treeview'
	Case 9
		ls_style = 'treeviewwithgrid'
	Case Else
		ls_style = 'etc'
End Choose

return ls_style

end function

public function integer setposition (readonly string n, readonly string b, boolean t);// Appeon용 SetPosition 함수
// 속도 문제가 있기 때문에 자주 사용하지 마세요

if gnv_vari.getclienttype = 'PB' then return super::setposition(n, b, t)

blob lblb_data
string ls_syntax
string ls_header, ls_detail, ls_footer
string ls_lnbuf[]
long ll_pos, ll_lastpos, ll_cnter
integer i

// 변경사항 보관
this.getchanges(lblb_data)

// Datawindow Syntax 를 Header, Detail, Footer로 구분
ls_syntax = describe("datawindow.syntax")

ll_pos = pos(ls_syntax, ')) )~r~n')
if ll_pos > 0 then
	ll_pos += 5
	ls_header = left(ls_syntax, ll_pos)
else
	ll_pos = pos(ls_syntax, '~r~n )~r~n')
	if ll_pos > 0 then
		ll_pos += 4
		ls_header = left(ls_syntax, ll_pos)
	else
		return -1
	end if
end if

ll_lastpos = lastpos(ls_syntax, 'htmltable(')
if ll_lastpos > 0 then
	ls_detail = mid(ls_syntax, ll_pos + 1, ll_lastpos - ll_pos - 1)
	ls_footer = mid(ls_syntax, ll_lastpos)
else
	ls_detail = mid(ls_syntax, ll_pos + 1)
end if

// SetPosition 대상 Syntax Line을  최상단 또는 최하단에 배치
ll_cnter = fw_f_obj2array(ls_detail, ' )~r~n', ls_lnbuf)

string ls_colname
string ls_outdetail
string ls_postarget

for i = 1 to ll_cnter
	ll_pos = pos(ls_lnbuf[i], 'name=')
	if ll_pos > 0 then
		ll_lastpos = pos(ls_lnbuf[i], ' ', ll_pos + 1)
		if ll_lastpos > 0 then
			ls_colname = mid(ls_lnbuf[i], ll_pos + 5, ll_lastpos - ll_pos - 5)
			if ls_colname = n then
				ls_postarget = ls_lnbuf[i] + ' )~r~n'
			else
				ls_outdetail += ls_lnbuf[i] + ' )~r~n'
			end if
		end if
	end if
next

if t = true then
	ls_outdetail = ls_outdetail + ls_postarget
else
	ls_outdetail = ls_postarget + ls_outdetail
end if

// DW Create
string ls_error

if this.create(ls_header + ls_outdetail + ls_footer, ls_error) = -1 then
	messagebox('SetPosition', 'DW Creation Failure!~r~n' + ls_error)
	return -1
end if

// 변경사항 복구
this.setchanges(lblb_data)

return 1

end function

public function integer of_setdwrowselect (boolean ab_switch);// grid, tabular 스타일만 RowSelect 가능
Choose Case isdesignstyle
	Case 'grid', 'tabular', 'crosstab'
	Case else
		return 0
End Choose

If ab_switch = true then
	If not isvalid(inv_rowselect) then
		inv_rowselect = create fw_n_rowselect
		inv_rowselect.of_initialize(this)
	End If
else
	If isvalid(inv_rowselect) then
		destroy inv_rowselect
	End If
End If

Return 1

end function

public function string of_getexpvalue (string as_exp, long al_row);String ls_quote = '"', ls_exp

If Pos( as_exp, '"' ) > 0 Then ls_quote = "'"
ls_exp = 'evaluate(' + ls_quote + as_exp + ls_quote + ',' + String( al_row ) + ')'

return string(this.describe(ls_exp))

end function

public function integer of_setbackgroundimage ();string ls_backgroundimage
string ls_band, ls_syntax, ls_errmsg

// background 용 bitmap 생성
ls_backgroundimage = this.describe("pf_background.Filename")
if ls_backgroundimage = '!' then
	ls_backgroundimage = gnv_vari.is_tempdirectory + gnv_extfunc.of_getuniqpicturename(this) + "_background.jpg"
	if gnv_extfunc.of_getbackdropcontrolimg(this, ls_backgroundimage) = false then
		messagebox('Notice', '배경화면 생성 실패!')
		return -1
	end if
	
	// appeon은 background/foreground band속성 미지원
	if gnv_vari.getclienttype = 'WEB' then
		if long(this.describe("datawindow.header.height")) > 0 then
			ls_band = 'header'
		else
			ls_band = 'detail'
		end if
	else
		ls_band = 'background'
	end if
	
	ls_syntax = 'bitmap(band=' + ls_band + ' filename="' + ls_backgroundimage + '" x="0" y="0" height="' + string(this.height) + '" width="' + string(this.width) + '" border="0"  name=pf_background visible="1" )'
	
	// Appeon은 SetPosition 함수 미지원, background 이미지를 syntax 
	// 맨 위로 올려서 새롭게 create 해야함
	if gnv_vari.getclienttype = 'WEB' then
		string ls_dwsyntax
		long ll_pos
		
		ls_dwsyntax = this.describe("datawindow.syntax")
		ll_pos = pos(ls_dwsyntax, '~r~n)~r~n')
		if ll_pos > 0 then
			ls_dwsyntax = replace(ls_dwsyntax, ll_pos + 5, 0, ls_syntax + '~r~n')
			if this.create(ls_dwsyntax, ls_errmsg) = -1 then
				::clipboard(ls_dwsyntax)
				messagebox('create error', 'of_registerparent()=' + ls_errmsg)
				return -1
			end if
		end if
	else
		ls_errmsg = this.modify('create ' + ls_syntax)
		if len(ls_errmsg) > 0 then
			::clipboard(ls_syntax)
			messagebox('modify error', 'of_registerparent()=' + ls_errmsg)
			return -1
		end if
	end if
end if

return 1

end function

public function string of_gettitle ();// 데이터윈도우 타이틀을 리턴합니다
// 타이틀이 설정되지않은 경우 Classname() 값을 리턴 합니다
// 리턴값: 데이터윈도우 타이틀
string ls_title

ls_title = string(this.title)
if len(trim(ls_title)) = 0 then
	ls_title = string(this.classname())
end if

return ls_title

end function

public function string of_getlasterrortext ();return istr_dberror.sqlerrtext

end function

public function long of_getlasterrorcode ();return istr_dberror.sqldbcode

end function

public subroutine of_setvisible (boolean ab_visible);This.Event oue_setvisible(ab_visible)
end subroutine

public function string of_getlastcolumnname ();// 데이터윈도우의 가장 마지막 컬럼(=Max TabOrder)를 찾습니다.
// 컬럼이 Visible = false 이거나 Protect = true 인 경우는 제외 됩니다.
// Appeon 에서 pbm_dwntabout 이벤트를 지원하지 않기 때문에 이 함수로
// 마지막 컬럼을 확인합니다.

if isnull(this) then return ''
if not isvalid(this) then return ''

integer li_columncnt, i, li_maxcolumn
integer li_tabseq, li_maxtabseq
long ll_pos
string ls_maxcolumn, ls_columnname
string ls_visible, ls_protect

li_columncnt = integer(this.describe("datawindow.column.count"))
for i = 1 to li_columncnt
	li_tabseq = integer(this.Describe("#" + string(i) + ".TabSequence"))
	ls_columnname = this.describe("#" + string(i) + ".Name")
	
	ls_protect = this.describe(ls_columnname + ".Protect")
	ll_pos = pos(ls_protect, '~t')
	
	// Expression 포함된 경우
	If ll_pos > 0 Then
		ls_protect = mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)
		ls_protect = this.describe("Evaluate(~"" + ls_protect + "~", " + string(this.getrow()) + ")")
	End If	
	
	ls_visible = this.describe(ls_columnname + ".visible")
	ll_pos = pos(ls_visible, '~t')
	// Expression 포함된 경우
	If ll_pos > 0 Then
		ls_visible = mid(ls_visible, ll_pos + 1, len(ls_visible) - ll_pos - 1)
		ls_visible = this.describe("Evaluate(~"" + ls_visible + "~", " + string(this.getrow()) + ")")
	End If	
	
	// Visible=0 또는 Protect=1 인 경우 Skip
	if ls_visible = '0' or ls_protect = '1' then continue
	
	if li_tabseq > li_maxtabseq then
		li_maxtabseq = li_tabseq
		ls_maxcolumn = ls_columnname
	end if
next

if li_maxtabseq = 0 then
	// 컬럼이 없거나 입력 가능한 컬럼(TabSequence>0) 이 없음?
	return ''
else
	return ls_maxcolumn
end if

end function

public function boolean of_isupdatable ();return ib_isUpdatable

end function

public function integer of_addsearchcriteria ();//// WHERE 절에 조건을 추가합니다
//
//pf_n_regexp lnv_regexp
//string ls_query, ls_objref[]
//long ll_refcnt, i
//
//ls_query = this.GetSqlSelect()
//messagebox("ls_query", ls_query)
//
//lnv_regexp = create pf_n_regexp
////ll_refcnt = lnv_regexp.of_findmatches(ls_query, "(\w+\.\w+(\[\d+\])?)", ls_objref[])
//ll_refcnt = lnv_regexp.of_findmatches(ls_query, "/[\s,]*\\\~"([^\\\~"]+)\\\~"[\s,]*|~" . ~"[\s,]*'([^']+)'[\s,]*|~" . ~"[\s,]+/~"", ls_objref[])
//
////messagebox('expression', "/[\s,]*\\\~"([^\\\~"]+)\\\~"[\s,]*|~" . ~"[\s,]*'([^']+)'[\s,]*|~" . ~"[\s,]+/")
//
//for i = 1 to ll_refcnt
//	messagebox(string(i), ls_objref[i])
//next
//
//destroy lnv_regexp
return 0

end function

public function integer of_xlsxdircopya (string as_txtfile, string as_tempdir, string as_xlsxfile);long                     ll_rtn
oleobject               lole_excel
 
lole_excel = Create oleobject
   
ll_rtn = lole_excel.ConnectToNewObject("excel.application")
If ll_rtn = 0 Then
	lole_excel.Application.DisplayAlerts = False
	lole_excel.Application.WorkBooks.OpenText(as_txtfile)
	
	lole_excel.ActiveWorkbook.Sheets(1).Cells.Select			// 전체 CELL 선택
	lole_excel.Selection.Font.Size = 10 
	lole_excel.ActiveSheet.Columns.AutoFit						// 자동으로 열 너비 조정	
	lole_excel.ActiveWorkbook.sheets(1).Cells(1,1).select		// Cells(1,1)로 Focus 지정
	
	// as-is
	//lole_excel.Application.ActiveWorkbook.SaveAs(ls_xlsxFile, 51)
	// to-be
	lole_excel.Application.ActiveWorkbook.SaveAs(as_tempdir, 51)
	
	lole_excel.Application.Workbooks.Close
Else
	Close(w_loadingmsg)
	MessageBox('ConnectToNewObject Error',string(ll_rtn))
End If
 
lole_excel.DisconnectObject()
DESTROY lole_excel

FileDelete(as_txtfile)
//Messagebox('', as_tempdir)

//to-be file 이동 후 삭제
Boolean	lb_flag, lb_rtn

lb_flag = false // 파일이 존재할 경우 오버라이트

lb_rtn = gnv_extfunc.CopyFileA(as_tempdir, as_xlsxFile, lb_flag)
If lb_rtn = false Then
	Close(w_loadingmsg)
	MessageBox("Check", "System temp : " + as_xlsxFile + " Copy False")
	Return -1
End If

lb_rtn = gnv_extfunc.DeleteFile(as_tempdir)
If lb_rtn = false Then
	Close(w_loadingmsg)
	MessageBox("Check", as_tempdir + " delete False")
	Return -1
End If

Return 1
end function

public function integer of_setdwdesign (boolean ab_applydesign, boolean ab_useborder);If ab_applydesign = false and ab_useborder = false Then /* design 과 border 분리 */
	If IsValid(inv_style)		Then Destroy inv_style
	If IsValid(fw_n_handle)	Then Destroy fw_n_handle
Else
	If Not Isvalid(inv_style) Then
		Choose Case isdesignstyle
			Case 'grid'
				inv_style = Create fw_n_style_grid
			Case 'tabular'
				inv_style = Create fw_n_style_tabu
			Case 'freeform'
				inv_style = Create fw_n_style_free
			Case 'cond'
				inv_style = Create fw_n_style_cond
			Case 'crosstab'
				inv_style = Create fw_n_style_crtab
			Case 'treeview'
				inv_style = Create fw_n_style_trview
			Case else
				Return 0
		End Choose
		inv_style.of_initialize(this, iw_parent, inv_handle)
	End If
End If

Return 1
end function

public function integer of_setlist4subbtn ();IF IsValid(ivo_dw2subbtn) AND ibsetlist4subbtn=False  Then
   ivo_dw2subbtn.Hide()
   IF Parent.typeof()=userobject! THEN gnv_extfunc.setparent(handle(ivo_dw2subbtn), il_hdleprintbutton)
   iw_parent.CloseUserObject (ivo_dw2subbtn)
   DESTROY ivo_dw2subbtn
   RETURN no_action
END IF
IF IsValid(ivo_dw2subbtn)   THEN RETURN no_action
IF ibsetlist4subbtn=False THEN RETURN no_action

// backup message object before OpenUserObject()
MESSAGE  lm_backup

lm_backup = CREATE MESSAGE

lm_backup.Handle          = MESSAGE.Handle
lm_backup.NUMBER          = MESSAGE.NUMBER
lm_backup.WordParm        = MESSAGE.WordParm
lm_backup.LongParm        = MESSAGE.LongParm
lm_backup.DOUBLEPARM      = MESSAGE.DOUBLEPARM
lm_backup.StringParm      = MESSAGE.StringParm
lm_backup.PowerObjectParm = MESSAGE.PowerObjectParm
lm_backup.Processed       = MESSAGE.Processed
lm_backup.ReturnValue     = MESSAGE.ReturnValue

STRING	ls_islist4subbtnauth
LONG	ll_xpos, ll_ypos, ll_height, ll_width

ll_ypos = This.y - gnv_vari.il_dwheightminus1value

iw_parent.OpenUserObjectWithParm (ivo_dw2subbtn, this, ll_xpos, ll_ypos)

IF parent.typeof()=userobject!   Then
   il_hdleprintbutton = gnv_extfunc.getparent (handle(ivo_dw2subbtn))
   gnv_extfunc.setparent (handle(ivo_dw2subbtn), handle(parent))
END IF

IF Isvalid(ivo_dw2subbtn)  Then
   ls_islist4subbtnauth = islist4subbtnauth
   IF eb_new_false    THEN ls_islist4subbtnauth=REPLACE (ls_islist4subbtnauth, 4, 1, '0')
   IF eb_copy_false   THEN ls_islist4subbtnauth=REPLACE (ls_islist4subbtnauth, 5, 1, '0')
   IF eb_delete_false THEN ls_islist4subbtnauth=REPLACE (ls_islist4subbtnauth, 6, 1, '0')
   ivo_dw2subbtn.of_setButtonAuth (ls_islist4subbtnauth)
   ivo_dw2subbtn.x          = this.x + this.width - ivo_dw2subbtn.width + pixelstounits (1, ypixelstounits!)
   ivo_dw2subbtn.width      = ivo_dw2subbtn.width
   ivo_dw2subbtn.VISIBLE    = this.VISIBLE
   ivo_dw2subbtn.BringToTop = TRUE

   ivo_dw2subbtn.of_initparent (iw_parent, This, inv_style) /* init value */
END IF

// restore message object
MESSAGE.Handle          = lm_backup.Handle
MESSAGE.NUMBER          = lm_backup.NUMBER
MESSAGE.WordParm        = lm_backup.WordParm
MESSAGE.LongParm        = lm_backup.LongParm
MESSAGE.DOUBLEPARM      = lm_backup.DOUBLEPARM
MESSAGE.StringParm      = lm_backup.StringParm
MESSAGE.PowerObjectParm = lm_backup.PowerObjectParm
MESSAGE.Processed       = lm_backup.Processed
MESSAGE.ReturnValue     = lm_backup.ReturnValue

RETURN 1
end function

public subroutine of_setcolumnvisible (string as_column, integer ai_case);string	ls_error
string	ls_sort2check = 'no'

If this.describe("#"+String(1)+".name") = as_column and ibsetlist4sort = True and isvalid(inv_handle) Then
	ls_sort2check = 'yes'
	of_setcolumnvisible_1sub(as_column, '01')
End If
This.SetRedRaw( false )
ls_error = This.modify(as_column + ".Visible='" + string(ai_case) +"'")
If len(ls_error) > 0 Then
	messagebox("Error", as_column + ' Column 명을 확인해 주십시요')
	Return
End If
If ls_sort2check = 'yes' Then
	post of_setcolumnvisible_1sub(as_column, '02')
End If
This.SetRedRaw( true )
end subroutine

public subroutine of_setbringtotop (boolean ab_boolean);//BringToTop
this.BringToTop = ab_boolean

If IsValid(inv_style) Then
	/* DataWindow Border positon */
	If UseBorder = True and this.titlebar = false and this.controlmenu = false Then inv_style.of_drawborderpos()
End If

If IsValid(ivo_dw2zoom) Then
	ivo_dw2zoom.SetPosition(ToTop!, This)
End If
end subroutine

public function integer of_setzoomdw ();If IsValid(ivo_dw2zoom) and ZoomInOut = False Then
	ivo_dw2zoom.Hide()
	If Parent.typeof() = userobject! Then gnv_extfunc.setparent(handle(ivo_dw2zoom), il_hdledwzoom)
	iw_parent.CloseUserObject(ivo_dw2zoom)
	Destroy ivo_dw2zoom
	Return no_action
End If
If ZoomInOut = False Then Return no_action
If IsValid(ivo_dw2zoom) Then Return no_action

// backup message object before OpenUserObject()
message lm_backup
lm_backup = create message
lm_backup.Handle = message.Handle
lm_backup.Number = message.Number
lm_backup.WordParm = message.WordParm
lm_backup.LongParm = message.LongParm
lm_backup.DoubleParm = message.DoubleParm
lm_backup.StringParm = message.StringParm
lm_backup.PowerObjectParm = message.PowerObjectParm
lm_backup.Processed = message.Processed
lm_backup.ReturnValue = message.ReturnValue

long		ll_xpos, ll_ypos
long		ll_height, ll_width
Long		ll_ret

ll_xpos = This.x - ilZoomXposMargin
ll_ypos = This.y - ilZoomYposMargin

ll_ret = iw_parent.OpenUserObjectWithParm(ivo_dw2zoom, This, ll_xpos, ll_ypos)

If parent.typeof() = userobject! then
	il_hdledwzoom = gnv_extfunc.getparent(handle(ivo_dw2zoom))
	gnv_extfunc.setparent(handle(ivo_dw2zoom), handle(parent))
End If

If Isvalid(ivo_dw2zoom) Then
	ivo_dw2zoom.visible = This.visible
	ivo_dw2zoom.SetPosition(ToTop!, This)
	ivo_dw2zoom.of_initparent(iw_parent, This, inv_style) /* init value */
End If

// restore message object
message.Handle = lm_backup.Handle
message.Number = lm_backup.Number
message.WordParm = lm_backup.WordParm
message.LongParm = lm_backup.LongParm
message.DoubleParm = lm_backup.DoubleParm
message.StringParm = lm_backup.StringParm
message.PowerObjectParm = lm_backup.PowerObjectParm
message.Processed = lm_backup.Processed
message.ReturnValue = lm_backup.ReturnValue
Return 1
end function

public subroutine of_hsplitzoom (long al_now, long al_zoom);If IsValid( ivo_dw4hsplit ) Then ivo_dw4hsplit.Dynamic of_zoom( al_now + al_zoom )
end subroutine

public function boolean of_getdesigncache ();Return DesignCache
end function

public subroutine of_setdesigncache ();String		ls_createsyntaxgb, ls_error
String		ls_pgm_id, ls_dwname, ls_dataobject, ls_dwobjnm
String		ls_object[]
String		ls_temp, ls_band, ls_objtype, ls_objuseellipsis, ls_objtiphelp
String		ls_tooltipArrHelp[], ls_tooltipArrHelpNull[]
String		ls_tooltipArrData[], ls_tooltipArrDataNull[]
Long		ll_objcnt, i, ll_ret

ls_tooltipArrHelp	= ls_tooltipArrHelpNull /* init */
ls_tooltipArrData	= ls_tooltipArrDataNull /* init */

Choose Case gnv_vari.getclienttype
	Case 'PB'
		If gnv_vari.SetCacheSignupIP = gnv_vari.is_ipaddress Then
			ls_createsyntaxgb = inv_handle.of_getdesignsyntaxcs()
		Else
			ls_createsyntaxgb = 'empty'
		End If
	Case 'WEB'
		ls_createsyntaxgb = inv_handle.of_getdesignsyntaxweb()
End Choose

If fw_f_nvls(ls_createsyntaxgb, '') = '' Then ls_createsyntaxgb = 'empty'
If ls_createsyntaxgb = '9' Then
	/* to-be lb_designcache true 일때 Tooltip 별도 처리 구현 */
	ls_temp = This.describe("Datawindow.Objects")
	ll_objcnt = fw_f_obj2array(ls_temp, "~t", ls_object[])	
	//If upperbound(ls_object[]) > 0 Then inv_handle.Event oue_setobjectsignup(ls_object[])
	
	/* to-be */
	ls_pgm_id		= iw_parent.Classname()
	ls_dwname		= This.Classname()
	ls_dataobject	= This.DataObject
	ls_dwobjnm		= lower(ls_pgm_id + '_' + ls_dwname)
	
	This.DataObject = ls_dwobjnm
	ls_error = This.Describe("DataWindow.Processing")
	Choose Case fw_f_nvls(ls_error, '')
		Case '?', '!', ''
			This.DataObject = ls_dataobject
			If ApplyDesign = True Then inv_style.of_applydesign()
	End Choose
Else
	If ApplyDesign = True Then inv_style.of_applydesign()
End If
end subroutine

public function long of_getscrollpos ();If fw_f_nvll(ilscrollpos, 0) = 0 Then ilscrollpos = 0

Return ilscrollpos
end function

public function string of_getdesignstyle ();Return isdesignstyle
end function

public function string of_getasissyntax ();Return isasissyntax4dwo
end function

public function integer deleterow (long r);//to-be 프레임1 일부기능 추가 insertrow, deleterow overroding
Integer li_rtn

IF r = 0 THEN r = getRow()

li_rtn = Event deleterowstart(r)
Choose Case li_rtn
	Case 1
		li_rtn = super::deleterow(r)
	Case -1
		//
	Case Else
		IF super::deleterow(r) < 0 THEN
			li_rtn = -1
		END IF
END CHoose

return li_rtn
end function

public function long insertrow (long r);//to-be 프레임1 임부기능 추가 insertrow, deleterow overroding
long ll_row
IF r = 0 THEN r = this.rowcount() + 1

ll_row = this.Event insertrowstart(r)
IF ll_row > 0 THEN
	ll_row = super::insertrow(r)
	IF ll_row > 0 THEN
		this.Event insertrowend(ll_row)
	END IF
END IF
return ll_row
end function

public function string of_getsqlerrmsg ();Return fw_f_nvls(isdberrorText, '')
end function

public subroutine of_getobjectsignup (ref string as_objs[]);inv_handle.Event oue_getobjectsignup(as_objs[])
end subroutine

public subroutine of_setexcel_saveas2st (boolean ab_boolean);inv_handle.of_setexcel_saveas2st(ab_boolean)
end subroutine

public subroutine of_setsaveas4excel (boolean ab_boolean);inv_handle.of_setsaveas4excel(ab_boolean)
end subroutine

public subroutine of_setsort_common (string as_sortgb);If Isvalid(inv_handle) Then inv_handle.dynamic of_setsort_common(as_sortgb, string(idwo.name), string(idwo.tag))
end subroutine

public subroutine of_setgroup1st (string as_gb);If isasisgrgb = as_gb and isasisgrobj = string(idwo.name) Then Return
Choose Case isdesignstyle
	Case 'tabular', 'grid'
		If string(idwo.type) <> 'text' Then
			Messagebox('Check', 'header에 text Control이 아닙니다.')
			Return
		End If
	Case Else
		Return
End Choose
If NOT IsValid(inv_style) Then
	Messagebox('Check', 'design 미적용입니다.')
	Return
End If
isasisgrgb		= as_gb
isasisgrobj	= string(idwo.name)
inv_handle.of_setgroup(isasisgrgb, isasisgrobj)

end subroutine

public subroutine of_setasissyntax (string asdwasissyntax);isasissyntax4dwo = asdwasissyntax
end subroutine

public function boolean of_getdesign4role ();Return ibdesign4role
end function

public subroutine of_setcreatehandle ();If Not IsValid(inv_handle) Then inv_handle = Create fw_n_handle //fw_n_handle Instance
inv_handle.of_initialize(This, iw_parent)
end subroutine

public subroutine of_setrbtnmenu (fw_m_dwrbutton am_menu);String	ls_menunm
Long		ll_objcnt, ll_i

ll_objcnt = Upperbound(am_menu.item)

For ll_i = 1 To ll_objcnt
	//messagebox('',am_menu.item[ll_i].classname())
	ls_menunm = am_menu.item[ll_i].ClassName()
	If ls_menunm = '-' Then Continue

	If Pos(ls_menunm, 'm_excel') > 0 Then /* excel */
		If iw_parent.Dynamic of_getcommbtnvisible('p_excel') = False Then am_menu.item[ll_i].enabled = false
	End If
	
	If Pos(ls_menunm, 'm_print') > 0 Then /* print */
		If iw_parent.Dynamic of_getcommbtnvisible('p_print') = False Then am_menu.item[ll_i].enabled = false
	End If
	If Pos(ls_menunm, 'm_group') > 0 Then /* group be */
		gnv_extfunc.biznode2te(203, gnv_vari.is_nodekey, isasissyntax4dwo, gnv_extfunc.is_nodevalue)
		If gnv_extfunc.is_nodevalue = 'Y' Then am_menu.item[ll_i].enabled = false
	End If
	If Pos(ls_menunm, 'm_dwodefault') > 0 Then /* dwo default */
		gnv_extfunc.biznode2te(202, gnv_vari.is_nodekey, ls_menunm, gnv_extfunc.is_nodevalue)
		If gnv_extfunc.is_nodevalue = 'N' or  ibrbtn4dwodefault = false Then /* return default */
			am_menu.item[ll_i].enabled = false
		End If
	End If
Next

end subroutine

public subroutine of_setfilterobj (fw_u_dw4filter au_dwbyfilter);ivo_dw4filter = au_dwbyfilter
end subroutine

public subroutine of_setborderfocuscolor (boolean ab_boolean);inv_handle.of_setborderfocuscolor(inv_style, ab_boolean)
end subroutine

public subroutine of_setexcel_import1st ();inv_handle.of_setexcel_import1st()
end subroutine

public function long of_getlist4goupcolor1 ();string		ls_colorarr[]
string		ls_syntax
Long		ll_grouprgb
Long		ll_colorcnt, ll_i
Long		ll_r, ll_g, ll_b

ll_colorcnt = fw_f_obj2array(setlist4goupcolor2, ',', ls_colorarr[])
If ll_colorcnt <> 3 Then
	ll_grouprgb = rgb(255,255,240)	
	Return ll_grouprgb
End If
for ll_i = 1 to ll_colorcnt
	Choose Case ll_i
		Case 1
			ll_r = Long(ls_colorarr[ll_i])
		Case 2
			ll_g = Long(ls_colorarr[ll_i])
		Case 3
			ll_b = Long(ls_colorarr[ll_i])
	End Choose
next
ll_grouprgb = rgb(ll_r, ll_g, ll_b)
Return ll_grouprgb
end function

public subroutine of_setdefault4dwo ();// filter init
If Isvalid(ivo_dw4filter) Then
	ilscrollpos = 0 /* ilscrollpos Init */
	ivo_dw4filter.Event oue_syncxpos('default', ilscrollpos)
End If

//  sortcolumn clear
If isvalid(inv_handle) Then
	inv_handle.of_setsort_clear()
	inv_handle.Event oue_dwowidthchanged(ilscrollpos)
End If

/* filter default */
isobj2filter[] = isempty2filter[]
ischeck2filter[] = isempty2filter[]
islcheck2filter[] = isempty2filter[]
istext2filter[] = isempty2filter[]

gnv_extfunc.biznode1te(124, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
iw_parent.TriggerEvent(gnv_extfunc.is_nodevalue)
gnv_extfunc.biznode1te(125, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
This.TriggerEvent(gnv_extfunc.is_nodevalue)
end subroutine

public subroutine of_sethsplitobj (fw_u_dw4hsplit au_dw4hsplit);ivo_dw4hsplit = au_dw4hsplit
end subroutine

public function integer of_settitle4datawindow ();if IsValid(ivo_dw2title) and ibtitle4datawindow = False then
	ivo_dw2title.Hide()
	if Parent.typeof() = userobject! then gnv_extfunc.setparent(handle(ivo_dw2title), il_hdledwtitle)
	iw_parent.CloseUserObject(ivo_dw2title)
	destroy ivo_dw2title
	Return no_action
End if

if ibtitle4datawindow = False then Return no_action
if len(trim(this.title)) = 0 then Return no_action
if IsValid(ivo_dw2title) then
	if this.title = ivo_dw2title.st_title.text then return no_action
	ivo_dw2title.st_title.text = this.title
	return no_action
End if

// backup message object before OpenUserObject()
message lm_backup
lm_backup = create message
lm_backup.Handle = message.Handle
lm_backup.Number = message.Number
lm_backup.WordParm = message.WordParm
lm_backup.LongParm = message.LongParm
lm_backup.DoubleParm = message.DoubleParm
lm_backup.stringParm = message.stringParm
lm_backup.PowerObjectParm = message.PowerObjectParm
lm_backup.Processed = message.Processed
lm_backup.ReturnValue = message.ReturnValue

string	ls_text, ls_fontface
long	ll_xpos, ll_ypos, ll_width

ls_text	= this.title
ll_xpos	= this.x //+ il_titlemargin2x
ll_ypos	= this.y - il_titlemargin2y - PixelsToUnits(17, XPixelsToUnits!)

iw_parent.OpenUserObjectWithParm(ivo_dw2title, this, ll_xpos, ll_ypos)
ivo_dw2title.of_settitle4name(ls_text)

if parent.typeof() = userobject! then
	il_hdledwtitle = gnv_extfunc.getparent(handle(ivo_dw2zoom))
	gnv_extfunc.setparent(handle(ivo_dw2title), handle(parent))
end if

//messagebox(string(ivo_dw2title.st_title.width), ls_text)
ivo_dw2title.st_title.text = ls_text
ivo_dw2title.visible = this.Visible
ivo_dw2title.SetPosition(Behind!, this)

// restore message object
message.Handle = lm_backup.Handle
message.Number = lm_backup.Number
message.WordParm = lm_backup.WordParm
message.LongParm = lm_backup.LongParm
message.DoubleParm = lm_backup.DoubleParm
message.stringParm = lm_backup.stringParm
message.PowerObjectParm = lm_backup.PowerObjectParm
message.Processed = lm_backup.Processed
message.ReturnValue = lm_backup.ReturnValue

return 0
end function

public function long of_getmax4xpos ();IF	NOT isValid (inv_handle) THEN RETURN 0
If not(inv_handle.imaxpos = il_max4xpos) or inv_handle.imaxpos = 0 Then
	inv_handle.of_getdwomaxwidth()
	il_max4xpos = inv_handle.imaxpos
End If
Return il_max4xpos
end function

public subroutine of_setdesignstyle (string as_style);isdesignstyle = as_style
this.of_setdwdesign(ApplyDesign, UseBorder) // use dw design service
end subroutine

public function dwobject of_getdwobj ();Return idwo
end function

public function long of_getwidth4datawindow ();Return ilorgwidth
end function

public function long of_getcurrentrow ();Return ilgetcurrent4row
end function

public function boolean of_getibsetlist4clearselect ();return ibsetlist4clearselect
end function

public subroutine of_setcolumnvisible_1sub (string as_column, string as_gb);choose case as_gb
	case '01'
		this.modify("sethpbc_stc.x='31543'")
		this.modify("sethpbcasc_stc.x='31543'")
		this.modify("sethpbcdesc_stc.x='31543'")
	case '02'
		this.modify("sethpbc_stc.x='-229'")
		this.modify("sethpbcasc_stc.x='-229'")
		this.modify("sethpbcdesc_stc.x='-229'")
end choose
end subroutine

public subroutine of_stc2off ();inv_handle.Event oue_stc2off()
end subroutine

public subroutine of_dw2subbtn (string as_btn_name[], boolean ab_enabled);if	not isvalid(ivo_dw2subbtn) then return

int	i, li_max

li_max = UpperBound(as_btn_name)
FOR  i = 1  TO  li_max
	CHOOSE CASE Lower(as_btn_name[i])
		CASE 'p_load'
			if ivo_dw2subbtn.p_load.Enabled<>ab_enabled then ivo_dw2subbtn.p_load.Enabled = ab_enabled
		CASE 'p_save'
			if ivo_dw2subbtn.p_save.Enabled<>ab_enabled then ivo_dw2subbtn.p_save.Enabled = ab_enabled
		CASE 'p_excel'
			if ivo_dw2subbtn.p_excel.Enabled<>ab_enabled then ivo_dw2subbtn.p_excel.Enabled = ab_enabled
		CASE 'p_input'
			if ivo_dw2subbtn.p_input.Enabled<>ab_enabled then ivo_dw2subbtn.p_input.Enabled = ab_enabled
		CASE 'p_copy'
			if ivo_dw2subbtn.p_copy.Enabled<>ab_enabled then ivo_dw2subbtn.p_copy.Enabled = ab_enabled
		CASE 'p_delete'
			if ivo_dw2subbtn.p_delete.Enabled<>ab_enabled then ivo_dw2subbtn.p_delete.Enabled = ab_enabled
		CASE 'p_firstpage'
			if ivo_dw2subbtn.p_firstpage.Enabled<>ab_enabled then ivo_dw2subbtn.p_firstpage.Enabled = ab_enabled
		CASE 'p_priorpage'
			if ivo_dw2subbtn.p_priorpage.Enabled<>ab_enabled then ivo_dw2subbtn.p_priorpage.Enabled = ab_enabled
		CASE 'p_nextpage'
			if ivo_dw2subbtn.p_nextpage.Enabled<>ab_enabled then ivo_dw2subbtn.p_nextpage.Enabled = ab_enabled
		CASE 'p_lastpage'
			if ivo_dw2subbtn.p_lastpage.Enabled<>ab_enabled then ivo_dw2subbtn.p_lastpage.Enabled = ab_enabled
	END CHOOSE
NEXT
end subroutine

public function long of_getcolumnxpos2max ();return 0
end function

public function integer of_dwheightminus1value ();if ibtitle4datawindow = true or ibsetlist4subbtn = true then
	return gnv_vari.il_dwheightminus1value
else
	return 0
end if
end function

public subroutine uf_resizecolumn ();LONG  lx
IF f_notnull (is_resize_column)   Then
	//<임시> x값이 없는 경우 항상 스크롤바가 사라집니다
	// width를 가지고 계산하는 경우 길이가 계속 바뀝니다
	// width 테스트 화면 : 1003
	// 스크롤바 테스트 화면 : sjc050 tab4
	IF describe (is_resize_column+'.x') <> '!' Then
		lx = long (describe (is_resize_column+'.x')) + PixelsToUnits (18, XPixelsToUnits!)// + long (describe (is_resize_column+'.width'))
		IF (Width - lx)>0	Then
			MODIFY (is_resize_column + "_t.width='" + string (Width - lx) + "'~t" + is_resize_column + ".width='" + string (Width - lx) + "'")
			HScrollBar = FALSE
		Else
			HScrollBar = TRUE
		End IF
	End IF
End IF
end subroutine

public function integer of_setdataobject (string as_dataobject);// 데이터윈도우 오브젝트를 변경하는 함수입니다
// as_dataobject: 변경할 데이터윈도우 오브젝트 명
// 리턴: success=성공, failure=실패

// 할당된 데이터윈도우 오브젝트가 없으면 리턴
If fw_f_nvls(as_dataobject, '') = '' Then Return FAILURE

//<임시> uf_dataobject에서 bforce로 들어온경우 실행되지 않습니다. 20210818
//If this.dataobject = as_dataobject   Then Return FAILURE

This.SetRedRaw( false ) /* to-be */
This.dataobject = as_dataobject
This.Event oue_dataobjectchanged()
This.SetRedRaw( true ) /* to-be */
Post fw_f_setparentwindowinit()

isasissyntax4dwo = This.Describe("DataWindow.Syntax")

Return SUCCESS
end function

public subroutine of_setdestroy2filter (string as_objtag);IF dataobject>'' THEN inv_handle.of_setdestroy2filter(as_objtag)
end subroutine

public subroutine of_setdestroy2sort (string as_obj);IF dataobject>'' THEN inv_handle.of_setdestroy2sort(as_obj)
end subroutine

public subroutine uf_setrow (long row, boolean arg_rowfocuschanged);IF	row=0 THEN RETURN
ib_range = FALSE
Enabled = TRUE
IF	getrow ()=row 	Then
	IF arg_rowfocuschanged OR NOT IsSelected (row) THEN event rowfocuschanged (row)
Else
	setrow (row)
	scrolltorow (row)
End IF
end subroutine

public subroutine of_settitle4name (string arg_title);ivo_dw2title.of_settitle4name (arg_title)
end subroutine

public function boolean uf_filter ();RETURN false
end function

public function boolean uf_getrange ();RETURN ib_range
end function

public subroutine uf_setrange (boolean ag_boolean);ib_range = ag_boolean
end subroutine

on fw_u_dwo.create
call super::create
end on

on fw_u_dwo.destroy
call super::destroy
end on

event constructor;call super::constructor;ibopening = true

// get parent window
iw_parent = fw_f_obj4parentwindow(this)

ilorgwidth = this.width
ilorgheight = this.height

if this.dataobject = '' then Return

// init dataobject
this.event oue_dataobjectchanged()
// post event
this.post Event oue_postopen()

end event

event resize;If ibresize4objwidth = true Then inv_handle.of_setobjresize2exe(this.width, this.height)
If newwidth = ilorgwidth and newheight = ilorgheight Then Return

If IsValid(inv_style) Then
	inv_style.of_resize(sizetype, this.width, this.height)
	If ibopening = false Then
		gnv_extfunc.biznode1te(101, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		This.TriggerEvent(gnv_extfunc.is_nodevalue)
	End If
End If

/* ibsetlist4subbtn toolbar resize*/
If IsValid(ivo_dw2subbtn) Then
	ivo_dw2subbtn.x = this.x + this.width - ivo_dw2subbtn.width + PixelsToUnits(1, XPixelsToUnits!)
End If

/* zoom dw toolbar resize*/
If IsValid(ivo_dw2zoom) Then
	ivo_dw2zoom.x = This.x - ilZoomXposMargin
	ivo_dw2zoom.y = This.y - ilZoomYposMargin
End If

If IsValid(inv_handle) and Isvalid(ivo_dw4filter) and ibsetlist4filter2uo = True Then
	of_getmax4xpos()
	If this.width > il_max4xpos Then
		ivo_dw4filter.Post Event oue_syncxpos('resize', 0)
	End If
End If

post uf_resizecolumn ()
end event

event destructor;call super::destructor;If IsValid(ivo_dw2title) Then
	ivo_dw2title.Hide()
	iw_parent.CloseUserObject(ivo_dw2title)
	Destroy ivo_dw2title
End If
If IsValid(ivo_dw2subbtn) Then
	ivo_dw2subbtn.Hide()
	iw_parent.CloseUserObject(ivo_dw2subbtn)
	Destroy ivo_dw2subbtn
End If
If IsValid(ivo_dw2zoom) Then
	ivo_dw2zoom.Hide()
	iw_parent.CloseUserObject(ivo_dw2zoom)
	Destroy ivo_dw2zoom
End If
If IsValid(inv_style)     Then	Destroy inv_style
If IsValid(inv_handle)    Then	Destroy inv_handle
If IsValid(inv_rowselect) Then	Destroy inv_rowselect
end event

event rowfocuschanged;If currentrow=0 OR not enabled OR ib_range Then Return
if isvalid(inv_style) Then inv_style.event rowfocuschanged(currentrow)
ilgetcurrent4row = currentrow
choose case isdesignstyle
	case 'grid', 'tabular', 'crosstab'
		if isValid(inv_rowselect) then
			this.selectrow(0, false)
			this.selectrow(currentrow, true)
		end if
		if iw_parent.TriggerEvent("wue_components") = 1 Then
			if iw_parent.dynamic of_getwindowtype() = 'main' Then
				if ibconfirmupdate4rowchanged = true Then iw_parent.dynamic of_confirmupdate4rowchanged()
				iw_parent.dynamic of_setdefault4rowchanged2boolean()
			end if
		end if
		IF enabled And eb_fund_default_change And describe ('fund_cd.type')='column'	Then
			IF f_nvl (Object.fund_cd [currentrow],'%')<>'%' THEN gaa.fund_cd = Object.fund_cd [currentrow]
		End IF
end choose
end event

event clicked;IF not IsValid(dwo)              THEN RETURN 0
IF string(dwo.name)='datawindow' THEN RETURN 0
IF PosA('148',describe ('DataWindow.processing'))=0  THEN RETURN 0

LONG	lRow, ll_currow, ll_startrow, ll_endrow

IF dwo.band='header' Then
   IF dwo.name='fseq_all'  Then   // 전체선택
      FOR  lRow = 1  TO  rowcount ()
         selectrow (lRow, TRUE)
      NEXT
      ib_range = TRUE
      RETURN
   End IF
End IF

il_xpos = xpos
il_ypos = ypos
Choose CASE isdesignstyle
   CASE 'freeform', 'cond'
      IF not isValid(idwo) THEN RETURN 0
      IF string(dwo.name)=string(idwo.name)  Then
         gnv_extfunc.biznode1te(151, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
         IF this.describe(gnv_extfunc.is_nodevalue)=gnv_vari.is_nodekey Then
            this.EVENT itemFocusChanged(row, dwo)
         End IF
      End IF
      idwo = dwo
   CASE 'grid','tabular'
      IF dwo.band='detail' Then
         IF KeyDown(KeyShift!)   Then
            ll_currow = getrow ()
            IF ll_currow>0  Then
               IF row>ll_currow   Then
                  ll_StartRow = ll_currow
                  ll_EndRow   = row
               Else
                  ll_StartRow = row
                  ll_EndRow   = ll_currow
               End IF
               FOR  lRow = ll_StartRow  TO  ll_EndRow
                  selectrow (lRow, TRUE)
               NEXT
            Else
               selectrow (row, TRUE)
            End IF
            ib_range = TRUE
            RETURN
         ElseIF KeyDown(KeyControl!)   Then
            IF ib_range THEN selectrow (row, NOT (IsSelected(row))) &
            ELSE             selectrow (row, TRUE)
            ib_range = TRUE
            RETURN
         End IF
		End IF
      ib_range = FALSE

		IF isValid(inv_rowselect)  Then
			IF ilgetcurrent4row=row Then
				inv_rowselect.EVENT oue_clicked (xpos, ypos, row, dwo)
				//<임시> editable상태에서 rowprotect에 selectrow가 되어있는 경우 row가 바뀌지 않아 강제로 변경합니다
				// 테스트화면 : 2641 - protect row와 editable row가 같이있어야 확인가능합니다
				IF getrow()<>row AND ibsetlist4singleselect THEN uf_setrow (getrow(), FALSE)
			else
				setrow (row)
			End IF
		End IF
		idwo = dwo

		STRING	ls_obj, ls_bandpointer
		ls_obj = fw_f_nm4dwo (THIS, string(dwo.name))
		ls_bandpointer = string(this.GetBandAtPointer ())
		IF (ibsetlist4sort OR ibsetlist4filter2dwo) And isValid(inv_handle) And POS(ls_bandpointer, 'header')>0 And fw_f_rtnheader2clicked(ls_obj)=1   Then
			inv_handle.EVENT oue_setheader2clicked (ls_bandpointer, idwo, row, ls_obj)
			RETURN
		End IF
End Choose
end event

event itemerror;//Set the return code to affect the outcome of the event:
//
//0  (Default) Reject the data value and show an error message box
//1  Reject the data value with no message box
//2  Accept the data value
//3  Reject the data value but allow focus to change

return 3

end event

event scrollhorizontal;gnv_extfunc.biznode2te(201, gnv_vari.is_nodekey, isdesignstyle, gnv_extfunc.is_nodevalue)
Choose Case gnv_extfunc.is_nodevalue
	Case 'A'
		ilscrollpos = Long(gnv_extfunc.biznode3te(301, gnv_vari.is_nodekey, Long(scrollpos), gnv_extfunc.is_nodevalue))
		If ibsetlist4filter2uo = True Then
			If Isvalid(ivo_dw4filter) Then ivo_dw4filter.Post Event oue_datasync()
		End If
		gnv_extfunc.biznode1te(101, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		This.TriggerEvent(gnv_extfunc.is_nodevalue)
	Case 'B'
		ilscrollpos = Long(gnv_extfunc.biznode3te(301, gnv_vari.is_nodekey, Long(scrollpos), gnv_extfunc.is_nodevalue))
		If ibsetlist4filter2uo = True Then
			If Isvalid(ivo_dw4filter) Then ivo_dw4filter.Post Event oue_datasync()
		End If
	Case 'C'
		ilscrollpos = Long(gnv_extfunc.biznode3te(301, gnv_vari.is_nodekey, Long(scrollpos), gnv_extfunc.is_nodevalue))
		If ibsetlist4filter2uo = True Then
			If Isvalid(ivo_dw4filter) Then ivo_dw4filter.Post Event oue_syncxpos('hscroll', ilscrollpos)
		End If
		gnv_extfunc.biznode1te(101, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		This.TriggerEvent(gnv_extfunc.is_nodevalue)
End Choose
end event

event rbuttondown;If not Isvalid(dwo) Then Return 0
If string(dwo.name) = 'datawindow' Then Return 0 // 데이터윈도우 빈 공백 클릭됨
If not IsValid(inv_style) Then Return 0
il_xpos = xpos
il_ypos = ypos
idwo = dwo
If ibsetlist4sort = True and IsValid(inv_handle) Then inv_handle.of_setsorthide()

If left(This.getbandatpointer(),7) = 'header~t' and ApplyDesign = True Then
	fw_m_dwrbutton lm_dwrbutton
	lm_dwrbutton = Create fw_m_dwrbutton
	lm_dwrbutton.of_setparent(this, iw_parent)
	of_setrbtnmenu(lm_dwrbutton)
	string		ls_type
	ls_type = iw_parent.Dynamic of_getwindowtype()
	If Pos(ls_type,'main') > 0 Then
		lm_dwrbutton.PopMenu(PointerX(gw_mdi), PointerY(gw_mdi))
	Else
		lm_dwrbutton.PopMenu(PointerX(iw_parent), PointerY(iw_parent))
	End If
End If
end event

event retrieveend;if rowcount > 0 Then
	if ibsetlist4filter2uo = True and Isvalid(ivo_dw4filter) Then
		gnv_extfunc.biznode1te(123, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		ivo_dw4filter.TriggerEvent(gnv_extfunc.is_nodevalue)
	end if
	if ibsetlist4hsplitscroll = True and Isvalid(ivo_dw4hsplit) Then
		gnv_extfunc.biznode1te(144, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		ivo_dw4hsplit.TriggerEvent(gnv_extfunc.is_nodevalue)
	end if
end if
if ibretrieve4defaultevent = true then
	choose case rowcount
		case is > 0
			//
		case 0
			messagebox("check", this.classname() + " no data")
		case is < 0
			messagebox("error",  this.classname() + "retrieve error")
	end choose
	this.post setfocus()
end if
end event

event retrievestart;if ibretrieve4defaultevent = true then
	this.reset()
	this.resetupdate()
end if
If ibsetlist4filter2uo = True Then
	If Isvalid(ivo_dw4filter) Then
		gnv_extfunc.biznode1te(122, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		ivo_dw4filter.TriggerEvent(gnv_extfunc.is_nodevalue)
	End If
End If
end event

event itemfocuschanged;IF isNull(dwo) THEN RETURN
idwo = dwo
If IsValid(inv_style) THEN  inv_handle.event oue_setedittoken ( string(dwo.name) )
end event

event getfocus;if iw_parent.triggerevent('wue_components') = 1 then
	if IsValid(inv_style) then
		if setfocusdw = true then iw_parent.dynamic of_setfocusdw (this)
	end if
end if
end event

event updatestart;call super::updatestart;iiUpdateStart = 1
If fw_f_nvls(isrowcheck4objupdate, '') <> '' Then
	If iw_parent.dynamic of_getobjdwbyname(isrowcheck4objupdate) = -1 Then
		Messagebox("Error",  "Update Row Check DataWindow가 맞지 않습니다.")
		Return iiUpdateStart
	Else
		If iw_parent.dynamic of_rtnmodifyrowbycheck('UPT') = -1 Then
			Return iiUpdateStart
		End If
	End If
End If
iiUpdateStart = 0
Return iiUpdateStart
end event

event losefocus;call super::losefocus;if iw_parent.triggerevent('wue_components') = 1 then
	if iw_parent.dynamic of_getwindowtype() <> 'main' then return
	this.accepttext()
	IF	isvalid(inv_handle) And ibsetlist4sort THEN inv_handle.of_setsorthide()
	IF	setedittoken                           THEN EVENT oue_setedittoken44()
end if
end event

event error;call super::error;//event oue_setdatabase2rollback()
end event

