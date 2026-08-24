forward
global type fw_n_dso from ads_jtier
end type
end forward

global type fw_n_dso from ads_jtier
event type boolean oue_components ( )
end type
global fw_n_dso fw_n_dso

type variables
private:
	transaction itr_trans

public:
	// restroed dberror information
	fw_s_dberror istr_dberror
	
	long HeaderBandColor	= 536870912
	long DetailBandColor	= 536870912

end variables

forward prototypes
public function string of_thisname ()
public function integer settransobject (transaction t)
public function transaction gettransobject ()
public function string of_getevaluate (string as_expression, long al_row)
public function long of_retrievefromsql (string as_query)
public function integer of_createfromsql (string as_query)
public function integer of_addsearchcriteria ()
end prototypes

event type boolean oue_components();Return True
end event

public function string of_thisname ();return 'fw_n_dso'

end function

public function integer settransobject (transaction t);this.itr_trans = t
return super::settransobject(t)

end function

public function transaction gettransobject ();return itr_trans

end function

public function string of_getevaluate (string as_expression, long al_row);String		ls_temp
String		ls_data
Long		ll_row

IF al_row = 0 THEN
	ls_temp = "summary"
	ll_row = 1
ELSE
	ls_temp = "detail"
	ll_row = al_row
END IF

ls_temp = 'compute(band=' + ls_temp + ' alignment="0" expression="0" border="0" color="33554432" x="1371" y="4" height="50" width="544" format="[GENERAL]" html.valueishtml="0"  name=compute_evaluate_lookupdisplay visible="0"  font.face="Arial" font.height="-12" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="1073741824" )'
ls_temp = This.Modify("create " + ls_temp)
IF ls_temp = '?' THEN
	Messagebox("Info", "Create Evaluate Failed")
	Return ''
END IF

ls_temp = This.Modify('compute_evaluate_lookupdisplay.expression="' + as_expression + '"')
IF ls_temp = '?' THEN
	messagebox("Error", "Modify LookupDisplay Failed")
	Return ""
END IF

IF This.Rowcount() > 0 THEN ls_data = This.GetItemString(ll_row, 'compute_Evaluate_lookupdisplay')

ls_temp = This.Modify("destroy compute_Evaluate_lookupdisplay")
IF ls_temp = '?' THEN
	Messagebox("Info", "Destroy Evaluate Failed")
	Return ''
END IF

return ls_data
end function

public function long of_retrievefromsql (string as_query);// 주어진 쿼리문으로 데이터 오브젝트를 만들어
// 동적으로 데이터를 조회합니다. 

MessageBox( "jtier-확인(of_createfromsql)", "[" + parent.classname() +"] [이 함수를 호출하는 속 수정 해야 함.]" )
// SQLCA.sql2ds( /*powerobject apo*/, /*string sql*/, /*ref ads_jtier ads */)
return -1
end function

public function integer of_createfromsql (string as_query);MessageBox( "jtier-확인(of_createfromsql)", "[" + parent.classname() +"] [이 함수를 호출하는 속 수정 해야 함.]" )
// SQLCA.sql2ds( /*powerobject apo*/, /*string sql*/, /*ref ads_jtier ads */)
return -1
end function

public function integer of_addsearchcriteria ();// WHERE 절에 조건을 추가합니다(작업중, 사용하지 마세요)

pf_n_regexp lnv_regexp
string ls_query, ls_objref[]
long ll_refcnt, i

ls_query = this.GetSqlSelect()
messagebox("ls_query", ls_query)

lnv_regexp = create pf_n_regexp
ll_refcnt = lnv_regexp.of_findmatches(ls_query, "(\w+\.\w+(\[\d+\])?)", ls_objref[])

for i = 1 to ll_refcnt
	messagebox(string(i), ls_objref[i])
next

return 0

end function

on fw_n_dso.create
call super::create
end on

on fw_n_dso.destroy
call super::destroy
end on

