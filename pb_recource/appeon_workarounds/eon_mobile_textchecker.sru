forward
global type eon_mobile_textchecker from nonvisualobject
end type
end forward

global type eon_mobile_textchecker from nonvisualobject
end type
global eon_mobile_textchecker eon_mobile_textchecker

forward prototypes
public function integer of_getmisspelledword (eon_mobile_str_textcheckoption astr_textcheckoption, ref long al_start, ref long al_length)
public function integer of_guessesforword (eon_mobile_str_textcheckoption astr_textcheckoption, ref string as_guesses[])
public function integer of_completionsforpartialword (eon_mobile_str_textcheckoption astr_textcheckoption, ref string as_completions[])
public function integer of_getignoredwords (ref string as_words[])
public function integer of_setignoredwords (string as_words[])
public function integer of_getlanguages (ref string as_languages[])
public function integer of_haslearnedword (string as_word)
public function integer of_learnword (string as_word)
public function integer of_unlearnword (string as_word)
end prototypes

public function integer of_getmisspelledword (eon_mobile_str_textcheckoption astr_textcheckoption, ref long al_start, ref long al_length);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_getmisspelledword
//------------------------------------------------------------------------------
// Description: 
// Gets the range of the first misspelled word encountered.
//	Supported on mobile client only.		
// 
// Arguments:
//		value        eon_mobile_str_textcheckoption    astr_textcheckoption
//						 Sets the check option.
//
//    			Variable list of the eon_mobile_str_textcheckoptio struct
//						string		s_source
//										The string which you want to check.
//						long			l_start
//										A long indicating where the check will begin in s_source.
//						long			l_length
//										Starting from the position specified by l_start, the number of characters needed to be checked.
//						string		s_language
//										The language of the words to be checked for correct spelling.
//
//		reference    long                              al_start
//						 Returns a long whose value is the starting position of the first misspelled word.
//		reference    long                              al_length	
//						 Returns a long whose value is the length of the first misspelled word.
//	
// Returns:  integer. 
//					 1 - Found the misspelled word.
//					 0 - Found no misspelled words.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return -1
end function

public function integer of_guessesforword (eon_mobile_str_textcheckoption astr_textcheckoption, ref string as_guesses[]);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_guessesforword
//------------------------------------------------------------------------------
// Description: 
// Returns an array of strings that are possible completions for a partially entered word.
//	Supported on mobile client only.		
// 
// Arguments:
//		value        eon_mobile_str_textcheckoption    of_guessesforword
//						 Sets the check option.
//
//    			Variable list of the eon_mobile_str_textcheckoptio struct
//						string		s_source
//										The string which you want to check.
//						long			l_start
//										A long indicating where the check will begin in s_source.
//						long			l_length
//										Starting from the position specified by l_start, the number of characters needed to be checked.
//						string		s_language
//										The language of the words to be checked for correct spelling.
//
//		reference    string      as_guesses[]
//						 Returns an array of strings each of which might be a correct substitute (that is, a guess) for a misspelled word in the given range of the string.
//						 If no possible guesses are found, the method returns an empty array.
//	
// Returns:  integer. 
//					 1 - Found possible guesses.
//					 0 - Found no possible guesses.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return -1
end function

public function integer of_completionsforpartialword (eon_mobile_str_textcheckoption astr_textcheckoption, ref string as_completions[]);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_completionsforpartialword
//------------------------------------------------------------------------------
// Description: 
// Returns a list of words that are possible valid replacements for a misspelled word.
//	Supported on mobile client only.		
// 
// Arguments:
//		value        eon_mobile_str_textcheckoption    astr_textcheckoption
//						 Sets the check option.
//
//    			Variable list of the eon_mobile_str_textcheckoptio struct
//						string		s_source
//										The string which you want to check.
//						long			l_start
//										A long indicating where the check will begin in s_source.
//						long			l_length
//										Starting from the position specified by l_start, the number of characters needed to be checked.
//						string		s_language
//										The language of the words to be checked for correct spelling.
//
//		reference    string      as_completions[]
//						 Returns an array of strings, each of which is a completion of a partially entered word represented by range in string.
//						 If no possible completions are found, the method returns an empty array.
//	
// Returns:  integer. 
//					 1 - Found possible completions.
//					 0 - Found no possible completions.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return -1
end function

public function integer of_getignoredwords (ref string as_words[]);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_getignoredwords
//------------------------------------------------------------------------------
// Description: 
// Returns the words that the receiver ignores when spell-checking.
// The spell checker excludes ignored words as misspelled words during the current spell-checking session only.
//	Supported on mobile client only.		
// 
// Arguments:
//		reference    string    as_words[]	
//						 Returns an array of strings, each of which specifies a word the receiver ignores.	
//	
// Returns:  integer. 
//					 1 - Found any ignored words.
//					 0 - Found no ignored words.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return -1
end function

public function integer of_setignoredwords (string as_words[]);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_setignoredwords
//------------------------------------------------------------------------------
// Description: 
// Sets the list of words that the receiver should ignore, and the ignored words are not treated as misspelled words.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_words[]	
//					Sets an array of strings, each of which specifies a word the receiver should ignore.		
//	
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

public function integer of_getlanguages (ref string as_languages[]);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_getlanguages
//------------------------------------------------------------------------------
// Description: 
// Gets the languages for which the text checker can perform spell-checking.
//	Supported on mobile client only.		
// 
// Arguments:
//		reference    string    as_languages[]	
//						 Returns an array of strings representing ISO 639-1 language codes or combined ISO 639-1 language codes
//						 and ISO 3166-1 regional codes (for example, en_US).	
//	
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

public function integer of_haslearnedword (string as_word);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_haslearnedword
//------------------------------------------------------------------------------
// Description: 
// Detects if the text checker has learned the specified word.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_word	
//					A string representing a word.	
//	
// Returns:  integer. 
//					 1 - The text check has learned the word.
//					 0 - The text check hasn't learned the word.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

return -1
end function

public function integer of_learnword (string as_word);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_learnword
//------------------------------------------------------------------------------
// Description: 
// Tells the text checker to learn the specified word so that it is not evaluated as misspelled.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_word	
//					A string representing the word for the text checker to learn.		
//	
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

public function integer of_unlearnword (string as_word);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_textchecker::of_unlearnword
//------------------------------------------------------------------------------
// Description: 
// Tells the text checker to unlearn the specified word.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_word	
//					A string representing the word for the text checker to unlearn.	
//	
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

on eon_mobile_textchecker.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_textchecker.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

