forward
global type w_window1st5ole from w_window1st5ncn
end type
type ole_web from pf_u_webbrowser within w_window1st5ole
end type
type p_refresh from pf_u_imagebutton within w_window1st5ole
end type
end forward

global type w_window1st5ole from w_window1st5ncn
ole_web ole_web
p_refresh p_refresh
end type
global w_window1st5ole w_window1st5ole

forward prototypes
public function string of_thisname ()
public function integer of_post_url (string as_url)
end prototypes

public function string of_thisname ();return 'w_window1st5ole'
end function

public function integer of_post_url (string as_url);long ll_rc

ll_rc = long(ole_web.object.navigate2(as_url))

// Wait for Document to finish loading
do while ole_web.Object.Busy
	yield()
loop

return ll_rc

// ===============================================
// 아래는 웹 어플리케이션 세션 생성 후 AS_URL 웹페이지 호출하는 샘플입니다.
// ===============================================
//string ls_forward
//string ls_parm[]
//string	ls_js
//
//// SESSION 생성 및 AS_URL로 이동하기 위해 해당  웹어플리케이션
//// 에서 제공되는 JSP 페이지
//ls_forward = 'http://info.sewc.ac.kr/cc/student/s_forward.jsp'
//ls_parm[1] = ''
//ls_parm[2] = gnv_vari.is_user_id
//ls_parm[3] = gnv_vari.of_getstring('login_pwd')
//ls_parm[4] = as_url
//
//if AppeonGetClientType() = "PB" then
//	ole_ie.object.navigate2('about:blank')
//	
//	// Wait for Document to finish loading
//	do while ole_ie.Object.Busy
//		yield()
//	loop
//	
//	ole_ie.object.document.Open()
//	ole_ie.object.document.WriteLn("<HTML><HEAD>")
//	ole_ie.object.document.WriteLn("<SCRIPT>")
//	ole_ie.object.document.WriteLn("function go() {")
//	ole_ie.object.document.WriteLn("  document.myform.submit()")
//	ole_ie.object.document.WriteLn("  }")
//	ole_ie.object.document.WriteLn("</SCRIPT>")
//	ole_ie.object.document.WriteLn("</HEAD>")
//	ole_ie.object.document.WriteLn("<BODY onload='go();'>")
//	ole_ie.object.document.WriteLn("<FORM name='myform' ")
//	ole_ie.object.document.WriteLn("METHOD='POST' ACTION='" + ls_forward + "'>")
//	ole_ie.object.document.WriteLn("<INPUT NAME='kubun' TYPE=HIDDEN VALUE='" + ls_parm[1] + "'>")
//	ole_ie.object.document.WriteLn("<INPUT NAME='userid' TYPE=HIDDEN VALUE='" + ls_parm[2] + "'>")
//	ole_ie.object.document.WriteLn("<INPUT NAME='passwd' TYPE=HIDDEN VALUE='" + ls_parm[3] + "'>")
//	ole_ie.object.document.WriteLn("<INPUT NAME='forward' TYPE=HIDDEN VALUE='" + ls_parm[4] + "'>")
//	ole_ie.object.document.WriteLn("</FORM>")
//	ole_ie.object.document.WriteLn("</BODY>")
//	ole_ie.object.document.WriteLn("</HTML>")
//	ole_ie.object.document.Close()
//else
//	string ls_url, ls_oldurl
//	
//	ls_OldURL = ole_ie.Object.LocationURL
//	ls_url = AppeonGetIEURL()
//	ls_url += 'plugin/empty.html'
//	
//	if ls_oldurl = ls_url then
//		// do nothing
//	else
//		ole_ie.object.navigate2(ls_url)
//		// Wait for Document to start loading
//		do while ls_OldURL = ole_ie.Object.LocationURL
//			Yield()
//		loop
//	end if
//	
//	// Wait for Document to finish loading
//	do while ole_ie.Object.Busy
//		yield()
//	loop
//	
//	ls_js += 'var submitForm = document.createElement("FORM");~r~n'
//	ls_js += 'document.body.appendChild(submitForm);~r~n'
//	ls_js += 'submitForm.method="POST";~r~n'
//	ls_js += 'var newElement = document.createElement("<input name=~'' + 'kubun' + '~' type=~'hidden~' value=~'' + ls_parm[1] + '~'>");~r~n'
//	ls_js += 'submitForm.appendChild(newElement);~r~n'
//	ls_js += 'var newElement = document.createElement("<input name=~'' + 'userid' + '~' type=~'hidden~' value=~'' + ls_parm[2] + '~'>");~r~n'
//	ls_js += 'submitForm.appendChild(newElement);~r~n'
//	ls_js += 'var newElement = document.createElement("<input name=~'' + 'passwd' + '~' type=~'hidden~' value=~'' + ls_parm[3] + '~'>");~r~n'
//	ls_js += 'submitForm.appendChild(newElement);~r~n'
//	ls_js += 'var newElement = document.createElement("<input name=~'' + 'forward' + '~' type=~'hidden~' value=~'' + ls_parm[4] + '~'>");~r~n'
//	ls_js += 'submitForm.appendChild(newElement);~r~n'
//	ls_js += 'submitForm.action="' + ls_forward + '";~r~n'
//	ls_js += 'submitForm.submit();'
//
//	ole_ie.object.document.parentwindow.execScript(ls_js, "JavaScript");
//end if
//
//return 0

end function

on w_window1st5ole.create
int iCurrent
call super::create
this.ole_web=create ole_web
this.p_refresh=create p_refresh
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_web
this.Control[iCurrent+2]=this.p_refresh
end on

on w_window1st5ole.destroy
call super::destroy
destroy(this.ole_web)
destroy(this.p_refresh)
end on

event wue_postinst;call super::wue_postinst;string		ls_url_link_yn, ls_linked_url
string		ls_pgm_no

ls_pgm_no = this.of_getpgmno()

  Select	url_link_yn,
			linked_url
	Into	:ls_url_link_yn,
			:ls_linked_url
  From	fw_pgm_mst
 Where	sys_id = :gnv_vari.is_sys_id
	and	pgm_no = :ls_pgm_no;
	
ls_url_link_yn = SQLCA.getitemstring (1)
ls_linked_url  = SQLCA.getitemstring (2)

If ls_url_link_yn = 'Y' and fw_f_nvls(ls_linked_url, '') <> '' Then Post of_post_url(ls_linked_url)

end event

type ln_templeft from w_window1st5ncn`ln_templeft within w_window1st5ole
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_window1st5ole
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_window1st5ole
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_window1st5ole
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_window1st5ole
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_window1st5ole
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_window1st5ole
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_window1st5ole
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_window1st5ole
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_window1st5ole
end type

type uo_navi from w_window1st5ncn`uo_navi within w_window1st5ole
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_window1st5ole
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_window1st5ole
end type

type p_close from w_window1st5ncn`p_close within w_window1st5ole
end type

type p_excel from w_window1st5ncn`p_excel within w_window1st5ole
end type

type p_print from w_window1st5ncn`p_print within w_window1st5ole
end type

type p_delete from w_window1st5ncn`p_delete within w_window1st5ole
end type

type p_update from w_window1st5ncn`p_update within w_window1st5ole
end type

type p_input from w_window1st5ncn`p_input within w_window1st5ole
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_window1st5ole
end type

type p_clear from w_window1st5ncn`p_clear within w_window1st5ole
end type

type ole_web from pf_u_webbrowser within w_window1st5ole
integer x = 50
integer y = 292
integer width = 5381
integer height = 2408
integer taborder = 110
boolean bringtotop = true
string binarykey = "w_window1st5ole.win"
boolean scaletoright = true
boolean scaletobottom = true
end type

type p_refresh from pf_u_imagebutton within w_window1st5ole
integer x = 5120
integer y = 184
integer width = 311
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_refresh.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
ole_web.Object.Refresh()
end event

