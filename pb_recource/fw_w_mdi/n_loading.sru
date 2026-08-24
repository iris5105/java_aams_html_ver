forward
global type n_loading from timing
end type
end forward

global type n_loading from timing
end type
global n_loading n_loading

type variables

end variables

forward prototypes
public subroutine uf_start (string arg_window)
end prototypes

public subroutine uf_start (string arg_window);CHOOSE CASE arg_window
	CASE 'w_loadingchart'
		OPEN (w_loadingchart)
		w_loadingchart.y += 500
	CASE 'w_loadingfind'
		OPEN (w_loadingfind)
		w_loadingchart.y += 500
	CASE 'w_loadingopen'
		OPEN (w_loadingopen)
		w_loadingopen.y += 500
	CASE 'w_loadingpage'
		OPEN (w_loadingpage)
		w_loadingpage.y += 500
	CASE 'w_loadingrd'
		OPEN (w_loadingrd)
	CASE 'w_loadingretrieve'
		OPEN (w_loadingretrieve)
		w_loadingretrieve.y += 500
END CHOOSE
end subroutine

on n_loading.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_loading.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

