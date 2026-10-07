forward
global type fw_w_btn_assign from w_window1st5ncn
end type
type dw_rolemst from fw_u_dwo within fw_w_btn_assign
end type
type dw_rolepgm from fw_u_dwo within fw_w_btn_assign
end type
type st_1 from pf_u_splitbar_vertical within fw_w_btn_assign
end type
type dw_role_memb from fw_u_dwo within fw_w_btn_assign
end type
end forward

global type fw_w_btn_assign from w_window1st5ncn
boolean ibconfirmupdate4closequery = true
dw_rolemst dw_rolemst
dw_rolepgm dw_rolepgm
st_1 st_1
dw_role_memb dw_role_memb
end type
global fw_w_btn_assign fw_w_btn_assign

type variables
String		isDataWindowSyntax = ''
end variables

forward prototypes
public function integer of_getbuttonlist (string as_pgm_id, ref windowobject awo_button[])
public function long of_getwindowcontrols (windowobject awo_input[], ref windowobject awo_output[])
public subroutine of_set_com_btn_auth_yn ()
end prototypes

public function integer of_getbuttonlist (string as_pgm_id, ref windowobject awo_button[]);window	lw_window
lw_window = create using as_pgm_id

if isnull(lw_window) then return -1
if not isvalid(lw_window) then return -1

long	i, ll_objcnt, ll_btncnt

windowobject	lw_object[]
ll_objcnt = of_getwindowcontrols (lw_window.control[], lw_object[])
for i = 1 to ll_objcnt
	choose case lw_object[i].typeof()
		case commandbutton!, picturebutton!
			ll_btncnt ++
			awo_button[ll_btncnt] = lw_object[i]
		case picture!
			picture lp_object
			lp_object = lw_object[i]
			if lp_object.triggerevent('oue_components') = 1 then
				if lp_object.dynamic of_thisname() = 'pf_u_imagebutton' then
					ll_btncnt ++
					awo_button[ll_btncnt] = lw_object[i]
				end if
			end if
	end choose
next
return ll_btncnt
end function

public function long of_getwindowcontrols (windowobject awo_input[], ref windowobject awo_output[]);long	ll_Input, ll_InputCount, ll_OutputCount, ll_Sub, ll_SubCount

window	lw_Control

userobject	luo_UserObject

tab	ltb_Tab

windowobject	lwo_Empty[], lwo_Sub[]

awo_Output = lwo_Empty

ll_InputCount = UpperBound (awo_Input)
FOR ll_Input = 1 TO ll_InputCount
    ll_OutputCount ++
    awo_Output[ll_OutputCount] = awo_Input[ll_Input]
    CHOOSE CASE awo_Input[ll_Input].TypeOf()
        CASE UserObject!
            luo_UserObject = awo_Input[ll_Input]
            ll_SubCount = of_getwindowcontrols (luo_UserObject.Control, lwo_Sub)
            FOR ll_Sub = 1 TO ll_SubCount
                ll_OutputCount ++
                awo_Output[ll_OutputCount] = lwo_Sub[ll_Sub]
            NEXT
        CASE Tab!
            ltb_Tab = awo_Input[ll_Input]
            ll_SubCount = of_getwindowcontrols (ltb_Tab.Control, lwo_Sub)
            FOR ll_Sub = 1 TO ll_SubCount
                ll_OutputCount ++
                awo_Output[ll_OutputCount] = lwo_Sub[ll_Sub]
            NEXT
    END CHOOSE
NEXT

RETURN ll_OutputCount
end function

public subroutine of_set_com_btn_auth_yn ();// 공통버튼 사용여부(Y/N)을 설정합니다.
dw_rolepgm.setitem(dw_rolepgm.getrow(), 'comm_btn_auth_yn', 'Y')
end subroutine

on fw_w_btn_assign.create
int iCurrent
call super::create
this.dw_rolemst=create dw_rolemst
this.dw_rolepgm=create dw_rolepgm
this.st_1=create st_1
this.dw_role_memb=create dw_role_memb
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rolemst
this.Control[iCurrent+2]=this.dw_rolepgm
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_role_memb
end on

on fw_w_btn_assign.destroy
call super::destroy
destroy(this.dw_rolemst)
destroy(this.dw_rolepgm)
destroy(this.st_1)
destroy(this.dw_role_memb)
end on

event wue_postopen;call super::wue_postopen;isDataWindowSyntax = dw_rolepgm.Describe("DataWindow.Syntax")

p_retrieve.Post Event Clicked()
end event

event wue_retrieve;call super::wue_retrieve;//dw_role_memb.of_dw2subbtn ({'p_input','p_delete'}, true)
dw_rolemst.retrieve(gnv_vari.is_sys_id, '%')
end event

event wue_update;call super::wue_update;if of_update({dw_rolepgm}) >= 0 then
	return 0
else
	return -1
end if
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw(dw_rolemst, 'pgm_lv2', {gnv_vari.is_sys_id})
end event

event wue_retrieve2ready;call super::wue_retrieve2ready;dw_rolemst.reset()
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_btn_assign
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_btn_assign
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_btn_assign
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_btn_assign
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_btn_assign
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_btn_assign
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_btn_assign
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_btn_assign
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_btn_assign
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_btn_assign
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_btn_assign
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_btn_assign
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_btn_assign
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_btn_assign
end type

type p_close from w_window1st5ncn`p_close within fw_w_btn_assign
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_btn_assign
end type

type p_print from w_window1st5ncn`p_print within fw_w_btn_assign
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_btn_assign
end type

type p_update from w_window1st5ncn`p_update within fw_w_btn_assign
end type

type p_input from w_window1st5ncn`p_input within fw_w_btn_assign
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_btn_assign
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_btn_assign
end type

type dw_rolemst from fw_u_dwo within fw_w_btn_assign
integer x = 50
integer y = 156
integer width = 2139
integer height = 1384
integer taborder = 10
boolean bringtotop = true
string title = "권한 리스트"
string dataobject = "fw_d_btn_assign_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletobottom = true
boolean ibconfirmupdate4rowchanged = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

event rowfocuschanged;call super::rowfocuschanged;If currentrow = 0 Then Return

String	ls_role_no, ls_role_nm, ls_div

If appeongetclienttype() = 'WEB' Then
	dw_rolepgm.Create(isDataWindowSyntax)
	dw_rolepgm.SetTransObject( sqlca )
End If

ls_role_no = This.getitemstring(currentrow, 'role_no')

dw_rolepgm.retrieve(gnv_vari.is_sys_id, ls_role_no)

/* to-be */
ls_role_no = this.getitemstring(currentrow, 'role_no')

dw_role_memb.retrieve (gnv_vari.is_sys_id, f_nvl (ls_role_no,'%'))
end event

type dw_rolepgm from fw_u_dwo within fw_w_btn_assign
integer x = 2222
integer y = 156
integer width = 3209
integer height = 2608
integer taborder = 10
boolean bringtotop = true
string title = "공통 버튼 권한"
string dataobject = "fw_d_btn_assign_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setedittoken = true
end type

event itemchanged;call super::itemchanged;choose case dwo.name
	case 'retrieve_auth_yn','input_auth_yn','delete_auth_yn','update_auth_yn','print_auth_yn','execute_auth_yn','cancel_auth_yn','ext1_auth_yn','excel_auth_yn'
		IF	dwo.name='update_auth_yn'	Then
			This.SetItem(row, 'cancel_auth_yn', data)
			This.SetItem(row, 'input_auth_yn', data)
			This.SetItem(row, 'ext1_auth_yn', data)
			This.SetItem(row, 'delete_auth_yn', data)
		End IF
		parent.post of_set_com_btn_auth_yn()
end choose
end event

event doubleclicked;call super::doubleclicked;// 폴더 열기,닫기 기능 to-be
String	ls_pgm_no, ls_filterfr, ls_filtersyntax, Null_str

long	ll_treelevel, ll_startrow, ll_Endrow, ll_find, ll_detailheight, ll_rowcount, ll_i

This.AcceptText()

ll_rowcount	= This.Rowcount()
ll_detailheight = long(This.describe("Datawindow.Detail.Height"))

If This.Getitemstring(row, 'pgm_kind_code') = 'M' Then
	If This.Getitemnumber(row, 'visible_fg') = 1 Then
		ll_treelevel	= This.Getitemnumber(row, 'tree_level')
		ll_startrow	= row + 1
		ll_find = This.find("tree_level <= " + string(ll_treelevel), ll_startrow, ll_rowcount)

		If fw_f_nvll(ll_find, 0) = 0 or ll_find < 1 Then
			ll_Endrow = ll_rowcount
		Else
			ll_Endrow = ll_find - 1
		End If
		//Messagebox(string(row), string(ll_startrow)+ '/' + string(ll_Endrow))
		
		This.setitem(row, 'visible_fg', 0)
		This.setitemstatus(row, 'visible_fg', Primary!, NotModified!)
		Yield ( )
		This.SetDetailHeight(ll_startrow, ll_Endrow, 0)
		This.GroupCalc ( )
//		For ll_i = ll_startrow To ll_Endrow
//			ls_pgm_no = This.GetItemString(ll_i, 'pgm_no')
//			
//			If ll_i = ll_startrow Then ls_filterfr = "pgm_no not in ("
//			If ll_i = ll_Endrow Then
//				ls_filtersyntax = ls_filtersyntax + "'" + ls_pgm_no + "')"
//			Else
//				ls_filtersyntax = ls_filtersyntax + "'" + ls_pgm_no + "', "
//			End If
//		Next
//		This.SetRedRaw( false )
//		ls_filtersyntax = ls_filterfr + ls_filtersyntax
//		This.SetFilter(ls_filtersyntax)
//		This.Filter()
//		
//		This.ScrollToRow(row)
//		This.Modify("DataWindow.HorizontalScrollPosition=" + String(0))
//		This.SetRedRaw( true )
		
		/*as-is */
		//This.setitem(row, 'visible_fg', 0)
		//This.setitemstatus(row, 'visible_fg', Primary!, NotModified!)
		//This.SetDetailHeight(ll_startrow, ll_Endrow, 0)
//		If appeongetclienttype() = 'WEB' Then
//			This.SetRedRaw( false )
//			This.Modify("DataWindow.Detail.Height.AutoSize=Yes")
//			This.Modify("DataWindow.Detail.Height.AutoSize=No")
//			This.Modify("DataWindow.HorizontalScrollPosition=" + String(0))
//			This.SetRedRaw( true )
//		End If
	Else
		/* as-is */
		ll_treelevel = This.Getitemnumber(row, 'tree_level')
		ll_startrow = row + 1
		ll_find = This.find("tree_level <= " + string(ll_treelevel), ll_startrow, ll_rowcount)

		If fw_f_nvll(ll_find, 0) = 0 or ll_find < 1 Then
			ll_Endrow = ll_rowcount
		Else
			ll_Endrow = ll_find - 1
		End If

		This.setitem(row, 'visible_fg', 1)
		This.setitemstatus(row, 'visible_fg', primary!, notmodIfied!)
		Yield ( )
		This.setdetailheight(ll_startrow, ll_Endrow, ll_detailheight)
		This.GroupCalc ( )
		
//		This.setitem(row, 'visible_fg', 1)
//		This.setitemstatus(row, 'visible_fg', primary!, notmodIfied!)
//		/* filter INIT */
//		If This.FilteredCount() > 0 Then
//			This.SetRedRaw( false )
//			This.SetFilter("")
//			This.Filter()
//			This.ScrollToRow(row)
//			This.Modify("DataWindow.HorizontalScrollPosition=" + String(0))
//			This.SetRedRaw( true )
//		End If
	End If
End If
end event

type st_1 from pf_u_splitbar_vertical within fw_w_btn_assign
integer x = 2194
integer y = 164
integer width = 23
integer height = 2608
boolean bringtotop = true
boolean setsheetcolor = true
string leftdragobject = "dw_rolemst;dw_role_memb"
string rightdragobject = "dw_rolepgm"
end type

type dw_role_memb from fw_u_dwo within fw_w_btn_assign
integer x = 50
integer y = 1556
integer width = 2139
integer height = 1208
integer taborder = 30
boolean bringtotop = true
string title = "권한 멤버"
string dataobject = "fw_d_btn_assign_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean fixedtobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0001010000"
boolean ibsetlist4clearselect = true
end type

event rbuttondown;call super::rbuttondown;choose case dwo.name
	case 'valid_dt_from', 'valid_dt_to'
		string ls_date
		ls_date = string(this.getitemstring(row, string(dwo.name)), '@@@@/@@/@@')
		//if gf_dwsetdate(this, string(dwo.name), ls_date) then
		//	this.setitem(row, string(dwo.name), string(date(ls_date), 'yyyymmdd'))
		//end if
end choose
end event

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)
end event

