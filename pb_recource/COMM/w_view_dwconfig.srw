forward
global type w_view_dwconfig from w_response1st
end type
type st_value from pf_u_statictext within w_view_dwconfig
end type
type st_4 from pf_u_statictext within w_view_dwconfig
end type
type st_6 from pf_u_statictext within w_view_dwconfig
end type
type st_2 from pf_u_statictext within w_view_dwconfig
end type
type st_7 from pf_u_statictext within w_view_dwconfig
end type
type st_filteredcount from pf_u_statictext within w_view_dwconfig
end type
type st_5 from pf_u_statictext within w_view_dwconfig
end type
type st_3 from pf_u_statictext within w_view_dwconfig
end type
type st_modifiedcount from pf_u_statictext within w_view_dwconfig
end type
type st_1 from pf_u_statictext within w_view_dwconfig
end type
type ln_2 from pf_u_line within w_view_dwconfig
end type
type st_rowcount from pf_u_statictext within w_view_dwconfig
end type
type st_deletedcount from pf_u_statictext within w_view_dwconfig
end type
end forward

global type w_view_dwconfig from w_response1st
integer width = 1440
integer height = 1772
string title = "자료 상태정보"
long backcolor = 67108864
boolean clientedge = true
st_value st_value
st_4 st_4
st_6 st_6
st_2 st_2
st_7 st_7
st_filteredcount st_filteredcount
st_5 st_5
st_3 st_3
st_modifiedcount st_modifiedcount
st_1 st_1
ln_2 ln_2
st_rowcount st_rowcount
st_deletedcount st_deletedcount
end type
global w_view_dwconfig w_view_dwconfig

on w_view_dwconfig.create
int iCurrent
call super::create
this.st_value=create st_value
this.st_4=create st_4
this.st_6=create st_6
this.st_2=create st_2
this.st_7=create st_7
this.st_filteredcount=create st_filteredcount
this.st_5=create st_5
this.st_3=create st_3
this.st_modifiedcount=create st_modifiedcount
this.st_1=create st_1
this.ln_2=create ln_2
this.st_rowcount=create st_rowcount
this.st_deletedcount=create st_deletedcount
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_value
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_7
this.Control[iCurrent+6]=this.st_filteredcount
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_modifiedcount
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.ln_2
this.Control[iCurrent+12]=this.st_rowcount
this.Control[iCurrent+13]=this.st_deletedcount
end on

on w_view_dwconfig.destroy
call super::destroy
destroy(this.st_value)
destroy(this.st_4)
destroy(this.st_6)
destroy(this.st_2)
destroy(this.st_7)
destroy(this.st_filteredcount)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.st_modifiedcount)
destroy(this.st_1)
destroy(this.ln_2)
destroy(this.st_rowcount)
destroy(this.st_deletedcount)
end on

event open;call super::open;u_dw  ldw

ldw = Message.PowerObjectParm

st_RowCount.TEXT = string (ldw.rowcount ())
st_DeletedCOunt.TEXT = string (ldw.deletedcount ())
st_ModifiedCount.TEXT = string (ldw.modifiedcount ())
st_FilteredCount.TEXT = string (ldw.filteredcount ())

st_4.TEXT = ldw.dataobject + ' 변수 값'

STRING   ls

ls = 'eb_new_false = ' + string (ldw.eb_new_false) + '~r~n' + &
		'eb_copy_false = ' + string (ldw.eb_copy_false) + '~r~n' + &
		'eb_delete_false = ' + string (ldw.eb_delete_false) + '~r~n~r~n' + &
		'ib_Range = ' + string (ldw.uf_getrange ()) + '~r~n' + &
		'il_width_max = ' + string (ldw.of_getmax4xpos ()) + '~r~n~r~n'

st_value.TEXT = ls
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_view_dwconfig
end type

type ln_tempstart from w_response1st`ln_tempstart within w_view_dwconfig
end type

type ln_templeft from w_response1st`ln_templeft within w_view_dwconfig
end type

type ln_cond_start from w_response1st`ln_cond_start within w_view_dwconfig
end type

type ln_tempright from w_response1st`ln_tempright within w_view_dwconfig
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_view_dwconfig
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_view_dwconfig
end type

type st_value from pf_u_statictext within w_view_dwconfig
integer x = 105
integer y = 572
integer width = 1115
integer height = 1084
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "none"
alignment alignment = center!
end type

type st_4 from pf_u_statictext within w_view_dwconfig
integer x = 105
integer y = 488
integer width = 1115
integer height = 60
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "dataobject 변수 값"
alignment alignment = center!
end type

type st_6 from pf_u_statictext within w_view_dwconfig
integer x = 713
integer y = 184
integer width = 402
integer height = 60
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "보여줍니다."
end type

type st_2 from pf_u_statictext within w_view_dwconfig
integer x = 713
integer y = 104
integer width = 617
integer height = 60
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "현재 자료의 상태정보를 "
end type

type st_7 from pf_u_statictext within w_view_dwconfig
integer x = 50
integer y = 368
integer width = 411
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "필터된 자료수 :"
alignment alignment = right!
end type

type st_filteredcount from pf_u_statictext within w_view_dwconfig
integer x = 475
integer y = 368
integer width = 137
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "0"
alignment alignment = right!
end type

type st_5 from pf_u_statictext within w_view_dwconfig
integer x = 50
integer y = 236
integer width = 411
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "삭제된 자료수 :"
alignment alignment = right!
end type

type st_3 from pf_u_statictext within w_view_dwconfig
integer x = 50
integer y = 156
integer width = 411
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "변경된 자료수 :"
alignment alignment = right!
end type

type st_modifiedcount from pf_u_statictext within w_view_dwconfig
integer x = 475
integer y = 156
integer width = 137
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "0"
alignment alignment = right!
end type

type st_1 from pf_u_statictext within w_view_dwconfig
integer x = 50
integer y = 32
integer width = 411
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "조회된 자료수 :"
alignment alignment = right!
end type

type ln_2 from pf_u_line within w_view_dwconfig
integer linethickness = 1
integer beginx = 663
integer beginy = 28
integer endx = 663
integer endy = 440
end type

type st_rowcount from pf_u_statictext within w_view_dwconfig
integer x = 475
integer y = 32
integer width = 137
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "0"
alignment alignment = right!
end type

type st_deletedcount from pf_u_statictext within w_view_dwconfig
integer x = 475
integer y = 236
integer width = 137
integer height = 64
integer textsize = -9
fontcharset fontcharset = hangeul!
long backcolor = 67108864
string text = "0"
alignment alignment = right!
end type

