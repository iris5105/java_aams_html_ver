forward
global type w_corp_change from window
end type
type sle_1 from pf_u_singlelineedit within w_corp_change
end type
type dw_corp_gr_list from u_dw_corp_list within w_corp_change
end type
type p_1 from picture within w_corp_change
end type
end forward

global type w_corp_change from window
integer width = 2514
integer height = 2596
boolean titlebar = true
string title = "회사 변경"
boolean controlmenu = true
windowtype windowtype = response!
string icon = "AppIcon!"
boolean toolbarvisible = false
boolean center = true
integer animationtime = 400
sle_1 sle_1
dw_corp_gr_list dw_corp_gr_list
p_1 p_1
end type
global w_corp_change w_corp_change

type prototypes

end prototypes

type variables
STRING	is_corp_gr1 []
STRING	is_corp_gr2 []
STRING	is_corp_gr3 []
STRING	is_corp_gr4 []

STRING	is_corp_nm1 []
STRING	is_corp_nm2 []
STRING	is_corp_nm3 []
STRING	is_corp_nm4 []

ads_jTier	ids_jTier

STRING	is_connect
end variables

on w_corp_change.create
this.sle_1=create sle_1
this.dw_corp_gr_list=create dw_corp_gr_list
this.p_1=create p_1
this.Control[]={this.sle_1,&
this.dw_corp_gr_list,&
this.p_1}
end on

on w_corp_change.destroy
destroy(this.sle_1)
destroy(this.dw_corp_gr_list)
destroy(this.p_1)
end on

event open;is_connect = gaa.jTier_dbname
dw_corp_gr_list.of_retrieve (gaa.customer_gr, ids_jTier)
end event

type sle_1 from pf_u_singlelineedit within w_corp_change
event oue_keydown pbm_keyup
integer x = 585
integer y = 44
integer width = 1216
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
boolean hideselection = false
end type

event oue_keydown;dw_corp_gr_list.setredraw(FALSE)

LONG	ll, ll_row, ll_cnt = 0

STRING	ls_corp_gr, ls_corp_gr_nm, ls_text, ls_img_file

ls_text = lower (TEXT)

dw_corp_gr_list.reset()

FOR  ll = 1  TO  ids_jTier.rowcount ()
	ls_corp_gr		= ids_jTier.getitemstring (ll, 1)
	ls_corp_gr_nm 	= ids_jTier.getitemstring (ll, 2)
	//내용이 포함되어 있다면 실행
	IF pos (lower (ls_corp_gr), ls_text)>0 OR pos (lower (ls_corp_gr_nm), ls_text)>0 OR f_null (ls_text) Then
		ll_cnt++
		ls_img_file =  "..\img\mainframe\company_logo\logo_" + ls_corp_gr + ".jpg"

		IF	mod(ll_cnt,2) = 1	then
			ll_row = dw_corp_gr_list.insertrow(0)
			IF	FileExists (ls_img_file) then
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_img_1st', ls_img_file )
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_1st', ls_corp_gr )
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_nm_1st', ls_corp_gr_nm )
			ELSE
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_nm_1st', ls_corp_gr_nm )
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_1st', ls_corp_gr )
			END IF
		else
			IF	FileExists (ls_img_file) then
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_img_2nd', ls_img_file )
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_2nd', ls_corp_gr )
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_nm_2nd', ls_corp_gr_nm )
			ELSE
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_nm_2nd', ls_corp_gr_nm )
				dw_corp_gr_list.setitem( ll_row, 'corp_gr_2nd', ls_corp_gr )
			END IF		
		end if
	End IF
NEXT

dw_corp_gr_list.setredraw(TRUE)
end event

event getfocus;call super::getfocus;pf_f_togglekoreng ('k')
end event

type dw_corp_gr_list from u_dw_corp_list within w_corp_change
integer x = 37
integer y = 160
integer width = 2418
integer height = 2344
integer taborder = 20
string dataobject = "d_login_corp_gr"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;IF ROW=0 THEN RETURN
IF DWO.NAME = "corp_gr_img_1st" OR DWO.NAME = "corp_gr_img_2nd"   Then
   this.of_clicked_menu (STRING(DWO.NAME), ROW, true)
ELSE
   RETURN
END IF

STRING	ls_corp_gr, ls_modify
DATETIME	ldt_hyun_ymd

IF DWO.NAME = "corp_gr_img_1st"  Then
   ls_corp_gr = this.GETITEMSTRING (ROW, "corp_gr_1st")
ELSEIF DWO.NAME = "corp_gr_img_2nd" Then
   ls_corp_gr = this.GETITEMSTRING (ROW, "corp_gr_2nd")
END IF

IF f_null(ls_corp_gr)   Then
   RETURN
ELSE
   gaa.CORP_GR = ls_corp_gr
END IF

ls_modify = gw_mdi.uo_userinfo.DESCRIBE ("role_nm.tooltip.tip")
ls_modify = f_replace (ls_modify, gaa.jTier_dbname, '')

IF is_connect <> gaa.jTier_dbname   Then
   gaa.jTier_dbname = is_connect
   f_jtier_connect ()
   gnv_authority.of_checkUserAuthority (gaa.login, '')
END IF

gnv_vari.of_setprofile ("login.last.corp_gr", gaa.CORP_GR)

SELECT t1.customer_gr
     , t2.e_mail
     , t1.company_name
     , t1.hyun_ymd
  INTO :gaa.customer_gr
     , :gaa.corp_e_mail
     , :gaa.corp_nm
     , :ldt_hyun_ymd
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
ldt_hyun_ymd    = SQLCA.getitemdatetime (4)

gnv_vari.of_setprofile ("login.corp.aams.dt", STRING (ldt_hyun_ymd, 'yyyy.mm.dd'))
gnv_vari.of_setprofile ("login.corp.aams.ytd", STRING (ldt_hyun_ymd, 'yyyy') + '.01.01')
gw_mdi.p_right_logo.picturename = "..\img\mainframe\right_logo\fw_top_logo_right_" + gaa.CORP_GR + ".jpg"

gaa.title = 'KFP ( ' + gaa.CORP_GR + ' ' + gaa.corp_nm + ' ) 자문계좌관리 시스템   [ 접속서버 ' + gaa.jTier_dbname + ' ]'

ls_modify = gaa.jTier_dbname + ls_modify

CLOSE (parent)
end event

type p_1 from picture within w_corp_change
integer y = 4
integer width = 2505
integer height = 2516
string picturename = "..\img\mainframe\mdi4comm\corp_chg_bg.jpg"
boolean focusrectangle = false
end type

