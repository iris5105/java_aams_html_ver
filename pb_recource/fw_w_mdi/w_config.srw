forward
global type w_config from window
end type
type mle_1 from u_mle within w_config
end type
end forward

global type w_config from window
integer width = 2464
integer height = 1216
boolean titlebar = true
string title = "초기환경설정"
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
mle_1 mle_1
end type
global w_config w_config

on w_config.create
this.mle_1=create mle_1
this.Control[]={this.mle_1}
end on

on w_config.destroy
destroy(this.mle_1)
end on

event open;mle_1.text = 'login.last.corp_gr=2200~r~nlogin.last.user_id=yjs1992@hitel.net~r~n~r~nconnect.last.jtier.url=app.aams.kr~r~nconnect.last.jtier.url.message=No~r~n~r~nconnect.' + gnv_vari.is_macaddress + '=PASSWORD'
end event

event close;STRING	la_text [], ls_section, ls_key, ls_value

LONG	ll, ll_text

ll_text = f_get_array (mle_1.text, '~r~n', la_text)
FOR  ll = 1  TO  ll_text
	IF	f_notnull (la_text [ll])	Then
		ls_key     = LEFT (la_text [ll], POS (la_text [ll],'=') - 1)
		ls_value   = MID (la_text [ll], POS (la_text [ll],'=') + 1)
		ls_section = LEFT (ls_key, POS (ls_key,'.') - 1)
		IF	ls_key='connect.'+gnv_vari.is_macaddress	Then
			SetProfileString (gaa.config, ls_section, 'connect.' + gnv_vari.is_macaddress, ls_value)
		Else
			IF	ls_key='connect.last.jtier.url'	Then
				ls_value ='http://' + ls_value + ':15700/jtier?'
				SELECT TO_ENCRYPTS (:ls_value) INTO :ls_value FROM DUAL;
				ls_value = SQLCA.GETITEMSTRING (1)
			End IF
			SetProfileString (gaa.config, ls_section, ls_key, ls_value)
		End IF
	End IF
NEXT
end event

type mle_1 from u_mle within w_config
integer x = 55
integer y = 44
integer width = 2322
integer height = 1028
integer taborder = 10
boolean enabled = true
end type

event constructor;//
end event

