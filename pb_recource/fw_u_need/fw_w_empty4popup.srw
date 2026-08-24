forward
global type fw_w_empty4popup from w_response1st5ncn
end type
end forward

global type fw_w_empty4popup from w_response1st5ncn
boolean visible = false
integer width = 914
integer height = 672
end type
global fw_w_empty4popup fw_w_empty4popup

on fw_w_empty4popup.create
call super::create
end on

on fw_w_empty4popup.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;Close(This)
end event

type ln_tempbutton from w_response1st5ncn`ln_tempbutton within fw_w_empty4popup
end type

type ln_tempstart from w_response1st5ncn`ln_tempstart within fw_w_empty4popup
end type

type ln_templeft from w_response1st5ncn`ln_templeft within fw_w_empty4popup
end type

type ln_cond_start from w_response1st5ncn`ln_cond_start within fw_w_empty4popup
end type

type ln_tempright from w_response1st5ncn`ln_tempright within fw_w_empty4popup
end type

type ln_cond1_yline from w_response1st5ncn`ln_cond1_yline within fw_w_empty4popup
end type

type ln_dw1_yline from w_response1st5ncn`ln_dw1_yline within fw_w_empty4popup
end type

type p_print from w_response1st5ncn`p_print within fw_w_empty4popup
integer x = 110
end type

type p_delete from w_response1st5ncn`p_delete within fw_w_empty4popup
integer x = 110
end type

type p_new from w_response1st5ncn`p_new within fw_w_empty4popup
integer x = 110
end type

type p_close from w_response1st5ncn`p_close within fw_w_empty4popup
end type

type p_cancel from w_response1st5ncn`p_cancel within fw_w_empty4popup
integer x = 3099
end type

type p_ok from w_response1st5ncn`p_ok within fw_w_empty4popup
integer x = 2857
end type

type p_preview from w_response1st5ncn`p_preview within fw_w_empty4popup
integer x = 110
end type

type p_update from w_response1st5ncn`p_update within fw_w_empty4popup
integer x = 110
end type

type p_excel from w_response1st5ncn`p_excel within fw_w_empty4popup
end type

type p_clear from w_response1st5ncn`p_clear within fw_w_empty4popup
integer x = 110
end type

type p_modify from w_response1st5ncn`p_modify within fw_w_empty4popup
integer x = 110
end type

type p_retrieve from w_response1st5ncn`p_retrieve within fw_w_empty4popup
end type

type p_tempsave from w_response1st5ncn`p_tempsave within fw_w_empty4popup
integer x = 110
end type

type p_collect from w_response1st5ncn`p_collect within fw_w_empty4popup
integer x = 110
end type

type p_select from w_response1st5ncn`p_select within fw_w_empty4popup
integer x = 110
end type

