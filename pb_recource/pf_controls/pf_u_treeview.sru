forward
global type pf_u_treeview from treeview
end type
end forward

global type pf_u_treeview from treeview
integer width = 549
integer height = 476
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
borderstyle borderstyle = stylelowered!
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event type boolean oue_components ( )
end type
global pf_u_treeview pf_u_treeview

type variables
public:
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables

forward prototypes
public function string of_thisname ()
public function integer of_movechildren (long al_oldparent, long al_newparent)
public subroutine of_setredraw (boolean ab_boolean)
end prototypes

event type boolean oue_components();return true

end event

public function string of_thisname ();return 'pf_u_treeview'

end function

public function integer of_movechildren (long al_oldparent, long al_newparent);// 메뉴아이템의 하위 메뉴들 위치를 변경합니다
// 리턴: 1=성공, -1=실패

long ll_child, ll_movedchild
treeviewitem ltvi_child

ll_child = this.finditem(ChildTreeItem!, al_oldparent)
do while ll_child > 0
	this.getitem(ll_child, ltvi_child)
	
	setnull(ltvi_child.itemhandle)
	ll_movedchild = this.insertitemlast(al_newparent, ltvi_child)
	if ll_movedchild = -1 then return -1
	
	// Move the children of the child that was found
	this.of_movechildren(ll_child, ll_movedchild)
	
	// Check for more children at the original level
	ll_child = this.finditem(NextTreeItem!, ll_child)
loop

return 1

end function

public subroutine of_setredraw (boolean ab_boolean);This.SetRedRaw( ab_boolean )
end subroutine

on pf_u_treeview.create
end on

on pf_u_treeview.destroy
end on

