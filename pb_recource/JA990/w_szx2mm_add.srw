forward
global type w_szx2mm_add from w_response_s
end type
end forward

global type w_szx2mm_add from w_response_s
integer width = 3013
integer height = 2136
string title = "매매처 추가정보"
end type
global w_szx2mm_add w_szx2mm_add

type variables
str_parameter  sp
end variables

on w_szx2mm_add.create
call super::create
end on

on w_szx2mm_add.destroy
call super::destroy
end on

event open;call super::open;sp = Message.PowerObjectParm
TITLE = sp.str [1]
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_szx2mm_add
end type

type ln_tempstart from w_response_s`ln_tempstart within w_szx2mm_add
end type

type ln_templeft from w_response_s`ln_templeft within w_szx2mm_add
end type

type ln_cond_start from w_response_s`ln_cond_start within w_szx2mm_add
end type

type ln_tempright from w_response_s`ln_tempright within w_szx2mm_add
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_szx2mm_add
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_szx2mm_add
end type

type dw_view from w_response_s`dw_view within w_szx2mm_add
integer width = 2912
string dataobject = "d_szx2mm_add"
end type

event dw_view::ue_retrieve;call super::ue_retrieve;retrieve (sp.str [2])
end event

event dw_view::doubleclicked;call super::doubleclicked;IF row>0 THEN
   sp.str [1] = 'insert'
   sp.str [2] = Object.ksd_cd [row]
   sp.str [3] = Object.xx_ksd_cd [row]
   sp.str [4] = Object.tr_gb [row]
   sp.str [5] = Object.fss_tr_co_cd [row]
   sp.str [6] = Object.xx_fss_tr_co_cd [row]
   sp.str [7] = Object.cut_gb [row]
   sp.str [8] = Object.comp_cd [row]

   INSERT  INTO SZX2MM tt
       ( CORP_GR       /* _1- */
       , TR_CO_CD      /* _2- */
       , TR_CO_NM      /* _3- */
       , TR_GB         /* _4- */
       , FSS_TR_CO_CD  /* _5- */
       , COMP_CD       /* _6- */
       , BANK_CD       /* _7- */
       , USED          /* _8- */
       , CUT_GB        /* _9- */
       , INS_USER      /* _10- */
       )
   VALUES ( :gaa.corp_gr  /* _1- */
          , :sp.str[2]    /* _2- */
          , :sp.str[3]    /* _3- */
          , :sp.str[4]    /* _4- */
          , :sp.str[5]    /* _5- */
          , :sp.str[8]    /* _6- */
          , NULL          /* _7- */
          , '1'           /* _8- */
          , :sp.str[7]    /* _9- */
          , 'ADD'         /* _10- */
          );

   commitJ ()

   CloseWithReturn (parent, sp)
End IF
end event

event dw_view::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (dw_view, 'tr_gb', gaa.corp_gr, '', 1, '')
end event

