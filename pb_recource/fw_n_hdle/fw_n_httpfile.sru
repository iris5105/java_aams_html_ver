forward
global type fw_n_httpfile from nonvisualobject
end type
end forward

global type fw_n_httpfile from nonvisualobject
end type
global fw_n_httpfile fw_n_httpfile

type prototypes

end prototypes

type variables
constant integer TYPE_PARAM = 0
constant integer TYPE_FILE = 1
constant integer TYPE_PARAM_NONE_ESCAPE = 2

constant integer SIZE_UPLOAD = 0
constant integer SIZE_DOWNLOAD = 1

constant integer HTTP_OK = 0

// HTTP_GETINFO 참조 가능한 항목
constant int HTTPINFO_RESPONSE_CODE = 100
constant int HTTPINFO_HTTP_CONNECTCODE = 101
constant int HTTPINFO_FILETIME = 102
constant int HTTPINFO_REDIRECT_COUNT = 103
constant int HTTPINFO_HEADER_SIZE = 104
constant int HTTPINFO_REQUEST_SIZE = 105
constant int HTTPINFO_SSL_VERIFYRESULT = 106
constant int HTTPINFO_HTTPAUTH_AVAIL = 107
constant int HTTPINFO_PROXYAUTH_AVAIL = 108
constant int HTTPINFO_OS_ERRNO = 109
constant int HTTPINFO_NUM_CONNECTS = 110
constant int HTTPINFO_PRIMARY_PORT = 111
constant int HTTPINFO_LOCAL_PORT = 112
constant int HTTPINFO_LASTSOCKET = 113
constant int HTTPINFO_CONDITION_UNMET = 114
constant int HTTPINFO_RTSP_CLIENT_CSEQ = 115
constant int HTTPINFO_RTSP_SERVER_CSEQ = 116
constant int HTTPINFO_RTSP_CSEQ_RECV = 117

constant int HTTPINFO_TOTAL_TIME = 200
constant int HTTPINFO_NAMELOOKUP_TIME = 201
constant int HTTPINFO_CONNECT_TIME = 202
constant int HTTPINFO_APPCONNECT_TIME = 203
constant int HTTPINFO_PRETRANSFER_TIME = 204
constant int HTTPINFO_STARTTRANSFER_TIME = 205
constant int HTTPINFO_REDIRECT_TIME = 206
constant int HTTPINFO_SIZE_UPLOAD = 207
constant int HTTPINFO_SIZE_DOWNLOAD = 208
constant int HTTPINFO_SPEED_DOWNLOAD = 209
constant int HTTPINFO_SPEED_UPLOAD = 210
constant int HTTPINFO_CONTENT_LENGTH_DOWNLOAD = 211
constant int HTTPINFO_CONTENT_LENGTH_UPLOAD = 212

constant int HTTPINFO_EFFECTIVE_URL = 300
constant int HTTPINFO_REDIRECT_URL = 301
constant int HTTPINFO_CONTENT_TYPE = 302
constant int HTTPINFO_PRIVATE = 303
constant int HTTPINFO_PRIMARY_IP = 304
constant int HTTPINFO_LOCAL_IP = 305
constant int HTTPINFO_FTP_ENTRY_PATH = 306
constant int HTTPINFO_RTSP_SESSION_ID = 307

fw_w_httpupload		iw_upload
fw_w_httpdownload	iw_download

fw_n_dso ids_httpcode

public:
	string UPLOAD_URL = '' //as-is "http://localhost:9090/pfservices/FileUpload"
	string DOWNLOAD_URL= '' //as-is "http://localhost:9090/pfservices/FileDownload"
	boolean OVERWRITE_UPLOADEDFILE = true
	uint DEFAULT_TIMEOUT = 5

end variables

forward prototypes
public subroutine of_setuploadurl (string as_uploadurl)
public subroutine of_setdownloadurl (string as_downloadurl)
public subroutine of_setoverwriteuploadedfile (boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir, boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir)
public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir)
public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir, boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfile, string as_subdir)
public function integer of_fileupload (ref string as_uploadfile, string as_subdir, boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir)
public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir, boolean ab_overwrite)
public function integer of_filedownload (string as_downloadfiles[], string as_downloadurl, string as_subdir, string as_downloadpath)
public function integer of_filedownload (string as_downloadfile, string as_subdir, ref string as_downloadpath)
public function boolean of_ping (string as_url, unsignedinteger aui_timeout)
public function boolean of_ping (string as_url)
public subroutine of_settimeout (unsignedinteger aui_timeout)
public function string of_getdescriptionofhttpcode (integer ai_httpcode)
public function string of_getmessageofhttpcode (integer ai_httpcode)
public function integer of_filedownload (string as_downloadfile, string as_subdir)
public function integer of_filedownload (string as_downloadfile, string as_downloadurl, string as_subdir, string as_downloadpath)
public function integer of_filedownload (string as_downloadfiles[], string as_subdir)
public function integer of_filedownload (string as_downloadfiles[], string as_subdir, string as_downloadpath)
public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content)
public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content, ref string as_uploadfiles[])
public function string of_urlencode (string as_text)
public function string of_ueldecode (string as_text)
end prototypes

public subroutine of_setuploadurl (string as_uploadurl);UPLOAD_URL = as_uploadurl

end subroutine

public subroutine of_setdownloadurl (string as_downloadurl);DOWNLOAD_URL = as_downloadurl

end subroutine

public subroutine of_setoverwriteuploadedfile (boolean ab_overwrite);OVERWRITE_UPLOADEDFILE = ab_overwrite

end subroutine

public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir, boolean ab_overwrite);string ls_filepath, ls_filename
STRING	ls_localfile, ls_serverfile, la_files []
string ls_error
integer li_rc, li_running

if isnull(as_uploadfiles) then return -1
if upperbound(as_uploadfiles) = 0 then
	messagebox('Notice(pf_n_httptransfer)', '업로드할 파일이 지정되지 않았습니다.')
	return - 1
end if

// 업로드 상태창 오픈
open(iw_upload)
iw_upload.cb_close.text = 'Cancel'
iw_upload.st_msg.text = '업로드 초기화 중...'

// 업로드할 파일 설정
long ll_new, i
long ll_filesize
long ll_total_sum, ll_sent_sum

iw_upload.dw_filelist.reset()

for i = 1 to upperbound(as_uploadfiles)
	f_get_array (as_uploadfiles[i], '|', la_files)
	IF upperbound (la_files)=1	THEN la_files [2] = as_uploadfiles[i]
	ll_filesize = gnv_extfunc.biz_getfilesize(la_files [1])
	if ll_filesize = -1 then
		messagebox('Notice', '[' + la_files [1] + '] 파일 정보를 읽을 수 없습니다')
		close(iw_upload)
		return -1
	end if

	ll_new = iw_upload.dw_filelist.insertrow(0)
	iw_upload.dw_filelist.setitem(ll_new, 'filepath', la_files [1])
	iw_upload.dw_filelist.setitem(ll_new, 'filename', gnv_extfunc.of_pathstrippath(la_files [1]))
	iw_upload.dw_filelist.setitem(ll_new, 'filesize', ll_filesize)
next

ll_total_sum = iw_upload.dw_filelist.getitemnumber(1, 'compute_1')
iw_upload.dw_2.object.total[1] = ' / ' + string(ll_total_sum, '#,##0')

// 업로드 초기화
double ld_ultotal, ld_ulnow
double ld_ultotal_bef, ld_ulnow_bef
integer li_percent, li_percent_bef
string ls_resptext, ls_uploadedfile
string ls_httpmesg
long ll_httpcode

// HTTP 모듈 초기화
gnv_extfunc.biz_http_globaldefault()
iw_upload.st_msg.text = '파일 업로드 중...'
iw_upload.dw_1.visible = TRUE
iw_upload.dw_2.visible = TRUE
for i = 1 to upperbound(as_uploadfiles)
	f_get_array (as_uploadfiles[i], '|', la_files)
	IF upperbound (la_files)=1	THEN la_files [2] = as_uploadfiles[i]
	iw_upload.dw_filelist.scrolltorow(i)
	iw_upload.dw_filelist.setrow(i)
	
	yield()
	
	ls_filepath = iw_upload.dw_filelist.getitemstring(i, 'filepath')
	ls_filename = la_files [2]
	ll_filesize = iw_upload.dw_filelist.getitemnumber(i, 'filesize')
	
	
	gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "filename", ls_filename)
	gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "subdir", as_subdir)
	if ab_overwrite = true then
		gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "overwrite", "true")
	else
		gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "overwrite", "false")
	end if
	gnv_extfunc.biz_http_addformfield(TYPE_FILE, "file1", ls_filepath)
	
	// initialize http
	if gnv_extfunc.biz_http_openupload(as_uploadurl, ls_filepath) = -1 then
		close(iw_upload)
		return -1
	end if
	
	li_running = gnv_extfunc.biz_http_send()
	do while li_running = 1
		ld_ultotal = gnv_extfunc.biz_http_uploadprogress_total()
		ld_ulnow = gnv_extfunc.biz_http_uploadprogress_now()
		
		if ld_ultotal <> ld_ultotal_bef then
			iw_upload.dw_1.object.total[1] = ' / ' + string(ld_ultotal, '#,##0')
			ld_ultotal_bef = ld_ultotal
		end if
		
		if ld_ulnow <> ld_ulnow_bef then
			iw_upload.dw_1.object.now[1] = string(ld_ulnow, '#,##0')
			iw_upload.dw_2.object.now[1] = string(ll_sent_sum + ld_ulnow, '#,##0')
			ld_ulnow_bef = ld_ulnow
		end if
		
		if ld_ulnow > 0 then
			li_percent = int((ld_ulnow / ld_ultotal) * 100)
			if li_percent <> li_percent_bef then
				iw_upload.hpb_file.position = li_percent
				iw_upload.hpb_total.position = int((ll_sent_sum + ld_ulnow) / ll_total_sum * 100)
				li_percent_bef = li_percent
			end if
		end if
		
		// Cancelling...
		if iw_upload.ib_cancel = true then
			gnv_extfunc.biz_http_abort()
			exit
		end if

		yield()
		li_running = gnv_extfunc.biz_http_checkrunningstatus()
	loop
	
	// check result code
	li_rc = gnv_extfunc.biz_http_getresultcode()
	if li_rc <> HTTP_OK then
		ls_error = gnv_extfunc.biz_http_geterrormessage(li_rc)
		gnv_extfunc.biz_http_close()
		gnv_extfunc.biz_http_globalcleanup()
		messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
		close(iw_upload)
		return -1
	end if
	
	// check http code
	ll_httpcode = gnv_extfunc.biz_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
	if ll_httpcode >= 300 then
		ls_httpmesg = '파일 업로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
		this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
		gnv_extfunc.biz_http_close()
		gnv_extfunc.biz_http_globalcleanup()
		messagebox('파일 업로드 오류', ls_httpmesg)
		close(iw_upload)
		return -1
	end if
	
	// get response
	ls_resptext = gnv_extfunc.biz_http_getresponsefromupload()
	if left(ls_resptext, 9) = 'uploaded:' then
		ls_uploadedfile = mid(ls_resptext, 10)
	end if
	
	gnv_extfunc.biz_http_close()
	
	// Check if cancel button was clicked
	if iw_upload.ib_cancel = true then
		exit
	end if
	
	ll_sent_sum += ll_filesize
	gnv_extfunc.sleep(10)
next

// HTTP 모듈 클린업
gnv_extfunc.biz_http_globalcleanup()
iw_upload.cb_close.text = 'Close'

if iw_upload.ib_cancel = true then
	iw_upload.st_msg.text = '파일 전송 취소!!'
	messagebox('Notice', '파일 전송이 취소되었습니다.')
else
	iw_upload.st_msg.text = '파일 업로드 완료!!'
	//messagebox('Notice', '파일 전송이 완료되었습니다.')
end if

close(iw_upload)

return li_rc

end function

public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir);return this.of_fileupload(as_uploadfiles, as_uploadurl, as_subdir, OVERWRITE_UPLOADEDFILE)

end function

public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir);if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('Notice', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

return this.of_fileupload(as_uploadfiles, UPLOAD_URL, as_subdir, OVERWRITE_UPLOADEDFILE)

end function

public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir, boolean ab_overwrite);if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('Notice', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

return this.of_fileupload(as_uploadfiles, UPLOAD_URL, as_subdir, ab_overwrite)

end function

public function integer of_fileupload (ref string as_uploadfile, string as_subdir);string	ls_uploadfiles[]
integer	li_rc

if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('Notice', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

ls_uploadfiles[1] = as_uploadfile
li_rc = this.of_fileupload(ls_uploadfiles, UPLOAD_URL, as_subdir, OVERWRITE_UPLOADEDFILE)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_fileupload (ref string as_uploadfile, string as_subdir, boolean ab_overwrite);string	ls_uploadfiles[]
integer	li_rc

if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('Notice', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

ls_uploadfiles[1] = as_uploadfile
li_rc =  this.of_fileupload(ls_uploadfiles, UPLOAD_URL, as_subdir, ab_overwrite)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir);string	ls_uploadfiles[]
integer	li_rc

ls_uploadfiles[1] = as_uploadfile
li_rc =  this.of_fileupload(ls_uploadfiles, as_uploadurl, as_subdir, OVERWRITE_UPLOADEDFILE)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir, boolean ab_overwrite);string	ls_uploadfiles[]
integer	li_rc

ls_uploadfiles[1] = as_uploadfile
li_rc = this.of_fileupload(ls_uploadfiles, as_uploadurl, as_subdir, ab_overwrite)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_filedownload (string as_downloadfiles[], string as_downloadurl, string as_subdir, string as_downloadpath);string ls_filepath
string ls_error
integer li_rc, li_running
integer i, li_filecnt

// 다운로드할 (서버)파일명 확인
if isnull(as_downloadfiles) then return -1

li_filecnt = upperbound(as_downloadfiles)
if li_filecnt = 0 then
	messagebox('Notice', '다운로드할 파일이 지정되지 않았습니다.')
	return - 1
end if

for i = 1 to li_filecnt
	if isnull(as_downloadfiles[i]) or len(trim(as_downloadfiles[i])) = 0 then
		messagebox('Notice', '다운로드할 파일이 지정되지 않았습니다.')
		return - 1
	end if
next

// 다운로드 URL 확인
if isnull(as_downloadurl) then return -1
if len(trim(as_downloadurl)) = 0 then
	messagebox('Notice', '다운로드 URL이 설정되지 않았습니다.')
	return - 1
end if

// 다운로드 SUBDIR 확인
if isnull(as_subdir) then return -1
if len(trim(as_subdir)) = 0 then
	messagebox('Notice', '다운로드 SUBDIR(서버_하위경로)이 설정되지 않았습니다.')
	return - 1
end if

// DownloadPath 가 미설정된 경우 사용자 설정 처리
long ll_lastpos
string ls_fileext
string	la_file [], la_filename [], la_server [], la_ext []

FOR  i = 1  TO  upperbound (as_downloadfiles)
	f_get_array (as_downloadfiles[i], '|', la_file)
	IF upperbound (la_file)=1	THEN la_file[2] = as_downloadfiles[i]
	
	ls_filepath = la_file [2]
	ll_lastpos = lastpos(ls_filepath, '.')
	if ll_lastpos > 0 then
		ls_fileext = mid(ls_filepath, ll_lastpos + 1)
		if isnumber(ls_fileext) then
			ls_filepath = mid(ls_filepath, 1, ll_lastpos - 1)
		end if
	end if
	la_filename [i] = la_file [1]
	la_server [i] = ls_filepath
	la_ext [i] = ls_fileext
NEXT

IF isnull(as_downloadpath) or len(trim(as_downloadpath))=0	Then
	IF getfolder ('파일을 저장할 폴더를 선택하십시요', ls_filepath)=-1	Then
		RETURN 0
	End IF
	as_downloadpath = ls_filepath
End IF

// 다운로드 상태창 오픈
open(iw_download)
iw_download.cb_close.text = 'Cancel'
iw_download.st_msg.text = '다운로드 초기화 중...'

// 다운로드 초기화
double ld_dltotal, ld_dlnow
double ld_dltotal_bef, ld_dlnow_bef
double ld_bytespersec
long ll_total_sum, ll_recv_sum
integer li_percent, li_percent_bef

iw_download.st_msg.text = '파일 다운로드 중...'

long ll_new
long ll_filesize
string ls_extension

// 다운로드할 파일 DW 표시
iw_download.dw_filelist.reset()
for i = 1 to li_filecnt
	
	// 파일명 일련번호 제거
	ls_filepath = as_downloadfiles[i]
	ll_lastpos = lastpos(ls_filepath, '.')
	if ll_lastpos > 0 then
		ls_fileext = mid(ls_filepath, ll_lastpos + 1)
		if isnumber(ls_fileext) then
			ls_filepath = mid(ls_filepath, 1, ll_lastpos - 1)
		end if
	end if
	
	ll_new = iw_download.dw_filelist.insertrow(0)
	iw_download.dw_filelist.setitem(ll_new, 'filepath', as_downloadpath + '\' + ls_filepath)
	iw_download.dw_filelist.setitem(ll_new, 'filename', ls_filepath)
	iw_download.dw_filelist.setitem(ll_new, 'filesize', 0)
next

// HTTP 모듈 초기화
gnv_extfunc.biz_http_globaldefault()

// 파일 다운로드
for i = 1 to li_filecnt
	iw_download.dw_filelist.scrolltorow(i)
	iw_download.dw_filelist.setrow(i)
	
	ls_filepath = iw_download.dw_filelist.getitemstring(i, 'filepath')
	
	// 다운로드 URL 및 로컬 파일경로 설정 e-결재 수정 to-be
	if gnv_extfunc.biz_http_opendownload(as_downloadurl, ls_filepath) = -1 then
		gnv_extfunc.biz_http_close()
		gnv_extfunc.biz_http_globalcleanup()
		return -1
//		messagebox('Notice', 'pf_http_opendownload() 호출 오류 입니다~r~nas_downloadurl=' + string(as_downloadurl) + ', as_downloadpath=' + string(ls_filepath))
//		return -1
	end if
	
	// 수신 파일명 및 서브 경로 설정
	gnv_extfunc.biz_http_setpostfields("filename=" + la_server[i] + "&subdir=" + as_subdir)
	//gnv_extfunc.biz_http_setpostfields("filename=" + this.of_urlencode(la_server[i]) + "&subdir=" + this.of_urlencode(as_subdir))
	if gnv_extfunc.biz_http_send() <> 1 then
		gnv_extfunc.biz_http_globalcleanup()
		messagebox('Notice', 'pf_http_send() 호출 오류 입니다')
		return -1
	end if
	
	// 진행상태 점검
	li_running = gnv_extfunc.biz_http_checkrunningstatus()
	do while li_running = 1
		////yield()
		
		ld_dlnow = gnv_extfunc.biz_http_downloadprogress_now()
		ld_dltotal = gnv_extfunc.biz_http_downloadprogress_total()
		
		if ld_dltotal <> ld_dltotal_bef then
			iw_download.dw_filelist.setitem(ll_new, 'filesize', ld_dltotal)
			iw_download.dw_filelist.uf_setrow (ll_new, TRUE)
			iw_download.dw_1.object.total[1] = ' / ' + string(ld_dltotal, '#,##0')
			iw_download.dw_2.object.total[1] = ' / ' + string(ll_recv_sum + ld_dltotal, '#,##0')
			ld_dltotal_bef = ld_dltotal
		end if	
		
		if ld_dlnow <> ld_dlnow_bef then
			iw_download.dw_1.object.now[1] = string(ld_dlnow, '#,##0')
			iw_download.dw_2.object.now[1] = string(ll_recv_sum + ld_dlnow, '#,##0')
			ld_dlnow_bef = ld_dlnow
		end if
		
		if ld_dlnow > 0 then
			li_percent = int((ld_dlnow / ld_dltotal) * 100)
			if li_percent <> li_percent_bef then
				iw_download.hpb_file.position = li_percent
				li_percent_bef = li_percent
			end if
		end if
		
		// 다운로드 취소 확인
		if iw_download.ib_cancel = true then
			gnv_extfunc.biz_http_abort()
			gnv_extfunc.biz_http_globalcleanup()
			exit
		end if
		
		li_running = gnv_extfunc.biz_http_checkrunningstatus()
	loop
	
	// 결과코드 처리
	li_rc = gnv_extfunc.biz_http_getresultcode()
	if li_rc <> HTTP_OK then
		ls_error = gnv_extfunc.biz_http_geterrormessage(li_rc)
		gnv_extfunc.biz_http_close()
		gnv_extfunc.biz_http_globalcleanup()
		messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
		close(iw_download)
		return -1
	end if
	
	// 마지막 진행상황 처리
	ld_dlnow = gnv_extfunc.biz_http_downloadprogress_now()
	if ld_dltotal > 0 then li_percent = int((ld_dlnow / ld_dltotal) * 100)
	iw_download.dw_1.object.now[1] = string(ld_dlnow, '#,##0')
	iw_download.dw_2.object.now[1] = string(ll_recv_sum + ld_dlnow, '#,##0')
	iw_download.hpb_file.position = li_percent
	iw_download.hpb_total.position = li_percent
	ll_recv_sum += ld_dltotal
	
	// 다운로드 전송 속도
	//ld_bytespersec = gnv_extfunc.biz_http_getinfo_double(HTTPINFO_SPEED_DOWNLOAD)
	//iw_download.st_msg.text = string(ld_bytespersec / 1000, '#,##0') + ' Kbytes/sec'
	
	// HTTP Code 확인
	long ll_httpcode
	string ls_httpmesg
	ll_httpcode = gnv_extfunc.biz_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
	if ll_httpcode >= 300 then
		ls_httpmesg = '파일 다운로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
		this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
		gnv_extfunc.biz_http_close()
		gnv_extfunc.biz_http_globalcleanup()
		messagebox('파일 다운로드 오류', ls_httpmesg)
		close(iw_download)
		return -1
	end if

	// HTTP 전송 종료
	gnv_extfunc.biz_http_close()
	
	// 오픈전 대기
	gnv_extfunc.sleep(10)
next

iw_download.cb_close.text = 'Close'
gnv_extfunc.biz_http_globalcleanup()

// 결과 메시지 표시
if len(ls_httpmesg) > 0 then
	li_rc = -1
	iw_download.st_msg.text = '파일 전송 오류!'
elseif iw_download.ib_cancel = true then
	li_rc = -1
	iw_download.st_msg.text = '전송이 취소되었습니다!'
else
	iw_download.st_msg.text = '파일 다운로드 완료!'
end if

close(iw_download)

return li_rc
end function

public function integer of_filedownload (string as_downloadfile, string as_subdir, ref string as_downloadpath);integer li_rc

li_rc = this.of_filedownload(as_downloadfile, DOWNLOAD_URL, as_subdir, as_downloadpath)

return li_rc

end function

public function boolean of_ping (string as_url, unsignedinteger aui_timeout);// as_url 이 유효한지 검사합니다
// as_url : 테스트할 URL 주소
// aui_timeout : 테스트 타임아웃(초)

boolean lb_rv

if isnull(as_url) or len(trim(as_url)) = 0 then
	messagebox('of_ping 알림', 'URL 정보가 없습니다')
	return false
end if

// Time Out 초가 설정되지 않은 경우 기본 5초 설정
if aui_timeout <= 0  then
	aui_timeout = DEFAULT_TIMEOUT
end if

lb_rv = gnv_extfunc.biz_http_ping(as_url, aui_timeout)

return lb_rv

end function

public function boolean of_ping (string as_url);// as_url 이 유효한지 검사합니다
// as_url : 테스트할 URL 주소

uint lui_timeout

lui_timeout = DEFAULT_TIMEOUT

return this.of_ping(as_url, lui_timeout)

end function

public subroutine of_settimeout (unsignedinteger aui_timeout);DEFAULT_TIMEOUT = aui_timeout

end subroutine

public function string of_getdescriptionofhttpcode (integer ai_httpcode);// HTTPCODE에 해당하는 상세 에러 메시지를 리턴합니다.

long		ll_find
string	ls_errmsg

ll_find = ids_httpcode.find("httpcode='" + string(ai_httpcode) + "'", 1, ids_httpcode.rowcount())
if ll_find > 0 then
	ls_errmsg = ids_httpcode.getitemstring(ll_find, 'httpcode_desc')
end if

return ls_errmsg

end function

public function string of_getmessageofhttpcode (integer ai_httpcode);// HTTPCODE에 해당하는 에러 메시지를 리턴합니다.

long		ll_find
string	ls_errmsg

ll_find = ids_httpcode.find("httpcode='" + string(ai_httpcode) + "'", 1, ids_httpcode.rowcount())
if ll_find > 0 then
	ls_errmsg = ids_httpcode.getitemstring(ll_find, 'httpcode_mesg')
end if

return ls_errmsg

end function

public function integer of_filedownload (string as_downloadfile, string as_subdir);integer li_rc
string ls_downloadpath

li_rc = this.of_filedownload(as_downloadfile, DOWNLOAD_URL, as_subdir, ls_downloadpath)

return li_rc

end function

public function integer of_filedownload (string as_downloadfile, string as_downloadurl, string as_subdir, string as_downloadpath);string ls_filepath, ls_filename
string ls_error
integer li_rc, li_running

// 다운로드할 (서버)파일명 확인
if isnull(as_downloadfile) then return -1
if len(trim(as_downloadfile)) = 0 then
	messagebox('Notice', '다운로드할 파일이 지정되지 않았습니다.')
	return - 1
end if

// 다운로드 URL 확인
if isnull(as_downloadurl) then return -1
if len(trim(as_downloadurl)) = 0 then
	messagebox('Notice', '다운로드 URL이 설정되지 않았습니다.')
	return - 1
end if

// 다운로드 SUBDIR 확인
if isnull(as_subdir) then return -1
if len(trim(as_subdir)) = 0 then
	messagebox('Notice', '다운로드 SUBDIR(서버_하위경로)이 설정되지 않았습니다.')
	return - 1
end if

// DownloadPath 가 미설정된 경우 사용자 설정 처리
long ll_lastpos
string ls_fileext
string	la_file []

f_get_array (as_downloadfile, '|', la_file)
IF upperbound (la_file)=1	THEN la_file[2] = as_downloadfile

ls_filepath = la_file [2]
ll_lastpos = lastpos(ls_filepath, '.')
if ll_lastpos > 0 then
	ls_fileext = mid(ls_filepath, ll_lastpos + 1)
	if isnumber(ls_fileext) then
		ls_filepath = mid(ls_filepath, 1, ll_lastpos - 1)
	end if
end if

if isnull(as_downloadpath) or len(trim(as_downloadpath)) = 0 then
	ls_filename = la_file [1]
	if getfilesavename("첨부파일을 저장할 위치를 설정하세요", ls_filepath, ls_filename) <= 0 then return 0
	as_downloadpath = ls_filepath
end if

// 다운로드 상태창 오픈
open(iw_download)
iw_download.cb_close.text = 'Cancel'
iw_download.st_msg.text = '다운로드 초기화 중...'

// 다운로드 초기화
double ld_dltotal, ld_dlnow
double ld_dltotal_bef, ld_dlnow_bef
double ld_bytespersec
long ll_total_sum, ll_recv_sum
integer li_percent, li_percent_bef
long ll_filecnt, i

iw_download.st_msg.text = '파일 다운로드 중...'

long ll_new
long ll_filesize
string ls_extension

// e-결재시 무시 무조건 엎어쓰기 // 기 존재하는 파일 확인 기 존재하는 파일 확인
//if fileexists(as_downloadpath) then
//	if messagebox('Notice', '[' + as_downloadpath + ']~r~n다운로드 받을 파일이 이미 존재합니다.~r~n해당 파일을 덮어쓰기 하시겠습니까?', Question!, YesNo!, 2) = 2 then
//		close(iw_download)
//		return -1
//	end if
//end if

// 다운로드할 파일 DW 표시
iw_download.dw_filelist.reset()
ll_new = iw_download.dw_filelist.insertrow(0)
iw_download.dw_filelist.setitem(ll_new, 'filepath', as_downloadpath)
iw_download.dw_filelist.setitem(ll_new, 'filename', gnv_extfunc.of_pathstrippath(as_downloadpath))
iw_download.dw_filelist.setitem(ll_new, 'filesize', 0)

// HTTP 모듈 초기화
gnv_extfunc.biz_http_globaldefault()

// HTTP header 설정
gnv_extfunc.biz_http_addhttpheader("User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705) ")
gnv_extfunc.biz_http_addhttpheader("Content-Type: application/x-www-form-urlencoded; charset=euc-kr")
//gnv_extfunc.biz_http_addhttpheader("Content-Type: multipart/form-data; charset=euc-kr")

// 다운로드 URL 및 로컬 파일경로 설정  e-결재 수정 to-be
if gnv_extfunc.biz_http_opendownload(as_downloadurl, as_downloadpath) = -1 then	
	gnv_extfunc.biz_http_close()
	gnv_extfunc.biz_http_globalcleanup()
	return -1
//	messagebox('Notice', 'pf_http_opendownload() 호출 오류 입니다~r~nas_downloadurl=' + string(as_downloadurl) + ', as_downloadpath=' + string(as_downloadpath))
//	return -1
end if

// 수신 파일명 및 서브 경로 설정
//<임시> 파일명 인코딩 사용시 파일명에 한글이 들어가면 http404 발생 20210707
//as_downloadfile = this.of_urlencode(as_downloadfile)
gnv_extfunc.biz_http_setpostfields("filename=" + la_file [2] + "&subdir=" + as_subdir)
//gnv_extfunc.biz_http_setpostfields("filename=" + this.of_urlencode(as_downloadfile) + "&subdir=" + this.of_urlencode(as_subdir))

if gnv_extfunc.biz_http_send() <> 1 then
	gnv_extfunc.biz_http_globalcleanup()
	messagebox('Notice', 'pf_http_send() 호출 오류 입니다')
	return -1
end if

// 진행상태 점검
li_running = gnv_extfunc.biz_http_checkrunningstatus()
iw_download.dw_1.visible = TRUE
iw_download.dw_2.visible = TRUE
do while li_running = 1
	yield()
	
	ld_dlnow = gnv_extfunc.biz_http_downloadprogress_now()
	ld_dltotal = gnv_extfunc.biz_http_downloadprogress_total()
	
	if ld_dltotal <> ld_dltotal_bef then
		iw_download.dw_filelist.setitem(ll_new, 'filesize', ld_dltotal)
		iw_download.dw_filelist.uf_setrow (ll_new, TRUE)
		iw_download.dw_1.object.total[1] = ' / ' + string(ld_dltotal, '#,##0')
		iw_download.dw_2.object.total[1] = ' / ' + string(ll_recv_sum + ld_dltotal, '#,##0')
		ld_dltotal_bef = ld_dltotal
	end if	
	
	if ld_dlnow <> ld_dlnow_bef then
		iw_download.dw_1.object.now[1] = string(ld_dlnow, '#,##0')
		iw_download.dw_2.object.now[1] = string(ll_recv_sum + ld_dlnow, '#,##0')
		ld_dlnow_bef = ld_dlnow
	end if
	
	if ld_dlnow > 0 then
		li_percent = int((ld_dlnow / ld_dltotal) * 100)
		if li_percent <> li_percent_bef then
			iw_download.hpb_file.position = li_percent
			iw_download.hpb_total.position = li_percent
			li_percent_bef = li_percent
		end if
	end if
	
	// 다운로드 취소 확인
	if iw_download.ib_cancel = true then
		gnv_extfunc.biz_http_abort()
		exit
	end if
	
	li_running = gnv_extfunc.biz_http_checkrunningstatus()
loop

// 결과코드 처리
li_rc = gnv_extfunc.biz_http_getresultcode()
if li_rc <> HTTP_OK then
	ls_error = gnv_extfunc.biz_http_geterrormessage(li_rc)
	gnv_extfunc.biz_http_close()
	gnv_extfunc.biz_http_globalcleanup()
	messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
	close(iw_download)
	return -1
end if

// 마지막 진행상황 처리
ld_dlnow = gnv_extfunc.biz_http_downloadprogress_now()
if ld_dltotal > 0 then li_percent = int((ld_dlnow / ld_dltotal) * 100)
//iw_download.st_bytesrecv.text = string(ld_dlnow, '#,##0')
//iw_download.st_bytesrecv_sum.text = string(ll_recv_sum + ld_dlnow, '#,##0')
iw_download.dw_1.object.now[1] = string(ld_dlnow, '#,##0')
iw_download.dw_2.object.now[1] = string(ll_recv_sum + ld_dlnow, '#,##0')
iw_download.hpb_file.position = li_percent
iw_download.hpb_total.position = li_percent
ll_recv_sum += ld_dltotal

// 다운로드 전송 속도
//ld_bytespersec = gnv_extfunc.biz_http_getinfo_double(HTTPINFO_SPEED_DOWNLOAD)
//iw_download.st_msg.text = string(ld_bytespersec / 1000, '#,##0') + ' Kbytes/sec'

// HTTP Code 확인
long ll_httpcode
string ls_httpmesg
ll_httpcode = gnv_extfunc.biz_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
if ll_httpcode >= 300 then
	ls_httpmesg = '파일 다운로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
	this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
	gnv_extfunc.biz_http_close()	
	gnv_extfunc.biz_http_globalcleanup()
	messagebox('파일 다운로드 오류', ls_httpmesg)
	close(iw_download)
	return -1
end if

// HTTP 전송 종료
gnv_extfunc.biz_http_close()
gnv_extfunc.biz_http_globalcleanup()
iw_download.cb_close.text = 'Close'

// 결과 메시지 표시
if len(ls_httpmesg) > 0 then
	li_rc = -1
	iw_download.st_msg.text = '파일 전송 오류!'
elseif iw_download.ib_cancel = true then
	li_rc = -1
	iw_download.st_msg.text = '전송이 취소되었습니다!'
else
	iw_download.st_msg.text = '파일 다운로드 완료!'
end if

close(iw_download)

return li_rc
end function

public function integer of_filedownload (string as_downloadfiles[], string as_subdir);integer	li_rc
string	ls_downloadpath

li_rc = this.of_filedownload(as_downloadfiles, DOWNLOAD_URL, as_subdir, ls_downloadpath)

return li_rc

end function

public function integer of_filedownload (string as_downloadfiles[], string as_subdir, string as_downloadpath);integer	li_rc

li_rc = this.of_filedownload(as_downloadfiles, DOWNLOAD_URL, as_subdir, as_downloadpath)

return li_rc

end function

public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content);String	ls_DummyFiles[]

return This.of_sendmail( as_server_url, as_from_user_name, as_from_addr, as_to_addr, as_subject, as_content, ls_DummyFiles )
end function

public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content, ref string as_uploadfiles[]);//string ls_filepath, ls_filename
string	ls_error
integer	li_rc, li_running

// 업로드 초기화
double	ld_ultotal, ld_ulnow
double	ld_ultotal_bef, ld_ulnow_bef
integer	li_percent, li_percent_bef
string	ls_resptext, ls_uploadedfile
string	ls_httpmesg
long		ll_httpcode

// HTTP 모듈 초기화
gnv_extfunc.biz_http_globaldefault()

string	ls_serverurl, ls_from_user_name, ls_from_addr, ls_to_addr
string	ls_subject, ls_content
		  
gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "from_user_name", as_from_user_name)
gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "from_addr", as_from_addr)
gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "to_addr", as_to_addr)
gnv_extfunc.biz_http_addformfield(TYPE_PARAM, "subject", as_subject)
gnv_extfunc.biz_http_addformfield(TYPE_PARAM_NONE_ESCAPE, "content", as_content)

long		i, li_cnt
string	ls_filename
string	ls_add_files[10]	// 첨부파일 최대 10개로 지정.(추가시 dll 수정 필요.)

li_cnt = UpperBound(as_uploadfiles)
if li_cnt > 0 then
	for i=1 to li_cnt
		ls_add_files[i] = as_uploadfiles[i]
		if pf_f_isemptystring(ls_add_files[i]) then
			messagebox('Notice', '첨부 파일이 빠져 있습니다!')
			return -1
		end if
	next
end if

// initialize http
if gnv_extfunc.biz_http_sendmail(as_server_url, ls_add_files, li_cnt ) = -1 then
	return -1
end if

li_running = gnv_extfunc.biz_http_send()
do while li_running = 1
	yield();yield();yield();yield();
	li_running = gnv_extfunc.biz_http_checkrunningstatus()
loop

// check result code
li_rc = gnv_extfunc.biz_http_getresultcode()
if li_rc <> HTTP_OK then
	ls_error = gnv_extfunc.biz_http_geterrormessage(li_rc)
	gnv_extfunc.biz_http_close()
	gnv_extfunc.biz_http_globalcleanup()
	messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
	return -1
end if

// check http code
ll_httpcode = gnv_extfunc.biz_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
if ll_httpcode >= 300 then
	ls_httpmesg = '메일 전송 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
	this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
	gnv_extfunc.biz_http_close()
	gnv_extfunc.biz_http_globalcleanup()
	messagebox('메일 전송 오류', ls_httpmesg)
	return -1
end if

gnv_extfunc.biz_http_close()

// HTTP 모듈 클린업
gnv_extfunc.biz_http_globalcleanup()

//messagebox('Notice', '메일 전송이 완료되었습니다.')

return li_rc
end function

public function string of_urlencode (string as_text);OleObject	wsh

Integer	li_rc
string	ls_temp

wsh = CREATE OleObject
li_rc = wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
wsh.language = "javascript"

as_text = fw_f_replaceall(as_text, "'", "\'")
ls_temp = wsh.Eval("encodeURIComponent('" + as_text + "')")

//MessageBox('ls_temp', ls_temp)
Destroy wsh
Return ls_temp

end function

public function string of_ueldecode (string as_text);OleObject	wsh

Integer	li_rc
string	ls_temp

wsh = CREATE OleObject
li_rc = wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
wsh.language = "javascript"

ls_temp = wsh.Eval("unescape('" + as_text + "')")

return ls_temp

end function

on fw_n_httpfile.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_httpfile.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;UPLOAD_URL = 'http://' + gnv_vari.SetWASSignupIP + '/pfservices/FileUpload'
DOWNLOAD_URL = 'http://' + gnv_vari.SetWASSignupIP + '/pfservices/FileDownload'

// HTTPCODE 메시지용 데이터윈도우
ids_httpcode = create fw_n_dso
ids_httpcode.dataobject = 'fw_d_httpcode'

end event

event destructor;if isvalid(ids_httpcode) then
	destroy ids_httpcode
end if

end event

