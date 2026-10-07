forward
global type u_dynamiccodesearch from nonvisualobject
end type
end forward

global type u_dynamiccodesearch from nonvisualobject
event type string ue_getcode ( long row,  fw_u_dwo au_dw,  string as_corp_gr )
event type integer ue_setcodename ( fw_u_dwo au_dw,  integer row,  string name,  string data,  any item_before_primary,  string as_corp_gr )
end type
global u_dynamiccodesearch u_dynamiccodesearch

type variables
STRING   is_title, is_sql, is_HeaderName, is_SearchDefault

// 우측버튼에서 선택된 row 처리용
STRING   is_SearchColumn, is_returncolumn, is_returnvalue, is_addrow, is_column_size, is_EditCase

INT   ii_CodeSeq

ANY   codesearch_select_data []
end variables

event type string ue_getcode(long row, fw_u_dwo au_dw, string as_corp_gr);WINDOW   lw

LONG  ll_rtn

STRING   ls_ColumnName, ls_Error, ls_SQLSelect , ls_Where, item_before, ls_BrowseWindow

is_returnvalue = null_s
ls_ColumnName  = au_dw.GetColumnName ( )
IF F_NULL (ls_ColumnName)  Then
   F_MESSAGEBOX ('ERR', '조회상태시 우측버튼 사용불가')
   RETURN ''
END IF

// 코드찾기에서 From TO를 무시한다. -> 지워버린다.
is_SearchColumn = F_REPLACE (ls_ColumnName, 'fr_', '')
is_SearchColumn = F_REPLACE (is_SearchColumn, 'to_', '')
is_SearchColumn = F_REPLACE (is_SearchColumn, 'xx_', '')

// SEQ & 추가적으로 필요한 Where절을 가져온다. Default SEQ는 1이다.
ii_CodeSeq = au_dw.DYNAMIC EVENT ue_SetCodeSearch (ROW, ls_Where, is_addrow)
IF ii_CodeSeq=0 THEN RETURN '' // 코드찾기 Pass

is_EditCase = au_dw.DESCRIBE (ls_ColumnName + ".Edit.Case")

// 조건절에 시간이 있을경우 삭제처리
ls_Where = F_REPLACE (ls_Where, ' 00:00:00', '')

// 테이블에 등록되어 있는 코드찾기 정보를 가져온다.
IF LEFT (is_addrow,7)='FENCODE'  Then
   is_HeaderName = F_REPLACE (is_addrow,'FENCODE','')
   is_addrow     = ''
   SELECT code_Select
        , Return_Column
        , NVL(window_nm,'w_DynamicCodeSearch')
        , cmnt
     INTO :ls_SQLSelect
        , :is_returncolumn
        , :ls_BrowseWindow
        , :is_title
     FROM WDCS01M t1
    WHERE column_nm  = 'FENCODE'
      AND column_seq = :ii_CodeSeq;

   ls_SQLSelect    = SQLCA.GETITEMSTRING (1)
   is_returncolumn = F_REPLACE (SQLCA.GETITEMSTRING (2),' ','')
   ls_BrowseWindow = SQLCA.GETITEMSTRING (3)
   is_title        = SQLCA.GETITEMSTRING (4)
ELSE
   SELECT code_Select
        , header_nm
        , Return_Column
        , NVL(window_nm,'w_DynamicCodeSearch')
        , cmnt
     INTO :ls_SQLSelect
        , :is_HeaderName
        , :is_returncolumn
        , :ls_BrowseWindow
        , :is_title
     FROM WDCS01M t1
    WHERE column_nm  = :is_SearchColumn
      AND column_seq = :ii_CodeSeq;

   ls_SQLSelect    = SQLCA.GETITEMSTRING (1)
   is_HeaderName   = SQLCA.GETITEMSTRING (2)
   is_returncolumn = F_REPLACE (SQLCA.GETITEMSTRING (3),' ','')
   ls_BrowseWindow = SQLCA.GETITEMSTRING (4)
   is_title        = SQLCA.GETITEMSTRING (5)
END IF

IF SQLCA.SQLCode ( )<>0  Then
   F_MESSAGEBOX ('ERR', '등록되어 있지 않은 컬럼(' + is_SearchColumn + string (ii_CodeSeq,'_##') + ')입니다.')
   RETURN ''
END IF

// Where 처리
IF F_NOTNULL (ls_Where) Then
   IF PosA (lower (ls_SQLSelect), 'where')>0 THEN ls_SQLSelect += '~r~nAnd ' + ls_Where &
      ELSE ls_SQLSelect += '~r~nWhere ' + ls_Where
END IF
is_sql = F_REPLACE (ls_SQLSelect, ':corp_gr', as_corp_gr)
is_sql += '~r~n--~r~n-- column : ' + ls_ColumnName + '(' + string (ii_CodeSeq) + ')'
OpenwithParm (lw, THIS, ls_BrowseWindow)  // 코드찾기 윈도우 오픈
IF gaa.debug THEN F_MESSAGEBOX ('INFO', 'RButten Column Debug SQL~r~n~r~n' + ls_SQLSelect)

RETURN   is_returnvalue
end event

event type integer ue_setcodename(fw_u_dwo au_dw, integer row, string name, string data, any item_before_primary, string as_corp_gr);ads_jtier   lds_getCode

INT   li_Seq, ll_Ret
INT   li_COL = 1
STRING   ls_Column, ls_Tag, ls_ColumnEXT, ls_ColumnName, ls_ReturnColumn, ls_Type, ls_SQLSelect, ls_Where, ls_Syntax

ls_Column = NAME
IF PosA ('fr_,to_', MidA (ls_Column,1,3))>0  Then
   ls_ColumnEXT = MidA (ls_Column,1,3)
   ls_Column    = MidA (ls_Column,4)
ELSE
   ls_ColumnEXT = ''
END IF

// SEQ & 추가적으로 필요한 Where절을 가져온다. Default SEQ는 1이다.
li_Seq = au_dw.DYNAMIC EVENT ue_setCodeSearch (ROW, ls_Where, is_addrow)
IF li_Seq=0 THEN RETURN 1 // 코드찾기 Pass

// 조건절에 시간이 있을경우 삭제처리
ls_Where = F_REPLACE (ls_Where, ' 00:00:00', '')

// 테이블에 등록되어 있는 코드찾기 정보를 가져온다.
IF LEFT (is_addrow,7)='FENCODE'  Then
   SELECT LTRIM(REPLACE(edit_Select, ':arg_code', :data))
        , REPLACE(Return_Column,' ')
        , column_size
     INTO :ls_SQLSelect
        , :ls_ReturnColumn
        , :is_column_size
     FROM WDCS01M t1
    WHERE column_nm  = 'FENCODE'
      AND column_seq = :li_Seq;
ELSE
   SELECT LTRIM(REPLACE(edit_Select, ':arg_code', :data))
        , REPLACE(Return_Column, ' ')
        , column_size
     INTO :ls_SQLSelect
        , :ls_ReturnColumn
        , :is_column_size
     FROM WDCS01M t1
    WHERE column_nm  = :ls_Column
      AND column_seq = :li_Seq;
END IF

IF SQLCA.sqlcode ( )=0   Then
   ls_sqlselect    = SQLCA.GETITEMSTRING (1)
   ls_ReturnColumn = SQLCA.GETITEMSTRING (2)
   is_column_size  = SQLCA.GETITEMSTRING (3)
ELSE
   F_MESSAGEBOX ('ERR', '등록되어 있지 않은 컬럼(' + ls_Column + string (ii_CodeSeq,'_##') + ')입니다.')
   RETURN 1
END IF
IF f_null (data)  Then  // 코드값 null입력시 관련된 column 초기화
   au_dw.SetItem (row, 'xx_'+name, null_s)
   DO WHILE f_notnull (ls_ReturnColumn)
      ls_ColumnName = f_get_Token (ls_ReturnColumn, ',')
      IF MidA (ls_ColumnName,1,1)='^' THEN ls_ColumnName = ls_ColumnEXT + MidA (ls_ColumnName,2) &
      Else                                 ls_ColumnName = 'xx_' + ls_ColumnEXT + ls_ColumnName
      IF au_dw.describe (ls_ColumnName+'.type')='column' Then
         ls_type = au_dw.describe (ls_ColumnName+".ColType")
         CHOOSE CASE ls_type
            CASE 'date'
               au_dw.SetItem (row, ls_ColumnName, null_d)
            CASE 'datetime'
               au_dw.SetItem (row, ls_ColumnName, null_dt)
            CASE 'int', 'long', 'number', 'real', 'ulong'
               au_dw.SetItem (row, ls_ColumnName, null_i)
            CASE Else
               IF MidA (ls_Type,1,7)='decimal' THEN au_dw.SetItem (row, ls_ColumnName, null_dc) &
               Else                                 au_dw.SetItem (row, ls_ColumnName, null_s)
         END CHOOSE
      End IF
   LOOP
   RETURN 0
End IF

IF data=is_ReturnValue And ls_Column=is_SearchColumn And li_Seq=ii_CodeSeq And UpperBound (codesearch_select_data)>0 Then  // Code Search Window에서 선택된 row로 처리
   //gw_mdi.setmicrohelp ('코드찾기 Window 선택 사용('+ ls_Column + ',' + string (li_Seq) + '=' + data + ')')
   au_dw.SetItem (row, 'xx_' + name, codesearch_select_data [2]) ; li_COL = 2
   DO WHILE f_notnull (ls_ReturnColumn)
      li_COL ++
      ls_ColumnName = f_get_Token (ls_ReturnColumn, ',')
      IF MidA (ls_ColumnName,1,1)='^' THEN ls_ColumnName = ls_ColumnEXT + MidA (ls_ColumnName,2) &
      Else                                 ls_ColumnName = 'xx_' + ls_ColumnEXT + ls_ColumnName
      IF au_dw.describe (ls_ColumnName+'.type')='column' Then
         ls_type = au_dw.describe (ls_ColumnName+".ColType")
         CHOOSE CASE ls_type
            CASE 'date'
               au_dw.SetItem (row, ls_ColumnName, date (MidA (string (codesearch_select_data [li_COL]),1,10)))
            CASE 'datetime'
               au_dw.SetItem (row, ls_ColumnName, datetime (date (MidA (string (codesearch_select_data [li_COL]),1,10))))
            CASE 'int', 'long', 'number', 'real', 'ulong'
               au_dw.SetItem (row, ls_ColumnName, dec (codesearch_select_data [li_COL]))
            CASE Else
               IF MidA (ls_Type,1,7)='decimal' THEN au_dw.SetItem (row, ls_ColumnName, dec (codesearch_select_data [li_COL])) &
               Else                                 au_dw.SetItem (row, ls_ColumnName, codesearch_select_data [li_COL])
         END CHOOSE
      End IF
   LOOP
   RETURN 0
End IF
ls_Tag = f_nvl (au_dw.describe (name+'.tag'),'')

IF f_null (ls_SQLSelect)   Then
   f_messageBox ('ERR', ls_Column + string (li_Seq,'(##)') + ' 코드찾기 선택오류 ?????~r~n~r~n마우스 우측버튼으로만 선택할 수 있습니다.')
   RETURN 1
End IF

// Where 처리
IF f_notnull (ls_Where) Then
   IF PosA (lower (ls_SQLSelect), 'where')>0 THEN ls_SQLSelect = ls_SQLSelect + '~r~nAnd ' + ls_Where &
   Else                                           ls_SQLSelect = ls_SQLSelect + '~r~nWhere ' + ls_Where
End IF
ls_SQLSelect = f_replace (ls_SQLSelect, ':corp_gr', as_corp_gr)

ll_ret = SQLCA.sql2ds (this.classname(), ls_SQLSelect, lds_getCode, 'xml')

IF ll_Ret=1 Then
   au_dw.SetItem (row, 'xx_' + name, lds_getCode.getitemString(1, 1))
   DO WHILE f_notnull (ls_ReturnColumn)
      li_COL ++
      ls_ColumnName = f_get_Token (ls_ReturnColumn, ',')
      IF MidA (ls_ColumnName,1,1)='^' THEN ls_ColumnName = ls_ColumnEXT + MidA (ls_ColumnName,2) &
      Else                                 ls_ColumnName = 'xx_' + ls_ColumnEXT + ls_ColumnName
      IF au_dw.describe (ls_ColumnName+'.type')='column' Then
         ls_type = au_dw.describe (ls_ColumnName+".ColType")
         CHOOSE CASE ls_type
            CASE 'date'
               au_dw.SetItem (row, ls_ColumnName, date (MidA (string (lds_getCode.getitemString (1, li_COL)),1,10)))
            CASE 'datetime'
               au_dw.SetItem (row, ls_ColumnName, datetime (date (MidA (string (lds_getCode.getitemString (1, li_COL)),1,10))))
            CASE 'int', 'long', 'number', 'real', 'ulong'
               au_dw.SetItem (row, ls_ColumnName, dec (lds_getCode.getitemString (1, li_COL)))
            CASE Else
               IF MidA (ls_Type,1,7)='decimal' THEN au_dw.SetItem (row, ls_ColumnName, dec (lds_getCode.getitemString (1, li_COL))) &
               Else                                 au_dw.SetItem (row, ls_ColumnName, lds_getCode.getitemString (1, li_COL))
         END CHOOSE
      End IF
   LOOP
   RETURN 0
Else
   ls_tag = f_nvl (ls_Tag,ls_column + string (li_Seq,'(##)')) + ' 코드찾기 오류~r~n~r~n'
   IF ll_Ret>1 Then
      f_messageBox ('ERR', ls_tag + ls_Syntax + '~r~n' + data + ' 코드명이 하나이상 조회되었습니다.~r~n조건을 확인하여 주십시요!')
   Else
      f_messageBox ('ERR', ls_Tag + '등록되어 있지 않은 코드값(' + data + ')입니다')
   End IF
   au_dw.SetItem (row, name, item_before_primary)
End IF

RETURN 1
end event

on u_dynamiccodesearch.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_dynamiccodesearch.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

