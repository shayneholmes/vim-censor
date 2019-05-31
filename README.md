# Censor

Hide words from view.

![](https://raw.github.com/shayneholmes/i/master/censor.png)

Censor blocks out the specified patterns: they're there, and you can see
they're there, but you can't read them.

Instead of "camouflaging" them by making them the same color as the background,
it uses vim's native `conceal` feature to replace the characters at render
time: When words are censored, they won't be displayed on the terminal at all.

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

## Options

Options don't immediately take effect: If you change an option while censor is
on, you'll need to turn censor off and on again to see any change.

Options can be configured for an individual window or buffer by prefixing them
with `w:` or `b:` instead of `g:`. (Note that highlight groups are global, so
you can't change them per buffer.)

### `g:censor_pattern` (default: `'\w\+'`)

Regular expression that specifies what should be censored.

Some interesting recipes:

```vim
" Censor letters and numbers (default)
"
"  Foo bar, hash.    XXX XXX, XXXX.
"    Baz (quux)?  ->   XXX (XXXX)?
"    Hashbaz!          XXXXXXX!
"
let g:censor_pattern='\w\+'

" Show the first and last character of every word
"
"  Foo bar, hash.    FXo bXr, hXXh.
"    Haz (quux)?  ->   bXz (qXXx)?
"    Hashbaz!          hXXXXXz!
"
let g:censor_pattern='\w\zs\w\+\ze\w'

" Censor all non-whitespace characters
"
"  Foo bar, hash.    XXX XXXXX XXXXX
"    Baz (quux)?  ->   XXX XXXXXXX
"    Hashbaz!          XXXXXXXX
"
let g:censor_pattern='\S\+'

" Censor words and the whitespace gaps between them
"
"  Foo bar, hash.    XXXXXXXXXXXXXXX
"    Baz (quux)?  ->   XXXXXXXXXXX
"    Hashbaz!          XXXXXXXX
"
" Use the |/\v| modifier to make the rest
" of the pattern 'very magic':
let g:censor_pattern='\v\S+%(\s\S+)*'
```

### `g:censor_concealcursor` (default: `'nciv'`)

Modes in which the cursor's current line will be concealed.

By default, censored items in the current line remain censored, even when
you're in insert mode. However, there are alternatives:

```vim
" Show censored items in the current line when inserting and in visual mode
let g:censor_concealcursor='nc'

" Always show censored items in the current line
let g:censor_concealcursor=''
```

See vim's `concealcursor` for details.

### `g:censor_conceal_char` (default: none)

The character that will be used in place of obscured characters. If not
specified, the default conceal character in `listchars` will be used. (By
default, this is the space character.)

See `:help :syn-cchar`.

## Other tweaks

You can alter the highlighting of the censored text using the `Conceal`
highlighting group (`:help hl-Conceal`):

```vim
" Remove highlighting entirely
highlight Conceal NONE
```

## Inspirations

 * [vim-veil](https://github.com/swordguin/vim-veil/)
 * [vim-redacted](https://github.com/dbmrq/vim-redacted)

