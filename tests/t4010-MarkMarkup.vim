" Test :MarkMarkup with mark numbers and format after the current line.

edit input.txt
call DefineMarks()

let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}
2
MarkMarkup 2,3 myformat

call vimtest#SaveOut()
call vimtest#Quit()
