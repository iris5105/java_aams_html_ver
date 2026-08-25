forward
global type w_ja050_popup from w_response1st
end type
type cbx_1 from pf_u_checkbox within w_ja050_popup
end type
type dw_detail from u_dw within w_ja050_popup
end type
type dw_list from u_dw within w_ja050_popup
end type
end forward

global type w_ja050_popup from w_response1st
integer width = 5381
integer height = 3512
string title = "Untitled"
boolean minbox = true
windowtype windowtype = popup!
boolean center = true
event ue_open ( )
cbx_1 cbx_1
dw_detail dw_detail
dw_list dw_list
end type
global w_ja050_popup w_ja050_popup

type variables
LONG	iRow

str_parameter  sp
end variables

event ue_open();DateTime ldt

SELECT  hyun_ymd
  INTO  :ldt
FROM    szx0aa t1
WHERE   t1.corp_gr = :sp.str[4];
ldt = SQLCA.getitemdatetime (1)

dw_List.retrieve (sp.str [4], ldt, sp.str [1], sp.str [2])
end event

on w_ja050_popup.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_detail=create dw_detail
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_list
end on

on w_ja050_popup.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.dw_detail)
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;sp = Message.PowerObjectParm
TITLE = sp.str [4] + ':' + string (sp.dt [1],'yyyy.mm.dd') + ' ' + sp.str [1] + ' ' + sp.str [2] + '(' + sp.str [3] + ') 계정 상세내역'

dw_List.SetTransObject (SQLCA)
dw_List.EVENT ue_dddw_retrieve ()

dw_Detail.SetTransObject (SQLCA)
dw_Detail.EVENT ue_dddw_retrieve ()

POST EVENT ue_open ()
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_ja050_popup
end type

type ln_tempstart from w_response1st`ln_tempstart within w_ja050_popup
end type

type ln_templeft from w_response1st`ln_templeft within w_ja050_popup
end type

type ln_cond_start from w_response1st`ln_cond_start within w_ja050_popup
end type

type ln_tempright from w_response1st`ln_tempright within w_ja050_popup
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_ja050_popup
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_ja050_popup
end type

type cbx_1 from pf_u_checkbox within w_ja050_popup
integer x = 2656
integer y = 28
integer width = 343
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 553648127
string text = "수기분개"
boolean setcondcolor = true
end type

event clicked;call super::clicked;IF iRow>0 Then
	dw_Detail.uf_reset ()
	dw_Detail.EVENT ue_retrieve ()
End IF
end event

type dw_detail from u_dw within w_ja050_popup
integer x = 2633
integer y = 24
integer width = 2693
integer height = 3364
integer taborder = 20
string dataobject = "d_ja050_p2"
boolean vscrollbar = true
boolean ibsetlist4singleselect = false
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, FALSE)
end event

event ue_retrieve;call super::ue_retrieve;STRING	ls_rt_key, ls_sr_err_msg, la_args[]

Datetime	ldt

f_loadingrd (TRUE)

ls_rt_key = sp.str [4] + gnv_vari.is_user_id + f_sysdate_str ('hh24miss')
ldt = dw_List.object.ymd [iRow]

la_args[1] = sp.str[4]
la_args[2] = ls_rt_key
la_args[3] = string (ldt, 'yyyy.mm.dd')
la_args[4] = sp.str[1]
IF cbx_1.checked  Then
   la_args[5] = '9'
Else
   la_args[5] = '999'
End IF
SQLCA.SP_CALL (THIS, 'SR_AC_POPUP ( ?, ?, ?, ?, ? )', la_args[], ls_sr_err_msg)

retrieve (ls_rt_key, sp.str [2])

f_loadingrd (FALSE)
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tr_cd', gaa.corp_gr, '', 1, '')
end event

type dw_list from u_dw within w_ja050_popup
integer x = 50
integer y = 24
integer width = 2574
integer height = 3364
integer taborder = 10
string dataobject = "d_ja050_p1"
boolean vscrollbar = true
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;IF rowcount =0 THEN dw_detail.uf_retrieveend ('', 0, FALSE)
uf_retrieveend ('', rowcount, FALSE)

LONG	ll

IF rowcount>0  Then
   ll = FIND ("ymd=date ('" + string (sp.dt [1],'yyyy.mm.dd') + "')", 1, rowcount )
   IF ll>0  Then
      ScrollToRow (ll)
      SetRow (ll)
   End IF
End IF
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow
dw_detail.uf_reset ()
dw_detail.EVENT ue_retrieve ()
RETURN 0
end event

