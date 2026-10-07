forward
global type n_transaction from transaction
end type
end forward

global type n_transaction from transaction
end type
global n_transaction n_transaction

type prototypes
subroutine P_AOI_D2D_R1(string PS_SYSID,string PS_YMD,ref string P_RTNCD,ref string P_ERRMSG) RPCFUNC ALIAS FOR "~"INFINITY21_JSLCD~".~"P_AOI_D2D_R1~""

end prototypes

type variables
Private:
	Boolean		connected   	= true
	Boolean		connectweb		= false
	Boolean		autowebdbms	= false

Protected:
	String		cachebyname	= ""
	String		cachedbms	= ""
end variables

forward prototypes
public function boolean connectdb (string as_dbms, string as_server, string as_user, string as_pass, string as_dbparm, boolean ab_autocommit)
public subroutine setcachebyinfo (string as_dbms, string as_cachebyname)
public function boolean connectdb (string as_user, string as_pass)
public function string getcachedbms ()
public subroutine disconnectdb ()
end prototypes

public function boolean connectdb (string as_dbms, string as_server, string as_user, string as_pass, string as_dbparm, boolean ab_autocommit);If Not connected Then
	If Not IsNull(as_dbms) 			Then sqlca.DBMS 			= as_dbms
	If Not IsNull(as_pass) 			Then sqlca.LogPass 		= as_pass
	If Not IsNull(as_server) 		Then sqlca.ServerName 	= as_server
	If Not IsNull(as_user) 			Then sqlca.LogId 			= as_user
	If Not IsNull(ab_autocommit) 	Then sqlca.AutoCommit 	= ab_autocommit
	If Not IsNull(as_dbparm) 		Then sqlca.DBParm 		= as_dbparm

	If gnv_vari.getclienttype = 'WEB' and connectweb Then
		If autowebdbms Then			
			String ls_data
			ls_data = left(upper(sqlca.DBMS), 3)
			If ls_data = 'ORA' Then ls_data = 'O10'
			Choose Case ls_data
				Case 'ASE'
					sqlca.DBMS	= 'ASE Adaptive Server Enterprise'
				Case 'SNC', 'MSS'
					sqlca.DBMS	= 'JDB-MSS'
				Case 'O84', 'O90', 'O10', 'ORA', 'SYC', 'DIR', 'IN9'
					sqlca.DBMS	= 'JDB-' + ls_data
				Case 'I10'
					sqlca.DBMS	= 'JDB-IN7'
				Case 'ODB', 'OLE', 'JDB'
					sqlca.DBMS	= 'JDB-OTH'
				Case Else
					sqlca.DBMS	= 'JDB-OTH'
			End CHoose
		Else
			sqlca.DBMS = cachedbms
		End If
		sqlca.DBParm = "CacheName='" + cachebyname + "'"
	End If
	Connect Using sqlca;
	If sqlca.sqlcode() = 0 Then connected =  true
End If

Return connected
end function

public subroutine setcachebyinfo (string as_dbms, string as_cachebyname);Choose Case gnv_vari.getclienttype
	Case 'WEB'
		Choose Case Lower(as_dbms)
			Case 'auto'
				autowebdbms = true
			Case Else
				cachedbms	= as_dbms
		End Choose
		cachebyname = as_cachebyname
		connectweb = true
End Choose
end subroutine

public function boolean connectdb (string as_user, string as_pass);// Profile ebs
String		ls_null
Boolean	lb_null
setNull(ls_null)
setNull(lb_null)
IF Not connected THEN 
	connected = this.connectdb( sqlca.DBMS, sqlca.ServerName, as_user, as_pass, sqlca.DBParm, sqlca.AutoCommit)
END IF

return connected
end function

public function string getcachedbms ();return cachedbms

end function

public subroutine disconnectdb ();IF connected THEN 
	Disconnect using sqlca;
	connected = false
END IF
end subroutine

on n_transaction.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_transaction.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

