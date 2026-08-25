forward
global type pf_u_webeditor from pf_u_webbrowser
end type
end forward

global type pf_u_webeditor from pf_u_webbrowser
end type
global pf_u_webeditor pf_u_webeditor

type variables
private:
	boolean	ib_busy
	string	is_temp

public:
	boolean	ib_update = false
end variables

forward prototypes
public function string of_getcontents ()
public subroutine of_openwebeditor ()
public subroutine of_resetcontents ()
public function integer of_setcontents (string as_innerhtml)
public function integer of_setcontents (string as_innerhtml, boolean ab_overwrap)
public subroutine of_seteditorurl (string as_url)
public subroutine of_setviewerurl (string as_url)
public function string of_thisname ()
public function blob of_getcontents_blob ()
public function boolean of_modify_check ()
end prototypes

public function string of_getcontents ();string ls_return

if this.of_waituntildocumentisready() = -1 then return ''

ls_return = this.of_execscript("getContents();")
ls_return = fw_f_replaceall(ls_return, '~r', '')
ls_return = fw_f_replaceall(ls_return, '~n', '')

return ls_return
end function

public subroutine of_openwebeditor ();// SmartEditor 페이지 오픈
this.of_navigate(EDITOR_URL)
end subroutine

public subroutine of_resetcontents ();if this.of_waituntildocumentisready() = -1 then return
this.of_execscript("resetContents();")
end subroutine

public function integer of_setcontents (string as_innerhtml);if this.of_waituntildocumentisready() = -1 then return -1

as_innerhtml = fw_f_replaceall(as_innerhtml, "'", "\'")
as_innerhtml = fw_f_replaceall(as_innerhtml, '"', '\"')
this.of_execscript("setContents('" + as_innerhtml + "');")

is_temp = this.of_getcontents()

return 1
end function

public function integer of_setcontents (string as_innerhtml, boolean ab_overwrap);if this.of_waituntildocumentisready() = -1 then return -1

as_innerhtml = fw_f_replaceall(as_innerhtml, "'", "\'")
as_innerhtml = fw_f_replaceall(as_innerhtml, '"', '\"')
this.of_execscript("setContentsOverwrap('" + as_innerhtml + "');")

is_temp = this.of_getcontents()

return 1
end function

public subroutine of_seteditorurl (string as_url);EDITOR_URL = as_url
end subroutine

public subroutine of_setviewerurl (string as_url);VIEWER_URL = as_url
end subroutine

public function string of_thisname ();return 'pf_u_webeditor'
end function

public function blob of_getcontents_blob ();blob lblb_null

if this.of_waituntildocumentisready() = -1 then return lblb_null

return Blob( this.of_execscript("getContents();"), EncodingUTF8!)
end function

public function boolean of_modify_check ();boolean	lb_ret
string	ls_html

ls_html = this.of_getcontents()

if len(ls_html) = len(is_temp) then
	if ls_html = is_temp then
		return false
	else
		return true
	end if
else
	return true
end if
end function

on pf_u_webeditor.create
call super::create
end on

on pf_u_webeditor.destroy
call super::destroy
end on

event clicked;call super::clicked;string	ls_html

ls_html = this.of_getcontents()

ib_update = (f_nvl (ls_html,'') <> f_nvl (is_temp,''))
end event

