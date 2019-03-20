" Test lookup.

call vimtest#StartTap()
call vimtap#Plan(6)

let g:MarkMarkup_Lookups = {}
call vimtap#err#Throws('MarkMarkup: No formats defined', "call MarkMarkup#Lookup(g:markList, 'myformat')", 'no configured lookups')

let g:MarkMarkup_Lookups = {'myformat': function('TestLookup')}
let s:expected = ['1: \<foo\>', '2: animals', '3: \<you\>\|\<me\>', '5: ^EOF$']
call vimtap#err#Throws('MarkMarkup: No such format: doesNotExist', "call MarkMarkup#Lookup(g:markList, 'doesNotExist')", 'no such format')
call vimtap#Is(MarkMarkup#Lookup(g:markList, 'myformat'), s:expected, 'lookup for myformat')
call vimtap#Is(MarkMarkup#Lookup(g:markList, ''), s:expected, 'lookup for sole myformat')

call extend(g:MarkMarkup_Lookups, {'another': function('tr')})
call vimtap#err#Throws('MarkMarkup: No {format} passed, but multiple defined: another, myformat', "call MarkMarkup#Lookup(g:markList, '')", 'no format but multiple available')
call vimtap#Is(MarkMarkup#Lookup(g:markList, 'myformat'), s:expected, 'lookup for myformat from multiple')

call vimtest#Quit()
