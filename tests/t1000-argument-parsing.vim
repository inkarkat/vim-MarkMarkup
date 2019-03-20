" Test argument parsing.

call vimtest#StartTap()
call vimtap#Plan(0)

call vimtap#Is(MarkMarkup#Parse([], ''), [-1, -1, ''], 'no arguments and no marks gives empty List')
call vimtap#Is(ingo#err#Get(), 'No marks defined', 'no marks defined error')

call vimtap#Is(MarkMarkup#Parse([], 'myformat'), [-1, -1, ''], 'format argument and no marks gives empty List')
call vimtap#Is(ingo#err#Get(), 'No marks defined', 'no marks defined error')

call vimtap#Is(MarkMarkup#Parse(['m1'], ''), [0, 0, ''], 'no arguments and one mark gives the mark')
call vimtap#Is(MarkMarkup#Parse(['m1', 'm2'], ''), [0, 1, ''], 'no arguments and two marks gives all marks')
call vimtap#Is(MarkMarkup#Parse(['m1', 'm2'], 'myformat'), [0, 1, 'myformat'], 'format argument and two marks')

let s:fourMarks = ['m1', 'm2', 'm3', 'm4']
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '2,3'), [1, 2, ''], 'select the inner 2 from 4 marks')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '2,'), [1, 3, ''], 'select 2- marks')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, ',3'), [0, 2, ''], 'select -3 marks')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '0,3'), [0, 2, ''], 'correct mark 0 to 1')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '1,9'), [-1, -1, ''], 'specify too high end mark')
call vimtap#Is(ingo#err#Get(), 'Only 4 marks defined', 'not enough marks error')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '3,2'), [-1, -1, ''], 'reversed range')
call vimtap#Is(ingo#err#Get(), 'Bad range', 'bad range error')

call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '2,3 myf'), [1, 2, 'myf'], 'select the inner 2 from 4 marks with format')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '2,3myf'), [1, 2, 'myf'], 'select the inner 2 from 4 marks with format')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '2, myf'), [1, 3, 'myf'], 'select 2- marks with format')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '2,myf'), [1, 3, 'myf'], 'select 2- marks with format')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, ',3 myf'), [0, 2, 'myf'], 'select -3 marks with format')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, ',3myf'), [0, 2, 'myf'], 'select -3 marks with format')

call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '3'), [2, 2, ''], 'select third mark')
call vimtap#Is(MarkMarkup#Parse(s:fourMarks, '9'), [-1, -1, ''], 'specify too high mark')
call vimtap#Is(ingo#err#Get(), 'Only 4 marks defined', 'not enough marks error')

call vimtest#Quit()
