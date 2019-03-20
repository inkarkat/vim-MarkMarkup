" Test preparing the border patterns from patterns.

call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#Is(MarkMarkup#PrepareBorderPatterns(['foo', '\<bar\>']), [['\ze\%(foo\)', '\%(foo\)\zs'], ['\ze\%(\<bar\>\)', '\%(\<bar\>\)\zs']], 'duplicated patterns for start and end')

call vimtest#Quit()
