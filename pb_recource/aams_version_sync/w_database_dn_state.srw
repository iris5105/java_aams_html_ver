forward
global type w_database_dn_state from window
end type
type uo_check from ez_u_funtion within w_database_dn_state
end type
type p_loading from picture within w_database_dn_state
end type
type st_9 from statictext within w_database_dn_state
end type
type dw_ver from datawindow within w_database_dn_state
end type
type hpb_del from hprogressbar within w_database_dn_state
end type
type st_msg from statictext within w_database_dn_state
end type
type hpb_down from hprogressbar within w_database_dn_state
end type
type st_8 from statictext within w_database_dn_state
end type
type cb_close from commandbutton within w_database_dn_state
end type
type st_title from statictext within w_database_dn_state
end type
end forward

global type w_database_dn_state from window
integer width = 1751
integer height = 1984
boolean titlebar = true
string title = "자문관리 Version 확인"
boolean controlmenu = true
windowtype windowtype = response!
boolean center = true
event wue_postopen ( )
uo_check uo_check
p_loading p_loading
st_9 st_9
dw_ver dw_ver
hpb_del hpb_del
st_msg st_msg
hpb_down hpb_down
st_8 st_8
cb_close cb_close
st_title st_title
end type
global w_database_dn_state w_database_dn_state

type prototypes
Function int Mipo_Unzip( String szZipFileName, String szDirName ) Library "MipoZip.dll" Alias For "Mipo_Unzip;Ansi"
end prototypes

type variables
public:
	boolean	ib_cancel
end variables

forward prototypes
public subroutine wf_pathcheck ()
public function boolean wf_version_execute ()
end prototypes

event wue_postopen();if wf_version_execute() = true then
	closewithreturn(this, 'Y')
else
	closewithreturn(this, 'N')
end if
end event

public subroutine wf_pathcheck ();string	ls_value

long	ll_rtn

ll_rtn = RegistryGet ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "Path", RegExpandString!, ls_value)
IF	ll_rtn=1	Then
	IF	POS(ls_value, 'C:\AAMS\kernel')<1	Then
		IF	RIGHT (ls_value,1)=';'	Then
			ls_value += ';C:\AAMS\kernel'
		Else
			ls_value += 'C:\AAMS\kernel'
		End IF
		ll_rtn = RegistrySet ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "Path", RegExpandString!, ls_value)
		IF	ll_rtn=1 THEN messagebox ('환경변수 수정', '시스템 환경변수 PATH에 추가 작업완료')
	End IF
End IF
end subroutine

public function boolean wf_version_execute ();ads_jTier   lds_fw_ver

STRING	ls_lib_dir, ls_lib_id, ls_dir, ls_basepath, ls_dir_zip, ls_max_lib_ver
STRING	ls_delete_file []
BOOLEAN	lb_return

BLOB	lob_file

INT   lR, lRC, lRead = 0, li_delete_file = 0, ll_ver

ls_basepath = getcurrentdirectory()
ls_max_lib_ver = ProfileString (gaa.config, 'config', 'version', '20240101' )

lRC = SQLCA.sql2ds ('versioncheck', "SELECT lib_dir, lib_id FROM fw_version where lib_ver > '" + ls_max_lib_ver + "' ORDER BY lib_dir, lib_id", lds_fw_ver, 'xml')

hpb_down.position = 0
hpb_del.position = 0

lRC = lds_fw_ver.rowcount ()
FOR  lR = lRC  TO  1  STEP -1
   yield ()
   ls_lib_dir = lds_fw_ver.getitemstring (lR, 1)
   ls_lib_id  = lds_fw_ver.getitemstring (lR, 2)

   IF ls_lib_dir='..\'  Then
      ls_dir = f_replace (ls_basepath,'kernel','') + ls_lib_id
   ElseIF POS (ls_lib_dir,'..\')>0  Then
      ls_dir = f_replace (ls_basepath,'kernel','') + f_replace (ls_lib_dir,'..\','') + ls_lib_id
   Else
      ls_dir = ls_basepath + ls_lib_dir + ls_lib_id
   End IF

   lRead ++
   ll_ver = dw_ver.insertrow (0)
   dw_ver.object.status [ll_ver] = f_n#(lRead,0,0) + '/' + f_n#(lRC,0,0) + ' : ' + ls_lib_id + '.zip download'

   hpb_down.position = long((ll_ver / lRC) * 100)

   SELECTBLOB lib_file
     INTO :lob_file
   FROM   fw_version t1
   WHERE  lib_dir = :ls_lib_dir
     AND  lib_id  = :ls_lib_id;

   filedelete (ls_dir)
   ls_dir_zip = ls_dir + '.zip'
   lb_return = mo_.hex2file (ls_dir_zip, SQLCA.is_Hexfile)
   li_delete_file ++
   ls_delete_file [li_delete_file] = ls_dir_zip

   mipo_unzip (ls_dir_zip, f_path (ls_dir,'\')) /* 압축풀기... */

   dw_ver.setrow (ll_ver)
   dw_ver.scrolltorow (ll_ver)
NEXT

// 압축풀기 완료파일 일괄삭제
FOR  lR = 1  TO  li_delete_file
   yield ()
   hpb_del.position = long((lR / li_delete_file) * 100)
   IF fileexists (ls_delete_file [lR]) Then
      filedelete (ls_delete_file [lR])
      ls_delete_file [lR] = mid(ls_delete_file [lR], LASTPOS(ls_delete_file [lR], '\') + 1)
      ll_ver = dw_ver.insertrow (0)
      dw_ver.object.status [ll_ver] = ls_delete_file [lR] + ' delete'
   End IF
   dw_ver.setrow (ll_ver)
   dw_ver.scrolltorow (ll_ver)
NEXT

hpb_down.position = 100
hpb_del.position = 100

/* config update */
SELECT max(lib_ver)
  INTO :ls_max_lib_ver
FROM   fw_version;

ls_max_lib_ver = SQLCA.getitemstring(1)

SetProfileString (gaa.config, 'config', 'version', ls_max_lib_ver)

RETURN TRUE
end function

on w_database_dn_state.create
this.uo_check=create uo_check
this.p_loading=create p_loading
this.st_9=create st_9
this.dw_ver=create dw_ver
this.hpb_del=create hpb_del
this.st_msg=create st_msg
this.hpb_down=create hpb_down
this.st_8=create st_8
this.cb_close=create cb_close
this.st_title=create st_title
this.Control[]={this.uo_check,&
this.p_loading,&
this.st_9,&
this.dw_ver,&
this.hpb_del,&
this.st_msg,&
this.hpb_down,&
this.st_8,&
this.cb_close,&
this.st_title}
end on

on w_database_dn_state.destroy
destroy(this.uo_check)
destroy(this.p_loading)
destroy(this.st_9)
destroy(this.dw_ver)
destroy(this.hpb_del)
destroy(this.st_msg)
destroy(this.hpb_down)
destroy(this.st_8)
destroy(this.cb_close)
destroy(this.st_title)
end on

event open;long	ll_rtn
ll_rtn = uo_check.lf_getpresslist()
if ll_rtn > 0 then
	messagebox('확인', '새로운 버전의 파일이 있습니다. 실행중인 시스템을 모두 닫고 다시 실행해 주십시요')
	HALT CLOSE  // System CLOSE
end if

wf_pathcheck()
post event wue_postopen()
end event

type uo_check from ez_u_funtion within w_database_dn_state
integer taborder = 10
end type

on uo_check.destroy
call ez_u_funtion::destroy
end on

type p_loading from picture within w_database_dn_state
integer x = 965
integer y = 196
integer width = 731
integer height = 640
boolean originalsize = true
string picturename = "..\img\mainframe\loading\loading4.gif"
boolean focusrectangle = false
end type

type st_9 from statictext within w_database_dn_state
integer x = 37
integer y = 520
integer width = 430
integer height = 76
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217856
string text = "step 2 : clear"
boolean focusrectangle = false
end type

type dw_ver from datawindow within w_database_dn_state
integer x = 23
integer y = 868
integer width = 1673
integer height = 924
integer taborder = 10
string dataobject = "d_database_dn_state_1"
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;ez_f_delaytime(50)
end event

type hpb_del from hprogressbar within w_database_dn_state
integer x = 32
integer y = 604
integer width = 910
integer height = 152
unsignedinteger minposition = 1
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_msg from statictext within w_database_dn_state
integer x = 23
integer y = 1796
integer width = 1673
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8421376
long backcolor = 16777215
boolean focusrectangle = false
end type

type hpb_down from hprogressbar within w_database_dn_state
integer x = 32
integer y = 308
integer width = 910
integer height = 152
unsignedinteger minposition = 1
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_8 from statictext within w_database_dn_state
integer x = 37
integer y = 216
integer width = 594
integer height = 80
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217856
string text = "step 1 : download"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_database_dn_state
integer x = 1518
integer y = 2408
integer width = 274
integer height = 108
integer taborder = 10
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "Close"
end type

event clicked;choose case this.text
	case 'Close'
		close(parent)
	case 'Cancel'
		ib_cancel = true
		close(parent)
end choose

end event

type st_title from statictext within w_database_dn_state
integer x = 23
integer y = 16
integer width = 1673
integer height = 148
boolean bringtotop = true
integer textsize = -20
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8421376
long backcolor = 16777215
string text = "AAMS server sync process"
alignment alignment = center!
boolean focusrectangle = false
end type

