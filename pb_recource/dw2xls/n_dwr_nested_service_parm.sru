forward
global type n_dwr_nested_service_parm from nonvisualobject
end type
end forward

shared variables

end variables

global type n_dwr_nested_service_parm from nonvisualobject
end type
global n_dwr_nested_service_parm n_dwr_nested_service_parm

type variables
public n_dwr_grid invo_global_vgrid
public n_dwr_grid invo_dynamic_hgrid
public n_xls_worksheet invo_cur_sheet
public n_dwr_worksheet inv_sheet
//public n_dwr_sub invo_sub
public n_dwr_colors invo_colors
public PowerObject ipo_dynamic_requestor
public long il_nested_x = 0
public long il_nested_y = 0
public string is_parent_band_id = "1"
//public long il_change_progress_each = 1

//inout
public long il_writer_row = -1
public long il_parent_row = -1
//public long il_cur_change_progress = 0

// workaround for nested on Appeon
public long il_requestor_rowcount = -1

public n_dwr_progress ipo_progress
//public boolean ib_show_progress = false

public boolean ib_multidw = false





end variables

forward prototypes

end prototypes

on n_dwr_nested_service_parm.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_nested_service_parm.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

