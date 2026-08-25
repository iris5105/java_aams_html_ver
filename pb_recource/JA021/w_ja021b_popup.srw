forward
global type w_ja021b_popup from w_response1st
end type
type dw_1 from u_dw within w_ja021b_popup
end type
end forward

global type w_ja021b_popup from w_response1st
integer width = 2990
integer height = 1372
string title = "종목별 확정배당 등록"
event type boolean ue_wpage_modified ( )
event type integer wue_update ( )
event type boolean ue_wpage_updatetable ( )
dw_1 dw_1
end type
global w_ja021b_popup w_ja021b_popup

type variables
str_parameter   sp
end variables

event type boolean ue_wpage_modified();RETURN FALSE
end event

event type integer wue_update();RETURN 0
end event

event type boolean ue_wpage_updatetable();RETURN FALSE
end event

on w_ja021b_popup.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_ja021b_popup.destroy
call super::destroy
destroy(this.dw_1)
end on

event key;IF key=KeyEscape! THEN CLOSE (THIS)
end event

event close;dw_1.update ()
end event

event wue_postopen;call super::wue_postopen;dw_1.SetTransObject (SQLCA)
dw_1.of_dw2subbtn ({'p_delete'}, true)
	
f_center (THIS)

sp = Message.PowerObjectParm

SELECT  aekm
  INTO  :sp.dc [1]
FROM    sjx0jb t1
WHERE   balh_co = :sp.str [2];

sp.dc [1] = SQLCA.getitemnumber (1)

dw_1.retrieve ('%', sp.dt [1], sp.str [1], sp.str [2])
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_ja021b_popup
end type

type ln_tempstart from w_response1st`ln_tempstart within w_ja021b_popup
end type

type ln_templeft from w_response1st`ln_templeft within w_ja021b_popup
end type

type ln_cond_start from w_response1st`ln_cond_start within w_ja021b_popup
end type

type ln_tempright from w_response1st`ln_tempright within w_ja021b_popup
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_ja021b_popup
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_ja021b_popup
end type

type dw_1 from u_dw within w_ja021b_popup
integer x = 50
integer y = 128
integer width = 2885
integer height = 1116
integer taborder = 10
boolean enabled = true
string title = "배당율등록"
string dataobject = "d_ja021b_p1"
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0000010000"
end type

event retrieveend;call super::retrieveend;IF	rowcount=0	Then
	LONG	lR, ll

	STRING	ls_sqlsyntax

	aDS_jTier	lds_jtier

	ls_sqlsyntax  = "   SELECT  jm_cd " &
					  + "         , jj_nm " &
					  + "   FROM    sjm0jj " &
					  + "   WHERE   balh_co = '" + sp.str [2] + "' " &
					  + "     AND   danc_gb IN ('A','C','D') " &
					  + "   ORDER BY  1 desc "

	lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'rs')

	FOR  ll = 1  TO  lR
		dw_1.insertrow (1)
		dw_1.object.corp_gr [1] = '%'
		dw_1.object.tr_ymd [1] = sp.dt [1]
		dw_1.object.tr_cd [1] = sp.str [1]
		dw_1.object.balh_co [1] = sp.str [2]
		dw_1.object.jj_cd [1] = lds_jtier.getitemstring (ll, 1)
		dw_1.object.xx_jj_cd [1] = lds_jtier.getitemstring (ll, 2)
	NEXT
End IF
end event

event itemchanged_next;call super::itemchanged_next;CHOOSE CASE name
	CASE 'baed_aek'
		Object.cash_per [row] = truncate (Object.baed_aek [row] / sp.dc [1] * 100., 4)
		Object.cash_rt [row] = Object.baed_aek [row] / sp.dc [1]
	CASE 'stock_per'
		Object.stock_rt [row] = Object.stock_per [row] / 100.
END CHOOSE
end event

