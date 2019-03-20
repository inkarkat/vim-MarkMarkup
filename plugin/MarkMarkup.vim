" MarkMarkup.vim: Convert mark.vim highlighting to markup inside the text.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_MarkMarkup') || (v:version < 700)
    finish
endif
let g:loaded_MarkMarkup = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:MarkMarkup_Formats')
    if v:version < 702 | runtime autoload/MarkMarkupFormats.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.
    let g:MarkMarkup_Formats = {
    \   'html': function('MarkMarkup#Formats#HtmlFormat'),
    \   'css': function('MarkMarkup#Formats#CssFormat'),
    \   'number': function('MarkMarkup#Formats#NumberFormat'),
    \   'symbol': function('MarkMarkup#Formats#SymbolFormat'),
    \}
endif
if ! exists('g:MarkMarkup_Lookups')
    if v:version < 702 | runtime autoload/MarkMarkupFormats.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.
    let g:MarkMarkup_Lookups = {
    \   'css': function('MarkMarkup#Formats#CssLookup'),
    \   'number': function('MarkMarkup#Formats#NumberLookup'),
    \   'symbol': function('MarkMarkup#Formats#SymbolLookup'),
    \}
endif


"- commands --------------------------------------------------------------------

call ingo#plugin#cmdcomplete#MakeListExprCompleteFunc('sort(keys(ingo#plugin#setting#GetBufferLocal("MarkMarkup_Formats")))', 'MarkMarkupCompleteFunc')
command! -range=% -nargs=* -complete=customlist,MarkMarkupCompleteFunc MarkMarkup
\   call setline(<line1>, getline(<line1>)) |
\   if ! MarkMarkup#Markup('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif

call ingo#plugin#cmdcomplete#MakeListExprCompleteFunc('sort(keys(ingo#plugin#setting#GetBufferLocal("MarkMarkup_Lookups")))', 'PutMarkLookupCompleteFunc')
command! -range=% -nargs=* -complete=customlist,PutMarkLookupCompleteFunc PutMarkLookup
\   call setline(<line1>, getline(<line1>)) |
\   if ! MarkMarkup#Put('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
