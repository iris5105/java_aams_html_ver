forward
global type n_siteapi from nonvisualobject
end type
end forward

global type n_siteapi from nonvisualobject
end type
global n_siteapi n_siteapi

type prototypes

end prototypes

on n_siteapi.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_siteapi.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

