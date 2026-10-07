forward
global type pf_n_syntaxbuffer from nonvisualobject
end type
end forward

global type pf_n_syntaxbuffer from nonvisualobject
end type
global pf_n_syntaxbuffer pf_n_syntaxbuffer

type variables
protected:
	fw_n_dso ids_data

end variables

forward prototypes
public subroutine of_createdwobject ()
public function long of_append (string as_data)
public function string of_tostring ()
public function integer of_put (long al_index, string as_data)
public function string of_get (long al_index)
public function long of_size ()
public subroutine of_clear ()
public function integer of_import (string as_data)
end prototypes

public subroutine of_createdwobject ();
end subroutine

public function long of_append (string as_data);Long	ll_row

if IsNull(as_data) then as_data = ""
ll_row = ids_data.insertrow(0)
ids_data.setItem(ll_Row, 'strings', as_data)

return ll_row

end function

public function string of_tostring ();return ids_data.describe("Datawindow.Data")

end function

public function integer of_put (long al_index, string as_data);long ll_newrow, ll_retval

if isnull(as_data) then return -1
if isnull(al_index) then return -1

ll_newrow = ids_data.insertrow(al_index)
ll_retval = ids_data.setItem(ll_newrow, 'strings', as_data)
return ll_retval

end function

public function string of_get (long al_index);string ls_return

setnull(ls_return)
if isnull(al_index) then return ls_return

if al_index > 0 and ids_data.rowcount() >= al_index then
	ls_return = ids_data.getitemstring(al_index, 'strings')
end if

return ls_return

end function

public function long of_size ();return ids_data.rowcount()

end function

public subroutine of_clear ();ids_data.reset()

end subroutine

public function integer of_import (string as_data);long ll_retval
if isnull(as_data) then return -1

ll_retval = ids_data.importstring(as_data)
choose case ll_retval
	case -1;  messagebox("ImportString() Error", "No rows or startrow value supplied is greater than the number of rows in the string")
	case -3;  messagebox("ImportString() Error", "Invalid argument")
	case -4;  messagebox("ImportString() Error", "Invalid input")
	case -11;  messagebox("ImportString() Error", "XML Parsing Error; XML parser libraries not found or XML not well formed")
	case -12;  messagebox("ImportString() Error", "XML Template does not exist or does not match the DataWindow")
	case -13;   messagebox("ImportString() Error", "Unsupported DataWindow style for import")
	case -14;   messagebox("ImportString() Error", "Error resolving DataWindow nesting")
end choose

return ll_retval

end function

on pf_n_syntaxbuffer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_syntaxbuffer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;string ls_syntax
string ls_errtext

ids_data = create fw_n_dso
ls_syntax = 'release 8;table(column=(type=char(4096) updatewhereclause=yes name=strings dbname="strings" ))'
ids_data.create(ls_syntax, ls_errtext)
if len(ls_errtext) > 0 then
	messagebox('Error!!', '데이터윈도우 생성 에러~r~n' + ls_errtext)
end if

end event

event destructor;destroy ids_data
end event

