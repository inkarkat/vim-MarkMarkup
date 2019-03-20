" Test :MarkMarkup errors.

edit input.txt
call DefineMarks()

call vimtest#StartTap()
call vimtap#Plan(2)

let g:MarkMarkup_Formats = {}
call vimtap#err#Errors('No formats defined', 'MarkMarkup', 'no configured lookups')

let g:MarkMarkup_Formats = {'myformat': function('TestBad')}
call vimtap#err#ErrorsLike('^E745:', 'MarkMarkup', 'bad formats function')

call vimtest#SaveOut()
call vimtest#Quit()
