forward
global type uo_wininet from nonvisualobject
end type
end forward

global type uo_wininet from nonvisualobject autoinstantiate
end type

type prototypes
// Windows Functions
Function ulong GetLastError ( ) Library "kernel32.dll"
Function ulong CreateFile ( string lpFileName, ulong dwDesiredAccess, ulong dwShareMode, ulong lpSecurityAttributes, ulong dwCreationDisposition, ulong dwFlagsAndAttributes, ulong hTemplateFile ) Library "kernel32.dll" Alias For "CreateFileA;Ansi"
Function boolean CloseHandle ( ulong hObject ) Library "kernel32.dll"
Function boolean ReadFile ( ulong hFile, Ref blob lpBuffer, ulong nNumberOfBytesToRead, Ref ulong lpNumberOfBytesRead, ulong lpOverlapped ) Library "kernel32.dll"

// Internet Functions
Function boolean FtpCreateDirectory ( ulong hConnect, string lpszDirectory ) Library "wininet.dll" Alias For "FtpCreateDirectoryA;Ansi"
Function boolean FtpDeleteFile ( ulong hConnect, string lpszFileName ) Library "wininet.dll" Alias For "FtpDeleteFileA;Ansi"
Function boolean FtpGetCurrentDirectory ( ulong hConnect, Ref string lpszCurrentDirectory, Ref ulong lpdwCurrentDirectory ) Library "wininet.dll" Alias For "FtpGetCurrentDirectoryA;Ansi"
Function boolean FtpGetFile ( ulong hConnect, string lpszRemoteFile, string lpszNewFile, boolean fFailIfExists, ulong dwFlagsAndAttributes, ulong dwFlags, ulong dwContext ) Library "wininet.dll" Alias For "FtpGetFileA;Ansi"
Function ulong FtpGetFileSize ( ulong hFile, Ref ulong lpdwFileSizeHigh ) Library "wininet.dll" Alias For "FtpGetFileSize"
Function ulong FtpOpenFile ( ulong hConnect, string lpszFileName, ulong dwAccess, ulong dwFlags, ulong dwContext ) Library "wininet.dll" Alias For "FtpOpenFileA;Ansi"
Function boolean FtpPutFile ( ulong hConnect, string lpszLocalFile, string lpszNewRemoteFile, ulong dwFlags, ulong dwContext ) Library "wininet.dll" Alias For "FtpPutFileA;Ansi"
Function boolean FtpRemoveDirectory ( ulong hConnect, string lpszDirectory ) Library "wininet.dll" Alias For "FtpRemoveDirectoryA;Ansi"
Function boolean FtpRenameFile ( ulong hConnect, string lpszExisting, string lpszNew ) Library "wininet.dll" Alias For "FtpRenameFileA;Ansi"
Function boolean FtpSetCurrentDirectory ( ulong hConnect, string lpszDirectory ) Library "wininet.dll" Alias For "FtpSetCurrentDirectoryA;Ansi"
Function boolean InternetCloseHandle ( ulong hInternet ) Library "wininet.dll"
Function ulong InternetConnect ( ulong hInternet, string lpszServerName, uint nServerPort, string lpszUserName, string lpszPassword, ulong dwService, ulong dwFlags, ulong dwContext ) Library "wininet.dll" Alias For "InternetConnectA;Ansi"
Function boolean InternetGetLastResponseInfo ( Ref ulong lpdwError, Ref string lpszBuffer, Ref ulong lpdwBufferLength ) Library "wininet.dll" Alias For "InternetGetLastResponseInfoA;Ansi"
Function ulong InternetOpen ( string lpszAgent, ulong dwAccessType, string lpszProxy, string lpszProxyBypass, ulong dwFlags ) Library "wininet.dll" Alias For "InternetOpenA;Ansi"
Function boolean InternetReadFile ( ulong hFile, ref blob lpBuffer, ulong dwNumberOfBytesToRead, ref ulong lpdwNumberOfBytesRead ) Library "wininet.dll" Alias For "InternetReadFile"
Function boolean InternetWriteFile ( ulong hFile, blob lpBuffer, ulong dwNumberOfBytesToWrite, ref ulong lpdwNumberOfBytesWritten ) Library "wininet.dll" Alias For "InternetWriteFile"

end prototypes

type variables
STRING	is_ip, is_user, is_pwd, is_path, is_name, is_local_path

INT	ii_port, ii_transfer_type

HProgressBar	ihpb		// 진행바

statictext	ist_Text	// 진행Text

STRING	is_st_text = ''

// Internet handles
ULONG	iul_internet
ULONG	iul_session

// Internet open types
CONSTANT uint INTERNET_OPEN_TYPE_PRECONFIG = 0
CONSTANT uint INTERNET_OPEN_TYPE_DIRECT = 1
CONSTANT uint INTERNET_OPEN_TYPE_PROXY = 3
CONSTANT uint INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4

// Internet service types
CONSTANT uint INTERNET_SERVICE_URL = 0
CONSTANT uint INTERNET_SERVICE_FTP = 1
CONSTANT uint INTERNET_SERVICE_GOPHER = 2
CONSTANT uint INTERNET_SERVICE_HTTP = 3

// Port numbers
CONSTANT uint INTERNET_INVALID_PORT_NUMBER = 0
CONSTANT uint INTERNET_DEFAULT_FTP_PORT = 21
CONSTANT uint INTERNET_DEFAULT_GOPHER_PORT = 70
CONSTANT uint INTERNET_DEFAULT_HTTP_PORT = 80
CONSTANT uint INTERNET_DEFAULT_HTTPS_PORT = 443
CONSTANT uint INTERNET_DEFAULT_SOCKS_PORT = 1080

// Internet flags
CONSTANT ulong INTERNET_FLAG_RELOAD = 2147483648
CONSTANT ulong INTERNET_FLAG_NO_CACHE_WRITE = 67108864
CONSTANT ulong INTERNET_FLAG_RAW_DATA = 1073741824
end variables

forward prototypes
public function string uf_getlasterror ()
public function integer uf_ftp_connect ()
public function string uf_ftp_writefile ()
public function string uf_ftp_readfile ()
public function string uf_ftp_deletefile ()
public function string uf_ftp_getcurrentdirectory ()
public function string uf_ftp_putfile ()
public subroutine uf_ftp_disconnect ()
public function string uf_ftp_getfile ()
public function integer uf_file_check ()
public function integer uf_ftp_changedirectory ()
end prototypes

public function string uf_getlasterror ();// Internet API error returns
UINT  INTERNET_ERROR_BASE = 12000
UINT  ERROR_INTERNET_OUT_OF_HANDLES = (INTERNET_ERROR_BASE + 1)
UINT  ERROR_INTERNET_TIMEOUT = (INTERNET_ERROR_BASE + 2)
UINT  ERROR_INTERNET_EXTENDED_ERROR = (INTERNET_ERROR_BASE + 3)
UINT  ERROR_INTERNET_INTERNAL_ERROR = (INTERNET_ERROR_BASE + 4)
UINT  ERROR_INTERNET_INVALID_URL = (INTERNET_ERROR_BASE + 5)
UINT  ERROR_INTERNET_UNRECOGNIZED_SCHEME = (INTERNET_ERROR_BASE + 6)
UINT  ERROR_INTERNET_NAME_NOT_RESOLVED = (INTERNET_ERROR_BASE + 7)
UINT  ERROR_INTERNET_PROTOCOL_NOT_FOUND = (INTERNET_ERROR_BASE + 8)
UINT  ERROR_INTERNET_INVALID_OPTION = (INTERNET_ERROR_BASE + 9)
UINT  ERROR_INTERNET_BAD_OPTION_LENGTH = (INTERNET_ERROR_BASE + 10)
UINT  ERROR_INTERNET_OPTION_NOT_SETTABLE = (INTERNET_ERROR_BASE + 11)
UINT  ERROR_INTERNET_SHUTDOWN = (INTERNET_ERROR_BASE + 12)
UINT  ERROR_INTERNET_INCORRECT_USER_NAME = (INTERNET_ERROR_BASE + 13)
UINT  ERROR_INTERNET_INCORRECT_PASSWORD = (INTERNET_ERROR_BASE + 14)
UINT  ERROR_INTERNET_LOGIN_FAILURE = (INTERNET_ERROR_BASE + 15)
UINT  ERROR_INTERNET_INVALID_OPERATION = (INTERNET_ERROR_BASE + 16)
UINT  ERROR_INTERNET_OPERATION_CANCELLED = (INTERNET_ERROR_BASE + 17)
UINT  ERROR_INTERNET_INCORRECT_HANDLE_TYPE = (INTERNET_ERROR_BASE + 18)
UINT  ERROR_INTERNET_INCORRECT_HANDLE_STATE = (INTERNET_ERROR_BASE + 19)
UINT  ERROR_INTERNET_NOT_PROXY_REQUEST = (INTERNET_ERROR_BASE + 20)
UINT  ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND = (INTERNET_ERROR_BASE + 21)
UINT  ERROR_INTERNET_BAD_REGISTRY_PARAMETER = (INTERNET_ERROR_BASE + 22)
UINT  ERROR_INTERNET_NO_DIRECT_ACCESS = (INTERNET_ERROR_BASE + 23)
UINT  ERROR_INTERNET_NO_CONTEXT = (INTERNET_ERROR_BASE + 24)
UINT  ERROR_INTERNET_NO_CALLBACK = (INTERNET_ERROR_BASE + 25)
UINT  ERROR_INTERNET_REQUEST_PENDING = (INTERNET_ERROR_BASE + 26)
UINT  ERROR_INTERNET_INCORRECT_FORMAT = (INTERNET_ERROR_BASE + 27)
UINT  ERROR_INTERNET_ITEM_NOT_FOUND = (INTERNET_ERROR_BASE + 28)
UINT  ERROR_INTERNET_CANNOT_CONNECT = (INTERNET_ERROR_BASE + 29)
UINT  ERROR_INTERNET_CONNECTION_ABORTED = (INTERNET_ERROR_BASE + 30)
UINT  ERROR_INTERNET_CONNECTION_RESET = (INTERNET_ERROR_BASE + 31)
UINT  ERROR_INTERNET_FORCE_RETRY = (INTERNET_ERROR_BASE + 32)
UINT  ERROR_INTERNET_INVALID_PROXY_REQUEST = (INTERNET_ERROR_BASE + 33)
UINT  ERROR_INTERNET_NEED_UI = (INTERNET_ERROR_BASE + 34)
UINT  ERROR_INTERNET_HANDLE_EXISTS = (INTERNET_ERROR_BASE + 36)
UINT  ERROR_INTERNET_SEC_CERT_DATE_INVALID = (INTERNET_ERROR_BASE + 37)
UINT  ERROR_INTERNET_SEC_CERT_CN_INVALID = (INTERNET_ERROR_BASE + 38)
UINT  ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR = (INTERNET_ERROR_BASE + 39)
UINT  ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR = (INTERNET_ERROR_BASE + 40)
UINT  ERROR_INTERNET_MIXED_SECURITY = (INTERNET_ERROR_BASE + 41)
UINT  ERROR_INTERNET_CHG_POST_IS_NON_SECURE = (INTERNET_ERROR_BASE + 42)
UINT  ERROR_INTERNET_POST_IS_NON_SECURE = (INTERNET_ERROR_BASE + 43)
UINT  ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED = (INTERNET_ERROR_BASE + 44)
UINT  ERROR_INTERNET_INVALID_CA = (INTERNET_ERROR_BASE + 45)
UINT  ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP = (INTERNET_ERROR_BASE + 46)
UINT  ERROR_INTERNET_ASYNC_THREAD_FAILED = (INTERNET_ERROR_BASE + 47)
UINT  ERROR_INTERNET_REDIRECT_SCHEME_CHANGE = (INTERNET_ERROR_BASE + 48)
UINT  ERROR_INTERNET_DIALOG_PENDING = (INTERNET_ERROR_BASE + 49)
UINT  ERROR_INTERNET_RETRY_DIALOG = (INTERNET_ERROR_BASE + 50)
UINT  ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR = (INTERNET_ERROR_BASE + 52)
UINT  ERROR_INTERNET_INSERT_CDROM = (INTERNET_ERROR_BASE + 53)

// FTP API errors
UINT  ERROR_FTP_TRANSFER_IN_PROGRESS = (INTERNET_ERROR_BASE + 110)
UINT  ERROR_FTP_DROPPED = (INTERNET_ERROR_BASE + 111)
UINT  ERROR_FTP_NO_PASSIVE_MODE = (INTERNET_ERROR_BASE + 112)

// additional Internet API error codes
UINT  ERROR_INTERNET_SECURITY_CHANNEL_ERROR = (INTERNET_ERROR_BASE + 157)
UINT  ERROR_INTERNET_UNABLE_TO_CACHE_FILE = (INTERNET_ERROR_BASE + 158)
UINT  ERROR_INTERNET_TCPIP_NOT_INSTALLED = (INTERNET_ERROR_BASE + 159)
UINT  ERROR_INTERNET_DISCONNECTED = (INTERNET_ERROR_BASE + 163)
UINT  ERROR_INTERNET_SERVER_UNREACHABLE = (INTERNET_ERROR_BASE + 164)
UINT  ERROR_INTERNET_PROXY_SERVER_UNREACHABLE = (INTERNET_ERROR_BASE + 165)
UINT  ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT = (INTERNET_ERROR_BASE + 166)
UINT  ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT = (INTERNET_ERROR_BASE + 167)
UINT  ERROR_INTERNET_SEC_INVALID_CERT = (INTERNET_ERROR_BASE + 169)
UINT  ERROR_INTERNET_SEC_CERT_REVOKED = (INTERNET_ERROR_BASE + 170)

STRING   ls_errortext

ULong lul_errorcode, lul_buffSize

BOOLEAN  lb_rc

lul_errorcode = GetLastError ()

CHOOSE CASE lul_errorcode
   CASE ERROR_INTERNET_OUT_OF_HANDLES
      ls_errortext = "더이상의 핸들은 이번에 생성될 수 없었습니다."
   CASE ERROR_INTERNET_TIMEOUT
      ls_errortext = "요청 시간이 초과되었습니다."
   CASE ERROR_INTERNET_EXTENDED_ERROR
      InternetGetLastResponseInfo (lul_errorcode, ls_errortext, lul_buffSize)
      IF lul_buffSize>0 THEN
         ls_errortext = Space (lul_buffSize + 1)
         lb_rc = InternetGetLastResponseInfo (lul_errorcode, ls_errortext, lul_buffSize)
         IF lb_rc=FALSE THEN
            ls_errortext = "확장된 오류는 서버에서 반환했습니다. 오류 텍스트를 검색할 수 InternetGetLastResponseInfo에 대한 호출에 실패했습니다."
         End IF
      Else
         ls_errortext = "확장된 오류는 서버에서 반환했습니다. 오류 텍스트를 검색할 수 InternetGetLastResponseInfo에 대한 호출에 실패했습니다."
      End IF
   CASE ERROR_INTERNET_INTERNAL_ERROR
      ls_errortext = "내부 오류가 발생했습니다."
   CASE ERROR_INTERNET_INVALID_URL
      ls_errortext = "URL이 잘못되었습니다."
   CASE ERROR_INTERNET_UNRECOGNIZED_SCHEME
      ls_errortext = "URL이 스키마 또는 인식되지 않을 수 있습니다."
   CASE ERROR_INTERNET_NAME_NOT_RESOLVED
      ls_errortext = "서버 이름을 확인할 수없습니다."
   CASE ERROR_INTERNET_PROTOCOL_NOT_FOUND
      ls_errortext = "요청한 프로토콜을 찾을 수없습니다."
   CASE ERROR_INTERNET_INVALID_OPTION
      ls_errortext = "InternetQueryOption 또는 InternetSetOption에 대한 요청이 잘못된 옵션 값을 지정합니다."
   CASE ERROR_INTERNET_BAD_OPTION_LENGTH
      ls_errortext = "옵션 InternetQueryOption 또는 InternetSetOption 공급의 길이 옵션의 유형을 지정에 대한 잘못된 것입니다."
   CASE ERROR_INTERNET_OPTION_NOT_SETTABLE
      ls_errortext = "요청 옵션 쿼리에만 설정할 수없습니다."
   CASE ERROR_INTERNET_SHUTDOWN
      ls_errortext = "인터넷 기능을 지원하고있다는 Win32 폐쇄 또는 하역."
   CASE ERROR_INTERNET_INCORRECT_USER_NAME
      ls_errortext = "이 요청을 연결하고 FTP 서버에 로그에 완료되지 않을 수있는 이유는 제공된 사용자 이름이 올바르지 않습니다."
   CASE ERROR_INTERNET_INCORRECT_PASSWORD
      ls_errortext = "이 요청에 연결하고 FTP 서버에 로그인할 때 비밀 번호가 완료되지 않을 수 있기 때문에 공급은 잘못된 것입니다."
   CASE ERROR_INTERNET_LOGIN_FAILURE
      ls_errortext = "이 요청에있는 FTP 서버에 로그인하여에 연결하는 데 실패했다."
   CASE ERROR_INTERNET_INVALID_OPERATION
      ls_errortext = "요청한 작업이 잘못되었습니다."
   CASE ERROR_INTERNET_OPERATION_CANCELLED
      ls_errortext = "'핸들은 일반적으로 운영하기 때문에 작업이 완료되기 전에는 요청을 처리할 폐쇄됐다'가 취소됐다."
   CASE ERROR_INTERNET_INCORRECT_HANDLE_TYPE
      ls_errortext = "'공급이 작업에 대한 핸들이 올바르지 않습니다'의 유형입니다."
   CASE ERROR_INTERNET_INCORRECT_HANDLE_STATE
      ls_errortext = "제공된 처리하기 때문에 요청한 작업을 수행하실 수없습니다 올바른 상태에 있지 않습니다."
   CASE ERROR_INTERNET_NOT_PROXY_REQUEST
      ls_errortext = "요청이 프록시를 통해 만들 어질 수없습니다."
   CASE ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND
      ls_errortext = "필요한 레지스트리 값을 찾을 수없습니다."
   CASE ERROR_INTERNET_BAD_REGISTRY_PARAMETER
      ls_errortext = "필요한 레지스트리 값을있는 것이었지만 잘못된 유형입니다거나 잘못된 값이있습니다."
   CASE ERROR_INTERNET_NO_DIRECT_ACCESS
      ls_errortext = "직접 네트워크 액세스를이 시간에 만들 어질 수없습니다."
   CASE ERROR_INTERNET_NO_CONTEXT
      ls_errortext = "제로 컨텍스트 값 때문에 제공된 비동기 요청할수 없습니다."
   CASE ERROR_INTERNET_NO_CALLBACK
      ls_errortext = "그 이유는 콜백 함수를 설정되지 않은 비동기 요청을 만들 수없습니다."
   CASE ERROR_INTERNET_REQUEST_PENDING
      ls_errortext = "필요한 작업을하기 때문에 하나 이상의 보류중인 요청을 완료할 수없습니다."
   CASE ERROR_INTERNET_INCORRECT_FORMAT
      ls_errortext = "요청의 형식이 잘못되었습니다."
   CASE ERROR_INTERNET_ITEM_NOT_FOUND
      ls_errortext = "요청한 항목을 찾을 수없습니다."
   CASE ERROR_INTERNET_CANNOT_CONNECT
      ls_errortext = "그 시도는 서버에 연결하는 데 실패했다."
   CASE ERROR_INTERNET_CONNECTION_ABORTED
      ls_errortext = "서버와의 연결이 종료되었습니다."
   CASE ERROR_INTERNET_CONNECTION_RESET
      ls_errortext = "서버와의 연결이 재설정되었습니다."
   CASE ERROR_INTERNET_FORCE_RETRY
      ls_errortext = "Win32 인터넷 함수 호출에 대한 요청을 고쳤습니다."
   CASE ERROR_INTERNET_INVALID_PROXY_REQUEST
      ls_errortext = "프록시에 대한 요청이 잘못되었습니다."
   CASE ERROR_INTERNET_HANDLE_EXISTS
      ls_errortext = "핸들이 이미 존재하기 때문에 요청이 실패했습니다."
   CASE ERROR_INTERNET_SEC_CERT_DATE_INVALID
      ls_errortext = "서버에서 SSL 인증서를받은 날짜가 좋지 않습니다.~r~n~r~n인증서가 만료됩니다."
   CASE ERROR_INTERNET_SEC_CERT_CN_INVALID
      ls_errortext = "SSL 인증서 공통 이름 (호스트 이름 필드)가 올바르지 않습니다.~r~n~r~n예를 들어, 일반적인 경우와 이름을 입력 www.server.com~r~n~r~n" + &
            "인증서에 www.different.com 말한다."
   CASE ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR
      ls_errortext = "응용 프로그램이 아닌 움직이는 - SSL을 리디렉션 때문에 SSL 연결합니다."
   CASE ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR
      ls_errortext = "이 애플 리케이션이 SSL에서 리디렉션 때문에 비 - SSL 연결로 이동합니다."
   CASE ERROR_INTERNET_MIXED_SECURITY
      ls_errortext = "그 내용은 안전하지 않은 전적을 나타냅니다.~r~n~r~n일부 콘텐츠의 무담보 본 서버에서 ON되어 있습니다."
   CASE ERROR_INTERNET_CHG_POST_IS_NON_SECURE
      ls_errortext = "응용 프로그램을 게시하고 안전하지 않은 서버에 텍스트의 여러 라인을 변경하려고 시도합니다."
   CASE ERROR_INTERNET_POST_IS_NON_SECURE
      ls_errortext = "응용 프로그램이 안전하지 않은 세베르에 데이터를 게시합니다."
   CASE ERROR_FTP_TRANSFER_IN_PROGRESS
      ls_errortext = "요청한 작업 FTP 세션 손잡이에 만들 어질 수없습니다.~r~n~r~n작업을 이미 진행 중입니다."
   CASE ERROR_FTP_DROPPED
      ls_errortext = "세션이 중단됐다가 FTP 작업이 완료되지 않았습니다.."
   CASE Else
      ls_errortext = "알수 없는 오류가 발생했습니다: " + string (lul_errorcode)
END CHOOSE

RETURN   ls_errortext
end function

public function integer uf_ftp_connect ();Application	la_app

la_app = GetApplication ()

iul_internet = InternetOpen (la_app.AppName, INTERNET_OPEN_TYPE_PRECONFIG, null_s, null_s, 0)
IF	f_null (iul_internet) OR iul_internet=0	Then
	MessageBox ('INIT 오류', uf_GetLastError ())
	RETURN -1
End If

DO WHILE TRUE
	iul_session = InternetConnect (iul_internet, is_ip, ii_port, is_user, is_pwd, INTERNET_SERVICE_FTP, 0, 0)
	IF	f_null (iul_session) OR iul_session=0	Then
		IF	f_messageBox ('FTP', uf_GetLastError ())=1	Then
			RETURN -1
		End IF
	Else
		EXIT
	End If
LOOP

IF	f_nvl (is_path,'/')<>'/'	Then
	IF	FtpSetCurrentDirectory (iul_session, is_path)=FALSE	Then
		IF	FtpCreateDirectory (iul_session, is_path)=FALSE	Then
			MessageBox ('Directory 오류' + is_path, uf_GetLastError ())
			RETURN -1
		Else
			FtpSetCurrentDirectory (iul_session, is_path)
		End IF
	End If
End IF

RETURN 1
end function

public function string uf_ftp_writefile ();CONSTANT ULong GENERIC_READ = 2147483648
CONSTANT ULong GENERIC_WRITE = 1073741824
CONSTANT ULong FILE_SHARE_READ = 1
CONSTANT ULong OPEN_EXISTING = 3

ULong lul_file, lul_hFile
ULong lul_bufsize = 32000, lul_LoadSize
ULong lul_bytesread, lul_byteswritten

BLOB  lblob_buffer

LONG  ll, ll_writefile, ll_FileSize

IF	NOT fileexists (is_local_path + is_name)	then
	RETURN   '화일을 찾을 수가 없습니다.~r작업을 취소합니다.'
End IF

ll_FileSize = FileLength (is_local_path + is_name)
lul_file = CreateFile (is_local_path + is_name, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
IF lul_file>0   Then
	lul_hFile = FtpOpenFile (iul_session, is_name, GENERIC_WRITE, ii_transfer_type, 0)
	DO WHILE TRUE
		lblob_buffer = blob (space (lul_bufsize))
		ReadFile (lul_file, lblob_buffer, lul_bufsize, lul_bytesread, 0)
		IF lul_bytesread=0   Then
			EXIT
		Else
			InternetWriteFile (lul_hFile, lblob_buffer, lul_bytesread, lul_byteswritten)
			lul_LoadSize += lul_bytesread
			IF	ll_FileSize>0	Then
				IF isValid (ihpb)     THEN ihpb.position = INT (lul_LoadSize / ll_FileSize * 100)
				IF isValid (ist_Text) THEN ist_Text.Text = is_st_text + f_ntrim (lul_LoadSize,0,0) + ' / ' + f_ntrim (ll_FileSize,0,0) + ' (' + f_ntrim (lul_LoadSize/ll_FileSize*100,1,0) + '%)'
			End IF
		End IF
	LOOP
	IF isValid (ihpb)     THEN ihpb.position = 100
	IF isValid (ist_Text) THEN ist_Text.Text = is_st_text + f_ntrim (ll_FileSize,0,0) + ' / ' + f_ntrim (ll_FileSize,0,0) + ' (100.0%)'
	CloseHandle (lul_file)
	InternetCloseHandle (lul_hFile)
	RETURN ''
Else
	RETURN   uf_GetLastError ()
End IF
end function

public function string uf_ftp_readfile ();CONSTANT ULong GENERIC_READ = 2147483648

INT   li_fnum

BOOLEAN  lb_rtn

ULong lul_hFile, lul_bytesread, lul_bufsize = 32000
ULong ll_FileSize, lul_sizehigh, lul_totalread

STRING   ls_response, ls_buffer

BLOB  lblob_buffer

LONG  rtn

// 파일열기
lul_hFile = FtpOpenFile (iul_session, is_name, GENERIC_READ, ii_transfer_type, 0)
IF lul_hFile>0   Then
   ll_FileSize = FtpGetFileSize (lul_hFile, lul_SizeHigh)
   IF FileExists (is_local_path + is_name) THEN FileDelete (is_local_path + is_name)
   li_fnum = FileOpen (is_local_path + is_name, StreamMode!, Write!, LockReadWrite!, Append!)
   DO WHILE TRUE
      lblob_buffer = blob (Space (lul_bufsize))
      InternetReadFile (lul_hFile, lblob_buffer, lul_bufsize, lul_bytesread)
      IF lul_bytesread=0   Then
         EXIT
      Else
         //파일 쓰기
         FileWrite (li_fnum, BlobMid (lblob_buffer, 1, lul_bytesread) )
         lul_totalread += lul_bytesread
			IF	ll_FileSize>0	Then
				IF isValid (ihpb)     THEN ihpb.position = integer (lul_totalread / ll_FileSize * 100)
				IF isValid (ist_Text) THEN ist_Text.Text = is_st_text + f_ntrim (lul_totalread,0,0) + ' / ' + f_ntrim (ll_FileSize,0,0) + ' (' + f_ntrim (lul_totalread/ll_FileSize * 100,1,0) + '%)'
			End IF
      End IF
   LOOP
	IF isValid (ihpb)     THEN ihpb.position = 100
	IF isValid (ist_Text) THEN ist_Text.Text = is_st_text + f_ntrim (ll_FileSize,0,0) + ' / ' + f_ntrim (ll_FileSize,0,0) + ' (100.0%)'
   InternetCloseHandle (lul_hFile)
   FileClose (li_fnum)
   RETURN ''
Else
   RETURN   uf_GetLastError ()
End IF
end function

public function string uf_ftp_deletefile ();IF	FtpDeleteFile (iul_session, is_name)	Then
	RETURN ''
Else
	RETURN	uf_GetLastError ()
End IF
end function

public function string uf_ftp_getcurrentdirectory ();ULong	lul_buflen = 256

is_path = Space(lul_buflen)

IF	FtpGetCurrentDirectory (iul_session, is_path, lul_buflen)	Then
	RETURN ''
Else
	RETURN	uf_GetLastError ()
End IF
end function

public function string uf_ftp_putfile ();IF	FtpPutFile (iul_session, is_path + is_name, is_name, ii_transfer_type, 0)	Then
	RETURN ''
Else
	RETURN	uf_GetLastError ()
End IF
end function

public subroutine uf_ftp_disconnect ();IF	iul_session > 0	Then
	IF	NOT InternetCloseHandle (iul_session)	THEN MessageBox (ClassName(), uf_GetLastError (), StopSign!)
End IF
IF	iul_internet > 0	Then
	IF	NOT InternetCloseHandle (iul_internet)	THEN MessageBox (ClassName(), uf_GetLastError (), StopSign!)
End IF
end subroutine

public function string uf_ftp_getfile ();IF	FtpGetFile (iul_session, is_name, is_path + is_name, FALSE, 0, ii_transfer_type, 0)	Then
	RETURN ''
Else
	RETURN	uf_GetLastError ()
End IF
end function

public function integer uf_file_check ();CONSTANT ULong	GENERIC_READ = 2147483648

ULong	lul_hFile

// 파일점검
IF	uf_FTP_Connect ()>0	Then
	lul_hFile = FtpOpenFile (iul_session, 'load_'+is_name, GENERIC_READ, ii_transfer_type, 0)
   InternetCloseHandle (lul_hFile)
	IF	lul_hFile>0	Then
		RETURN 1
	Else
		RETURN 0
	End IF
Else
	RETURN 0
End IF
end function

public function integer uf_ftp_changedirectory ();IF	FtpSetCurrentDirectory (iul_session, is_path)=FALSE	Then
	IF	FtpCreateDirectory (iul_session, is_path)=FALSE	Then
		MessageBox ('Directory 오류' + is_path, uf_GetLastError ())
		RETURN -1
	Else
		FtpSetCurrentDirectory (iul_session, is_path)
	End IF
End If
RETURN 1
end function

on uo_wininet.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_wininet.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

