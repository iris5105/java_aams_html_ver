forward
global type fw_n_v3cview from nonvisualobject
end type
end forward

global type fw_n_v3cview from nonvisualobject
end type
global fw_n_v3cview fw_n_v3cview

type prototypes
function Long node4cview2bizA01(uInt input1, String input2, Ref String output1) library "node4cview2.dll" Alias for "node4cview2bizA01;Ansi"
function Long node4cview2bizA02(uInt input1, String input2, String input3, Ref String output1) library "node4cview2.dll" Alias for "node4cview2bizA02;Ansi"
function Long node4cview2bizH01(uInt input1, ulong hWnd, String input2, Ref fw_s_node4value syntax) library "node4cview2.dll" Alias for "node4cview2bizH01;Ansi"

end prototypes

type variables
fw_s_cht4property		istr_cht4property
fw_s_node4value		istr_node4value
datastore				ids_objsort

string		ischar4datasetvalue	= ''
string		isrtn4cht		= ''
long		iirtn4cht		= 0
long		ilDataLimit		= 10000
long		ilcnt4data		= 0
end variables

forward prototypes
public function string of_thisname ()
public function integer of_rtntaskcheck1st (long al_cnt)
public function long of_rtnmaxarry (long al_val[])
public subroutine of_setdsinstance ()
public subroutine of_setcht_u (olecustomcontrol aole_webbrowser, string as_values)
public subroutine of_getcht_data (olecustomcontrol aole_webbrowser, ref string as_values)
public subroutine of_setdatalimited (long al_limited)
public subroutine of_setconstapi ()
public subroutine of_y_setbuild4data_1sub (string as_datagb, ref string as_uniontemp[], ref long al_cnt)
public subroutine of_x_setbuild4data_1sub (string as_datagb, ref string as_uniontemp[], ref long al_cnt)
public function integer of_getcnt4data ()
public subroutine of_sety_delete (olecustomcontrol aole_webbrowser, string as_values)
public subroutine of_setx_delete (olecustomcontrol aole_webbrowser, string as_values)
public subroutine of_setx_append (olecustomcontrol aole_webbrowser, string as_values)
public subroutine of_sety_append (olecustomcontrol aole_webbrowser, string as_values)
public subroutine of_initialize ()
public subroutine of_setcht_dcht (olecustomcontrol aole_webbrowser, string as_values)
public subroutine of_setchty_appendpointall (olecustomcontrol aole_webbrowser, string as_values)
public function string of_setexception4title (string as_title)
public subroutine of_xy_setbuild4data_3sub (string as_datagb, datawindow adw_data, string as_obj[], ref string as_uniontemp[], ref long al_j, long al_objcnt)
public subroutine of_xy_setbuild4data_3sub (string as_datagb, datawindow adw_data, string as_obj[], string as_selectobj[], ref string as_uniontemp[], ref long al_j, long al_objcnt)
public subroutine of_setinitializationapi ()
public function string of_dec4num (datawindow adw_data, string as_obj, long al_row)
public function string of_dec4num_1sub (decimal adc_data, long al_point)
public function integer of_rtnchtclassify2 ()
public subroutine of_setproperty4fcht (fw_s_cht4property astr_cht4property)
public subroutine of_setx_all_append (olecustomcontrol aole_webbrowser, string as_values)
public subroutine of_setx_all_delete (olecustomcontrol aole_webbrowser, string as_values)
public function integer of_rtnchtclassify1 (string as_chtkind)
public subroutine of_setruntype (ref string as_runtype, ref long al_modidata, long al_row, long al_prevdata[], long al_livedata[], string as_interval_yn)
public subroutine of_setintervalrange (datawindow adw_data, integer al_rcnt, ref long al_selectcnt, ref long al_livedata[], ref long al_ilintervalrow[])
public function integer of_setseqcreate (fw_u_v3cview auo_cht1, datawindow adw_data, string as_selectobj[], string as_actionnm, long al_row, ref long al_selectcnt, ref long al_livedata[], ref long al_ilintervalrow[], long al_nullarr[], long al_maxcount)
public subroutine of_y_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public subroutine of_y_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public subroutine of_y_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public subroutine of_y_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public subroutine of_x_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public subroutine of_x_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public subroutine of_x_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public subroutine of_x_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[])
public function string of_x_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_name[], string as_runtype, string as_uniondata[])
public function string of_x_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_runtype, string as_uniondata[])
public function string of_y_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_name[], string as_uniondata[])
public function string of_y_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_uniondata[])
public function string of_setconfiguration_step2 (ref fw_s_cht4property astr_cht4property)
public function string of_setconfiguration_step1 ()
end prototypes

public function string of_thisname ();return 'fw_u_v3cview'
end function

public function integer of_rtntaskcheck1st (long al_cnt);if al_cnt < 4 then return -1
end function

public function long of_rtnmaxarry (long al_val[]);long	ll_cnt, ll_i, ll_temp

ll_cnt = upperbound(al_val[])

ll_temp = 0

for ll_i = 1 To ll_cnt
	if ll_temp < al_val[ll_i] then
		ll_temp = al_val[ll_i]
	end if
next

return ll_temp
end function

public subroutine of_setdsinstance ();node4cview2bizA01(101, gnv_vari.is_node4cview2key, isrtn4cht)
ids_objsort = Create DataStore
ids_objsort.dataobject = isrtn4cht
end subroutine

public subroutine of_setcht_u (olecustomcontrol aole_webbrowser, string as_values);//as_values = Mid(as_values, 2)
if Pos(as_values, '?') > 0 then as_values = Mid(as_values, 2)
//::clipboard('of_setcht_u : ' + as_values)

aole_webbrowser.Object.Document.Parentwindow.updatecht(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public subroutine of_getcht_data (olecustomcontrol aole_webbrowser, ref string as_values);string ls_url
ls_url = fw_f_nvls(string(aole_webbrowser.object.LocationURL), '' )
if ls_url = '' or ls_url = 'about:blank' then return

as_values = ''
as_values = fw_f_nvls(string(aole_webbrowser.Object.Document.Parentwindow.getClickedData()), '')
end subroutine

public subroutine of_setdatalimited (long al_limited);ilDataLimit = al_limited
end subroutine

public subroutine of_setconstapi ();isrtn4cht = space(250000)

end subroutine

public subroutine of_y_setbuild4data_1sub (string as_datagb, ref string as_uniontemp[], ref long al_cnt);string	ls_obj[], ls_data[]
long	ll_uppercnt, ll_i

if not isvalid(ids_objsort) then
	of_setdsinstance()
else
	ids_objsort.reset()
end if

for ll_i = 1 To al_cnt
	ids_objsort.Insertrow(0)
	fw_f_obj2array(as_uniontemp[ll_i], '~t', ls_data[])	
	if ls_data[1] = 'nonchtyn_h1' then ls_data[1] = istr_node4value.cstr09
	ids_objsort.SetItem(ll_i, istr_node4value.cstr06, long(ls_data[1]))
	ids_objsort.SetItem(ll_i, istr_node4value.cstr07, ls_data[2])
next

ids_objsort.SetSort(istr_node4value.cstr08)
ids_objsort.Sort()

//if ilDataLimit < al_cnt then al_cnt = ilDataLimit
for ll_i = 1 To al_cnt
	ls_obj[ll_i] = ids_objsort.getitemstring(ll_i, istr_node4value.cstr11)
next
as_uniontemp = ls_obj
end subroutine

public subroutine of_x_setbuild4data_1sub (string as_datagb, ref string as_uniontemp[], ref long al_cnt);string	ls_obj[], ls_data[]
long	ll_uppercnt, ll_i

if not isvalid(ids_objsort) then
	of_setdsinstance()
else
	ids_objsort.reset()
end if
for ll_i = 1 To al_cnt
	ids_objsort.Insertrow(0)
	fw_f_obj2array(as_uniontemp[ll_i], '~t', ls_data[])	
	if ls_data[1] = 'nonchtyn_h1' then ls_data[1] = istr_node4value.cstr09
	ids_objsort.setitem(ll_i, istr_node4value.cstr06, long(ls_data[1]))
	ids_objsort.setitem(ll_i, istr_node4value.cstr07, ls_data[2])
next

ids_objsort.setsort(istr_node4value.cstr08)
ids_objsort.sort()

//if ilDataLimit < al_cnt then al_cnt = ilDataLimit
for ll_i = 1 To al_cnt
	ls_obj[ll_i] = ids_objsort.getitemstring(ll_i, istr_node4value.cstr11)
next
as_uniontemp = ls_obj
end subroutine

public function integer of_getcnt4data ();return ilcnt4data
end function

public subroutine of_sety_delete (olecustomcontrol aole_webbrowser, string as_values);//::clipboard('of_sety_delete : ' + as_values)

aole_webbrowser.Object.Document.Parentwindow.deletecht(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public subroutine of_setx_delete (olecustomcontrol aole_webbrowser, string as_values);//::clipboard('of_setx_delete : ' + as_values)

aole_webbrowser.Object.Document.Parentwindow.deletecolumn(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public subroutine of_setx_append (olecustomcontrol aole_webbrowser, string as_values);//as_values = Mid(as_values, 2)
if PosA(as_values, '?') > 0 then
	as_values = MidA(as_values, 2)
end if
//::clipboard('of_setx_append : ' + as_values)

aole_webbrowser.Object.Document.Parentwindow.setx_append(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public subroutine of_sety_append (olecustomcontrol aole_webbrowser, string as_values);//as_values = Mid(as_values, 2)
if PosA(as_values, '?') > 0 then
	as_values = MidA(as_values, 2)
end if
//::clipboard('of_sety_append : ' + as_values)

aole_webbrowser.Object.Document.Parentwindow.appendcht(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public subroutine of_initialize ();
end subroutine

public subroutine of_setcht_dcht (olecustomcontrol aole_webbrowser, string as_values);//as_values = Mid(as_values, 2)
if Pos(as_values, '?') > 0 then as_values = mid(as_values, 2)

//::Clipboard('of_setcht_dcht : ' + as_values)
aole_webbrowser.Object.Document.Parentwindow.startDrawChart(as_values)
end subroutine

public subroutine of_setchty_appendpointall (olecustomcontrol aole_webbrowser, string as_values);//as_values = Mid(as_values, 2)
if Pos(as_values, '?') > 0 then as_values = Mid(as_values, 2)
//::Clipboard('of_setcht_dcht : ' + as_values)
aole_webbrowser.Object.Document.Parentwindow.appendpointall(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public function string of_setexception4title (string as_title);if pos(as_title, '~r~n') > 0 then as_title = fw_f_replaceall( as_title, '~r~n', ' ')
if pos(as_title, '"') > 0 then as_title = fw_f_replaceall( as_title, '"', '')
if pos(as_title, '&') > 0 then as_title = fw_f_replaceall( as_title, '&', '*')

return as_title
end function

public subroutine of_xy_setbuild4data_3sub (string as_datagb, datawindow adw_data, string as_obj[], ref string as_uniontemp[], ref long al_j, long al_objcnt);String	ls_objtype, ls_band
long	ll_i

for ll_i = 1 to al_objcnt
	ls_objtype = adw_data.describe(as_obj[ll_i] + ".Type")
	ls_band = adw_data.describe(as_obj[ll_i] + ".Band")
	choose case as_datagb
		case 'col_header1'
			if NOT (ls_objtype = "column" or ls_objtype = "compute") then continue
			if ls_band = "?" or ls_band = "!" then continue // 화면에 위치 하지 않는 컨트롤 제외
			if as_obj[ll_i] = 'cv2_chtnm' then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
				exit
			end if
		case 'header_nm'
			if not (ls_objtype = "text") then continue
			if ls_band = "?" or ls_band = "!" then continue // 화면에 위치 하지 않는 컨트롤 제외				
			if Pos(as_obj[ll_i], istr_node4value.cstr05) > 0 then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
			end if
		case 'cv2_sample'
			as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		case 'cv2_chtvalue0'
			if NOT (ls_objtype = "column" or ls_objtype = "compute") then continue
			if ls_band = "?" or ls_band = "!" then continue // 화면에 위치 하지 않는 컨트롤 제외
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
			end if
		case 'cv2_sumvalue'
			if NOT (ls_objtype = "column" or ls_objtype = "compute") then continue
			if ls_band = "?" or ls_band = "!" then continue // 화면에 위치 하지 않는 컨트롤 제외
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
			end if
	end choose
next
end subroutine

public subroutine of_xy_setbuild4data_3sub (string as_datagb, datawindow adw_data, string as_obj[], string as_selectobj[], ref string as_uniontemp[], ref long al_j, long al_objcnt);String	ls_objtype, ls_band
string	ls_selectobj = '', ls_sym
long	ll_i, ll_a, ll_tmpcnt

ll_tmpcnt = upperbound(as_selectobj)
if as_datagb = 'header_nm' then
	ls_sym =  istr_node4value.cstr04
else
	ls_sym = '==='
end if
for ll_a = 1 to ll_tmpcnt
	ls_selectobj += as_selectobj[ll_a] + ls_sym
next
ls_sym = '==='
for ll_i = 1 to al_objcnt
	if fw_f_rtnbackgrobjchk(as_obj[ll_i]) = -1 then Continue
	ls_objtype	= adw_data.describe(as_obj[ll_i] + ".Type")
	ls_band		= adw_data.describe(as_obj[ll_i] + ".Band")
	choose case as_datagb
		case 'col_header1'
			if not (ls_objtype = "column" or ls_objtype = "compute") then Continue
			if ls_band = "?" or ls_band = "!" then Continue // 화면에 위치 하지 않는 컨트롤 제외
			if as_obj[ll_i] = 'cv2_chtnm' and Pos(ls_selectobj, as_obj[ll_i] + ls_sym) > 0 then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
			end if
		case 'header_nm'
			if not (ls_objtype = "text") then Continue
			if ls_band = "?" or ls_band = "!" then Continue // 화면에 위치 하지 않는 컨트롤 제외				
			if Pos(as_obj[ll_i], istr_node4value.cstr05) > 0 and Pos(ls_selectobj, as_obj[ll_i] + ls_sym) > 0 then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
			end if
		case 'cv2_sample'
			as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		case 'cv2_chtvalue0'
			if not (ls_objtype = "column" or ls_objtype = "compute") then Continue
			if ls_band = "?" or ls_band = "!" then Continue // 화면에 위치 하지 않는 컨트롤 제외
			if Pos(as_obj[ll_i], as_datagb) > 0 and Pos(ls_selectobj, as_obj[ll_i] + ls_sym) > 0 then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
			end if
		case 'cv2_sumvalue'
			if NOT (ls_objtype = "column" or ls_objtype = "compute") then Continue
			if ls_band = "?" or ls_band = "!" then Continue // 화면에 위치 하지 않는 컨트롤 제외
			if Pos(as_obj[ll_i], as_datagb) > 0 and Pos(ls_selectobj, as_obj[ll_i] + ls_sym) > 0 then
				al_j++
				as_uniontemp[al_j] = adw_data.describe(as_obj[ll_i] + ".x") + '~t' + as_obj[ll_i]
			end if
	end choose
next
end subroutine

public subroutine of_setinitializationapi ();isrtn4cht = space(250000)
istr_node4value.cstr01 = isrtn4cht
istr_node4value.cstr02 = isrtn4cht
istr_node4value.cstr03 = isrtn4cht
istr_node4value.cstr04 = isrtn4cht
istr_node4value.cstr05 = isrtn4cht
istr_node4value.cstr06 = isrtn4cht
istr_node4value.cstr07 = isrtn4cht
istr_node4value.cstr08 = isrtn4cht
istr_node4value.cstr09 = isrtn4cht
istr_node4value.cstr10 = isrtn4cht
istr_node4value.cstr11 = isrtn4cht
istr_node4value.cstr12 = isrtn4cht
istr_node4value.cstr13 = isrtn4cht
istr_node4value.cstr14 = isrtn4cht
istr_node4value.cstr15 = isrtn4cht
istr_node4value.cstr16 = isrtn4cht
istr_node4value.cstr17 = isrtn4cht
istr_node4value.cstr18 = isrtn4cht
istr_node4value.cstr19 = isrtn4cht
istr_node4value.cstr20 = isrtn4cht
istr_node4value.cstr21 = isrtn4cht
istr_node4value.cstr22 = isrtn4cht
istr_node4value.cstr23 = isrtn4cht
istr_node4value.cstr24 = isrtn4cht
istr_node4value.cstr25 = isrtn4cht
istr_node4value.cstr26 = isrtn4cht
istr_node4value.cstr27 = isrtn4cht
istr_node4value.cstr28 = isrtn4cht
istr_node4value.cstr29 = isrtn4cht
istr_node4value.cstr30 = isrtn4cht

iirtn4cht = 0
end subroutine

public function string of_dec4num (datawindow adw_data, string as_obj, long al_row);string	ls_data, ls_temp, ls_num_l, ls_num_r
long	ll_i, ll_num, ll_len
dec{6}	ldc_numpoint6
dec{5}	ldc_numpoint5
dec{4}	ldc_numpoint4
dec{3}	ldc_numpoint3
dec{2}	ldc_numpoint2
dec{1}	ldc_numpoint1
dec{0}	ldc_numpoint0

ldc_numpoint6 = fw_f_nvll(adw_data.getitemdecimal(al_row, as_obj), 0)
ls_temp = string(ldc_numpoint6)
if isnumber(ls_temp) = false then return '-1'
ls_num_l = left(ls_temp, pos(ls_temp, '.') - 1)
ls_num_r = mid(ls_temp, len(ls_num_l) + 2)
if fw_f_nvls(ls_num_r, '') = '' then ls_num_r = '000000'

choose case ls_num_r
	case '000000'
		ls_data = ls_num_l
		ldc_numpoint0 = dec(ls_data)
		ls_data = of_dec4num_1sub(ldc_numpoint0, 0)
	case else
		for ll_i = 6 to 1 step -1
			ll_num = long(mid(ls_num_r, ll_i, 1))
			if ll_num > 0 then
				ls_num_r = left(ls_num_r, ll_i)
				ll_len = ll_i
				exit
			end if
		next
		ls_data = ls_num_l + '.' + ls_num_r
		choose case ll_len
			case 6
				ldc_numpoint6 = dec(ls_data)
				ls_data = of_dec4num_1sub(ldc_numpoint6, 6)
			case 5
				ldc_numpoint5 = dec(ls_data)
				ls_data = of_dec4num_1sub(ldc_numpoint5, 5)
			case 4
				ldc_numpoint4 = dec(ls_data)
				ls_data = of_dec4num_1sub(ldc_numpoint4, 4)
			case 3
				ldc_numpoint3 = dec(ls_data)
				ls_data = of_dec4num_1sub(ldc_numpoint3, 3)
			case 2
				ldc_numpoint2 = dec(ls_data)
				ls_data = of_dec4num_1sub(ldc_numpoint2, 2)
			case 1
				ldc_numpoint1 = dec(ls_data)
				ls_data = of_dec4num_1sub(ldc_numpoint1, 1)
		end choose
end choose

return ls_data
end function

public function string of_dec4num_1sub (decimal adc_data, long al_point);string	ls_data

if istr_cht4property.ibnulldatagb = true then
	if fw_f_nvll(adc_data, 0) = 0 then
		ls_data = istr_node4value.cstr02
	else
		ls_data = string(adc_data)
	end if
else
	if fw_f_nvll(adc_data, 0) = 0 then
		ls_data = '0'
	else
		ls_data = string(adc_data)
	end if
end if

choose case ls_data
	case '0', istr_node4value.cstr02
		return ls_data
	case else
		adc_data = dec(ls_data)
		adc_data = adc_data * istr_cht4property.iimultiplication
		adc_data = adc_data / istr_cht4property.iidivision
		if al_point > istr_cht4property.iiround then
			adc_data = round( adc_data, istr_cht4property.iiround)
		end if
		ls_data = string(adc_data)
		return ls_data
end choose
end function

public function integer of_rtnchtclassify2 ();choose case istr_cht4property.ischtkind
	case 'y31', 'y33'// bubble
		return 41
	case 'y32' //scatter
		return 42
	case else
		return 0
end choose
end function

public subroutine of_setproperty4fcht (fw_s_cht4property astr_cht4property);istr_cht4property = astr_cht4property

//현재 chart.js 문제로 date및 기타 형식은 char로 표현
if istr_cht4property.ibchar4datasetgb = true then
	ischar4datasetvalue = '.'
else
	ischar4datasetvalue = ''
end if
end subroutine

public subroutine of_setx_all_append (olecustomcontrol aole_webbrowser, string as_values);//as_values = Mid(as_values, 2)
if PosA(as_values, '?') > 0 then
	as_values = MidA(as_values, 2)
end if
//::clipboard('of_setx_append : ' + as_values)

aole_webbrowser.Object.Document.Parentwindow.setx_all_append(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public subroutine of_setx_all_delete (olecustomcontrol aole_webbrowser, string as_values);//::clipboard('of_setx_delete : ' + as_values)

aole_webbrowser.Object.Document.Parentwindow.setx_all_delete(as_values)
//// Wait for Document to finish loading
//Do While aole_webbrowser.Object.Busy
//	Yield()
//Loop
end subroutine

public function integer of_rtnchtclassify1 (string as_chtkind);choose case as_chtkind
	case 'a01' // bar line
		return 1
	case 'a05' // horizontal  등 (x y축 겸용) chart
		return 2
	case 'g01', 'g02', 'g03' // gauge 차트 :  초기값 true와 무조건 x 좌표로만 진행		
		return 21
	case 'p12', 'p13', 'p14' //pie polar radar
		return 31
	case 'y31', 'y32', 'y33'// bubble scatter
		return 41
	case else
		return 99
end choose
end function

public subroutine of_setruntype (ref string as_runtype, ref long al_modidata, long al_row, long al_prevdata[], long al_livedata[], string as_interval_yn);long	ll_i, ll_prevcnt, ll_nowcnt

if as_runtype <> '01' then
	ll_prevcnt	= upperbound(al_prevdata)
	ll_nowcnt	= upperbound(al_livedata)
	choose case ll_prevcnt
		case is < ll_nowcnt
			as_runtype = '03'
			al_modidata = fw_f_nvll(al_livedata[ll_nowcnt], 0)
			
		case is > ll_nowcnt
//			if as_interval_yn = 'Y' then
//				al_prevdata = al_livedata
//				ll_prevcnt = upperbound(al_prevdata)
//				as_runtype = '02'
//			else			
//				as_runtype = '04'
//			end if
			as_runtype = '04'
			for ll_i = 1 to ll_prevcnt
				if al_prevdata[ll_i] = al_row then
					al_modidata = ll_i - 1
					exit
				end if
			next
		case ll_nowcnt
			as_runtype = '02'
	end choose
end if
end subroutine

public subroutine of_setintervalrange (datawindow adw_data, integer al_rcnt, ref long al_selectcnt, ref long al_livedata[], ref long al_ilintervalrow[]);long	ll_i, ll_j = 0, ll_intervalcnt
long	ll_temp[]

ll_intervalcnt = upperbound(al_ilintervalrow)
for ll_i = 1 to ll_intervalcnt
	if ll_i = 1 then
		adw_data.setitem(al_ilintervalrow[ll_i], 'cht_yn', 'N')
	else
		ll_j++
		ll_temp[ll_j] = al_ilintervalrow[ll_i]
	end if
next
al_selectcnt = ll_j
al_ilintervalrow = ll_temp
al_livedata = ll_temp


//if al_rcnt > istr_cht4property.ilintervalrange then
//	ll_intervalcnt = al_rcnt - istr_cht4property.ilintervalrange
//	al_rcnt = al_rcnt - ll_intervalcnt
//	for ll_i = 1 To al_rcnt
//		ll_temp2[ll_i] = al_livedata[ll_i + ll_intervalcnt]
//		if ll_i <= ll_intervalcnt then
//			adw_data.setitem(al_livedata[ll_i], 'cht_yn', 'N')
//		end if
//	next
//	al_selectcnt = al_rcnt
//	al_livedata = ll_temp2
//end if
end subroutine

public function integer of_setseqcreate (fw_u_v3cview auo_cht1, datawindow adw_data, string as_selectobj[], string as_actionnm, long al_row, ref long al_selectcnt, ref long al_livedata[], ref long al_ilintervalrow[], long al_nullarr[], long al_maxcount);string	ls_value, ls_check
long	ll_i, ll_j = 0, ll_rcnt, ll_objcnt, ll_intervalcnt
long	ll_temp1[]

ll_rcnt = adw_data.rowcount()

al_selectcnt = adw_data.find("cht_yn='Y'", 1, ll_rcnt)
if al_selectcnt = 0 then
	al_livedata = al_nullarr
	al_ilintervalrow = al_nullarr
	if auo_cht1.of_getobj2event() = 'buttonup' and of_rtnchtclassify1(istr_cht4property.ischtkind) = 41 then return -1
	if upperbound(as_selectobj) > 0 then
		auo_cht1.of_default4cht('02', as_selectobj)
	else
		auo_cht1.of_default4cht('02')
	end if	
	return -1
end if

ls_value = fw_f_nvls(adw_data.getitemstring(al_row, istr_node4value.cstr10), '')
if ls_value = 'Y' then
	if upperbound(al_ilintervalrow) = 0 then
		al_ilintervalrow[1] = al_row
	else
		if al_ilintervalrow[upperbound(al_ilintervalrow)] <> al_row then
			al_ilintervalrow[upperbound(al_ilintervalrow) + 1] = al_row
		end if
	end if
end if

//al_selectcnt = 0
//for ll_i = 1 To ll_rcnt
//	ls_value = fw_f_nvls(adw_data.getitemstring(ll_i, istr_node4value.cstr10), '')
//	if ls_value = 'Y' then
//		al_selectcnt++
//		if al_row = 0 then al_livedata[al_selectcnt] = ll_i
//	end if
//next

if al_row = 0 then
	al_selectcnt = 0
	for ll_i = 1 To ll_rcnt
		ls_value = fw_f_nvls(adw_data.getitemstring(ll_i, istr_node4value.cstr10), '')
		if ls_value = 'Y' then
			al_selectcnt++
			al_livedata[al_selectcnt] = ll_i
		end if
	next
else
	ls_check = 'N'
	ll_objcnt = upperbound(al_livedata)
	ls_value = fw_f_nvls(adw_data.getitemstring(al_row, istr_node4value.cstr10), '')
	if ls_value = 'Y' then
		if as_actionnm = 'Y' then
			al_selectcnt = upperbound(al_livedata) + 1
			al_livedata[al_selectcnt] = al_row
		else
			for ll_i = 1 To ll_objcnt
				if al_livedata[ll_i] = al_row then
					al_selectcnt = upperbound(al_livedata)
					ls_check = 'Y'
					exit
				end if
			next
			if ls_check = 'N' then
				al_selectcnt = upperbound(al_livedata) + 1
				al_livedata[al_selectcnt] = al_row
			end if
		end if
	else
		al_selectcnt = upperbound(al_livedata) - 1
		for ll_i = 1 To al_selectcnt + 1
			if ll_i = al_selectcnt + 1 then
				al_livedata[ll_i] = 0
			else
				if fw_f_nvll(al_livedata[ll_i], 0) = al_row or ls_check = 'Y' then
					al_livedata[ll_i] = al_livedata[ll_i + 1]
					ls_check = 'Y'
				end if
			end if
		next
	end if
	ll_objcnt = upperbound(al_livedata)
	for ll_i = 1 To ll_objcnt
		if al_livedata[ll_i] > 0 then ll_temp1[ll_i] = al_livedata[ll_i]
	next
	al_livedata = ll_temp1
	
	if istr_cht4property.ibintervalsect = true and al_selectcnt > istr_cht4property.ilintervalrange then
		ll_objcnt = upperbound(al_livedata)
		of_setintervalrange(adw_data, ll_objcnt, al_selectcnt, al_livedata, al_ilintervalrow)
	end if
end if

return 1
end function

public subroutine of_y_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);string	ls_objtype, ls_band
string	ls_rdatayn
string	ls_uniontemp_loc[]
long	ll_i, ll_j, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_col_header1, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_col_header1[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_col_header1[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_i] = of_setexception4title(as_col_header1[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_header_nm, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt			
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			string	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_y_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose

end subroutine

public subroutine of_y_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);String	ls_objtype, ls_band
string	ls_rdatayn
string	ls_uniontemp_loc[]
long	ll_i, ll_j, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_col_header1, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_col_header1[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_col_header1[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_i] = of_setexception4title(as_uniontemp[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_header_nm, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			string	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_y_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose

end subroutine

public subroutine of_y_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);string	ls_objtype, ls_band
string	ls_rdatayn
string	ls_uniontemp_loc[]
long	ll_i, ll_j, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + as_title
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_col_header1, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_col_header1[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_col_header1[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_i] = of_setexception4title(as_col_header1[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = as_title
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_header_nm, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next		
	case 'cv2_sample'
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To ll_j
			if istr_cht4property.ibdefaultdata100 = true then
				as_uniontemp[ll_i] = '100'
			else
				as_uniontemp[ll_i] = '0'
			end if
			if istr_cht4property.ibnulldatagb = true then 
				if fw_f_nvls(as_uniontemp[ll_i], '0') = '0' then as_uniontemp[ll_i] = istr_node4value.cstr02
			else
				if fw_f_nvls(as_uniontemp[ll_i], '') = '' then as_uniontemp[ll_i] = '0'
			end if
			if ll_i = ll_j then
				as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
			else
				as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
			end if
		next
		
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			String	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_y_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose

end subroutine

public subroutine of_y_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], string as_uniontemp[], long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);string	ls_objtype, ls_band
string	ls_rdatayn
string	ls_uniontemp_loc[]
long	ll_i, ll_j, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + as_title
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_col_header1, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_uniontemp[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_uniontemp[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_uniontemp[ll_i] = of_setexception4title(as_uniontemp[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = as_title
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_header_nm, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next
		
	case 'cv2_sample'
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_uniontemp, ll_j, al_objcnt)
		of_y_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To ll_j
			if istr_cht4property.ibdefaultdata100 = true then
				as_uniontemp[ll_i] = '100'
			else
				as_uniontemp[ll_i] = '0'
			end if
			if istr_cht4property.ibnulldatagb = true then 
				if fw_f_nvls(as_uniontemp[ll_i], '0') = '0' then as_uniontemp[ll_i] = istr_node4value.cstr02
			else
				if fw_f_nvls(as_uniontemp[ll_i], '') = '' then as_uniontemp[ll_i] = '0'
			end if
			if ll_i = ll_j then
				as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
			else
				as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
			end if
		next
		
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			string	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_y_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose

end subroutine

public subroutine of_x_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);string	ls_rdatayn, ls_uniontemp_loc[]
long	ll_i, ll_j, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_col_header1, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_col_header1[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_col_header1[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_i] = of_setexception4title(as_col_header1[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_header_nm, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)		
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				choose case of_rtnchtclassify2()
					case 41
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case 42
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case else
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
				end choose
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			string	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_x_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					choose case of_rtnchtclassify2()
						case 41
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case 42
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case else
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
					end choose
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose

end subroutine

public subroutine of_x_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);string	ls_rdatayn
string	ls_uniontemp_loc[]
long	ll_i, ll_j, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + as_title
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_col_header1, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_col_header1[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_col_header1[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_i] = of_setexception4title(as_col_header1[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = as_title
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_header_nm, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)		
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next
	case 'cv2_sample'
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To ll_j
			if istr_cht4property.ibdefaultdata100 = true then
				as_uniontemp[ll_i] = '100'
			else
				as_uniontemp[ll_i] = '0'
			end if
			if istr_cht4property.ibnulldatagb = true then 
				if fw_f_nvls(as_uniontemp[ll_i], '0') = '0' then as_uniontemp[ll_i] = istr_node4value.cstr02
			else
				if fw_f_nvls(as_uniontemp[ll_i], '') = '' then as_uniontemp[ll_i] = '0'
			end if
			if ll_i = ll_j then
				choose case of_rtnchtclassify2()
					case 41
						as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case 42
						as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case else
						as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
				end choose
			else
				as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
			end if
		next
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				choose case of_rtnchtclassify2()
					case 41
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case 42
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case else
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
				end choose
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			string	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_x_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					choose case of_rtnchtclassify2()
						case 41
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case 42
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case else
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
					end choose
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose

end subroutine

public subroutine of_x_setbuild4data (string as_datagb, datawindow adw_info, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);string	ls_rdatayn
string	ls_uniontemp_loc[]
long	ll_i, ll_j, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_col_header1, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_col_header1[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_col_header1[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_i] = of_setexception4title(as_col_header1[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = adw_info.describe("Evaluate('LookUpDisplay(lvl2_cd) ', "+ string(al_row) + ")")
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_header_nm, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)		
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				choose case of_rtnchtclassify2()
					case 41
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case 42
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case else
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
				end choose
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			string	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_x_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					choose case of_rtnchtclassify2()
						case 41
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case 42
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case else
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
					end choose
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose

end subroutine

public subroutine of_x_setbuild4data (string as_datagb, string as_title, datawindow adw_data, long al_row, string as_selectobj[], ref string as_uniondata[], ref string as_uniontemp[], ref long al_uniontempcnt, string as_obj[], long al_objcnt, ref string as_col_header1[], ref string as_header_nm[]);string	ls_rdatayn
string	ls_uniontemp_loc[]
long	ll_i, ll_j, ll_a, ll_unionseq

choose case as_datagb
	case 'col_header1'
		as_col_header1[1] = 'nonchtyn_h1~t' + as_title
		ll_j = upperbound(as_col_header1)
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_col_header1, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_col_header1, ll_j)
		for ll_i = 2 To ll_j
			as_col_header1[ll_i] = adw_data.describe("Evaluate('LookUpDisplay(" + as_col_header1[ll_i] + ") ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_i] = of_setexception4title(as_col_header1[ll_i])
		next
	case 'col_header2'
		if al_row = 0 then
			as_col_header1[1] = as_title
			as_col_header1[1] = of_setexception4title(as_col_header1[1])
		else
			ll_j = upperbound(as_col_header1)
			as_col_header1[ll_j + 1] = adw_data.describe("Evaluate('LookUpDisplay(cv2_chtnm) ', "+ string(al_row) + ")") + ischar4datasetvalue
			as_col_header1[ll_j + 1] = of_setexception4title(as_col_header1[ll_j + 1])
		end if
	case 'header_nm'
		if upperbound(as_header_nm) > 0 then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_header_nm, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_header_nm, ll_j)		
		for ll_i = 1 To ll_j
			as_header_nm[ll_i] = adw_data.describe(as_header_nm[ll_i] + ".Text")
			as_header_nm[ll_i] = of_setexception4title(as_header_nm[ll_i])
		next
	case 'cv2_sample'
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_uniontemp, ll_j, al_objcnt)
		of_x_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To ll_j
			if istr_cht4property.ibdefaultdata100 = true then
				as_uniontemp[ll_i] = '100'
			else
				as_uniontemp[ll_i] = '0'
			end if
			if istr_cht4property.ibnulldatagb = true then 
				if fw_f_nvls(as_uniontemp[ll_i], '0') = '0' then as_uniontemp[ll_i] = istr_node4value.cstr02
			else
				if fw_f_nvls(as_uniontemp[ll_i], '') = '' then as_uniontemp[ll_i] = '0'
			end if
			if ll_i = ll_j then
				choose case of_rtnchtclassify2()
					case 41
						as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case 42
						as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case else
						as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
				end choose
			else
				as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
			end if
		next
		
	case 'cv2_chtvalue0'
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		if upperbound(as_uniontemp) = 0 then
			al_uniontempcnt = 0
			of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_uniontemp, al_uniontempcnt, al_objcnt)
			of_x_setbuild4data_1sub(as_datagb, as_uniontemp, al_uniontempcnt)
		end if
		ls_uniontemp_loc = as_uniontemp
		ll_unionseq = upperbound(as_uniondata) + 1
		for ll_i = 1 To al_uniontempcnt
			ls_uniontemp_loc[ll_i] = of_dec4num(adw_data, ls_uniontemp_loc[ll_i], al_row)
			if ll_i = al_uniontempcnt then
				choose case of_rtnchtclassify2()
					case 41
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case 42
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
						as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
					case else
						as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i]
				end choose
			else
				as_uniondata[ll_unionseq] += ls_uniontemp_loc[ll_i] + '==='
			end if
		next
		
	case 'cv2_sumvalue'
		as_datagb = left(as_datagb, 4) + istr_node4value.cstr03
		ls_rdatayn = 'N'
		for ll_i = 1 to al_objcnt
			if Pos(as_obj[ll_i], as_datagb) > 0 then
				ls_rdatayn = 'Y'
				Exit
			end if
		next
		if ls_rdatayn = 'N' then return
		ll_j = 0
		of_xy_setbuild4data_3sub(as_datagb, adw_data, as_obj, as_selectobj, as_uniontemp, ll_j, al_objcnt)
		if upperbound(as_uniondata) < 1 then
			ll_unionseq = 1
		else
			string	ls_values[]
			long	ll_valcnt
			ll_valcnt = fw_f_obj2array(as_uniondata[1], '===', ls_values[])
			as_uniondata[1] = ''
		end if
		of_x_setbuild4data_1sub(as_datagb, as_uniontemp, ll_j)
		for ll_i = 1 To ll_j
			as_uniontemp[ll_i] = of_dec4num(adw_data, as_uniontemp[ll_i], al_row)
			if ll_valcnt > 0 then
				if ll_i = ll_j then
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i]))
				else
					as_uniondata[1] += string(long(as_uniontemp[ll_i]) + long(ls_values[ll_i])) + '==='
				end if
			else
				if ll_i = ll_j then
					choose case of_rtnchtclassify2()
						case 41
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq] + istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case 42
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
							as_uniondata[ll_unionseq] += istr_node4value.cstr01 + as_uniondata[ll_unionseq]
						case else
							as_uniondata[ll_unionseq] += as_uniontemp[ll_i]
					end choose
				else
					as_uniondata[ll_unionseq] += as_uniontemp[ll_i] + '==='
				end if
			end if
		next
end choose
end subroutine

public function string of_x_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_name[], string as_runtype, string as_uniondata[]);string	ls_basketdata1, ls_basketdata2
string	ls_arrdata[]
string	ls_lvl1title, ls_lvl2title, ls_optjson
long	ll_titlecnt, ll_nmcnt, ll_datacnt, ll_i, ll_j

ls_optjson = of_setconfiguration_step1()

ll_titlecnt = upperbound(as_titleobj[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_titlecnt = 1 // gauge
for ll_i = 1 To ll_titlecnt
 	choose case ll_i
		case 1
			if ll_i = ll_titlecnt then				
				ls_basketdata1 = as_titleobj[ll_i]
			else
				ls_lvl1title = as_titleobj[ll_i]
			end if
		case ll_titlecnt
			ls_basketdata1 += as_titleobj[ll_i]
		case else 
			ls_basketdata1 += as_titleobj[ll_i] + '='
	end choose
next

ll_nmcnt = upperbound(as_name[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_nmcnt = 1 // gauge
for ll_j = 1 To ll_nmcnt
	if ll_j = ll_nmcnt then
		ls_lvl2title += as_name[ll_j]
	else
		ls_lvl2title += as_name[ll_j] + '='
	end if
next

ll_datacnt= upperbound(as_uniondata[])
ilcnt4data = fw_f_obj2array(as_uniondata[ll_datacnt], '===', ls_arrdata[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ilcnt4data = 1 // gauge
for ll_j = 1 To ilcnt4data
	for ll_i = 1 To ll_datacnt
		fw_f_obj2array(as_uniondata[ll_i], '===', ls_arrdata[])
		if ll_i = ll_datacnt then
			if ll_j = ilcnt4data then
				ls_basketdata2 += ls_arrdata[ll_j]
			else
				if as_runtype = '03' then
					ls_basketdata2 += ls_arrdata[ll_j] + '='
				else
					choose case of_rtnchtclassify1(istr_cht4property.ischtkind)
						case 41
							ls_basketdata2 += ls_arrdata[ll_j] + '='
						case else
							ls_basketdata2 += ls_arrdata[ll_j] + istr_node4value.cstr01
					end choose
				end if
			end if
		else
			choose case of_rtnchtclassify1(istr_cht4property.ischtkind)
				case 41
					ls_basketdata2 += ls_arrdata[ll_j] + istr_node4value.cstr01
				case else
					ls_basketdata2 += ls_arrdata[ll_j] + '='
			end choose
		end if
	next
next

isrtn4cht = '?' + ls_lvl1title + '=' + ls_lvl2title + istr_node4value.cstr01 + ls_optjson + istr_node4value.cstr01 + ls_basketdata1 + istr_node4value.cstr01 + ls_basketdata2
return isrtn4cht
end function

public function string of_x_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_runtype, string as_uniondata[]);string	ls_lvl1title, ls_optjson, ls_basketdata1, ls_basketdata2
string	ls_arrdata[]
long	ll_titlecnt, ll_nmcnt, ll_datacnt, ll_i, ll_j
long	ll_sumnum[], ll_addnum[]

ls_optjson = of_setconfiguration_step1()

ll_titlecnt = upperbound(as_titleobj[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_titlecnt = 1 // gauge
for ll_i = 1 To ll_titlecnt
 	choose case ll_i
		case 1
			if ll_i = ll_titlecnt then
				ls_basketdata1 = as_titleobj[ll_i]
			else
				ls_lvl1title = as_titleobj[ll_i]
			end if
		case ll_titlecnt
			ls_basketdata1 += as_titleobj[ll_i]
		case else 
			ls_basketdata1 += as_titleobj[ll_i] + '='
	end choose
next

ll_datacnt= upperbound(as_uniondata[])
ilcnt4data = fw_f_obj2array(as_uniondata[ll_datacnt], '===', ls_arrdata[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ilcnt4data = 1 // gauge
for ll_j = 1 To ilcnt4data
	for ll_i = 1 To ll_datacnt
		fw_f_obj2array(as_uniondata[ll_i], '===', ls_arrdata[])
		if ll_i = ll_datacnt then
			if ll_j = ilcnt4data then
				ls_basketdata2 += ls_arrdata[ll_j]
			else
				if as_runtype = '03' then
					ls_basketdata2 += ls_arrdata[ll_j] + '='
				else
					choose case of_rtnchtclassify1(istr_cht4property.ischtkind)
						case 41
							ls_basketdata2 += ls_arrdata[ll_j] + '='
						case else
							ls_basketdata2 += ls_arrdata[ll_j] + istr_node4value.cstr01
					end choose
				end if
			end if
		else
			choose case of_rtnchtclassify1(istr_cht4property.ischtkind)
				case 41
					ls_basketdata2 += ls_arrdata[ll_j] + istr_node4value.cstr01
				case else
					ls_basketdata2 += ls_arrdata[ll_j] + '='
			end choose
		end if
	next
next

//This.getchartvalue2te(1007, ls_lvl1title, ls_optjson, ls_basketdata2, isrtn4cht)
isrtn4cht = '?' + ls_basketdata1 + istr_node4value.cstr01 + ls_optjson + istr_node4value.cstr01 + ls_basketdata2

return isrtn4cht
end function

public function string of_y_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_name[], string as_uniondata[]);string	ls_basketdata1, ls_basketdata2
string	ls_arrdata[]
string	ls_lvl1title, ls_lvl2title, ls_titleobj, ls_optjson
long	ll_titlecnt, ll_nmcnt, ll_datacnt, ll_i, ll_j

ls_optjson = of_setconfiguration_step1()

ll_titlecnt = upperbound(as_titleobj[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_titlecnt = 1 // gauge
for ll_i = 1 To ll_titlecnt
	if ll_i = ll_titlecnt then
		ls_lvl1title += as_titleobj[ll_i]
	else
		ls_lvl1title += as_titleobj[ll_i] + '='	
	end if
next

ll_nmcnt = upperbound(as_name[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_nmcnt = 1 // gauge
for ll_j = 1 To ll_nmcnt
	if ll_j = ll_nmcnt then
		ls_lvl2title += as_name[ll_j]
	else
		ls_lvl2title += as_name[ll_j] + '='
	end if
next

ll_datacnt= upperbound(as_uniondata[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_datacnt = 1 // gauge
for ll_i = 1 To ll_datacnt
	ilcnt4data = fw_f_obj2array(as_uniondata[ll_i], '===', ls_arrdata[])
	for ll_j = 1 To ilcnt4data
		if ll_j = ilcnt4data then
			if ll_i = ll_datacnt then
				ls_basketdata2 += ls_arrdata[ll_j]
			else
				ls_basketdata2 += ls_arrdata[ll_j] + istr_node4value.cstr01
			end if
		else
			ls_basketdata2 += ls_arrdata[ll_j] + '='
		end if
	next
next

isrtn4cht = '?' + ls_lvl1title + istr_node4value.cstr01 + ls_optjson + istr_node4value.cstr01 + ls_lvl2title + istr_node4value.cstr01 + ls_basketdata2

return isrtn4cht
end function

public function string of_y_setbuild4rvalue (string as_timeractive_yn, string as_titleobj[], string as_datasets, string as_uniondata[]);string	ls_basketdata1, ls_basketdata2
string	ls_arrdata[]
string	ls_lvl1title, ls_lvl2title, ls_titleobj, ls_optjson
long	ll_titlecnt, ll_nmcnt, ll_datacnt, ll_i, ll_j

ls_optjson = of_setconfiguration_step1()

ll_titlecnt = upperbound(as_titleobj[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_titlecnt = 1 // gauge
for ll_i = 1 To ll_titlecnt
	if ll_i = ll_titlecnt then
		ls_lvl1title += as_titleobj[ll_i]
	else
		ls_lvl1title += as_titleobj[ll_i] + '='
	end if
next

ll_datacnt= upperbound(as_uniondata[])
if of_rtnchtclassify1(istr_cht4property.ischtkind) = 21 then ll_datacnt = 1 // gauge
for ll_i = 1 To ll_datacnt
	ilcnt4data = fw_f_obj2array(as_uniondata[ll_i], '===', ls_arrdata[])
	for ll_j = 1 To ilcnt4data
		if ll_j = ilcnt4data then
			if ll_i = ll_datacnt then
				ls_basketdata2 += ls_arrdata[ll_j]
			else
				ls_basketdata2 += ls_arrdata[ll_j] + istr_node4value.cstr01
			end if
		else
			ls_basketdata2 += ls_arrdata[ll_j] + '='
		end if
	next
next

isrtn4cht = '?' + ls_lvl1title + istr_node4value.cstr01 + ls_optjson + istr_node4value.cstr01 + ls_basketdata2

return isrtn4cht
end function

public function string of_setconfiguration_step2 (ref fw_s_cht4property astr_cht4property);string		ls_chtjson, ls_json4json
string		ls_usercht4obj, ls_chtkind
string		ls_ibdatalabels
string		ls_chartrule
long		ll_findobject

ls_usercht4obj = astr_cht4property.usercht4obj
ls_chtkind = astr_cht4property.ischtkind

fw_n_cht4json ljson_option, lj_option
fw_n_cht4json ljson_data, lj_data
ljson_option = create fw_n_cht4json
ljson_data = create fw_n_cht4json

ls_chartrule = string(of_rtnchtclassify1(istr_cht4property.ischtkind))
//add json object
lj_option = ljson_option.addobject( 'options')
lj_option.setattribute( 'optionBtn', astr_cht4property.ibbtnvisible4cht)
lj_option.setattribute( 'chartRule',  ls_chartrule)
lj_option.setattribute( 'commonColor', astr_cht4property.ibcommoncolor )

lj_option.setattribute( 'ibpns2dls2display', astr_cht4property.ibpns2dls2display )
lj_option.setattribute( 'ispns2dls2bordercolor', astr_cht4property.ispns2dls2bordercolor )
lj_option.setattribute( 'ispns2dls2backgroundcolor', astr_cht4property.ispns2dls2backgroundcolor )
lj_option.setattribute( 'ispns2dls2color', astr_cht4property.ispns2dls2color )
lj_option.setattribute( 'ispns2dls2colorh', astr_cht4property.ispns2dls2colorh )
lj_option.setattribute( 'ispns2dls2formatterlabelgb', astr_cht4property.ispns2dls2formatterlabelgb )
lj_option.setattribute( 'ispns2dls2formatterlabelvalgb', astr_cht4property.ispns2dls2formatterlabelvalgb )

lj_option.setattribute( 'isdefaultFontStyle', astr_cht4property.isdefaultfontstyle )
lj_option.setattribute( 'ildefaultFontSize', astr_cht4property.ildefaultfontsize )
lj_option.setattribute( 'isdefaultFontFamily', astr_cht4property.isdefaultfontfamily )
lj_option.setattribute( 'isdefaultFontColor', astr_cht4property.isdefaultfontcolor )

lj_option.setattribute( 'ibthousandcomma', astr_cht4property.ibthousandcomma )
lj_option.setattribute( 'LegendDisplay', astr_cht4property.iblegenddisplay)
lj_option.setattribute( 'LegendPosition', astr_cht4property.islegendposition)
lj_option.setattribute( 'tooltipsrangegb', astr_cht4property.ibtooltipsrangegb ) //순서중요 1.tooltipsrangegb 2. tooltips 
lj_option.setattribute( 'tooltips', astr_cht4property.ibtooltipsgb )
lj_option.setattribute( 'ilborderwidth', astr_cht4property.ilborderwidth )
lj_option.setattribute( 'iblinefillgb', astr_cht4property.iblinefillgb )
lj_option.setattribute( 'ibhoverborder', astr_cht4property.ibhoverborder )
lj_option.setattribute( 'ishoverbordercolor', astr_cht4property.ishoverbordercolor )
lj_option.setattribute( 'ilhoverborderwidth', astr_cht4property.ilhoverborderwidth )
lj_option.setattribute( 'WarningStep', astr_cht4property.iswaringstep )

lj_option.setattribute( 'iblinebargb', astr_cht4property.iblinebargb )
lj_option.setattribute( 'illinebarcnt', astr_cht4property.illinebarcnt )
lj_option.setattribute( 'illiney1axiscnt', astr_cht4property.illiney1axiscnt )
lj_option.setattribute( 'ibxaxes0display', astr_cht4property.ibxaxes0display )
lj_option.setattribute( 'ibyaxes0display', astr_cht4property.ibyaxes0display )
lj_option.setattribute( 'ibyaxes1display', astr_cht4property.ibyaxes1display )
lj_option.setattribute( 'ibxaxes0gridlinedisplay', astr_cht4property.ibxaxes0gridlinedisplay )
lj_option.setattribute( 'ibyaxes0gridlinedisplay', astr_cht4property.ibyaxes0gridlinedisplay )
lj_option.setattribute( 'ibyaxes1gridlinedisplay', astr_cht4property.ibyaxes1gridlinedisplay )
lj_option.setattribute( 'ibxaxes0gridlinecolor', astr_cht4property.ibxaxes0gridlinecolor )
lj_option.setattribute( 'ibyaxes0gridlinecolor', astr_cht4property.ibyaxes0gridlinecolor )
lj_option.setattribute( 'ibyaxes1gridlinecolor', astr_cht4property.ibyaxes1gridlinecolor )

lj_option.setattribute( 'lineTension', astr_cht4property.iblinetension )
lj_option.setattribute( 'minmax2fixcolor', astr_cht4property.ibminmax2fixcolor )
lj_option.setattribute( 'linePoint', astr_cht4property.iblinepoint )
lj_option.setattribute( 'linePointRadius', astr_cht4property.illinepointradius )
lj_option.setattribute( 'linePointHoverRadius', astr_cht4property.illinepointhoverradius )
lj_option.setattribute( 'ibbeginatzeroleft', astr_cht4property.ibbeginatzeroleft )
lj_option.setattribute( 'ibbeginatzeroright', astr_cht4property.ibbeginatzeroright )

lj_option.setattribute( 'xAxesLabelString', astr_cht4property.isxaxeslabelstring )
lj_option.setattribute( 'yAxesLabelString1', astr_cht4property.isyaxeslabelstring1 )
lj_option.setattribute( 'yAxesLabelString2', astr_cht4property.isyaxeslabelstring2 )

lj_option.setattribute( 'lineStacked', astr_cht4property.iblinestacked )
lj_option.setattribute( 'lineLogarithmic', astr_cht4property.iblinelogarithmic )
lj_option.setattribute( 'lineStepped', astr_cht4property.iblinestepped )

lj_option.setattribute( 'lineAlterColor2All', astr_cht4property.iblinealtercolor2all )
lj_option.setattribute( 'lineAlterBkColor2All', astr_cht4property.islinealterbkcolor2all )
lj_option.setattribute( 'lineAlterBdColor2All', astr_cht4property.islinealterbdcolor2all )

lj_option.setattribute( 'lineAlter1st', astr_cht4property.iblinealter1st )
lj_option.setattribute( 'lineAlter1st_row', astr_cht4property.illinealter1st_row - 1 )
lj_option.setattribute( 'lineAlterFill1st', astr_cht4property.iblinealterfill1st )
lj_option.setattribute( 'lineAlterBkColor1st', astr_cht4property.islinealterbkcolor1st )
lj_option.setattribute( 'lineAlterBdColor1st', astr_cht4property.islinealterbdcolor1st )

lj_option.setattribute( 'lineAlter2nd', astr_cht4property.iblinealter2nd )
lj_option.setattribute( 'lineAlter2nd_row', astr_cht4property.illinealter2nd_row - 1)
lj_option.setattribute( 'lineAlterFill2nd', astr_cht4property.iblinealterfill2nd )
lj_option.setattribute( 'lineAlterBkColor2nd', astr_cht4property.islinealterbkcolor2nd )
lj_option.setattribute( 'lineAlterBdColor2nd', astr_cht4property.islinealterbdcolor2nd )

lj_option.setattribute( 'lineAlter3rd', astr_cht4property.iblinealter3rd )
lj_option.setattribute( 'lineAlter3rd_row', astr_cht4property.illinealter3rd_row - 1 )
lj_option.setattribute( 'lineAlterFill3rd', astr_cht4property.iblinealterfill3rd )
lj_option.setattribute( 'lineAlterBkColor3rd', astr_cht4property.islinealterbkcolor3rd )
lj_option.setattribute( 'lineAlterBdColor3rd', astr_cht4property.islinealterbdcolor3rd )

lj_option.setattribute( 'lineAlter4th', astr_cht4property.iblinealter4th )
lj_option.setattribute( 'lineAlter4th_row', astr_cht4property.illinealter4th_row - 1 )
lj_option.setattribute( 'lineAlterFill4th', astr_cht4property.iblinealterfill4th )
lj_option.setattribute( 'lineAlterBkColor4th', astr_cht4property.islinealterbkcolor4th )
lj_option.setattribute( 'lineAlterBdColor4th', astr_cht4property.islinealterbdcolor4th )		

lj_option.setattribute( 'lineyAxesL', astr_cht4property.ibyaxes4l )
lj_option.setattribute( 'lineyAxesLMin', astr_cht4property.min4left )
lj_option.setattribute( 'lineyAxesLMax', astr_cht4property.max4left )
lj_option.setattribute( 'lineyAxesLStep', astr_cht4property.ticksstepsize4l )
if astr_cht4property.ibyaxes4l = true and astr_cht4property.ibyaxes4l_q = true then
	lj_option.setattribute( 'lineyAxesLMin', astr_cht4property.min4left_q )
	lj_option.setattribute( 'lineyAxesLMax', astr_cht4property.max4left_q )
	lj_option.setattribute( 'lineyAxesLStep', astr_cht4property.ticksstepsize4l_q )
end if

lj_option.setattribute( 'lineyAxesR', astr_cht4property.ibyaxes4r )		
lj_option.setattribute( 'lineyAxesRMin', astr_cht4property.min4right )
lj_option.setattribute( 'lineyAxesRMax', astr_cht4property.max4right )
lj_option.setattribute( 'lineyAxesRStep', astr_cht4property.ticksstepsize4r )
if astr_cht4property.ibyaxes4r = true and astr_cht4property.ibyaxes4r_q = true then
	lj_option.setattribute( 'lineyAxesRMin', astr_cht4property.min4right_q )
	lj_option.setattribute( 'lineyAxesRMax', astr_cht4property.max4right_q )
	lj_option.setattribute( 'lineyAxesRStep', astr_cht4property.ticksstepsize4r_q )
end if

//'31' doughnut
lj_option.setattribute( 'PiecutoutPercentage', astr_cht4property.ilpiecutoutpercentage )
choose case ls_chartrule
	case '1', '2', '31'
		lj_option.setattribute( 'ibXaxis', astr_cht4property.ibxaxis )
	case '41'
		lj_option.setattribute( 'lineLogarithmic', astr_cht4property.iblinelogarithmic )
		lj_option.setattribute( 'ibXaxis', false )
	case else
		lj_option.setattribute( 'ibXaxis', false )
end choose

string	ls_scales, ls_xAxes, ls_xAxes_scales
string	ls_yaxes, ls_yaxes4left, ls_yaxes4right
string	ls_scales_data
ls_scales =	'"scales":{' 
ls_json4json = ljson_option.getformatjson('' )
ls_scales += '}'

if fw_f_nvls(ls_yaxes, '') <> '' then
	ls_scales_data = ReplaceA(ls_json4json, LenA(ls_json4json), 1, ',' + ls_scales + '}' + '}')
	ls_chtjson = ls_scales_data
end if
ll_findobject = PosA( ls_chtjson, '},"scales"' )
if ll_findobject > 0 then
	ls_chtjson = ReplaceA(ls_chtjson, ll_findobject , 1, "" )
else
	ls_chtjson = ls_json4json
end if

return ls_chtjson
end function

public function string of_setconfiguration_step1 ();String		ls_chtjson
String		ls_chartobj
long	ll_findobject

ls_chartobj	= istr_cht4property.usercht4obj

if LenA(istr_cht4property.isuserdatasets) = 0 then
	ls_chtjson = of_setconfiguration_step2( istr_cht4property )

	if LenA(istr_cht4property.isdatasets) = 0 then 
		ls_chtjson = ls_chtjson + '={"datasets": []}'
	else 
		ls_chtjson = ls_chtjson + '=' + istr_cht4property.isdatasets
	end if	
else 
	ls_chtjson = istr_cht4property.isuserdatasets
end if	

return ls_chtjson
end function

on fw_n_v3cview.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_v3cview.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;of_setconstapi()
of_setdsinstance()

end event

