forward
global type appeonextfuncs from nonvisualobject
end type
end forward

global type appeonextfuncs from nonvisualobject
end type
global appeonextfuncs appeonextfuncs

forward prototypes
public function string of_getappeonusername ()
public function string of_getbrowserversion ()
public function string of_getclienttype ()
public function string of_gethttpinfo (string attribute)
public function string of_getostype ()
public function long of_getsessioncount (string servername, string appname)
public subroutine of_popmenu (datawindow adw_dw, integer nx, integer ny)
public subroutine of_popmenuon (datawindow adw_dw, boolean ab_show)
public function string of_getclientid ()
public function string of_getclientip ()
public function integer of_getservertype ()
public function string of_getcachedir ()
public function long of_getiehandle ()
public function string of_getieurl ()
public function string of_ldaplogon (string as_username, string as_password)
public function long of_print2file (powerobject adw, string asoutpath, string asoutname, long alouttype)
public function boolean of_is64browser ()
public function integer of_print2pdf (powerobject adw)
public function integer of_clearlog ()
public function integer of_log (integer ai_level, string as_info)
public function string of_getrunmode ()
public function integer of_switchrealtimecalc (powerobject adw, integer para)
public function integer of_sethinttext (singlelineedit sle_target, string as_hinttext)
public function integer of_getappeonadtversion (ref string as_version)
public function integer of_getappeonwebversion (ref string as_version)
end prototypes

public function string of_getappeonusername ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getappeonusername()
//------------------------------------------------------------------------------
// Description: 
// 				Returns the User Name that a user types into the Appeon Web Login dialogue box.
//	
// Arguments:(None)
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

RETURN ''

end function

public function string of_getbrowserversion ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getbrowserversion()
//------------------------------------------------------------------------------
// Description: 
// 				Returns Internet Explorer version of the client.
//	
// Arguments:(None)
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

RETURN ""

end function

public function string of_getclienttype ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getclienttype()
//------------------------------------------------------------------------------
// Description: 
// 				Gets the type of an application. 
//                Returns "PB" if the application runs in PowerBuilder.
//	
// Arguments: (None)	
//	
// Returns:  string
//        WEB     :Runs on the Web .
//        PB      :Runs in the PowerBuilder enviorment.
//        MOBILE  :Runs on the Mobile.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

RETURN "PB"

end function

public function string of_gethttpinfo (string attribute);//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_gethttpinfo()
//------------------------------------------------------------------------------
// Description: 
//               Returns the HTTP header information from a particular request.
//	
// Arguments: 
//		value	string	attribute : The HTTP information that need to be known.		
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

RETURN ""
end function

public function string of_getostype ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getostype()
//------------------------------------------------------------------------------
// Description: 
// 				Returns the type of OS that runs your application.
//	
// Arguments:(None)
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

environment lenv
Integer li_return

li_return = GetEnvironment(lenv)

IF li_return <> 1 THEN RETURN ''

CHOOSE CASE lenv.OSType
	CASE aix!
		RETURN 'aix'
	CASE Windows!
		RETURN 'Windows'
	CASE WindowsNT!
		RETURN 'WindowsNT'
	CASE hpux!
		RETURN 'hpux'
	CASE macintosh!
		RETURN 'macintosh'
	CASE osf1!
		RETURN 'osf1'
	CASE sol2!
		RETURN 'sol2'
	CASE ELSE
		RETURN ''
END CHOOSE


end function

public function long of_getsessioncount (string servername, string appname);//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_GetSessionCount()
//------------------------------------------------------------------------------
// Description: 
//				Returns the total number of active sessions currently on a cluster.
//				If there is no cluster configured in AEM, it gets all the active sessions
//				for a single named application or all applications in Appeon Server.
//	
// Arguments: 
//		string	servername : The name of the server. 	
//		string	appname :  The name of the application.  		
//	
// Returns:  long
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

RETURN 0;
end function

public subroutine of_popmenu (datawindow adw_dw, integer nx, integer ny);//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_popmenu()
//------------------------------------------------------------------------------
// Description: 
//				Pops up Appeon DataWindow menu at a specified position in a 
//				specified DataWindow control.
// 
// Arguments: 
//		datawindow	adw_dw	: DataWindow control.	
//		integer nx : The x-axis of the popup menu.    		
//		integer ny : The y-axis of the popup menu.   		
//	
// Returns:  (none)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

end subroutine

public subroutine of_popmenuon (datawindow adw_dw, boolean ab_show);//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_popmenuon()
//------------------------------------------------------------------------------
// Description: 
//				Enable or disable the right mouse button menu of a specific 
//               Appeon DataWindow. 
//	
// Arguments: 
//		datawindow	adw_dw : DataWindow control. 		
//		boolean ab_show : Enable right mouse button.	
//	
// Returns:  (none)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================


end subroutine

public function string of_getclientid ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::appeongetclientid()
//------------------------------------------------------------------------------
// Description: 
// 				Returns the unique session identifier for the Internet Explorer client.
//	
// Arguments:(None)
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

String ls_IP,ls_SessionID
appeonservice lnv_service
String ls_array[]
Int	li_count,li_i

//Gets IP Address
ls_IP = AppeonGetClientIP()

//Convert to array
li_count = lnv_service.of_ParseToArray(ls_IP,'.',ls_array)

FOR li_i = 1 TO li_count
	ls_SessionID += String(Integer(ls_array[li_i]),'000')
NEXT

//Gets SessionID
Randomize(32767)
ls_SessionID += String(Rand(32767),'00000')

RETURN ls_SessionID
end function

public function string of_getclientip ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::appeongetclientip()
//------------------------------------------------------------------------------
// Description: 
// 				Returns the IP address of the Internet Explorer client.
//	
// Arguments:(None)
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

String ls_IPAddress
appeonservice	lnv_service

//Gets Local Host IP Address
IF lnv_service.of_GetIPAddress(ls_IPAddress) = 1 THEN
	RETURN ls_IPAddress
ELSE
	RETURN ''
END IF


end function

public function integer of_getservertype ();//==============================================================================
// 
// Copyright ? 2001-2008 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeongetservertype()
//------------------------------------------------------------------------------
// Description: 
// 				Returns the type of Appeon Server that runs your application.
//	
// Arguments:(None)
//	
// Returns:  integer
//					1 -- J2EE Server
//					2 -- .Net Server
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2008-2
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================


return 1
end function

public function string of_getcachedir ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getbrowserversion()
//------------------------------------------------------------------------------
// Description: 
// 				Returns Internet Explorer Cache Directory. Only useful in B/S mode.
//	
// Arguments:(None)
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2008-2
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

//

return ""
end function

public function long of_getiehandle ();//==============================================================================
// 
// Copyright ? 2001-2008 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeongetiehandle()
//------------------------------------------------------------------------------
// Description: 
// 				Returns the running IE handle of the Internet Explorer client.
//					Only significative in B/S mode.
// Arguments:(None)
//	
// Returns:  long
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2008-2
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return 0
end function

public function string of_getieurl ();//==============================================================================
// 
// Copyright ? 2001-2008 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeongetiehandle()
//------------------------------------------------------------------------------
// Description: 
// 				Returns the running IE URL of the Internet Explorer client.
//					Only significative in B/S mode.
// Arguments:(None)
//	
// Returns:  string
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2008-2
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return ""
end function

public function string of_ldaplogon (string as_username, string as_password);//==============================================================================
// 
// Copyright ? 2001-2008 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: of_ldaplogon()
//------------------------------------------------------------------------------
// Description: 
// 				Check LDAP security settings according to giving UserName and Password.
// Arguments:(None)
//	
// Returns:  string
//                 ""   Blank string indicates logon successfully.
//                 Other string indicates some error occurs.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2008-3
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return ""
end function

public function long of_print2file (powerobject adw, string asoutpath, string asoutname, long alouttype);//==============================================================================
// 
// Copyright ? 2009-2012 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: of_print2file()
//------------------------------------------------------------------------------
// Description: 
// 				Prints the specified DataWindow/DataStore as a file on Client.
//	
// Arguments: 
//		powerobject	 adw - datawindow/datastore that will print
//      string asoutpath   - output directory
//      string asoutname   - output name
//      long alouttype      - output file type, currently can support 3 types:
//                                   1: BMP, 2: JPG, 3:GIF
//	
// Returns:  integer 1 when sucessful otherwise less than zero
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2009-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return 0
end function

public function boolean of_is64browser ();//==============================================================================
// 
// Copyright ? 2001-2010 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_is64browser()
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

RETURN false
end function

public function integer of_print2pdf (powerobject adw);//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::appeonprint2pdf()
//------------------------------------------------------------------------------
// Description: 
// 				Prints the specified DataWindow/DataStore as a PDF file with the 
//                PDFPrinter on the Appeon Server.
//
// Arguments: 
//		powerobject	adw : The datawindow or datastore that will be printed.
//	
// Returns:  integer 1 when suceeded. Otherwise returns -1.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2005-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

Int nRet = -1
IF adw.TypeOf() = datawindow! OR adw.TypeOf() = datastore! THEN
	nRet = adw.DYNAMIC Print()
END IF

RETURN nRet
end function

public function integer of_clearlog ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_logex::of_clearlog
//------------------------------------------------------------------------------
// Description:
//		Clears the Appeon application log file on the client-side.
// 
// Arguments: None
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-06-25
//------------------------------------------------------------------------------
// Revision History: 
//				1.5   Initial version
//==============================================================================


return -1
end function

public function integer of_log (integer ai_level, string as_info);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_log
//------------------------------------------------------------------------------
// Description: 
//		Generates the Appeon application log file on the client-side.
//		Supported on mobile and web client.		
// 
// Arguments:
//		value    integer    ai_level
//					1 - FATAL level.
//					2 - ERROR level.
//					3 - WARNING level.
//					4 - INFO level.
//					5 - DEBUG level. 
//
//		value    string     as_info
//					The log information. 	
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-06-25
//------------------------------------------------------------------------------
// Revision History: 
//				1.5   Initial version
//==============================================================================
return -1
end function

public function string of_getrunmode ();//==============================================================================
// 
// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getrunmode
//------------------------------------------------------------------------------
// Description: 
// 				Returns the application's deploy mode like as RELEASE/DEBUG.
//	
// Arguments:(None)
//	
// Returns:  string
//         RELEASE     Deploy as RELEASE mode.
//         DEBUG       Deploy as debug js or dubug ps/js mode. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.5   Initial version
//==============================================================================

return ""
end function

public function integer of_switchrealtimecalc (powerobject adw, integer para);//==============================================================================
// 
// Copyright ? 2001-2011 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_switchRealTimeCalc()
//------------------------------------------------------------------------------
// Description: 
//				Configure datawindow realtime expression calc in time or only
//				calcuated 1 time in whole life-cycle
//	
// Arguments: 
//		powerobject : datawindow/datastore/datawindowchild reference
//		integer:  0 - default value, need to realtime calc;
//					1 - needn't to realtime calc;
//	
// Returns:  integer
//------------------------------------------------------------------------------
// Author:	Isaac	2011-05-17
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

RETURN 0

end function

public function integer of_sethinttext (singlelineedit sle_target, string as_hinttext);// Copyright ? 2001-2006 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_sethinttext
//------------------------------------------------------------------------------
// Description: 
//				Sets the singlelineedit hinttext property.
//      
// Arguments: 
//				singlelineedit   sle_target                  
//				string   as_hinttext    
// Returns:  integer
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2014-12
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.5   Initial version
//==============================================================================


return 0
end function

public function integer of_getappeonadtversion (ref string as_version);//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getappeonadtversion
//------------------------------------------------------------------------------
// Description: 
//		Gets the version number of Appeon Developer. 
// 
// Arguments:
//		reference    string		as_version
//		Returns the Appeon Developer version number; returns empty string if there is any error. 
//
// Returns: integer
//					 1 - Success.
//					-1 - there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2015-12
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
as_version=""
return -1
end function

public function integer of_getappeonwebversion (ref string as_version);//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: appeonextfuncs::of_getappeonwebversion
//------------------------------------------------------------------------------
// Description: 
//		Gets the version number of Appeon Weblibrary. 
//		Supported on web client only.		
// 
// Arguments:
//		reference    string		as_version
//		Returns the Appeon weblibrary version number; returns empty string if it is called in mobile client  or if there is any error. 
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in Mobile client, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2015-12
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
as_version=""
return -1
end function

on appeonextfuncs.create
call super::create
TriggerEvent( this, "constructor" )
end on

on appeonextfuncs.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

