forward
global type n_siteexternal from nonvisualobject
end type
end forward

global type n_siteexternal from nonvisualobject
end type
global n_siteexternal n_siteexternal

type prototypes

end prototypes

on n_siteexternal.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_siteexternal.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

