" Test reshuffling of the start-end items and flattening into one List.

call vimtest#StartTap()
call vimtap#Plan(2)

call vimtap#Is(MarkMarkup#ReshuffleAndFlatten([[1, 2]]), [1, 2], 'flatten a single pair')
call vimtap#Is(MarkMarkup#ReshuffleAndFlatten([[1, 2], [3, 4]]), [3, 1, 2, 4], 'reshuffle and flatten two pairs')

call vimtest#Quit()
