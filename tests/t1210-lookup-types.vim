" Test lookup returning different variable types.

function! TestLookupString( mark ) abort
    return ' - ' . a:mark.number . ': ' . a:mark.pattern
endfunction

call vimtest#StartTap()
call vimtap#Plan(1)

let g:MarkMarkup_Lookups = {'myformat': function('TestLookupString')}
call vimtap#Is(MarkMarkup#Lookup(g:markList, 'myformat'), ' - 1: \<foo\> - 2: eagle\|pig\|rabbit - 3: \<you\>\|\<me\> - 5: ^EOF$', 'lookup for myformat as concatenated String')

call vimtest#Quit()
