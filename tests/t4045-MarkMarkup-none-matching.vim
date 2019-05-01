" Test :MarkMarkup with marks that all do not match.

edit input.txt
MarkClear
1Mark! /\<foOIsMixspelled\>/
4Mark! /doesNotMatch/
let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}

MarkMarkup

call vimtest#SaveOut()
call vimtest#Quit()
