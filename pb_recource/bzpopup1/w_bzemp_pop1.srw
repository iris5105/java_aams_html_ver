forward
global type w_bzemp_pop1 from w_response1st5ncn
end type
type dw_empl from fw_u_dwo within w_bzemp_pop1
end type
type uo_dept from u_dept1 within w_bzemp_pop1
end type
end forward

global type w_bzemp_pop1 from w_response1st5ncn
integer width = 4782
integer height = 2444
string title = "임직원조회"
dw_empl dw_empl
uo_dept uo_dept
end type
global w_bzemp_pop1 w_bzemp_pop1

type variables
Private:
	pf_n_hashtable	inv_hash
	
	String		is_findSyntax

end variables

forward prototypes
public function string of_gettaskgb ()
end prototypes

public function string of_gettaskgb ();Return 'EMP'
end function

on w_bzemp_pop1.create
int iCurrent
call super::create
this.dw_empl=create dw_empl
this.uo_dept=create uo_dept
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_empl
this.Control[iCurrent+2]=this.uo_dept
end on

on w_bzemp_pop1.destroy
call super::destroy
destroy(this.dw_empl)
destroy(this.uo_dept)
end on

event wue_postopen;call super::wue_postopen;fw_f_setdddw(dw_empl, 'duty_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP004', '%'})
fw_f_setdddw(dw_empl, 'rank_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP005', '%'})

dw_empl.SetTransObject( sqlca )

uo_dept.of_drawmenu()

uo_dept.em_findstr.text = gnv_vari.is_dept_cd

uo_dept.p_search.Post Event Clicked()

uo_dept.Post of_clearfindstr()
end event

event wue_ok;call super::wue_ok;Long		ll_Row
IF Not IsValid(inv_hash) THEN inv_hash = Create pf_n_hashtable

dw_empl.AcceptText()
IF dw_empl.rowcount() > 0 THEN
	ll_Row = dw_empl.getRow()

	inv_hash.of_put('sys_id'		, dw_empl.getItemString(ll_row, 'sys_id'))
	inv_hash.of_put('dept_cd'	, dw_empl.getItemString(ll_row, 'dept_cd'))
	inv_hash.of_put('dept_nm'	, dw_empl.getItemString(ll_row, 'dept_nm'))
	inv_hash.of_put('user_id'		, dw_empl.getItemString(ll_row, 'user_id'))
	inv_hash.of_put('user_nm'	, dw_empl.getItemString(ll_row, 'user_nm'))
	inv_hash.of_put('rank_cd'		, dw_empl.getItemString(ll_row, 'rank_cd')) //dw_empl.Describe("Evaluate( ' lookupdisplay(duty_nm) ' , " + String( ll_Row ) + " )"  ) )
	inv_hash.of_put('duty_cd'		, dw_empl.getItemString(ll_row, 'duty_cd'))
	inv_hash.of_put('tel_no2'		, dw_empl.getItemString(ll_row, 'tel_no2'))

	CloseWithReturn(this, inv_hash)
ELSE
	p_close.Event Clicked()
END IF


end event

type ln_tempbutton from w_response1st5ncn`ln_tempbutton within w_bzemp_pop1
end type

type ln_tempstart from w_response1st5ncn`ln_tempstart within w_bzemp_pop1
end type

type ln_templeft from w_response1st5ncn`ln_templeft within w_bzemp_pop1
end type

type ln_cond_start from w_response1st5ncn`ln_cond_start within w_bzemp_pop1
end type

type ln_tempright from w_response1st5ncn`ln_tempright within w_bzemp_pop1
end type

type ln_cond1_yline from w_response1st5ncn`ln_cond1_yline within w_bzemp_pop1
end type

type ln_dw1_yline from w_response1st5ncn`ln_dw1_yline within w_bzemp_pop1
end type

type p_print from w_response1st5ncn`p_print within w_bzemp_pop1
integer x = 50
end type

type p_delete from w_response1st5ncn`p_delete within w_bzemp_pop1
integer x = 50
end type

type p_new from w_response1st5ncn`p_new within w_bzemp_pop1
integer x = 50
end type

type p_close from w_response1st5ncn`p_close within w_bzemp_pop1
boolean visible = true
integer x = 4498
end type

type p_cancel from w_response1st5ncn`p_cancel within w_bzemp_pop1
integer x = 50
end type

type p_ok from w_response1st5ncn`p_ok within w_bzemp_pop1
boolean visible = true
integer x = 4261
end type

event p_ok::clicked;call super::clicked;Parent.PostEvent("wue_ok")
end event

type p_preview from w_response1st5ncn`p_preview within w_bzemp_pop1
integer x = 50
end type

type p_update from w_response1st5ncn`p_update within w_bzemp_pop1
integer x = 50
end type

type p_excel from w_response1st5ncn`p_excel within w_bzemp_pop1
integer x = 50
end type

type p_clear from w_response1st5ncn`p_clear within w_bzemp_pop1
integer x = 50
end type

type p_modify from w_response1st5ncn`p_modify within w_bzemp_pop1
integer x = 50
end type

type p_retrieve from w_response1st5ncn`p_retrieve within w_bzemp_pop1
integer x = 4023
end type

type p_tempsave from w_response1st5ncn`p_tempsave within w_bzemp_pop1
integer x = 50
end type

type p_collect from w_response1st5ncn`p_collect within w_bzemp_pop1
integer x = 50
end type

type dw_empl from fw_u_dwo within w_bzemp_pop1
integer x = 1298
integer y = 156
integer width = 3433
integer height = 2176
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_bzemp_pop1_1"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4singleselect = true
end type

event doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

parent.Event wue_ok()
end event

type uo_dept from u_dept1 within w_bzemp_pop1
event destroy ( )
integer x = 50
integer y = 156
integer width = 1221
integer height = 2172
integer taborder = 50
boolean bringtotop = true
borderstyle borderstyle = styleshadowbox!
boolean scaletoright = true
boolean scaletobottom = true
end type

on uo_dept.destroy
call u_dept1::destroy
end on

event oue_clicked;call super::oue_clicked;Long		ll_ret, ll_row

ll_row	= dw_empl.Getrow()
ll_ret	= dw_empl.Retrieve(gnv_vari.is_sys_id, as_dept_cd, gnv_vari.is_lang_type)

Choose Case ll_ret
	Case is > 0
		If ll_row > 0 Then dw_empl.Event RowFocusChanged(1)
	Case 0
		//MessageBox("Check", "Search된 자료가 없습니다.")
	Case is < 0
		MessageBox("Error", "Search Error")
End Choose
end event

