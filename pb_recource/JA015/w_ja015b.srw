forward
global type w_ja015b from wt_vertdetail
end type
type cb_3 from pf_u_commandbutton within w_ja015b
end type
end forward

global type w_ja015b from wt_vertdetail
string tag = "전단채수요예측 자료"
boolean ib_managedata = false
cb_3 cb_3
end type
global w_ja015b w_ja015b

on w_ja015b.create
int iCurrent
call super::create
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
end on

on w_ja015b.destroy
call super::destroy
destroy(this.cb_3)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = f_gijunga_ymd ('-')

end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event open;icmdbutton = { cb_3 }
call super::open
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja015b
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja015b
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja015b
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja015b
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja015b
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja015b
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja015b
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja015b
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja015b
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja015b
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja015b
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja015b
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja015b
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja015b
end type

type p_close from wt_vertdetail`p_close within w_ja015b
end type

type p_excel from wt_vertdetail`p_excel within w_ja015b
end type

type p_print from wt_vertdetail`p_print within w_ja015b
end type

type p_delete from wt_vertdetail`p_delete within w_ja015b
end type

type p_update from wt_vertdetail`p_update within w_ja015b
end type

type p_input from wt_vertdetail`p_input within w_ja015b
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja015b
end type

type p_clear from wt_vertdetail`p_clear within w_ja015b
end type

type p_copy from wt_vertdetail`p_copy within w_ja015b
end type

type dw_c from wt_vertdetail`dw_c within w_ja015b
string tag = "전단채 수요예측용"
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertdetail`btn_update within w_ja015b
end type

type st_count from wt_vertdetail`st_count within w_ja015b
end type

type dw_list from wt_vertdetail`dw_list within w_ja015b
string dataobject = "d_ja015b1"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;cb_3.of_setEnabled(TRUE)
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja015b
string dataobject = "d_ja015b2"
boolean maxbox = true
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_List.object.ksd_jm_cd [iRow])
end event

type st_move from wt_vertdetail`st_move within w_ja015b
end type

type cb_3 from pf_u_commandbutton within w_ja015b
integer x = 2231
integer y = 16
integer width = 544
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

ads_jTier   lds1, lds2, lds3

lds1 = CREATE ads_jTier
lds1.DataObject = 'd_save_file'

lds2 = CREATE ads_jTier
lds2.DataObject = 'd_save_file'

lds3 = CREATE ads_jTier
lds3.DataObject = 'd_save_file'

obj_excel = CREATE oleobject

IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.excel  + '전단채수요예측 총괄집계표(' + string (dw_c.object.ymd [1],'yyyymmdd') + ').xlsx'
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

obj_excel.workbooks.open (gnv_vari.basepath + '\sja201_su.xlsx', 0, FALSE)   // 읽기전용
lSheet = obj_excel.Application.ActiveSheet

lSheet.Range('2:2').Copy
lSheet.Range('3:'+string (dw_Detail.rowcount () + 2)).INSERT

lds1.reset ()
lds2.reset ()
lds3.reset ()
FOR  ll = 1  TO  dw_Detail.rowcount ()
   lR = lds1.insertrow (0)
   lds1.SetItem (lR, 'a',  string (dw_Detail.object.tr_co_nm [ll]) + '~t' +  string (dw_Detail.object.hj_nm [ll]) + '~t' + string (dw_Detail.object.ksd_jm_cd [ll]) + '~t' + string(dw_Detail.object.fund_fnm [ll]) + '~t' +  string (dw_Detail.object.acct_no [ll]) + '~t' + string (f_num (dw_Detail.object.aekm [ll])))


   lR = lds2.insertrow (0)
   lds2.SetItem (lR, 'a',  string (f_num (dw_Detail.object.pyom_iyul [ll])) + '~t' + string (f_num (dw_Detail.object.meib_suik_rt [ll])) + '~t' + string (dw_Detail.object.balh_ymd [ll],'yyyy-mm-dd') + '~t' + string (dw_Detail.object.sanghw_ymd [ll],'yyyy-mm-dd'))

   lR = lds3.insertrow (0)
   lds3.SetItem (lR, 'a',  string (dw_Detail.object.jj_nm [ll]) + '~t' + string (dw_Detail.object.pb_nm [ll]) + '~t' + string (dw_Detail.object.pb_tel [ll]))
NEXT

lSheet.cells(2,1).Select
::Clipboard (lds1.Describe("DataWindow.Data"))
lSheet.Paste()
::Clipboard ('')

lSheet.cells(2,8).Select
::Clipboard (lds2.Describe("DataWindow.Data"))
lSheet.Paste()
::Clipboard ('')

lSheet.cells(2,13).Select
::Clipboard (lds3.Describe("DataWindow.Data"))
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

