forward
global type u_ja021b_t1 from utt_listdetail
end type
end forward

global type u_ja021b_t1 from utt_listdetail
end type
global u_ja021b_t1 u_ja021b_t1

type variables

end variables

on u_ja021b_t1.create
call super::create
end on

on u_ja021b_t1.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja021b_t1
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja021b_t1
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja021b_t1
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja021b_t1
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja021b_t1
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja021b_t1
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja021b_t1
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja021b_t1
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja021b_t1
string dataobject = "d_ja021b_t11"
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'baed_mth', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'baej_mth', gaa.corp_gr, '', 1, "")
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;iu_wpage.tab_string [1] = Object.balh_co [currentrow]
RETURN 0
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
IF f_notnull (Object.tr_ymd [row]) And f_notnull (Object.balh_co [row]) Then
   RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.tr_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
   gnv_rolemenu.of_setopensheet('00941')
End IF
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja021b_t1
string dataobject = "d_ja021b_t12"
boolean ibsetlist4subbtn = false
boolean eb_new_false = true
boolean eb_copy_false = true
end type

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;IF	gaa.aams	Then
	retrieve ('%', dw_pagelist.object.tr_ymd [tRow], dw_pagelist.object.tr_cd [tRow], dw_pagelist.object.balh_co [tRow])
Else
	retrieve (gaa.corp_gr, dw_pagelist.object.tr_ymd [tRow], dw_pagelist.object.tr_cd [tRow], dw_pagelist.object.balh_co [tRow])
End IF
end event

type st_move from utt_listdetail`st_move within u_ja021b_t1
end type

