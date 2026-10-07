forward
global type w_langcvt_02 from w_window1st5cn
end type
type dw_list from fw_u_dwo within w_langcvt_02
end type
end forward

global type w_langcvt_02 from w_window1st5cn
dw_list dw_list
end type
global w_langcvt_02 w_langcvt_02

on w_langcvt_02.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_langcvt_02.destroy
call super::destroy
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;dw_list.SetTransObject( sqlca )

dw_cond.InsertRow(0)
dw_cond.SetFocus()
end event

event wue_retrieve;call super::wue_retrieve;string	ls_text, ls_match_type
long	ll_rowcnt

dw_cond.AcceptText()

ls_text = trim(dw_cond.GetItemString(1, 'text'))
ls_match_type = dw_cond.GetItemString(1, 'match_type')

if isnull(ls_text) or ls_text = '' then
	ls_text = '%'
end if

//매치 유형('E': 일치, 'I': 포함)
if ls_match_type = 'I' then
	if ls_text <> '%' then
		ls_text = '%' + ls_text + '%'
	end if
end if

ll_rowcnt = dw_list.retrieve(gnv_vari.is_sys_id, ls_text)

if ll_rowcnt < 1 then
	messagebox('Notice', '조회된 내용이 없습니다.')
end if
end event

event wue_saveas;call super::wue_saveas;integer	li_ret
string	ls_title, ls_path, ls_file, ls_extension, ls_filter

ls_title = "저장할 파일명을 입력하세요"
ls_extension = "XLS"
ls_filter = "Excel Files (*.xls), *.xls"

li_ret = GetFileSaveName(ls_title, ls_path, ls_file, ls_extension, ls_filter)

if li_ret = 1 then
	li_ret = dw_list.SaveAs(ls_path, Excel5!, true, EncodingANSI!)
	
	if li_ret = 1 then
		messagebox('확인', '[' + ls_file + '] 파일로 저장되었습니다.')
	else
		messagebox('오류', '파일 저장을 실패하였습니다.')
	end if
else
	return
end if
end event

event wue_update;call super::wue_update;Long	ll_rtn
ll_rtn = of_update({dw_list})
If ll_rtn = 1 Then Messagebox('Check', 'Saving has been carried out successfully')

return ll_rtn
end event

event wue_input;idw_u = dw_list
If IsValid(idw_u) Then
	Long		ll_row
	ll_row = idw_u.InsertRow(0)
	idw_u.Post ScrollToRow(ll_row)
	idw_u.Post SetFocus()
End If
return 1
end event

event wue_lastopen;call super::wue_lastopen;dw_cond.InsertRow(0)
end event

type lb_dirlist from w_window1st5cn`lb_dirlist within w_langcvt_02
end type

type ln_templeft from w_window1st5cn`ln_templeft within w_langcvt_02
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_langcvt_02
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_langcvt_02
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_langcvt_02
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_langcvt_02
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_langcvt_02
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_langcvt_02
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_langcvt_02
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_langcvt_02
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_langcvt_02
end type

type uo_navi from w_window1st5cn`uo_navi within w_langcvt_02
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_langcvt_02
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_langcvt_02
end type

type p_close from w_window1st5cn`p_close within w_langcvt_02
end type

type p_excel from w_window1st5cn`p_excel within w_langcvt_02
end type

type p_print from w_window1st5cn`p_print within w_langcvt_02
end type

type p_delete from w_window1st5cn`p_delete within w_langcvt_02
end type

type p_update from w_window1st5cn`p_update within w_langcvt_02
end type

type p_input from w_window1st5cn`p_input within w_langcvt_02
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_langcvt_02
end type

type p_clear from w_window1st5cn`p_clear within w_langcvt_02
end type

type dw_cond from w_window1st5cn`dw_cond within w_langcvt_02
string dataobject = "d_langcvt_02_0"
end type

event dw_cond::getfocus;call super::getfocus;pf_f_togglekoreng('K')
end event

type dw_list from fw_u_dwo within w_langcvt_02
integer x = 50
integer y = 348
integer width = 5381
integer height = 2352
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_langcvt_02_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean setfocusdw = true
end type

event updatestart;call super::updatestart;String		ls_mjr_cd, ls_mnr_cd, ls_fa_seq
Long		ll_rcnt, ll_row
dwitemstatus	 ldwstatus

ll_rcnt = this.rowcount()

do while ll_row <= ll_rcnt        
	ll_row = this.getnextmodified(ll_row, Primary!)        
	IF ll_row > 0 THEN
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)
		Choose Case ldwstatus
			Case NewModified!
				this.setItem(ll_row, 'sys_id', gnv_vari.is_nodekey)
				this.setItem(ll_row, 'reg_id', gnv_vari.is_user_id)
				this.setItem(ll_row, 'reg_dt', fw_f_getymdhh24miss4s())
				
			Case DataModified!
				this.setItem(ll_row, 'upd_id', gnv_vari.is_user_id)
				this.setItem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
		End CHoose
	Else
		ll_row = ll_rcnt + 1        
	End If
Loop

end event

event oue_setupdatecheck;call super::oue_setupdatecheck;long 		NbrRows, ll_row = 0, count = 0
Long		ll_rowcnt, ll_r, ll_temp
String		ls_temp, ls_biz_sumy
String		ls_appr_no
DWItemStatus		ldwstate

dw_list.AcceptText()

NbrRows = this.RowCount()
Do While ll_row <= NbrRows
	ll_row = this.GetNextModified(ll_row, Primary!)        
	
	IF ll_row > 0 Then
		ls_temp = fw_f_nvls(this.getItemString(ll_row, 'org'), '')
		IF Len(ls_temp) = 0 Then
			Messagebox("Check", " row is " + string(ll_row) + " / Original language not registered.")
			return -1
		End IF
	ELSE            
		ll_row = NbrRows + 1
	End IF
LOOP

return 1

end event

event insertrowend;call super::insertrowend;this.setItem(row, 'lng_gb', 'Y')
this.setItem(row, 'use_yn', 'Y')

end event

