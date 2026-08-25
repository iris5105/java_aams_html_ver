forward
global type pf_n_internetresult from internetresult
end type
end forward

global type pf_n_internetresult from internetresult
end type
global pf_n_internetresult pf_n_internetresult

type variables
blob iblb_data

end variables

forward prototypes
public function integer internetdata (blob data)
public function string of_thisname ()
end prototypes

public function integer internetdata (blob data);iblb_data = data
return 1

end function

public function string of_thisname ();return 'pf_n_internetresult'

end function

on pf_n_internetresult.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_internetresult.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

