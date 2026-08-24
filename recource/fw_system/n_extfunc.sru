forward
global type n_extfunc from nonvisualobject
end type
end forward

global type n_extfunc from nonvisualobject
end type
global n_extfunc n_extfunc

type prototypes
function Long biznode1te(uInt input1, String input2, Ref String output1) library "node4bizlib.dll" Alias For "biznode1te;Ansi"
function Long biznode2te(uInt input1, String input2, String input3, Ref String output1) library "node4bizlib.dll" Alias For "biznode2te;Ansi"
function Long biznode3te(uInt input1, String input2, Long input3, Ref String output1) library "node4bizlib.dll" Alias For "biznode3te;Ansi"
function Long biznode11te(uInt input1, ulong hWnd, String input2, Ref fw_s_node4value syntax) library "node4bizlib.dll" Alias For "biznode11te;Ansi"
function string biz_replaceall(string lpszoriginal, string lpszpattern, string lpszreplacement) library "node4bizlib.dll" alias for "biz_replaceall;Ansi"

function long biz_setmdiclientborder(ulong hWnd, long index ) library "node4bizlib.dll" Alias For "biz_setmdiclientborder;Ansi"
function boolean biz_wintransparentcolor(ulong hWnd, long trspColor, byte alpha, boolean state) library "node4bizlib.dll" alias for "biz_wintransparentcolor;Ansi"
function boolean biz_winroundrect(ulong hWnd, int x1, int y1, int x2, int y2, int x3, int y3) library "node4bizlib.dll" alias for "biz_winroundrect;Ansi"
function long biz_gethostname(ref string hostname, long length) library "node4bizlib.dll" alias for "biz_gethostname;Ansi"
function long biz_getipaddress(ref string ipaddress, long length) library "node4bizlib.dll" alias for "biz_getipaddress;Ansi"
function long biz_getmacaddress(ref string macaddress, long length) library "node4bizlib.dll" alias for "biz_getmacaddress;Ansi"
function long biz_setwindowsbackgroundimage(ulong hWnd, ref string backgroundimage) library "node4bizlib.dll" alias for "biz_getmacaddress;Ansi"

function long biz_setsystemcolor(ulong a1, ulong a2, ulong a3, ulong a4, ulong a5, ulong a6, ulong a7, ulong a8, ulong a9, ulong a10, ulong a11, ulong a12, ulong a13, ulong a14, ulong a15, ulong a16, ulong a17, ulong a18, ulong a19, ulong a20, ulong a21, ulong a22, ulong a23, ulong a24, ulong a25, ulong a26, ulong a27, ulong a28, ulong a29, ulong a30) library "node4bizlib.dll" alias for "biz_setsystemcolor;Ansi"
function long biz_setdefaultsystemcolor() library "node4bizlib.dll" alias for "biz_setdefaultsystemcolor;Ansi"

function long biz_setmouseoverbtnimg(string source_img_path, string target_img_path) library "node4bizlib.dll" alias for "biz_setmouseoverbtnimg;Ansi"
function long biz_setclickedbtnimg(string source_img_path, string target_img_path) library "node4bizlib.dll" alias for "biz_setclickedbtnimg;Ansi"
function long biz_setdisabledbtnimg(string source_img_path, string target_img_path) library "node4bizlib.dll" alias for "biz_setdisabledbtnimg;Ansi"
function long biz_setpicturebtnimg(string icon_name, string target_img_path, long button_width, long button_height, boolean enabled) library "node4bizlib.dll" alias for "biz_setpicturebtnimg;Ansi"
function long biz_setgradientbackdropimg(string target_img_path, int obj_width, int obj_height) library "node4bizlib.dll" alias for "biz_setgradientbackdropimg;Ansi"
function long biz_getimgsize(string lpctImagePath, ref pf_s_size imageSize) library "node4bizlib.dll" alias for "biz_getimgsize;Ansi"
function long biz_setresizeimg(string as_sourceImagePath, string as_targetImagePath, long basePixelX, long basePixelY, long resizeWidth, long resizeHeight) library "node4bizlib.dll" alias for "biz_setresizeimg;Ansi"
function long biz_setresizeimgw(string as_sourceImagePath, string as_targetImagePath, long basePixelX, long basePixelY, long resizeWidth, long resizeHeight) library "node4bizlib.dll" alias for "biz_setresizeimgw"
function long biz_compositebackdropimg(string as_sourceImagePath, string as_targetImagePath, string as_backgroundImagePath, long ai_backgroundtop, long ai_backgroundleft) library "node4bizlib.dll" alias for "biz_compositebackdropimg;Ansi"
function long biz_cropimage(string as_sourceImagePath, string as_targetImagePath, long ai_left, long ai_top, long ai_width, long ai_height) library "node4bizlib.dll" alias for "biz_cropimage;Ansi"
function boolean biz_setbackdroptransparent(ulong hWnd, ref pf_s_rect srect, string lpszSourcePath, string lpszTargetPath) library "node4bizlib.dll" alias for "biz_setbackdroptransparent;Ansi"
function int biz_setcommandbtnoverlayimg(string szSourceImage, string szTargetImage, int nCBWidth, int nCBHeight, string szCBText, int nFontSize, int nFontWeight, ulong nFontColor, ulong fdwItalic, ulong fdwUnderline, ulong fdwCharSet, ulong fdwPitch, ulong fdwFamily, string szFontFace) library "node4bizlib.dll" alias for "biz_setcommandbtnoverlayimg;Ansi"
function int biz_setcommandbtnoverlayimgw(string szSourceImage, string szTargetImage, int nCBWidth, int nCBHeight, string szCBText, int nFontSize, int nFontWeight, ulong nFontColor, ulong fdwItalic, ulong fdwUnderline, ulong fdwCharSet, ulong fdwPitch, ulong fdwFamily, string szFontFace) library "node4bizlib.dll" alias for "biz_setcommandbtnoverlayimgw"
function int biz_setcommandbtnimgw(string szSourceImage, string szTargetImage, int nCBWidth, int nCBHeight, string szCBText, int nFontSize, int nFontWeight, ulong nFontColor, ulong fdwItalic, ulong fdwUnderline, ulong fdwCharSet, ulong fdwPitch, ulong fdwFamily, string szFontFace, string szIconFile) library "node4bizlib.dll" alias for "biz_setcommandbtnimgw"

function integer biz_seed128encrypt(string userkey, string plaintext, ref string encrypedtext) library "node4bizlib.dll" alias for "biz_seed128encrypt;Ansi"
function integer biz_seed128decrypt(string userkey, string encryptedtext, ref string plaintext) library "node4bizlib.dll" alias for "biz_seed128decrypt;Ansi"
function integer biz_sha256hash(string lpszplaintext, ref string lpszhashedtext) library "node4bizlib.dll" alias for "biz_sha256hash;Ansi"
function boolean biz_md5hash(string lpszplaintext, ref string lpszhashedtext) library "node4bizlib.dll" alias for "biz_md5hash;Ansi"
function long biz_seturiencode(blob input, ref string output) library "node4bizlib.dll" alias for "biz_uriencode;Ansi"
function long biz_seturidecode(string input, ref blob output) library "node4bizlib.dll" alias for "biz_uridecode;Ansi"
function long biz_urldownload2file(string lpszurl, string lpszlocalfile) library "node4bizlib.dll" alias for "biz_urldownloadtofile;Ansi"
function uint biz_bitwise_or_uint(uint op1, uint op2) library "node4bizlib.dll"
function ulong biz_bitwise_or_ulong(ulong op1, ulong op2) library "node4bizlib.dll"
function uint biz_bitwise_and_uint(uint op1, uint op2) library "node4bizlib.dll"
function ulong biz_bitwise_and_ulong(ulong op1, ulong op2) library "node4bizlib.dll"
function uint biz_bitwise_xor_uint(uint op1, uint op2) library "node4bizlib.dll"
function ulong biz_bitwise_xor_ulong(ulong op1, ulong op2) library "node4bizlib.dll"
function uint biz_bitwise_not_uint(uint op1) library "node4bizlib.dll"
function ulong biz_bitwise_not_ulong(ulong op1) library "node4bizlib.dll"
function uint biz_bitwise_rshift_uint(uint op1, int cnt) library "node4bizlib.dll"
function ulong biz_bitwise_rshift_ulong(ulong op1, int cnt) library "node4bizlib.dll"
function uint biz_bitwise_lshift_uint(uint op1, int cnt) library "node4bizlib.dll"
function ulong biz_bitwise_lshift_ulong(ulong op1, int cnt) library "node4bizlib.dll"

function long biz_gettextsize(ulong hWnd, string szText, string szFontFace, long fontSize, long fontWeight, ref pf_s_size textSize) library "node4bizlib.dll" alias for "biz_gettextsize;Ansi"
function long biz_gettextsize_w(ulong hWnd, string szText, string szFontFace, long fontSize, long fontWeight, ref pf_s_size textSize) library "node4bizlib.dll" alias for "biz_gettextsize_w"
function long biz_gettextsize_ex(ulong hWnd, string szText, string szFontFace, int fontSize, int fontWeight, ulong fdwFamily, ulong fdwPitch, ulong  fdwCharSet, ref pf_s_size textSize) library "node4bizlib.dll" alias for "biz_gettextsize_ex;Ansi"
function long biz_string2hex(string input, ref string output) library "node4bizlib.dll" alias for "biz_string2hex;Ansi"
function long biz_hex2string(string input, ref string output) library "node4bizlib.dll" alias for "biz_hex2string;Ansi"
function boolean biz_getfilewritetime(string lpszFileName, ref string lpszWriteTime) library "node4bizlib.dll" Alias For "biz_getfilewritetime;Ansi"
function boolean biz_setfilewritetime(string lpszFileName, string lpszWriteTime) library "node4bizlib.dll" Alias For "biz_setfilewritetime;Ansi"
function ulong biz_getfilesize(string lpszFilename) library "node4bizlib.dll" alias for "biz_getfilesize;Ansi"

function long biz_enablesendmessage() library "node4bizlib.dll" alias for "biz_enablesendmessage;ansi"
function long biz_disablesendmessage() library "node4bizlib.dll" alias for "biz_disablesendmessage;ansi"
function long biz_setclipboardtobitmap(string lpFileName) library "node4bizlib.dll" alias for "biz_setclipboardtobitmap;ansi"

function boolean biz_getbackdropcontrolimg(ulong hWnd, ref pf_s_rect srect, string lpszTargetPath) library "node4bizlib.dll" alias for "biz_getbackdropcontrolimg;ansi"
function int biz_rescaleimage(string sourceImage, int imageWidth, int imageHeight, string resizedImage) library "node4bizlib.dll" alias for "biz_rescaleimage;Ansi"

function int biz_convertimageformat(string sourceImage, string targetImage) library "node4bizlib.dll" alias for "biz_convertimageformat;Ansi"
function int biz_convertwmftobmp(string sourceImage, string targetImage) library "node4bizlib.dll" alias for "biz_convertwmftobmp;Ansi"

function ulong biz_compress(ref blob bTarget, ulong nTargetSize, ref blob bSource, ulong nSourceSize) library "node4bizlib.dll" alias for "biz_compress"
function ulong biz_uncompress(ref blob bTarget, ulong nTargetSize, ref blob bSource, ulong nSourceSize) library "node4bizlib.dll" alias for "biz_uncompress"
function ulong biz_compressfile(string lpszSource, string lpszDestination) library "node4bizlib.dll" alias for "biz_compressfile;ansi"
function ulong biz_uncompressfile(string lpszSource, string lpszDestination) library "node4bizlib.dll" alias for "biz_uncompressfile;ansi"

function boolean biz_http_ping(string lpszURL, uint nTimeout) library "node4bizlib.dll" alias for "biz_http_ping;Ansi"
function int biz_http_escape(string lpszURL, ref string lpszescaped) library "node4bizlib.dll" alias for "biz_http_escape;Ansi"
function int biz_http_unescape(string lpszURL, ref string lpszUnescaped) library "node4bizlib.dll" alias for "biz_http_unescape;Ansi"
function int biz_http_globaldefault() library "node4bizlib.dll"
function int biz_http_globalcleanup() library "node4bizlib.dll"
function int biz_http_addformfield(int nFormType, string lpszItemName, string lpszItemValue) library "node4bizlib.dll" alias for "biz_http_addformfield;Ansi"
function int biz_http_addhttpheader(string lpszHeader) library "node4bizlib.dll" alias for "biz_http_addhttpheader;Ansi"
function int biz_http_setpostfields(string lpszPostFields) library "node4bizlib.dll" alias for "biz_http_setpostfields;Ansi"
function double biz_http_uploadprogress_now() library "node4bizlib.dll"
function double biz_http_uploadprogress_total() library "node4bizlib.dll"
function double biz_http_downloadprogress_now() library "node4bizlib.dll"
function double biz_http_downloadprogress_total() library "node4bizlib.dll"
function string biz_http_getresponsefromupload() library "node4bizlib.dll" alias for "biz_http_getresponsefromupload;Ansi"
function int biz_http_speedupload(ref double nBytesPerSec) library "node4bizlib.dll"
function int biz_http_speeddownload(ref double nBytesPerSec) library "node4bizlib.dll"
function long biz_http_getinfo_long(int nInfoType) library "node4bizlib.dll"
function double biz_http_getinfo_double(int nInfoType) library "node4bizlib.dll"
function string biz_http_getinfo_char(int nInfoType) library "node4bizlib.dll"
function int biz_http_sendmail(string szURL, string szAddFiles[10], int nFileCnt) library "node4bizlib.dll" alias for "biz_http_sendmail;Ansi"
function int biz_http_filedownload(string lpszURL, string lpszFilename) library "node4bizlib.dll" alias for "biz_http_filedownload;Ansi"
function int biz_http_fileupload(string lpszURL, string lpszFilename) library "node4bizlib.dll" alias for "biz_http_fileupload;Ansi"
function int biz_http_openupload(string lpszURL, string lpszFilename) library "node4bizlib.dll" alias for "biz_http_openupload;Ansi"
function int biz_http_opendownload(string lpszURL, string lpszFilename) library "node4bizlib.dll" alias for "biz_http_opendownload;Ansi"
function int biz_http_send() library "node4bizlib.dll"
function int biz_http_post_request(string lpszDownloadURL, string lpszPostFields, string lpszSaveAsFilename) library "node4bizlib.dll" alias for "biz_http_post_request;Ansi"
function int biz_http_multipart_upload(ulong hWnd, string lpszDownloadURL, string lpszPostFields, string lpszFilename) library "node4bizlib.dll" alias for "biz_http_multipart_upload;Ansi"
function int biz_http_getresultcode() library "node4bizlib.dll"
function string biz_http_geterrormessage(int nErrorNumb) library "node4bizlib.dll" alias for "biz_http_geterrormessage;Ansi"
function string biz_http_getlasterror() library "node4bizlib.dll" alias for "biz_http_getlasterror;Ansi"
function int biz_http_checkrunningstatus() library "node4bizlib.dll"
function int biz_http_close() library "node4bizlib.dll"
function int biz_http_abort() library "node4bizlib.dll"

function int biz_setcapture4jpgw(ulong hWnd, string sztargetpath, int nquality) library "node4bizlib.dll" alias for "biz_setcapture4jpgw"
function int biz_setcapture4pngw(ulong hWnd, string sztargetpath) library "node4bizlib.dll" alias for "biz_setcapture4pngw"

// ez.smart
function string  ez_urlencode_component(string lpszurlencode) library "ezservicepb233.dll" alias for "ez_urlencode_component;Ansi"

function ulong ez_getfilesize(string lpszFilename) library "ezservicepb233.dll" alias for "ez_getfilesize;Ansi"

function boolean  ez_http_ping(string lpszURL, uint nTimeout) library "ezservicepb233.dll" alias for "ez_http_ping;Ansi"
function int  ez_http_escape(string lpszURL, ref string lpszescaped) library "ezservicepb233.dll" alias for "ez_http_escape;Ansi"
function int  ez_http_unescape(string lpszURL, ref string lpszUnescaped) library "ezservicepb233.dll" alias for "ez_http_unescape;Ansi"
function int  ez_http_globaldefault() library "ezservicepb233.dll"
function int  ez_http_globalcleanup() library "ezservicepb233.dll"
function int  ez_http_addformfield(int nFormType, string lpszItemName, string lpszItemValue) library "ezservicepb233.dll" alias for "ez_http_addformfield;Ansi"
function int  ez_http_addhttpheader(string lpszHeader) library "ezservicepb233.dll" alias for "ez_http_addhttpheader;Ansi"
function int  ez_http_setpostfields(string lpszPostFields) library "ezservicepb233.dll" alias for "ez_http_setpostfields;Ansi"
function double  ez_http_uploadprogress_now() library "ezservicepb233.dll"
function double  ez_http_uploadprogress_total() library "ezservicepb233.dll"
function double  ez_http_downloadprogress_now() library "ezservicepb233.dll"
function double  ez_http_downloadprogress_total() library "ezservicepb233.dll"
function string  ez_http_getresponsefromupload() library "ezservicepb233.dll" alias for "ez_http_getresponsefromupload;Ansi"
function int  ez_http_speedupload(ref double nBytesPerSec) library "ezservicepb233.dll"
function int  ez_http_speeddownload(ref double nBytesPerSec) library "ezservicepb233.dll"
function long  ez_http_getinfo_long(int nInfoType) library "ezservicepb233.dll"
function double  ez_http_getinfo_double(int nInfoType) library "ezservicepb233.dll"
function string  ez_http_getinfo_char(int nInfoType) library "ezservicepb233.dll"
function int  ez_http_sendmail(string szURL, string szAddFiles[10], int nFileCnt) library "ezservicepb233.dll" alias for "ez_http_sendmail;Ansi"
function int  ez_http_filedownload(string lpszURL, string lpszFilename) library "ezservicepb233.dll" alias for "ez_http_filedownload;Ansi"
function int  ez_http_fileupload(string lpszURL, string lpszFilename) library "ezservicepb233.dll" alias for "ez_http_fileupload;Ansi"
function int  ez_http_openupload(string lpszURL, string lpszFilename) library "ezservicepb233.dll" alias for "ez_http_openupload;Ansi"
function int  ez_http_opendownload(string lpszURL, string lpszFilename) library "ezservicepb233.dll" alias for "ez_http_opendownload;Ansi"
function int  ez_http_send() library "ezservicepb233.dll"
function int  ez_http_post_request(string lpszDownloadURL, string lpszPostFields, string lpszSaveAsFilename) library "ezservicepb233.dll" alias for "ez_http_post_request;Ansi"
function int  ez_http_multipart_upload(ulong hWnd, string lpszDownloadURL, string lpszPostFields, string lpszFilename) library "ezservicepb233.dll" alias for "ez_http_multipart_upload;Ansi"
function int  ez_http_getresultcode() library "ezservicepb233.dll"
function string  ez_http_geterrormessage(int nErrorNumb) library "ezservicepb233.dll" alias for "ez_http_geterrormessage;Ansi"
function string  ez_http_getlasterror() library "ezservicepb233.dll" alias for "ez_http_getlasterror;Ansi"
function int  ez_http_checkrunningstatus() library "ezservicepb233.dll"
function int  ez_http_close() library "ezservicepb233.dll"
function int  ez_http_abort() library "ezservicepb233.dll"

// Kernel32.dll
function ULong GetTempPath (ULong nBufferLength, Ref String lpBuffer) library "kernel32.dll" Alias For "GetTempPathA;Ansi"
function ULong GetLongPathName(Ref String lpszShortPath, Ref String lpszLongPath, ULong cchBuffer ) library "kernel32.dll" Alias For "GetLongPathNameA;Ansi"
function Boolean SetCurrentDirectory(ref string lpsdir) library "Kernel32.dll" Alias For "SetCurrentDirectoryA;Ansi"
function Long GetModuleHandle(String modulename) library "kernel32.dll" Alias for "GetModuleHandleA;Ansi"
function Boolean CreateDirectory(ref string pathname,integer sa) library "kernel32.dll" Alias For "CreateDirectoryA;Ansi"
function ULong GetCurrentDirectoryA (ulong cchCurDir, ref string lpszCurDi) library "kernel32.dll" alias for "GetCurrentDirectoryA;Ansi"
function ULong SetCurrentDirectoryA (string lpszCurDi) library "kernel32.dll" alias for "SetCurrentDirectoryA;Ansi"
function ULong GetWindowsDirectoryA (ref string wdir, ulong buf) library "kernel32.dll" alias for "GetWindowsDirectoryA;Ansi"
subroutine Sleep(ulong millisecond) library "Kernel32.dll"
function boolean GetComputerName (Ref string buffer, Ref long buflen) Library "kernel32.dll" Alias For "GetComputerNameA;Ansi"
function ulong GetLastError() Library "kernel32.dll"
function ulong FormatMessage(ulong dwFlags, ulong lpSource, ulong dwMessageId, 	ulong dwLanguageId, Ref string lpBuffer, ulong nSize, ulong Arguments) Library "kernel32.dll" Alias For "FormatMessageA;Ansi"

// User32.dll
function boolean GetCursorPos(Ref pf_s_point mousepos) library "User32.dll"
function long GetClassName(ulong hwnd, ref string cname, int buf) library "User32.dll" Alias For "GetClassNameA;Ansi"
function long SetWindowLong(ULong hWnd, ULong offset, ULong attributes) library 'user32.dll' Alias For "SetWindowLongA;Ansi"
function long GetWindowLong(ULong hWnd, int nIndex) library 'user32.dll' Alias For "GetWindowLongA;Ansi"
function long SetLayeredWindowAttributes(ULong hWnd, ULong colorref, Char Transparency, ULong flag) library 'user32.dll'
function boolean ReleaseCapture() library "user32.dll"
function long SetCapture(long hWnd) library "user32.dll"
function boolean ScreenToClient(ulong hWnd, Ref pf_s_point lpPoint) library "user32.dll"
function ulong SetParent (ulong hChild, ulong hParent) library "user32.dll"
function ulong GetParent (ulong hChild) library "user32.dll"
function uint SetFocus(int winHand) library "user32.dll" 
function uint FindWindow(Ulong className, string winName) library "user32.dll" Alias For "FindWindowA;Ansi"
function boolean CloseWindow(ulong w_handle) library "user32.dll"
function boolean DestroyWindow(ulong w_handle) library "user32.dll"
subroutine keybd_event(int bVk, int bScan, int dwFlags, int dwExtraInfo) library "user32.dll"
function long GetDesktopWindow() library "user32" alias for "GetDesktopWindow;Ansi"
function long GetWindow( long hWnd, long uCmd ) library "user32" alias for "GetWindow;Ansi"
function long GetClassNameA ( long hWnd, Ref String lpClassName, long nMaxCount ) library "user32" alias for "GetClassNameA;Ansi"
function long GetWindowTextA ( long hWnd, Ref String lpString, long nMaxCount ) library "user32" alias for "GetWindowTextA;Ansi"
function long SetTimer(Long hwnd, long idTimer, Long uTimeOut, Long tmprc) Library "user32.dll"
function long KillTimer(Long hwnd, Long idEvent) Library "user32.dll" 
function integer GetSystemMetrics (integer nIndex) Library "user32.dll"
function long MonitorFromWindow (Long hwnd, Long dwFlags) Library "user32"
function long GetMonitorInfo (long hMonitor, ref pf_s_tagmonitorinfo moninfo) Library "user32"  alias for "GetMonitorInfoA"
function boolean SetForegroundWindow(long hWnd) Library "user32"  alias for "SetForegroundWindow"

// Shlwapi.dll
function Boolean PathRemoveFileSpec(Ref String pszPath) library "shlwapi.dll" Alias For "PathRemoveFileSpecA;Ansi"
subroutine PathStripPath(Ref String pszPath) library "shlwapi.dll" Alias For "PathStripPathA;Ansi"

// Wininet.dll
function Boolean InternetCanonicalizeUrl(String lpszUrl, Ref String lpszBuffer, Ref Long lpdwBufferLength, long dwFlags) library "Wininet.dll" Alias for "InternetCanonicalizeUrlA;Ansi"

// Shell32.dll
function long ShellExecute (uint  ihwnd,string  lpszOp, string lpszFile, string lpszParams, string lpszDir, int  wShowCmd) library "shell32.dll" Alias For "ShellExecuteA;Ansi" 
function long ShellExecuteEx(REF pf_s_shellexecuteinfo lpExecInfo) library "shell32.dll" Alias For "ShellExecuteA;Ansi"

// Imm32.dll
function Long ImmGetContext( long handle ) library "imm32.dll"
function Long ImmSetConversionStatus( long hlMC,long fFlag,long cFlag) library "imm32.dll"
function Long ImmGetConversionStatus(long hImc, ref ulong lpfdwConversion, ref ulong lpfdwSentence) Library "imm32.dll"
function Long ImmReleaseContext( long handle,long hlMC) library "imm32.dll"

// Gdi32.dll
function long GetDC(long hwnd) library "user32.dll"
function long CreateCompatibleDC(long hdc) library "gdi32.dll"
function boolean ReleaseDC(long hwnd, long hdc)library "user32.dll"
function boolean DeleteDC(long hdc) library "gdi32.dll"
function long SelectObject(long hdc, long handle) library "gdi32.dll"
function long CreateCompatibleBitmap(long hdc, int nWidth, int nHeight) library "gdi32.dll"
function long CreateBitmap(long w, long h, long panels, long bits, long data) library "gdi32.dll"
function boolean BitBlt(long hdcDest, long nXDest, long nYDest, long nWidth, long nHeight, long hdcSrc,long nXSrc, long nYSrc, long dwRop) library "gdi32.dll"
function boolean DeleteObject(long hObject)library "gdi32.dll"
function long CreateSolidBrush(long crColor) library "gdi32.dll"
function long SetBkMode(long hdc,int iBkMode) library "gdi32.dll"
function long SetBkColor(long hdc, long crColor) library "gdi32.dll"
function long SetTextColor(long hdc, long crColor) library "gdi32.dll"
function ulong GetStockObject(ulong nIndex) library "gdi32.dll"
function long SetDCPenColor(ulong hdc,ulong color) library "gdi32.dll"
function long SetDCBrushColor(ulong hdc,ulong color) library "gdi32.dll"

function Integer GlobalAddAtom (ref string lpString) library "kernel32.dll" ALIAS FOR "GlobalAddAtomA" 
function ulong RegisterHotKey (ulong hwnd, ulong id, ulong fsModifiers, ulong vk) library "user32.dll" 

// Window FUNCTIONs
function ulong GetSystemMetrics(ulong nIndex) library "user32.dll"

// system path folder add
FUNCTION boolean DeleteFile(ref string filename) LIBRARY "Kernel32" ALIAS FOR "DeleteFileW"
FUNCTION long SHGetFolderPath ( long hwndOwner, long nFolder, long hToken, long dwFlags, Ref string pszPath ) Library "shell32.dll" alias For "SHGetFolderPathW"
FUNCTION boolean CreateDirectoryA(ref string pathname, int sa) LIBRARY "Kernel32.dll" alias for "CreateDirectoryA;Ansi" 
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" alias for "CopyFileA;Ansi"

//External Function iwa화면크기조정
Function Boolean SetWindowPos(Long hwnd, Long hWndInsertAfter, Int x, Int y, Int cx, Int cy, UInt uFlag) Library "USER32" alias for "SetWindowPos;ANSI"

//base64.dll chart
//function long BASE64_Decode( blob indata, long indatalen, ref blob outdata, ref long outdatalen, long inmode, long outmode ) library "base64.dll"
end prototypes
type variables
protected:
	string	is_temppath4frame

Public:
	fw_s_node4value	istr_node4value

	String	is_nodevalue	= ''
	Long		il_nodevalue	= 0
end variables

forward prototypes
public subroutine of_setinitializationapi ()
public function string of_gethostname ()
public function string of_getipaddress ()
public function string of_getmacaddress ()
public subroutine of_initsyscolor (fw_s_syscolor astr_parm)
public function integer of_setsyscolor (fw_s_syscolor astr_parm)
public function long of_setcommandbtnoverlayimgw (commandbutton acb_button, string as_sourceimage, string as_targetimage, unsignedlong aul_fontcolor)
public function boolean of_setbackdroptransparent (picture ap_target, string as_targetpath)
public function long of_setcommandbtnoverlayimgw (commandbutton acb_button, string as_sourceimage, string as_targetimage, unsignedlong aul_fontcolor, string as_iconfile)
public function long of_urldownload2file (string as_url, string as_localfile)
public function string of_seturidecode (string as_source, encoding ae_encode)
public function string of_seturiencode (string as_source, encoding ae_encode)
public function boolean of_getfilewritetime (string as_filename, ref datetime adtm_writetime)
public function boolean of_getfilewritetime (string as_filepath, ref string as_writetime)
public function boolean of_setfilewritetime (string as_filepath, datetime adtm_writetime)
public function boolean of_setfilewritetime (string as_filepath, string as_writetime)
public function integer of_gettextsize (unsignedlong al_hwnd, string as_text, integer ai_fontsize, integer ai_fontweight, fontfamily aenum_fontfamily, fontpitch aenum_fontpitch, fontcharset aenum_fontcharset, string as_fontface, ref pf_s_size astr_textsize)
public function boolean of_getbackdropcontrolimg (dragobject ado_target, string as_targetpath)
public function unsignedlong of_compress (ref blob ablb_src, ref blob ablb_rslt)
public function blob of_compress (string as_source)
public function integer of_compressfile (string as_source, string as_destination)
public function unsignedlong of_uncompress (ref blob ablb_src, ref blob ablb_rslt)
public function string of_uncompress (ref blob ablb_src)
public function integer of_uncompressfile (ref string as_source, ref string as_destination)
public function string of_getuniqpicturename (powerobject apo_object)
public function long of_extendimage (string as_sourcefilepath, string as_targetfilepath, long al_basexpos, long al_baseypos, long al_extendwidth, long al_extendheight)
public function string of_getpowerframetemppath ()
public function string of_getsystemtemppath ()
public function string of_getlasterror ()
public function string of_formatmessage (unsignedlong aul_error)
public function string of_thisname (powerobject lpo_target)
public function integer of_setopacity (long al_handle)
public subroutine of_explorertotop (string as_http, string as_browser)
public function string of_pathstrippath (string as_filepath)
public function string of_pathremovefilespec (string as_filepath)
public function long of_shellexecute (string as_file)
public function boolean of_shellexecute (string as_file, string as_extension)
public function long of_immgetcontext (long hwnd)
public function long of_immgetconversionstatus (unsignedlong himc, unsignedlong lpfdwconversion, unsignedlong lpfdwsentence)
public function long of_immreleasecontext (long handle, long himc)
public function long of_immsetconversionstatus (long himc, long fflag, long l)
end prototypes

public subroutine of_setinitializationapi ();is_nodevalue = space(250000)
istr_node4value.cstr01 = is_nodevalue
istr_node4value.cstr02 = is_nodevalue
istr_node4value.cstr03 = is_nodevalue
istr_node4value.cstr04 = is_nodevalue
istr_node4value.cstr05 = is_nodevalue
istr_node4value.cstr06 = is_nodevalue
istr_node4value.cstr07 = is_nodevalue
istr_node4value.cstr08 = is_nodevalue
istr_node4value.cstr09 = is_nodevalue
istr_node4value.cstr10 = is_nodevalue
istr_node4value.cstr11 = is_nodevalue
istr_node4value.cstr12 = is_nodevalue
istr_node4value.cstr13 = is_nodevalue
istr_node4value.cstr14 = is_nodevalue
istr_node4value.cstr15 = is_nodevalue
istr_node4value.cstr16 = is_nodevalue
istr_node4value.cstr17 = is_nodevalue
istr_node4value.cstr18 = is_nodevalue
istr_node4value.cstr19 = is_nodevalue
istr_node4value.cstr20 = is_nodevalue
istr_node4value.cstr21 = is_nodevalue
istr_node4value.cstr22 = is_nodevalue
istr_node4value.cstr23 = is_nodevalue
istr_node4value.cstr24 = is_nodevalue
istr_node4value.cstr25 = is_nodevalue
istr_node4value.cstr26 = is_nodevalue
istr_node4value.cstr27 = is_nodevalue
istr_node4value.cstr28 = is_nodevalue
istr_node4value.cstr29 = is_nodevalue
istr_node4value.cstr30 = is_nodevalue

il_nodevalue = 0
end subroutine

public function string of_gethostname ();String ls_hostname

ls_hostname = space(512)
if this.biz_gethostname(ls_hostname, len(ls_hostname)) = 1 then
	return ls_hostname
else
	return ''
end if
end function

public function string of_getipaddress ();String ls_ipaddress

ls_ipaddress = space(512)
if this.biz_getipaddress(ls_ipaddress, len(ls_ipaddress)) = 1 then
	return ls_ipaddress
else
	return ''
end if
end function

public function string of_getmacaddress ();String ls_macaddress

ls_macaddress = space(512)
if this.biz_getmacaddress(ls_macaddress, len(ls_macaddress)) = 1 then
	return ls_macaddress
else
	return ''
end if
end function

public subroutine of_initsyscolor (fw_s_syscolor astr_parm);astr_parm.scrollbar = 0
astr_parm.desktop = 0
astr_parm.activecaption = 0
astr_parm.inactivecaption = 0
astr_parm.menu = 0
astr_parm.window = 0
astr_parm.windowframe = 0
astr_parm.menutext = 0
astr_parm.windowtext = 0
astr_parm.captiontext = 0
astr_parm.activeborder = 0
astr_parm.inactiveborder = 0
astr_parm.appworkspace = 0
astr_parm.highlight = 0
astr_parm.highlighttext = 0
astr_parm.btnface = 0
astr_parm.btnshadow = 0
astr_parm.graytext = 0
astr_parm.btntext = 0
astr_parm.inactivecaptiontext = 0
astr_parm.btnhilight = 0
astr_parm.ddkshadow = 0
astr_parm.dlight = 0
astr_parm.infotext = 0
astr_parm.infobk = 0
astr_parm.hotlight = 0
astr_parm.gradientactivecaptio = 0
astr_parm.gradientinactivecapt = 0
astr_parm.menuhilight = 0
astr_parm.menubar = 0
end subroutine

public function integer of_setsyscolor (fw_s_syscolor astr_parm);Return this.biz_setsystemcolor( &
		astr_parm.scrollbar, &
		astr_parm.desktop, &
		astr_parm.activecaption, &
		astr_parm.inactivecaption, &
		astr_parm.menu, &
		astr_parm.window, &
		astr_parm.windowframe, &
		astr_parm.menutext, &
		astr_parm.windowtext, &
		astr_parm.captiontext, &
		astr_parm.activeborder, &
		astr_parm.inactiveborder, &
		astr_parm.appworkspace, &
		astr_parm.highlight, &
		astr_parm.highlighttext, &
		astr_parm.btnface, &
		astr_parm.btnshadow, &
		astr_parm.graytext, &
		astr_parm.btntext, &
		astr_parm.inactivecaptiontext, &
		astr_parm.btnhilight, &
		astr_parm.ddkshadow, &
		astr_parm.dlight, &
		astr_parm.infotext, &
		astr_parm.infobk, &
		astr_parm.hotlight, &
		astr_parm.gradientactivecaptio, &
		astr_parm.gradientinactivecapt, &
		astr_parm.menuhilight, &
		astr_parm.menubar)

end function

public function long of_setcommandbtnoverlayimgw (commandbutton acb_button, string as_sourceimage, string as_targetimage, unsignedlong aul_fontcolor);// FONT PITCH
constant ulong DEFAULT_PITCH = 0
constant ulong FIXED_PITCH = 1
constant ulong VARIABLE_PITCH = 2
constant ulong MONO_FONT = 8

// FONT FAMILY
constant ulong FF_DONTCARE = 0
constant ulong FF_ROMAN = 1
constant ulong FF_SWISS = 2
constant ulong FF_MODERN = 3
constant ulong FF_SCRIPT = 4
constant ulong FF_DECORATIVE = 5

// FONT CHARSET
constant ulong ANSI_CHARSET = 0
constant ulong DEFAULT_CHARSET = 1
constant ulong SYMBOL_CHARSET = 2
constant ulong SHIFTJIS_CHARSET = 128
constant ulong HANGEUL_CHARSET = 129
constant ulong HANGUL_CHARSET = 129
constant ulong GB2312_CHARSET = 134
constant ulong CHINESEBIG5_CHARSET = 136
constant ulong OEM_CHARSET = 255
constant ulong JOHAB_CHARSET = 130
constant ulong HEBREW_CHARSET = 177
constant ulong ARABIC_CHARSET = 178
constant ulong GREEK_CHARSET = 161
constant ulong TURKISH_CHARSET = 162
constant ulong VIETNAMESE_CHARSET = 163
constant ulong THAI_CHARSET = 222
constant ulong EASTEUROPE_CHARSET = 238
constant ulong RUSSIAN_CHARSET = 204
constant ulong MAC_CHARSET = 77
constant ulong BALTIC_CHARSET = 186

long ll_retval, ll_fontsize
long ll_width, ll_height, ll_fontweight
long ll_charset, ll_fontpitch, ll_fontfamily
string ls_text, ls_fontface
long ll_italic, ll_underline

ll_width = unitstopixels(acb_button.width, xunitstopixels!) - 1
ll_height = unitstopixels(acb_button.height, yunitstopixels!) - 1
ls_text = acb_button.text
ls_fontface = acb_button.facename
ll_fontsize = abs(acb_button.textsize)
ll_fontweight = acb_button.weight

if acb_button.italic = true then
	ll_italic = 1
else
	ll_italic = 0
end if

if acb_button.underline = true then
	ll_underline = 1
else
	ll_underline = 0
end if

choose case acb_button.FontPitch
	case Default!
		ll_fontpitch = DEFAULT_PITCH
	case Fixed!
		ll_fontpitch = FIXED_PITCH
	case Variable!
		ll_fontpitch = VARIABLE_PITCH
end choose

choose case acb_button.FontFamily
	case AnyFont!
		ll_fontfamily = FF_DONTCARE
	case Decorative!
		ll_fontfamily = FF_DECORATIVE
	case Modern!
		ll_fontfamily = FF_MODERN
	case Roman!
		ll_fontfamily = FF_ROMAN
	case Script!
		ll_fontfamily = FF_SCRIPT
	case Swiss!
		ll_fontfamily = FF_SWISS
end choose

choose case acb_button.FontCharSet
	case ansi!
		ll_charset = ANSI_CHARSET
	case arabiccharset!
		ll_charset = ARABIC_CHARSET
	case balticcharset!
		ll_charset = BALTIC_CHARSET
	case chinesebig5!
		ll_charset = CHINESEBIG5_CHARSET
	case defaultcharset!
		ll_charset = DEFAULT_CHARSET
	case easteuropecharset!
		ll_charset = EASTEUROPE_CHARSET
	case gb2312charset!
		ll_charset = GB2312_CHARSET
	case greekcharset!
		ll_charset = GREEK_CHARSET
	case hangeul!
		ll_charset = HANGEUL_CHARSET
	case hebrewcharset!
		ll_charset = HEBREW_CHARSET
	case johabcharset!
		ll_charset = JOHAB_CHARSET
	case maccharset!
		ll_charset = MAC_CHARSET
	case oem!
		ll_charset = OEM_CHARSET
	case russiancharset!
		ll_charset = RUSSIAN_CHARSET
	case shiftjis!
		ll_charset = SHIFTJIS_CHARSET
	case symbol!
		ll_charset = SYMBOL_CHARSET
	case thaicharset!
		ll_charset = THAI_CHARSET
	case turkishcharset!
		ll_charset = TURKISH_CHARSET
	case vietnamesecharset!
		ll_charset = VIETNAMESE_CHARSET
end choose

ll_retval = biz_setcommandbtnoverlayimgw(as_sourceimage, as_targetimage, ll_width, ll_height, ls_text, ll_fontsize, ll_fontweight, aul_fontcolor, ll_italic, ll_underline, ll_charset, ll_fontpitch, ll_fontfamily, ls_fontface)

if ll_retval < 0 then
	choose case ll_retval
		case -99
			messagebox('Notice', '버튼용 이미지 파일을 찾을 수 없습니다.~r~n' + as_sourceimage)
		case else
	end choose
end if

return ll_retval
end function

public function boolean of_setbackdroptransparent (picture ap_target, string as_targetpath);pf_s_rect lstr_rect

boolean	lb_rv
string	ls_sourcepath

lstr_rect.left = unitstopixels(ap_target.x, xunitstopixels!)
lstr_rect.top = unitstopixels(ap_target.y, yunitstopixels!)
lstr_rect.right = lstr_rect.left + unitstopixels(ap_target.width, xunitstopixels!)
lstr_rect.bottom = lstr_rect.top + unitstopixels(ap_target.height, yunitstopixels!)

ls_sourcepath = ap_target.picturename

lb_rv = biz_setbackdroptransparent(handle(ap_target), lstr_rect, ls_sourcepath, as_targetpath)
if lb_rv = true then
	ap_target.picturename = as_targetpath
	ap_target.visible = true
end if

return lb_rv
end function

public function long of_setcommandbtnoverlayimgw (commandbutton acb_button, string as_sourceimage, string as_targetimage, unsignedlong aul_fontcolor, string as_iconfile);// FONT PITCH
constant ulong DEFAULT_PITCH = 0
constant ulong FIXED_PITCH = 1
constant ulong VARIABLE_PITCH = 2
constant ulong MONO_FONT = 8

// FONT FAMILY
constant ulong FF_DONTCARE = 0
constant ulong FF_ROMAN = 1
constant ulong FF_SWISS = 2
constant ulong FF_MODERN = 3
constant ulong FF_SCRIPT = 4
constant ulong FF_DECORATIVE = 5

// FONT CHARSET
constant ulong ANSI_CHARSET = 0
constant ulong DEFAULT_CHARSET = 1
constant ulong SYMBOL_CHARSET = 2
constant ulong SHIFTJIS_CHARSET = 128
constant ulong HANGEUL_CHARSET = 129
constant ulong HANGUL_CHARSET = 129
constant ulong GB2312_CHARSET = 134
constant ulong CHINESEBIG5_CHARSET = 136
constant ulong OEM_CHARSET = 255
constant ulong JOHAB_CHARSET = 130
constant ulong HEBREW_CHARSET = 177
constant ulong ARABIC_CHARSET = 178
constant ulong GREEK_CHARSET = 161
constant ulong TURKISH_CHARSET = 162
constant ulong VIETNAMESE_CHARSET = 163
constant ulong THAI_CHARSET = 222
constant ulong EASTEUROPE_CHARSET = 238
constant ulong RUSSIAN_CHARSET = 204
constant ulong MAC_CHARSET = 77
constant ulong BALTIC_CHARSET = 186

long ll_retval, ll_fontsize
long ll_width, ll_height, ll_fontweight
long ll_charset, ll_fontpitch, ll_fontfamily
string ls_text, ls_fontface
long ll_italic, ll_underline

ll_width = unitstopixels(acb_button.width, xunitstopixels!) - 1
ll_height = unitstopixels(acb_button.height, yunitstopixels!) - 1
ls_text = acb_button.text
ls_fontface = acb_button.facename
ll_fontsize = abs(acb_button.textsize)
ll_fontweight = acb_button.weight

if acb_button.italic = true then
	ll_italic = 1
else
	ll_italic = 0
end if

if acb_button.underline = true then
	ll_underline = 1
else
	ll_underline = 0
end if

choose case acb_button.FontPitch
	case Default!
		ll_fontpitch = DEFAULT_PITCH
	case Fixed!
		ll_fontpitch = FIXED_PITCH
	case Variable!
		ll_fontpitch = VARIABLE_PITCH
end choose

choose case acb_button.FontFamily
	case AnyFont!
		ll_fontfamily = FF_DONTCARE
	case Decorative!
		ll_fontfamily = FF_DECORATIVE
	case Modern!
		ll_fontfamily = FF_MODERN
	case Roman!
		ll_fontfamily = FF_ROMAN
	case Script!
		ll_fontfamily = FF_SCRIPT
	case Swiss!
		ll_fontfamily = FF_SWISS
end choose

choose case acb_button.FontCharSet
	case ansi!
		ll_charset = ANSI_CHARSET
	case arabiccharset!
		ll_charset = ARABIC_CHARSET
	case balticcharset!
		ll_charset = BALTIC_CHARSET
	case chinesebig5!
		ll_charset = CHINESEBIG5_CHARSET
	case defaultcharset!
		ll_charset = DEFAULT_CHARSET
	case easteuropecharset!
		ll_charset = EASTEUROPE_CHARSET
	case gb2312charset!
		ll_charset = GB2312_CHARSET
	case greekcharset!
		ll_charset = GREEK_CHARSET
	case hangeul!
		ll_charset = HANGEUL_CHARSET
	case hebrewcharset!
		ll_charset = HEBREW_CHARSET
	case johabcharset!
		ll_charset = JOHAB_CHARSET
	case maccharset!
		ll_charset = MAC_CHARSET
	case oem!
		ll_charset = OEM_CHARSET
	case russiancharset!
		ll_charset = RUSSIAN_CHARSET
	case shiftjis!
		ll_charset = SHIFTJIS_CHARSET
	case symbol!
		ll_charset = SYMBOL_CHARSET
	case thaicharset!
		ll_charset = THAI_CHARSET
	case turkishcharset!
		ll_charset = TURKISH_CHARSET
	case vietnamesecharset!
		ll_charset = VIETNAMESE_CHARSET
end choose

if isnull(as_iconfile) or as_iconfile = '' then
	ll_retval = biz_setcommandbtnoverlayimgw(as_sourceimage, as_targetimage, ll_width, ll_height, ls_text, ll_fontsize, ll_fontweight, aul_fontcolor, ll_italic, ll_underline, ll_charset, ll_fontpitch, ll_fontfamily, ls_fontface)
else
	ll_retval = biz_setcommandbtnimgw(as_sourceimage, as_targetimage, ll_width, ll_height, ls_text, ll_fontsize, ll_fontweight, aul_fontcolor, ll_italic, ll_underline, ll_charset, ll_fontpitch, ll_fontfamily, ls_fontface, as_iconfile)
end if

if ll_retval < 0 then
	choose case ll_retval
		case -99
			messagebox('Notice', '버튼용 이미지 파일을 찾을 수 없습니다.~r~nSource Image: ' + as_sourceimage + '~r~nIcon Image: ' + as_iconfile)
		case else
	end choose
end if

return ll_retval
end function

public function long of_urldownload2file (string as_url, string as_localfile);long ll_ret

ll_ret = biz_urldownload2file(as_url, as_localfile)

return ll_ret
end function

public function string of_seturidecode (string as_source, encoding ae_encode);long		ll_strlen, ll_retval
blob		lb_result
string	ls_result

ll_strlen = lena(as_source)
lb_result = blob(space(ll_strlen))
ll_retval = this.biz_seturidecode(as_source, lb_result)
ls_result = string(blobmid(lb_result, 1, ll_retval), ae_encode)

return ls_result
end function

public function string of_seturiencode (string as_source, encoding ae_encode);long		ll_strlen, ll_retval
string	ls_result
blob		lb_source

ll_strlen = lena(as_source)
ls_result = space(ll_strlen * 4)
lb_source = blob(space(lena(as_source)))
blobedit(lb_source, 1, as_source, ae_encode)
ll_retval = this.biz_seturiencode(lb_source, ls_result)
ls_result = lefta(ls_result, ll_retval)

return ls_result
end function

public function boolean of_getfilewritetime (string as_filename, ref datetime adtm_writetime);// 해당 파일의 최종 수정일시를 구해옵니다

string	ls_writetime
boolean	lb_rc

ls_writetime = space(23)
lb_rc = this.biz_getfilewritetime(as_filename, ls_writetime)
if lb_rc = true then
	adtm_writetime = datetime(ls_writetime)
end if

return lb_rc
end function

public function boolean of_getfilewritetime (string as_filepath, ref string as_writetime);boolean lb_retval

if isnull(as_filepath) then return false
as_writetime = space(23)

// Return Format = %04d/%02d/%02d %02d:%02d:%02d
lb_retval = biz_getfilewritetime(as_filepath, as_writetime)

return lb_retval
end function

public function boolean of_setfilewritetime (string as_filepath, datetime adtm_writetime);boolean	lb_retval
string	ls_writetime

ls_writetime = string(adtm_writetime, 'yyyy.mm.dd hh:mm:ss')
// WriteTime Format = %04d/%02d/%02d %02d:%02d:%02d
lb_retval = biz_setfilewritetime(as_filepath, ls_writetime)

return lb_retval
end function

public function boolean of_setfilewritetime (string as_filepath, string as_writetime);boolean	lb_retval

// WriteTime Format = %04d/%02d/%02d %02d:%02d:%02d
lb_retval = biz_setfilewritetime(as_filepath, as_writetime)

return lb_retval
end function

public function integer of_gettextsize (unsignedlong al_hwnd, string as_text, integer ai_fontsize, integer ai_fontweight, fontfamily aenum_fontfamily, fontpitch aenum_fontpitch, fontcharset aenum_fontcharset, string as_fontface, ref pf_s_size astr_textsize);// FONT PITCH
constant ulong DEFAULT_PITCH = 0
constant ulong FIXED_PITCH = 1
constant ulong VARIABLE_PITCH = 2
constant ulong MONO_FONT = 8

// FONT FAMILY
constant ulong FF_DONTCARE = 0
constant ulong FF_ROMAN = 1
constant ulong FF_SWISS = 2
constant ulong FF_MODERN = 3
constant ulong FF_SCRIPT = 4
constant ulong FF_DECORATIVE = 5

// FONT CHARSET
constant ulong ANSI_CHARSET = 0
constant ulong DEFAULT_CHARSET = 1
constant ulong SYMBOL_CHARSET = 2
constant ulong SHIFTJIS_CHARSET = 128
constant ulong HANGEUL_CHARSET = 129
constant ulong HANGUL_CHARSET = 129
constant ulong GB2312_CHARSET = 134
constant ulong CHINESEBIG5_CHARSET = 136
constant ulong OEM_CHARSET = 255
constant ulong JOHAB_CHARSET = 130
constant ulong HEBREW_CHARSET = 177
constant ulong ARABIC_CHARSET = 178
constant ulong GREEK_CHARSET = 161
constant ulong TURKISH_CHARSET = 162
constant ulong VIETNAMESE_CHARSET = 163
constant ulong THAI_CHARSET = 222
constant ulong EASTEUROPE_CHARSET = 238
constant ulong RUSSIAN_CHARSET = 204
constant ulong MAC_CHARSET = 77
constant ulong BALTIC_CHARSET = 186

long ll_retval
long ll_charset, ll_fontpitch, ll_fontfamily

ai_fontsize = abs(ai_fontsize)

choose case aenum_fontpitch
	case Default!
		ll_fontpitch = DEFAULT_PITCH
	case Fixed!
		ll_fontpitch = FIXED_PITCH
	case Variable!
		ll_fontpitch = VARIABLE_PITCH
end choose

choose case aenum_fontfamily
	case AnyFont!
		ll_fontfamily = FF_DONTCARE
	case Decorative!
		ll_fontfamily = FF_DECORATIVE
	case Modern!
		ll_fontfamily = FF_MODERN
	case Roman!
		ll_fontfamily = FF_ROMAN
	case Script!
		ll_fontfamily = FF_SCRIPT
	case Swiss!
		ll_fontfamily = FF_SWISS
end choose

choose case aenum_fontcharset
	case ansi!
		ll_charset = ANSI_CHARSET
	case arabiccharset!
		ll_charset = ARABIC_CHARSET
	case balticcharset!
		ll_charset = BALTIC_CHARSET
	case chinesebig5!
		ll_charset = CHINESEBIG5_CHARSET
	case defaultcharset!
		ll_charset = DEFAULT_CHARSET
	case easteuropecharset!
		ll_charset = EASTEUROPE_CHARSET
	case gb2312charset!
		ll_charset = GB2312_CHARSET
	case greekcharset!
		ll_charset = GREEK_CHARSET
	case hangeul!
		ll_charset = HANGEUL_CHARSET
	case hebrewcharset!
		ll_charset = HEBREW_CHARSET
	case johabcharset!
		ll_charset = JOHAB_CHARSET
	case maccharset!
		ll_charset = MAC_CHARSET
	case oem!
		ll_charset = OEM_CHARSET
	case russiancharset!
		ll_charset = RUSSIAN_CHARSET
	case shiftjis!
		ll_charset = SHIFTJIS_CHARSET
	case symbol!
		ll_charset = SYMBOL_CHARSET
	case thaicharset!
		ll_charset = THAI_CHARSET
	case turkishcharset!
		ll_charset = TURKISH_CHARSET
	case vietnamesecharset!
		ll_charset = VIETNAMESE_CHARSET
end choose
if ASCA( LeftA(as_text,1) ) > 0 then
	ll_retval = biz_gettextsize_ex(al_hwnd, as_text, as_fontface, ai_fontsize, ai_fontweight, ll_fontfamily, ll_fontpitch, ll_charset, astr_textsize)
else
   ll_retval = biz_gettextsize_w(al_hwnd, as_text, as_fontface, ai_fontsize, ai_fontweight, astr_textsize)
end if

return ll_retval
end function

public function boolean of_getbackdropcontrolimg (dragobject ado_target, string as_targetpath);pf_s_rect	lstr_rect
boolean		lb_rv

lstr_rect.left = unitstopixels(ado_target.x, xunitstopixels!)
lstr_rect.top = unitstopixels(ado_target.y, yunitstopixels!)
lstr_rect.right = lstr_rect.left + unitstopixels(ado_target.width, xunitstopixels!)
lstr_rect.bottom = lstr_rect.top + unitstopixels(ado_target.height, yunitstopixels!)

lb_rv = biz_getbackdropcontrolimg(handle(ado_target), lstr_rect, as_targetpath)

return lb_rv
end function

public function unsignedlong of_compress (ref blob ablb_src, ref blob ablb_rslt);// Description:
// 바이너리 데이터를 압축합니다(ZIP)
// Parameter:
// ablb_src = 압축할 바이너리 데이터
// ablb_rslt = 압축된 바이너리 데이터
// Return:
// 압축된 데이터의 바이트 수

ulong lul_srclen, lul_destlen, lul_rsltlen
blob lblb_dest

lul_srclen = len(ablb_src)
lul_destlen = (lul_srclen * 1.01) + 12
lblb_dest = blob(space(lul_destlen), encodingansi!)

lul_rsltlen = biz_compress(lblb_dest, lul_destlen, ablb_src, lul_srclen)
if lul_rsltlen > 0 then
	ablb_rslt = blobmid(lblb_dest, 1, lul_rsltlen)
end if

return lul_rsltlen

end function

public function blob of_compress (string as_source);// Description:
// 문자열을 압축합니다(ZIP)
// Parameters:
// as_source = 압축할 문자열
// Return:
// as_source가 압축된 바이너리 데이터

blob lblb_src, lblb_rslt

lblb_src = blob(as_source)
this.of_compress(lblb_src, lblb_rslt)

return lblb_rslt
end function

public function integer of_compressfile (string as_source, string as_destination);// Description:
// as_source 파일을 압축해서 as_destination 파일명으로 저장합니다.
// Parameter:
// as_source = 압축할 파일명
// as_destination = 압축된 파일명
// Return:
// 0 = 성공, 마이너스 = 실패

integer li_rc

li_rc = biz_compressfile(as_source, as_destination)

return li_rc
end function

public function unsignedlong of_uncompress (ref blob ablb_src, ref blob ablb_rslt);// Description:
// 바이너리 데이터를 압축 해제합니다(UNZIP)
// Parameters:
// ablb_src = 압축된 데이터를 담고있는 바이너리
// ablb_rslt = 압축해제된 데이터를 담을 바이너리 변수
// Return:
// 압축해제된 데이터의 바이트 수
// ※ 압축해제 BUFFER 사이즈를 최대 10배로 설정 했으나
// 그 이상 차이가 나는 경우가 발생 될 수 있습니다.
// 이럴 경우 of_compressfile / of_uncompressfile을 사용하세요.

ulong	lul_srclen, lul_destlen, lul_rsltlen
blob	lblb_dest

lul_srclen = len(ablb_src)
lul_destlen = lul_srclen * 10
lblb_dest = blob(space(lul_destlen), encodingansi!)

lul_rsltlen = biz_uncompress(lblb_dest, lul_destlen, ablb_src, lul_srclen)
if lul_rsltlen > 0 then
	ablb_rslt = blobmid(lblb_dest, 1, lul_rsltlen)
end if

return lul_rsltlen
end function

public function string of_uncompress (ref blob ablb_src);// Description:
// 문자열을 압축 해제합니다(UNZIP)
// Parameters:
// ablb_src = 압축된 데이터를 담고있는 바이너리
// Return:
// 압축이 해제된 문자열

blob		lblb_rslt
string	ls_rslt

this.of_uncompress(ablb_src, lblb_rslt)
ls_rslt = string(lblb_rslt)

return ls_rslt
end function

public function integer of_uncompressfile (ref string as_source, ref string as_destination);// Description:
// as_source 파일을 압축해제해서 as_destination 파일명으로 저장합니다.
// Parameter:
// as_source = 압축해제할 파일명
// as_destination = 압축해제된 파일명
// Return:
// 0 = 성공, 마이너스 = 실패

integer li_rc

li_rc = biz_uncompressfile(as_source, as_destination)

return li_rc

end function

public function string of_getuniqpicturename (powerobject apo_object);powerobject lpo_parent

string ls_retval

ls_retval = apo_object.classname()

lpo_parent = apo_object.GetParent()
Do While IsValid (lpo_parent)
	ls_retval = lpo_parent.classname() + "_" + ls_retval
	lpo_parent = lpo_parent.GetParent()
Loop

return ls_retval
end function

public function long of_extendimage (string as_sourcefilepath, string as_targetfilepath, long al_basexpos, long al_baseypos, long al_extendwidth, long al_extendheight);long ll_basexpos, ll_baseypos
long ll_extendwidth, ll_extendheight
long ll_retval

ll_basexpos = unitstopixels(al_basexpos, xunitstopixels!)
ll_baseypos = unitstopixels(al_baseypos, yunitstopixels!)
ll_extendwidth = unitstopixels(al_extendwidth, xunitstopixels!)
ll_extendheight = unitstopixels(al_extendheight, yunitstopixels!)

ll_retval = biz_setresizeimgw(as_sourcefilepath, as_targetfilepath, ll_basexpos, ll_baseypos, ll_extendwidth, ll_extendheight)

return ll_retval
end function

public function string of_getpowerframetemppath ();return is_temppath4frame
end function

public function string of_getsystemtemppath ();// get system temporary path
constant long MAX_PATH = 256

long		ll_bufflen
string	ls_shortpath, ls_longpath

ll_bufflen = MAX_PATH
ls_shortpath = space(MAX_PATH)

if GetTempPath(ll_bufflen, ls_shortpath) > 0 then
	ls_longpath = space(MAX_PATH)
	GetLongPathName(ls_shortpath, ls_longpath, MAX_PATH)
end if

return ls_longpath
end function

public function string of_getlasterror ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_GetLastError
//
// PURPOSE:		This function returns the message text for
//					the most recent system error.
//
// RETURN:		Counter value
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON

ULong		lul_error
String	ls_errmsg

lul_error = GetLastError()

If lul_error = 0 Then
	ls_errmsg = "An unknown error has occurred!"
Else
	ls_errmsg = of_FormatMessage(lul_error)
End If

Return ls_errmsg
end function

public function string of_formatmessage (unsignedlong aul_error);// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_FormatMessage
//
// PURPOSE:		This function returns the message text for
//					the given system error code.
//
// ARGUMENTS:	aul_error	- Error code
//
// RETURN:		Message text
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
String ls_buffer, ls_errmsg

ls_buffer = Space(200)

FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, aul_error, LANG_NEUTRAL, ls_buffer, 200, 0)

ls_errmsg = "Error# " + String(aul_error) + "~r~n~r~n" + ls_buffer

Return ls_errmsg
end function

public function string of_thisname (powerobject lpo_target);string	ls_classname
long		ll_retval
ulong		ll_handle

ll_handle = handle(lpo_target)
ls_classname = space(256)
ll_retval = GetClassName(ll_handle, ls_classname, 256)

return ls_classname
end function

public function integer of_setopacity (long al_handle);CONSTANT long LWA_COLORKEY = 1, LWA_ALPHA = 2
CONSTANT long GWL_EXSTYLE = -20
CONSTANT long WS_EX_LAYERED = 524288 //2^19

long ll_Ret, ll_handle

// or-bitwise function
OleObject wsh
wsh = CREATE OleObject
wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
wsh.language = "vbscript"

//ll_handle = Handle (this)  // handle of the window
ll_handle = al_handle
ll_Ret = GetWindowLong(ll_handle, GWL_EXSTYLE)
ll_Ret = wsh.Eval(string(ll_ret) + " or " + string(WS_EX_LAYERED))
SetWindowLong (ll_handle, GWL_EXSTYLE, ll_Ret)

// Set the opacity of the layered window to 128 (transparent)
SetLayeredWindowAttributes (ll_handle, 0, char(128), LWA_ALPHA)

// Set the opacity of the layered window to 255 (opaque)
// SetLayeredWindowAttributes (ll_handle, 0, char(255),LWA_ALPHA)

return 0
end function

public subroutine of_explorertotop (string as_http, string as_browser);Long			ll_ret
OLEObject	Ie

Ie = CREATE OLEObject
ll_ret = Ie.ConnectToNewObject("InternetExplorer.application")

//Ie.left	= Ie.Parent.x     //창 왼쪽 시작 위치(픽셀)
Ie.top = 100     

Ie.navigate(as_http)
Ie.visible=1
SetForegroundWindow(Ie.hwnd)
DO WHILE Ie.busy
	setpointer(hourglass!) 
	yield() 
LOOP

Destroy Ie
end subroutine

public function string of_pathstrippath (string as_filepath);string	ls_filename

ls_filename = as_filepath
PathStripPath(ls_filename)

return ls_filename
end function

public function string of_pathremovefilespec (string as_filepath);string ls_pathonly

ls_pathonly = as_filepath
PathRemoveFileSpec(ls_pathonly)

return ls_pathonly
end function

public function long of_shellexecute (string as_file);string ls_Null
long   ll_rc

SetNull(ls_Null)
ll_rc = ShellExecute( handle(this), "open", as_file, ls_Null, ls_Null, 1)

return ll_rc
end function

public function boolean of_shellexecute (string as_file, string as_extension);CONSTANT long SEE_MASK_CLASSNAME = 1
CONSTANT long SW_NORMAL = 1

string	ls_class
long		ll_ret

pf_s_shellexecuteinfo	lnvos_shellexecuteinfo

Inet	l_Inet

IF lower(as_extension) = "htm" OR lower(as_extension) = "html" THEN
   // Open html file with HyperlinkToURL
   // So, a new browser is launched
   // (with the code using ShellExecuteEx, it is not sure)
   GetContextService("Internet", l_Inet)
   ll_ret = l_Inet.HyperlinkToURL(as_file)
   IF ll_ret = 1 THEN
      RETURN true
   END IF
   RETURN false
END IF

// Search for the classname associated with extension
RegistryGet("HKEY_CLASSES_ROOT\." + as_extension, "", ls_class)
IF isNull(ls_class) OR trim(ls_class) = "" THEN
   // The class is not found, try with .txt (why not ?)
   RegistryGet("HKEY_CLASSES_ROOT\.txt", "", ls_class)
END IF

IF isNull(ls_class) OR Trim(ls_class) = "" THEN
   // No class : error
   RETURN false
END IF

lnvos_shellexecuteinfo.cbsize = 60
lnvos_shellexecuteinfo.fMask = SEE_MASK_CLASSNAME  // Use classname
lnvos_shellexecuteinfo.hwnd = 0
lnvos_shellexecuteinfo.lpVerb = "open"
lnvos_shellexecuteinfo.lpfile = as_file
lnvos_shellexecuteinfo.lpClass = ls_class
lnvos_shellexecuteinfo.nShow = SW_NORMAL

ll_ret = ShellExecuteEx(lnvos_shellexecuteinfo)
IF ll_ret = 0 THEN
   // Error
   RETURN false
END IF

RETURN true
end function

public function long of_immgetcontext (long hwnd);Long	ll_rtn

ll_rtn = ImmGetContext(hWnd)

return ll_rtn
end function

public function long of_immgetconversionstatus (unsignedlong himc, unsignedlong lpfdwconversion, unsignedlong lpfdwsentence);Long	ll_rtn

ll_rtn = ImmGetConversionStatus(himc, lpfdwconversion, lpfdwsentence)

Return ll_rtn
end function

public function long of_immreleasecontext (long handle, long himc);Long	ll_rtn

ll_rtn = ImmReleaseContext( handle, hIMC )

Return ll_rtn
end function

public function long of_immsetconversionstatus (long himc, long fflag, long l);Long	ll_rtn

ll_rtn = ImmSetConversionStatus(himc, fFlag, l)

return ll_rtn
end function

on n_extfunc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_extfunc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;of_setinitializationapi()
end event

event destructor;//system color init
gnv_extfunc.biz_setdefaultsystemcolor()
end event

