" MarkMarkup/Formats.vim: Default formats and lookups.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

scriptencoding utf-8

if ! exists('g:MarkMarkup_Symbols')
    let g:MarkMarkup_Symbols = '※†‡✱◇⁂♫¤⁜★฿♠¥§⌘®Ω¶▥×∀✠♣Ψ◌∃∅∮⊙ΔΣ卍Ю℞℠◆☆♪⁑Φ◐'
endif
function! s:GetSymbol( number ) abort
    return get(split(ingo#plugin#setting#GetBufferLocal('MarkMarkup_Symbols'), '\zs'), a:number - 1, '?')
endfunction
function! s:GetColor( palette, isBackground ) abort
    let l:what = (a:isBackground ? 'bg' : 'fg')
    return get(a:palette, 'gui' . l:what, get(a:palette, 'cterm' . l:what, ''))
endfunction
function! s:GetStyles( palette ) abort
    let l:styles = []
    let l:fgColor = s:GetColor(a:palette, 0)
    if ! empty(l:fgColor)
	call add(l:styles, printf('color: %s', l:fgColor))
    endif
    let l:bgColor = s:GetColor(a:palette, 1)
    if ! empty(l:bgColor)
	call add(l:styles, printf('background-color: %s', l:bgColor))
    endif

    for l:attribute in split(get(a:palette, 'gui', get(a:palette, 'cterm', get(a:palette, 'term'))), ',')
	if l:attribute ==# 'bold'
	    call add(l:styles, 'font-weight: bold')
	elseif l:attribute ==# 'italic'
	    call add(l:styles, 'font-style: italic')
	elseif l:attribute ==# 'underline'
	    call add(l:styles, 'text-decoration: underline')
	elseif l:attribute ==# 'strike'
	    call add(l:styles, 'text-decoration: line-through')
	endif
    endfor

    return l:styles
endfunction
function! s:NameToTitle( name ) abort
    return printf('title="%s"', substitute(a:name, '"', '&quot;', 'g'))
endfunction
function! s:FormatNumber( mark ) abort
    return printf('[%d]', a:mark.number)
endfunction
function! s:MakeLegend( element, mark ) abort
    return printf('%s: %s', a:element, empty(a:mark.name) ? a:mark.pattern : a:mark.name)
endfunction



function! MarkMarkup#Formats#HtmlFormat( mark ) abort
    let l:attributes = []
    if ! empty(a:mark.name)
	call add(l:attributes, s:NameToTitle(a:mark.name))
    endif

    let l:styles = s:GetStyles(a:mark.palette)
    if ! empty(l:styles)
	call add(l:attributes, printf('style="%s"', join(l:styles, '; ')))
    endif

    return [printf('<span %s>', join(l:attributes, ' ')), '</span>']
endfunction

function! MarkMarkup#Formats#CssFormat( mark ) abort
    let l:attributes = [printf('class="mark%d"', a:mark.number)]
    if ! empty(a:mark.name)
	call add(l:attributes, s:NameToTitle(a:mark.name))
    endif

    return [printf('<span %s>', join(l:attributes, ' ')), '</span>']
endfunction
function! MarkMarkup#Formats#CssLookup( mark ) abort
    let l:css = [printf('.mark%d {', a:mark.number)]
    let l:css += map(s:GetStyles(a:mark.palette), 'v:val . ";"')
    call add(l:css, '}')
    return l:css
endfunction

function! MarkMarkup#Formats#NumberFormat( mark ) abort
    return ['', s:FormatNumber(a:mark)]
endfunction
function! MarkMarkup#Formats#NumberLookup( mark ) abort
    return [s:MakeLegend(s:FormatNumber(a:mark), a:mark)]
endfunction

function! MarkMarkup#Formats#SymbolFormat( mark ) abort
    return ['', s:GetSymbol(a:mark.number)]
endfunction
function! MarkMarkup#Formats#SymbolLookup( mark ) abort
    return [s:MakeLegend(s:GetSymbol(a:mark.number), a:mark)]
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
