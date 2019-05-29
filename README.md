# Turbidity

Turbidity obscures your words, so you can see the shape of them, but not read
them.

![](https://raw.github.com/shayneholmes/i/master/turbidity-before.png)
![](https://raw.github.com/shayneholmes/i/master/turbidity-after.png)

Turbidity uses vim's native `conceal` feature to physically hide the
characters, as opposed to camouflaging them by printing them the same color as
the background. When the words are obscured, you can't even copy them out of
the terminal.

## Installation

Use your favorite plugin manager.

- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'shayneholmes/vim-turbidity'` to .vimrc
  2. Run `:PlugInstall`

## Usage

### `:Turbidity`

  Toggle turbidity on and off.

  This command has a `<Plug>` mapping available, if that's your preferred way
  of specifying mappings:

    <Plug>Turbidity

  An example mapping:

    nmap <Leader>t <Plug>Turbidity

### `:Turbidity!`

  Turn turbidity off.

## Options

Options don't immediately take effect: If you change an option while turbidity
is on, you'll need to turn turbidity off and on again to see any change.

Most options can be configured for an individual buffer by prefixing them with
`b:` instead of `g:`.

### `g:turbidity_character`

  - Type: `String`
  - Default: `'0-9a-zA-Z_'` (equivalent to `\w`)

  A collection of characters to be obscured, as used in a `/collection`.

  Some useful non-default values:

    " Obscure every character but whitespace
    let g:turbidity_character='^ \t'

    " Obscure more international characters
    let g:turbidity_character='a-zA-ZçÇâÂàÀéÉêÊèÈîÎôÔûÛùÙœ'

### `g:turbidity_show_first`

  - Type: `Number`
  - Default: `0`

  When set to {n}, the first {n} characters in an obscured character group
  (usually a word) will be shown. This gives extra context when obscured.

### `g:turbidity_show_last`
  - Type: `Number`
  - Default: `0`

  When set to {n}, the last {n} characters in an obscured character group
  (usually a word) will be shown. This gives extra context when obscured.

### `g:turbidity_concealcursor`

  - Type: `String`
  - Default: `'nvic'`

  Modes in which the cursor line will be concealed.

  By default, the current line is obscured, even when you're editing it.
  However, there are alternatives:

    " Show the current line when inserting and in visual mode
    let g:turbidity_concealcursor='nc'

    " Always show the current line
    let g:turbidity_concealcursor=''

  See 'concealcursor'.

### `g:turbidity_conceal_char`

  - Type: `String` (only one character)
  - Default: None (`v:null`)

  The character that will be used in place of obscured characters. If not
  specified, the default conceal character in 'listchars' will be used.

  See `:syn-cchar`.

## Inspirations

 * [vim-veil](https://github.com/swordguin/vim-veil/)

