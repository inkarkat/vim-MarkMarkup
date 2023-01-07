" MarkMarkup/Formats.vim: Default formats and lookups.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if ! exists('g:MarkMarkup_Symbols')
    let g:MarkMarkup_Symbols = '※†‡✱◇⁂♫¤❇⁜★฿♠¥✪§⌘Ω¶▥×∀✠♣Ψ◌∃∅∮⌗⊙ΔΣ卍Ю❀℞◆☆♪⁑Φ▤◐⌬⚝☣❖⎆⏚⌀⍭'
endif
function! s:GetSymbol( number ) abort
    return get(split(ingo#plugin#setting#GetBufferLocal('MarkMarkup_Symbols'), '\zs'), a:number - 1, '?')
endfunction

function! MarkMarkup#Formats#HighlightGroupToStyles( hlGroupName ) abort
    let l:hlID = synIDtrans(hlID(a:hlGroupName))

    let l:styles = []
    for [l:what, l:cssAttribute] in [
    \   ['fg#', 'color'],
    \   ['bg#', 'background-color'],
    \   ['font', 'font-family'],
    \   ['bold', 'font-weight: bold'],
    \   ['italic', 'font-style: italic'],
    \   ['underline', 'text-decoration: underline'],
    \   ['strike', 'text-decoration: line-through']
    \]
	let l:attributeValue = synIDattr(l:hlID, l:what, 'gui')
	if ! empty(l:attributeValue)
	    call add(l:styles,
	    \   l:cssAttribute .
	    \       (l:cssAttribute =~# ':' ?
	    \           '' :
	    \           ': ' . (l:attributeValue =~# '\s' ? string(l:attributeValue) : l:attributeValue)
	    \       )
	    \)
	endif
    endfor
    return l:styles
endfunction
function! MarkMarkup#Formats#HighlightGroupToCSS( hlGroupName, cssClassName ) abort
    let l:css = [printf('.%s {', a:cssClassName)]
    let l:css += map(MarkMarkup#Formats#HighlightGroupToStyles(a:hlGroupName), '"    " . v:val . ";"')
    call add(l:css, '}')
    return l:css
endfunction

function! s:NameToTitle( name ) abort
    return printf('title="%s"', substitute(a:name, '"', '&quot;', 'g'))
endfunction
function! s:FormatNumber( mark ) abort
    return printf('[%d]', a:mark.number)
endfunction
function! s:MakeLegend( element, separator, mark ) abort
    return a:element . a:separator . (empty(a:mark.name) ? a:mark.pattern : a:mark.name)
endfunction



function! MarkMarkup#Formats#HtmlFormat( mark ) abort
    let l:attributes = []
    if ! empty(a:mark.name)
	call add(l:attributes, s:NameToTitle(a:mark.name))
    endif

    let l:styles = MarkMarkup#Formats#HighlightGroupToStyles('MarkWord' . a:mark.number)
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
    return MarkMarkup#Formats#HighlightGroupToCSS('MarkWord' . a:mark.number, 'mark' . a:mark.number)
endfunction

function! MarkMarkup#Formats#NumberFormat( mark ) abort
    return ['', s:FormatNumber(a:mark)]
endfunction
function! MarkMarkup#Formats#NumberLookup( mark ) abort
    return [s:MakeLegend(s:FormatNumber(a:mark), ' ', a:mark)]
endfunction

function! MarkMarkup#Formats#SymbolFormat( mark ) abort
    return ['', s:GetSymbol(a:mark.number)]
endfunction
function! MarkMarkup#Formats#SymbolLookup( mark ) abort
    return [s:MakeLegend(s:GetSymbol(a:mark.number), ': ', a:mark)]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
