" Test :MarkMarkup with overlapping patterns and test format.

call append(0, [
\   '<p> The new MarkMarkup.vim plugin',
\   '    is a great companion to the popular <a href="http://www.vim.org/scripts/script.php?script_id=2666" class="external">Mark.vim plugin</a>.',
\   '    With it, you can render the highlightings as HTML (or any other markup),',
\   '    and therefore "export" them into a commonplace format.',
\   '    This paragraph has been marked with the following highlightings (which',
\   '    have been extracted via <tt>:MarkYankDefinitions</tt>):',
\   '</p>'
\])
MarkPalette extended
MarkClear
1Mark! /\<MarkMarkup\>/
2Mark! /Mark/
3Mark! /\<Mark/
6Mark! /\<popular\>/
7Mark! /\<markup\>\|\<format\>\|\<HTML\>/
13Mark! /\<highlightings\>/
14Mark! /lighting/
15Mark! /light/
16Mark! /igh/
21Mark! /\<great\>/

let g:MarkMarkup_Formats = {'myformat': function('TestFormat')}
MarkMarkup

call vimtest#SaveOut()
call vimtest#Quit()
