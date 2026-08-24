forward
global type n_dwr_rect_band from n_dwr_band
end type
end forward

global type n_dwr_rect_band from n_dwr_band
end type
global n_dwr_rect_band n_dwr_rect_band

type variables

protected:

n_dwr_field inv_parent_field
end variables

forward prototypes
public subroutine of_setparent (n_dwr_field anv_parent)
public subroutine of_init_bg_fillers ()
public function long of_descr_bg_color ()
public subroutine of_getbgrect (ref st_rect ast_rect, long al_row)
public subroutine of_dispose ()
end prototypes

public subroutine of_setparent (n_dwr_field anv_parent);inv_parent_field = anv_parent
end subroutine

public subroutine of_init_bg_fillers ();ib_background_color = true

If ib_background_color Then
	of_InitBgStorage()

	inv_bg_format.setBgColor(inv_bg_format.handle, of_descr_bg_color())
	ib_custom_format =  ib_bg_color_expr
	If Not ib_custom_format Then
		il_bg_format_ix = inv_book.of_AddFormat(inv_bg_format)
	End If
End If



end subroutine

public function long of_descr_bg_color ();long ll_color

ll_color = inv_parent_field.of_descr_bg_color2()
ib_bg_color_expr = inv_parent_field.ib_bg_color_expr
is_bg_color_expr = inv_parent_field.is_bg_color_expr

return ll_color



end function

public subroutine of_getbgrect (ref st_rect ast_rect, long al_row);inv_parent_field.of_GetBGRect(ref ast_rect, al_row)
end subroutine

public subroutine of_dispose ();
call super::of_dispose

SetNull(inv_parent_field)


end subroutine

on n_dwr_rect_band.create
call super::create
end on

on n_dwr_rect_band.destroy
call super::destroy
end on

