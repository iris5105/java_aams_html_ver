forward
global type ez_n_http from nonvisualobject
end type
end forward

global type ez_n_http from nonvisualobject
end type
global ez_n_http ez_n_http

type prototypes

end prototypes

type variables
constant integer HTTP_OK = 0
constant integer TYPE_FILE = 1
constant integer TYPE_PARAM = 0
constant int HTTPINFO_SPEED_DOWNLOAD = 209
constant int HTTPINFO_RESPONSE_CODE = 100

ez_w_http_up_state	iw_up_state
ez_w_http_dn_state	iw_dn_state

datastore	ids_httpcode

public:
	string		is_upload_url = ''
	string		is_down_url= ''
	uint		timeout = 3
end variables

forward prototypes
public function boolean of_http_ping (string as_url, unsignedinteger aui_timeout)
public function boolean of_http_ping (string as_url)
public subroutine of_settimeout (unsignedinteger aui_timeout)
public function string of_http_desc (integer ai_httpcode)
public function string of_http_msg (integer ai_httpcode)
public function string of_definename ()
public function string of_temp_history (string as_text)
public function integer of_http_dn (string as_file[], long al_filesize[], string as_dnpath[], string as_svrpath[], string as_down_url)
public function integer of_http_dn (string as_file[], long al_filesize[], string as_dnpath[], string as_svrpath[])
public function integer of_http_dn (string as_file, long al_filesize, string as_dnpath, ref string as_svrpath)
public function integer of_http_up (string as_file, string as_svrpath, boolean ab_overwrite, boolean ab_visible)
public function integer of_http_up (string as_file[], string as_svrpath, boolean ab_overwrite, boolean ab_visible)
public function integer of_http_up (string as_file[], string as_svrpath, string as_upload_url, boolean ab_overwrite, boolean ab_visible)
end prototypes

public function boolean of_http_ping (string as_url, unsignedinteger aui_timeout);// as_url 이 유효한지 검사합니다
// as_url : 테스트할 URL 주소
boolean lb_rv

if isnull(as_url) or len(trim(as_url)) = 0 then
	messagebox('of_http_ping 알림', 'URL 정보가 없습니다')
	return false
end if

//timeout 초가 설정되지 않은 경우 기본 5초 설정
if aui_timeout <= 0  then aui_timeout = timeout

lb_rv = gnv_extfunc.ez_http_ping(as_url, aui_timeout)
return lb_rv

end function

public function boolean of_http_ping (string as_url);// as_url 이 유효한지 검사합니다
// as_url : 테스트할 URL 주소

uint lui_timeout

lui_timeout = timeout
return this.of_http_ping(as_url, lui_timeout)

end function

public subroutine of_settimeout (unsignedinteger aui_timeout);timeout = aui_timeout

end subroutine

public function string of_http_desc (integer ai_httpcode);// HTTPCODE에 해당하는 상세 에러 메시지를 리턴합니다.

long ll_find
string ls_errmsg

ll_find = ids_httpcode.find("httpcode='" + string(ai_httpcode) + "'", 1, ids_httpcode.rowcount())
if ll_find > 0 then
	ls_errmsg = ids_httpcode.getitemstring(ll_find, 'httpcode_desc')
end if

return ls_errmsg

end function

public function string of_http_msg (integer ai_httpcode);// HTTPCODE에 해당하는 에러 메시지를 리턴합니다.

long ll_find
string ls_errmsg

ll_find = ids_httpcode.find("httpcode='" + string(ai_httpcode) + "'", 1, ids_httpcode.rowcount())
if ll_find > 0 then
	ls_errmsg = ids_httpcode.getitemstring(ll_find, 'httpcode_mesg')
end if

return ls_errmsg

end function

public function string of_definename ();return 'ez_n_http'
end function

public function string of_temp_history (string as_text);OleObject lo_ole
Integer  li_rc
string ls_temp

lo_ole = create OleObject
li_rc = lo_ole.ConnectToNewObject( "MSScriptControl.ScriptControl" )
lo_ole.language = "javascript"

as_text = fw_f_replaceall(as_text, "'", "\'")
ls_temp = lo_ole.Eval("encodeURIComponent('" + as_text + "')")

destroy lo_ole
return ls_temp

end function

public function integer of_http_dn (string as_file[], long al_filesize[], string as_dnpath[], string as_svrpath[], string as_down_url);string	ls_filepath, ls_urlencodefilenm, ls_urlsvrpath, ls_error, ls_temp
long	ll_i, ll_rcnt
integer	li_rc, li_running, i, li_filecnt

li_filecnt = upperbound(as_file)
if li_filecnt = 0 then
	messagebox('check', 'file does not exist.')
	return - 1
end if

for i = 1 to li_filecnt
	if isnull(as_file[i]) or len(trim(as_file[i])) = 0 then
		messagebox('check', string(i) + 'th file name does not exist..')
		return - 1
	end if
next

// 다운로드 server parh 확인
if isnull(as_down_url) then return -1
if len(trim(as_down_url)) = 0 then
	messagebox('check', 'down url address is not defined.')
	return - 1
end if

// 다운로드 server parh 확인
ll_rcnt = upperbound(as_svrpath)
for ll_i = 1 to ll_rcnt
	if isnull(as_svrpath[ll_i]) then return -1
	if len(trim(as_svrpath[ll_i])) = 0 then
		messagebox('check', string(ll_i) + '번째 다운로드 server parh가 설정되지 않았습니다.')
		return - 1
	end if
next

// downloadpath 가 미설정된 경우 사용자 설정 처리
ll_rcnt = upperbound(as_dnpath)
for ll_i = 1 to ll_rcnt
	if isnull(as_dnpath[ll_i]) or len(trim(as_dnpath[ll_i])) = 0 then
		if getfolder(string(ll_i) + 'select a folder to save the attachment', as_dnpath[ll_i]) < 1 then return 0
	end if
next

// 다운로드 상태창 오픈
open(iw_dn_state)
iw_dn_state.cb_close.text = 'Cancel'
iw_dn_state.st_msg.text = '다운로드 초기화 중...'

// 다운로드 초기화
double ld_dltotal, ld_dlnow
double ld_dltotal_bef, ld_dlnow_bef
double ld_bytespersec
long ll_total_sum, ll_recv_sum
integer li_percent, li_percent_bef

iw_dn_state.st_msg.text = '파일 다운로드 중...'

long ll_new, ll_lastpos
string ls_extension
string ls_fileext

// 다운로드할 파일 dw 표시
iw_dn_state.dw_list.reset()
for i = 1 to li_filecnt	
//	// 파일명 일련번호 제거
//	ls_filepath = as_file[i]
//	ll_lastpos = lastpos(ls_filepath, '.')
//	if ll_lastpos > 0 then
//		ls_fileext = mid(ls_filepath, ll_lastpos + 1)
//		if isnumber(ls_fileext) then
//			ls_filepath = mid(ls_filepath, 1, ll_lastpos - 1)
//		end if
//	end if
	
// e-결재시 무시 무조건 엎어쓰기 // 기 존재하는 파일 확인
//	if fileexists(as_dnpath + '\' + ls_filepath) then
//		li_rc = messagebox('check', '[' + as_dnpath + '\' + ls_filepath + ']~r~n다운로드 받을 파일이 이미 존재합니다.~r~n해당 파일을 덮어쓰기 하시겠습니까?', Question!, YesNoCancel!, 2)
//		choose case li_rc
//			case 2
//				continue
//			case 3
//				close(iw_dn_state)
//				return -1
//		end choose
//	end if

	ll_new = iw_dn_state.dw_list.insertrow(0)
	iw_dn_state.dw_list.setitem(ll_new, 'filepath', as_dnpath[i])
	iw_dn_state.dw_list.setitem(ll_new, 'filename', as_file[i])
	iw_dn_state.dw_list.setitem(ll_new, 'filesize', al_filesize[i])
next

//for i = 1 to upperbound(as_file)
//	iw_dn_state.dw_list.scrolltorow(i)
//	iw_dn_state.dw_list.setrow(i)
//	
//	ls_filepath = as_dnpath + '\' + iw_dn_state.dw_list.getitemstring(i, 'ls_filename') //as_file[i]
//	ls_filename = as_file[i]
//	
//	if gnv_extfunc.ez_http_opendownload(as_down_url, ls_filepath) = -1 then
//		return -1
//	end if

// HTTP 모듈 초기화
gnv_extfunc.ez_http_globaldefault()

gnv_extfunc.ez_http_addhttpheader("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; InfoPath.2; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)")
//gnv_extfunc.ez_http_addhttpheader("Content-Type: application/x-www-form-urlencoded")
//gnv_extfunc.ez_http_addhttpheader("Content-Type: application/json")
// 파일 다운로드
for i = 1 to li_filecnt
	yield( )
	iw_dn_state.dw_list.scrolltorow(i)
	iw_dn_state.dw_list.setrow(i)
	iw_dn_state.dw_list.selectrow(i, true)
	if i > 1 then iw_dn_state.dw_list.selectrow(i -1, false)
	yield( )
	
	ls_filepath = iw_dn_state.dw_list.getitemstring(i, 'filepath')
	
	// 다운로드 URL 및 로컬 파일경로 설정 e-결재 수정 to-be
	if gnv_extfunc.ez_http_opendownload(as_down_url, ls_filepath) = -1 then
		gnv_extfunc.ez_http_close()
		gnv_extfunc.ez_http_globalcleanup()
		return -1
//		messagebox('check', 'ez_http_opendownload() 호출 오류 입니다~r~nas_down_url=' + string(as_down_url) + ', as_dnpath=' + string(ls_filepath))
//		return -1
	end if
	
	// 수신 파일명 및 서브 경로 설정
	ls_urlencodefilenm = gnv_extfunc.ez_urlencode_component(as_file[i])
	ls_urlencodefilenm = gnv_extfunc.ez_urlencode_component(ls_urlencodefilenm)
	ls_urlsvrpath = gnv_extfunc.ez_urlencode_component(as_svrpath[i])
	gnv_extfunc.ez_http_setpostfields("filename=" + ls_urlencodefilenm + "&subdir=" + ls_urlsvrpath)
	if gnv_extfunc.ez_http_send() <> 1 then
		gnv_extfunc.ez_http_globalcleanup()
		messagebox('check', 'ez_http_send() 호출 오류 입니다')
		return -1
	end if
	
	// 진행상태 점검
	li_running = gnv_extfunc.ez_http_checkrunningstatus()
	do while li_running = 1
		yield( )
		ld_dlnow = gnv_extfunc.ez_http_downloadprogress_now()
		ld_dltotal = gnv_extfunc.ez_http_downloadprogress_total()
		
		if ld_dltotal <> ld_dltotal_bef then
			iw_dn_state.st_total.text = string(ld_dltotal, '#,##0')
			iw_dn_state.st_total_sum.text = string(ll_recv_sum + ld_dltotal, '#,##0')
			ld_dltotal_bef = ld_dltotal
		end if	
		
		if ld_dlnow <> ld_dlnow_bef then
			iw_dn_state.st_size.text = string(ld_dlnow, '#,##0')
			iw_dn_state.st_size_sum.text = string(ll_recv_sum + ld_dlnow, '#,##0')
			ld_dlnow_bef = ld_dlnow
		end if
		
		if ld_dlnow > 0 then
			li_percent = int((ld_dlnow / ld_dltotal) * 100)
			if li_percent <> li_percent_bef then
				iw_dn_state.hpb_file.position = li_percent
				li_percent_bef = li_percent
			end if
		end if
		
		// 다운로드 취소 확인
		if iw_dn_state.ib_cancel = true then
			gnv_extfunc.ez_http_abort()
			gnv_extfunc.ez_http_globalcleanup()
			exit
		end if
		
		li_running = gnv_extfunc.ez_http_checkrunningstatus()
	loop
	
	// 결과코드 처리
	li_rc = gnv_extfunc.ez_http_getresultcode()
	if li_rc <> HTTP_OK then
		ls_error = gnv_extfunc.ez_http_geterrormessage(li_rc)
		gnv_extfunc.ez_http_close()
		gnv_extfunc.ez_http_globalcleanup()
		messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
		close(iw_dn_state)
		return -1
	end if
	
	// 마지막 진행상황 처리
	ld_dlnow = gnv_extfunc.ez_http_downloadprogress_now()
	if ld_dltotal > 0 then li_percent = int((ld_dlnow / ld_dltotal) * 100)
	iw_dn_state.st_size.text = string(ld_dlnow, '#,##0')
	iw_dn_state.st_size_sum.text = string(ll_recv_sum + ld_dlnow, '#,##0')
	iw_dn_state.hpb_file.position = li_percent
	iw_dn_state.hpb_total.position = li_percent
	ll_recv_sum += ld_dltotal
	
	// 다운로드 전송 속도
	//ld_bytespersec = gnv_extfunc.ez_http_getinfo_double(HTTPINFO_SPEED_DOWNLOAD)
	//iw_dn_state.st_msg.text = string(ld_bytespersec / 1000, '#,##0') + ' Kbytes/sec'
	
	// HTTP Code 확인
	long ll_httpcode
	string ls_httpmesg
	ll_httpcode = gnv_extfunc.ez_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
	if ll_httpcode >= 300 then
		ls_httpmesg = '파일 다운로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
		this.of_http_msg(ll_httpcode) + '~r~nHttp Description: ' + this.of_http_desc(ll_httpcode)
		gnv_extfunc.ez_http_close()
		gnv_extfunc.ez_http_globalcleanup()
		messagebox('파일 다운로드 오류', ls_httpmesg)
		close(iw_dn_state)
		return -1
	end if

	// HTTP 전송 종료
	gnv_extfunc.ez_http_close()	
	ez_f_delaytime(5)
next

iw_dn_state.cb_close.text = 'Close'
gnv_extfunc.ez_http_globalcleanup()

// 결과 메시지 표시
if len(ls_httpmesg) > 0 then
	li_rc = -1
	iw_dn_state.st_msg.text = 'file transfer error!'
elseif iw_dn_state.ib_cancel = true then
	li_rc = -1
	iw_dn_state.st_msg.text = 'cancel transfer'
else
	iw_dn_state.st_msg.text = 'completion!'
end if

close(iw_dn_state)
return li_rc
return 1
end function

public function integer of_http_dn (string as_file[], long al_filesize[], string as_dnpath[], string as_svrpath[]);long	ll_rtn

ll_rtn =  this.of_http_dn(as_file, al_filesize, as_dnpath, as_svrpath, is_down_url)
return ll_rtn

end function

public function integer of_http_dn (string as_file, long al_filesize, string as_dnpath, ref string as_svrpath);string	ls_file[], ls_dnpath[], ls_srvpath[]
long	ll_filesize[], ll_rtn

ls_file[1] = as_file
ls_dnpath[1] = as_dnpath
ls_srvpath[1] = as_svrpath
ll_filesize[1] = al_filesize
ll_rtn =  this.of_http_dn(ls_file, ll_filesize, ls_dnpath, ls_srvpath, is_down_url)
return ll_rtn

end function

public function integer of_http_up (string as_file, string as_svrpath, boolean ab_overwrite, boolean ab_visible);string	ls_file[]
integer	li_rc

ls_file[1] = as_file
li_rc =  this.of_http_up(ls_file, as_svrpath, is_upload_url, ab_overwrite, ab_visible)

return li_rc

end function

public function integer of_http_up (string as_file[], string as_svrpath, boolean ab_overwrite, boolean ab_visible);return this.of_http_up(as_file, as_svrpath, is_upload_url, ab_overwrite, ab_visible)

end function

public function integer of_http_up (string as_file[], string as_svrpath, string as_upload_url, boolean ab_overwrite, boolean ab_visible);string	ls_filepath, ls_filenm
string	ls_error, ls_temp
integer	li_rc, li_running, li_rtn

string	ls_resptext, ls_uploadedfile, ls_httpmesg
double	ld_ultotal, ld_ulnow, ld_ultotal_bef, ld_ulnow_bef
long	ll_httpcode
integer	li_percent, li_percent_bef

if isnull(is_upload_url) then return -1
if len(trim(is_upload_url)) = 0 then
	messagebox('check', 'server ip not conf')
	return -1
end if

if isnull(as_file) then return -1
if upperbound(as_file) = 0 then
	messagebox('check(ez_n_http)', 'no file specified to upload.')
	return - 1
end if

// 업로드 상태창 오픈
open(iw_up_state)
iw_up_state.visible = ab_visible
iw_up_state.cb_close.text = 'cancel'
iw_up_state.st_msg.text = 'Initializing...'

// 업로드할 파일 설정
long ll_new, i
long ll_filesize
long ll_total_sum, ll_sent_sum

iw_up_state.dw_list.reset()

for i = 1 to upperbound(as_file)
	ll_filesize = gnv_extfunc.ez_getfilesize(as_file[i])
	if ll_filesize = -1 then
		messagebox('check', '[' + as_file[i] + '] 파일 정보를 읽을 수 없습니다')
		close(iw_up_state)
		return -1
	end if

	ll_new = iw_up_state.dw_list.insertrow(0)
	iw_up_state.dw_list.setitem(ll_new, 'filepath', as_file[i])
	iw_up_state.dw_list.setitem(ll_new, 'filename', gnv_extfunc.of_pathstrippath(as_file[i]))
	iw_up_state.dw_list.setitem(ll_new, 'filesize', ll_filesize)
next

ll_total_sum = iw_up_state.dw_list.getitemnumber(1, 'compute_1')
iw_up_state.st_total_sum.text = string(ll_total_sum, '#,##0')

// HTTP  초기화
gnv_extfunc.ez_http_globaldefault()
iw_up_state.st_msg.text = '파일 업로드 중...'

// HTTP header 설정
//gnv_extfunc.ez_http_addhttpheader("User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705) ")
//gnv_extfunc.ez_http_addhttpheader("Content-Type: multipart/form-data; charset=euc-kr")
//gnv_extfunc.ez_http_addhttpheader("Content-Type: application/x-www-form-urlencoded")


for i = 1 to upperbound(as_file)
	iw_up_state.dw_list.scrolltorow(i)
	iw_up_state.dw_list.setrow(i)
	
	yield()
	
	ls_filepath = iw_up_state.dw_list.getitemstring(i, 'filepath')
	ls_filenm = iw_up_state.dw_list.getitemstring(i, 'filename')
	ll_filesize = iw_up_state.dw_list.getitemnumber(i, 'filesize')
	
//	gnv_extfunc.ez_http_test(handle(iw_up_state), ls_filenm, ls_temp)
//	messagebox('00', ls_temp)
//	return -1
	li_rtn = gnv_extfunc.ez_http_addformfield(TYPE_PARAM, "filename", ls_filenm)
	li_rtn = gnv_extfunc.ez_http_addformfield(TYPE_PARAM, "subdir", as_svrpath)
	if ab_overwrite = true then
		li_rtn = gnv_extfunc.ez_http_addformfield(TYPE_PARAM, "overwrite", "true")
	else
		li_rtn = gnv_extfunc.ez_http_addformfield(TYPE_PARAM, "overwrite", "false")
	end if
	li_rtn = gnv_extfunc.ez_http_addformfield(TYPE_FILE, "file1", ls_filepath)
	
	// initialize http
	if gnv_extfunc.ez_http_openupload(as_upload_url, ls_filepath) = -1 then
		close(iw_up_state)
		return -1
	end if
	
	li_running = gnv_extfunc.ez_http_send()
	do while li_running = 1
		ld_ultotal = gnv_extfunc.ez_http_uploadprogress_total()
		ld_ulnow = gnv_extfunc.ez_http_uploadprogress_now()
		
		if ld_ultotal <> ld_ultotal_bef then
			iw_up_state.st_total.text = string(ld_ultotal, '#,##0')
			ld_ultotal_bef = ld_ultotal
		end if
		
		if ld_ulnow <> ld_ulnow_bef then
			iw_up_state.st_size.text = string(ld_ulnow, '#,##0')
			iw_up_state.st_size_sum.text = string(ll_sent_sum + ld_ulnow, '#,##0')
			ld_ulnow_bef = ld_ulnow
		end if
		
		if ld_ulnow > 0 then
			li_percent = int((ld_ulnow / ld_ultotal) * 100)
			if li_percent <> li_percent_bef then
				iw_up_state.hpb_file.position = li_percent
				iw_up_state.hpb_total.position = int((ll_sent_sum + ld_ulnow) / ll_total_sum * 100)
				li_percent_bef = li_percent
			end if
		end if
		
		// Cancelling...
		if iw_up_state.ib_cancel = true then
			gnv_extfunc.ez_http_abort()
			exit
		end if

		//yield()
		li_running = gnv_extfunc.ez_http_checkrunningstatus()
	loop
	
	// check result code
	li_rc = gnv_extfunc.ez_http_getresultcode()
	if li_rc <> HTTP_OK then
		ls_error = gnv_extfunc.ez_http_geterrormessage(li_rc)
		gnv_extfunc.ez_http_close()
		gnv_extfunc.ez_http_globalcleanup()
		messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
		close(iw_up_state)
		return -1
	end if
	
	// check http code
	ll_httpcode = gnv_extfunc.ez_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
	if ll_httpcode >= 300 then
		ls_httpmesg = '파일 업로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
		this.of_http_msg(ll_httpcode) + '~r~nHttp Description: ' + this.of_http_desc(ll_httpcode)
		gnv_extfunc.ez_http_close()
		gnv_extfunc.ez_http_globalcleanup()
		messagebox('upload err', ls_httpmesg)
		close(iw_up_state)
		return -1
	end if
	
	// get response
	ls_resptext = gnv_extfunc.ez_http_getresponsefromupload()
	if left(ls_resptext, 9) = 'uploaded:' then
		ls_uploadedfile = mid(ls_resptext, 10)
		if ls_uploadedfile <> as_file[i] then
			as_file[i] = ls_uploadedfile
		end if
	end if
	
	gnv_extfunc.ez_http_close()
	
	// Check if cancel button was clicked
	if iw_up_state.ib_cancel = true then
		exit
	end if	
	ll_sent_sum += ll_filesize
	
	ez_f_delaytime(5)
next

// HTTP 모듈 클린업
gnv_extfunc.ez_http_globalcleanup()
iw_up_state.cb_close.text = 'Close'

if iw_up_state.ib_cancel = true then
	iw_up_state.st_msg.text = '파일 전송 취소!!'
	messagebox('check', '파일 전송이 취소되었습니다.')
else
	iw_up_state.st_msg.text = '파일 업로드 완료!!'
	//messagebox('check', '파일 전송이 완료되었습니다.')
end if

close(iw_up_state)
return li_rc

end function

on ez_n_http.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ez_n_http.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//is_upload_url = 'http://' + gnv_vari.SetWASSignupIP + '/ezserviceweb/FileUpload'
//is_down_url = 'http://' + gnv_vari.SetWASSignupIP + '/ezserviceweb/FileDownload'
is_upload_url = 'http://app.aams.kr:8080/ezserviceweb/FileUpload'
is_down_url = 'http://app.aams.kr:8080/ezserviceweb/FileDownload'

//is_upload_url = 'http://172.20.5.100:8080/ezserviceweb/FileUpload'
//is_down_url = 'http://172.20.5.100:8080/ezserviceweb/FileDownload'

ids_httpcode = create datastore
ids_httpcode.dataobject = 'ez_d_httpfile_1'

end event

event destructor;if isvalid(ids_httpcode) then
	destroy ids_httpcode
end if

end event

