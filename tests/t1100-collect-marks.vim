" Test collecting selected marks.

call vimtest#StartTap()
call vimtap#Plan(3)

let s:markList = ['\<foo\>', {'pattern': 'eagle\|pig\|rabbit', 'name': 'animals'}, '\<you\>\|\<me\>', '', '^EOF$']
call vimtap#Is(MarkMarkup#CollectMarks(s:markList, 0, len(s:markList) - 1), [
\   {'number': 1, 'name': '', 'pattern': '\<foo\>'},
\   {'number': 2, 'name': 'animals', 'pattern': 'eagle\|pig\|rabbit'},
\   {'number': 3, 'name': '', 'pattern': '\<you\>\|\<me\>'},
\   {'number': 5, 'name': '', 'pattern': '^EOF$'},
\], 'collect all marks')

call vimtap#Is(MarkMarkup#CollectMarks(s:markList, 2, 2), [
\   {'number': 3, 'name': '', 'pattern': '\<you\>\|\<me\>'},
\], 'collect a single mark')

call vimtap#Is(MarkMarkup#CollectMarks(s:markList, 1, len(s:markList) - 2), [
\   {'number': 2, 'name': 'animals', 'pattern': 'eagle\|pig\|rabbit'},
\   {'number': 3, 'name': '', 'pattern': '\<you\>\|\<me\>'},
\], 'collect marks from the middle')

call vimtest#Quit()
