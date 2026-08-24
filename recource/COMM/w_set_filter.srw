forward
global type w_set_filter from w_response1st
end type
type p_1 from pf_u_imagebutton within w_set_filter
end type
type st_1 from statictext within w_set_filter
end type
type p_clear from pf_u_imagebutton within w_set_filter
end type
type p_ok from pf_u_imagebutton within w_set_filter
end type
type p_add from pf_u_imagebutton within w_set_filter
end type
type dw_c from fw_u_dwo within w_set_filter
end type
end forward

global type w_set_filter from w_response1st
integer x = 837
integer y = 852
integer width = 2002
integer height = 1176
boolean titlebar = false
boolean controlmenu = false
long backcolor = 67108864
string icon = "DataWindow5!"
p_1 p_1
st_1 st_1
p_clear p_clear
p_ok p_ok
p_add p_add
dw_c dw_c
end type
global w_set_filter w_set_filter

type variables
DATASTORE   ids
end variables

on w_set_filter.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_1=create st_1
this.p_clear=create p_clear
this.p_ok=create p_ok
this.p_add=create p_add
this.dw_c=create dw_c
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.p_clear
this.Control[iCurrent+4]=this.p_ok
this.Control[iCurrent+5]=this.p_add
this.Control[iCurrent+6]=this.dw_c
end on

on w_set_filter.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_1)
destroy(this.p_clear)
destroy(this.p_ok)
destroy(this.p_add)
destroy(this.dw_c)
end on

event open;call super::open;ids = Message.PowerObjectParm

IF isValid (ids)  Then
   ids.ShareData (dw_c)
   dw_c.POST setcolumn ('value')
Else
   MessageBox ('error', 'object error')
   CLOSE (THIS)
End IF

dw_c.POST setfocus ()
end event

event key;call super::key;IF	key=KeyEnter! THEN p_ok.EVENT clicked ()
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_set_filter
end type

type ln_tempstart from w_response1st`ln_tempstart within w_set_filter
end type

type ln_templeft from w_response1st`ln_templeft within w_set_filter
end type

type ln_cond_start from w_response1st`ln_cond_start within w_set_filter
end type

type ln_tempright from w_response1st`ln_tempright within w_set_filter
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_set_filter
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_set_filter
end type

type p_1 from pf_u_imagebutton within w_set_filter
integer x = 1705
integer y = 28
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

event clicked;call super::clicked;CloseWithReturn (Parent, 'Cancel')
end event

type st_1 from statictext within w_set_filter
integer x = 69
integer y = 76
integer width = 745
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 8421504
long backcolor = 553648127
string text = " Ctrl + V : 동일조건추가(OR)"
boolean focusrectangle = false
end type

type p_clear from pf_u_imagebutton within w_set_filter
integer x = 1006
integer y = 28
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_clear.jpg"
end type

event clicked;call super::clicked;CloseWithReturn (Parent, 'reset')
end event

type p_ok from pf_u_imagebutton within w_set_filter
integer x = 1472
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_execu.jpg"
end type

event clicked;call super::clicked;BOOLEAN   lb_or = FALSE

LONG  ll, ll_cnt,lk

STRING   ls_Column, ls_Operate, ls_Value, ls_Value1, ls_Filter = '', ls_join = ''
STRING   ls_ddlb, la_ddlb []

dw_c.AcceptText ()

ll_cnt = dw_c.rowcount ()
FOR  ll = 1  TO  ll_cnt
   IF f_null (dw_c.object.value [ll]) THEN CONTINUE

   ls_Column  = dw_c.object.column_name [ll]
   ls_Operate = dw_c.object.operator [ll]
   ls_Value   = dw_c.object.value [ll]

   IF f_notnull (dw_c.object.ddlb [ll])   Then
      ls_ddlb = dw_c.object.ddlb [ll]
      IF ls_join='' THEN ls_Filter = '(' + ls_Column + '=' &
      Else               ls_Filter += ls_join + '(' + ls_Column + '='
      FOR  lk = 1  TO  f_get_array (ls_ddlb, '/', la_ddlb)
         IF POS (la_ddlb [lk],ls_value)>0 Then
            IF lb_or Then
               ls_Filter += ' OR ' + ls_Column + "='" + f_get_token (la_ddlb [lk], '~t') + "'"
            Else
               ls_Filter += "'" + f_get_token (la_ddlb [lk], '~t') + "'"
            End IF
            lb_or = TRUE
         End IF
      NEXT
      ls_Filter += ')'
   End IF

   IF f_null (dw_c.object.ddlb [ll]) OR NOT lb_or  Then
      IF ls_Operate=' like '  Then
         ls_Value = '"%' + ls_Value + '%"'
      Else
         IF PosA (dw_c.object.type [ll],'date')>0  Then
            IF ls_Operate=' between '  Then
               ls_Value1 = ls_Value
               ls_Value = 'date("' + TRIM (f_get_token (ls_Value1,'and')) + '") and '
               ls_Value = ls_value + 'date("' + TRIM (ls_Value1) + '")'
            Else
               ls_Value = 'date("' + ls_Value + '")'
            End IF
         ElseIF PosA (dw_c.object.type [ll],'num')>0 OR PosA (dw_c.object.type [ll],'dec')>0 THEN
            IF ls_Operate=' between '  Then
               ls_Value1 = ls_Value
               ls_Value = TRIM (f_get_token (ls_value1,'and')) + ' and '
               ls_Value = TRIM (ls_Value1)
            Else
               ls_Value = '"' + ls_Value + '"'
            End IF
         Else
            IF ls_Operate=' between '  Then
               ls_Value = ' ' + ls_Value + ' '
            Else
               ls_Value = '"' + ls_Value + '"'
            End IF
         End IF
      End IF
      IF ls_join='' THEN ls_Filter = '(' + ls_Column + ls_Operate + ls_Value + ')' &
      Else               ls_Filter = ls_Filter + ls_join + '(' + ls_Column + ls_Operate + ls_Value + ')'
   End IF

   ls_join = dw_c.object.join [ll]
   IF NOT f_null (dw_c.object.crow [ll]) And ls_join=' and ' THEN ls_Filter = ls_Filter + ')'
NEXT
CloseWithReturn (Parent, ls_Filter)
end event

type p_add from pf_u_imagebutton within w_set_filter
integer x = 1239
integer y = 28
integer width = 229
integer height = 96
integer taborder = 40
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_add.jpg"
end type

event clicked;call super::clicked;IF	dw_c.rowcount ()=0 THEN RETURN

LONG	lRow

lRow = dw_c.getrow ()
IF dw_c.object.join [lRow]=' or '  Then
	MessageBox ('조건복사','아래 And조건을 복사하십시오.')
	RETURN
End IF
dw_c.rowscopy (lRow, lRow, Primary!, dw_c, lRow + 1, Primary!)
dw_c.object.join [lRow] = ' or '
IF f_null (dw_c.object.crow [lRow]) THEN dw_c.object.column_name [lRow] = '(' + dw_c.object.column_name [lRow]
dw_c.object.value [lRow + 1] = null_s
dw_c.object.crow [lRow + 1] = '*'

dw_c.setrow (lRow + 1)
dw_c.scrollTOrow (lRow + 1)
dw_c.setcolumn ('value')
end event

type dw_c from fw_u_dwo within w_set_filter
integer x = 50
integer y = 144
integer width = 1888
integer height = 972
integer taborder = 10
string dataobject = "d_set_filter"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
end type

event rowfocuschanging;IF newrow=0 THEN RETURN
IF	Object.lang [newrow]='한'	Then
	post pf_f_togglekoreng ('k')
Else
	post pf_f_togglekoreng ('e')
End IF
end event

event itemfocuschanged;call super::itemfocuschanged;IF dwo.name='value'   Then
   MODIFY ("value.edit.case='" + Object.mask [row] + "'")
   f_selectText (THIS)
End IF
end event

event constructor;call super::constructor;MODIFY ("datawindow.selected.mouse=no datawindow.grid.columnmove=no")
end event

event oue_keydown;IF	dw_c.rowcount ()=0 THEN RETURN

LONG	lRow, ll, ll_count

STRING	ls_clipboard, ls_cut, la_data []

IF	key=KeyEnter!	Then
	p_ok.EVENT clicked ()
Else
	IF keyflags=2  Then
		CHOOSE CASE key
			CASE KeyV!
				ls_clipboard = TRIM (clipBoard ())
				IF f_null (ls_clipboard) THEN RETURN
	
				IF POS (ls_clipboard, '~r~n')>0  Then
					ls_cut = '~r~n'
				ElseIF POS (ls_clipboard, '~r')>0 THEN
					ls_cut = '~r'
				ElseIF POS (ls_clipboard, '~n')>0 THEN
					ls_cut = '~n'
				ElseIF POS (ls_clipboard, '~t')>0 THEN
					ls_cut = '~t'
				ElseIF POS (ls_clipboard, ':')>0 THEN
					ls_cut = ':'
				ElseIF POS (ls_clipboard, '|')>0 THEN
					ls_cut = '|'
				ElseIF POS (ls_clipboard, '@')>0 THEN
					ls_cut = '@'
				ElseIF POS (ls_clipboard, '/')>0 THEN
					ls_cut = '/'
				Else
					ls_cut = ','
				End IF
				ll_count = f_get_array (ls_clipboard, ls_cut, la_data)
				IF ll_count>1  Then
					lRow = getrow ()
					FOR  ll = 1  TO  ll_count
						IF NOT f_null (la_data [ll])  Then
							IF NOT f_null (Object.value [lRow]) Then
								RowsCopy (lRow, lRow, Primary!, THIS, lRow + 1, Primary!)
								Object.join [lRow] = ' or '
								IF f_null (Object.crow [lRow]) THEN Object.column_name [lRow] = '(' + Object.column_name [lRow]
								lRow ++
								Object.crow [lRow] = '*'
							End IF
							Object.operator [lRow] = ' = '
							Object.value [lRow] = la_data [ll]
						End IF
					NEXT
					SetRow (lRow)
					ScrollToRow (lRow)
					SetColumn ('column_tag')
				End IF
		END CHOOSE
	End IF
End IF
end event

