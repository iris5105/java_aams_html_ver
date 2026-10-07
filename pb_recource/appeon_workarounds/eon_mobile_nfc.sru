forward
global type eon_mobile_nfc from nonvisualobject
end type
end forward

global type eon_mobile_nfc from nonvisualobject
event oe_newtagfound ( integer ai_type )
event oe_error ( )
end type
global eon_mobile_nfc eon_mobile_nfc

forward prototypes
public function integer of_open ()
public function integer of_close ()
public function integer of_getsize ()
public function integer of_getmaxblockcount ()
public function integer of_getmaxsectorcount ()
public function integer of_getblocksize ()
public function integer of_gettagid (ref string as_tagid)
public function integer of_getndefrecordcount ()
public function integer of_getndefrecord (integer ai_index, ref eon_mobile_str_nfcrecord astr_nfcrecord)
public function integer of_settimeout (integer ai_timeout)
public function integer of_gettimeout ()
public function integer of_setkey (string as_key)
public function integer of_startblockoperate ()
public function integer of_stopblockoperate ()
public function integer of_readblock (integer ai_block, ref blob abl_data)
public function integer of_writeblock (integer ai_block, blob abl_data)
public function integer of_addrecord (eon_mobile_str_nfcrecord astr_nfcrecord)
public function integer of_writerecords ()
end prototypes

event oe_newtagfound(integer ai_type);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_nfc::oe_newtagfound
//------------------------------------------------------------------------------
// Description: 
// Occurs when the card is detected by the reader.
// Supported on mobile client only.		
// 
// Arguments: 
//	integer ai_type:
//		0  MifareClassic     Requires the encryption key, or uses the default key.
//		1  MifareUltralight  Requires no encryption key.
//		2  NfcV                 Requires no encryption key.
//		3  NDEFOnly          Supports read/write NDEF records but does not support read/write data (in bytes) from the block. 
//		4  UNKNOWN         Unrecognizable card types. Cannot read/write from the card, but can get card identifier.

// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
end event

event oe_error();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_nfc::oe_error
//------------------------------------------------------------------------------
// Description: 
// Occurs when there is any error in this functionality.
//	Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-06
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
end event

public function integer of_open ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_open
//------------------------------------------------------------------------------
// Description: 
// Starts the NFC communication.
// Supported on mobile client only.		
// 
// Arguments:
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_close ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_close
//------------------------------------------------------------------------------
// Description: 
// Closes the NFC communication.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_getsize ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_getsize
//------------------------------------------------------------------------------
// Description: 
//			Gets the total capacity of the card. 
//			Supported on mobile client only.		
// 
// Arguments:	None
//	
// Returns:  integer
//					>0 - Returns the total capacity of the card. 
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_getmaxblockcount ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_getmaxblockcount
//------------------------------------------------------------------------------
// Description: 
//			Gets the total number of blocks. 
//			Supported on mobile client only.		
// 
// Arguments:	None
//	
// Returns:  integer
//					>0 - Returns the total number of blocks.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_getmaxsectorcount ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_getmaxsectorcount
//------------------------------------------------------------------------------
// Description: 
//			Gets the total number of sectors. 
//			Supported on mobile client only.		
// 
// Arguments:	None
//	
// Returns:  integer
//					>0 - Returns the total number of sectors. 
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_getblocksize ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_getblocksize
//------------------------------------------------------------------------------
// Description: 
//			Gets the size of the block. 
//			Supported on mobile client only.		
// 
// Arguments:	None
//	
// Returns:  integer
//					>0 - Returns the size of the block. 
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_gettagid (ref string as_tagid);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_getTagID
//------------------------------------------------------------------------------
// Description: 
//		Gets the unique identifier of the card.
//		Supported on mobile client only.	
// 
// Arguments:
//		reference    string    as_tagid
//		Returns the unique identifier of the card; or returns empty string if it is called in PowerBuilder or Appeon Web or if there is any error. 
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
as_tagid = ""
return -1
end function

public function integer of_getndefrecordcount ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_getNdefRecordCount
//------------------------------------------------------------------------------
// Description: 
//			Gets the total number of the NDEF records. 
//			Supported on mobile client only.		
// 
// Arguments:	None
//	
// Returns:  integer
//					>0 - Returns  the total number of the NDEF records. 
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_getndefrecord (integer ai_index, ref eon_mobile_str_nfcrecord astr_nfcrecord);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_getndefrecord
//------------------------------------------------------------------------------
// Description: 
// Gets the NDEF record.
// Supported on mobile client only.		
// 
// Arguments:
//		Integer ai_index;
//					Block indexes which is obtained through of_getMaxBlockCount. 
//					Block indexes are sequential numbers starting from 1.
//		reference    eon_mobile_str_nfcrecord     astr_nfcrecord
//					The record to be read.
//
//    	Variable list of the eon_mobile_str_nfcrecord struct
//					int     i_messagetype;
//						  0 - URL message
//						  1 - Mime message
//						  2 - App message
//						  3 - Text message
//						  4 - Poster message
//						  5 - Alternative carrier message
//						  6 - Handover carrier message
//						  7 - Handover request
//						  8 - Handover select
//						  9 - External message 					
//					String s_Domain;
//						This parameter is required when i_messagetype is External message.
//					String s_Type;
//						data type or MIME type. This parameter is required when i_messagetype is Mime message or External message.
//					String s_Payload;
//						Valid data
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_settimeout (integer ai_timeout);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_setTimeout
//------------------------------------------------------------------------------
// Description: 
//			Sets the timeout value for reading/writing the data. 
//			Supported on mobile client only.		
// 
// Arguments:	
//			integer ai_timeout
//				Timeout value for reading/writing the data. Normally, this parameter needs not to be set. 
//				Only if the read/write operation would take a long time, then this parameter should be set, 
//				otherwise the operation will time out and disconnect automatically. 
//
// Returns:  integer
//					 1 - Set the timeout successfully.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_gettimeout ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_gettimeout
//------------------------------------------------------------------------------
// Description: 
//			Gets the timeout value for reading/writing the data. 
//			Supported on mobile client only.		
// 
// Arguments:	None
//	
// Returns:  integer
//					 1 - Returns the timeout value for reading/writing the data. 
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_setkey (string as_key);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_setkey
//------------------------------------------------------------------------------
// Description: 
//			Sets the read/write encryption key. 
//			Supported on mobile client only.		
// 
// Arguments:	
//			string as_key
//					Encryption key for reading/writing data. Or use the system default key.
//					MIFARE Classic cards require the key. Card types can be obtained through oe_newtagfound event.
//
// Returns: integer
//					 1 - Set the key successfully.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_startblockoperate ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_startBlockOperate
//------------------------------------------------------------------------------
// Description: 
//  Starts the read/write operations on the block. 
//	Supported on mobile client only.		
// 
// Arguments: none
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_stopblockoperate ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_stopBlockOperate
//------------------------------------------------------------------------------
// Description: 
//  Stops the read/write operations on the block.
//	Supported on mobile client only.		
// 
// Arguments:none
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_readblock (integer ai_block, ref blob abl_data);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_readblock
//------------------------------------------------------------------------------
// Description: 
// Reads data (in bytes) from the block.
// Supported on mobile client only.		
// Arguments:
//		integer ai_block
//					Block indexes which is obtained through of_getMaxBlockCount. 
//					Block indexes are sequential numbers starting from 1.
//		reference    blob     abl_data
//					Data that are read from the block. 
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
setnull(abl_data)
return -1
end function

public function integer of_writeblock (integer ai_block, blob abl_data);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_writeblock
//------------------------------------------------------------------------------
// Description: 
//  Writes data (in bytes) to the block.
//	Supported on mobile client only.		
// Arguments:
//		integer ai_block
//					Block indexes which is obtained through of_getMaxBlockCount. 
//					Block indexes are sequential numbers starting from 1.
//		blob     abl_data
//					Data to be written to the block. Block size should be obtained through of_getBlockSize first. 
//					Block size can be 4 bytes or 16 bytes. Data exceeding the block size will be automatically truncated.
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_addrecord (eon_mobile_str_nfcrecord astr_nfcrecord);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_addrecord
//------------------------------------------------------------------------------
// Description: 
// Adds the NDEF record.
// Supported on mobile client only.		
// 
// Arguments:
//		reference    eon_mobile_str_nfcrecord     astr_nfcrecord
//						The record to be added.
//
//    	Variable list of the eon_mobile_str_nfcrecord struct
//					int     i_messagetype;
//						  0 - URL message
//						  1 - Mime message
//						  2 - App message
//						  3 - Text message
//						  4 - Poster message
//						  5 - Alternative carrier message
//						  6 - Handover carrier message
//						  7 - Handover request
//						  8 - Handover select
//						  9 - External message 					
//					string s_Domain;
//						This parameter is required when i_messagetype is External message.
//					string s_Type;
//						data type or MIME type. This parameter is required when i_messagetype is Mime message or External message.
//					string s_Payload;
//						Valid data.
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_writerecords ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_nfc::of_writerecords
//------------------------------------------------------------------------------
// Description: 
//  Writes the NDEF record.
//	Supported on mobile client only.		
//	of_addrecord should be called first to add one or more records, then of_writerecords 
//  should be called to write all these records at one time.
// Arguments: none
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

on eon_mobile_nfc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_nfc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

