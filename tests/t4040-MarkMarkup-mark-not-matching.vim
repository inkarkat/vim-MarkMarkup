" Test :MarkMarkup with one mark that does not match.

edit input.txt
call DefineMarks()
4Mark! /doesNotMatch/
let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}

MarkMarkup

call vimtest#SaveOut()
call vimtest#Quit()
