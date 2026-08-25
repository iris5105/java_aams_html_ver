forward
global type w_response from w_response1st
end type
type dw_cond from fw_u_dwo within w_response
end type
type p_retrieve from pf_u_imagebutton within w_response
end type
type p_clear from pf_u_imagebutton within w_response
end type
type p_new from pf_u_imagebutton within w_response
end type
type p_delete from pf_u_imagebutton within w_response
end type
type p_update from pf_u_imagebutton within w_response
end type
type p_ok from pf_u_imagebutton within w_response
end type
type p_close from pf_u_imagebutton within w_response
end type
type p_print from pf_u_imagebutton within w_response
end type
type p_copy from pf_u_imagebutton within w_response
end type
type dw_list from u_dw within w_response
end type
type p_excel from pf_u_imagebutton within w_response
end type
end forward

global type w_response from w_response1st
integer height = 2640
event type boolean ue_wpage_modified ( )
event ue_setenabled ( boolean arg_new_false,  boolean arg_copy_false,  boolean arg_delete_false )
event ue_setdisabled ( )
event type boolean ue_wpage_updatetable ( )
dw_cond dw_cond
p_retrieve p_retrieve
p_clear p_clear
p_new p_new
p_delete p_delete
p_update p_update
p_ok p_ok
p_close p_close
p_print p_print
p_copy p_copy
dw_list dw_list
p_excel p_excel
end type
global w_response w_response

type variables
BOOLEAN  eb_retrievewait = FALSE
BOOLEAN  eb_rowchangewait = FALSE
BOOLEAN  eb_direct_retrieve = FALSE	// 자동조회

INT   ii_dddw_position = 2
INT   ii_dddw_width = 649
INT   ii_dddw_width2 = 649
INT   ii_dddw_width3 = 649
INT   ii_rcd_width = 402
LONG	iRow

STRING	is_date_nation = 'KR'
STRING   is_find  // 조회시 Column 위치 재설정용 Find 문

BOOLEAN  ib_managedata = TRUE

Private:
	ANY	item_before
end variables

forward prototypes
public function integer uf_itemerror (string name, string msg)
public subroutine of_setenabled ()
end prototypes

event type boolean ue_wpage_modified();RETURN dw_List.uf_ismodified ()
end event

event ue_setenabled(boolean arg_new_false, boolean arg_copy_false, boolean arg_delete_false);p_new.of_setenabled ((arg_new_false=FALSE And ib_managedata))
p_copy.of_setenabled ((arg_copy_false=FALSE And ib_managedata))
p_update.of_setenabled (EVENT ue_wpage_updatetable ())
p_delete.of_setenabled ((arg_delete_false=FALSE And ib_managedata))
end event

event ue_setdisabled();p_clear.of_setenabled (false)
IF	ib_managedata	Then
	p_new.of_setenabled (false)
	p_copy.of_setenabled (false)
	p_delete.of_setenabled (false)
End IF
end event

event type boolean ue_wpage_updatetable();RETURN dw_List.uf_isupdatetable ()
end event

public function integer uf_itemerror (string name, string msg);f_messageBox ('ERR', msg)
dw_cond.SetItem (1, name, item_before)
dw_cond.POST SetFocus ()
dw_cond.POST SetColumn (name)
RETURN 1
end function

public subroutine of_setenabled ();EVENT ue_setenabled (dw_list.eb_new_false, dw_list.eb_copy_false, dw_list.eb_delete_false)
end subroutine

on w_response.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.p_retrieve=create p_retrieve
this.p_clear=create p_clear
this.p_new=create p_new
this.p_delete=create p_delete
this.p_update=create p_update
this.p_ok=create p_ok
this.p_close=create p_close
this.p_print=create p_print
this.p_copy=create p_copy
this.dw_list=create dw_list
this.p_excel=create p_excel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.p_retrieve
this.Control[iCurrent+3]=this.p_clear
this.Control[iCurrent+4]=this.p_new
this.Control[iCurrent+5]=this.p_delete
this.Control[iCurrent+6]=this.p_update
this.Control[iCurrent+7]=this.p_ok
this.Control[iCurrent+8]=this.p_close
this.Control[iCurrent+9]=this.p_print
this.Control[iCurrent+10]=this.p_copy
this.Control[iCurrent+11]=this.dw_list
this.Control[iCurrent+12]=this.p_excel
end on

on w_response.destroy
call super::destroy
destroy(this.dw_cond)
destroy(this.p_retrieve)
destroy(this.p_clear)
destroy(this.p_new)
destroy(this.p_delete)
destroy(this.p_update)
destroy(this.p_ok)
destroy(this.p_close)
destroy(this.p_print)
destroy(this.p_copy)
destroy(this.dw_list)
destroy(this.p_excel)
end on

event wue_lastopen;call super::wue_lastopen;IF	f_notnull (dw_cond.TAG) THEN dw_cond.modify ("tag_text.text='" + dw_cond.TAG + "'")
dw_list.event ue_dddw_retrieve ()
IF	eb_direct_retrieve	Then
	p_retrieve.POST EVENT clicked ()
Else
	dw_List.insertrow (0)
End IF
end event

event wue_update;call super::wue_update;IF	dw_list.AcceptText ()=-1	Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF	EVENT ue_wpage_modified ()	Then
   IF	dw_list.uf_update ()=FALSE THEN RETURN -1
   IF	gaa.admin THEN gw_mdi.setmicrohelp (string (Now ()) + ' -> ' + TAG + ' commit')
End IF
RETURN 1
end event

event wue_confirmupdate4close;IF	dw_List.AcceptText ()=-1         THEN RETURN 1
IF	EVENT ue_wpage_modified ()=FALSE THEN RETURN 0   //변경된 자료가 없다.

CHOOSE CASE f_messageBox ('W005', inv_menu.is_pgm_nm)
   CASE 1 // Update_OK
      IF	EVENT wue_update ()=-1 THEN RETURN 1
   CASE 2 // Update_PASS
      rollbackJ ()
	CASE 3
      RETURN 1
END CHOOSE

RETURN 0
end event

event wue_postopen;call super::wue_postopen;EVENT ue_setdisabled ()
IF	f_notnull (dw_cond.dataobject)	Then
	dw_cond.reset ()
   dw_cond.insertrow (0)
   dw_cond.event ue_dddw_retrieve ()
End IF
end event

event wue_retrieve;call super::wue_retrieve;IF	dw_cond.visible	Then
	IF	dw_cond.setedittoken THEN dw_cond.post event oue_setedittoken44()
End IF
IF	eb_retrievewait THEN f_loadingretrieve (true)
end event

event resize;call super::resize;dw_cond.modify ("tag_text.width='" + string (dw_cond.width - dec (dw_cond.describe ('tag_text.x'))) + "'")
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_response
end type

type ln_tempstart from w_response1st`ln_tempstart within w_response
end type

type ln_templeft from w_response1st`ln_templeft within w_response
end type

type ln_cond_start from w_response1st`ln_cond_start within w_response
end type

type ln_tempright from w_response1st`ln_tempright within w_response
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_response
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_response
end type

type dw_cond from fw_u_dwo within w_response
event type integer ue_getdate ( string rs_ymd )
event type integer ue_setcodesearch ( long row,  ref string rs_where,  ref string rs_addrow )
event type boolean ue_valid ( )
boolean visible = false
integer x = 50
integer y = 156
integer width = 3520
integer height = 164
integer taborder = 11
boolean bringtotop = true
boolean livescroll = false
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
boolean setfocusdw = true
boolean setedittoken = true
boolean ibsetlist4alrowcolor = false
end type

event type integer ue_getdate(string rs_ymd);RETURN -1	// 입력일이 존재하면 1 아니면 0
end event

event type integer ue_setcodesearch(long row, ref string rs_where, ref string rs_addrow);/*
CHOOSE CASE	GetColumnName()
	CASE ''
		rs_where = ""
		RETURN 2	// column_seq가 1이 아닐때......
END CHOOSE
*/
rs_where = ''
rs_addrow = ''
RETURN 1	// 순번
end event

event type boolean ue_valid();RETURN TRUE
end event

event constructor;IF	f_null (dataobject) THEN RETURN
MODIFY ('datawindow.selected.mouse=no datawindow.grid.columnmove=no')
CHOOSE CASE dataobject
	CASE 'dc_2ymd_dddw','dc_xx_ymd','dc_ymd','dc_ymd_dddw','dc_ymd_dddw2','dc_ymd_dddw3','dc_ymd_dddw3_xx','dc_ymd_dddw_xx'
		f_dw_cond1 (THIS, dataobject, TITLE, ii_dddw_position, ii_dddw_width, ii_dddw_width2, ii_dddw_width3, ii_rcd_width)
	CASE 'dc_ftymd','dc_ftymd_dddw','dc_ftymd_dddw2','dc_ftymd_dddw3','dc_ftymd_dddw_xx','dc_xx_ftymd'
		f_dw_cond2 (THIS, dataobject, TITLE, ii_dddw_position, ii_dddw_width, ii_dddw_width2, ii_dddw_width3, ii_rcd_width)
	CASE 'dc_dddw_ym','dc_ftmm','dc_ftmm_dddw2','dc_ym_dddw3','dc_yyyy','dc_yyyy_dddw2'
		f_dw_cond3 (THIS, dataobject, TITLE, ii_dddw_position, ii_dddw_width, ii_dddw_width2, ii_dddw_width3, ii_rcd_width)
END CHOOSE
call super::constructor
end event

event doubleclicked;call super::doubleclicked;TRY
	IF	row>0	Then
		::Clipboard ( string (dwo.primary [row]) )	// ClipBoard에 복사처리
		IF	gaa.admin THEN gw_mdi.setmicrohelp (string (dwo.primary [row]) + '...ClipBoard에 복사 ' + dataobject)
	End IF
CATCH (runtimeerror er)
	//
END TRY
end event

event itemchanged;call super::itemchanged;IF dwo.type='column' THEN item_before = dwo.primary [row]

INT   li_ret = 0

STRING   ls_fund_cd [], ls_fund_nm []

IF describe ('xx_'+dwo.NAME+'.type')='column'   Then
   li_ret = gaa.getcode.EVENT ue_setcodeName (THIS, row, dwo.NAME, data, item_before, gaa.corp_gr)
End IF
IF eb_direct_retrieve And li_ret=0 THEN p_retrieve.POST EVENT clicked ()   // 자동조회 처리

RETURN li_ret
end event

event itemfocuschanged;call super::itemfocuschanged;IF	POS (describe (dwo.name+".tag"),'(한)')>0	Then
	pf_f_togglekoreng ('k')
Else
	pf_f_togglekoreng ('e')
End IF
end event

event losefocus;call super::losefocus;IF	setedittoken And ib_managedata=false THEN EVENT oue_setedittoken44()
AcceptText ()
end event

event rbuttondown;If NOT Isvalid(dwo) Then Return
If string(dwo.name) = 'datawindow' Then Return // 데이터윈도우 빈 공백 클릭됨

STRING	ls_protect, ls_ret

IF	dwo.TYPE='column'	Then
	IF	gaa.debug	Then	// DropDownDataWindow Select문 점검용...
		DataWindowChild	ldwc
		IF	GetChild (dwo.name, ldwc)=1	Then
			::Clipboard ( string (ldwc.GetSQLSelect ()) )
			gw_mdi.setmicrohelp ('...ClipBoard에 SQL문 복사')
			f_messageBox ('INFO', 'DDDW Debug GetSQLSelect~r~n~r~n' + string (ldwc.GetSQLSelect ()))
		End IF
	End IF
	item_before = dwo.primary [row]
	ls_protect = dwo.Protect
	IF	isNumber (ls_protect)=FALSE THEN ls_protect = describe ("Evaluate(~""+RightA(ls_protect, LenA(ls_protect)-PosA(ls_protect,"~t"))+", "+string (row)+")")
	IF	ls_protect='0' And (dec (dwo.TabSequence)>0)	Then
		SetColumn (string (dwo.name))
		IF	describe ('xx_'+dwo.name+'.type')='column'	Then	// 코드찾기가 필요한 컬럼인지 확인한다.
			ls_ret = gaa.getcode.EVENT ue_getcode (row, THIS, gaa.corp_gr)
			IF	NOT f_null (ls_ret)	Then
				dwo.primary [row] = ls_ret ; EVENT itemchanged (row, dwo, ls_ret)
			End IF
			RETURN
		End IF
		// 달력윈도우 열기
		IF	describe (dwo.name+'.ColType')='datetime' THEN f_dwodaycal (is_date_nation, iw_parent, THIS, row, dwo.name, null_s)
	End IF
End IF
end event

event dberror;//
end event

event buttonup;call super::buttonup;STRING   ls_dwo_name, ls_prefix, ls_colname, ls_ret, ls_data, la_column[]

ls_dwo_name = string (DWO.NAME)
ls_prefix   = LEFT (ls_dwo_name, 4)
ls_colname  = MID (ls_dwo_name, 6)

CHOOSE CASE ls_prefix
   CASE 'p_xx'
      SETROW (ROW)
      SetColumn (ls_colname)

      ls_ret = gaa.getcode.EVENT ue_getcode (ROW, THIS, gaa.CORP_GR)
      IF F_NOTNULL(ls_ret) THEN
         ls_data = string (gaa.getcode.codesearch_select_data[1])
         SetText (ls_data)
         ACCEPTTEXT ( )   // ItemChanged 이벤트발생
      END IF

   CASE 'p_dd'
      F_DWODAYCAL (is_date_nation, iw_parent, THIS, ROW, ls_colname, null_s)

   CASE 'p_d2'
      F_GET_ARRAY (ls_colname, '__', la_column)
      F_DWODAYCAL (is_date_nation, iw_parent, THIS, ROW, la_column[1], la_column[2])

   CASE 'p_mm'
      F_DWOMONCAL (iw_parent, THIS, ROW, ls_colname, null_s)

   CASE 'p_m2'
      F_GET_ARRAY (ls_colname, '__', la_column)
      F_DWOMONCAL (iw_parent, THIS, ROW, la_column[1], la_column[2])
END CHOOSE
end event

type p_retrieve from pf_u_imagebutton within w_response
boolean visible = false
integer x = 1417
integer y = 28
integer width = 229
integer height = 96
integer taborder = 2
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_lookup.jpg"
end type

event clicked;IF	dw_cond.EVENT ue_valid ()=FALSE	Then
   dw_cond.SetFocus ()
   RETURN
End IF

IF	ib_managedata	Then
   dw_cond.Enabled = FALSE
	p_clear.of_setenabled (true)
	of_setenabled (false)
	dw_List.uf_protect (0, dw_List.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2])
End IF

dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

call super::clicked
Parent.PostEvent("wue_retrieve2ready")
end event

type p_clear from pf_u_imagebutton within w_response
boolean visible = false
integer x = 1179
integer y = 28
integer width = 229
integer height = 96
integer taborder = 1
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_reset1.jpg"
end type

event clicked;call super::clicked;IF EVENT wue_update ()=1 THEN RETURN
IF	dw_cond.dataobject>'' And ib_manageData	Then
	dw_list.uf_clear ()

	p_retrieve.of_setenabled (true)

	dw_cond.Enabled = TRUE
	dw_cond.SetFocus () ; f_selectText (dw_cond)
	RETURN
End IF
IF	eb_direct_retrieve THEN p_retrieve.POST EVENT clicked ()
end event

type p_new from pf_u_imagebutton within w_response
boolean visible = false
integer x = 1655
integer y = 28
integer width = 229
integer height = 96
integer taborder = 3
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_add.jpg"
end type

event clicked;call super::clicked;dw_list.EVENT ue_insert (0)
end event

type p_delete from pf_u_imagebutton within w_response
boolean visible = false
integer x = 2130
integer y = 28
integer width = 229
integer height = 96
integer taborder = 5
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_delete.jpg"
end type

event clicked;call super::clicked;dw_list.EVENT ue_delete ()
end event

type p_update from pf_u_imagebutton within w_response
boolean visible = false
integer x = 2368
integer y = 28
integer width = 229
integer height = 96
integer taborder = 6
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_save.jpg"
end type

event clicked;call super::clicked;Parent.PostEvent("wue_update")
end event

type p_ok from pf_u_imagebutton within w_response
boolean visible = false
integer x = 3081
integer y = 28
integer width = 229
integer height = 96
integer taborder = 9
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

type p_close from pf_u_imagebutton within w_response
boolean visible = false
integer x = 3319
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;Close(Parent)
end event

type p_print from pf_u_imagebutton within w_response
boolean visible = false
integer x = 2606
integer y = 28
integer width = 229
integer height = 96
integer taborder = 7
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_print2.jpg"
end type

type p_copy from pf_u_imagebutton within w_response
boolean visible = false
integer x = 1893
integer y = 28
integer width = 229
integer height = 96
integer taborder = 4
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_copy.jpg"
end type

event clicked;call super::clicked;dw_list.EVENT ue_copyrow ()
end event

type dw_list from u_dw within w_response
integer x = 50
integer y = 348
integer width = 3520
integer height = 2180
integer taborder = 12
boolean bringtotop = true
boolean ibsetlist4excelclip = true
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
of_setenabled ()
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;IF currentrow=0 OR NOT Enabled OR uf_getrange () THEN RETURN 1
iRow = currentrow
of_setenabled ()
RETURN 0
end event

type p_excel from pf_u_imagebutton within w_response
boolean visible = false
integer x = 2843
integer y = 28
integer width = 229
integer height = 96
integer taborder = 8
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_excel.jpg"
end type

event clicked;call super::clicked;STRING	ls_seq

SELECT  '(' || f_n0 (excel_seq.nextval, 3) || ')'
  INTO  :ls_seq
FROM    dual;

ls_seq = SQLCA.getitemstring (1)

IF	f_nvl (lower (dw_list.title),'none')='none'	Then
	f_xlsx (dw_list, '__' + dw_list.dataobject + ls_seq, dw_list.dataobject, '', '', '', '')
Else
	f_xlsx (dw_list, '__' + dw_list.dataobject + ls_seq, dw_list.title, '', '', '', '')
End IF
end event

