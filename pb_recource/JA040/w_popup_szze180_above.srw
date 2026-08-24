forward
global type w_popup_szze180_above from w_response1st
end type
type dw_1 from u_dw within w_popup_szze180_above
end type
end forward

global type w_popup_szze180_above from w_response1st
integer width = 5051
integer height = 3116
string title = "우선배당 동일분류 펀드현황"
dw_1 dw_1
end type
global w_popup_szze180_above w_popup_szze180_above

type variables
wt_listdetail   lu_object

LONG	il_list

end variables

on w_popup_szze180_above.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_popup_szze180_above.destroy
call super::destroy
destroy(this.dw_1)
end on

event key;IF key=KeyEscape! THEN CLOSE (THIS)
end event

event wue_postopen;call super::wue_postopen;dw_1.SetTransObject (SQLCA)

f_center (THIS)

lu_object = Message.PowerObjectParm

il_list = lu_object.dw_list.getrow ()
f_dddwctl (dw_1, 'corp_gr', gaa.corp_gr, '', 1, '')
f_dddwctl (dw_1, 'above_gb', gaa.corp_gr, '', 1, '')
dw_1.of_dw2subbtn ({'p_excel'}, true)
dw_1.retrieve (lu_object.dw_list.object.above_gb [il_list])
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_popup_szze180_above
end type

type ln_tempstart from w_response1st`ln_tempstart within w_popup_szze180_above
end type

type ln_templeft from w_response1st`ln_templeft within w_popup_szze180_above
end type

type ln_cond_start from w_response1st`ln_cond_start within w_popup_szze180_above
end type

type ln_tempright from w_response1st`ln_tempright within w_popup_szze180_above
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_popup_szze180_above
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_popup_szze180_above
end type

type dw_1 from u_dw within w_popup_szze180_above
integer x = 50
integer y = 128
integer width = 4923
integer height = 2864
integer taborder = 10
boolean enabled = true
string title = "보수율 등록"
string dataobject = "d_szze180_above"
boolean vscrollbar = true
boolean livescroll = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "00100000000"
end type

