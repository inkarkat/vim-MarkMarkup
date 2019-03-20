" Test lookup function throwing exception.

call vimtest#StartTap()
call vimtap#Plan(1)

let g:MarkMarkup_Lookups = {'myformat': function('TestBadLookup')}
call vimtap#err#ThrowsLike('^E745:', "call MarkMarkup#Lookup(g:markList, 'myformat')", 'bad lookup function')

call vimtest#Quit()
