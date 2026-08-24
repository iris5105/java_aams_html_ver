forward
global type w_exam4function1 from w_window1st5ncn
end type
type cb_3 from pf_u_commandbutton within w_exam4function1
end type
type cb_ie from pf_u_commandbutton within w_exam4function1
end type
type cb_1 from pf_u_commandbutton within w_exam4function1
end type
type cb_5 from pf_u_commandbutton within w_exam4function1
end type
type cb_9 from pf_u_commandbutton within w_exam4function1
end type
type cb_8 from commandbutton within w_exam4function1
end type
type cb_7 from commandbutton within w_exam4function1
end type
type cb_10 from pf_u_commandbutton within w_exam4function1
end type
type cb_6 from pf_u_commandbutton within w_exam4function1
end type
type cb_4 from pf_u_commandbutton within w_exam4function1
end type
type cb_2 from pf_u_commandbutton within w_exam4function1
end type
type cb_message1 from pf_u_commandbutton within w_exam4function1
end type
end forward

global type w_exam4function1 from w_window1st5ncn
cb_3 cb_3
cb_ie cb_ie
cb_1 cb_1
cb_5 cb_5
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
cb_10 cb_10
cb_6 cb_6
cb_4 cb_4
cb_2 cb_2
cb_message1 cb_message1
end type
global w_exam4function1 w_exam4function1

on w_exam4function1.create
int iCurrent
call super::create
this.cb_3=create cb_3
this.cb_ie=create cb_ie
this.cb_1=create cb_1
this.cb_5=create cb_5
this.cb_9=create cb_9
this.cb_8=create cb_8
this.cb_7=create cb_7
this.cb_10=create cb_10
this.cb_6=create cb_6
this.cb_4=create cb_4
this.cb_2=create cb_2
this.cb_message1=create cb_message1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_ie
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_5
this.Control[iCurrent+5]=this.cb_9
this.Control[iCurrent+6]=this.cb_8
this.Control[iCurrent+7]=this.cb_7
this.Control[iCurrent+8]=this.cb_10
this.Control[iCurrent+9]=this.cb_6
this.Control[iCurrent+10]=this.cb_4
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_message1
end on

on w_exam4function1.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.cb_ie)
destroy(this.cb_1)
destroy(this.cb_5)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.cb_10)
destroy(this.cb_6)
destroy(this.cb_4)
destroy(this.cb_2)
destroy(this.cb_message1)
end on

type lb_dirlist from w_window1st5ncn`lb_dirlist within w_exam4function1
end type

type ln_templeft from w_window1st5ncn`ln_templeft within w_exam4function1
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_exam4function1
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_exam4function1
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_exam4function1
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_exam4function1
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_exam4function1
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_exam4function1
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_exam4function1
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_exam4function1
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_exam4function1
end type

type uo_navi from w_window1st5ncn`uo_navi within w_exam4function1
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_exam4function1
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_exam4function1
end type

type st_top_rect from w_window1st5ncn`st_top_rect within w_exam4function1
end type

type p_close from w_window1st5ncn`p_close within w_exam4function1
end type

type p_excel from w_window1st5ncn`p_excel within w_exam4function1
end type

type p_print from w_window1st5ncn`p_print within w_exam4function1
end type

type p_delete from w_window1st5ncn`p_delete within w_exam4function1
end type

type p_update from w_window1st5ncn`p_update within w_exam4function1
end type

type p_input from w_window1st5ncn`p_input within w_exam4function1
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_exam4function1
end type

type p_clear from w_window1st5ncn`p_clear within w_exam4function1
end type

type cb_3 from pf_u_commandbutton within w_exam4function1
event enchange pbm_enchange
integer x = 151
integer y = 668
integer width = 1047
integer height = 124
integer taborder = 120
boolean bringtotop = true
string text = "temppath"
end type

event clicked;call super::clicked;messagebox(gnv_vari.is_tempdirectory, gnv_extfunc.of_getsystemtemppath())


//gnv_extfunc.of_getsystemtemppath()  ... temp까지
//gnv_vari.is_tempdirectory  .. temp/pentalib/site명


end event

type cb_ie from pf_u_commandbutton within w_exam4function1
event enchange pbm_enchange
integer x = 151
integer y = 820
integer width = 1047
integer height = 124
integer taborder = 130
boolean bringtotop = true
string text = "naver"
end type

event clicked;call super::clicked;pf_f_browser("http://www.naver.com")

//string ls_null
//setnull(ls_null)
//
//gnv_extfunc.ShellExecute(handle(Parent), 'open', "http://www.naver.com/", ls_null, ls_null, 5)
end event

type cb_1 from pf_u_commandbutton within w_exam4function1
integer x = 151
integer y = 972
integer width = 1047
integer height = 124
integer taborder = 130
boolean bringtotop = true
string text = "bar msg"
end type

event clicked;call super::clicked;gw_mdi.Dynamic SetMicrohelp('Message Test Test Test Test...')
end event

type cb_5 from pf_u_commandbutton within w_exam4function1
integer x = 151
integer y = 1124
integer width = 1047
integer height = 124
integer taborder = 130
boolean bringtotop = true
string text = "popup"
end type

event clicked;call super::clicked;
openwithparm(w_test4pop1, '')
end event

type cb_9 from pf_u_commandbutton within w_exam4function1
integer x = 151
integer y = 516
integer width = 1047
integer height = 124
integer taborder = 130
boolean bringtotop = true
string text = "dynamic update"
end type

event clicked;call super::clicked;string ls_sqlerrtext, ls_req_nb
//PREPARE SQLSA FROM "UPDATE ts_to_reqdtl_it SET sys_dt = getdate() WHERE req_nb =? " using sqlca;
//EXECUTE SQLSA USING :req_nb;
ls_req_nb = '001'

PREPARE SQLSA FROM "UPDATE fw_cmcd01m SET detl_nm = '1111'  where mast_cd =  'test' and detl_cd = ? " using sqlca;

EXECUTE SQLSA USING :ls_req_nb;

If sqlca.sqlcode <> 0 Then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollbackJ ()
	MessageBox('Error : ' + '자료 dynamic 저장 실패했습니다!!' + String(Sqlca.sqlcode), ls_sqlErrText)
	Return
End If
			
commitJ ()

end event

type cb_8 from commandbutton within w_exam4function1
integer x = 2441
integer y = 516
integer width = 1047
integer height = 124
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "ppt execute"
end type

event clicked;constant long SW_SHOWNORMARL = 1

String 	ls_nulstring

SetNull(ls_nulstring)
gnv_extfunc.ShellExecute(0, ls_nulstring, "C:\Temp\프레임 특장점.pptx", ls_nulstring, ls_nulstring, SW_SHOWNORMARL)

end event

type cb_7 from commandbutton within w_exam4function1
integer x = 2441
integer y = 668
integer width = 1047
integer height = 124
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "mail test"
end type

event clicked;string		ls_serverurl, ls_from_user_name, ls_from_addr, ls_to_addr
string		ls_subject, ls_content

pf_n_cryptoapi lnv_crypto
lnv_crypto = create pf_n_cryptoapi

ls_serverurl				= 'http://' + gnv_vari.is_ipaddress + '/pfservices/SendMailServlet'
ls_from_user_name		= 'bm팀'
ls_from_addr			= 'twsh01@penta.co.kr'
//ls_to_addr				= 'twsh01@penta.co.kr; twsh01@hanmail.net; twsh01@naver.com;'
ls_to_addr				= 'twsh01@naver.com'
ls_subject				= '메일테스트'
ls_content				= lnv_crypto.of_encode64( blob( '안녕하세요.. 우리나라...', EncodingUTF8! ) )

if pf_f_isemptystring(ls_serverurl) then
	messagebox('알림', '서버 URL 정보를 입력하세요')
	Return -1
end if

fw_n_httpfile lnv_http
lnv_http = Create fw_n_httpfile

integer li_rc
li_rc = lnv_http.of_sendmail( ls_serverurl, ls_from_user_name, ls_from_addr, ls_to_addr, ls_subject, ls_content )
messagebox('',li_rc)
Return li_rc
end event

type cb_10 from pf_u_commandbutton within w_exam4function1
integer x = 151
integer y = 172
integer width = 1047
integer height = 124
integer taborder = 120
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "empty"
end type

type cb_6 from pf_u_commandbutton within w_exam4function1
integer x = 1298
integer y = 516
integer width = 1047
integer height = 124
integer taborder = 130
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "capture"
end type

event clicked;call super::clicked;//gnv_extfunc.biz_setcapture4jpgw(handle(tab_1.tabpage_1.dw_1), gnv_extfunc.of_getsystemtemppath() + '\capture.jpg', 100)
gnv_extfunc.biz_setcapture4jpgw(handle(parent), gnv_extfunc.of_getsystemtemppath() + '\capture.jpg', 100)
end event

type cb_4 from pf_u_commandbutton within w_exam4function1
integer x = 1298
integer y = 668
integer width = 1047
integer height = 124
integer taborder = 140
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "temp test"
end type

event clicked;call super::clicked;messagebox('', gnv_vari.ilupdate4error2num)
//dw_cond.enabled = false
//string	ls_error
//ls_error = tab_1.tabpage_1.dw_1.Modify("tmp_03.Values='1번	001/2번	002/3번	003/4번	004/5번	005'")
//uo_tab.of_setenabledtabpage(2,false)
//dw_cond.event wue_setedittoken44()

////uo_tab.of_settabtext(1, '(우리 나라 가나다(((')
//string	ls_url
//long	ll_rc
//
//ls_url = 'http://' + gnv_vari.getserverip + '/xml2csv-conv  c:\\Temp\\test.xml c:\\Temp\\test.csv'
//ll_rc = long(ole_xml.object.Navigate2(ls_url))
//messagebox('', ll_rc)

//gnv_rolemenu.of_setopensheet('00048')
end event

type cb_2 from pf_u_commandbutton within w_exam4function1
integer x = 1298
integer y = 820
integer width = 1047
integer height = 124
integer taborder = 150
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "asis msg"
end type

event clicked;call super::clicked;messagebox('Check', '프레임용 메시지 박스입니다.')

//dw_cond.ibsetlist4singleselect	= true
//dw_cond.of_setdataobject('d_sample_typeall_1')
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
end event

type cb_message1 from pf_u_commandbutton within w_exam4function1
integer x = 1298
integer y = 972
integer width = 1047
integer height = 124
integer taborder = 160
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "fw msg"
end type

event clicked;call super::clicked;gw_mdi.of_setmessagebox('Check', '프레임용 메시지 박스입니다.')

//dw_cond.ibsetlist4singleselect	= false
//dw_cond.of_setdataobject('d_sample_typeall_cond')
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
end event

