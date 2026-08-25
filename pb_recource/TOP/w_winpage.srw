forward
global type w_winpage from w_window1st1ncn
end type
type dw_c from fw_u_dwo within w_winpage
end type
type btn_update from pf_u_commandbutton within w_winpage
end type
type st_count from pf_u_statictext within w_winpage
end type
end forward

global type w_winpage from w_window1st1ncn
integer height = 2904
string icon = "AppIcon!"
boolean ibconfirmupdate4closequery = true
event ue_activate ( )
event type boolean ue_wpage_modified ( )
event ue_setenabled ( boolean arg_new_false,  boolean arg_copy_false,  boolean arg_delete_false )
event ue_setdisabled ( )
event type boolean ue_wpage_updatetable ( )
dw_c dw_c
btn_update btn_update
st_count st_count
end type
global w_winpage w_winpage

type prototypes
Function long GetWindowLong (ulong hWnd, int nIndex) Library "user32.dll" Alias for "GetWindowLongW"
Function long SetWindowLong (ulong hWnd, int nIndex, long dwNewLong) Library "user32.dll" Alias for "SetWindowLongW"
Function Long SetLayeredWindowAttributes(ulong hWnd, Long crKey , byte bAlpha , Long dwFlags) Library "user32.dll"
end prototypes

type variables
BOOLEAN  eb_retrievewait = FALSE
BOOLEAN  eb_rowchangewait = FALSE
BOOLEAN  eb_direct_retrieve = FALSE	// 자동조회

DateTime idt_workdate

INT   ii_dddw_position = 2
INT   ii_dddw_width = 649
INT   ii_dddw_width2 = 649
INT   ii_dddw_width3 = 649
INT   ii_rcd_width = 402
LONG	iRow

STRING	is_date_nation = 'KR'
STRING   is_find  // 조회시 Column 위치 재설정용 Find 문 (retrieveend에서 사용하므로 조회조건 초기값을 주어야 함)
STRING   is_init_value, ia_value []
STRING	tab_string []

BOOLEAN  ib_managedata = TRUE // 초기설정 또는 ue_valid에서 변경

Private:
	DateTime idt_inputdate, idt_ytd
	ANY	item_before []
	BOOLEAN	ib_tag_text_first = TRUE	// dw_c tag_text 초기값 처리
end variables

forward prototypes
public function integer uf_updatecommit (u_dw adw_1, u_dw adw_2)
public function integer uf_updatecommit (u_dw adw)
public function integer uf_itemerror (string name, string msg)
public subroutine wf_setenabled ()
public function datetime uf_initdate (string ag_name)
end prototypes

event ue_activate();IF gaa.debug THEN f_messageBox ('INFO', Classname () + ' : ue_activate')
end event

event type boolean ue_wpage_modified();/* window 내에 변경된 데이타윈도우 혹은 탭페이지가 있는지를 확인
		TRUE  : 자료변경된 데이타윈도우 혹은 탭페이지가 있다.
		FALSE : 자료변경된 데이타윈도우 혹은 탭페이지가 없다.
*/
IF	isvalid (idw_list)	Then
	RETURN idw_list.uf_ismodified ()
Else
	RETURN FALSE
End IF
end event

event ue_setenabled(boolean arg_new_false, boolean arg_copy_false, boolean arg_delete_false);BOOLEAN	lb_enabled
lb_enabled = (arg_new_false=FALSE And ib_managedata)		; if	p_input.enabled<>lb_enabled  then p_input.of_setenabled (lb_enabled)
lb_enabled = (arg_copy_false=FALSE And ib_managedata)		; if	p_copy.enabled<>lb_enabled   then p_copy.of_setenabled (lb_enabled)
lb_enabled = EVENT ue_wpage_updatetable ()					; if	p_update.enabled<>lb_enabled then p_update.of_setenabled (lb_enabled)
lb_enabled = (arg_delete_false=FALSE And ib_managedata)	; if	p_delete.enabled<>lb_enabled then p_delete.of_setenabled (lb_enabled)
end event

event ue_setdisabled();p_clear.of_setenabled (false)
p_update.of_setenabled (false)
p_input.of_setenabled (false)
p_copy.of_setenabled (false)
p_delete.of_setenabled (false)
end event

event type boolean ue_wpage_updatetable();// window 내에 저장 데이타윈도우 혹은 탭페이지가 있는지를 확인
IF	isvalid (idw_list)	Then
	RETURN idw_list.uf_isupdatetable ()
Else
	RETURN FALSE
End IF
end event

public function integer uf_updatecommit (u_dw adw_1, u_dw adw_2);IF	adw_2.uf_Update ()=FALSE THEN RETURN -1
IF	adw_1.uf_Update ()=FALSE THEN RETURN -1
gw_mdi.setmicrohelp (string (Now ()) + ' -> ' + TAG + ' commit')
RETURN 1
end function

public function integer uf_updatecommit (u_dw adw);IF	adw.uf_update ()=false THEN RETURN -1
gw_mdi.setmicrohelp (string (Now ()) + ' -> ' + TAG + ' commit')
RETURN 1
end function

public function integer uf_itemerror (string name, string msg);f_messageBox ('ERR', msg)
dw_c.SetItem (1, name, item_before [1])
dw_c.POST SetFocus ()
dw_c.POST SetColumn (name)
RETURN 1
end function

public subroutine wf_setenabled ();IF	isValid (idw_list)	Then
	IF	idw_list.enabled THEN EVENT ue_setenabled (idw_list.eb_new_false, idw_list.eb_copy_false, idw_list.eb_delete_false)
End IF
end subroutine

public function datetime uf_initdate (string ag_name);CHOOSE CASE ag_name
	CASE 'inputdate'
		RETURN idt_inputdate
	CASE 'ytd'
		RETURN idt_ytd
	CASE ELSE
		RETURN idt_workdate
END CHOOSE
end function

on w_winpage.create
int iCurrent
call super::create
this.dw_c=create dw_c
this.btn_update=create btn_update
this.st_count=create st_count
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_c
this.Control[iCurrent+2]=this.btn_update
this.Control[iCurrent+3]=this.st_count
end on

on w_winpage.destroy
call super::destroy
destroy(this.dw_c)
destroy(this.btn_update)
destroy(this.st_count)
end on

event close;call super::close;f_init_value (classname (), 'setprofile', ia_value)
rollbackJ ()
//Forces immediate garbage collection.
GarbageCollect ()
end event

event resize;call super::resize;dw_c.modify ("tag_text.width='" + string (dw_c.width - dec (dw_c.describe ('tag_text.x'))) + "'")
end event

event open;call super::open;btn_update.VISIBLE = (gaa.login = 'yjs1992@hitel.net')

f_init_value (classname (), is_init_value, ia_value)

idt_ytd = datetime (DATE (gnv_vari.of_getprofile("login.corp.aams.ytd",STRING (DATETIME (today ()),'yyyy') + '.01.01')))

SELECT hyun_ymd
     , f_trade_ymd(hyun_ymd,'-7')
  INTO :idt_workdate
     , :idt_inputdate
  FROM SZX0AA t1
 WHERE t1.CORP_GR = :gaa.CORP_GR ;

idt_workdate  = SQLCA.getitemdatetime (1)
idt_inputdate = SQLCA.getitemdatetime (2)
end event

event wue_confirmupdate4close;IF	EVENT ue_wpage_modified ()=FALSE THEN RETURN 0	//변경된 자료가 없다.

CHOOSE CASE	f_messageBox ('W005', inv_menu.is_pgm_nm)
	CASE 1 // Update
		IF	EVENT wue_update ()=-1 THEN RETURN 1
	CASE 2 // no Update
		rollbackJ ()
	CASE 3
		RETURN 1
END CHOOSE

RETURN 0
end event

event wue_postopen;post event ue_setdisabled ()
IF f_notnull (dw_c.dataobject)	Then
	dw_c.setfocus ()
	dw_c.reset ()
	dw_c.insertrow (0)
	dw_c.event ue_dddw_retrieve ()
End IF
// dddw 값 표시때문에 순서변경하느라...
event wue_lastopen()
end event

event wue_update;/* window 내에 변경된 데이타윈도우 혹은 탭페이지의 자료를 저장한다.
	RETURN Value
		 1 : 자료저장에 성공하였다.
	 	-1 : 자료저장에 실패하였다.
*/
RETURN 0
end event

event wue_retrieve;call super::wue_retrieve;IF	gaa.debug THEN f_messageBox ('INFO', 'wue_retrieve')
IF	dw_c.visible And dw_c.setedittoken THEN dw_c.post event oue_setedittoken44()
IF	isValid (idw_list) THEN idw_list.setredraw (false)
IF	eb_retrievewait THEN f_loadingretrieve (true)
end event

event wue_saveas;call super::wue_saveas;IF IsValid(idw_list) THEN idw_list.EVENT oue_subbtn_excel ()
end event

event wue_delete;INT	li_rtn = 0
IF	isValid (idw_list) THEN li_rtn = idw_list.EVENT ue_delete ()
RETURN li_rtn
end event

event wue_input;INT	li_rtn = 0
IF	isValid (idw_list) THEN li_rtn = idw_list.EVENT ue_insert (0)
RETURN li_rtn
end event

event wue_copy;call super::wue_copy;INT	li_rtn = 0
IF	isValid (idw_list) THEN li_rtn = idw_list.EVENT ue_copyrow ()
RETURN li_rtn
end event

event wue_retrieve2ready;Post Event wue_retrieve()
end event

event wue_print;call super::wue_print;fw_s_parent	lstr_parent

IF	isValid (idw_list)	Then
	idw_list.EVENT ue_print ()
Else
	lstr_parent.w_obj	= iw_parent
	lstr_parent.dw_obj = idw_u

	OpenWithParm(fw_w_dw2preview, lstr_parent)
End IF
end event

event wue_lastopen;call super::wue_lastopen;IF	f_notnull (dw_c.TAG) And ib_tag_text_first THEN dw_c.modify ("tag_text.text='" + dw_c.TAG + "'")
end event

type lb_dirlist from w_window1st1ncn`lb_dirlist within w_winpage
integer x = 5216
integer y = 496
integer width = 160
integer height = 512
end type

type ln_templeft from w_window1st1ncn`ln_templeft within w_winpage
end type

type ln_tempbuttom from w_window1st1ncn`ln_tempbuttom within w_winpage
end type

type ln_temptop from w_window1st1ncn`ln_temptop within w_winpage
end type

type ln_tempbutton from w_window1st1ncn`ln_tempbutton within w_winpage
end type

type ln_tempstart from w_window1st1ncn`ln_tempstart within w_winpage
end type

type ln_cond1_yline from w_window1st1ncn`ln_cond1_yline within w_winpage
end type

type ln_dw1_yline from w_window1st1ncn`ln_dw1_yline within w_winpage
end type

type ln_cond2_yline from w_window1st1ncn`ln_cond2_yline within w_winpage
end type

type ln_dw2_yline from w_window1st1ncn`ln_dw2_yline within w_winpage
end type

type ln_tempright from w_window1st1ncn`ln_tempright within w_winpage
end type

type uo_navi from w_window1st1ncn`uo_navi within w_winpage
end type

type ln_temptop_shadow from w_window1st1ncn`ln_temptop_shadow within w_winpage
end type

type st_windelaytime from w_window1st1ncn`st_windelaytime within w_winpage
end type

type st_top_rect from w_window1st1ncn`st_top_rect within w_winpage
end type

type p_close from w_window1st1ncn`p_close within w_winpage
integer taborder = 10
end type

type p_excel from w_window1st1ncn`p_excel within w_winpage
integer taborder = 90
end type

type p_print from w_window1st1ncn`p_print within w_winpage
integer taborder = 80
end type

type p_delete from w_window1st1ncn`p_delete within w_winpage
integer taborder = 70
boolean enabled = false
end type

type p_update from w_window1st1ncn`p_update within w_winpage
integer taborder = 60
boolean enabled = false
end type

type p_input from w_window1st1ncn`p_input within w_winpage
integer taborder = 40
boolean enabled = false
end type

type p_retrieve from w_window1st1ncn`p_retrieve within w_winpage
integer taborder = 30
end type

type p_clear from w_window1st1ncn`p_clear within w_winpage
boolean enabled = false
end type

type p_copy from w_window1st1ncn`p_copy within w_winpage
integer y = 16
integer taborder = 50
boolean enabled = false
end type

type dw_c from fw_u_dwo within w_winpage
event type boolean ue_valid ( )
event type integer ue_setcodesearch ( long row,  ref string rs_where,  ref string rs_addrow )
event type integer ue_getdate ( string rs_ymd )
event ue_print ( )
integer x = 50
integer y = 156
integer width = 5381
integer height = 164
integer taborder = 100
boolean livescroll = false
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
boolean setfocusdw = true
boolean setedittoken = true
boolean ibsetlist4alrowcolor = false
end type

event type boolean ue_valid();RETURN TRUE
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

event type integer ue_getdate(string rs_ymd);RETURN -1	// 입력일이 존재하면 1 아니면 0
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

event doubleclicked;TRY
	IF	row>0	Then
		::Clipboard ( string (dwo.primary [row]) )	// ClipBoard에 복사처리
		IF	gaa.admin THEN gw_mdi.setmicrohelp (string (dwo.primary [row]) + '...ClipBoard에 복사 ' + dataobject)
	End IF
CATCH (runtimeerror er)
	//
END TRY
end event

event itemchanged;IF dwo.type='column' THEN item_before [1] = dwo.primary [row]

INT   li_ret = 0

STRING   ls_fund_cd [], ls_fund_nm []

IF describe ('xx_'+dwo.NAME+'.type')='column'   Then
   li_ret = gaa.getcode.EVENT ue_setcodeName (THIS, row, dwo.NAME, data, item_before [1], gaa.corp_gr)
End IF

IF dwo.type='column' And LEFT (dwo.name,3)='fr_' And dwo.coltype<>'datetime'	Then
	// from, to 조건은 from 조건으로 복사(자동조회 X)
	IF	li_ret=0 And describe ('to_' + MID (dwo.name,4) +'.type')='column'	Then
		setitem (row, 'to_' + MID (dwo.name,4), data)
		IF	describe ('xx_to_' + MID (dwo.name,4) +'.type')='column'	Then
			setitem (row, 'xx_to_' + MID (dwo.name,4), getitemstring (row, 'xx_fr_' + MID (dwo.name,4)))
		End IF
	End IF
Else
	IF eb_direct_retrieve And li_ret=0 THEN p_retrieve.POST EVENT clicked ()   // 자동조회 처리
End IF

RETURN li_ret
end event

event losefocus;call super::losefocus;IF	setedittoken And ib_managedata=false THEN EVENT oue_setedittoken44()
AcceptText ()
end event

event itemfocuschanged;call super::itemfocuschanged;IF	POS (describe (dwo.name+".tag"),'(한)')>0	Then
	pf_f_togglekoreng ('k')
Else
	pf_f_togglekoreng ('e')
End IF
end event

event itemerror;call super::itemerror;f_selectText (THIS)
RETURN 1
end event

event rbuttondown;STRING	ls_protect, ls_ret

IF	dwo.TYPE='column'	Then
	IF	gaa.debug	Then	// DropDownDataWindow Select문 점검용...
		DataWindowChild	ldwc
		IF	GetChild (dwo.name, ldwc)=1	Then
			::Clipboard ( string (ldwc.GetSQLSelect ()) )
			gw_mdi.setmicrohelp ('...ClipBoard에 SQL문 복사')
			f_messageBox ('INFO', 'DDDW Debug GetSQLSelect~r~n~r~n' + string (ldwc.GetSQLSelect ()))
		End IF
	End IF
	item_before [1] = dwo.primary [row]
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

event buttonup;call super::buttonup;STRING   ls_dwo_name, ls_prefix, ls_colname, ls_ret, ls_data, la_column []

ls_dwo_name = string (DWO.NAME)
ls_prefix   = LEFT (ls_dwo_name, 4)
ls_colname  = MID (ls_dwo_name, 6)

CHOOSE CASE ls_prefix
	CASE 'p_xx'
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
      F_GET_ARRAY (ls_colname, '__', la_column[])
      F_DWODAYCAL (is_date_nation, iw_parent, THIS, ROW, la_column[1], la_column[2])

   CASE 'p_mm'
      F_DWOMONCAL (iw_parent, THIS, ROW, ls_colname, null_s)

   CASE 'p_m2'
      F_GET_ARRAY (ls_colname, '__', la_column[])
      F_DWOMONCAL (iw_parent, THIS, ROW, la_column[1], la_column[2])
END CHOOSE
end event

event dberror;//
end event

type btn_update from pf_u_commandbutton within w_winpage
integer x = 3867
integer y = 16
integer width = 334
integer taborder = 110
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "버튼권한"
end type

event clicked;call super::clicked;str_parameter lstr_parm

lstr_parm.str[1] = of_getpgmno ()
lstr_parm.str[2] = UPPER (parent.classname ())
lstr_parm.str[3] = string (ib_managedata)
lstr_parm.str[4] = f_nvl(dw_c.dataobject,'null')
IF	isvalid (idw_list)	Then
	lstr_parm.bo[1] = idw_list.eb_new_false
	lstr_parm.bo[2] = idw_list.eb_copy_false
	lstr_parm.bo[3] = idw_list.eb_delete_false
End IF

openwithParm (w_popup_btn_role_assign , lstr_parm)
end event

type st_count from pf_u_statictext within w_winpage
boolean visible = false
integer x = 3877
integer y = 180
integer width = 1458
integer height = 116
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 19737901
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean setbringtotop = true
boolean setcondcolor = true
boolean fixedtoright = true
end type

