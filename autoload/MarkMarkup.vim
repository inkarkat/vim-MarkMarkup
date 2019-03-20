" MarkMarkup.vim: Convert mark.vim highlighting to markup inside the text.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! MarkMarkup#Parse( markList, arguments ) abort
    if empty(a:markList)
	throw 'MarkMarkup: No marks defined'
    endif

    let l:markNum = len(a:markList)
    let [l:n, l:comma, l:m, l:format] = matchlist(a:arguments, '^\(\d*\)\%(\(,\)\(\d*\)\)\?\s*\(\D.*\)\?$')[1:4]
    let [l:start, l:end] = [0, l:markNum - 1]
    if ! empty(l:n)
	let l:start = max([1, str2nr(l:n)]) - 1
	if empty(l:comma)
	    let l:end = l:start
	endif
    endif
    if ! empty(l:m)
	let l:end = str2nr(l:m) - 1
    endif
    if l:end > l:markNum - 1
	throw 'MarkMarkup: ' . printf('Only %d mark%s defined', l:markNum, (l:markNum == 1 ? '' : 's'))
    elseif l:start > l:end
	throw 'MarkMarkup: Bad range'
    endif

    return [l:start, l:end, l:format]
endfunction
function! MarkMarkup#CollectMarks( markList, startIndex, endIndex ) abort
    " TODO
endfunction

function! s:GetFormat( formats, format ) abort
    if empty(a:formats)
	throw 'MarkMarkup: No formats defined'
    elseif empty(a:format)
	return a:formats[0]
    elseif ! has_key(a:formats, a:format)
	throw 'MarkMarkup: No such format: ' . a:format
    endif

    return a:formats[a:format]
endfunction


function! MarkMarkup#Markup( range, arguments ) abort
    " TODO
endfunction

function! MarkMarkup#Lookup( arguments ) abort
    let l:markList = mark#ToList()
    let [l:start, l:end, l:format] = MarkMarkup#Parse(l:markList, a:arguments)
    let l:marks = MarkMarkup#CollectMarks(l:markList, l:startIndex, l:endIndex)

    let l:LookupFuncref = s:GetFormat(ingo#plugin#setting#GetBufferLocal('MarkMarkup_Lookups'), l:format)
    let l:lookups = map(l:marks, 'call(l:LookupFuncref, [v:val])')
    return (type(l:lookups[0]) == type([]) ?
    \   ingo#collections#Flatten1(l:lookups) :
    \   join(l:lookups, '')
    \)
endfunction
function! MarkMarkup#Put( lnum, arguments ) abort
    try
	let l:lookup = MarkMarkup#Lookup(a:arguments)

	call ingo#lines#PutWrapper(a:lnum, 'put', l:lookup)
	return 1
    catch /^MarkMarkup:/
	call ingo#err#SetCustomException('MarkMarkup')
	return 0
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
