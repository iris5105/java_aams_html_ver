forward
global type w_saveas from w_response1st
end type
type dw_save from fw_u_dwo within w_saveas
end type
end forward

global type w_saveas from w_response1st
boolean visible = false
integer width = 2542
integer height = 1436
long backcolor = 67108864
dw_save dw_save
end type
global w_saveas w_saveas

on w_saveas.create
int iCurrent
call super::create
this.dw_save=create dw_save
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_save
end on

on w_saveas.destroy
call super::destroy
destroy(this.dw_save)
end on

event open;call super::open;fw_u_dwo ldw_Save

ldw_Save = Message.POwerObjectParm

dw_Save.DataObject = ldw_Save.DataObject

dw_Save.object.Data = ldw_Save.object.Data.Selected
f_saveas_new (dw_Save)

CLOSE (THIS)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_saveas
end type

type ln_tempstart from w_response1st`ln_tempstart within w_saveas
end type

type ln_templeft from w_response1st`ln_templeft within w_saveas
end type

type ln_cond_start from w_response1st`ln_cond_start within w_saveas
end type

type ln_tempright from w_response1st`ln_tempright within w_saveas
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_saveas
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_saveas
end type

type dw_save from fw_u_dwo within w_saveas
integer x = 50
integer y = 24
integer width = 2418
integer height = 1288
integer taborder = 10
end type

