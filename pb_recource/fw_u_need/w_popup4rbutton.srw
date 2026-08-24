forward
global type w_popup4rbutton from w_response1st
end type
end forward

global type w_popup4rbutton from w_response1st
boolean visible = false
integer width = 914
integer height = 672
end type
global w_popup4rbutton w_popup4rbutton

on w_popup4rbutton.create
call super::create
end on

on w_popup4rbutton.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;Close(This)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_popup4rbutton
end type

type ln_tempstart from w_response1st`ln_tempstart within w_popup4rbutton
end type

type ln_templeft from w_response1st`ln_templeft within w_popup4rbutton
end type

type ln_cond_start from w_response1st`ln_cond_start within w_popup4rbutton
end type

type ln_tempright from w_response1st`ln_tempright within w_popup4rbutton
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_popup4rbutton
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_popup4rbutton
end type

