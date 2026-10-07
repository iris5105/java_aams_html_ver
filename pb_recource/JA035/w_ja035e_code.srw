forward
global type w_ja035e_code from w_response_s
end type
end forward

global type w_ja035e_code from w_response_s
string title = "권리락 처리현황"
end type
global w_ja035e_code w_ja035e_code

type variables
w_ja035e   lu
end variables

event key;call super::key;IF	key=KeyEscape!	THEN CLOSE (THIS)
end event

on w_ja035e_code.create
call super::create
end on

on w_ja035e_code.destroy
call super::destroy
end on

event wue_lastinst;call super::wue_lastinst;lu = Message.PowerObjectParm
lu.ids_code.ShareData (dw_view)
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_ja035e_code
end type

type ln_tempstart from w_response_s`ln_tempstart within w_ja035e_code
end type

type ln_templeft from w_response_s`ln_templeft within w_ja035e_code
end type

type ln_cond_start from w_response_s`ln_cond_start within w_ja035e_code
end type

type ln_tempright from w_response_s`ln_tempright within w_ja035e_code
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_ja035e_code
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_ja035e_code
end type

type dw_view from w_response_s`dw_view within w_ja035e_code
string dataobject = "d_ja035e_code"
end type

event dw_view::doubleclicked;call super::doubleclicked;LONG  ll

CHOOSE CASE dwo.Type
   CASE 'column'
      ll = lu.dw_list.getrow ()
      lu.dw_list.object.corp_gr [ll] = Object.corp_gr [row]
      lu.dw_list.object.fund_cd [ll] = Object.fund_cd [row]
      lu.dw_list.object.fund_nm [ll] = Object.fund_nm [row]
      lu.dw_list.object.yj_cd [ll] = Object.jm_cd [row]
      lu.dw_list.object.xx_yj_cd [ll] = Object.jm_nm [row]
      lu.dw_list.object.trustee [ll] = Object.trustee [row]
      lu.dw_list.object.currency [ll] = Object.currency [row]
      lu.dw_list.object.hwakj_ymd [ll] = Object.hwakj_ymd [row]
      lu.dw_list.object.hwakj_jusu [ll] = Object.hwakj_jusu [row]
      lu.dw_list.object.hwakj_per [ll] = Object.hwakj_per [row]
      lu.dw_list.object.jusu [ll] = Object.jusu [row]
      lu.dw_list.object.aek [ll] = Object.aek [row]
      lu.dw_list.object.tax_per [ll] = Object.tax_per [row]
      lu.dw_list.object.tax_aek [ll] = Object.tax_aek [row]
      lu.dw_list.object.bs_type [ll] = 0
      lu.dw_list.object.org_won_aek [ll] = Object.won_aek [row]
      lu.dw_list.object.org_won_tax_aek [ll] = Object.won_tax_aek [row]
      lu.dw_list.object.org_pyunga_join [ll] = Object.pyunga_join [row]
      lu.dw_list.object.yg_rowid [ll] = Object.yg_rowid [row]
		deleterow (row)
      CLOSE (parent)
END CHOOSE
end event

