" Test :PutMarkLookup with lnum, all marks, and single format.

edit input.txt
call DefineMarks()

let g:MarkMarkup_Lookups = {'myformat': function('TestLookup')}
2
%PutMarkLookup

call vimtest#SaveOut()
call vimtest#Quit()
