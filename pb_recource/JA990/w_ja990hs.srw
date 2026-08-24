forward
global type w_ja990hs from w_response_s
end type
type cb_3 from pf_u_commandbutton within w_ja990hs
end type
type cb_2 from pf_u_commandbutton within w_ja990hs
end type
type cb_1 from pf_u_commandbutton within w_ja990hs
end type
end forward

global type w_ja990hs from w_response_s
integer width = 1902
integer height = 972
string title = "분할채 상환내역"
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
end type
global w_ja990hs w_ja990hs

type variables
Datawindow  ldw
LONG	iRow

end variables

on w_ja990hs.create
int iCurrent
call super::create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
end on

on w_ja990hs.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event wue_postopen;call super::wue_postopen;ldw = message.PowerObjectParm

iRow = ldw.getRow ()

dw_view.setTransObject(SQLCA)
IF dw_view.retrieve (gaa.corp_gr, ldw.object.jm_cd [iRow])=0 Then
   dw_view.insertrow (0)
   dw_view.object.corp_gr [1] = gaa.corp_gr
   dw_view.object.jm_cd [1] = ldw.object.jm_cd [iRow]
   dw_view.object.com_geochi_iyul [1] = ldw.object.com_pyom_iyul [iRow]
   dw_view.object.com_sanghw_iyul [1] = ldw.object.com_pyom_iyul [iRow]
   dw_view.object.geochi_iyul [1] = ldw.object.pyom_iyul [iRow]
   dw_view.object.sanghw_iyul [1] = ldw.object.pyom_iyul [iRow]
End IF

f_center (THIS)
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_ja990hs
end type

type ln_tempstart from w_response_s`ln_tempstart within w_ja990hs
end type

type ln_templeft from w_response_s`ln_templeft within w_ja990hs
end type

type ln_cond_start from w_response_s`ln_cond_start within w_ja990hs
end type

type ln_tempright from w_response_s`ln_tempright within w_ja990hs
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_ja990hs
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_ja990hs
end type

type dw_view from w_response_s`dw_view within w_ja990hs
integer width = 1810
integer height = 716
integer taborder = 30
string dataobject = "d_code70s"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = stylelowered!
end type

event itemchanged;CHOOSE CASE dwo.name
   CASE 'sanghw_gigan'
      IF Object.sanghw_gb [row]='1' Then
         Object.com_sanghw_biyul [row] = 100.0 / dec (data)
         Object.sanghw_biyul [row] = Object.com_sanghw_biyul [row] / 100.0
      Else
         Object.com_sanghw_biyul [row] = null_dc
      End IF

   CASE 'com_geochi_iyul'
      Object.geochi_iyul [row] = dec (data) / 100.0

   CASE 'com_sanghw_iyul'
      Object.sanghw_iyul [row] = dec (data) / 100.0

   CASE 'com_sanghw_biyul'
      Object.sanghw_biyul [row] = dec (data) / 100.0
END CHOOSE
end event

type cb_3 from pf_u_commandbutton within w_ja990hs
integer x = 1289
integer y = 768
integer width = 457
integer height = 92
integer taborder = 30
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "종료"
end type

event clicked;CLOSE (parent)

end event

type cb_2 from pf_u_commandbutton within w_ja990hs
integer x = 722
integer y = 768
integer width = 457
integer height = 92
integer taborder = 20
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "삭제"
end type

event clicked;STRING	jm_cd

jm_cd = ldw.object.jm_cd [iRow]

DELETE  scm0cj
WHERE   jm_cd = :jm_cd;

DELETE  scm0cl
WHERE   jm_cd = :jm_cd;

CLOSE (parent)

end event

type cb_1 from pf_u_commandbutton within w_ja990hs
integer x = 155
integer y = 768
integer width = 457
integer height = 92
integer taborder = 20
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장"
boolean default = true
end type

event clicked;dw_view.update ()
Close (parent)

end event

