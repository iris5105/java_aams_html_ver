forward
global type w_login_aams from window
end type
type cb_pwd from commandbutton within w_login_aams
end type
type cb_1 from commandbutton within w_login_aams
end type
type em_user_id from pf_u_editmask within w_login_aams
end type
type sle_password from singlelineedit within w_login_aams
end type
type p_login_corp_gr from picture within w_login_aams
end type
type lb_dirlist from pf_u_listbox within w_login_aams
end type
type cbx_idcheck from checkbox within w_login_aams
end type
type p_close from pf_u_imagebutton within w_login_aams
end type
type p_ok from pf_u_imagebutton within w_login_aams
end type
type p_login_bg from picture within w_login_aams
end type
end forward

global type w_login_aams from window
integer width = 7351
integer height = 3548
boolean border = false
windowtype windowtype = popup!
string icon = "AppIcon!"
boolean toolbarvisible = false
boolean center = true
integer animationtime = 400
event wue_postopen ( )
cb_pwd cb_pwd
cb_1 cb_1
em_user_id em_user_id
sle_password sle_password
p_login_corp_gr p_login_corp_gr
lb_dirlist lb_dirlist
cbx_idcheck cbx_idcheck
p_close p_close
p_ok p_ok
p_login_bg p_login_bg
end type
global w_login_aams w_login_aams

type prototypes
Function long GetWindowLong (ulong hWnd, int nIndex) Library "user32.dll" Alias for "GetWindowLongW"
Function long SetWindowLong (ulong hWnd, int nIndex, long dwNewLong) Library "user32.dll" Alias for "SetWindowLongW"
Function Long SetLayeredWindowAttributes(ulong hWnd, Long crKey , byte bAlpha , Long dwFlags) Library "user32.dll"
end prototypes

type variables
//SetWindowPos
Constant Long HWND_TOPMOST = -1
Constant Long HWND_NOTOPMOST = -2
Constant Long HWND_TOP = 1
Constant Long SWP_NOSIZE = 1
Constant Long SWP_NOMOVE = 2
Constant Long SWP_NOACTIVATE = 16
Constant Long SWP_SHOWWINDOW = 64

BOOLEAN	ib_pass = FALSE
STRING	is_pass
end variables

event wue_postopen();setposition (topmost!)
setposition (notopmost!)

// gnv_vari.is_lang_type = gnv_vari.of_getprofile("login.last.lang.type", "")
is_pass = gnv_vari.of_getprofile ('connect.' + gnv_vari.is_macaddress, 'PASSWORD')

IF ProfileString (gaa.config, 'SetConfig', gaa.login, '20230101') = STRING (toDay (),'yyyymmdd') OR is_pass = 'TRUE' Then
   // 하루 한번만 점검, 맥주소로 pass
   em_user_id.text        = gaa.login
   p_login_bg.PictureName = "..\img\mainframe\login1\login_bg0.jpg"
   cb_pwd.VISIBLE         = false
   sle_password.VISIBLE   = false
   em_user_id.setfocus ()
   ib_pass = TRUE
ELSE
   em_user_id.text = gaa.login
   IF f_null (gaa.login)   Then
      em_user_id.setfocus ()
   ELSE
      sle_password.setfocus ()
   END IF
END IF

LONG	li

lb_dirlist.DirList ("c:\up\__*.*", 0)
FOR  li = 1  TO  lb_dirlist.TotalItems ()
   FileDelete ('c:\up\' + lb_dirlist.TEXT (li))
NEXT
lb_dirlist.dirlist (gaa.excel + "__*.*", 0)
FOR  li = 1  TO  lb_dirlist.totalitems ()
   FileDelete (gaa.excel + lb_dirlist.TEXT (li))
NEXT
lb_dirlist.dirlist (gaa.pdf + "__*.*", 0)
FOR  li = 1  TO  lb_dirlist.totalitems ()
   FileDelete (gaa.pdf + lb_dirlist.TEXT (li))
NEXT
lb_dirlist.DirList (gaa.temp + "*.*", 0)
FOR  li = 1  TO  lb_dirlist.TotalItems ()
   FileDelete (gaa.temp + lb_dirlist.TEXT (li))
NEXT

ChangeDirectory (gnv_vari.basepath)
end event

on w_login_aams.create
this.cb_pwd=create cb_pwd
this.cb_1=create cb_1
this.em_user_id=create em_user_id
this.sle_password=create sle_password
this.p_login_corp_gr=create p_login_corp_gr
this.lb_dirlist=create lb_dirlist
this.cbx_idcheck=create cbx_idcheck
this.p_close=create p_close
this.p_ok=create p_ok
this.p_login_bg=create p_login_bg
this.Control[]={this.cb_pwd,&
this.cb_1,&
this.em_user_id,&
this.sle_password,&
this.p_login_corp_gr,&
this.lb_dirlist,&
this.cbx_idcheck,&
this.p_close,&
this.p_ok,&
this.p_login_bg}
end on

on w_login_aams.destroy
destroy(this.cb_pwd)
destroy(this.cb_1)
destroy(this.em_user_id)
destroy(this.sle_password)
destroy(this.p_login_corp_gr)
destroy(this.lb_dirlist)
destroy(this.cbx_idcheck)
destroy(this.p_close)
destroy(this.p_ok)
destroy(this.p_login_bg)
end on

event open;this.x		= p_login_bg.x
this.y		= p_login_bg.y
this.width	= p_login_bg.width
this.height	= p_login_bg.height

p_login_corp_gr.PictureName = "..\img\mainframe\company_logo\logo_" + gaa.corp_gr + ".jpg"

event wue_postopen()
end event

event mousemove;Send (handle(THIS),274,61458,0)
end event

event key;return 1
end event

type cb_pwd from commandbutton within w_login_aams
integer x = 5317
integer y = 2596
integer width = 457
integer height = 120
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "비밀번호변경"
end type

event clicked;str_parameter	sp

sp.bo [1]  = false
sp.str [1] = gaa.corp_gr
sp.str [2] = em_user_id.text
sp.str [3] = '기존 비밀번호를 입력 후~r~n변경할 비밀번호를 입력하십시오.'

openwithparm (w_change_pwd, sp)
end event

type cb_1 from commandbutton within w_login_aams
boolean visible = false
integer x = 5787
integer y = 2828
integer width = 457
integer height = 132
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "config"
end type

event clicked;open (w_config)
end event

type em_user_id from pf_u_editmask within w_login_aams
integer x = 5097
integer y = 1836
integer width = 1115
integer taborder = 30
integer textsize = -11
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
borderstyle borderstyle = stylebox!
maskdatatype maskdatatype = stringmask!
string mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
end type

event modified;call super::modified;IF text = 'marrow67@daum.net' Then
   cb_1.VISIBLE = TRUE
ELSE
   STRING	ls_text, ls_old

   ls_text = text
   ::clipboard (ls_text)

   ls_old = gaa.CORP_GR

   SELECT t1.CORP_GR
     INTO :gaa.CORP_GR
     FROM FW_USER_MST t1
    WHERE t1.CORP_GR    LIKE '%'
      AND t1.ENC_E_MAIL = TO_ENCRYPTS(:ls_text)
      AND t1.out_ymd IS NULL
      AND ROWNUM = 1 ;
   IF SQLCA.sqlcode()<>0 THEN RETURN

   gaa.CORP_GR = SQLCA.GETITEMSTRING (1)
   IF gaa.CORP_GR = '2200' Then
      gaa.aams    = true
      gaa.CORP_GR = ls_old
   ELSE
      gaa.aams = false
   END IF

   SELECT t1.customer_gr
        , t1.company_name
     INTO :gaa.customer_gr
        , :gaa.corp_nm
     FROM SZX0AA t1
    WHERE t1.CORP_GR = :gaa.CORP_GR ;

   gaa.customer_gr = SQLCA.GETITEMSTRING (1)
   gaa.corp_nm     = SQLCA.GETITEMSTRING (2)

   p_login_corp_gr.PictureName = "..\img\mainframe\company_logo\logo_" + gaa.CORP_GR + ".jpg"
   gaa.title = 'KFP ( ' + gaa.CORP_GR + ' ' + gaa.corp_nm + ' ) 자문계좌관리 시스템   [ 접속서버 ' + gaa.jTier_dbname + ' ]'
END IF
end event

type sle_password from singlelineedit within w_login_aams
integer x = 5097
integer y = 2112
integer width = 1115
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean password = true
end type

type p_login_corp_gr from picture within w_login_aams
integer x = 4914
integer y = 884
integer width = 1253
integer height = 248
boolean enabled = false
string picturename = "..\img\mainframe\company_logo\logo_2200.jpg"
boolean focusrectangle = false
end type

type lb_dirlist from pf_u_listbox within w_login_aams
boolean visible = false
integer x = 7886
integer width = 480
integer height = 424
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
fontcharset fontcharset = hangeul!
long textcolor = 33554432
boolean enabled = false
boolean sorted = false
end type

type cbx_idcheck from checkbox within w_login_aams
integer x = 8224
integer y = 468
integer width = 101
integer height = 124
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19474729
long backcolor = 553648127
boolean checked = true
end type

type p_close from pf_u_imagebutton within w_login_aams
integer x = 7218
integer y = 16
integer width = 119
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\login1\login_btn_close.jpg"
end type

event clicked;call super::clicked;Close(Parent)
end event

type p_ok from pf_u_imagebutton within w_login_aams
integer x = 4791
integer y = 2340
integer width = 1486
integer height = 176
integer taborder = 30
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\mainframe\login1\login_button.jpg"
end type

event clicked;call super::clicked;DATETIME	ldt_sysdate
STRING	ls_pwd

IF ib_pass  Then
   IF f_null (em_user_id.text)   Then
      IF gaa.login <> 'yjs1992@hitel.net' Then
         em_user_id.POST setfocus ()
         RETURN
      END IF
   ELSE
      IF is_pass = 'TRUE'	Then
         // 맥주소로 pass
         ib_pass   = TRUE
         gaa.login = em_user_id.text
      ELSE
         IF POS (em_user_id.text,'@') > 0 Then
            IF em_user_id.text <> gaa.login  Then
               p_login_bg.PictureName = "..\img\mainframe\login1\login_bg.jpg"
               sle_password.VISIBLE = true
               cb_pwd.VISIBLE       = true
               MESSAGEBOX ('Notice', '다른 작업자로 접속 했습니다.~r~n비밀번호를 다시 입력하십시오.')
               sle_password.POST setfocus ()
               ib_pass = FALSE
               RETURN
            END IF
         ELSE
            IF em_user_id.text <> LEFT (gaa.login,POS(gaa.login,'@')-1) Then
               p_login_bg.PictureName = "..\img\mainframe\login1\login_bg.jpg"
               sle_password.VISIBLE = true
               cb_pwd.VISIBLE       = true
               MESSAGEBOX ('Notice', '다른 작업자로 접속 했습니다.~r~n비밀번호를 다시 입력하십시오.')
               sle_password.POST setfocus ()
               ib_pass = FALSE
               RETURN
            END IF
         END IF
      END IF
   END IF
ELSE
   gaa.login = em_user_id.text
   IF f_null (gaa.login)   Then
      MESSAGEBOX ('Notice', '접속자 아이디를 입력하십시오.')
      em_user_id.POST setfocus ()
      RETURN
   END IF
   IF is_pass = gaa.login	Then
      ib_pass = TRUE
   ELSE
      ls_pwd = sle_password.text
      IF f_null (ls_pwd) AND NOT gaa.aams Then
         sle_password.POST setfocus ()
         RETURN
      END IF
   END IF
END IF

// 사용자 권한 체크
Choose CASE gnv_authority.of_checkUserAuthority (gaa.login, ls_pwd)
   CASE -1
      closewithreturn (parent, 'failure')
      RETURN
   CASE 0
      sle_password.text = ''
      sle_password.POST Setfocus ()
      RETURN
End Choose

f_jtier_connect ()	// DB connect

IF ProfileString (gaa.config, 'SetConfig', gaa.login, '20200101')=STRING (toDay (),'yyyymmdd') THEN ib_pass = TRUE

CHOOSE CASE gnv_authority.of_checkUserAuthority (gaa.login, sle_password.text)
	CASE 1	// ok
		SetProfilestring (gaa.config, 'SetConfig', gaa.login, STRING (toDay(), 'yyyymmdd'))
   CASE 3
      IF NOT ib_pass Then
         MESSAGEBOX ('접속오류', '비밀번호를 다시 입력하십시오.', Question!)
         sle_password.text = ''
         sle_password.POST setfocus ()
         RETURN
      END IF
		SetProfilestring (gaa.config, 'SetConfig', gaa.login, STRING (toDay(), 'yyyymmdd'))

   CASE 0
      MESSAGEBOX ('Notice', '접속자 아이디를 찾을수 없습니다~r~n아이디를 확인하십시오.')
      em_user_id.POST setfocus ()
      RETURN
   CASE -1
      RETURN
END CHOOSE

SELECT t1.customer_gr
     , ab.e_mail
     , t1.company_name
     , hyun_ymd
  INTO :gaa.customer_gr
     , :gaa.corp_e_mail
     , :gaa.corp_nm
     , :ldt_sysdate
  FROM SZX0AA t1
     , SZX0AB ab
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND ab.CORP_GR = t1.CORP_GR
   AND ab.ymd     = (SELECT MAX(ymd)
                       FROM SZX0AB ta
                      WHERE ta.CORP_GR = :gaa.CORP_GR) ;

gaa.customer_gr = SQLCA.GETITEMSTRING (1)
gaa.corp_e_mail = SQLCA.GETITEMSTRING (2)
gaa.corp_nm     = SQLCA.GETITEMSTRING (3)
ldt_sysdate     = SQLCA.getitemdatetime (4)

gnv_vari.of_setprofile ("login.LAST.corp_gr", gaa.CORP_GR)
gnv_vari.of_setprofile ("login.LAST.user_id", gaa.login)
gnv_vari.of_setprofile ("login.corp.aams.dt", STRING (ldt_sysdate, 'yyyy.mm.dd'))
gnv_vari.of_setprofile ("login.corp.aams.ytd", STRING (ldt_sysdate, 'yyyy') + '.01.01')

gaa.find_object = TRUE

::Clipboard ('')

// 로그인 완료 후 프로세스 수행
IF gnv_vari.getclienttype = "PB" Then
   gnv_appmgr.EVENT oue_afterloginprocess ()
   CLOSE (parent)
ELSE
   CLOSE (parent)
   gnv_appmgr.EVENT oue_afterloginprocess ()
END IF
end event

type p_login_bg from picture within w_login_aams
integer width = 7351
integer height = 3556
boolean enabled = false
boolean originalsize = true
string picturename = "..\img\mainframe\login1\login_bg.jpg"
boolean border = true
boolean focusrectangle = false
end type

