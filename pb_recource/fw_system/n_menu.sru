forward
global type n_menu from nonvisualobject
end type
end forward

global type n_menu from nonvisualobject
end type
global n_menu n_menu

type variables
public:
	Window	iw_sheet_ref
	Integer	ii_tabseq
	String		is_statusbar_id
	
	String		is_pgm_no
	String		is_pgm_id
	String		is_pgm_nm
	String		is_pgm_path
	String		is_parameter1
	String		is_parameter2
	String		is_parameter3

end variables

forward prototypes
public function string of_thisname ()
end prototypes

public function string of_thisname ();return 'n_menu'
end function

on n_menu.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_menu.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

