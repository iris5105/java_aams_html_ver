forward
global type n_resql from nonvisualobject
end type
end forward

global type n_resql from nonvisualobject
end type
global n_resql n_resql

type prototypes

end prototypes

type variables

end variables

forward prototypes
public function string nf_decode (string arg_decode)
public function integer nf_first (string ls_bef, string ls_cur)
public function integer nf_dml_first (string ls_bef, string ls_cur)
public function string nf_0 (string arg_space, string arg_text, boolean arg_order)
public function long rt_line (string arg_line, ref string ra_word[])
public function boolean nf_comp (string arg_comp_str[], string arg_str)
public function string nf_clear_sqm (string arg_line, boolean arg_comment_clear)
public function string nf_clear (string arg_text)
public function string wf_line_comment (string arg_line[], long arg_ll_line, ref long arg_ll, boolean arg_move)
public function string wf_dml_insert (string arg_insert)
public function string nf_add_comment (string arg_comment, string add_comment)
public function string wf_deselect (string arg_text)
public function string wf_bracket_space (string arg_line)
public function string wf_add_comment_num (string arg_line, string arg_comment, long arg_colnum, boolean arg_space)
public function string wf_dml_update (string arg_update)
public function s_ret nf_bracket_pivot (string arg_text[], long arg_ll_text, long arg_ll, long arg_lm)
public function string wf_move (string arg_move_line, long arg_move, boolean arg_trim)
public function string wf_move_force (string arg_move_line, string arg_move)
public function string wf_move_back (string arg_move_line, integer arg_back)
public function string wf_with (string arg_with)
public function string nf_1space (string arg_word)
public function string wf_dml_where_line (long arg_max, string arg_t1, string arg_t2, string arg_t3, string arg_xml_if, string arg_t5, string arg_t6, boolean arg_where)
public function s_ret wf_dml_where (string arg_where[], string arg_alias[], string arg_table[], string arg_join_table[], ref s_where_add_column arg_add_where, long arg_ll_where, long arg_ll, long arg_lm)
public function string wf_in (string arg_line, string arg_in)
public function string wf_dml_update_set (ref long arg_ll, ref long arg_lm, string arg_line[], string arg_end[])
public function string wf_case (string arg_case)
public function string nf_case_space (string arg_case, string arg_bracket[])
public function string wf_dml_select_as (string arg_select[], long arg_ll)
public function string wf_dml (string arg_dml, string arg_space)
public function string nf_dml_space (string arg_array[], long arg_dml)
public function string wf_fetch_list (string arg_fetch[], long al_fetch, integer ai_step)
public function string wf_setting_max (string assign_word, long ll_start, long ll_line, ref long target_end, ref string la_line[])
public function string wf_indentation_space (integer arg_begin, string begin_space[], integer arg_if, string if_space[], integer arg_for, string for_space[], integer arg_do, string do_space[])
public function string wf_assign_max (boolean arg_begin, string assign_word, long ll_start, long ll_line, boolean lb_begin, ref long assign_end, ref string la_line[])
public function string wf_4space (string arg_line)
public function string wf_dml_select (string arg_select)
public function string wf_on_where (string arg_text, string arg_alias)
public function string wf_bracket_comma (string arg_comma)
public function s_ret wf_func_str (string arg_text[], long arg_ll_text, long arg_ll, long arg_lm)
public function long wt_line (string arg_line, ref string ra_word[])
public function string wf_bracket (string arg_text)
public function string wf_1 (string arg_text)
public function long nf_bracket_space (string arg_line)
public function long nf_select_column (string arg_line[])
public function integer nf_case_first (string arg_bef, string arg_cur)
public function string wf_dml_merge (string arg_merge)
public function long rt_file (string arg_line, ref string ra_word[])
end prototypes

public function string nf_decode (string arg_decode);BOOLEAN	lb_1line, lb_first, lb_value = TRUE, lb_result = TRUE, lb_end = FALSE
STRING	la_decode [], la_case [], ra_word [], la_comment [], ls_add_comment, ls_comment = ''
STRING	ls_line = '', ls_return, ls_when, ls_value, ls_result, ls_text, ls_s, ls_e

LONG	ll, lm, lm_word, lm_when, ll_decode, in_case = 0, ll_bracket, in_bracket, lCase = 0, lm_case, ll_comma, ll_comment

// decode를 case 변경시 내부 관리문자 clear
ll_decode = f_get_array (nf_clear (arg_decode), '~r~n', la_decode)
FOR  ll = 1  TO  ll_decode
	IF	f_null (la_decode [ll]) THEN CONTINUE
	lm_word = rt_line (la_decode [ll], ra_word)
	lm = 1
	FOR  lm = lm  TO  lm_word
		IF	ra_word [lm]='' THEN CONTINUE
		IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
			IF	ll_comment>0	Then
				IF	lm>2	Then
					IF	ra_word [lm - 2] = ','	Then
						la_comment [ll_comment - 1] = ra_word [lm]
					Else
						la_comment [ll_comment] = ra_word [lm]
					End IF
				Else
					la_comment [ll_comment] = ra_word [lm]
				End IF
			Else
				ls_comment += ra_word [lm]
			End IF
			CONTINUE
		End IF
		CHOOSE CASE lower (ra_word [lm])
			CASE 'decode'
				ls_line += ra_word [lm] + ' '
			CASE 'case','select'
				lCase ++ ; la_case [lCase] = ''
				IF	lower (ra_word [lm])='case'	Then
					ls_s = 'case' ; ls_e = 'end'
					in_bracket = 0
				Else
					ls_s = '(' ; ls_e = ')'
					in_bracket = 1
				End IF
				FOR  ll = ll  TO  ll_decode
					lm_word = rt_line (la_decode [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_s
								in_bracket ++
							CASE ls_e
								in_bracket --
								IF	ls_e='end' And in_bracket=0 THEN la_case [lCase] += ra_word [lm]
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
						la_case [lCase] += ra_word [lm]
					NEXT
					IF	in_bracket=0 THEN EXIT
					la_case [lCase] += '~r~n'
					lm = 1
				NEXT
				ls_line += '[BRACKET' + string(lCase) + '] ' + IIF (ls_e=')',')','')
				IF	ll>ll_decode THEN EXIT
			CASE ELSE
				IF	ra_word [lm]=','	Then
					ll_comma ++
					CHOOSE CASE ll_comma
						CASE 2,4,6,8,10,12,14,16,18,20,22,24,26,28
							ll_comment ++
					END CHOOSE
				End IF
				ls_line += ra_word [lm] + ' '
		END CHOOSE
	NEXT
NEXT

lm_word = rt_line (ls_line, ra_word)
// decode 조건생성
ls_when = ''
ll_bracket = 1
FOR  lm = 5  TO  lm_word
	FOR  lm = lm  TO  lm_word
		CHOOSE CASE ra_word [lm]
			CASE '('
				ll_bracket ++
			CASE ')'
				ll_bracket --
			CASE ','
				IF	ll_bracket=1 THEN EXIT
		END CHOOSE
		ls_when += nf_1space (ra_word [lm])
	NEXT
	EXIT
NEXT

lb_1line = TRUE; lb_first = TRUE
ll_comma = 0 ; ll_comment = 0
in_bracket = 1
ls_value = 'CASE WHEN ' + TRIM (ls_when) + '='
lm_when = lm
FOR  lm = lm + 2  TO  lm_word
	IF	ra_word [lm]='' THEN CONTINUE
	IF	RIGHT (TRIM (ls_value),1)='(' OR ra_word [lm]=')' THEN ls_value = RIGHTTRIM (ls_value)
	CHOOSE CASE lower (ra_word [lm])
		CASE 'decode','case','select'
			lb_1line = FALSE
			EXIT
		CASE ','
			ll_comment ++
			IF	ll_comment <= UPPERBOUND (la_comment) THEN ls_add_comment = la_comment [ll_comment]
			IF	in_bracket=1	Then
				ll_comma ++
				IF	ll_comma>2	Then
					lb_1line = FALSE
					EXIT
				End IF
				CONTINUE
			End IF
		CASE '('
			in_bracket ++
		CASE ')'
			in_bracket --
			IF	in_bracket=0 THEN EXIT
	END CHOOSE
	IF	ll_comma=0	Then
		IF	lower (ra_word [lm])='null'	Then
			ls_value = 'CASE WHEN ' + RIGHTTRIM (ls_when) + ' IS NULL'
		Else
			ls_value += nf_1space (ra_word [lm])
		End IF
	ElseIF ll_comma=1	Then
		IF	lb_first THEN ls_value = RIGHTTRIM (ls_value) + ' THEN '
		lb_first = FALSE
		ls_value += ra_word [lm]
		IF	f_notnull (ra_word [lm]) And f_notnull (ls_add_comment)	Then
			ls_value += '  ' + ls_add_comment
			ls_add_comment = ''
		End IF
	Else
		IF	NOT lb_first THEN ls_value += '~r~n ELSE '
		lb_first = TRUE
		ls_value += ra_word [lm]
		IF	f_notnull (ra_word [lm]) And f_notnull (ls_add_comment)	Then
			ls_value += '  ' + ls_add_comment
			ls_add_comment = ''
		End IF
	End IF
NEXT
IF	lb_1line	Then
	FOR  ll = 1  TO  lCase
		ls_value = f_replace (ls_value, '[BRACKET' + string(ll) + ']', la_case [ll])
	NEXT
	ls_value += '~r~n END'
	IF	f_notnull (ls_add_comment)	Then
		ls_value += '  ' + ls_add_comment
		ls_add_comment = ''
	End IF
	RETURN	ls_value
End IF

ls_return = 'CASE ' + ls_when + ' '
ll_comment = 0
FOR  lm = lm_when + 2  TO  lm_word
	IF	f_null (ra_word [lm]) OR ra_word [lm]=',' THEN CONTINUE
	// decode 조건값
	IF	lb_value	Then
		ls_value = ''
		FOR  lm = lm  TO  lm_word
			IF	f_null (ra_word [lm]) And LEFT (ra_word [lm],1)=' ' THEN ra_word [lm] = ' '
			CHOOSE CASE lower (ra_word [lm])
				CASE 'decode'
					in_bracket = 0 ; ls_text = ''
					FOR  lm = lm  TO  lm_word
						ls_text += ra_word [lm]
						CHOOSE CASE ra_word [lm]
							CASE '('
								in_bracket ++
							CASE ')'
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					ls_value += '~r~n' + nf_decode (ls_text) + '~r~n'
					CONTINUE
				CASE '('
					ll_bracket ++
				CASE ')'
					ll_bracket --
					IF	ll_bracket=0	Then
						lb_end = TRUE
						EXIT
					End IF
				CASE ','
					IF	ll_bracket=1 THEN EXIT
			END CHOOSE
			ls_value += ra_word [lm]
		NEXT
		IF	lb_end	Then
			ls_return += '~r~nELSE ' + ls_value + '~r~n END '
			EXIT
		End IF
		ls_return += '~r~n          WHEN ' + RIGHTTRIM (ls_value) + ' THEN '
		lb_value = FALSE
	End IF

	ls_result = ''
	FOR  lm = lm + 2  TO  lm_word
		IF	ra_word [lm]='' THEN CONTINUE
		CHOOSE CASE lower (ra_word [lm])
			CASE 'decode'
				in_bracket = 0 ; ls_text = ''
				FOR  lm = lm  TO  lm_word
					ls_text += nf_1space (ra_word [lm])
					CHOOSE CASE ra_word [lm]
						CASE '('
							in_bracket ++
						CASE ')'
							in_bracket --
							IF	in_bracket=0 THEN EXIT
					END CHOOSE
				NEXT
				ls_result += '~r~n    ' + nf_decode (ls_text) + '~r~n'
				CONTINUE
			CASE '('
				ll_bracket ++
			CASE ')'
				IF	ll_bracket=1 THEN EXIT
				ll_bracket --
			CASE ','
				IF	ll_bracket=1 THEN EXIT
		END CHOOSE
		ls_result += nf_1space (ra_word [lm])
		IF	f_notnull (ra_word [lm])	Then
			ll_comment ++
			IF	ll_comment <= UPPERBOUND (la_comment)	Then
				ls_result += '  ' + la_comment [ll_comment]
			End IF
		End IF
	NEXT
	ls_return += ls_result
	lb_value = TRUE
NEXT
IF	NOT lb_end THEN ls_return += '~r~n END ' + ls_comment

FOR  ll = 1  TO  lCase
	ls_return = f_replace (ls_return, '[BRACKET' + string(ll) + ']', la_case [ll])
NEXT

RETURN	ls_return
end function

public function integer nf_first (string ls_bef, string ls_cur);LONG	ll_first = 0, ll_LeftTRIM = 999

STRING	ls_space = ''

IF	POS (ls_bef,'~r~n')>0 THEN ls_bef = MID (ls_bef, LASTPOS (ls_bef, '~r~n') + 2)
ls_bef = lower (nf_clear_sqm (nf_clear (ls_bef), true))
ls_cur = UPPER (nf_clear_sqm (ls_cur, true))

IF	LEFT (ls_cur,1)=','	Then
	IF	POS (ls_bef,'in (')>0	Then
		IF	POS (ls_bef,"','")>0	Then
			RETURN	PosA (ls_bef,"',") + 1
		Else
			RETURN	PosA (ls_bef,'in (') + 3
		End IF
	End IF
	IF	LEFT (TRIM (ls_bef),1)=','                                                THEN ll_first = PosA (ls_bef,',')
	IF	LEFT (TRIM (ls_bef),1)='(' And (PosA (ls_bef,'(')<ll_first OR ll_first=0) THEN ll_first = PosA (ls_bef,'(')
	IF	POS (ls_bef,'(')>0         And (PosA (ls_bef,'(')<ll_first OR ll_first=0) THEN ll_first = PosA (ls_bef,'(')
Else
	IF	LEFT (ls_cur,2)='||' And POS (ls_bef,'||')>0	Then
		ll_first = PosA (ls_bef,'||')
		IF	POS (ls_cur,'COALESCE')>0 And POS (ls_bef,'coalesce')>0 And (PosA (ls_bef,'coalesce') - 8)<ll_first THEN ll_first = PosA (ls_bef,'coalesce') - 8
		IF	POS (ls_cur,'NVL')>0 And POS (ls_bef,'nvl')>0 And (PosA (ls_bef,'nvl') - 3)<ll_first THEN ll_first = PosA (ls_bef,'nvl') - 3
		IF	POS (ls_cur,'MAX')>0 And POS (ls_bef,'max')>0 And (PosA (ls_bef,'max') - 3)<ll_first THEN ll_first = PosA (ls_bef,'max') - 3
		IF	POS (ls_cur,'SUM')>0 And POS (ls_bef,'sum')>0 And (PosA (ls_bef,'sum') - 3)<ll_first THEN ll_first = PosA (ls_bef,'sum') - 3
		RETURN ll_first
	End IF
	IF	ll_first=0 And nf_comp ({'+','-','*','/'}, LEFT (ls_cur,1))	Then
		IF	POS (ls_bef,'+')>0                                   THEN ll_LeftTRIM = PosA (ls_bef,'+') - 1
		IF	POS (ls_bef,'-')>0 And PosA (ls_bef,'-')<ll_LeftTRIM THEN ll_LeftTRIM = PosA (ls_bef,'-') - 1
		IF	POS (ls_bef,'*')>0 And PosA (ls_bef,'*')<ll_LeftTRIM THEN ll_LeftTRIM = PosA (ls_bef,'*') - 1
		IF	POS (ls_bef,'/')>0 And PosA (ls_bef,'/')<ll_LeftTRIM THEN ll_LeftTRIM = PosA (ls_bef,'/') - 1
		IF	ll_LeftTRIM<999 THEN ll_first = ll_LeftTRIM
	ElseIF POS (ls_bef,'elsif')>0	Then
		RETURN PosA (ls_bef,'elsif') + 6
	Else
		IF	(POS (ls_bef,'or')>0 OR POS (ls_bef,'and')>0 OR POS (ls_bef,'(')>0 OR POS (ls_bef,'if ')>0) &
				And (LEFT (ls_cur,3)='OR ' OR LEFT (ls_cur,4)='AND ')	Then
			IF	POS (ls_bef,'and ')>0               THEN ll_first = PosA (ls_bef,'and ')
			IF	ll_first=0 And POS (ls_bef,'or ')>0 THEN ll_first = PosA (ls_bef,'or ')
			IF	ll_first=0 And POS (ls_bef,'(')>0   THEN ll_first = PosA (ls_bef,'(')
			IF	ll_first=0 And POS (ls_bef,'if ')>0 THEN ll_first = PosA (ls_bef,'if ') + 8
			RETURN ll_first
		Else
			IF	POS (ls_bef,'(')>0	Then
				ll_first = PosA (ls_bef,'(') + 1
				ll_LeftTRIM = 0
			End IF
			IF	PosA (ls_bef,',')<ll_first And LEFT (ls_bef,1)=' '	Then
				DO WHILE TRUE
					ls_space += ' '
					ls_bef = MID (ls_bef, 2)
					IF	LEFT (ls_bef,1)<>' ' OR LEN (ls_bef)=0 THEN EXIT
				LOOP				
				ll_first = MIN (ll_first, LEN (ls_space) + 1)
				ll_LeftTRIM = 0
			End IF
		End IF
	End IF
End IF
RETURN ll_first
end function

public function integer nf_dml_first (string ls_bef, string ls_cur);LONG	ll_first = 0, ll_leftpos = 999

IF	POS (ls_bef,'~r~n')>0 THEN ls_bef = MID (ls_bef, LASTPOS (ls_bef, '~r~n') + 2)
ls_bef = lower (nf_clear_sqm (nf_clear (ls_bef), true))
ls_cur = lower (TRIM (ls_cur))

IF	LEFT (ls_cur,1)=',' And (POS (ls_bef,'from') + POS (ls_bef,'select'))=0	Then
	IF	POS (ls_bef,'in (')>0	Then
		IF	POS (ls_bef,"','")>0	Then
			RETURN	PosA (ls_bef,"',",PosA (ls_bef,'in (')) + 1
		Else
			RETURN	PosA (ls_bef,'in (') + 3
		End IF
	ElseIF LEFT (LEFTTRIM (ls_bef),1)=','	Then
		RETURN	PosA (ls_bef,',') - 1
	ElseIF LEFT (LEFTTRIM (ls_bef),1)='('	Then
		RETURN	PosA (ls_bef,'(')
	ElseIF POS (ls_bef,'values')>0	Then
		RETURN	PosA (ls_bef,'(')
	End IF
	IF	POS (ls_bef,'+')>0                                  THEN ll_leftpos = PosA (ls_bef,'+') - 1
	IF	POS (ls_bef,'-')>0 And PosA (ls_bef,'-')<ll_leftpos THEN ll_leftpos = PosA (ls_bef,'-') - 1
	IF	POS (ls_bef,'*')>0 And PosA (ls_bef,'*')<ll_leftpos THEN ll_leftpos = PosA (ls_bef,'*') - 1
	IF	POS (ls_bef,'/')>0 And PosA (ls_bef,'/')<ll_leftpos THEN ll_leftpos = PosA (ls_bef,'/') - 1
	IF	ll_leftpos<999 THEN RETURN ll_leftpos
ElseIF (LEFT (LEFTTRIM (ls_bef),1)=',' OR POS(ls_bef,'outer')>0) And POS (ls_bef,'select')>0 	Then
	RETURN	PosA (ls_bef,'select')
ElseIF POS (ls_bef,'=')>0 And nf_comp ({'+','-','*','/'}, LEFT (ls_cur,1))	Then
	ll_first = PosA (ls_bef,'=') + 2
ElseIF nf_comp ({',','('}, LEFT (ls_cur,1))	Then
	IF	POS (ls_bef,',')>0                    THEN ll_leftpos = PosA (ls_bef,',')
	IF	POS (ls_bef,'(')>0 And ll_leftpos=999 THEN ll_leftpos = PosA (ls_bef,'(')
	IF	ll_leftpos<999 THEN RETURN ll_leftpos
End IF

IF	LEFT (ls_bef,6)='insert'	Then
	ll_first = 6
Else
	IF	LEFT (ls_cur,2)='||'	Then
		IF	POS (ls_bef,'||')>0	Then
			ll_first = PosA (ls_bef,'||')
			IF	POS (ls_cur,'coalesce')>0 And POS (ls_bef,'coalesce')>0 And (PosA (ls_bef,'coalesce') - 8)<ll_first THEN ll_first = PosA (ls_bef,'coalesce') - 8
			IF	POS (ls_cur,'nvl')>0 And POS (ls_bef,'nvl')>0 And (PosA (ls_bef,'nvl') - 3)<ll_first THEN ll_first = PosA (ls_bef,'nvl') - 3
			IF	POS (ls_cur,'max')>0 And POS (ls_bef,'max')>0 And (PosA (ls_bef,'max') - 3)<ll_first THEN ll_first = PosA (ls_bef,'max') - 3
			IF	POS (ls_cur,'sum')>0 And POS (ls_bef,'sum')>0 And (PosA (ls_bef,'sum') - 3)<ll_first THEN ll_first = PosA (ls_bef,'sum') - 3
		Else
			ll_first = 8
		End IF
	End IF
	IF	ll_first=0 And nf_comp ({'+','-','*','/'}, LEFT (ls_cur,1))	Then
		ll_leftpos = 999
		IF	POS (ls_bef,'+')>0                                  THEN ll_leftpos = PosA (ls_bef,'+') - 1
		IF	POS (ls_bef,'-')>0 And PosA (ls_bef,'-')<ll_leftpos THEN ll_leftpos = PosA (ls_bef,'-') - 1
		IF	POS (ls_bef,'*')>0 And PosA (ls_bef,'*')<ll_leftpos THEN ll_leftpos = PosA (ls_bef,'*') - 1
		IF	POS (ls_bef,'/')>0 And PosA (ls_bef,'/')<ll_leftpos THEN ll_leftpos = PosA (ls_bef,'/') - 1
		IF	ll_leftpos<999	Then
			ll_first = ll_leftpos
		Else
			IF	POS (lower (ls_bef),'case')>0	THEN ll_first = PosA (ls_bef,'case')
		End IF
	End IF
	IF	POS (ls_bef,',')>0 And ll_first=0 THEN ll_first = PosA (ls_bef,',') + 1
End IF

RETURN ll_first
end function

public function string nf_0 (string arg_space, string arg_text, boolean arg_order);LONG  ll, ll_text, ll_before, ll_first

BOOLEAN  lb_first = true, lb_single, lb_pc

STRING   ls_text, ls_exec = '', la_text []
STRING   ls_tab, ls_space, ls_hint, ls_temp

ls_text = nf_clear (arg_text)

ll_text = f_get_array (ls_text, '~r~n', la_text)
IF	POS (ls_text,'~t')>0	Then	// TAB --> SPACE로
	//messagebox ('변환', 'TAB --> SPACE로')
	FOR  ll = 1  TO  ll_text
		IF	POS (la_text [ll],'~t')>0	Then
			ls_tab = la_text [ll]
			la_text [ll] = ''
			DO WHILE TRUE
				IF	LEFT (ls_tab,1)='~t'	Then
					la_text [ll] = LeftA (la_text [ll] + '    ', truncate((LenA (la_text [ll]) + 4) / 4, 0) * 4)
				Else
					la_text [ll] += LEFT (ls_tab,1)
				End IF
				ls_tab = MID (ls_tab, 2)
				IF	f_null (ls_tab) THEN EXIT
			LOOP
		End IF
	NEXT
End IF

ls_text = ''
FOR  ll = 1  TO  ll_text
	IF	lb_first And f_null (la_text [ll]) THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_text [ll]),2))	Then
		IF f_notnull (ls_text) And RIGHT (ls_text,2)<>'~r~n' THEN ls_text += '~r~n'
		ls_text += wf_line_comment (la_text, ll_text, ll, false)
		lb_first = false
		CONTINUE
	ElseIF lower (la_text [ll])='from'	Then
		IF	f_notnull (ls_text) And RIGHT (ls_text,2)<>'~r~n' THEN ls_text += '~r~n'
		ls_text += la_text [ll]
		FOR  ll = ll + 1  TO  ll_text
			IF	f_null (la_text [ll]) THEN CONTINUE
			ls_text += ' ' + la_text [ll]
			IF	lower (la_text [ll])='('	Then
				CONTINUE
			Else
				EXIT
			End IF
		NEXT
		lb_first = false
		CONTINUE
	End IF
	lb_first = FALSE
NEXT
ls_text = TRIM (LEFT (ls_text, LEN (ls_text) - 2))

gl_select_step = 1
gl_select      = 0

CHOOSE CASE lower (LEFT (ls_text,6))
	CASE 'insert'
		IF RIGHT (ls_text,1)=';'	Then
			ls_text = LEFT (ls_text, LEN (ls_text) - 1)
			lb_single = true
		End IF
		ls_text = wf_dml_insert (ls_text)
		IF POS (ls_text,'[SELECT-')>0 THEN ls_text = wf_deselect (ls_text)
	CASE 'update','delete'
		IF RIGHT (ls_text,1)=';'	Then
			ls_text = LEFT (ls_text, LEN (ls_text) - 1)
			lb_single = true
		End IF
		ls_text = wf_dml_update (ls_text)
		IF POS (ls_text,'[SELECT-')>0 THEN ls_text = wf_deselect (ls_text)
	CASE ELSE
		IF	lower (LEFT (ls_text,4))='with'	Then
			IF RIGHT (ls_text,1)=';'	Then
				ls_text = LEFT (ls_text, LEN (ls_text) - 1)
				lb_single = true
			End IF
			ls_text = wf_with (ls_text)
			IF POS (ls_text,'[SELECT-')>0 THEN ls_text = wf_deselect (ls_text)
		ElseIF lower (LEFT (ls_text,5))='merge'	Then
			IF RIGHT (ls_text,1)=';'	Then
				ls_text = LEFT (ls_text, LEN (ls_text) - 1)
				lb_single = true
			End IF
			ls_text = wf_dml_merge (ls_text)
			IF POS (ls_text,'[SELECT-')>0 THEN ls_text = wf_deselect (ls_text)
		Else
			ls_text = wf_1 (ls_text)
			IF	POS (ls_text,'[SPACE')>0	Then
				ll_text = f_get_array (ls_text, '~r~n', la_text)
				ls_text = '' ; ll_before = 1
				lb_first = TRUE
				FOR  ll = 1  TO  ll_text
					IF	ll=1 THEN la_text [ll] = nf_clear (la_text [ll])
					IF	POS (la_text [ll],'[SPACE^]')>0	Then
						la_text [ll] = nf_clear (la_text [ll])
						ll_first = nf_first (la_text [ll_before], LEFTTRIM (la_text [ll]))
						IF	ll_first>0 THEN ls_space = SPACE (ll_first - 1)
						la_text [ll] = ls_space + TRIM (la_text [ll])
					End IF
					ll_before = ll
					ls_text += IIF (lb_first,'','~r~n') + la_text [ll]
					lb_first = FALSE
				NEXT
			End IF
		End IF
END CHOOSE

IF	lb_single And POS (ls_text,';')=0 THEN ls_text += '~r~n;'

IF f_notnull (ls_exec) THEN ls_text=ls_exec + '~r~n' + SPACE(LenA (ls_exec) - 3) + wf_dml (ls_text, SPACE(LenA (ls_exec) - 3))

RETURN ls_text
end function

public function long rt_line (string arg_line, ref string ra_word[]);BOOLEAN	lb_schema
STRING	ls_varTmp, la_clear [], ls_temp, ls_xml_comment = ''

LONG	ll, ll_line

ra_word   = la_clear
ls_varTmp = arg_line

IF	f_null (ls_varTmp) OR nf_comp ({'--','//','<!'}, LEFT (ls_varTmp,2))	Then
	ll_line ++ ; ra_word [1] = ls_varTmp
	RETURN ll_line
End IF

DO WHILE TRUE
	ll_line ++ ; ra_word [ll_line] = ''
	IF	LEFT (ls_varTmp, 1)=' '	Then
		DO WHILE TRUE
			ra_word [ll_line] += ' '
			ls_varTmp = MID (ls_varTmp, 2)
			IF	LEFT (ls_varTmp,1)<>' ' OR LEN (ls_varTmp)=0 THEN EXIT
		LOOP
	Else
		DO WHILE TRUE
			IF LEFT (ls_varTmp, 2)='()'	Then	// default function
				ra_word [ll_line] += LEFT (ls_varTmp, 2)
				ls_varTmp = MID (ls_varTmp, 3)
				EXIT
			ElseIF LEFT (ls_varTmp, 2)='::'	Then	// postgreSQL data type
				ra_word [ll_line] += LEFT (ls_varTmp, 2)
				ls_varTmp = MID (ls_varTmp, 3)
				DO WHILE TRUE
					ls_temp = lower (LEFT (ls_varTmp, 1))
					CHOOSE CASE ls_temp
						CASE 'a' to 'z'
							//
						CASE ELSE
							EXIT
					END CHOOSE
					ra_word [ll_line] += LEFT (ls_varTmp, 1)
					ls_varTmp = MID (ls_varTmp, 2)
					IF	LEN (ls_varTmp)=0 THEN EXIT
				LOOP
				EXIT
			ElseIF nf_comp ({'[SPAC','[CASE','[MOVE','[BRAC','[SELE'}, LEFT (ls_varTmp,5))	Then	// [SPACE,[CASE,[MOVE,[BRACKET,[SELECT
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				IF	POS (ls_varTmp,']')=0	Then
					ra_word [ll_line] = ls_varTmp
					ls_varTmp = ''
				Else
					ra_word [ll_line] = LEFT (ls_varTmp, POS (ls_varTmp,']'))
					ls_varTmp = MID (ls_varTmp, POS (ls_varTmp,']') + 1)
				End IF
				IF	LEFT (ra_word [ll_line],9)='[SPACEAS-' And LEFT (ls_varTmp,2)='AS'	Then
					ra_word [ll_line] += 'AS'
					ls_varTmp = MID (ls_varTmp, 3)
				End IF
				EXIT	
			ElseIF LEFT (ls_varTmp,3)='(+)'	Then
				FOR  ll = ll_line  TO  1  STEP -1
					IF	f_null (ra_word [ll]) THEN CONTINUE
					ra_word [ll] += '(+)'
					ll_line = ll
					EXIT
				NEXT
				ls_varTmp = MID (ls_varTmp, 4)
				EXIT
			ElseIF LEFT (ls_varTmp, 3)='/*+'	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				IF	POS (ls_varTmp,'*/')=0	Then
					ra_word [ll_line] = ls_varTmp
					ls_varTmp = ''
				Else
					ra_word [ll_line] = LEFT (ls_varTmp, POS (ls_varTmp,'*/') + 1)
					ls_varTmp = MID (ls_varTmp, POS (ls_varTmp,'*/') + 2)
				End IF
				ra_word [ll_line] = UPPER (ra_word [ll_line])
				EXIT
			ElseIF nf_comp ({'--','++'}, LEFT (ls_varTmp,2))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = ls_varTmp
				IF	f_null (MID (ra_word [ll_line],3)) THEN ra_word [ll_line] = TRIM (ra_word [ll_line])	// 연산식(--,++) 로 인식하기위해 TRIM
				ls_varTmp = ''
				EXIT
			ElseIF nf_comp ({'//','<!'}, LEFT (ls_varTmp,2))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = ls_varTmp
				ls_varTmp = ''
				EXIT
			ElseIF LEFT (ls_varTmp, 2)='/*'	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				IF	POS (ls_varTmp,'*/')=0	Then
					ra_word [ll_line] = ls_varTmp
					ls_varTmp = ''
					EXIT
				Else
					ra_word [ll_line] = LEFT (ls_varTmp, POS (ls_varTmp,'*/') + 1)
					ls_varTmp = MID (ls_varTmp, POS (ls_varTmp,'*/') + 2)
				End IF
				ls_temp = f_replace (ra_word [ll_line], '/*', '')
				ls_temp = f_replace (ls_temp, '*/', '')
				IF	f_null (ls_temp) THEN ra_word [ll_line] = ''
				EXIT
			ElseIF nf_comp ({'*/',':=','>=','<=','<>','!=','!~~','||','**','+=','-='}, LEFT (ls_varTmp,2))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 2)
				ls_varTmp = MID (ls_varTmp, 3)
				EXIT
			ElseIF LEFT (ls_varTmp, 1)="'"	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = "'"
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					IF	LEFT (ls_varTmp, 2)="''"	Then
						ra_word [ll_line] += "''"
						ls_varTmp = MID (ls_varTmp, 3)
					ElseIF LEFT (ls_varTmp, 1)="'"	Then
						ra_word [ll_line] += "'"
						ls_varTmp = MID (ls_varTmp, 2)
						EXIT
					Else
						ra_word [ll_line] += LEFT (ls_varTmp, 1)
						ls_varTmp = MID (ls_varTmp, 2)
					End IF
					IF	LEN (ls_varTmp)=0 THEN EXIT
				LOOP
				EXIT
			ElseIF LEFT (ls_varTmp, 1)='"'	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = '"'
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					IF	LEFT (ls_varTmp, 1)='"'	Then
						ra_word [ll_line] += '"'
						ls_varTmp = MID (ls_varTmp, 2)
						EXIT
					Else
						ra_word [ll_line] += LEFT (ls_varTmp, 1)
						ls_varTmp = MID (ls_varTmp, 2)
					End IF
					IF	LEN (ls_varTmp)=0 THEN EXIT
				LOOP
				EXIT
			ElseIF LEFT (ls_varTmp, 1)='['	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = '['
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					ra_word [ll_line] += LEFT (ls_varTmp, 1)
					IF	LEFT (ls_varTmp,1)=']'	Then
						ls_varTmp = MID (ls_varTmp, 2)
						EXIT
					End IF
					ls_varTmp = MID (ls_varTmp, 2)
					IF	LEN (ls_varTmp)=0 THEN EXIT
				LOOP
				EXIT
			ElseIF LEFT (ls_varTmp,1)='*'	Then
				IF	RIGHT (ra_word [ll_line],1)='.'	Then
					ra_word [ll_line] += '*'
				Else
					IF LEN (ra_word [ll_line])>0 THEN ll_line ++
					ra_word [ll_line] = LEFT (ls_varTmp, 1)
				End IF
				ls_varTmp = MID (ls_varTmp, 2)
				EXIT
			ElseIF nf_comp ({'+','-'}, LEFT (ls_varTmp,1))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 1)
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					CHOOSE CASE LEFT (ls_varTmp, 1)
						CASE '0' TO '9'
							ra_word [ll_line] += LEFT (ls_varTmp, 1)
							ls_varTmp = MID (ls_varTmp, 2)
							IF	LEN (ls_varTmp)=0 THEN EXIT
						CASE ELSE
							EXIT
					END CHOOSE
				LOOP
				EXIT
			ElseIF nf_comp ({'{','}','(',')',',','=','<','>','/','^',';'}, LEFT (ls_varTmp,1))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 1)
				ls_varTmp = MID (ls_varTmp, 2)
				EXIT
			ElseIF LEFT (ls_varTmp, 2)='~r~n'	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 2)
				ls_varTmp = MID (ls_varTmp, 3)
				EXIT
			Else
				ra_word [ll_line] += LEFT (ls_varTmp, 1)
				ls_varTmp = MID (ls_varTmp, 2)
				IF	LEFT (ls_varTmp,1)=' ' OR LEN (ls_varTmp)=0 THEN EXIT
			End IF
		LOOP
	End IF
	IF	LEN (ls_varTmp)=0  THEN EXIT
LOOP

FOR  ll = 1  TO  ll_line
	IF f_null(ra_word[ll]) THEN CONTINUE
	CHOOSE CASE lower(ra_word[ll])
		CASE ')'
			IF (ll + 2) <= ll_line THEN
				IF	f_null (ra_word [ll + 1])	Then
					IF lower(ra_word [ll + 2]) = 'loop' THEN
						 ra_word [ll] += ' loop'
						 ra_word [ll + 1] = ''
						 ra_word [ll + 2] = ''
					END IF
				End IF
			END IF
		CASE 'case'
			IF (ll + 2) <= ll_line THEN
				IF	f_null (ra_word [ll + 1])	Then
					IF lower(ra_word[ll + 2]) = 'else'	Then
						ra_word [ll] = UPPER(ra_word[ll] + ' ' + ra_word[ll + 2])
						ra_word [ll + 1] = ''
						ra_word [ll + 2] = ''
					END IF
				End IF
			END IF
		CASE 'start','partition','group','order','connect','full','left','right','inner','cross','is'
			IF (ll + 2) <= ll_line THEN
				IF	f_null (ra_word [ll + 1])	Then
					CHOOSE CASE lower(ra_word [ll + 2])
						CASE 'join'
							// 'full', 'left', 'right', 'inner', 'cross' JOIN 처리
							CHOOSE CASE lower(ra_word [ll])
								CASE 'full','left','right','inner','cross'
									ra_word [ll] = UPPER (LEFT (ra_word [ll],1)) + lower (MID (ra_word [ll],2)) + ' ' + UPPER(ra_word [ll + 2])
									ra_word [ll + 1] = ''
									ra_word [ll + 2] = ''
							END CHOOSE
						CASE 'by'
							// 'partition', 'group', 'order', 'connect'
							CHOOSE CASE lower(ra_word [ll])
								CASE 'partition','group','order'
									ra_word [ll] = UPPER(ra_word [ll] + ' ' + ra_word [ll + 2])
									ra_word [ll + 1] = ''
									ra_word [ll + 2] = ''
								CASE 'connect'
									ra_word [ll] = UPPER(ra_word [ll] + ' ' + ra_word [ll + 2])
									ra_word [ll + 1] = ''
									ra_word [ll + 2] = ''
									IF (ll + 4) <= ll_line THEN
										IF	f_null (ra_word [ll + 3])	Then
											CHOOSE CASE lower(ra_word[ll + 4])
												CASE 'prior', 'level', 'nocycle'
													ra_word [ll] = UPPER(ra_word [ll] + ' ' + ra_word [ll + 4])
													ra_word [ll + 3] = ''
													ra_word [ll + 4] = ''
											END CHOOSE
										End IF
									END IF
							END CHOOSE
						CASE 'with'
							CHOOSE CASE lower(ra_word [ll])
								CASE 'start'
									ra_word [ll] = 'START WITH'
									ra_word [ll + 1] = ''
									ra_word [ll + 2] = ''
							END CHOOSE
						CASE 'null'
							CHOOSE CASE lower(ra_word [ll])
								CASE 'is'
									ra_word [ll] = UPPER(ra_word [ll] + ' ' + ra_word [ll + 2])
									ra_word [ll + 1] = ''
									ra_word [ll + 2] = ''
							END CHOOSE
						CASE 'not'
							IF (ll + 4) <= ll_line THEN
								IF	f_null (ra_word [ll + 3])	Then
									IF lower(ra_word [ll + 4]) = 'null' THEN
										ra_word [ll] = UPPER(ra_word [ll] + ' ' + ra_word [ll + 2] + ' ' + ra_word [ll + 4])
										ra_word [ll + 1] = ''
										ra_word [ll + 2] = ''
										ra_word [ll + 3] = ''
										ra_word [ll + 4] = ''
									END IF
								End IF
							END IF
						CASE 'outer'
							IF (ll + 4) <= ll_line THEN
								IF	f_null (ra_word [ll + 3])	Then
									IF lower(ra_word [ll + 4]) = 'join' THEN
										ra_word [ll] = UPPER (LEFT (ra_word [ll],1)) + lower (MID (ra_word [ll],2)) + ' ' + ra_word [ll + 2] + ' ' + ra_word [ll + 4]
										ra_word [ll + 1] = ''
										ra_word [ll + 2] = ''
										ra_word [ll + 3] = ''
										ra_word [ll + 4] = ''
									END IF
								End IF
							END IF
						CASE ELSE
							IF lower(ra_word [ll]) = 'order' THEN ra_word [ll] = UPPER(ra_word [ll])
					END CHOOSE
				End IF
			END IF			
		CASE 'not'
			// 'not in', 'not like', 'not regexp_like', 'not exists', 'not between', 'not matched' 처리
			IF (ll + 2) <= ll_line THEN
				IF	f_null (ra_word [ll + 1])	Then
					CHOOSE CASE lower(ra_word [ll + 2])
						CASE 'in','like','regexp_like','exists','between','matched'
							ra_word [ll] = UPPER(ra_word [ll] + ' ' + ra_word [ll + 2])
							ra_word [ll + 1] = ''
							ra_word [ll + 2] = ''
					END CHOOSE
					End IF
			End IF
		CASE 'end'
			IF (ll + 2) <= ll_line THEN
				IF	f_null (ra_word [ll + 1])	Then
					CHOOSE CASE lower(ra_word [ll + 2])
						CASE 'on','type','event','forward','if','case','loop','choose','try'
							ra_word [ll] += ' ' + ra_word[ll + 2]
							ra_word [ll + 1] = ''
							ra_word [ll + 2] = ''
					END CHOOSE
				End IF
			End IF
		CASE 'do','loop'
			IF (ll + 2) <= ll_line THEN
				IF	f_null (ra_word [ll + 1])	Then
					CHOOSE CASE lower(ra_word [ll + 2])
						CASE 'until','while'
							ra_word [ll] += ' ' + ra_word[ll + 2]
							ra_word [ll + 1] = ''
							ra_word [ll + 2] = ''
					END CHOOSE
				End IF
			End IF
      CASE 'escape'
			ra_word[ll] = ' ' + UPPER(ra_word[ll]) + ' '
	END CHOOSE
NEXT

FOR  ll = 1  TO  ll_line
	IF	profilestring ('c:\ncSQL\ncSQL.ini', "UPPER", lower (ra_word [ll]), 'None')='1' &
			OR LEFT (lower(ra_word [ll]),2)='f_' OR LEFT (lower(ra_word [ll]),3)='fr_' OR LEFT (lower(ra_word [ll]),3)='to_'	Then
		ra_word [ll] = UPPER (ra_word [ll])
	End IF
NEXT

RETURN	ll_line
end function

public function boolean nf_comp (string arg_comp_str[], string arg_str);LONG	ll_str, ll

ll_str = UPPERBOUND (arg_comp_str)
IF	ll_str=0 OR f_null (arg_str) THEN RETURN false

FOR  ll = 1  TO  ll_str
	IF	lower (arg_comp_str [ll])=lower (arg_str) THEN RETURN true
NEXT

RETURN false
end function

public function string nf_clear_sqm (string arg_line, boolean arg_comment_clear);IF	POS (arg_line,"'")=0 And POS (arg_line,'"')=0 And POS (arg_line,"--")=0 And POS (arg_line,"//")=0 And POS (arg_line,"/*")=0 THEN RETURN arg_line

// single quotation marks clear
STRING	la_line [], ra_word [], ls_line, ls_word, ls_return = '', ls_start = "sqm_start_word"

LONG	ll_line, ll, lm, lm_word, ll_bracket = 0

ll_line = f_get_array (arg_line, '~r~n', la_line)
FOR  ll = 1  TO  ll_line
	IF	arg_comment_clear	Then
		ls_line = ''
		lm_word = rt_line (la_line [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	nf_comp ({'--','//'}, LEFT (ra_word [lm],2)) 	Then
				ls_line += '__' + SPACE (LEN (ra_word [lm]) - 2)
			ElseIF LEFT (ra_word [lm],2)='/*'	Then
				ls_line += '__' + SPACE (LEN (ra_word [lm]) - 4) + '__'
			Else
				ls_line += ra_word [lm]
			End IF
		NEXT
	Else
		ls_line = la_line [ll]
	End IF
	IF	POS (ls_line, "'")=0 And POS (ls_line, '"')=0 And ll_bracket=0	Then
		ls_return += ls_line + '~r~n'
		CONTINUE
	End IF
	DO WHILE TRUE
		IF	ll_bracket>0 And LEFT (ls_line,2)="''"	Then
			ls_return += '  '
			ls_line = MID (ls_line,3)
		Else
			ls_word = LEFT (ls_line,1)
			IF	(ls_word="'" OR ls_word='"') And ls_start = 'sqm_start_word' THEN ls_start = ls_word
			IF	ls_word=ls_start	Then
				IF	ll_bracket=0	Then
					ll_bracket ++
				Else
					ll_bracket --
					IF	ll_bracket=0 THEN ls_start = 'sqm_start_word'
				End IF
				ls_return += ls_word
			Else
				IF	ll_bracket>0	Then
					ls_return += SPACE(LenA (ls_word))
				Else
					ls_return += ls_word
				End IF
			End IF
			ls_line = MID (ls_line,2)
		End IF
		IF	f_null (ls_line) THEN EXIT
	LOOP
	ls_return += '~r~n'
NEXT
ls_return = LEFT (ls_return, LEN (ls_return) - 2)

RETURN ls_return
end function

public function string nf_clear (string arg_text);STRING	la_line [], ra_word [], ls_return = ''

LONG	ll, lm, lm_word, ll_line

ll_line = f_get_array (arg_text, '~r~n', la_line)
FOR  ll = 1  TO  ll_line
	IF	POS (la_line [ll],'[SPACE')=0 And POS (la_line [ll],'[SELECTSPACE')=0 And POS (la_line [ll],'[CASE')=0	Then
		ls_return += la_line [ll]
	Else
		lm_word = rt_line (la_line [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	POS (ra_word [lm],'[SPACE')>0 OR POS (ra_word [lm],'[CASE')>0 OR POS (ra_word [lm],'[SELECTSPACE')>0	Then
				ls_return += MID (ra_word [lm], POS (ra_word [lm],']') + 1)
			Else
				ls_return += ra_word [lm]
			End IF
		NEXT
	End IF
	ls_return += '~r~n'
NEXT
ls_return = LEFT (ls_return, LEN (ls_return) - 2)

RETURN	ls_return
end function

public function string wf_line_comment (string arg_line[], long arg_ll_line, ref long arg_ll, boolean arg_move);// line은 마지막에 ~r~n 포함, 처음 ~r~n은 조건에 따라 선택

STRING	ls_return = '', ls_temp, ra_word []

LONG	ll, ll_line, ll_move = 0

IF	LEFT (TRIM (arg_line [arg_ll]),2)='--'	Then
	FOR ll = arg_ll  TO  arg_ll_line
		IF LEFT (TRIM (arg_line [ll]),2)='--'	Then
			IF	arg_move THEN arg_line [ll] = TRIM (arg_line [ll])
			ls_return += arg_line [ll] + '~r~n'
		Else
			arg_ll = ll - 1
			EXIT
		End IF
	NEXT
	IF	ll>arg_ll THEN arg_ll = ll - 1
ElseIF LEFT (TRIM (arg_line [arg_ll]),2)='//'	Then
	FOR ll = arg_ll  TO  arg_ll_line
		IF	LEFT (TRIM (arg_line [ll]),2)='//'	Then
			IF	f_notnull (MID (arg_line [ll],3,1)) THEN arg_line [ll] = '// ' + TRIM (MID (arg_line [ll], 3))
			IF	arg_move THEN arg_line [ll] = TRIM (arg_line [ll])
			ls_return += arg_line [ll] + '~r~n'
		Else
			arg_ll = ll - 1
			EXIT
		End IF
	NEXT
	IF	ll>arg_ll THEN arg_ll = ll - 1
// comment /* 를 여러줄에 걸치는 경우 처리
ElseIF LEFT (TRIM (arg_line [arg_ll]),2)='/*'	Then
	rt_line (arg_line [arg_ll], ra_word)
	IF	f_null (ra_word [1]) THEN ll_move = LEN (ra_word [1])
	FOR  ll = arg_ll  TO  arg_ll_line
		IF	ll_move>0 And f_notnull (LEFT (arg_line [ll], ll_move)) THEN arg_line [ll] = SPACE (ll_move) + TRIM (arg_line [ll])
		IF	RIGHT (TRIM (arg_line [ll]),2)='*/'	Then
			ls_return += arg_line [ll] + '~r~n'
			IF	ll<arg_ll_line	Then
				//   /* 주석 */
				//   /* 주석 */ 인경우 처리
				IF	LEFT (TRIM (arg_line [ll + 1]),2)='/*' THEN CONTINUE
			End IF
			arg_ll = ll
			EXIT
		Else
			IF	POS (arg_line [ll],'*/')>0	Then
				IF nf_comp ({'--','//','/*'}, LEFT (TRIM (arg_line [ll]),2))	Then
					ls_return += arg_line [ll] + '~r~n'
				Else
					ls_return += LEFT (arg_line [ll], POS (arg_line [ll],'*/') + 2) + '~r~n'
					ls_temp = MID (arg_line [ll], POS (arg_line [ll],'*/') + 2)
					IF	f_notnull (ls_temp) THEN ls_return += ls_temp + '~r~n'
					arg_ll = ll
					EXIT
				End IF
			Else
				ls_return += RIGHTTRIM (arg_line [ll]) + '~r~n'
			End IF
		End IF
	NEXT
	IF	ll>arg_ll THEN arg_ll = ll

ElseIF LEFT (TRIM (arg_line [arg_ll]),2)='<<' Then
	ls_return += arg_line [arg_ll] + '~r~n'
	arg_ll ++
End IF

RETURN	ls_return
end function

public function string wf_dml_insert (string arg_insert);S_RET	pivot

LONG	ll, ll_insert, ll_line, ll_return, in_bracket, lm, lm_word
LONG	ll_bracket = 0, ll_insert_line = 0, ll_colnum = 0

STRING	la_insert [], la_return [], la_line [], ra_word []
STRING	ls_order, ls_start, ls_end, ls_table, ls_comment, ls_space, ls_temp
STRING	ls_text, ls_return = '', ls_line = '', ls_alias = 'auto', ls_line_comment = ''

BOOLEAN	lb_line_first, lb_in_first, lb_values, lb_bracket, lb_exit, lb_and_pass, lb_order

gl_select_step ++ 

ll_insert = f_get_array (arg_insert, '~r~n', la_insert)
FOR  ll = 1  TO  ll_insert
	IF	f_null (la_insert [ll]) THEN CONTINUE
	IF	TRIM (la_insert [ll])=','	Then	// , 만 있는 경우 합치는 처리
		la_insert [ll] = RIGHTTRIM (la_insert [ll]) + ' ' + TRIM (la_insert [ll + 1])
		la_insert [ll + 1] = ''
		CONTINUE
	End IF
	lm_word = rt_line (la_insert [ll], ra_word)
	FOR  lm = 1  TO  lm_word
		IF	f_null (ra_word [lm]) THEN CONTINUE
		CHOOSE CASE ra_word [lm]
			CASE 'VALUES'
				IF	ll_colnum>0 THEN EXIT
			CASE 'SELECT'
				ll_colnum = 6
				EXIT
			CASE '('
				ll_bracket ++
				FOR  ll = ll  TO  ll_insert
					IF	f_null (la_insert [ll]) THEN CONTINUE
					IF	TRIM (la_insert [ll])=','	Then	// , 만 있는 경우 합치는 처리
						la_insert [ll] = RIGHTTRIM (la_insert [ll]) + ' ' + TRIM (la_insert [ll + 1])
						la_insert [ll + 1] = ''
						IF	ll_bracket=1 THEN ll_colnum ++
						CONTINUE
					End IF
					lm_word = rt_line (la_insert [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						IF	f_null (ra_word [lm]) THEN CONTINUE
						CHOOSE CASE ra_word [lm]
							CASE '('
								ll_bracket ++
							CASE ')'
								ll_bracket --
								IF	ll_bracket=0 THEN EXIT
							CASE ','
								IF	ll_bracket=1 THEN ll_colnum ++
								IF	ll_colnum>5 THEN EXIT
						END CHOOSE
					NEXT
					IF	ll_colnum>5 OR ll_bracket=0 THEN EXIT
					lm = 0
				NEXT
		END CHOOSE
		IF	lb_exit OR ll_colnum>5 THEN EXIT
	NEXT
	IF	ll_colnum>5	THEN EXIT
NEXT
lb_order = (ll_colnum > 5)

ll_bracket = 0
ls_comment = ''
FOR  ll = 1  TO  ll_insert
	IF	f_null (la_insert [ll]) THEN CONTINUE

	lm_word = rt_line (la_insert [ll], ra_word)
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_insert [ll]),2))	Then
		IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
		ls_line_comment += wf_line_comment (la_insert, ll_insert, ll, false)
		CONTINUE
	End IF
	lb_line_first = TRUE
	FOR  lm = 1  TO  lm_word
		IF	f_null (ra_word [lm]) THEN CONTINUE
		IF	LeftA (ra_word [lm],3)='/*+'	Then
			ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
			CONTINUE
		ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
			ls_comment = nf_add_comment (ls_comment, ra_word [lm])
			CONTINUE
		End IF

		CHOOSE CASE lower (ra_word [lm])
			CASE 'return','exit'
				ra_word [lm] = UPPER (ra_word [lm])
			CASE "'0010185'"
				ra_word [lm] = 'w_fss_cd'
		END CHOOSE

		CHOOSE CASE UPPER (ra_word [lm])
			CASE 'USING'
				ls_line += '~r~nUSING '
				FOR  lm = lm + 1  TO  lm_word
					ls_line += nf_1space (ra_word [lm])
				NEXT
				EXIT
			CASE 'INSERT'
				ls_comment = ''; lb_exit = false
				FOR  ll = ll  TO  ll_insert
					IF	f_null (la_insert [ll]) THEN CONTINUE
					lm_word = rt_line (la_insert [ll], ra_word)
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_insert [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line += wf_line_comment (la_insert, ll_insert, ll, false)
						CONTINUE
					End IF
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]='' THEN CONTINUE
						IF	nf_comp ({'(','values','select'}, ra_word [lm])	Then
							lb_exit = true
							lm --
							EXIT
						End IF

						CHOOSE CASE ra_word [lm]
							CASE 'INSERT'
								IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
								ls_line = ra_word [lm]
								CONTINUE
							CASE 'INTO'
								ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm]
								CONTINUE
							CASE 'WITH'
								ls_return += ls_line + '~r~n'
								ls_space += '    '
								ls_line = ''
								lb_exit = FALSE
								FOR  ll = ll  TO  ll_insert
									// xml
									IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_insert [ll]),2)) Then
										IF	f_notnull (ls_return) And RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
										ls_comment = wf_line_comment (la_insert, ll_insert, ll, false)
										IF	POS (ls_comment,'내부 함수')=0 THEN ls_return += ls_comment
										ls_comment = ''
										lm = 1
										CONTINUE
									ElseIF LEFT (TRIM (la_insert [ll]),2)='<<'	Then
										IF	f_notnull (ls_return) And RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
										ls_return += la_insert [ll] + '~r~n'
										lm = 1
										CONTINUE
									End IF
									lm_word = rt_line (la_insert [ll], ra_word)
									FOR  lm = lm  TO  lm_word
										IF	ra_word [lm]=';'	Then
											lb_exit = true
											EXIT
										ElseIF POS (ra_word [lm],'</')>0	Then
											lb_exit = true
											lm = 1
											EXIT
										End IF
										ls_line += ra_word [lm]
									NEXT
									IF	lb_exit THEN EXIT
									ls_line += '~r~n'
									lm = 1
								NEXT
								ls_line = wf_with (ls_line)
								ls_return = RIGHTTRIM (ls_return) + ls_space + wf_move (ls_line, LEN (ls_space), false)
								ls_line = ''
								CONTINUE
						END CHOOSE

						IF	LEFT (ra_word [lm],3)='/*+'	Then
							ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm]
							CONTINUE
						ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF
						IF	f_null (ls_table) And f_notnull (ra_word [lm])	Then
							IF	POS (ra_word [lm],'.')>0	Then
								IF	MID (ra_word [lm],2,1)='{'	Then
									ra_word [lm] = MID (ra_word [lm],3)
									ra_word [lm] = f_replace (ra_word [lm],'}.','.')
								End IF
							End IF
							IF	f_notnull (is_asis_table) And RIGHT (UPPER (ra_word [lm]),LEN (is_asis_table))=is_asis_table	Then
								ls_line += is_tobe_table
								ls_comment = nf_add_comment (ls_comment, is_asis_table + ' --> ' + is_tobe_write)
							Else
								ls_line += UPPER (ra_word [lm])
							End IF
							ls_table = UPPER (ra_word [lm])
						ElseIF ls_alias='auto' And f_notnull (ra_word [lm])	Then
							ls_alias = ra_word [lm]
							ls_line += ia [gl_select_step] + string(ASC (UPPER (ls_alias)) - 64)
						Else
							ls_line += nf_1space (ra_word [lm])
						End IF
					NEXT
					IF	lb_exit THEN EXIT
					ls_line += ' '
					lm = 1
				NEXT
				IF	ls_alias='auto' THEN ls_line = RIGHTTRIM (ls_line)
				IF	f_notnull (ls_comment)	Then
					ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
					ls_comment = ''
				End IF
				ls_line += '~r~n'
				IF	ll>ll_insert THEN EXIT
				CONTINUE
			CASE 'SELECT'
				ls_text = ''
				lb_in_first = true
				FOR  ll = ll  TO  ll_insert
					IF	f_null (la_insert [ll])	Then
						lm = 1
						CONTINUE
					End IF
					IF	lb_in_first	Then
						FOR  lm = lm  TO  lm_word
							ls_text += ra_word [lm]
						NEXT
						lb_in_first = false
					Else
						ls_text += la_insert [ll]
					End IF
					ls_text += '~r~n'
				NEXT
				ls_text = wf_dml_select (ls_text)
				ll_return = f_get_array (ls_text, '~r~n', la_return)
				FOR  lm = 1  TO  ll_return
					IF	f_null (la_return [lm]) THEN CONTINUE
					ls_line += '~r~n  ' + la_return [lm]
				NEXT
				IF	lb_bracket THEN ls_line += ' )'
				EXIT
			CASE 'DECODE','CASE'
				ls_text = ra_word [lm]
				IF	lower (ra_word [lm])='case'	Then
					in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  ll_insert
					lm_word = rt_line (la_insert [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						ls_text += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								in_bracket ++
							CASE ls_end
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_bracket=0 THEN EXIT
					ls_text += '~r~n'
					lm = 0
				NEXT
				IF	ls_start='case'	Then
					ls_text = wf_case (ls_text)
				Else
					ls_text = nf_decode (ls_text)
				End IF
				ls_space = wf_bracket_space (ls_line)
				ls_line += wf_dml (ls_text, ls_space)
				IF	ll>ll_insert THEN EXIT
			CASE '('
				IF	lb_values	Then
					IF	RIGHT (RIGHTTRIM (ls_line),6)='VALUES'	Then
						ls_line = RIGHTTRIM (ls_line) + ' ( '
					Else
						pivot = nf_bracket_pivot (la_insert, ll_insert, ll, lm)
						ll = pivot.ll
						lm = pivot.lm
						ls_space = wf_bracket_space (ls_line)
						IF	f_null (pivot.pivot)	Then	// pivot
							ls_temp = wf_in (ls_return + ls_line, pivot.text)
							ls_line += wf_move ('(' + ls_temp, LEN (ls_space), false) + ') '
						Else
							ls_line += wf_move (pivot.text, LEN (ls_space), false) + ')~r~n'
						End IF
						IF	ll>ll_insert THEN EXIT
						lm_word = rt_line (la_insert [ll], ra_word)	// 변경된 ll 반영
					End IF
				Else
					ls_line += '    ( '
					pivot = nf_bracket_pivot (la_insert, ll_insert, ll, lm)
					IF	LEFT(TRIM (pivot.text),8)='[SELECT-'	Then
						ls_temp = wf_bracket (pivot.text)
						ls_line += TRIM (wf_dml (ls_temp, SPACE (4)))  + ' )'
						ll = pivot.ll
						lm = pivot.lm
					Else
						// ( ) VALUES ( ) 순번 처리를 함께처리하기 위해
						CONTINUE
					End IF
					IF	ll>ll_insert THEN EXIT
					lm_word = rt_line (la_insert [ll], ra_word)	// 변경된 ll 반영
				End IF
				CONTINUE
			CASE ','
				IF	lb_order	Then
					ll_insert_line ++
					ls_line = wf_add_comment_num (ls_line, ls_comment, ll_insert_line, true)
				ElseIF f_notnull (ls_comment)	Then
					ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
				End IF
				ls_comment = ''
				IF	lb_order OR ll_colnum>5	Then
					IF	lb_values	Then
						ls_line += '~r~n       , '
					Else
						ls_line += '~r~n    , '
					End IF
				Else
					ls_line += ', '
				End IF
			CASE ')'
				IF	lb_order	Then
					ll_insert_line ++
					ls_line = wf_add_comment_num (ls_line, ls_comment, ll_insert_line, true)
				ElseIF f_notnull (ls_comment)	Then
					ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
				End IF
				ls_comment = ''
				IF	ll_colnum>5	Then
					IF	lb_values	Then
						ls_line += '~r~n       )'
					Else
						ls_line += '~r~n    )'
					End IF
				Else
					ls_line += ' )'
				End IF
				ls_line += '[SPACEASCLEAR-' + string(gl_select_step) + ']'
			CASE 'VALUES'
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				IF	PosA (ls_return+ls_line,'INSERT INTO')>0 And PosA (arg_insert,'(')=0 And PosA (lower (arg_insert),'select')=0	Then
					ls_line += ' VALUES '
					FOR  lm = lm + 1  TO  lm_word
						IF	f_null (ra_word [lm]) THEN CONTINUE
						ls_line += ra_word [lm]
					NEXT
					EXIT
				End IF
				lb_values = TRUE
				ls_line += '~r~nVALUES '
				ll_insert_line = 0
			CASE '+','-','*','/','^','**','||'
				IF	lb_line_first	Then
					ls_line = RIGHTTRIM (ls_line) + '~r~n[SPACE^]' + ra_word [lm] + ' '
				Else
					ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
				End IF
			CASE ELSE
				ls_line += ra_word [lm]
		END CHOOSE
		lb_line_first = FALSE
	NEXT
	IF	f_notnull (ls_line_comment)	Then
		ls_return += ls_line_comment
		ls_line_comment = ''
	End IF
	ls_return += ls_line
	ls_line = ''
NEXT
ls_return = wf_dml (ls_return, '')

// alias.+TABLE. 처리 20240320
IF	POS (ls_table,'.')>0 THEN ls_table = MID (ls_table, POS (ls_table,'.') + 1)
// 기존 1자리 영문자를 2자리 치환시 중복발생으로 기존영문을 숫자로 변환
IF	LenA (ls_alias)=1	Then
	ls_temp = ia [gl_select_step] + string(ASC (UPPER (ls_alias)) - 64)
	ls_return = f_replace1 (ls_return, ls_alias+'.', ls_temp+'.')
	ls_alias = ls_temp
End IF

gl_select_step --

RETURN	ls_return
end function

public function string nf_add_comment (string arg_comment, string add_comment);STRING	ls_return, ls_add, ls_temp

IF	f_null (add_comment) THEN RETURN arg_comment

IF	LEFT (TRIM (add_comment),2)='<!'	Then
	ls_add = TRIM (add_comment)

ElseIF LEFT (TRIM (add_comment),2)='//'	Then
	ls_add = '// ' + TRIM (MID (add_comment, 3))

ElseIF LEFT (TRIM (add_comment),2)='--'	Then
	ls_temp = f_replace (add_comment, '--', '')
	ls_temp = f_replace (ls_temp, '/*', '')
	ls_temp = f_replace (ls_temp, '*/', '')
	ls_add = TRIM (ls_temp)

ElseIF LEFT (add_comment,4)='/* _'	Then
	IF	POS (add_comment,'-')>0	Then
		ls_temp = MID (add_comment, POS (add_comment,'-') + 1)
	ElseIF POS (add_comment,':')>0	Then
		ls_temp = MID (add_comment, POS (add_comment,':') + 1)
	Else
		ls_temp = MID (add_comment,3)
	End IF
	ls_temp = TRIM (ls_temp)
	IF	POS (ls_temp, '*/')=0	Then
		ls_add = ls_temp
	Else
		ls_add = TRIM (LEFT (ls_temp,  POS (ls_temp,'*/') - 1))
	End IF

ElseIF LEFT (add_comment,2)='/*'	Then
	ls_temp = f_replace (add_comment, '/*', '')
	ls_add  = TRIM (f_replace (ls_temp, '*/', ''))
	
ElseIF POS (add_comment,'/*')=0 And POS (add_comment,'*/')>0	Then
	ls_add = TRIM (LEFT (add_comment, POS (add_comment,'*/') - 1))
Else
	ls_add = add_comment
End IF

IF	f_null (arg_comment)	Then
	ls_return = ls_add
Else
	ls_temp = f_replace (arg_comment, '/*', '')
	ls_temp = TRIM (f_replace (ls_temp, '*/', ''))
	IF	f_null (ls_add)	Then
		ls_return = ls_temp
	Else
		ls_return = ls_temp + '|' + ls_add
	End IF
End IF

RETURN ls_return
end function

public function string wf_deselect (string arg_text);LONG  ll_dml, ll, l2, lm, lx, ll_text, lm_word, lm_word2, ll_array, in_bracket

BOOLEAN  lb_dml, lb_select

STRING   ls_text, ls_line, ls_dml, ls_line_comment, ls_space, ls_temp
STRING   la_text [], ra_word [], ra_word2 [], la_dml []

ls_text = arg_text

DO WHILE TRUE
   IF POS (ls_text,'[SELECT-')=0 THEN EXIT
   // [SELECT-n] 풀기
   ll_text = f_get_array (ls_text, '~r~n', la_text)
   ls_text = ''
   FOR  ll = 1  TO  ll_text
      IF nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_text [ll]),2))	Then
         IF f_notnull (ls_line_comment) AND RIGHT (ls_line_comment,2) <> '~r~n' THEN ls_line_comment += '~r~n'
         ls_line_comment += wf_line_comment (la_text, ll_text, ll, false)
         CONTINUE
      END IF
      IF f_notnull (ls_line_comment)   Then
         IF f_notnull (ls_text) AND RIGHT (ls_text,2) <> '~r~n' THEN ls_text += '~r~n'
         ls_text         += ls_line_comment
         ls_line_comment = ''
      END IF
      IF POS (la_text [ll],'[SELECT-')=0  Then
         ls_text += la_text [ll] + '~r~n'
      ELSE
			lb_select = false
         lm_word = rt_line (la_text [ll], ra_word)
         ls_line = ''
         FOR  lm = 1  TO  lm_word
            IF LEFT (ra_word [lm],8)='[SELECT-' Then
               f_microhelp (ra_word [lm] + ' ...')

               ls_dml   = MID (ra_word [lm], 9)
               ll_array = dec (LEFT (ls_dml, LEN (ls_dml) - 1))
               ls_dml   = ga_select [ll_array]
					lb_select = true

               ll_dml = f_get_array (ls_dml, '~r~n', la_dml)
               ls_dml = ''
               IF LEFT (TRIM (ls_dml),1)='(' Then
                  in_bracket = 0
               ELSE
                  in_bracket = 1
               END IF
               FOR  lx = 1  TO  ll_dml
                  lm_word2 = rt_line (la_dml [lx], ra_word2)
                  FOR  l2 = 1  TO  lm_word2
                     CHOOSE CASE ra_word2 [l2]
                        CASE 'SELECT'
                           lb_dml = true
                        CASE '('
                           in_bracket ++
                        CASE ')'
                           in_bracket --
                           IF in_bracket=0 THEN EXIT
                     END CHOOSE
                     IF lb_dml   Then
                        ls_dml += ra_word2 [l2]
                     ELSE
                        ls_line += ra_word2 [l2]
                     END IF
                  NEXT
                  IF lb_dml   Then
                     ls_dml += '~r~n'
                  ELSE
                     ls_line += '~r~n'
                  END IF
               NEXT

               IF POS (ls_dml,'~r~n')=0   Then
                  ls_line += ls_dml
               ELSE
                  ls_space = wf_bracket_space (ls_line)
                  ls_dml   = wf_move (ls_dml, LEN (ls_space), false)
                  ls_line  += ls_dml
                  FOR  l2 = lm + 2  TO  lm_word
                     ls_temp = nf_clear (ra_word [l2])
                     IF f_NVL (ls_temp,')')=')' THEN CONTINUE
                     IF ls_temp='AS' THEN EXIT
                     IF nf_comp ({'--','//','/*'}, LEFT (ls_temp,2))  Then
                        nf_add_comment ('', ls_temp)
                        CONTINUE
                     END IF
							ls_line += ' '
                     EXIT
                  NEXT
               END IF
            ELSE
               ls_line += ra_word [lm]
            END IF
         NEXT
         ls_text += ls_line + '~r~n'
      END IF
   NEXT
   IF RIGHT (ls_text,2)='~r~n' THEN ls_text = LEFT (ls_text, LEN (ls_text) - 2)
LOOP

RETURN   ls_text
end function

public function string wf_bracket_space (string arg_line);// 0, comment 제외한 최종라인 길이
STRING	ls_line, la_line [], ls_deselect
LONG	ll, ll_line

IF	POS (arg_line,'[SELECT-')>0	Then
	ls_deselect = wf_deselect (arg_line)
	IF	POS (ls_deselect,'~r~n')>0 THEN ls_deselect = MID (ls_deselect, LASTPOS (ls_deselect,'~r~n') + 2)
Else
	ls_deselect = arg_line
End IF
ll_line = f_get_array (nf_clear (ls_deselect), '~r~n', la_line)
ls_line = ''
FOR  ll = 1  TO  ll_line
	IF	LEN (la_line [ll])=0 THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_line [ll]),2))	Then
		wf_line_comment (la_line, ll_line, ll, false)
		CONTINUE
	End IF
	ls_line += la_line [ll] + '~r~n'
NEXT
ls_line = LEFT (ls_line, LEN (ls_line) - 2)
IF	POS (ls_line,'~r~n')>0 THEN ls_line = MID (ls_line, LASTPOS (ls_line,'~r~n') + 2)

RETURN SPACE (LenA (ls_line))

end function

public function string wf_add_comment_num (string arg_line, string arg_comment, long arg_colnum, boolean arg_space);STRING	last_line, ls_rtn

IF	f_null (arg_comment) And arg_colnum=0 THEN RETURN arg_line

last_line = wf_bracket_space (arg_line)

ls_rtn = arg_line
IF	LEFT (arg_comment,2)='//'	Then
	ls_rtn += arg_comment
Else
	IF	arg_colnum>0 OR f_notnull (arg_comment)	Then
		IF	POS (last_line,'[SPACE*')=0 And arg_space	Then
			ls_rtn += ' [SPACE*' + string (gl_select_step) + ']'
		Else
			ls_rtn += ' '
		End IF
		IF	arg_colnum=0	Then
			IF	f_notnull (arg_comment) THEN ls_rtn += '/* ' + TRIM (arg_comment) + ' */'
		Else
			IF POS (arg_comment,' ')<6 And LenA (arg_comment)>6 And DEC (LEFT (arg_comment, POS (arg_comment,' ')))>0	Then
				// column 순번 삭제처리
				arg_comment = MID (arg_comment, POS (arg_comment,' '))
			End IF
			ls_rtn += '/* _' + string(arg_colnum) + '-' + TRIM (arg_comment) + ' */'
		End IF
	End IF
End IF
RETURN ls_rtn
end function

public function string wf_dml_update (string arg_update);S_RET	pivot, where_syntax
S_WHERE_ADD_COLUMN	add_where

LONG	ll, ll_update, lm, lm_word

STRING	la_update [], ra_word [], ls_update, ls_return = '', ls_line = '', ls_comment
STRING	ls_table = '', ls_alias = 'auto', ls_line_comment = '', ls_temp

BOOLEAN	lb_update = TRUE, lb_exit, lb_set, lb_where

IF	POS (arg_update,'~r~n')=0	Then
	ls_update = arg_update
	IF	POS (lower (ls_update),'delete')>0 And POS (lower (ls_update),' from')=0	Then
		ls_update = f_replace (UPPER (ls_update),'  ',' ')
		ls_update = f_replace (UPPER (ls_update),'DELETE','DELETE FROM')
	End IF
	RETURN ls_update
End IF

gl_select_step ++

ll_update = f_get_array (arg_update, '~r~n', la_update)
FOR  ll = 1  TO  ll_update
	STRING	ls_text
	IF	f_null (la_update [ll]) THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_update [ll]),2)) Then
		IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
		ls_line_comment += wf_line_comment (la_update, ll_update, ll, false)
		CONTINUE
	ElseIF TRIM (la_update [ll])=','	Then	// , 만 있는경우 줄 합치기 처리
		la_update [ll] = RightTRIM (la_update [ll]) + ' ' + TRIM (la_update [ll + 1])
		la_update [ll + 1] = ''
		CONTINUE
	End IF
	IF	lb_update	Then	// UPDATE,DELETE
		lm_word = rt_line (la_update [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	ra_word [lm]='' THEN CONTINUE
			IF	LeftA (ra_word [lm],3)='/*+'	Then
				ls_line = RightTRIM (ls_line) + ' ' + ra_word [lm] + '~r~n'
				CONTINUE
			End IF
			IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
				ls_comment = nf_add_comment (ls_comment, ra_word [lm])
				CONTINUE
			End IF
			CHOOSE CASE UPPER (ra_word [lm])
				CASE 'UPDATE','UPDATEBLOB'
					ls_line += UPPER (ra_word [lm]) + ' '
					ls_comment = ''; lb_exit = false
					FOR  ll = ll  TO  ll_update
						IF	f_null (la_update [ll]) THEN CONTINUE
						// xml
						IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_update [ll]),2)) Then
							IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
							ls_line_comment += wf_line_comment (la_update, ll_update, ll, false)
							lm = 0
							CONTINUE
						End IF
						lm_word = rt_line (la_update [ll], ra_word)
						FOR  lm = lm + 1  TO  lm_word
							IF	f_null (ra_word [lm]) THEN CONTINUE
							IF lower (ra_word [lm])='set'	Then
								lb_exit = true
								lb_update = FALSE
								lb_set = TRUE
								EXIT
							End IF
							IF	LEFT (ra_word [lm],3)='/*+'	Then
								ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
								CONTINUE
							ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
								ls_comment = nf_add_comment (ls_comment, ra_word [lm])
								CONTINUE
							ElseIF ra_word [lm]='('	Then
								pivot = nf_bracket_pivot (la_update, ll_update, ll, lm)
								ls_temp = wf_in (ls_return + ls_line, pivot.text)
								ls_line += wf_move ('(' + ls_temp, LenA (ls_line) + 1, false)  + ') '
								ll = pivot.ll ; lm = pivot.lm
								ls_table = 'bracket'
								IF	ll>ll_update THEN EXIT
								lm_word = rt_line (la_update [ll], ra_word)	// 변경된 ll 반영
								CONTINUE
							End IF
							IF	f_null (ls_table) And f_notnull (ra_word [lm])	Then
								IF	POS (ra_word [lm],'.')>0	Then
									IF	MID (ra_word [lm],2,1)='{'	Then
										ra_word [lm] = MID (ra_word [lm],3)
										ra_word [lm] = f_replace (ra_word [lm],'}.','.')
									End IF
								End IF
								IF	f_notnull (is_asis_table) And RIGHT (UPPER (ra_word [lm]),LEN (is_asis_table))=is_asis_table	Then
									ls_line += is_tobe_table + ' '
									ls_comment = nf_add_comment (ls_comment, is_asis_table + ' --> ' + is_tobe_write)
								Else
									ls_line += UPPER (ra_word [lm]) + ' '
								End IF
								ls_table = UPPER (ra_word [lm])
							ElseIF ls_alias='auto' And f_notnull (ra_word [lm])	Then
								ls_alias = lower (ra_word [lm]) 
								IF	LenA (ls_alias)=1	Then
									ls_line += ia [gl_select_step] + string(ASC (UPPER (ls_alias)) - 64) + ' '
								Else
									ls_line += ls_alias + ' '
								End IF
							Else
								ls_line += ra_word [lm] + ' '
							End IF
						NEXT
						IF	lb_exit THEN EXIT
						ls_line += ' '
						lm = 0
					NEXT
					IF	ls_alias='auto' THEN ls_line = RIGHTTRIM (ls_line)
					IF	f_notnull (ls_comment)	Then
						ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
						ls_comment = ''
					End IF
					IF	f_notnull (ls_line_comment)	Then
						ls_return += ls_line_comment
						ls_line_comment = ''
					End IF
					ls_return += ls_line + '~r~n'
					ls_line = ''
					EXIT
				CASE 'DELETE'
					ls_line += UPPER (ra_word [lm]) + ' '
					ls_comment = ''; lb_exit = false
					FOR  ll = ll  TO  ll_update
						IF	f_null (la_update [ll]) THEN CONTINUE
						lm_word = rt_line (la_update [ll], ra_word)
						// xml
						IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_update [ll]),2)) Then
							IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
							ls_line_comment += wf_line_comment (la_update, ll_update, ll, false)
							lm = 0
							CONTINUE
						End IF
						FOR  lm = lm + 1  TO  lm_word
							IF	f_null (ra_word [lm]) THEN CONTINUE
							IF lower (ra_word [lm])='where'	Then
								lb_exit = true
								lb_update = FALSE
								lb_where = TRUE
								EXIT
							ElseIF lower (ra_word [lm])='from'	Then
								ls_line = RIGHTTRIM (ls_line) + ' FROM '
								CONTINUE
							ElseIF LEFT (ra_word [lm],3)='/*+'	Then
								ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
								CONTINUE
							ElseIF LEFT (ra_word [lm],6)='[SPACE'	Then
								CONTINUE
							ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
								ls_comment = nf_add_comment (ls_comment, ra_word [lm])
								CONTINUE
							ElseIF ra_word [lm]='('	Then
								pivot = nf_bracket_pivot (la_update, ll_update, ll, lm)
								ls_temp = wf_in (ls_return + ls_line, pivot.text)
								ls_line += wf_move ('(' + ls_temp, LenA (ls_line) + 1, false) + ') '
								ll = pivot.ll ; lm = pivot.lm
								ls_table = 'bracket'
								IF	ll>ll_update THEN EXIT
								lm_word = rt_line (la_update [ll], ra_word)	// 변경된 ll 반영
								CONTINUE
							End IF

							IF	f_null (ls_table)	Then
								ls_table = UPPER (ra_word [lm])
								ls_line += ls_table + ' '
							ElseIF ls_alias='auto'	Then
								ls_alias = lower (ra_word [lm])
								IF	LenA (ls_alias)=1	Then
									ls_line += ia [gl_select_step] + string(ASC (UPPER (ls_alias)) - 64) + ' '
								Else
									ls_line += ls_alias + ' '
								End IF
							Else
								ls_line += ra_word [lm] + ' '
							End IF
						NEXT
						IF	lb_exit THEN EXIT
						ls_line += ' '
						lm = 0
					NEXT
					IF	ls_alias='auto' THEN ls_line = RIGHTTRIM (ls_line)
					IF	f_notnull (ls_comment)	Then
						ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
						ls_comment = ''
					End IF
					IF	POS (ls_line,'FROM')=0 THEN ls_line = f_replace (ls_line, 'DELETE','DELETE FROM')
					IF	f_notnull (ls_line_comment)	Then
						ls_return += ls_line_comment
						ls_line_comment = ''
					End IF
					ls_return += ls_line + '~r~n'
					ls_line = ''
					EXIT
			END CHOOSE
		NEXT
	End IF

	IF	lb_set	Then	// SET
		IF	f_notnull (ls_line_comment)	Then
			ls_return += ls_line_comment
			ls_line_comment = ''
		End IF
		ls_return = RIGHTTRIM (ls_return) + '   SET '
		ls_text = wf_dml_update_set (ll, lm, la_update, {'where','using'})
		ls_return += wf_move (ls_text, 5, false) + '~r~n'
		IF	ll>ll_update THEN EXIT
		lm_word = rt_line (la_update [ll], ra_word)	// 변경된 ll 반영
		ll --
		lb_set = FALSE
		lb_where = TRUE
		CONTINUE
	End IF

	IF lb_where	Then	// WHERE
		IF	f_notnull (ls_line_comment)	Then
			ls_return += ls_line_comment
			ls_line_comment = ''
		End IF

		// 조건에 반드시 포함되어야 할 컬럼
		add_where.corp_gr [1] = false

		where_syntax = wf_dml_where (la_update, {ls_alias}, {ls_table}, {'N'}, add_where, ll_update, ll, lm)
		ls_return += where_syntax.text
		ll        = where_syntax.ll
		lm        = where_syntax.lm
		lb_where  = false
		IF	ll>ll_update THEN EXIT
	End IF
NEXT
IF	RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)

IF	POS (ls_return,'[SPACE')>0 THEN ls_return = wf_dml (ls_return + '[SPACEASCLEAR-' + string(gl_select_step) + ']', '')

// alias.+TABLE. 처리 20240320
IF	POS (ls_table,'.')>0 THEN ls_table = MID (ls_table, POS (ls_table,'.') + 1)
// 기존 1자리 영문자를 2자리 치환시 중복발생으로 기존영문을 숫자로 변환
IF	LenA (ls_alias)=1	Then
	ls_temp = ia [gl_select_step] + string(ASC (UPPER (ls_alias)) - 64)
	ls_return = f_replace1 (ls_return, ls_alias+'.', ls_temp+'.')
	ls_alias = ls_temp
End IF

gl_select_step --

IF	f_notnull (ls_line_comment) THEN ls_return += ls_line_comment

RETURN	ls_return
end function

public function s_ret nf_bracket_pivot (string arg_text[], long arg_ll_text, long arg_ll, long arg_lm);// ( ) 내용만 추출
S_RET	pivot, in_pivot

LONG  ll, lm, lm_word, in_bracket = 1, case_bracket, next_exit

BOOLEAN  lb_select, lb_exit, lb_pivot, lm_first, bracket_first, lb_0space, lb_with_dml

STRING   ls_line = '', ra_word [], bracket_space = ''
STRING   ls_dml, ls_with, ls_start, ls_end, ls_case, ls_line_comment, ls_space, ls_temp

pivot.text  = ''
pivot.pivot = ''

lm = arg_lm + 1
FOR  ll = arg_ll  TO  arg_ll_text
	yield ()
	IF	f_null (arg_text [ll]) THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_text [ll]),2)) Then
		IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
		ls_line_comment += wf_line_comment (arg_text, arg_ll_text, ll, false)
		CONTINUE
	End IF
	IF	f_notnull (ls_line_comment)	Then
		IF	f_notnull (pivot.text) And RIGHT (pivot.text,2)<>'~r~n' THEN pivot.text += '~r~n'
		pivot.text += ls_line_comment ; ls_line_comment = ''
	End IF
	lm_word = rt_line (arg_text [ll], ra_word)
	lm_first = true ; bracket_first = true
	FOR  lm = lm  TO  lm_word
		IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
		lb_0space = false
		CHOOSE CASE lower (ra_word [lm])
			CASE 'with'
				pivot.text += ls_line ; ls_line = ''
				lb_exit = false ; lb_with_dml = false
				ls_with = '' ; ls_dml = '' ; next_exit = in_bracket
				FOR  ll = ll  TO  arg_ll_text
					IF	f_null (arg_text [ll]) THEN CONTINUE
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_text [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (arg_text, arg_ll_text, ll, false)
						CONTINUE
					End IF
					IF	f_notnull (ls_line_comment)	Then
						IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
						IF	lb_with_dml	Then
							ls_dml += ls_line_comment
						Else
							ls_with += ls_line_comment
						End IF
						ls_line_comment = ''
					End IF
					lm_word = rt_line (arg_text [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]='' THEN CONTINUE
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							IF	lb_with_dml	Then
								ls_dml += ra_word [lm]
							Else
								ls_with += ra_word [lm]
							End IF
							CONTINUE
						End IF
						CHOOSE CASE lower (ra_word [lm])
							CASE '('
								in_bracket ++
								IF	lb_with_dml	Then
									ls_dml += ra_word [lm]
								Else
									ls_with += ra_word [lm]
								End IF
								CONTINUE
							CASE ')'
								in_bracket --
								IF	in_bracket=next_exit	Then
									ls_with += ls_dml + '~r~n)'
									ls_dml = '' ; lb_with_dml = false
									CONTINUE
								End IF
							CASE 'select'
								lb_select = true
								IF	lb_with_dml=false And in_bracket=next_exit	Then
									// with 최종 select
									FOR ll = ll  TO  arg_ll_text
										IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_text [ll]),2)) Then
											IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
											ls_line_comment += wf_line_comment (arg_text, arg_ll_text, ll, false)
											CONTINUE
										End IF
										IF	f_notnull (ls_line_comment)	Then
											IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
											ls_with += ls_line_comment
											ls_line_comment = ''
										End IF
										lm_word = rt_line (arg_text [ll], ra_word)
										FOR  lm = lm  TO  lm_word
											CHOOSE CASE ra_word [lm]
												CASE '('
													in_bracket ++
												CASE ')',') loop'
													in_bracket --
													IF	in_bracket=(next_exit - 1)	Then
														lb_exit = true
														EXIT
													End IF
											END CHOOSE
											ls_dml += ra_word [lm]
										NEXT
										IF	lb_exit THEN EXIT
										ls_dml += '~r~n'
										lm = 1
									NEXT
									ls_with += ls_dml ; ls_dml = ''
									EXIT
								End IF
						END CHOOSE
						IF	in_bracket>next_exit And f_notnull (ra_word [lm]) THEN lb_with_dml = true
						IF	lb_with_dml	Then
							ls_dml += ra_word [lm]
						Else
							ls_with += ra_word [lm]
						End IF
					NEXT
					IF	lb_exit THEN EXIT
					IF	lb_with_dml	Then
						ls_dml += '~r~n'
					Else
						ls_with += '~r~n'
					End IF
					lm = 1
				NEXT
				ls_with = wf_with (ls_with)
				IF	RIGHT (ls_with,2)='~r~n' THEN ls_with = LEFT (ls_with, LEN (ls_with) - 2)
				pivot.text = TRIM (pivot.text) + ls_with
				EXIT
			CASE 'select'
				lb_select = true
				pivot.text += ls_line ; ls_line = ''
				next_exit = in_bracket - 1
				lb_exit = false ; ls_dml = ''
				FOR  ll = ll  TO  arg_ll_text
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_text [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (arg_text, arg_ll_text, ll, false)
						CONTINUE
					End IF
					IF	f_notnull (ls_line_comment)	Then
						IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
						ls_dml += ls_line_comment
						ls_line_comment = ''
					End IF
					lm_word = rt_line (arg_text [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						CHOOSE CASE lower (ra_word [lm])
							CASE '('
								in_bracket ++
							CASE ')',') loop'
								in_bracket --
								IF	in_bracket=next_exit	Then
									lb_exit = true
									EXIT
								End IF
						END CHOOSE
						ls_dml += ra_word [lm]
					NEXT
					IF	lb_exit THEN EXIT
					ls_dml += '~r~n'
					lm = 1
				NEXT
				ls_dml = wf_dml_select (ls_dml)
				IF	POS (ls_dml,'~r~n')=0 Then
					pivot.text += ls_dml ; ls_line = ''
				Else
					gl_select ++
					ga_select [gl_select] = ls_dml
					pivot.text = RIGHTTRIM (pivot.text) + '[SELECT-' + string (gl_select) + ']'
				End IF
				ls_dml = ''
				EXIT
			CASE 'case','decode'
				ls_case = ra_word [lm]
				IF	ra_word [lm]='CASE'	Then
					case_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					case_bracket = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  arg_ll_text
					IF	f_null (arg_text [ll]) THEN CONTINUE
					lm_word = rt_line (arg_text [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						ls_case += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								case_bracket ++
							CASE ls_end
								case_bracket --
								IF	case_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	case_bracket=0 THEN EXIT
					ls_case += '~r~n'
					lm = 0
				NEXT
				IF	ls_start='case'	Then
					ls_case = wf_case (ls_case)
				Else
					ls_case = nf_decode (ls_case)
				End IF
				ls_space = wf_bracket_space (ls_line)
				ls_line += wf_move (ls_case, LEN (ls_space), false) + ' '
				IF	ll>arg_ll_text THEN EXIT
				lb_0space = true
				lm_first = false
				CONTINUE
			CASE 'partition by'
				ls_line = RIGHTTRIM (ls_line) + ra_word [lm]
				lm_first = false
				CONTINUE
			CASE '('
				ls_space = wf_bracket_space (ls_line)
				in_pivot = nf_bracket_pivot (arg_text, arg_ll_text, ll, lm)
				ls_temp  = in_pivot.text
				IF POS (lower (ls_temp),' and')=0 And POS (ls_temp,' or')=0	Then
					ls_temp = f_word_replace (ls_temp, {'AND','And','OR','Or'})
				Else
					ls_temp = wf_in (ls_line, ls_temp)
				End IF
				ls_line += '(' + wf_move (ls_temp, LEN (ls_space) + 1, false) + ') '
				ll = in_pivot.ll
				lm = in_pivot.lm
				IF	ll>arg_ll_text THEN EXIT
				lm_word = rt_line (arg_text [ll], ra_word)	// 변경된 ll 반영
				lb_0space = true
				lm_first = false
				CONTINUE
			CASE ')',') loop'
				in_bracket --
				IF	in_bracket=0	Then
					lb_exit = true
					EXIT
				End IF
				bracket_first = false
			CASE ','
				ls_line = RIGHTTRIM (ls_line) + ','
				IF	lm<(lm_word - 1)	Then
					IF	f_notnull (ra_word [lm + 1])	Then
						IF NOT (LEFT (ra_word [lm + 1],1)="'" OR isNumber (ra_word [lm + 1])) THEN ls_line += ' '
					Else
						IF	NOT (LEFT (ra_word [lm + 2],1)="'" OR isNumber (ra_word [lm + 2])) THEN ls_line += ' '
					End IF
				End IF
				lb_0space = true
				lm_first = false
				CONTINUE
			CASE '+','-','*','/','**','<','>','<=','>=','<>','!=','!~~','<![cdata[<=]]>','<![cdata[>=]]>','<![cdata[<]]>','<![cdata[>]]>','<![cdata[<>]]>','||'
				IF	lm_first	Then
					ls_line = RIGHTTRIM (ls_line) + bracket_space + ra_word [lm] + ' '
				Else
					ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
				End IF
				lb_0space = TRUE
				lm_first = false
				CONTINUE
		END CHOOSE
		IF	lm_first	Then
			ls_line = RIGHTTRIM (ls_line) + bracket_space + ra_word [lm]
		Else
			ls_line += ra_word [lm]
		End IF
		IF	f_notnull (ra_word [lm]) THEN lm_first = false
	NEXT
	IF	f_notnull (nf_clear (ls_line))	Then
		IF	RIGHT(TRIM (ls_line),2)='BY'	Then
			pivot.text += RIGHTTRIM (ls_line) + ' '
			lb_0space = true
		ElseIF RIGHT(pivot.text,3)=',~r~n'	Then
			pivot.text += TRIM (ls_line) + '~r~n'
		Else
			pivot.text += RIGHTTRIM (ls_line) + '~r~n'
		End IF
	End IF
	ls_line = ''
	IF	lb_exit THEN EXIT
	lm = 1
NEXT
IF	RIGHT (pivot.text,2)='~r~n' THEN pivot.text = LEFT (pivot.text, LEN (pivot.text) - 2)

IF	ll>arg_ll_text	Then
	pivot.ll = arg_ll_text
	pivot.lm = lm_word
Else
	pivot.ll = ll
	pivot.lm = lm
End IF

IF	lb_select	Then
	lb_exit = false
	FOR  ll = ll  TO  arg_ll_text
		IF	f_null (arg_text [ll]) THEN CONTINUE
		lm_word = rt_line (arg_text [ll], ra_word)
		FOR  lm = lm + 1  TO  lm_word
			IF	f_null (ra_word [lm]) THEN CONTINUE
			CHOOSE CASE lower (ra_word [lm])
				CASE 'pivot','unpivot'
					pivot.pivot = ' ' + UPPER (ra_word [lm])
					lb_exit = TRUE
					EXIT
			END CHOOSE
			lb_exit = true
			EXIT
		NEXT
		IF	lb_exit THEN EXIT
		IF	f_notnull (pivot.pivot) And RIGHT (pivot.pivot,1)<>' ' THEN pivot.pivot += ' '
		lm = 0
	NEXT
	IF	f_notnull (pivot.pivot)	Then
		in_bracket = 0
		FOR  ll = ll  TO  arg_ll_text
			lm_word = rt_line (arg_text [ll], ra_word)
			lb_0space = false
			FOR  lm = lm  TO  lm_word
				IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
				lb_0space = false
				CHOOSE CASE lower (ra_word [lm])
					CASE 'pivot','unpivot'
						lb_pivot = TRUE
						FOR  lm = lm + 1  TO  lm_word
							IF	ra_word [lm]='('	Then
								in_bracket ++
								EXIT
							End IF
							pivot.pivot += nf_1space (UPPER (ra_word [lm]))
						NEXT
					CASE '('
						IF	lb_pivot THEN in_bracket ++
					CASE ')'
						IF	lb_pivot THEN in_bracket --
					CASE ','
						pivot.pivot = RIGHTTRIM (pivot.pivot) + '~r~n ' + ls_space + ','
						lb_0space = true
						CONTINUE
					CASE 'for','as'
						pivot.pivot = RIGHTTRIM (pivot.pivot) + ' ' + UPPER (ra_word [lm])
						CONTINUE
					CASE 'in'
						pivot.pivot = RIGHTTRIM (pivot.pivot) + ' IN'
						ls_space = wf_bracket_space (pivot.pivot)
						CONTINUE
				END CHOOSE
				IF	lb_pivot	Then
					IF	in_bracket=0 THEN EXIT
					pivot.pivot += ra_word [lm]
				End IF
			NEXT
			IF	in_bracket=0 And lb_pivot THEN EXIT
			IF	lb_pivot THEN pivot.pivot += '~r~n'
			lm = 1
		NEXT
		IF	RIGHT (pivot.pivot,2)='~r~n' THEN pivot.pivot = LEFT (pivot.pivot, LEN (pivot.pivot) - 2)
		IF	ll>arg_ll_text	Then
			pivot.ll = arg_ll_text
			pivot.lm = lm_word
		Else
			pivot.ll = ll
			pivot.lm = lm
		End IF
	End IF
End IF

IF	f_notnull (pivot.pivot)	Then
	ls_space = wf_bracket_space (pivot.text)
	pivot.text += ' )' + wf_move (pivot.pivot, LEN (ls_space) + 2, false)
End IF

RETURN	pivot
end function

public function string wf_move (string arg_move_line, long arg_move, boolean arg_trim);// arg_move 크기만큼 위치이동

LONG  ll, ll_line, ll_comment, lc

STRING   ls_return, ls_temp, ls_line_comment
STRING   la_line [], la_comment []

IF POS (arg_move_line, '~r~n')=0 Then
   IF arg_trim Then
      RETURN TRIM (arg_move_line)
   ELSE
      RETURN arg_move_line
   END IF
END IF
ll_line = f_get_array (arg_move_line, '~r~n', la_line)
FOR  ll = 1  TO  ll_line
   IF f_null (la_line [ll]) THEN CONTINUE
   IF nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_line [ll]),2))   Then
      IF f_notnull (ls_line_comment) AND RIGHT (ls_line_comment,2) <> '~r~n' THEN ls_line_comment += '~r~n'
      ls_line_comment += wf_line_comment (la_line, ll_line, ll, true)
      CONTINUE
   END IF
   IF f_notnull (ls_line_comment)   Then
      IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
      ll_comment = f_get_array (ls_line_comment, '~r~n', la_comment)
      FOR  lc = ll_comment  TO  1  STEP -1
         IF f_null (la_comment [lc])   Then
            ll_comment --
         ELSE
            EXIT
         END IF
      NEXT
      FOR  lc = 1  TO  ll_comment
         ls_return += SPACE (arg_move) + la_comment [lc] + '~r~n'
      NEXT
      ls_line_comment = ''
   END IF
   IF ll=1  Then
      IF arg_trim Then
         ls_return += TRIM (la_line [1])
      ELSE
         ls_return += la_line [1]
      END IF
   ELSE
      IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
      IF arg_trim Then
         ls_return += SPACE (arg_move) + TRIM (la_line [ll])
      ELSE
         IF arg_move>0  Then
            ls_return += SPACE (arg_move) + la_line [ll]
         ELSE
            ls_temp = LEFT (la_line [ll], ABS (arg_move) - 1)
            IF f_null (ls_temp)  Then
               ls_return += MID (la_line [ll], ABS (arg_move))
            ELSE
               ls_return += la_line [ll]
            END IF
         END IF
      END IF
   END IF
NEXT
IF f_notnull (ls_line_comment)   Then
   IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
   ll_comment = f_get_array (ls_line_comment, '~r~n', la_comment)
   FOR  lc = ll_comment  TO  1  STEP -1
      IF f_null (la_comment [lc])   Then
         ll_comment --
      ELSE
         EXIT
      END IF
   NEXT
   FOR  lc = 1  TO  ll_comment
      IF f_notnull (LEFT (la_comment [lc], arg_move + 1)) THEN ls_return += SPACE (arg_move + 1)
      ls_return += la_comment [lc] + '~r~n'
   NEXT
   ls_line_comment = ''
END IF

RETURN   ls_return
end function

public function string wf_move_force (string arg_move_line, string arg_move);// arg_move 크기만큼 일괄 위치이동
// 이동할 위치보다 공백이 적은 경우에만 공백추가
BOOLEAN	lb_first = true, lb_move

LONG  ll, ll_line, lm, lm_word

STRING   ls_return = '',  la_line [], ra_word []

ll_line = f_get_array (arg_move_line, '~r~n', la_line)
FOR  ll = 1  TO  ll_line
   IF f_null (la_line [ll])   Then
      ls_return += '~r~n'
		CONTINUE
	End IF
	IF	lb_first	Then
		IF	LEFT (TRIM (la_line [ll]),2)='/*'	Then
			lb_move = true
			lb_first = false
		ElseIF LEFT (TRIM (la_line [ll]),2)='--'	Then	// -- remark는 위치이동 없음
			lb_move = false
		End IF
	End IF
	IF	lb_move=false	Then	
		ls_return += la_line [ll] + '~r~n'
	Else
		lm_word = rt_line (la_line [ll], ra_word)
		IF	f_notnull (ra_word [1])	Then
			ls_return += arg_move + TRIM (ra_word [1])
		Else
			IF	LEN (ra_word [1])>LEN (arg_move)	Then
				ls_return += ra_word [1]
			Else
				ls_return += arg_move
			End IF
		End IF
		FOR  lm = 2  TO  lm_word
			ls_return += ra_word [lm]
		NEXT
		ls_return += '~r~n'
	End IF
NEXT
RETURN	LEFT (ls_return, LEN (ls_return) - 2)
end function

public function string wf_move_back (string arg_move_line, integer arg_back);// arg_back 크기만큼 일괄 위치이동
// 뒤로 이동할 공간이 공백인 경우 뒤로 이동, 공백이 적은 경우는 해당 공백만 제거
LONG  ll, ll_line

STRING   ls_return = '', la_line []

ll_line = f_get_array (arg_move_line, '~r~n', la_line)
FOR  ll = 1  TO  ll_line
   IF f_null (la_line [ll])   Then
      ls_return += '~r~n'
   ELSEIF f_null (LEFT (la_line [ll], arg_back))   Then
      ls_return += MID (la_line [ll], arg_back + 1) + '~r~n'
   ELSE
      ls_return += TRIM (la_line [ll]) + '~r~n'
   END IF
NEXT
RETURN   LEFT (ls_return, LEN (ls_return) - 2)
end function

public function string wf_with (string arg_with);BOOLEAN	lb_with_as, lb_exit, lm_first, lb_0space

LONG	ll, lm, lm_word, ll_with, in_bracket

STRING	ls_with, ls_sql_comment = '', ls_line_comment, ls_dml, ls_temp
STRING	la_with [], ra_word []

ls_sql_comment  = '--------------------------------------------------------------------------------~r~n'
ls_sql_comment += '-- 내부 함수(테이블) 이용한 쿼리 실행~r~n'
ls_sql_comment += '--------------------------------------------------------------------------------~r~n'

ll_with = f_get_array (LEFTTRIM (arg_with),'~r~n',la_with)
FOR  ll = 1  TO  ll_with
	IF	f_null (la_with [ll]) THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_with [ll]),2)) Then
		IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
		ls_line_comment += wf_line_comment (la_with, ll_with, ll, false)
		IF	POS (ls_line_comment,'이용한 쿼리 실행')>0 OR POS (ls_line_comment,'-- MAIN SQL')>0 THEN ls_sql_comment = ''
		CONTINUE
	End IF
	IF	f_notnull (ls_line_comment)	Then
		IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
		ls_with += ls_line_comment
		ls_line_comment = ''
	End IF
	lm_word = rt_line (la_with [ll], ra_word)
	lb_0space = false
	FOR  lm = 1  TO  lm_word
		IF	ra_word [lm]='' OR ((lb_0space OR NOT lb_with_as) And f_null (ra_word [lm])) THEN CONTINUE
		lb_0space = false
		CHOOSE CASE lower (ra_word [lm])
			CASE 'select'
				lb_exit = true
				EXIT
			CASE 'with'
				ls_with += 'WITH '
				lb_0space = true
				CONTINUE
			CASE 'is','as'
				lb_with_as = true
				IF	RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
				ls_with = RIGHTTRIM (ls_with) + ' ' + UPPER (ra_word [lm])
			CASE ','
				IF	RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
				ls_with += '   , '
				lb_0space = true
			CASE 'function'
				ls_with = RIGHTTRIM (ls_with) + IIF (lower (ra_word [1])='with','','~r~n    ') + ' FUNCTION'
				FOR  ll = ll  TO  ll_with
					IF	f_null (la_with [ll]) THEN CONTINUE
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_with [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (la_with, ll_with, ll, false)
						CONTINUE
					End IF
					IF	f_notnull (ls_line_comment)	Then
						IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
						ls_with += ls_line_comment
						ls_line_comment = ''
					End IF
					IF	lm=0	Then
						ls_with += la_with [ll]
					Else
						FOR  lm = lm + 1  TO  lm_word
							ls_with += ra_word [lm]
						NEXT
						lm = 0
					End IF
					IF	lower(TRIM (la_with [ll]))='end;'	Then
						ls_with += la_with [ll]
						EXIT
					End IF
					IF f_notnull (ls_with) THEN ls_with += '~r~n'
				NEXT
				IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
				IF	ll>ll_with THEN EXIT
				CONTINUE
			CASE ')'
				IF	RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
				ls_with += '   )'
				lb_0space = true
				CONTINUE
			CASE '('
				ls_with = RIGHTTRIM (ls_with)
				IF	NOT lb_with_as	Then
					IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
					ls_with += '   ( '
					lb_0space = true
					CONTINUE
				Else
					ls_with += ' ( '
				End IF
				ls_dml = '' ; in_bracket = 1
				FOR  ll = ll  TO  ll_with
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_with [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (la_with, ll_with, ll, false)
						IF	POS (ls_line_comment,'이용한 쿼리 실행')>0 OR POS (ls_line_comment,'-- MAIN SQL')>0 THEN ls_sql_comment = ''
						CONTINUE
					End IF
					IF	f_notnull (ls_line_comment)	Then
						IF	f_notnull (ls_dml)	Then
							IF	RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
							ls_dml +=  ls_line_comment
						Else
							IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
							ls_with +=  ls_line_comment
						End IF
						ls_line_comment = ''
					End IF
					lm_word = rt_line (la_with [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						CHOOSE CASE lower (ra_word [lm])
							CASE 'select'
								ls_dml += ra_word [lm]
								CONTINUE
							CASE '('
								in_bracket ++
							CASE ')'
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
						IF	f_notnull (ls_dml)	Then
							ls_dml += ra_word [lm]
						Else
							ls_with += ra_word [lm]
						End IF
					NEXT
					IF	in_bracket=0 THEN EXIT
					IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
					lm = 0
				NEXT
				IF	LEFT (ls_dml,6)='SELECT'	Then
					ls_dml = wf_dml_select (ls_dml)
					ls_dml = wf_move (ls_dml, 6, false)
				End IF
				ls_with = RIGHTTRIM (ls_with) + ' ' + ls_dml + '~r~n    )'
				lb_with_as = false
				lb_0space  = true
			CASE ELSE
				ls_with += nf_1space (ra_word [lm])
		END CHOOSE
	NEXT
	IF	f_notnull (ls_with) And RIGHT (ls_with,2)<>'~r~n' THEN ls_with += '~r~n'
	IF	lb_exit THEN EXIT
NEXT

ls_dml = 'SELECT'
FOR ll = ll  TO  ll_with
	IF	f_null (la_with [ll]) THEN CONTINUE
	IF	lm=0	Then
		ls_dml += la_with [ll]
	Else
		FOR  lm = lm + 1  TO  lm_word
			ls_dml += ra_word [lm]
		NEXT
		lm = 0
	End IF
	ls_dml += '~r~n'
NEXT
ls_dml = LEFT (ls_dml, LEN (ls_dml) - 2)

IF	f_notnull (ls_sql_comment) THEN ls_with += ls_sql_comment + '~r~n'

IF	LEFT (ls_dml,6)='SELECT' THEN ls_dml = wf_dml_select (ls_dml)
ls_with += '  ' + wf_move (ls_dml, 2, false)

ll_with = f_get_array (ls_with, '~r~n', la_with)
ls_with = ''
FOR  ll = 1  TO  ll_with
	IF	f_null (la_with [ll]) THEN CONTINUE
	ls_with += la_with [ll] + '~r~n'
NEXT
ls_with = LEFT (ls_with, LEN (ls_with) - 2)

RETURN	ls_with
end function

public function string nf_1space (string arg_word);IF	f_notnull (arg_word)	Then
	RETURN arg_word
Else
	IF	LEN (arg_word)>=1	Then
		RETURN ' '
	Else
		RETURN ''
	End IF
End IF
end function

public function string wf_dml_where_line (long arg_max, string arg_t1, string arg_t2, string arg_t3, string arg_xml_if, string arg_t5, string arg_t6, boolean arg_where);LONG  ll, ll_text, lSP, ll_pos, ll_first

BOOLEAN  lb_first

STRING   ls_return = '', la_text [], ls_line, ls_space, ls_temp

ls_temp = f_replace (lower (arg_t1), '~r~n', '') + TRIM (arg_t2) + f_replace (lower (arg_t3), '~r~n', '')
IF NOT arg_where AND (ls_temp='1=1' OR ls_temp='a=a') Then
   RETURN ''
END IF

IF arg_t5='OR' Then
   ls_return = IIF (NOT arg_where, '    OR ', ' WHERE ')
ELSE
   ls_return = IIF (NOT arg_where, '   AND ', ' WHERE ')
END IF

lSP = LenA (ls_return)

IF UPPER (arg_t1)='ROWNUM' Then
   ls_return += 'ROWNUM '
ELSEIF NOT nf_comp ({'EXISTS','NOT EXISTS','REGEXP_LIKE','NOT REGEXP_LIKE'}, arg_t1)  Then
	ls_temp = TRIM (f_replace (lower (arg_t1), '~r~n', ' '))
	IF	arg_t2='' And arg_t3='' And LEFT (ls_temp,1)='(' And RIGHT (ls_temp,1)=')' And POS (ls_temp,' or ')=0 	Then
		arg_t1 = MID (TRIM (arg_t1),2)
		arg_t1 = MID (arg_t1, 1, LASTPOS (arg_t1,')') - 1) + MID (arg_t1, LASTPOS (arg_t1,')') + 1)
	End IF
   ll_text  = f_get_array (arg_t1, '~r~n', la_text)
   lb_first = TRUE
   FOR  ll = 1  TO  ll_text
      IF f_null (la_text [ll])   Then
         IF NOT lb_first AND (LEFT (TRIM (arg_t3),1)='(' OR LEFT (TRIM (arg_t3),4)='CASE') THEN ls_return=RIGHTTRIM (ls_return) + '~r~n' + SPACE (8)
         CONTINUE
      END IF
      ls_line = la_text [ll]
      IF LEFT (TRIM (ls_line),2)='/*'  Then
         ls_line = '       ' + LEFTTRIM (ls_line)
      ELSEIF ll>1 AND nf_comp ({'+','-','*','/','|'}, LEFT (TRIM (ls_line),1))  Then
         ll_pos = nf_first (la_text [ll - 1], LEFTTRIM (la_text [ll]))
         IF ll_pos>0 THEN ls_line=SPACE (ll_pos) + LEFTTRIM (ls_line)
      END IF
      IF LenA (ls_line) >= arg_max OR lower (ls_line)='rownum' Then
         IF ll_first<1  Then
            ls_return += IIF (NOT lb_first, '~r~n' + SPACE (lSP), '') + ls_line
         ELSE
            ls_return += IIF (NOT lb_first, '~r~n' + SPACE (ll_first), '') + ls_line
         END IF
      ELSE
         IF LEFT (TRIM (ls_line),1)=','   Then
            IF ll_first=-1 Then
               ll_first = PosA (la_text [ll - 1], 'in (')
               IF ll_first>0 THEN ll_first += 9
            END IF
         END IF
         IF f_null (LeftA (ls_line + SPACE(arg_max), arg_max)) Then  // ' '가 들어간 경우 null이 나옴
            ls_line += ' '
         ELSE
            ls_line = LeftA (ls_line + SPACE(arg_max), arg_max)
         END IF
         IF ll_first<1  Then
            IF NOT lb_first THEN ls_return += '~r~n' + SPACE (lSP)
         ELSE
            IF NOT lb_first THEN ls_return += '~r~n' + SPACE (ll_first)
         END IF
         ls_return += ls_line
      END IF
      lb_first = FALSE
   NEXT
   ls_return += ' '
END IF

IF nf_comp ({'is null','is not null'}, arg_t2)   Then
   ls_return = RIGHTTRIM (ls_return) + ' ' + arg_t2 + ' '
ELSE
   ls_return += arg_t2 + ' '
END IF

IF POS (arg_t3,'~r~n')=0   Then
   ls_return += arg_t3
ELSE
   ls_space = wf_bracket_space (ls_return)
   IF lower (RIGHT (TRIM (ls_return),7))='between' Then
      ls_return += wf_move (arg_t3, LEN (ls_space) - 4, false)
   ELSE
      ls_return += wf_move (arg_t3, LEN (ls_space), false)
   END IF
END IF
ls_return = RIGHTTRIM (ls_return)
IF RIGHT (ls_return,2)='~r~n' THEN ls_return=LEFT (ls_return, LEN (ls_return) - 2)

// comment
ls_return = wf_add_comment_num (ls_return, arg_t6, 0, true)

RETURN   ls_return + '~r~n'
end function

public function s_ret wf_dml_where (string arg_where[], string arg_alias[], string arg_table[], string arg_join_table[], ref s_where_add_column arg_add_where, long arg_ll_where, long arg_ll, long arg_lm);LONG  lw = 0, lo, lt, lx, lz, lm_word, ll_move
LONG  in_bracket, lw_col, lMax = 2, ll_alias, ll_max_com

BOOLEAN  lb_first, lb_between_exit, lb_exit, lb_where_first, lb_sort, lb_1where, lb_0space

STRING   ls_start, ls_end, ls_with_space, ls_space, ls_temp, ls_case, ra_word []
STRING   ls_using = '', ls_xml_if = '', ls_for_lock = '', ls_line_comment = '', ls_with = ''

S_WHERE  la_where []

S_RET    pivot, where_syntax

ll_alias = UPPERBOUND (arg_alias)

where_syntax.text = ''
FOR  where_syntax.ll = arg_ll  TO  arg_ll_where
   IF f_null (arg_where [where_syntax.ll])   Then
      arg_lm = 1
      CONTINUE
   END IF
   IF UPPER (LEFT (TRIM (arg_where [where_syntax.ll]),4))='WITH'  Then
      ls_with = '~r~n~r~n'
      FOR  where_syntax.ll = where_syntax.ll  TO  arg_ll_where
         lm_word  = rt_line (arg_where [where_syntax.ll], ra_word)
         lb_first = true
         FOR  where_syntax.lm = 1  TO  lm_word
            IF f_null (ra_word [where_syntax.lm]) AND lb_first THEN CONTINUE
            lb_first = false
            ls_with  += nf_1space (ra_word [where_syntax.lm])
         NEXT
         ls_with += '~r~n'
      NEXT
      EXIT
   END IF

   lm_word = rt_line (arg_where [where_syntax.ll], ra_word)
   IF nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_where [where_syntax.ll]),2))  Then
      IF f_notnull (ls_line_comment) AND RIGHT (ls_line_comment,2) <> '~r~n' THEN ls_line_comment += '~r~n'
      ls_line_comment += wf_line_comment (arg_where, arg_ll_where, where_syntax.ll, false)
      arg_lm          = 1
      CONTINUE
   END IF
   lb_first = TRUE
   FOR  where_syntax.lm = arg_lm  TO  lm_word
      IF f_null (ra_word [where_syntax.lm]) THEN CONTINUE
      IF nf_comp ({'--','//','/*'}, LEFT (ra_word [where_syntax.lm],2))   Then
         IF lw=0  Then
            // where 조건전에 comment가 있는 경우 1 = 1 추가해서 comment 처리
            lw ++
            la_where [lw].w1 = '1'
            la_where [lw].w2 = '='
            la_where [lw].w3 = '1'
            la_where [lw].w4 = TRIM (ls_xml_if)
            la_where [lw].w5 = ''
            la_where [lw].w6 = ''
            la_where [lw].w7 = ''
         END IF
         la_where [lw].w6 = nf_add_comment (la_where [lw].w6, ra_word [where_syntax.lm])
         CONTINUE
      END IF

      IF lower (ra_word [where_syntax.lm])='start with'  Then
         IF f_notnull (where_syntax.text) AND RIGHT (where_syntax.text,2) <> '~r~n' THEN where_syntax.text += '~r~n'
         where_syntax.text += ' START WITH '
         ls_with_space     = SPACE (LenA (ra_word [where_syntax.lm]) - 3)
         lw_col            = 1
         lb_first          = FALSE
         lw ++
         la_where [lw].w1 = ''
         la_where [lw].w2 = ''
         la_where [lw].w3 = ''
         la_where [lw].w4 = TRIM (ls_xml_if)
         la_where [lw].w5 = 'START WITH'
         la_where [lw].w6 = ''
         la_where [lw].w7 = ''
         CONTINUE
      END IF

      CHOOSE CASE lower (ra_word [where_syntax.lm])
         CASE 'where', 'and', 'or'
            lw_col   = 1
            lb_first = FALSE
            lw ++
            la_where [lw].w1 = ''
            la_where [lw].w2 = ''
            la_where [lw].w3 = ''
            la_where [lw].w4 = TRIM (ls_xml_if)
            la_where [lw].w5 = upper (ra_word [where_syntax.lm])
            la_where [lw].w6 = ''
            la_where [lw].w7 = ''
            // 조건에 OR 만 있는 경우 처리는 위해
            // OR 와 AND 가 병행되어 있을때는 ( ) 처리를 해야 하므로
            IF lower (ra_word [where_syntax.lm])='or' AND la_where [1].w5='WHERE'   Then
               FOR  lo = 1  TO  lw
                  IF f_nvl (la_where [lo].w5,'WHERE')='WHERE' THEN la_where [lo].w5 = 'OR'
               NEXT
            END IF
            CONTINUE
         CASE 'union', 'minus'
            where_syntax.by    = FALSE
            where_syntax.UNION = TRUE
            lb_exit            = TRUE
            EXIT
         CASE 'using', 'limit'
            ls_using += ' ' + upper (ra_word [where_syntax.lm])
            FOR  where_syntax.lm = where_syntax.lm + 1  TO  lm_word
               ls_using += nf_1space (ra_word [where_syntax.lm])
            NEXT
            where_syntax.by    = FALSE
            where_syntax.UNION = FALSE
            lb_exit            = TRUE
            EXIT
         CASE 'group by', 'order by', 'having', 'connect by', 'connect by prior', 'connect by level', 'connect by nocycle'
            where_syntax.by    = TRUE
            where_syntax.UNION = FALSE
            lb_exit            = TRUE
            EXIT
         CASE 'for'
            FOR  where_syntax.ll = where_syntax.ll  TO  arg_ll_where
               lm_word = rt_line (arg_where [where_syntax.ll], ra_word)
               FOR  where_syntax.lm = where_syntax.lm  TO  lm_word
                  CHOOSE CASE lower (ra_word [where_syntax.lm])
                     CASE 'for', 'update', 'nowait', 'wait', 'of', 'skip', 'locked'
                        ra_word [where_syntax.lm] = upper (ra_word [where_syntax.lm])
                  END CHOOSE
                  ls_for_lock += nf_1space (ra_word [where_syntax.lm])
               NEXT
               where_syntax.lm = 1
            NEXT
            where_syntax.by    = TRUE
            where_syntax.UNION = FALSE
            lb_exit            = TRUE
            IF where_syntax.ll>arg_ll_where THEN EXIT
            EXIT
         CASE 'case', 'decode'
            ls_case = ra_word [where_syntax.lm]
            IF lower (ls_case)='case'  Then
               in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
            ELSE
               in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
            END IF
            FOR  where_syntax.ll = where_syntax.ll  TO  arg_ll_where
               IF f_null (arg_where [where_syntax.ll]) THEN CONTINUE
               lm_word = rt_line (arg_where [where_syntax.ll], ra_word)
               IF nf_comp ({'--','//','/*'}, LEFT (TRIM (arg_where [where_syntax.ll]),2)) Then
                  IF f_notnull (ls_case) AND RIGHT (ls_case,2) <> '~r~n' THEN ls_case += '~r~n'
                  ls_case += wf_line_comment (arg_where, arg_ll_where, where_syntax.ll, false)
                  where_syntax.lm = 0
                  CONTINUE
               END IF
               FOR  where_syntax.lm = where_syntax.lm + 1  TO  lm_word
                  ls_case += ra_word [where_syntax.lm]
                  CHOOSE CASE lower (ra_word [where_syntax.lm])
                     CASE ls_start
                        in_bracket ++
                     CASE ls_end
                        in_bracket --
                        IF in_bracket=0 THEN EXIT
                  END CHOOSE
               NEXT
               IF in_bracket=0 THEN EXIT
               ls_case += '~r~n'
               where_syntax.lm = 0
            NEXT
            IF ls_start='case'   Then
               ls_case = wf_case (ls_case)
            ELSE
               ls_case = nf_decode (ls_case)
            END IF
				// where 조건에 있는 case에 ( )가 없는경우 추가
				IF LEFT (ls_case,1)<>'(' THEN ls_case = '(' + ls_case + ')'
            IF lw_col=1 Then
               la_where [lw].w1 += ls_case
            ELSE
               ls_space = wf_bracket_space (la_where [lw].w3)
               la_where [lw].w3 += wf_move (ls_case, LEN (ls_space), false)
            END IF
            IF where_syntax.ll>arg_ll_where  Then
               where_syntax.by    = TRUE
               where_syntax.UNION = FALSE
               lb_exit            = TRUE
               EXIT
            END IF
         CASE 'between', 'not between'
            la_where [lw].w7 = 'change'
            IF lower (ra_word [where_syntax.lm])='between'  Then
               la_where [lw].w2 += 'Between'
            ELSE
               la_where [lw].w2 += 'NOT Between'
            END IF
            lw_col          = 3
            lb_between_exit = FALSE
            FOR  where_syntax.ll = where_syntax.ll  TO  arg_ll_where
               lm_word = rt_line (arg_where [where_syntax.ll], ra_word)
               lb_0space = false
               FOR  where_syntax.lm = where_syntax.lm + 1  TO  lm_word
                  IF lb_0space AND f_null (ra_word [where_syntax.lm]) THEN CONTINUE
                  lb_0space = false
                  CHOOSE CASE lower (ra_word [where_syntax.lm])
                     CASE 'case', 'decode'
                        ls_case = ra_word [where_syntax.lm]
                        IF lower (ra_word [where_syntax.lm])='case'  Then
                           in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
                        ELSE
                           in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
                        END IF
                        FOR  where_syntax.ll = where_syntax.ll  TO  arg_ll_where
                           IF f_null (arg_where [where_syntax.ll]) THEN CONTINUE
                           lm_word = rt_line (arg_where [where_syntax.ll], ra_word)
                           FOR  where_syntax.lm = where_syntax.lm + 1  TO  lm_word
                              IF nf_comp ({'--','//','/*'}, LEFT (ra_word [where_syntax.lm],2))   Then
                                 la_where [lw].w6 = nf_add_comment (la_where [lw].w6, ra_word [where_syntax.lm])
                                 CONTINUE
                              END IF
                              ls_case += ra_word [where_syntax.lm]
                              CHOOSE CASE lower (ra_word [where_syntax.lm])
                                 CASE ls_start
                                    in_bracket ++
                                 CASE ls_end
                                    in_bracket --
                                    IF in_bracket=0 THEN EXIT
                              END CHOOSE
                           NEXT
                           IF in_bracket=0 THEN EXIT
                           ls_case += '~r~n'
                           where_syntax.lm = 0
                        NEXT
                        IF ls_start='case'   Then
                           ls_case = wf_case (ls_case)
                        ELSE
                           ls_case = nf_decode (ls_case)
                        END IF
                        ls_space = wf_bracket_space (la_where [lw].w3)
                        la_where [lw].w3 += wf_dml (ls_case, ls_space)
                        IF where_syntax.ll>arg_ll_where THEN EXIT
                     CASE 'and'
                        IF RIGHT (TRIM (la_where [lw].w3),2)='~r~n'  Then
                           la_where [lw].w3 = RIGHTTRIM (wf_move (la_where [lw].w3, 4, false)) + '~r~nAND '
                        ELSE
                           la_where [lw].w3 = RIGHTTRIM (wf_move (la_where [lw].w3, 4, false)) + ' AND '
                        END IF
                        lb_between_exit = TRUE
								lb_0space       = true
                     CASE '('
                        la_where [lw].w3 += '(' ; ls_space = wf_bracket_space (la_where [lw].w3)
                        pivot   = nf_bracket_pivot (arg_where, arg_ll_where, where_syntax.ll, where_syntax.lm)
                        ll_move = LEN (ls_space)
                        IF nf_comp ({'IN','NOT IN'},la_where [lw].w2) Then
                           pivot.text = wf_in (la_where [lw].w2, pivot.text)
                           IF POS (pivot.text,'~r~n,')>0 THEN ll_move --
                        ELSE
                           pivot.text = wf_bracket (pivot.text)
                        END IF
                        la_where [lw].w3 += wf_move (pivot.text, ll_move, false) + ') '
                        where_syntax.ll  = pivot.ll
                        where_syntax.lm  = pivot.lm
                        IF where_syntax.ll>arg_ll_where THEN EXIT
                        lm_word   = rt_line (arg_where [where_syntax.ll], ra_word)  // 변경된 ll 반영
                        lb_0space = true
                     CASE '+', '-', '/', '||'
                        la_where [lw].w3 = RIGHTTRIM (la_where [lw].w3) + ' ' + ra_word [where_syntax.lm] + ' '
                        lb_0space        = true
                     CASE ELSE
                        IF f_null (la_where [lw].w3)  Then
                           la_where [lw].w3 = nf_1space (ra_word [where_syntax.lm])
                        ELSE
                           la_where [lw].w3 += nf_1space (ra_word [where_syntax.lm])
                        END IF
                  END CHOOSE
                  IF lb_between_exit THEN EXIT
               NEXT
               IF lb_between_exit THEN EXIT
               la_where [lw].w3 += '~r~n'
               where_syntax.lm  = 0
            NEXT
            IF where_syntax.ll>arg_ll_where  Then
               where_syntax.by    = TRUE
               where_syntax.UNION = FALSE
               lb_exit            = TRUE
               EXIT
            END IF
         CASE '=', '!=', '!~~', '<=', '>=', '<', '>', '<>', '<![cdata[<=]]>', '<![cdata[>=]]>', '<![cdata[<]]>', '<![cdata[>]]>', '<![cdata[<>]]>', &
              'in', 'not in', 'is null', 'is not null', 'like', 'not like', 'regexp_like', 'not regexp_like', 'exists', 'not exists'
				la_where [lw].w1 = RIGHTTRIM (la_where [lw].w1)
            IF nf_comp ({'exists','not exists','regexp_like','not regexp_like'}, ra_word [where_syntax.lm])  Then
               la_where [lw].w7 = 'change'
               la_where [lw].w1 = ra_word [where_syntax.lm]
               la_where [lw].w2 = ra_word [where_syntax.lm]
            ELSE
               IF nf_comp ({'in','not in','null','is not null','like','not like'}, ra_word [where_syntax.lm]) THEN la_where [lw].w7 = 'change'
               la_where [lw].w2 += ra_word [where_syntax.lm]
            END IF
            lw_col = 3
         CASE '('
            IF lw_col=1 Then
               IF f_nvl (la_where [lw].w1,'(') <> '(' AND lb_first THEN la_where [lw].w1 += '~r~n'
               la_where [lw].w1 += '('; ls_space = wf_bracket_space (la_where [lw].w1)
            ELSE
               IF f_nvl (la_where [lw].w3,'(') <> '(' AND lb_first THEN la_where [lw].w3 += '~r~n'
               la_where [lw].w3 += '('; ls_space = wf_bracket_space (la_where [lw].w3)
            END IF
            pivot = nf_bracket_pivot (arg_where, arg_ll_where, where_syntax.ll, where_syntax.lm)
            ll_move = LEN (ls_space)
            IF LEFT (pivot.text,8)='[SELECT-'	Then
               IF lw_col=1 Then
                  la_where [lw].w1 += ' '
               ELSE
                  la_where [lw].w3 += ' '
               END IF
               ll_move ++
	           	pivot.text += ' '
				Else
					IF nf_comp ({'IN','NOT IN'}, la_where [lw].w2)   Then
						pivot.text = wf_in (la_where [lw].w2, pivot.text)
					Else
						pivot.text = wf_bracket (pivot.text)
					END IF
            END IF
            IF lw_col=1 Then
               la_where [lw].w1 += wf_move (pivot.text, ll_move, false) + ') '
            ELSE
               la_where [lw].w3 += wf_move (pivot.text, ll_move, false) + ') '
            END IF
            where_syntax.ll = pivot.ll
            where_syntax.lm = pivot.lm
            IF where_syntax.ll>arg_ll_where THEN EXIT
            lm_word = rt_line (arg_where [where_syntax.ll], ra_word)  // 변경된 ll 반영
         CASE '+', '-', '*', '/', '^', '**', '||'
            IF where_syntax.lm>1 Then
               IF f_null (ra_word [where_syntax.lm - 1]) Then
                  IF lw_col=1 Then
                     la_where [lw].w1 = RIGHTTRIM (la_where [lw].w1) + ' ' + ra_word [where_syntax.lm] + ' '
                  ELSE
                     la_where [lw].w3 = RIGHTTRIM (la_where [lw].w3) + ' ' + ra_word [where_syntax.lm] + ' '
                  END IF
                  CONTINUE
               END IF
            END IF
            IF where_syntax.lm + 1 <= lm_word   Then
               IF lw_col=1 Then
                  IF f_null (ra_word [where_syntax.lm + 1]) Then
                     la_where [lw].w1 = RIGHTTRIM (la_where [lw].w1) + ' ' + ra_word [where_syntax.lm] + ' '
                  ELSE
                     la_where [lw].w1 += ra_word [where_syntax.lm]
                  END IF
               ELSE
                  IF f_null (ra_word [where_syntax.lm + 1]) Then
                     la_where [lw].w3 = RIGHTTRIM (la_where [lw].w3) + ' ' + ra_word [where_syntax.lm] + ' '
                  ELSE
                     la_where [lw].w3 += ra_word [where_syntax.lm]
                  END IF
               END IF
            ELSE
               IF lw_col=1 Then
                  la_where [lw].w1 += ra_word [where_syntax.lm]
               ELSE
                  la_where [lw].w3 += ra_word [where_syntax.lm]
               END IF
            END IF
         CASE 'not'
            IF lw_col=1 Then
               la_where [lw].w1 += upper (ra_word [where_syntax.lm]) + ' '
            ELSE
               la_where [lw].w3 += upper (ra_word [where_syntax.lm]) + ' '
            END IF
         CASE ELSE
            IF lw_col=1 Then
               la_where [lw].w1 += ra_word [where_syntax.lm]
            ELSE
               la_where [lw].w3 += ra_word [where_syntax.lm]
            END IF
      END CHOOSE
      IF where_syntax.lm>lm_word THEN EXIT
      IF f_notnull (ra_word [where_syntax.lm]) THEN lb_first = FALSE
   NEXT
   IF lb_exit THEN EXIT
   ls_temp = f_replace (la_where [lw].w1, '(+)', '') ; ls_temp = lower (ls_temp)
   IF POS (ls_temp,'~r~n')=0 And POS (ls_temp,' and ')=0 And POS (ls_temp,' or ')=0 Then
		// 사칙연산 중복 점검용
		ll_max_com = 0
		IF	POS (ls_temp,',')>0	Then
			ll_max_com ++
			IF	POS (ls_temp,',')<>LASTPOS (ls_temp,',') THEN ll_max_com ++
		End IF
		IF	POS (ls_temp,'+')>0	Then
			ll_max_com ++
			IF	POS (ls_temp,'+')<>LASTPOS (ls_temp,'+') THEN ll_max_com = ll_max_com + 2
		End IF
		IF	POS (ls_temp,'-')>0	Then
			ll_max_com ++
			IF	POS (ls_temp,'-')<>LASTPOS (ls_temp,'-') THEN ll_max_com = ll_max_com + 2
		End IF
		IF	POS (ls_temp,'*')>0	Then
			ll_max_com ++
			IF	POS (ls_temp,'*')<>LASTPOS (ls_temp,'*') THEN ll_max_com = ll_max_com + 2
		End IF
		IF	POS (ls_temp,'/')>0	Then
			ll_max_com ++
			IF	POS (ls_temp,'/')<>LASTPOS (ls_temp,'/') THEN ll_max_com = ll_max_com + 2
		End IF
		IF	ll_max_com<3 THEN lMax = MAX (lMax, LenA (nf_clear (la_where [lw].w1)))
   END IF
   IF lw_col=1 Then
      IF f_notnull (la_where [lw].w1) AND RIGHT (la_where [lw].w1,2)<>'~r~n' THEN la_where [lw].w1 = RIGHTTRIM (la_where [lw].w1) + '~r~n'
   ELSEIF lw_col=3   Then
      IF f_notnull (la_where [lw].w3) AND RIGHT (la_where [lw].w3,2)<>'~r~n' THEN la_where [lw].w3 = RIGHTTRIM (la_where [lw].w3) + '~r~n'
   END IF
   arg_lm = 1
NEXT

IF la_where [1].w5 <> 'START WITH'  Then
   lb_where_first = TRUE
   // 1 = 1
   FOR  lt = 1  TO  lw
      IF la_where [lt].w1='1' AND la_where [lt].w2='=' AND la_where [lt].w3='1'  Then
         where_syntax.text += ' WHERE 1 = 1 ' + IIF (f_null (la_where [lt].w6), '~r~n', wf_add_comment_num ('', la_where [lt].w6, 0, true))
         la_where [lt].w1  = ''
         lb_where_first    = false
         lb_1where         = true
         EXIT
      END IF
   NEXT

   IF f_notnull (ls_line_comment)   Then
      // where 절 주석처리는 맨 위로 올려 조정처리케 함
      IF NOT lb_1where THEN where_syntax.text += ' WHERE 1 = 1~r~n'
      lb_where_first = false
      IF f_notnull (where_syntax.text) AND RIGHT (where_syntax.text,2) <> '~r~n' THEN where_syntax.text += '~r~n'
      where_syntax.text += ls_line_comment
   END IF

   // 조회조건이 상수인 경우 우측으로
	FOR  lo = 1  TO  lw
		IF	(isNumber (la_where [lo].w1) OR LEFT (la_where [lo].w1,1)="'") And nf_comp ({'=','<','>','<=','>=','<![CDATA[=]]>','<![CDATA[<]]>','<![CDATA[>]]>','<![CDATA[<=]]>','<![CDATA[>=]]>'},la_where [lo].w2)	Then
			ls_temp = la_where [lo].w1
			la_where [lo].w1 = la_where [lo].w3
			la_where [lo].w3 = ls_temp
			CHOOSE CASE la_where [lo].w2
				CASE '<'
					la_where [lo].w2 = '>'
				CASE '>'
					la_where [lo].w2 = '<'
				CASE '<='
					la_where [lo].w2 = '>='
				CASE '>='
					la_where [lo].w2 = '<='
				CASE '<![CDATA[<]]>'
					la_where [lo].w2 = '<![CDATA[>]]>'
				CASE '<![CDATA[>]]>'
					la_where [lo].w2 = '<![CDATA[<]]>'
				CASE '<![CDATA[<=]]>'
					la_where [lo].w2 = '<![CDATA[>=]]>'
				CASE '<![CDATA[>=]]>'
					la_where [lo].w2 = '<![CDATA[<=]]>'
			END CHOOSE
		End IF
	NEXT

   // FROM순 정렬전 작업
   FOR  lt = ll_alias  TO  1  STEP -1
      FOR  lo = 1  TO  lw
         IF POS (lower (la_where [lo].w1),lower (arg_alias [lt] + '.corp_gr'))>0 OR POS (lower (la_where [lo].w3),lower (arg_alias [lt] + '.corp_gr'))>0  Then
            arg_add_where.CORP_GR [lt] = false
         ELSE
            IF ll_alias=1  Then
               IF POS (lower (la_where [lo].w1),'corp_gr')>0 OR POS (lower (la_where [lo].w3),'corp_gr')>0 THEN arg_add_where.CORP_GR [lt] = false
            END IF
         END IF
         IF la_where [lo].w7='change' THEN CONTINUE
         IF f_null (la_where [lo].w3) OR POS (la_where [lo].w3,'.')=0 OR POS (la_where [lo].w3,'.') <> LASTPOS (la_where [lo].w3,'.') OR &
            (POS (lower (la_where [lo].w1), lower (arg_alias [lt]) + '.')>0 AND POS (lower (la_where [lo].w3), lower (arg_alias [lt]) + '.')>0)   Then
            la_where [lo].w7 = 'change'
            CONTINUE
         END IF
         IF POS (lower (la_where [lo].w1), lower (arg_alias [lt]) + '.')>0  Then
            FOR  lx = 1  TO  lt - 1
               IF POS (lower (la_where [lo].w3), lower (arg_alias [lx]) + '.')>0  Then
                  la_where [lo].w7 = 'change'
                  EXIT
               END IF
            NEXT
         END IF
         IF la_where [lo].w7='change' THEN CONTINUE
         IF POS (lower (la_where [lo].w3), lower (arg_alias [lt]) + '.')>0 AND &
            NOT (f_null (la_where [lo].w1) OR POS (la_where [lo].w1,'.')=0 OR POS (la_where [lo].w1,'.') <> LASTPOS (la_where [lo].w1,'.')) Then
               CHOOSE CASE la_where [lo].w2
                  CASE '<'
                     la_where [lo].w2 = '>'
                  CASE '>'
                     la_where [lo].w2 = '<'
                  CASE '<='
                     la_where [lo].w2 = '>='
                  CASE '>='
                     la_where [lo].w2 = '<='
                  CASE '<![CDATA[<]]>'
                     la_where [lo].w2 = '<![CDATA[>]]>'
                  CASE '<![CDATA[>]]>'
                     la_where [lo].w2 = '<![CDATA[<]]>'
                  CASE '<![CDATA[<=]]>'
                     la_where [lo].w2 = '<![CDATA[>=]]>'
                  CASE '<![CDATA[>=]]>'
                     la_where [lo].w2 = '<![CDATA[<=]]>'
               END CHOOSE
               la_where [lo].w7 = la_where [lo].w3
               la_where [lo].w3 = la_where [lo].w1
               la_where [lo].w1 = la_where [lo].w7
               la_where [lo].w7 = 'change'
         END IF
      NEXT
   NEXT

   // FROM 테이블순 SORT
   FOR  lt = 1  TO  ll_alias
      FOR  lo = 1  TO  UPPERBOUND (ia_order)
         FOR  lx = 1  TO  lw
            IF f_null (la_where [lx].w1) THEN CONTINUE
            IF POS (lower (la_where [lx].w1), lower (arg_alias [lt] + '.' + ia_order [lo]))>0 Then
					where_syntax.text += wf_dml_where_line (lMax, la_where [lx].w1, la_where [lx].w2, la_where [lx].w3, la_where [lx].w4, la_where [lx].w5, la_where [lx].w6, lb_where_first)
					la_where [lx].w1  = ''  // 출력완료
					lb_where_first    = FALSE
            END IF
         NEXT
      NEXT

      // 상수조건 맨위로
      FOR  lx = 1  TO  lw
         IF f_null (la_where [lx].w1) THEN CONTINUE
         IF POS (lower (la_where [lx].w1), lower (arg_alias [lt]) + '.')>0 AND (f_null (la_where [lx].w3) OR POS (la_where [lx].w3,'.')=0 OR isNumber (la_where [lx].w3) OR LEFT (la_where [lx].w3,1)="'") Then
				where_syntax.text += wf_dml_where_line (lMax, la_where [lx].w1, la_where [lx].w2, la_where [lx].w3, la_where [lx].w4, la_where [lx].w5, la_where [lx].w6, lb_where_first)
				la_where [lx].w1  = ''  // 출력완료
				lb_where_first    = FALSE
         END IF
      NEXT

      FOR  lx = 1  TO  lw
         IF f_null (la_where [lx].w1) THEN CONTINUE
         lb_sort = (POS (lower (la_where [lx].w1), lower (arg_alias [lt]) + '.') > 0)
         IF NOT lb_sort Then
            IF POS ('exists,not exists,between',lower (la_where [lx].w2))>0   Then
               lb_sort = (POS (lower (la_where [lx].w3), lower (arg_alias [lt]) + '.') > 0)
            ELSE
               lb_sort = (POS (la_where [lx].w1, '.')=0 AND POS (lower (la_where [lx].w3), lower (arg_alias [lt]) + '.') > 0)
            END IF
         END IF
         IF lb_sort  Then
				where_syntax.text += wf_dml_where_line (lMax, la_where [lx].w1, la_where [lx].w2, la_where [lx].w3, la_where [lx].w4, la_where [lx].w5, la_where [lx].w6, lb_where_first)
				la_where [lx].w1  = ''  // 출력완료
				lb_where_first    = FALSE
         END IF
      NEXT
   NEXT

   FOR  lt = 1  TO  lw
      IF f_null (la_where [lt].w1) THEN CONTINUE
		where_syntax.text += wf_dml_where_line (lMax, la_where [lt].w1, la_where [lt].w2, la_where [lt].w3, la_where [lt].w4, la_where [lt].w5, la_where [lt].w6, lb_where_first)
		la_where [lt].w1  = ''  // 출력완료
		lb_where_first    = FALSE
   NEXT

   // 조건에 반드시 포함되어야 할 컬럼
   FOR  lt = 1  TO  ll_alias
      IF arg_add_where.CORP_GR [lt] Then
         IF lb_where_first Then
            where_syntax.text += " WHERE " + arg_alias [lt] + ".CORP_GR = '' " + IIF (f_null (la_where [lt].w6), '~r~n', wf_add_comment_num ('', la_where [lt].w6, 0, true))
            lb_where_first    = false
         ELSE
            where_syntax.text += "   AND " + arg_alias [lt] + ".CORP_GR = '' " + IIF (f_null (la_where [lt].w6), '~r~n', wf_add_comment_num ('', la_where [lt].w6, 0, true))
         END IF
      END IF
   NEXT
ELSE
   ls_with_space = ''
   FOR  lt = 2  TO  lw
      ls_with_space = SPACE (MAX (LenA (nf_clear (la_where [lt].w5 + ' ' + la_where [lt].w1)), LenA (ls_with_space)))
   NEXT
   FOR  lt = 2  TO  lw
      where_syntax.text += la_where [lt].w5 + ' ' + la_where [lt].w1 + SPACE (LenA (ls_with_space) - LenA (nf_clear (la_where [lt].w5 + la_where [lt].w1))) + la_where [lt].w2 + ' ' + la_where [lt].w3 + '~r~n'
   NEXT
END IF
IF f_notnull (ls_using) THEN where_syntax.text += ls_using
IF f_notnull (ls_with)  THEN where_syntax.text += ls_with

IF f_notnull (ls_for_lock)  THEN where_syntax.text += ls_for_lock + '~r~n'

RETURN   where_syntax
end function

public function string wf_in (string arg_line, string arg_in);BOOLEAN	lb_in, lb_first, lb_0space, lb_1space, lb_proc, lb_dml
STRING	ls_return = '', ls_temp, ls_in, ls_line
STRING	la_in [], la_line [], ra_word [], la_comment []

LONG	ll, lm, lm_word, ll_line = 1, ll_in_line, ll_max, in_bracket

IF	POS (arg_in,'[SELECT-')>0 THEN RETURN arg_in
lm_word = rt_line (nf_clear_sqm (arg_in, true), ra_word)
FOR  lm = 1  TO  lm_word
	IF	f_null (ra_word [lm]) THEN CONTINUE
	ls_temp = lower (ra_word [lm])
	CHOOSE CASE ls_temp
		CASE 'select'
			RETURN arg_in
		CASE 'sum','exp','avg','min','max','lag','case','keep','rank','lead','count','least','decode','listagg','greatest', &
			  'row_number','dense_rank','first_value','last_value','percent_rank','ratio_to_report'
			RETURN arg_in
		CASE 'trunc','round','date','nvl','coalesce','instr','substr','like','instrb','substrb'
			lb_in = true
			EXIT
	END CHOOSE
NEXT

IF	POS (arg_line,'~r~n')>0	Then
	ls_line = lower (MID (arg_line, LASTPOS (arg_line,'~r~n') + 2)) + ' '
Else
	ls_line = lower (arg_line) + ' '
End IF

ls_in = arg_in
ls_temp = lower (nf_clear_sqm (ls_in, true))
IF	POS (ls_temp,'(')>0 OR POS (ls_temp,'and ')>0 OR POS (ls_temp,'or ')>0	Then
	lb_1space = true
End IF

IF POS (ls_line,'sr_')>0 OR POS (ls_line,'f_')>0 OR POS (ls_line,'varray')>0 OR POS (ls_line,'_rec')>0 OR POS (ls_line,'_error')>0	Then
	lb_proc = true
ElseIF nf_comp ({'add_'},LEFT (ls_temp,4))	Then
	RETURN	arg_in
End IF

la_line [ll_line] = ''
la_comment [ll_line] = ''

IF nf_comp ({'in','in (','not in','not in ('}, TRIM (ls_line)) OR POS (ls_line,' in ')>0 OR POS (ls_line,' not in ')>0	Then
	ls_temp = nf_clear_sqm (ls_in, true)
	ls_temp = f_replace (ls_temp, "__", '')
	ls_temp = f_replace (ls_temp, "'", '')
	ls_temp = f_replace (ls_temp, ",", '')
	ls_temp = f_replace (ls_temp, "~r~n", '')
	IF	f_null (ls_temp) THEN lb_in = true
ElseIF POS (ls_line,'trunc')>0 OR POS (ls_line,'round')>0 OR POS (ls_line,'date')>0 OR POS (ls_line,'nvl')>0 OR POS (ls_line,'coalesce')>0 &
	                            OR POS (ls_line,'instr')>0 OR POS (ls_line,'substr')>0 OR POS (ls_line,'like')>0 &
	                            OR POS (ls_line,'instrb')>0 OR POS (ls_line,'substrb')>0	Then
	lb_in = true
End IF

ls_temp = nf_clear (ls_in)
ll_in_line = f_get_array (TRIM (ls_temp), '~r~n', la_in)

// ( )안에 연산에 의한 위치조정이 필요한 경우 20250722
IF	lb_proc	Then
	FOR  ll = 1  TO  ll_in_line
		lm_word = rt_line (la_in [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	f_null (ra_word [lm]) THEN CONTINUE
			CHOOSE CASE lower (ra_word [lm])
				CASE '+','-','*','/','^','**','||'
					lb_dml = true
			END CHOOSE
			EXIT
		NEXT
		IF	lb_dml THEN EXIT
	NEXT
End IF

IF	lb_dml	Then
	la_line [ll_line] = wf_dml (ls_temp, '')
Else
	ll_in_line = f_get_array (TRIM (ls_temp), '~r~n', la_in)
	FOR  ll = 1  TO  ll_in_line
		IF	f_null (la_in [ll]) THEN CONTINUE
		lm_word = rt_line (la_in [ll], ra_word)
		lb_first = true ; lb_0space = true
		FOR  lm = 1  TO  lm_word
			IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
			lb_0space = false
			IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
				ls_temp = MID (ra_word [lm],3)
				ls_temp = f_replace (ls_temp, '*/', '')
				IF	f_null (la_comment [ll_line])	Then
					la_comment [ll_line] = TRIM (ls_temp)
				Else
					la_comment [ll_line] += '|' + ls_temp
				End IF
				CONTINUE
			End IF
			CHOOSE CASE lower (ra_word [lm])
				CASE 'case'
					FOR  ll = ll  TO  ll_in_line
						lm_word = rt_line (la_in [ll], ra_word)
						FOR  lm = lm  TO  lm_word
							la_line [ll_line] += ra_word [lm]
							CHOOSE CASE lower (ra_word [lm])
								CASE 'case'
									in_bracket ++
								CASE 'end'
									in_bracket --
									IF	in_bracket=0 THEN EXIT
							END CHOOSE
						NEXT
						IF	in_bracket=0 THEN EXIT
						la_line [ll_line] += '~r~n'
						lm = 1
					NEXT
					CONTINUE
				CASE ','
					IF	lb_first	Then
						la_line [ll_line] += ','
						ll_line ++ ; la_line [ll_line] = ''
						la_comment [ll_line] = ''
					Else
						IF	lb_proc=false And lb_in	Then
							la_line [ll_line] += ','
						Else
							la_line [ll_line] += ', '
						End IF
					End IF
					lb_0space = true
				CASE '+','-','*','/','^','**','||'
					IF	lb_first	Then
						FOR  lm = lm  TO  lm_word
							la_line [ll_line] += ra_word [lm]
						NEXT
						EXIT
					Else
						IF	lm<lm_word	Then
							la_line [ll_line] = RIGHTTRIM (la_line [ll_line]) + ' ' + ra_word [lm] + ' '
							lb_0space = TRUE
						Else
							la_line [ll_line] = RIGHTTRIM (la_line [ll_line]) + ra_word [lm]
						End IF
					End IF
				CASE ELSE
					IF	nf_comp ({'+','-','*','/'}, LEFT (ra_word [lm],1)) And f_notnull (la_line [ll_line])	Then
						la_line [ll_line] = RIGHTTRIM (la_line [ll_line]) + ' ' + ra_word [lm]
					Else
						IF	lb_in OR lb_1space	Then
							la_line [ll_line] += nf_1space (ra_word [lm])
						Else
							la_line [ll_line] += ra_word [lm]
						End IF
					End IF
			END CHOOSE
			lb_first = false
		NEXT
		ll_line ++
		la_line [ll_line] = ''
		la_comment [ll_line] = ''
	NEXT
	FOR  ll = ll_line TO  1  STEP -1
		IF	f_notnull (la_line [ll]) THEN EXIT
		ll_line --
	NEXT
	FOR  ll = 1  TO  ll_line
		IF	f_notnull (la_comment [ll])	Then
			ls_temp = wf_bracket_space (RIGHTTRIM (la_line [ll]))
			ll_max = MAX (ll_max, LenA (ls_temp))
		End IF
	NEXT
End IF

lb_first = TRUE
FOR  ll = 1  TO  ll_line
	IF	f_notnull (la_comment [ll])	Then
		IF	f_null (la_line [ll])	Then
			ls_return += SPACE (ll_max) + '  /* ' + la_comment [ll] + ' */'
		Else
			la_line [ll] = RIGHTTRIM (la_line [ll])
			ls_temp = wf_bracket_space (la_line [ll])
			ls_return += la_line [ll] + SPACE (ll_max - LEN (ls_temp))
			IF	lb_first THEN ls_return += ' '
			ls_return += ' /* ' + la_comment [ll] + ' */'
		End IF
	Else
		IF	TRIM (la_line [ll])=',' And RIGHT (ls_return,2)='~r~n'	Then
			ls_return = RIGHTTRIM (LEFT (ls_return, LEN (ls_return) - 2))
			IF	RIGHT (ls_return,1)='&'	Then
				ls_return = RIGHTTRIM (LEFT (ls_return, LEN (ls_return) - 1))
				ls_return += ', &~r~n'
			Else
				ls_return += ',~r~n'
			End IF
		Else
			ls_return += RIGHTTRIM (la_line [ll])
		End IF
	End IF
	IF	f_notnull (ls_return) And RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
	lb_first = false
NEXT

RETURN	LEFT (ls_return, LEN (ls_return) - 2)
end function

public function string wf_dml_update_set (ref long arg_ll, ref long arg_lm, string arg_line[], string arg_end[]);// 컬럼크기 조정

S_RET	pivot

BOOLEAN	lb_first, lb_0space, lb_exit = FALSE

LONG	ll, lm, lm_word, lt, ll_end, in_bracket
LONG	ll_set = 1, ll_col = 1, ll_space, lSet1 = 0, lSet2 = 0

// 3-comment, 4-xml
STRING	la_set1 [], la_set2 [], la_set3 [], la_set4 [], ra_word [], ls_return = ''
STRING	ls_text, ls_eq, ls_start, ls_end, ls_space, ls_temp

arg_end [UPPERBOUND (arg_end) + 1] = ';'
la_set1 [1] = ''
la_set2 [1] = ''
la_set3 [1] = ''
la_set4 [1] = ''

lm = arg_lm + 1
ll_end = UPPERBOUND (arg_line)
FOR  ll = arg_ll  TO  ll_end
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_line [ll]),2)) Then
		IF f_notnull (la_set4 [ll_set]) And RIGHT (la_set4 [ll_set],2)<>'~r~n' THEN la_set4 [ll_set] += '~r~n'
		la_set4 [ll_set] += wf_line_comment (arg_line, ll_end, ll, false)
		CONTINUE
	End IF
	lm_word = rt_line (arg_line [ll], ra_word)
	lb_first = TRUE ; lb_0space = false
	FOR  lm = lm  TO  lm_word
		IF	ra_word [lm]='' OR ((lb_first OR lb_0space) And f_null (ra_word [lm])) THEN CONTINUE
		lb_0space = false
		IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
			la_set3 [ll_set] = nf_add_comment (la_set3 [ll_set], ra_word [lm])
			CONTINUE
		End IF
		CHOOSE CASE UPPER (ra_word [lm])
			CASE 'CASE','DECODE'
				ls_text = ra_word [lm]
				IF	lower (ra_word [lm])='case'	Then
					in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  ll_end
					IF	f_null (arg_line [ll]) THEN CONTINUE
					lm_word = rt_line (arg_line [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						ls_text += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								in_bracket ++
							CASE ls_end
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_bracket=0 THEN EXIT
					ls_text += '~r~n'
					lm = 0
				NEXT
				IF	ll_col=1	Then
					la_set1 [ll_set] = RIGHTTRIM (la_set1 [ll_set]) + IIF (f_null (la_set1 [ll_set]),'',' ')
					ls_space = wf_bracket_space (la_set1 [ll_set])
				Else
					la_set2 [ll_set] = RIGHTTRIM (la_set2 [ll_set]) + IIF (f_null (la_set2 [ll_set]),'',' ')
					ls_space = wf_bracket_space (la_set2 [ll_set])
				End IF
				IF	ls_start='case'	Then
					ls_temp = wf_case (ls_text)
				Else
					ls_temp = nf_decode (ls_text)
				End IF
				IF	ll_col=1	Then
					la_set1 [ll_set] += wf_move (ls_temp, LEN (ls_space), false)
				Else
					la_set2 [ll_set] += wf_move (ls_temp, LEN (ls_space), false)
				End IF
				IF	ll>ll_end THEN EXIT
				lb_first = false
				CONTINUE
			CASE '('
				IF PosA (arg_line [ll],'SET ')>0	Then
					ll_space = PosA (arg_line [ll],'(', PosA (arg_line [ll],'=')) - PosA (arg_line [ll],'SET ') + 8
				Else
					ll_space = PosA (arg_line [ll],'(', PosA (arg_line [ll],'='))
				End IF
				IF	ll_col=1	Then
					la_set1 [ll_set] += '('
				Else
					la_set2 [ll_set] += '('
				End IF
				pivot = nf_bracket_pivot (arg_line, ll_end, ll, lm)
				IF	ll_col=1	Then
					ls_temp  = wf_in (la_set1 [ll_set], pivot.text)
					ls_space = wf_bracket_space (la_set1 [ll_set])
					la_set1 [ll_set] += wf_move (ls_temp, LEN (ls_space), false) + ')'
				Else
					IF	LEFT (pivot.text,8)='[SELECT-'	Then
						la_set2 [ll_set] += ' '
						ls_temp = pivot.text
					Else
						ls_temp = wf_in (la_set2 [ll_set], pivot.text)
					End IF
					ls_space = wf_bracket_space (la_set2 [ll_set])
					la_set2 [ll_set] += wf_move (ls_temp, LEN (ls_space), false) + ')'
				End IF
				ll = pivot.ll ; lm = pivot.lm
				IF	ll>ll_end THEN EXIT
				lm_word = rt_line (arg_line [ll], ra_word)	// 변경된 ll 반영
			CASE '='
				ll_col = 2
				lb_first = true
				CONTINUE
			CASE ','
				ll_set ++ ; ll_col = 1
				la_set1 [ll_set] = ''
				la_set2 [ll_set] = ''
				la_set3 [ll_set] = ''
				la_set4 [ll_set] = ''
			CASE '+','-','/','||'
				IF	lb_first	Then
					IF ll_col=1 Then
						la_set1 [ll_set] += '[SPACE^]' + ra_word [lm] + ' '
					ELSE
						la_set2 [ll_set] += '[SPACE^]' + ra_word [lm] + ' '
					END IF
				Else
					IF ll_col=1 Then
						la_set1 [ll_set] = RIGHTTRIM (la_set1 [ll_set]) + ' ' + ra_word [lm] + ' '
					ELSE
						la_set2 [ll_set] = RIGHTTRIM (la_set2 [ll_set]) + ' ' + ra_word [lm] + ' '
					END IF
				End IF
				lb_0space = true
				lb_first = false
				CONTINUE
			CASE ELSE
				FOR  lt = 1  TO  UPPERBOUND (arg_end)
					IF	lower (ra_word [lm])=lower (arg_end [lt])	Then
						arg_ll = ll ; ll_end = ll
						arg_lm = lm
						lb_exit = true
						EXIT
					End IF
				NEXT
				IF	lb_exit THEN EXIT
				IF	ll_col=1	Then
					la_set1 [ll_set] += ra_word [lm]
					IF	POS (la_set1 [ll_set],'~r~n')=0 THEN la_set1 [ll_set] = TRIM (la_set1 [ll_set])
				Else
					la_set2 [ll_set] += ra_word [lm]
					IF	POS (la_set2 [ll_set],'~r~n')=0 THEN la_set2 [ll_set] = TRIM (la_set2 [ll_set])
				End IF
		END CHOOSE
		IF	f_notnull (ra_word [lm]) THEN lb_first = FALSE
	NEXT
	IF	lb_exit THEN EXIT
	IF	ll_col=1	Then
		la_set1 [ll_set] += '~r~n'
	Else
		la_set2 [ll_set] += '~r~n'
	End IF
	lm = 1
NEXT
IF	NOT lb_exit And ll>arg_ll THEN arg_ll = ll

FOR  lm = 1  TO  ll_set
	ls_temp = RIGHTTRIM (la_set1 [lm])
	IF	POS (ls_temp,'~r~n')>0 THEN ls_temp = MID (ls_temp, LASTPOS (ls_Temp,'~r~n') + 2)
	lSet1 = MAX (lSet1, LenA (ls_temp) + 1)

	ls_temp = TRIM (la_set2 [lm])
	IF	POS (ls_temp,'~r~n')>0 THEN ls_temp = MID (ls_temp, LASTPOS (ls_Temp,'~r~n') + 2)
	lSet2 = MAX (lSet2, LenA (ls_temp))

	la_set3 [lm] = TRIM (la_set3 [lm])
NEXT

FOR  lm = 1  TO  ll_set
	ls_return += IIF (lm=1,'','~r~n, ')
	IF	f_notnull (la_set4 [lm]) THEN ls_return += la_set4 [lm] + '~r~n'

	ls_space = wf_bracket_space (nf_clear (ls_return))

	IF	RIGHT (la_set1 [lm],2)='~r~n'	Then
		la_set1 [lm] = LEFT (la_set1 [lm], LEN (la_set1 [lm]) - 2)
		ls_eq = '~r~n     = '
	Else
		ls_eq = '= '
	End IF
	ls_temp = la_set1 [lm]
	IF	LEFT (ls_temp,1)='(' THEN ls_temp = wf_in (ls_return, ls_temp)
	ls_return += wf_move (ls_temp, LEN (ls_space), false)

	IF	POS (ls_temp,'~r~n')>0 THEN ls_temp = MID (ls_temp, LASTPOS (ls_Temp,'~r~n') + 2)
	ls_return += SPACE (lSet1 - LenA (ls_temp)) + ls_eq

	IF	lm=1 And LEFT (ls_eq,1)='='	Then
		ls_space = wf_bracket_space (nf_clear (ls_return)) + '  '	// 첫줄 ", " 위치추가
	Else
		ls_space = wf_bracket_space (nf_clear (ls_return))
	End IF

	ls_temp = la_set2 [lm]
	IF	POS (ls_temp,'[SPACE')>0	Then
		ls_temp = wf_dml (ls_temp, '')
	Else
		IF	LEFT (ls_temp,1)='(' And LEFT (ls_temp,7)<>'(SELECT' THEN ls_temp = wf_in (ls_return, ls_temp)
	End IF
	ls_return += wf_move (ls_temp, LEN (ls_space), false)

	IF	f_notnull (la_set3 [lm])	Then
		ls_temp = nf_clear (ls_temp)
		IF	POS (ls_temp,'~r~n')>0 THEN ls_temp = MID (ls_temp, LASTPOS (ls_Temp,'~r~n') + 2)
		ls_return = wf_add_comment_num (ls_return, la_set3 [lm], 0, true)
	End IF
NEXT

IF	POS (ls_return,'[SPACE')>0 THEN ls_return = wf_dml (ls_return + '~r~n[SPACEASCLEAR-' + string (gl_select_step) + ']', '')

RETURN ls_return
end function

public function string wf_case (string arg_case);S_RET pivot

LONG  ll, lm, lm_word, ll_case, in_bracket, ll_bracket, ll_bracket_then, ll_before

BOOLEAN  lb_then, lm_first, lb_0space, lb_exit, lb_bracket, lb_spaceasclear, then_first

STRING   la_case [], la_bracket [], ra_word []
STRING   ls_return = '', ls_line = '', ls_case = '', ls_spaceasclear = ''
STRING   ls_space, ls_temp, ls_comment, ls_dml

ll_case = f_get_array (arg_case, '~r~n', la_case)
FOR  ll = ll_case  TO  1  STEP -1
   IF f_null (la_case [ll])   Then
      ll_case --
      CONTINUE
   END IF
   EXIT
NEXT
FOR  ll = 1  TO  ll_case
   IF f_null (la_case [ll]) THEN CONTINUE
   lm_word = rt_line (la_case [ll], ra_word)
   lm_first = TRUE; lb_0space = FALSE
   FOR  lm = 1  TO  lm_word
      IF (lm_first OR lb_0space) AND f_null (ra_word [lm]) THEN CONTINUE
      lb_0space = FALSE
      IF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))   Then
         ls_comment = nf_add_comment (ls_comment, ra_word [lm])
			ls_spaceasclear = '[SPACEASCLEARCASE-' + STRING (gl_select_step) + ']~r~n'
         CONTINUE
      END IF
      CHOOSE CASE lower (ra_word [lm])
         CASE 'case'
            gl_select_step ++
            ls_case = '[CASECASE-' + STRING (gl_select_step) + ']'
            ls_line += ls_case + 'CASE '
            lb_then   = false ; then_first = false
            lb_0space = true
         CASE 'when'
            ls_case = '[CASEWHEN-' + STRING (gl_select_step) + ']'
            IF lm_first And f_notnull (ls_comment)  Then
               IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN(ls_return) - 2)
               ls_return = wf_add_comment_num (ls_return, ls_comment, 0, true) + '~r~n'
               ls_comment = ''
					IF lb_spaceasclear Then
						lb_spaceasclear = false
						IF	RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
						ls_return += ls_spaceasclear
						ls_spaceasclear = ''
					END IF	
            END IF
            lb_spaceasclear = false
            IF NOT lm_first AND RIGHT (ls_line,1) <> ' '  THEN ls_line += ' '
				IF	then_first And RIGHT (ls_return,2)<>'~r~n' THEN ls_line += '~r~n'
            ls_line += IIF (lm_first, ls_case, '') + 'When '
            lb_then   = false
            lb_0space = true
         CASE 'then'
            ls_case = '[CASETHEN-' + STRING (gl_select_step) + ']'
            IF lm_first And f_notnull (ls_comment)  Then
               IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN(ls_return) - 2)
               ls_return = wf_add_comment_num (ls_return, ls_comment, 0, true) + '~r~n'
               ls_comment = ''
					IF lb_spaceasclear Then
						lb_spaceasclear = false
						IF	RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
						ls_return += ls_spaceasclear
						ls_spaceasclear = ''
					END IF	
            END IF
            IF NOT lm_first AND RIGHT (ls_line,1) <> ' ' THEN ls_line += ' '
            ls_line += ls_case + 'THEN '
				then_first = lm_first ; lm_first  = false
            lb_then   = true
            lb_0space = true
            CONTINUE
         CASE 'else'
            ls_case = '[CASEELSE-' + STRING (gl_select_step) + ']'
            IF lm_first And f_notnull (ls_comment)  Then
               IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN(ls_return) - 2)
               ls_return = wf_add_comment_num (ls_return, ls_comment, 0, true) + '~r~n'
               ls_comment = ''
					IF lb_spaceasclear Then
						lb_spaceasclear = false
						IF	RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
						ls_return += ls_spaceasclear
						ls_spaceasclear = ''
					END IF	
            END IF
            IF NOT lm_first AND RIGHT (ls_line,1) <> ' '  THEN ls_line += ' '
				IF	then_first And RIGHT (ls_return,2)<>'~r~n' THEN ls_line += '~r~n'
            ls_line += ls_case + 'ELSE '
            lb_0space = true
         CASE 'end', 'end case'
            ls_case = '[CASEEND -' + STRING (gl_select_step) + ']'
            IF lm_first And f_notnull (ls_comment)  Then
               IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN(ls_return) - 2)
               ls_return = wf_add_comment_num (ls_return, ls_comment, 0, true) + '~r~n'
               ls_comment = ''
					IF lb_spaceasclear Then
						lb_spaceasclear = false
						IF	RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
						ls_return += ls_spaceasclear
						ls_spaceasclear = ''
					END IF	
            END IF
            IF NOT lm_first THEN ls_line = RIGHTTRIM (ls_line) + ' '
            ls_line += ls_case + upper (ra_word [lm])
				lb_spaceasclear = true
            gl_select_step --
         CASE 'open'
            ls_return += ls_line
            ls_line   = ''
            ls_space  = wf_bracket_space (ls_return)
            ls_space  = SPACE (4 * TRUNCATE (LenA (ls_space) / 4 + .9, 0))

            IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
            ls_return = RIGHTTRIM (ls_return) + ls_space

            lb_exit = FALSE
            FOR  ll = ll  TO  ll_case
               IF f_null (la_case [ll]) THEN CONTINUE
               lm_word = rt_line (la_case [ll], ra_word)
               IF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))   Then
                  IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
                  ls_return += wf_line_comment (la_case, ll_case, ll, false)
						ls_spaceasclear = '[SPACEASCLEARCASE-' + STRING (gl_select_step) + ']~r~n'
                  CONTINUE
               END IF
               FOR  lm = lm  TO  lm_word
                  IF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))   Then
                     ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							ls_spaceasclear = '[SPACEASCLEARCASE-' + STRING (gl_select_step) + ']~r~n'
                     CONTINUE
                  END IF
                  CHOOSE CASE lower (ra_word [lm])
                     CASE 'with'
                        ls_space += '    '
                        ls_dml   = ''
                        lb_exit  = FALSE
                        FOR  ll = ll  TO  ll_case
                           lm_word = rt_line (la_case [ll], ra_word)
                           FOR  lm = lm  TO  lm_word
                              IF ra_word [lm]=';'  Then
                                 lb_exit = true
                                 EXIT
                              END IF
                              ls_dml += ra_word [lm]
                           NEXT
                           IF lb_exit THEN EXIT
                           ls_dml += '~r~n'
                           lm     = 1
                        NEXT
                        ls_dml    = wf_with (ls_dml)
                        ls_return = RIGHTTRIM (ls_return) + ls_space + wf_move (ls_dml, LEN (ls_space), false)
                        FOR  lm = lm  TO  lm_word
                           ls_return += ra_word [lm]
                        NEXT
                        EXIT
                     CASE 'select'
                        ls_space += '    '
                        IF f_notnull (ls_comment)  Then
                           ls_return  = wf_add_comment_num (ls_return, ls_comment, 0, false) + '~r~n'
                           ls_comment = ''
                        END IF
                        IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
                        ls_dml = ''
                        FOR  ll = ll  TO  ll_case
                           lm_word = rt_line (la_case [ll], ra_word)
                           FOR  lm = lm  TO  lm_word
                              IF ra_word [lm]=';'  Then
                                 lb_exit = TRUE
                                 EXIT
                              END IF
                              ls_dml += ra_word [lm]
                           NEXT
                           IF lb_exit THEN EXIT
                           IF f_notnull (ls_dml) THEN ls_dml += '~r~n'
                           lm = 1
                        NEXT
                        ls_dml = wf_dml_select (ls_dml)
                        gl_select ++
                        ga_select [gl_select] = ls_dml
                        ls_return += ls_space + '[SELECT-' + STRING (gl_select) + ']'
                        EXIT
                     CASE ';'
                        FOR  lm = lm  TO  lm_word
                           ls_return += ra_word [lm]
                        NEXT
                        lb_exit = true
                        EXIT
                     CASE ELSE
                        ls_return += nf_1space (UPPER (ra_word [lm]))
                  END CHOOSE
               NEXT
               IF lb_exit THEN EXIT
               lm = 1
               ls_return += '~r~n'
            NEXT
            IF ll>ll_case THEN EXIT
         CASE 'decode'
            in_bracket = 0 ; ls_temp = ''
            FOR  ll = ll  TO  ll_case
               lm_word = rt_line (la_case [ll], ra_word)
               FOR  lm = lm  TO  lm_word
                  ls_temp += ra_word [lm]
                  CHOOSE CASE ra_word [lm]
                     CASE '('
                        in_bracket ++
                     CASE ')'
                        in_bracket --
                        IF in_bracket=0 THEN EXIT
                  END CHOOSE
               NEXT
               IF in_bracket=0 THEN EXIT
               ls_temp += '~r~n'
               lm      = 1
            NEXT
            ls_line   = RIGHTTRIM (ls_line) + ' ' + nf_decode (ls_temp) + ' '
            lb_0space = true
            IF ll>ll_case THEN EXIT
         CASE '('
            pivot = nf_bracket_pivot (la_case, ll_case, ll, lm)
            ls_temp = wf_bracket (pivot.text)
            IF POS (ls_line,' IN ')>0 THEN ls_temp = wf_in (ls_line, ls_temp)
            IF POS (ls_temp,'[SELECT-')>0  Then
               ls_line += '( ' + ls_temp + ')'
            ElseIF POS (ls_temp,'~r~n')=0	Then
               ls_line += '(' + ls_temp + ')'
            ELSE
               ll_bracket ++
               la_bracket [ll_bracket] = ls_temp
               ls_line                 += '([BRACKET-' + STRING (ll_bracket) + '])'
            END IF
            ll = pivot.ll
            lm = pivot.lm
            IF ll>ll_case THEN EXIT
            lm_word = rt_line (la_case [ll], ra_word) // 변경된 ll 반영
         CASE '='
            IF RIGHT (ls_line,1)=' ' AND NOT lm_first Then
               ls_line   = RIGHTTRIM (ls_line) + '='
               lb_0space = TRUE
            ELSE
               ls_line += ra_word [lm]
            END IF
         CASE '+', '-', '*', '/', '^', '||', '**', '!=', '!~~', '<>', '<', '>', '<=', '>=', '<![cdata[<=]]>', '<![cdata[>=]]>', '<![cdata[<]]>', '<![cdata[>]]>', '<![cdata[<>]]>'
            IF NOT lm_first THEN ls_line = RIGHTTRIM (ls_line) + ' '
            ls_line   += ra_word [lm] + ' '
            lb_0space = TRUE
         CASE 'between', 'and', 'or', 'to', 'in', 'not in', 'not between', 'exists', 'not exists'
            IF NOT lm_first THEN ls_line = RIGHTTRIM (ls_line) + ' '
            CHOOSE CASE lower (ra_word [lm])
               CASE 'or'
                  ra_word [lm] = 'OR'
               CASE 'and'
                  ra_word [lm] = 'And'
               CASE 'between'
                  ra_word [lm] = 'Between'
               CASE 'not in'
                  ra_word [lm] = 'NOT IN'
               CASE 'not between'
                  ra_word [lm] = 'NOT Between'
               CASE ELSE
                  ra_word [lm] = upper (ra_word [lm])
            END CHOOSE
            ls_line   += ra_word [lm] + ' '
            lb_0space = TRUE
         CASE ELSE
            ls_line += ra_word [lm] + IIF ((lb_0space AND f_notnull (RIGHT (ra_word [lm], 1))), ' ', '')
      END CHOOSE
      IF f_notnull (ra_word [lm]) THEN lm_first = FALSE
   NEXT
	IF nf_comp ({'CASE','ELSE'},RIGHT (TRIM (ls_line),4))  Then
		ls_return += RIGHTTRIM (ls_line) + ' '
	ELSE
		IF nf_comp ({'THEN','ELSE'},RIGHT (TRIM (ls_line),4))  Then
			ls_return += ls_line + ' '
		ELSE
			IF	RIGHT (ls_line,2)<>'~r~n'	Then
				ls_return += ls_line + '~r~n'
			Else
				ls_return += ls_line
			End IF
		END IF
	END IF
	IF f_notnull (ls_comment)  Then
		IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN(ls_return) - 2)
		ls_return = wf_add_comment_num (ls_return, ls_comment, 0, true) + '~r~n'
		ls_spaceasclear = '[SPACEASCLEARCASE-' + STRING (gl_select_step) + ']~r~n'
		ls_comment = ''
		IF lb_spaceasclear Then
			lb_spaceasclear = false
			IF	RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
			ls_return += ls_spaceasclear
			ls_spaceasclear = ''
		END IF	
	END IF
	ls_line = ''
NEXT
IF f_notnull (ls_comment)  Then
   IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN(ls_return) - 2)
   ls_return = wf_add_comment_num (ls_return, ls_comment, 0, true) + '~r~n[SPACEASCLEARCASE-' + STRING (gl_select_step) + ']'
	ls_spaceasclear = ''
   ls_comment = ''
END IF
IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)
IF gl_select_step>0 THEN ls_return += ls_spaceasclear

// bracket 은 nf_case_space 에서 다 풀음
ls_return = nf_case_space (ls_return, la_bracket)

ll_case = f_get_array (ls_return, '~r~n', la_case)
ls_return = ''
FOR  ll = 1  TO  ll_case
   ls_temp = TRIM (la_case [ll])
   IF nf_comp ({'--','//','/*','<!'}, LEFT (ls_temp,2))	Then
      IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
      ls_return += wf_line_comment (la_case, ll_case, ll, false)
      CONTINUE
   END IF
   lm_word = rt_line (la_case [ll], ra_word)
   lb_bracket = false
   FOR  lm = 1  TO  lm_word
      IF ra_word [lm]='THEN'  Then
         IF lb_bracket  Then
            // WHEN 조건이 ( ) 인경우 바로 위 THEN 위치로 조정
            IF LEN (wf_bracket_space (ls_return))>ll_bracket_then Then
               ls_return = RIGHTTRIM (ls_return) + ' '
            ELSE
               ls_return = RIGHTTRIM (ls_return) + SPACE (ll_bracket_then - LenA (wf_bracket_space (ls_return)))
            END IF
         ELSE
            ll_bracket_then = LenA (wf_bracket_space (ls_return))
         END IF
      END IF
      ls_return += ra_word [lm]
   NEXT
   ls_return += '~r~n'
   IF POS (ls_temp,'+')>0 OR POS (ls_temp,'-')>0 OR POS (ls_temp,'*')>0 OR POS (ls_temp,'/')>0 OR POS (ls_temp,'||')>0 THEN ll_before = ll
NEXT
IF RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)

RETURN   RIGHTTRIM (ls_return)
end function

public function string nf_case_space (string arg_case, string arg_bracket[]);BOOLEAN	lm_first, lb_0space, lb_first_pos, lb_concate_pos
STRING	la_line [], ra_word []
STRING	ls_case = '', ls_temp, ls_char

LONG	ll_line, ll_case, case_start, ll, lm, lt, lm_word, ll_bracket, ll_space, ll_concat_space, ll_move
LONG	lx_c [], lx_w [], ly_t [], null_la []

ll_line = f_get_array (arg_case, '~r~n', la_line)	// 여기서 위치조정하므로
FOR  ll = 1  TO  ll_line
	yield ()
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_line [ll]),2)) Then
		IF	f_notnull (ls_case) And RIGHT (ls_case,2)<>'~r~n' THEN ls_case += '~r~n'
		ls_case += wf_line_comment (la_line, ll_line, ll, false)
		CONTINUE
	End IF
	lm_word = rt_line (la_line [ll], ra_word)
	lm_first = true ; lb_0space = false ; lb_first_pos = false
	FOR  lm = 1  TO  lm_word
		IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
		lb_0space = false

		IF	LEFT (ra_word [lm],5)='[CASE'	Then
			ls_temp = LEFT (ra_word [lm], LEN (ra_word [lm]) - 1)
			ls_char = UPPER (MID (ls_temp,6,4))
			ll_case = dec (MID (ls_temp, POS (ls_temp,'-') + 1))
		End IF
		IF	ll_case=0	Then
			ls_case += ra_word [lm]
			CONTINUE
		End IF

		CHOOSE CASE LEFT (ra_word [lm],9)
			CASE '[CASECASE'
				IF	ll_case=case_start	Then
					ll_concat_space = 0
					lx_c = null_la
					lx_w = null_la
					ly_t = null_la
				Else
					IF	UPPERBOUND (lx_c)=0 THEN case_start = ll_case
				End IF
				lx_c [ll_case] = nf_bracket_space (ls_case)
				lx_w [ll_case] = -1
				ly_t [ll_case] = -1
				lb_0space = true
				CONTINUE
			CASE '[CASEWHEN'
				IF	lx_w [ll_case]=-1	Then
					IF	lm_first	Then
						lx_w [ll_case] = lx_c [ll_case] + 5
					Else
						lx_w [ll_case] = nf_bracket_space (RIGHTTRIM (ls_case))
					End IF
				End IF
				CONTINUE
			CASE '[CASETHEN','[CASEELSE'
				IF	lm_first	Then
					IF	ly_t [ll_case]=-1	Then
						IF	lx_w [ll_case]=-1	Then
							ly_t [ll_case] = lx_c [ll_case] + 5
						Else
							ly_t [ll_case] = lx_w [ll_case]
						End IF
					End IF
				Else
					IF	ly_t [ll_case]=-1 THEN ly_t [ll_case] = nf_bracket_space (ls_case)
				End IF
				CONTINUE
			CASE '[CASEEND '
				IF	lm_first THEN ls_case = RIGHTTRIM (ls_case) + SPACE (lx_c [ll_case])
				lx_c [ll_case] = -1
				lx_w [ll_case] = -1
				ly_t [ll_case] = -1
				lb_0space = true
				CONTINUE
			CASE '[BRACKET-'
				ll_move = nf_bracket_space (ls_case)
				ls_temp = LEFT (ra_word [lm], LEN (ra_word [lm]) - 1)
				ll_bracket = dec (MID (ls_temp, 10))
				IF	RIGHT (ls_case,4)='IN (' THEN ll_move --
				ls_case += wf_move (arg_bracket [ll_bracket], ll_move, false)
				ll_space = nf_case_first (ls_case, '+')
				CONTINUE
		END CHOOSE

		CHOOSE CASE UPPER (ra_word [lm])
			CASE 'CASE'
				ls_case += ra_word [lm] + ' '
				lb_0space = true
			CASE 'WHEN'
				IF	lx_w [ll_case]=-1 THEN lx_w [ll_case] = nf_bracket_space (ls_case)
				ls_case = RIGHTTRIM (ls_case)
				IF	lm_first	Then
					ls_case += SPACE (lx_w [ll_case]) + ra_word [lm] + ' '
				Else
					ls_case += ' ' + ra_word [lm] + ' '
				End IF
				lb_0space = true
				lb_concate_pos = true
			CASE 'THEN','ELSE'
				ls_case = RIGHTTRIM (ls_case)
				IF	nf_bracket_space (ls_case)>=ly_t [ll_case]	Then
					ls_case += ' ' + ra_word [lm] + ' '
				Else
					ls_case += SPACE (ly_t [ll_case] - nf_bracket_space (ls_case)) + ra_word [lm] + ' '
				End IF
				lb_0space = true
				lb_concate_pos = true
			CASE '+','-','*','/'
				IF	lm_first	Then
					IF	ll_space=0 THEN 
						CHOOSE CASE ls_char
							CASE 'CASE','WHEN'
								ll_space = lx_w [ll_case] + 5
							CASE 'THEN','CHOOSE'
								ll_space = ly_t [ll_case] + 5
						END CHOOSE
					End IF
					ls_case += SPACE (ll_space) + ra_word [lm] + ' '
					lb_0space = true
				Else
					ls_case = RIGHTTRIM (ls_case) + ' ' + ra_word [lm] + ' '
				End IF
				IF	lb_first_pos=false And (POS (la_line [ll],'+')>0 OR POS (la_line [ll],'-')>0 OR POS (la_line [ll],'*')>0 OR POS (la_line [ll],'/')>0)	Then
					ll_space = nf_case_first (ls_case, '+')
					lb_first_pos = true
				End IF
				lb_0space = true
			CASE '||'
				IF	lm_first	Then
					ls_case = RIGHTTRIM (ls_case) + SPACE (ll_concat_space) + ra_word [lm] + ' '
				Else
					IF	ll_concat_space=0 THEN ll_concat_space = nf_bracket_space (ls_case)
					ls_case += ra_word [lm] + ' '
				End IF
				lb_0space = true
			CASE ELSE
				IF	lm_first	Then
					CHOOSE CASE ls_char
						CASE 'CASE','WHEN'
							ls_case += SPACE (lx_w [ll_case] + 5)
						CASE 'THEN','ELSE'
							ls_case += SPACE (ly_t [ll_case] + 5)
					END CHOOSE
				End IF
				ls_case += ra_word [lm]
		END CHOOSE
		IF	f_notnull (ra_word [lm]) THEN lm_first = false
	NEXT
	IF	lb_concate_pos	Then
		CHOOSE CASE ls_char
			CASE 'WHEN'
				ll_concat_space = lx_w [ll_case] + 5
			CASE 'THEN','ELSE'
				ll_concat_space = ly_t [ll_case] + 5
		END CHOOSE
		ls_temp = ls_case
		IF	POS (ls_temp,'~r~n')>0 THEN ls_temp = MID (ls_temp, LASTPOS (ls_temp,'~r~n') + 2)
		IF	POS (ls_temp,'||')>0	Then
			lb_concate_pos = false
			ll_concat_space = LEN (LEFT (ls_temp, POS (ls_temp,'||') - 1))
		End IF
	End IF
	ls_case += '~r~n'
NEXT
ls_case = LEFT (ls_case, LEN (ls_case) - 2)

IF	POS (ls_case,'[SPACEASCLEARCASE-')>0	Then
	BOOLEAN	lb_first
	STRING	ls_max, la_spaceascase []

	LONG	lk, lj, lw, ll_max, ll_for, ll_add, ll_spaceascase []

	ll_line = f_get_array (ls_case, '~r~n', la_line)
	FOR  ll = 1  TO  ll_line
		lm_word = rt_line (la_line [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	LEFT (ra_word [lm],7)='[SPACE*'	Then
				ls_temp = MID (ra_word [lm],8) ; lk = dec (LEFT (ls_temp, POS (ls_temp,']') - 1))
				la_spaceascase [lk] = '*'
			ElseIF LEFT (ra_word [lm],18)='[SPACEASCLEARCASE-'	Then
				ls_temp = MID (ra_word [lm],19) ; lk = dec (LEFT (ls_temp, POS (ls_temp,']') - 1))
				IF	UPPERBOUND (la_spaceascase)>=lk	Then
					IF	f_notnull (la_spaceascase [lk]) THEN ll_spaceascase [lk] = ll
				Else
					ll_spaceascase [lk] = 0
				End IF
			End IF
		NEXT
	NEXT
	// SPACEASCLEARCASE 만 존재하는경우 clear 처리
	FOR  ll = 1  TO  ll_line
		FOR  lj = 1  TO  UPPERBOUND (ll_spaceascase)
			IF	ll_spaceascase [lj]=0	Then
				ls_temp = '[SPACEASCLEARCASE-' + string (lj) + ']'
				IF	POS (la_line [ll], ls_temp)>0 THEN la_line [ll] = f_replace (la_line [ll], ls_temp, '')
			End IF
		NEXT
	NEXT

	FOR  lj = 1  TO  UPPERBOUND (ll_spaceascase)
		IF	ll_spaceascase [lj]=0 THEN CONTINUE
		ll = 0
		DO
			ll_max = 4
			ll_for = ll_spaceascase [lj] - 1
			lb_first = TRUE
			FOR  ll = ll + 1 TO  ll_spaceascase [lj]
				IF	f_null (la_line [ll]) THEN CONTINUE
				IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_line [ll]),2)) Then
					wf_line_comment (la_line, ll_line, ll, false)
					IF	ll>ll_line THEN EXIT
					CONTINUE
				End IF
				lm_word = rt_line (la_line [ll], ra_word)
				ls_temp = '' ; ls_max = ''
				FOR  lm = 1  TO  lm_word
					CHOOSE CASE ra_word [lm]
						CASE '[SPACEASCLEARCASE-' + string(lj) + ']'
							la_line [ll] = f_replace (la_line [ll], ra_word [lm], '')
						CASE '[SPACE*' + string(lj) + ']'
							IF	lb_first	Then
								ll_for = ll ; lb_first = FALSE
							End IF
							ll_max = MAX (ll_max, nf_bracket_space (RIGHTTRIM (ls_temp)) + 2)
						CASE ELSE
							ls_temp += ra_word [lm]
					END CHOOSE
				NEXT
			NEXT
			FOR  lk = ll_for  TO  ll - 1
				ls_max = la_line [lk]
				lw = PosA (ls_max,'[SPACE*' + string(lj) + ']')
				IF lw>0	Then
					ll_add = LEN ('[SPACE*' + string(lj) + ']')
					ls_temp = RIGHTTRIM (MidA (ls_max, 1, lw - 1))
					ls_temp += SPACE (ll_max - LenA (ls_temp))
					IF	RIGHT (ls_temp,1)<>' ' THEN ls_temp += ' '
					la_line [lk] = ls_temp + TRIM (MidA (ls_max, lw + ll_add))
				Else
					la_line [lk] = ls_max
				End IF
			NEXT
		LOOP WHILE ll < ll_spaceascase [lj]
	NEXT

	ls_case = ''
	FOR  ll = 1  TO  ll_line
		ls_case += la_line [ll] + '~r~n'
	NEXT
	ls_case = LEFT (ls_case, LEN (ls_case) - 2)
End IF

RETURN ls_case
end function

public function string wf_dml_select_as (string arg_select[], long arg_ll);LONG  ll, lm, lm_word, ll_as

BOOLEAN  lm_last, lb_add

STRING   ls_rtn = '', ra_word []

ll_as = UPPERBOUND (arg_select)

lm_word = rt_line (arg_select [arg_ll], ra_word)
IF POS (arg_select [arg_ll],'[SPACEAS')=0 AND POS (lower (arg_select [arg_ll]),' as ')=0 AND POS (lower (arg_select [arg_ll]),'from ')=0  Then
   FOR  ll = arg_ll + 1  TO  ll_as
      IF f_null (arg_select [ll]) THEN CONTINUE
      IF nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_select [ll]),2))   Then
         wf_line_comment (arg_select, ll_as, ll, false)
         CONTINUE
      END IF
      IF LEFT (TRIM (arg_select [ll]),1)=',' OR nf_comp ({'from','into'}, LEFT (TRIM (arg_select [ll]),4)) THEN lb_add=true
      EXIT
   NEXT
   IF lb_add   Then
      IF POS (lower (arg_select [arg_ll]),' as ')=0 AND lm_word>3 Then
			lm_last = true
         FOR  lm = lm_word  TO  3  STEP -1
				IF	lm_last And f_null (ra_word [lm]) THEN CONTINUE
            IF f_null (ra_word [lm]) OR nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2)) OR nf_comp ({'[',']'}, LEFT (ra_word [lm],1)) THEN CONTINUE

         	IF lm_last And (ra_word [lm]=')' OR isNumber (ra_word [lm])) OR (LEFT (ra_word [lm],1)='"' And RIGHT (ra_word [lm - 1],1)='.') THEN EXIT
            IF LEFT (ra_word [lm],1)='"' OR LEFT (ra_word [lm - 1],1)="'"	Then
               ra_word [lm] = ' [SPACEAS-' + STRING (gl_select_step) + ']AS ' + ra_word [lm]
               EXIT
            END IF
				lm_last = false
            IF lm<4 OR isNumber (ra_word [lm])                      THEN EXIT
            IF nf_comp ({'null','end','*'}, ra_word [lm])      THEN EXIT
            IF LEFT (ra_word [lm - 2],3)='/*+'                      THEN EXIT
            IF POS (ra_word [lm],'(')>0 OR POS (ra_word [lm],')')>0 THEN EXIT
            IF POS (ra_word [lm],']')>0 OR POS (ra_word [lm],'.')>0 THEN EXIT
            IF f_notnull (ra_word [lm - 1])  Then
               IF ra_word [lm - 1]=')' THEN ra_word [lm]=' [SPACEAS-' + STRING(gl_select_step) + ']AS ' + ra_word [lm]
               EXIT
            END IF
            IF nf_comp ({'+','-','*','/','^','||',','}, ra_word [lm - 2]) THEN EXIT
            CHOOSE CASE lower (ra_word [lm - 2])
               CASE 'select', 'distinct', 'unique', 'not'
                  EXIT
            END CHOOSE
            ra_word [lm] = ' [SPACEAS-' + STRING (gl_select_step) + ']AS ' + ra_word [lm]
            EXIT
         NEXT
      END IF
   END IF
END IF

FOR  lm = 1  TO  lm_word
   ls_rtn += ra_word [lm]
NEXT

RETURN ls_rtn
end function

public function string wf_dml (string arg_dml, string arg_space);BOOLEAN	lb_first, lb_add, lb_exit, lb_space_pos

LONG	ll, lm, lm_word, lj, lk, lw, lw2, ll_dml, ll_before, ll_first, ll_union, ll_concat, ll_bracket
LONG	ll_add, ll_as_max, ll_as_text, ll_mod_line, in_bracket, ll_spaceasclear []

STRING	la_dml [], ra_word [], la_spaceasclear [], la_bracket []
STRING	ls_dml, ls_char, ls_temp, ls_temp2, ls_max, ls_deselect, ls_space

ls_dml = arg_dml

ll_dml = f_get_array (ls_dml, '~r~n', la_dml)
IF	POS (arg_dml,'[SPACE^]')>0	Then
	ls_dml = nf_dml_space (la_dml, ll_dml)
	ll_dml = f_get_array (ls_dml, '~r~n', la_dml)
	lb_space_pos = true
End IF

IF	POS (ls_dml,'[SELECTSPACE-')>0	Then
	ll_before = 1
	FOR  lk = 1  TO  19
		ls_char = '[SELECTSPACE-' + string(lk) + ']'
		IF	POS (ls_dml,ls_char)=0 THEN CONTINUE
		ll_first = 0
		lb_first = true
		FOR  ll = 1  TO  ll_dml
			IF	f_null (la_dml [ll]) THEN CONTINUE
			IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_dml [ll]),2)) Then
				wf_line_comment (la_dml, ll_dml, ll, false)
				CONTINUE
			End IF
			lw = PosA (la_dml [ll],ls_char)
			IF	lw>0	Then
				ls_temp = lower (nf_clear_sqm(la_dml [ll_before], true))
				IF	lb_first	Then
					IF	POS (ls_temp,'select ')>0 And POS (ls_temp,'[select- ')>0	Then
						ll_first = PosA (lower (la_dml [ll_before]),'select ') - 2
					End IF
					IF	ll_first>0 THEN ll_union = ll_first
					lb_first = FALSE
				ElseIF POS (ls_temp,'union')>0	then
					ll_first = MIN (ll_union, PosA (lower (la_dml [ll_before]),'union'))
				ElseIF POS (ls_temp,'minus')>0	then
					ll_first = MIN (ll_union, PosA (lower (la_dml [ll_before]),'minus'))
				End IF
				la_dml [ll] = SPACE (ll_first) + MidA (la_dml [ll], lw + LenA (ls_char))
			Else
				lb_first = TRUE
			End IF
			ll_before = ll
		NEXT
	NEXT
End IF

// CASE bracket 처리
ls_dml = ''
FOR  ll = 1  TO  ll_dml
	IF	f_null (la_dml [ll]) THEN CONTINUE
	// xml
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_dml [ll]),2)) Then
		IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
		ls_dml += wf_line_comment (la_dml, ll_dml, ll, false)
		CONTINUE
	ElseIF LEFT (TRIM (la_dml [ll]),2)='<<'	Then
		IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
		ls_dml += la_dml [ll] + '~r~n'
		CONTINUE
	End IF
	lm_word = rt_line (la_dml [ll], ra_word)
	FOR  lm = 1  TO  lm_word
		IF	ra_word [lm]='' THEN CONTINUE
		CHOOSE CASE ra_word [lm]
			CASE 'CASE'
				ll_bracket ++ ; la_bracket [ll_bracket] = ''
				ls_dml += '[BRACKET' + string(ll_bracket) + ']'
				in_bracket = 0
				FOR  ll = ll  TO  ll_dml
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_dml [ll]),2)) OR LEFT (TRIM (la_dml [ll]),1)='<' OR TRIM (la_dml [ll])=']]>' Then
						IF	f_notnull (la_bracket [ll_bracket]) And RIGHT (la_bracket [ll_bracket],2)<>'~r~n' THEN la_bracket [ll_bracket] += '~r~n'
						la_bracket [ll_bracket] += wf_line_comment (la_dml, ll_dml, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_dml [ll]),2)='<<'	Then
						la_bracket [ll_bracket] += la_dml [ll] + '~r~n'
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_dml [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						la_bracket [ll_bracket] += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE 'case'
								in_bracket ++
							CASE 'end'
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_bracket=0 THEN EXIT
					la_bracket [ll_bracket] += '~r~n'
					lm = 1
				NEXT
				CONTINUE
		END CHOOSE
		ls_dml += ra_word [lm]
	NEXT
	ls_dml += '~r~n'
NEXT
ls_dml = LEFT (ls_dml, LEN (ls_dml) - 2)

IF	lb_space_pos=false	Then
	ll_dml = f_get_array (ls_dml, '~r~n', la_dml)
	// [SPACE^] 로 산칙연사자 위치조정이 없으면 여기서 위치조정
	ll_before = 1
	ls_dml = ''
	FOR  ll = 1  TO  ll_dml
		IF	f_null (la_dml [ll]) THEN CONTINUE
		ls_temp = lower (TRIM (la_dml [ll]))
		IF	nf_comp ({'--','//','/*','<!'}, LEFT (ls_temp,2)) Then
			IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
			ls_dml += wf_line_comment (la_dml, ll_dml, ll, false)
			CONTINUE
		End IF
		IF	LEFT (ls_temp,2)='<<'	Then
			ls_dml += '~r~n'
			CONTINUE
		End IF
		IF	LEFT (ls_temp,1)=',' OR LEFT (ls_temp,4)='into' OR LEFT (ls_temp,4)='from' OR LEFT (ls_temp,3)='and' THEN ll_concat = 0
		IF	nf_comp ({'+','-','*','/','|'}, LEFT (ls_temp,1)) And (POS (ls_temp,'select')=0 And POS (ls_temp,'case')=0)	Then
			IF	ll>1	Then
				ll_first	= nf_dml_first (la_dml [ll_before], TRIM (la_dml [ll]))
				IF	ll_first>1	Then
					IF	LEFT (ls_temp,2)='||'	Then
						IF	ll_concat>0	Then
							ls_dml += SPACE (ll_concat - 1) + TRIM (la_dml [ll]) + '~r~n'
						Else
							ls_dml += SPACE (ll_first + 2) + TRIM (la_dml [ll]) + '~r~n'
						End IF
					Else
						ls_dml += SPACE (ll_first) + TRIM (la_dml [ll]) + '~r~n'
					End IF
					CONTINUE
				End IF
			End IF
		End IF
		ls_dml += la_dml [ll] + '~r~n'
		IF	POS (ls_temp,'||')>0 And ll_concat=0 THEN ll_concat = PosA (la_dml [ll], '||')
		IF	POS (ls_temp,'+')>0 OR POS (ls_temp,'-')>0 OR POS (ls_temp,'*')>0 OR POS (ls_temp,'/')>0 THEN ll_before = ll
	NEXT
	ls_dml = LEFT (ls_dml, LEN (ls_dml) - 2)
End IF

ll_dml = f_get_array (ls_dml, '~r~n', la_dml)
ls_dml = ''
FOR  ll = 1  TO  ll_dml
	IF	POS (la_dml [ll],'[BRACKET')>0	Then
		lm_word = rt_line (la_dml [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	LEFT (ra_word [lm],8)='[BRACKET'	Then
				ls_temp = MID (ra_word [lm], 9) ; ll_bracket = dec (LEFT (ls_temp, LEN (ls_temp) - 1))
				ls_space = wf_bracket_space (ls_dml)
				ls_dml += wf_move (wf_case (la_bracket [ll_bracket]), LEN (ls_space), false)
			Else
				ls_dml += ra_word [lm]
			End IF
		NEXT
	Else
		ls_dml += la_dml [ll]
	End IF
	ls_dml += '~r~n'
NEXT
ls_dml = LEFT (ls_dml, LEN (ls_dml) - 2)

ll_dml = f_get_array (ls_dml, '~r~n', la_dml)
IF	POS (ls_dml,'[SPACEASCLEAR-')>0	Then
	FOR  ll = 1  TO  ll_dml
		lm_word = rt_line (la_dml [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	LEFT (ra_word [lm],7)='[SPACE*'	Then
				ls_temp = MID (ra_word [lm],8) ; lk = dec (LEFT (ls_temp, POS (ls_temp,']') - 1))
				la_spaceasclear [lk] = '*'
			ElseIF LEFT (ra_word [lm],9)='[SPACEAS-'	Then
				ls_temp = MID (ra_word [lm],10) ; lk = dec (LEFT (ls_temp, POS (ls_temp,']') - 1))
				la_spaceasclear [lk] = 'AS'
			ElseIF LEFT (ra_word [lm],14)='[SPACEASCLEAR-'	Then
				ls_temp = MID (ra_word [lm],15) ; lk = dec (LEFT (ls_temp, POS (ls_temp,']') - 1))
				IF	UPPERBOUND (la_spaceasclear)>=lk	Then
					IF	f_notnull (la_spaceasclear [lk]) THEN ll_spaceasclear [lk] = ll
				Else
					ll_spaceasclear [lk] = 0
				End IF
			End IF
		NEXT
	NEXT
	// SPACEASCLEAR 만 존재하는경우 clear 처리
	FOR  ll = 1  TO  ll_dml
		FOR  lj = 1  TO  UPPERBOUND (ll_spaceasclear)
			IF	ll_spaceasclear [lj]=0	Then
				ls_temp = '[SPACEASCLEAR-' + string (lj) + ']'
				IF	POS (la_dml [ll], ls_temp)>0 THEN la_dml [ll] = f_replace (la_dml [ll], ls_temp, '')
			End IF
		NEXT
	NEXT

	FOR  lj = UPPERBOUND (ll_spaceasclear) TO  1  STEP -1
		IF	ll_spaceasclear [lj]=0 THEN CONTINUE
		ll = 0
		DO
			ll_as_max = 4
			ll_as_text = 0
			lb_exit = false
			FOR  ll = ll + 1  TO  ll_spaceasclear [lj]
				IF	f_null (la_dml [ll]) THEN CONTINUE
				IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_dml [ll]),2)) Then
					wf_line_comment (la_dml, ll_dml, ll, false)
					IF	ll>ll_dml THEN EXIT
					CONTINUE
				End IF

				IF	POS (la_dml [ll],'[SELECT-')>0	Then
					ls_deselect = wf_deselect (la_dml [ll])
					ls_deselect = MID (ls_deselect, LASTPOS (ls_deselect,'~r~n') + 2)
					lm_word = rt_line (ls_deselect, ra_word)
				Else
					lm_word = rt_line (la_dml [ll], ra_word)
				End IF
				ls_temp = '' ; ls_max = ''
				FOR  lm = 1  TO  lm_word
					CHOOSE CASE ra_word [lm]
						CASE '[SPACEASCLEAR-' + string(lj) + ']'
							lb_exit = true
							la_dml [ll] = f_replace (la_dml [ll],'[SPACEASCLEAR-' + string(lj) + ']','')
							EXIT
						CASE '[SPACEAS-' + string(lj) + ']AS'
							ls_max = nf_clear (RIGHTTRIM (ls_temp))
							ls_max = wf_bracket_space (ls_max)
							ll_as_max = MAX (ll_as_max, LenA (ls_max) + 2)
						CASE '[SPACE*' + string(lj) + ']'
							IF	LEN (ls_max)=0	Then
								ls_max = nf_clear (ls_temp)
								ls_max = wf_bracket_space (RIGHTTRIM (ls_max))
								ll_as_max = MAX (ll_as_max, LenA (ls_max) + 2)
							Else
								ll_as_text = MAX (ll_as_text, LenA (RIGHTTRIM (ls_temp)) - LenA (ls_max) + 2)
							End IF
						CASE ELSE
							ls_temp += ra_word [lm]
					END CHOOSE
				NEXT
				IF	lb_exit THEN EXIT
			NEXT

			FOR  lk = 1  TO  ll - 1
				ls_max = la_dml [lk]
				IF	POS (ls_max,'[SELECT-')>0	Then
					ls_deselect = wf_deselect (ls_max)
					ls_deselect = MID (ls_deselect, LASTPOS (ls_deselect,'~r~n') + 2)
					lw  = PosA (ls_max,'[SPACEAS-' + string(lj) + ']')
					lw2 = PosA (ls_deselect,'[SPACEAS-' + string(lj) + ']')
					IF lw>0	Then
						ll_add = LEN ('[SPACEAS-' + string(lj) + ']')
						ls_temp  = RIGHTTRIM (MidA (ls_max, 1, lw - 1))
						ls_temp2 = RIGHTTRIM (MidA (ls_deselect, 1, lw2 - 1))
						ls_temp  += SPACE (ll_as_max - LenA (ls_temp2))
						ls_temp2 += SPACE (ll_as_max - LenA (ls_temp2))
						IF	RIGHT (ls_temp,1)<>' '  THEN ls_temp += ' '
						IF	RIGHT (ls_temp2,1)<>' ' THEN ls_temp2 += ' '
						ls_max = ls_temp + TRIM (MidA (ls_max, lw + ll_add))
						ls_deselect = ls_temp2 + TRIM (MidA (ls_deselect, lw2 + ll_add))
					End IF
					lw  = PosA (ls_max,'[SPACE*' + string(lj) + ']')
					lw2 = PosA (ls_deselect,'[SPACE*' + string(lj) + ']')
					IF lw>0	Then
						ll_add = LEN ('[SPACE*' + string(lj) + ']')
						ls_temp  = RIGHTTRIM (MidA (ls_max, 1, lw - 1))
						ls_temp2 = RIGHTTRIM (MidA (ls_deselect, 1, lw2 - 1))
						ls_temp += SPACE (ll_as_max + ll_as_text - LenA (ls_temp2))
						IF	RIGHT (ls_temp,1)<>' ' THEN ls_temp += ' '
						la_dml [lk] = ls_temp + TRIM (MidA (ls_max, lw + ll_add))
					Else
						la_dml [lk] = ls_max
					End IF
				Else
					lw = PosA (ls_max,'[SPACEAS-' + string(lj) + ']')
					IF lw>0	Then
						ll_add = LEN ('[SPACEAS-' + string(lj) + ']')
						ls_temp = RIGHTTRIM (MidA (ls_max, 1, lw - 1))
						ls_temp += SPACE (ll_as_max - LenA (ls_temp))
						IF	RIGHT (ls_temp,1)<>' ' THEN ls_temp += ' '
						ls_max = ls_temp + TRIM (MidA (ls_max, lw + ll_add))
					End IF
					lw = PosA (ls_max,'[SPACE*' + string(lj) + ']')
					IF lw>0	Then
						ll_add = LEN ('[SPACE*' + string(lj) + ']')
						ls_temp = RIGHTTRIM (MidA (ls_max, 1, lw - 1))
						ls_temp += SPACE (ll_as_max + ll_as_text - LenA (ls_temp))
						IF	RIGHT (ls_temp,1)<>' ' THEN ls_temp += ' '
						la_dml [lk] = ls_temp + TRIM (MidA (ls_max, lw + ll_add))
					Else
						la_dml [lk] = ls_max
					End IF
				End IF
			NEXT
		LOOP WHILE ll < ll_spaceasclear [lj]
	NEXT
End IF

ls_dml = '' ; lb_first = true
FOR  ll = 1  TO  ll_dml
	IF	f_null (la_dml [ll]) THEN CONTINUE
	IF	lower (LEFT (TRIM (la_dml [ll]),5))='union'	Then
		lb_add = false
		FOR  lj = ll  TO  2
			IF	POS (lower (nf_clear_sqm (la_dml [lj], true)),'from')>0	Then
				IF	POS (la_dml [lj - 1],'/* _')>0 THEN lb_add = true
				EXIT
			End IF
		NEXT
		IF	lb_add THEN ls_dml += '~r~n'
	End IF
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_dml [ll]),2)) Then
		ls_dml += wf_line_comment (la_dml, ll_dml, ll, false)
		CONTINUE
	End IF

	IF	LEN (arg_space)>0	Then
		IF	NOT lb_first THEN ls_dml += arg_space
	End IF
	ls_dml += la_dml [ll] + '~r~n'
	lb_first = FALSE
NEXT
IF	RIGHT (ls_dml,2)='~r~n' THEN ls_dml = LEFT (ls_dml, LEN (ls_dml) - 2)

RETURN	ls_dml
end function

public function string nf_dml_space (string arg_array[], long arg_dml);S_RET pivot

LONG  ll_dml, ll, lm, lm_word, ll_pos, ll_first, ll_xml, ll_before = 1, ll_bracket = 0
LONG  ll_concat, ll_comma, in_bracket

BOOLEAN  lb_dml

STRING   ls_dml = '', ls_lower_trim, ls_temp, ls_space
STRING   la_dml [], ra_word [], la_bracket []

IF	nf_comp ({'select','insert','update','delete'}, lower (LEFT (TRIM (nf_clear_sqm (arg_array [1], true)),6)))	Then
	lb_dml = true
	ll_dml = 1
End IF

// CASE bracket 처리
ls_dml = ''
FOR  ll = 1  TO  arg_dml
	IF	f_null (arg_array [ll]) THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_array [ll]),2)) Then
		IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
		ls_dml += wf_line_comment (arg_array, arg_dml, ll, false)
		CONTINUE
	ElseIF LEFT (TRIM (arg_array [ll]),2)='<<'	Then
		IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
		ls_dml += arg_array [ll] + '~r~n'
		CONTINUE
	End IF
	lm_word = rt_line (arg_array [ll], ra_word)
	FOR  lm = 1  TO  lm_word
		IF	ra_word [lm]='' THEN CONTINUE
		CHOOSE CASE ra_word [lm]
			CASE 'CASE'
				ll_bracket ++ ; la_bracket [ll_bracket] = ''
				ls_dml += '[BRACKET' + string(ll_bracket) + ']'
				in_bracket = 0
				FOR  ll = ll  TO  arg_dml
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (arg_array [ll]),2)) OR LEFT (TRIM (arg_array [ll]),1)='<' OR TRIM (arg_array [ll])=']]>' Then
						IF	f_notnull (la_bracket [ll_bracket]) And RIGHT (la_bracket [ll_bracket],2)<>'~r~n' THEN la_bracket [ll_bracket] += '~r~n'
						la_bracket [ll_bracket] += wf_line_comment (arg_array, arg_dml, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (arg_array [ll]),2)='<<'	Then
						la_bracket [ll_bracket] += arg_array [ll] + '~r~n'
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (arg_array [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						la_bracket [ll_bracket] += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE 'case'
								in_bracket ++
							CASE 'end'
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_bracket=0 THEN EXIT
					la_bracket [ll_bracket] += '~r~n'
					lm = 1
				NEXT
				CONTINUE
//			CASE '('
//				ll_bracket ++
//				ls_dml += '[BRACKET' + string(ll_bracket) + ']'
//				la_bracket [ll_bracket] = '('
//				pivot = nf_bracket_pivot (arg_array, arg_dml, ll, lm)
//				la_bracket [ll_bracket] += pivot.text + ')'
//				ll = pivot.ll
//				lm = pivot.lm
//				IF	ll>arg_dml THEN EXIT
//				lm_word = rt_line (arg_array [ll], ra_word)	// 변경된 ll 반영
//				CONTINUE
		END CHOOSE
		ls_dml += ra_word [lm]
	NEXT
	ls_dml += '~r~n'
NEXT
ls_dml = LEFT (ls_dml, LEN (ls_dml) - 2)

ll_dml = f_get_array (ls_dml, '~r~n', la_dml)
ls_dml = ''
FOR  ll = 1  TO  ll_dml
	IF	f_null (la_dml [ll]) OR POS (la_dml [ll],'[SPACEASCLEAR')>0 THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_dml [ll]),2)) Then
		wf_line_comment (la_dml, ll_dml, ll, false)
		CONTINUE
	ElseIF LEFT (TRIM (la_dml [ll]),2)='<<'	Then
		CONTINUE
	End IF

	ls_lower_trim = lower (nf_clear_sqm (TRIM (nf_clear (la_dml [ll])), true))	// 존재 점검용
	IF	lb_dml	Then
		IF	LEFT (ls_lower_trim,6)='values'	Then
			ll_before = ll
			la_dml [ll] = TRIM (la_dml [ll])
			ll_comma  = PosA (la_dml [ll],'(')
			ll_concat = PosA (la_dml [ll],'||')
			ll_xml = ll
			CONTINUE
		End IF
		IF	ll_comma>0 And ls_lower_trim=')'	Then
			la_dml [ll] = SPACE (ll_comma - 1) + TRIM (la_dml [ll])
			ll_xml = ll
			CONTINUE
		End IF
		ll_pos = nf_dml_first (la_dml [ll_before], ls_lower_trim)
	Else
		ll_pos = nf_first (la_dml [ll_before], ls_lower_trim)
	End IF
	IF	ll_pos>0 THEN ll_first = ll_pos
	IF	POS (la_dml [ll],'[SPACE^')>0	Then
		la_dml [ll] = f_replace (la_dml [ll], '[SPACE^]', '')
		IF	nf_comp ({'into','from'}, LEFT (ls_lower_trim,4))	Then
			ll_concat = 0
			ll_before = ll
			la_dml [ll] = SPACE (ll_first + 2) + TRIM (la_dml [ll])
		ElseIF LEFT (ls_lower_trim,5)='where'	Then
			ll_concat = 0
			ll_before = ll
			la_dml [ll] = SPACE (ll_first + 1) + TRIM (la_dml [ll])
		ElseIF LEFT (ls_lower_trim,3)='and'	Then
			ll_concat = 0
			la_dml [ll] = SPACE (ll_first + 3) + TRIM (la_dml [ll])
		ElseIF POS (la_dml [ll_before],':=')>0	Then
			FOR  ll = ll  TO  ll_dml
				IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_dml [ll]),2)) Then
					wf_line_comment (la_dml, ll_dml, ll, false)
					EXIT
				ElseIF LEFT (TRIM (la_dml [ll]),2)='<<'	Then
					EXIT
				End IF
				IF	LEFT (ls_lower_trim,2)='||' And POS (la_dml [ll_before],':=')<ll_concat	Then
					la_dml [ll] = SPACE (ll_concat - 1) + TRIM (la_dml [ll])
				Else
					la_dml [ll] = SPACE (ll_first) + TRIM (la_dml [ll])
				End IF
				IF RIGHT (TRIM (la_dml [ll]),1)=';' THEN EXIT
				ls_lower_trim = lower (nf_clear_sqm (TRIM (nf_clear (la_dml [ll])), true))	// 존재 점검용
			NEXT
		Else
			IF	LEFT (ls_lower_trim,2)='||'	Then
				IF	ll_concat=0	Then
					la_dml [ll] = SPACE (ll_first + 2) + TRIM (la_dml [ll])
				Else
					la_dml [ll] = SPACE (ll_concat - 1) + TRIM (la_dml [ll])
				End IF
			ElseIF ll_comma>0	Then
				IF	LEFT (la_dml [ll],2)=",'"	Then
					la_dml [ll] = TRIM (la_dml [ll])
				ElseIF LEFT (la_dml [ll],1)=","	Then
					IF	POS (la_dml [ll_before],'(')>0	Then
						la_dml [ll] = SPACE (ll_first - 2) + TRIM (la_dml [ll])
					Else
						la_dml [ll] = SPACE (ll_comma - 1) + TRIM (la_dml [ll])
					End IF
				Else
					la_dml [ll] = SPACE (ll_first) + TRIM (la_dml [ll])
				End If
			Else
				la_dml [ll] = SPACE (ll_first) + TRIM (la_dml [ll])
			End IF
		End IF
		ll --
		CONTINUE
	End IF
	IF	LEFT (ls_lower_trim,1)=',' OR (NOT lb_dml And (POS (ls_lower_trim,'(')>0 OR POS (ls_lower_trim,':')>0))	Then
		ll_concat = 0
		ll_before = ll
		IF	LEFT (ls_lower_trim,1)=','	Then
			ll_comma = POS (la_dml [ll],',')
		ElseIF POS (ls_lower_trim,':')>0	Then
			ll_comma = POS (la_dml [ll],':')
		Else
			ll_comma = POS (la_dml [ll],'(')
		End IF
	ElseIF POS (ls_lower_trim,'outer')>0	Then
		ll_concat = 0
		ll_before = ll
		IF	ll_comma=0 THEN ll_comma = ll_first
	ElseIF POS (ls_lower_trim,'+')>0 OR POS (ls_lower_trim,'-')>0 OR POS (ls_lower_trim,'*')>0 OR POS (ls_lower_trim,'/')>0	Then
		ll_before = ll
	Else
		IF	nf_comp ({'into','from'}, LEFT (ls_lower_trim,4)) OR LEFT (ls_lower_trim,3)='and'	Then
			ll_concat = 0
			ll_before = ll
		End IF
	End IF
	IF	ll_concat=0	Then
		ls_temp = nf_clear_sqm (nf_clear (la_dml [ll]), true)	// 위치용
		IF	POS (ls_temp,'||')>0	Then
			ll_concat = PosA (ls_temp, '||')
		Else
			IF	POS (ls_temp,'(')>0 THEN ll_concat = PosA (ls_temp, '(')
			IF	POS (ls_temp,"'")>0 THEN ll_concat = MIN (ll_concat, PosA (ls_temp, "'"))
			IF	ll_concat=0         THEN ll_concat = PosA (ls_temp, ':=') + 3
		End IF
	End IF
	ll_xml = ll	// xml < 컬럼 위치 제외하기 위해서
NEXT

FOR  ll = ll_dml  TO  1  STEP -1
	IF	f_notnull (la_dml [ll]) THEN EXIT
	ll_dml --
NEXT
FOR  ll = 1  TO  ll_dml
	IF	POS (la_dml [ll],'[BRACKET')>0	Then
		lm_word = rt_line (la_dml [ll], ra_word)
		FOR  lm = 1  TO  lm_word
			IF	LEFT (ra_word [lm],8)='[BRACKET'	Then
				ls_temp = MID (ra_word [lm], 9) ; ll_bracket = dec (LEFT (ls_temp, LEN (ls_temp) - 1))
				ls_temp = nf_clear (la_bracket [ll_bracket])

				ls_space = wf_bracket_space (ls_dml)
				IF	LEFT (ls_temp,4)='CASE'	Then
					ls_temp = wf_case (ls_temp)
				Else
					ls_temp = wf_in (ls_dml, ls_temp)
				End IF
				ls_dml += wf_move (ls_temp, LEN (ls_space), false)
			Else
				ls_dml += ra_word [lm]
			End IF
		NEXT
	Else
		ls_dml += la_dml [ll]
	End IF
	ls_dml += '~r~n'
NEXT
ls_dml = LEFT (ls_dml, LEN (ls_dml) - 2)

RETURN ls_dml
end function

public function string wf_fetch_list (string arg_fetch[], long al_fetch, integer ai_step);// fetch list
INT   lx, li, ln_index

LONG  la_fetch_max []

STRING   ls_line, ls_comment

IF al_fetch <= 7  Then
	FOR  lx = 1  TO  al_fetch
		IF lx=1  Then
         ls_line += arg_fetch [lx]
      ELSE
         ls_line += ', ' + arg_fetch [lx]
      END IF
   NEXT
   ls_line += ';'
ELSE
   // Max 길이 계산
   FOR  lx = 1  TO  al_fetch
		FOR li = 1 TO ai_step
			ln_index = lx + li - 1
			IF ln_index>al_fetch THEN EXIT
			la_fetch_max [li] = MAX (la_fetch_max[li], LenA(arg_fetch[ln_index]))
		NEXT
		lx += (ai_step - 1)
   NEXT
   // 실제 줄 만들기
	FOR  lx = 1  TO  al_fetch
		IF lx=1  Then
         ls_line += LEFT (arg_fetch[lx] + SPACE(la_fetch_max[1]), la_fetch_max[1])
      ELSE
         ls_line += '~r~n, ' + LEFT (arg_fetch[lx] + SPACE(la_fetch_max[1]), la_fetch_max[1])
      END IF
		// 각 step만큼 이어붙이기
		FOR  li = 2  TO  ai_step
			ln_index = lx + li - 1
         IF ln_index>al_fetch Then
				ls_comment = ' -- ' + string (lx) + IIF (li = 2, '', ' - ' + STRING(ln_index - 1))
            // 마무리 포맷
				ls_line = RIGHTTRIM (ls_line) + ';' + SPACE (la_fetch_max[li - 1] - LenA(arg_fetch[ln_index - 1]) + 2 * (ai_step - li + 1))
            FOR  li = li  TO  ai_step
					ls_line += SPACE (la_fetch_max[li])
				NEXT
				ls_line += ls_comment
				RETURN ls_line
         END IF
         ls_line += ', ' + LEFT (arg_fetch[ln_index] + SPACE(la_fetch_max[li]), la_fetch_max[li])
      NEXT
		// 완전한 줄 포맷
		IF	(lx + ai_step - 1)=al_fetch	Then
			ls_line = RIGHTTRIM (ls_line) + ';' + SPACE (la_fetch_max[ai_step] - LenA(arg_fetch[lx + ai_step - 1]))
			ls_line += ' -- ' + STRING (lx) + ' - ' + STRING (MIN(lx + ai_step - 1, al_fetch))
		Else
			ls_line += '  -- ' + STRING (lx) + ' - ' + STRING (MIN(lx + ai_step - 1, al_fetch))
		End IF
		lx += (ai_step - 1)
   NEXT
END IF

RETURN ls_line
end function

public function string wf_setting_max (string assign_word, long ll_start, long ll_line, ref long target_end, ref string la_line[]);LONG  target_start, max_target, max_value, ll_eq, ll, lm_word, lm, ll_target, ll_value

BOOLEAN  lb_0space, lm_first

STRING   ls_result = '', ls_temp, ls_line, ls_space = '    ', ra_word[]

target_start = ll_start
target_end   = ll_start

// 1. MAX 길이 계산
FOR ll_eq = ll_start TO ll_line
	IF f_null(la_line[ll_eq]) THEN EXIT

   ls_temp = lower (TRIM(la_line[ll_eq]))
   IF nf_comp({"--","/*","<!"}, LEFT (ls_temp, 2)) OR f_null(la_line[ll_eq]) THEN EXIT

	ls_temp = nf_clear_sqm (ls_temp, true)
	IF	POS (ls_temp,'__')>0   THEN ls_temp = LEFT (ls_temp, POS (ls_temp,'__') - 1)
   IF RIGHT (ls_temp,1)<>';' THEN EXIT

	IF nf_comp({"if", "do"}, LEFT (ls_temp, 2)) OR &
	   LEFT (ls_temp, 3)="for" OR LEFT (ls_temp, 5)="elsif" OR POS(ls_temp, assign_word)=0 THEN EXIT

	lm_word = rt_line (la_line[ll_eq], ra_word)
	FOR lm = 1 TO lm_word
		IF	f_null (ra_word [lm]) THEN CONTINUE
		IF	ra_word [lm]='('	Then
			ll_target = 0
			FOR lm = lm + 1 TO lm_word
				IF	f_null (ra_word [lm]) THEN CONTINUE
				IF	ra_word [lm]=','	Then
					EXIT
				End if
				ll_target += LenA (ra_word [lm])
			NEXT
			ll_value = 0
			FOR lm = lm + 1 TO lm_word
				IF	f_null (ra_word [lm]) THEN CONTINUE
				IF	ra_word [lm]=';'	Then
					EXIT
				End if
				ll_value += LenA (ra_word [lm])
			NEXT
			max_target = MAX (max_target, ll_target)
			max_value  = MAX (max_value, ll_value - 1)
			EXIT
		End IF
	NEXT
   target_end = ll_eq
NEXT

// 2. MAx 길이 적용
FOR ll = target_start TO target_end
   lm_word = rt_line (la_line[ll], ra_word)
   IF ll=target_start And f_null(ra_word[1]) THEN ls_space = ra_word[1]

   ls_line   = ls_space
   lb_0space = true
   lm_first  = true
   FOR lm = 1 TO lm_word
		IF	f_null (ra_word [lm]) THEN CONTINUE
		CHOOSE CASE lower (ra_word [lm])
			CASE lower (assign_word)
				ls_line += ra_word [lm]
			CASE '('
				ls_line += '('
				ls_temp = ''
				FOR lm = lm + 1 TO lm_word
					IF	f_null (ra_word [lm]) THEN CONTINUE
					IF	ra_word [lm]=','	Then
						EXIT
					End if
					ls_temp += ra_word [lm]
				NEXT
				ls_line += LEFT (ls_temp + SPACE (max_target), max_target) + ','
				ls_temp = ''
				FOR lm = lm + 1 TO lm_word
					IF	f_null (ra_word [lm]) THEN CONTINUE
					IF	ra_word [lm]=';'	Then
						EXIT
					End if
					ls_temp += ra_word [lm]
				NEXT
				ls_line += LEFT (LEFT (ls_temp, LEN (ls_temp) - 1) + SPACE (max_value), max_value) + ');'
				IF	(lm + 1) <= lm_word	Then
					ls_line += '  '
					lm_first = true
					FOR lm = lm + 1 TO lm_word
						IF	lm_first And f_null (ra_word [lm])	Then
							lm_first = false
							CONTINUE
						End IF
						lm_first = false
						ls_line += ra_word [lm]
					NEXT
				End IF
				EXIT
		END CHOOSE
	NEXT
   ls_result += ls_line + "~r~n"
NEXT

RETURN ls_result
end function

public function string wf_indentation_space (integer arg_begin, string begin_space[], integer arg_if, string if_space[], integer arg_for, string for_space[], integer arg_do, string do_space[]);// 들여쓰기 기준공란

STRING	ls_indentation_space = ''

IF	arg_begin>0	Then
	IF	ls_indentation_space < begin_space [arg_begin] THEN ls_indentation_space = begin_space [arg_begin]
End IF
IF	arg_if>0	then
	IF	ls_indentation_space < if_space [arg_if] THEN ls_indentation_space = if_space [arg_if]
End IF
IF	arg_for>0	Then
	IF	ls_indentation_space < for_space [arg_for] THEN ls_indentation_space = for_space [arg_for]
End IF
IF	arg_do>0	Then
	IF	ls_indentation_space < do_space [arg_do] THEN ls_indentation_space = do_space [arg_do]
End IF

RETURN	ls_indentation_space
end function

public function string wf_assign_max (boolean arg_begin, string assign_word, long ll_start, long ll_line, boolean lb_begin, ref long assign_end, ref string la_line[]);LONG  assign_start, assign_max, remark_max, ll_eq, ll, lm_word, lm

BOOLEAN  lb_0SPACE, lm_first

STRING   ls_result = "", ls_temp, ls_line, ls_SPACE, ra_word[]

assign_start = ll_start
assign_end   = ll_start
assign_max   = 0
remark_max   = 0

// 1. MAX 길이 계산
FOR ll_eq = ll_start TO ll_line
	IF f_null(la_line[ll_eq]) THEN EXIT

   ls_temp = lower (TRIM(la_line[ll_eq]))
   IF nf_comp({"--","/*","<!"}, LEFT (ls_temp, 2)) OR f_null(la_line[ll_eq]) THEN EXIT

	ls_temp = nf_clear_sqm (ls_temp, true)
	IF	POS (ls_temp,'__')>0   THEN ls_temp = TRIM (LEFT (ls_temp, POS (ls_temp,'__') - 1))
   IF RIGHT (ls_temp,1)<>';' THEN EXIT

	IF nf_comp({"if", "do"}, LEFT (ls_temp, 2)) OR &
	   LEFT (ls_temp, 3)="for" OR LEFT (ls_temp, 4)="else" OR LEFT (ls_temp, 5)="elsif" OR POS(ls_temp, assign_word)=0 THEN EXIT

	lm_word = rt_line (la_line[ll_eq], ra_word)
	ls_temp = ""
	FOR lm = 1 TO lm_word
		IF ra_word [lm]=assign_word THEN EXIT
		ls_temp += ra_word [lm]
	NEXT

	IF la_line[ll_eq]=ls_temp THEN EXIT

	assign_max = MAX (assign_max, LenA(TRIM(ls_temp)) + 1)

	IF POS(la_line[ll_eq], "--")>0   Then
		FOR lm = lm TO lm_word
			IF left(ra_word[lm], 2)="--"  Then
				ls_temp    = TRIM (ls_temp)
				remark_max = MAX (remark_max, LenA(ls_temp) + 2)
				EXIT
			END IF
			ls_temp += ra_word [lm]
		NEXT
	ELSEIF POS(la_line[ll_eq], "/*")>0  Then
		FOR lm = lm TO lm_word
			IF left(ra_word[lm], 2)="/*"  Then
				ls_temp    = TRIM (ls_temp)
				remark_max = MAX (remark_max, LenA(ls_temp) + 2)
				EXIT
			END IF
			ls_temp += ra_word [lm]
		NEXT
	END IF
   assign_end = ll_eq
NEXT

// 2. MAX 길이 적용
IF	assign_start=assign_end And arg_begin	Then
	ls_result += la_line[assign_start] + "~r~n"
Else
	FOR ll = assign_start TO assign_end
		lm_word = rt_line (la_line[ll], ra_word)
		IF ll=assign_start   Then
			ls_SPACE = ""
			IF f_null(ra_word[1]) THEN ls_SPACE = ra_word[1]
		END IF
	
		ls_line   = ""
		lb_0SPACE = true
		lm_first  = true
		FOR lm = 1 TO lm_word
			IF lb_0SPACE AND f_null(ra_word[lm]) THEN CONTINUE
			lb_0SPACE = false
			IF ra_word [lm]=assign_word   Then
				ls_line = TRIM (ls_line)
				IF LenA(ls_line) >= assign_max   Then
					ls_line += " "
				ELSE
					ls_line = left (ls_line + SPACE(assign_max), assign_max)
				END IF
				ls_line += ra_word [lm] + " "
				IF remark_max>0   Then
					FOR lm = (lm + 1) TO lm_word
						IF lm_first AND f_null(ra_word[lm]) THEN CONTINUE
						lm_first = false
						IF LEFT (ra_word[lm], 2)="--" Then
							IF LenA(TRIM(ls_line)) >= remark_max   Then
								ls_line += ra_word [lm]
							ELSE
								ls_line = RIGHTTRIM (ls_line) + SPACE (remark_max - LenA(TRIM(ls_line))) + ra_word [lm]
							END IF
						ELSEIF LEFT (ra_word[lm], 2)="/*"   Then
							IF LenA(TRIM(ls_line)) >= remark_max   Then
								ls_line += ra_word [lm]
							ELSE
								ls_line = RIGHTTRIM (ls_line) + SPACE (remark_max - LenA(TRIM(ls_line))) + ra_word [lm]
							END IF
						ELSE
							ls_line += ra_word [lm]
						END IF
					NEXT
				ELSE
					FOR lm = (lm + 1) TO lm_word
						IF lm_first AND f_null(ra_word[lm]) THEN CONTINUE
						lm_first = false
						ls_line  += ra_word [lm]
					NEXT
				END IF
				EXIT
			ELSE
				IF	lb_begin	Then
					ls_line += nf_1SPACE (ra_word[lm])
				Else
					ls_line += ra_word[lm]
				End IF
			END IF
		NEXT
		ls_result += ls_SPACE + ls_line + "~r~n"
	NEXT
End IF

RETURN ls_result
end function

public function string wf_4space (string arg_line);STRING	ls_space, ls_return

ls_return = arg_line
IF	f_notnull (RIGHT (ls_return,1)) THEN ls_return += ' '
ls_space = wf_bracket_space (ls_return)
IF	MOD (LenA (ls_space),4)>0 THEN ls_return += SPACE (4 - MOD (LenA (ls_space),4))

RETURN	ls_return
end function

public function string wf_dml_select (string arg_select);S_ORDER	la_order [], la_null []

S_RET	pivot, where_syntax
S_WHERE_ADD_COLUMN	add_where

INT   add_line, ii

LONG  ll_select, ll_from, ll_alias = 0, ll_table, lw_col, in_bracket, ll_order_line, ll_order, ll_move_back
LONG  ll, lm, lm_word, lo, lt, lx, ly, ll_column = 0, lMax []

BOOLEAN  lb_select = TRUE, lb_into, lb_union, lb_from, lb_where, lb_by, lb_join_exit, lb_union_exit
BOOLEAN  lb_first = true, lm_first, lb_exit, lb_0space, lb_order, lb_from_pivot, lb_pivot, lb_pivot_in, from_exit

STRING   ls_line = '', ls_comment = '', ls_line_comment = ''
STRING   ls_return, ls_pivot, ls_union_select, ls_temp
STRING   ls_case, ls_start, ls_end, ls_space, ls_table, ls_column, ls_spaceasclear, ls_fetch, ls_order
STRING   la_return [], la_select [], la_table [], la_alias [], la_join_table [], ra_word []

gl_select_step ++

ll_select = f_get_array (arg_select, '~r~n', la_select)
ll_column = nf_select_column (la_select)	// 조회 컬럼이 4개 미만인경우 순번제외 점검용
lb_order = (ll_column > 4)

ll_column = 0
la_return = {''} ; add_line = UPPERBOUND (la_return)
FOR  ll = 1  TO  ll_select
	yield ()
	IF	f_null (la_select [ll]) THEN CONTINUE

	// xml
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_select [ll]),2)) Then
		IF	lb_select OR lb_into	Then
			IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
			ls_line_comment += wf_line_comment (la_select, ll_select, ll, false)
			IF	TRIM (la_return [add_line])=','	Then
				add_line ++
				la_return [add_line] = la_return [add_line - 1]
				la_return [add_line - 1] = ls_line_comment
				ls_line_comment = ''
			End IF
		Else
			IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
			ls_line_comment += wf_line_comment (la_select, ll_select, ll, false)
		End IF
		CONTINUE
	End IF
	IF	f_notnull (ls_line_comment)	Then
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		la_return [add_line] += ls_line_comment ; ls_line_comment = ''
	End IF

	// 연산자만 있는경우 줄 합치기 * 는 예외 점검
	IF	nf_comp ({'+','-','/','||',',','*'}, TRIM (la_select [ll]))	Then
		IF	TRIM (la_select [ll])='*'	Then
			IF	RIGHT (la_return [add_line],2)='~r~n' THEN la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2)
			IF RIGHT (la_return [add_line],1)<>' '   THEN la_return [add_line] += ' '
			la_return [add_line] += TRIM (la_select [ll]) + '~r~n'
		ElseIF TRIM (la_select [ll])=',' And (lb_select OR lb_into)	Then
			IF	f_notnull (ls_comment)	Then
				IF	RIGHT (la_return [add_line],2)='~r~n' THEN la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2)
				IF	lb_order	Then
					ll_column ++
					la_return [add_line] = wf_add_comment_num (la_return [add_line], ls_comment, ll_column, true) + '~r~n'
				Else
					la_return [add_line] = wf_add_comment_num (la_return [add_line], ls_comment, 0, true) + '~r~n'
				End IF
				ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
				ls_comment = ''
			End IF
			add_line ++
			la_return [add_line] = RIGHTTRIM (la_select [ll]) + ' '
		Else
			la_return [add_line] += la_select [ll] + ' '
		End IF
		CONTINUE
	End IF

	IF	lb_select	Then	// SELECT
		lm_word = rt_line (la_select [ll], ra_word)
		lm_first = TRUE; lb_0space = TRUE
		FOR  lm = 1  TO  lm_word
			IF	ra_word [lm]='' THEN CONTINUE
			IF	f_null (ra_word [lm])	Then
				IF	lm_first OR lb_0space THEN CONTINUE
				IF	NOT lm_first And LEFT (ra_word [lm],1)=' '	Then
					ls_line += ' '
					CONTINUE
				End IF
			End IF
			IF	(lm + 2)<=lm_word And RIGHT (ra_word [lm],1)='.'	Then
				IF	f_null (ra_word [lm + 1])	Then
					ra_word [lm] += ra_word [lm + 2]
					ra_word [lm + 2] = ''
				End IF
			End IF

			lb_0space = FALSE
			IF	LEFT (ra_word [lm],3)='/*+'	Then
				IF	RIGHT (ls_line,2)='~r~n' THEN ls_line = LEFT (ls_line, LEN (ls_line) - 2)
				ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm]
				CONTINUE
			ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
				ls_comment = nf_add_comment (ls_comment, ra_word [lm])
				CONTINUE
			End IF

			CHOOSE CASE UPPER (ra_word [lm])
				CASE 'SELECT'
					lb_select = TRUE
					lb_into   = false
					lb_from   = false
					lb_where  = false
					lb_by     = false
					ls_line += 'SELECT '
					lb_0space = TRUE
				CASE 'SELECTBLOB'
					lb_select = TRUE
					lb_into   = false
					lb_from   = false
					lb_where  = false
					lb_by     = false
					ls_line += 'SELECTBLOB '
					lb_0space = TRUE
				CASE 'DISTINCT','UNIQUE'
					ls_line = RIGHTTRIM (ls_line) + ' ' + UPPER (ra_word [lm]) + ' '
					lb_0space = TRUE
				CASE 'INTO'
					IF	f_notnull (ls_comment)	Then
						IF	RIGHT (la_return [add_line],2)='~r~n' THEN la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2)
						ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
						ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
						ls_comment = ''
					End IF
					lb_select = false
					lb_into   = TRUE
					lb_from   = false
					lb_where  = false
					lb_by     = false
					ll_column = 0
					EXIT
				CASE 'FROM'
					IF	f_notnull (ls_comment)	Then
						IF	RIGHT (la_return [add_line],2)='~r~n' THEN la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2)
						ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
						ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
						ls_comment = ''
					End IF
					lb_select = false
					lb_into   = false
					lb_from   = TRUE
					lb_where  = false
					lb_by     = false
					EXIT
				CASE 'CAST'
					ls_temp = ra_word [lm]
					in_bracket = 0
					FOR  ll = ll  TO  ll_select
						IF	f_null (la_select [ll]) THEN CONTINUE
						lm_word = rt_line (la_select [ll], ra_word)
						FOR  lm = lm + 1  TO  lm_word
							ls_temp += lower (ra_word [lm])
							CHOOSE CASE ra_word [lm]
								CASE '('
									in_bracket ++
								CASE ')'
									in_bracket --
									IF	in_bracket=0 THEN EXIT
							END CHOOSE
						NEXT
						IF	in_bracket=0 THEN EXIT
						ls_temp += ' '
						lm = 0
					NEXT
					ls_line += IIF (lm_first,'[SPACE^]','') + ls_temp
					IF	ll>ll_select THEN EXIT
					CONTINUE
				CASE 'CASE','DECODE'
					la_return [add_line] += ls_line ; ls_line = ''
					ls_temp = ra_word [lm]
					IF	lower (ra_word [lm])='case'	Then
						in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
					Else
						in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
					End IF
					ls_space = wf_bracket_space (la_return [add_line])
					FOR  ll = ll  TO  ll_select
						yield ()
						IF	f_null (la_select [ll]) THEN CONTINUE
						lm_word = rt_line (la_select [ll], ra_word)
						FOR  lm = lm + 1  TO  lm_word
							IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
								ls_temp += wf_add_comment_num ('', nf_add_comment ('', ra_word [lm]), 0, false)
								CONTINUE
							End IF
							ls_temp += ra_word [lm]
							CHOOSE CASE lower (ra_word [lm])
								CASE ls_start
									in_bracket ++
								CASE ls_end
									in_bracket --
									IF	in_bracket=0 THEN EXIT
							END CHOOSE
						NEXT
						IF	in_bracket=0 THEN EXIT
						ls_temp += '~r~n'
						lm = 0
					NEXT
					ls_line += IIF (lm_first,'[SPACE^]','')
					IF	ls_start='case'	Then
						ls_case = wf_case (ls_temp)
					Else
						ls_case = nf_decode (ls_temp)
					End IF
					ls_line += wf_move (ls_case, LEN (ls_space), false)
					IF	ll>ll_select THEN EXIT
					CONTINUE
				CASE 'LISTAGG','RANK','DENSE_RANK','PERCENT_RANK','ROW_NUMBER','ROUND','SUM','AVG','MAX','MIN','COUNT','FIRST_VALUE','LAST_VALUE','RATIO_TO_REPORT','LAG','LEAD','EXP','LEAST','GREATEST'
					ra_word [lm] = UPPER (ra_word [lm])
					pivot = wf_func_str (la_select, ll_select, ll, lm)
					IF	pivot.func	Then
						ls_space = wf_bracket_space (ls_line)
						ls_line += wf_move (pivot.text, LEN (ls_space), false)
						la_return [add_line] += wf_move (ls_line, nf_bracket_space (la_return [add_line]), false) ; ls_line = ''
						ll = pivot.ll ; lm = pivot.lm
						IF	ll>ll_select THEN EXIT
						lm_word = rt_line (la_select [ll], ra_word)	// 변경된 ll 반영
						CONTINUE
					Else
						IF	ra_word [lm]='('	Then
							la_return [add_line] += ls_line + '(' ; ls_line = ''
							ls_space = wf_bracket_space (la_return [add_line])
							pivot = nf_bracket_pivot (la_select, ll_select, ll, lm)
							ls_temp = wf_in (la_return [add_line], pivot.text)
							la_return [add_line] += wf_move ('(' + ls_temp, LEN (ls_space), false) + ') '
							ll = pivot.ll
							lm = pivot.lm
							IF	ll>ll_select THEN EXIT
							lm_word = rt_line (la_select [ll], ra_word)	// 변경된 ll 반영
							lb_0space = true
							CONTINUE
						Else
							ls_line += ra_word [lm]
						End IF
					End IF
				CASE '('
					la_return [add_line] += ls_line + '(' ; ls_line = ''
					ls_space = wf_bracket_space (la_return [add_line])
					pivot = nf_bracket_pivot (la_select, ll_select, ll, lm)
					ls_temp = wf_bracket (pivot.text)
					IF	POS (ls_Temp,'[SPACE')>0  THEN ls_temp = wf_dml (ls_temp, '')
					la_return [add_line] += wf_move (ls_temp, LEN (ls_space), false)
					ll = pivot.ll
					lm = pivot.lm
					IF	ll>ll_select THEN EXIT
					lm_word = rt_line (la_select [ll], ra_word)	// 변경된 ll 반영
					la_return [add_line] += ')'
					lb_0space = true
					CONTINUE
				CASE ','
					IF	f_notnull (ls_comment)	Then
						IF	RIGHT (la_return [add_line],2)='~r~n' THEN la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2)
						IF	lb_order	Then
							ll_column ++
							ls_line = wf_add_comment_num (ls_line, ls_comment, ll_column, true) + '~r~n'
						Else
							ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true) + '~r~n'
						End IF
						ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
						ls_comment = ''
					End IF					
					la_return [add_line] += ls_line + '~r~n'
					ls_line = ''
					add_line ++
					la_return [add_line] = '     , '
					lb_0space = TRUE
				CASE 'AS'
					ls_line += ' [SPACEAS-' + string(gl_select_step) + ']AS '
					ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
					lb_0space = TRUE
				CASE '+','-','/','||'
					IF	lm_first	Then
						ls_line += '[SPACE^]' + ra_word [lm] + ' '
					Else
						la_return [add_line] += ls_line
						la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' ' + ra_word [lm] + ' '
						ls_line = ''
					End IF
					lb_0space = true
					lm_first = false
					CONTINUE
				CASE '*'
					IF	lm_first	Then
						ls_line += '[SPACE^]' + ra_word [lm] + ' '
					Else
						IF	POS (ls_line,'SELECT')>0 OR POS (ls_line,'DISTINCT')>0 OR POS (ls_line,'COUNT')>0	Then
							ls_temp = ls_line
							IF	RIGHT (ls_temp,2)='~r~n' THEN ls_temp = LEFT (ls_temp, LEN (ls_temp) - 2)
							IF	POS(ls_temp,'SELECT')>0 OR POS (ls_line,'DISTINCT')>0	Then
								ls_line = RIGHTTRIM (ls_temp) + ' * '
							ElseIF POS (ls_temp,'COUNT')>0	Then
								ls_line = RIGHTTRIM (ls_temp) + '*'
							ElseIF RIGHT(TRIM (ls_temp),1)='.'	Then
								ls_line = RIGHTTRIM (ls_temp) + '* '
							Else
								ls_line += ra_word [lm] + ' '
							End IF
						Else
							ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
						End IF
					End IF
					lb_0space = true
					lm_first = false
					CONTINUE
				CASE ELSE
					IF	LEFT (ra_word [lm],9)='[SPACEAS-'	Then
						ls_line += ' ' + ra_word [lm] + ' '
						ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
						lb_0space = TRUE
					Else
						IF	lm_first And ra_word [lm]<>','	Then
							ls_line += '       '
						Else
							ls_line += IIF (lm_first,'[SPACE^]','')
						End IF
						ls_line += ra_word [lm]
					End IF
			END CHOOSE
			IF	f_notnull (ra_word [lm]) THEN lm_first = FALSE
		NEXT
		IF	RIGHT (lower (la_return [add_line]),8)='select~r~n'	Then
			IF	NOT (LEFT (TRIM(ls_line),1)=',' OR LEFT (TRIM(ls_line),4)='INTO' OR LEFT (TRIM(ls_line),4)='FROM')	Then
				la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2) + ' '
			End IF
		End IF
		IF	lb_select	Then
			IF	lb_order And ll<=ll_select	Then
				// 컬럼순번 확인 routine
				FOR  lo = ll + 1  TO  ll_select
					IF	f_null (la_select [lo]) THEN CONTINUE
					lm_word = rt_line (la_select [lo], ra_word)
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_select [ll]),2))	Then
						wf_line_comment (la_select, ll_select, lo, false)
						CONTINUE
					End IF
					IF	LEFT (TRIM (la_select [lo]),1)=',' OR LEFT (TRIM (lower (la_select [lo])),5)='into ' OR LEFT (TRIM (lower (la_select [lo])),5)='from ' &
																	  OR lower (TRIM (la_select [lo]))='into' OR lower (TRIM (la_select [lo]))='from'	Then
						ll_column ++
						ls_line = wf_add_comment_num (ls_line, ls_comment, ll_column, true) ; ls_comment = ''
						ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
					End IF
					EXIT
				NEXT
				lm_word = rt_line (la_select [ll], ra_word)
			End IF
			IF	nf_comp ({'+','-','|','/','(',')'}, LEFT (TRIM (ls_line),1)) THEN ls_line = IIF (lb_first, '[SPACE^]', '') + ls_line
			IF	RIGHT (RIGHTTRIM (ls_line),1)=','	Then
				la_return [add_line] += RIGHTTRIM (ls_line) + ' '
			Else
				IF	RIGHT (TRIM (ls_line),8)='DISTINCT'	Then
					la_return [add_line] += RIGHTTRIM (ls_line) + ' '
				Else
					la_return [add_line] += RIGHTTRIM (ls_line) + '~r~n'
				End IF
			End IF
		Else
			la_return [add_line] += ls_line + '~r~n' + ls_spaceasclear
			ls_spaceasclear = ''
		End IF
		IF	ll>ll_select THEN EXIT	// 중간에서 처리한 부분 반영
		ls_line = ''
	End IF

	IF	lb_into	Then	// INTO
		IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
		lm_word = rt_line (la_select [ll], ra_word)
		lm_first = TRUE; lb_0space = FALSE
		FOR  lm = lm  TO  lm_word
			IF	ra_word [lm]='' THEN CONTINUE
			IF	f_null (ra_word [lm])	Then
				IF	lm_first OR lb_0space THEN CONTINUE
				IF	NOT lm_first And LEFT (ra_word [lm],1)=' '	Then
					ls_line += ' '
					CONTINUE
				End IF
			End IF
			IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
				ls_comment = nf_add_comment (ls_comment, ra_word [lm])
				CONTINUE
			End IF

			lb_0space = FALSE
			CHOOSE CASE UPPER (ra_word [lm])
				CASE 'FROM'
					lb_into   = false
					lb_from   = TRUE
					lb_where  = false
					lb_by     = false
					la_return [add_line] += ls_line + ls_spaceasclear
					ls_spaceasclear = ''
					ls_line = ''
					EXIT
				CASE 'INTO'
					la_return [add_line] += ls_line ; ls_line = ''
					IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
					la_return [add_line] += '  INTO '
					lb_0space = TRUE
				CASE 'STRICT'
					IF	f_null (ls_line)	Then
						la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' STRICT '
						lb_0space = TRUE
					Else
						ls_line += ra_word [lm]
					End IF
				CASE ','
					IF	f_notnull (ls_comment)	Then
						IF	RIGHT (la_return [add_line],2)='~r~n' THEN la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2)
						IF	lb_order	Then
							ll_column ++
							ls_line = wf_add_comment_num (ls_line, ls_comment, ll_column, true) + '~r~n'
						Else
							ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true) + '~r~n'
						End IF
						ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
						ls_comment = ''
					End IF
					IF	NOT lm_first And f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
					la_return [add_line] += ls_line
					ls_line = ''
					add_line ++
					la_return [add_line] = '     , '
					lb_0space = TRUE
				CASE ELSE
					ls_line += IIF (lm_first,'[SPACE^]','')
					IF	nf_comp ({'+','-','*','/','||'}, ra_word [lm])	Then
						ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
						lb_0space = TRUE
					Else
						ls_line += ra_word [lm]
					End IF
					lb_0space = TRUE
			END CHOOSE
			lm_first = FALSE
		NEXT
		IF	lb_into And (f_notnull (ls_comment) OR lb_order)	Then
			IF	lb_order	Then
				ll_column ++
				ls_line = wf_add_comment_num (ls_line, ls_comment, ll_column, true)
			Else
				ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
			End IF
			ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
			ls_comment = ''
		End IF

		la_return [add_line] += RIGHTTRIM (ls_line) ; ls_line = ''
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		IF	lb_into THEN lm = 1
	End IF

	IF lb_from	Then	// FROM
		IF	f_notnull (ls_spaceasclear)	Then
			la_return [add_line] += ls_spaceasclear
			ls_spaceasclear = ''
		End IF
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		add_line ++ ; la_return [add_line] = ''
		ls_line += '  FROM '
		FOR  ll = ll  TO  ll_select
			yield ()
			IF	f_null (la_select [ll]) THEN CONTINUE
			// xml
			IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_select [ll]),2)) Then
				IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
				ls_line_comment += wf_line_comment (la_select, ll_select, ll, false)
				lm = 0
				CONTINUE
			End IF
			IF	f_notnull (ls_line_comment)	Then
				IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
				la_return [add_line] += ls_line_comment ; ls_line_comment = ''
			End IF

			lm_word = rt_line (la_select [ll], ra_word)
			lw_col = 0; lb_exit = FALSE
			lm_first = true
			FOR  lm = lm + 1  TO  lm_word
				IF	f_null (ra_word [lm]) THEN CONTINUE
				IF	LEFT (ra_word [lm],6)='[SPACE'	then
					CONTINUE
				ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
					ls_comment = nf_add_comment (ls_comment, ra_word [lm])
					CONTINUE
				End IF
				CHOOSE CASE UPPER (ra_word [lm])
					CASE ';'
						lb_from  = false
						lb_where = false
						lb_by    = false
						lb_exit = TRUE
						EXIT
					CASE 'WHERE','START WITH'
						lb_from  = false
						lb_where = TRUE
						lb_by    = false
						lb_exit = TRUE
						EXIT
					CASE 'GROUP BY','ORDER BY','HAVING','CONNECT BY','CONNECT BY PRIOR','CONNECT BY LEVEL','CONNECT BY NOCYCLE'
						lb_from  = false
						lb_where = false
						lb_by    = true
						lb_exit = TRUE
						EXIT
					CASE 'PIVOT','UNPIVOT'
						ls_pivot = '~r~n' + UPPER (ra_word [lm])
						lb_from_pivot = TRUE
						lb_exit  = true
						EXIT
					CASE 'UNION','MINUS'
						lb_from  = false
						lb_where = false
						lb_union = TRUE
						lb_exit = TRUE
						EXIT
					CASE 'AS'
						lm_first = false
						CONTINUE
					CASE 'DUAL'
						lm_first = false
						la_return [add_line] += ls_line + 'DUAL'
						ls_line = ''
						lw_col ++; ll_alias ++
						la_table [ll_alias]      = 'DUAL'
						la_join_table [ll_alias] = 'N'
						la_alias [ll_alias]      = 'dual'
						add_where.corp_gr [ll_alias] = false
						CONTINUE
					CASE 'TABLE'
						lm_first = false
						ra_word [lm] = UPPER (ra_word [lm])
						la_return [add_line] += ls_line + 'TABLE'
						in_bracket = 0; ls_line = ''
						FOR  ll = ll  TO  ll_select
							IF	f_null (la_select [ll]) THEN CONTINUE
							lm_word = rt_line (la_select [ll], ra_word)
							FOR  lm = lm + 1  TO  lm_word
								ls_line += nf_1space (ra_word [lm])
								CHOOSE CASE ra_word [lm]
									CASE '('
										in_bracket ++
									CASE ')'
										in_bracket --
										IF	in_bracket=0 THEN EXIT
								END CHOOSE
							NEXT
							IF	in_bracket=0 THEN EXIT
							IF	RIGHT (ls_line,1)<>' ' THEN ls_line += ' '
							lm = 0
						NEXT
						ll_alias ++ ; lw_col = 1
						la_table [ll_alias]      = 'bracket' + string(ll_alias)
						la_join_table [ll_alias] = 'N'
						la_alias [ll_alias]      = 'auto' + string(ll_alias)
						add_where.corp_gr [ll_alias] = false
						IF	ll>ll_select THEN EXIT
						CONTINUE
					CASE '('
						IF	lm_first And lower (TRIM (ls_line))='from' THEN 
							ls_line = '  FROM '
						Else
							IF	RIGHT (ls_line,2)='~r~n' THEN ls_line = LEFT (ls_line, LEN (ls_line) - 2)
						End IF
						la_return [add_line] += ls_line + '(' ; ls_line = ''
						pivot = nf_bracket_pivot (la_select, ll_select, ll, lm)
						IF	POS (pivot.text,'[SELECT-')>0 THEN la_return [add_line] += ' '
						ls_space = wf_bracket_space (la_return [add_line])
						ll = pivot.ll
						lm = pivot.lm
						from_exit = false
						IF	f_null (pivot.pivot)	Then	// pivot
							ls_temp = wf_bracket (pivot.text)
							la_return [add_line] += wf_move (ls_temp, LEN (ls_space), false) + ')'
							ll_alias ++ ; lw_col = 1
							la_table [ll_alias]      = 'bracket' + string(ll_alias)
							la_join_table [ll_alias] = 'N'
							la_alias [ll_alias]      = 'auto' + string(ll_alias)
							add_where.corp_gr [ll_alias] = false
							FOR  ll = ll  TO  ll_select
								lm_word = rt_line (la_select [ll], ra_word)
								FOR  lm = lm + 1  TO  lm_word
									CHOOSE CASE UPPER (ra_word [lm])
										CASE 'WHERE','START WITH','GROUP BY','ORDER BY','HAVING','CONNECT BY','CONNECT BY PRIOR','CONNECT BY LEVEL','CONNECT BY NOCYCLE','PIVOT','UNPIVOT','UNION','MINUS', &
											  'FULL OUTER JOIN','RIGHT OUTER JOIN','RIGHT JOIN','LEFT OUTER JOIN','LEFT JOIN','INNER JOIN','CROSS JOIN','JOIN', ','
											lm --
											from_exit = true
											EXIT
										CASE ELSE
											IF	f_notnull (ra_word [lm])	Then
												ls_line = RIGHTTRIM (ls_line) + ' '
												la_alias [ll_alias] = lower (ra_word [lm])
												IF	LenA (ra_word [lm])=1	Then
													ls_line += ia [gl_select_step] + string(ASC (UPPER (la_alias [ll_alias])) - 64)
												Else
													ls_line += la_alias [ll_alias]
												End IF
												from_exit = true
												EXIT
											End IF
									END CHOOSE
								NEXT
								IF	from_exit THEN EXIT
								IF	RIGHT (ls_line,1)<>' ' THEN ls_line += ' '
								lm = 0
							NEXT
						Else
							la_return [add_line] += wf_move (pivot.text, LEN (ls_space), false) + ')'
							la_return [add_line] += '~r~n'
						End IF
						IF	ll>ll_select THEN EXIT
						CONTINUE
					CASE 'FULL OUTER JOIN','RIGHT OUTER JOIN','RIGHT JOIN','LEFT OUTER JOIN','LEFT JOIN','INNER JOIN','CROSS JOIN','JOIN'
						lm_first = false
						// outer join 수정 발생시 And 조건 복사내용중 첫번째 on 처리
						IF	(ll + 1)<=ll_select	Then
							IF	POS (lower (la_select [ll]),'on')=0 And LEFT (lower (TRIM (la_select [ll + 1])),3)='and' &
							   THEN la_select [ll + 1] = f_replace1 (la_select [ll + 1],'and','on')
						End IF
						IF	f_notnull (ls_comment)	Then
							ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
							ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
							ls_comment = ''
						End IF
						IF	POS (ra_word [lm],' ')=5	Then
							ls_line += '~r~n  ' + ra_word [lm] + ' '
						Else
							ls_line += '~r~n ' + ra_word [lm] + ' '
						End IF
						la_return [add_line] += ls_line
						ls_line = ''

						lb_join_exit = false
						lw_col = 0
						FOR  ll = ll  TO  ll_select
							yield ()
							lm_word = rt_line (la_select [ll], ra_word)
							FOR  lm = lm + 1  TO  lm_word
								IF	f_null (ra_word [lm]) THEN CONTINUE
								IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
									ls_comment = nf_add_comment (ls_comment, ra_word [lm])
									CONTINUE
								End IF
								CHOOSE CASE lower (ra_word [lm])
									CASE 'as'
										CONTINUE
									CASE 'table'
										in_bracket = 0
										ls_line += UPPER (ra_word [lm])
										FOR  ll = ll  TO  ll_select
											IF	f_null (la_select [ll]) THEN CONTINUE
											lm_word = rt_line (la_select [ll], ra_word)
											FOR  lm = lm + 1  TO  lm_word
												ls_line += nf_1space (ra_word [lm])
												CHOOSE CASE ra_word [lm]
													CASE '('
														in_bracket ++
													CASE ')'
														in_bracket --
														IF	in_bracket=0 THEN EXIT
												END CHOOSE
											NEXT
											IF	in_bracket=0 THEN EXIT
											IF	RIGHT (ls_line,1)<>' ' THEN ls_line += ' '
											lm = 0
										NEXT
										ll_alias ++ ; lw_col = 1
										la_table [ll_alias]      = 'bracket'
										la_join_table [ll_alias] = 'Y'
										la_alias [ll_alias]      = 'auto' + string(ll_alias)
										add_where.corp_gr [ll_alias] = false
										IF	ll>ll_select THEN EXIT
										CONTINUE
									CASE '('
										la_return [add_line] += ls_line + '(' ; ls_line = ''
										pivot = nf_bracket_pivot (la_select, ll_select, ll, lm)
										IF	LEFT (pivot.text,8)='[SELECT-' THEN la_return [add_line] += ' '
										ls_space = wf_bracket_space (la_return [add_line])
										ls_temp = wf_bracket (pivot.text)
										la_return [add_line] += wf_move (ls_temp, LEN (ls_space), false) + ')'
										ll = pivot.ll
										lm = pivot.lm
										IF	ll>ll_select THEN EXIT
										lm_word = rt_line (la_select [ll], ra_word)	// 변경된 ll 반영

										ll_alias ++ ; lw_col = 1
										la_table [ll_alias]      = 'bracket' + string(ll_alias)
										la_join_table [ll_alias] = 'Y'
										la_alias [ll_alias]      = 'auto' + string(ll_alias)
										add_where.corp_gr [ll_alias] = false
										CONTINUE
									CASE 'on'
										IF	RIGHT (ls_line,2)='~r~n' THEN ls_line = LEFT (ls_line, LEN (ls_line) - 2)
										IF	ll_alias>0	Then
											IF	(LEFT (la_alias [ll_alias],4)='auto' OR LEFT (la_alias [ll_alias],7)='bracket')	Then
												la_alias [ll_alias] = ia [gl_select_step] + string(ll_alias)
												ls_line += ' ' + la_alias [ll_alias]
											End IF
										End IF
										la_return [add_line] += ls_line + '  ON '
										ls_line = ''
										FOR  ll = ll  TO  ll_select
											// xml
											IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_select [ll]),2)) Then
												IF	f_notnull (la_return [add_line]) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
												ls_line += wf_line_comment (la_select, ll_select, ll, false)
												lm = 0
												CONTINUE
											End IF
											lm_word = rt_line (la_select [ll], ra_word)
											lm_first = TRUE
											FOR  lm = lm + 1  TO  lm_word
												IF	ra_word [lm]='' OR (lm_first And f_null (ra_word [lm])) THEN CONTINUE
												lm_first = false
												IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
													ls_comment = nf_add_comment (ls_comment, ra_word [lm])
													CONTINUE
												End IF
												CHOOSE CASE lower (ra_word [lm])
													CASE 'where'
														lb_from  = false
														lb_where = TRUE
														lb_by    = false
														lb_exit  = TRUE
														EXIT
													CASE 'group by','order by','having'
														lb_from  = false
														lb_where = false
														lb_by    = true
														lb_exit = TRUE
														EXIT
													CASE ',','full outer join','right outer join','right join','left outer join','left join','inner join','cross join','join'
														lm --
														lb_join_exit = true
														EXIT
													CASE '('
														pivot = nf_bracket_pivot (la_select, ll_select, ll, lm)
														IF	LEFT (pivot.text,4)='CASE'	Then
															// on where 조건에 있는 case에 ( )가 없는 경우 wf_on_where 에서 ( ) 추가 하므로 
															ls_line += wf_on_where (pivot.text, la_alias [ll_alias])
														Else
															IF	LEFT (pivot.text,8)='[SELECT-'	Then
																pivot.text = '( ' + pivot.text + ' )'
															Else
																IF	RIGHT (pivot.text,2)='~r~n' THEN pivot.text = LEFT (pivot.text, LEN (pivot.text) - 2)
																pivot.text = '(' + pivot.text + ')'
															End IF
															ls_line += wf_on_where (pivot.text, la_alias [ll_alias])
														End IF
														ll = pivot.ll
														lm = pivot.lm
														IF	ll>ll_select THEN EXIT
														lm_word = rt_line (la_select [ll], ra_word)	// 변경된 ll 반영
													CASE ELSE
														ls_line += ra_word [lm]
												END CHOOSE
											NEXT
											IF	lb_join_exit OR lb_exit	Then
												ls_space = wf_bracket_space (la_return [add_line])
												IF	LEFT (ls_line,1)='('	Then
													la_return [add_line] += wf_move (ls_line, LenA (ls_space) - 6, false)
												Else
													ls_temp = wf_on_where (ls_line, la_alias [ll_alias])
													la_return [add_line] += wf_move (ls_temp, LenA (ls_space) - 7, false)
												End IF
												ls_line = ''
												EXIT
											End IF
											IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
											lm =0
										NEXT
										IF	f_notnull (ls_line)	Then
											ls_space = wf_bracket_space (la_return [add_line])
											IF	LEFT (ls_line,1)='('	Then
												la_return [add_line] += wf_move (ls_line, LenA (ls_space) - 6, false)
											Else
												ls_temp = wf_on_where (ls_line, la_alias [ll_alias])
												la_return [add_line] += wf_move (ls_temp, LenA (ls_space) - 7, false)
											End IF
											ls_line = ''
										End IF
										IF	f_notnull (ls_comment)	Then
											ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
											ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
											ls_comment = ''
										End IF
										EXIT
								END CHOOSE
								lw_col ++
								CHOOSE CASE lw_col
									CASE 1
										ll_alias ++
										ls_temp = ra_word [lm]
										IF	f_notnull (is_asis_table) And RIGHT (UPPER (ra_word [lm]),LEN (is_asis_table))=is_asis_table	Then
											ls_line += is_tobe_table + ' '
											ls_comment = nf_add_comment (ls_comment, is_asis_table + ' --> ' + is_tobe_write)
										Else
											IF	POS (ls_temp,'.')>0	Then
												IF	MID (ls_temp,2,1)='{'	Then
													ls_temp = MID (ls_temp,3)
													ls_temp = f_replace (ls_temp,'}.','.')
												End IF
											End IF
											IF	POS (ls_temp,'}')>0	Then
												ls_temp = lower (LEFT (ls_temp,LASTPOS (ls_temp,'}'))) + UPPER (MID (ls_temp,LASTPOS (ls_temp,'}') + 1))
											Else
												ls_temp = UPPER (ls_temp)
												la_table [ll_alias] = ls_temp
											End IF
											ls_line += ls_temp + ' '
										End IF
										la_table [ll_alias]      = ls_temp
										la_join_table [ll_alias] = 'Y'
										add_where.corp_gr [ll_alias] = false
										la_alias [ll_alias] = 'auto' + string(ll_alias)
									CASE 2
										ls_line = RIGHTTRIM (ls_line) + ' '
										la_alias [ll_alias] = lower (ra_word [lm])
										IF	LenA (la_alias [ll_alias] )=1	Then
											ls_line += ia [gl_select_step] + string(ASC (UPPER (la_alias [ll_alias] )) - 64)
										Else
											ls_line += la_alias [ll_alias] 
										End IF
									CASE ELSE
										ls_line += ra_word [lm]
								END CHOOSE
								IF	LEFT (la_alias [ll_alias],4)='auto' OR LEFT (la_alias [ll_alias],7)='bracket'	Then
									IF	POS (lower (ra_word [lm]),'corp_gr')>0 THEN add_where.corp_gr [ll_alias] = false
								Else
									IF	POS (lower (ra_word [lm]),lower (la_alias [ll_alias]+'.corp_gr'))>0 THEN add_where.corp_gr [ll_alias] = false
								End IF
							NEXT
							IF	lb_join_exit OR lb_exit THEN EXIT
							lm = 0
						NEXT
						IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
						lw_col = 0
						IF	lb_exit OR ll>ll_select	Then
							lb_exit = true
							EXIT
						End IF
						CONTINUE
					CASE ','
						IF	ll_alias>0 And (LEFT (la_alias [ll_alias],4)='auto' OR LEFT (la_alias [ll_alias],7)='bracket')	Then
							la_alias [ll_alias] = ia [gl_select_step] + string(ll_alias)
							ls_line += ' ' + la_alias [ll_alias]
						End IF
						IF	f_notnull (ls_comment)	Then
							ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
							ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
							ls_comment = ''
						End IF
						lw_col = 0
						ls_line += '~r~n     , '
						CONTINUE
					CASE ELSE
						lm_first = false
				END CHOOSE
				lw_col ++
				CHOOSE CASE lw_col
					CASE 1
						ll_alias ++
						ls_temp = ra_word [lm]
						IF	f_notnull (is_asis_table) And RIGHT (UPPER (ra_word [lm]),LEN (is_asis_table))=is_asis_table	Then
							ls_line += is_tobe_table + ' '
							ls_comment = nf_add_comment (ls_comment, is_asis_table + ' --> ' + is_tobe_write)
						Else
							IF	POS (ls_temp,'.')>0	Then
								IF	MID (ls_temp,2,1)='{'	Then
									ls_temp = MID (ls_temp,3)
									ls_temp = f_replace (ls_temp,'}.','.')
								End IF
							End IF
							IF	POS (ls_temp,'}')>0	Then
								ls_temp = lower (LEFT (ls_temp,LASTPOS (ls_temp,'}'))) + UPPER (MID (ls_temp,LASTPOS (ls_temp,'}') + 1))
							Else
								ls_temp = UPPER (ls_temp)
							End IF
							ls_line += ls_temp + ' '
						End IF
						la_table [ll_alias] = ls_temp
						la_join_table [ll_alias] = 'N'
						la_alias [ll_alias]      = 'auto' + string(ll_alias)

						// 조건에 반드시 포함되어야 할 컬럼
						add_where.corp_gr [ll_alias] = false
					CASE 2
						ls_line = RIGHTTRIM (ls_line) + ' '
						la_alias [ll_alias] = lower (ra_word [lm])
						IF	LenA (ra_word [lm])=1	Then
							ls_line += ia [gl_select_step] + string(ASC (UPPER (la_alias [ll_alias])) - 64)
						Else
							ls_line += la_alias [ll_alias]
						End IF
					CASE ELSE
						ls_line += ra_word [lm]
				END CHOOSE
			NEXT
			IF	ll_alias>0	Then
				IF	RIGHT (ls_line,2)='~r~n' THEN ls_line = LEFT (ls_line, LEN (ls_line) - 2)
				IF	ll_alias>0 And (LEFT (la_alias [ll_alias],4)='auto' OR LEFT (la_alias [ll_alias],7)='bracket')	Then
					la_alias [ll_alias] = ia [gl_select_step] + string(ll_alias)
					ls_line = RIGHTTRIM (ls_line) + ' ' + la_alias [ll_alias]
				End IF
			End IF
			IF	f_notnull (ls_comment)	Then
				ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
				ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
				ls_comment = ''
			End IF
			IF	lb_exit OR ll>ll_select	Then
				la_return [add_line] += ls_line
				ls_line = ''
				EXIT
			End IF
			la_return [add_line] += ls_line ; ls_line = ''
			IF	lb_from	Then
				IF	NOT (lm_first And RIGHT (TRIM (la_return [add_line]),1)=',')	Then
					IF	RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
				End IF
				lm = 0
			Else
				la_return [add_line] += '~r~n'
			End IF
		NEXT
		IF	ll>ll_select THEN EXIT	// 중간에서 처리한 부분 반영
	End IF

	IF lb_from_pivot	Then	// PIVOT,UNPIVOT
		in_bracket = 0 ; lb_pivot = FALSE ; lb_pivot_in = FALSE
		FOR  ll = ll  TO  ll_select
			yield ()
			IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_select [ll]),2)) Then
				IF	f_notnull (ls_pivot) And RIGHT (ls_pivot,2)<>'~r~n' THEN ls_pivot += '~r~n'
				ls_pivot += wf_line_comment (la_select, ll_select, ll, false)
				lm = 1
				CONTINUE
			End IF
			IF	f_notnull (ls_line_comment)	Then
				IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
				la_return [add_line] += ls_line_comment ; ls_line_comment = ''
			End IF

			lm_word = rt_line (la_select [ll], ra_word)
			FOR  lm = lm  TO  lm_word
				IF	ra_word [lm]='' THEN CONTINUE
				IF	f_null (ra_word [lm]) And LEFT (ra_word [lm],1)=' ' THEN ra_word [lm] = ' '
				CHOOSE CASE lower (ra_word [lm])
					CASE 'pivot','unpivot'
						lb_pivot = TRUE
						FOR  lm = lm + 1  TO  lm_word
							IF	f_null (ra_word [lm]) And LEFT (ra_word [lm],1)=' ' THEN ra_word [lm] = ' '
							IF	ra_word [lm]='('	Then
								in_bracket ++
								EXIT
							End IF
							ls_pivot += UPPER (ra_word [lm])
						NEXT
						EXIT
					CASE '('
						IF	lb_pivot THEN in_bracket ++
					CASE ')'
						IF	lb_pivot THEN in_bracket --
					CASE 'for','as'
						ls_pivot = RIGHTTRIM (ls_pivot) + ' ' + UPPER (ra_word [lm])
						CONTINUE
					CASE 'in'
						ls_pivot = RIGHTTRIM (ls_pivot) + ' IN'
						lb_pivot_in = TRUE
						CONTINUE
				END CHOOSE
				IF	lb_pivot	Then
					IF	in_bracket=0 THEN EXIT
					ls_pivot += ra_word [lm]
				End IF
			NEXT
			IF	in_bracket=0 And lb_pivot THEN EXIT
			IF	RIGHT (ls_pivot,1)<>' ' THEN ls_pivot += ' '
			IF	lb_pivot	Then
				IF	LEFT (TRIM (la_select [MIN (ll + 1,ll_select)]),1)=')' THEN ls_pivot += ' ' ELSE ls_pivot += '~r~n[SELECTSPACE-' + string(gl_select_step) + ']' + IIF (lb_pivot_in,' [SPACE^]','')
			End IF
			lm = 1
		NEXT
		la_return [add_line] += RIGHTTRIM (ls_pivot) + ' )'
		IF	ll>ll_select THEN EXIT
		lb_select = TRUE
		lb_into   = false
		lb_union  = false
		lb_from   = false
		lb_where  = false
		lb_by     = false
		lb_from_pivot = false
		CONTINUE
	End IF

	IF lb_where	Then	// WHERE
		IF	RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		add_line ++ ; la_return [add_line] = ''
		IF	ll_alias>1	Then
			ll_table = 0
			FOR  lt = 1  TO  ll_alias
				IF	POS (la_table [lt],'bracket')=0 And POS (la_table [lt],'DUAL')=0 And la_join_table [lt]='N' THEN ll_table = MAX (ll_table, LenA (la_table [lt]))
			NEXT
			IF	ll_table>0	Then
				ll_table += 1
				FOR  lt = 1  TO  ll_alias
					IF	POS (la_table [lt],'bracket')=0 And POS (la_table [lt],'DUAL')=0 And la_join_table [lt]='N'	Then
						FOR  ii = 1  TO  add_line
							la_return [ii] = f_replace1 (la_return [ii], la_table [lt] + ' ' + la_alias [lt], la_table [lt] + SPACE (ll_table - LenA (la_table [lt])) + la_alias [lt])
						NEXT
					End IF
				NEXT
			End IF
		End IF
		IF	f_notnull (ls_spaceasclear)	Then
			la_return [add_line] += ls_spaceasclear
			ls_spaceasclear = ''
		End IF
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'

		where_syntax = wf_dml_where (la_select, la_alias, la_table, la_join_table, add_where, ll_select, ll, lm)
		la_return [add_line] += where_syntax.text
		IF	POS (la_return [add_line],'[SPACE*')>0 THEN la_return [add_line] += '[SPACEASCLEAR-' + string(gl_select_step) + ']'
		ll       = where_syntax.ll
		lm       = where_syntax.lm
		lb_where = false
		lb_union = where_syntax.union
		lb_by    = where_syntax.by
		IF	ll>ll_select THEN EXIT
	End IF

	IF lb_by	Then	// group, order, having, connect
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		lb_exit = false ; ll_order_line = 1
		FOR  ll_order = 1  TO  15
			la_order [ll_order_line].p[ll_order] = ''
		NEXT
		ll_order = 0
		FOR  ll = ll  TO  ll_select
			IF	f_null (la_select [ll]) THEN CONTINUE
			yield ()
			IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_select [ll]),2)) Then
				IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
				ls_line_comment += wf_line_comment (la_select, ll_select, ll, false)
				lm = 1
				CONTINUE
			End IF
			IF	f_notnull (ls_line_comment)	Then
				IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
				la_return [add_line] += ls_line_comment ; ls_line_comment = ''
			End IF

			lm_word = rt_line (la_select [ll], ra_word)
			lm_first = TRUE ; lb_0space = FALSE
			FOR  lm = lm  TO  lm_word
				IF	ra_word [lm]='' THEN CONTINUE
				IF	f_null (ra_word [lm])	Then
					IF	lm_first OR lb_0space THEN CONTINUE
					IF	NOT lm_first And LEFT (ra_word [lm],1)=' '	Then
						ls_line += ' '
						CONTINUE
					End IF
				End IF
				IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
					ls_comment = nf_add_comment (ls_comment, ra_word [lm])
					CONTINUE
				End IF
				lb_0space = FALSE
				CHOOSE CASE UPPER (ra_word [lm])
					CASE 'UNION','MINUS','WITH'
						IF	f_notnull (ls_line)	Then
							la_order [ll_order_line].p[ll_order + 1] = TRIM (ls_line)
							ll_order = 0
						End IF
						ls_line = ''
						lb_union = TRUE
						lb_exit = TRUE
						EXIT
					CASE 'OFFSET','FETCH'
						ls_fetch = ' '
						FOR  ll = ll  TO  ll_select
							IF	f_null (la_select [ll]) THEN CONTINUE
							lm_word = rt_line (la_select [ll], ra_word)
							FOR  lm = lm  TO  lm_word
								ls_fetch += nf_1space (ra_word [lm])
								IF ra_word [lm]='ONLY'	Then
									lb_exit = true
									EXIT
								End IF
							NEXT
							IF	lb_exit THEN EXIT
							lm = 1
						NEXT
						EXIT
					CASE 'CASE','DECODE'
						ls_temp = ra_word [lm]
						IF	lower (ra_word [lm])='case'	Then
							in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
						Else
							in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
						End IF
						FOR  ll = ll  TO  ll_select
							IF	f_null (la_select [ll]) THEN CONTINUE
							lm_word = rt_line (la_select [ll], ra_word)
							FOR  lm = lm + 1  TO  lm_word
								IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
									ls_temp += wf_add_comment_num ('', nf_add_comment ('', ra_word [lm]), 0, false)
									CONTINUE
								End IF
								ls_temp += ra_word [lm]
								CHOOSE CASE lower (ra_word [lm])
									CASE ls_start
										in_bracket ++
									CASE ls_end
										in_bracket --
										IF	in_bracket=0 THEN EXIT
								END CHOOSE
							NEXT
							IF	in_bracket=0 THEN EXIT
							IF	f_notnull (la_return [add_line]) And RIGHT (ls_temp,2)<>'~r~n' THEN ls_temp += '~r~n'
							lm = 0
						NEXT
						IF	ls_start='case'	Then
							ls_temp = wf_case (ls_temp)
						Else
							ls_temp = nf_decode (ls_temp)
						End IF
						ls_space = wf_bracket_space (ls_line)
						ls_line += wf_dml (ls_temp, ls_space)
						IF	ll>ll_select THEN EXIT
						CONTINUE
					CASE 'GROUP BY','ORDER BY','HAVING','CONNECT BY','CONNECT BY PRIOR','CONNECT BY LEVEL','CONNECT BY NOCYCLE'
						IF	ll_order_line>1 OR ll_order>0	Then
							la_return [add_line] += ls_order
							IF	ls_order<>' HAVING '	Then
								// order by 위치별 크기계산
								FOR  ly = 1  TO  15
									lMax [ly] = 0
									FOR  lx = 1  TO  ll_order_line
										IF	f_null (la_order [lx].p[ly]) THEN EXIT
										IF	POS (la_order [lx].p[ly],'~r~n')=0 And (POS (la_order [lx].p[ly],',')=0 OR POS (la_order [lx].p[ly],',')=LASTPOS (la_order [lx].p[ly],','))	Then
											IF	LEFT (la_order [lx].p[ly],3)<>'NVL' And LEFT (la_order [lx].p[ly],6)<>'SUBSTR' And POS (la_order [lx].p[ly],' + ')=0 And POS (la_order [lx].p[ly],' - ')=0 And &
											   POS (la_order [lx].p[ly],' * ')=0 And POS (la_order [lx].p[ly],' / ')=0 THEN lMax [ly] = MAX (lMax [ly], LenA (la_order [lx].p[ly]))
										End IF
									NEXT
								NEXT
								FOR  ly = 1  TO  15
									IF	lMax [ly]=0 THEN CONTINUE
									FOR  lx = 1  TO  ll_order_line
										IF	f_null (la_order [lx].p[ly]) THEN EXIT
										IF	lMax [ly]>LenA (la_order [lx].p[ly]) THEN la_order [lx].p[ly] = LEFT (la_order [lx].p[ly] + SPACE (lMax [ly]), lMax [ly])
									NEXT
								NEXT
							End IF
							FOR  lx = 1  TO  ll_order_line
								FOR  ly = 1  TO  15
									IF	f_null (la_order [lx].p[ly]) THEN EXIT
									IF	ly>1 And ls_order<>' HAVING ' THEN la_return [add_line] += ', '
									IF	POS (la_order [lx].p[ly],'~r~n')=0	Then
										la_return [add_line] += la_order [lx].p[ly]
									Else
										ls_space = wf_bracket_space (la_return [add_line])
										la_return [add_line] += wf_move (la_order [lx].p[ly], LEN (ls_space), false)
									End IF
								NEXT
								IF	f_null (la_order [lx + 1].p[1]) THEN EXIT
								IF	ls_order=' HAVING '	Then
									la_return [add_line] += '~r~n' + SPACE (8)
								Else
									la_return [add_line] += '~r~n        , '
								End IF
							NEXT
							IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
							la_order = la_null
						End IF
						ls_order = ' ' + UPPER (ra_word [lm]) + ' '
						ll_order_line = 1
						FOR  ll_order = 1  TO  15
							la_order [ll_order_line].p[ll_order] = ''
						NEXT
						ll_order = 0
						lb_0space = TRUE
					CASE 'DESC','ASC'
						ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm]
					CASE 'AND','OR'
						IF	ls_order=' HAVING ' And f_notnull (ls_line)	Then
							ll_order ++
							la_order [ll_order_line].p[ll_order] = ls_line
							ls_line = UPPER (ra_word [lm])
						Else
							ls_line = RIGHTTRIM (ls_line) + ' ' + UPPER (ra_word [lm])
						End IF
					CASE '=','!=','!~~','<=','>=','<','>','<>','<![cdata[<=]]>','<![cdata[>=]]>','<![cdata[<]]>','<![cdata[>]]>','<![cdata[<>]]>', &
						  'in','not in','is null','is not null','like','not like','regexp_like','not regexp_like','exists','not exists'
						ls_line = RIGHTTRIM (ls_line) + ' ' + UPPER (ra_word [lm]) + ' '
						lb_0space = TRUE
					CASE ','
						IF	f_notnull (ls_line)	Then
							ll_order ++
							la_order [ll_order_line].p[ll_order] = RIGHTTRIM (ls_line)
						End IF
						ls_line = ''
						lb_0space = TRUE
					CASE '('
						ls_space = wf_bracket_space (ls_line) + ' '
						pivot = nf_bracket_pivot (la_select, ll_select, ll, lm)
						ls_temp = wf_bracket (pivot.text)
						ls_line += '(' + wf_move (ls_temp, LEN (ls_space), false) + ') '
						ll = pivot.ll
						lm = pivot.lm
						IF	ll>ll_select THEN EXIT
						lm_word = rt_line (la_select [ll], ra_word)	// 변경된 ll 반영
						lb_0space = TRUE
						CONTINUE
					CASE ELSE
						IF	lm_first THEN ls_line = RIGHTTRIM (ls_line) + SPACE (9)
						ls_line += nf_1space (ra_word [lm])
				END CHOOSE
				IF	f_notnull (ra_word [lm]) THEN lm_first = FALSE
			NEXT
			IF	f_notnull (ls_comment)	then
				ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
				ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
				ls_comment = ''
			End IF
			IF	f_notnull (ls_line)	Then
				ll_order ++
				la_order [ll_order_line].p[ll_order] = RIGHTTRIM (ls_line)
			End IF
			IF	ll_order>0 THEN ll_order_line ++
			FOR  ll_order = 1  TO  15
				la_order [ll_order_line].p[ll_order] = ''
			NEXT
			ls_line = '' ; ll_order = 0
			IF	lb_exit OR ll>ll_select THEN EXIT
			lm = 1
		NEXT
		IF	f_notnull (ls_comment)	then
			la_return [add_line] = wf_add_comment_num (la_return [add_line], ls_comment, 0, true)
			ls_spaceasclear = '[SPACEASCLEAR-' + string(gl_select_step) + ']'
			ls_comment = ''
		End IF
		la_return [add_line] = RIGHTTRIM (la_return [add_line])
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'

		la_return [add_line] += ls_order
		IF	ls_order<>' HAVING '	Then
			// order by 위치별 크기계산
			FOR  ly = 1  TO  15
				lMax [ly] = 0
				FOR  lx = 1  TO  ll_order_line
					IF	f_null (la_order [lx].p[ly]) THEN EXIT
					IF	POS (la_order [lx].p[ly],'~r~n')=0 And (POS (la_order [lx].p[ly],',')=0 OR POS (la_order [lx].p[ly],',')=LASTPOS (la_order [lx].p[ly],','))	Then
						IF	LEFT (la_order [lx].p[ly],3)<>'NVL' And LEFT (la_order [lx].p[ly],6)<>'SUBSTR' And POS (la_order [lx].p[ly],' + ')=0 And POS (la_order [lx].p[ly],' - ')=0 And &
						   POS (la_order [lx].p[ly],' * ')=0 And POS (la_order [lx].p[ly],' / ')=0 THEN lMax [ly] = MAX (lMax [ly], LenA (la_order [lx].p[ly]))
					End IF
				NEXT
			NEXT
			FOR  ly = 1  TO  15
				IF	lMax [ly]=0 THEN CONTINUE
				FOR  lx = 1  TO  ll_order_line
					IF	f_null (la_order [lx].p[ly]) THEN EXIT
					IF	lMax [ly]>LenA (la_order [lx].p[ly]) THEN la_order [lx].p[ly] = LEFT (la_order [lx].p[ly] + SPACE (lMax [ly]), lMax [ly])
				NEXT
			NEXT
		End IF
		FOR  lx = 1  TO  ll_order_line
			FOR  ly = 1  TO  15
				IF	f_null (la_order [lx].p[ly]) THEN EXIT
				IF	ly>1 And ls_order<>' HAVING ' THEN la_return [add_line] += ', '
				IF	POS (la_order [lx].p[ly],'~r~n')=0	Then
					la_return [add_line] += la_order [lx].p[ly]
				Else
					ls_space = wf_bracket_space (la_return [add_line])
					la_return [add_line] += wf_move (la_order [lx].p[ly], LEN (ls_space), false)
				End IF
			NEXT
			IF	f_null (la_order [lx + 1].p[1]) THEN EXIT
			IF	ls_order=' HAVING '	Then
				la_return [add_line] += '~r~n' + SPACE (8)
			Else
				la_return [add_line] += '~r~n        , '
			End IF
		NEXT
		IF	f_notnull (ls_fetch) THEN la_return [add_line] += '~r~n' + ls_fetch + '~r~n'
		lb_select = TRUE
		lb_by = FALSE
		IF	ll>ll_select THEN EXIT
	End IF

	IF	lb_union	Then
		ls_return = ''
		FOR  ii = 1  TO  add_line
			IF	la_return [ii]>'' THEN ls_return += la_return [ii]
		NEXT
		ls_return = wf_dml (ls_return, '')

		// alias.+TABLE. 처리 20240309
		FOR  lt = 1  TO  ll_alias
			yield ()
			IF	POS (la_table [lt],'.')>0 THEN la_table [lt] = MID (la_table [lt], POS (la_table [lt],'.') + 1)
			// 기존 1자리 영문자를 2자리 치환시 중복발생으로 기존영문을 숫자로 변환
			IF	LenA (la_alias [lt])=1	Then
				ls_temp = ia [gl_select_step] + string(ASC (UPPER (la_alias [lt])) - 64)
				ls_return = f_replace1 (ls_return, la_alias [lt] + '.', ls_temp + '.')
				la_alias [lt] = ls_temp
			End IF
		NEXT
		la_return = {ls_return} ; add_line = 1

		// UNION 처리
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		ls_union_select = ''
		FOR  ll = ll  TO  ll_select
			yield ()
			IF	f_null (la_select [ll]) THEN CONTINUE
			// xml
			IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_select [ll]),2)) Then
				ls_line_comment = wf_line_comment (la_select, ll_select, ll, false)
				CONTINUE
			End IF
			lm_word = rt_line (la_select [ll], ra_word)
			FOR  lm = lm  TO  lm_word
				IF	ra_word [lm]='' THEN CONTINUE
				CHOOSE CASE ra_word [lm]
					CASE 'SELECT'
						la_return [add_line] = RIGHTTRIM (la_return [add_line])
						IF	RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
						IF	f_notnull (ls_line_comment)	Then
							IF	lm=1	Then
								ll_move_back = 0
								la_return [add_line] += ls_line_comment
							Else
								ll_move_back = LEN (ra_word [1])
								la_return [add_line] += wf_move_back (ls_line_comment, ll_move_back)
							End IF
							ls_line_comment = ''
						End IF
						add_line ++ ; la_return [add_line] = ''
						ls_union_select = 'SELECT'
						CONTINUE
					CASE '('
						in_bracket = 0
						FOR  ll = ll  TO  ll_select
							IF	f_null (la_select [ll]) THEN CONTINUE
							lm_word = rt_line (la_select [ll], ra_word)
							FOR  lm = lm  TO  lm_word
								ls_union_select += ra_word [lm]
								CHOOSE CASE ra_word [lm]
									CASE '('
										in_bracket ++
									CASE ')'
										in_bracket --
										IF	in_bracket=0 THEN EXIT
								END CHOOSE
							NEXT
							IF	in_bracket=0 THEN EXIT
							ls_union_select += '~r~n'
							lm = 1
						NEXT
						IF	ll>ll_select THEN EXIT
						CONTINUE
					CASE 'CASE'
						in_bracket = 0
						FOR  ll = ll  TO  ll_select
							IF	f_null (la_select [ll]) THEN CONTINUE
							lm_word = rt_line (la_select [ll], ra_word)
							FOR  lm = lm  TO  lm_word
								ls_union_select += ra_word [lm]
								CHOOSE CASE ra_word [lm]
									CASE 'CASE'
										in_bracket ++
									CASE 'END'
										in_bracket --
										IF	in_bracket=0 THEN EXIT
								END CHOOSE
							NEXT
							IF	in_bracket=0 THEN EXIT
							ls_union_select += '~r~n'
							lm = 1
						NEXT
						IF	ll>ll_select THEN EXIT
						CONTINUE
					CASE 'UNION','MINUS'
						IF	f_notnull (ls_union_select)	Then
							gl_select_step ++
							la_return [add_line] += wf_dml_select (ls_union_select) + '~r~n'
							gl_select_step --
							add_line ++ ; la_return [add_line] = ''
							ls_union_select = ''
						End IF
				END CHOOSE
				IF	f_null (ls_union_select)	then
					la_return [add_line] += ra_word [lm]
				Else
					ls_union_select += ra_word [lm]
				End IF
			NEXT
			IF	f_null (ls_union_select)	then
				la_return [add_line] += '~r~n'
			Else
				ls_union_select += '~r~n'
			End IF
			lm = 1
		NEXT
		IF	f_notnull (ls_union_select)	Then
			gl_select_step ++
			la_return [add_line] += wf_dml_select (ls_union_select)
			gl_select_step --
		End IF
		EXIT	// union 이후 끝까지 wf_dml_select에 넘기므로 여기서는 빠짐
	End IF
NEXT

IF f_notnull (ls_spaceasclear) THEN la_return [add_line] += ls_spaceasclear

IF	NOT lb_union	Then
	// alias.+TABLE. 처리 20240309
	FOR  lt = 1  TO  ll_alias
		yield ()
		IF	POS (la_table [lt],'.')>0 THEN la_table [lt] = MID (la_table [lt], POS (la_table [lt],'.') + 1)
		// 기존 1자리 영문자를 2자리 치환시 중복발생으로 기존영문을 숫자로 변환
		IF	LenA (la_alias [lt])=1	Then
			ls_temp = ia [gl_select_step] + string(ASC (UPPER (la_alias [lt])) - 64)
			FOR  ii = 1  TO  add_line
				la_return [ii] = f_replace1 (la_return [ii], la_alias [lt] + '.', ls_temp + '.')
			NEXT
			la_alias [lt] = ls_temp
		End IF
	NEXT
End IF

ls_return = ''
FOR  ii = 1  TO  add_line
	IF	la_return [ii]>'' THEN ls_return += la_return [ii]
NEXT
IF	POS (ls_return,'[SPACE')>0 THEN ls_return = wf_dml (ls_return, '')

IF	NOT lb_union	Then
	IF LEN (ls_return)<99 And POS (ls_return,' AS ')=0 And POS (ls_return,'CASE')=0 And POS (ls_return,'WHERE')=0 And POS (ls_return,'CONNECT')=0 And POS (ls_return,'[SELECT')=0	Then
		ll_select = f_get_array (ls_return, '~r~n', la_select)
		ls_return = ''
		FOR  ll = 1  TO  ll_select
			lm_word = rt_line (la_select [ll], ra_word)
			FOR  lm = 1  TO  lm_word
				CHOOSE CASE ra_word [lm]
					CASE 'UNION','MINUS'
						ls_return += '~r~n' + ra_word [lm]
					CASE '('
						pivot = nf_bracket_pivot (la_select, ll_select, ll, lm)
						ls_return += '(' + pivot.text + ')'
						ll = pivot.ll
						lm = pivot.lm						
					CASE ','
						ls_return = RIGHTTRIM (ls_return) + ra_word [lm]
					CASE ELSE
						IF	f_null (ra_word [lm])	Then
							ls_return = RIGHTTRIM (ls_return) + ' '
						Else
							ls_return += ra_word [lm]
						End IF
				END CHOOSE
			NEXT
			ls_return = RIGHTTRIM (ls_return) + ' '
		NEXT
		ls_return = nf_clear (ls_return)
	End IF
End IF

ls_return = RIGHTTRIM (ls_return)
IF	RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)

gl_select_step --

RETURN	ls_return
end function

public function string wf_on_where (string arg_text, string arg_alias);S_RET	pivot

S_WHERE	la_where []

STRING	ls_return, ls_temp, ls_start, ls_end, ls_line_comment
STRINg	la_with [], ra_word []

BOOLEAN	lb_first, lb_between_exit, lb_0space

LONG	ll, lm, lw, ll_with, lMax, lw_col, lm_word, in_bracket

ll_with = f_get_array (arg_text, '~r~n', la_with)

lMax = 4
lw = 1 ; lw_col = 1
la_where [lw].w1 = ''
la_where [lw].w2 = ''
la_where [lw].w3 = ''
la_where [lw].w4 = 'AND'
la_where [lw].w5 = ''
la_where [lw].w6 = ''
FOR  ll = 1  TO  ll_with
	IF	f_null (la_with [ll]) THEN CONTINUE
	IF	nf_comp ({'--','//','/*','<!'},  LEFT (TRIM (la_with [ll]),2)) Then
		IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
		ls_line_comment += wf_line_comment (la_with, ll_with, ll, false)
		lm = 0
		CONTINUE
	End IF
	lm_word = rt_line (la_with [ll], ra_word)
	lb_first = TRUE
	FOR  lm = 1  TO  lm_word
		IF	f_null (ra_word [lm]) THEN CONTINUE
		IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
			la_where [lw].w5 = nf_add_comment (la_where [lw].w5, ra_word [lm])
			CONTINUE
		End IF
		CHOOSE CASE lower (ra_word [lm])
			CASE 'and','or'
				lw ++; lw_col = 1
				la_where [lw].w1 = ''
				la_where [lw].w2 = ''
				la_where [lw].w3 = ''
				la_where [lw].w4 = lower (ra_word [lm])
				la_where [lw].w5 = ''
				la_where [lw].w6 = ''
				// 조건에 OR 만 있는 경우 처리는 위해
				// OR 와 AND 가 병행되어 있을때는 ( ) 처리를 해야 하므로
				IF	lower (ra_word [lm])='or' And la_where [1].w4='and' THEN la_where [1].w4 = 'or'
			CASE 'case','decode'
				ls_temp = ra_word [lm]
				IF	lower (ra_word [lm])='case'	Then
					in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  ll_with
					IF	f_null (la_with [ll]) THEN CONTINUE
					lm_word = rt_line (la_with [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_temp += wf_add_comment_num ('', nf_add_comment ('', ra_word [lm]), 0, false)
							CONTINUE
						End IF
						ls_temp += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								in_bracket ++
							CASE ls_end
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_bracket=0 THEN EXIT
					ls_temp += '~r~n'
					lm = 0
				NEXT
				IF	ls_start='case'	Then
					IF	lw_col=1	Then
						la_where [lw].w1 += wf_case (ls_temp)
					Else
						la_where [lw].w3 += wf_case (ls_temp)
					End IF
				Else
					IF	lw_col=1	Then
						la_where [lw].w1 += nf_decode (ls_temp)
					Else
						la_where [lw].w3 += nf_decode (ls_temp)
					End IF
				End IF
				IF	ll>ll_with THEN EXIT
			CASE 'between','not between'
				la_where [lw].w6 = 'change'
				IF	lower (ra_word [lm])='between'	Then
					la_where [lw].w2 += 'Between'
				Else
					la_where [lw].w2 += 'NOT Between'
				End IF
				lw_col = 3
				lb_between_exit = FALSE
				FOR  ll = ll  TO  ll_with
					lm_word = rt_line (la_with [ll], ra_word)
					lb_0space = false
					FOR  lm = lm + 1  TO  lm_word
						IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
						lb_0space = false
						CHOOSE CASE lower (ra_word [lm])
							CASE 'case','decode'
								ls_temp = ra_word [lm]
								IF	lower (ra_word [lm])='case'	Then
									in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
								Else
									in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
								End IF
								FOR  ll = ll  TO  ll_with
									IF	f_null (la_with [ll]) THEN CONTINUE
									lm_word = rt_line (la_with [ll], ra_word)
									FOR  lm = lm + 1  TO  lm_word
										IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
											ls_temp += wf_add_comment_num ('', nf_add_comment ('', ra_word [lm]), 0, false)
											CONTINUE
										End IF
										ls_temp += ra_word [lm]
										CHOOSE CASE lower (ra_word [lm])
											CASE ls_start
												in_bracket ++
											CASE ls_end
												in_bracket --
												IF	in_bracket=0 THEN EXIT
										END CHOOSE
									NEXT
									IF	in_bracket=0 THEN EXIT
									ls_temp += '~r~n'
									lm = 0
								NEXT
								IF	ls_start='case'	Then
									la_where [lw].w3 += wf_case (ls_temp)
								Else
									la_where [lw].w3 += nf_decode (ls_temp)
								End IF
							CASE 'and'
								la_where [lw].w3 += 'And '
								lb_between_exit = TRUE
							CASE '+','-','/','||'
                        la_where [lw].w3 = RIGHTTRIM (la_where [lw].w3) + ' ' + ra_word [lm] + ' '
								lb_0space = true
							CASE ELSE
								IF	f_null (la_where [lw].w3)	Then
									la_where [lw].w3 = nf_1space (ra_word [lm])
								Else
									la_where [lw].w3 += nf_1space (ra_word [lm])
								End IF
						END CHOOSE
						IF	lb_between_exit THEN EXIT
					NEXT
					IF	lb_between_exit THEN EXIT
					la_where [lw].w3 += '~r~n'
				NEXT
				IF	ll>ll_with THEN EXIT
			CASE '=','!=','!~~','<=','>=','<','>','<>','<![cdata[<=]]>','<![cdata[>=]]>','<![cdata[<]]>','<![cdata[>]]>','<![cdata[<>]]>', &
				  'in','not in','is null','is not null','like','not like','regexp_like','not regexp_like','exists','not exists','not between'
				IF	nf_comp ({'exists','not exists','regexp_like','not regexp_like'}, ra_word [lm])	Then
					la_where [lw].w6 = 'change'
					la_where [lw].w1 = ra_word [lm]
					la_where [lw].w2 = ra_word [lm]
				Else
					IF	nf_comp ({'in','not in','null','is not null','like','not like'}, ra_word [lm]) THEN la_where [lw].w6 = 'change'
					la_where [lw].w2 += ra_word [lm]
				End IF
				lw_col = 3
			CASE '('
				IF	lw_col=1	Then
					IF	f_nvl (la_where [lw].w1,'(')<>'(' And lb_first THEN la_where [lw].w1 += '~r~n'
				Else
					IF	f_nvl (la_where [lw].w3,'(')<>'(' And lb_first THEN la_where [lw].w3 += '~r~n'
				End IF
				pivot = nf_bracket_pivot (la_with, ll_with, ll, lm)
				ls_temp = wf_in (' ' + la_where [lw].w2 + ' ' + la_where [lw].w3, pivot.text)
				ls_temp = '(' + wf_move (ls_temp, 1, false) + ') '
				IF	lw_col=1	Then
					la_where [lw].w1 += ls_temp
				Else
					la_where [lw].w3 += ls_temp
				End IF
				ll = pivot.ll ; lm = pivot.lm
				IF	ll>ll_with THEN EXIT
				lm_word = rt_line (la_with [ll], ra_word)	// 변경된 ll 반영
			CASE '+','-','*','/','^','**','||'
				IF	lm>1	Then
					IF	f_null (ra_word [lm - 1])	Then
						IF	lw_col=1	Then
							la_where [lw].w1 += ' ' + ra_word [lm] + ' '
						Else
							la_where [lw].w3 += ' ' + ra_word [lm] + ' '
						End IF
						CONTINUE
					End IF
				End IF
				IF	lm + 1<=lm_word	Then
					IF	lw_col=1	Then
						IF	f_null (ra_word [lm + 1])	Then
							la_where [lw].w1 += ' ' + ra_word [lm] + ' '
						Else
							la_where [lw].w1 += ra_word [lm]
						End IF
					Else
						IF	f_null (ra_word [lm + 1])	Then
							la_where [lw].w3 += ' ' + ra_word [lm] + ' '
						Else
							la_where [lw].w3 += ra_word [lm]
						End IF
					End IF
				Else
					IF	lw_col=1	Then
						la_where [lw].w1 += ra_word [lm]
					Else
						la_where [lw].w3 += ra_word [lm]
					End IF
				End IF
			CASE ELSE
				IF	lw_col=1	Then
					la_where [lw].w1 += ra_word [lm]
				Else
					la_where [lw].w3 += ra_word [lm]
				End IF
		END CHOOSE
		IF	f_notnull (ra_word [lm]) THEN lb_first = FALSE
	NEXT
	ls_temp = f_replace (la_where [lw].w1,'(+)','') ; ls_temp = lower (ls_temp)
   IF POS (ls_temp,'~r~n')=0	Then
		IF	(POS (ls_temp,',')=0 OR (POS (ls_temp,',')=LASTPOS (ls_temp,',')) OR POS (ls_temp,'substr')>0) And &
	      POS (ls_temp,'-')=0 And POS (ls_temp,'/')=0 And POS (ls_temp,'*')=0 And POS (ls_temp,' and ')=0 AND POS (ls_temp,' or ')=0 Then
         lMax = MAX (lMax, LenA (nf_clear (la_where [lw].w1)))
		End IF
   END IF
	IF	lw_col=1	Then
		IF	f_notnull (la_where [lw].w1) And RIGHT (la_where [lw].w1,2)<>'~r~n' THEN la_where [lw].w1 += '~r~n'
	Else
		IF	f_notnull (la_where [lw].w3) And RIGHT (la_where [lw].w3,2)<>'~r~n' THEN la_where [lw].w3 += '~r~n'
	End IF
	IF	LEFT (la_where [lw].w1,4)='CASE' THEN la_where [lw].w1 = '(' + la_where [lw].w1 + ')'
	IF	LEFT (la_where [lw].w3,4)='CASE' THEN la_where [lw].w3 = '(' + la_where [lw].w3 + ')'
	lm =0
NEXT

FOR  ll = 1  TO  lw
	IF	la_where [ll].w6='change' THEN CONTINUE
	IF	POS (lower (la_where [ll].w1), lower (arg_alias) + '.')>0 OR f_null (la_where [ll].w3)	Then
		// pass
	ElseIF POS (lower (la_where [ll].w3), lower (arg_alias) + '.')>0 And POS (la_where [ll].w3,'.')=LASTPOS (la_where [ll].w3,'.')	Then
		CHOOSE CASE la_where [ll].w2
			CASE '<'
				la_where [ll].w2 = '>'
			CASE '>'
				la_where [ll].w2 = '<'
			CASE '<='
				la_where [ll].w2 = '>='
			CASE '>='
				la_where [ll].w2 = '<='
			CASE '<![CDATA[<]]>'
				la_where [ll].w2 = '<![CDATA[>]]>'
			CASE '<![CDATA[>]]>'
				la_where [ll].w2 = '<![CDATA[<]]>'
			CASE '<![CDATA[<=]]>'
				la_where [ll].w2 = '<![CDATA[>=]]>'
			CASE '<![CDATA[>=]]>'
				la_where [ll].w2 = '<![CDATA[<=]]>'
		END CHOOSE
		la_where [ll].w6 = la_where [ll].w3
		la_where [ll].w3 = la_where [ll].w1
		la_where [ll].w1 = la_where [ll].w6
		la_where [ll].w6 = 'change'
		IF	POS (ls_temp,'~r~n')=0 THEN lMax = MAX (lMax, LenA (nf_clear (ls_temp)))
	End IF
NEXT

lb_first = true
FOR  ll = 1  TO  UPPERBOUND (ia_order)
	FOR  lm = 1  TO  lw
		IF	f_null (la_where [lm].w1) THEN CONTINUE
		IF	POS (lower (la_where [lm].w1), lower (arg_alias + '.' + ia_order [ll]))>0	Then
			ls_temp = wf_dml_where_line (lmax, la_where [lm].w1, la_where [lm].w2, la_where [lm].w3, '', la_where [lm].w4, la_where [lm].w5, false)
			IF	lb_first	THEN ls_temp = MID (ls_temp, 8)
			ls_return += ls_temp
			la_where [lm].w1 = ''
			lb_first = false
		End IF
	NEXT
NEXT
FOR  ll = 1  TO  lw
	IF	f_null (la_where [ll].w1)	THEN CONTINUE
	ls_temp = wf_dml_where_line (lmax, la_where [ll].w1, la_where [ll].w2, la_where [ll].w3, '', la_where [ll].w4, la_where [ll].w5, false)
	IF	lb_first	THEN ls_temp = MID (ls_temp, 8)
	ls_return += ls_temp
	lb_first = false
NEXT
IF	RIGHT (ls_return,2)='~r~n' THEN LEFT (ls_return, LEN (ls_return) - 2)

IF	f_notnull (ls_line_comment)	Then
	IF	f_notnull (ls_return) And RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
	ls_return += wf_move (ls_line_comment, 0, true)
End IF

RETURN	ls_return
end function

public function string wf_bracket_comma (string arg_comma);BOOLEAN	lm_first, lb_0space
STRING	la_comma [], la_1 [], la_2 [], ra_word []
STRING	ls_start, ls_end, ls_return = '', ls_temp, ls_space

LONG	ll, lm, lm_word, ll_comma, ll_bracket, ll_line = 1

la_1 [ll_line] = ''
la_2 [ll_line] = ''

ll_comma = f_get_array (arg_comma, '~r~n', la_comma)

FOR  ll = 1  TO  ll_comma
	ls_temp = LEFTTRIM (la_comma [ll])
	IF	f_null (ls_temp) OR (nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (ls_temp),2))) THEN CONTINUE
	lm_word = rt_line (la_comma [ll], ra_word)
	lm_first = true
	FOR  lm = 1  TO  lm_word
		IF	f_null (ra_word [lm]) THEN CONTINUE
		IF	LEFT (ra_word [lm],2)='/*'	Then
			IF	LEFT (ra_word [lm],4)='/* _'	Then
				IF	POS (ra_word [lm],'-')>0	Then
					la_2 [ll_line] = f_replace (MID (ra_word [lm], POS (ra_word [lm],'-') + 1),'*/','')
				ElseIF POS (ra_word [lm],':')>0	Then
					la_2 [ll_line] = f_replace (MID (ra_word [lm], POS (ra_word [lm],':') + 1),'*/','')
				End IF
			Else
				la_2 [ll_line] = MID (ra_word [lm],3)
			End IF
			la_2 [ll_line] = f_replace (la_2 [ll_line], '*/', '')
			CONTINUE
		End IF
		CHOOSE CASE UPPER (ra_word [lm])
			CASE ','
				la_2 [ll_line] = '/* _' + string (ll_line) + '-' + TRIM (la_2 [ll_line]) + ' */'
				ll_line ++
				la_1 [ll_line] = ''
				la_2 [ll_line] = ''
			CASE 'DECODE','CASE'
				ls_temp = UPPER (ra_word [lm])
				IF	ls_temp='CASE'	Then
					ll_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					ll_bracket = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  ll_comma
					lm_word = rt_line (la_comma [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						IF	LEFT (ra_word [lm],2)='/*'	Then
							IF	LEFT (ra_word [lm],4)='/* _'	Then
								IF	POS (ra_word [lm],'-')>0	Then
									la_2 [ll_line] = f_replace (MID (ra_word [lm], POS (ra_word [lm],'-') + 1),'*/','')
								ElseIF POS (ra_word [lm],':')>0	Then
									la_2 [ll_line] = f_replace (MID (ra_word [lm], POS (ra_word [lm],':') + 1),'*/','')
								End IF
							Else
								la_2 [ll_line] = MID (ra_word [lm],3)
							End IF
							la_2 [ll_line] = f_replace (la_2 [ll_line], '*/', '')
							CONTINUE
						End IF
						ls_temp += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								ll_bracket ++
							CASE ls_end
								ll_bracket --
								IF	ll_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	ll_bracket=0 THEN EXIT
					ls_temp += '~r~n'
					lm = 0
				NEXT
				ls_space = wf_bracket_space (la_1 [ll_line]) + '  '
				IF	ls_start='case'	Then
					la_1 [ll_line] += wf_dml (wf_case (ls_temp), ls_space)
				Else
					la_1 [ll_line] += wf_dml (nf_decode (ls_temp), ls_space)
				End IF
				IF	ll>ll_comma THEN EXIT
			CASE '('
				ll_bracket = 0
				ls_temp = ''
				FOR  ll = ll  TO  ll_comma
					lm_word = rt_line (la_comma [ll], ra_word)
					lm_first = true
					lb_0space = false
					FOR  lm = lm  TO  lm_word
						IF	lb_0space And f_null (ra_word [lm]) THEN CONTINUE
						lb_0space = false
						IF	LEFT (ra_word [lm],2)='/*'	Then
							IF	LEFT (ra_word [lm],4)='/* _'	Then
								IF	POS (ra_word [lm],'-')>0	Then
									la_2 [ll_line] = f_replace (MID (ra_word [lm], POS (ra_word [lm],'-') + 1),'*/','')
								ElseIF POS (ra_word [lm],':')>0	Then
									la_2 [ll_line] = f_replace (MID (ra_word [lm], POS (ra_word [lm],':') + 1),'*/','')
								End IF
							Else
								la_2 [ll_line] = MID (ra_word [lm],3)
							End IF
							la_2 [ll_line] = f_replace (la_2 [ll_line], '*/', '')
							CONTINUE
						End IF
						CHOOSE CASE ra_word [lm]
							CASE '+','-','*','/','^','**','||'
								ls_temp = RIGHTTRIM (ls_temp)
								IF	lm_first	Then
									ls_temp += '[SPACE^]' + ra_word [lm] + ' '
								Else
									ls_temp += ' ' + ra_word [lm] + ' '
								End IF
								lb_0space = true
								CONTINUE
							CASE '('
								ll_bracket ++
							CASE ')'
								ll_bracket --
						END CHOOSE
						ls_temp += ra_word [lm]
						IF	ll_bracket=0 THEN EXIT
						IF	f_notnull (ra_word [lm]) THEN lm_first = false
					NEXT
					IF	ll_bracket=0 THEN EXIT
					ls_temp += '~r~n'
					lm = 1
				NEXT
				ls_space = wf_bracket_space (la_1 [ll_line]) + '  '
				la_1 [ll_line] += wf_dml (ls_temp, ls_space)
				IF	ll>ll_comma THEN EXIT
			CASE '+','-','*','/','^','**','||'
				la_1 [ll_line] = RIGHTTRIM (la_1 [ll_line])
				IF	lm_first	Then
					la_1 [ll_line] += '[SPACE^]' + ra_word [lm] + ' '
				Else
					la_1 [ll_line] += ' ' + ra_word [lm] + ' '
				End IF
			CASE ELSE
				la_1 [ll_line] += ra_word [lm]
		END CHOOSE
		IF	f_notnull (ra_word [lm]) THEN lm_first = false
	NEXT
	IF	ll<ll_comma	Then
		IF	LEFT (TRIM (la_comma [ll + 1]),1)<>',' And f_notnull (la_1 [ll_line]) THEN la_1 [ll_line] += '~r~n'
	End IF
NEXT
la_2 [ll_line] = '/* _' + string (ll_line) + '-' + TRIM (la_2 [ll_line]) + ' */'

FOR  ll = 1  TO  ll_line
	IF	RIGHT (la_1 [ll],2)='~r~n' THEN la_1 [ll] = LEFT (la_1 [ll], LEN (la_1 [ll]) - 2)
	ls_temp = la_1 [ll]
	IF	POS (ls_temp,'~r~n')>0 THEN ls_temp = MID (ls_temp, LASTPOS (ls_temp, '~r~n') + 2)
	ls_temp = wf_bracket_space (ls_temp)
	ls_return += IIF (ll=1,'  ',', ') + la_1 [ll] + ' [SPACE*1]' + la_2 [ll] + '~r~n'
NEXT
ls_return += '[SPACEASCLEAR-1]'
ls_return = TRIM (wf_dml (ls_return, SPACE (12))) + '~r~n'

RETURN	ls_return
end function

public function s_ret wf_func_str (string arg_text[], long arg_ll_text, long arg_ll, long arg_lm);S_RET pivot, in_pivot

LONG  ll, lm, lm_word, ls, in_bracket = 1, in_case, in_count, ll_over

BOOLEAN  lb_exit, lb_func = FALSE, lm_first, lb_0space

STRING   ls_text, ls_start, ls_end, ls_space, case_space, ls_case, ls_temp
STRING   ra_word []

ll = arg_ll
lm = arg_lm
pivot.text = ''

lm_word = rt_line (arg_text [ll], ra_word)
FOR  lm = lm  TO  lm_word
	IF	ra_word [lm]='' THEN CONTINUE
	IF	f_null (ra_word [lm]) And LeftA (ra_word [lm],1)=' ' THEN ra_word [lm] = ' '
	CHOOSE CASE UPPER (ra_word [lm])
		CASE 'COUNT'
			pivot.text += UPPER (ra_word [lm])
			in_count = 0
			FOR  lm = lm + 1  TO  lm_word
				IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
				lb_0space = false
				IF	ra_word [lm]='*'	Then
					pivot.text = RIGHTTRIM (pivot.text) + '*'
					lb_0space = true
					CONTINUE
				End IF
				pivot.text += nf_1space (ra_word [lm])
				CHOOSE CASE ra_word [lm]
					CASE '('
						in_count ++
					CASE ')'
						in_count --
						IF	in_count=0	Then
							pivot.func = true
							pivot.ll = ll
							pivot.lm = lm
							RETURN pivot
						End IF
				END CHOOSE
			NEXT
			EXIT
		CASE ELSE
			pivot.text += UPPER (ra_word [lm])
			IF	lower (ra_word [lm])='('	Then
				arg_lm = lm
				EXIT
			End IF
	END CHOOSE
NEXT
// 빈줄작업
ls_space = SPACE (6)
FOR  ls = 1  TO  arg_lm
	ls_space += SPACE (LenA (nf_clear (ra_word [ls])))
NEXT

// 분석함수인지 확인하기 위한 사전작업
FOR  ll = ll  TO  arg_ll_text
	lm_word = rt_line (arg_text [ll], ra_word)
	FOR  lm = lm + 1  TO  lm_word
		CHOOSE CASE ra_word [lm]
			CASE '('
				in_bracket ++
			CASE ')'
				in_bracket --
				IF	in_bracket=0 THEN EXIT
		END CHOOSE
	NEXT
	IF	in_bracket=0 THEN EXIT
	lm = 0
NEXT
lb_exit = FALSE
FOR  ll = ll  TO  arg_ll_text
	lm_word = rt_line (arg_text [ll], ra_word)
	FOR  lm = lm + 1  TO  lm_word
		IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2)) THEN CONTINUE
		CHOOSE CASE lower (ra_word [lm])
			CASE 'keep','within','over'
				lb_exit = TRUE
				lb_func = TRUE
				EXIT
			CASE ',','(',')','*','/','^','**','+','-','as'
				lb_exit = TRUE
				EXIT
		END CHOOSE
	NEXT
	IF	lb_exit THEN EXIT
	lm = 0
NEXT

ll = arg_ll
lm = arg_lm

IF	NOT lb_func	Then
	pivot.func = false
	pivot.ll = ll
	pivot.lm = lm
	RETURN pivot
End IF

in_bracket = 1
FOR  ll = ll  TO  arg_ll_text
	IF	f_null (arg_text [ll]) THEN CONTINUE
	lm_word = rt_line (arg_text [ll], ra_word)
	lm_first = TRUE
	FOR  lm = lm + 1  TO  lm_word
		IF	ra_word [lm]='' THEN CONTINUE
		IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2)) THEN EXIT
		CHOOSE CASE lower (ra_word [lm])
			CASE '('
				pivot.text += '('
				in_pivot = nf_bracket_pivot (arg_text, arg_ll_text, ll, lm)
				pivot.text += in_pivot.text + ')'
				ll = in_pivot.ll
				lm = in_pivot.lm
				IF	ll>arg_ll_text THEN EXIT
				lm_word = rt_line (arg_text [ll], ra_word)	// 변경된 ll 반영
				lm_first = FALSE
				CONTINUE
			CASE ')'
				in_bracket --
				IF	in_bracket=0	Then
					pivot.text += ')'
					EXIT
				End IF
			CASE 'case','decode'
				ls_text = ra_word [lm]
				IF	lower (ra_word [lm])='case'	Then
					in_case = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					in_case = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  arg_ll_text
					IF	f_null (arg_text [ll]) THEN CONTINUE
					lm_word = rt_line (arg_text [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						ls_text += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								in_case ++
							CASE ls_end
								in_case --
								IF	in_case=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_case=0 THEN EXIT
					ls_text += '~r~n'
					lm = 0
				NEXT
				IF	ls_start='case'	Then
					ls_case += wf_case (ls_text)
				Else
					ls_case += nf_decode (ls_text)
				End IF
				case_space = wf_bracket_space (pivot.text)
				pivot.text += wf_dml (ls_case, case_space)
				IF	ll>arg_ll_text THEN EXIT
				lm_first = FALSE
				CONTINUE
		END CHOOSE
		pivot.text += IIF (f_null (ra_word [lm]),' ',ra_word [lm])
		IF	f_notnull (ra_word [lm]) THEN lm_first = FALSE
	NEXT
	IF	in_bracket=0 THEN EXIT
	lm = 0
	pivot.text += '~r~n[SPACE^]'
NEXT

lb_exit = FALSE
FOR  ll = ll  TO  arg_ll_text
	IF	f_null (arg_text [ll]) THEN CONTINUE
	lm_word = rt_line (arg_text [ll], ra_word)
	FOR  lm = lm + 1  TO  lm_word
		IF	ra_word [lm]='' THEN CONTINUE
		CHOOSE CASE lower (ra_word [lm])
			CASE '('
				lb_exit = TRUE
				EXIT
			CASE 'keep','within','over'
				pivot.text = RIGHTTRIM (pivot.text) + ' ' + UPPER (ra_word [lm])
				FOR  ll = ll  TO  arg_ll_text
					IF	f_null (arg_text [ll]) THEN CONTINUE
					lm_word = rt_line (arg_text [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						IF	ra_word [lm] = '()'	Then
							pivot.text = RIGHTTRIM (pivot.text) + ' ()'
							pivot.ll = ll
							pivot.lm = lm
							pivot.func = true
							RETURN pivot
						Else
							IF	ra_word [lm]='('	Then
								pivot.text = RIGHTTRIM (pivot.text) + ' ('
								in_pivot = nf_bracket_pivot (arg_text, arg_ll_text, ll, lm)
								pivot.ll = in_pivot.ll
								pivot.lm = in_pivot.lm
								pivot.func = true
	
								ls_space = wf_bracket_space (pivot.text)
//								ls_temp = wf_bracket (in_pivot.text)
								pivot.text += wf_move (ls_temp, LEN (ls_space), false) + ')'
								RETURN pivot
							Else
								pivot.text += ra_word [lm]
							End IF
						End IF
					NEXT
					IF	f_notnull (pivot.text) And RIGHT (pivot.text,1)<>' ' THEN pivot.text += ' '
					lm = 0
				NEXT
				IF	ll>ll_over THEN EXIT
		END CHOOSE
		pivot.text += UPPER (nf_1space (ra_word [lm]))
	NEXT
	IF	lb_exit THEN EXIT
	lm = 0
	pivot.text += '~r~n' + ls_space
NEXT
pivot.text = RIGHTTRIM (pivot.text) + ' ('

in_bracket = 1
FOR  ll = ll  TO  arg_ll_text
	IF	f_null (arg_text [ll]) THEN CONTINUE
	lm_word = rt_line (arg_text [ll], ra_word)
	lm_first = true
	FOR  lm = lm + 1  TO  lm_word
		IF	ra_word [lm]='' THEN CONTINUE
		CHOOSE CASE lower (ra_word [lm])
			CASE '('
				in_bracket ++
			CASE ')'
				in_bracket --
				IF	in_bracket=0	Then
					pivot.text += ')'
					EXIT
				End IF
			CASE 'case','decode'
				ls_text = ra_word [lm]
				IF	lower (ra_word [lm])='case'	Then
					in_case = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					in_case = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  arg_ll_text
					IF	f_null (arg_text [ll]) THEN CONTINUE
					lm_word = rt_line (arg_text [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						ls_text += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								in_case ++
							CASE ls_end
								in_case --
								IF	in_case=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_case=0 THEN EXIT
					ls_text += '~r~n'
					lm = 0
				NEXT
				IF	ls_start='case'	Then
					pivot.text += wf_case (ls_text)
				Else
					pivot.text += nf_decode (ls_text)
				End IF
				lm_first = false
				IF	ll>arg_ll_text THEN EXIT
				CONTINUE
			CASE ','
				pivot.text += IIF (lm_first,'[SPACE^]','') + ','
				lm_first = false
				CONTINUE
		END CHOOSE
		pivot.text += nf_1space (ra_word [lm])
		IF	f_notnull (ra_word [lm]) THEN lm_first = false
	NEXT
	IF	in_bracket=0 THEN EXIT
	lm = 0
	pivot.text += '~r~n'
NEXT

IF	ll>arg_ll_text	Then
	pivot.ll = arg_ll_text
	pivot.lm = lm_word
Else
	pivot.ll = ll
	pivot.lm = lm
End IF
pivot.func = true

RETURN pivot
end function

public function long wt_line (string arg_line, ref string ra_word[]);STRING	ls_varTmp, la_clear [], ls_temp

LONG	ll, ll_line

ra_word = la_clear
ls_varTmp = arg_line

DO WHILE TRUE
	ll_line ++ ; ra_word [ll_line] = ''
	IF	LEFT (ls_varTmp, 1)=' '	Then
		DO WHILE TRUE
			ra_word [ll_line] += ' '
			ls_varTmp = MID (ls_varTmp, 2)
			IF	LEFT (ls_varTmp,1)<>' ' OR LEN (ls_varTmp)=0 THEN EXIT
		LOOP
	Else
		DO WHILE TRUE
			IF	nf_comp ({'*/',':=','>=','<=','<>','!=','!~~','||','**'}, LEFT (ls_varTmp,2))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 2)
				ls_varTmp = MID (ls_varTmp, 3)
				EXIT
			ElseIF LEFT (ls_varTmp, 1)="'"	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = "'"
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					IF	LEFT (ls_varTmp, 2)="''"	Then
						ra_word [ll_line] += "''"
						ls_varTmp = MID (ls_varTmp, 3)
					ElseIF LEFT (ls_varTmp, 1)="'"	Then
						ra_word [ll_line] += "'"
						ls_varTmp = MID (ls_varTmp, 2)
						EXIT
					Else
						ra_word [ll_line] += LEFT (ls_varTmp, 1)
						ls_varTmp = MID (ls_varTmp, 2)
					End IF
					IF	LEN (ls_varTmp)=0 THEN EXIT
				LOOP
				EXIT
			ElseIF LEFT (ls_varTmp, 1)='"'	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = '"'
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					IF	LEFT (ls_varTmp, 1)='"'	Then
						ra_word [ll_line] += '"'
						ls_varTmp = MID (ls_varTmp, 2)
						EXIT
					Else
						ra_word [ll_line] += LEFT (ls_varTmp, 1)
						ls_varTmp = MID (ls_varTmp, 2)
					End IF
					IF	LEN (ls_varTmp)=0 THEN EXIT
				LOOP
				EXIT
			ElseIF LEFT (ls_varTmp, 1)='['	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = '['
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					ra_word [ll_line] += LEFT (ls_varTmp, 1)
					IF	LEFT (ls_varTmp,1)=']'	Then
						ls_varTmp = MID (ls_varTmp, 2)
						EXIT
					End IF
					ls_varTmp = MID (ls_varTmp, 2)
					IF	LEN (ls_varTmp)=0 THEN EXIT
				LOOP
				EXIT
			ElseIF LEFT (ls_varTmp,1)='*'	Then
				IF	RIGHT (ra_word [ll_line],1)='.'	Then
					ra_word [ll_line] += '*'
				Else
					IF LEN (ra_word [ll_line])>0 THEN ll_line ++
					ra_word [ll_line] = LEFT (ls_varTmp, 1)
				End IF
				ls_varTmp = MID (ls_varTmp, 2)
				EXIT
			ElseIF nf_comp ({'+','-'}, LEFT (ls_varTmp,1))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 1)
				ls_varTmp = MID (ls_varTmp, 2)
				DO WHILE TRUE
					CHOOSE CASE LEFT (ls_varTmp, 1)
						CASE '0' TO '9','+','-','='
							ra_word [ll_line] += LEFT (ls_varTmp, 1)
							ls_varTmp = MID (ls_varTmp, 2)
							IF	LEN (ls_varTmp)=0 THEN EXIT
						CASE ELSE
							EXIT
					END CHOOSE
				LOOP
				EXIT
			ElseIF nf_comp ({'{','}','(',')',',','=','<','>','/','^',';','.','\'}  ,LEFT (ls_varTmp,1))	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 1)
				ls_varTmp = MID (ls_varTmp, 2)
				EXIT
			ElseIF LEFT (ls_varTmp, 2)='~r~n'	Then
				IF LEN (ra_word [ll_line])>0 THEN ll_line ++
				ra_word [ll_line] = LEFT (ls_varTmp, 2)
				ls_varTmp = MID (ls_varTmp, 3)
				EXIT
			Else
				ra_word [ll_line] += LEFT (ls_varTmp, 1)
				ls_varTmp = MID (ls_varTmp, 2)
				IF	LEFT (ls_varTmp,1)=' ' OR LEN (ls_varTmp)=0 THEN EXIT
			End IF
		LOOP
	End IF
	IF	LEN (ls_varTmp)=0  THEN EXIT
LOOP

RETURN	ll_line
end function

public function string wf_bracket (string arg_text);// 주석처리는 dml 또는 wf_1에서만

IF	arg_text='*' THEN RETURN arg_text

S_RET	pivot

BOOLEAN	lm_first, lb_0space

LONG	ll, lm, lm_word, ll_text, in_bracket

STRING	ls_case, ls_start, ls_end, ls_space, ls_dml
STRING	ls_return = '', ls_line = '', ls_line_comment = '', ls_comment = ''
STRING	la_text [], ra_word []

ll_text = f_get_array (arg_text, '~r~n', la_text)
FOR  ll = 1  TO  ll_text
	IF	f_null (la_text [ll]) THEN CONTINUE
	lm_word = rt_line (la_text [ll], ra_word)
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_text [ll]),2)) Then
		IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
		ls_line_comment += wf_line_comment (la_text, ll_text, ll, true)
		CONTINUE
	End IF
	IF	f_notnull (ls_line_comment)	Then
		ls_return += ls_line_comment
		ls_line_comment = ''
	End IF
	lm_first = true
	FOR  lm = 1  TO  lm_word
		IF	lb_0space And f_null (ra_word [lm]) THEN CONTINUE
		lb_0space = false
		IF	LEFT (ra_word [lm],3)='/*+'	Then
			IF	RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)
			ls_return = RIGHTTRIM (ls_return) + ' ' + ra_word [lm]
			CONTINUE
		ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
			ls_comment = nf_add_comment (ls_comment, ra_word [lm])
			CONTINUE
		End IF
		CHOOSE CASE lower (ra_word [lm])
			CASE 'select'
				IF	f_notnull (ls_comment)	Then
					ls_return = wf_add_comment_num (ls_return, ls_comment, 0, false) + '~r~n'
					ls_comment = ''
				End IF
				IF	f_notnull (ls_return) And RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
				ls_dml = ''
				FOR  ll = ll  TO  ll_text
					IF	lm=1	Then
						ls_dml += la_text [ll] + '~r~n'
					Else
						lm_word = rt_line (la_text [ll], ra_word)
						FOR  lm = lm  TO  lm_word
							ls_dml += ra_word [lm]
						NEXT
						ls_dml += '~r~n'
					End IF
					lm = 1
				NEXT
				ls_dml = wf_dml_select (ls_dml)
				gl_select ++
				ga_select [gl_select] = ls_dml
				ls_return += '[SELECT-' + string (gl_select) + ']'
				EXIT				
			CASE 'case','decode'
				ls_case = ra_word [lm]
				IF	lower (ra_word [lm])='case'	Then
					in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
				Else
					in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
				End IF
				FOR  ll = ll  TO  ll_text
					IF	f_null (la_text [ll]) THEN CONTINUE
					lm_word = rt_line (la_text [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						ls_case += ra_word [lm]
						CHOOSE CASE lower (ra_word [lm])
							CASE ls_start
								in_bracket ++
							CASE ls_end
								in_bracket --
								IF	in_bracket=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	in_bracket=0 THEN EXIT
					ls_case += '~r~n'
					lm = 0
				NEXT
				IF	ls_start='case'	Then
					ls_case = wf_case (ls_case)
				Else
					ls_case = nf_decode (ls_case)
				End IF
				ls_return += ls_line ; ls_line = ''
				ls_space = wf_bracket_space (ls_return)
				ls_return += wf_move (ls_case, LEN (ls_space), false)
				IF	ll>ll_text THEN EXIT
			CASE 'partition by'
				ls_return = RIGHTTRIM (ls_return)
				FOR  ll = ll  TO  ll_text
					IF	f_null (la_text [ll]) THEN CONTINUE
					lm_word = rt_line (la_text [ll], ra_word)
					lm_first = true
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]='ORDER BY' And lm_first	Then
							ls_return = RIGHTTRIM (ls_return) + '    ' + ra_word [lm]
							FOR  lm = lm + 1  TO  lm_word
								ls_return += nf_1space (ra_word [lm])
							NEXT
							EXIT
						ElseIF ra_word [lm]='CASE'	Then
							ls_case = ra_word [lm]
							IF	lower (ra_word [lm])='case'	Then
								in_bracket = 1 ; ls_start = 'case' ; ls_end = 'end'
							Else
								in_bracket = 0 ; ls_start = '(' ; ls_end = ')'
							End IF
							FOR  ll = ll  TO  ll_text
								IF	f_null (la_text [ll]) THEN CONTINUE
								lm_word = rt_line (la_text [ll], ra_word)
								FOR  lm = lm + 1  TO  lm_word
									ls_case += ra_word [lm]
									CHOOSE CASE lower (ra_word [lm])
										CASE ls_start
											in_bracket ++
										CASE ls_end
											in_bracket --
											IF	in_bracket=0 THEN EXIT
									END CHOOSE
								NEXT
								IF	in_bracket=0 THEN EXIT
								ls_case += '~r~n'
								lm = 0
							NEXT
							IF	ls_start='case'	Then
								ls_case = wf_case (ls_case)
							Else
								ls_case = nf_decode (ls_case)
							End IF
							ls_space = wf_bracket_space (ls_return)
							ls_return += wf_move (ls_case, LEN (ls_space), false)
							CONTINUE
						End IF
						IF	lm_first And ra_word [lm]=','	Then
							ls_return = RIGHTTRIM (ls_return) + SPACE (11) + ra_word [lm]
							IF	f_notnull (ra_word [lm + 1]) THEN ls_return += ' '
						Else
							ls_return += nf_1space (ra_word [lm])
						End IF
						IF	f_notnull (ra_word [lm]) THEN lm_first = false
					NEXT
					ls_return += '~r~n' + SPACE (11)
					lm = 1
				NEXT
				IF	RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)
				EXIT
			CASE 'listagg','keep','rank','dense_rank','percent_rank','row_number','round','sum','avg','max','min','count','first_value','last_value','ratio_to_report','lag','lead','exp','least','greatest'
				ra_word [lm] = UPPER (ra_word [lm])
				pivot = wf_func_str (la_text, ll_text, ll, lm)
				IF	pivot.func	Then
					ll = pivot.ll
					lm = pivot.lm
					ls_line += pivot.text
					IF	ll>ll_text THEN EXIT
					lm_word = rt_line (la_text [ll], ra_word)	// 변경된 ll 반영
				Else
					ls_line += ra_word [lm]
				End IF
			CASE '('
				ls_return += ls_line + '(' ; ls_line = ''
				pivot = nf_bracket_pivot (la_text, ll_text, ll, lm)
				IF	POS (pivot.text,'~r~n')>0	Then
					ls_space = wf_bracket_space (ls_return)
					ls_return += wf_move (pivot.text, LEN (ls_space), false)
				Else
					ls_return += pivot.text
				end IF
				ls_return += ')'
				ll = pivot.ll
				lm = pivot.lm
				IF	ll>ll_text THEN EXIT
				lm_word = rt_line (la_text [ll], ra_word)	// 변경된 ll 반영
			CASE '='
				IF	RIGHT (ls_line,1)=' ' And NOT lm_first	Then
					ls_line = RIGHTTRIM (ls_line) + ' '
					ls_line += ra_word [lm] + ' '
					lb_0space = TRUE
				Else
					ls_line += ra_word [lm]
				End IF
			CASE '+','-','*','/','**','<','>','<=','>=','<>','!=','!~~','<![cdata[<=]]>','<![cdata[>=]]>','<![cdata[<]]>','<![cdata[>]]>','<![cdata[<>]]>','||'
				IF	lm_first	Then
					ls_line = RIGHTTRIM (ls_line) + '[SPACE^]' + ra_word [lm] + ' '
				Else
					ls_line = RIGHTTRIM (ls_line) + ' ' + ra_word [lm] + ' '
				End IF
				lb_0space = TRUE
			CASE 'between'
				ls_line = RIGHTTRIM (ls_line) + ' Between '
				lb_0space = TRUE
			CASE 'and'
				ls_line = RIGHTTRIM (ls_line) + ' And '
				lb_0space = TRUE
			CASE 'or','in','not in','like','not like','regexp_like','not regexp_like','is null','is not null','not between','distinct','unique','exists','not exists'
				ls_line = RIGHTTRIM (ls_line) + ' ' + UPPER (ra_word [lm]) + ' '
				lb_0space = TRUE
			CASE ELSE
				ls_line += nf_1space (ra_word [lm])
		END CHOOSE
		IF	f_notnull (ra_word [lm]) THEN lm_first = false
	NEXT
	IF	f_notnull (ls_comment)	Then
		ls_line = wf_add_comment_num (ls_line, ls_comment, 0, false)
		ls_comment = ''
	End IF
	ls_return += ls_line + '~r~n'
	ls_line = ''
NEXT
IF	RIGHT (ls_return,2)='~r~n' THEN ls_return = TRIM (LEFT (ls_return, LEN (ls_return) - 2))

RETURN	RIGHTTRIM (ls_return)
end function

public function string wf_1 (string arg_text);S_RET	pivot

BOOLEAN	lm_first, lb_lm_first, lb_exit, lb_then, lb_exception, begin_exit, if_exit
BOOLEAN	lb_proc, lb_view, lb_0space, lb_space = true, lb_fetch, in_exit

INT	add_line, li_mapper
LONG	ll, lm, lm_word, lm_if, ll_source, ll_order, ll_for_loop, ll_if, ll_begin, func_begin
LONG	in_case, in_bracket, in_col = 0, ll_fetch, ll_fetch_max

STRING	la_source [], la_return [], ra_word [], ls_return, ls_in_func
STRING	ls_comment, ls_space, ls_dml, ls_lower, ls_temp, ls_begin, ls_mapper_file
STRING	ls_sql_comment = '', ls_line = '', ls_line_comment = '', ls_with_read = ''
STRING	begin_space [], for_space [], if_space [], la_fetch []

la_return = {''} ; add_line = UPPERBOUND (la_return)
ll_source = f_get_array (LEFTTRIM (arg_text),'~r~n',la_source)
FOR  ll = 1  TO  ll_source
	IF	f_null (la_source [ll])	Then
		la_return [add_line] += '~r~n'
		CONTINUE
	ElseIF TRIM (la_source [ll])='/'	Then
		IF f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		la_return [add_line] += '/'
		CONTINUE
	End IF
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		ls_temp = wf_line_comment (la_source, ll_source, ll, false)
		ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
		IF	ls_space>''	Then
			la_return [add_line] += wf_move_force (ls_temp, ls_space + '    ')
		Else
			la_return [add_line] += ls_temp
		End IF
		CONTINUE
	ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
		IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
		la_return [add_line] += la_source [ll] + '~r~n'
		CONTINUE
	ElseIF TRIM (lower (la_source [ll]))='declare'	Then
		la_return [add_line] = 'DECLARE~r~n'
		add_line ++ ; la_return [add_line] = ''
		CONTINUE
	ElseIF lower (LEFT (TRIM (la_source [ll]),6))='create'	Then
		IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
		lb_exit = false ; ls_line_comment = ''
		FOR  ll = ll  TO  ll_source
			// xml
			IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
				ls_line_comment += wf_line_comment (la_source, ll_source, ll, false)
				ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
				IF	ls_space>''	Then
					IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
					la_return [add_line] += wf_move_force (ls_line_comment, ls_space + '    ')
					ls_line_comment = ''
				End IF
				CONTINUE
			ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
				IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
				ls_line += la_source [ll] + '~r~n'
				CONTINUE
			End IF
			lm_word = rt_line (la_source [ll], ra_word)
			FOR  lm = 1  TO  lm_word
				IF	ra_word [lm]='' THEN CONTINUE
				CHOOSE CASE UPPER (ra_word [lm])
					CASE 'CREATE','OR','REPLACE'
						ls_line += UPPER (ra_word [lm])
					CASE 'PROCEDURE'
						ls_line += UPPER (ra_word [lm])
						lb_proc = TRUE
					CASE 'FUNCTION'
						ls_line += UPPER (ra_word [lm])
						lb_proc = FALSE
					CASE 'VIEW'
						ls_line += UPPER (ra_word [lm])
						lb_view = TRUE
					CASE 'IS','AS'
						la_return [add_line] += ls_line ; ls_line = ''
						IF	(lb_view OR POS (la_return [add_line],'(')=0) And f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
						ls_line += UPPER (ra_word [lm])
						IF	(lm + 1)<=lm_word	Then
							FOR  lm = lm + 1  TO  lm_word
								ls_line += nf_1space (ra_word [lm])
							NEXT
						end IF
						ls_line += '~r~n'
						IF	f_notnull (ls_line_comment)	Then
							ls_line += ls_line_comment
							ls_line_comment = ''
						End IF
						lb_exit = true
						EXIT
					CASE '('
						gl_select_step ++	// comment 위치처리를 위해
						la_return [add_line] += RIGHTTRIM (ls_line) + ' (' ; ls_line = '~r~n'
						in_bracket = 1; in_col = 0
						ls_line_comment = '' ; ls_comment = ''
						lb_lm_first = true
						FOR  ll = ll  TO  ll_source
							IF	f_null (la_source [ll]) THEN CONTINUE
							// xml
							IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
								ls_line_comment += wf_line_comment (la_source, ll_source, ll, false)
								lm = 0
								CONTINUE
							ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
								IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
								ls_line += la_source [ll] + '~r~n'
								lm = 0
								CONTINUE
							End IF
							lm_word = rt_line (la_source [ll], ra_word)
							lb_0space = true
							FOR  lm = lm + 1  TO  lm_word
								IF	ra_word [lm]='' OR ((in_col=0 OR lb_0space) And f_null (ra_word [lm])) THEN CONTINUE
								lb_0space = false
								IF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
									ls_comment = nf_add_comment (ls_comment, ra_word [lm])
									CONTINUE
								End IF
								CHOOSE CASE lower (ra_word [lm])
									CASE ','
										ls_line = RIGHTTRIM (ls_line) + ','
										in_col = 0
										CONTINUE
									CASE '('
										in_bracket ++
									CASE ')'
										in_bracket --
										IF	in_bracket=0 THEN EXIT
									CASE 'in','out','inout'
										ls_line += LEFT (UPPER (ra_word [lm]) + SPACE(5),6)
										lb_0space = true
										CONTINUE
									CASE 'default',':='
										FOR lm = lm TO  lm_word
											ls_line += nf_1space (ra_word [lm])
										NEXT
										EXIT
								END CHOOSE
								IF	in_col=0	Then
									IF	NOT lb_lm_first	Then
										IF	f_notnull (ls_comment) OR lb_view	Then
											IF	lb_view	Then
												ll_order ++
												ls_line = wf_add_comment_num (ls_line, ls_comment, ll_order, true)
											Else
												ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
											End IF
											ls_comment = ''
										End IF
										la_return [add_line] += ls_line
										ls_line = '~r~n'
									End IF
									in_col = 1
									IF	LenA (ra_word [lm])>30	Then
										ls_line += '    ' + ra_word [lm] + ' '
									Else
										ls_line += '    ' + LeftA (ra_word [lm] + SPACE (30),30)
									End IF
								Else
									ls_line += nf_1space (ra_word [lm])
								End IF
								IF	f_notnull (ra_word [lm]) THEN lb_lm_first = false
							NEXT
							IF	in_bracket=0 THEN EXIT
							lm = 0
						NEXT
						IF	f_notnull (ls_comment) OR lb_view	Then
							IF	lb_view	Then
								ll_order ++
								ls_line = wf_add_comment_num (ls_line, ls_comment, ll_order, true)
							Else
								ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
							End IF
							ls_comment = ''
						End IF
						la_return [add_line] += ls_line + '~r~n)' ; ls_line = ''
						lb_exit = false
						FOR  ll = ll  TO  ll_source
							// xml
							IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
								ls_line_comment += wf_line_comment (la_source, ll_source, ll, false)
								lm = 0
								CONTINUE
							ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
								IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
								ls_line += la_source [ll] + '~r~n'
								lm = 0
								CONTINUE
							End IF
							lm_word = rt_line (la_source [ll], ra_word)
							FOR  lm = lm + 1  TO  lm_word
								IF	ra_word [lm]='' THEN CONTINUE
								IF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
									ls_comment = nf_add_comment (ls_comment, ra_word [lm])
									CONTINUE
								End IF
								CHOOSE CASE lower (ra_word [lm])
									CASE 'return'
										ls_line += ' RETURN'
										CONTINUE
									CASE 'is','as'
										ls_line += UPPER (ra_word [lm]) + '[SPACEASCLEAR-' + string(gl_select_step) + ']'
										IF	(lm + 1)<=lm_word	Then
											FOR  lm = lm + 1  TO  lm_word
												ls_line += ra_word [lm]
											NEXT
											ls_line += '~r~n'
										end IF
										lb_exit = true
										la_return [add_line] += ls_line ; ls_line = ''
										IF	POS (la_return [add_line],')  RETURN')>0	Then
											la_return [add_line] = f_replace (la_return [add_line], ')  RETURN', ' ) RETURN')
										ElseIF POS (la_return [add_line],')  AS')>0	then
											la_return [add_line] = f_replace (la_return [add_line], ') AS', ' ) AS')
										Else
											la_return [add_line] = f_replace (la_return [add_line], ') IS', ' ) IS')
										End IF
										IF	f_notnull (ls_line_comment)	Then
											la_return [add_line] += '~r~n' + ls_line_comment
											ls_line_comment = ''
										End IF
										gl_select_step --
										EXIT
								END CHOOSE
								ls_line += nf_1space (ra_word [lm])
							NEXT
							IF	lb_exit THEN EXIT
							IF	f_notnull (ls_line) And RIGHT (ls_line,1)<>' ' THEN ls_line += ' '
							lm = 0
						NEXT
						IF	f_notnull (ls_comment)	Then
							ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
							ls_comment = ''
						End IF
						lb_exit = true
						IF	ll>ll_source THEN EXIT
					CASE 'TRIGGER'
						ls_line += UPPER (ra_word [lm])
						lb_exit = FALSE
						FOR  ll = ll  TO  ll_source
							// xml
							IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
								IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
								ls_line += wf_line_comment (la_source, ll_source, ll, false)
								lm = 0
								CONTINUE
							ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
								IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
								ls_line += la_source [ll] + '~r~n'
								lm = 0
								CONTINUE
							End IF
							lm_word = rt_line (la_source [ll], ra_word)
							FOR  lm = lm + 1  TO  lm_word
								IF	ra_word [lm]='' THEN CONTINUE
								CHOOSE CASE lower (ra_word [lm])
									CASE 'after','before','for'
										IF	RIGHT (ls_line,2)<>'~r~n' THEN ls_line += + '~r~n'
										ls_line += '    ' + UPPER (ra_word [lm])
										CONTINUE
									CASE 'of'
										ls_line = RIGHTTRIM (ls_line) + ' OF~r~n         '
										lb_0space = true
										FOR  lm = lm + 1  TO  lm_word
											IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
											lb_0space = false
											CHOOSE CASE lower (ra_word [lm])
												CASE 'on'
													lm --
													EXIT
												CASE ','
													ls_line += ', '
													lb_0space = true
												CASE ELSE
													ls_line += nf_1space (ra_word [lm])
											END CHOOSE
										NEXT
										IF	lb_0space And ll<ll_source THEN la_source [ll + 1] = TRIM (la_source [ll + 1])
										CONTINUE
									CASE 'referencing'
										IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
										ls_line += '          ' + UPPER (ra_word [lm])
										CONTINUE
									CASE 'declare','begin'
										IF	lower (ra_word [lm])='begin'	Then
											ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
											ll_begin ++
											IF	f_null (ra_word [1])	Then
												IF	ls_space < ra_word [1]	Then
													begin_space [ll_begin] = ra_word [1]
												Else
													begin_space [ll_begin] = ls_space + '    '
												End IF
											Else
												begin_space [ll_begin] = ''
											End IF
										End IF
										IF	f_notnull (ls_line) And RIGHT (ls_line,2)<>'~r~n' THEN ls_line += '~r~n'
										ls_line += UPPER (ra_word [lm])
										lb_exit = TRUE
										EXIT
									CASE 'end'
										IF	ll_begin>0	then
											IF	ll_begin=1	Then
												ls_line = RIGHTTRIM (ls_line) + 'END;'
												EXIT
											Else
												ls_line = RIGHTTRIM (ls_line) + begin_space [ll_begin]
											End IF
											ll_begin --
										End IF
								END CHOOSE
								ls_line += nf_1space (ra_word [lm])
							NEXT
							IF	lb_exit THEN EXIT
							IF	f_notnull (ls_line) And RIGHT (ls_line,1)<>' ' THEN ls_line += ' '
							lm = 0
						NEXT
						EXIT
					CASE ELSE
						ls_line += nf_1space (ra_word [lm])
				END CHOOSE
			NEXT
			la_return [add_line] += ls_line ; ls_line = ''
			IF	lb_exit THEN EXIT
		NEXT
		la_return [add_line] = wf_dml (la_return [add_line], '') + '~r~n'
		add_line ++ ; la_return [add_line] = ''
		IF	ll>ll_source THEN EXIT
		CONTINUE
	End IF
	// add_lline
	lm_word = rt_line (la_source [ll], ra_word)
	IF	RIGHT (TRIM (la_source [ll]),1)=';'	Then
		FOR  lm = lm_word  TO  2  STEP -1
			IF	ra_word [lm]=';'	Then
				IF	f_null (ra_word [lm - 1]) THEN ra_word [lm - 1] = ''
				EXIT
			End IF
		NEXT
	ElseIF LEFT (lower (f_replace (la_source [ll],' ','')),7)='execsql'	Then
		la_return [add_line] += SPACE (POS (lower (la_source [ll]),'exec') - 1) + 'EXEC SQL~r~n'
		add_line ++ ; la_return [add_line] = ''
		IF	f_notnull (MID (la_source [ll], POS (lower (la_source [ll]),'sql') + 3))	Then
			la_return [add_line] += SPACE (POS (lower (la_source [ll]),'exec') + 3) + TRIM (MID (la_source [ll], POS (lower (la_source [ll]),'sql') + 3)) + '~r~n'
			add_line ++ ; la_return [add_line] = ''
		End IF
		CONTINUE
	End IF
	
	IF	f_null (ra_word [1]) And lb_space THEN ra_word [1] = SPACE (4 * TRUNCATE (LenA (ra_word [1]) / 4 + .9,0))

	// 들여쓰기 기준보다 공란이 작은 경우에 들여쓰기 기준 공란 추가
	lm_first = true ; lb_0space = false
	IF	f_null (ra_word [1])	Then
		ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
		IF	ls_space>'' And ra_word [1] <= ls_space	Then
			la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ls_space + '    '
			lb_0space = true
		End IF
	End IF

	FOR  lm = 1  TO  lm_word
		IF	ra_word [lm]='' OR (((ll_begin=0 And lm_first) OR lb_0space) And f_null (ra_word [lm])) THEN CONTINUE
		lb_0space = false
		IF	lb_space	Then
			IF	POS ('execute',lower (ra_word [lm]))>0 THEN lb_space = false
		Else
			IF	ra_word [lm]=';' THEN lb_space = true
		End IF

		ls_lower = lower (ra_word [lm])
		CHOOSE CASE ls_lower
			CASE 'function'
				func_begin = 0 ; begin_exit = false
				ls_in_func = 'create '
				FOR  ll = ll  TO  ll_source
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						CHOOSE CASE ra_word [lm]
							CASE 'BEGIN'
								func_begin ++
							CASE 'END'
								func_begin --
								IF	func_begin=0	Then
									FOR  lm = lm  TO  lm_word
										ls_in_func += ra_word [lm]
									NEXT
									begin_exit = true
									EXIT
								End IF
						END CHOOSE
						ls_in_func += ra_word [lm]
					NEXT
					IF	begin_exit THEN EXIT
					ls_in_func += '~r~n'
					lm = 1
				NEXT
				ls_in_func = wf_1 (ls_in_func)
				la_return [add_line] += '    ' + wf_move (MID (ls_in_func,8), 4, false)
				CONTINUE
			CASE ':=','default'
				la_return [add_line] = wf_4space (la_return [add_line]) + ls_lower + ' '
				lb_0space = TRUE
				lm_first = FALSE
				CONTINUE
			CASE '('
				pivot = nf_bracket_pivot (la_source, ll_source, ll, lm)
				ls_temp = pivot.text
				IF LEFT (ls_temp,4)='WITH'	Then
					la_return [add_line] += '('
					ls_temp = wf_with (ls_temp)
					la_return [add_line] += '~r~n'
					add_line ++ ; la_return [add_line] = ''
					IF	ll_for_loop>0	Then
						la_return [add_line] += for_space [ll_for_loop] + '    ' + wf_move (ls_temp, LEN (for_space [ll_for_loop]) + 4, false)
					Else
						la_return [add_line] += '    ' + wf_move (ls_temp, 4, false)
					End IF
				Else
					IF	LEFT (TRIM (ls_temp),8)='[SELECT-' OR LEFT (TRIM (ls_temp),6)='SELECT' Then
						la_return [add_line] += '('
						IF POS (ls_temp,'[SELECT-')>0	Then
							ls_temp = wf_deselect (ls_temp)
						Else
							ls_temp = TRIM (ls_temp)
						End IF
						IF	ll_for_loop>0	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = for_space [ll_for_loop] + '    '+ wf_move (ls_temp, LEN (for_space [ll_for_loop]) + 4, false)
						Else
							la_return [add_line] += '    ' + wf_move (ls_temp, 4, false)
						End IF
					Else
						IF	ll_begin>0	Then
							la_return [add_line] += '('
							ls_space = wf_bracket_space (la_return [add_line])
							ls_temp = wf_in (la_return [add_line], ls_temp)
							la_return [add_line] += wf_move (ls_temp, LEN (ls_space), false)
						Else
							la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' (' + ls_temp
						End IF
					End IF
				End IF
				ll = pivot.ll
				lm = pivot.lm
				IF	ll>ll_source THEN EXIT
				lm_word = rt_line (la_source [ll], ra_word)	// 변경된 ll 반영
				la_return [add_line] += ')'
				lm_first = FALSE
				CONTINUE
			CASE 'open'
				lb_exit = FALSE
				ls_space = SPACE (PosA (lower (la_source [ll]),'open') - 1)
				ls_space = SPACE (4 * TRUNCATE (LenA (ls_space) / 4 + .9,0))
				la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ls_space
				FOR  ll = ll  TO  ll_source
					IF	f_null (la_source [ll]) THEN CONTINUE
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						add_line ++ ; la_return [add_line] = ''
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]='' THEN CONTINUE
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF							
						CHOOSE CASE lower (ra_word [lm])
							CASE 'with'
								ls_space += '    '
								ls_dml = ''
								lb_exit = FALSE
								FOR  ll = ll  TO  ll_source
									// xml
									IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
										IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
											la_return [add_line] += '~r~n'
											add_line ++ ; la_return [add_line] = ''
										End IF
										la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
										lm = 1
										CONTINUE
									ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
										IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
											la_return [add_line] += '~r~n'
											add_line ++ ; la_return [add_line] = ''
										End IF
										la_return [add_line] += la_source [ll] + '~r~n'
										add_line ++ ; la_return [add_line] = ''
										lm = 1
										CONTINUE
									End IF
									lm_word = rt_line (la_source [ll], ra_word)
									FOR  lm = lm  TO  lm_word
										IF	ra_word [lm]=';'	Then
											lb_exit = true
											EXIT
										ElseIF POS (ra_word [lm],'</')>0	Then
											lb_exit = true
											lm = 1
											EXIT
										End IF
										ls_dml += ra_word [lm]
									NEXT
									IF	lb_exit THEN EXIT
									ls_dml += '~r~n'
									lm = 1
								NEXT
								ls_dml = wf_with (ls_dml)
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ls_space + wf_move (ls_dml, LEN (ls_space), false)
								IF	ll>ll_source THEN EXIT
								IF	lm=1	Then
									la_return [add_line] += '~r~n'
									add_line ++ ; la_return [add_line] = ''
								End IF
								FOR  lm = lm  TO  lm_word
									la_return [add_line] += ra_word [lm]
								NEXT
								EXIT
							CASE 'select'
								ls_space += '    '
								IF	f_notnull (ls_comment)	Then
									la_return [add_line] = wf_add_comment_num (la_return [add_line], ls_comment, 0, false) + '~r~n'
									add_line ++ ; la_return [add_line] = ''
									ls_comment = ''
								End IF
								IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
									la_return [add_line] += '~r~n'
									add_line ++ ; la_return [add_line] = ''
								End IF
								ls_dml = ''
								FOR  ll = ll  TO  ll_source
									// xml
									IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
										IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
											la_return [add_line] += '~r~n'
											add_line ++ ; la_return [add_line] = ''
										End IF
										la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
										lm = 1
										CONTINUE
									ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
										IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
											la_return [add_line] += '~r~n'
											add_line ++ ; la_return [add_line] = ''
										End IF
										la_return [add_line] += la_source [ll] + '~r~n'
										add_line ++ ; la_return [add_line] = ''
										lm = 1
										CONTINUE
									End IF
									lm_word = rt_line (la_source [ll], ra_word)
									FOR  lm = lm  TO  lm_word
										IF	ra_word [lm]=';'	Then
											lb_exit = TRUE
											EXIT
										ElseIF POS (ra_word [lm],'</')>0	Then
											lb_exit = true
											lm = 1
											EXIT
										End IF
										ls_dml += ra_word [lm]
									NEXT
									IF	lb_exit THEN EXIT
									IF	f_notnull (ls_dml) THEN ls_dml += '~r~n'
									lm = 1
								NEXT
								ls_dml = wf_dml_select (ls_dml)
								IF POS (ls_dml,'[SELECT-')>0 THEN ls_dml = wf_deselect (ls_dml)
								la_return [add_line] += ls_space + wf_move (ls_dml, LEN (ls_space), false)
								IF	ll>ll_source THEN EXIT
								IF	lm=1	Then
									la_return [add_line] += '~r~n'
									add_line ++ ; la_return [add_line] = ''
								End IF
								FOR  lm = lm  TO  lm_word
									la_return [add_line] += ra_word [lm]
								NEXT
								EXIT
							CASE ';'
								FOR  lm = lm  TO  lm_word
									la_return [add_line] += ra_word [lm]
								NEXT
								lb_exit = true
								EXIT
							CASE ELSE
								la_return [add_line] += nf_1space (UPPER (ra_word [lm]))
						END CHOOSE
					NEXT
					IF	lb_exit THEN EXIT
					IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],1)<>' ' THEN la_return [add_line] += ' '
					lm = 1
				NEXT
				IF	ll>ll_source THEN EXIT
				IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],1)<>' ' THEN la_return [add_line] += ' '
				CONTINUE
			CASE 'cursor'
				lb_exit = FALSE
				FOR  ll = ll  TO  ll_source
					IF	f_null (la_source [ll]) THEN CONTINUE
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						add_line ++ ; la_return [add_line] = ''
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]='' THEN CONTINUE
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF							
						CHOOSE CASE lower (ra_word [lm])
							CASE 'cursor'
								IF	RIGHT (TRIM (la_return [add_line]),2)<>'~r~n' And f_notnull (la_return [add_line])	Then
									la_return [add_line] = RIGHTTRIM (la_return [add_line]) + '~r~n'
									add_line ++ ; la_return [add_line] = ''
								End IF
								la_return [add_line] = wf_4space (la_return [add_line])
								ls_space = wf_bracket_space (la_return [add_line]) ; ls_space += '    '	// cursor 다음 select 위치
								la_return [add_line] += UPPER (ra_word [lm])
							CASE 'select'							
								IF	f_notnull (ls_comment)	Then
									la_return [add_line] = wf_add_comment_num (la_return [add_line], ls_comment, 0, false) + '~r~n'
									add_line ++ ; la_return [add_line] = ''
									ls_comment = ''
								Else
									// cursor 위치에 다른 공백조정으로
									la_return [add_line] = RIGHTTRIM (la_return [add_line])
								End IF
								IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
									la_return [add_line] += '~r~n'
									add_line ++ ; la_return [add_line] = ''
								End IF
								ls_dml = ''
								FOR  ll = ll  TO  ll_source
									// xml
									IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
										IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
										ls_dml += wf_line_comment (la_source, ll_source, ll, false)
										lm = 1
										CONTINUE
									ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
										IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
										ls_dml += la_source [ll] + '~r~n'
										lm = 1
										CONTINUE
									End IF
									lm_word = rt_line (la_source [ll], ra_word)
									FOR  lm = lm  TO  lm_word
										IF	ra_word [lm]=';'	Then
											lb_exit = TRUE
											EXIT
										End IF
										ls_dml += ra_word [lm]
									NEXT
									IF	lb_exit THEN EXIT
									IF	f_notnull (ls_dml) THEN ls_dml += '~r~n'
									lm = 1
								NEXT
								ls_dml = wf_dml_select (ls_dml)
								IF POS (ls_dml,'[SELECT-')>0 THEN ls_dml = wf_deselect (ls_dml)
								la_return [add_line] += ls_space + wf_move (ls_dml, LEN (ls_space), false)
								EXIT
							CASE ELSE
								la_return [add_line] += UPPER (ra_word [lm])
						END CHOOSE
					NEXT
					IF	lb_exit THEN EXIT
					IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],1)<>' ' THEN la_return [add_line] += ' '
					lm = 1
				NEXT
				ls_temp = MID (la_return [add_line], LASTPOS (la_return [add_line],'~r~n') + 2)
				la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ';'
				IF	ll>ll_source THEN EXIT
				CONTINUE
			CASE 'while'
				ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
				ll_for_loop ++
				IF	f_null (ra_word [1])	Then
					IF	ls_space < ra_word [1]	Then
						for_space [ll_for_loop] = ra_word [1]
					Else
						for_space [ll_for_loop] = ls_space + '    '
					End IF
				Else
					IF	ls_space < '    '	Then
						for_space [ll_for_loop] = '    '
					Else
						for_space [ll_for_loop] = ls_space + '    '
					End IF
				End IF
				lb_exit = false
				FOR  ll = ll  TO  ll_source
					IF	f_null (la_source [ll]) THEN CONTINUE
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						add_line ++ ; la_return [add_line] = ''
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						CHOOSE CASE lower (ra_word [lm])
							CASE 'while'
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + for_space [ll_for_loop] + 'WHILE'
							CASE 'loop'
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' LOOP'
								lb_exit = true
								EXIT
							CASE ELSE
								la_return [add_line] += nf_1space (ra_word [lm])
						END CHOOSE
					NEXT
					IF	lb_exit THEN EXIT
					la_return [add_line] += '~r~n'
					add_line ++ ; la_return [add_line] = ''
					lm = 1
				NEXT
				IF	ll>ll_source THEN EXIT
				CONTINUE
			CASE 'loop'
				ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
				ll_for_loop ++
				IF	f_null (ra_word [1])	Then
					IF	ls_space < ra_word [1]	Then
						for_space [ll_for_loop] = ra_word [1]
					Else
						for_space [ll_for_loop] = ls_space + '    '
					End IF
				Else
					IF	ls_space < '    '	Then
						for_space [ll_for_loop] = '    '
					Else
						for_space [ll_for_loop] = ls_space + '    '
					End IF
				End IF
				la_return [add_line] = RIGHTTRIM (la_return [add_line]) + for_space [ll_for_loop] + 'LOOP'
				FOR  lm = lm + 1  TO  lm_word
					la_return [add_line] += nf_1space (ra_word [lm])
				NEXT
				EXIT
         CASE 'fetch'
				IF	ll_for_loop>0	Then
	            la_return [add_line] = RIGHTTRIM (la_return [add_line]) + for_space [ll_for_loop] + '    FETCH  '
				Else
	            la_return [add_line] += '    FETCH  '
				End IF
				lm_first  = false
            lb_fetch  = true
            lb_0space = true
            ll_fetch  = 0
				CONTINUE
         CASE 'into'
            IF lb_fetch Then
               la_return [add_line] = RIGHTTRIM (la_return [add_line]) + '  INTO '
               lb_fetch = false
               in_exit  = false
               FOR  ll = ll  TO  ll_source
                  IF f_null (la_source [ll]) THEN CONTINUE
                  lm_word = rt_line (la_source [ll], ra_word)
                  FOR  lm = lm + 1  TO  lm_word
							IF	f_null (ra_word [lm]) THEN CONTINUE
							IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
								ls_comment = nf_add_comment (ls_comment, ra_word [lm])
								CONTINUE
							End IF
                     CHOOSE CASE ra_word [lm]
                        CASE ','
                           CONTINUE
                        CASE ';'
                           in_exit = true
                           EXIT
                        CASE ELSE
                           ll_fetch ++
                           la_fetch [ll_fetch] = ra_word [lm]
                           ll_fetch_max        = MAX (ll_fetch_max, LenA (ra_word [lm]))
                     END CHOOSE
                  NEXT
                  IF in_exit THEN EXIT
                  lm = 0
               NEXT
               ls_space = SPACE (nf_bracket_space (la_return [add_line]) - 2)
               IF ll_fetch_max>15   Then
                   ls_temp = wf_fetch_list (la_fetch, ll_fetch, 3)
               ELSE
                   ls_temp = wf_fetch_list (la_fetch, ll_fetch, 5)
               END IF
               la_return [add_line] += wf_move (ls_temp, LEN (ls_space), false)
               EXIT
            ELSE
               la_return [add_line] += ra_word [lm]
            END IF
			CASE 'for'
				ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
				ll_for_loop ++
				IF	f_null (ra_word [1])	Then
					IF	ls_space < ra_word [1]	Then
						for_space [ll_for_loop] = ra_word [1]
					Else
						for_space [ll_for_loop] = ls_space + '    '
					End IF
				Else
					IF	ls_space < '    '	Then
						for_space [ll_for_loop] = '    '
					Else
						for_space [ll_for_loop] = ls_space + '    '
					End IF
				End IF
				lb_exit = FALSE
				ls_dml  = ''
				FOR  ll = ll  TO  ll_source
					IF	f_null (la_source [ll]) THEN CONTINUE
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n' THEN la_return [add_line] += '~r~n'
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						add_line ++ ; la_return [add_line] = ''
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					lb_0space = false
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
						lb_0space = false
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF							
						CHOOSE CASE lower (ra_word [lm])
							CASE 'for'
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + for_space [ll_for_loop] + 'FOR'
							CASE 'loop'
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' LOOP'
								lb_exit = true
								EXIT
							CASE 'in'
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' IN '
								lb_0space = true
							CASE '('
								pivot = nf_bracket_pivot (la_source, ll_source, ll, lm)
								ls_temp = pivot.text
								IF LEFT (ls_temp,4)='WITH'	Then
									ls_temp = wf_with (ls_temp)
									la_return [add_line] += '(~r~n' + for_space [ll_for_loop] + '    '
									IF	LEFT (ls_temp,4)='WITH'	Then
										la_return [add_line] += wf_move (ls_temp, LEN (for_space [ll_for_loop]) + 4, false)
									Else
										la_return [add_line] += TRIM (wf_move (ls_temp, LEN (for_space [ll_for_loop]) + 4, false))
									End IF
								Else
									IF	POS (ls_temp,'[SELECT-')>0	Then
										ls_temp = wf_deselect (ls_temp)
										la_return [add_line] += '(~r~n' + for_space [ll_for_loop] + '    '
										IF	LEFT (ls_temp,6)='SELECT'	Then
											la_return [add_line] += wf_move (ls_temp, LEN (for_space [ll_for_loop]) + 4, false)
										Else
											la_return [add_line] += TRIM (wf_move (ls_temp, LEN (for_space [ll_for_loop]) + 4, false))
										End IF
									Else
										la_return [add_line] += '('
										ls_space = wf_bracket_space (la_return [add_line])
										la_return [add_line] += '~r~n'
										ls_temp = wf_in (la_return [add_line], ls_temp)
										la_return [add_line] += wf_move (ls_temp, LEN (ls_space), false)
									End IF
								End IF
								ll = pivot.ll
								lm = pivot.lm
								IF	ll>ll_source THEN EXIT
								lm_word = rt_line (la_source [ll], ra_word)	// 변경된 ll 반영
								IF	ra_word [lm]=') loop'	Then
									la_return [add_line] = RIGHTTRIM (la_return [add_line]) + '~r~n' + for_space [ll_for_loop] + ra_word [lm]
									lm++
								Else
									la_return [add_line] += ')'
								End IF
								lb_exit = true
								EXIT
							CASE ELSE
								la_return [add_line] += nf_1space (ra_word [lm])
						END CHOOSE
					NEXT
					IF	lb_exit THEN EXIT
					IF f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],1)<>' ' THEN la_return [add_line] += ' '
					lm = 1
				NEXT
				IF	ll>ll_source THEN EXIT
				CONTINUE
			CASE 'end loop'
				IF	ll_for_loop>0	Then
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + for_space [ll_for_loop]
					ll_for_loop --
					lm_first = false
				End IF
			CASE 'else'
				IF	ll_if>0	Then
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + if_space [ll_if] + 'else'
				Else
					la_return [add_line] += 'else'
				End IF
				IF	RIGHT (TRIM (la_source [ll]),1)=';'	Then
					FOR  lm = lm + 1  TO  lm_word
						la_return [add_line] += ra_word [lm]
					NEXT
					EXIT
				Else
					lm_first = FALSE
					CONTINUE
				End IF
			CASE 'end if'
				ra_word [lm] = lower (ra_word [lm])
				IF	ll_if>0	Then
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + if_space [ll_if]
					ll_if --
				End IF
				la_return [add_line] += ra_word [lm]
				lm_first = FALSE
				lb_0space = true
				CONTINUE
			CASE 'case'
				in_case = 0 ; ls_temp = ''
				FOR  ll = ll  TO  ll_source
					IF	f_null (la_source [ll]) THEN CONTINUE
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (ls_temp) And RIGHT (ls_temp,2)<>'~r~n' THEN ls_temp += '~r~n'
						ls_temp += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (ls_temp) And RIGHT (ls_temp,2)<>'~r~n' THEN ls_temp += '~r~n'
						ls_temp += la_source [ll] + '~r~n'
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]='' THEN CONTINUE
						IF	lower (ra_word [lm])='begin'	Then
							ls_begin = ''
							begin_exit = false
							FOR ll = ll TO  ll_source
								IF	f_null (la_source [ll]) THEN CONTINUE
								lm_word = rt_line (la_source [ll], ra_word)
								FOR  lm = 1  TO  lm_word
									ls_begin += ra_word [lm]
									IF	lower (ra_word [lm])='end' THEN begin_exit = true
								NEXT
								IF	begin_exit THEN EXIT
								ls_begin += '~r~n'
							NEXT
							ls_temp = RIGHTTRIM (ls_temp) + '[BEGIN]~r~n'
							EXIT
						Else
							ls_temp += ra_word [lm]
							CHOOSE CASE lower (ra_word [lm])
								CASE 'case'
									in_case ++
								CASE 'end','end case'
									in_case --
									IF	in_case=0 THEN EXIT
							END CHOOSE
						End IF
					NEXT
					IF	in_case=0 THEN EXIT
					ls_temp += '~r~n'
					lm = 1
				NEXT
				ls_space = wf_bracket_space (la_return [add_line])
				ls_temp = wf_case (ls_temp)
				IF POS (ls_temp,'[SELECT-')>0 THEN ls_temp = wf_deselect (ls_temp)
				la_return [add_line] += wf_dml (ls_temp, ls_space) + ';'
				IF	POS (la_return [add_line], '[BEGIN]')>0 THEN la_return [add_line] = f_replace (la_return [add_line], '[BEGIN]', ls_begin)
				IF	ll>ll_source THEN EXIT
				lm ++
				lm_first = FALSE
				CONTINUE
			CASE 'if','elsif'
				lb_then = FALSE
				IF ls_lower='if'	Then
					ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
					ll_if ++
					IF	lm=1	Then
						IF	ls_space < '    '	Then
							if_space [ll_if] = '    '
						Else
							if_space [ll_if] = ls_space + '    '
						End IF
					Else
						IF	ls_space < ra_word [lm - 1]	Then
							if_space [ll_if] = ra_word [lm - 1]
						Else
							if_space [ll_if] = ls_space + '    '
						End IF
					End IF
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + if_space [ll_if] + ls_lower + '  '
				Else
					IF	ll_if>0	Then
						la_return [add_line] = RIGHTTRIM (la_return [add_line]) + if_space [ll_if] + ls_lower + ' '
					Else
						la_return [add_line] += ls_lower + ' '
					End IF
				End IF
				lb_exit = FALSE ; lm_if = ll
				FOR  ll = ll  TO  ll_source
					lm_word = rt_line (la_source [ll], ra_word)
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
						End IF
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 0
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						lm = 0
						CONTINUE
					End IF
					lb_0space = TRUE
					IF	UPPER (RIGHT (RIGHTTRIM (la_return [add_line]),3))=' IF' OR UPPER (RIGHT (RIGHTTRIM (la_return [add_line]),5))='ELSIF'	Then
						lb_lm_first = false
					Else
						lb_lm_first = true
						lb_0space = true
					End IF
					FOR  lm = lm + 1  TO  lm_word
						IF	ra_word [lm]='' OR (lb_0space And f_null (ra_word [lm])) THEN CONTINUE
						lb_0space = FALSE
						CHOOSE CASE lower (ra_word [lm])
							CASE '('
								IF	lb_lm_first And NOT lb_then	Then
									la_return [add_line] += '('
								Else
									la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' ('
									ls_space = wf_bracket_space (la_return [add_line])
									pivot = nf_bracket_pivot (la_source, ll_source, ll, lm)
									ls_temp = wf_in (la_return [add_line], pivot.text)
									IF	POS (ls_temp,'~r~n')>0	Then
										la_return [add_line] += ' ' + wf_move (ls_temp, LEN (ls_space) + 1, false) + ' ) '
									Else
										la_return [add_line] += wf_move (ls_temp, LEN (ls_space) + 1, false) + ') '
									End IF
									ll = pivot.ll ; lm = pivot.lm
									IF	ll>ll_source THEN EXIT
									lm_word = rt_line (la_source [ll], ra_word)	// 변경된 ll 반영
									lb_0space = true
									CONTINUE
								End IF
							CASE 'between','is null','is not null','not between'
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' ' + lower (ra_word [lm]) + ' '
								lb_0space = TRUE
							CASE 'and'
								la_return [add_line] = RIGHTTRIM (la_return [add_line])
								IF	lb_lm_first And NOT lb_then	Then
									la_return [add_line] += if_space [ll_if] + '     And '
								Else
									la_return [add_line] += IIF (lb_lm_first,'[SPACE^]','') + ' And '
								End IF
								lb_0space = TRUE
							CASE 'or'
								la_return [add_line] = RIGHTTRIM (la_return [add_line])
								IF	lb_lm_first And NOT lb_then	Then
									la_return [add_line] += if_space [ll_if] + '     OR '
								Else
									la_return [add_line] += IIF (lb_lm_first,'[SPACE^]','') + ' OR '
								End IF
								lb_0space = TRUE
							CASE 'nvl','coalesce'
								la_return [add_line] = RIGHTTRIM (la_return [add_line])
								IF	lb_lm_first And NOT lb_then	Then
									la_return [add_line] += if_space [ll_if] + '     ' + UPPER (ra_word [lm])
								Else
									la_return [add_line] += IIF (lb_lm_first,'[SPACE^]',' ') + UPPER (ra_word [lm])
								End IF
								lb_0space = TRUE
							CASE 'is','like','not like','not in','in'
								la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' ' + UPPER (ra_word [lm]) + ' '
								lb_0space = TRUE
							CASE 'substr'
								la_return [add_line] += UPPER (ra_word [lm]) + ' '
								lb_0space = TRUE
							CASE '+','-','*','/','^','**','||','>','<','=','>=','<=','<>','!=','!~~','<![cdata[<=]]>','<![cdata[>=]]>','<![cdata[<]]>','<![cdata[>]]>','<![cdata[<>]]>'
								IF	lb_lm_first And NOT lb_then	Then
									la_return [add_line] = RIGHTTRIM (la_return [add_line]) + if_space [ll_if] + ' ' + ra_word [lm] + ' '
								Else
									la_return [add_line] = RIGHTTRIM (la_return [add_line]) + IIF (lb_lm_first,'[SPACE^]',' ') + ra_word [lm] + ' '
								End IF
								lb_0space = TRUE
							CASE 'then'
								lb_then = TRUE
								la_return [add_line] = RIGHTTRIM (la_return [add_line])	// then 위치조정은 뒤에서 하므로 공란유지
								IF	f_notnull (ra_word [lm - 1])	Then
									// THEN에 공란을 주지 않은 경우 처리
									la_return [add_line] += ' '
									FOR  lm = lm  TO  lm_word
										la_return [add_line] += ra_word [lm]
									NEXT
								Else
									FOR  lm = lm - 1  TO  lm_word
										la_return [add_line] += ra_word [lm]
									NEXT
								End IF
								lb_exit = TRUE
								EXIT
							CASE ';'
								la_return [add_line] = RIGHTTRIM (la_return [add_line])
								FOR  lm = lm  TO  lm_word
									la_return [add_line] = la_return [add_line] + ra_word [lm]
								NEXT
								EXIT
							CASE ELSE
								IF	lm=1 And f_null (ra_word [lm]) And ll_if=0	Then
									la_return [add_line] = RIGHTTRIM (la_return [add_line]) + if_space [ll_if] + ra_word [lm]
								Else
									la_return [add_line] += f_nvl (ra_word [lm],' ')
								End IF
						END CHOOSE
						lb_lm_first = false
					NEXT
					IF	lb_exit THEN EXIT
					la_return [add_line] += '~r~n' + if_space [ll_if] + '    '
					lm = 0
				NEXT
				EXIT
			CASE 'type'
				la_return [add_line] += la_source [ll]
				IF	POS (la_source [ll],';')=0	Then
					FOR  ll = ll + 1  TO  ll_source
						la_return [add_line] += '~r~n'
						add_line ++ ; la_return [add_line] = la_source [ll]
						IF	POS (la_source [ll],';')>0 THEN EXIT
					NEXT
				End IF
				EXIT
			CASE 'begin','function'
				IF	ls_lower='begin'	Then
					ls_space = wf_indentation_space (ll_begin, begin_space, ll_if, if_space, ll_for_loop, for_space, 0, {''})	// 들여쓰기 공란
					ll_begin ++
					IF	f_null (ra_word [1])	Then
						IF	ls_space < ra_word [1]	Then
							begin_space [ll_begin] = ra_word [1]
						Else
							begin_space [ll_begin] = ls_space + '    '
						End IF
					Else
						begin_space [ll_begin] = ''
					End IF
				End IF
			CASE 'end'
				IF	ll_begin>0	then
					lb_exception = false
					IF	ll_begin=1	Then
						la_return [add_line] = RIGHTTRIM (la_return [add_line]) + 'END;'
						EXIT
					Else
						la_return [add_line] = RIGHTTRIM (la_return [add_line]) + begin_space [ll_begin]
					End IF
					ll_begin --
				End IF
			CASE 'exception'
				IF	ll_begin>0	Then
					lb_exception = true
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + begin_space [ll_begin]
					lb_0space = true
					lb_exit = false
					FOR  ll = ll  TO  ll_source
						lm_word = rt_line (la_source [ll], ra_word)
						FOR  lm = lm  TO  lm_word
							la_return [add_line] += nf_1space (ra_word [lm])
							IF	lower (ra_word [lm])='then'	Then
								lb_exit = true
								EXIT
							End IF
						NEXT
						IF f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],1)<>' ' THEN la_return [add_line] += ' '
						IF	lb_exit THEN EXIT
						lm = 1
					NEXT
					lm_first = FALSE
					IF	ll>ll_source THEN EXIT
					la_return [add_line] += '~r~n'
					add_line ++ ; la_return [add_line] = ''
					CONTINUE
				End IF
			CASE 'exit'
				lb_exit = false
				FOR  ll = ll  TO  ll_source
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						add_line ++ ; la_return [add_line] = ''
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						la_return [add_line] += nf_1space (ra_word [lm])
						IF	ra_word [lm]=';'	Then
							lb_exit = true
							EXIT
						End IF
					NEXT
					IF	lb_exit THEN EXIT
					lm = 1
				NEXT
				lm_first = FALSE
				IF	ll>ll_source THEN EXIT
				la_return [add_line] += '~r~n'
				add_line ++ ; la_return [add_line] = ''
				CONTINUE
			CASE 'when'
				IF	ll_begin>0 THEN la_return [add_line] = RIGHTTRIM (la_return [add_line]) + begin_space [ll_begin]
				lb_exit = false
				FOR  ll = ll  TO  ll_source
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						add_line ++ ; la_return [add_line] = ''
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						la_return [add_line] += nf_1space (ra_word [lm])
						IF	lower (ra_word [lm])='then'	Then
							lb_exit = true
							EXIT
						End IF
					NEXT
					IF	lb_exit THEN EXIT
					IF RIGHT (la_return [add_line],1)<>' ' THEN la_return [add_line] += ' '
					lm = 1
				NEXT
				lm_first = FALSE
				IF	ll>ll_source THEN EXIT
				la_return [add_line] += '~r~n'
				add_line ++ ; la_return [add_line] = ''
				CONTINUE
			CASE 'with','select','selectblob','insert','update','updateblob','delete'
				gl_select = 0
				ga_select [] = {''}
				ls_dml = '' ; ls_line_comment = ''
				lb_exit = FALSE
				FOR  ll = ll  TO  ll_source
					IF	f_null (la_source [ll]) THEN CONTINUE
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_null (ls_dml)	Then
							IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
							ls_line_comment += wf_line_comment (la_source, ll_source, ll, false)
						Else
							IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
							ls_dml += wf_line_comment (la_source, ll_source, ll, false)
						End IF
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_null (ls_dml)	Then
							IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
							ls_line_comment += la_source [ll] + '~r~n'
						Else
							IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
							ls_dml += la_source [ll] + '~r~n'
						End IF
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						CHOOSE CASE lower (ra_word [lm])
							CASE ';'
								lb_exit = true
								EXIT
							CASE 'with'
								IF	RIGHT (TRIM (la_source [ll]),1)=';'	Then
									FOR  ll = ll  TO  ll_source
										lm_word = rt_line (la_source [ll], ra_word)
										FOR  lm = lm  TO  lm_word
											ls_with_read += UPPER (nf_1space (ra_word [lm]))
										NEXT
									NEXT
									lb_exit = true
									EXIT
								End IF
						END CHOOSE
						ls_dml += ra_word [lm]
					NEXT
					IF	lb_exit THEN EXIT
					ls_dml += '~r~n'
					lm = 1
				NEXT
				CHOOSE CASE ls_lower
					CASE 'with'
						ls_dml = wf_with (ls_dml)
					CASE 'select','selectblob'
						ls_dml = wf_dml_select (ls_dml)
					CASE 'insert'
						ls_dml = wf_dml_insert (ls_dml)
					CASE ELSE
						ls_dml = wf_dml_update (ls_dml)
				END CHOOSE
				IF POS (ls_dml,'[SELECT-')>0 THEN ls_dml = wf_deselect (ls_dml)
				IF	f_notnull (ls_line_comment)	Then
					IF	f_notnull (ls_dml) And RIGHT (ls_dml,2)<>'~r~n' THEN ls_dml += '~r~n'
					ls_dml += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_space = wf_bracket_space (la_return [add_line])
				IF	POS (ls_dml,'~r~n')=0	Then
					la_return [add_line] += ls_dml
				Else
					la_return [add_line] += wf_move (ls_dml, LEN (ls_space), false)
				End IF
				IF	f_notnull (ls_with_read)	Then
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + '~r~n~r~n'
					add_line ++ ; la_return [add_line] = TRIM (ls_with_read)
					ls_with_read = ''
				End IF
				IF	ll>ll_source THEN EXIT
				IF	lm<2 And f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
					la_return [add_line] += '~r~n'
					add_line ++ ; la_return [add_line] = ''
				End IF
				IF	lm=0 THEN EXIT
				FOR  lm = lm  TO  lm_word
					la_return [add_line] += ra_word [lm]
				NEXT
				lm_first = FALSE
				EXIT
			CASE 'merge'
				ls_space = wf_bracket_space (la_return [add_line])
				ls_temp = ''
				lb_exit = false
				FOR  ll = ll  TO  ll_source
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_source [ll]),2)) Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += wf_line_comment (la_source, ll_source, ll, false)
						lm = 1
						CONTINUE
					ElseIF LEFT (TRIM (la_source [ll]),2)='<<'	Then
						IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
							la_return [add_line] += '~r~n'
							add_line ++ ; la_return [add_line] = ''
						End IF
						la_return [add_line] += la_source [ll] + '~r~n'
						add_line ++ ; la_return [add_line] = ''
						lm = 1
						CONTINUE
					End IF
					lm_word = rt_line (la_source [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						IF	ra_word [lm]=';'	Then
							lb_exit = true
							Exit
						ElseIF POS (ra_word [lm],'</')>0	Then
							lm = 1
							lb_exit = true
							EXIT
						End IF
						ls_temp += ra_word [lm]
					NEXT
					IF	lb_exit THEN EXIT
					ls_temp += '~r~n'
					lm = 1
				NEXT
//				ls_temp = wf_dml_merge (ls_temp)
				IF POS (ls_temp,'[SELECT-')>0 THEN ls_temp = wf_deselect (ls_temp)
				la_return [add_line] += wf_move (ls_temp, LEN (ls_space), false)
				IF	ll>ll_source THEN EXIT
				IF	lm=1	Then
					la_return [add_line] += '~r~n'
					add_line ++ ; la_return [add_line] = ''
				End IF
				FOR  lm = lm  TO  lm_word
					la_return [add_line] += ra_word [lm]
				NEXT
				lm_first = FALSE
				CONTINUE
			CASE '+','-','*','/','^','**','||','='
				IF	lm_first	Then
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + '[SPACE^]' + ra_word [lm] + ' '
				Else
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ' ' + ra_word [lm] + ' '
				End IF
				lb_0space = TRUE
				lm_first = FALSE
				CONTINUE
		END CHOOSE
		IF	ll_begin=0	Then
			IF	lm_first	Then
				IF	LenA (ra_word [lm])>26	Then
					la_return [add_line] += '    ' + ra_word [lm]
				Else
					la_return [add_line] += '    ' + LeftA (ra_word [lm] + SPACE (28),28)
				End IF
			Else
				IF	ra_word [lm]=';'	Then
					la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ';'
				Else
					la_return [add_line] += nf_1space (ra_word [lm])
				End IF
			End IF
		Else
			IF	ra_word [lm]=';'	Then
				IF	RIGHT (TRIM (la_return [add_line]),1)<>';' THEN la_return [add_line] = RIGHTTRIM (la_return [add_line]) + ';'
			Else
				la_return [add_line] += ra_word [lm]
			End IF
		End IF
		IF	f_notnull (ra_word [lm]) THEN lm_first = FALSE
	NEXT
	IF	f_notnull (la_return [add_line]) And RIGHT (la_return [add_line],2)<>'~r~n'	Then
		la_return [add_line] += '~r~n'
		IF	ll_begin>0 And ll_if=0	Then
			add_line ++ ; la_return [add_line] = ''
		End IF
	End IF
NEXT
IF	la_return [add_line]='' THEN add_line --
IF	RIGHT (la_return [add_line],2)='~r~n' THEN la_return [add_line] = LEFT (la_return [add_line], LEN (la_return [add_line]) - 2)

ls_return = ''
FOR  ll = 1  TO  add_line
	IF	la_return [ll]>'' THEN ls_return += la_return [ll]
NEXT
ll_source = f_get_array (ls_return,'~r~n',la_source)

// := 위치조정
ll_source = f_get_array (ls_return, '~r~n', la_source)
ls_return = ''
ll_begin = 0
FOR  ll = 1  TO  ll_source
   IF nf_comp ({'--','//','/*','<!'}, LEFT (la_source [ll],2)) Then
      IF f_notnull (ls_return) AND RIGHT (ls_return,2) <> '~r~n' THEN ls_return += '~r~n'
      ls_return += wf_line_comment (la_source, ll_source, ll, false)
      CONTINUE
   END IF

	ls_temp = nf_clear_sqm (la_source [ll], true) ; ls_temp = lower (TRIM (ls_temp))
	IF	POS (ls_temp,'__')>0 THEN ls_temp = TRIM (LEFT (ls_temp, POS (ls_temp,'__') - 1))
	
   IF ls_temp='begin' THEN ll_begin ++

   IF RIGHT (ls_temp,1)<>';'	Then
      ls_return += la_source [ll] + "~r~n"
		CONTINUE
	End IF

	IF LEFT (ls_temp,2)='if' OR LEFT (ls_temp,5)='elsif'	Then
      if_exit = false
      FOR  ll = ll  TO  ll_source
         lm_word = rt_line (la_source [ll], ra_word)
         FOR  lm = 1  TO  lm_word
            ls_return += ra_word [lm]
            IF lower (ra_word [lm])='then'   Then
               if_exit = true
               EXIT
            END IF
         NEXT
         IF if_exit THEN EXIT
         ls_return += '~r~n'
      NEXT
      FOR  lm = lm + 1  TO  lm_word
         ls_return += ra_word [lm]
      NEXT
      ls_return += '~r~n'

	ELSEIF LEFT (ls_temp,4)='else'	Then
      ls_return += la_source [ll] + "~r~n"
	Else
		IF POS(ls_temp, ":=")>0	Then
			ls_return += wf_assign_max ((ll_begin>0), ":=", ll, ll_source, (ll_begin > 0), ll, la_source)
		ElseIF ll_begin=0 And POS(ls_temp, " default ")>0	Then
			ls_return += wf_assign_max ((ll_begin>0), "DEFAULT", ll, ll_source, false, ll, la_source)
		ELSE
			ls_return += la_source [ll] + "~r~n"
		END IF
   END IF
NEXT
ls_return = LEFT (ls_return, LEN (ls_return) - 2)

RETURN	ls_return
end function

public function long nf_bracket_space (string arg_line);// 최종 line 길이
STRING	ls_line

ls_line = nf_clear (arg_line)
IF	POS (ls_line,'~r~n')>0 THEN ls_line = MID (ls_line, LASTPOS (ls_line,'~r~n') + 2)

RETURN LenA (ls_line)
end function

public function long nf_select_column (string arg_line[]);BOOLEAN	lb_exit

LONG  ll_column, ll, lm, lm_word, ll_bracket, ll_case

STRING   ra_word []

FOR  ll = 1  TO  UPPERBOUND (arg_line)
   IF f_null (arg_line [ll]) THEN CONTINUE
   lm_word = rt_line (arg_line [ll], ra_word)
   FOR  lm = 1  TO  lm_word
      IF f_null (ra_word [lm]) THEN CONTINUE
      CHOOSE CASE ra_word [lm]
         CASE 'SELECT'
				ll_column = 0
		   CASE '('
				ll_bracket ++
		   CASE ')'
				ll_bracket --
			CASE 'CASE'
				ll_case = 1
				FOR  ll = ll  TO  UPPERBOUND (arg_line)
					lm_word = rt_line (arg_line [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						CHOOSE CASE lower (ra_word [lm])
							CASE 'case'
								ll_case ++
							CASE 'end'
								ll_case --
								IF	ll_case=0 THEN EXIT
						END CHOOSE
					NEXT
					IF	ll_case=0 THEN EXIT
					lm = 0
				NEXT
				CONTINUE
			CASE 'INTO', 'FROM', 'WHERE'
				ll_column ++
            lb_exit = true
            EXIT
         CASE ','
            IF	ll_bracket=0 THEN ll_column ++
            IF ll_column>5 THEN EXIT
      END CHOOSE
   NEXT
   IF lb_exit OR ll_column>5  THEN EXIT
NEXT

RETURN   ll_column
end function

public function integer nf_case_first (string arg_bef, string arg_cur);LONG	ll_first = 0, ll_start = 1, ll_LeftTRIM = 999

STRING	ls_space = '', ls_bef

ls_bef = arg_bef
IF	POS (ls_bef,'~r~n')>0 THEN ls_bef = MID (ls_bef, LASTPOS (ls_bef, '~r~n') + 2)

ls_bef = lower (nf_clear_sqm (nf_clear (ls_bef), true))
IF	POS (ls_bef,'then')>0	Then
	ll_start = PosA (ls_bef,'then') + 4
ElseIF POS (ls_bef,'when')>0	Then
	ll_start = PosA (ls_bef,'when') + 4
End IF

IF	LEFT (arg_cur,2)='||'	Then
	IF	POS (ls_bef,'||',ll_start)>0	Then
		ll_first = PosA (ls_bef,'||',ll_start)
	Else
		ll_first = PosA (ls_bef,'nvl',ll_start) - 3
		IF	POS (UPPER (arg_cur),'COALESCE')>0 And PosA (ls_bef,'coalesce',ll_start)>0 And (PosA (ls_bef,'coalesce',ll_start) - 8)<ll_first THEN ll_first = PosA (ls_bef,'coalesce',ll_start) - 8
		IF	POS (UPPER (arg_cur),'MAX')>0 And PosA (ls_bef,'max',ll_start)>0 And (PosA (ls_bef,'max',ll_start) - 3)<ll_first THEN ll_first = PosA (ls_bef,'max',ll_start) - 3
		IF	POS (UPPER (arg_cur),'SUM')>0 And PosA (ls_bef,'sum',ll_start)>0 And (PosA (ls_bef,'sum',ll_start) - 3)<ll_first THEN ll_first = PosA (ls_bef,'sum',ll_start) - 3
		IF	ll_first=999 THEN ll_first = PosA (ls_bef,'(',ll_start)
		IF	ll_first=0   THEN ll_first = ll_start
	End IF
	RETURN ll_first
End IF
IF	nf_comp ({'+','-','*','/'}, LEFT (arg_cur,1))	Then
	IF	PosA (ls_bef,'+',ll_start)>0                                            THEN ll_LeftTRIM = PosA (ls_bef,'+',ll_start) - 1
	IF	PosA (ls_bef,'-',ll_start)>0 And PosA (ls_bef,'-',ll_start)<ll_LeftTRIM THEN ll_LeftTRIM = PosA (ls_bef,'-',ll_start) - 1
	IF	PosA (ls_bef,'*',ll_start)>0 And PosA (ls_bef,'*',ll_start)<ll_LeftTRIM THEN ll_LeftTRIM = PosA (ls_bef,'*',ll_start) - 1
	IF	PosA (ls_bef,'/',ll_start)>0 And PosA (ls_bef,'/',ll_start)<ll_LeftTRIM THEN ll_LeftTRIM = PosA (ls_bef,'/',ll_start) - 1
	ll_first = IIF (ll_LeftTRIM<999, ll_LeftTRIM, ll_start)
Else
	IF	PosA (ls_bef,'(',ll_start)>0 THEN ll_first = PosA (ls_bef,'(',ll_start) + 1
	IF	PosA (ls_bef,',',ll_start)<ll_first And LEFT (ls_bef,1)=' '	Then
		DO WHILE TRUE
			ls_space += ' '
			ls_bef = MID (ls_bef, 2)
			IF	LEFT (ls_bef,1)<>' ' OR LEN (ls_bef)=0 THEN EXIT
		LOOP
		ll_first = MIN (ll_first, LEN (ls_space) + 1)
	End IF
End IF
RETURN ll_first
end function

public function string wf_dml_merge (string arg_merge);S_WHERE	la_where []

S_RET	pivot

LONG	ll_merge, ll, lm, lm_word, lt, lx, gs_ii
LONG	lw = 0, lw_col, ll_bracket, in_bracket, case_bracket, ll_value, lMax, lAdd

BOOLEAN	lb_first, lb_in_exit, lb_values, lb_between_exit, lb_change
STRING	la_merge [], la_bracket [], ra_word []
STRING	ls_temp, ls_table, ls_alias = 'auto', ls_using_table, ls_using_alias = 'auto', ls_line = ''
STRING	ls_select, ls_text, ls_bracket, ls_fill1, ls_fill2, ls_return, ls_comment, ls_line_comment, ls_space

gl_select_step ++

ll_merge = f_get_array (arg_merge,'~r~n',la_merge)
FOR  ll = 1  TO  ll_merge
	yield ()
	IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_merge [ll]),2))	Then
		IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
		ls_line_comment += wf_line_comment (la_merge, ll_merge, ll, false)
		CONTINUE
	End IF
	lm_word = rt_line (la_merge [ll], ra_word)
	lb_first = true
	FOR  lm = 1  TO  lm_word
		IF	ra_word [lm]='' OR (lb_first And f_null (ra_word [lm])) THEN CONTINUE
		CHOOSE CASE lower (ra_word [lm])
			CASE 'merge'
				ls_comment = ''; lb_in_exit = false
				FOR  ll = ll  TO  ll_merge
					IF	f_null (la_merge [ll]) THEN CONTINUE
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_merge [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (la_merge, ll_merge, ll, false)
						CONTINUE
					End IF
					lm_word = rt_line (la_merge [ll], ra_word)
					FOR  lm = lm  TO  lm_word
						IF	f_null (ra_word [lm]) THEN CONTINUE
  						IF nf_comp ({'as','using'}, ra_word [lm])	Then
							lb_in_exit = true
							lm --
							EXIT
						ElseIF nf_comp ({'merge','into'}, ra_word [lm])	Then
							ls_line += UPPER (ra_word [lm]) + ' '
							CONTINUE
						End IF
						IF	LEFT (ra_word [lm],3)='/*+'	Then
							ls_line += ra_word [lm]
							CONTINUE
						ElseIF nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF
						// merge 테이블
						IF	f_null (ls_table)	Then
							IF	f_notnull (is_asis_table) And RIGHT (UPPER (ra_word [lm]),LEN (is_asis_table))=is_asis_table	Then
								ls_line += is_tobe_table + ' '
								ls_comment = nf_add_comment (ls_comment, is_asis_table + ' --> ' + is_tobe_write)
							Else
								ls_line += UPPER (ra_word [lm]) + ' '
							End IF
							ls_table = UPPER (ra_word [lm])
						ElseIF ls_alias='auto'	Then
							ls_alias = ra_word [lm]
							IF	LenA (ls_alias)=1	Then
								ls_line += ia [gl_select_step] + string(ASC (UPPER (ls_alias)) - 64) + ' '
							Else
								ls_line += ls_alias + ' '
							End IF
						Else
							ls_line += ra_word [lm] + ' '
						End IF
					NEXT
					IF	lb_in_exit THEN EXIT
					lm = 1
				NEXT
				IF	f_notnull (ls_table) And ls_alias='auto'	Then
					ls_alias = ia [gl_select_step] + ia [gl_select_step]
					ls_line += ' ' + ls_alias
				End IF
				IF	f_notnull (ls_comment)	Then
					ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
					ls_comment = ''
				End IF
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return = RIGHTTRIM (ls_return) + ls_line + '~r~n'
				ls_line = ''
				IF	ll>ll_merge THEN EXIT
				CONTINUE
			CASE 'as'
				ls_line += 'AS '
			CASE 'using'
				IF	NOT lb_first THEN ls_line += '~r~n'
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return += RIGHTTRIM (ls_line) + '   USING '
				ls_line = ''; lb_in_exit = false
				FOR  ll = ll  TO  ll_merge
					lm_word = rt_line (la_merge [ll], ra_word)
					FOR  lm = lm + 1  TO  lm_word
						IF	f_null (ra_word [lm]) THEN CONTINUE
						CHOOSE CASE lower (ra_word [lm])
							CASE 'on'
								IF	f_notnull (ls_line_comment)	Then
									ls_return += ls_line_comment
									ls_line_comment = ''
								End IF
								lm --
								lb_in_exit = true
								EXIT
							CASE '('
								pivot = nf_bracket_pivot (la_merge, ll_merge, ll, lm)
								ls_temp = wf_bracket (pivot.text)
								IF	POS (lower (ls_temp),'select')>0	Then
									ls_space = SPACE (11)
								Else
									ls_space = SPACE (9)
								End IF
								IF	POS (ls_temp,'[SELECT-')>0 THEN ls_temp = wf_deselect (ls_temp)
								ls_return += wf_dml ('( ' + ls_temp, ls_space)  + ' )'
								ls_using_table = 'bracket'
								ll = pivot.ll
								lm = pivot.lm
								IF	ll>ll_merge THEN EXIT
								lm_word = rt_line (la_merge [ll], ra_word)	// 변경된 ll 반영
								CONTINUE
						END CHOOSE
						IF	f_null (ls_using_table)	Then
							ls_return = RIGHTTRIM (ls_return) + ' '
							IF	f_notnull (is_asis_table) And RIGHT (UPPER (ra_word [lm]),LEN (is_asis_table))=is_asis_table	Then
								ls_return += is_tobe_table
								ls_comment = nf_add_comment (ls_comment, is_asis_table + ' --> ' + is_tobe_write)
							Else
								ls_return += UPPER (ra_word [lm])
							End IF
							ls_using_table = UPPER (ra_word [lm])
						ElseIF ls_using_alias='auto' And f_notnull (ra_word [lm])	Then
							ls_using_alias = ra_word [lm]
							ls_return = RIGHTTRIM (ls_return) + ' '
							IF	LenA (ls_using_alias)=1	Then
								ls_return += ia [gl_select_step] + string(ASC (UPPER (ls_using_alias)) - 64)
							End IF
						Else
							ls_return += '?' + ra_word [lm]
						End IF
					NEXT
					IF	lb_in_exit THEN EXIT
					IF RIGHT (ls_return,1)<>' ' THEN ls_return += ' '
					lm = 0
				NEXT
				IF	ll>ll_merge THEN EXIT
				CONTINUE
			CASE 'on'
				ls_return += RIGHTTRIM (ls_line)
				ls_line = ''
				IF	f_notnull (ls_using_table) And ls_using_alias='auto' And ls_using_table<>'DUAL'	Then
					ls_using_alias = ia [gl_select_step + 1] + ia [gl_select_step + 1]
					IF	RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)
					ls_return += ' ' + ls_using_alias
				End IF
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return += '  ON ( '
				ll_bracket = 0
				lb_in_exit = false
				FOR  ll = ll  TO  ll_merge
					IF	f_null (la_merge [ll]) THEN CONTINUE
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_merge [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (la_merge, ll_merge, ll, false)
						CONTINUE
					End IF
					lm_word = rt_line (la_merge [ll], ra_word)
					lb_first = TRUE
					FOR  lm = lm + 1  TO  lm_word
						IF	f_null (ra_word [lm]) THEN CONTINUE
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							IF	lw=0	Then
								// where 조건전에 comment가 있는 경우 1 = 1 추가해서 comment 처리
								lw ++
								la_where [lw].w1 = '1'
								la_where [lw].w2 = '='
								la_where [lw].w3 = '1'
								la_where [lw].w4 = ''
								la_where [lw].w5 = 'AND'
								la_where [lw].w6 = ''
							End IF
							la_where [lw].w6 = nf_add_comment (la_where [lw].w6, ra_word [lm])
							CONTINUE
						End IF
						CHOOSE CASE lower (ra_word [lm])
							CASE '('
								ll_bracket ++
								IF	ll_bracket=1	Then
									lw_col = 1 ; lw ++
									la_where [lw].w1 = ''
									la_where [lw].w2 = ''
									la_where [lw].w3 = ''
									la_where [lw].w4 = ''
									la_where [lw].w5 = ''
									la_where [lw].w6 = ''
									CONTINUE
								End IF
								IF	lw_col=1	Then
									la_where [lw].w1 += ra_word [lm]
								Else
									la_where [lw].w3 += ra_word [lm]
								End IF
							CASE ')'
								ll_bracket --
								IF	ll_bracket=0	Then
									lb_in_exit = true
									EXIT
								End IF
								IF	lw_col=1	Then
									la_where [lw].w1 += ra_word [lm]
								Else
									la_where [lw].w3 += ra_word [lm]
								End IF
							CASE 'select'
								ls_select = '' ; in_bracket = 1
								lb_in_exit = FALSE
								FOR  ll = ll  TO  ll_merge
									lm_word = rt_line (la_merge [ll], ra_word)
									FOR  lm = lm  TO  lm_word
										CHOOSE CASE lower (ra_word [lm])
											CASE 'case'
												case_bracket = 0
												FOR  ll = ll  TO  ll_merge
													lm_word = rt_line (la_merge [ll], ra_word)
													FOR  lm = lm  TO  lm_word
														ls_select += ra_word [lm]
														CHOOSE CASE ra_word [lm]
															CASE 'CASE'
															   case_bracket ++
															CASE 'END'
																case_bracket --
																IF	case_bracket=0 THEN EXIT
														END CHOOSE
													NEXT
													IF	case_bracket=0 THEN EXIT
													ls_select += '~r~n'
													lm = 1
												NEXT
												IF	ll>ll_merge THEN EXIT
												CONTINUE
											CASE '('
												in_bracket ++
											CASE ')'
												in_bracket --
												IF	in_bracket=0	Then
													lb_in_exit = TRUE
													EXIT
												End IF
										END CHOOSE
										ls_select += ra_word [lm]
									NEXT
									IF	lb_in_exit THEN EXIT
									IF	f_notnull (ls_select) And RIGHT (ls_select,2)<>'~r~n' THEN ls_select += '~r~n'
									lm = 1
								NEXT
								IF	lw_col=1	Then
									la_where [lw].w1 += wf_dml_select (ls_select)
								Else
									la_where [lw].w3 += wf_dml_select (ls_select)
								End IF
								ll_bracket --
								EXIT
							CASE 'and','or'
								lw_col = 1
								lb_first = FALSE
								lw ++
								la_where [lw].w1 = ''
								la_where [lw].w2 = ''
								la_where [lw].w3 = ''
								la_where [lw].w4 = ''
								la_where [lw].w5 = UPPER (ra_word [lm]) 
								la_where [lw].w6 = ''
								CONTINUE
							CASE 'case','decode'
								ls_text = ra_word [lm]
								IF	lower (ra_word [lm])='case'	Then
									in_bracket = 1 ; ls_fill1 = 'case' ; ls_fill2 = 'end'
								Else
									in_bracket = 0 ; ls_fill1 = '(' ; ls_fill2 = ')'
								End IF
								FOR  ll = ll  TO  ll_merge
									IF	f_null (la_merge [ll]) THEN CONTINUE
									lm_word = rt_line (la_merge [ll], ra_word)
									FOR  lm = lm + 1  TO  lm_word
										ls_text += ra_word [lm]
										CHOOSE CASE lower (ra_word [lm])
											CASE ls_fill1
												in_bracket ++
											CASE ls_fill2
												in_bracket --
												IF	in_bracket=0 THEN EXIT
										END CHOOSE
									NEXT
									IF	in_bracket=0 THEN EXIT
									ls_text += '~r~n'
									lm = 0
								NEXT
								IF	ls_fill1='case'	Then
									IF	lw_col=1	Then
										la_where [lw].w1 += wf_case (ls_text)
									Else
										la_where [lw].w3 += wf_case (ls_text)
									End IF
								Else
									IF	lw_col=1	Then
										la_where [lw].w1 += nf_decode (ls_text)
									Else
										la_where [lw].w3 += nf_decode (ls_text)
									End IF
								End IF
								IF	ll>ll_merge THEN EXIT
							CASE 'between','not between'
								IF	lower (ra_word [lm])='between'	Then
									la_where [lw].w2 += 'Between'
								Else
									la_where [lw].w2 += 'NOT Between'
								End IF
								lw_col = 3
								lb_between_exit = FALSE
								FOR  ll = ll  TO  ll_merge
									lm_word = rt_line (la_merge [ll], ra_word)
									FOR  lm = lm + 1  TO  lm_word
										IF	ra_word [lm]='' THEN CONTINUE
										IF	f_null (ra_word [lm]) And LEFT (ra_word [lm],1)=' ' THEN ra_word [lm] = ' '
										CHOOSE CASE lower (ra_word [lm])
											CASE 'case','decode'
												ls_text = ra_word [lm]
												IF	lower (ra_word [lm])='case'	Then
													in_bracket = 1 ; ls_fill1 = 'case' ; ls_fill2 = 'end'
												Else
													in_bracket = 0 ; ls_fill1 = '(' ; ls_fill2 = ')'
												End IF
												FOR  ll = ll  TO  ll_merge
													IF	f_null (la_merge [ll]) THEN CONTINUE
													lm_word = rt_line (la_merge [ll], ra_word)
													FOR  lm = lm + 1  TO  lm_word
														ls_text += ra_word [lm]
														CHOOSE CASE lower (ra_word [lm])
															CASE ls_fill1
																in_bracket ++
															CASE ls_fill2
																in_bracket --
																IF	in_bracket=0 THEN EXIT
														END CHOOSE
													NEXT
													IF	in_bracket=0 THEN EXIT
													ls_text += '~r~n'
													lm = 0
												NEXT
												IF	ls_fill1='case'	Then
													la_where [lw].w3 += wf_case (ls_text)
												Else
													la_where [lw].w3 += nf_decode (ls_text)
												End IF
											CASE 'and'
												la_where [lw].w3 += 'And '
												lb_between_exit = TRUE
											CASE ELSE
												la_where [lw].w3 += ra_word [lm]
										END CHOOSE
										IF	lb_between_exit THEN EXIT
									NEXT
									IF	lb_between_exit THEN EXIT
									la_where [lw].w3 += '~r~n'
									lm = 0
								NEXT
								IF	ll>ll_merge THEN EXIT
								CONTINUE
							CASE '=','!=','!~~','<=','>=','<','>','<>','<![cdata[<=]]>','<![cdata[>=]]>','<![cdata[<]]>','<![cdata[>]]>','<![cdata[<>]]>', &
								  'in','not in','is null','is not null','like','not like','regexp_like','not regexp_like','exists','not exists','not between'
								la_where [lw].w2 += ra_word [lm]
								lw_col = 3
							CASE '('
								IF	lw_col=1	Then
									IF	f_notnull (la_where [lw].w1) And lb_first THEN la_where [lw].w1 += '~r~n'
								Else
									IF	f_notnull (la_where [lw].w3) And lb_first THEN la_where [lw].w3 += '~r~n'
								End IF
								pivot = nf_bracket_pivot (La_merge, ll_merge, ll, lm)
								IF	lw_col=1	Then
									ls_temp = wf_in (la_where [lw].w1, pivot.text)
									la_where [lw].w1 += wf_move ('(' + ls_temp, 11, false) + ') '
								Else
									ls_temp = wf_in (la_where [lw].w3, pivot.text)
									la_where [lw].w3 += wf_move ('(' + ls_temp, 11, false) + ') '
								End IF
								ll = pivot.ll
								lm = pivot.lm
								IF	ll>ll_merge THEN EXIT
								lm_word = rt_line (la_merge [ll], ra_word)	// 변경된 ll 반영
							CASE '+','-','*','/','^','**','||'
								IF	lw_col=1	Then
									IF	lm>1	Then
										IF	f_null (ra_word [lm - 1])	Then
											la_where [lw].w1 += ' ' + ra_word [lm] + ' '
											CONTINUE
										End IF
									End IF
									IF	(lm + 1)<=lm_word	Then
										IF	f_null (ra_word [lm + 1])	Then
											la_where [lw].w1 += ' ' + ra_word [lm] + ' '
										Else
											la_where [lw].w1 += ra_word [lm]
										End IF
									Else
										la_where [lw].w1 += ra_word [lm]
									End IF
								Else
									IF	lm>1	Then
										IF	f_null (ra_word [lm - 1])	Then
											la_where [lw].w3 += ' ' + ra_word [lm] + ' '
											CONTINUE
										End IF
									End IF
									IF	(lm + 1)<=lm_word	Then
										IF	f_null (ra_word [lm + 1])	Then
											la_where [lw].w3 += ' ' + ra_word [lm] + ' '
										Else
											la_where [lw].w3 += ra_word [lm]
										End IF
									Else
										la_where [lw].w3 += ra_word [lm]
									End IF
								End IF
							CASE ELSE
								IF	lw_col=1	Then
									la_where [lw].w1 += ra_word [lm]
								Else
									la_where [lw].w3 += ra_word [lm]
								End IF
						END CHOOSE
						IF	f_notnull (ra_word [lm]) THEN lb_first = FALSE
					NEXT
					IF	POS (la_where [lw].w1,'~r~n')=0 And POS (la_where [lw].w1,' + ')=0 And POS (la_where [lw].w1,' - ')=0 &
														  And POS (la_where [lw].w1,' * ')=0 And POS (la_where [lw].w1,' / ')=0	&
														  And POS (lower (la_where [lw].w1),' and ')=0 And POS (lower (la_where [lw].w1),' or ')=0	Then
						lMax = MAX (lMax, LenA (nf_clear (la_where [lw].w1)))
					End IF
					IF	lb_in_exit THEN EXIT
					IF	lw_col=1	Then
						la_where [lw].w1 += '~r~n'
					ElseIF lw_col=3	Then
						la_where [lw].w3 += '~r~n'
					End IF
					IF	POS (la_where [lw].w1,'(')=0 And POS (la_where [lw].w1,'CASE')>0 THEN la_where [lw].w1 = '(' + la_where [lw].w1 + ')'
					IF	POS (la_where [lw].w3,'(')=0 And POS (la_where [lw].w3,'CASE')>0 THEN la_where [lw].w3 = '(' + la_where [lw].w3 + ')'
					lm = 0
				NEXT
				// on sort
				FOR  lx = 1  TO  lw
					lb_change = (POS (lower (la_where [lx].w3), lower (ls_alias) + '.')>0)
					IF	NOT lb_change THEN lb_change = ( POS (la_where [lx].w1,'.')=0 And POS (lower (la_where [lx].w3), lower (ls_alias) + '.')>0 )
					IF	lb_change	Then
						CHOOSE CASE la_where [lx].w2
							CASE '<'
								la_where [lx].w2 = '>'
							CASE '>'
								la_where [lx].w2 = '<'
							CASE '<='
								la_where [lx].w2 = '>='
							CASE '>='
								la_where [lx].w2 = '<='
							CASE '<![CDATA[<]]>'
								la_where [lx].w2 = '<![CDATA[>]]>'
							CASE '<![CDATA[>]]>'
								la_where [lx].w2 = '<![CDATA[<]]>'
							CASE '<![CDATA[<=]]>'
								la_where [lx].w2 = '<![CDATA[>=]]>'
							CASE '<![CDATA[>=]]>'
								la_where [lx].w2 = '<![CDATA[<=]]>'
						END CHOOSE
						ls_temp        = la_where [lx].w1
						la_where [lx].w1 = la_where [lx].w3
						la_where [lx].w3 = ls_temp 
					End IF
				NEXT
				FOR  lt = 1  TO  lw
					IF	f_null (la_where [lt].w1) THEN CONTINUE
					IF	lt=1	Then
						ls_fill1 = wf_dml_where_line (lmax, la_where [lt].w1, la_where [lt].w2, la_where [lt].w3, la_where [lt].w4, la_where [lt].w5, la_where [lt].w6, false)
						ls_fill1 = MID (ls_fill1,7)	// 처음 and 제거용
					Else
						ls_fill1 += wf_dml_where_line (lmax, la_where [lt].w1, la_where [lt].w2, la_where [lt].w3, la_where [lt].w4, la_where [lt].w5, la_where [lt].w6, false)
					End IF
				NEXT
				IF	RIGHT (ls_fill1,2)='~r~n' THEN ls_fill1 = LEFT (ls_fill1, LEN (ls_fill1) - 2)
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_temp = ls_return
				ls_space = wf_bracket_space (ls_temp)
				ls_return += wf_move (ls_fill1, LEN (ls_space) - 4, true) + ' )'
				IF	ll>ll_merge THEN EXIT
			CASE 'when'
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return = RIGHTTRIM (ls_return) + ls_line
				ls_line = 'WHEN '
				lb_in_exit = false
				FOR  ll = ll  TO  ll_merge
					lm_word = rt_line (la_merge [ll], ra_word)
					// xml
					IF	LEFT (TRIM (la_merge [ll]),2)='--'	Then
						IF	ls_line='WHEN '	then
							ls_return += la_merge [ll] + '~r~n'
						Else
							ls_line += la_merge [ll] + '~r~n'
						End IF
						CONTINUE
					End IF
					lb_first = true; ls_comment = ''
					FOR  lm = lm + 1  TO  lm_word
						IF	ra_word [lm]='' OR (lb_first And f_null (ra_word [lm])) THEN CONTINUE
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF
						CHOOSE CASE lower (ra_word [lm])
							CASE 'matched','not matched'
								IF	LEFT (ls_line,4)='WHEN' And RIGHT (ls_line,2)='~r~n' THEN ls_line = LEFT (ls_line, LEN (ls_line) - 2) + ' '
								ls_line += ra_word [lm]
							CASE 'then'
								IF	LEFT (ls_line,4)='WHEN' And RIGHT (ls_line,2)='~r~n' THEN ls_line = LEFT (ls_line, LEN (ls_line) - 2) + ' '
								ls_line += 'THEN~r~n'
								lb_in_exit = TRUE
								EXIT
							CASE ELSE
								ls_line += ra_word [lm]
						END CHOOSE
						lb_first = false
					NEXT
					IF	f_notnull (ls_comment)	Then
						ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
						ls_comment = ''
					End IF
					IF	lb_in_exit THEN EXIT
					ls_return += ls_line + '~r~n'
					ls_line = ''
					lm = 0
				NEXT
				IF	ll>ll_merge THEN EXIT
			CASE 'update'
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return = RIGHTTRIM (ls_return) + ls_line + '     UPDATE' ; lm ++
				ls_line = ''
				lb_in_exit = false
				FOR  ll = ll  TO  ll_merge
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_merge [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (la_merge, ll_merge, ll, false)
						CONTINUE
					End IF
					lm_word = rt_line (la_merge [ll], ra_word)
					lb_first = true; ls_comment = ''
					FOR  lm = lm + 1  TO  lm_word
						IF	ra_word [lm]='' OR (lb_first And f_null (ra_word [lm])) THEN CONTINUE
						IF	LEN (ra_word [lm])>1 And POS ('--`//`/*`<!', LEFT (ra_word [lm],2))>0	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF
						CHOOSE CASE lower (ra_word [lm])
							CASE 'set'
								IF	f_notnull (ls_line_comment)	Then
									ls_return += ls_line_comment
									ls_line_comment = ''
								End IF
								ls_return += ls_line ; ls_line = ''
								IF	f_notnull (ls_return) And RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
								ls_return += '        SET '
								ls_text = wf_dml_update_set (ll, lm, la_merge, {'when'}) ; lm --
								ls_return += wf_move (ls_text, 10, false) + '~r~n'
								IF	ll>ll_merge THEN EXIT
								lm_word = rt_line (la_merge [ll], ra_word)	// 변경된 ll 반영
								CONTINUE
							CASE ','
								IF	lb_first	Then
									ls_line = RIGHTTRIM (ls_line) + '          , '
								Else
									ls_line = RIGHTTRIM (ls_line) + '~r~n          , '
								End IF
							CASE '('
								pivot = nf_bracket_pivot (la_merge, ll_merge, ll, lm)
								ls_temp = wf_in (ls_return + ls_line, pivot.text)
								ls_line += wf_move ('(' + ls_temp, 11, false) + ') '
								ll = pivot.ll
								lm = pivot.lm
								IF	ll>ll_merge THEN EXIT
								lm_word = rt_line (la_merge [ll], ra_word)	// 변경된 ll 반영
							CASE 'when'
								lb_in_exit = TRUE
								lm --
								EXIT
							CASE ELSE
								ls_line += ra_word [lm]
						END CHOOSE
						lb_first = FALSE
					NEXT
					IF	f_notnull (ls_comment)	Then
						ls_line = wf_add_comment_num (ls_line, ls_comment, 0, false)
						ls_comment = ''
					End IF
					IF	lb_in_exit THEN EXIT
					IF	f_notnull (ls_line_comment)	Then
						ls_return += ls_line_comment
						ls_line_comment = ''
					End IF
					ls_return += ls_line
					ls_line = ''
					IF	RIGHT(ls_return,4)<>'SET ' THEN ls_return += '~r~n'
					lm = 0
				NEXT
				IF	ll>ll_merge THEN EXIT
			CASE 'insert'
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return = RIGHTTRIM (ls_return) + ls_line + '     INSERT' ; lm ++
				ls_line = ''
				lb_in_exit = false
				FOR  ll = ll  TO  ll_merge
					// xml
					IF	nf_comp ({'--','//','/*','<!'}, LEFT (TRIM (la_merge [ll]),2)) Then
						IF	f_notnull (ls_line_comment) And RIGHT (ls_line_comment,2)<>'~r~n' THEN ls_line_comment += '~r~n'
						ls_line_comment += wf_line_comment (la_merge, ll_merge, ll, false)
						CONTINUE
					End IF
					lm_word = rt_line (la_merge [ll], ra_word)
					lb_first = true; ls_comment = ''
					FOR  lm = lm + 1  TO  lm_word
						IF	ra_word [lm]='' OR (lb_first And f_null (ra_word [lm])) THEN CONTINUE
						IF	nf_comp ({'--','//','/*'}, LEFT (ra_word [lm],2))	Then
							ls_comment = nf_add_comment (ls_comment, ra_word [lm])
							CONTINUE
						End IF
						CHOOSE CASE lower (ra_word [lm])
							CASE '('
								IF	f_notnull (ls_line_comment)	Then
									ls_return += ls_line_comment
									ls_line_comment = ''
								End IF
								ls_return += RIGHTTRIM (ls_line) + ' ( '
								ls_line = ''
								ll_bracket = 1 ; ls_bracket = ''
								FOR  ll = ll  TO  ll_merge
									lm_word = rt_line (la_merge [ll], ra_word)
									FOR  lm = lm + 1  TO  lm_word
										CHOOSE CASE ra_word [lm]
											CASE '('
												ll_bracket ++
											CASE ')'
												ll_bracket --
												IF	ll_bracket=0	Then
													IF	(lm + 2)<=lm_word	Then
														IF	LEFT (ra_word [lm + 2],2)='/*'	Then
															ls_bracket += ra_word [lm + 1] + ra_word [lm + 2]
															lm += 2
														End IF
													End IF
													IF	lb_values THEN lb_in_exit = true
													EXIT
												End IF
										END CHOOSE
										ls_bracket += ra_word [lm]
									NEXT
									IF	ll_bracket=0 THEN EXIT
									ls_bracket += '~r~n'
									lm = 0
								NEXT
								ls_return += wf_bracket_comma (ls_bracket) + SPACE (12) + ')'
								IF	lb_in_exit OR ll>ll_merge THEN EXIT
							CASE 'values'
								lb_values = true
								ls_line = RIGHTTRIM (ls_line) + IIF (POS (lower(la_merge [ll]),'insert')>0,'~r~n','') + '     VALUES'
							CASE 'when'
								lb_in_exit = true
								EXIT
							CASE ELSE
								ls_line += ra_word [lm]
						END CHOOSE
						lb_first = false
					NEXT
					IF	f_notnull (ls_comment)	Then
						ls_line = wf_add_comment_num (ls_line, ls_comment, 0, true)
						ls_comment = ''
					End IF
					IF	f_notnull (ls_line_comment)	Then
						ls_return += ls_line_comment
						ls_line_comment = ''
					End IF
					ls_return += ls_line
					ls_line = ''
					IF	lb_in_exit THEN EXIT
					ls_return += '~r~n'
					lm = 0
				NEXT
				IF	ll>ll_merge THEN EXIT
			CASE 'delete'
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return = RIGHTTRIM (ls_return) + ls_line + '     DELETE'
				ls_line = ''
			CASE '('
				IF	f_notnull (ls_line_comment)	Then
					ls_return += ls_line_comment
					ls_line_comment = ''
				End IF
				ls_return += ls_line ; ls_line = ''
				pivot = nf_bracket_pivot (la_merge, ll_merge, ll, lm)
				ls_temp = wf_in (ls_return + ls_line, pivot.text)
				ls_return += wf_move ('(' + ls_temp, 11, false) + ') '
				ll = pivot.ll
				lm = pivot.lm
				IF	ll>ll_merge THEN EXIT
				lm_word = rt_line (la_merge [ll], ra_word)	// 변경된 ll 반영
			CASE ELSE
				ls_line += nf_1space (ra_word [lm])
				IF	f_notnull (ra_word [lm]) THEN lb_first = FALSE
		END CHOOSE
	NEXT
	IF	f_notnull (ls_line_comment)	Then
		ls_return += ls_line_comment
		ls_line_comment = ''
	End IF
	IF	f_notnull (ls_return) And RIGHT (ls_return,2)<>'~r~n' THEN ls_return += '~r~n'
NEXT
IF	RIGHT (ls_return,2)='~r~n' THEN ls_return = LEFT (ls_return, LEN (ls_return) - 2)

IF	ls_alias<>'auto'	Then
	// alias.+TABLE. 처리 20240320
	IF	POS (ls_table,'.')>0 THEN ls_table = MID (ls_table, POS (ls_table,'.') + 1)
	// 기존 1자리 영문자를 2자리 치환시 중복발생으로 기존영문을 숫자로 변환
	IF	LenA (ls_alias)=1	Then
		ls_temp = ia [gl_select_step] + string(ASC (UPPER (ls_alias)) - 64)
		ls_return = f_replace1 (ls_return, ls_alias+'.', ls_temp+'.')
		ls_alias = ls_temp
	End IF
End IF
IF	ls_using_alias<>'auto'	Then
	// alias.+TABLE. 처리 20240320
	IF	POS (ls_using_table,'.')>0 THEN ls_using_table = MID (ls_using_table, POS (ls_using_table,'.') + 1)
	// 기존 1자리 영문자를 2자리 치환시 중복발생으로 기존영문을 숫자로 변환
	IF	LenA (ls_using_alias)=1	Then
		ls_temp = ia [gl_select_step + 1] + string(ASC (UPPER (ls_using_alias)) - 64)
		ls_return = f_replace1 (ls_return, ls_using_alias+'.', ls_temp+'.')
		ls_using_alias = ls_temp
	End IF
End IF

gl_select_step --

RETURN	nf_clear (ls_return)
end function

public function long rt_file (string arg_line, ref string ra_word[]);LONG  ll, ll_line

BOOLEAN  lb_schema

STRING   ls_varTmp, la_clear [], ls_upper, ls_temp

ra_word   = la_clear
ls_varTmp = arg_line

DO WHILE TRUE
   ll_line ++ ; ra_word [ll_line] = ''
   IF LEFT (ls_varTmp, 1)=' ' Then
      DO WHILE TRUE
         ra_word [ll_line] += ' '
         ls_varTmp         = MID (ls_varTmp, 2)
         IF LEFT (ls_varTmp,1)<>' ' OR LEN (ls_varTmp)=0 THEN EXIT
      LOOP
   ELSE
      DO WHILE TRUE
         IF POS ('`*/`:=`>=`<=`<>`!=`!~~`||`**`', '`' + LEFT (ls_varTmp,2) + '`')>0  Then
            IF LEN (ra_word [ll_line])>0 THEN ll_line ++
            ra_word [ll_line] = LEFT (ls_varTmp, 2)
            ls_varTmp         = MID (ls_varTmp, 3)
            EXIT
         ELSEIF LEFT (ls_varTmp, 1)="'"   Then
            IF LEN (ra_word [ll_line])>0 THEN ll_line ++
            ra_word [ll_line] = "'"
            ls_varTmp         = MID (ls_varTmp, 2)
            DO WHILE TRUE
               IF LEFT (ls_varTmp, 2)="''"   Then
                  ra_word [ll_line] += "''"
                  ls_varTmp         = MID (ls_varTmp, 3)
               ELSEIF LEFT (ls_varTmp, 1)="'"   Then
                  ra_word [ll_line] += "'"
                  ls_varTmp         = MID (ls_varTmp, 2)
                  EXIT
               ELSE
                  ra_word [ll_line] += LEFT (ls_varTmp, 1)
                  ls_varTmp         = MID (ls_varTmp, 2)
               END IF
               IF LEN (ls_varTmp)=0 THEN EXIT
            LOOP
            EXIT
         ELSEIF LEFT (ls_varTmp, 1)='"'   Then
            IF LEN (ra_word [ll_line])>0 THEN ll_line ++
            ra_word [ll_line] = '"'
            ls_varTmp         = MID (ls_varTmp, 2)
            DO WHILE TRUE
               IF LEFT (ls_varTmp, 1)='"' Then
                  ra_word [ll_line] += '"'
                  ls_varTmp         = MID (ls_varTmp, 2)
                  EXIT
               ELSE
                  ra_word [ll_line] += LEFT (ls_varTmp, 1)
                  ls_varTmp         = MID (ls_varTmp, 2)
               END IF
               IF LEN (ls_varTmp)=0 THEN EXIT
            LOOP
            EXIT
         ELSEIF LEFT (ls_varTmp, 1)='['   Then
            IF LEN (ra_word [ll_line])>0 THEN ll_line ++
            ra_word [ll_line] = '['
            ls_varTmp         = MID (ls_varTmp, 2)
            DO WHILE TRUE
               IF LEFT (ls_varTmp,1)=']' THEN EXIT
               ra_word [ll_line] += LEFT (ls_varTmp, 1)
               ls_varTmp         = MID (ls_varTmp, 2)
               IF LEN (ls_varTmp)=0 THEN EXIT
            LOOP
            EXIT
         ELSEIF LEFT (ls_varTmp,1)='*' Then
            IF RIGHT (ra_word [ll_line],1)='.'  Then
               ra_word [ll_line] += '*'
            ELSE
               IF LEN (ra_word [ll_line])>0 THEN ll_line ++
               ra_word [ll_line] = LEFT (ls_varTmp, 1)
            END IF
            ls_varTmp = MID (ls_varTmp, 2)
            EXIT
         ELSEIF POS ('+-',LEFT (ls_varTmp,1))>0 Then
            IF LEN (ra_word [ll_line])>0 THEN ll_line ++
            ra_word [ll_line] = LEFT (ls_varTmp, 1)
            ls_varTmp         = MID (ls_varTmp, 2)
            DO WHILE TRUE
               CHOOSE CASE LEFT (ls_varTmp, 1)
                  CASE '0' TO '9'
                     ra_word [ll_line] += LEFT (ls_varTmp, 1)
                     ls_varTmp         = MID (ls_varTmp, 2)
                     IF LEN (ls_varTmp)=0 THEN EXIT
                  CASE ELSE
                     EXIT
               END CHOOSE
            LOOP
            EXIT
         ELSEIF POS ('{}(),=<>/^;_.\',LEFT (ls_varTmp,1))>0 Then
            IF LEN (ra_word [ll_line])>0 THEN ll_line ++
            ra_word [ll_line] = LEFT (ls_varTmp, 1)
            ls_varTmp         = MID (ls_varTmp, 2)
            EXIT
         ELSEIF LEFT (ls_varTmp, 2)='~r~n'   Then
            IF LEN (ra_word [ll_line])>0 THEN ll_line ++
            ra_word [ll_line] = LEFT (ls_varTmp, 2)
            ls_varTmp         = MID (ls_varTmp, 3)
            EXIT
         ELSE
            ra_word [ll_line] += LEFT (ls_varTmp, 1)
            ls_varTmp         = MID (ls_varTmp, 2)
            IF LEFT (ls_varTmp,1)=' ' OR LEN (ls_varTmp)=0 THEN EXIT
         END IF
      LOOP
   END IF
   IF LEN (ls_varTmp)=0  THEN EXIT
LOOP

RETURN   ll_line
end function

on n_resql.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_resql.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

