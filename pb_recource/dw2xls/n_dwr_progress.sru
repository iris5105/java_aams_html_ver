forward
global type n_dwr_progress from nonvisualobject
end type
end forward

global type n_dwr_progress from nonvisualobject
end type
global n_dwr_progress n_dwr_progress

type variables
public:
w_n_dwr_service_progress iw_progress
long il_progress_rown = 0
long il_change_progress_each = 1
long il_cur_change_progress = 0
long il_progress_row = 0
long il_percent_of_process = 100
long il_percent_of_analyse = 0

end variables

on n_dwr_progress.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_progress.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

