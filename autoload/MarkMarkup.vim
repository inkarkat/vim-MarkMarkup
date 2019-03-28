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

function! s:BuildMarkObject( index, mark ) abort
    return extend(ingo#dict#Make(a:mark, 'pattern'), {'number': a:index + 1, 'name': ''}, 'keep')
endfunction
function! MarkMarkup#CollectMarks( markList, startIndex, endIndex ) abort
    return filter(
    \   map(
    \       range(a:startIndex, a:endIndex),
    \       's:BuildMarkObject(v:val, a:markList[v:val])'
    \   ), '! empty(v:val.pattern)'
    \)
endfunction

function! s:GetFormat( formats, format ) abort
    if empty(a:formats)
	throw 'MarkMarkup: No formats defined'
    elseif empty(a:format)
	if len(a:formats) == 1
	    return values(a:formats)[0]
	else
	    throw 'MarkMarkup: No {format} passed, but multiple defined: ' . join(sort(keys(a:formats)), ', ')
	endif
    elseif ! has_key(a:formats, a:format)
	throw 'MarkMarkup: No such format: ' . a:format
    endif

    return a:formats[a:format]
endfunction


function! MarkMarkup#Formats( markList, arguments ) abort
    let [l:startIndex, l:endIndex, l:format] = MarkMarkup#Parse(a:markList, a:arguments)
    let l:marks = MarkMarkup#CollectMarks(a:markList, l:startIndex, l:endIndex)

    let l:FormatsFuncref = s:GetFormat(ingo#plugin#setting#GetBufferLocal('MarkMarkup_Formats'), l:format)
    return [
    \   map(copy(l:marks), 'v:val.pattern'),
    \   map(copy(l:marks), 'call(l:FormatsFuncref, [v:val])')
    \]
endfunction
function! MarkMarkup#PrepareBorderPatterns( patterns ) abort
    return map(a:patterns, '["\\ze\\%(" . v:val . "\\)", "\\%(" . v:val . "\\)\\zs"]')
endfunction
function! MarkMarkup#ReshuffleAndFlatten( pairs ) abort
    let [l:front, l:back] = [[], []]
    for [l:a, l:b] in a:pairs
	call insert(l:front, l:a)
	call add(l:back, l:b)
    endfor
    return l:front + l:back
endfunction
function! MarkMarkup#Markup( range, arguments ) abort
    try
	let [l:patterns, l:formats] = MarkMarkup#Formats(mark#ToList(), a:arguments)
	return PatternsOnText#Transactional#ExprEach#TransactionalSubstitute(
	\   a:range,
	\   MarkMarkup#ReshuffleAndFlatten(MarkMarkup#PrepareBorderPatterns(l:patterns)),
	\   MarkMarkup#ReshuffleAndFlatten(l:formats),
	\   'g', '', '')
    catch /^MarkMarkup:/
	call ingo#err#SetCustomException('MarkMarkup')
	return 0
    catch
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

function! MarkMarkup#Lookup( markList, arguments ) abort
    let [l:startIndex, l:endIndex, l:format] = MarkMarkup#Parse(a:markList, a:arguments)
    let l:marks = MarkMarkup#CollectMarks(a:markList, l:startIndex, l:endIndex)

    let l:LookupFuncref = s:GetFormat(ingo#plugin#setting#GetBufferLocal('MarkMarkup_Lookups'), l:format)
    let l:lookups = map(l:marks, 'call(l:LookupFuncref, [v:val])')
    return (type(l:lookups[0]) == type([]) ?
    \   ingo#collections#Flatten1(l:lookups) :
    \   join(l:lookups, '')
    \)
endfunction
function! MarkMarkup#Put( lnum, arguments ) abort
    try
	call ingo#lines#PutWrapper(a:lnum, 'put', MarkMarkup#Lookup(mark#ToList(), a:arguments))
	return 1
    catch /^MarkMarkup:/
	call ingo#err#SetCustomException('MarkMarkup')
	return 0
    catch
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
