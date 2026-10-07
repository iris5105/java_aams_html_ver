forward
global type pf_n_rolemenu from n_ancestor
end type
end forward

global type pf_n_rolemenu from n_ancestor
end type
global pf_n_rolemenu pf_n_rolemenu

type variables
public:
	fw_n_dso	ids_menudata, ids_fullmenudata

	string	is_platform_type
end variables

forward prototypes
public function string of_thisname ()
public function long of_getmenudata (string as_itemtype, string as_pgmno)
protected subroutine of_setplatformtype ()
public subroutine of_initfw_n_dso ()
public function string of_getpgmicon (string as_pgmno)
public function string of_getpgmnm (string as_pgmno)
public function string of_getpgmpath (string as_pgmno)
public function long of_getmenuauth (string as_pgmno)
public function long of_fulllmenudata (string as_userrole[])
public function string of_getpgmid (string as_pgmno)
public function string of_getpgmparameter (string as_pgmno, string as_seq)
public subroutine of_setdsbymenudata ()
public function integer of_getmenudata_by_pgmid (string as_pgm_id, ref n_menu anv_menudata)
public function integer of_getmenudata_by_pgmno (string as_pgm_no, ref n_menu anv_menudata)
public subroutine of_setopensheet (string as_pgm_no)
public subroutine of_setpgmgo (string as_pgmgo)
public function long of_getlevel4menu (string as_pgmno)
public function string of_getlevellist4pgm (string as_pgmno)
public function string of_getlevel4findmenu (string as_pgmno, integer al_level)
public function integer of_getpgmsearchdata (datawindow adw_pgm_search)
public function integer of_gettreemenudata (ref fw_s_menudata astr_data[])
end prototypes

public function string of_thisname ();return 'pf_n_rolemenu'

end function

public function long of_getmenudata (string as_itemtype, string as_pgmno);of_initfw_n_dso() /* Filter init */
// 로그인 사용자에게 할당된 메뉴를 설정합니다
// 설정된 메뉴는 ids_userrrole 데이터스토어에 보관됩니다.
Long	ll_ret

Choose Case as_itemtype
	Case 'self'
		ids_fullmenudata.SetFilter("pgm_no = '" + as_pgmno + "' ")
		ids_fullmenudata.Filter()
		ids_fullmenudata.GroupCalc( )
		ll_ret = ids_fullmenudata.Rowcount()
	Case 'parent'
		ids_fullmenudata.SetFilter("parent_pgm = '" + as_pgmno + "' ")
		ids_fullmenudata.Filter()
		ids_fullmenudata.SetSort("parent_pgm a, sort_order a")
		ids_fullmenudata.Sort()
		ids_fullmenudata.GroupCalc( )
		ll_ret = ids_fullmenudata.Rowcount()
End Choose

ids_menudata.Object.Data = ids_fullmenudata.Object.Data /* sharedata는 구성에 맞지않음 */

return ll_ret
end function

protected subroutine of_setplatformtype ();// 파워프레임은 플랫폼 타입에 따라 메뉴 구성이 달라질 수 있습니다.

// CS,  WEB,  MOBILE 구분
Choose case lower(gnv_vari.getclienttype)
	Case 'pb'
		is_platform_type = '1__'
	Case 'web'
		is_platform_type = '_1_'
	Case 'mobile'
		is_platform_type = '__1'
End Choose
end subroutine

public subroutine of_initfw_n_dso ();ids_fullmenudata.SetFilter("")
ids_fullmenudata.Filter()
ids_fullmenudata.GroupCalc()
ids_menudata.Reset()
end subroutine

public function string of_getpgmicon (string as_pgmno);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_pgm_icon
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ls_pgm_icon = ids_fullmenudata.GetItemString(ll_find, 'pgm_icon')
Else
	ls_pgm_icon = '..\img\mainframe\mdi4topmenu\mainicon_01.jpg'
End If

return ls_pgm_icon
end function

public function string of_getpgmnm (string as_pgmno);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_pgm_nm
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ls_pgm_nm = ids_fullmenudata.GetItemString(ll_find, 'pgm_nm')
Else
	ls_pgm_nm = ''
End If

return ls_pgm_nm
end function

public function string of_getpgmpath (string as_pgmno);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_pgmpath, ls_pgmgo
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ls_pgmgo = ids_fullmenudata.GetItemString(ll_find, 'pgm_go')
	ls_pgmpath = ids_fullmenudata.GetItemString(ll_find, 'fullpgmpath')
	If left(ls_pgmpath, 3) = ' > ' Then ls_pgmpath = Mid(ls_pgmpath, 4, len(ls_pgmpath) - 3)
Else
	ls_pgmpath = ''
End If

Return ls_pgmpath
end function

public function long of_getmenuauth (string as_pgmno);of_initfw_n_dso()/* Filter init */
// as_pgmno = 프로그램 NO
string	ls_pgmlevel
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
ll_find = fw_f_nvll(ll_find, 0)

return ll_find
end function

public function long of_fulllmenudata (string as_userrole[]);Long	ll_retval

ids_fullmenudata.SetTransObject (sqlca)
ll_retval = ids_fullmenudata.retrieve (gnv_vari.is_sys_id, gnv_vari.is_lang_type, as_userrole[1], as_userrole[2])

Return ll_retval
end function

public function string of_getpgmid (string as_pgmno);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_pgm_id
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ls_pgm_id = ids_fullmenudata.GetItemString(ll_find, 'pgm_id')
Else
	ls_pgm_id = ''
End If

return ls_pgm_id
end function

public function string of_getpgmparameter (string as_pgmno, string as_seq);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_parameter
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	Choose Case as_seq
		Case '1'
			ls_parameter = ids_fullmenudata.GetItemString(ll_find, 'parameter1')
		Case '2'
			ls_parameter = ids_fullmenudata.GetItemString(ll_find, 'parameter2')
		Case '3'
			ls_parameter = ids_fullmenudata.GetItemString(ll_find, 'parameter3')
	End Choose	
Else
	ls_parameter = ''
End If

return ls_parameter
end function

public subroutine of_setdsbymenudata ();// 로그인 사용자에게 할당된 메뉴를 retrieve
ids_fullmenudata = Create fw_n_dso
ids_fullmenudata.dataobject = 'fw_d_fullrollmenu_ora'

ids_menudata = Create fw_n_dso
ids_menudata.dataobject = ids_fullmenudata.dataobject
end subroutine

public function integer of_getmenudata_by_pgmid (string as_pgm_id, ref n_menu anv_menudata);// ProgramID 값으로 메뉴데이터 Structure 값을 구한다
If isnull(as_pgm_id) or as_pgm_id = ''               Then Return -1
If isnull(anv_menudata) or not isvalid(anv_menudata) Then Return -1

of_initfw_n_dso()/* Filter init */

Long	ll_row

ids_fullmenudata.SetFilter("pgm_id = upper('" + as_pgm_id + "') ")
ids_fullmenudata.Filter()
ids_fullmenudata.GroupCalc( )
ll_row = ids_fullmenudata.Rowcount()

Choose Case ll_row
	Case 1
		anv_menudata.is_pgm_no	= ids_fullmenudata.getitemstring(1, 'pgm_no')
		anv_menudata.is_pgm_id	= ids_fullmenudata.getitemstring(1, 'pgm_id')
		anv_menudata.is_pgm_nm	= ids_fullmenudata.getitemstring(1, 'pgm_nm')
	Case is > 1
		anv_menudata.is_pgm_no	= ids_fullmenudata.getitemstring(1, 'pgm_no')
		anv_menudata.is_pgm_id	= ids_fullmenudata.getitemstring(1, 'pgm_id')
		anv_menudata.is_pgm_nm	= ids_fullmenudata.getitemstring(1, 'pgm_nm')
	Case Else
		anv_menudata.is_pgm_no = ''
		anv_menudata.is_pgm_id = ''
		anv_menudata.is_pgm_nm = ''
End Choose

Return ll_row
end function

public function integer of_getmenudata_by_pgmno (string as_pgm_no, ref n_menu anv_menudata);// ProgramNo 값으로 메뉴데이터 Structure 값을 구한다
long ll_retval

return ll_retval
end function

public subroutine of_setopensheet (string as_pgm_no);String	ls_pgm_id, ls_pgm_nm, ls_parameter1, ls_parameter2, ls_parameter3, ls_fullpgmlvl4cd, ls_tobelv1, ls_tobelv2, ls_tobemobj
String	ls_pgmarr[]
Long		ll_pgmcnt, ll_i

ls_pgm_id = of_getpgmid(as_pgm_no)
If fw_f_nvls(ls_pgm_id, '') = '' Then
	Messagebox('Check', 'You do not have permission for this program.')
	Return
End If
ls_pgm_nm = of_getpgmnm(as_pgm_no)
ls_parameter1 = of_getpgmparameter(as_pgm_no, '1')
ls_parameter2 = of_getpgmparameter(as_pgm_no, '2')
ls_parameter3 = of_getpgmparameter(as_pgm_no, '3')

ls_fullpgmlvl4cd = of_getlevellist4pgm(as_pgm_no)
ll_pgmcnt = fw_f_obj2array(ls_fullpgmlvl4cd, ';', ls_pgmarr[])
If ll_pgmcnt < 1 Then Return
For ll_i = 1 To ll_pgmcnt
	If ls_pgmarr[ll_i] = '0'     Then Continue
	If ls_pgmarr[ll_i] = '00000' Then Continue
	ls_tobelv1 = ls_pgmarr[ll_i]
	ls_tobelv2 = ls_pgmarr[ll_i + 1]
	Exit
Next
ls_tobemobj = gw_mdi.uo_topmenu.dynamic of_getobj4menu(ls_tobelv1)
If fw_f_nvls(ls_tobemobj, '') <> '' Then
	gw_mdi.uo_topmenu.dynamic of_menuclicked (0, ls_tobemobj)
End If
Yield ( )

//ls_tobemobj = gw_mdi.uo_submenu.dynamic of_getobj4menu(ls_tobelv2)
//If fw_f_nvls(ls_tobemobj, '') <> '' Then
//	gw_mdi.uo_submenu.dynamic of_menuclicked(0, ls_tobemobj)
//End If
//Yield ( )

gw_mdi.uo_xpmenu.of_setpgmexpression(as_pgm_no)

gw_mdi.Post dynamic of_opensheet(as_pgm_no, ls_pgm_id, ls_pgm_nm, ls_parameter1, ls_parameter2, ls_parameter3)
end subroutine

public subroutine of_setpgmgo (string as_pgmgo);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_pgm_no
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_go='" + as_pgmgo + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ls_pgm_no = ids_fullmenudata.GetItemString(ll_find, 'pgm_no')
	of_setopensheet(ls_pgm_no)
Else
	Messagebox('Check', '프로그램 번호를 다시 확인해 주십시요')
End If
end subroutine

public function long of_getlevel4menu (string as_pgmno);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
Long	ll_level4menu
Long	ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ll_level4menu = ids_fullmenudata.GetItemNumber(ll_find, 'maxlvl')
Else
	ll_level4menu = 0
End If

return ll_level4menu
end function

public function string of_getlevellist4pgm (string as_pgmno);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_pgmlevel
Long		ll_find

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ls_pgmlevel = ids_fullmenudata.GetItemString(ll_find, 'fullpgmlevel')
Else
	ls_pgmlevel = ''
End If

return ls_pgmlevel
end function

public function string of_getlevel4findmenu (string as_pgmno, integer al_level);of_initfw_n_dso()/* Filter init */
// 프로그램 기본정보에 등록된 프로그램 명을 구합니다
// as_pgmno = 프로그램 NO
string	ls_pgmno, ls_fullpgmlevel, ls_temp
string	ls_data[]
Long		ll_find, ll_objcnt

ll_find = ids_fullmenudata.find("pgm_no='" + as_pgmno + "'", 1, ids_fullmenudata.rowcount())
If fw_f_nvll(ll_find, 0) > 0 Then
	ls_fullpgmlevel = ids_fullmenudata.GetItemString(ll_find, 'fullpgmlevel')
	ll_objcnt = fw_f_obj2array(ls_fullpgmlevel, ";", ls_data[])
	If ll_objcnt>0 Then ls_pgmno = ls_data[al_level]
Else
	ls_pgmno = ''
End If

return ls_pgmno
end function

public function integer of_getpgmsearchdata (datawindow adw_pgm_search);// MDI PGM-GO에서 사용 DATA.
ids_fullmenudata.setfilter( "pgm_kc = 'P'" )
ids_fullmenudata.filter()

adw_pgm_search.object.pgm_no.Primary = ids_fullmenudata.object.pgm_no.Primary
adw_pgm_search.object.pgm_id.Primary = ids_fullmenudata.object.pgm_id.Primary
adw_pgm_search.object.pgm_go.Primary = ids_fullmenudata.object.pgm_go.Primary
adw_pgm_search.object.pgm_kc.Primary =ids_fullmenudata.object.pgm_kc.Primary
adw_pgm_search.object.fullpgmpath.Primary = ids_fullmenudata.object.fullpgmpath.Primary

ids_fullmenudata.setfilter( "" )
ids_fullmenudata.filter()

return adw_pgm_search.rowcount()
end function

public function integer of_gettreemenudata (ref fw_s_menudata astr_data[]);long	i, ll_rowcnt

ll_rowcnt = ids_fullmenudata.RowCount()

for i = 1 to ll_rowcnt
	astr_data[i].pgm_no		= ids_fullmenudata.getitemstring(i, 'pgm_no')
	astr_data[i].pgm_id		= ids_fullmenudata.getitemstring(i, 'pgm_id')
	astr_data[i].pgm_kc		= ids_fullmenudata.getitemstring(i, 'pgm_kc')
	astr_data[i].pgm_nm		= ids_fullmenudata.getitemstring(i, 'pgm_nm')
	astr_data[i].parent_pgm	= ids_fullmenudata.getitemstring(i, 'parent_pgm')
	astr_data[i].parameter1	= ids_fullmenudata.getitemstring(i, 'parameter1')
	astr_data[i].parameter2	= ids_fullmenudata.getitemstring(i, 'parameter2')
	astr_data[i].parameter3	= ids_fullmenudata.getitemstring(i, 'parameter3')
next

return ll_rowcnt
end function

on pf_n_rolemenu.create
call super::create
end on

on pf_n_rolemenu.destroy
call super::destroy
end on

event constructor;call super::constructor;This.of_setplatformtype() // 현재 어플리케이션의 실행환경 및 메뉴 권한 생성 
This.of_setdsbymenudata()
end event

event destructor;call super::destructor;destroy ids_menudata
destroy ids_fullmenudata
end event

