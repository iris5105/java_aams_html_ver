forward
global type w_fund_tree from w_window1st1ncn
end type
type dw_no from fw_u_dwo within w_fund_tree
end type
type st_1 from pf_u_splitbar_vertical within w_fund_tree
end type
type tv_fullmenu from pf_u_treeview within w_fund_tree
end type
type p_2 from picture within w_fund_tree
end type
type st_3 from pf_u_statictext within w_fund_tree
end type
end forward

global type w_fund_tree from w_window1st1ncn
dw_no dw_no
st_1 st_1
tv_fullmenu tv_fullmenu
p_2 p_2
st_3 st_3
end type
global w_fund_tree w_fund_tree

type variables
treeviewitem   itvi_item

ads_jTier	ids_fullmenu

STRING	ia_pgm []

LONG	il_handle
end variables

forward prototypes
public function integer of_set_pgm_fullmenu ()
end prototypes

public function integer of_set_pgm_fullmenu ();LONG	ll, ll_rowcnt, ll_handle, ll_parent []

treeviewitem   ltvi_item

tv_fullmenu.setredraw (FALSE)

ll_handle = tv_fullmenu.finditem(roottreeitem!, 0)
ll_parent [1] = 0
DO WHILE ll_handle > 0
   tv_fullmenu.deleteitem (ll_handle)
   ll_handle = tv_fullmenu.finditem(roottreeitem!, ll_handle)
loop

ll_rowcnt = ids_fullmenu.retrieve ()
for  ll = 1  to  ll_rowcnt
   choose CASE ids_fullmenu.object.fund_color [ll]
      CASE 'b'
         ltvi_item.data = ids_fullmenu.object.펀드코드 [ll]
         ltvi_item.label = ids_fullmenu.object.펀드코드 [ll] + ' ' + ids_fullmenu.object.펀드명 [ll]
         ltvi_item.PictureIndex = 1
         ltvi_item.SelectedPictureIndex = 2
         ltvi_item.children = FALSE
         ll_handle = tv_fullmenu.InsertItemLast (ll_parent [2], ltvi_item)
         itvi_item.children = TRUE
         tv_fullmenu.setitem (ll_parent [2], itvi_item)
         tv_fullmenu.ExpandAll (ll_parent [2])

      CASE ELSE
         ltvi_item.data = ids_fullmenu.object.펀드코드 [ll]
         ltvi_item.label = ids_fullmenu.object.펀드코드 [ll] + ' ' + ids_fullmenu.object.펀드명 [ll]
         ltvi_item.PictureIndex = 1
         ltvi_item.SelectedPictureIndex = 2
         ltvi_item.children = FALSE
         ll_handle = tv_fullmenu.InsertItemLast (0, ltvi_item)
         itvi_item = ltvi_item
   end choose
   IF ids_fullmenu.object.fund_color [ll]<>'b' THEN ll_parent [2] = ll_handle
next

tv_fullmenu.setredraw (TRUE)

RETURN ll_rowcnt
end function

on w_fund_tree.create
int iCurrent
call super::create
this.dw_no=create dw_no
this.st_1=create st_1
this.tv_fullmenu=create tv_fullmenu
this.p_2=create p_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_no
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.tv_fullmenu
this.Control[iCurrent+4]=this.p_2
this.Control[iCurrent+5]=this.st_3
end on

on w_fund_tree.destroy
call super::destroy
destroy(this.dw_no)
destroy(this.st_1)
destroy(this.tv_fullmenu)
destroy(this.p_2)
destroy(this.st_3)
end on

event open;call super::open;ids_fullmenu = CREATE ads_jTier
ids_fullmenu.dataobject = 'dc_fund_list'
ids_fullmenu.settransobject(SQLCA)
end event

event activate;call super::activate;tv_fullmenu.SetFocus ()
end event

event wue_postopen;call super::wue_postopen;p_retrieve.post event clicked()
end event

event wue_retrieve;call super::wue_retrieve;dw_no.retrieve ()
of_set_pgm_fullmenu ()
end event

event wue_update;// 버튼 기본정보 저장
if dw_no.accepttext() = -1 then return -1
if dw_no.modifiedcount() + dw_no.deletedcount() = 0 then return 1
IF messagebox ('Notice', '[ ' + inv_menu.is_pgm_nm + ' ] Do you want to update your changes?', Question!, YesNo!, 2)=2  Then
   dw_no.reset ()
   RETURN 1
End IF

string ls_errtext

If dw_no.update ()=1	Then
	commitJ ()
Else
	ls_errtext = sqlca.sqlerrtext()
	rollbackJ ()
	messagebox('Notice', 'Updating data failed for the following reasons~r~n' + ls_errtext)
	RETURN -1
End If
end event

event wue_confirmupdate4close;call super::wue_confirmupdate4close;If of_confirmupdate4close({dw_no})=1 Then this.Event wue_update()
Return 0
end event

type lb_dirlist from w_window1st1ncn`lb_dirlist within w_fund_tree
end type

type ln_templeft from w_window1st1ncn`ln_templeft within w_fund_tree
integer beginx = 59
integer endx = 59
end type

type ln_tempbuttom from w_window1st1ncn`ln_tempbuttom within w_fund_tree
end type

type ln_temptop from w_window1st1ncn`ln_temptop within w_fund_tree
end type

type ln_tempbutton from w_window1st1ncn`ln_tempbutton within w_fund_tree
end type

type ln_tempstart from w_window1st1ncn`ln_tempstart within w_fund_tree
end type

type ln_cond1_yline from w_window1st1ncn`ln_cond1_yline within w_fund_tree
end type

type ln_dw1_yline from w_window1st1ncn`ln_dw1_yline within w_fund_tree
end type

type ln_cond2_yline from w_window1st1ncn`ln_cond2_yline within w_fund_tree
end type

type ln_dw2_yline from w_window1st1ncn`ln_dw2_yline within w_fund_tree
end type

type ln_tempright from w_window1st1ncn`ln_tempright within w_fund_tree
end type

type uo_navi from w_window1st1ncn`uo_navi within w_fund_tree
end type

type ln_temptop_shadow from w_window1st1ncn`ln_temptop_shadow within w_fund_tree
end type

type st_windelaytime from w_window1st1ncn`st_windelaytime within w_fund_tree
end type

type p_close from w_window1st1ncn`p_close within w_fund_tree
end type

type p_excel from w_window1st1ncn`p_excel within w_fund_tree
end type

type p_print from w_window1st1ncn`p_print within w_fund_tree
end type

type p_delete from w_window1st1ncn`p_delete within w_fund_tree
end type

type p_update from w_window1st1ncn`p_update within w_fund_tree
end type

type p_input from w_window1st1ncn`p_input within w_fund_tree
end type

type p_retrieve from w_window1st1ncn`p_retrieve within w_fund_tree
end type

type p_clear from w_window1st1ncn`p_clear within w_fund_tree
end type

type p_copy from w_window1st1ncn`p_copy within w_fund_tree
end type

type dw_no from fw_u_dwo within w_fund_tree
integer x = 2752
integer y = 244
integer width = 2679
integer height = 2520
integer taborder = 10
boolean bringtotop = true
string title = "화면번호 지정현황"
string dataobject = "d_obj_no_assign"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

event oue_postopen;call super::oue_postopen;dw_no.SetTransObject ( sqlca )
end event

event clicked;call super::clicked;IF	MID (string (dwo.name),1,4)='obj_' And f_null (ia_pgm [1])	Then
   f_messageBox ('I000', '화면번호 지정 대상이 아닙니다.')
	RETURN 1
End IF
CHOOSE CASE dwo.name
   CASE 'obj_no_1'
		IF	f_nvl (Object.pgm_no_1 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_1 [row] = 'N'
			Object.pgm_no_1 [row] = null_s
			Object.pgm_id_1 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_1 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_1 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_1 [row] = ia_pgm [2]
					Object.pgm_id_1 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_2'
		IF	f_nvl (Object.pgm_no_2 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_2 [row] = 'N'
			Object.pgm_no_2 [row] = null_s
			Object.pgm_id_2 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_2 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_2 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_2 [row] = ia_pgm [2]
					Object.pgm_id_2 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_3'
		IF	f_nvl (Object.pgm_no_3 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_3 [row] = 'N'
			Object.pgm_no_3 [row] = null_s
			Object.pgm_id_3 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_3 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_3 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_3 [row] = ia_pgm [2]
					Object.pgm_id_3 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_4'
		IF	f_nvl (Object.pgm_no_4 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_4 [row] = 'N'
			Object.pgm_no_4 [row] = null_s
			Object.pgm_id_4 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_4 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_4 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_4 [row] = ia_pgm [2]
					Object.pgm_id_4 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_5'
		IF	f_nvl (Object.pgm_no_5 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_5 [row] = 'N'
			Object.pgm_no_5 [row] = null_s
			Object.pgm_id_5 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_5 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_5 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_5 [row] = ia_pgm [2]
					Object.pgm_id_5 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_6'
		IF	f_nvl (Object.pgm_no_6 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_6 [row] = 'N'
			Object.pgm_no_6 [row] = null_s
			Object.pgm_id_6 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_6 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_6 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_6 [row] = ia_pgm [2]
					Object.pgm_id_6 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_7'
		IF	f_nvl (Object.pgm_no_7 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_7 [row] = 'N'
			Object.pgm_no_7 [row] = null_s
			Object.pgm_id_7 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_7 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_7 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_7 [row] = ia_pgm [2]
					Object.pgm_id_7 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_8'
		IF	f_nvl (Object.pgm_no_8 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_8 [row] = 'N'
			Object.pgm_no_8 [row] = null_s
			Object.pgm_id_8 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_8 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_8 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_8 [row] = ia_pgm [2]
					Object.pgm_id_8 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_9'
		IF	f_nvl (Object.pgm_no_9 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_9 [row] = 'N'
			Object.pgm_no_9 [row] = null_s
			Object.pgm_id_9 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_9 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_9 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_9 [row] = ia_pgm [2]
					Object.pgm_id_9 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
   CASE 'obj_no_10'
		IF	f_nvl (Object.pgm_no_10 [row],'null')=ia_pgm [2]	Then
			ia_pgm [1] = '....'
			Object.obj_check_10 [row] = 'N'
			Object.pgm_no_10 [row] = null_s
			Object.pgm_id_10 [row] = null_s
			itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
			itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
			tv_fullmenu.setitem (il_handle, itvi_item)
		Else
			IF string (Object.obj_check_10 [row])='Y'   Then
				f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
			Else
				IF	ia_pgm [1]='....'	Then
					Object.obj_check_10 [row] = 'Y'
					ia_pgm [1] = Object.obj_no [row]
					Object.pgm_no_10 [row] = ia_pgm [2]
					Object.pgm_id_10 [row] = ia_pgm [3]
					itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
					itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
					tv_fullmenu.setitem (il_handle, itvi_item)
				Else
					f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
				End IF
			End IF
		End IF
END CHOOSE

IF MID (string (dwo.name),1,6)='obj_no'   Then
   IF ia_pgm [1]='....' Then
      UPDATE  fw_pgm_mst
         SET  pgm_go = :null_s
      WHERE   pgm_no = :ia_pgm[2];
   Else
      UPDATE  fw_pgm_mst
         SET  pgm_go = :ia_pgm [1]
      WHERE   pgm_no = :ia_pgm[2];
   End IF
End IF
end event

event oue_keydown;call super::oue_keydown;LONG lRow

STRING   ls_num

CHOOSE CASE key
   CASE Key0!, KeyNumpad0!
      ls_num = '0'
   CASE Key1!, KeyNumpad1!
      ls_num = '1'
   CASE Key2!, KeyNumpad2!
      ls_num = '2'
   CASE Key3!, KeyNumpad3!
      ls_num = '3'
   CASE Key4!, KeyNumpad4!
      ls_num = '4'
   CASE Key5!, KeyNumpad5!
      ls_num = '5'
   CASE Key6!, KeyNumpad6!
      ls_num = '6'
   CASE Key7!, KeyNumpad7!
      ls_num = '7'
   CASE Key8!, KeyNumpad8!
      ls_num = '8'
   CASE Key9!, KeyNumpad9!
      ls_num = '9'
   CASE Else
      RETURN
END CHOOSE

IF f_notnull (ls_num)   Then
   lRow = FIND ("obj_no='" + ls_num + "000'", 1, 10000)
   TITLE = '화면번호 지정현황(' + ls_num + '000)'
	of_settitle4datawindow ()
	IF lRow>0   Then
		setrow (lRow)
		scrolltorow (lRow)
	End IF
End IF
end event

event itemchanged;call super::itemchanged;IF MID (string (dwo.name),1,4)='obj_' And f_null (ia_pgm [1])  Then
   f_messageBox ('I000', '화면번호 지정 대상이 아닙니다.')
   RETURN 1
End IF
CHOOSE CASE dwo.name
   CASE 'obj_check_1'
      IF f_nvl (Object.pgm_no_1 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_1 [row] = null_s
            Object.pgm_id_1 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_1 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_1 [row] = ia_pgm [2]
               Object.pgm_id_1 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_2'
      IF f_nvl (Object.pgm_no_2 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_2 [row] = null_s
            Object.pgm_id_2 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_2 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_2 [row] = ia_pgm [2]
               Object.pgm_id_2 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_3'
      IF f_nvl (Object.pgm_no_3 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_3 [row] = null_s
            Object.pgm_id_3 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_3 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_3 [row] = ia_pgm [2]
               Object.pgm_id_3 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_4'
      IF f_nvl (Object.pgm_no_4 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_4 [row] = null_s
            Object.pgm_id_4 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_4 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_4 [row] = ia_pgm [2]
               Object.pgm_id_4 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_5'
      IF f_nvl (Object.pgm_no_5 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_5 [row] = null_s
            Object.pgm_id_5 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_5 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_5 [row] = ia_pgm [2]
               Object.pgm_id_5 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_6'
      IF f_nvl (Object.pgm_no_6 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_6 [row] = null_s
            Object.pgm_id_6 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_6 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_6 [row] = ia_pgm [2]
               Object.pgm_id_6 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_7'
      IF f_nvl (Object.pgm_no_7 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_7 [row] = null_s
            Object.pgm_id_7 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_7 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_7 [row] = ia_pgm [2]
               Object.pgm_id_7 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_8'
      IF f_nvl (Object.pgm_no_8 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_8 [row] = null_s
            Object.pgm_id_8 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_8 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_8 [row] = ia_pgm [2]
               Object.pgm_id_8 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_9'
      IF f_nvl (Object.pgm_no_9 [row],'null')=ia_pgm [2] Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_9 [row] = null_s
            Object.pgm_id_9 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_9 [row])='Y'  Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_9 [row] = ia_pgm [2]
               Object.pgm_id_9 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
   CASE 'obj_check_10'
      IF f_nvl (Object.pgm_no_10 [row],'null')=ia_pgm [2]   Then
         IF data='N' Then
            ia_pgm [1] = '....'
            Object.pgm_no_10 [row] = null_s
            Object.pgm_id_10 [row] = null_s
            itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
            itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
            tv_fullmenu.setitem (il_handle, itvi_item)
         End IF
      Else
         IF string (Object.obj_check_10 [row])='Y' Then
            f_messageBox ('I000', '이미 사용하고 있는 화면번호입니다')
            RETURN 1
         Else
            IF ia_pgm [1]='....' Then
               ia_pgm [1] = Object.obj_no [row]
               Object.pgm_no_10 [row] = ia_pgm [2]
               Object.pgm_id_10 [row] = ia_pgm [3]
               itvi_item.data = ia_pgm [1] + '~t' + ia_pgm [2] + '~t' + ia_pgm [3] + '~t' + ia_pgm [4]
               itvi_item.label = ia_pgm [1] + ' ' + ia_pgm [4]
               tv_fullmenu.setitem (il_handle, itvi_item)
            Else
               f_messageBox ('I000', '기존 번호를 해제하고 변경 하십시오.')
               RETURN 1
            End IF
         End IF
      End IF
END CHOOSE

IF MID (string (dwo.name),1,9)='obj_check'   Then
   IF ia_pgm [1]='....' Then
      UPDATE  fw_pgm_mst
         SET  pgm_go = :null_s
      WHERE   pgm_no = :ia_pgm[2];
   Else
      UPDATE  fw_pgm_mst
         SET  pgm_go = :ia_pgm [1]
      WHERE   pgm_no = :ia_pgm[2];
   End IF
End IF
end event

type st_1 from pf_u_splitbar_vertical within w_fund_tree
integer x = 2725
integer y = 244
integer width = 23
integer height = 2520
boolean bringtotop = true
boolean setsheetcolor = true
boolean scaletobottom = false
string leftdragobject = "tv_fullmenu"
string rightdragobject = "dw_no"
end type

type tv_fullmenu from pf_u_treeview within w_fund_tree
integer x = 59
integer y = 244
integer width = 2661
integer height = 2520
integer taborder = 20
boolean bringtotop = true
long textcolor = 19737901
boolean linesatroot = true
string picturename[] = {"..\img\controls\u_icon4comm\imagebtn_fund.jpg","..\img\controls\u_favicon\favicon_04.ico"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event selectionchanged;//LONG	ll
//
//il_handle = newhandle
//IF	getitem(il_handle, itvi_item)>0	Then
//	f_get_array (string (itvi_item.data), '~t', ia_pgm)	// 화면번호,pgm_no,pgm_id,pgm_nm
//	IF	ia_pgm [1]<>'menu' And ia_pgm [1]<>'....'	Then
//		ll = dw_no.find ("pgm_no='" + ia_pgm [2] + "'", 1, 10000)
//		IF	ll>0	Then
//			dw_no.setrow (ll)
//			dw_no.scrolltorow (ll)
//		End IF
//	End IF
//End IF
end event

type p_2 from picture within w_fund_tree
integer x = 64
integer y = 180
integer width = 73
integer height = 60
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4comm\icon_breadcrumb2.jpg"
boolean focusrectangle = false
end type

type st_3 from pf_u_statictext within w_fund_tree
integer x = 160
integer y = 176
integer width = 549
integer height = 68
boolean bringtotop = true
integer weight = 700
fontcharset fontcharset = hangeul!
string text = "전체 프로그램 메뉴"
boolean setsheetcolor = true
end type

