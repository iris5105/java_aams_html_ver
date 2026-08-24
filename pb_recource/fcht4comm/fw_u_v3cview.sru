forward
global type fw_u_v3cview from u_ancestor
end type
type st_isyaxeslabelstring1b from pf_u_statictext within fw_u_v3cview
end type
type dw_cht from fw_u_dwo within fw_u_v3cview
end type
type p_chart from pf_u_imagebutton within fw_u_v3cview
end type
type p_icontitile from picture within fw_u_v3cview
end type
type ln_x1 from line within fw_u_v3cview
end type
type ln_y1 from line within fw_u_v3cview
end type
type ln_y2 from line within fw_u_v3cview
end type
type ln_x2 from line within fw_u_v3cview
end type
type ln_x3 from line within fw_u_v3cview
end type
type ln_x4 from line within fw_u_v3cview
end type
type ln_x5 from line within fw_u_v3cview
end type
type ln_y3 from line within fw_u_v3cview
end type
type ln_y4 from line within fw_u_v3cview
end type
type ln_y5 from line within fw_u_v3cview
end type
type ln_x6 from line within fw_u_v3cview
end type
type ln_y6 from line within fw_u_v3cview
end type
type ln_y7 from line within fw_u_v3cview
end type
type ln_x7 from line within fw_u_v3cview
end type
type ln_x8 from line within fw_u_v3cview
end type
type ln_y9 from line within fw_u_v3cview
end type
type p_refresh from pf_u_imagebutton within fw_u_v3cview
end type
type st_top from pf_u_statictext within fw_u_v3cview
end type
type st_chartnm from pf_u_statictext within fw_u_v3cview
end type
type ln_1 from line within fw_u_v3cview
end type
type ln_2 from line within fw_u_v3cview
end type
type ln_3 from line within fw_u_v3cview
end type
type st_left from pf_u_statictext within fw_u_v3cview
end type
type st_bottom from pf_u_statictext within fw_u_v3cview
end type
type st_isyaxeslabelstring2b from pf_u_statictext within fw_u_v3cview
end type
type ole_cht from fw_u_cht4browser within fw_u_v3cview
end type
end forward

global type fw_u_v3cview from u_ancestor
integer width = 1710
integer height = 760
long backcolor = 16777215
event oue_datasets ( )
event oue_op4cht ( )
event oue_datasets4user ( )
st_isyaxeslabelstring1b st_isyaxeslabelstring1b
dw_cht dw_cht
p_chart p_chart
p_icontitile p_icontitile
ln_x1 ln_x1
ln_y1 ln_y1
ln_y2 ln_y2
ln_x2 ln_x2
ln_x3 ln_x3
ln_x4 ln_x4
ln_x5 ln_x5
ln_y3 ln_y3
ln_y4 ln_y4
ln_y5 ln_y5
ln_x6 ln_x6
ln_y6 ln_y6
ln_y7 ln_y7
ln_x7 ln_x7
ln_x8 ln_x8
ln_y9 ln_y9
p_refresh p_refresh
st_top st_top
st_chartnm st_chartnm
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
st_left st_left
st_bottom st_bottom
st_isyaxeslabelstring2b st_isyaxeslabelstring2b
ole_cht ole_cht
end type
global fw_u_v3cview fw_u_v3cview

type prototypes
// 인터넷 파일 캐시 제거
//Function long DeleteURLCacheEntry (string IPszURLname) Library "Wininet.dll" Alias for "DeleteURLCacheEntryA;Ansi"
end prototypes

type variables
Constant string string1te	= 'itemchanged'
Constant string string2te	= 'cht_yn'
Constant string sdelimiter	= ';'
Constant long il_timeout	 = 500

Private:
	fw_n_v3cview	inv_v3cview
	datawindow	idw_cht
	datastore		ids_uniondata
	
	string			ishtmlvalue			= ''
	string			ishtmlvalue_sub		= ''
	string			ishtmlurl			= ''
	string			isruntype			= '01'
	/* parsetoarray Variable */ 
	string			is_obj, is_obj_chk
	string			is_objlist[], is_null[]
	string			is_selectobj[]
	string			is_header_nm[], is_uniontemp[]
	long			il_uniontempcnt		= 0
	long			il_oleorgheight		= 0
	long			il_titlenum			= 0
	long			il_objcnt			= 0
	boolean		setinitdata			= false
	boolean		ib_chtyn			= false			/* cht_yn 유무 */
	/* business 구성 Variable */
	long			illivedata[], ilprevdata[], ilnullarr[]
	long			ilintervalrow[], ilintervalrow_empty[]
	long			ilmaxcount			= 10000
	long			ilselectcnt			= 0
	string			isasissyntax			= ''
	
	boolean		ibchar4datasetgb	= true
	boolean		ibcallbackdatagb	= false
	//boolean		ibconfirm4datasum	= false //tooltips use gb
	
	boolean		ibclosing		= false
Protected:
	boolean	A--------------------------------user-not-enable	/* empty Object */
	long			il_row					= 0
	string			isgetchtdata			= ''	
	string			isobj2event				= ''
	string			isinterval_yn				= 'N'
	string			istimeractive_yn			= 'N'
//	string			isdatasets				= ''
//	string			isuserdatasets			= '' // 사용자 datasets

Public:
	fw_s_cht4property 	istr_cht4property1, istr_cht4property2
	boolean	B--------------------------------powerbuilder		// empty Object */
	string			is_objectbackcolor		= '250,250,250'
	string			is_titletextcolor			= '45,45,45'
	boolean		ibfullsize4pb		= false	
	boolean		ibbtnvisible4pb		= true
	boolean		ibtitlevisible4pb		= true
	boolean		iblinevisible4pb		= true
	string			istitlenm			= ''
end variables

forward prototypes
public subroutine of_setcharthtml (string as_values)
public function string of_thisname ()
public subroutine of_runhtml ()
public subroutine of_setinitialhtml ()
public subroutine of_setinitialvariables ()
public subroutine of_setdatalimited (long al_limited)
public function integer of_setchton_step1_2sub (datawindow adw_data, string as_actionnm[])
public subroutine of_default4cht (datawindow adw_data)
public subroutine of_default4cht (string as_runtype)
public subroutine of_default4cht_delete ()
public function string of_getcallbackdata ()
public function string of_getreadystate ()
public subroutine of_setoption4fcht ()
public subroutine of_setaccept4cht ()
public function integer of_setexception4cht ()
public subroutine of_setchton_step2 (datawindow adw_obj, datawindow adw_title, long al_row, boolean ab_rowtof)
public subroutine of_setchton_step2 (datawindow adw_obj, string as_title, long al_row, boolean ab_rowtof)
public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], datawindow adw_title, long al_row)
public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], string as_title, long al_row)
public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], string as_title, string as_selectobj[], long al_row)
public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], datawindow adw_title, string as_selectobj[], long al_row)
public subroutine of_setchton_step2 (datawindow adw_obj, datawindow adw_title, string as_selectobj[], long al_row, boolean ab_rowtof)
public subroutine of_setchton_step2 (datawindow adw_obj, string as_title, string as_selectobj[], long al_row, boolean ab_rowtof)
public subroutine of_default4cht (datawindow adw_data, string as_selectobj[])
public subroutine of_default4cht (string as_runtype, string as_selectobj[])
public subroutine of_sethide4cht ()
public function integer of_setchton_step1_1sub (datawindow adw_data, long al_row)
public subroutine of_setagain4html ()
public function string of_getobj2event ()
public subroutine of_getdbproperty ()
public function boolean of_geterrorissue ()
public function decimal of_setminmax_multiple (decimal adc_num, decimal adc_multiple)
public subroutine of_setminmax_step1 (string as_gb, string as_selectobj[])
public subroutine of_setminmax_step2 (string as_data[])
end prototypes

event oue_datasets();string	ls_json

istr_cht4property1.isdatasets = ''
ls_json = ''

istr_cht4property1.isdatasets = '{"datasets" : [' + ls_json + '] }'

//istr_cht4property1.isdatasets = + &
//"{"datasets" :' + &
//	' ['+ &      
//		'{"backgroundColor" : "rgba(255, 0, 0, 0.3)","borderColor": "rgba(255,0,0,0.1)" },' + &     
//		'{"backgroundColor" : "rgba(255, 0, 0, 0.3)","borderColor": "rgba(255,0,0,0.1)" },' + &     
//		'{"backgroundColor" : "rgba(255, 0, 0, 0.3)","borderColor": "rgba(255,0,0,0.1)" }' + &     
//		']'+ &
//'}'

end event

event oue_datasets4user();// chart option , chart datasets 사용자 설정 
istr_cht4property1.isuserdatasets = ''

//isuserdatasets = + &
//"{"datasets" :' + &
//	' ['+ &      
//		'{"backgroundColor" : "rgba(255, 0, 0, 0.3)","borderColor": "rgba(255,0,0,0.1)" },' + &     
//		'{"backgroundColor" : "rgba(255, 0, 0, 0.3)","borderColor": "rgba(255,0,0,0.1)" },' + &     
//		'{"backgroundColor" : "rgba(255, 0, 0, 0.3)","borderColor": "rgba(255,0,0,0.1)" }' + &     
//		']'+ &
//'}'
end event

public subroutine of_setcharthtml (string as_values);if fw_f_nvls(istr_cht4property1.ischtkind, '') = '' then return

if setinitdata = true then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/barlinemaxis_gen2.html'

if istr_cht4property1.ischtkind = 'a01' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/barlinemaxis_gen2.html'
if istr_cht4property1.ischtkind = 'a05' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/horizontal_gen2.html'

if istr_cht4property1.ischtkind = 'p12' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/pie_gen2.html'
if istr_cht4property1.ischtkind = 'p13' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/polar_gen2.html'
if istr_cht4property1.ischtkind = 'p14' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/radar_gen2.html'

if istr_cht4property1.ischtkind = 'y31' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/bubble_gen2.html'
if istr_cht4property1.ischtkind = 'y32' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/scatter_gen2.html'
if istr_cht4property1.ischtkind = 'y33'  then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/chtv294/html/bubbletimetable_gen2.html'

if istr_cht4property1.ischtkind = 'g01' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/c3v042/html/c3_gauge1.html'
if istr_cht4property1.ischtkind = 'g02' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/c3v042/html/c3_gauge2.html'
if istr_cht4property1.ischtkind = 'g03' then ishtmlurl = 'http://' + gnv_vari.setwassignupip + '/cht/c3v042/html/c3_powergauge7.html'

string	ls_htmlstatus, ls_getreadystate, ls_OldURL
long	ll_ret, ll_start

if ibclosing = true then return

ole_cht.object.navigate2(ishtmlurl)
ls_oldurl = ole_cht.object.locationurl
do while ls_oldurl = ole_cht.object.locationurl
	yield ()
loop
if ibclosing = true then return

if ole_cht.dynamic of_gethtmlstatus() = -1 then
	gw_mdi.setmicrohelp('chart timeout')
end if
inv_v3cview.of_setcht_dcht(ole_cht, as_values)

//ls_OldURL = ole_cht.object.LocationURL
//Do While ls_OldURL = ole_cht.object.LocationURL
//	yield ()
//Loop
//long		ll_ret
//ll_ret = DeleteURLCacheEntry(ishtmlurl)
//ole_cht.object.document.execCommand("ClearAuthenticationCache")
end subroutine

public function string of_thisname ();return 'fw_u_v3cview'
end function

public subroutine of_runhtml ();ilprevdata = illivedata
if fw_f_nvls(ishtmlvalue, '') = 'empty' then return
if fw_f_nvls(ishtmlvalue_sub, '') = 'empty' then return
choose case isruntype
	case '01' //first call
		of_setcharthtml(ishtmlvalue)
		ole_cht.show()
		st_top.show()
		st_bottom.show()
		st_left.show()
		isruntype = '02'
	case '02'
		inv_v3cview.of_setcht_u(ole_cht, ishtmlvalue)		
	case '03' //append call
		choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
			case 41
				inv_v3cview.of_sety_append(ole_cht, ishtmlvalue_sub)
			case else
				if istr_cht4property1.ibxaxis = true then
					inv_v3cview.of_setx_append(ole_cht, ishtmlvalue_sub)
				else
					inv_v3cview.of_sety_append(ole_cht, ishtmlvalue_sub)
				end if
		end choose
	case '04' //delete call
		choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
			case 41
				inv_v3cview.of_sety_delete(ole_cht, ishtmlvalue_sub)
			case else
				if istr_cht4property1.ibxaxis = true then
					inv_v3cview.of_setx_delete(ole_cht, ishtmlvalue_sub)
				else
					inv_v3cview.of_sety_delete(ole_cht, ishtmlvalue_sub)
				end if
		end choose
end choose



//// Wait for Document to finish loading
//Do While ole_cht.Object.Busy
//	yield()
//Loop

//choose case isruntype
//	case '01', '02'
//		// Wait for Document to get ready
//		Do Until this.of_getreadystate() = "complete"
//			yield()
//		Loop
//end choose

end subroutine

public subroutine of_setinitialhtml ();ole_cht.hide()
ole_cht.object.navigate2("about:blank")
Do While ole_cht.Object.LocationURL <> "about:blank"
	yield()
Loop
Do While ole_cht.Object.Busy
	yield()
Loop


end subroutine

public subroutine of_setinitialvariables ();/* Private */
ishtmlvalue			= ''
ishtmlvalue_sub		= ''
ishtmlurl			= ''

/* Protected */
istimeractive_yn		= 'N'
isobj2event			= ''

isruntype			= '01'
/* parsetoarray */ 
is_obj				= ''
is_obj_chk			= ''
is_objlist[]			= is_null[]
is_header_nm[]		= is_null[]
is_uniontemp[]		= is_null[]
il_uniontempcnt		= 0
il_objcnt			= 0
ib_chtyn			= false

/* business  */
illivedata[]			= ilnullarr[]
ilprevdata[]			= ilnullarr[]
ilintervalrow[]		= ilintervalrow_empty[]
ilselectcnt			= 0
isasissyntax			= ''

//Protected:
il_row				= 0
istr_cht4property1.isdatasets			= ''
istr_cht4property1.isuserdatasets		= '' // 사용자 datasets
isgetchtdata		= ''

long	ll_ret
dw_cht.settransobject( sqlca )
ll_ret = dw_cht.retrieve(gnv_vari.is_sys_id, istr_cht4property1.pgm_no, istr_cht4property1.pgm_id, istr_cht4property1.cht_id)
if ll_ret < 1 then
	istr_cht4property1 = fw_f_cht4defaultvariable(istr_cht4property1, dw_cht)
else
	of_getdbproperty()
end if
end subroutine

public subroutine of_setdatalimited (long al_limited);inv_v3cview.of_setdatalimited(al_limited)

string		ls_title
ls_title = st_chartnm.text
If setinitdata = true then
	of_default4cht('01')
else
	of_setinitialhtml()
	of_setchton_step1(idw_cht, {string1te, string2te}, ls_title, il_row)
end if
end subroutine

public function integer of_setchton_step1_2sub (datawindow adw_data, string as_actionnm[]);is_obj_chk = idw_cht.describe("Datawindow.Objects")
if is_obj <> is_obj_chk then
	is_obj = is_obj_chk
	if setinitdata = true then of_default4cht('02')
	return 1
end if

isobj2event = as_actionnm[1]
if inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind) = 41 and isobj2event = 'buttonup' then
	return 1
else
	if not(inv_v3cview.node4cview2bizA02(209, gnv_vari.is_node4cview2key, isobj2event, inv_v3cview.isrtn4cht) = 1) then return -1
	if inv_v3cview.node4cview2bizA02(210, gnv_vari.is_node4cview2key, as_actionnm[2], inv_v3cview.isrtn4cht) = 1 then
		if setinitdata = true then of_default4cht_delete()
		return 1
	else
		if setinitdata = true then return -1
	end if
end if

return 1
end function

public subroutine of_default4cht (datawindow adw_data);of_setinitialvariables()

idw_cht = adw_data
is_obj = idw_cht.describe("Datawindow.Objects")
il_objcnt = fw_f_obj2array(is_obj, '~t', is_objlist[])

inv_v3cview.node4cview2bizA02(213, gnv_vari.is_node4cview2key, 'Window', inv_v3cview.isrtn4cht)
isasissyntax	= idw_cht.describe(inv_v3cview.isrtn4cht)
if pos(isasissyntax, 'cht_yn') > 0 then
	ib_chtyn = true
	long	ll_i, ll_rowcnt
	ll_rowcnt = adw_data.rowcount()
	if ll_rowcnt > 0 then
		for ll_i = 1 to ll_rowcnt
			adw_data.setitem(ll_i, 'cht_yn', 'N')
		next
	end if
end if
yield ( )
of_setchton_step1_1sub(idw_cht, 0)
If upperbound(is_selectobj) > 0 then
	of_default4cht('01', is_selectobj)
else
	of_default4cht('01')
end if
end subroutine

public subroutine of_default4cht (string as_runtype);if not isvalid(idw_cht) then
	Messagebox('check', 'Reference DataWindow가 미 지정되었습니다.')
	return
end if
string	ls_htitle[], ls_uniondata[], ls_uniontemp[], ls_col_header1[], ls_temp[]
long	ll_temp

of_setoption4fcht()
choose case as_runtype
	case '01'
		of_setinitialhtml()
		if istr_cht4property1.ibxaxis = true then
			inv_v3cview.of_x_setbuild4data('header_nm', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_x_setbuild4data('cv2_sample', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			// json 생성 및 property 적용
			il_titlenum = upperbound(ls_htitle)
			of_setminmax_step1('01', ls_temp[])
			ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, {'Default chart', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, 'Legend', ls_uniondata)
		else
			inv_v3cview.of_y_setbuild4data('header_nm', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_y_setbuild4data('cv2_sample', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			// json 생성 및 property 적용
			il_titlenum = upperbound(ls_htitle)
			of_setminmax_step1('01', ls_temp[])
			ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, {'Default', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
		end if
	case '02'
		isruntype = as_runtype
		if istr_cht4property1.ibxaxis = true then
			inv_v3cview.of_x_setbuild4data('header_nm', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_x_setbuild4data('cv2_sample', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, {'Default chart', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, 'Legend', ls_uniondata)
		else
			inv_v3cview.of_y_setbuild4data('header_nm', '', idw_cht, 0, ls_uniondata, ls_htitle, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_y_setbuild4data('cv2_sample', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, {'Default', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
		end if
	case '03'
		isruntype = as_runtype
		if istr_cht4property1.ibxaxis = true then
			inv_v3cview.of_x_setbuild4data('cv2_sample', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, {'Default chart', 'Default Value'}, istr_cht4property1.isdatasets, 'Legend', ls_uniondata)
		else
			inv_v3cview.of_y_setbuild4data('cv2_sample', '', idw_cht, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, {'Default', 'Default Value'}, istr_cht4property1.isdatasets, ls_uniondata)
		end if
end choose

choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
	case 21
		setinitdata = false
	case else
		setinitdata = true
end choose

of_runhtml()
end subroutine

public subroutine of_default4cht_delete ();if setinitdata = true then
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 41
			inv_v3cview.of_sety_delete(ole_cht, '0')
		case else
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_setx_delete(ole_cht, '0')
			else
				inv_v3cview.of_sety_delete(ole_cht, '0')
			end if
	end choose
end if
end subroutine

public function string of_getcallbackdata ();isgetchtdata = ''
inv_v3cview.of_getcht_data(ole_cht, isgetchtdata)

return isgetchtdata
end function

public function string of_getreadystate ();long	ll_ii
// "loading", "interactive", "complete"
If isnull(ole_cht.object.document) then 
	return 'loading'
else
	For ll_ii = 1 to 100
		yield() // Some processing
	next
	return string(ole_cht.object.document.readyState)
end if
end function

public subroutine of_setoption4fcht ();this.event oue_datasets()
this.event oue_datasets4user()
//x축 고정 db값과 상관없이 진행시에만 사용
choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
	case 21  // gauge
		if istr_cht4property1.ibxaxis = false then istr_cht4property1.ibxaxis = true
	case 41
		if istr_cht4property1.ibxaxis = true then istr_cht4property1.ibxaxis = false
end choose

inv_v3cview.of_setproperty4fcht(istr_cht4property1)
end subroutine

public subroutine of_setaccept4cht ();string	ls_title
of_setinitialhtml()
isruntype = '01'
ls_title = st_chartnm.text	

If IsValid(idw_cht) then	
	If upperbound(is_selectobj) > 0 then
		of_setchton_step1(idw_cht, {string1te, string2te}, ls_title, is_selectobj, il_row)
	else
		of_setchton_step1(idw_cht, {string1te, string2te}, ls_title, il_row)
	end if
end if
end subroutine

public function integer of_setexception4cht ();return 1
end function

public subroutine of_setchton_step2 (datawindow adw_obj, datawindow adw_title, long al_row, boolean ab_rowtof);string	ls_uniondata[], ls_uniontemp[], ls_col_header1[], ls_nullobj[]
string	ls_datagb
long	ll_chkcnt[]
long	ll_i, ll_temp, ll_rtn, ll_rowcnt, ll_asrowcnt, ll_modidata

adw_obj.accepttext()
adw_title.accepttext()
if inv_v3cview.of_rtntaskcheck1st(il_objcnt) = -1 then return
if al_row = 0 then isruntype = '01'

choose case isruntype
	case '01'
		of_setinitialhtml()
	case else
		inv_v3cview.of_setruntype(isruntype, ll_modidata, al_row, ilprevdata, illivedata, isinterval_yn)
		choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
			case 21, 51
				isruntype = '02'
		end choose
		if ab_rowtof = false then isruntype = '02'
end choose

if ib_chtyn = true and  ab_rowtof = true then	
	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data('header_nm', adw_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	else
		inv_v3cview.of_y_setbuild4data('header_nm', adw_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	end if
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'sumvalue'
		case else
			ls_datagb = 'chtvalue0'
	end choose
	choose case isruntype
		case '01', '02'
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				for ll_i = 1 to ilselectcnt
					inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if
				next
				ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)
			else
				inv_v3cview.of_y_setbuild4data('col_header2', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				for ll_i = 1 to ilselectcnt
					inv_v3cview.of_y_setbuild4data('col_header2', adw_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if					
				next
				ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata) 
			end if
			
		case '03'
			ls_uniondata = ls_nullobj
			ls_uniontemp = ls_nullobj
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, ll_modidata, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, ll_modidata, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				
				ishtmlvalue_sub = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, isruntype, ls_uniondata)
			else
				inv_v3cview.of_y_setbuild4data('col_header2', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('col_header2', adw_title, adw_obj, ll_modidata, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, ll_modidata, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				
				ishtmlvalue_sub = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, ls_uniondata)
			end if
			
		case '04'
			ishtmlvalue_sub = string(ll_modidata)			
	end choose
else
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'col_header2'
		case else
			ls_datagb = 'col_header1'
	end choose
	
	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data(ls_datagb, adw_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', adw_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, al_row, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)	
	else
		inv_v3cview.of_y_setbuild4data(ls_datagb, adw_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', adw_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, al_row, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)	
	end if
end if

of_runhtml()
end subroutine

public subroutine of_setchton_step2 (datawindow adw_obj, string as_title, long al_row, boolean ab_rowtof);string	ls_uniondata[], ls_uniontemp[], ls_col_header1[], ls_nullobj[]
string	ls_datagb
long	ll_chkcnt[]
long	ll_i, ll_temp, ll_rtn, ll_rowcnt, ll_asrowcnt, ll_modidata

adw_obj.accepttext()

if inv_v3cview.of_rtntaskcheck1st(il_objcnt) = -1 then return
if al_row = 0 then isruntype = '01'

choose case isruntype
	case '01'
		of_setinitialhtml()
	case else
		inv_v3cview.of_setruntype(isruntype, ll_modidata, al_row, ilprevdata, illivedata, isinterval_yn)
		choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
			case 21, 51
				isruntype = '02'
		end choose
		if ab_rowtof = false then isruntype = '02'
end choose

if ib_chtyn = true and ab_rowtof = true then
	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data('header_nm', as_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	else
		inv_v3cview.of_y_setbuild4data('header_nm', as_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	end if
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'sumvalue'
		case else
			ls_datagb = 'chtvalue0'
	end choose
	
	choose case isruntype
		case '01', '02'
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				for ll_i = 1 to ilselectcnt
					inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if
				next
				ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)
			else
				inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				for ll_i = 1 to ilselectcnt
					inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if
					
				next
				ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
			end if
		case '03'
			ls_uniondata = ls_nullobj
			ls_uniontemp = ls_nullobj
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, ll_modidata, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', as_title, adw_obj, ll_modidata, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				ishtmlvalue_sub = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, isruntype, ls_uniondata)
			else
				inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, ll_modidata, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', as_title, adw_obj, ll_modidata, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				ishtmlvalue_sub = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, ls_uniondata)
			end if
		case '04'
			ishtmlvalue_sub = string(ll_modidata)
	end choose
else
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'col_header2'
		case else
			ls_datagb = 'col_header1'
	end choose
	
	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data(ls_datagb, as_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', as_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', as_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', as_title, adw_obj, al_row, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)
	else
		inv_v3cview.of_y_setbuild4data(ls_datagb, as_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', as_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', as_title, adw_obj, al_row, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', as_title, adw_obj, al_row, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
	end if	
end if

of_runhtml()
end subroutine

public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], datawindow adw_title, long al_row);string	ls_empty[]
long	ll_rtn

il_row = al_row
if upperbound(as_actionnm) < 3 then
	messagebox('check', 'array value is not sufficient.')
	return
end if
istimeractive_yn = as_actionnm[3]
choose case ib_chtyn
	case true
		if as_actionnm[1] = 'clicked' then return
		ll_rtn = of_setchton_step1_2sub(adw_data, as_actionnm)
		if ll_rtn = -1 then return
		ll_rtn = inv_v3cview.of_setseqcreate(this, adw_data, ls_empty, istimeractive_yn, al_row, ilselectcnt, illivedata, ilintervalrow, ilnullarr, ilmaxcount)
		if ll_rtn = -1 then return
end choose
if setinitdata = true then setinitdata = false
st_chartnm.text = adw_title.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
of_setchton_step2(idw_cht, adw_title, al_row, true)
yield ( )
end subroutine

public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], string as_title, long al_row);string	ls_empty[]
long	ll_rtn

il_row = al_row
if upperbound(as_actionnm) < 3 then
	messagebox('check', 'array value is not sufficient.')
	return
end if
istimeractive_yn = as_actionnm[3]
choose case ib_chtyn
	case true
		if as_actionnm[1] = 'clicked' then return
		ll_rtn = of_setchton_step1_2sub(adw_data, as_actionnm)
		if ll_rtn = -1 then return
		ll_rtn = inv_v3cview.of_setseqcreate(this, adw_data, ls_empty, istimeractive_yn, al_row, ilselectcnt, illivedata, ilintervalrow, ilnullarr, ilmaxcount)
		if ll_rtn = -1 then return
end choose
if setinitdata = true then setinitdata = false
st_chartnm.text = as_title
of_setchton_step2(idw_cht, as_title, al_row, true)
yield ( )
end subroutine

public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], string as_title, string as_selectobj[], long al_row);long	ll_rtn

il_row = al_row
if upperbound(as_actionnm) < 3 then
	messagebox('check', 'array value is not sufficient.')
	return
end if
istimeractive_yn = as_actionnm[3]
choose case ib_chtyn
	case true
		if as_actionnm[1] = 'clicked' then return
		ll_rtn = of_setchton_step1_2sub(adw_data, as_actionnm)
		if ll_rtn = -1 then return
		ll_rtn = inv_v3cview.of_setseqcreate(this, adw_data, as_selectobj, istimeractive_yn, al_row, ilselectcnt, illivedata, ilintervalrow, ilnullarr, ilmaxcount)
		if ll_rtn = -1 then return
end choose
if setinitdata = true then setinitdata = false
st_chartnm.text = as_title
of_setchton_step2(idw_cht, as_title, as_selectobj, al_row, true)
yield ( )

end subroutine

public subroutine of_setchton_step1 (datawindow adw_data, string as_actionnm[], datawindow adw_title, string as_selectobj[], long al_row);long	ll_rtn

il_row = al_row
if upperbound(as_actionnm) < 3 then
	messagebox('check', 'array value is not sufficient.')
	return
end if
istimeractive_yn = as_actionnm[3]
choose case ib_chtyn
	case true
		if as_actionnm[1] = 'clicked' then return
		ll_rtn = of_setchton_step1_2sub(adw_data, as_actionnm)
		if ll_rtn = -1 then return
		ll_rtn = inv_v3cview.of_setseqcreate(this, adw_data, as_selectobj, istimeractive_yn, al_row, ilselectcnt, illivedata, ilintervalrow, ilnullarr, ilmaxcount)
		if ll_rtn = -1 then return
end choose
if setinitdata = true then setinitdata = false
st_chartnm.text = adw_title.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
of_setchton_step2(idw_cht, adw_title, as_selectobj, al_row, true)
yield ( )
end subroutine

public subroutine of_setchton_step2 (datawindow adw_obj, datawindow adw_title, string as_selectobj[], long al_row, boolean ab_rowtof);string	ls_uniondata[], ls_uniontemp[], ls_col_header1[], ls_nullobj[]
string	ls_datagb
long	ll_chkcnt[]
long	ll_i, ll_temp, ll_rtn, ll_rowcnt, ll_asrowcnt, ll_modidata

adw_obj.acceptText()
adw_title.acceptText()

if inv_v3cview.of_rtntaskcheck1st(il_objcnt) = -1 then return
if al_row = 0 then isruntype = '01'

choose case isruntype
	case '01'
		of_setinitialhtml()
	case else
		inv_v3cview.of_setruntype(isruntype, ll_modidata, al_row, ilprevdata, illivedata, isinterval_yn)
		choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
			case 21, 51
				isruntype = '02'
		end choose
		if ab_rowtof = false then isruntype = '02'
end choose

if ib_chtyn = true and  ab_rowtof = true then
	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data('header_nm', adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	else
		inv_v3cview.of_y_setbuild4data('header_nm', adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	end if
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'sumvalue'
		case else
			ls_datagb = 'chtvalue0'
	end choose
	choose case isruntype
		case '01', '02'
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				For ll_i = 1 To ilselectcnt
					inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if
					
				next
				ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)
			else
				inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, 0, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				For ll_i = 1 To ilselectcnt
					inv_v3cview.of_y_setbuild4data('col_header2', adw_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, adw_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if
					
				next
				ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
			end if
		case '03'
			ls_uniondata = ls_nullobj
			ls_col_header1 = ls_nullobj
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('col_header2', adw_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				
				ishtmlvalue_sub = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, isruntype, ls_uniondata)
			else
				inv_v3cview.of_y_setbuild4data('col_header2', adw_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('col_header2', adw_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)

				ishtmlvalue_sub = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, ls_uniondata)
			end if
		case '04'
			ishtmlvalue_sub = string(ll_modidata)			
	end choose
else
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'col_header2'
		case else
			ls_datagb = 'col_header1'
	end choose

	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data(ls_datagb, adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', adw_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)	
	else
		inv_v3cview.of_y_setbuild4data(ls_datagb, adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', adw_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', adw_title, adw_obj, al_row, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)	
	end if
end if
is_selectobj = as_selectobj

of_runhtml()
end subroutine

public subroutine of_setchton_step2 (datawindow adw_obj, string as_title, string as_selectobj[], long al_row, boolean ab_rowtof);string	ls_uniondata[], ls_uniontemp[], ls_col_header1[], ls_nullobj[]
string	ls_datagb
long	ll_chkcnt[]
long	ll_i, ll_temp, ll_rtn, ll_rowcnt, ll_asrowcnt, ll_modidata

adw_obj.acceptText()

if inv_v3cview.of_rtntaskcheck1st(il_objcnt) = -1 then return
if al_row = 0 then isruntype = '01'

choose case isruntype
	case '01'
		of_setinitialhtml()
	case else
		inv_v3cview.of_setruntype(isruntype, ll_modidata, al_row, ilprevdata, illivedata, isinterval_yn)
		choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
			case 21, 51
				isruntype = '02'
		end choose
		if ab_rowtof = false then isruntype = '02'
end choose

if ib_chtyn = true and ab_rowtof = true then
	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data('header_nm', as_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	else
		inv_v3cview.of_y_setbuild4data('header_nm', as_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
	end if
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'sumvalue'
		case else
			ls_datagb = 'chtvalue0'
	end choose
	choose case isruntype
		case '01', '02'
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				for ll_i = 1 To ilselectcnt
					inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_x_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if					
				next
				ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)
			else
				inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				for ll_i = 1 To ilselectcnt
					inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					if ls_datagb = 'sumvalue' then
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					else
						inv_v3cview.of_y_setbuild4data('cv2_' + ls_datagb, as_title, adw_obj, illivedata[ll_i], as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
					end if
					
				next
				ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
			end if
		case '03'
			ls_uniondata = ls_nullobj
			ls_uniontemp = ls_nullobj
			if istr_cht4property1.ibxaxis = true then
				inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('col_header2', as_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', as_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				ishtmlvalue_sub = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, isruntype, ls_uniondata)
			else
				inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('col_header2', as_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', as_title, adw_obj, ll_modidata, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				ishtmlvalue_sub = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, ls_uniondata)
			end if
		case '04'
			ishtmlvalue_sub = string(ll_modidata)
	end choose
else
	choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
		case 21, 51
			ls_datagb = 'col_header2'
		case else
			ls_datagb = 'col_header1'
	end choose
	if istr_cht4property1.ibxaxis = true then
		inv_v3cview.of_x_setbuild4data(ls_datagb, as_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', as_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('header_nm', as_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', as_title, adw_obj, al_row, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, isruntype, ls_uniondata)
	else
		inv_v3cview.of_y_setbuild4data(ls_datagb, as_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', as_title, adw_obj, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('header_nm', as_title, adw_obj, al_row, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', as_title, adw_obj, al_row, as_selectobj, ls_uniondata, is_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
		
		ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, ls_col_header1, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
	end if	
end if
is_selectobj = as_selectobj

of_runhtml()
end subroutine

public subroutine of_default4cht (datawindow adw_data, string as_selectobj[]);of_setinitialvariables()

idw_cht = adw_data
is_obj = idw_cht.describe("Datawindow.Objects")
il_objcnt = fw_f_obj2array(is_obj, '~t', is_objlist[])

inv_v3cview.node4cview2bizA02(213, gnv_vari.is_node4cview2key, 'Window', inv_v3cview.isrtn4cht)
isasissyntax	= idw_cht.describe(inv_v3cview.isrtn4cht)
if pos(isasissyntax, 'cht_yn') > 0 then
	ib_chtyn = true
	long	ll_i, ll_rowcnt
	ll_rowcnt = adw_data.rowcount()
	if ll_rowcnt > 0 then
		for ll_i = 1 to ll_rowcnt
			adw_data.setitem(ll_i, 'cht_yn', 'N')
		next
	end if
end if
yield ( )
of_setchton_step1_1sub(idw_cht, 0)
of_default4cht('01', as_selectobj)
end subroutine

public subroutine of_default4cht (string as_runtype, string as_selectobj[]);if not isvalid(idw_cht) then
	Messagebox('check', 'Reference DataWindow가 미 지정되었습니다.')
	return
end if
string	ls_htitle[], ls_uniondata[], ls_uniontemp[], ls_col_header1[], ls_temp[]
long	ll_temp

of_setoption4fcht()
choose case as_runtype
	case '01'
		of_setinitialhtml()
		if istr_cht4property1.ibxaxis = true then
			inv_v3cview.of_x_setbuild4data('header_nm', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_x_setbuild4data('cv2_sample', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			// json 생성 및 property 적용
			il_titlenum = upperbound(ls_htitle)
			of_setminmax_step1('02', as_selectobj)
			ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, {'Default Chart', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, 'Legend', ls_uniondata)
		else
			inv_v3cview.of_y_setbuild4data('header_nm', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_y_setbuild4data('cv2_sample', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			// json 생성 및 property 적용
			il_titlenum = upperbound(ls_htitle)
			of_setminmax_step1('02', as_selectobj)
			ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, {'Default', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
		end if
	case '02'
		isruntype = as_runtype
		if istr_cht4property1.ibxaxis = true then
			inv_v3cview.of_x_setbuild4data('header_nm', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_x_setbuild4data('cv2_sample', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, {'Default Chart', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, 'Legend', ls_uniondata)
		else
			inv_v3cview.of_y_setbuild4data('header_nm', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			inv_v3cview.of_y_setbuild4data('cv2_sample', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, {'Default', 'Default Value'}, istr_cht4property1.isdatasets, is_header_nm, ls_uniondata)
		end if
	case '03'
		isruntype = as_runtype
		if istr_cht4property1.ibxaxis = true then
			inv_v3cview.of_x_setbuild4data('cv2_sample', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_x_setbuild4rvalue(istimeractive_yn, {'Default Chart', 'Default Value'}, istr_cht4property1.isdatasets, 'Legend', ls_uniondata)
		else
			inv_v3cview.of_y_setbuild4data('cv2_sample', '', idw_cht, 0, as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
			ishtmlvalue = inv_v3cview.of_y_setbuild4rvalue(istimeractive_yn, {'Default', 'Default Value'}, istr_cht4property1.isdatasets, ls_uniondata)
		end if
end choose

choose case inv_v3cview.of_rtnchtclassify1(istr_cht4property1.ischtkind)
	case 21
		setinitdata = false
	case else
		setinitdata = true
end choose
is_selectobj = as_selectobj

of_runhtml()
end subroutine

public subroutine of_sethide4cht ();ole_cht.hide()
of_setinitialvariables()
end subroutine

public function integer of_setchton_step1_1sub (datawindow adw_data, long al_row);if of_setexception4cht() = -1 then return -1
string	ls_null[]
ole_cht.enabled = true
inv_v3cview.node4cview2bizA02(213, gnv_vari.is_node4cview2key, 'Window', inv_v3cview.isrtn4cht)
if fw_f_nvls(isasissyntax, '') = '' then isasissyntax = adw_data.describe(inv_v3cview.isrtn4cht)

inv_v3cview.of_setinitializationapi()
inv_v3cview.node4cview2bizH01(121, handle(this), gnv_vari.is_node4cview2key, inv_v3cview.istr_node4value)
end function

public subroutine of_setagain4html ();yield( )
p_refresh.Post Event Clicked()

end subroutine

public function string of_getobj2event ();return isobj2event
end function

public subroutine of_getdbproperty ();istr_cht4property1.ischtkind = dw_cht.getitemstring(1, 'chtkind')
//istr_cht4property1.usercht4obj = dw_cht.getitemstring(1, 'usercht4obj')
//istr_cht4property1.isdatasets = dw_cht.getitemstring(1, 'isdatasets')
//istr_cht4property1.isuserdatasets = dw_cht.getitemstring(1, 'isuserdatasets')

if dw_cht.getitemstring(1, 'ibxaxis') = 'Y' then
	istr_cht4property1.ibxaxis = true
else
	istr_cht4property1.ibxaxis = false
end if
if dw_cht.getitemstring(1, 'ibcommoncolor') = 'Y' then
	istr_cht4property1.ibcommoncolor = true
else
	istr_cht4property1.ibcommoncolor = false
end if
if dw_cht.getitemstring(1, 'ibchar4datasetgb') = 'Y' then
	istr_cht4property1.ibchar4datasetgb = true
else
	istr_cht4property1.ibchar4datasetgb = false
end if
if dw_cht.getitemstring(1, 'ibdefaultdata100') = 'Y' then
	istr_cht4property1.ibdefaultdata100 = true
else
	istr_cht4property1.ibdefaultdata100 = false
end if

if dw_cht.getitemstring(1, 'ibpns2dls2display') = 'Y' then
	istr_cht4property1.ibpns2dls2display = true
else
	istr_cht4property1.ibpns2dls2display = false
end if
istr_cht4property1.ispns2dls2bordercolor = dw_cht.getitemstring(1, 'ispns2dls2bordercolor')
istr_cht4property1.ispns2dls2backgroundcolor = dw_cht.getitemstring(1, 'ispns2dls2backgroundcolor')
istr_cht4property1.ispns2dls2color = dw_cht.getitemstring(1, 'ispns2dls2color')
istr_cht4property1.ispns2dls2colorh = dw_cht.getitemstring(1, 'ispns2dls2colorh')
istr_cht4property1.ispns2dls2formatterlabelgb = dw_cht.getitemstring(1, 'ispns2dls2formatterlabelgb')
istr_cht4property1.ispns2dls2formatterlabelvalgb = dw_cht.getitemstring(1, 'ispns2dls2formatterlabelvalgb')

istr_cht4property1.isdefaultfontstyle = dw_cht.getitemstring(1, 'isdefaultfontstyle')
istr_cht4property1.ildefaultfontsize = dw_cht.getitemnumber(1, 'ildefaultfontsize')
istr_cht4property1.isdefaultfontfamily = dw_cht.getitemstring(1, 'isdefaultfontfamily')
istr_cht4property1.isdefaultfontcolor = dw_cht.getitemstring(1, 'isdefaultfontcolor')

if dw_cht.getitemstring(1, 'iblegenddisplay') = 'Y' then
	istr_cht4property1.iblegenddisplay = true
else
	istr_cht4property1.iblegenddisplay = false
end if
istr_cht4property1.islegendposition = dw_cht.getitemstring(1, 'islegendposition')

if dw_cht.getitemstring(1, 'iblinefillgb') = 'Y' then
	istr_cht4property1.iblinefillgb = true
else
	istr_cht4property1.iblinefillgb = false
end if

if dw_cht.getitemstring(1, 'ibthousandcomma') = 'Y' then
	istr_cht4property1.ibthousandcomma = true
else
	istr_cht4property1.ibthousandcomma = false
end if

if dw_cht.getitemstring(1, 'ibtooltipsgb') = 'Y' then
	istr_cht4property1.ibtooltipsgb = true
else
	istr_cht4property1.ibtooltipsgb = false
end if

if dw_cht.getitemstring(1, 'ibtooltipsrangegb') = 'Y' then
	istr_cht4property1.ibtooltipsrangegb = true
else
	istr_cht4property1.ibtooltipsrangegb = false
end if

istr_cht4property1.ilborderwidth = dw_cht.getitemnumber(1, 'ilborderwidth')

if dw_cht.getitemstring(1, 'ibhoverBorder') = 'Y' then
	istr_cht4property1.ibhoverBorder = true
else
	istr_cht4property1.ibhoverBorder = false
end if
istr_cht4property1.ilhoverborderwidth = dw_cht.getitemnumber(1, 'ilhoverborderwidth')
istr_cht4property1.ishoverbordercolor = dw_cht.getitemstring(1, 'ishoverbordercolor')

istr_cht4property1.iswaringstep = dw_cht.getitemstring(1, 'iswaringstep')

istr_cht4property1.iimultiplication = dw_cht.getitemnumber(1, 'iimultiplication')
istr_cht4property1.iidivision = dw_cht.getitemnumber(1, 'iidivision')
istr_cht4property1.iiround = dw_cht.getitemnumber(1, 'iiround')

if dw_cht.getitemstring(1, 'iblinebargb') = 'Y' then
	istr_cht4property1.iblinebargb = true
else
	istr_cht4property1.iblinebargb = false
end if
istr_cht4property1.illinebarcnt = dw_cht.getitemnumber(1, 'illinebarcnt')
istr_cht4property1.illiney1axiscnt = dw_cht.getitemnumber(1, 'illiney1axiscnt')

if dw_cht.getitemstring(1, 'ibxaxes0display') = 'Y' then
	istr_cht4property1.ibxaxes0display = true
else
	istr_cht4property1.ibxaxes0display = false
end if
if dw_cht.getitemstring(1, 'ibyaxes0display') = 'Y' then
	istr_cht4property1.ibyaxes0display = true
else
	istr_cht4property1.ibyaxes0display = false
end if
if dw_cht.getitemstring(1, 'ibyaxes1display') = 'Y' then
	istr_cht4property1.ibyaxes1display = true
else
	istr_cht4property1.ibyaxes1display = false
end if

if dw_cht.getitemstring(1, 'ibxaxes0gridlinedisplay') = 'Y' then
	istr_cht4property1.ibxaxes0gridlinedisplay = true
else
	istr_cht4property1.ibxaxes0gridlinedisplay = false
end if
if dw_cht.getitemstring(1, 'ibyaxes0gridlinedisplay') = 'Y' then
	istr_cht4property1.ibyaxes0gridlinedisplay = true
else
	istr_cht4property1.ibyaxes0gridlinedisplay = false
end if
if dw_cht.getitemstring(1, 'ibyaxes1gridlinedisplay') = 'Y' then
	istr_cht4property1.ibyaxes1gridlinedisplay = true
else
	istr_cht4property1.ibyaxes1gridlinedisplay = false
end if

if dw_cht.getitemstring(1, 'ibxaxes0gridlinecolor') = 'Y' then
	istr_cht4property1.ibxaxes0gridlinecolor = true
else
	istr_cht4property1.ibxaxes0gridlinecolor = false
end if
if dw_cht.getitemstring(1, 'ibyaxes0gridlinecolor') = 'Y' then
	istr_cht4property1.ibyaxes0gridlinecolor = true
else
	istr_cht4property1.ibyaxes0gridlinecolor = false
end if
if dw_cht.getitemstring(1, 'ibyaxes1gridlinecolor') = 'Y' then
	istr_cht4property1.ibyaxes1gridlinecolor = true
else
	istr_cht4property1.ibyaxes1gridlinecolor = false
end if

if dw_cht.getitemstring(1, 'iblinetension') = 'Y' then
	istr_cht4property1.iblinetension = true
else
	istr_cht4property1.iblinetension = false
end if

if dw_cht.getitemstring(1, 'ibminmax2fixcolor') = 'Y' then
	istr_cht4property1.ibminmax2fixcolor = true
else
	istr_cht4property1.ibminmax2fixcolor = false
end if

if dw_cht.getitemstring(1, 'iblinepoint') = 'Y' then
	istr_cht4property1.iblinepoint = true
else
	istr_cht4property1.iblinepoint = false
end if
istr_cht4property1.illinepointradius = dw_cht.getitemnumber(1, 'illinepointradius')
istr_cht4property1.illinepointhoverradius = dw_cht.getitemnumber(1, 'illinepointhoverradius')

if dw_cht.getitemstring(1, 'ibintervalsect') = 'Y' then
	istr_cht4property1.ibintervalsect = true
else
	istr_cht4property1.ibintervalsect = false
end if
istr_cht4property1.ilintervalrange = dw_cht.getitemnumber(1, 'ilintervalrange')

if dw_cht.getitemstring(1, 'ibbeginatzeroleft') = 'Y' then
	istr_cht4property1.ibbeginatzeroleft = true
else
	istr_cht4property1.ibbeginatzeroleft = false
end if
if dw_cht.getitemstring(1, 'ibbeginatzeroright') = 'Y' then
	istr_cht4property1.ibbeginatzeroright = true
else
	istr_cht4property1.ibbeginatzeroright = false
end if

istr_cht4property1.isxaxeslabelstring = dw_cht.getitemstring(1, 'isxaxeslabelstring')
istr_cht4property1.isyaxeslabelstring1 = dw_cht.getitemstring(1, 'isyaxeslabelstring1')
istr_cht4property1.isyaxeslabelstring2 = dw_cht.getitemstring(1, 'isyaxeslabelstring2')
istr_cht4property1.isyaxeslabelstring1b = dw_cht.getitemstring(1, 'isyaxeslabelstring1b')
istr_cht4property1.isyaxeslabelstring2b = dw_cht.getitemstring(1, 'isyaxeslabelstring2b')

if not(istr_cht4property1.isyaxeslabelstring1b = 'empty') then
	st_isyaxeslabelstring1b.text = istr_cht4property1.isyaxeslabelstring1b
end if
if not(istr_cht4property1.isyaxeslabelstring2b = 'empty') then
	st_isyaxeslabelstring2b.text = istr_cht4property1.isyaxeslabelstring2b
end if
if not(istr_cht4property1.isyaxeslabelstring1b = 'empty') or not(istr_cht4property1.isyaxeslabelstring2b = 'empty') then	
	st_isyaxeslabelstring1b.visible = true
	st_isyaxeslabelstring2b.visible = true
else
	st_isyaxeslabelstring1b.visible = false
	st_isyaxeslabelstring2b.visible = false
end if
this.event resize(0, this.width, this.height)

if dw_cht.getitemstring(1, 'iblinestacked') = 'Y' then
	istr_cht4property1.iblinestacked = true
else
	istr_cht4property1.iblinestacked = false
end if
if dw_cht.getitemstring(1, 'iblinelogarithmic') = 'Y' then
	istr_cht4property1.iblinelogarithmic = true
else
	istr_cht4property1.iblinelogarithmic = false
end if
if dw_cht.getitemstring(1, 'iblinestepped') = 'Y' then
	istr_cht4property1.iblinestepped = true
else
	istr_cht4property1.iblinestepped = false
end if

if dw_cht.getitemstring(1, 'ibnulldatagb') = 'Y' then
	istr_cht4property1.ibnulldatagb = true
else
	istr_cht4property1.ibnulldatagb = false
end if
if dw_cht.getitemstring(1, 'ibbtnvisible4cht') = 'Y' then
	istr_cht4property1.ibbtnvisible4cht = true
else
	istr_cht4property1.ibbtnvisible4cht = false
end if

if dw_cht.getitemstring(1, 'iblinealtercolor2all') = 'Y' then
	istr_cht4property1.iblinealtercolor2all = true
else
	istr_cht4property1.iblinealtercolor2all = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk2all') = 'Y' then
	istr_cht4property1.iblinealterfillbk2all = true
else
	istr_cht4property1.iblinealterfillbk2all = false
end if
istr_cht4property1.islinealterbkcolor2all = dw_cht.getitemstring(1, 'islinealterbkcolor2all')
istr_cht4property1.islinealterbdcolor2all = dw_cht.getitemstring(1, 'islinealterbdcolor2all')

if dw_cht.getitemstring(1, 'iblinealter1st') = 'Y' then
	istr_cht4property1.iblinealter1st = true
else
	istr_cht4property1.iblinealter1st = false
end if
istr_cht4property1.illinealter1st_row = dw_cht.getitemnumber(1, 'illinealter1st_row')
if dw_cht.getitemstring(1, 'iblinealterfill1st') = 'Y' then
	istr_cht4property1.iblinealterfill1st = true
else
	istr_cht4property1.iblinealterfill1st = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk1st') = 'Y' then
	istr_cht4property1.iblinealterfillbk1st = true
else
	istr_cht4property1.iblinealterfillbk1st = false
end if
istr_cht4property1.islinealterbkcolor1st = dw_cht.getitemstring(1, 'islinealterbkcolor1st')
istr_cht4property1.islinealterbdcolor1st = dw_cht.getitemstring(1, 'islinealterbdcolor1st')

if dw_cht.getitemstring(1, 'iblinealter2nd') = 'Y' then
	istr_cht4property1.iblinealter2nd = true
else
	istr_cht4property1.iblinealter2nd = false
end if
istr_cht4property1.illinealter2nd_row = dw_cht.getitemnumber(1, 'illinealter2nd_row')
if dw_cht.getitemstring(1, 'iblinealterfill2nd') = 'Y' then
	istr_cht4property1.iblinealterfill2nd = true
else
	istr_cht4property1.iblinealterfill2nd = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk2nd') = 'Y' then
	istr_cht4property1.iblinealterfillbk2nd = true
else
	istr_cht4property1.iblinealterfillbk2nd = false
end if
istr_cht4property1.islinealterbkcolor2nd = dw_cht.getitemstring(1, 'islinealterbkcolor2nd')
istr_cht4property1.islinealterbdcolor2nd = dw_cht.getitemstring(1, 'islinealterbdcolor2nd')

if dw_cht.getitemstring(1, 'iblinealter3rd') = 'Y' then
	istr_cht4property1.iblinealter3rd = true
else
	istr_cht4property1.iblinealter3rd = false
end if
istr_cht4property1.illinealter3rd_row = dw_cht.getitemnumber(1, 'illinealter3rd_row')
if dw_cht.getitemstring(1, 'iblinealterfill3rd') = 'Y' then
	istr_cht4property1.iblinealterfill3rd = true
else
	istr_cht4property1.iblinealterfill3rd = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk3rd') = 'Y' then
	istr_cht4property1.iblinealterfillbk3rd = true
else
	istr_cht4property1.iblinealterfillbk3rd = false
end if
istr_cht4property1.islinealterbkcolor3rd = dw_cht.getitemstring(1, 'islinealterbkcolor3rd')
istr_cht4property1.islinealterbdcolor3rd = dw_cht.getitemstring(1, 'islinealterbdcolor3rd')

if dw_cht.getitemstring(1, 'iblinealter4th') = 'Y' then
	istr_cht4property1.iblinealter4th = true
else
	istr_cht4property1.iblinealter4th = false
end if
istr_cht4property1.illinealter4th_row = dw_cht.getitemnumber(1, 'illinealter4th_row')
if dw_cht.getitemstring(1, 'iblinealterfill4th') = 'Y' then
	istr_cht4property1.iblinealterfill4th = true
else
	istr_cht4property1.iblinealterfill4th = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk4th') = 'Y' then
	istr_cht4property1.iblinealterfillbk4th = true
else
	istr_cht4property1.iblinealterfillbk4th = false
end if
istr_cht4property1.islinealterbkcolor4th = dw_cht.getitemstring(1, 'islinealterbkcolor4th')
istr_cht4property1.islinealterbdcolor4th = dw_cht.getitemstring(1, 'islinealterbdcolor4th')

istr_cht4property1.ilpiecutoutpercentage = dw_cht.getitemnumber(1, 'ilpiecutoutpercentage')

if dw_cht.getitemstring(1, 'ibyaxes4l_q') = 'Y' then
	istr_cht4property1.ibyaxes4l_q = true
else
	istr_cht4property1.ibyaxes4l_q = false
end if
if dw_cht.getitemstring(1, 'ibyaxes4l') = 'Y' then
	istr_cht4property1.ibyaxes4l = true
else
	istr_cht4property1.ibyaxes4l = false
end if
istr_cht4property1.min4left = dw_cht.getitemnumber(1, 'min4left')
istr_cht4property1.max4left = dw_cht.getitemnumber(1, 'max4left')
istr_cht4property1.ticksstepsize4l = dw_cht.getitemnumber(1, 'ticksstepsize4l')
if dw_cht.getitemstring(1, 'ibyaxes4r_q') = 'Y' then
	istr_cht4property1.ibyaxes4r_q = true
else
	istr_cht4property1.ibyaxes4r_q = false
end if
if dw_cht.getitemstring(1, 'ibyaxes4r') = 'Y' then
	istr_cht4property1.ibyaxes4r = true
else
	istr_cht4property1.ibyaxes4r = false
end if
istr_cht4property1.min4right = dw_cht.getitemnumber(1, 'min4right')
istr_cht4property1.max4right = dw_cht.getitemnumber(1, 'max4right')
istr_cht4property1.ticksstepsize4r = dw_cht.getitemnumber(1, 'ticksstepsize4r')
end subroutine

public function boolean of_geterrorissue ();return ole_cht.iberrorissue
end function

public function decimal of_setminmax_multiple (decimal adc_num, decimal adc_multiple);adc_multiple = round(adc_multiple, istr_cht4property1.iiround)

if istr_cht4property1.iiround > 2 then
	adc_num = round(adc_num * adc_multiple, 2)
else
	adc_num = round(adc_num * adc_multiple, 0)
end if

return adc_num




//choose case adc_num
//	case is < 0
//		adc_num = 0
//	case is < 100
//		adc_num = round(adc_num * adc_multiple * 0.1, 0) * 10
//	case is < 1000
//		adc_num = round(adc_num * adc_multiple * 0.01, 1) * 100
//	case is < 10000
//		adc_num = round(adc_num * adc_multiple * 0.001, 1) *  1000
//	case is < 100000
//		adc_num = round(adc_num * adc_multiple * 0.0001, 1) * 10000
//	case is < 1000000
//		adc_num = round(adc_num * adc_multiple * 0.00001, 1) * 100000
//	case is < 10000000
//		adc_num = round(adc_num * adc_multiple * 0.000001, 1) * 1000000
//	case is < 100000000
//		adc_num = round(adc_num * adc_multiple * 0.0000001, 1) * 10000000
//	case else
//		adc_num = round(adc_num * adc_multiple * 0.00000001, 1) * 100000000
//end choose
end function

public subroutine of_setminmax_step1 (string as_gb, string as_selectobj[]);if	istr_cht4property1.ischtkind = 'a01' and &
	(istr_cht4property1.ibyaxes4l = true and istr_cht4property1.ibyaxes4l_q = true) or &
	(istr_cht4property1.ibyaxes4r = true and istr_cht4property1.ibyaxes4r_q = true) then
	string	ls_uniondata[], ls_uniontemp[], ls_col_header1[]
	long	ll_i, ll_rcnt, ll_temp
	
	ll_rcnt = idw_cht.rowcount()
	if ll_rcnt < 1 then return
	
	choose case as_gb
		case '01'
			for ll_i = 1 To ll_rcnt	
				illivedata[ll_i] = ll_i
				if istr_cht4property1.ibxaxis = true then			
					inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', '', idw_cht, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				else
					inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', '', idw_cht, illivedata[ll_i], ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				end if
			next
		case '02'
			for ll_i = 1 To ll_rcnt	
				illivedata[ll_i] = ll_i
				if istr_cht4property1.ibxaxis = true then			
					inv_v3cview.of_x_setbuild4data('cv2_chtvalue0', '', idw_cht, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				else
					inv_v3cview.of_y_setbuild4data('cv2_chtvalue0', '', idw_cht, illivedata[ll_i], as_selectobj, ls_uniondata, ls_uniontemp, il_uniontempcnt, is_objlist, il_objcnt, ls_col_header1, is_header_nm)
				end if
			next
	end choose
	if istr_cht4property1.ibyaxes4l_q = true or istr_cht4property1.ibyaxes4r_q = true then
		of_setminmax_step2(ls_uniondata)
	end if
	illivedata[] = ilnullarr[]
	isinterval_yn = 'Y'
end if

end subroutine

public subroutine of_setminmax_step2 (string as_data[]);string	ls_data[]
long	ll_rcnt, ll_i, ll_j, ll_jcnt, ll_z = 0
dec{4}	ldc_data_left[], ldc_data_right[]
dec{4}	ldc_min_left = 99999999999, ldc_max_left = -99999999999
dec{4}	ldc_min_right = 99999999999, ldc_max_right = -99999999999
dec{4}	ldc_ticksstepsize4r = 0, ldc_ticksstepsize4l = 0

ll_rcnt = upperbound(as_data[])
if istr_cht4property1.ibyaxes4l_q = true then
	ll_z = 0
	for ll_i = 1 to ll_rcnt
		ll_jcnt = fw_f_obj2array(as_data[ll_i], "===", ls_data[])
		if istr_cht4property1.illiney1axiscnt < ll_jcnt then ll_jcnt = istr_cht4property1.illiney1axiscnt
		for ll_j = 1 to ll_jcnt
			ll_z++
			ldc_data_left[ll_z] = dec(ls_data[ll_j])
		next
	next
end if

if istr_cht4property1.ibyaxes4r_q = true then
	ll_z = 0
	for ll_i = 1 to ll_rcnt
		ll_jcnt = fw_f_obj2array(as_data[ll_i], "===", ls_data[])
		for ll_j = istr_cht4property1.illiney1axiscnt + 1 to ll_jcnt
			ll_z++
			ldc_data_right[ll_z] = dec(ls_data[ll_j])
		next
	next
end if

if istr_cht4property1.ibyaxes4l_q = true then
	ll_rcnt = upperbound(ldc_data_left[])
	for ll_i = 1 to ll_rcnt
		if ldc_max_left < ldc_data_left[ll_i] then
			ldc_max_left = ldc_data_left[ll_i]
		end if
		if ldc_min_left > ldc_data_left[ll_i] then
			ldc_min_left = ldc_data_left[ll_i]
		end if
	next
	if fw_f_nvll(ldc_max_left, 0) = 0 then ldc_max_left = 0
	if fw_f_nvll(ldc_min_left, 0) = 0 then ldc_min_left = 0
	
	choose case ldc_min_left
		case is < 0
			//
		case else
			ldc_min_left = 0
	end choose
	
	ldc_max_left = of_setminmax_multiple(ldc_max_left, 1.3)
	ldc_ticksstepsize4l = truncate(ldc_max_left / 3, istr_cht4property1.iiround)
	ldc_ticksstepsize4l = of_setminmax_multiple(ldc_ticksstepsize4l, 1)
	
	istr_cht4property1.max4left_q = ldc_max_left
	istr_cht4property1.ticksstepsize4l_q = ldc_ticksstepsize4l
	
	istr_cht4property1.min4left_q = ldc_min_left
end if

if istr_cht4property1.ibyaxes4r_q = true then
	ll_rcnt = upperbound(ldc_data_right[])
	for ll_i = 1 to ll_rcnt
		if ldc_max_right < ldc_data_right[ll_i] then
			ldc_max_right = ldc_data_right[ll_i]
		end if
		if ldc_min_right > ldc_data_right[ll_i] then
			ldc_min_right = ldc_data_right[ll_i]
		end if
	next
	if fw_f_nvll(ldc_max_right, 0) = 0 then ldc_max_right = 0
	if fw_f_nvll(ldc_min_right, 0) = 0 then ldc_min_right = 0
	
	choose case ldc_min_right
		case is < 0
			//
		case else
			ldc_min_right = 0
	end choose
	ldc_max_right = of_setminmax_multiple(ldc_max_right, 1.3)
	ldc_ticksstepsize4r = truncate(ldc_max_right / 4, istr_cht4property1.iiround)
	ldc_ticksstepsize4r = of_setminmax_multiple(ldc_ticksstepsize4r, 1)
	
	istr_cht4property1.max4right_q = ldc_max_right
	istr_cht4property1.ticksstepsize4r_q = ldc_ticksstepsize4r
	
	istr_cht4property1.min4right_q = ldc_min_right
end if

inv_v3cview.of_setproperty4fcht(istr_cht4property1)

end subroutine

on fw_u_v3cview.create
int iCurrent
call super::create
this.st_isyaxeslabelstring1b=create st_isyaxeslabelstring1b
this.dw_cht=create dw_cht
this.p_chart=create p_chart
this.p_icontitile=create p_icontitile
this.ln_x1=create ln_x1
this.ln_y1=create ln_y1
this.ln_y2=create ln_y2
this.ln_x2=create ln_x2
this.ln_x3=create ln_x3
this.ln_x4=create ln_x4
this.ln_x5=create ln_x5
this.ln_y3=create ln_y3
this.ln_y4=create ln_y4
this.ln_y5=create ln_y5
this.ln_x6=create ln_x6
this.ln_y6=create ln_y6
this.ln_y7=create ln_y7
this.ln_x7=create ln_x7
this.ln_x8=create ln_x8
this.ln_y9=create ln_y9
this.p_refresh=create p_refresh
this.st_top=create st_top
this.st_chartnm=create st_chartnm
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.st_left=create st_left
this.st_bottom=create st_bottom
this.st_isyaxeslabelstring2b=create st_isyaxeslabelstring2b
this.ole_cht=create ole_cht
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_isyaxeslabelstring1b
this.Control[iCurrent+2]=this.dw_cht
this.Control[iCurrent+3]=this.p_chart
this.Control[iCurrent+4]=this.p_icontitile
this.Control[iCurrent+5]=this.ln_x1
this.Control[iCurrent+6]=this.ln_y1
this.Control[iCurrent+7]=this.ln_y2
this.Control[iCurrent+8]=this.ln_x2
this.Control[iCurrent+9]=this.ln_x3
this.Control[iCurrent+10]=this.ln_x4
this.Control[iCurrent+11]=this.ln_x5
this.Control[iCurrent+12]=this.ln_y3
this.Control[iCurrent+13]=this.ln_y4
this.Control[iCurrent+14]=this.ln_y5
this.Control[iCurrent+15]=this.ln_x6
this.Control[iCurrent+16]=this.ln_y6
this.Control[iCurrent+17]=this.ln_y7
this.Control[iCurrent+18]=this.ln_x7
this.Control[iCurrent+19]=this.ln_x8
this.Control[iCurrent+20]=this.ln_y9
this.Control[iCurrent+21]=this.p_refresh
this.Control[iCurrent+22]=this.st_top
this.Control[iCurrent+23]=this.st_chartnm
this.Control[iCurrent+24]=this.ln_1
this.Control[iCurrent+25]=this.ln_2
this.Control[iCurrent+26]=this.ln_3
this.Control[iCurrent+27]=this.st_left
this.Control[iCurrent+28]=this.st_bottom
this.Control[iCurrent+29]=this.st_isyaxeslabelstring2b
this.Control[iCurrent+30]=this.ole_cht
end on

on fw_u_v3cview.destroy
call super::destroy
destroy(this.st_isyaxeslabelstring1b)
destroy(this.dw_cht)
destroy(this.p_chart)
destroy(this.p_icontitile)
destroy(this.ln_x1)
destroy(this.ln_y1)
destroy(this.ln_y2)
destroy(this.ln_x2)
destroy(this.ln_x3)
destroy(this.ln_x4)
destroy(this.ln_x5)
destroy(this.ln_y3)
destroy(this.ln_y4)
destroy(this.ln_y5)
destroy(this.ln_x6)
destroy(this.ln_y6)
destroy(this.ln_y7)
destroy(this.ln_x7)
destroy(this.ln_x8)
destroy(this.ln_y9)
destroy(this.p_refresh)
destroy(this.st_top)
destroy(this.st_chartnm)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.st_left)
destroy(this.st_bottom)
destroy(this.st_isyaxeslabelstring2b)
destroy(this.ole_cht)
end on

event constructor;call super::constructor;inv_v3cview = create fw_n_v3cview
inv_v3cview.of_initialize()

istr_cht4property1.sys_id = gnv_vari.is_sys_id
istr_cht4property1.pgm_no = iw_parent.classname()
istr_cht4property1.pgm_id = iw_parent.classname()
istr_cht4property1.cht_id = this.classname()

ole_cht.enabled = false
il_oleorgheight = this.height

//string	ls_color[]
//long	ll_r, ll_g, ll_b, ll_objcnt
//ll_objcnt = fw_f_obj2array(is_objectbackcolor, ",", ls_color[])
//if ll_objcnt > 0 then
//	ll_r = long(ls_color[1])
//	ll_g = long(ls_color[2])
//	ll_b = long(ls_color[3])
//	
//	this.backcolor = long(rgb(ll_r, ll_g, ll_b))
//	st_chartnm.backcolor = long(rgb(ll_r, ll_g, ll_b))
//end if
//
//ll_objcnt = fw_f_obj2array(is_titletextcolor, ",", ls_color[])
//if ll_objcnt > 0 then
//	ll_r = long(ls_color[1])
//	ll_g = long(ls_color[2])
//	ll_b = long(ls_color[3])
//	st_chartnm.textcolor = long(rgb(ll_r, ll_g, ll_b))
//end if

of_setinitialvariables()


end event

event destructor;ibclosing = true
if isvalid(inv_v3cview) then destroy inv_v3cview
end event

event resize;if ibfullsize4pb = true then
	st_left.x				= 0
	st_left.y				= 0
	st_left.height		= newheight
	st_top.x				= 0
	st_top.y 			= st_left.y
	st_top.width			= newwidth + PixelsToUnits(2, XPixelsToUnits!)
	st_bottom.x			= st_left.x
	st_bottom.y			= newheight - st_bottom.height
	st_bottom.width		= newwidth
	ole_cht.x			= 0
	ole_cht.y			= 0
	ole_cht.width		= newwidth + PixelsToUnits(6, XPixelsToUnits!)
	ole_cht.height 		= newheight + PixelsToUnits(15, YPixelsToUnits!)
else
	st_chartnm.width = newwidth - p_chart.width - p_refresh.width - p_icontitile.width - PixelsToUnits(20, XPixelsToUnits!)
	st_left.x				= 0
	st_left.height		= newheight
	st_bottom.x			= st_left.x
	st_bottom.y			= newheight - st_bottom.height
	st_bottom.width		= newwidth
	p_refresh.x			= newwidth - p_refresh.width - PixelsToUnits(2, XPixelsToUnits!)
	p_chart.x			= p_refresh.x - p_chart.width - PixelsToUnits(2, XPixelsToUnits!)
	st_top.x				= st_left.x
	if st_isyaxeslabelstring1b.visible = true then
		st_top.y = st_isyaxeslabelstring1b.y + st_isyaxeslabelstring1b.height
	else
		st_top.y = p_chart.y + p_chart.height
	end if
	st_top.width			= newwidth + PixelsToUnits(2, XPixelsToUnits!)
	ole_cht.x			= st_left.x
	ole_cht.y			= st_top.y
	ole_cht.width		= newwidth
	ole_cht.height = st_bottom.y - st_top.y + PixelsToUnits(1, YPixelsToUnits!)
	
	st_isyaxeslabelstring2b.x = newwidth - st_isyaxeslabelstring2b.width - PixelsToUnits(1, XPixelsToUnits!)
end if

end event

event oue_postopen;call super::oue_postopen;st_chartnm.text = istitlenm

If fw_f_nvls(istr_cht4property1.ischtkind, '') = '' then
	Messagebox('확인', '초기 Chart type이 지정되지 않았습니다.')
	return
end if

If ibbtnvisible4pb = false then
	p_chart.visible =  false
	p_refresh.visible =  false
else
	p_chart.visible = true
	p_refresh.visible = true
end if

choose case ibtitlevisible4pb
	case true
		p_icontitile.show()
		st_chartnm.show()
	case false
		p_icontitile.hide()
		st_chartnm.hide()
end choose

choose case iblinevisible4pb
	case true
		st_bottom.backcolor = 0 //19737901 //33536371
		st_left.backcolor = 33225466 //19737901 //25198847
	case false
		st_bottom.backcolor = 33225466 //16777215
		st_left.backcolor = 33225466 //16777215
end choose

end event

type st_isyaxeslabelstring1b from pf_u_statictext within fw_u_v3cview
boolean visible = false
integer x = 9
integer y = 104
integer width = 507
integer height = 64
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 19737901
long backcolor = 33225466
boolean setsheetcolor = true
end type

type dw_cht from fw_u_dwo within fw_u_v3cview
boolean visible = false
integer x = 1362
integer width = 105
integer height = 88
integer taborder = 40
boolean bringtotop = true
string dataobject = "fw_d_cht4select_1"
end type

event updatestart;call super::updatestart;string	ls_cntr_sn
Long	ll_rcnt, ll_row
Long	ll_mstrow

dwitemstatus	 ldwstatus
do while ll_row <= ll_rcnt
	ll_row = this.getnextmodified(ll_row, Primary!)
	IF ll_row > 0 then
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)		
		choose case ldwstatus
			case NewModified!
				this.setitem(ll_row, 'use_yn', 'Y')				
				this.setitem(ll_row, 'reg_id', gnv_vari.is_user_id)
				this.setitem(ll_row, 'reg_dt', fw_f_getymdhh24miss4s())
				this.setitem(ll_row, 'upd_id', gnv_vari.is_user_id)
				this.setitem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
			case DataModified!
				this.setitem(ll_row, 'upd_id', gnv_vari.is_user_id)
				this.setitem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
		end choose
	else
		ll_row = ll_rcnt + 1        
	end if
Loop

end event

type p_chart from pf_u_imagebutton within fw_u_v3cview
integer x = 1477
integer width = 110
integer height = 96
integer taborder = 20
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\menu_graph.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;Openwithparm(fw_w_cht4select, istr_cht4property1)

istr_cht4property2 = message.powerobjectparm
if not isvalid(istr_cht4property2) then return
if fw_f_nvls(istr_cht4property2.ischtkind, '') <> '' then
	istr_cht4property1 = istr_cht4property2
	yield()
	if isvalid(idw_cht) then post of_default4cht(idw_cht)
end if
end event

type p_icontitile from picture within fw_u_v3cview
integer x = 14
integer y = 20
integer width = 14
integer height = 56
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_icon4comm\icon_breadcrumb6.jpg"
boolean focusrectangle = false
end type

type ln_x1 from line within fw_u_v3cview
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 2373
integer endx = 2373
integer endy = 5140
end type

type ln_y1 from line within fw_u_v3cview
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 1136
integer endx = 8896
integer endy = 1136
end type

type ln_y2 from line within fw_u_v3cview
boolean visible = false
long linecolor = 16711680
integer linethickness = 4
integer beginy = 1432
integer endx = 8873
integer endy = 1432
end type

type ln_x2 from line within fw_u_v3cview
boolean visible = false
long linecolor = 16711680
integer linethickness = 2
integer beginx = 3063
integer endx = 3063
integer endy = 5140
end type

type ln_x3 from line within fw_u_v3cview
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 3749
integer endx = 3749
integer endy = 5140
end type

type ln_x4 from line within fw_u_v3cview
boolean visible = false
long linecolor = 16711680
integer linethickness = 2
integer beginx = 4439
integer endx = 4439
integer endy = 5140
end type

type ln_x5 from line within fw_u_v3cview
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 5129
integer endx = 5129
integer endy = 5140
end type

type ln_y3 from line within fw_u_v3cview
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 1708
integer endx = 8873
integer endy = 1708
end type

type ln_y4 from line within fw_u_v3cview
boolean visible = false
long linecolor = 16711680
integer linethickness = 4
integer beginy = 1984
integer endx = 8873
integer endy = 1984
end type

type ln_y5 from line within fw_u_v3cview
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 2260
integer endx = 8873
integer endy = 2260
end type

type ln_x6 from line within fw_u_v3cview
boolean visible = false
long linecolor = 8421376
integer linethickness = 2
integer beginx = 5819
integer endx = 5819
integer endy = 5140
end type

type ln_y6 from line within fw_u_v3cview
boolean visible = false
long linecolor = 8421376
integer linethickness = 4
integer beginy = 2536
integer endx = 8873
integer endy = 2536
end type

type ln_y7 from line within fw_u_v3cview
boolean visible = false
long linecolor = 15780518
integer linethickness = 4
integer beginy = 2812
integer endx = 8873
integer endy = 2812
end type

type ln_x7 from line within fw_u_v3cview
boolean visible = false
long linecolor = 15780518
integer linethickness = 2
integer beginx = 6510
integer endx = 6510
integer endy = 5140
end type

type ln_x8 from line within fw_u_v3cview
boolean visible = false
long linecolor = 255
integer linethickness = 2
integer beginx = 7200
integer endx = 7200
integer endy = 5140
end type

type ln_y9 from line within fw_u_v3cview
boolean visible = false
long linecolor = 255
integer linethickness = 4
integer beginy = 3440
integer endx = 8873
integer endy = 3440
end type

type p_refresh from pf_u_imagebutton within fw_u_v3cview
integer x = 1595
integer width = 110
integer height = 96
integer taborder = 20
string picturename = "..\img\controls\u_icon4btn\iconbtn_reset2.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;yield()
If ole_cht.enabled = false then return
If IsValid(idw_cht) then of_default4cht(idw_cht)
end event

type st_top from pf_u_statictext within fw_u_v3cview
integer y = 96
integer width = 1751
integer height = 4
boolean bringtotop = true
long backcolor = 33225466
boolean scaletoright = true
end type

type st_chartnm from pf_u_statictext within fw_u_v3cview
integer x = 41
integer y = 8
integer width = 1024
integer height = 84
integer textsize = -11
fontcharset fontcharset = hangeul!
long textcolor = 19737901
long backcolor = 16777215
boolean enabled = false
end type

type ln_1 from line within fw_u_v3cview
boolean visible = false
long linecolor = 8421376
integer linethickness = 2
integer beginx = 7886
integer beginy = 16
integer endx = 7886
integer endy = 5156
end type

type ln_2 from line within fw_u_v3cview
boolean visible = false
long linecolor = 15780518
integer linethickness = 2
integer beginx = 8576
integer beginy = 16
integer endx = 8576
integer endy = 5156
end type

type ln_3 from line within fw_u_v3cview
boolean visible = false
long linecolor = 255
integer linethickness = 2
integer beginx = 9266
integer beginy = 16
integer endx = 9266
integer endy = 5156
end type

type st_left from pf_u_statictext within fw_u_v3cview
integer y = 100
integer width = 5
integer height = 680
boolean bringtotop = true
long textcolor = 134217752
long backcolor = 33225466
boolean scaletobottom = true
end type

type st_bottom from pf_u_statictext within fw_u_v3cview
integer y = 756
integer width = 1714
integer height = 4
boolean bringtotop = true
long backcolor = 0
boolean fixedtobottom = true
boolean scaletoright = true
end type

type st_isyaxeslabelstring2b from pf_u_statictext within fw_u_v3cview
boolean visible = false
integer x = 1198
integer y = 104
integer width = 507
integer height = 64
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 19737901
long backcolor = 33225466
alignment alignment = right!
boolean setsheetcolor = true
boolean fixedtoright = true
end type

type ole_cht from fw_u_cht4browser within fw_u_v3cview
integer y = 96
integer width = 1719
integer height = 676
integer taborder = 30
string binarykey = "fw_u_v3cview.udo"
end type

