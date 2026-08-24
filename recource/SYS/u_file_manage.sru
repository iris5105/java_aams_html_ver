forward
global type u_file_manage from u_ancestor
end type
type dw_view from u_dw within u_file_manage
end type
type p_close from pf_u_imagebutton within u_file_manage
end type
type p_down from pf_u_imagebutton within u_file_manage
end type
type p_delete from pf_u_imagebutton within u_file_manage
end type
type p_add from pf_u_imagebutton within u_file_manage
end type
end forward

global type u_file_manage from u_ancestor
integer width = 2848
integer height = 592
event ue_init ( string as_corp_gr,  string as_key,  string as_auth )
event ue_close ( )
event ue_add ( )
event ue_delete ( long row )
event ue_deleteall ( )
event ue_download ( long row )
event ue_downloadall ( )
event ue_open ( long row )
dw_view dw_view
p_close p_close
p_down p_down
p_delete p_delete
p_add p_add
end type
global u_file_manage u_file_manage

type variables
STRING	is_key, is_auth='11110', is_corp_gr

BOOLEAN	ib_changed=FALSE
end variables

forward prototypes
public subroutine wf_setenabled ()
end prototypes

event ue_init(string as_corp_gr, string as_key, string as_auth);is_corp_gr = as_corp_gr
is_key = as_key
IF f_notnull (as_auth) THEN is_auth = as_auth

LONG	ll, ll_right_x

ll_right_x = dw_view.x + dw_view.width
pf_u_imagebutton	la_btn[], null_p
la_btn = {p_add, p_delete, null_p, p_down, p_close}
FOR  ll = LEN (is_auth)  TO  1  STEP  -1
	IF isValid (la_btn [ll])	Then
		IF MID (is_auth, ll, 1)='0' Then
			la_btn [ll].visible = FALSE
		Else
			//우측정렬로 버튼정리 간격 12
			la_btn [ll].x = ll_right_x - la_btn [ll].width
			ll_right_x = la_btn [ll].x - 12
		End IF
	End IF
NEXT

dw_view.event ue_retrieve()
end event

event ue_close();//팝업같은경우 구현하여 사용
end event

event ue_add ();STRING	ls_path, la_name[], ls_file, ls_seq

LONG	ll, ll_file, ll_seq, ll_name, ll_row

BLOB	lb_data

IF GetFileOpenName ("첨부파일 선택", ls_path, la_name, '', "All Files (*.*),*.*", '', 2)<>1 THEN RETURN

ll_name = upperbound (la_name)
IF ll_name=0	THEN RETURN

SELECT  MAX (file_seq)
  INTO  :ll_seq
FROM    popup_file
WHERE   file_key = :is_key;

ll_seq = SQLCA.getitemnumber (1)
IF f_num (ll_seq)=0	THEN ll_seq = 0

f_loadingrd (TRUE)

FOR  ll = 1  TO  ll_name
	yield()
	IF ll_name = 1	Then
		ls_file = ls_path
	Else
		ls_file = ls_path + '\' + la_name [ll]
	End IF

	ll_seq ++

	INSERT INTO popup_file
	VALUES ( :is_corp_gr
	       , :is_key
	       , :ll_seq
			 , :la_name [ll]
			 , now()
			 , NULL
			 );

	lb_data = BLOB (' ')

	//압축
	IF	mo_.zip (ls_file, ls_file + '.zip', 'f')<>0	Then
		f_messagebox ('ERR', '압축실패!')
		RETURN
	End IF
	SQLCA.setupdateBLOB_file (ls_file + '.zip')

	UPDATEBLOB  popup_file
	   SET  load_file = :lb_data
	WHERE   file_key = :is_key
	  AND   file_seq = :ll_seq;
	IF SQLCA.sqlcode ()<>0  Then
		f_messageBox ('SQLCA', '파일저장중 오류발생~r~n' + is_key + ':' + string (ll_seq))
		RETURN
	End IF

	filedelete (ls_file + '.zip')	
NEXT
commitJ ()

f_loadingrd (FALSE)

ib_changed = TRUE

dw_view.event ue_retrieve ()
end event

event ue_delete(long row);LONG	ll_seq

IF messageBox ('INFO', '해당 파일을 삭제하시겠습니까?', Question!, OkCancel!)=2	THEN RETURN

ll_seq = dw_view.object.file_seq [row]
DELETE  popup_file
WHERE   file_key = :is_key
  AND   file_seq = :ll_seq;

commitJ ()

dw_view.deleterow (row)
ib_changed = TRUE
end event

event ue_deleteall ();LONG	ll, ll_seq

IF messageBox ('INFO', '모든 파일을 삭제하시겠습니까?', Question!, OkCancel!)=2	THEN RETURN

FOR  ll = 1  TO  dw_view.rowcount()
	ll_seq = dw_view.object.file_seq [ll]

	DELETE  popup_file
	WHERE   file_key = :is_key
	  AND   file_seq = :ll_seq;
NEXT
commitJ()

ib_changed = TRUE

dw_view.event ue_retrieve ()
end event

event ue_download(long row);STRING	ls_path, ls_file

LONG	ll_seq

BLOB	lb_data

BOOLEAN	lb_return

IF getfolder ('파일을 저장할 폴더를 선택하십시요', ls_path)<>1	Then
	RETURN
End IF

IF f_null (ls_path) THEN RETURN
ls_path += '\'
ll_seq = dw_view.object.file_seq [row]
ls_file = dw_view.object.file_name [row]

f_loadingrd (TRUE)

SELECTBLOB  load_file
  INTO  :lb_data
FROM    popup_file
WHERE   file_key = :is_key
  AND   file_seq = :ll_seq;

filedelete (ls_path + ls_file + '.zip')
filedelete (ls_path + ls_file)

lb_return = mo_.hex2file (ls_path + ls_file + '.zip', SQLCA.is_Hexfile)
IF lb_return   Then
	mo_.unzip (ls_path + ls_file + '.zip', ls_path)
	sleep (1)
Else
	f_messageBox ('ERR', '파일생성오류')
End IF

filedelete (ls_path + ls_file + '.zip')
gnv_extfunc.of_shellexecute(ls_path)

f_loadingrd (FALSE)
end event

event ue_downloadall();//다운로드
LONG	ll, ll_seq

STRING	ls_path, ls_file

BLOB	lb_data

BOOLEAN	lb_return

IF dw_view.rowcount()=0	THEN RETURN
IF getfolder ('파일을 저장할 폴더를 선택하십시요', ls_path)<>1	Then
	RETURN
End IF

IF f_null (ls_path) THEN RETURN

ls_path += '\'

f_loadingrd (TRUE)

FOR  ll = 1  TO  dw_view.rowcount()
	yield()
	dw_view.uf_setrow (ll, FALSE)
	ll_seq = dw_view.object.file_seq [ll]
	ls_file = dw_view.object.file_name [ll]

	SELECTBLOB	load_file
	  INTO  :lb_data
	FROM    popup_file
	WHERE   file_key = :is_key
	  AND   file_seq = :ll_seq;

	filedelete (ls_path + ls_file + '.zip')
	filedelete (ls_path + ls_file)
	lb_return = mo_.hex2file (ls_path + ls_file + '.zip', SQLCA.is_Hexfile)
	IF lb_return   Then
		mo_.unzip (ls_path + ls_file + '.zip', ls_path)
		sleep (1)
	Else
		f_messageBox ('ERR', '파일생성오류')
	End IF
	
	filedelete (ls_path + ls_file + '.zip')
NEXT
gnv_extfunc.of_shellexecute(ls_path)

f_loadingrd (FALSE)

messageBox ('INFO', '파일 저장이 완료되었습니다.')
end event

event ue_open(long row);LONG	ll_seq

STRING	ls_file

BLOB	lb_data

BOOLEAN	lb_return

ll_seq = dw_view.object.file_seq [row]
ls_file = dw_view.object.file_name [row]

f_loadingrd (TRUE)

SELECTBLOB  load_file
  INTO  :lb_data
FROM    popup_file
WHERE   file_key = :is_key
  AND   file_seq = :ll_seq;

filedelete (gaa.temp + ls_file + '.zip')
filedelete (gaa.temp + ls_file)

lb_return = mo_.hex2file (gaa.temp + ls_file + '.zip', SQLCA.is_Hexfile)
IF lb_return   Then
	mo_.unzip (gaa.temp + ls_file + '.zip', gaa.temp)
	sleep (1)
Else
	f_messageBox ('ERR', '파일생성오류')
End IF
filedelete (gaa.temp + ls_file + '.zip')
gnv_extfunc.of_shellexecute(gaa.temp + ls_file)

f_loadingrd (FALSE)
end event

public subroutine wf_setenabled ();//
end subroutine

on u_file_manage.create
int iCurrent
call super::create
this.dw_view=create dw_view
this.p_close=create p_close
this.p_down=create p_down
this.p_delete=create p_delete
this.p_add=create p_add
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_view
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.p_down
this.Control[iCurrent+4]=this.p_delete
this.Control[iCurrent+5]=this.p_add
end on

on u_file_manage.destroy
call super::destroy
destroy(this.dw_view)
destroy(this.p_close)
destroy(this.p_down)
destroy(this.p_delete)
destroy(this.p_add)
end on

event resize;call super::resize;dw_view.width = newwidth - 12// - dw_view.x - 33
dw_view.height = newheight - dw_view.y - 12// - 24
end event

type dw_view from u_dw within u_file_manage
integer x = 5
integer y = 140
integer width = 2843
integer height = 452
integer taborder = 10
string dataobject = "d_file_manage"
boolean vscrollbar = true
end type

event ue_insertstart;call super::ue_insertstart;uf_setcolumn ('corp_gr', is_corp_gr)
uf_setcolumn ('auth', is_auth)

RETURN 0
end event

event buttonup;call super::buttonup;IF row=0	THEN RETURN

CHOOSE CASE dwo.name
	CASE 'p_delete'
		event ue_delete (row)
	CASE 'p_open'
		event ue_open (row)
	CASE 'p_download'
		event ue_download (row)
END CHOOSE
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, FALSE)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (is_corp_gr, is_key, is_auth)
end event

type p_close from pf_u_imagebutton within u_file_manage
integer x = 2619
integer y = 24
integer width = 229
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;event ue_close()
end event

type p_down from pf_u_imagebutton within u_file_manage
integer x = 2304
integer y = 24
integer width = 302
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_alldown.jpg"
end type

event clicked;call super::clicked;event ue_downloadall()
end event

type p_delete from pf_u_imagebutton within u_file_manage
integer x = 1989
integer y = 24
integer width = 302
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_alldelete.jpg"
end type

event clicked;call super::clicked;event ue_deleteall ()
end event

type p_add from pf_u_imagebutton within u_file_manage
integer x = 1746
integer y = 24
integer width = 229
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_add.jpg"
end type

event clicked;call super::clicked;event ue_add ()
end event

