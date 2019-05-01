" Test expanding pattern branches into separate mark objects.

call vimtest#StartTap()
call vimtap#Plan(4)

let s:plainMark1 = {'pattern': '\<simple\>', 'number': 1, 'name': ''}
let s:plainMark3 = {'pattern': '\<plain\>', 'number': 3, 'name': 'plain'}
let s:branchedMark = {'pattern': '\<foo\>\|bar\|fa\%(n\|xy\)', 'number': 2, 'name': ''}

call vimtap#Is(MarkMarkup#ExpandMarkBranches([s:plainMark1]), [s:plainMark1], 'forwards plain mark')
call vimtap#Is(MarkMarkup#ExpandMarkBranches([s:plainMark1, s:plainMark3]), [s:plainMark1, s:plainMark3], 'forwards plain marks')

call vimtap#Is(MarkMarkup#ExpandMarkBranches([s:branchedMark]), [{'pattern': '\<foo\>', 'number': 2, 'name': ''}, {'pattern': 'bar', 'number': 2, 'name': ''}, {'pattern': 'fa\%(n\|xy\)', 'number': 2, 'name': ''}], 'expands branched mark into individual branches')
call vimtap#Is(MarkMarkup#ExpandMarkBranches([s:plainMark1, s:branchedMark, s:plainMark3]), [s:plainMark1, {'pattern': '\<foo\>', 'number': 2, 'name': ''}, {'pattern': 'bar', 'number': 2, 'name': ''}, {'pattern': 'fa\%(n\|xy\)', 'number': 2, 'name': ''}, s:plainMark3], 'plain and branched marks together')

call vimtest#Quit()
