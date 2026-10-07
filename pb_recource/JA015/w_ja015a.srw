forward
global type w_ja015a from wt_list
end type
type cb_3 from pf_u_commandbutton within w_ja015a
end type
end forward

global type w_ja015a from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
integer ii_dddw_position = 1
string is_init_value = "00003"
boolean ib_managedata = false
cb_3 cb_3
end type
global w_ja015a w_ja015a

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = ia_value [1]
dw_c.object.ymd [1] = f_gijunga_ymd ('-')
end event

event wue_retrieve;call super::wue_retrieve;
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.dddw [1])
end event

on w_ja015a.create
int iCurrent
call super::create
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
end on

on w_ja015a.destroy
call super::destroy
destroy(this.cb_3)
end on

event open;icmdbutton = { cb_3 }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja015a
end type

type ln_templeft from wt_list`ln_templeft within w_ja015a
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja015a
end type

type ln_temptop from wt_list`ln_temptop within w_ja015a
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja015a
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja015a
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja015a
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja015a
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja015a
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja015a
end type

type ln_tempright from wt_list`ln_tempright within w_ja015a
end type

type uo_navi from wt_list`uo_navi within w_ja015a
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja015a
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja015a
end type

type p_close from wt_list`p_close within w_ja015a
end type

type p_excel from wt_list`p_excel within w_ja015a
end type

type p_print from wt_list`p_print within w_ja015a
end type

type p_delete from wt_list`p_delete within w_ja015a
end type

type p_update from wt_list`p_update within w_ja015a
end type

type p_input from wt_list`p_input within w_ja015a
end type

type p_retrieve from wt_list`p_retrieve within w_ja015a
end type

type p_clear from wt_list`p_clear within w_ja015a
end type

type p_copy from wt_list`p_copy within w_ja015a
end type

type dw_c from wt_list`dw_c within w_ja015a
string title = "증권사@기준일자"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_valid;call super::ue_valid;ia_value [1] = Object.dddw [1]
RETURN TRUE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw', gaa.corp_gr, "%,전체,", 2, "tr_co_cd in (select mg_cd from szm0ia where corp_gr='" + gaa.corp_gr + "')")
end event

type btn_update from wt_list`btn_update within w_ja015a
end type

type st_count from wt_list`st_count within w_ja015a
end type

type dw_list from wt_list`dw_list within w_ja015a
string dataobject = "d_ja015a"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;
cb_3.of_setEnabled(TRUE)
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mg_cd', gaa.corp_gr, '', 1, '')
end event

type cb_3 from pf_u_commandbutton within w_ja015a
integer x = 2231
integer y = 16
integer width = 535
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "집계표엑셀생성"
end type

event clicked;STRING	ls_file

LONG	ll, lR

OLEObject   obj_excel, lSheet

ads_jTier   lds1, lds2, lds3, lds4

lds1 = CREATE ads_jTier
lds1.DataObject = 'd_save_file'

lds2 = CREATE ads_jTier
lds2.DataObject = 'd_save_file'

lds3 = CREATE ads_jTier
lds3.DataObject = 'd_save_file'

lds4 = CREATE ads_jTier
lds4.DataObject = 'd_save_file'

obj_excel = CREATE oleobject

IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.excel  + '수요예측 총괄집계표(' + string (dw_c.object.ymd [1],'yyyymmdd') + ').xlsx'
IF FileExists (ls_file) Then
   IF NOT FileDelete (ls_file)   Then
      f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
      RETURN
   End IF
End IF

f_loadingyield ('start')

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.Visible = TRUE
obj_excel.Application.CutCopyMode = FALSE
obj_excel.windowstate = 3

obj_excel.workbooks.open (gnv_vari.basepath + '\sja200_su.xlsx', 0, FALSE)   // 읽기전용
lSheet = obj_excel.Application.ActiveSheet

lSheet.Range('7:7').Copy
lSheet.Range('8:'+string (dw_List.rowcount () + 2)).INSERT

lds1.reset ()
lds2.reset ()
lds3.reset ()
lds4.reset ()
FOR  ll = 1  TO  dw_List.rowcount ()
   lR = lds1.insertrow (0)
   lds1.SetItem (lR, 'a', f_nvl (dw_List.object.fund_nm [ll],'') + '~t' + string (dw_List.object.fst_seolj_ymd [ll],'yyyy-mm-dd') + '~t' + string (f_num (dw_List.object.nav [ll])))

   lR = lds2.insertrow (0)
   lds2.SetItem (lR, 'a', string (f_num (dw_List.object.biuo [ll])))

   lR = lds3.insertrow (0)
   lds3.SetItem (lR, 'a', string (f_num (dw_List.object.bond_tot [ll])))

   lR = lds4.insertrow (0)
   lds4.SetItem (lR, 'a', string (f_num (dw_List.object.stock_d [ll])))
NEXT

lSheet.cells(6,1).Select
::Clipboard (lds1.Describe("DataWindow.Data"))
lSheet.Paste()
::Clipboard ('')

lSheet.cells(6,4).Select
::Clipboard (lds2.Describe("DataWindow.Data"))
lSheet.Paste()
::Clipboard ('')

lSheet.cells(6,6).Select
::Clipboard (lds3.Describe("DataWindow.Data"))
lSheet.Paste()
::Clipboard ('')

lSheet.cells(6,9).Select
::Clipboard (lds4.Describe("DataWindow.Data"))
lSheet.Paste()
::Clipboard ('')

f_loadingyield ('stop')
TRY
   obj_excel.activeworkbook.SaveAS (ls_file)
   f_messageBox ('INFO', '운용사보고(HG) 엑셀생성 작업이 완료 되었습니다.~r~n~r~n('+ls_file+') 에서 자료를 확인하십시오.')
CATCH (runtimeerror er)
   f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
END TRY

obj_excel.DisConnectObject ()
DESTROY obj_excel
end event

