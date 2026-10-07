forward
global type n_dwr_service_excel from nonvisualobject
end type
end forward

global type n_dwr_service_excel from nonvisualobject
end type
global n_dwr_service_excel n_dwr_service_excel

type variables
private n_dwr_service invo_dwr
public n_dwr_workbook invo_writer
public n_dwr_workbook inv_book
protected n_dwr_const inv_const
private string is_filename
private boolean ib_init = false

end variables

forward prototypes
public function integer of_close_wb ()
public function integer of_create_wb (string as_filename, ref n_dwr_service_parm anvo_parm)
public function integer of_save_dw2sheet (ref datawindow adw_dw, ref n_dwr_service_parm anvo_parm)
public function integer of_save_ds2sheet (ref ads_jTier ads_ds, ref n_dwr_service_parm anvo_parm)
public function integer of_store_multidw_sheet ()
protected function integer of_save_2cursheet (powerobject apo_requestor)
public function integer of_save_dw2cursheet (datawindow adw_dw)
public function integer of_save_ds2cursheet (ads_jTier ads_ds)
public function integer of_end_multidw_line ()
public function integer of_add_multidw_vspacer (long al_height)
public function integer of_add_multidw_hspacer (long al_width)
public function integer of_create_multidw_sheet (n_dwr_service_parm anvo_parm)
end prototypes

public function integer of_close_wb ();integer li_ret = 1

if ib_init then
	li_ret = invo_dwr.of_close()
	
	destroy invo_writer
	destroy invo_dwr
	
	if li_ret <> 1 then FileDelete(is_filename)
	ib_init = false
else
	messagebox('DW2XLS-Error', 'Workbook was not created!')
end if

return li_ret
end function

public function integer of_create_wb (string as_filename, ref n_dwr_service_parm anvo_parm);integer li_ret = 1
long ll_error

if not(ib_init) then
	if isNull(anvo_parm) and not isValid(anvo_parm) then anvo_parm = create n_dwr_service_parm
	
	invo_dwr = create n_dwr_service
	
	invo_dwr.ib_multisheet = true
	inv_book = Create n_dwr_workbook

	inv_book.invo_parm = anvo_parm
	if not anvo_parm.ib_nonvisual_calc_height then
		open(inv_book.ws)
	end if
	
	invo_writer = inv_book //legacy
	ll_error = inv_book.of_create(anvo_parm.is_version, as_filename, true)
	if ll_error <> inv_const.S_OK then 
		return -1
	end if
	is_filename = as_filename
	
	ib_init = true
else
	messagebox('DW2XLS Error', 'Workbook already created!')
end if

return li_ret
end function

public function integer of_save_dw2sheet (ref datawindow adw_dw, ref n_dwr_service_parm anvo_parm);integer li_ret = 1
n_dwr_nested_service_parm lnvo_nested_parm

if ib_init then 
	li_ret = invo_dwr.of_create(adw_dw, inv_book, is_filename, anvo_parm, lnvo_nested_parm)
	
	if li_ret = 1 then
		li_ret = invo_dwr.of_process()
	end if
else
	messagebox('DW2XLS-Error', 'There is no created Workbook!')
	li_ret = -1
end if

return li_ret
end function

public function integer of_save_ds2sheet (ref ads_jTier ads_ds, ref n_dwr_service_parm anvo_parm);integer li_ret = 1
n_dwr_nested_service_parm lnvo_nested_parm

if ib_init then 
	li_ret = invo_dwr.of_create(ads_ds, inv_book, is_filename, anvo_parm, lnvo_nested_parm)
	
	if li_ret = 1 then
		li_ret = invo_dwr.of_process()
	end if
else
	messagebox('DW2XLS-Error', 'There is no created Workbook!')
	li_ret = -1
end if
return li_ret

end function

public function integer of_store_multidw_sheet ();integer li_ret = 1
if ib_init then 
	li_ret = invo_dwr.of_store_multidw()
else
	messagebox('DW2XLS-Error', 'There is no created Workbook!')
	li_ret = -1
end if
return li_ret

end function

protected function integer of_save_2cursheet (powerobject apo_requestor);integer li_ret = 1
if ib_init then 
	li_ret = invo_dwr.of_export_to_current_sheet(apo_requestor)
else
	messagebox('DW2XLS-Error', 'There is no created Workbook!')
	li_ret = -1
end if
return li_ret

end function

public function integer of_save_dw2cursheet (datawindow adw_dw);return of_save_2cursheet(adw_dw)
end function

public function integer of_save_ds2cursheet (ads_jTier ads_ds);return of_save_2cursheet(ads_ds)
end function

public function integer of_end_multidw_line ();
Return invo_dwr.of_multidw_endln()

end function

public function integer of_add_multidw_vspacer (long al_height);
Return invo_dwr.of_multidw_add_vspacer(al_height)

end function

public function integer of_add_multidw_hspacer (long al_width);Return invo_dwr.of_multidw_add_hspacer(al_width)
end function

public function integer of_create_multidw_sheet (n_dwr_service_parm anvo_parm);integer li_ret = 1
if ib_init then 
	li_ret = invo_dwr.of_create_multidw(inv_book, is_filename, anvo_parm)
else
	messagebox('DW2XLS-Error', 'There is no created Workbook!')
	li_ret = -1
end if
return li_ret

end function

on n_dwr_service_excel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_service_excel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;inv_const = create n_dwr_const
end event

