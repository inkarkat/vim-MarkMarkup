" Test :MarkMarkup with overlapping patterns.

edit input.txt
MarkClear
1Mark! /\<fox\>\|\<s\w\+g\>/
2Mark! /\<fo/
3Mark! /\<foony\>/
4Mark! /\<eagles\>/
5Mark! /\<\w\{6}\>/
6Mark! /\<strong\>/

let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}
MarkMarkup

call vimtest#SaveOut()
call vimtest#Quit()
