# Censor

![](https://raw.github.com/shayneholmes/i/master/censor.png)

Censor blocks specified patterns from view: they're in the buffer, and you can
see they're there, but you can't read them.

Instead of "camouflaging" them by making them the same color as the
background, it uses vim's `conceal` feature to intercept the characters at
render time: When words are censored, they won't be displayed on the terminal
at all, even when the cursor is on them.

Note that the buffer is never changed: the underlying text is the same
regardless of whether or not censor is enabled.

## Installation

Use your favorite plugin manager.

### [vim-plug](https://github.com/junegunn/vim-plug)

1. Add `Plug 'shayneholmes/vim-censor'` to .vimrc
2. Run `:PlugInstall`

## Usage

### `:Censor`

Toggle censor on and off.

You can easily map a keypress to it:

```vim
nnoremap <Leader>c :Censor<CR>
```

### `:Censor!`

Turn censor off.

## Recipes <a name="recipes"></a>

Ready-made recipes for interesting censorship patterns:

```vim
" Censor word characters: letters, numbers, and _ (default)
"
"  Foo bar, hash.    ███ ███, ████.
"    Baz (quux)?  ->   ███ (████)?
"    Hashbaz!          ███████!
"
let g:censor_pattern='\w\+'

" Show the first and last character of every word
"
"  Foo bar, hash.    F█o b█r, h██h.
"    Haz (quux)?  ->   b█z (q██x)?
"    Hashbaz!          h█████z!
"
let g:censor_pattern='\w\zs\w\+\ze\w'

" Censor all non-whitespace characters
"
"  Foo bar, hash.    ███ █████ █████
"    Baz (quux)?  ->   ███ ███████
"    Hashbaz!          ████████
"
let g:censor_pattern='\S\+'

" Censor words and the whitespace gaps between them
"
"  Foo bar, hash.    ███████████████
"    Baz (quux)?  ->   ███████████
"    Hashbaz!          ████████
"
let g:censor_pattern='\v\S+%(\s+\S+)*'
```

## Options

Options don't immediately take effect: If you change an option while censor is
on, you'll need to turn censor off and on again to see any change.

Options can be configured for an individual window or buffer by prefixing them
with `w:` or `b:` instead of `g:`.

### `g:censor_pattern` (default: `'\w\+'`)

A regular expression that specifies what should be censored. It is always
interpreted as though `'magic'` is set; see `:help :syn-pattern`.

Change this to get different censoring behavior; see [Recipes](#recipes),
above.

### `g:censor_replacement_char` (default: none)

The character that will be used in place of obscured characters. If not
specified, the default conceal character in `listchars` will be used. (By
default, this is the space character.)

```vim
" Use the letter 'X' to replace censored characters
let g:censor_replacement_char = 'X'
```

See `:help :syn-cchar`.

### `g:censor_concealcursor` (default: `'nciv'`)

Modes in which the cursor's current line will be censored.

By default, censored items in the current line remain censored, even when
you're in insert mode. However, there are alternatives:

```vim
" Show censored items in the current line when inserting and in visual mode
let g:censor_concealcursor='nc'

" Always show censored items in the current line
let g:censor_concealcursor=''
```

See vim's `concealcursor` for details.

### `g:censor_highlight_def` (default: none)

An optional definition of highlighting for censored characters. Changes the
highlighting of the `Conceal` group; see `help hl-Conceal`. The original value
will be restored when censor is disabled.

```vim
" Remove highlighting entirely
let g:censor_highlight_def = NONE
```

Note that highlighting is global and so can't be altered per buffer.

### Callbacks

If you want to run additional commands when toggling censoring, you can do
this with the `CensorEnter` and `CensorLeave` events:

- `CensorEnter` runs just _after_ enabling censoring
- `CensorLeave` runs just _before_ disabling censoring

This pattern is similar to e.g. `TabEnter` and `TabLeave`.

Some examples:

```vim
# Show the cursor column when censored
autocmd! User CensorEnter setl cursorcolumn
autocmd! User CensorLeave set cursorcolumn<

# Get fancy: Show capitals vs lower-case
function! s:censor_enter()
  syn match CensoredChar '[a-z]' conceal cchar=x
  syn match CensoredChar '[A-Z]' conceal cchar=X
endfunction

autocmd! User CensorEnter call <SID>censor_enter()
```

## Inspirations

 * [vim-veil](https://github.com/swordguin/vim-veil/)
 * [vim-redacted](https://github.com/dbmrq/vim-redacted)

<!-- vim: set tw=78 sw=2 ts=2 et ft=markdown norl nowrap : -->
