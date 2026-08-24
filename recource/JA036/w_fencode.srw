forward
global type w_fencode from wt_vertdetail
end type
type ole_rd from u_rd within w_fencode
end type
end forward

global type w_fencode from wt_vertdetail
boolean eb_direct_retrieve = true
ole_rd ole_rd
end type
global w_fencode w_fencode

on w_fencode.create
int iCurrent
call super::create
this.ole_rd=create ole_rd
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_rd
end on

on w_fencode.destroy
call super::destroy
destroy(this.ole_rd)
end on

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve ()
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_fencode
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_fencode
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_fencode
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_fencode
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_fencode
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_fencode
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_fencode
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_fencode
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_fencode
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_fencode
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_fencode
end type

type uo_navi from wt_vertdetail`uo_navi within w_fencode
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_fencode
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_fencode
end type

type p_close from wt_vertdetail`p_close within w_fencode
end type

type p_excel from wt_vertdetail`p_excel within w_fencode
end type

type p_print from wt_vertdetail`p_print within w_fencode
end type

type p_delete from wt_vertdetail`p_delete within w_fencode
end type

type p_update from wt_vertdetail`p_update within w_fencode
end type

type p_input from wt_vertdetail`p_input within w_fencode
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_fencode
end type

type p_clear from wt_vertdetail`p_clear within w_fencode
end type

type p_copy from wt_vertdetail`p_copy within w_fencode
end type

type dw_c from wt_vertdetail`dw_c within w_fencode
boolean visible = false
end type

type btn_update from wt_vertdetail`btn_update within w_fencode
end type

type st_count from wt_vertdetail`st_count within w_fencode
end type

type dw_list from wt_vertdetail`dw_list within w_fencode
integer y = 156
integer height = 2608
string dataobject = "d_fencode_1"
boolean ibsetlist4filter2dwo = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow, lRowCount

CHOOSE CASE dwo.name
   CASE 'gr_cd'
      lRowCount = dw_Detail.rowcount ()
      FOR  lRow = 1  TO  lRowCount
         dw_Detail.object.gr_cd [lRow] = data
      NEXT
END CHOOSE
end event

event dw_list::ue_print;LONG	lRow

STRING	ls_gr_cd

IF uf_getrange () Then
   lRow = GetSelectedRow (0) ; ls_gr_cd = ''
   DO WHILE (lRow > 0)
      IF f_null (ls_gr_cd) THEN ls_gr_cd = ls_gr_cd + ","
      ls_gr_cd = ls_gr_cd + "'" + Object.gr_cd [lRow] + "'"
      lRow = GetSelectedRow (lRow)
   LOOP
   ole_rd.uf_fileopen ('rd_fencode.mrd', "gr_cd[" + ls_gr_cd + "]")
Else
   dw_Detail.TriggerEvent ('ue_print')
End IF
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF AncestorReturnVALUE=1 THEN RETURN 1

uf_setColumn ('sebu_cd', '.')

POST SetColumn ('gr_cd')

RETURN 0
end event

event dw_list::doubleclicked;call super::doubleclicked;IF dwo.name<>'gr_cd' THEN RETURN

IF f_messageBox ('INFO2', Object.gr_cd [row] + '코드를 엑셀load 하시겠습니까?')=2 THEN RETURN

OLEObject   xlapp, xlsub

LONG	ret, r = 2, c, lRow

STRING	ls_cd, ls_nm

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

// Connect to Excel and check the return code
ret = xlApp.ConnectToObject ("", "excel.application")   // 현재 실행되어 있는 엑셀 Connect
IF ret<0 Then
   f_messageBox ('XLS1', string (ret))
   RETURN 0
End IF

// Make Excel visible
xlApp.Application.Visible = TRUE

xlsub = xlapp.Application.ActiveSheet

FOR  c = 1  TO 99
   IF string (xlsub.cells (2,c).Value)='CODE:'+Object.gr_cd [row] THEN EXIT
NEXT
IF c>90  Then
   f_messageBox ('ERR', '코드가 없습니다.')
   RETURN
End IF

r = 2
DO WHILE TRUE
   r ++
   ls_cd = string (xlsub.cells (r,c).Value)
   IF f_null (ls_cd) THEN EXIT
   gw_mdi.setmicrohelp (f_ntrim (r,0,0))

   ls_nm = MID (ls_cd, POS (ls_cd,' ') + 1)
   ls_cd = MID (ls_cd, 1, POS (ls_cd,' ') - 1)

   lRow = dw_detail.FIND ("sebu_cd='" + ls_cd + "'", 1, dw_detail.rowcount ())
   IF lRow=0   Then
      dw_detail.insertrow (1)
		dw_detail.object.p_visible [1] = 1
      dw_detail.object.gr_cd [1] = Object.gr_cd [row]
      dw_detail.object.sebu_cd [1] = ls_cd
      dw_detail.object.sebu_cd_nm [1] = TRIM (ls_nm)
   Else
      dw_detail.object.sebu_cd_nm [lRow] = TRIM (ls_nm)
   End IF
LOOP

// clean up
xlApp.DisConnectObject ()

DESTROY xlapp

wf_setenabled ()
end event

type dw_detail from wt_vertdetail`dw_detail within w_fencode
integer y = 156
integer height = 2608
string dataobject = "d_fencode_2"
string is_receivetype = "xml"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_List.object.gr_cd [iRow])
end event

event dw_detail::ue_print;ole_rd.uf_fileopen ('rd_fencode.mrd', "gr_cd['" + dw_List.object.gr_cd [iRow] + "']")
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('gr_cd', dw_List.object.gr_cd [iRow])

POST SetColumn ('sebu_cd')

RETURN 0
end event

type st_move from wt_vertdetail`st_move within w_fencode
integer y = 156
integer height = 2608
end type

type ole_rd from u_rd within w_fencode
boolean visible = false
integer x = 1842
integer y = 1344
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string binarykey = "w_fencode.win"
boolean eb_directprint = true
end type

