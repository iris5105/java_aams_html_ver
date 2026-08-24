forward
global type aams from application
end type
global n_tr_a sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
pf_n_appmanager	gnv_appmgr
pf_n_rolemenu		gnv_rolemenu		/* instance -> global variable trans */
pf_n_buttonrole	gnv_authorbtn		/* instance -> global variable */

n_variables		gnv_vari
n_extfunc		gnv_extfunc
fw_n_handle		gnv_handle
n_authority		gnv_authority
fw_n_dwcache	gnv_dwcache
n_siteapi		gnv_siteapi
n_menu			gnv_menu
fw_n_file		gnv_file
fw_n_lang		gnv_lang

w_mdi4framelv2	gw_mdi

//-------------------------

n_jtier_method	mo_
n_process		gfp
n_resql			gre

STR_AAMS		gaa

//머리글용
ads_jTier	gds, gds1, gds2, gds3, gds4

//SQL문 조정용
STRING	ia [] = {'h','t','f','g','d','p','u','k','r','x','y','w','v','z','b','c','m','s','a','e'}, ia_c1 []
STRING	ga_select [], is_asis_table, is_asis_alias, is_tobe_table, is_tobe_write, is_path_table, is_intg_ast_tc
STRING	ia_order [] = {'CORP_GR','API_KEY','JC_JOIN','FUND_CD','YMD','TR_YMD','GYUL_YMD','SANGHW_YND','CHG_YMD','JM_GR','GB','BALH_CO','JM_CD','SJ_CD','CASH_CD','CURRENCY','TR_SEQ','TR_CD','SEQ_NO','SEQ','TR_SEQ','TRUSTEE','GWAMOK','TR_CO_CD'}
LONG		gl_select_step, gl_select, gst_row
BOOLEAN	sql_comment

// Null Setting 변수
STRING	Null_s, null_a[], debug_step[]
DATE		Null_d
DateTime	Null_dt
LONG		Null_l
DEC		Null_dc
INT		Null_i
WINDOW	null_w
end variables
global type aams from application
string appname = "aams"
end type
global aams aams

type prototypes
FUNCTION Long ShellExecute (Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) LIBRARY "shell32.dll" ALIAS FOR "ShellExecuteW"

FUNCTION ulong GetDesktopWindow() LIBRARY "user32.dll"
FUNCTION ulong GetWindow(ulong hwnd, uint fuDirection) LIBRARY "user32.dll"
FUNCTION int GetKeyState(int keystatus) LIBRARY "user32.dll"

FUNCTION ulong FindWindow(ref string  classname, ref string windowname) LIBRARY "user32.dll" ALIAS FOR "FindWindowA;ansi"
FUNCTION int GetClassNameA(ulong hwnd, ref string  lpClassName, int length) LIBRARY "user32.dll" alias for "GetClassNameA;ansi"
FUNCTION int GetWindowTextA(ulong hwnd,  ref string wintext, int length) LIBRARY "user32.dll" alias for "GetWindowTextA;ansi"
end prototypes

on aams.create
appname="aams"
message=create message
sqlca=create n_tr_a
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on aams.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event close;SetProfileString (gaa.config, 'INIT Value', 'fund_cd', gaa.fund_cd)
IF	isvalid (gds2)	Then
	gds2.UPDATE ()
	gds3.UPDATE ()
	gds4.UPDATE ()
End IF

mo_.Dynamic event destructor_pre()
DESTROY	mo_
DESTROY	gaa.getcode

gnv_appmgr.Event oue_applicationclose()
Destroy gnv_appmgr
end event

event open;/* yjs */
mo_ = CREATE n_jTier_method
gds = CREATE fw_n_dso
gfp = CREATE n_process
gre = CREATE n_resql

gaa.pbr = f_replace (GetCurrentDirectory (), 'kernel','')
gaa.config = gaa.pbr + 'kernel\fw_config.ini'

gaa.excel  = gaa.pbr + '(Excel)\'  ; IF NOT DirectoryExists (gaa.excel) THEN CreateDirectory (gaa.excel)
gaa.xlsx   = gaa.pbr + '재산현황\' ; IF NOT DirectoryExists (gaa.xlsx)  THEN CreateDirectory (gaa.xlsx)
gaa.pdf    = gaa.pbr + '(PDF)\'    ; IF NOT DirectoryExists (gaa.pdf)   THEN CreateDirectory (gaa.pdf)
gaa.temp   = gaa.pbr + '(TEMP)\'   ; IF NOT DirectoryExists (gaa.temp)  THEN CreateDirectory (gaa.temp)

IF NOT DirectoryExists ('c:\up')   		THEN CreateDirectory ('c:\up' )
IF NOT DirectoryExists ('c:\down') 		THEN CreateDirectory ('c:\down' )

gaa.getcode = CREATE u_DynamicCodeSearch

SetNull (null_s)
SetNull (null_d)
SetNull (null_dt)
SetNull (null_l)
SetNull (null_dc)
SetNull (null_i)

/* yjs end */
// Application Open 이벤트를 수정하면 Full Build가 수행되므로,
// pf_n_appmanager.oue_ApplicationOpen() 이벤트를 사용합니다
gnv_appmgr = create pf_n_appmanager
gnv_appmgr.event oue_applicationopen (commandline)
end event

event idle;gnv_appmgr.event oue_applicationidle()
end event

event systemerror;gnv_appmgr.Event oue_systemerror()
end event

