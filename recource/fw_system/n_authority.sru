forward
global type n_authority from nonvisualobject
end type
end forward

global type n_authority from nonvisualobject
end type
global n_authority n_authority

type prototypes

end prototypes

type variables
Public:
	fw_n_dso	ids_rolecat
	fw_n_dso	ids_userinfo

	String	is_userrole[]
	String	is_memb_code[]

	String	is_inq_userrole[]
	String	is_inq_memb_code[]
end variables

forward prototypes
public function long of_setuserinfo (string as_user_id)
public function string of_getuserinfo (string as_columnname)
public function string of_thisname ()
public function integer of_setalluserrole (string as_user_id)
public function integer of_setsystemuserrole (string as_user_id)
public function integer of_checkuserauthority (string as_user_id, string as_user_pwd)
public function integer of_setaction4database (string as_dbcd)
public function integer of_setsystemcolor ()
public function long of_getuserroleinfo (string as_memb_code1, string as_memb_code2)
end prototypes

public function long of_setuserinfo (string as_user_id);// pf_user_mst 사용자 정보를 보관한다
STRING	ls_syntax, ls_query, ls_errmsg
LONG	ll_rtn

IF isvalid(ids_userinfo) THEN DESTROY ids_userinfo

ls_query = "select * from fw_user_mst where corp_gr = '" + gaa.corp_gr + "' and user_id = '" + as_user_id + "'"
ll_rtn = SQLCA.sql2ds ('setuserinfo', ls_query, ids_userinfo, 'xml')

RETURN ll_rtn
end function

public function string of_getuserinfo (string as_columnname);string ls_coltype
string ls_retval

setnull(ls_retval)
if ids_userinfo.rowcount() = 0 then return ls_retval

ls_coltype = ids_userinfo.describe(as_columnname + '.coltype')
choose case left(ls_coltype, 5)
	case 'char('
		ls_retval = ids_userinfo.getitemstring(1, as_columnname)
	case 'date'
		ls_retval = string(ids_userinfo.getitemDate(1, as_columnname), 'yyyy-mm-dd')
	case 'datet'
		ls_retval = string(ids_userinfo.getitemDateTime(1, as_columnname), 'yyyy-mm-dd hh:mm:ss')
	case 'decim'
		ls_retval = string(ids_userinfo.getitemDecimal(1, as_columnname))
	case 'int', 'long', 'ulong', 'numbe', 'real'
		ls_retval = string(ids_userinfo.getitemnumber(1, as_columnname))
	case 'time', 'times'
		ls_retval = string(ids_userinfo.getitemTime(1, as_columnname), 'hh:mm:ss')
	case '!', '?'
		messagebox('of_getuserinfo()', '[' + as_columnname + '] 존재하지 않는 컬럼명 입니다')
end choose

if isnull(ls_retval) then ls_retval = ''

return ls_retval
end function

public function string of_thisname ();return 'n_authority'

end function

public function integer of_setalluserrole (string as_user_id);STRING	ls_user_tbl_col, ls_user_tbl_data, ls_sqlsyntax, ls_SqlErrText, ls_temp[8]

LONG	ll_role_cat_no, ll_row_cnt

INTEGER	i

is_inq_memb_code [1] = gaa.corp_gr
is_inq_memb_code [2] = as_user_id

STRING	ls_userrole[], ls_role_nm[]

fw_n_dso lds_role_info

lds_role_info = CREATE fw_n_dso
lds_role_info.dataobject = 'fw_d_userole_list'
lds_role_info.settransobject(SQLCA)
ll_row_cnt = lds_role_info.retrieve (gnv_vari.is_sys_id, is_inq_memb_code[1], is_inq_memb_code[2])
for i = 1 to ll_row_cnt
   ls_userrole[i] = lds_role_info.getitemstring(i, 'role_no')
   ls_role_nm[i]  = lds_role_info.getitemstring(i, 'role_nm')
next

is_inq_userrole = ls_userrole

IF ll_row_cnt=0   Then
   RETURN -1
End IF

RETURN ll_row_cnt
end function

public function integer of_setsystemuserrole (string as_user_id);LONG	ll_row_cnt

if	gaa.aams	Then
	is_memb_code [1] = '2200'
else
	is_memb_code [1] = gaa.corp_gr
end if;
is_memb_code [2] = as_user_id

ll_row_cnt = of_getuserroleinfo (is_memb_code[1], is_memb_code[2])
IF ll_row_cnt=0   Then
   Messagebox('Notice', '메뉴 권한에 없습니다 1')
   RETURN -1
End IF

is_userrole = gnv_vari.role_no
gnv_rolemenu = CREATE pf_n_rolemenu /* to-be gnv_rolemenu Instance service start */

LONG	ll_ret	/* to-be user ALL menu fw_n_dso update */

ll_ret = gnv_rolemenu.of_fulllmenudata (is_memb_code)
IF ll_ret<1 Then
   Messagebox('Notice', '메뉴 권한에 없습니다 2')
   RETURN -1
End IF

RETURN 1
end function

public function integer of_checkuserauthority (string as_user_id, string as_user_pwd);// 사용자 권한 확인 및 사용자 정보 설정
STRING	ls_old, ls_pw, ls_watchman, ls_admin, ls_Manager, ls_bookmark

ls_old = gaa.CORP_GR

SELECT user_id
     , user_nm
     , NVL(TO_CHAR (out_ymd,'yyyymmdd'), '99991231')
     , NVL(dept_cd,'A420')
     , dept_nm
     , in_ymd
     , out_ymd
     , CORP_GR
     , to_decrypts (enc_pw)
     , admin_yn
     , manager_yn
     , watchman_yn
	  , bookmark_start
  INTO :gnv_vari.is_user_id
     , :gnv_vari.is_user_nm
     , :gnv_vari.is_dept_dt
     , :gnv_vari.is_dept_cd
     , :gnv_vari.is_dept_nm
     , :gnv_vari.idt_in_ymd
     , :gnv_vari.idt_out_ymd
     , :gaa.CORP_GR
     , :ls_pw
     , :ls_Admin
     , :ls_Manager
     , :ls_watchman
	  , :ls_bookmark
  FROM FW_USER_MST la
 WHERE la.enc_e_mail = TO_ENCRYPTS(:as_user_id) ;

Choose CASE SQLCA.sqlcode ()
   CASE -1
      MESSAGEBOX ('Check', 'Unable to proceed with login process due to DataBase error~r~n' + SQLCA.sqlerrtext())
      RETURN -1
   CASE 100
      RETURN 0
End Choose

gnv_vari.is_dept_jc   = null_s
gnv_vari.is_dept_jcnm = null_s

gnv_vari.is_user_id     = SQLCA.GETITEMSTRING (1)
gnv_vari.is_user_nm     = SQLCA.GETITEMSTRING (2)
gnv_vari.is_dept_dt     = SQLCA.GETITEMSTRING (3)
gnv_vari.is_dept_dt     = SQLCA.GETITEMSTRING (4)
gnv_vari.is_dept_cd     = SQLCA.GETITEMSTRING (5)
gnv_vari.idt_in_ymd     = SQLCA.getitemdatetime (6)
gnv_vari.idt_out_ymd    = SQLCA.getitemdatetime (7)

gaa.CORP_GR = SQLCA.GETITEMSTRING (8)
ls_pw       = SQLCA.GETITEMSTRING (9)
ls_Admin    = SQLCA.GETITEMSTRING (10)
ls_Manager  = SQLCA.GETITEMSTRING (11)
ls_watchman = SQLCA.GETITEMSTRING (12)

IF gaa.CORP_GR = '2200' Then
   gaa.CORP_GR = ls_old
   gaa.aams    = true
   mo_.setmessagelevel ('ADMIN')// 에러메세지 상세여부
ELSE
   gaa.aams = false
   mo_.setmessagelevel ('USER')// 에러메세지 상세여부
END IF

gaa.admin    = (ls_Admin = 'Y')
gaa.bookmark = (ls_bookmark = 'Y')
IF gaa.admin OR gaa.aams   Then
   gaa.title = 'KFP ( ' + gaa.CORP_GR + ' ' + gaa.corp_nm + ' ) 자문계좌관리   [ 접속서버 ' + gaa.jTier_dbname + ' ]'
ELSE
   gaa.title = 'AAMS 자문계좌관리 시스템 ( ' + gaa.corp_nm + ' )'
END IF
gaa.manager  = (ls_Manager = 'Y' OR gaa.admin)
gaa.watchman = (ls_watchman = 'Y')

// 사용자 정보 보관
// 권한 테이블이 바뀌더라도, 아래 login_yn, login_dt, user_id, user_nm
// 5개 항목은 Session에 필수 저장 하세요
gnv_vari.is_login_yn = 'Y'
gnv_vari.idtm_login  = fw_f_getymdhh24miss4d ()
gnv_vari.is_login_dt = STRING (gnv_vari.idtm_login, 'yyyymmdd')

// 사용자 권한 설정
IF this.of_setsystemUserRole(gnv_vari.is_user_id) < 0 Then
   RETURN -1
END IF

IF of_setsystemcolor() = -1 THEN RETURN -1

UPDATE FW_USER_MST la  
   SET last_connect = sysdate
 WHERE la.enc_e_mail = TO_ENCRYPTS(:as_user_id) ;

IF ls_pw<>as_user_pwd THEN RETURN 3
RETURN 1 // 비밀번호 통과
end function

public function integer of_setaction4database (string as_dbcd);//If not(as_dbcd = 'hi') Then sqlca.disconnectdb()
//Choose Case as_dbcd
//	Case 'hi'
//		sqlca.disconnectdb()
//		sqlca.setcachebyinfo( "auto", "hsdbhi")
//		sqlca.connectdb('hi002', 'hwasung')
//	Case 'ha'
//		sqlca.setcachebyinfo( "ASE", "hsdbha")
//		sqlca.connectdb('hsa02', 'hwasung')
//	Case 'hm'
//		sqlca.setcachebyinfo( "ASE", "hsdbhm")
//		sqlca.connectdb('hsm01', 'hwasung')
//	Case 'hh'
//		sqlca.setcachebyinfo( "ASE", "hsdbhh")
//		sqlca.connectdb('hh001', 'hwasung')
//	Case 'hr'
//		sqlca.setcachebyinfo( "ASE", "hsdbhr")
//		sqlca.connectdb('hr002', 'hwasung')
//End Choose

Return 1
end function

public function integer of_setsystemcolor ();fw_n_dso	lds_syscolor
lds_syscolor = Create fw_n_dso
lds_syscolor.dataobject = 'fw_d_syscolor_ds1'
lds_syscolor.settransobject( sqlca )

string	ls_vari_nm
long	ll_ret, ll_i
long	ll_r, ll_g, ll_b
ll_ret = lds_syscolor.retrieve(gnv_vari.is_sys_id)

If ll_ret > 0 Then
	for ll_i = 1 to ll_ret
		ls_vari_nm = lds_syscolor.getitemstring(ll_i, 'vari_nm')
		If fw_f_nvls(ls_vari_nm, '') = '' Then continue
		ll_r	= lds_syscolor.getitemnumber(ll_i, 'rgb_r')
		ll_g	= lds_syscolor.getitemnumber(ll_i, 'rgb_g')
		ll_b	= lds_syscolor.getitemnumber(ll_i, 'rgb_b')
		Choose Case ls_vari_nm
			Case 'basefontcolor'
				gnv_vari.basefontcolor = rgb(ll_r, ll_g, ll_b)
			Case 'framebackcolor'
				gnv_vari.framebackcolor = rgb(ll_r, ll_g, ll_b)
				
			Case 'mdi2topmenubackcolor'
				gnv_vari.mdi2topmenubackcolor = rgb(ll_r, ll_g, ll_b)
			Case 'mdi2topmenuselected4fontcolor'
				gnv_vari.mdi2topmenuselected4fontcolor = rgb(ll_r, ll_g, ll_b)
			case 'mdi2topmenuselected4backcolor'
				gnv_vari.mdi2topmenuselected4backcolor = rgb(ll_r, ll_g, ll_b)		
			Case 'mdi2submenuselected4fontcolor'
				gnv_vari.mdi2submenuselected4fontcolor = rgb(ll_r, ll_g, ll_b)
			case 'mdi2submenuselected4backcolor'
				gnv_vari.mdi2submenuselected4backcolor = rgb(ll_r, ll_g, ll_b)
			Case 'mdi2topmenunotselected4fontcolor'
				gnv_vari.mdi2topmenunotselected4fontcolor = rgb(ll_r, ll_g, ll_b)
			Case 'mdi2submenunotselected4fontcolor'
				gnv_vari.mdi2submenunotselected4fontcolor = rgb(ll_r, ll_g, ll_b)

			Case 'sheettab2selected4fontcolor'
				gnv_vari.sheettab2selected4fontcolor = 'rgb('+ string(ll_r) + ', ' + string(ll_g) + ', ' + string(ll_b) + ')'
			Case 'sheettab2notselected4fontcolor'
				gnv_vari.sheettab2notselected4fontcolor = 'rgb('+ string(ll_r) + ', ' + string(ll_g) + ', ' + string(ll_b) + ')'

			Case 'mdi2xpmenubackcolor'
				gnv_vari.mdi2xpmenubackcolor = rgb(ll_r, ll_g, ll_b)
			Case 'mdi2xpmenudetailcolor'
				gnv_vari.mdi2xpmenudetailcolor = rgb(ll_r, ll_g, ll_b)
			Case 'mdi2xpmenu4treelevelcolor'
				gnv_vari.mdi2xpmenu4treelevelcolor = rgb(ll_r, ll_g, ll_b)
				
			Case 'sheetbackcolor'
				gnv_vari.sheetbackcolor = rgb(ll_r, ll_g, ll_b)
				
			Case 'setlist4backcolor'
				gnv_vari.setlist4backcolor = rgb(ll_r, ll_g, ll_b)
			Case 'setcondbackcolor'
				gnv_vari.setcondbackcolor = rgb(ll_r, ll_g, ll_b)
			Case 'setfreebackcolor'
				gnv_vari.setfreebackcolor = rgb(ll_r, ll_g, ll_b)
			Case 'bordernor2topcolor'
				gnv_vari.bordernor2topcolor = rgb(ll_r, ll_g, ll_b)
			Case 'bordernor2bottomcolor'
				gnv_vari.bordernor2bottomcolor = rgb(ll_r, ll_g, ll_b)
			Case 'bordernor2leftcolor'
				gnv_vari.bordernor2leftcolor = rgb(ll_r, ll_g, ll_b)
			Case 'bordernor2rightcolor'
				gnv_vari.bordernor2rightcolor = rgb(ll_r, ll_g, ll_b)
			Case 'borderfocuscolor'
				gnv_vari.borderfocuscolor = rgb(ll_r, ll_g, ll_b)
			Case 'alternatefirstrowcolor'
				gnv_vari.alternatefirstrowcolor = rgb(ll_r, ll_g, ll_b)
			Case 'alternatesecondrowcolor'
				gnv_vari.alternatesecondrowcolor = rgb(ll_r, ll_g, ll_b)
			Case 'setclearselectcolor'
				gnv_vari.setclearselectcolor = rgb(ll_r, ll_g, ll_b)
			Case 'setcolfocusbackcolor'
				gnv_vari.setcolfocusbackcolor = rgb(ll_r, ll_g, ll_b)
			Case 'setrectfocuscolor'
				gnv_vari.setrectfocuscolor = rgb(ll_r, ll_g, ll_b)
			Case 'setrectnormalcolor'
				gnv_vari.setrectnormalcolor = rgb(ll_r, ll_g, ll_b)
			Case 'disabledcolbgcolor'
				gnv_vari.disabledcolbgcolor = rgb(ll_r, ll_g, ll_b)
			Case 'editablecolbgcolor'
				gnv_vari.editablecolbgcolor = rgb(ll_r, ll_g, ll_b)
				
			Case 'sort2back4color'
				gnv_vari.sort2back4color = rgb(ll_r, ll_g, ll_b)
			Case 'sort2asc4color'
				gnv_vari.sort2asc4color = rgb(ll_r, ll_g, ll_b)
			Case 'sort2desc4color'
				gnv_vari.sort2desc4color = rgb(ll_r, ll_g, ll_b)
			Case 'sort2arrow4color'
				gnv_vari.sort2arrow4color = rgb(ll_r, ll_g, ll_b)
			Case 'filter2font4color'
				gnv_vari.filter2font4color = rgb(ll_r, ll_g, ll_b)
			Case 'filter2sign4color'
				gnv_vari.filter2sign4color = rgb(ll_r, ll_g, ll_b)
				
			Case 'setlist4headercolor'
				gnv_vari.setlist4headercolor = rgb(ll_r, ll_g, ll_b)
			Case 'setlist4summarycolor'
				gnv_vari.setlist4summarycolor = rgb(ll_r, ll_g, ll_b)
			Case 'setlist4footercolor'
				gnv_vari.setlist4footercolor = rgb(ll_r, ll_g, ll_b)
			Case 'setlist4goupcolor1'
				gnv_vari.setlist4goupcolor1 = rgb(ll_r, ll_g, ll_b)
			Case 'setlist4goupcolor2'
				gnv_vari.setlist4goupcolor2 = rgb(ll_r, ll_g, ll_b)
			Case 'setlist4headerfontcolor'
				gnv_vari.setlist4headerfontcolor = rgb(ll_r, ll_g, ll_b)
			Case 'setlist4summaryfontcolor'
				gnv_vari.setlist4summaryfontcolor = rgb(ll_r, ll_g, ll_b)
			Case 'setlist4footerfontcolor'
				gnv_vari.setlist4footerfontcolor = rgb(ll_r, ll_g, ll_b)
			case 'setlist4mouseovercolor'
				gnv_vari.setlist4mouseovercolor = rgb(ll_r, ll_g, ll_b)
				
			Case 'pointcolor4objfont_a'
				gnv_vari.pointcolor4objfont_a = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4objfont_b'
				gnv_vari.pointcolor4objfont_b = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4objfont_c'
				gnv_vari.pointcolor4objfont_c = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4objfont_d'
				gnv_vari.pointcolor4objfont_d = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4objfont_e'
				gnv_vari.pointcolor4objfont_e = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4row_a'
				gnv_vari.pointcolor4row_a = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4row_b'
				gnv_vari.pointcolor4row_b = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4row_c'
				gnv_vari.pointcolor4row_c = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4row_d'
				gnv_vari.pointcolor4row_d = rgb(ll_r, ll_g, ll_b)
			Case 'pointcolor4row_e'
				gnv_vari.pointcolor4row_e = rgb(ll_r, ll_g, ll_b)
		End Choose
	next
Else
	messagebox ('fw_syscolor table', 'table 확인')
	Return -1
End If

Return 1

end function

public function long of_getuserroleinfo (string as_memb_code1, string as_memb_code2);STRING	ls_role_no, ls_role_nm, ls_sqlsyntax

LONG	ll_rollcnt = 0, ll_i = 0, lR

aDS_jTier   lds_jtier

ls_sqlsyntax = "   Select distinct a.role_no " &
             + "        , b.role_nm " &
             + "     From fw_role_memb a " &
             + "        , fw_role_mst  b " &
             + "   Where  a.sys_id     = '" + gnv_vari.is_sys_id + "'" &
             + "     and  a.memb_code1 = '" + as_memb_code1 + "' " &
             + "     and  (a.memb_code2 is null OR a.memb_code2 = '" + as_memb_code2 + "') " &
             + "     and  a.sys_id     = b.sys_id " &
             + "     and  a.role_no    = b.role_no "

//::clipboard (ls_sqlsyntax)
//messagebox('sqlsyntax',ls_sqlsyntax)

lR = SQLCA.sql2ds ('getuserroleinfo', ls_sqlsyntax, lds_jtier, 'xml')
FOR  ll_i = 1  TO  lR
   ls_role_no = lds_jtier.getitemstring (ll_i, 1)
   ls_role_nm = lds_jtier.getitemstring (ll_i, 2)
   IF fw_f_nvls(ls_role_no, '')<>'' Then
      ll_rollcnt ++
      gnv_vari.role_no[ll_rollcnt]  = ls_role_no
      gnv_vari.role_nm[ll_rollcnt]  = ls_role_nm
   End IF
NEXT

RETURN ll_rollcnt
end function

on n_authority.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_authority.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

