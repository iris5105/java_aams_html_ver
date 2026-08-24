forward
global type w_api_params from w_winpage
end type
type mle_queryparams from u_mle within w_api_params
end type
type st_1 from pf_u_splitbar_vertical within w_api_params
end type
type mle_url from u_mle within w_api_params
end type
type mle_comments from u_mle within w_api_params
end type
type st_move from pf_u_splitbar_horizontal within w_api_params
end type
type dw_list from u_dw within w_api_params
end type
type mle_q_value from u_mle within w_api_params
end type
end forward

global type w_api_params from w_winpage
boolean eb_direct_retrieve = true
integer ii_dddw_width = 1000
string is_init_value = "00003"
mle_queryparams mle_queryparams
st_1 st_1
mle_url mle_url
mle_comments mle_comments
st_move st_move
dw_list dw_list
mle_q_value mle_q_value
end type
global w_api_params w_api_params

type variables
//BOOLEAN	ib_update = FALSE
end variables

on w_api_params.create
int iCurrent
call super::create
this.mle_queryparams=create mle_queryparams
this.st_1=create st_1
this.mle_url=create mle_url
this.mle_comments=create mle_comments
this.st_move=create st_move
this.dw_list=create dw_list
this.mle_q_value=create mle_q_value
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_queryparams
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.mle_url
this.Control[iCurrent+4]=this.mle_comments
this.Control[iCurrent+5]=this.st_move
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.mle_q_value
end on

on w_api_params.destroy
call super::destroy
destroy(this.mle_queryparams)
destroy(this.st_1)
destroy(this.mle_url)
destroy(this.mle_comments)
destroy(this.st_move)
destroy(this.dw_list)
destroy(this.mle_q_value)
end on

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN

iRow = 0

dw_list.uf_reset (FALSE)
dw_list.Modify (dw_List.ia_protect [4])
dw_list.insertrow (0)

p_retrieve.of_setenabled (true)
EVENT ue_setdisabled ()

dw_c.Enabled = TRUE
dw_c.SetFocus () ; f_selectText (dw_c)

mle_url.uf_init ('', ib_ManageData)
mle_q_value.uf_init ('', ib_ManageData)
mle_comments.uf_init ('', ib_ManageData)
mle_queryparams.uf_init ('', ib_ManageData)
end event

event ue_activate;call super::ue_activate;mle_url.BACKCOLOR         = RGB (240, 255, 255)
mle_q_value.BACKCOLOR     = RGB (240, 255, 255)
mle_comments.BACKCOLOR    = RGB (240, 255, 255)
mle_queryparams.BACKCOLOR = RGB (240, 255, 255)
end event

event wue_update;call super::wue_update;IF dw_list.ACCEPTTEXT () = -1 Then
   F_MESSAGEBOX ('W006', '')
   RETURN -1
END IF

IF mle_url.ib_update         THEN dw_list.object.url [iRow] = mle_url.TEXT
IF mle_q_value.ib_update     THEN dw_list.object.q_value [iRow] = mle_q_value.TEXT
IF mle_comments.ib_update    THEN dw_list.object.comments [iRow] = mle_comments.TEXT
IF mle_queryparams.ib_update THEN dw_list.object.QUERYPARAMS [iRow] = mle_queryparams.TEXT

IF EVENT ue_wpage_Modified () Then
   IF uf_UpdateCommit (dw_list)=-1 THEN RETURN -1
   mle_url.ib_update         = FALSE
   mle_q_value.ib_update     = FALSE
   mle_comments.ib_update    = FALSE
   mle_queryparams.ib_update = FALSE
END IF
RETURN 1
end event

event wue_retrieve;call super::wue_retrieve;mle_url.uf_init ('', ib_ManageData)
mle_q_value.uf_init ('', ib_ManageData)
mle_comments.uf_init ('', ib_ManageData)
mle_queryparams.uf_init ('', ib_ManageData)

ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (dw_c.object.dddw [1])
end event

event ue_wpage_modified;IF dw_list.uf_isModified ()=FALSE And mle_url.ib_update=FALSE And mle_comments.ib_update=FALSE And mle_queryparams.ib_update=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = ia_value [1]

p_retrieve.post event clicked ()
end event

type lb_dirlist from w_winpage`lb_dirlist within w_api_params
end type

type ln_templeft from w_winpage`ln_templeft within w_api_params
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_api_params
end type

type ln_temptop from w_winpage`ln_temptop within w_api_params
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_api_params
end type

type ln_tempstart from w_winpage`ln_tempstart within w_api_params
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_api_params
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_api_params
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_api_params
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_api_params
end type

type ln_tempright from w_winpage`ln_tempright within w_api_params
end type

type uo_navi from w_winpage`uo_navi within w_api_params
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_api_params
end type

type st_windelaytime from w_winpage`st_windelaytime within w_api_params
end type

type st_top_rect from w_winpage`st_top_rect within w_api_params
end type

type p_close from w_winpage`p_close within w_api_params
end type

type p_excel from w_winpage`p_excel within w_api_params
end type

type p_print from w_winpage`p_print within w_api_params
end type

type p_delete from w_winpage`p_delete within w_api_params
end type

type p_update from w_winpage`p_update within w_api_params
end type

type p_input from w_winpage`p_input within w_api_params
end type

type p_retrieve from w_winpage`p_retrieve within w_api_params
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
IF	p_clear.visible	Then
	p_clear.of_setenabled (true)
	of_setenabled (false)
End IF
dw_List.uf_protect (0, dw_List.ia_protect [1])

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_api_params
end type

type p_copy from w_winpage`p_copy within w_api_params
end type

type dw_c from w_winpage`dw_c within w_api_params
string tag = "URL / API_Q 요청자료 (더블클릭)생성 / COMMENTS / QUERYPARAMS  ( ctrl + 오늘쪽화살표로 TAB 설정 )"
string title = "매매처"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

type btn_update from w_winpage`btn_update within w_api_params
end type

type st_count from w_winpage`st_count within w_api_params
end type

type mle_queryparams from u_mle within w_api_params
integer x = 3387
integer y = 2008
integer width = 2048
integer height = 756
integer taborder = 70
boolean bringtotop = true
fontpitch fontpitch = fixed!
string facename = "D2Coding"
string text = "QUERYPARMS"
boolean scaletoright = true
boolean scaletobottom = true
end type

event constructor;//
end event

event key;ib_update = TRUE

STRING	ls_data

LONG	lPos

lPos = Position ()

IF keyflags=2	Then
	CHOOSE CASE key
		CASE KeyRightArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,true))
			RETURN 1
		CASE KeyLeftArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,false))
			RETURN 1
		CASE KeyY!
			SelectText (POS (TEXT, TextLine ()), Len (TextLine ()) + 1)
			clear ()
			RETURN
		CASE KeyZ!
			undo ()
			RETURN
	END CHOOSE
	RETURN 1
END IF
end event

type st_1 from pf_u_splitbar_vertical within w_api_params
integer x = 3355
integer y = 348
integer height = 2420
boolean bringtotop = true
boolean setcondcolor = true
boolean leftmaxsizefixed = true
string leftdragobject = "dw_list"
string rightdragobject = "mle_url;mle_q_value;mle_comments;st_move;mle_queryparams"
end type

type mle_url from u_mle within w_api_params
integer x = 3383
integer y = 348
integer width = 2048
integer height = 240
integer taborder = 70
boolean bringtotop = true
fontpitch fontpitch = fixed!
string facename = "D2Coding"
string text = "URL"
boolean scaletoright = true
end type

event constructor;//
end event

event key;ib_update = TRUE

STRING	ls_data

LONG	lPos

lPos = Position ()

IF keyflags=2	Then
	CHOOSE CASE key
		CASE KeyRightArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,true))
			RETURN 1
		CASE KeyLeftArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,false))
			RETURN 1
		CASE KeyY!
			SelectText (POS (TEXT, TextLine ()), Len (TextLine ()) + 1)
			clear ()
			RETURN
		CASE KeyZ!
			undo ()
			RETURN
	END CHOOSE
	RETURN 1
END IF
end event

type mle_comments from u_mle within w_api_params
integer x = 3383
integer y = 936
integer width = 2048
integer height = 1040
integer taborder = 80
boolean bringtotop = true
fontpitch fontpitch = fixed!
string facename = "D2Coding"
string text = "COMMENTS"
boolean scaletoright = true
end type

event constructor;//
end event

event key;ib_update = TRUE

STRING	ls_data

LONG	lPos

lPos = Position ()

IF keyflags=2	Then
	CHOOSE CASE key
		CASE KeyRightArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,true))
			RETURN 1
		CASE KeyLeftArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,false))
			RETURN 1
		CASE KeyY!
			SelectText (POS (TEXT, TextLine ()), Len (TextLine ()) + 1)
			clear ()
			RETURN
		CASE KeyZ!
			undo ()
			RETURN
	END CHOOSE
	RETURN 1
END IF
end event

type st_move from pf_u_splitbar_horizontal within w_api_params
integer x = 3383
integer y = 1984
integer width = 2048
boolean bringtotop = true
boolean setcondcolor = true
string topdragobject = "mle_comments"
string bottomdragobject = "mle_queryparams"
end type

type dw_list from u_dw within w_api_params
integer x = 50
integer y = 348
integer width = 3296
integer height = 2416
integer taborder = 55
string dataobject = "d_api_params"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
string is_receivetype = "sqlm"
boolean scaletobottom = true
boolean ibsettooltiphelp = true
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;mle_url.BACKCOLOR      = RGB (240, 255, 255)
mle_q_value.BACKCOLOR = RGB (240, 255, 255)
mle_comments.BACKCOLOR = RGB (240, 255, 255)
mle_queryparams.BACKCOLOR   = RGB (240, 255, 255)

iRow = currentrow

STRING ls_data

ls_data = Object.url [iRow]         ; mle_url.TEXT         = f_tab (2,ls_data, false)
ls_data = Object.q_value [iRow]     ; mle_q_value.TEXT    = f_tab (2,ls_data, false)
ls_data = Object.comments [iRow]    ; mle_comments.TEXT    = f_tab (2,ls_data, false)
ls_data = Object.queryparams [iRow] ; mle_queryparams.TEXT = f_tab (2,ls_data, false)

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_url.uf_reset (TRUE)
mle_q_value.uf_reset (TRUE)
mle_comments.uf_reset (TRUE)
mle_queryparams.uf_reset (TRUE)
RETURN 0
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;IF mle_url.ib_update         THEN Object.url [iRow]         = mle_url.TEXT
IF mle_q_value.ib_update     THEN Object.q_value [iRow]     = mle_q_value.TEXT
IF mle_comments.ib_update    THEN Object.comments [iRow]    = mle_comments.TEXT
IF mle_queryparams.ib_update THEN Object.queryparams [iRow] = mle_queryparams.TEXT
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;uf_setcolumn ('tr_co_cd', dw_c.object.dddw [1])
IF	iRow=0	Then
	uf_setcolumn ('gr_cd', '1')
Else
	uf_setcolumn ('gr_cd', Object.gr_cd [iRow])
End IF

IF mle_url.ib_update         THEN Object.url [iRow] = mle_url.TEXT
IF mle_q_value.ib_update     THEN Object.q_value [iRow] = mle_q_value.TEXT
IF mle_comments.ib_update    THEN Object.comments [iRow] = mle_comments.TEXT
IF mle_queryparams.ib_update THEN Object.queryparams [iRow] = mle_queryparams.TEXT

mle_url.ib_update         = FALSE
mle_q_value.ib_update     = FALSE
mle_comments.ib_update    = FALSE
mle_queryparams.ib_update = FALSE

POST SetColumn ('gr_cd')

RETURN 0
end event

event rowfocuschanged;call super::rowfocuschanged;IF currentrow=0 OR NOT Enabled THEN RETURN
iRow = currentrow
end event

type mle_q_value from u_mle within w_api_params
integer x = 3383
integer y = 596
integer width = 2048
integer height = 332
integer taborder = 80
boolean bringtotop = true
fontpitch fontpitch = fixed!
string facename = "D2Coding"
string text = "API_Q VALUE"
boolean scaletoright = true
end type

event constructor;//
end event

event key;ib_update = TRUE

STRING	ls_data

LONG	lPos

lPos = Position ()

IF keyflags=2	Then
	CHOOSE CASE key
		CASE KeyRightArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,true))
			RETURN 1
		CASE KeyLeftArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,false))
			RETURN 1
		CASE KeyY!
			SelectText (POS (TEXT, TextLine ()), Len (TextLine ()) + 1)
			clear ()
			RETURN
		CASE KeyZ!
			undo ()
			RETURN
	END CHOOSE
	RETURN 1
END IF
end event

event doubleclicked;call super::doubleclicked;STRING	ls_company, ls_url, ls_headers, ls_params, ls_table, ls_sub, ls_key, ls_sub_key

ls_company = dw_list.object.company [iRow]
ls_url     = dw_list.object.url [iRow]
ls_headers = dw_list.object.headers [iRow]
ls_params  = this.TEXT
ls_table   = dw_list.object.tablename [iRow]
ls_sub     = dw_list.object.subtable [iRow]
ls_key     = dw_list.object.key_value [iRow]
ls_sub_key = dw_list.object.sub_key_value [iRow]

INSERT INTO API_Q
    ( COMPANY        /* _1- */
    , URL            /* _2- */
    , HEADERS        /* _3- */
    , QUERYPARAMS    /* _4- */
    , TABLENAME      /* _5- */
    , SUBTABLE       /* _6- */
    , REQUEST        /* _7- */
    , API_KEY        /* _8- */
    , KEY_VALUE      /* _9- */
    , SUB_KEY_VALUE  /* _10- */
    , PG_NM			   /* _11- */
    )
VALUES ( :ls_company                                                 /* _1- */
       , :ls_url                                                     /* _2- */
       , :ls_headers                                                 /* _3- */
       , :ls_params                                                  /* _4- */
       , :ls_table                                                   /* _5- */
       , :ls_sub                                                     /* _6- */
       , '0'                                                         /* _7- */
       , TO_CHAR(sysdate,'yyyymmdd') || '-' || RAWTOHEX(SYS_GUID())  /* _8- */
       , :ls_key                                                     /* _9- */
       , :ls_sub_key                                                 /* _10- */
       , 'W_API_PARAMS'                                              /* _11- */
       ) ;

commitJ ()

f_messageBox ('I000', 'API_Q에 요청자료 생성완료!!!')
end event

