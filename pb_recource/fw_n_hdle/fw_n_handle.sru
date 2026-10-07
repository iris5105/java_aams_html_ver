forward
global type fw_n_handle from n_ancestor
end type
end forward

global type fw_n_handle from n_ancestor
event clicked pbm_dwnlbuttonclk
event resize pbm_dwnresize
event rowfocuschanged pbm_dwnrowchange
event rowfocuschanging pbm_dwnrowchanging
event itemchanged pbm_dwnitemchange
event itemerror pbm_dwnitemvalidationerror
event itemfocuschanged pbm_dwnitemchangefocus
event losefocus pbm_dwnkillfocus
event getfocus pbm_dwnsetfocus
event rbuttondown pbm_dwnrbuttondown
event columnmove pbm_dwnmousemove
event move pbm_move
event oue_stcsort2on ( ref string as_syntax,  string as_obj,  long al_xpos,  long al_ypos,  long al_width,  long al_height )
event oue_stcfilter2off ( ref string as_syntax )
event oue_setedittoken ( string as_obj )
event oue_setedittoken44 ( )
event oue_setobjectsignup ( string as_objects[],  string as_rectobjects[],  string as_sortcol[],  long al_sortcol2xpos[],  long al_sortco2lwidth[] )
event oue_setheader2clicked ( string as_bandpointer,  dwobject adwo_obj,  long al_row,  string as_obj )
event oue_sort1stclicked ( string sortgb,  dwobject dwo,  long al_row )
event oue_dwowidthchanged ( long al_scrollpos )
event oue_getobjectsignup ( ref string as_objs[] )
event oue_stc2on ( string as_obj,  boolean ab_boolean )
event oue_stc2off ( )
event oue_stcfilter2on ( ref string as_syntax,  string as_obj,  long al_xpos,  long al_ypos,  long al_width,  long al_height )
event oue_stcsort2off ( ref string as_syntax )
end type
global fw_n_handle fw_n_handle

type prototypes

end prototypes

type variables
protected:
	fw_u_dwo			idw_target
	graphicobject	igo_parent
	window			iw_parent
	windowobject	iwo_parent
	
	string		is_sort_syntax[], is_sort_syntax_null[]
	//to-be column name variable
	string		isobjects[], isrect2obj[]
	// to-be parent imfor  gnv_vari.getcachedir gnv_vari.getcachedir + '\meta\' 
	string		isParentId
	string		isParentTitle
	string		isTargetId
	string		isDWId
	string		isDWObjCreateGB
	string		isdesignstyle
	
	string		Tooltiphelpdwo		= ''	//ToolTipHelp
	string		Tooltipdatadwo		= ''	//ToolTipData
	string		Tooltipdescdwo		= ''	//ToolTipdesc
	string		Tooltipdescsave		= ''	//ToolTipdesc
	
	long		ildw2orgwidth		= 0
	long		ilobjresize2cnt		= 0
	long		ilrobjresize2cnt		= 0
	long		ilobjresize2width[], ilobjresize2xpos[], ilobjresize2visible[]
	string		isobjresize2type[]
	string		is4scale2obj[]
	string		isfempty[]
	
Public:
	dwobject	idw_obj
	
	string	is_asisdwsyntax	= ''		/* dw table sign up */
	long		il_headerheight	= 0
	
	/* ibsetlist4filter2dwo, ibsetlist4sort으로 통합 <- setHeaderPoint Variable ; ibsetlist4sort variable */
	string	setpointheaderdwo		= ''
	
	boolean	ib_multisort		= false
	boolean	ib_nullsort		= true
	boolean	ib_lookupsort	= true
	
	// dynamic group information
	string	isdwgrasissyntax = ''
	// column information
	string	is_sort4colnm[]
	long		il_sort4colcnt
	long		il_sort4col2xpos[], il_sort4col2width[]
	 /* column width :  max column */
	string	iwidthcolumn	= ''
	long		iobjcnt			= 0
	long		imaxpos		   = 0
	/* push */
	boolean	ibpush4message	= false
end variables

forward prototypes
public function string of_thisname ()
public subroutine of_resize (integer sizetype, long newwidth, long newheight)
public subroutine of_move (long xpos, long ypos)
public function string of_getdesignsyntaxcs ()
public function string of_getdesignsyntaxweb ()
public subroutine of_setcacheborder ()
public subroutine of_setdesignstatus (string as_creategb)
public function string of_getedittokenbyobj (string as_obj, string as_objtype)
public subroutine of_ibsettooltipdata (dwobject dwo, string as_obj, long al_row, long al_xpos, long al_ypos)
public subroutine of_ibsettooltiphelp (dwobject dwo, string as_obj, long al_xpos, long al_ypos)
public subroutine of_setsaveas4excel8 (string path, datawindow adw_data, string as_type)
public function integer of_setexcel_saveas2st (boolean ab_boolean)
public function integer of_setexcel_saveas2stfunc (string as_filename, string as_typefile, string as_xlsxfile)
public subroutine of_setsaveas4excel (boolean ab_boolean)
public subroutine of_setsort_step2 (boolean ab_boolean, string as_bandpointer, string as_obj, string as_objtype, long al_xpos, long al_ypos)
public subroutine of_setsort_step2exe (boolean ab_boolean, string as_obj, string as_objtype, long al_xpos, long al_ypos)
public subroutine of_setsort_step2pos (boolean ab_boolean, string as_obj, string as_objtype, long al_xpos, long al_ypos)
public function integer of_setsort_common (string sortgb, string as_obj, string as_objtag)
public subroutine of_setinitheaderimage (long al_xpos, long al_maxwidth)
public function long of_getdwomaxwidth ()
public subroutine of_hscrollbar (boolean ab_loolean)
public subroutine of_setdesignupdate1st (string as_asissyntax)
public function integer of_setdesignupdate2st (string as_asistobesyntax)
public subroutine of_setgroup (string as_gb, string as_obj)
public function integer of_setgroup1step (string as_dwasissyntax)
public function integer of_setgroup2step (string as_gb, string as_obj)
public function integer of_setgroup3step (string sortgb, string as_obj)
public subroutine of_setdwasissyntaxmodify (long al_width)
public subroutine of_setborderfocuscolor (fw_n_style anv_style, boolean ab_boolean)
public subroutine of_setexcel_import1st ()
public subroutine of_setexcel_import2st (string as_filepath)
public subroutine of_setobjresize2exe (long al_width, long al_height)
public subroutine of_setobjresize2define ()
public subroutine of_initialize (readonly fw_u_dwo adw_datawindow, window aw_parent)
public subroutine of_setsorthide ()
public subroutine of_setdestroy2sort (string as_obj)
public subroutine of_setdestroy2filter (string as_obj)
public subroutine of_ibsettooltipdesc (dwobject dwo, string as_obj, long al_row, long al_xpos, long al_ypos)
public subroutine of_exe4tooltip (datawindow adw_obj, string as_obj, string as_dataobj, string as_objtype, string as_tooltiptitle, string as_objoption, long al_row, long al_xpos, long al_ypos)
public function integer of_setsort_step3 (string as_obj, string as_sortorder_old, string as_sortorder_new, ref string as_sort_col[])
public subroutine of_setsort_clear ()
public subroutine of_ibsetlist4mouseovercolor (long al_row)
end prototypes

event clicked;// Clicked Event
end event

event resize;// Resize Event
end event

event rowfocuschanged;// RowFocuschanged Event
end event

event rowfocuschanging;// RowFocusChanging Event
end event

event itemchanged;// ItemChanged Event
end event

event itemerror;// itemError Event
end event

event losefocus;// losefocus Event
end event

event getfocus;// getFocus Event
end event

event rbuttondown;// rbuttondown Event
end event

event columnmove;// ColumnMove

end event

event move;// move event

end event

event oue_stcsort2on(ref string as_syntax, string as_obj, long al_xpos, long al_ypos, long al_width, long al_height);//idw_target.SetPosition('sethpbcasc_stc',	'', true)
//idw_target.SetPosition('sethpbcdesc_stc',	'', true)

as_syntax += 'sethpbcasc_stc.visible="1"~r~n'
as_syntax += 'sethpbcasc_stc.tag="' + as_obj + '"~r~n'
as_syntax += 'sethpbcasc_stc.x="' + string((al_xpos + al_width) - PixelsToUnits(40, YPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcasc_stc.y="' + string(al_ypos) + '"~r~n'
as_syntax += 'sethpbcasc_stc.width="' + string(PixelsToUnits(16, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcasc_stc.height="' + string(al_height) + '"~r~n'

as_syntax += 'sethpbcdesc_stc.visible="1"~r~n'
as_syntax += 'sethpbcdesc_stc.tag="' + as_obj + '"~r~n'
as_syntax += 'sethpbcdesc_stc.x="' + string((al_xpos + al_width) - PixelsToUnits(21, YPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcdesc_stc.y="' + string(al_ypos) + '"~r~n'
as_syntax += 'sethpbcdesc_stc.width="' + string(PixelsToUnits(16, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcdesc_stc.height="' + string(al_height) + '"'
end event

event oue_stcfilter2off(ref string as_syntax);//idw_target.setposition('setfilasc_stc', '', false)
	
as_syntax += 'setfilasc_stc.visible="0"~r~n'
as_syntax += 'setfilasc_stc.x="' + string(PixelsToUnits(-10, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'setfilasc_stc.y="' + string(PixelsToUnits(-5, YPixelsToUnits!)) + '"~r~n'
as_syntax += 'setfilasc_stc.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'setfilasc_stc.height="' + string(PixelsToUnits(1, YPixelsToUnits!)) + '"~r~n'
//as_syntax += 'sethpbcasc_stc.tag=""~r~n'
end event

event oue_setedittoken(string as_obj);If lower(as_obj) = 'datawindow' or as_obj = '' then Return
If as_obj = 'empty' then Return
choose case isdesignstyle
	case 'freeform', 'cond', 'grid', 'tabular'
		gnv_extfunc.biznode1te(148, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		idw_target.Modify(gnv_extfunc.is_nodevalue + as_obj + "'")
		//<임시> protect에서 죽는현상 2313
		//yield()
end choose
end event

event oue_setedittoken44();string		ls_syntax, ls_error

choose case isdesignstyle
	case 'grid', 'tabular'
		//
	case 'freeform', 'cond'
		gnv_extfunc.biznode1te(148, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		idw_target.Modify(gnv_extfunc.is_nodevalue + gnv_vari.is_nodekey + "'")
		idw_target.SetRedraw( true )
end choose

end event

event oue_setobjectsignup(string as_objects[], string as_rectobjects[], string as_sortcol[], long al_sortcol2xpos[], long al_sortco2lwidth[]);isobjects[] = as_objects[]
isrect2obj[] = as_rectobjects[]

is_sort4colnm[] = as_sortcol[]
il_sort4colcnt = upperbound(as_sortcol)
il_sort4col2xpos[] = al_sortcol2xpos[]
il_sort4col2width[] = al_sortco2lwidth[]



end event

event oue_setheader2clicked(string as_bandpointer, dwobject adwo_obj, long al_row, string as_obj);//choose case isdesignstyle
//	case 'grid', 'tabular'
//		if Pos(as_bandpointer, 'header') > 0 then
//			choose case as_obj
//				case 'sethpbcasc_stc', 'sethpbcdesc_stc'
//					if idw_target.ibsetlist4sort = true then
//						if Pos(as_obj, 'asc_stc')	> 0 then idw_target.dynamic of_setsort_common('A')
//						if Pos(as_obj, 'desc_stc')	> 0 then idw_target.dynamic of_setsort_common('D')
//						post of_setsorthide()
//					end if
//				case 'setfilasc_stc'
//					if idw_target.ibsetlist4filter2dwo = true then fw_f_filter4dwo1(iw_parent, idw_target, adwo_obj, string(adwo_obj.tag), al_row)
//					post of_setsorthide()
//				case else
//					return
//			end choose
//		end if
//end choose
//gw_mdi.Dynamic setmicrohelp(as_obj )
end event

event oue_dwowidthchanged(long al_scrollpos);choose case idw_target.Describe("img4header.Type")
	case '?', '!'
		Return
	case Else 
		If il_headerheight < Long(pixelstounits(10, YPixelsToUnits!)) then Return
end choose
choose case isdesignstyle
	case 'grid', 'tabular', 'crosstab'
		Long		ll_maxwidth
		ll_maxwidth	= This.of_getdwomaxwidth()
		If ll_maxwidth > idw_target.Width - al_scrollpos then
			If idw_target.hscrollbar = False then of_hscrollbar(True)
			This.of_setinitheaderimage(0, ll_maxwidth)
		Else
			If idw_target.hscrollbar = True then of_hscrollbar(False)
			This.of_setinitheaderimage(0, idw_target.Width)
		end If
end choose
end event

event oue_getobjectsignup(ref string as_objs[]);as_objs[] = isobjects[] /* to-be column sign up */
end event

event oue_stc2on(string as_obj, boolean ab_boolean);choose case idw_target.describe("sethpbc_stc.type")
	case '?', '!'
		Return
end choose
string		ls_syntax, ls_errmsg
string		ls_parent, ls_sorthideyn = 'N'
long		ll_xpos, ll_ypos, ll_width, ll_height

choose case isdesignstyle
	case 'grid', 'tabular'
		if il_headerheight < Long(pixelstounits(10, YPixelsToUnits!)) then return
		if idw_target.dynamic of_getdesign4role() = true then
			ll_xpos		= Long(idw_target.describe(as_obj + ".X"))
			ll_ypos		= Long(idw_target.describe(as_obj + ".Y")) - PixelsToUnits(2, YPixelsToUnits!)
			ll_width		= Long(idw_target.describe(as_obj + ".width")) - PixelsToUnits(1, XPixelsToUnits!)
			ll_height	= Long(idw_target.describe(as_obj + ".height")) + PixelsToUnits(2, YPixelsToUnits!)
	
			choose case isdesignstyle
				case 'grid'
					if gnv_vari.getclienttype = 'WEB' then ll_height -= PixelsToUnits(1, YPixelsToUnits!)
				case 'tabular'
					ll_xpos	+= PixelsToUnits(1, XPixelsToUnits!)
					ll_width -= PixelsToUnits(1, XPixelsToUnits!)
					//ll_height -= PixelsToUnits(1, YPixelsToUnits!)
			end choose
		else
			ll_xpos		= Long(idw_target.describe(as_obj + ".X"))
			ll_ypos		= PixelsToUnits(1, YPixelsToUnits!)
			ll_width		= Long(idw_target.describe(as_obj + ".width")) - PixelsToUnits(2, YPixelsToUnits!)
			ll_height	= il_headerheight - PixelsToUnits(3, YPixelsToUnits!)
			
			choose case isdesignstyle
				case 'grid'
					if gnv_vari.getclienttype = 'WEB' then ll_height -= PixelsToUnits(1, YPixelsToUnits!)
			end choose
		end if
		
		ls_syntax = ''		
		ls_syntax += 'sethpbc_stc.visible="1"~r~n'
		ls_syntax += 'sethpbc_stc.tag="' + as_obj + '"~r~n'
		ls_syntax += 'sethpbc_stc.x="' + string(ll_xpos) + '"~r~n'
		ls_syntax += 'sethpbc_stc.y="' + string(ll_ypos) + '"~r~n'
		ls_syntax += 'sethpbc_stc.width="' + string(ll_width) + '"~r~n'
		ls_syntax += 'sethpbc_stc.height="' + string(ll_height) + '"~r~n'
		
//		ll_xpos += PixelsToUnits(1, YPixelsToUnits!)
//		ll_ypos += PixelsToUnits(1, YPixelsToUnits!)
//		ll_height -= PixelsToUnits(2, YPixelsToUnits!)
//		if idw_target.ibsetlist4filter2dwo = true then event oue_stcfilter2on(ls_syntax, as_obj, ll_xpos, ll_ypos, ll_width, ll_height)
//	
//		ll_xpos -= PixelsToUnits(1, YPixelsToUnits!)
//		ll_ypos += PixelsToUnits(1, YPixelsToUnits!)
//		ll_height -= PixelsToUnits(1, YPixelsToUnits!)
//		if idw_target.ibsetlist4sort = true then event oue_stcsort2on(ls_syntax, as_obj, ll_xpos, ll_ypos, ll_width, ll_height)

		ls_errmsg = idw_target.modify(ls_syntax)
		if fw_f_nvls(ls_errmsg, '') <> '' then
			::clipboard(ls_syntax)
			Messagebox('event oue_stc2son Error', ls_errmsg)
			Return
		end if
		//gw_mdi.dynamic setmicrohelp(setpointheaderdwo+'1'+as_obj)
		setpointheaderdwo = as_obj /* dwoname 등록 */
		gnv_extfunc.biznode1te(110, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		if iw_parent.TriggerEvent(gnv_extfunc.is_nodevalue) = 1 then
			fw_u_dwo ldw_dw
			ldw_dw = iw_parent.dynamic of_getmm2obj()
			if isvalid(ldw_dw) then
				if ldw_dw.classname() <> idw_target.classname() then
					iw_parent.dynamic of_setsorthide()
				end if
			end if
			iw_parent.dynamic of_setmm2obj(idw_target)
		end if
end choose
end event

event oue_stc2off();If idw_target.describe("sethpbc_stc.visible") = '1' then
	string		ls_syntax, ls_errmsg
	Long		ll_width, ll_height
	
	setpointheaderdwo = ''
	ll_width		= PixelsToUnits(1, XPixelsToUnits!)
	ll_height	= PixelsToUnits(1, YPixelsToUnits!)
	
	//idw_target.setposition('sethpbc_stc', '', false)
	
	ls_syntax = 'sethpbc_stc.visible="0"~r~n'
	ls_syntax += 'sethpbc_stc.x="' + string(PixelsToUnits(-10, XPixelsToUnits!)) + '"~r~n'
	ls_syntax += 'sethpbc_stc.y="' + string(PixelsToUnits(-5, YPixelsToUnits!)) + '"~r~n'
	ls_syntax += 'sethpbc_stc.width="' + string(ll_width) + '"~r~n'
	ls_syntax += 'sethpbc_stc.height="' + string(ll_height) + '"~r~n'
//	ls_syntax += 'sethpbc_stc.color="' + string(536870912) + '"~r~n'
//	ls_syntax += 'sethpbc_stc.text=""~r~n'
	
//	If idw_target.ibsetlist4filter2dwo = true then event  oue_stcfilter2off(ls_syntax)
//	If idw_target.ibsetlist4sort = true then event oue_stcsort2off(ls_syntax)
	
	ls_errmsg = idw_target.modify(ls_syntax)
	If fw_f_nvls(ls_errmsg, '') <> '' then
		::clipboard(ls_syntax)
		messagebox('event oue_stc2off Error', ls_errmsg)
		Return
	end If	
end If
end event

event oue_stcfilter2on(ref string as_syntax, string as_obj, long al_xpos, long al_ypos, long al_width, long al_height);//idw_target.SetPosition('setfilasc_stc',	'', true)

as_syntax += 'setfilasc_stc.visible="1"~r~n'
as_syntax += 'setfilasc_stc.tag="' + as_obj + '"~r~n'
as_syntax += 'setfilasc_stc.x="' + string(al_xpos) + '"~r~n'
as_syntax += 'setfilasc_stc.y="' + string(al_ypos) + '"~r~n'
as_syntax += 'setfilasc_stc.width="' + string(PixelsToUnits(16, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'setfilasc_stc.height="' + string(al_height) + '"~r~n'
end event

event oue_stcsort2off(ref string as_syntax);//idw_target.setposition('sethpbcasc_stc', '', false)
//idw_target.setposition('sethpbcdesc_stc', '', false)
	
as_syntax += 'sethpbcasc_stc.visible="0"~r~n'
as_syntax += 'sethpbcasc_stc.x="' + string(PixelsToUnits(-10, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcasc_stc.y="' + string(PixelsToUnits(-5, YPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcasc_stc.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcasc_stc.height="' + string(PixelsToUnits(1, YPixelsToUnits!)) + '"~r~n'

as_syntax += 'sethpbcdesc_stc.visible="0"'
as_syntax += 'sethpbcdesc_stc.x="' + string(PixelsToUnits(-10, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcdesc_stc.y="' + string(PixelsToUnits(-5, YPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcdesc_stc.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '"~r~n'
as_syntax += 'sethpbcdesc_stc.height="' + string(PixelsToUnits(1, YPixelsToUnits!)) + '"~r~n'
end event

public function string of_thisname ();return 'fw_n_handle'

end function

public subroutine of_resize (integer sizetype, long newwidth, long newheight);
end subroutine

public subroutine of_move (long xpos, long ypos);
end subroutine

public function string of_getdesignsyntaxcs ();String		ls_createsyntax, ls_designcolorobj, ls_designdwobj
String		ls_syntax[]
String		ls_dtm, ls_blob_err
Long		ll_syncnt, ll_find, ll_blob
Blob		lb_syntax
/* cache init Variable  init */
is_asisdwsyntax	= ''

ll_find = gnv_dwcache.ids_stylesyntax.Find("pgm_id='" + isParentId + "' and dw_id='" + isDWId + "' and dataobject='" + isTargetId + "'", 1, gnv_dwcache.ids_stylesyntax.rowcount())

Choose Case ll_find
	Case is > 0
		isDWObjCreateGB	= gnv_dwcache.ids_stylesyntax.GetItemString(ll_find, 'creategb')
		gnv_extfunc.biznode1te(109, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		If isDWObjCreateGB <> gnv_extfunc.is_nodevalue Then Return 'empty'
		
		SelectBlob	a.createsyntax
		      Into :lb_syntax
			  From	fw_designsyntax a
			Where	a.site_id			= :gnv_vari.SetEssSite
				and	a.pgm_id			= :isParentId
				and	a.dw_id			= :isDWId
				and	a.dataobject		= :isTargetId
				and	a.windowrate	= :gnv_vari.mswindowrate;
			
		IF	SQLCA.sqlcode ()=0	then
			ll_blob = mo_.Hex2Blob (SQLCA.is_hexFile, lb_syntax, ls_blob_err)
			IF	ll_blob < 0	Then
				f_messageBox ('ERR', 'blob 변환 오류 : ' + ls_blob_err)
			End IF
		End IF
			
		ls_createsyntax = String(lb_syntax, EncodingANSI!)
		If fw_f_nvls(ls_createsyntax, '') <> '' Then
			gnv_extfunc.biznode1te(104, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
			ll_syncnt = fw_f_obj2array(ls_createsyntax, "~r~n" + gnv_extfunc.is_nodevalue + "~r~n", ls_syntax[])
			If ll_syncnt < 9 Then
				is_asisdwsyntax = ''
				Return 'empty'
			Else
				gnv_extfunc.biznode1te(108, isdesignstyle, gnv_extfunc.is_nodevalue)
				ls_designdwobj		= gnv_dwcache.of_setdesignobj(gnv_extfunc.is_nodevalue)
				If ls_designdwobj	= 'empty' Then Return 'empty'
				ls_designcolorobj	= gnv_vari.setcache4backcolorsyn
				If ls_designcolorobj	<> ls_syntax[3] Then Return 'empty'
				If ls_designdwobj	<> ls_syntax[5] Then Return 'empty'
				
				is_asisdwsyntax = ls_syntax[9]
				gnv_extfunc.biznode1te(109, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
				Return gnv_extfunc.is_nodevalue
			End If
		End If

	Case 0
		ls_dtm = fw_f_getymdhh24miss4s()
		Insert Into fw_designsyntax(site_id, pgm_id, dw_id, dataobject, windowrate, creategb, pgm_nm, pgm_lib, reg_id, reg_dt, upd_id, upd_dt)
		Values(:gnv_vari.SetEssSite, :isParentId, :isDWId, :isTargetId, :gnv_vari.mswindowrate, '1', :isParentTitle, '', :gnv_vari.is_user_id, :ls_dtm, :gnv_vari.is_user_id, :ls_dtm);
		
		If Sqlca.SqlCode() = 0 Then			
			commitJ ()
		Else
			rollbackJ ()
		End If
	Case is < 0
		Messagebox('Error', 'gnv_rolemenu.ids_stylesyntax find fail')
End Choose

Return 'empty'
end function

public function string of_getdesignsyntaxweb ();string		ls_createyn
Long		ll_find

ll_find = gnv_dwcache.ids_stylesyntax.Find("pgm_id='" + isParentId + "' and dw_id='" + isDWId + "' and dataobject='" + isTargetId + "'", 1, gnv_dwcache.ids_stylesyntax.rowcount())

choose case ll_find
	case is > 0
		ls_createyn = fw_f_nvls(gnv_dwcache.ids_stylesyntax.GetItemstring(ll_find, 'creategb'), '')
		Return ls_createyn
end choose

Return 'empty'
end function

public subroutine of_setcacheborder ();idw_target.borderstyle = StyleLowered!
end subroutine

public subroutine of_setdesignstatus (string as_creategb);string ls_datetime

ls_datetime	= fw_f_getymdhh24miss4s()

/* creategb 진행여부 Update */
 Update	fw_designsyntax
	  Set	creategb			= :as_creategb,
			upd_id			= :gnv_vari.is_user_id,
			upd_dt			= :ls_datetime
 Where	site_id				= :gnv_vari.SetEssSite
	and	pgm_id			= :isParentId
	and	dw_id				= :isDWId
	and	dataobject		= :isTargetId
	and	windowrate		= :gnv_vari.mswindowrate;

If Sqlca.SqlCode <> 0 then
	rollbackJ ()
else
	commitJ ()
end If
end subroutine

public function string of_getedittokenbyobj (string as_obj, string as_objtype);string		ls_protect
Long		ll_pos, ll_tabsequence

If as_objtype = "column" then
	ll_tabsequence	= Long(idw_target.Describe(as_obj + ".TabSequence"))
	If fw_f_nvll(ll_tabsequence, 0) = 0 then Return '1'
	
	ls_protect = idw_target.describe(as_obj + ".Protect")
	ll_pos = pos(ls_protect, '~t')
	If ll_pos > 0 then
		ls_protect = Trim(lower(mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)))
		choose case len(ls_protect)
			case 1
				choose case ls_protect
					case '1'
						Return '1'
					case '0'
						Return '0'
				end choose
			case Else
				If Pos(ls_protect, 'if(') > 0 then
					Return '2'
				Else
					Return '0'
				end If
		end choose
	Else
		Return '0'
	end If
end If

Return '0'
end function

public subroutine of_ibsettooltipdata (dwobject dwo, string as_obj, long al_row, long al_xpos, long al_ypos);choose case idw_target.Describe(as_obj + ".Type")  /* only data column */
	case 'column'
		if Tooltipdatadwo = as_obj + 'data' + string(al_row) then return
		of_exe4tooltip(idw_target, as_obj, as_obj, 'column', 'DATA', '11', al_row, 0, 0)
		Tooltipdatadwo = as_obj + 'data' + string(al_row)
end choose
end subroutine

public subroutine of_ibsettooltiphelp (dwobject dwo, string as_obj, long al_xpos, long al_ypos);string		ls_type

ls_type = idw_target.Describe(as_obj + ".Type")
choose case ls_type
	case 'column', 'text', 'rectangle'
		if fw_f_rtnbackgrobjchk(as_obj) = -1 then return
		if ls_type = 'rectangle' and Pos(as_obj, '_rect') > 0 then as_obj = left(as_obj, Pos(as_obj, '_rect') - 1)
		if ls_type = 'column' and fw_f_nvls(Tooltipdatadwo,'') <> '' then return
		if Tooltiphelpdwo = as_obj + 'help' then return
		if ls_type = 'column' then ls_type = 'column_t'
		of_exe4tooltip(idw_target, as_obj, as_obj, ls_type, 'HELP', '01', 0, 0, 0)
		Tooltiphelpdwo = as_obj + 'help'
end choose
end subroutine

public subroutine of_setsaveas4excel8 (string path, datawindow adw_data, string as_type);string		ls_syntax, ls_errmsg
string		ls_object, ls_objarr[]
string		ls_data, ls_filter, ls_band, ls_objtype
string		ls_editstyle, ls_rowdata, ls_coltext
Long		i, ll_objcnt, ll_rowcnt, ll_i
Long		ll_objpos, ll_xpos, ll_width, ll_bandheight, ll_ypos

ls_syntax = ''

DataStore lds_excel
lds_excel = Create DataStore
lds_excel.DataObject = idw_target.DataObject
lds_excel.Object.Data = idw_target.Object.Data

ll_rowcnt = lds_excel.rowcount()

ls_object = lds_excel.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
For i = 1 to ll_objcnt
	/* to-be controls YPosition이 해당 band 밑에 있으면 Continue */
	ls_objtype		= lds_excel.describe(ls_objarr[i] + ".Type")
	ls_band			= lds_excel.Describe(ls_objarr[i] + ".Band")
	ll_bandheight	= Long(lds_excel.describe("DataWindow." + ls_band + ".Height"))
	ll_ypos			= Long(lds_excel.describe(ls_objarr[i] + ".Y"))
	
	If ls_band = "?" or ls_band = "!" then continue
	If ll_bandheight <= ll_ypos then Continue
	If Not (ls_objtype = "column" or ls_objtype = "text" or ls_objtype = "compute") then Continue

	/* header Modify */
	If ls_objtype = "column" then
		ls_coltext = idw_target.Describe(ls_objarr[i] + "_t.Text")
		If fw_f_nvls(ls_coltext, '') <> '' then ls_syntax += ls_objarr[i] + ".dbName='" + ls_coltext + "'~r~n"
	end If
	
	/* detail Modify */
	choose case left(lds_excel.Describe(ls_objarr[i] + ".Coltype"), 5)
		case 'char('
			ls_editstyle = lds_excel.describe(ls_objarr[i] + ".Edit.Style")
			choose case ls_editstyle
				case 'dddw', 'ddlb'					
					For ll_i = 1 To ll_rowcnt
						ls_rowdata	= idw_target.Describe("Evaluate('LookUpDisplay(" + ls_objarr[i] + ") ', "+ string(ll_i) + ")")
						lds_excel.SetItem(ll_i, ls_objarr[i], ls_rowdata)
					Next
			end choose
//		case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
//			lds_excel.SetItem(1, ls_objarr[i], 0)
	end choose	
Next

ls_errmsg = lds_excel.Modify(ls_syntax)
If len(ls_errmsg) > 0 then
	::clipboard(ls_syntax)
	messagebox('Excel SaveAs Header Error', ls_errmsg)
	Return
end If

lds_excel.SaveAs(path , Excel8!, True) 
end subroutine

public function integer of_setexcel_saveas2st (boolean ab_boolean);// orginal func -> dw_excel.of_saveas1type_xlsx(true)
string ls_path, ls_name, ls_filename
long ll_totlen, ll_len, i
String ls_xlsxFile, ls_txtFile, ls_xlsFile

If idw_target.RowCount() < 1 Then return -1

String	ls_currentdir
ls_currentdir = GetCurrentDirectory()
ChangeDirectory(gaa.excel)  /* 특정 폴더로 먼저 이동 할 시 */
IF GetFileSaveName("Select File",ls_xlsxFile, ls_name, "xlsx","Excel Files (*.xlsx), *.xlsx") <> 1 THEN
	ChangeDirectory(ls_currentdir)
	RETURN -1
END IF

/* system temp folder load */
long ll_bufferlength = 256
string ls_tempDir

ls_tempDir = SPACE(ll_bufferLength)

IF gnv_extfunc.GetTempPath(ll_bufferLength, ls_tempDir) = 0 THEN
	ChangeDirectory(ls_currentdir)
	MessageBox("Check", "System temp folder not defined")
	Return -1
END IF
ChangeDirectory(ls_currentdir)

Open(w_loadingmsg)

ll_totlen	= Len(ls_xlsxFile)
ls_xlsFile	= Left(ls_xlsxFile, ll_totlen - 4) + "xls"

SetPointer(HourGlass!)

// '01'같은 문자 처리
IF idw_target.SaveAs (ls_xlsFile, Excel5!, ab_boolean)<>1	Then
	ChangeDirectory(ls_currentdir)
	Close(w_loadingmsg)
	RETURN -1
END IF

of_setexcel_saveas2stfunc (ls_name, ls_xlsFile, ls_xlsxFile)

ShellExecute (handle (this), 'open', ls_xlsxFile, '', '', 1)

Close(w_loadingmsg)
end function

public function integer of_setexcel_saveas2stfunc (string as_filename, string as_typefile, string as_xlsxfile);long                     ll_rtn
oleobject               lole_excel
 
lole_excel = Create oleobject
   
ll_rtn = lole_excel.ConnectToNewObject("excel.application")
If ll_rtn = 0 then
	lole_excel.Application.DisplayAlerts = False
	lole_excel.Application.WorkBooks.OpenText(as_typefile)
		
	lole_excel.ActiveWorkbook.Sheets(1).Cells.Select			// 전체 CELL 선택
	lole_excel.Selection.Font.Size = 10
	//lole_excel.Activesheet.Columns.NumberFormat= "@"		// 모든 셀 문자로 참고 "General"
	lole_excel.ActiveSheet.Columns.AutoFit						// 자동으로 열 너비 조정	
	lole_excel.ActiveWorkbook.sheets(1).Cells(1,1).select		// Cells(1,1)로 Focus 지정
	
	lole_excel.Application.ActiveWorkbook.SaveAs(as_xlsxfile, 51)
	
	lole_excel.Application.Workbooks.Close
Else
	Close(w_loadingmsg)
	MessageBox('ConnectToNewObject Error',string(ll_rtn))
end If
 
lole_excel.DisconnectObject()
DESTROY lole_excel

FileDelete(as_typefile)

Return 1
end function

public subroutine of_setsaveas4excel (boolean ab_boolean);string	path, file, ls_type
Integer	li_rc
Boolean	lb_fileexist

string ls_current
//---------------------------------------------------------------------------------
ls_current = getcurrentdirectory()
ChangeDirectory('C:\')  /* 특정 폴더로 먼저 이동 할 시 */
li_rc =  GetFileSaveName('저장할 파일명', path, File, 'xls', 'Excel Files (*.xls),*.xls')
						
// 'Excel Files (*.xls),*.xls,' + &
// 'Excel Files (*.oxls),*.ole,' + &
// 'Text Files (*.txt),*.txt,'  + &
// 'wmf Files (*.Wmf),*.wmf,'  + &	
// 'html Files (*.html),*.html,'  + &	
//  'Psr Files (*.psr),*.psr')

Changedirectory(ls_current)
If li_rc = 1 then
	lb_fileexist = FileExists(path)
	If lb_fileexist then	
		li_rc = MessageBox("파일저장" , path + "파일이 이미 존재합니다.~r~n" + &
											 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		If li_rc = 2 then 
			 Return
		end If
	end If
	 
	 SetPointer(HourGlass!)
	 ls_type = upper(trim(right(path,3)))
	 choose case ls_type
		case 'TXT'
			idw_target.SaveAs(Path,TEXT!, TRUE)
		case 'XLS'
			of_setsaveas4excel8(path, idw_target, ls_type)
		case 'PSR'
			idw_target.SaveAs(Path,PSReport!, false)
		case 'WMF'
			idw_target.SaveAs(Path,WMF!, false)
		case 'TML'
			idw_target.SaveAs(Path,HTMLTABLE!, false)
	end choose
Else
	 Return
end If

end subroutine

public subroutine of_setsort_step2 (boolean ab_boolean, string as_bandpointer, string as_obj, string as_objtype, long al_xpos, long al_ypos);if Pos(as_bandpointer, 'header') > 0 then
	if ab_boolean = true and setpointheaderdwo = as_obj then return
	if ab_boolean = true and fw_f_rtnbackgrobjchk(as_obj) = -1 then return
	string	ls_obj
	if as_objtype = 'text' then
		if fw_f_rtnheader2clicked(as_obj) = 1 or lastpos(as_obj, '_sortarrow') > 0 then
			ls_obj = idw_target.describe(as_obj + '.tag')
			as_obj = ls_obj
		end if
		ls_obj = left(as_obj, len(as_obj) - 2)
		ls_obj = fw_f_nm4dwo(idw_target, ls_obj)
	end if
	if ls_obj = 'datawindow' then
		of_setsorthide()
	else
		of_setsort_step2pos(ab_boolean, as_obj, as_objtype, al_xpos, al_ypos)
	end if
else
	of_setsorthide()
end if
//gw_mdi.Dynamic setmicrohelp(as_bandpointer + '/' + as_obj + '/' + setpointheaderdwo + '/' + string(al_ypos))
end subroutine

public subroutine of_setsort_step2exe (boolean ab_boolean, string as_obj, string as_objtype, long al_xpos, long al_ypos);Long		ll_vscrollxpos
choose case idw_target.vscrollbar
	case True
		ll_vscrollxpos = Long(PixelsToUnits(5, XPixelsToUnits!))
	case False
		ll_vscrollxpos = Long(PixelsToUnits(1, XPixelsToUnits!))
end choose
gnv_extfunc.biznode2te(208, gnv_vari.is_nodekey, as_obj, gnv_extfunc.is_nodevalue)
If Long(UnitsToPixels(idw_target.Width, XUnitsToPixels!)) - ll_vscrollxpos <= al_xpos or al_xpos < Long(PixelsToUnits(Long(gnv_extfunc.is_nodevalue), XPixelsToUnits!)) or al_ypos < Long(PixelsToUnits(Long(gnv_extfunc.is_nodevalue), YPixelsToUnits!)) then
	of_setsorthide()
Else
	gnv_extfunc.biznode2te(209, gnv_vari.is_nodekey, as_objtype, gnv_extfunc.is_nodevalue)
	choose case as_objtype
		case gnv_extfunc.is_nodevalue
			If fw_f_rtnbackgrobjchk(as_obj) = 1 then This.Event oue_stc2on(as_obj, ab_boolean)
		case Else
			of_setsorthide()
	end choose
end If
//gw_mdi.Dynamic setmicrohelp(as_obj + '/' + as_objtype + '/' + string(al_ypos))
end subroutine

public subroutine of_setsort_step2pos (boolean ab_boolean, string as_obj, string as_objtype, long al_xpos, long al_ypos);choose case isdesignstyle
	case 'grid', 'tabular'
		If as_obj <> 'datawindow' then
			of_setsort_step2exe(ab_boolean, as_obj, as_objtype, al_xpos, al_ypos)
		end If
end choose
end subroutine

public function integer of_setsort_common (string sortgb, string as_obj, string as_objtag);// '_arrow' 텍스트 클릭한 경우 소트 컬럼명
string	ls_obj, ls_objtext
boolean	lb_dosort = false

ls_objtext = as_objtag
If right(ls_objtext, 10) = '_sortarrow' then
	ls_obj = left(ls_objtext, len(ls_objtext) - 10)
	lb_dosort = true
end If

long ll_pos, ll_lastpos, i, ll_xpos, ll_width

// 1. '_t' 를 제외한 소트 컬럼명이 있는지 확인
If lb_dosort = false then
	ll_pos = LastPos(ls_objtext, '_t')
	If ll_pos > 0 then
		ls_obj = left(ls_objtext, ll_pos - 1)
		for i = 1 to il_sort4colcnt
			If ls_obj = is_sort4colnm[i] then
				lb_dosort = true
				exit
			end If
		next
	end If
end If

// 2. xpos 와 width 가 일치하는 소트 컬럼이 있는지 확인
If lb_dosort = false then	
	ll_xpos = long(idw_target.Describe(as_obj + ".X"))
	ll_width = long(idw_target.Describe(as_obj + ".Width"))
	for i = 1 to il_sort4colcnt
		If ll_xpos = il_sort4col2xpos[i] and ll_width = il_sort4col2width[i] then
			ls_obj = is_sort4colnm[i]
			lb_dosort = true
			exit
		end If
	next
end If

// 소트 컬럼이 없으면 리턴
If lb_dosort = false then Return 0
// 소트 Order 구하기
string	ls_sortorder_old, ls_sortorder_new
string	ls_sortcriteria, ls_textname
string	ls_syntax, ls_error
long	ll_sortobjcnt, ll_i

ls_textname = idw_target.Describe(ls_obj + "_sortarrow.Name")
ls_sortorder_old = idw_target.Describe(ls_obj + "_sortarrow.Tag")
ls_sortorder_new = sortgb
If (ls_textname = '?' or ls_textname = '!') or (ls_sortorder_old = '?' or ls_sortorder_old = '!') then
	ls_sortorder_old = 'None'
end If

of_setsort_step3(ls_obj, ls_sortorder_old, ls_sortorder_new, is_sort_syntax)

ll_sortobjcnt = upperbound(is_sort_syntax)
for ll_i = 1 to ll_sortobjcnt
	ls_syntax += is_sort_syntax[ll_i]
next
//modify
ls_error = idw_target.modify(ls_syntax)
If ls_error <> '' then
	::clipboard(idw_target.classname() + "~r~n" + ls_syntax)
	messagebox("of_sort()", idw_target.classname() + " of_setsort_common Syntax Creation Failure!!~r~n" + ls_error)
	Return -1
end If

Return 1
end function

public subroutine of_setinitheaderimage (long al_xpos, long al_maxwidth);choose case idw_target.Describe("img4header.Type")
	case '?', '!'
		Return
end choose
idw_target.Object.img4header.x		= al_xpos
idw_target.Object.img4header.width	= al_maxwidth

Post of_setdwasissyntaxmodify(al_maxwidth)
end subroutine

public function long of_getdwomaxwidth ();string		ls_object, ls_objarr[]
Long		ll_i, ll_objcnt
Long		ll_objpos, ll_maxpos = 0
Long		ll_bandheight, ll_ypos
string		ls_band
Long		ll_colxpos, ll_colwidth

ls_object = idw_target.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])

/* to-be Befor Column Count Check Add */
If NOT ( iwidthcolumn = '' ) and ( iobjcnt = ll_objcnt ) then
	ll_colxpos	= long(idw_target.Describe(iwidthcolumn + ".X"))
	ll_colwidth	= long(idw_target.Describe(iwidthcolumn + ".Width"))
	
	If imaxpos = ll_colxpos + ll_colwidth then Return imaxpos
end If

iobjcnt = ll_objcnt /*  Column Count Setting */

For ll_i = 1 To iobjcnt
	If fw_f_rtnbackgrobjchk(ls_objarr[ll_i]) = -1 then Continue
	ls_band = idw_target.Describe(ls_objarr[ll_i] + ".Band")
	If ls_band = 'header' then
		/* to-be controls YPosition이 해당 band 밑에 있으면 Continue */
		ll_bandheight	= Long(idw_target.Describe("DataWindow." + ls_band + ".Height"))
		ll_ypos			= Long(idw_target.Describe(ls_objarr[ll_i] + ".y"))
		If ll_bandheight <= ll_ypos then Continue
		If idw_target.Describe(ls_objarr[ll_i] + ".Visible") = '1' then
			ll_objpos = long(idw_target.Describe(ls_objarr[ll_i] + ".X")) + long(idw_target.Describe(ls_objarr[ll_i] + ".Width"))
			If ll_maxpos < ll_objpos then
				ll_maxpos		= ll_objpos				
				iwidthcolumn	= ls_objarr[ll_i]
				imaxpos		= ll_maxpos
			end If
		end If
	end If
Next

Return imaxpos

end function

public subroutine of_hscrollbar (boolean ab_loolean);idw_target.hscrollbar = ab_loolean
end subroutine

public subroutine of_setdesignupdate1st (string as_asissyntax);string		ls_tobesyntax = ''
string		ls_asistobedesignsyntax = ''
string		ls_designobj
Boolean	lb_designcache

lb_designcache = idw_target.Dynamic of_getdesigncache()
If gnv_vari.getclienttype = 'PB' and lb_designcache = True then
	ls_tobesyntax	= idw_target.Describe("DataWindow.Syntax")
	ls_designobj		= gnv_dwcache.of_setdesignobj(isdesignstyle)
	If NOT(ls_designobj = 'empty') then
		ls_asistobedesignsyntax = fw_f_designsignon()
		This.of_setdesignupdate2st(isdesignstyle + ls_asistobedesignsyntax + gnv_vari.setcache4backcolorsyn + ls_asistobedesignsyntax + ls_designobj + ls_asistobedesignsyntax + as_asissyntax + ls_asistobedesignsyntax + ls_tobesyntax)
	end If
end If
end subroutine

public function integer of_setdesignupdate2st (string as_asistobesyntax);If fw_f_nvls(as_asistobesyntax, '') <> '' Then
	String	ls_syntax[], ls_blob_err
	Long		ll_syncnt, ll_blob
	
	gnv_extfunc.biznode1te(104, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
	ll_syncnt = fw_f_obj2array(as_asistobesyntax, "~r~n" + gnv_extfunc.is_nodevalue + "~r~n", ls_syntax[])

	If fw_f_nvls(is_asisdwsyntax, '') <> '' Then /* not empty 일때 Check */
		If ls_syntax[9] = is_asisdwsyntax Then Return 1
	End If
	
	Blob	lb_tobe_syntax

	//lb_tobe_syntax = blob(as_asistobesyntax, EncodingANSI!)
	lb_tobe_syntax = BLOB(" ")
	ll_blob = mo_.blob2hex(lb_tobe_syntax, SQLCA.is_updateblob, ls_blob_err)

	Updateblob	fw_designsyntax
		  Set	createsyntax	= :lb_tobe_syntax
	 Where	site_id			= :gnv_vari.SetEssSite
		and	pgm_id			= :isParentId
		and	dw_id				= :isDWId
		and	dataobject		= :isTargetId
		and	windowrate		= :gnv_vari.mswindowrate;
	If Sqlca.SqlCode() = 0 Then			
		commitJ ()
		gnv_extfunc.biznode1te(106, isDWObjCreateGB, gnv_extfunc.is_nodevalue)
		Choose Case isDWObjCreateGB /* creategb 진행여부 Update */
			Case gnv_extfunc.is_nodevalue
				gnv_dwcache.Post of_applydesigncreate(isParentId, isDWId)
			Case Else
				gnv_extfunc.biznode1te(107, isDWObjCreateGB, gnv_extfunc.is_nodevalue)
				of_setdesignstatus(gnv_extfunc.is_nodevalue)
		End Choose
	Else
		rollbackJ ()
	End If
End If

Return 1
end function

public subroutine of_setgroup (string as_gb, string as_obj);string		ls_objs[]
string		ls_objnm, ls_asissyntax4dwo, ls_error
Long		ll_objcnt, ll_pos, ll_ii
boolean	lb_name

idw_target.dynamic of_getobjectsignup(ls_objs[])
ll_objcnt = upperbound(ls_objs[])
If ll_objcnt < 1 then Return

ls_objnm = as_obj
ll_pos = LastPos(ls_objnm, '_t')
If ll_pos > 0 then
	ls_objnm = left(ls_objnm, ll_pos - 1)
Else
	Messagebox('Check', 'Text Column 양식이 맞지 않습니다.')
	Return
end If

lb_name = false /* init value */
for ll_ii = 1 to ll_objcnt
	If ls_objnm = ls_objs[ll_ii] then
		lb_name = true
		Exit
	end If
next
If lb_name = false then
	Messagebox('Check', '해당 Column(_t)가 없습니다.')
	Return
end If
ls_asissyntax4dwo = idw_target.dynamic of_getasissyntax()
If idw_target.Create(ls_asissyntax4dwo, ls_error) = -1 then
	::clipboard(idw_target.classname() + "~r~n" + ls_asissyntax4dwo)
	messagebox("Error", idw_target.classname() + " :  Group Create AS-IS Syntax sign up Failure!! : " + ls_error)
	Return
end If
If of_setgroup1step(ls_asissyntax4dwo) = -1 then Return
of_setgroup2step(as_gb, ls_objnm)	/* Column name apply, Trailer.1.Height sign up ; Group Create DataWindow */
of_setgroup3step('A', ls_objnm)			/* Group Sort DataWindow */

end subroutine

public function integer of_setgroup1step (string as_dwasissyntax);string		ls_modifysyntax, ls_error
string		ls_dwgrsyntax

/* Group 생성 전 기존 그룹이 있으면 중복 예외 처리 */
gnv_extfunc.biznode1te(113, as_dwasissyntax, gnv_extfunc.is_nodevalue)
If gnv_extfunc.is_nodevalue = 'Y' then
	Messagebox('Check', 'Group already exists.')
	Return -1
end If

gnv_extfunc.biznode1te(114, 'of_setgroup1step', gnv_extfunc.is_nodevalue)
ls_modifysyntax =gnv_extfunc.is_nodevalue

ls_error = idw_target.Modify( ls_modifysyntax )
If fw_f_nvls(ls_error, '') <> '' then
	::clipboard(ls_modifysyntax)
	Messagebox('Error', 'RuntimeGroup Create Modify 실패')
	Return -1
end If

string		ls_synvvy, ls_synvyv, ls_synyyv
Long		ll_lineStart, ll_StartPos

isdwgrasissyntax = idw_target.Describe("DataWindow.Syntax") /* runtimegroup 포함 instance variable */

gnv_extfunc.biznode1te(116, isdwgrasissyntax, gnv_extfunc.is_nodevalue)
If gnv_extfunc.is_nodevalue = 'N' then
	Messagebox('Check', 'Group cannot proceed.')
	Return -1
end If

gnv_extfunc.biznode2te(204, gnv_vari.is_nodekey, gnv_vari.GetBlock, gnv_extfunc.is_nodevalue)
ll_StartPos	= Pos(isdwgrasissyntax, gnv_extfunc.is_nodevalue)
ll_lineStart	= LastPos(left(isdwgrasissyntax, ll_StartPos), gnv_vari.GetBlock)
ls_synvyv	= Mid(isdwgrasissyntax, ll_lineStart, len(isdwgrasissyntax) - ll_lineStart)
gnv_extfunc.biznode1te(115, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
ls_synyyv	 = gnv_extfunc.is_nodevalue + string(idw_target.dynamic of_getlist4goupcolor1()) + "' )"
ls_synvvy	= Left(isdwgrasissyntax, ll_lineStart)

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01	= ls_synvvy
gnv_extfunc.istr_node4value.cstr02	= ls_synvyv
gnv_extfunc.istr_node4value.cstr03	= ls_synyyv
gnv_extfunc.biznode11te(103, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
ls_dwgrsyntax	= gnv_extfunc.istr_node4value.cstr05

If idw_target.Create(ls_dwgrsyntax, ls_error) = -1 then
	::clipboard(idw_target.classname() + "~r~n" + ls_dwgrsyntax)
	Messagebox("Error", idw_target.classname() + " :  Group Create Syntax Modification(Create) Failure!! : " + ls_error)
	Return -1
end If
end function

public function integer of_setgroup2step (string as_gb, string as_obj);/* Column name apply, Trailer.1.Height sign up ; Group Create DataWindow */
string		ls_modifysyntax, ls_createsyntax, ls_error
string		ls_objects[]
string		ls_visible, ls_objtype, ls_band, ls_coltype, ls_border
Long		ll_objectcnt, ll_xpos, ll_ypos, ll_width, ll_height, ll_bandheight, ll_ii
Long		ColumnBorderColor

ll_bandheight	= Long(idw_target.Describe("DataWindow.Detail.Height"))

/* Property Modify */
gnv_extfunc.biznode2te(206, gnv_vari.is_nodekey, as_obj, gnv_extfunc.is_nodevalue)
ls_modifysyntax = gnv_extfunc.is_nodevalue + as_obj + "'~r~n"
gnv_extfunc.biznode2te(207, gnv_vari.is_nodekey, string(ll_bandheight), gnv_extfunc.is_nodevalue)
ls_modifysyntax += gnv_extfunc.is_nodevalue + string(ll_bandheight) + "'"

ls_error = idw_target.Modify( ls_modifysyntax )
If fw_f_nvls(ls_error, '') <> '' then
	::clipboard(ls_modifysyntax)
	Messagebox('Error', 'Column apply Modify 실패')
	Return -1
end If
ls_modifysyntax = '' /* init */

/* rectangle Create */
idw_target.dynamic of_getobjectsignup(ls_objects[])
ll_objectcnt = upperbound(ls_objects[])

ColumnBorderColor	= RGB(190,190,190)

For ll_ii = 1 to ll_objectcnt
	ls_coltype	= left(idw_target.Describe(ls_objects[ll_ii] + ".Coltype"), 5)
	ls_band		= idw_target.Describe(ls_objects[ll_ii] + ".Band")
	If (ls_band = '?' or ls_band = '!') or ls_band <> "detail" then Continue
	
	ll_xpos	= Long(idw_target.Describe(ls_objects[ll_ii] + ".x"))
	ll_ypos	= Long(idw_target.Describe(ls_objects[ll_ii] + ".y"))
	ls_border	= idw_target.Describe(ls_objects[ll_ii] + ".Border")
	ls_visible	= idw_target.Describe(ls_objects[ll_ii] + ".visible")
	If ll_ypos < ll_bandheight and ls_visible = '1' then
		ll_width	= Long(idw_target.Describe(ls_objects[ll_ii] + ".Width"))
		If idw_target.setedittoken = True and Pos(ls_border, '~tIf') > 0 then
			ll_height = Long(mid(idw_target.Describe(ls_objects[ll_ii] + ".Height"), 2, Pos(ls_border, '~tIf') - 1))
		Else
			ll_height = Long(idw_target.Describe(ls_objects[ll_ii] + ".Height"))
		end If
		choose case ls_coltype
			case 'decim', 'int', 'long', 'ulong', 'numbe', 'real'
				choose case as_gb
					case 'sum'
						gnv_extfunc.of_setinitializationapi()
						gnv_extfunc.istr_node4value.cstr01	= string(ll_xpos)
						gnv_extfunc.istr_node4value.cstr02	= ls_objects[ll_ii]
						gnv_extfunc.istr_node4value.cstr03	= string(ll_ypos)
						gnv_extfunc.istr_node4value.cstr04	= string(ll_height)
						gnv_extfunc.istr_node4value.cstr05	= string(ll_width)
						gnv_extfunc.biznode11te(105, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
						ls_modifysyntax += gnv_extfunc.istr_node4value.cstr09 + "~r~n"
					case 'avg'
						gnv_extfunc.of_setinitializationapi()
						gnv_extfunc.istr_node4value.cstr01	= string(ll_xpos)
						gnv_extfunc.istr_node4value.cstr02	= ls_objects[ll_ii]
						gnv_extfunc.istr_node4value.cstr03	= string(ll_ypos)
						gnv_extfunc.istr_node4value.cstr04	= string(ll_height)
						gnv_extfunc.istr_node4value.cstr05	= string(ll_width)
						gnv_extfunc.biznode11te(106, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
						ls_modifysyntax += gnv_extfunc.istr_node4value.cstr09 + "~r~n"
				end choose
		end choose
		
		choose case isdesignstyle
			case 'tabular'
				ll_xpos	= Long(idw_target.Describe(ls_objects[ll_ii] + "_rect.x"))
				ll_ypos	= Long(idw_target.Describe(ls_objects[ll_ii] + "_rect.y"))
				ll_width	= Long(idw_target.Describe(ls_objects[ll_ii] + "_rect.width"))
				ll_height	= Long(idw_target.Describe(ls_objects[ll_ii] + "_rect.height"))
				ls_modifysyntax += 'create rectangle(name=' + ls_objects[ll_ii] + '_c_rect visible="' + ls_visible+ '" band=trailer.1 pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(ColumnBorderColor) + '"' + & 
										' brush.hatch="7" brush.color="553648127" background.mode="0" background.color="553648127" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
		end choose
	end If
Next

ls_error = idw_target.Modify( ls_modifysyntax )
If fw_f_nvls(ls_error, '') <> '' then
	::clipboard(This.classname() + "~r~n" + ls_modifysyntax)
	Messagebox('Error', 'rectangle Modify 실패' + ls_error)
	Return -1
end If

ls_createsyntax = idw_target.Describe("DataWindow.Syntax")

If idw_target.Create(ls_createsyntax, ls_error) = -1 then
	::clipboard(idw_target.classname() + "~r~n" + ls_createsyntax)
	messagebox("Error", idw_target.classname() + " :  Reconfirm Group Create Syntax Create Failure!! : " + ls_error)
	Return -1
end If

idw_target.dynamic of_setdefault4dwo()
end function

public function integer of_setgroup3step (string sortgb, string as_obj);of_setsort_common('A', as_obj, as_obj + '_t')

Return 1

end function

public subroutine of_setdwasissyntaxmodify (long al_width);/* to-be DataWindow 초기syntax에 image width만 변경 후 저장 */
string	ls_asissyntax
string	ls_frontsyntax, ls_backsyntax
Long		ll_StartPos, ll_findpos

ls_asissyntax	= idw_target.dynamic of_getasissyntax()
ll_StartPos		= Pos(ls_asissyntax, 'bitmap(name=img4header')
If fw_f_nvls(ls_asissyntax, '') <> '' and ll_StartPos > 0 then
	ll_findpos			= Pos(ls_asissyntax, 'width="', ll_StartPos) + 6
	ls_frontsyntax	= left(ls_asissyntax, ll_findpos)
	ll_findpos			= Pos(ls_asissyntax, '"', ll_findpos + 1)
	ls_backsyntax	= mid(ls_asissyntax, ll_findpos)
	ls_asissyntax	= ls_frontsyntax + string(al_width) + ls_backsyntax
	idw_target.dynamic of_setasissyntax(ls_asissyntax)
end If
end subroutine

public subroutine of_setborderfocuscolor (fw_n_style anv_style, boolean ab_boolean);anv_style.of_setborderfocuscolor(ab_boolean)
end subroutine

public subroutine of_setexcel_import1st ();//***************************************************************************************// 
//* 용 도 : 선택한 Excel을 DataWindow에 ImportFile 하기 *// 
//* Argument : ls_filepath (처리할 Excel File 경로, 파일명 포함) *// 
//*            adw (IMPORT할 DataWindow) *//
//*            startrow (If the first row contains headings that you want to skip, set startrow to 2. The default is 1) *//
//*            as_error ( Reference, Error Msg) *// 
//* Return값 : Long( 1 : Success, 0에서 -9 : ImportFile Fail, -10 : FileOpen Fail, -11 : FileDelete Fail ) *// 
//* 사 용 예 : gf_excel_import('C:\TEMP\TEMP.XLS', dw_1, startrow, REF ls_err) *// 
//***************************************************************************************// 

string		ls_open_file, ls_save_file
string		ls_filepath, ls_filenm
Long		ll_xls, ll_row, ll_import
Integer	li_connect, li_open, ll_startrow, li_value

oleobject	ole_excel
Boolean		lb_select, lb_delete

fw_f_savepath('get', '')
li_value = GetFileOpenName("Select File", ls_filepath, ls_filenm, "xlsx", &
			"Excel Files (*.xlsx),*.xlsx," +  &
			"Excel Files (*.xls),*.xls")
					
If li_value < 1 then Return

ls_open_file	= trim(ls_filepath) 
ll_startrow	= 2

If LenA(ls_open_file) = 0 then 
	Messagebox('Error', 'Enter the path to the Excel file') 
	Return
end If 

If Not FileExists(ls_open_file) then 
	Messagebox('Error', 'The specified file does not exist.') 
	Return
end If 

If Pos(ls_open_file, '.xlsx') > 0 then
	ll_xls = Pos(ls_open_file,'xlsx') 
Elseif Pos(ls_open_file, '.xls') > 0 then	
	ll_xls = Pos(ls_open_file,'xls') 
end If

//If IsNull(ll_xls) or ll_xls = 0 then //* Excel File이 아니면 Text File인지 체크 
//	ll_xls = PosA(ls_open_file, 'txt') 
//	If Not IsNull(ll_xls) or ll_xls > 0 then 
//		ls_save_file = ls_open_file
//		goto excel_import
//	end If 
//	
//	as_error = "Excel 파일이 아닙니다." 
//	Return -10 
//end If 

ole_excel = CREATE OLEobject 

li_connect = ole_excel.ConnectToObject("","excel.application") 

If li_connect = -5 then 
	// -5 Can't connect to the currently active object 
	li_connect = ole_excel.ConnectToNewObject("excel.application") 
end If 

If li_connect <> 0 then 
	SetPointer(Arrow!) 
	DESTROY ole_excel 
	Messagebox('Error', 'Can not run Excel program.') 
	Return
end If 

SetPointer(HourGlass!) 

ole_excel.WorkBooks.Open(ls_open_file) 
ole_excel.Application.Visible = FALSE 

lb_select = ole_excel.WorkSheets(1).Activate 

ls_save_file = Mid(ls_open_file, 1, ll_xls - 2) + string(now(),'hhmmss') + ".txt" 

ole_excel.Application.Workbooks(1).Saveas(ls_save_file, -4158) 
ole_excel.WorkBooks(1).Saved = TRUE 

ole_excel.Application.Quit 
ole_excel.DisConnectObject() 

DESTROY ole_excel 

ll_import = idw_target.ImportFile(ls_save_file, ll_startrow) 

SetPointer(Arrow!) 

If ll_import < 1 then 
	MessageBox("Error", "File Processing failed.(" + ls_save_file + ")", StopSign!) 
	Return 
end If

Yield( )
Post of_setexcel_import2st(ls_save_file)
end subroutine

public subroutine of_setexcel_import2st (string as_filepath);If NOT FileDelete(as_filepath) then 
	MessageBox("Error", "File Deletion failed.(" + as_filepath + ")", StopSign!) 
	Return
end If 
end subroutine

public subroutine of_setobjresize2exe (long al_width, long al_height);If ilobjresize2cnt < 1 then Return
If not isvalid(idw_target) then Return

string	ls_syntax, ls_error
Long	ll_i, ll_xpos, ll_width
dec{4}	ldc_rate2xpos

ls_syntax = ''
If al_width > ildw2orgwidth then
	ldc_rate2xpos = 1 + ((al_width - ildw2orgwidth) / ildw2orgwidth)
	For ll_i = 1 to ilobjresize2cnt
		If ilobjresize2visible[ll_i] = 0 then continue
		ll_xpos = truncate(ilobjresize2xpos[ll_i] * ldc_rate2xpos, 0)
		ll_width = truncate(ilobjresize2width[ll_i] * ldc_rate2xpos, 0)
		ll_xpos = UnitsToPixels(ll_xpos, xUnitsToPixels!)
		ll_width = UnitsToPixels(ll_width, xUnitsToPixels!)
		ll_xpos = PixelsToUnits(ll_xpos, xPixelsToUnits!)
		ll_width = PixelsToUnits(ll_width, xPixelsToUnits!)

		ls_syntax += is4scale2obj[ll_i] + '.x=' + string(ll_xpos) + '~r~n'
		choose case isobjresize2type[ll_i]
			case 'column', 'text', 'compute', 'rectangle', 'groupbox'
				ls_syntax += is4scale2obj[ll_i] + '.width=' + string(ll_width) +'~r~n'
		end choose
	Next
Else
	For ll_i = 1 to ilobjresize2cnt
		If ilobjresize2visible[ll_i] = 0 then continue
		ls_syntax += is4scale2obj[ll_i] + '.x=' + string(ilobjresize2xpos[ll_i]) + '~r~n'
		choose case isobjresize2type[ll_i]
			case 'column', 'text', 'compute', 'rectangle', 'groupbox'
				ls_syntax += is4scale2obj[ll_i] + '.width=' + string(ilobjresize2width[ll_i]) +'~r~n'
		end choose
	Next
end If

ls_error = idw_target.modify(ls_syntax)
If len(ls_error) > 0 then
	::clipboard(ls_syntax)
	messagebox('of_setrobject4resize() failure', ls_error)
	Return
end If
end subroutine

public subroutine of_setobjresize2define ();If not isvalid(idw_target) then Return
Long	ll_i, ll_rcnt, ll_num = 0

ll_rcnt = upperbound(isobjects)
for ll_i = 1 to ll_rcnt
	choose case idw_target.describe(isobjects[ll_i] + ".band")
		case '?','!'
			continue
		case else 
			ll_num++
			is4scale2obj[ll_num] = isobjects[ll_i]
	end choose
next
//is4scale2obj = isobjects
ilobjresize2cnt = upperbound(is4scale2obj)
For ll_i = 1 to ilobjresize2cnt
	ilobjresize2xpos	[ll_i] = long(idw_target.describe(is4scale2obj[ll_i] + ".x"))
	ilobjresize2width[ll_i] = long(idw_target.describe(is4scale2obj[ll_i] + ".width"))
	ilobjresize2visible[ll_i] = long(idw_target.describe(is4scale2obj[ll_i] + ".visible"))
	isobjresize2type[ll_i] = idw_target.describe(is4scale2obj[ll_i] + ".type")
next

ilrobjresize2cnt = upperbound(isrect2obj)
For ll_i = 1 to ilrobjresize2cnt
	is4scale2obj[ilobjresize2cnt + ll_i] = isrect2obj[ll_i]
	ilobjresize2xpos	[ilobjresize2cnt + ll_i] = Long(idw_target.describe(is4scale2obj[ilobjresize2cnt + ll_i] + ".x"))
	ilobjresize2width[ilobjresize2cnt + ll_i] = Long(idw_target.describe(is4scale2obj[ilobjresize2cnt + ll_i] + ".width"))
	ilobjresize2visible[ilobjresize2cnt + ll_i] = Long(idw_target.describe(is4scale2obj[ilobjresize2cnt + ll_i] + ".visible"))
	isobjresize2type[ilobjresize2cnt + ll_i] = 'rectangle'
next

ilobjresize2cnt = upperbound(is4scale2obj)
end subroutine

public subroutine of_initialize (readonly fw_u_dwo adw_datawindow, window aw_parent);// parent datawindow / window 등록
idw_target	= adw_datawindow
igo_parent	= idw_target.getparent()
iw_parent	= aw_parent

/* to-be */
// parent imfor
isParentId		= upper(iw_parent.Classname())
isParentTitle	= iw_parent.title
isDWId			= upper(idw_target.Classname())
isTargetId		= idw_target.dataobject

isdesignstyle	= idw_target.Dynamic of_getdesignstyle()
il_headerheight	= long(idw_target.Describe("Datawindow.Header.Height"))
ildw2orgwidth	= idw_target.dynamic of_getwidth4datawindow()
//of_resize(0, idw_target.width, idw_target.height)  /* init size */
end subroutine

public subroutine of_setsorthide ();event oue_stc2off()
end subroutine

public subroutine of_setdestroy2sort (string as_obj);string	ls_obj, ls_syntax, ls_error
long		ll_i, ll_objcnt1

ll_objcnt1 = upperbound(idw_target.isobj2sort[])
If ll_objcnt1 = 0 then return

idw_target.setsort("")
idw_target.sort( )

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = as_obj
gnv_extfunc.biznode11te(119, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

ls_syntax = ''
for ll_i = 1 to ll_objcnt1
	ls_obj = idw_target.isobj2sort[ll_i]
	ls_syntax += gnv_extfunc.istr_node4value.cstr12 + ls_obj + '_sortarrow~r~n'
next

ls_error = idw_target.modify(ls_syntax)
If ls_error <> '' then
	::clipboard(idw_target.classname() + "~r~n" + ls_syntax)
	messagebox("sort sign destroy", idw_target.classname() + " syntax Creation Failure!!~r~n" + ls_error)
end If

idw_target.isobj2sort[] = idw_target.isempty2sort[]
is_sort_syntax[] = is_sort_syntax_null[]
end subroutine

public subroutine of_setdestroy2filter (string as_obj);string		ls_obj, ls_syntax, ls_error
string		ls_data
string		ls_obj2temp[]
long		ll_i, ll_j = 0, ll_objcnt1, ll_find

datastore	lds_ds1, lds_ds2

lds_ds1 = create datastore
lds_ds1.dataobject = 'fw_d_dw4filter2'

lds_ds2 = create datastore
lds_ds2.dataobject = 'fw_d_dw4filter2'

ll_objcnt1 = upperbound(idw_target.isobj2filter[])
if ll_objcnt1 = 0 then return

if ll_objcnt1 > 1 then
	for ll_i = 1 to ll_objcnt1
		lds_ds1.insertrow(0)
		lds_ds1.setitem(ll_i, 'c_name', idw_target.isobj2filter[ll_i])
	next
	
	for ll_i = 1 to ll_objcnt1
		ls_data = lds_ds1.getitemstring(ll_i, 'c_name')
		ll_find = lds_ds2.find("c_name='" + ls_data + "'", 1, lds_ds2.rowcount())
		if ll_find = 0 then
			ll_j = lds_ds2.insertrow(0)
			lds_ds2.setitem(ll_j, 'c_name', ls_data)
			ls_obj2temp[ll_j] = ls_data
		end if
	next
	idw_target.isobj2filter[] = ls_obj2temp[]
	ll_objcnt1 = upperbound(idw_target.isobj2filter[])
end if

idw_target.SetFilter('')
idw_target.Filter()
idw_target.GroupCalc ( )
			
gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = as_obj
gnv_extfunc.biznode11te(119, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

ls_syntax = ''
for ll_i = 1 to ll_objcnt1
	ls_obj = idw_target.isobj2filter[ll_i]
	ls_syntax += gnv_extfunc.istr_node4value.cstr12 + ls_obj + gnv_extfunc.istr_node4value.cstr09
next

ls_error = idw_target.modify(ls_syntax)
If ls_error <> '' then
	::clipboard(idw_target.classname() + "~r~n" + ls_syntax)
	messagebox("filter sign destroy", idw_target.classname() + " syntax Creation Failure!!~r~n" + ls_error)
end If

idw_target.isobj2filter[]		= idw_target.isempty2filter[]
idw_target.ischeck2filter[]	= idw_target.isempty2filter[]
idw_target.islcheck2filter[]	= idw_target.isempty2filter[]
idw_target.istext2filter[]		= idw_target.isempty2filter[]
end subroutine

public subroutine of_ibsettooltipdesc (dwobject dwo, string as_obj, long al_row, long al_xpos, long al_ypos);string	ls_tooliptext, ls_dataobj
string	ls_temp[]
long	ll_pos, ll_cnt

choose case idw_target.Describe(as_obj + ".Type")  /* only data column */
	case 'column'
		if Tooltipdescdwo = as_obj + 'desc' + string(al_row) then return
		ll_cnt = fw_f_obj2array(Tooltipdescdwo, "desc", ls_temp[])		
		if fw_f_nvls(Tooltipdescsave, '') = '' or ls_temp[1] <> as_obj then
			ls_tooliptext = idw_target.Describe(as_obj +".Tooltip.Tip")
		else
			ls_tooliptext = Tooltipdescsave
		end if
		
		ll_pos = pos(ls_tooliptext, 'describe=')
		if ll_pos = 0 then return
		ll_cnt = fw_f_obj2array(ls_tooliptext, "=", ls_temp[])
		if fw_f_nvls(ls_temp[2], '') = '' then return
		ls_dataobj = ls_temp[2]
		choose case idw_target.describe(ls_dataobj +".type")
			case '?', '!'
				return
		end choose
		of_exe4tooltip(idw_target, as_obj, ls_dataobj, 'column', 'Description', '12', al_row, 0, 0)
		Tooltipdescsave = ls_tooliptext
		Tooltipdescdwo = as_obj + 'desc' + string(al_row)
end choose
end subroutine

public subroutine of_exe4tooltip (datawindow adw_obj, string as_obj, string as_dataobj, string as_objtype, string as_tooltiptitle, string as_objoption, long al_row, long al_xpos, long al_ypos);string		ls_objcstr06, ls_rowdata
string		ls_syntax, ls_errmsg

choose case as_objtype
	case 'column'
		gnv_extfunc.of_setinitializationapi()
		gnv_extfunc.istr_node4value.cstr01 = as_obj
		gnv_extfunc.biznode1te(135, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		//ls_rowdata = adw_obj.describe(gnv_extfunc.is_nodevalue + gnv_extfunc.istr_node4value.cstr01 + ") ', " + string(al_row) + ")")
		ls_rowdata = adw_obj.describe(gnv_extfunc.is_nodevalue + as_dataobj + ") ', " + string(al_row) + ")")
		ls_rowdata = fw_f_replaceall(ls_rowdata, "'", '"')
		if fw_f_nvls(ls_rowdata, '') = '' then ls_rowdata = ''
		gnv_extfunc.istr_node4value.cstr02 = ls_rowdata
		gnv_extfunc.istr_node4value.cstr03 = as_tooltiptitle
		gnv_extfunc.biznode11te(107, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
		choose case as_objoption /* 1자리 :  objuseellipsis, 2자리 :  title */
			case '10'
				ls_objcstr06 = adw_obj.describe(gnv_extfunc.istr_node4value.cstr06)
				if ls_objcstr06 = 'yes' then
					ls_syntax = gnv_extfunc.istr_node4value.cstr11
				end if
			case '11'
				ls_objcstr06 = adw_obj.describe(gnv_extfunc.istr_node4value.cstr06)
				if ls_objcstr06 = 'yes' then
					ls_syntax = gnv_extfunc.istr_node4value.cstr10
				end if
			case '12'
				ls_syntax = gnv_extfunc.istr_node4value.cstr10
			case '01'
				ls_syntax = gnv_extfunc.istr_node4value.cstr10
			case '00'
				ls_syntax = gnv_extfunc.istr_node4value.cstr11
		end choose
		if fw_f_nvls(ls_syntax, '') <> '' then
			ls_errmsg	= adw_obj.modify(ls_syntax)
			if fw_f_nvls(ls_errmsg, '') <> '' then
				Messagebox('exe Tooltip column Error', ls_errmsg)
				return
			end if
		end if
	case 'column_t', 'text', 'rectangle'
		string		ls_tooltipenabled, ls_tooltipdesc
		gnv_extfunc.of_setinitializationapi()
		gnv_extfunc.istr_node4value.cstr01 = as_obj
		gnv_extfunc.istr_node4value.cstr02 = as_tooltiptitle
		gnv_extfunc.biznode11te(108, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
		ls_tooltipenabled	= adw_obj.Describe(gnv_extfunc.istr_node4value.cstr06)
		ls_tooltipdesc		= adw_obj.Describe(gnv_extfunc.istr_node4value.cstr07)		
		if ls_tooltipenabled = '1' and fw_f_nvls(ls_tooltipdesc, '') <> '' then
			choose case as_objoption /* 1자리 :  objuseellipsis, 2자리 :  title */
				case '01'
					ls_syntax = gnv_extfunc.istr_node4value.cstr10
				case '00'
					ls_syntax = gnv_extfunc.istr_node4value.cstr11
			end choose
		else
			if as_objtype = 'rectangle' then return
			ls_syntax = gnv_extfunc.istr_node4value.cstr09
		end if
		ls_errmsg	= adw_obj.Modify(ls_syntax)
		if fw_f_nvls(ls_errmsg, '') <> '' then
			Messagebox('exe Tooltip text Error', ls_errmsg)
			return
		end if
end choose
end subroutine

public function integer of_setsort_step3 (string as_obj, string as_sortorder_old, string as_sortorder_new, ref string as_sort_col[]);// dddw, ddlb 컬럼을 코드값이 아닌 화면에 보이는 값으로 sort 하는 옵션
string		ls_sortcriteria
string		ls_editstyle
string		ls_colexp
long		i, ll_pos
boolean	lb_lookup

ls_colexp = as_obj

If ib_lookupsort = true then
	ls_editstyle = idw_target.describe(as_obj + ".Edit.Style")
	choose case ls_editstyle
		case 'dddw', 'ddlb'
			lb_lookup = true
		case 'edit'
			choose case lower(idw_target.describe(as_obj + ".Edit.CodeTable"))
				case 'yes', '1'
					lb_lookup = true
			end choose
		case 'editmask'
			choose case lower(idw_target.describe(as_obj + ".EditMask.CodeTable"))
				case 'yes', '1'
					lb_lookup = true
			end choose
	end choose
	
	If lb_lookup = true then
		ls_colexp = "lookupdisplay(" + as_obj + ")"
	end if
end if

// null 데이터 값을 empty로 치환해서 sort 하는 옵션
If ib_nullsort = true then
	choose case left(lower(idw_target.describe(as_obj + ".coltype")), 5)
		case 'char('
			ls_colexp = 'If(isnull(' + ls_colexp + '), "", ' + ls_colexp + ')'
		case 'datet', 'times'
			ls_colexp = 'If(isnull(' + ls_colexp + '), 1900-01-01 00:00:00, ' + ls_colexp + ')'
		case 'date'
			ls_colexp = 'If(isnull(' + ls_colexp + '), 1900-01-01, ' + ls_colexp + ')'
		case 'decim', 'int', 'long', 'numbe', 'real', 'ulong'
			ls_colexp = 'If(isnull(' + ls_colexp + '), 0, ' + ls_colexp + ')'
		case 'time'
			ls_colexp = 'If(isnull(' + ls_colexp + '), 00:00:00, ' + ls_colexp + ')'
	end choose
end if

// 소트 criteria 생성
If ib_multisort = true then
	ls_sortcriteria = idw_target.describe("Datawindow.Table.Sort")
	If ls_sortcriteria = '!' or ls_sortcriteria = '?' then ls_sortcriteria = ''
	
	// Appeon 인 경우 [If(isnull(code_name), "", code_name) D] 형태로 소트를 진행하면
	// [If ( isnull ( code_name ) , "" , code_name ) D] 처럼 형태가 변경됨... 이를 맞춰주기 위해서 Temp Datastore를 사용합니다.
	If gnv_vari.getclienttype = "WEB" then
		datastore lds_temp
		lds_temp = create datastore
		lds_temp.dataobject = idw_target.dataobject
		lds_temp.setsort(ls_colexp + " " + as_sortorder_old)
		ls_colexp = lds_temp.describe("Datawindow.Table.Sort")
		ls_colexp = left(ls_colexp, len(ls_colexp) - 2)
	end if
	
	ll_pos = pos(ls_sortcriteria, ls_colexp + " " + as_sortorder_old)
	If ll_pos > 0 then
		ls_sortcriteria = replace(ls_sortcriteria, ll_pos, len(ls_colexp + " " + as_sortorder_old), ls_colexp + " " + as_sortorder_new)
	else
		If len(ls_sortcriteria) > 0 then ls_sortcriteria += ", "
		ls_sortcriteria += ls_colexp + " " + as_sortorder_new
	end if
else
	ls_sortcriteria = ls_colexp + " " + as_sortorder_new
end if

// 소트 수행
idw_target.setsort(ls_sortcriteria)
idw_target.sort()
If idw_target.findgroupchange(0, 1) > 0 then
	idw_target.groupcalc()
end if

// 데이터윈도우 디자인
string	ls_text, ls_sortcheck
string	ls_syntax, ls_error
long	ll_ypos
long	ll_sortobjcnt

If as_sortorder_new = 'A' then
	ls_text = "t"
else
	ls_text = "u"
end if

If as_sortorder_old = 'None' then
	gnv_extfunc.of_setinitializationapi()
	gnv_extfunc.istr_node4value.cstr01	= as_obj
	gnv_extfunc.istr_node4value.cstr02	= string(gnv_vari.sort2arrow4color)
	gnv_extfunc.istr_node4value.cstr03	= ls_text
	gnv_extfunc.istr_node4value.cstr04	= as_sortorder_new
	gnv_extfunc.istr_node4value.cstr05	= string(PixelsToUnits(19, XPixelsToUnits!))
	ll_ypos = UnitsToPixels(long(idw_target.describe(as_obj + "_t.height")) * (1 / 10), YUnitsToPixels!)
	gnv_extfunc.istr_node4value.cstr06	= string(PixelsToUnits(ll_ypos, YPixelsToUnits!))
	gnv_extfunc.biznode11te(104, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
	
	ls_syntax = gnv_extfunc.istr_node4value.cstr09
	ls_error = idw_target.modify(ls_syntax)
	if ls_error <> '' then
		::clipboard(idw_target.classname() + "~r~n" + ls_syntax)
		messagebox("sort", idw_target.classname() + " of_setsort_step3 create sortarrow syntax failure!!~r~n" + ls_error)
		return -1
	end if
end if

ll_sortobjcnt = upperbound(idw_target.isobj2sort[])
if ll_sortobjcnt < 1 then
	idw_target.isobj2sort[1] = as_obj
	is_sort_syntax[1] += idw_target.isobj2sort[1] + "_sortarrow.text='" + ls_text + "'~r~n"
	is_sort_syntax[1] += idw_target.isobj2sort[1] + "_sortarrow.visible=1~r~n"
	is_sort_syntax[1] += idw_target.isobj2sort[1] + "_sortarrow.tag='" + as_sortorder_new + "'~r~n"
else
	ls_sortcheck = 'N'
	for i = 1 to ll_sortobjcnt
		if idw_target.isobj2sort[i] = as_obj then
			is_sort_syntax[i] = as_obj+ "_sortarrow.text='" + ls_text + "'~r~n"
			is_sort_syntax[i] += as_obj+ "_sortarrow.tag='" + as_sortorder_new + "'~r~n"
			is_sort_syntax[i] += as_obj+ "_sortarrow.visible=1~r~n"
			ls_sortcheck = 'Y'
		else		
			is_sort_syntax[i] = idw_target.isobj2sort[i]+ "_sortarrow.text=''~r~n"
			is_sort_syntax[i] += idw_target.isobj2sort[i]+ "_sortarrow.tag=''~r~n"
			is_sort_syntax[i] += idw_target.isobj2sort[i]+ "_sortarrow.visible=0~r~n"
		end if
	next
	if ls_sortcheck = 'N' then
		idw_target.isobj2sort[ll_sortobjcnt + 1] = as_obj
		is_sort_syntax[ll_sortobjcnt + 1] += as_obj + "_sortarrow.text='" + ls_text + "'~r~n"
		is_sort_syntax[ll_sortobjcnt + 1] += as_obj + "_sortarrow.tag='" + as_sortorder_new + "'~r~n"
		is_sort_syntax[ll_sortobjcnt + 1] += as_obj + "_sortarrow.visible=1~r~n"
	end if
end if

return 1
end function

public subroutine of_setsort_clear ();of_setdestroy2sort('')
end subroutine

public subroutine of_ibsetlist4mouseovercolor (long al_row);choose case isdesignstyle
	case 'grid', 'tabular'
		idw_target.object.datawindow.detail.pointer = string(al_row)
		idw_target.setredraw(true)
end choose
end subroutine

on fw_n_handle.create
call super::create
end on

on fw_n_handle.destroy
call super::destroy
end on

