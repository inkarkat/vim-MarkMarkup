" Test producing the formats.

call vimtest#StartTap()
call vimtap#Plan(6)

let g:MarkMarkup_Formats = {}
call vimtap#err#Throws('MarkMarkup: No formats defined', "call MarkMarkup#Formats(g:markList, 'myformat')", 'no configured formats')

let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}
let s:expected = [['\<foo\>', 'eagle\|pig\|rabbit', '\<you\>\|\<me\>', '^EOF$'], [['1<', '>1'], ['2<', '>2'], ['3<', '>3'], ['5<', '>5']]]
call vimtap#err#Throws('MarkMarkup: No such format: doesNotExist', "call MarkMarkup#Formats(g:markList, 'doesNotExist')", 'no such format')
call vimtap#Is(MarkMarkup#Formats(g:markList, 'myformat'), s:expected, 'formats for myformat')
call vimtap#Is(MarkMarkup#Formats(g:markList, ''), s:expected, 'formats for sole myformat')

call extend(g:MarkMarkup_Formats, {'another': function('tr')})
call vimtap#err#Throws('MarkMarkup: No {format} passed, but multiple defined: another, myformat', "call MarkMarkup#Formats(g:markList, '')", 'no format but multiple available')
call vimtap#Is(MarkMarkup#Formats(g:markList, 'myformat'), s:expected, 'formats for myformat from multiple')

call vimtest#Quit()
