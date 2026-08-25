forward
global type fw_w_postcode from w_response1st
end type
type ole_postalweb from pf_u_webbrowser within fw_w_postcode
end type
type p_close from pf_u_imagebutton within fw_w_postcode
end type
type st_1 from statictext within fw_w_postcode
end type
type st_2 from statictext within fw_w_postcode
end type
type st_3 from statictext within fw_w_postcode
end type
type st_4 from statictext within fw_w_postcode
end type
end forward

global type fw_w_postcode from w_response1st
integer width = 3086
integer height = 2232
string title = "우편번호"
ole_postalweb ole_postalweb
p_close p_close
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
end type
global fw_w_postcode fw_w_postcode

type variables
String		is_postalurl = ''
String		is_rtnvalue[], is_rtnnull[]
fw_s_postalvalue	istr_postalvalue
end variables

on fw_w_postcode.create
int iCurrent
call super::create
this.ole_postalweb=create ole_postalweb
this.p_close=create p_close
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_postalweb
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
end on

on fw_w_postcode.destroy
call super::destroy
destroy(this.ole_postalweb)
destroy(this.p_close)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
end on

event open;call super::open;is_postalurl = 'http://' + gnv_vari.SetWASSignupIP + '/daum_postcode.html'

ole_postalweb.object.navigate(is_postalurl)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_postcode
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_postcode
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_postcode
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_postcode
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_postcode
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_postcode
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_postcode
end type

type ole_postalweb from pf_u_webbrowser within fw_w_postcode
integer y = 156
integer width = 3122
integer height = 1988
integer taborder = 40
borderstyle borderstyle = stylebox!
string binarykey = "fw_w_postcode.win"
end type

event navigatecomplete2;call super::navigatecomplete2;String		ls_url, ls_htmlurl
String		ls_args[] = {'postcode', 'address', 'zonecode', 'addressEnglish' , 'postcode_old', 'jibunAddress'}
Long		ll_pos, ll_index= 0, ll_pos_n, ll_cnt

//ls_url 			= string(url )
ls_url		= String(This.of_geturl( ))
ls_htmlurl	= is_postalurl + '?'
is_rtnvalue[]	= is_rtnnull[]

ll_pos = pos(ls_url,ls_htmlurl)
If ll_pos > 0 Then
	ls_url	= mid(ls_url , len(ls_htmlurl) + 1, len(ls_url) - len(ls_htmlurl))
	ll_cnt	= upperbound(ls_args)
	Do While true
		If ll_index >= ll_cnt Then Exit
		ll_index ++
		ll_pos 	= pos(ls_url, ls_args[ll_index] + '=')
		ll_pos_n  = pos(ls_url, '&', ll_pos)
		If ll_pos > 0 Then
			If ll_pos_n = 0 Then 
				is_rtnvalue[ll_index] = mid(ls_url , ll_pos + len(ls_args[ll_index]+'=') )
			Else
				is_rtnvalue[ll_index] = mid(ls_url , ll_pos + len(ls_args[ll_index]+'=') , ll_pos_n -  len(ls_args[ll_index] + '=') - 1)
				ls_url					= mid(ls_url, ll_pos_n + 1)
			End If
		End If
	Loop
	
	istr_postalvalue.postcode		= is_rtnvalue[1]
	istr_postalvalue.address			= is_rtnvalue[2]
	istr_postalvalue.zonecode		= is_rtnvalue[3]
	istr_postalvalue.addressEnglish	= is_rtnvalue[4]
	istr_postalvalue.postcode_old	= is_rtnvalue[5]
	istr_postalvalue.jibunAddress	= is_rtnvalue[6]
	
	CloseWithReturn ( Parent, istr_postalvalue )
End If
end event

type p_close from pf_u_imagebutton within fw_w_postcode
integer x = 2761
integer y = 28
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;Close(Parent)

end event

type st_1 from statictext within fw_w_postcode
integer y = 132
integer width = 3136
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_2 from statictext within fw_w_postcode
integer y = 2108
integer width = 3136
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_3 from statictext within fw_w_postcode
integer y = 132
integer width = 40
integer height = 2020
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_4 from statictext within fw_w_postcode
integer x = 2990
integer y = 132
integer width = 146
integer height = 2020
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

