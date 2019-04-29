" Test :MarkMarkup with overlapping patterns inside a single mark.

edit input.txt
MarkClear
1Mark! /\<pig\>\|pi/
2Mark! /\%3lfo[ox]\|ox\>/
3Mark! /\<EOF\>\|E\|O\|F/
4Mark! /\<strong\>\|ron/
5Mark! /\<rabbits\>\|\<\w\{7}\>/

let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}
MarkMarkup

call vimtest#SaveOut()
call vimtest#Quit()
