call vimtest#AddDependency('vim-ingo-library')

runtime plugin/MarkMarkup.vim

let g:markList = ['\<foo\>', {'pattern': 'eagle\|pig\|rabbit', 'name': 'animals'}, '\<you\>\|\<me\>', '', '^EOF$']
function! TestLookup( mark ) abort
    return [a:mark.number . ': ' . (empty(a:mark.name) ? a:mark.pattern : a:mark.name)]
endfunction

function! TestBadLookup( mark ) abort
    return 42 + []
endfunction
