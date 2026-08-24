forward
global type w_langcm_01 from w_window1st5cn
end type
type dw_mst from fw_u_dwo within w_langcm_01
end type
type dw_dtl from fw_u_dwo within w_langcm_01
end type
end forward

global type w_langcm_01 from w_window1st5cn
string title = "공통코드관리"
dw_mst dw_mst
dw_dtl dw_dtl
end type
global w_langcm_01 w_langcm_01

type variables

end variables

on w_langcm_01.create
int iCurrent
call super::create
this.dw_mst=create dw_mst
this.dw_dtl=create dw_dtl
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mst
this.Control[iCurrent+2]=this.dw_dtl
end on

on w_langcm_01.destroy
call super::destroy
destroy(this.dw_mst)
destroy(this.dw_dtl)
end on

event wue_postopen;call super::wue_postopen;this.postevent("wue_retrieve2ry")
end event

event wue_retrieve;call super::wue_retrieve;long	ll_ret, ll_row

dw_mst.AcceptText()

ll_ret = dw_mst.retrieve(gnv_vari.is_sys_id)

end event

event wue_update;call super::wue_update;Long	ll_rtn
ll_rtn = of_update({dw_mst, dw_dtl})
if ll_rtn = 1 then Messagebox('Check', '저장이 정상적으로 진행되었습니다')

Return 1
end event

type ln_templeft from w_window1st5cn`ln_templeft within w_langcm_01
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_langcm_01
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_langcm_01
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_langcm_01
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_langcm_01
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_langcm_01
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_langcm_01
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_langcm_01
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_langcm_01
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_langcm_01
end type

type uo_navi from w_window1st5cn`uo_navi within w_langcm_01
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_langcm_01
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_langcm_01
end type

type p_close from w_window1st5cn`p_close within w_langcm_01
end type

type p_excel from w_window1st5cn`p_excel within w_langcm_01
end type

type p_print from w_window1st5cn`p_print within w_langcm_01
end type

type p_delete from w_window1st5cn`p_delete within w_langcm_01
end type

type p_update from w_window1st5cn`p_update within w_langcm_01
end type

type p_input from w_window1st5cn`p_input within w_langcm_01
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_langcm_01
end type

type p_clear from w_window1st5cn`p_clear within w_langcm_01
end type

type dw_cond from w_window1st5cn`dw_cond within w_langcm_01
boolean visible = false
integer x = 2569
integer y = 4
integer width = 110
integer height = 80
boolean enabled = false
boolean ibdesign4cond = false
end type

type dw_mst from fw_u_dwo within w_langcm_01
integer x = 50
integer y = 156
integer width = 1819
integer height = 2544
integer taborder = 20
boolean bringtotop = true
string title = "table"
string dataobject = "d_langcm_01_1"
boolean hscrollbar = true
boolean scaletobottom = true
string isrowcheck4objdelete = "dw_dtl"
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setfocusdw = true
boolean setedittoken = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0001010000"
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return
string	ls_tbl_id
long	ll_ret, ll_row, ll_rtn

dw_mst.AcceptText()

ls_tbl_id = dw_mst.getitemstring(currentrow, 'tbl_id')

if fw_f_nvls(ls_tbl_id, '' ) = '' then
	dw_dtl.reset()
	return
end if

ll_ret = dw_dtl.retrieve(gnv_vari.is_sys_id, ls_tbl_id)
end event

event itemchanged;call super::itemchanged;if row = 0 then return
long	i, ll_cnt	
	
Choose Case dwo.name
	Case 'tbl_id'
		ll_cnt = dw_dtl.rowcount()
		FOR i = 1 TO ll_cnt
			dw_dtl.setItem(i, 'tbl_id', String(data))
		NEXT
	Case 'tbl_nm'
		ll_cnt = dw_dtl.rowcount()
		FOR i = 1 TO ll_cnt
			dw_dtl.setItem(i, 'tbl_nm', String(data))
		NEXT
End CHoose
end event

event insertrowend;call super::insertrowend;if row < 1 then return
this.setFocus()
this.scrollToRow(row)
this.setItem(row, 'sys_id', gnv_vari.is_sys_id)
this.setItem(row, 'use_yn', 'Y')

this.setColumn('tbl_id')
end event

event updatestart;call super::updatestart;Long		ll_rcnt, ll_row, ll_nowseq = 0
Long		ll_mastrow

dwitemstatus	 ldwstatus

ll_rcnt = this.rowcount()

Do While ll_row <= ll_rcnt
	ll_row = this.getnextmodified(ll_row, Primary!)
	if ll_row > 0 then
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)
		Choose Case ldwstatus
			Case NewModified!
				This.setItem(ll_row, 'sys_id', gnv_vari.is_sys_id)
				This.setItem(ll_row, 'col_id', '000')
				This.setItem(ll_row, 'sort_seq', '000')
				This.setItem(ll_row, 'use_yn', 'Y')
				This.setItem(ll_row, 'reg_id', gnv_vari.is_user_id)				
				This.setItem(ll_row, 'reg_dt', fw_f_getymdhh24miss4s())
			Case DataModified!
				This.setItem(ll_row, 'upd_id', gnv_vari.is_user_id)
				This.setItem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
		End CHoose
	Else
		ll_row = ll_rcnt + 1        
	end if
Loop

end event

event oue_subbtn_delete;call super::oue_subbtn_delete;Long	ll_delrow, ll_rowcnt
this.AcceptText()
ll_delrow = this.getrow()
if this.deleterow(0) < 1 then return
ll_rowcnt = this.rowcount()
this.setfocus( )
if this.rowcount() > 0 then
	if ll_delrow < ll_rowcnt then
		this.event rowfocuschanged(ll_delrow)
	else
		this.event rowfocuschanged(ll_rowcnt)
	end if
end if
end event

event oue_subbtn_input;call super::oue_subbtn_input;long		ll_row, ll_rowcnt
ll_rowcnt = this.rowcount()
ll_row = this.insertrow(0)

this.post scrolltorow(ll_row)
this.post setfocus()
end event

type dw_dtl from fw_u_dwo within w_langcm_01
integer x = 1902
integer y = 156
integer width = 3529
integer height = 2544
integer taborder = 30
string title = "column"
string dataobject = "d_langcm_01_2"
boolean scaletoright = true
boolean scaletobottom = true
string isrowcheck4objupdate = "dw_mst"
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setfocusdw = true
boolean setedittoken = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0001010000"
boolean ibsetlist4excelclip = true
end type

event updatestart;call super::updatestart;string	ls_tbl_id, ls_tbl_nm, ls_sort_seq
long	ll_rcnt, ll_row, ll_nowseq = 0
long	ll_mastrow

dwitemstatus	 ldwstatus

ll_mastrow = dw_mst.getrow()
ll_rcnt = this.rowcount()

ls_tbl_id	= dw_mst.getitemstring(ll_mastrow, 'tbl_id')
ls_tbl_nm = dw_mst.getitemstring(ll_mastrow, 'tbl_nm' )

Do While ll_row <= ll_rcnt
	ll_row = this.getnextmodified(ll_row, Primary!)
	if ll_row > 0 then
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)
		Choose Case ldwstatus
			Case NewModified!
				ll_nowseq ++
				
				select	trim(to_char(to_number(nvl(max(col_id), '0')) + :ll_nowseq, '000')) into :ls_sort_seq
				from 	fw_lng02
				where	sys_id = :gnv_vari.is_sys_id
				and		nvl(tbl_id, '')	= :ls_tbl_id
				and		nvl(sort_seq, '') <> '000'
				using sqlca;
				 
				if sqlca.sqlcode <> 0 then
					messagebox("ERROR", "중분류 코드를 생성하지 못했습니다. ")
					iiUpdateStart = 1
					Return iiUpdateStart
				end if
				
				This.setItem(ll_row, 'sys_id', 		gnv_vari.is_sys_id)
				This.setItem(ll_row, 'tbl_id',		ls_tbl_id)
				This.setItem(ll_row, 'tbl_nm',		ls_tbl_nm)
				This.setItem(ll_row, 'sort_seq',	ls_sort_seq)
				This.setItem(ll_row, 'use_yn',		'Y')
				This.setItem(ll_row, 'reg_id',		gnv_vari.is_user_id)				
				This.setItem(ll_row, 'reg_dt',		fw_f_getymdhh24miss4s())
			Case DataModified!
				This.setItem(ll_row, 'upd_id',		gnv_vari.is_user_id)
				This.setItem(ll_row, 'upd_dt',		fw_f_getymdhh24miss4s())
		End CHoose
	Else
		ll_row = ll_rcnt + 1        
	end if
Loop

end event

event insertrowstart;call super::insertrowstart;string	ls_tbl_id, ls_tbl_nm, ls_col_id
dw_mst.AcceptText()

if dw_mst.rowcount() = 0 then
	messagebox("error", "마스터 코드에 데이터가 없습니다. ")
	return -1
end if

ls_tbl_id = dw_mst.getitemstring(dw_mst.getRow(), 'tbl_id' )
if fw_f_nvls(ls_tbl_id, '') = '' then 
	messagebox("ERROR", "테이블명을 입력하지 않았습니다.")
	return -1
end if

ls_col_id = dw_mst.getitemstring(dw_mst.getRow(), 'col_id' )
if fw_f_nvls(ls_col_id, '') = '' then 
	messagebox("ERROR", "컬럼을 입력하지 않았습니다.")
	return -1
end if

return 1

end event

event insertrowend;call super::insertrowend;string 	ls_tbl_nm, ls_tbl_id

ls_tbl_id = dw_mst.getitemstring(row, 'tbl_id' )
ls_tbl_nm = dw_mst.getitemstring(row, 'tbl_nm' )

this.setItem(row, 'tbl_id',	ls_tbl_id)
this.setItem(row, 'tbl_nm', ls_tbl_nm)
this.setItem(row, 'use_yn', 'Y')

this.setFocus()
this.scrollToRow(row)
this.setColumn('col_id')
end event

event deleterowstart;call super::deleterowstart;//dw_mster.setUpdate(False)
return 1
end event

event oue_subbtn_delete;call super::oue_subbtn_delete;Long	ll_delrow, ll_rowcnt
this.AcceptText()
ll_delrow = this.getrow()
if this.deleterow(0) < 1 then return
ll_rowcnt = this.rowcount()
this.setfocus( )
if this.rowcount() > 0 then
	if ll_delrow < ll_rowcnt then
		this.event rowfocuschanged(ll_delrow)
	else
		this.event rowfocuschanged(ll_rowcnt)
	end if
end if
end event

event oue_subbtn_input;call super::oue_subbtn_input;long		ll_row, ll_rowcnt
ll_rowcnt = this.rowcount()
ll_row = this.insertrow(0)
this.post scrolltorow(ll_row)
this.post setfocus()
end event

