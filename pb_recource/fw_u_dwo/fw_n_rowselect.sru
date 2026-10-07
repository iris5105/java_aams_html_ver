forward
global type fw_n_rowselect from n_ancestor
end type
end forward

global type fw_n_rowselect from n_ancestor
event type long oue_clicked ( integer xpos,  integer ypos,  long row,  dwobject dwo )
event oue_rowfocuschanged ( long currentrow )
end type
global fw_n_rowselect fw_n_rowselect

type variables
protected:
	fw_u_dwo idw_target
	graphicobject igo_parent

end variables

forward prototypes
public function string of_thisname ()
public function integer of_multirowselect (long row)
public function integer of_singlerowselect (long row)
public subroutine of_initialize (datawindow adw_datawindow)
end prototypes

event type long oue_clicked(integer xpos, integer ypos, long row, dwobject dwo);if idw_target.ibsetlist4multiselect = true then
	this.of_multirowselect(row)
end if

if idw_target.ibsetlist4singleselect = true then
	this.of_singlerowselect(row)
end if

return 0

end event

event oue_rowfocuschanged(long currentrow);// ibsetlist4multiselect
if idw_target.ibsetlist4multiselect = true then
	if KeyDown(KeyShift!) and (KeyDown(KeyDownArrow!) or KeyDown(KeyUpArrow!)) Then
		idw_target.SelectRow(currentrow,true)
		return
	end if
end if

// ibsetlist4singleselect
if idw_target.ibsetlist4singleselect = true then
	idw_target.selectrow(0, false)
	idw_target.selectrow(currentrow, true)
	return
end if

end event

public function string of_thisname ();return 'fw_n_rowselect'
end function

public function integer of_multirowselect (long row);// ibsetlist4multiselect
if row = 0 then return 0

long ll_selectedrow, ll_rc
ll_selectedrow = idw_target.getselectedrow(0)

// select range
IF KeyDown(keyShift!) THEN
	IF ll_selectedrow = 0 THEN
		idw_target.SelectRow(row, True)
	ELSE
		idw_target.SelectRow(0, False)
		IF row > ll_selectedrow THEN
			FOR ll_rc = ll_selectedrow TO row
				idw_target.SelectRow(ll_rc, True)
			NEXT
		ELSE
			FOR ll_rc = row TO ll_selectedrow
				idw_target.SelectRow(ll_rc, True)
			NEXT
	END IF
END IF

// multi select
ELSEIF KeyDown(keyControl!) THEN
	IF idw_target.IsSelected(row) THEN
		idw_target.SelectRow(row, False)
	ELSE
		idw_target.SelectRow(row, True)
	END IF

// single select
ELSE
	IF idw_target.IsSelected(row) THEN
		idw_target.SelectRow(0, False)
		idw_target.SelectRow(row, True)
	ELSE
		idw_target.SelectRow(0, False)
		idw_target.SelectRow(row, True)
	END IF
END IF

return 1
end function

public function integer of_singlerowselect (long row);// ibsetlist4singleselect
if row = 0 then return 0

IF idw_target.IsSelected(row) THEN
	idw_target.SelectRow(0, False)
	idw_target.SelectRow(row, True)
ELSE
	idw_target.SelectRow(0, False)
	idw_target.SelectRow(row, True)
END IF

return 1

end function

public subroutine of_initialize (datawindow adw_datawindow);// parent datawindow 등록
idw_target = adw_datawindow
igo_parent = idw_target.getparent()

end subroutine

on fw_n_rowselect.create
call super::create
end on

on fw_n_rowselect.destroy
call super::destroy
end on

