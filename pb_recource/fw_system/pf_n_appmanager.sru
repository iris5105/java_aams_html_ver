forward
global type pf_n_appmanager from n_ancestor
end type
end forward

global type pf_n_appmanager from n_ancestor
event oue_applicationopen ( string commandline )
event oue_applicationclose ( )
event oue_afterloginprocess ( )
event oue_loginprocess ( )
event oue_applicationidle ( )
event oue_logoutprocess ( )
event oue_systemerror ( )
end type
global pf_n_appmanager pf_n_appmanager

type prototypes

end prototypes

type variables
// 기본 IDLE TIME 값
constant integer DEFAULT_IDLE_TIMEOUT_SEC = (60 * 60 * 2)

public:
   // 현재 실행 중인 Application Object
   application inv_application

   // Main MDI/Login 윈도우 참조변수
   window iw_mainframe
   window iw_login

   // CommandParameter 보관
   STRING	is_commandparm

   // 실행모드
   STRING	is_runningmode

   //SSO Check
   oleobject inv_xmlhttp
end variables

forward prototypes
public function string of_thisname ()
public function boolean of_checksinglesignon ()
private function boolean of_isrunningindebuggingmode ()
public function string of_getpbrunningmode ()
end prototypes

event oue_applicationopen(string commandline);// Get Application
inv_application	= GetApplication()
is_commandparm = commandline
// Transaction Pool 설정(필요한 경우 UnCommnet)
//powerframe.SetTransPool(1, 12, 10)

// 세션 생성(=글로벌 변수 모음)
gnv_vari			= Create n_variables
gnv_vari.of_setvariable()							/* to-be system base value set*/

gnv_extfunc		= Create n_extfunc
gnv_handle		= Create fw_n_handle
gnv_authority	= Create n_authority
gnv_authorbtn	= Create pf_n_buttonrole		/* to-be button author Instance */
gnv_siteapi		= Create n_siteapi
gnv_menu			= Create n_menu
gnv_file			= Create fw_n_file
gnv_lang			= create fw_n_lang

gaa.corp_gr = gnv_vari.of_getprofile('login.last.corp_gr', '2200')
// 삭제예정
IF	f_null (gaa.corp_gr)	Then
	gaa.corp_gr = gnv_vari.of_getprofile('login.last.corp.gr', '')
	SELECT TO_DECRYPTS (:gaa.corp_gr) INTO :gaa.corp_gr FROM DUAL;
	gaa.corp_gr = SQLCA.GETITEMSTRING (1)
End IF

/* to-be w_loadingsystem.additem( "DatabaseConnect End" ) */
// IDLE TIMEOUT 설정(0=무제한)
idle (DEFAULT_IDLE_TIMEOUT_SEC)

gnv_vari.is_sys_id = 'SY'
gnv_vari.is_ipaddress = gnv_extfunc.of_getipaddress()		// IP Address
gnv_vari.is_macaddress = gnv_extfunc.of_getmacaddress()	// Mac Address

//IF	gnv_vari.is_macaddress='A0:A4:C5:51:E6:04'	Then
//	setJtier('DBNAME', 'icam_main')
//	IF	setJtier('URL', 'http://183.96.184.1:15700/jtier?')>0	Then
//		STRING	ls_sqlsyntax
//		aDS_jTier	lds_jtier
//
//		LONG	ll, ly
//
//		ls_sqlsyntax = " SELECT * " + &
//							" FROM   SJX0JB " + &
//							" ORDER BY BALH_CO "
//
//		SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
//		lds_jtier.SaveAs ('c:\temp\SJX0JB_LOAD.txt', Text!, TRUE, EncodingUTF16LE!)
//
//		ls_sqlsyntax = " SELECT * " + &
//							" FROM   SJM0JJ "
//
//		SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
//		lds_jtier.SaveAs ('c:\temp\SJM0JJ_LOAD.txt', Text!, TRUE, EncodingUTF16LE!)
//
//		ls_sqlsyntax = " SELECT * " + &
//							" FROM   SZM0FD "
//
//		SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
//		lds_jtier.SaveAs ('c:\temp\SZM0FD_LOAD.txt', Text!, TRUE, EncodingUTF16LE!)
//
//		FOR  lY = 2010 TO 2024
//			ls_sqlsyntax = " SELECT * " + &
//								" FROM   SCM0CJ_KAP " + &
//								" WHERE  BALH_IL BETWEEN '" + string (lY) + "0101' And '" + string (lY) + "0531'  "
//
//			SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
//			lds_jtier.SaveAs ('c:\temp\SCM0CJ_KAP_LOAD_' + string (ly) + '01.txt', Text!, TRUE, EncodingUTF16LE!)
//
//			ls_sqlsyntax = " SELECT * " + &
//								" FROM   SCM0CJ_KAP " + &
//								" WHERE  BALH_IL BETWEEN '" + string (lY) + "0601' And '" + string (lY) + "1231'  "
//
//			SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
//			lds_jtier.SaveAs ('c:\temp\SCM0CJ_KAP_LOAD_' + string (ly) + '06.txt', Text!, TRUE, EncodingUTF16LE!)
//		NEXT

//		ls_sqlsyntax = " SELECT * " + &
//							" FROM   SYM0YA_KAP "
//
//		SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
//		lds_jtier.SaveAs ('c:\temp\SYM0YA_KAP_LOAD.txt', Text!, TRUE, EncodingUTF16LE!)

//		FOR  ll = 1  TO  31
//			ls_sqlsyntax = " SELECT * " + &
//								" FROM   SJT1TG " + &
//								" WHERE  YMD = '2024.05." + string (ll,'00') + "' And length(koscom_cd)=6 "
//	
//			SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
//			lds_jtier.SaveAs ('c:\temp\SJT1TG_LOAD_202405' + string (ll,'00') + '.txt', Text!, TRUE, EncodingUTF16LE!)
//		NEXT
//	End IF
//End IF

/* mnpmod */
f_jtier_connect ()
IF	gaa.jtier_url='not connect'	Then
	messagebox ("확인", "jTier  환경설정 실패!", stopsign!)
	DISCONNECT;
	HALT CLOSE  // System CLOSE
End IF

event oue_LoginProcess()
end event

event oue_applicationclose();// 글로벌 변수 삭제
if isvalid(gnv_vari)			then Destroy gnv_vari
if isvalid(gnv_extfunc)		then Destroy gnv_extfunc
if isvalid(gnv_handle)		then Destroy gnv_handle
if isvalid(gnv_rolemenu)	then Destroy gnv_rolemenu
if isvalid(gnv_authority)	then Destroy gnv_authority
if isvalid(gnv_authorbtn)	then Destroy gnv_authorbtn
if isvalid(gnv_siteapi)		then Destroy gnv_siteapi
if isvalid(gnv_menu)			then Destroy gnv_menu
if isvalid(gnv_file)			then Destroy gnv_file
if isvalid(gnv_lang)			then Destroy gnv_lang

// 데이터베이스 연결 종료
Disconnect Using SQLCA;
end event

event oue_afterloginprocess();// 머리글
STRING	la_head[] = {'■','ㆍ','∴','※','…','√','⇒','◈','●','⊙','◇','▷','‥','☞','±','=','【】','「」','『』','《》','〔〕','〈〉'}
STRING	la[] = {'■','ㆍ','∴','※','…','√','⇒','◈','●','⊙','◇','▷','‥','☞','±','=','【','】','「','」','『','』'}
STRING	ls_corp_gr

LONG	ll

gds1 = CREATE fw_n_dso
gds1.DataObject = '머리글'
// 첫번째 SQLCA은 저장하지 않음.
FOR  ll = 1  TO  22
   gds1.insertrow (1)
   gds1.object.c [1] = la_head [ll]
   gds1.object.t [1] = 23 - ll
NEXT
gds1.object.u [1] = 99
gds1.Sort ()

gds2 = CREATE fw_n_dso
gds2.DataObject = '머리글'
gds2.SetTransObject (SQLCA)
IF gds2.retrieve (gaa.login, 2)=0  Then
   FOR  ll = 22  TO  1  STEP -1
      gds2.insertrow (1)
      gds2.object.sb_cd [1] = gaa.login
      gds2.object.n [1] = 2
      gds2.object.c [1] = la [ll]
      gds2.object.t [1] = 0
      gds2.object.u [1] = 0
   NEXT
   gds2.object.t [1] = -3
   gds2.object.t [2] = 3
   gds2.Sort ()
End IF

gds3 = CREATE fw_n_dso
gds3.DataObject = '머리글'
gds3.SetTransObject (SQLCA)
IF gds3.retrieve (gaa.login, 3)=0  Then
   FOR  ll = 22  TO  1  STEP -1
      gds3.insertrow (1)
      gds3.object.sb_cd [1] = gaa.login
      gds3.object.n [1] = 3
      gds3.object.c [1] = la [ll]
      gds3.object.t [1] = 0
      gds3.object.u [1] = 0
   NEXT
   gds3.object.t [1] = -3
   gds3.object.t [2] = -3
   gds3.object.t [3] = 3
   gds3.Sort ()
End IF

gds4 = CREATE fw_n_dso
gds4.DataObject = '머리글'
gds4.SetTransObject (SQLCA)
IF gds4.retrieve (gaa.login, 4)=0  Then
   FOR  ll = 22  TO  1  STEP -1
      gds4.insertrow (1)
      gds4.object.sb_cd [1] = gaa.login
      gds4.object.n [1] = 4
      gds4.object.c [1] = la [ll]
      gds4.object.t [1] = 0
      gds4.object.u [1] = 0
   NEXT
   gds4.object.t [1] = -3
   gds4.object.t [2] = -3
   gds4.object.t [3] = -3
   gds4.object.t [4] = 3
   gds4.Sort ()
End IF

// 로그인이 완료된 이후 프로세스를 기술한다
If gnv_vari.is_login_yn = 'Y' Then
	Open(iw_mainframe, gnv_vari.w_frame)
End If

/* to-be w_loadingsystem.additem( "oue_afterloginprocess end" ) */
end event

event oue_loginprocess();STRING	ls_yes

SELECT t1.customer_gr
     , t2.e_mail
     , t1.company_name
  INTO :gaa.customer_gr
     , :gaa.corp_e_mail
     , :gaa.corp_nm
  FROM SZX0AA t1
     , SZX0AB t2
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t2.CORP_GR = t1.CORP_GR
   AND t2.ymd     = (SELECT MAX(ymd)
                       FROM SZX0AB ta
                      WHERE ta.CORP_GR = :gaa.CORP_GR) ;

gaa.customer_gr = SQLCA.GETITEMSTRING (1)
gaa.corp_e_mail = SQLCA.GETITEMSTRING (2)
gaa.corp_nm     = SQLCA.GETITEMSTRING (3)

gaa.fund_cd = ProfileString (gaa.config, 'INIT Value', 'fund_cd', '')
gaa.login   = gnv_vari.of_getprofile ('login.last.user_id', '')

SELECT TO_ENCRYPTS ('Yes')
  INTO :ls_yes
  FROM FW_USER_MST t1
 WHERE t1.CORP_GR    = '2200'
	AND t1.enc_e_mail = :gaa.login ;
IF SQLCA.SQLCode ()=0 THEN gaa.aams = TRUE

OPEN (iw_login, gnv_vari.w_login)

/* to-be w_loadingsystem.additem( "oue_loginprocess End" ) */

// 로그인 윈도우가 MDI 형태이기 때문에 윈도우 종료 후 현재 스크립트로 리턴되지 않음.
// 따라서, 이후 스크립트는 ue_afterloginprocess() 이벤트에서 기술한다.
// 로그인을 수행하는 오브젝트는 로그인 완료 후 gnv_vari 에 is_login_yn='Y' (of_checkuserauthority 함수 참고)
// 항목을 추가 하고 ue_afterloginprocess() 이벤트를 반드시 호출해 줘야 함.
end event

event oue_applicationidle();// Application Idle Timeout
messagebox ('Notice', "장시간 프로그램을 사용하지 않아 프로그램을 종료합니다")
RegistryDelete ("HKEY_CURRENT_USER\Software\AAMS\Version\File", "downfile")
gfp.killprocess ('aams.exe')
end event

event oue_logoutprocess();// 로그아웃 프로세스를 기술합니다
// MDI 윈도우 CLOSE -> 로그인 페이지 이동
IF IsValid(iw_mainframe) THEN
//	// 사용자 로그아웃 정보 로그 생성
//	inv_logger.of_writelog_logout(gnv_vari.is_user_id, gnv_vari.is_user_nm)
	RegistryDelete ("HKEY_CURRENT_USER\Software\AAMS\Version\File", "downfile")

	// 기 로그인 정보 clear
	gnv_vari.is_login_yn	= 'N'
	gnv_vari.idtm_login	= null_dt
	gnv_vari.is_user_id	= ''
	gnv_vari.is_user_nm	= ''

	IF gnv_vari.getclienttype='PB'	Then
		Open(iw_login, gnv_vari.w_login)
		Close(iw_mainframe)
	Else
		Close(iw_mainframe)
		Open(iw_login, gnv_vari.w_login)
	End IF
End IF
end event

event oue_systemerror();gw_mdi.of_loadingwait(false)

string	ls_title, ls_errormsg

ls_title = "SYSTEM ERROR"
ls_errormsg = "DATETIME : " + string(today(), "yyyy.mm.dd hh:mm:ss") + "~r~n"
ls_errormsg += "ERROR NUMBER : " + string(error.number) + "~r~n"
ls_errormsg += "ERROR MESSAGE : " + error.text + "~r~n"
ls_errormsg += "WINDOW/MENU : " + error.windowmenu + "~r~n"
ls_errormsg += "OBJECT : " + error.object + "~r~n"
ls_errormsg += "EVENT : " + error.objectevent + "~r~n"
ls_errormsg += "LINE : [" + string(error.line) + "]~r~n"
ls_errormsg += "~r~n"
ls_errormsg += "오류를 시스템 관리부서에 전달하고 진행하시겠습니까?~r~n( '아니요'는 시스템 종료입니다. )"

IF	isValid (gnv_vari)	Then
	gnv_vari.iserror2window = error.windowmenu
	fw_f_collect4error(ls_errormsg)
End IF
end event

public function string of_thisname ();return 'pf_n_appmanager'
end function

public function boolean of_checksinglesignon ();// SSO 로그인 정보 확인 로직
// SSO 제품에 따라 제공되는 샘플 로직을 참고로 작성하세요
// 아래 로직은 교육과학기술부 전사서명인증용 샘플 입니다

/* to-be w_loadingsystem.additem( "SSO CHECK start" ) */

// XMLHTTP OleObject 생성
Integer	li_rc
String	ls_status_text, ls_response_text, ls_url
Long		ll_status_code

inv_xmlhttp = CREATE oleobject
li_rc = inv_xmlhttp.ConnectToNewObject("Msxml2.XMLHTTP")
//messagebox('li_rc', li_rc)

If li_rc < 0 then
	choose Case li_rc
		Case -1;  messagebox('[' + this.classname() + '] ConnectToObject', 'Invalid Call: the argument is the Object property of a control')
		Case -2;  messagebox('[' + this.classname() + '] ConnectToObject', 'Class name not found')
		Case -3;  messagebox('[' + this.classname() + '] ConnectToObject', 'Object could not be created')
		Case -4;  messagebox('[' + this.classname() + '] ConnectToObject', 'Could not connect to object')
		Case -9;  messagebox('[' + this.classname() + '] ConnectToObject', 'Other error')
		Case -15;  messagebox('[' + this.classname() + '] ConnectToObject', 'COM+ is not loaded on this computer')
		Case -16;  messagebox('[' + this.classname() + '] ConnectToObject', 'Invalid Call this function not applicable')
	End choose
	RETURN FALSE
End If

ls_url = gnv_vari.AppeonGetIEurl //AppeonGetIEURL ( )
ls_url = Left(ls_url, Pos(ls_url,"/",8))

inv_xmlhttp.Open("POST",ls_url + "sso/getsession.jsp", false)
inv_xmlhttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8")

inv_xmlhttp.SEnd()

// no need to check the result, cuase http calling is in async mode.

//Get our response
ls_status_text = inv_xmlhttp.StatusText
ll_status_code = inv_xmlhttp.Status

//Check HTTP Response code for errors
If ll_status_code >= 300 then
	MessageBox("HTTP POST Request Failed", 'SSO 진행 실패 / ' + ls_response_text)
	RETURN FALSE
Else
	//Get the response we received from the web server
	ls_response_text = inv_xmlhttp.ResponseText
	//MessageBox("POST Request Succeeded", ls_response_text)
End If

String	ls_user_id = ""
ls_user_id = Mid(ls_response_text, POS(ls_response_text, "{") + 1, POS(ls_response_text,"}") - POS(ls_response_text, "{") - 1)

If fw_f_nvls(ls_user_id, '') <> '' THEN
	// 사용자 권한 체크
	Choose Case gnv_authority.of_checkUserAuthority(ls_user_id, 'SSO')
		Case -1, 0
			Messagebox("Error", "SSO 권한체크 실패")
			Halt Close
	End choose
	Return TRUE
Else
	halt Close
End If
end function

private function boolean of_isrunningindebuggingmode ();//Find out if the application is being run in PowerBuilder debugger. We
//look for a PowerBuilder MDI frame.
//If found, look for MDIClient. If found, look for window with title
//beginning with "Debugger" If found -> Debug!

long ll_Desktop,ll_Child, ll_child2, ll_child3

string ls_ClassName, ls_WindowName

Constant long GW_HWNDFIRST = 0
Constant long GW_HWNDLAST = 1
Constant long GW_HWNDNEXT = 2
Constant long GW_HWNDPREV = 3
Constant long GW_OWNER = 4
Constant long GW_CHILD = 5
Constant long GW_MAX = 5

Constant long MAX_WIDTH = 255

ll_Desktop = gnv_extfunc.GetDesktopWindow()

ll_Child = gnv_extfunc.GetWindow( ll_Desktop, GW_CHILD )

DO WHILE (ll_Child > 0)
	ls_ClassName = Space(MAX_WIDTH)
	gnv_extfunc.GetClassNameA( ll_Child, ls_ClassName, MAX_WIDTH )
	
	// PowerBuilder Main window. The whole name would be for PB11 "PBFRAME110".
	IF Left(ls_classname, 7) = "PBFRAME" THEN
		// PowerBuilder Main window found. Now look for MDI client
		ll_Child2 = gnv_extfunc.GetWindow( ll_Child, GW_CHILD )
		DO WHILE (ll_Child2 > 0)
			ls_ClassName = Space(MAX_WIDTH)
			gnv_extfunc.GetClassNameA( ll_Child2, ls_ClassName, MAX_WIDTH )
			IF ls_classname = "MDIClient" THEN
				// We get closer, the MDI Client was found. Now look for the debugger sheet; use the Window title, not the class
				ll_Child3 = gnv_extfunc.GetWindow( ll_Child2, GW_CHILD )
				DO WHILE (ll_Child3 > 0)
					ls_WindowName = Space(MAX_WIDTH)
					gnv_extfunc.GetWindowTextA( ll_Child3, ls_WindowName, MAX_WIDTH )
					IF Left(ls_WindowName, 8) = "Debugger" THEN
						RETURN true
					END IF
					ll_Child3 = gnv_extfunc.GetWindow( ll_Child3, GW_HWNDNEXT )
				LOOP
			END IF
			ll_Child2 = gnv_extfunc.GetWindow( ll_Child2, GW_HWNDNEXT )
		LOOP
	END IF
	ll_Child = gnv_extfunc.GetWindow( ll_Child, GW_HWNDNEXT )
LOOP

RETURN false

end function

public function string of_getpbrunningmode ();CONSTANT String IS_ENV_EXE = "exe"
CONSTANT String IS_ENV_PB = "pb"
CONSTANT String IS_ENV_DEBUG = "debug"

String ls_enviroment

// Finf out the environment.
IF Handle(GetApplication()) = 0 THEN
	IF of_isrunningindebuggingmode() THEN
		ls_enviroment = IS_ENV_DEBUG
	ELSE
		ls_enviroment = IS_ENV_PB
	END IF
ELSE
	ls_enviroment = IS_ENV_EXE
END IF

RETURN ls_enviroment
end function

on pf_n_appmanager.create
call super::create
end on

on pf_n_appmanager.destroy
call super::destroy
end on

