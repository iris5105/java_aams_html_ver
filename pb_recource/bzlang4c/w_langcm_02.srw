forward
global type w_langcm_02 from w_window1st5cn
end type
type dw_list from fw_u_dwo within w_langcm_02
end type
end forward

global type w_langcm_02 from w_window1st5cn
dw_list dw_list
end type
global w_langcm_02 w_langcm_02

type variables

end variables

on w_langcm_02.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_langcm_02.destroy
call super::destroy
destroy(this.dw_list)
end on

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw2(dw_cond, 'dddw||empty', 'tbl_id', {gnv_vari.is_sys_id})

string	ls_tbl_id
dataWindowChild		ldwc_mstcd

dw_cond.getChild('tbl_id', ldwc_mstcd)
ls_tbl_id = ldwc_mstcd.getitemstring(1, 'tbl_id')
dw_cond.setitem(1, 'tbl_id', ls_tbl_id)
dw_cond.Event itemchanged(1, dw_cond.Object.tbl_id, ls_tbl_id)
end event

event wue_update;call super::wue_update;string	ls_lng_org, ls_lng_kor, ls_lng_eng, ls_lng_chn, ls_lng_vit, ls_lng_loc, ls_errtext
string	ls_sysdate
long		ll_rowcnt, ll_i
integer		li_chk, li_cnt
datetime	ldt_sysdate
dwItemStatus	ldwstatus

dw_list.AcceptText()

ll_rowcnt = dw_list.rowcount()

if ll_rowcnt < 1 then return -1

if dw_list.modifiedcount() + dw_list.deletedcount() > 0 then
	ls_sysdate = fw_f_getymdhh24miss4s()
	
	For ll_i = 1 to ll_rowcnt
		ls_lng_org	= fw_f_nvls(trim(dw_list.getitemstring(ll_i, 'text_lng_org')), '')
		ls_lng_kor	= fw_f_nvls(trim(dw_list.getitemstring(ll_i, 'text_lng_kor')), '')
		ls_lng_eng	= fw_f_nvls(trim(dw_list.getitemstring(ll_i, 'text_lng_eng')), '')
		ls_lng_chn	= fw_f_nvls(trim(dw_list.getitemstring(ll_i, 'text_lng_chn')), '')
		ls_lng_vit	= fw_f_nvls(trim(dw_list.getitemstring(ll_i, 'text_lng_vit')), '')
		ls_lng_loc	= fw_f_nvls(trim(dw_list.getitemstring(ll_i, 'text_lng_loc')), '')
		
		if ls_lng_org <> '' and (ls_lng_kor <> '' or ls_lng_eng <> '' or ls_lng_chn <> '' or ls_lng_vit <> '' or ls_lng_loc <> '') then
			ldwstatus = dw_list.GetItemStatus(ll_i, 0, Primary!)
			
			if ldwstatus = DataModified! or ldwstatus = NewModified! then
				select	count(*) into :li_cnt
				from	fw_lng01
				where	sys_id = :gnv_vari.is_sys_id
				and		lng_gb = '02'
				and		lng_org = :ls_lng_org
				;
				
				li_cnt = SQLCA.getitemnumber (1)

				if li_cnt > 0 then
					update	fw_lng01
						set	lng_kor	= :ls_lng_kor,
							lng_eng	= :ls_lng_eng,
							lng_chn	= :ls_lng_chn,
							lng_vit	= :ls_lng_vit,
							lng_loc	= :ls_lng_loc,
							upd_id = :gnv_vari.is_user_id,
							upd_dt = :ls_sysdate
					where	sys_id	= :gnv_vari.is_sys_id
					and		lng_gb	= '02'
					and		lng_org = :ls_lng_org
					;
				Else
					insert into fw_lng01 (sys_id, lng_gb, lng_org, lng_kor, lng_eng, lng_chn, lng_vit, lng_loc, reg_id, reg_dt)
					values (:gnv_vari.is_sys_id, '02', :ls_lng_org, :ls_lng_kor, :ls_lng_eng, :ls_lng_chn, :ls_lng_vit, :ls_lng_loc, :gnv_vari.is_user_id, :ls_sysdate)
					;
				end if
				
				if SQLCA.SQLCODE() = 0 and SQLCA.SQLNROWS() = 1 then
					li_chk++
				Else
					ls_errtext = SQLCA.SQLERRTEXT
					rollbackj();
					messagebox('ERROR', ls_errtext)
					return -1
				end if
			Else
				Continue
			end if
		end if
	Next
	
	if li_chk > 0 then
		commitj();
		dw_list.ResetUpdate()	//Update Flag 초기화
		//cb_scan.event clicked()
		Messagebox('Check', string(li_chk, '#,##0') + ' count successfully..')
	Else
		Messagebox('Notice', 'There is no content to save.')
	end if
Else
	Messagebox('Notice', 'There is no content to save.')
end if

end event

event wue_retrieve;call super::wue_retrieve;string	ls_tbl_id, ls_col, ls_data
string	ls_lng_kor, ls_lng_eng, ls_lng_chn, ls_lng_vit, ls_lng_loc, ls_reg_yn

dw_cond.AcceptText()
dw_list.reset()
ls_tbl_id	= dw_cond.getitemstring(1, 'tbl_id')
ls_col = dw_cond.getitemstring(1, 'col_id')
if fw_f_nvls(ls_tbl_id, '') = '' then return
if fw_f_nvls(ls_col, '') = '' then return

ads_jtier	lds

string	ls_sqlsyntax

long	lr, lj

lds = create ads_jtier

ls_sqlsyntax =" select  distinct " + ls_col + " from " + ls_tbl_id

lr = sqlca.sql2ds (this.classname(), ls_sqlsyntax, lds, 'xml')
for  lj = 1  to  lr
	dw_list.insertrow (0)
	ls_data = lds.getitemstring (lj, 1)
	dw_list.setitem(lj, 'col_data', ls_data)
	dw_list.setitem(lj, 'text_lng_org', ls_data)
	dw_list.setitem(lj, 'text_lng_kor', ls_data)

	//등록 여부 확인
	select		lng_kor, lng_eng, lng_chn, lng_vit, lng_loc
	into		:ls_lng_kor, :ls_lng_eng, :ls_lng_chn, :ls_lng_vit, :ls_lng_loc
	from		fw_lng01
	where	sys_id = :gnv_vari.is_sys_id
	and		lng_gb = '02'
	and		lng_org = :ls_data
	;
	if sqlca.sqlcode() = 0 and sqlca.sqlnrows() = 1 then
		ls_lng_kor = SQLCA.getitemstring (1)
		ls_lng_eng = SQLCA.getitemstring (2)
		ls_lng_chn = SQLCA.getitemstring (3)
		ls_lng_vit = SQLCA.getitemstring (4)
		ls_lng_loc = SQLCA.getitemstring (5)
		ls_reg_yn = 'Y'
	else
		ls_lng_kor	= ''
		ls_lng_eng	= ''
		ls_lng_chn	= ''
		ls_lng_vit		= ''
		ls_lng_loc	= ''
		ls_reg_yn	= 'N'
	end if
	
	dw_list.setitem(lj, 'text_lng_kor', ls_lng_kor)
	dw_list.setitem(lj, 'text_lng_eng', ls_lng_eng)
	dw_list.setitem(lj, 'text_lng_chn', ls_lng_chn)
	dw_list.setitem(lj, 'text_lng_vit', ls_lng_vit)
	dw_list.setitem(lj, 'text_lng_loc', ls_lng_loc)
	dw_list.setitem(lj, 'reg_yn', ls_reg_yn)
	yield ()
next

//ll_i = 0
//ls_sqlsyntax	= " select  distinct " + ls_col + " from " + ls_tbl_id
//
//Declare mlang_1 Dynamic Cursor FOR sqlsa;
//Prepare sqlsa From :ls_sqlsyntax;
//
//Open Dynamic mlang_1;
//
//Do While TRUE
//	Fetch mlang_1 into :ls_data;
//	
//	if SqlCa.SqlCode = 100 then
//		Exit
//	Elseif SqlCa.SqlCode <> 0 then
//		ls_sqlerrtext = SqlCa.SqlErrText
//		MessageBox('mlang data loading error: ' + string(SqlCa.SqlCode), ls_SqlErrText)
//		Exit
//	end if
//	ll_i++
//	dw_list.insertrow(0)
//	dw_list.setitem(ll_i, 'col_data', ls_data)
//	dw_list.setitem(ll_i, 'text_lng_org', ls_data)
//	dw_list.setitem(ll_i, 'text_lng_kor', ls_data)
//	//등록 여부 확인
//	select	lng_kor, lng_eng, lng_chn, lng_vit, lng_loc
//	into		:ls_lng_kor, :ls_lng_eng, :ls_lng_chn, :ls_lng_vit, :ls_lng_loc
//	from		fw_lng01
//	where	sys_id = :gnv_vari.is_sys_id
//	and		lng_gb = '02'
//	and		lng_org = :ls_data
//	;
//	
//	ls_lng_kor = SQLCA.getitemstring (1)
//	ls_lng_eng = SQLCA.getitemstring (2)
//	ls_lng_chn = SQLCA.getitemstring (3)
//	ls_lng_vit = SQLCA.getitemstring (4)
//	ls_lng_loc = SQLCA.getitemstring (5)
//	
//	if sqlca.sqlcode () = 0 and sqlca.sqlnrows() = 1 then
//		ls_reg_yn = 'Y'
//	Else
//		ls_lng_kor	= ''
//		ls_lng_eng	= ''
//		ls_lng_chn	= ''
//		ls_lng_vit	= ''
//		ls_lng_loc	= ''
//		ls_reg_yn	= 'N'
//	end if
//	dw_list.setitem(ll_i, 'text_lng_eng', ls_lng_eng)
//	dw_list.setitem(ll_i, 'text_lng_chn', ls_lng_chn)
//	dw_list.setitem(ll_i, 'text_lng_vit', ls_lng_vit)
//	dw_list.setitem(ll_i, 'text_lng_loc', ls_lng_loc)
//	dw_list.setitem(ll_i, 'reg_yn', ls_reg_yn)
//Loop
//close mlang_1;


end event

event wue_lastopen;call super::wue_lastopen;dw_cond.Insertrow(0)
end event

type lb_dirlist from w_window1st5cn`lb_dirlist within w_langcm_02
end type

type ln_templeft from w_window1st5cn`ln_templeft within w_langcm_02
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_langcm_02
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_langcm_02
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_langcm_02
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_langcm_02
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_langcm_02
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_langcm_02
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_langcm_02
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_langcm_02
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_langcm_02
end type

type uo_navi from w_window1st5cn`uo_navi within w_langcm_02
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_langcm_02
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_langcm_02
end type

type p_close from w_window1st5cn`p_close within w_langcm_02
end type

type p_excel from w_window1st5cn`p_excel within w_langcm_02
end type

type p_print from w_window1st5cn`p_print within w_langcm_02
end type

type p_delete from w_window1st5cn`p_delete within w_langcm_02
end type

type p_update from w_window1st5cn`p_update within w_langcm_02
end type

type p_input from w_window1st5cn`p_input within w_langcm_02
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_langcm_02
end type

type p_clear from w_window1st5cn`p_clear within w_langcm_02
boolean visible = true
end type

type dw_cond from w_window1st5cn`dw_cond within w_langcm_02
string dataobject = "d_langcm_02_c1"
boolean ibdesign4role = false
end type

event dw_cond::itemchanged;call super::itemchanged;if row < 1 then return
string	ls_tbl_id, ls_col_id
string	ls_objsyntax, ls_error
long	ll_ret
blob	lb_dwsyntax

choose case dwo.name
	case 'tbl_id'
		this.setitem(1, 'col_id', '')
		isdddwarg[] = {gnv_vari.is_sys_id, string(data)}
		fw_f_setdddw2 (this, 'dddw||empty', 'col_id', isdddwarg)
		
	case 'col_id'
		dw_list.reset()
		if fw_f_nvls(string(data), '') = '' then return
		
		ls_tbl_id = this.getitemstring(row, 'tbl_id')
		ls_col_id = string(data)
end choose
end event

type dw_list from fw_u_dwo within w_langcm_02
integer x = 50
integer y = 348
integer width = 5381
integer height = 2352
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_langcm_02_1"
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
end type

