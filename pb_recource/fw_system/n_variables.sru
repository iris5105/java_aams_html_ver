forward
global type n_variables from nonvisualobject
end type
end forward

global type n_variables from nonvisualobject
end type
global n_variables n_variables

type prototypes
// Kernel32.dll
function ULong GetTempPath (ULong nBufferLength, Ref String lpBuffer) library "kernel32.dll" Alias For "GetTempPathA;Ansi"
function ULong GetLongPathName(Ref String lpszShortPath, Ref String lpszLongPath, ULong cchBuffer ) library "kernel32.dll" Alias For "GetLongPathNameA;Ansi"

// Gdi32.dll
function long GetDC(long hwnd) library "user32.dll"
function boolean ReleaseDC(long hwnd, long hdc)library "user32.dll"
function long GetDeviceCaps(long hdc, int nIndex) library "gdi32.dll" // Gdi32.dll window size 125% check

end prototypes

type variables
Constant    string ini4config = ".\fw_config.ini"
Constant    string ini4topmenu = ".\fw_topmenu.ini"

// 공통 리턴값 상수
Constant    integer success = 1
Constant    integer failure = -1
Constant    integer no_action = 0

Public:
   fw_n_dso		ids_imagefile	/* f_getimagepathappeon image value fw_n_dso */
   fw_n_dso		ids_logseq_max
   fw_n_dso		ids_err_log

   STRING	is_sys_id
   STRING	is_nodekey
   STRING	is_login_yn
   STRING	is_user_gu
   STRING	is_user_id, is_user_nm
   STRING	is_dept_cd, is_dept_nm
   STRING	is_dept_dt
   STRING	is_dept_jc, is_dept_jcnm
   STRING	is_dbconnect

   datetime idt_in_ymd
   datetime idt_out_ymd
   datetime idtm_login

   STRING	is_sysdept_cd
   STRING	is_login_dt
   STRING	is_user_tel_no
   STRING	is_lang_type = 'lng_kor'
   STRING	is_crypter_key = 'biz4pentabiz4penta'
	
   STRING	is_node4cview2key = ''		/* log table, designsyntax table에 등록 cs 및 web variable */

   STRING	is_ipaddress
   STRING	is_macaddress

   window   iwparent                /* iw_parent value */

   STRING	isprev4topmenu = ''
   STRING	isnow4topmenu  = ''
   STRING	isprev4submenu = ''
   STRING	isnow4submenu  = ''
   STRING	basepath                /* 기본 경로 저장 */
   STRING	is_tempdirectory        /* ..\AppData\Local\Temp\pentalib\CS 및 SITE 경로 등록 */
	
	string	iserror2pgmno				/* error window 경로 저장 */
	string	iserror2navi				/* error window 경로 저장 */
	string	iserror2window				/* error window 실제 명 저장 */
	window	iwerror2window				/* error window 마지막 window 저장 */
	string	iserror2path1				/* error img 경로 저장 1 */
	string	iserror2path2				/* error img 경로 저장 2 */

	STRING	iserrorpath1            /* error 경로 저장 1 ? */
	STRING	iserrorpath2            /* error 경로 저장 2 ? */
   STRING	iserrormsg              /* error 내용 */
   LONG		ilupdate4error2num		/* update4error2num */

   STRING	role_no[]
   STRING	role_nm[]
   STRING	mswindowrate               /* MS Window Text 돋보기 사용 100% - '100', 125% - '125' */
   dec{2}   mswindowratedec            /* MS Window dec 돋보기 사용 100% - '100', 125% - '125' */
   STRING	w_frame     		= ''  	/* w_frame */
   STRING	w_login    			= ''  	/* w_login */
   STRING	w_home    			= ''  	/* w_home type별로 선언 type1, type2.... */
   STRING	is_last4topmenu   = ''
   STRING	is_last4submenu   = ''

	Long	il_return4closesheettab	= 0
	Long	il_dwheightminus1value = 0

   STRING	SSOProgressYN  = 'N'
   STRING	idbackdoor     = ''     /* back door variable id등록 후 password skip */
   STRING	linkpgm_no     = ''     /* link program no */
   dec{2}   windelaytime   = 0      /* window menu delay time */
   STRING	ispush2delayyn = 'N'    /* push delay cnt */

   LONG	iladditives2numcolor = 16777216
   LONG	basefontcolor
   LONG	framebackcolor

   LONG	mdi2topmenubackcolor
   LONG	mdi2topmenuselected4fontcolor
   LONG	mdi2submenuselected4fontcolor
   LONG	mdi2topmenuselected4backcolor
   LONG	mdi2submenuselected4backcolor
   LONG	mdi2topmenunotselected4fontcolor
   LONG	mdi2submenunotselected4fontcolor

   STRING	sheettab2selected4fontcolor
   STRING	sheettab2notselected4fontcolor

   LONG	mdi2xpmenubackcolor
   LONG	mdi2xpmenudetailcolor
   LONG	mdi2xpmenu4treelevelcolor

   LONG	sheetbackcolor
   LONG	setlist4backcolor
   LONG	setcondbackcolor
   LONG	setfreebackcolor
   LONG	bordernor2topcolor
   LONG	bordernor2bottomcolor
   LONG	bordernor2leftcolor
   LONG	bordernor2rightcolor
   LONG	borderfocuscolor
   LONG	alternatefirstrowcolor
   LONG	alternatesecondrowcolor
   LONG	setclearselectcolor
   LONG	setcolfocusbackcolor
   LONG	setrectfocuscolor
   LONG	setrectnormalcolor
   LONG	disabledcolbgcolor
   LONG	editablecolbgcolor

   LONG	sort2back4color
   LONG	sort2asc4color
   LONG	sort2desc4color
   LONG	sort2arrow4color
   LONG	filter2font4color
   LONG	filter2sign4color

   LONG	setlist4headercolor
   LONG	setlist4summarycolor
   LONG	setlist4footercolor
   LONG	setlist4goupcolor1
   LONG	setlist4goupcolor2
   LONG	setlist4headerfontcolor
   LONG	setlist4summaryfontcolor
   LONG	setlist4footerfontcolor
	long	setlist4mouseovercolor

   LONG	pointcolor4objfont_a
   LONG	pointcolor4objfont_b
   LONG	pointcolor4objfont_c
   LONG	pointcolor4objfont_d
   LONG	pointcolor4objfont_e
   LONG	pointcolor4row_a
   LONG	pointcolor4row_b
   LONG	pointcolor4row_c
   LONG	pointcolor4row_d
   LONG	pointcolor4row_e

   STRING	GetClientType     = ''
   STRING	Getcachedir       = ''           /* appeongetcachedir() 를  variable 등록 */
   STRING	AppeonGetSite     = ''           /* pentalib 에서 of_getappeonsite() 값을  variable 등록 */
   STRING	AppeonGetIEurl    = ''           /* appeongetieurl() 를  variable 등록 */
   LONG		GetIEHandle       = 0            /* GetIEHandle() 를  variable 등록 */
   STRING	Getbrowserversion = ''           /* appeongetbrowserversion() 를  variable 등록 */

   STRING	GetSavePath = ''     /* 파일경로를 초기화 없이 임시 variable   variable 등록 */
   STRING	GetBlock    = ''     /* Block   variable 등록 */
   LONG		GetBlockLen = 0      /* Block Len   variable 등록 */

   STRING	SetEssSite              = ''     /* log table, designsyntax table에 등록 cs 및 web variable */
   STRING	SetCacheSignupIP        = ''     /* DesignCache 처리 가능 ip 등록 예) 배포 서버 */
   STRING	setwassignupip          = ''     /* WAS editor html 가능 ip 등록 예) 공지사항 editor html 서버 */
   STRING	setcachelibdir          = ''     /* DesignCache 관련 variable  gnv_vari.basepath + '\pf_datawindow.pbl' */
   STRING	setcache4backcolorsyn   = ''     /* DesignCache 관련 variable */
   STRING	setcache4freesyn        = ''     /* DesignCache 관련 variable */
   STRING	setcache4condsyn        = ''     /* DesignCache 관련 variable */
   STRING	setcache4gridsyn        = ''     /* DesignCache 관련 variable */
   STRING	setcache4tabularsyn     = ''     /* DesignCache 관련 variable */

   STRING	ModifyDT_commandbutton              = ''  /* pf_u_commandbutton.js 변경일자를  variable 등록 */
   STRING	ModifyDT_commandbutton_overlay      = ''  /* pf_u_commandbutton_overlay.js 변경일자를  variable 등록 */
   STRING	ModifyDT_dwdesign_freeform          = ''  /* fw_u_dwdesign_freeform.js 변경일자를  variable 등록 */
   STRING	ModifyDT_dwdesign_searchcondition   = ''  /* fw_u_dwdesign_searchcondition.js 변경일자를  variable 등록 */
   STRING	ModifyDT_dwdesign_tabular           = ''  /* fw_u_dwdesign_tabular.js 변경일자를  variable 등록 */

   STRING	ModifyDT_button_normal_img    = ''  /* is_normal_img 변경일자를  variable 등록 */
   STRING	ModifyDT_button_mouseover_img = ''  /* is_mouseover_img 변경일자를  variable 등록 */
   STRING	ModifyDT_button_clicked_img   = ''  /* is_clicked_img 변경일자를  variable 등록 */
   STRING	ModifyDT_button_disabled_img  = ''  /* is_disabled_img 변경일자를  variable 등록 */

   STRING	ModifyDT_tab_img_notselected  = ''  /* TAB_IMG_NOTSELECTED 변경일자를  variable 등록 */
   STRING	ModifyDT_tab_img_selected     = ''  /* TAB_IMG_SELECTED 변경일자를  variable 등록 */
   STRING	ModifyDT_tab_img_disabled     = ''  /* TAB_IMG_DISABLED 변경일자를  variable 등록 */
end variables

forward prototypes
public function string of_getwebsitebyname ()
public function string of_thisname ()
public function string of_getprofile (string as_key, string as_default)
public function integer of_setprofile (string as_key, string as_value)
public function string of_getsection (string as_key)
public subroutine of_settemppathcreate ()
public function string of_gettemppathfind ()
public function string of_getwindowrate ()
public subroutine of_setvariable ()
public subroutine of_getimagepath ()
public function string of_getprofile4topmenu (string as_key, string as_default)
public function integer of_setprofile4topmenu (string as_key, string as_value)
end prototypes

public function string of_getwebsitebyname ();String	ls_getappeonsite
Long		ll_lastpos

If gnv_vari.getclienttype = 'WEB' Then
	ls_getappeonsite = fw_f_nvls(appeongetieurl(), '')
	If ls_getappeonsite = '' Then Return ''
	
	ls_getappeonsite = left(ls_getappeonsite, len(ls_getappeonsite) - 1)
	ll_lastpos = lastpos(ls_getappeonsite, '/')
	If ll_lastpos > 0 Then ls_getappeonsite = Trim(mid(ls_getappeonsite, ll_lastpos + 1))

	Return ls_getappeonsite
Else
	Return gnv_vari.SetEssSite
End If
end function

public function string of_thisname ();return 'n_variables'
end function

public function string of_getprofile (string as_key, string as_default);// 파워프레임 환경설정 값을 가져옵니다
// as_key=설정값을 가져올 키값
// as_default=키값이 없을 경우 기본 값
// 리턴값=환경설정 값

string ls_section
string ls_retval

ls_section = this.of_getsection(as_key)
ls_retval  = profilestring(ini4config, ls_section, as_key, as_default)

return ls_retval

end function

public function integer of_setprofile (string as_key, string as_value);// 파워프레임 환경설정 값을 저장합니다
// as_key=ini 파일에 저장할 키값
// as_default=ini 파일에 저장할 값
// 리턴값=성공:1, 실패:-1

string ls_section
integer li_retcd

ls_section = this.of_getsection(as_key)
li_retcd  = setprofilestring(ini4config, ls_section, as_key, as_value)

return li_retcd

end function

public function string of_getsection (string as_key);// 넘거받은 키값으로 ini파일의 섹션값을 구합니다 
// 검색된 섹션값이 없으면 '.'로 구분되어진 좌측 값을 사용합니다(예:mdi.backcolor = mdi 섹션)
// as_key=섹션값을 구할 키값
// 리턴=검색된 키값

long ll_pos
string ls_section

ll_pos = pos(as_key, '.')
if ll_pos > 0 then
	ls_section = left(as_key, ll_pos - 1)
	choose case ls_section
		case 'slplit'
			ls_section = 'SplitBar'
		case 'frame'
			ls_section = 'FrameWork'
		case 'mdi'
			ls_section = 'MDIWindow'
		case 'user'
			ls_section = 'UserSettings'
		case 'KICC'
			ls_section = 'KICC'
	end choose
else
	ls_section = 'FrameWork'
end if

return ls_section

end function

public subroutine of_settemppathcreate ();is_tempdirectory = of_gettemppathfind()
is_tempdirectory = is_tempdirectory + 'penta\'
If Not DirectoryExists(is_tempdirectory) Then
	Createdirectory(is_tempdirectory)
End If

If fw_f_nvls(gnv_vari.AppeonGetSite, '') <> '' Then
	is_tempdirectory += gnv_vari.AppeonGetSite + '\'
Else
	is_tempdirectory += gnv_vari.SetEssSite + '\'
End If
If Not DirectoryExists(is_tempdirectory) Then
	Createdirectory(is_tempdirectory)
End If
end subroutine

public function string of_gettemppathfind ();// get find system temporary path
Constant long MAX_PATH = 256

long ll_bufflen
string ls_shortpath, ls_longpath

ll_bufflen = MAX_PATH
ls_shortpath = space(MAX_PATH)

If GetTempPath(ll_bufflen, ls_shortpath) > 0 then
	ls_longpath = space(MAX_PATH)
	GetLongPathName(ls_shortpath, ls_longpath, MAX_PATH)
End if

Return ls_longpath

end function

public function string of_getwindowrate ();//function long GetDC(long hwnd) library "user32.dll"
//function long GetDeviceCaps(long hdc, int nIndex) library "gdi32.dll"
//function boolean ReleaseDC(long hwnd, long hdc)library "user32.dll"

CONSTANT LONG LOGPIXELSX = 88

Long		ll_hwd, ll_hdc
Long		ll_dpi_x

ll_hdc = GetDC(Handle(this))

ll_dpi_x = GetDeviceCaps( ll_hdc, LOGPIXELSX)

ReleaseDC( ll_hdc, ll_hdc )
//    96 DPI = 100% scaling
//    120 DPI = 125% scaling
//    144 DPI = 150% scaling
//    192 DPI = 200% scaling

Choose Case ll_dpi_x
	Case 96
		Return '100'
		//Messagebox( "작게(기본)", "100% scaling")
	Case 120
		Return '125'
		//Messagebox( "중간", "125% scaling")
	Case 144
		Return '150'
		//Messagebox( "크게", "150% scaling")
	Case 192
		Return '200'
		//Messagebox( "크게", "150% scaling")
	Case Else
		Return '999'
		//Messagebox( "사용자", String(ll_dpi_x))
End Choose

end function

public subroutine of_setvariable ();/* ver 1.7.6.1 */
w_frame = 'w_mdi4framelv2'
w_login = 'w_login_aams'

w_home				= 'w_home5'	/* pf_w_home type별로 선언 type1, type2.... */
setesssite				= 'aams'		/* cache 및 로그 관리 -> cs 및 web 통합 관리 site */
is_sys_id				= ''
is_lang_type				= 'lng_kor'
is_nodekey				= 'biz4penta'
is_node4cview2key		= 'node4cview2'

ids_logseq_max = create fw_n_dso
ids_logseq_max.dataobject = 'fw_d_logseq_max'
ids_err_log = create fw_n_dso
ids_err_log.dataobject = 'fw_d_error_log'

setwassignupip		= ''					//'localhost:8888'// 'erp.hwasung.com' 	/* 'localhost:8888' REAL WAS SERVER */
SetCacheSignupIP	= 'localhost'		/* DesignCache 처리 가능 ip 등록 예) 배포 서버 aws.penta.co.kr:8888 */
GetSavePath			= ''					/* 파일경로를 초기화 없이 임시 variable  appsession variable 등록 */
il_dwheightminus1value	= 88			/* datawindow subbutton height */

getclienttype		= 'PB'	// appeongetclienttype()							/* to-be  getclienttype 변수 등록 */
getcachedir			= appeongetcachedir()							/* dw design syntax 변수 appeongetcachedir() 등록 */
mswindowrate		= of_getwindowrate()								/* to-be  MS windowrate */
mswindowratedec	= Truncate(Long(mswindowrate) / 100, 2)	/* to-be  MS window rate dec */
AppeonGetIEurl		= appeongetieurl()								/* appeongetieurl() 를 appsession variable 등록 */
GetIEHandle			= AppeonGetIEHandle( )							/* AppeonGetIEHandle() 를 appsession variable 등록 */
Getbrowserversion	= appeongetbrowserversion()					/* appeongetbrowserversion() 를 appsession variable 등록 */
AppeonGetSite		= of_getwebsitebyname()							/* to-be pentalib 에서 of_getappeonsite() 값을 appsession variable 등록 차 후 log table, designsyntax table에 등록 */

basepath = getcurrentdirectory()
of_settemppathcreate()

fw_f_setblockvalue()	/* blockinitialize */
end subroutine

public subroutine of_getimagepath ();/* to-be global image file fw_n_dso Create */
ids_imagefile = Create fw_n_dso
ids_imagefile.DataObject = 'fw_d_imgfile'
ids_imagefile.SetTransObject( sqlca )
end subroutine

public function string of_getprofile4topmenu (string as_key, string as_default);// 파워프레임 환경설정 값을 가져옵니다
// as_key=설정값을 가져올 키값
// as_default=키값이 없을 경우 기본 값
// 리턴값=환경설정 값

string ls_section
string ls_retval

ls_section = this.of_getsection(as_key)
ls_retval  = profilestring(ini4topmenu, ls_section, as_key, as_default)

return ls_retval

end function

public function integer of_setprofile4topmenu (string as_key, string as_value);// 파워프레임 환경설정 값을 저장합니다
// as_key=ini 파일에 저장할 키값
// as_default=ini 파일에 저장할 값
// 리턴값=성공:1, 실패:-1

string ls_section
integer li_retcd

ls_section = this.of_getsection(as_key)
li_retcd  = setprofilestring(ini4topmenu, ls_section, as_key, as_value)

return li_retcd

end function

on n_variables.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_variables.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;of_getimagepath()
end event

