forward
global type pf_n_regexp from n_ancestor
end type
end forward

global type pf_n_regexp from n_ancestor
end type
global pf_n_regexp pf_n_regexp

type variables
// Properties of VBScript.RegExp (MSDN) -> https://msdn.microsoft.com/en-us/library/1400241x%28VS.85%29.aspx
//    Pattern - A string that is used to define the regular expression. This must be set before use of the regular expression object. Patterns are described in more detail below.
//    IgnoreCase - A Boolean property that indicates if the regular expression should be tested against all possible matches in a string. By default, IgnoreCase is set to False.
//    Global - A Boolean property that indicates if the regular expression should be tested against all possible matches in a string. By default, Global is set to False.
//    Test (string) - The Test method takes a string as its argument and returns True if the regular expression can successfully be matched against the string, otherwise False is returned.
//    Replace (search-string, replace-string) - The Replace method takes 2 strings as its arguments. If it is able to successfully match the regular expression in the search-string, then it replaces that match with the replace-string, and the new string is returned. If no matches were found, then the original search-string is returned.
//    Execute (search-string) - The Execute method works like Replace, except that it returns a Matches collection object, containing a Match object for each successful match. It doesn't modify the original string.

private:
	OLEObject iole_regexp
	OLEObject iole_matches

public:
	boolean ib_global = false
	boolean ib_ignorecase = false
	string is_pattern

	integer ii_matchcnt
	integer ii_matchpos[]
	string is_matchestr[]

end variables

forward prototypes
public function string of_thisname ()
public function boolean of_validate_ishangul (string as_value)
public function boolean of_validate_phonenumber (string as_value)
public function boolean of_validate_email (string as_value)
public function boolean of_validate_url (string as_value)
public function string of_replace (string as_searchstr, string as_pattern, string as_newstr)
public function string of_replaceall (string as_searchstr, string as_pattern, string as_newstr)
public function integer of_findmatches (string as_searchstr, string as_pattern, ref string as_result[])
public function boolean of_test (string as_teststr, string as_pattern)
public subroutine of_initialize (boolean ab_ignorecase, boolean ab_global)
public subroutine of_initialize (boolean ab_ignorecase, boolean ab_global, string as_pattern)
public function integer of_findmatches (string as_searchstr)
public subroutine of_setpattern (string as_pattern)
public function string of_getmatchstr (integer ai_index)
public function integer of_getmatchpos (integer ai_index)
public subroutine of_setignorecase (boolean ab_switch)
public subroutine of_setglobal (boolean ab_switch)
public function boolean of_test (string as_teststr)
public function integer of_findmatches (string as_searchstr, ref string as_result[])
public function string of_replace (string as_searchstr, string as_newstr)
public function string of_replaceall (string as_searchstr, string as_newstr)
end prototypes

public function string of_thisname ();return "pf_n_regexp"

end function

public function boolean of_validate_ishangul (string as_value);/************************************************
DESCRIPTION: 한글이 포함된 문자열인지 확인합니다

 PARAMETERS:
   as_value - String to be tested for validity

RETURNS:
   True if valid, otherwise false.

REMARKS: 
*************************************************/

iole_regexp.Pattern = "[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]"

// 한글로만 구성된 문자열을 확인할 경우 아래 패턴 사용
//iole_regexp.Pattern = "^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]+$"

iole_regexp.IgnoreCase = false
iole_regexp.Global = false

return iole_regexp.Test(as_value)

end function

public function boolean of_validate_phonenumber (string as_value);/************************************************
DESCRIPTION: 전화번호 패턴을 비교합니다
  Phone Number pattern.
  Ex. (999) 999-9999 or (999)999-9999

PARAMETERS:
   as_value - String to be tested for validity

RETURNS:
   True if valid, otherwise false.
*************************************************/

// (02) 769-9795 형태의 전화번호 패턴
iole_regexp.Pattern = "^\(\d{2,3}\)\s?\d{3,4}-\d{4}$"

// 02-769-9795 형태의 전화 번호 패턴
//iole_regexp.Pattern = "^\d{2,3}-\d{3,4}-\d{4}$"

iole_regexp.IgnoreCase = false
iole_regexp.Global = false

return iole_regexp.Test(as_value)

end function

public function boolean of_validate_email (string as_value);/************************************************
DESCRIPTION: E-Mail 패턴을 확인합니다

 PARAMETERS:
   as_value - String to be tested for validity

RETURNS:
   True if valid, otherwise false.

REMARKS: Accounts for email with country appended does not validate
  that email contains valid URL type (.com, .gov, etc.) or valid country suffix.
*************************************************/

iole_regexp.Pattern = "^[A-Za-z0-9._-]+@[[A-Za-z0-9.-]+$"
iole_regexp.IgnoreCase = false
iole_regexp.Global = false

return iole_regexp.Test(as_value)

end function

public function boolean of_validate_url (string as_value);/************************************************
DESCRIPTION: URL 패턴을 비교합니다
  Ex. http://www.naver.com/mail.php

 PARAMETERS:
   as_value - String to be tested for validity

RETURNS:
   True if valid, otherwise false.

REMARKS: 
*************************************************/

iole_regexp.Pattern = "^(https?:\/\/[a-z0-9\-]+\.[a-z0-9\-\.]+(?:\/|(?:\/[a-zA-Z0-9!#\$%&'\*\+,\-\.:;=\?@\[\]_~]+)*))$"
iole_regexp.IgnoreCase = true
iole_regexp.Global = false

return iole_regexp.Test(as_value)

end function

public function string of_replace (string as_searchstr, string as_pattern, string as_newstr);///************************************************
//DESCRIPTION: 일치하는 패턴을 검색후 해당 문자열을 Replace 합니다
//
// PARAMETERS:
//   as_searchstr - String to be tested for validity
//   as_pattern - Search pattern
//   as_newstr - New string for matched string
//
//RETURNS:
//   치환된 문자열
//
//REMARKS: New String 은 아래와 같은 형태로 사용 가능 합니다.
//  "($1) $2-$3"
//*************************************************/
string ls_result

iole_regexp.Pattern = as_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = false

ls_result = iole_regexp.replace(as_searchstr, as_newstr)
return ls_result

end function

public function string of_replaceall (string as_searchstr, string as_pattern, string as_newstr);///************************************************
//DESCRIPTION: 일치하는 패턴을 모두 검색후 해당 문자열을 모두 Replace 합니다
//
// PARAMETERS:
//   as_searchstr - String to be tested for validity
//   as_pattern - Search pattern
//   as_newstr - New string for matched string
//
//RETURNS:
//   치환된 문자열
//
//REMARKS: New String 은 아래와 같은 형태로 사용 가능 합니다.
//  "($1) $2-$3"
//*************************************************/
string ls_result

iole_regexp.Pattern = as_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = true

ls_result = iole_regexp.replace(as_searchstr, as_newstr)
return ls_result

end function

public function integer of_findmatches (string as_searchstr, string as_pattern, ref string as_result[]);///************************************************
//DESCRIPTION: 일치하는 패턴을 검색후 해당 문자열을 구해옵니다.
//
// PARAMETERS:
//   as_searchstr - String to be tested for matching
//   as_pattern - Search pattern
//   as_result - String array to be returned
//
//RETURNS:
//   검색된 문자열 갯수
//
//REMARKS: 
//*************************************************/
integer i, li_matchcnt
string ls_empty[]

as_result[] = ls_empty[]

if isvalid(iole_matches) then
	destroy iole_matches
end if

iole_regexp.Pattern = as_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = ib_global

// execute() returns a Matches collection object
iole_matches = iole_regexp.execute(as_searchstr)
if not isvalid(iole_matches) then return -1

li_matchcnt = iole_matches.Count
for i = 1 to li_matchcnt
	as_result[i] = string(iole_matches.Item(i - 1).Value)
next

return li_matchcnt

end function

public function boolean of_test (string as_teststr, string as_pattern);/************************************************
DESCRIPTION: 패턴을 확인합니다

 PARAMETERS:
   as_value - String to be tested for validity

RETURNS:
   True if valid, otherwise false.

REMARKS: 
*************************************************/

iole_regexp.Pattern = as_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = ib_global

return iole_regexp.Test(as_teststr)

end function

public subroutine of_initialize (boolean ab_ignorecase, boolean ab_global);// Regular Expression 서비스를 초기화 합니다
// ab_ignorecase : true=정규식 검색 시 대/소문자 구분을 무시합니다, false=정규식 검색 시 대/소문자 구분
// ab_global : true=정규식 검색대상을 전체 문자열로 지정, false=정규식 검색대상을 최초 검색에 한정

ib_ignorecase = ab_ignorecase
ib_global = ab_global

end subroutine

public subroutine of_initialize (boolean ab_ignorecase, boolean ab_global, string as_pattern);// Regular Expression 서비스를 초기화 합니다
// ab_ignorecase : true=정규식 검색 시 대/소문자 구분을 무시합니다, false=정규식 검색 시 대/소문자 구분
// ab_global : true=정규식 검색대상을 전체 문자열로 지정, false=정규식 검색대상을 최초 검색에 한정
// as_pattern : 문자열을 검색할 정규표현식

ib_ignorecase = ab_ignorecase
ib_global = ab_global
is_pattern = as_pattern

end subroutine

public function integer of_findmatches (string as_searchstr);///************************************************
//DESCRIPTION: 일치하는 패턴을 검색후 해당 문자열을 구해옵니다.
//
// PARAMETERS:
//   as_searchstr - String to be tested for matching
//
//RETURNS:
//   검색된 문자열 갯수
//
//REMARKS: 
//*************************************************/
integer i
string ls_empty[]

is_matchestr[] = ls_empty[]

if isvalid(iole_matches) then
	destroy iole_matches
end if

iole_regexp.Pattern = is_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = ib_global

// execute() returns a Matches collection object
iole_matches = iole_regexp.execute(as_searchstr)
if not isvalid(iole_matches) then return -1

ii_matchcnt = iole_matches.Count
for i = 1 to ii_matchcnt
	is_matchestr[i] = string(iole_matches.Item(i - 1).Value)
	ii_matchpos[i] = integer(iole_matches.Item(i - 1).FirstIndex)
next

return ii_matchcnt

end function

public subroutine of_setpattern (string as_pattern);is_pattern = as_pattern

end subroutine

public function string of_getmatchstr (integer ai_index);if ai_index < 1 or ai_index > ii_matchcnt then
	messagebox('Notice', '정규식 검색결과를  넘어선 수치입니다')
	return ''
end if

return is_matchestr[ai_index]

end function

public function integer of_getmatchpos (integer ai_index);if ai_index < 1 or ai_index > ii_matchcnt then
	messagebox('Notice', '정규식 검색결과를  넘어선 수치입니다')
	return -1
end if

return ii_matchpos[ai_index]

end function

public subroutine of_setignorecase (boolean ab_switch);ib_ignorecase = ab_switch

end subroutine

public subroutine of_setglobal (boolean ab_switch);ib_global = ab_switch

end subroutine

public function boolean of_test (string as_teststr);/************************************************
DESCRIPTION: 패턴을 확인합니다

 PARAMETERS:
   as_value - String to be tested for validity

RETURNS:
   True if valid, otherwise false.

REMARKS: 
*************************************************/

iole_regexp.Pattern = is_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = ib_global

return iole_regexp.Test(as_teststr)

end function

public function integer of_findmatches (string as_searchstr, ref string as_result[]);///************************************************
//DESCRIPTION: 일치하는 패턴을 검색후 해당 문자열을 구해옵니다.
//
// PARAMETERS:
//   as_searchstr - String to be tested for matching
//   as_result - String array to be returned
//
//RETURNS:
//   검색된 문자열 갯수
//
//REMARKS: 
//*************************************************/
integer i, li_matchcnt
string ls_empty[]

as_result[] = ls_empty[]

if isvalid(iole_matches) then
	destroy iole_matches
end if

iole_regexp.Pattern = is_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = ib_global

// execute() returns a Matches collection object
iole_matches = iole_regexp.execute(as_searchstr)
if not isvalid(iole_matches) then return -1

li_matchcnt = iole_matches.Count
for i = 1 to li_matchcnt
	as_result[i] = string(iole_matches.Item(i - 1).Value)
next

return li_matchcnt

end function

public function string of_replace (string as_searchstr, string as_newstr);///************************************************
//DESCRIPTION: 일치하는 패턴을 검색후 해당 문자열을 Replace 합니다
//
// PARAMETERS:
//   as_searchstr - String to be tested for validity
//   as_pattern - Search pattern
//   as_newstr - New string for matched string
//
//RETURNS:
//   치환된 문자열
//
//REMARKS: New String 은 아래와 같은 형태로 사용 가능 합니다.
//  "($1) $2-$3"
//*************************************************/
string ls_result

iole_regexp.Pattern = is_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = false

ls_result = iole_regexp.replace(as_searchstr, as_newstr)
return ls_result

end function

public function string of_replaceall (string as_searchstr, string as_newstr);///************************************************
//DESCRIPTION: 일치하는 패턴을 모두 검색후 해당 문자열을 모두 Replace 합니다
//
// PARAMETERS:
//   as_searchstr - String to be tested for validity
//   as_pattern - Search pattern
//   as_newstr - New string for matched string
//
//RETURNS:
//   치환된 문자열
//
//REMARKS: New String 은 아래와 같은 형태로 사용 가능 합니다.
//  "($1) $2-$3"
//*************************************************/
string ls_result

iole_regexp.Pattern = is_pattern
iole_regexp.IgnoreCase = ib_ignorecase
iole_regexp.Global = true

ls_result = iole_regexp.replace(as_searchstr, as_newstr)
return ls_result

end function

on pf_n_regexp.create
call super::create
end on

on pf_n_regexp.destroy
call super::destroy
end on

event constructor;call super::constructor;integer li_retval

iole_regexp = Create OLEObject
li_retval = iole_regexp.ConnectToNewObject("VBScript.RegExp")
if li_retval < 0 then
	choose case li_retval
		case -1;  messagebox("Creating RegExp Failure!", "Invalid Call: the argument is the Object property of a control")
		case -2;  messagebox("Creating RegExp Failure!", "Class name not found")
		case -3;  messagebox("Creating RegExp Failure!", "Object could not be created")
		case -4;  messagebox("Creating RegExp Failure!", "Could not connect to object")
		case -9;  messagebox("Creating RegExp Failure!", "Other error")
		case -15;  messagebox("Creating RegExp Failure!", "COM+ is not loaded on this computer")
		case -16;  messagebox("Creating RegExp Failure!", "Invalid Call: this function not applicable")
		case else; messagebox("Creating RegExp Failure!", "Unknown Error")
	end choose
end if

end event

event destructor;call super::destructor;if isvalid(iole_matches) then destroy iole_matches

if isvalid(iole_regexp) then
	iole_regexp.disconnectobject()
	destroy iole_regexp
end if

end event

