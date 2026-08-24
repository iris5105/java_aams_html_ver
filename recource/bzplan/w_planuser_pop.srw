forward
global type w_planuser_pop from w_response1st5ncn
end type
type dw_notice from u_dw within w_planuser_pop
end type
end forward

global type w_planuser_pop from w_response1st5ncn
integer width = 1883
integer height = 684
boolean titlebar = false
windowtype windowtype = child!
long backcolor = 16777215
dw_notice dw_notice
end type
global w_planuser_pop w_planuser_pop

type prototypes
FUNCTION boolean AnimateWindow(long lhWnd, long lTm, long lFlags ) library 'user32.dll'
FUNCTION boolean GetCursorPos(REF pf_s_POINT ipPoint) LIBRARY "user32.dll"
FUNCTION boolean ScreenToClient(ulong hWnd, ref pf_s_POINT lpPoint) Library "USER32.DLL"

end prototypes

type variables
windowobject	iwo_parent
dwobject			idwo_parent

fw_s_home		istr_home
end variables

forward prototypes
public subroutine of_highlightcolumn ()
public function string of_thisname ()
public function string of_getload4style (datawindow adw_target)
end prototypes

public subroutine of_highlightcolumn ();
end subroutine

public function string of_thisname ();return 'w_userplan_pop'
end function

public function string of_getload4style (datawindow adw_target);// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

string ls_processing, ls_style

ls_processing = adw_target.describe("datawindow.processing")
choose case long(ls_processing)
	case 0
		//freeform인 경우 : detail band height가 dw control의 height의 2.5배 미만(만약 Header가 있는경우를 대비)
		long ll_detailheight, ll_dwcontrolheight, ll_headerheight
		
		ll_headerheight = long(adw_target.describe("Datawindow.Header.Height"))
		ll_detailheight = long(adw_target.describe("Datawindow.Detail.Height"))
		ll_dwcontrolheight = adw_target.Height
		
		if ll_headerheight > pixelstounits(10, ypixelstounits!) then
			ls_style = "tabular"
		elseif ll_detailheight * 2.2 < ll_dwcontrolheight then
			ls_style = "tabular"
		else
			ls_style = "freeform"
		end if
	case 1
		ls_style = 'grid'
	case 2
		ls_style = 'label'
	case 3
		ls_style = 'graph'
	case 4
		ls_style = 'crosstab'
	case 5
		ls_style = 'composite'
	case 6
		ls_style = 'ole'
	case 7
		ls_style = 'richText'
	case 8
		ls_style = 'treevew'
	case 9
		ls_style = 'treeviewwithgrid'
	Case Else
		ls_style = 'etc'
end choose

return ls_style

end function

on w_planuser_pop.create
int iCurrent
call super::create
this.dw_notice=create dw_notice
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_notice
end on

on w_planuser_pop.destroy
call super::destroy
destroy(this.dw_notice)
end on

event close;istr_home.w_obj.Dynamic Post Event wue_retrieve2ready()
end event

event wue_postopen;call super::wue_postopen;String		ls_ymd
Long		ll_rtn

ls_ymd	= istr_home.ymd

dw_notice.SetTransObject( sqlca )

//ll_rtn = dw_notice.Retrieve(gnv_vari.is_sys_id, gnv_vari.is_user_id, ls_ymd)
ll_rtn = dw_notice.Retrieve(gnv_vari.is_sys_id, 'all', ls_ymd)

If ll_rtn = 0 Then
	dw_notice.Insertrow(0)
	dw_notice.Object.ymd[1] = ls_ymd
End If
end event

event wue_update;call super::wue_update;Long	ll_rtn
ll_rtn = of_update({dw_notice})
If ll_rtn > 0 Then Messagebox('Check', 'Saving has been carried out successfully')

Return ll_rtn
end event

event open;call super::open;istr_home = Message.PowerObjectParm

If Not IsValid(istr_home) Then Return

iw_parent = istr_home.w_obj
If IsValid(istr_home.dw_obj) Then
	iwo_parent	= istr_home.dw_obj
	idwo_parent	= istr_home.dwo_col
End If

powerobject lpo_parent
Long		ll_xpos, ll_ypos

// 부모 컨트롤의 X, Y 좌표를 구합니다.
lpo_parent = iwo_parent.getparent()
Do While isvalid(lpo_parent)
	Choose Case lpo_parent.typeof()
		Case tab!
			tab ltab
			ltab = lpo_parent
			ll_xpos += ltab.x
			ll_ypos += ltab.y
		Case userobject!
			userobject luo
			luo = lpo_parent
			ll_xpos += luo.x
			ll_ypos += luo.y
		Case window!
			String	ls_type
			ls_type = fw_f_nvls(iw_parent.Dynamic of_getwindowtype(), '')
			If Pos(ls_type, 'main') > 0 Then
				ll_xpos += gw_mdi.st_mdiclient.x
				ll_ypos += gw_mdi.st_mdiclient.y
			End If
			Exit
	End Choose
	lpo_parent = lpo_parent.getparent()
Loop

If Not isvalid(iw_parent) Then
	messagebox('Notice(fw_w_filter4dwo1)', '부모 윈도우를 찾을 수 없습니다.')
	return
End If

// 오브젝트의 타입에 따라 달력 위치를 조절합니다.
String	ls_date, ls_yyyy
Date	ld_date

Choose Case iwo_parent.typeof()	
	Case datawindow!
		datawindow ldw_parent
		ldw_parent = iwo_parent
		If This.of_getload4style(ldw_parent)  = 'freeform' Then
			If ldw_parent.titlebar = true Then
				ll_xpos += ldw_parent.x + Long(idwo_parent.x) + Pixelstounits(3, YPixelstounits!)
				ll_ypos += ldw_parent.y + Long(idwo_parent.y) + Long(idwo_parent.height) + Pixelstounits(29, YPixelstounits!)
			Else
				ll_xpos += ldw_parent.x + Long(idwo_parent.x)
				ll_ypos += ldw_parent.y + Long(idwo_parent.y) + Long(idwo_parent.height) + Pixelstounits(2, YPixelstounits!)
			End If
		Else
			ll_xpos += Long(istr_home.dwo_col.x) + Long(idwo_parent.x) - Pixelstounits(2, XPixelstounits!)
			ll_ypos += Long(istr_home.dwo_col.y) + (Long(idwo_parent.height) / 2) + ldw_parent.pointery()
		End If
End Choose

If ll_xpos + This.width > gw_mdi.width Then
	Choose Case iwo_parent.typeof()
		Case datawindow!
			ll_xpos -= This.width - Long(idwo_parent.width)
	End Choose
End If

If ll_ypos + This.height > iw_parent.workspaceheight() Then
	If ldw_parent.titlebar = true Then
		ll_ypos -= (This.height + Pixelstounits(27, YPixelstounits!))
	Else
		ll_ypos -= This.height
	End If
End If

This.x = ll_xpos
This.y = ll_ypos

If gnv_vari.getclienttype = 'WEB' Then This.Height -= pixelstounits(2, ypixelstounits!)
end event

type ln_tempbutton from w_response1st5ncn`ln_tempbutton within w_planuser_pop
end type

type ln_tempstart from w_response1st5ncn`ln_tempstart within w_planuser_pop
end type

type ln_templeft from w_response1st5ncn`ln_templeft within w_planuser_pop
end type

type ln_cond_start from w_response1st5ncn`ln_cond_start within w_planuser_pop
end type

type ln_tempright from w_response1st5ncn`ln_tempright within w_planuser_pop
end type

type ln_cond1_yline from w_response1st5ncn`ln_cond1_yline within w_planuser_pop
end type

type ln_dw1_yline from w_response1st5ncn`ln_dw1_yline within w_planuser_pop
end type

type p_print from w_response1st5ncn`p_print within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_delete from w_response1st5ncn`p_delete within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_new from w_response1st5ncn`p_new within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_close from w_response1st5ncn`p_close within w_planuser_pop
integer x = 2263
integer y = 140
end type

type p_cancel from w_response1st5ncn`p_cancel within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_ok from w_response1st5ncn`p_ok within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_preview from w_response1st5ncn`p_preview within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_update from w_response1st5ncn`p_update within w_planuser_pop
integer x = 2226
integer y = 132
end type

type p_excel from w_response1st5ncn`p_excel within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_clear from w_response1st5ncn`p_clear within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_modify from w_response1st5ncn`p_modify within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_retrieve from w_response1st5ncn`p_retrieve within w_planuser_pop
integer x = 2254
integer y = 128
end type

type p_tempsave from w_response1st5ncn`p_tempsave within w_planuser_pop
end type

type p_collect from w_response1st5ncn`p_collect within w_planuser_pop
end type

type p_select from w_response1st5ncn`p_select within w_planuser_pop
end type

type p_find from w_response1st5ncn`p_find within w_planuser_pop
end type

type p_execu from w_response1st5ncn`p_execu within w_planuser_pop
end type

type p_enroll from w_response1st5ncn`p_enroll within w_planuser_pop
end type

type dw_notice from u_dw within w_planuser_pop
integer width = 1874
integer height = 676
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_planuser_pop_1"
end type

event updatestart;call super::updatestart;dwitemstatus	 ldwstatus
long	ll_rcnt, ll_row, ll_grow, i
string	ls_mast_cd, ls_mast_name, ls_detail_cd
ll_rcnt = this.rowcount()

Do While ll_row <= ll_rcnt        
	ll_row = this.getnextmodified(ll_row, Primary!)
	IF ll_row > 0 THEN
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)
		Choose Case ldwstatus 
			Case NewModified!
				this.setItem(ll_row, 'sys_id',		gnv_vari.is_sys_id)
				this.setItem(ll_row, 'user_id',		gnv_vari.is_user_id)
				this.setItem(ll_row, 'ymd',		istr_home.ymd)
				this.setItem(ll_row, 'reg_id',		gnv_vari.is_user_id)
				this.setItem(ll_row, 'reg_dt',		fw_f_getymdhh24miss4s())
				this.setItem(ll_row, 'upd_id',		gnv_vari.is_user_id)
				this.setItem(ll_row, 'upd_dt',		fw_f_getymdhh24miss4s())
			Case DataModified!
				this.setItem(ll_row, 'upd_id',		gnv_vari.is_user_id)
				this.setItem(ll_row, 'upd_dt',		fw_f_getymdhh24miss4s())
		End CHoose
	ELSE            
		ll_row = ll_rcnt + 1        
	END IF
LOOP

end event

event clicked;call super::clicked;This.AcceptText()
Choose Case dwo.name
	Case 'p_update'
		Parent.Event wue_update()
		Post Close(parent)
	Case 'p_close'
		// 포커스 잃는 경우 종료
		Post Close(parent)
End Choose
end event

event losefocus;call super::losefocus;// 포커스 잃는 경우 종료
Post Close(parent)

end event

event oue_setupdatecheck;call super::oue_setupdatecheck;String		ls_temp
long		NbrRows, ll_row = 0

DWItemStatus		ldwstate

NbrRows = this.RowCount()

If NbrRows = 0 Then
	messagebox( "ERROR", "No data available.")
	Return 1
End If


DO WHILE ll_row <= NbrRows        
	ll_row = this.GetNextModIfied(ll_row, Primary!)        
	
	If ll_row > 0 Then
		ls_temp = fw_f_nvls(this.getItemString(ll_Row, 'description'), '')
		If Len(ls_temp) = 0 Then
			Messagebox("ERROR", "Please Register Description!")
			Return -1
		End If
	Else
		ll_row = NbrRows + 1
	End If
Loop

Return 1
end event

event rowfocuschanged;//
end event

