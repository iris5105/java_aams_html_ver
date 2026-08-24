forward
global type appeondconfigdatasource from nonvisualobject
end type
end forward

global type appeondconfigdatasource from nonvisualobject
end type
global appeondconfigdatasource appeondconfigdatasource

type variables
AppeonDotNetComponent iobj_appeonloaddbList 


end variables

forward prototypes
public function integer of_deletedatasource (string as_datasourcename)
public function integer of_adddatasource (eon_str_connection astr_connection)
public function integer of_editdatasource (eon_str_connection astr_connection)
end prototypes

public function integer of_deletedatasource (string as_datasourcename);//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeondconfigdatasource::of_deletedatasource
//------------------------------------------------------------------------------
// Description: 
// Delete the specified data source.
//
// Arguments:
//		value        string    as_datasourcename
//								The name of the data source to be deleted.
// Returns:  integer. 
//					 0 - Success.
//					-1 - The parameters are incorrect. Failed to delete the data source.
//					 1 - The data source name does not exist. Failed to delete the data source.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
long ll_Ret
Any la_connectionparam[]

la_connectionparam[1] = as_datasourcename
ll_Ret = iobj_appeonloaddbList.of_ExecInterface("EonDelDataSource",la_connectionparam) 
IF ll_Ret = 0 THEN 
	RETURN iobj_appeonloaddbList.ReturnValue
END IF
RETURN -1

end function

public function integer of_adddatasource (eon_str_connection astr_connection);//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeondconfigdatasource::of_adddatasource
//------------------------------------------------------------------------------
// Description: 
// Create a data source with the specified parameters.
//
// Arguments:
//		value        eon_str_connection    astr_connection
//						  The parameters for the data source.
//
//    			Variable list of the eon_str_connection struct
//						string		s_dbtype
//										The database type of the data source. Supported values are: sqlserver, informix, teradata, mysql, ase, postgresql, db2
//						string		s_datasourcename
//										The name of the data source to be created.
//						string		s_server
//										The machine name or IP address of the database server.
//						string		s_port
//										The port number of the database server.
//						string		s_database
//										The database name.
//						string		s_username
//										The user name of the database.
//						string		s_password
//										The password of the database.
//						string		s_maxpool
//										The maximum number of connections Appeon Server opens and pools on startup.
//						string		s_minpool
//										The minimum number of connections Appeon Server opens and pools on startup.
//						string		s_pooling
//										Whether to use the connection pool. Supported values are: true, false.
//						string		s_connectiontimeout
//										The timeout period (in seconds) for the connection.
//						string		s_commandtimeout
//										The timeout period (in seconds) for the commands.
//						string		s_usedynamicconn
//										Whether to enable dynamic database connection. Supported values are: true, false.
// Returns:  integer. 
//					 0 - Success.
//					-1 - The parameters are incorrect. Failed to create the data source.
//					 1 - The data source name already exist.
//					 2 - The database type is not supported.
//					 3 - The database connection failed.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
Long ll_Ret 
Any la_connectionparam[] 

la_connectionparam[1] =astr_connection.s_dbtype
la_connectionparam[2] = astr_connection.s_datasourcename
la_connectionparam[3] = astr_connection.s_server
la_connectionparam[4] = astr_connection.s_port
la_connectionparam[5] = astr_connection.s_database
la_connectionparam[6] = astr_connection.s_userName
la_connectionparam[7] = astr_connection.s_password
la_connectionparam[8] = astr_connection.s_maxpool
la_connectionparam[9] = astr_connection.s_minpool
la_connectionparam[10] = astr_connection.s_pooling
la_connectionparam[11] = astr_connection.s_connectiontimeout
la_connectionparam[12] = astr_connection.s_commandtimeout
la_connectionparam[13] = astr_connection.s_usedynamicconn

ll_Ret = iobj_appeonloaddbList.of_ExecInterface("EonAddDataSource",la_connectionparam) 
IF ll_Ret = 0 THEN
	Return iobj_appeonloaddbList.ReturnValue
End IF

RETURN -1
end function

public function integer of_editdatasource (eon_str_connection astr_connection);//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeondconfigdatasource::of_editdatasource
//------------------------------------------------------------------------------
// Description: 
// Modify the parameters of the specified data source.
//
// Arguments:
//		value        eon_str_connection    astr_connection
//						 The parameters of the specified data source.
//
//    			Variable list of the eon_str_connection struct
//						string		s_dbtype
//										The database type of the data source. Supported values are: sqlserver, informix, teradata, mysql, ase, postgresql, db2
//						string		s_datasourcename
//										The name of the data source.
//						string		s_server
//										The machine name or IP address of the database server.
//						string		s_port
//										The port number of the database server.
//						string		s_database
//										The database name.
//						string		s_username
//										The user name of the database.
//						string		s_password
//										The password of the database.
//						string		s_maxpool
//										The maximum number of connections Appeon Server opens and pools on startup.
//						string		s_minpool
//										The minimum number of connections Appeon Server opens and pools on startup.
//						string		s_pooling
//										Whether to use the connection pool. Supported values are: true, false.
//						string		s_connectiontimeout
//										The timeout period (in seconds) for the connection.
//						string		s_commandtimeout
//										The timeout period (in seconds) for the commands.
//						string		s_usedynamicconn
//										Whether to enable dynamic database connection. Supported values are: true, false.
// Returns:  integer. 
//					 0 - Success.
//					-1 - The parameters are incorrect. Failed to modify the data source.
//					 1 - The data source name does not exist.
//					 2 - The database type is not supported.
//					 3 - The database connection failed.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

Long ll_Ret 
Any la_connectionparam[]
la_connectionparam[1] = astr_connection.s_dbType
la_connectionparam[2] = astr_connection.s_dataSourceName
la_connectionparam[3] = astr_connection.s_server
la_connectionparam[4] = astr_connection. s_port 
la_connectionparam[5] = astr_connection.s_database
la_connectionparam[6] = astr_connection.s_userName
la_connectionparam[7] = astr_connection.s_password
la_connectionparam[8] = astr_connection.s_maxPool
la_connectionparam[9] = astr_connection.s_minPool
la_connectionparam[10] =astr_connection.s_pooling
la_connectionparam[11] =astr_connection.s_connectionTimeout 
la_connectionparam[12] = astr_connection.s_commandTimeout
la_connectionparam[13] = astr_connection.s_useDynamicConn

ll_Ret = iobj_appeonloaddbList.of_ExecInterface("EonEditDataSource",la_connectionparam) 
IF ll_Ret = 0 THEN
	RETURN iobj_appeonloaddbList.ReturnValue
END IF
RETURN -1


end function

on appeondconfigdatasource.create
call super::create
TriggerEvent( this, "constructor" )
end on

on appeondconfigdatasource.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;iobj_appeonloaddbList = create AppeonDotNetComponent
iobj_appeonloaddblist.componenttype = '4'
iobj_appeonloaddblist.typelib = ''
iobj_appeonloaddblist.classdescript = ''
end event

event destructor;destroy iobj_appeonloaddbList
end event

