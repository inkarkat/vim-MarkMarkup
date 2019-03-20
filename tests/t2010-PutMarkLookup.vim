" Test :PutMarkLookup with mark numbers and format after the current line.

edit input.txt
call DefineMarks()

let g:MarkMarkup_Lookups = {'myformat': function('TestLookup')}
2
PutMarkLookup 2,3 myformat

call vimtest#SaveOut()
call vimtest#Quit()
