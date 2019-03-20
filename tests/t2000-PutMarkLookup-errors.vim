" Test :PutMarkLookup errors.

edit input.txt
call DefineMarks()

call vimtest#StartTap()
call vimtap#Plan(2)

let g:MarkMarkup_Lookups = {}
call vimtap#err#Errors('No formats defined', '$PutMarkLookup', 'no configured lookups')

let g:MarkMarkup_Lookups = {'myformat': function('TestBad')}
call vimtap#err#ErrorsLike('^E745:', '$PutMarkLookup', 'bad lookup function')

call vimtest#SaveOut()
call vimtest#Quit()
