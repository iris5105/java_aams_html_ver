forward
global type w_syx1hy from wt_list
end type
end forward

global type w_syx1hy from wt_list
boolean eb_direct_retrieve = true
end type
global w_syx1hy w_syx1hy

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_syx1hy.create
int iCurrent
call super::create
end on

on w_syx1hy.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_syx1hy
end type

type ln_templeft from wt_list`ln_templeft within w_syx1hy
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_syx1hy
end type

type ln_temptop from wt_list`ln_temptop within w_syx1hy
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_syx1hy
end type

type ln_tempstart from wt_list`ln_tempstart within w_syx1hy
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_syx1hy
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_syx1hy
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_syx1hy
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_syx1hy
end type

type ln_tempright from wt_list`ln_tempright within w_syx1hy
end type

type uo_navi from wt_list`uo_navi within w_syx1hy
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_syx1hy
end type

type st_windelaytime from wt_list`st_windelaytime within w_syx1hy
end type

type st_top_rect from wt_list`st_top_rect within w_syx1hy
end type

type p_close from wt_list`p_close within w_syx1hy
end type

type p_excel from wt_list`p_excel within w_syx1hy
end type

type p_print from wt_list`p_print within w_syx1hy
end type

type p_delete from wt_list`p_delete within w_syx1hy
end type

type p_update from wt_list`p_update within w_syx1hy
end type

type p_input from wt_list`p_input within w_syx1hy
end type

type p_retrieve from wt_list`p_retrieve within w_syx1hy
end type

type p_clear from wt_list`p_clear within w_syx1hy
end type

type p_copy from wt_list`p_copy within w_syx1hy
end type

type dw_c from wt_list`dw_c within w_syx1hy
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_list`btn_update within w_syx1hy
end type

type st_count from wt_list`st_count within w_syx1hy
end type

type dw_list from wt_list`dw_list within w_syx1hy
string dataobject = "d_syx1hy_2501"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event dw_list::updatestart;DATETIME	ldt
STRING	ls_cur

LONG	ll
DEC	ldc_gijun_rt, ldc_bm_val

FOR  ll = 1  TO  rowcount ()
   ldt = Object.ymd [ll]
	IF GETITEMSTATUS (ll, 'hkd_gijun_rt', PRIMARY!) = DATAMODIFIED!   Then
		ldc_gijun_rt = dec (Object.hkd_gijun_rt [ll])
		ls_cur       = Object.hkd_cur [ll]
		IF f_null (ls_cur)   Then
			INSERT INTO SYX1HY
			VALUES ( :gaa.CORP_GR
					 , :ldt
					 , 'HKD'
					 , :ldc_gijun_rt
					 , sysdate
					 , NULL
					 ) ;
			IF SQLCA.sqlcode () <> 0   Then
				UPDATE SYX1HY
					SET gijun_rt = :ldc_gijun_rt
					  , ip_ymd   = sysdate
				 WHERE CORP_GR   = :gaa.CORP_GR
					AND gijun_ymd = :ldt
					AND currency  = 'HKD' ;
			END IF
		ELSE
			UPDATE SYX1HY
				SET gijun_rt = :ldc_gijun_rt
				  , ip_ymd   = sysdate
			 WHERE CORP_GR   = :gaa.CORP_GR
				AND gijun_ymd = :ldt
				AND currency  = :ls_cur ;
		END IF
	END IF
	IF GETITEMSTATUS (ll, 'usd_gijun_rt', PRIMARY!) = DATAMODIFIED!   Then
		ldc_gijun_rt = dec (Object.usd_gijun_rt [ll])
		ls_cur       = Object.usd_cur [ll]
		IF f_null (ls_cur)   Then
			INSERT INTO SYX1HY
			VALUES ( :gaa.CORP_GR
					 , :ldt
					 , 'USD'
					 , :ldc_gijun_rt
					 , sysdate
					 , NULL
					 ) ;
			IF SQLCA.sqlcode () <> 0   Then
				UPDATE SYX1HY
					SET gijun_rt = :ldc_gijun_rt
					  , ip_ymd   = sysdate
				 WHERE CORP_GR   = :gaa.CORP_GR
					AND gijun_ymd = :ldt
					AND currency  = 'USD' ;
			END IF
		ELSE
			UPDATE SYX1HY
				SET gijun_rt = :ldc_gijun_rt
				  , ip_ymd   = sysdate
			 WHERE CORP_GR   = :gaa.CORP_GR
				AND gijun_ymd = :ldt
				AND currency  = :ls_cur ;
		END IF
	END IF
	IF GETITEMSTATUS (ll, 'gbp_gijun_rt', PRIMARY!) = DATAMODIFIED!   Then
		ldc_gijun_rt = dec (Object.idr_gijun_rt [ll])
		ls_cur       = Object.idr_cur [ll]
		IF f_null (ls_cur)   Then
			INSERT INTO SYX1HY
			VALUES ( :gaa.CORP_GR
					 , :ldt
					 , 'GBP'
					 , :ldc_gijun_rt
					 , sysdate
					 , NULL
					 ) ;
			IF SQLCA.sqlcode () <> 0   Then
				UPDATE SYX1HY
					SET gijun_rt = :ldc_gijun_rt
					  , ip_ymd   = sysdate
				 WHERE CORP_GR   = :gaa.CORP_GR
					AND gijun_ymd = :ldt
					AND currency  = 'GBP' ;
			END IF
		ELSE
			UPDATE SYX1HY
				SET gijun_rt = :ldc_gijun_rt
				  , ip_ymd   = sysdate
			 WHERE CORP_GR   = :gaa.CORP_GR
				AND gijun_ymd = :ldt
				AND currency  = :ls_cur ;
		END IF
	END IF
	IF GETITEMSTATUS (ll, 'vnd_gijun_rt', PRIMARY!) = DATAMODIFIED!   Then
		ldc_gijun_rt = dec (Object.vnd_gijun_rt [ll])
		ls_cur       = Object.vnd_cur [ll]
		IF f_null (ls_cur)   Then
			INSERT INTO SYX1HY
			VALUES ( :gaa.CORP_GR
					 , :ldt
					 , 'VND'
					 , :ldc_gijun_rt
					 , sysdate
					 , NULL
					 ) ;
			IF SQLCA.sqlcode () <> 0   Then
				UPDATE SYX1HY
					SET gijun_rt = :ldc_gijun_rt
					  , ip_ymd   = sysdate
				 WHERE CORP_GR   = :gaa.CORP_GR
					AND gijun_ymd = :ldt
					AND currency  = 'VND' ;
			END IF
		ELSE
			UPDATE SYX1HY
				SET gijun_rt = :ldc_gijun_rt
				  , ip_ymd   = sysdate
			 WHERE CORP_GR   = :gaa.CORP_GR
				AND gijun_ymd = :ldt
				AND currency  = :ls_cur ;
		END IF
	END IF
	IF GETITEMSTATUS (ll, 'sgd_gijun_rt', PRIMARY!) = DATAMODIFIED!   Then
		ldc_gijun_rt = dec (Object.sgd_gijun_rt [ll])
		ls_cur       = Object.sgd_cur [ll]
		IF f_null (ls_cur)   Then
			INSERT INTO SYX1HY
			VALUES ( :gaa.CORP_GR
					 , :ldt
					 , 'SGD'
					 , :ldc_gijun_rt
					 , sysdate
					 , NULL
					 ) ;
			IF SQLCA.sqlcode () <> 0   Then
				UPDATE SYX1HY
					SET gijun_rt = :ldc_gijun_rt
					  , ip_ymd   = sysdate
				 WHERE CORP_GR   = :gaa.CORP_GR
					AND gijun_ymd = :ldt
					AND currency  = 'SGD' ;
			END IF
		ELSE
			UPDATE SYX1HY
				SET gijun_rt = :ldc_gijun_rt
				  , ip_ymd   = sysdate
			 WHERE CORP_GR   = :gaa.CORP_GR
				AND gijun_ymd = :ldt
				AND currency  = :ls_cur ;
		END IF
	END IF
NEXT
commitJ ();
end event

