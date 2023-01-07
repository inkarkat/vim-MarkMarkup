MARK MARKUP
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin can persist the highlightings you've added to text via the
mark.vim plugin ([vimscript #2666](http://www.vim.org/scripts/script.php?script_id=2666)) as markup - directly inside the text. Any
kind of markup can be configured, and the plugin ships with predefined formats
that use &lt;span&gt; tags (to render the text as HTML) in order to reproduce the
original mark colors. Other formats append numbers[1] or symbols※, and
additionally a legend listing all used marks and their names or patterns can
be added to the buffer, too.                         [1] Example ※: \\&lt;s\\w\\+s\\&gt;

### SEE ALSO

- ExtractLinks.vim ([vimscript #4870](http://www.vim.org/scripts/script.php?script_id=4870)) uses a regular expression instead of
  marked text to identify text. Instead of appending the label, it replaces
  the text with it, and then collects references for use in a legend.

USAGE
------------------------------------------------------------------------------

    :[range]MarkMarkup [N[,M]] [{format}]
                            Put markup [in the passed {format}] around each match
                            of any defined :Mark / the mark(s) with numbers [N]
                            to [M], in the current buffer / within [range].
                            Formats (e.g. HTML markup) are taken from
                            g:MarkMarkup_Formats. If more than one is defined,
                            a valid {format} has to be passed.

    :[line]PutMarkLookup [N[,M]] [{format}]
                            Put a lookup table [for {format}] after [line]
                            (default current line). Depending on the format, this
                            could be the optional |:MarkName|s, or text attributes
                            and color definitions taken from the mark
                            highlightings. See g:MarkMarkup_Lookups.

    The plugin ships with these default {format}s:

    html                    Surrounds the marked text with an HTML <span> tag that
                            reproduces the mark's colors and text attributes. A
                            mark name is rendered as a title attribute, which the
                            browser usually shows on hover.
            <span style="color: #001e80; background-color: #a1b7ff">Lorem</span>
            <span title="latin" style="color: #80005d; background-color: #ffa1c6">ipsum</span>

    css                     Surrounds the marked text with an HTML <span> tag that
                            works like the html format, but uses "markN" CSS
                            classes.
            <span class="mark1">Lorem</span> <span class="mark2" title="latin">ipsum</span>
                            The corresponding CSS definitions can be obtained via
                                :PutMarkLookup css
            .mark1 {
                color: #001e80;
                background-color: #a1b7ff;
            }
            .mark2 {
                color: #80005d;
                background-color: #ffa1c6;
            }

    number                  Appends a [1], [2], ... counter behind each mark.
                            Lorem[1] ipsum[2]
                            A legend that maps those numbers to the mark's
                            name or (if unnamed) to the regular expression that
                            defines the mark can be inserted via
                                :PutMarkLookup number
                            [1] \<Lorem\>
                            [2] latin

    symbol                  Like number, but appends a single-character (Unicode)
                            symbol, taken from g:MarkMarkup_Symbols.
                            Lorem※ ipsum†
                            ※: \<Lorem\>
                            †: latin

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at https://github.com/inkarkat/vim-MarkMarkup
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim MarkMarkup*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.037 or
  higher.
- Requires the mark.vim plugin ([vimscript #2666](http://www.vim.org/scripts/script.php?script_id=2666)), version 3.0.0 or higher.
- Requires the PatternsOnText.vim plugin ([vimscript #4602](http://www.vim.org/scripts/script.php?script_id=4602)), version 2.20 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

The available markup formats are configured as a Dictionary of {format} keys
mapping to a Funcref that is passed an object with the following attributes:
- number:   the number of the mark, starting with 1
- name:     the name given to the mark via :MarkName, or empty
- pattern:  the regular expression that defines the mark

It should return a List of [{prefix}, {suffix}].

    let g:MarkMarkup_Formats = {'html': function('MarkToHtml')}

The global configuration can be overwritten by a buffer-local one.

The available markup lookups are configured as a Dictionary of {format} keys
mapping to a Funcref (like above). Here, it should return a String or a List.
All lookups are then concatenated; Strings as-is (without separator), each
List element as a separate line.

    let g:MarkMarkup_Lookups = {'html': function('MarkToHtmlLookup')}

The global configuration can be overwritten by a buffer-local one.

String of (single-character) symbols to be used (from left to right) for the
default "symbol" format.

    let g:MarkMarkup_Symbols = '※†‡…'

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-MarkMarkup/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.02    07-Jan-2023
- Adapt: :PutMarkLookup needs to check &lt;count&gt; == -1 instead of &lt;line2&gt; to
  support current line as well as a lnum of 0 (since Vim 8.1.1241).
- Compatibility: FIX: Correct autoloading for Vim 7.0/1.
- :MarkMarkup: Don't clobber the search history with the last mark's pattern.

__You need to update to PatternsOnText.vim ([vimscript #4602](http://www.vim.org/scripts/script.php?script_id=4602)) version 2.20!__

##### 1.01    01-May-2019
- FIX: Don't error when (individual or even all) mark(s) do not match.
- BUG: If a mark consists of multiple branches and one branch match is
  contained in another, only the contained match gets the suffix; the
  containing text gets a prefix, but no suffix.

##### 1.00    28-Mar-2019
- First published version.

##### 0.01    19-Mar-2019
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2019-2023 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
