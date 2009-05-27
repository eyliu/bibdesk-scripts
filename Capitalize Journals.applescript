(*
This script capitalizes the journal titles of the selected publications 
in Bibdesk using smart capitalization. I.e., 'small' words 
such as the, a, in, for, from, about, ..., are not capitalized, 
unless at the beginning of a sentence, and capitalization is 
supressed between matching braces {}.
It is based on the "Capitalize Titles" script and uses the "Capitalize"
and "Error Reporting" libraries, all of which were written by
Christiaan Hofman
(http://www.physics.rutgers.edu/~hofman/applescript/). 
This script requires Bibdesk 0.97 or higher. 
*)

-- load the script library for capitalization
set capitalizeLib to (load script file Â
	((path to home folder as string) & "Library:ScriptingAdditions:Capitalize.scpt"))
-- load the Error Reporting script library
set errorLib to (load script file Â
	((path to home folder as string) & "Library:ScriptingAdditions:Error Reporting.scpt"))
-- we only report all errors at the end
tell errorLib
	delayReportErrors()
	set its defaultErrorFileName to "BibdeskScriptErrors"
end tell

tell application "BibDesk"
	activate
	
	-- without document, there is no selection, so nothing to do
	if (count of documents) = 0 then
		beep
		display dialog "No documents found." buttons {"¥"} default button 1 giving up after 3
	end if
	set thePublications to the selection of document 1
	
	tell capitalizeLib
		-- protect chars between balanced {} 
		set its startProtectChar to "{"
		set its endProtectChar to "}"
		
		repeat with thePub in thePublications
			try
				set theJournal to the value of field "Journal" of thePub
				set theJournal to capitalize(theJournal)
				set the value of field "Journal" of thePub to theJournal
			on error errorMessage number errorNumber
				tell errorLib to reportError(errorMessage, errorNumber)
			end try
		end repeat
		
	end tell -- capitalizeLib
	
	set selection of document 1 to thePublications
	
end tell -- Bibdesk

-- see if we had any errors
tell errorLib to checkForErrors()

-- we're done!
beep
display dialog "Changed " & (count of thePublications) & " publications." buttons {"¥"} default button 1 giving up after 3
