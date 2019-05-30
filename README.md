# Unhance

Unhance obscures your words, so you can see the shape of them, but not read
them.

![](https://raw.github.com/shayneholmes/i/master/unhance-before.png)
![](https://raw.github.com/shayneholmes/i/master/unhance-after.png)

Unhance uses vim's native `conceal` feature to physically hide the
characters, as opposed to camouflaging them by printing them the same color as
the background. When the words are obscured, you can't even copy them out of
the terminal.

## Installation

Use your favorite plugin manager.

- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'shayneholmes/vim-unhance'` to .vimrc
  2. Run `:PlugInstall`

## Usage

### `:Unhance`

  Toggle unhance on and off.

  This command has a `<Plug>` mapping available, if that's your preferred way
  of specifying mappings:

    <Plug>Unhance

  An example mapping:

    nmap <Leader>u <Plug>Unhance

### `:Unhance!`

  Turn unhance off.

## Options

Options don't immediately take effect: If you change an option while unhance
is on, you'll need to turn unhance off and on again to see any change.

Most options can be configured for an individual buffer by prefixing them with
`b:` instead of `g:`.

### `g:unhance_character`

  - Type: `String`
  - Default: `'0-9a-zA-Z_'` (equivalent to `\w`)

  A collection of characters to be obscured, as used in a `/collection`.

  Some useful non-default values:

    " Obscure every character but whitespace
    let g:unhance_character='^ \t'

    " Obscure more international characters
    let g:unhance_character='a-zA-ZçÇâÂàÀéÉêÊèÈîÎôÔûÛùÙœ'

### `g:unhance_show_first`

  - Type: `Number`
  - Default: `0`

  When set to {n}, the first {n} characters in an obscured character group
  (usually a word) will be shown. This gives extra context when obscured.

### `g:unhance_show_last`
  - Type: `Number`
  - Default: `0`

  When set to {n}, the last {n} characters in an obscured character group
  (usually a word) will be shown. This gives extra context when obscured.

### `g:unhance_concealcursor`

  - Type: `String`
  - Default: `'nvic'`

  Modes in which the cursor line will be concealed.

  By default, the current line is obscured, even when you're editing it.
  However, there are alternatives:

    " Show the current line when inserting and in visual mode
    let g:unhance_concealcursor='nc'

    " Always show the current line
    let g:unhance_concealcursor=''

  See 'concealcursor'.

### `g:unhance_conceal_char`

  - Type: `String` (only one character)
  - Default: None (`v:null`)

  The character that will be used in place of obscured characters. If not
  specified, the default conceal character in 'listchars' will be used.

  See `:syn-cchar`.

## Inspirations

 * [vim-veil](https://github.com/swordguin/vim-veil/)

