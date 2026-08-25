forward
global type u_dw from fw_u_dwo
end type
end forward

global type u_dw from fw_u_dwo
integer height = 600
boolean enabled = false
boolean livescroll = false
boolean applydesign = true
boolean useborder = true
boolean setfocusdw = true
boolean setedittoken = true
event type long ue_copyrow ( )
event type long ue_delete ( )
event type long ue_insert ( long row )
event ue_print ( )
event ue_saveas ( )
event type integer ue_setcodesearch ( long row,  ref string rs_where,  ref string rs_addrow )
event ue_update ( )
event ue_viewconfig ( )
event ue_retrieve ( )
event type integer ue_getdate ( string rs_ymd )
event type integer rowfocuschanging_return ( long currentrow,  long newrow )
event type integer rowfocuschanged_if ( long currentrow )
event type long ue_copystart ( )
event type long ue_deletestart ( )
event type long ue_insertstart ( )
event ue_protect ( long row )
event ue_copyrowset ( integer row )
event ue_deleterow ( integer row )
event ue_load ( )
end type
global u_dw u_dw

type variables
STRING	ia_protect [] = {'', '', 'current column tab list ... uf_protect Checking And seting', ''}   // 1-edit, 2-All Tab 0, 3-Current, 4-InitValue Empty
STRING	is_encrypts				// 암호화 컬럼
BOOLEAN	ib_encrypts = true	// 암호화 컬럼 .format 적용여부
STRING	ia_sort_col [], ia_sort [], ia_sort_header [], ia_sort_htext []

Private:
	BOOLEAN	ib_filter
	LONG		il_width_max = 0
	STRING	is_date_nation, is_sql_default, is_sort_default, ia_encrypts []
	ANY		item_before
end variables

forward prototypes
public function integer uf_dblog ()
public subroutine uf_setcolumn (string as_columnname, string as_initvalue)
public subroutine uf_constructor ()
public subroutine uf_reset (boolean benabled)
public subroutine uf_reset ()
public subroutine uf_retrieveend (string afind, long arowcount, boolean amanagedata)
public function boolean uf_ismodified ()
public function boolean uf_update ()
public subroutine uf_protect (long arow, string aprotect)
public subroutine uf_protect (long arow, string aprotect, boolean anew, boolean acopy, boolean adel)
public function long uf_find (string afind)
public function integer uf_itemerr (integer row, string name, string msg)
public function integer uf_deleteall ()
public subroutine uf_setitem (long ag_row, string ag_column, any ag_value)
public function long of_getcolumnxpos2max ()
public function integer uf_setcodename (long row, string columnold, string as_corp_gr)
public function string uf_dddwctl (string dddw_id1, fw_u_dwo shdw, string dddw_id2, string corp_gr, string add_data, integer iseq, string swhere)
public function string uf_sql_default ()
public subroutine uf_enabled (boolean arg_loading, boolean arg_enabled)
public function boolean uf_filter ()
public function long of_getmax4xpos ()
public function any uf_item_before ()
public function boolean uf_isupdatetable ()
public subroutine uf_dataobject (string dwnm, boolean bforce, u_dw sharedw, string sharedwnm)
public subroutine uf_clear ()
public subroutine uf_dataobject (string dwnm, boolean bforce)
public subroutine uf_date_nation (string nation_cd)
end prototypes

event type long ue_copyrow();IF	rowcount ()=0 THEN RETURN -1
IF	AcceptText ()=-1	Then
	f_messageBox ('W006', '')
	RETURN -1
End IF
IF	eb_Range_DelCopy=FALSE And uf_getrange ()	Then
	f_messageBox ('RANG', '복사')
	RETURN -1
End IF

IF EVENT ue_copystart ()=1 THEN RETURN -1

LONG	ll_firstrow, ll_SelectedRow, ll_startrow, ll_copyrow

ll_firstrow = getrow ()
ll_copyrow = rowcount() + 1 ; ll_startrow = ll_copyrow

Enabled = FALSE

ll_SelectedRow = GetSelectedRow (0)
IF	ll_SelectedRow=0	THEN ll_SelectedRow = ll_firstrow
DO WHILE  ll_SelectedRow>0 And ll_SelectedRow < ll_startrow
	selectrow (ll_SelectedRow, false)
	RowsCopy (ll_SelectedRow, ll_SelectedRow,  Primary!, THIS, ll_copyrow, Primary!)
	EVENT ue_copyrowset (ll_copyrow)
	selectrow (ll_copyrow, true)
	ll_copyrow ++
	ll_SelectedRow = GetSelectedRow (ll_SelectedRow)
	IF	gaa.admin THEN gw_mdi.setmicrohelp ('copyrow : ' + string(ll_copyrow))
LOOP

selectrow (ll_firstrow, false)
//<임시> rowfocuschange가 발생하지 않아서 uf_setrow사용
//setrow (ll_startrow)
uf_setrow (ll_startrow, TRUE)
scrolltorow (ll_startrow)
uf_setrange (false)

Enabled = TRUE

POST SetFocus ()

RETURN 0
end event

event type long ue_delete();IF	rowcount ()=0 THEN RETURN -1
IF	eb_Range_DelCopy=FALSE And uf_getrange ()	Then
	f_messageBox ('RANG', '삭제')
	RETURN -1
End IF

IF EVENT ue_deletestart ()=1 THEN RETURN -1
IF f_messageBox ('W003',iw_parent.dynamic of_getpgmnm ())=2 THEN RETURN -1	// delete Cancel

LONG	ll, ll_row, ll_delete = 0

Enabled = FALSE

ll_row = GetSelectedRow (0)
IF	ll_row=0	Then
	POST SetFocus ()
	RETURN 0
End IF

FOR  ll = rowcount ()  TO  ll_row  STEP -1
	IF	IsSelected (ll)	Then
		EVENT ue_deleterow (ll)
		IF	deleterow (ll)=-1	Then
			f_messageBox ('D000', iw_parent.dynamic of_getpgmnm ())
			RETURN -1
		End IF
	End IF
NEXT
IF ll_row>rowcount () THEN ll_row = rowcount ()
uf_setrow (ll_row, true)

POST SetFocus ()

RETURN	ll_delete
end event

event type long ue_insert(long row);IF	AcceptText ()=-1	Then
	f_messageBox ('W006', '')
	RETURN -1
End IF

IF EVENT ue_insertstart ()=1 THEN RETURN -1

LONG	lRow

Enabled = FALSE

IF	eb_Always_1_Insert THEN	lRow = insertrow (1) ELSE lRow = insertrow (row)
uf_setrow (lRow, true)

POST SetFocus ()

RETURN	lRow
end event

event ue_print();fw_s_parent	lstr_parent

lstr_parent.w_obj	= iw_parent
lstr_parent.dw_obj = THIS

OpenWithParm(fw_w_dw2preview, lstr_parent)

end event

event ue_saveas();IF	uf_getrange ()	Then
	IF	f_messageBox ('W015','')=1	Then
		OpenWithParm (w_SaveAS, THIS)
	Else
		f_saveas_new (THIS)
	End IF
Else
	f_saveas_new (THIS)
End IF

ChangeDirectory (gnv_vari.basepath)

POST SetFocus ()
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

event ue_update();Parent.TriggerEvent ('wue_update')
end event

event ue_viewconfig();OpenwithParm (w_View_dwConfig, THIS)
end event

event type integer ue_getdate(string rs_ymd);RETURN -1	// 입력일이 존재하면 1 아니면 0
end event

event type integer rowfocuschanging_return(long currentrow, long newrow);RETURN 0
end event

event type integer rowfocuschanged_if(long currentrow);RETURN 0
end event

event type long ue_copystart();RETURN 0
end event

event type long ue_deletestart();RETURN 0
end event

event type long ue_insertstart();Modify ('corp_gr.initial="' + gaa.corp_gr + '"')
Modify ('p_visible.initial="1"')
Modify ('rowprotect.initial="0"')
RETURN 0
end event

event ue_protect(long row);// [1] Tab Order 있는 컬럼 Edit
// [2] 모든컬럼 Tab Order 0 처리
// [3] 현재 Modify된 상태 (uf_protect에서 Modify하면서 생성 및 변경)

// uf_protect (row, ia_protect [1])
// uf_protect (row, ia_protect [2], New TRUE/FALSE, Copy TRUE/FALSE, Delete TRUE/FALSE)
post setfocus ()
end event

public function integer uf_dblog ();// 변경된 자료가 없으면 저장하지 않는다.
IF (deletedcount () + ModifiedCount ())<1 THEN RETURN 0

// LOG 관리를 하는지의 여부를 체크한다.
// 로그관리 테이블인지의 여부를 체크한다.

STRING	ls_Table, insert_yn, delete_yn, update_yn, ls_LogTime

LONG	ll_CNT

ls_Table = UPPER (Object.DataWindow.Table.UpdateTable)

SELECT COUNT(*)
     , INSERT_YN
     , UPDATE_YN
     , DELETE_YN
     , TO_CHAR(now(),'yyyymmddhh24miss')
  INTO :ll_CNT
     , :insert_yn
     , :update_yn
     , :delete_yn
     , :ls_LogTime
  FROM WLOG01M t1
 WHERE t1.TABLE_ID = :ls_table
 GROUP BY INSERT_YN
        , UPDATE_YN
        , DELETE_YN;

ll_CNT     = SQLCA.getitemnumber (1)
insert_yn  = SQLCA.getitemstring (2)
update_yn  = SQLCA.getitemstring (3)
delete_yn  = SQLCA.getitemstring (4)
ls_LogTime = SQLCA.getitemstring (5)

CHOOSE CASE SQLCA.SQLCode ()
   CASE 0      // Count > 0이상이며 SQL성공
      IF ll_CNT<1 THEN RETURN 0  // LOG테이블에 등록되지않은 테이블
   CASE 100    // Not Found
      RETURN 0
   CASE ELSE   // 기준테이블에 오류발생 자료를 저장하지 않는다.
      MessageBox ('WLOG01M 조회실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
      RETURN 1
END CHOOSE

LONG	ll_Row, ll_count, ll_Column, ll_Seq

STRING	ls_Column, ls_Value, ls_Key, ls_OldValue, ls_dbColumn

// Primary Buffer
FOR  ll_Row = 1  TO  rowcount ()
   ll_Seq ++
   CHOOSE CASE GetItemStatus (ll_Row, 0, Primary!)
      CASE NewModified! // Insert_Log
         IF insert_yn='Y' THEN
            FOR  ll_Column = 1  TO  integer (Object.DataWindow.Column.Count)
               ls_Column = describe ("#" + STRING (ll_Column) + ".Name")
               IF describe (ls_Column + ".Update")='yes' THEN
                  ls_Value = STRING (Object.Data [ll_Row, ll_Column])
                  ls_Key = IIF (describe (ls_Column+".Key")='yes','Y','N')
                  ls_dbColumn = describe (ls_Column + ".dbName")
                  ls_dbColumn = MidA (ls_dbColumn, PosA (ls_dbColumn,'.') + 1)

                  INSERT  INTO WLOG02T
                      ( CORP_GR    /* _1- */
                      , LOG_YMDT   /* _2- */
                      , LOG_USER   /* _3- */
                      , LOG_GB     /* _4- */
                      , TABLE_ID   /* _5- */
                      , COLUMN_ID  /* _6- */
                      , SERIAL_NO  /* _7- */
                      , KEY_YN     /* _8- */
                      , DATA       /* _9- */
                      , OLD_DATA   /* _10- */
                      )
                  VALUES ( :gaa.corp_gr          /* _1- */
                         , :ls_LogTime           /* _2- */
                         , :gnv_vari.is_user_nm  /* _3- */
                         , 'I'                   /* _4- */
                         , :ls_Table             /* _5- */
                         , :ls_dbColumn          /* _6- */
                         , :ll_Seq               /* _7- */
                         , :ls_Key               /* _8- */
                         , :ls_Value             /* _9- */
                         , NULL                  /* _10- */
                         );
                  IF SQLCA.sqlcode ()<>0 THEN
                     MessageBox ('WLOG02T INSERT LOG 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
                     RETURN 1
                  End IF
               End IF
            NEXT
         End IF

      CASE DataModified! // Update_Log
         IF update_yn='Y' THEN
            FOR  ll_Column = 1  TO  integer (Object.DataWindow.Column.Count)
               ls_Column = describe ("#" + STRING (ll_Column) + ".Name")
               IF describe (ls_Column + ".Update")<>'yes' THEN CONTINUE
               ls_Key = IIF (describe (ls_Column+".Key")='yes','Y','N')
               IF ls_Key='Y' OR GetItemStatus (ll_Row, ll_Column, Primary!)=DataModified! THEN
                  ls_Value = STRING (Object.Data.Current [ll_Row, ll_Column]) // Changed Value
                  ls_OldValue = STRING (Object.Data.Original [ll_Row, ll_Column])   // Original Value
                  ls_dbColumn = describe (ls_Column + ".dbName")
                  ls_dbColumn = MidA (ls_dbColumn, PosA (ls_dbColumn, '.') + 1)

                  INSERT  INTO WLOG02T
                      ( CORP_GR    /* _1- */
                      , LOG_YMDT   /* _2- */
                      , LOG_USER   /* _3- */
                      , LOG_GB     /* _4- */
                      , TABLE_ID   /* _5- */
                      , COLUMN_ID  /* _6- */
                      , SERIAL_NO  /* _7- */
                      , KEY_YN     /* _8- */
                      , DATA       /* _9- */
                      , OLD_DATA   /* _10- */
                      )
                  VALUES ( :gaa.corp_gr          /* _1- */
                         , :ls_LogTime           /* _2- */
                         , :gnv_vari.is_user_nm  /* _3- */
                         , 'U'                   /* _4- */
                         , :ls_Table             /* _5- */
                         , :ls_dbColumn          /* _6- */
                         , :ll_Seq               /* _7- */
                         , :ls_Key               /* _8- */
                         , :ls_Value             /* _9- */
                         , :ls_OldValue          /* _10- */
                         );
                  IF SQLCA.sqlcode ()<>0 THEN
                     MessageBox ('WLOG02T UPDATE LOG 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())
                     RETURN 1
                  End IF
               End IF
            NEXT
         End IF
   END CHOOSE
NEXT

// Delete_Log
IF delete_yn='Y' THEN
   FOR  ll_Row = 1  TO  deletedcount ()
      ll_Seq ++
      FOR  ll_Column = 1  TO  integer (Object.DataWindow.Column.Count)
         ls_Column = describe ("#" + STRING (ll_Column) + ".Name")
         IF describe (ls_Column + ".Update")='yes' THEN
            ls_Value = STRING (Object.Data.Delete [ll_Row, ll_Column])
            ls_Key = IIF (describe (ls_Column+".Key")='yes','Y','N')
            ls_dbColumn = describe (ls_Column + ".dbName")
            ls_dbColumn = MidA (ls_dbColumn, PosA (ls_dbColumn, '.') + 1)

            INSERT  INTO WLOG02T
                ( CORP_GR    /* _1- */
                , LOG_YMDT   /* _2- */
                , LOG_USER   /* _3- */
                , LOG_GB     /* _4- */
                , TABLE_ID   /* _5- */
                , COLUMN_ID  /* _6- */
                , SERIAL_NO  /* _7- */
                , KEY_YN     /* _8- */
                , DATA       /* _9- */
                , OLD_DATA   /* _10- */
                )
            VALUES ( :gaa.corp_gr          /* _1- */
                   , :ls_LogTime           /* _2- */
                   , :gnv_vari.is_user_nm  /* _3- */
                   , 'D'                   /* _4- */
                   , :ls_Table             /* _5- */
                   , :ls_dbColumn          /* _6- */
                   , :ll_Seq               /* _7- */
                   , :ls_Key               /* _8- */
                   , :ls_Value             /* _9- */
                   , NULL                  /* _10- */
                   );
            IF SQLCA.sqlcode ()<>0 THEN
               MessageBox ('WLOG02T DELETE LOG 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
               RETURN 1
            End IF
         End IF
      NEXT
   NEXT
End IF

RETURN 0
end function

public subroutine uf_setcolumn (string as_columnname, string as_initvalue);IF f_null (as_InitValue) THEN Modify (as_ColumnName + '.Initial="null"') &
ELSE								   Modify (as_ColumnName + '.Initial="' + as_InitValue + '"')
end subroutine

public subroutine uf_constructor ();BOOLEAN	lb_fund_cd = FALSE

LONG	ll, lRow

STRING	ls_fund_cd, ls_fund_nm
STRING	ls_col, ls_col_nm, ls_seq, ls_tag, ls_lang

IF	gaa.customer_gr='자문회사'	Then
	ls_fund_cd = '관리번호'
	ls_fund_nm = '계좌명'
Else
	ls_fund_cd = '펀드코드'
	ls_fund_nm = '펀드명'
End IF

is_sort_default = describe ("DataWindow.Table.Sort")
ia_sort = null_a
ia_sort_header = null_a
ia_sort_htext = null_a
ia_sort_col = null_a

IF isValid (ids_filter)	Then
	DESTROY ids_filter
End IF
ids_filter = CREATE datastore
ids_filter.dataobject = 'd_set_filter'

is_sql_default = GetSQLSelect () // DataWindow SQL을 Convert TO Syntax로 생성해야 SQL문에 WHERE문을 변경 사용 할 수 있음

f_get_array (is_encrypts,',',ia_encrypts)
//IF (ib_encrypts And gaa.password) And f_notnull (is_encrypts)   Then
//   FOR  ll = 1  TO  UPPERBOUND (ia_encrypts)
//      MODIFY (MID (ia_encrypts [ll],5)+".format='***' "+MID (ia_encrypts [ll],5)+".edit.password=yes")
//   NEXT
//End IF

IF	describe ("fund_cd_t.type")='text'    THEN MODIFY ("fund_cd_t.text='" + ls_fund_cd + "'")
IF	describe ("fund_nm_t.type")='text'    THEN MODIFY ("fund_nm_t.text='" + ls_fund_nm + "'")
IF	describe ("xx_fund_cd_t.type")='text' THEN MODIFY ("xx_fund_cd_t.text='" + ls_fund_nm + "'")

ia_protect = {'', '', 'current column tab list ... uf_protect Checking And seting', ''}
il_width_max = 0
FOR  ll = 1  TO  long (Object.datawindow.Column.Count)
   ls_col = '#' + string (ll)
	ls_col_nm = describe (ls_col+'.name')
	ls_tag    = describe (ls_col + '.tag')
   IF describe (ls_col+".band")='detail' And (describe (ls_col+".visible")='1' OR f_nvl(ls_tag,'?')<>'?') And describe (ls_col+".type")='column' And long (describe (ls_col+".width"))>0	Then
      il_width_max = MAX(long (describe (ls_col+".x")) + long (describe (ls_col+".width")), il_width_max)
      il_width_max = MAX(long (describe (ls_col+"_t.x")) + long (describe (ls_col+"_t.width")), il_width_max)

		IF	PosA (ls_tag,'(한)')>0	Then
			ls_lang = '한'
			ls_tag = f_replace (ls_tag,'(한)','')
		Else
			ls_lang = '영'
		End IF

      // protect가 선언된 컬럼 또는 chk컬럼은 ue_protect에서 control 제외
      ls_seq = describe(ls_col+'.TabSequence') + ' '
      IF (POS(describe(ls_col+'.protect'),'~t')=0 OR POS (ls_tag,'chk')>0) And long (ls_seq)>0	Then
			ls_tag = f_replace (ls_tag,'chk','')
			ia_protect [1] += ls_col + '.tabsequence=' + ls_seq
			ia_protect [2] += ls_col + '.tabsequence=0 '
		End IF

		IF	f_nvl(ls_tag,'?')<>'?'	Then
			IF	describe (ls_col_nm + '_t.enabled')='1' THEN MODIFY (ls_col_nm + '_t.enabled="1"')
			ls_tag = f_replace (ls_tag,'KEY','')
			IF	f_null (ls_tag) THEN CONTINUE
			CHOOSE CASE ls_col_nm
				CASE 'fund_cd'
					lRow = ids_filter.insertrow (1)
					lb_fund_cd = TRUE
					ids_filter.object.lang [1] = ls_lang
					ids_filter.object.column_tag [1] = ls_fund_cd
					ids_filter.object.column_name [1] = ls_col_nm
					ids_filter.object.type [1] = 'string'
					ids_filter.object.operator [1] = ' like '
					ids_filter.object.mask [1] = null_s
					continue
				CASE 'xx_fund_cd','fund_nm','acct_nm'
					lRow = ids_filter.insertrow ( IIF (lb_fund_cd,2,1) )
					ids_filter.object.lang [lRow] = ls_lang
					ids_filter.object.column_tag [lRow] = ls_fund_nm
					ids_filter.object.column_name [lRow] = ls_col_nm
					ids_filter.object.type [lRow] = 'string'
					ids_filter.object.operator [lRow] = ' like '
					ids_filter.object.mask [lRow] = null_s
					continue
				CASE ELSE
					lRow = ids_filter.insertrow (0)
			END CHOOSE
			ids_filter.object.lang [lRow] = ls_lang
			ids_filter.object.column_tag [lRow] = ls_tag
			ids_filter.object.column_name [lRow] = ls_col_nm
			ids_filter.object.type [lRow] = describe (ls_col+'.ColType')
			CHOOSE CASE	ids_filter.object.type [lRow]
				CASE 'date', 'datetime'
					ids_filter.object.lang [lRow] = 'DT'
					ids_filter.object.operator [lRow] = ' = '
				CASE 'int', 'long', 'number', 'real', 'ulong'
					ids_filter.object.lang [lRow] = 'Num'
					ids_filter.object.operator [lRow] = ' >= '
				CASE ELSE
					ids_filter.object.operator [lRow] = IIF (MidA (ids_filter.object.type [lRow],1,7)='decimal', ' >= ', ' like ')
			END CHOOSE
			ids_filter.object.mask [lRow] = describe(ls_col+'.Edit.Case')
		End IF
      IF describe(ls_col+'.Edit.Style')='dddw' THEN MODIFY (ls_col + '.dddw.lines=10')
      ia_protect [4] += ls_col + ".initial='null' "
	End IF
NEXT
ib_filter = (lRow > 0)

IF	PosA('148',describe ('DataWindow.processing'))>0	Then
	il_width_max = pixelstounits (UnitsToPixels (il_width_max + 127, XUnitsToPixels!), XPixelsToUnits!)
Else
	il_width_max = pixelstounits (UnitsToPixels (il_width_max + 240, XUnitsToPixels!), XPixelsToUnits!)
End IF

uf_resizecolumn()
end subroutine

public subroutine uf_reset (boolean benabled);IF	f_null (dataobject) THEN RETURN
uf_setrange (false)
IF	benabled	Then
	setredraw (false)	// retrieveend에서 TRUE
Else
	Enabled = FALSE
End IF
reset ()

LONG		ll, ll_sort
STRING	ls_modify
ll_sort = UPPERBOUND (ia_sort)
IF	ll_sort>0	Then
	FOR  ll = 1  TO  ll_sort
		ls_modify += ia_sort_header [ll] + ".color='0'~t" + ia_sort_header [ll] + ".text='" + ia_sort_htext [ll] + "'~t"
	NEXT
	Modify (ls_modify)
End IF
end subroutine

public subroutine uf_reset ();IF f_null (dataobject) THEN RETURN
uf_setrange (false)
reset ()

LONG		ll, ll_sort
STRING	ls_modify
ll_sort = UPPERBOUND (ia_sort)
IF	ll_sort>0	Then
	FOR  ll = 1  TO  ll_sort
		ls_modify += ia_sort_header [ll] + ".color='0'~t" + ia_sort_header [ll] + ".text='" + ia_sort_htext [ll] + "'~t"
	NEXT
	Modify (ls_modify)
End IF
end subroutine

public subroutine uf_retrieveend (string afind, long arowcount, boolean amanagedata);f_loadingun ()

LONG	lRow
INT	li_sort, li

li_sort = UPPERBOUND (ia_sort)
IF	li_sort>0	Then
	ia_sort = null_a
	setsort (is_sort_default)
	sort ()
	GroupCalc ()
End IF

Enabled = TRUE
uf_setrange (false)

IF	amanagedata And arowcount=0	Then
	event ue_insert (0)
Else
	IF	f_nvl (afind,'detail')<>'detail' And arowcount>0	Then
		lRow = FIND (afind, 1, arowcount)
		IF lRow=0 THEN lRow = 1
		uf_setrow (lRow, false)
	Else
		IF	arowcount>0 THEN uf_setrow (1, false)
		//<임시> editable상태에서 rowprotect에 selectrow가 되어있는 경우 row가 바뀌지 않아 강제로 변경합니다
		// 테스트화면 : 2641
		// protect row와 editable row가 같이있어야 확인가능합니다
		IF getrow()<>1 AND ibsetlist4singleselect THEN uf_setrow (getrow (), false)
	End IF
End IF

setredraw (true)

IF	afind<>'detail' THEN POST SetFocus ()
end subroutine

public function boolean uf_ismodified ();IF f_null (dataobject) THEN RETURN FALSE
IF Object.datawindow.Table.UpdateTable='?' THEN RETURN FALSE
IF	AcceptText ()=-1 THEN RETURN TRUE
IF ModifiedCount ()>0 OR deletedcount ()>0 THEN RETURN TRUE
RETURN FALSE
end function

public function boolean uf_update ();IF f_null (dataobject)                     THEN RETURN TRUE
IF Object.DataWindow.Table.updatetable='?' THEN RETURN TRUE
IF	modifiedcount ()>0 OR deletedcount ()>0	Then
	IF	UPDATE ()=-1	Then	// update Error
		f_messageBox ('W024', dataobject + ' update 에러 (no rollback)')
		RETURN FALSE
	End IF
	commitJ ()
	IF	SQLCA.sqlcode ()<>0	Then
		messagebox ('commit error', SQLCA.sqlerrtext ())
		RETURN FALSE
	End IF
	gw_mdi.setmicrohelp (dataobject + ' 수정한 자료가 저장되었습니다.')
End IF
RETURN TRUE
end function

public subroutine uf_protect (long arow, string aprotect);IF	describe ('rowprotect.type')='column' THEN RETURN	// datawindow protect에서 처리
IF ia_protect [3]=aprotect OR f_null (aprotect) THEN RETURN
ia_protect [3] = aprotect
setredraw (false)
modify (ia_protect [3])
setredraw (true)
end subroutine

public subroutine uf_protect (long arow, string aprotect, boolean anew, boolean acopy, boolean adel);eb_new_false = NOT anew
eb_copy_false = NOT acopy
eb_delete_false = NOT adel
IF	describe ('rowprotect.type')='column' THEN RETURN	// datawindow protect에서 처리
IF ia_protect [3]=aprotect OR f_null (aprotect) THEN RETURN
ia_protect [3] = aprotect
setredraw (false)
modify (ia_protect [3])
setredraw (true)
end subroutine

public function long uf_find (string afind);LONG	ll
ll = FIND (afind, 1, rowcount ())
IF ll>0 THEN uf_setrow (ll, false)
RETURN ll
end function

public function integer uf_itemerr (integer row, string name, string msg);IF msg<>'item_before' THEN F_MESSAGEBOX ('I000', msg + classname (name))

STRING	ls_coltype 

ls_coltype = DESCRIBE (NAME + ".ColType")
IF	POS (ls_coltype,'(')>0 THEN ls_coltype = LEFT (ls_coltype, POS (ls_coltype,'(') - 1)
CHOOSE CASE TRIM (ls_coltype)
   CASE 'char', 'string'
      setitem (ROW, NAME, '')
   CASE 'decimal', 'int', 'long', 'ulong', 'number', 'real', 'integer'
      setitem (ROW, NAME, null_dc)
   CASE 'date', 'datetime'
      setitem (ROW, NAME, null_dt)
END CHOOSE

POST SetFocus ()
POST SetColumn (NAME)
RETURN 1
end function

public function integer uf_deleteall ();LONG  lRow, lrowcount

Enabled = FALSE
setfilter ('') ; filter ()

lrowcount = rowcount ()
FOR  lRow = lrowcount  TO  1  STEP -1
	EVENT ue_deleterow (lRow)
	IF	deleterow (lRow)=-1	Then
		f_messageBox ('D000', 'uf_deleteall : ' + iw_parent.dynamic of_getpgmnm ())
		RETURN -1
	End IF
NEXT

Enabled = TRUE

uf_update ()

RETURN 0
end function

public subroutine uf_setitem (long ag_row, string ag_column, any ag_value);STRING   ls_type
ls_type = describe (ag_column+".ColType")
CHOOSE CASE ls_type
	CASE 'date'
		setitem (ag_row, ag_column, date (MidA (string (ag_value),1,10)))
	CASE 'datetime'
		setitem (ag_row, ag_column, datetime (date (MidA (string (ag_value),1,10))))
	CASE 'int', 'long', 'number', 'real', 'ulong'
		setitem (ag_row, ag_column, dec (ag_value))
	CASE Else
		IF MidA (ls_Type,1,7)='decimal' THEN setitem (ag_row, ag_column, dec (ag_value)) ELSE setitem (ag_row, ag_column, ag_value)
END CHOOSE
end subroutine

public function long of_getcolumnxpos2max ();IF	PosA('148',describe ('DataWindow.processing'))>0 And NOT HScrollBar THEN HScrollBar = TRUE
RETURN pixelstounits (UnitsToPixels (il_width_max, XUnitsToPixels!), XPixelsToUnits!)
end function

public function integer uf_setcodename (long row, string columnold, string as_corp_gr);uf_setrow (row, false)
SetColumn (columnold)
RETURN	gaa.getcode.EVENT ue_SetCodeName (THIS, row, columnold, GetText (), '', as_corp_gr)
end function

public function string uf_dddwctl (string dddw_id1, fw_u_dwo shdw, string dddw_id2, string corp_gr, string add_data, integer iseq, string swhere);LONG	ll_width, ll_leng, ll, lShare

STRING	ls_ret, ls1_dddw_id, la_dddw_id []

DataWindowChild	ldwc1, ldwc2

ls_ret = f_dddwctl (THIS, dddw_id1, corp_gr, add_data, iseq, swhere)

ls1_dddw_id = dddw_id1
IF POSA (dddw_id1, ' | ')>0 THEN ls1_dddw_id = LEFT (dddw_id1, POSA (dddw_id1, ' | ') - 1)	// 조회조건 dddw Column 을 위해

IF GetChild (ls1_dddw_id, ldwc1)=-1 THEN RETURN ''

ll_leng = dec (ldwc1.describe ('#2.tag'))

lShare = f_get_array (dddw_id2, ',', la_dddw_id)
FOR  ll = 1  TO  lShare
	IF shdw.GetChild (la_dddw_id [ll], ldwc2)=-1 THEN CONTINUE

	ldwc1.ShareData (ldwc2)
	ldwc2.Modify ( '#1.width='+string (ldwc1.describe('#1.width')) )
	IF	ldwc1.rowcount ()>10 THEN shdw.Modify (la_dddw_id [ll]+'.dddw.vscrollbar=yes')

	ll_width = dec (shdw.describe(la_dddw_id [ll]+'.width'))
	IF	ll_width<ll_leng	Then
		shdw.Modify (la_dddw_id [ll]+'.dddw.PercentWidth='+string (round (ll_leng / ll_width * 100, 0)))
	Else
		shdw.Modify (la_dddw_id [ll]+'.dddw.PercentWidth=100')
	End IF
NEXT

RETURN	ls_ret
end function

public function string uf_sql_default ();RETURN is_sql_default
end function

public subroutine uf_enabled (boolean arg_loading, boolean arg_enabled);IF	arg_loading THEN f_loadingrd (NOT arg_enabled)
enabled = arg_enabled
end subroutine

public function boolean uf_filter ();RETURN ib_filter
end function

public function long of_getmax4xpos ();RETURN il_width_max
end function

public function any uf_item_before ();RETURN item_before
end function

public function boolean uf_isupdatetable ();IF f_null (dataobject)                     THEN RETURN FALSE
IF Object.datawindow.Table.UpdateTable='?' THEN RETURN FALSE
RETURN TRUE
end function

public subroutine uf_dataobject (string dwnm, boolean bforce, u_dw sharedw, string sharedwnm);IF lower(DataObject) <> lower(dwnm) OR bForce   Then
   ShareDataOff ()
   of_setdataobject (dwnm)
   uf_constructor ()
   of_setdefault4dwo ()
   SETTRANSOBJECT (SQLCA)
   sharedw.of_setdataobject (sharedwnm)
   sharedw.uf_constructor ()
   sharedw.of_setdefault4dwo ()
   ShareData (sharedw)
END IF
end subroutine

public subroutine uf_clear ();uf_reset (FALSE)
of_setdestroy2filter('')
of_setdestroy2sort('')
IF ibsetlist4subbtn THEN of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
modify (ia_protect [4])
insertrow (0)
IF	describe ('p_visible.type')='column'	Then
	setitem (1, 'p_visible', 0)
	f_dw_resetstatus (THIS, 1, {'p_visible'})
End IF
end subroutine

public subroutine uf_dataobject (string dwnm, boolean bforce);IF lower(DataObject) <> lower(dwnm) OR bForce   Then
   of_setdataobject (dwnm)
   uf_constructor ()
   of_setdefault4dwo ()
   SETTRANSOBJECT (SQLCA)
END IF
end subroutine

public subroutine uf_date_nation (string nation_cd);is_date_nation = nation_cd
end subroutine

event updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1
IF uf_DBLog ()=1         THEN RETURN 1

LONG  ll, ll_en, lCol, lColCnt

STRING   ls_col_nm, ls_tag, ls_data, ls_enc_data

lColCnt = integer (Object.datawindow.Column.Count)
FOR  ll = 1  TO  rowcount ()
   IF GetItemStatus (ll, 0, Primary!)=DataModified! OR GetItemStatus (ll, 0, Primary!)=NewModified!   Then
      FOR  lCol = 1  TO  lColCnt
         ls_col_nm = describe ('#' + string (lCol) + ".Name")
         ls_tag = describe (ls_col_nm+".Tag") ; ls_tag = f_replace (ls_tag, '(한)', '') // filter에서 한,영 입력모드 변환용
         IF PosA (ls_tag,'KEY')>0   Then
            IF f_null (Object.Data [ll, lCol])  Then
               f_messageBox ('I000', f_ntrim (ll,0,0) + '행 ' + f_replace (ls_tag, 'KEY', '') + '(' + ls_col_nm + ')에 값을 입력하십시오.')
               SetRow (ll)
               ScrollToRow (ll)
               SetColumn (ls_col_nm)
               RETURN 1
            End IF
         End IF
      NEXT
   End IF
	IF	f_notnull (is_encrypts)	Then
		FOR  ll_en = 1  TO  UPPERBOUND (ia_encrypts)
			ls_col_nm = ia_encrypts [ll_en]
			IF	GetItemStatus (ll, MID (ls_col_nm,5), Primary!)=DataModified! OR GetItemStatus (ll, MID (ls_col_nm,5), Primary!)=NewModified!	Then
				ls_data = GetItemString (ll, MID (ls_col_nm,5))
				IF	f_null (ls_data)	Then
					SetItem (ll, ls_col_nm, NULL_S)
				Else
					SELECT TO_ENCRYPTS (:ls_data) INTO :ls_data FROM DUAL;
					SetItem (ll, ls_col_nm, SQLCA.GETITEMSTRING (1))
				End IF
			End IF
		NEXT
	End IF
NEXT
end event

event constructor;call super::constructor;IF	f_null (dataobject) THEN RETURN
uf_constructor ()
end event

event doubleclicked;IF	isvalid (dwo)	Then
	TRY
		IF dwo.BAND='header'	Then
			BOOLEAN	lb_name
			STRING	ls_col, ls_color = '16711680', ls_sort = '', ls_modify = '', la_sort []	// Clear 용
			LONG		ll_sort, ll, lj
	
			ll_sort = UPPERBOUND (ia_sort)
			FOR  ll = 1  TO  ll_sort
				IF	ia_sort_header [ll]=dwo.NAME	THEN
					IF	ia_sort [ll]=' DS, '	Then
						ia_sort [ll] = ' AS, '
						ls_color = '999108'
					Else
						ls_color = '2960685'
						FOR  lj = ll  TO  ll_sort
							ls_modify += ia_sort_header [lj] + ".color='0'~t" + ia_sort_header [lj] + ".text='" + ia_sort_htext [lj] + "'~t"
						NEXT
					End IF
					EXIT
				End IF
				la_sort [ll] = ia_sort [ll]
			NEXT
			CHOOSE CASE	ls_color
				CASE '2960685'
					ia_sort = la_sort
				CASE '16711680'
					ll_sort ++
					lb_name = FALSE
					FOR  ll = 1  TO  long (Object.DataWindow.Column.Count)
						ls_col = '#' + string (ll)
						IF	string (describe (ls_col + ".Name"))+'_t' = dwo.name	Then
							ia_sort_col [ll_sort] = string (describe (ls_col + ".Name"))
							ia_sort [ll_sort] = ' DS, '
							ia_sort_header [ll_sort] = dwo.NAME
							ia_sort_htext [ll_sort] = f_replace (dwo.text,'"','')
							ls_modify += dwo.NAME + ".text='" + string (ll_sort) + ia_sort_htext [ll_sort] + "'~t"
							lb_name = TRUE
							EXIT
						End IF
					NEXT
					IF	lb_name=FALSE	Then
						FOR  ll = 1  TO  long (Object.DataWindow.Column.Count)
							ls_col = '#' + string (ll)
							IF	describe (ls_col+".Band")='detail' And describe (ls_col + ".visible")='1'	Then
								CHOOSE CASE  long (dwo.x)
									CASE long (describe (ls_col + ".X")) TO long (describe (ls_col + ".X")) + long (describe (ls_col + ".Width"))
										ia_sort_col [ll_sort] = string (describe (ls_col + ".Name"))
										ia_sort [ll_sort] = ' DS, '
										ia_sort_header [ll_sort] = dwo.NAME
										ia_sort_htext [ll_sort] = f_replace (dwo.text,'"','')
										ls_modify += dwo.NAME + ".text='" + string (ll_sort) + ia_sort_htext [ll_sort] + "'~t"
										EXIT
								END CHOOSE
							End IF
						NEXT
					End IF
			END CHOOSE
			Modify (ls_modify + dwo.NAME + ".color='" + ls_color + "'")
	
			ll_sort = UPPERBOUND (ia_sort)
			FOR  ll = 1  TO  ll_sort
				ls_sort += ia_sort_col [ll] + ia_sort [ll]
			NEXT
			IF	LEN (ls_sort)>0 THEN ls_sort = MidA (ls_sort, 1, LenA (ls_sort) - 2)
			IF	gaa.admin THEN f_microHelp (string (Now ()) + ' sort:' + f_nvl (ls_sort,'(default)'+is_sort_default))
			Enabled = FALSE ; SetRedraw (FALSE)
			SetSort (f_nvl (ls_sort, is_sort_default))
			Sort () ; GroupCalc ()
			uf_setrow (1, true)
			Enabled = TRUE ; SetRedraw (TRUE)
		End IF
		IF	row=0 THEN RETURN
		::Clipboard ( string (dwo.primary [row]) )	// CllpBoard에 복사처리
	CATCH (runtimeerror er)
		RETURN
	END TRY
	IF	gaa.admin THEN gw_mdi.setmicrohelp (string (dwo.primary [row]) + '...doubleclicked cllpBoard에 복사 ' + dataobject)
End IF
end event

event itemfocuschanged;call super::itemfocuschanged;IF	NOT enabled OR isNull(dwo) THEN RETURN
IF	POS (describe (dwo.name+".tag"),'(한)')>0	Then
	post pf_f_togglekoreng ('k')
Else
	post pf_f_togglekoreng ('e')
End IF
end event

event rowfocuschanged;call super::rowfocuschanged;IF currentrow=0 OR NOT enabled OR uf_getrange () THEN RETURN
IF	EVENT rowfocuschanged_if (currentrow)=1 THEN RETURN 1
event ue_protect (currentrow)
parent.dynamic post wf_setenabled ()
end event

event rowfocuschanging;IF AcceptText ()=-1 THEN RETURN 1
IF NOT Enabled OR newrow=0 OR uf_getrange ()	THEN RETURN
RETURN	event rowfocuschanging_return (currentrow, newrow)
end event

on u_dw.create
call super::create
end on

on u_dw.destroy
call super::destroy
end on

event itemchanged;call super::itemchanged;IF	dwo.type='column'	Then
	item_before = dwo.primary [row]
	IF	describe ('xx_'+dwo.name+'.type')='column'	Then
		IF	gaa.getcode.EVENT ue_setcodeName (THIS, row, dwo.name, data, item_before, gaa.corp_gr)=1	Then
			POST setcolumn (string (dwo.name))
			RETURN 1
		End IF
	End IF	
	post event itemchanged_next (row, string (dwo.name))
	IF	dwo.name='chk'       THEN post f_dw_resetstatus (this, row, {'chk'})
	IF	dwo.name='p_visible' THEN post f_dw_resetstatus (this, row, {'p_visible'})
End IF
end event

event rbuttondown;If NOT Isvalid(dwo)              THEN RETURN
If string(dwo.name)='datawindow' THEN RETURN // 데이터윈도우 빈 공백 클릭됨

IF PosA('148',describe ('DataWindow.processing'))=0 And row=0	THEN RETURN // freeform 헤더에 있는 컬럼 우클릭 시 row=0 >> 4114 fund명 우클릭
IF POS (describe (dwo.name+'.band'),'.')>0 And row=0 THEN RETURN // group에 있는 컬럼 우클릭 시 >> 2313 tab5번째 헤더그룹 우클릭

STRING	ls_protect, ls_ret

IF	dwo.TYPE='column'	Then
	item_before = dwo.primary [row]
	ls_protect = dwo.Protect
	IF	isNumber (ls_protect)=FALSE THEN ls_protect = describe ("Evaluate(~""+RightA(ls_protect, LenA(ls_protect)-PosA(ls_protect,"~t"))+", "+string (row)+")")
	//<임시> 우클릭 마다 rowchanged가 발생합니다
	//uf_setrow (row, true)
	uf_setrow (row, false)
	IF	ls_protect='0' And (dec (dwo.TabSequence)>0)	Then
		setcolumn (string (dwo.name))
		IF	describe ('xx_'+dwo.name+'.type')='column'	Then	// 코드찾기가 필요한 컬럼인지 확인한다.
			ls_ret = gaa.getcode.EVENT ue_getcode (row, THIS, gaa.corp_gr)
			IF	NOT f_null (ls_ret)	Then
				dwo.primary [row] = ls_ret ; EVENT itemchanged (row, dwo, ls_ret)
			End IF
			RETURN
		End IF
		// 달력윈도우 열기
		IF	describe (dwo.name+'.ColType')='datetime'	Then
			//<임시> 우클릭으로 달력을 켜는경우 바로 꺼지는 현상수정 2022.01.28 post 추가
			//테스트화면 : 공지사항 dw_master
			post f_dwodaycal (is_date_nation, iw_parent, THIS, row, dwo.name, null_s)
			RETURN
		End IF
	End IF
Else
	TRY
		IF	dwo.BAND='header' And gaa.debug	Then
			f_messageBox ('INFO', 'Protect Debug List~r~n~r~n' + 'all edit [ ' + ia_protect [1] + ' ]~r~ntab(admin) edit [ ' + ia_protect [2] + ' ]~r~ncurrent [ ' + ia_protect [3] + ' ]')
			RETURN
		End IF
	CATCH (runtimeerror er)
		//
	END TRY
End IF
call super::rbuttondown
end event

event oue_keydown;If ibsetlist4excelclip=false      Then return 0
IF not (keyflags=2 and key=KeyV!) THEN RETURN 0

STRING   ls_old, ls_data, ls_columnname, ls_rows[], ls_fields[]

LONG	ll, lm, ll_row, ll_rowcnt, ll_fieldcnt

// get current row
ll_row = getrow ()
IF ll_row=0 THEN RETURN 0

// get current column
ls_columnname = getcolumnname ()
IF ls_columnname="" THEN RETURN 0

// get data from clipboard
ls_old = TRIM (::clipboard ())
ls_data = ls_old
IF right (ls_data,1)="~n" THEN ls_data = left (ls_data, len (ls_data) - 1)
IF right (ls_data,1)="~r" THEN ls_data = left (ls_data, len (ls_data) - 1)

IF ibsetlist4excelclip=FALSE or (POS (ls_data,'~r')=0 And POS (ls_data,'~n')=0 And POS (ls_data,'~t')=0)	Then
	IF	ls_data<>ls_old THEN settext (ls_data)
	RETURN 0
End IF
IF	f_messageBox ('INFO2','여러행 붙여넣기 입니까?')=2	Then
	IF	ls_data<>ls_old THEN settext (ls_data)
	RETURN 0
End IF

// parse the clipboard data into row
IF POS (ls_data,'~r~n')>0  Then
   ll_rowcnt = fw_f_obj2array (ls_data, "~r~n", ls_rows)
ElseIF POS (ls_data,'~r')>0 THEN
   ll_rowcnt = fw_f_obj2array (ls_data, "~r", ls_rows)
Else
   ll_rowcnt = fw_f_obj2array (ls_data, "~n", ls_rows)
End IF
FOR  ll = ll_rowcnt  TO  1  STEP -1
	IF	f_notnull (ls_rows [ll]) THEN EXIT
	ll_rowcnt --
NEXT
FOR  ll = 1  TO  ll_rowcnt
	ls_rows[ll] = f_replace (ls_rows[ll], '~r', '')
	ls_rows[ll] = f_replace (ls_rows[ll], '~n', '')
   // parse the row data into field
   ll_fieldcnt = fw_f_obj2array (ls_rows[ll], "~t", ls_fields)
	FOR  lm = ll_fieldcnt  TO  1  STEP -1
		IF	f_notnull (ls_fields [lm]) THEN EXIT
		ll_fieldcnt --
	NEXT
	FOR  lm = 1  TO  ll_fieldcnt
      // paste data
      IF	NOT isNULL (ls_fields[lm]) THEN settext (ls_fields[lm])
      // move focus to the next column
      IF lm<ll_fieldcnt  Then
         sEnd (handle (THIS), 256, 9, long (0,0))
      End IF
   next
   // move focus to the next row
   IF lm<ll_rowcnt Then
      ll_row ++
      IF ll_row>rowcount () THEN EVENT ue_insert (ll_row)
      scrolltorow (ll_row)
      setrow (ll_row)
      setcolumn (ls_columnname)
   End IF
NEXT
RETURN 1
end event

event oue_subbtn_input;call super::oue_subbtn_input;EVENT ue_insert (0)
end event

event oue_subbtn_delete;call super::oue_subbtn_delete;EVENT ue_delete ()
end event

event oue_subbtn_copy;call super::oue_subbtn_copy;EVENT ue_copyrow ()
end event

event oue_subbtn_save;call super::oue_subbtn_save;EVENT ue_saveas ()
end event

event oue_subbtn_excel;call super::oue_subbtn_excel;STRING	ls_seq

SELECT '(' || f_n0 (seqval ('excel_seq'),3) || ')' INTO :ls_seq FROM DUAL;

ls_seq = SQLCA.GETITEMSTRING (1)

IF f_nvl (lower (title),'none')='none' Then
   f_xlsx (THIS, '__' + dataobject + ls_seq, dataobject, '', '', '', '')
ELSE
   f_xlsx (this, '__' + dataobject + ls_seq, title, '', '', '', '')
END IF
end event

event retrieveend;call super::retrieveend;IF	FilteredCount ()>0 OR rowcount=0 OR NOT isValid (ids_filter) THEN RETURN
IF	ids_filter.rowcount ()=0                                     THEN RETURN

// filter ddlb List 생성
DataWindowChild   ldwc

STRING	ls_col_var []

LONG	lj, lRC, lk, lk_cnt

lRC = ids_filter.rowcount ()
IF	lRC=0 THEN RETURN
FOR  lj = 1  TO  lRC
	ls_col_var [lj] = ''
NEXT
FOR  lj = 1  TO  lRC
	IF	describe(string(ids_filter.object.column_name [lj])+'.Edit.Style')='dddw'	Then
		IF	GetChild (ids_filter.object.column_name [lj], ldwc)=1	Then
			FOR  lk = 1  TO  ldwc.rowcount ()
				ls_col_var [lj] += ldwc.GetItemString (lk,1) + '~t' + ldwc.GetItemString (lk,2) + '/'
			NEXT
		ElseIF  describe (string(ids_filter.object.column_name [lj])+'.Edit.Style')='ddlb'	Then
			ls_col_var [lj] = describe(string(ids_filter.object.column_name [lj])+'.vales')
		End IF
	End IF
NEXT
FOR  lj = 1  TO  lRC
	ids_filter.object.ddlb [lj] = ls_col_var [lj]
NEXT
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

event itemchanged_next;call super::itemchanged_next;// ** 주의사항 : post실행으로 값을 변경하고 rowfocuschanged event가 발생하면
//               detail 값이 변경된 자료에 수정되므로 이 event에서 작업하지 말 것.
//               itemchanged event에서 accepttext () 실행 후 작업 하면 됨.
end event

event getfocus;call super::getfocus;if iw_parent.triggerevent('wue_components') = 1 then
	if IsValid(inv_style) then
		if setfocusdw then parent.dynamic post wf_setenabled ()
	end if
end if
end event

event retrievestart;call super::retrievestart;setfilter ('') ; filter ()
event ue_dddw_retrieve ()
end event

