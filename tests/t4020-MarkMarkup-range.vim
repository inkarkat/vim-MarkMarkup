" Test :MarkMarkup with range, all marks, and single format.

edit input.txt
call DefineMarks()

let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}
2,$MarkMarkup

call vimtest#SaveOut()
call vimtest#Quit()
