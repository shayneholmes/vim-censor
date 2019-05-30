" Copyright 2019 Shayne Holmes
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.

let s:default_character='0-9a-zA-Z_'
let s:default_show_first=0
let s:default_show_last=0
let s:default_concealcursor='nvic'
let s:default_conceal_char=v:null

function! s:Unhance()
  if exists('b:unhanced')
    return
  endif

  let l:character=
        \ get(b:, 'unhance_character',
        \ get(g:, 'unhance_character',
        \ s:default_character))

  let l:show_first =
        \ get(b:, 'unhance_show_first',
        \ get(g:, 'unhance_show_first',
        \ s:default_show_first))
  let l:show_last =
        \ get(b:, 'unhance_show_last',
        \ get(g:, 'unhance_show_last',
        \ s:default_show_last))
  let l:min_match_size = 1 + l:show_first + l:show_last

  let l:concealcursor = get(b:, 'unhance_concealcursor',
        \ get(g:, 'unhance_concealcursor', s:default_concealcursor))

  let l:conceal_char = get(b:, 'unhance_conceal_char',
        \ get(g:, 'unhance_conceal_char', s:default_conceal_char))
  if empty(l:conceal_char)
    let l:conceal_char_def = ''
  else
    let l:conceal_char_def = 'cchar=' . l:conceal_char
  endif

  let b:unhanced=1
  let b:unhance_restore={
        \ 'syntax': &l:syntax,
        \ 'conceallevel': &l:conceallevel,
        \ 'concealcursor': &l:concealcursor,
        \}
  setlocal syntax=text
  setlocal conceallevel=1
  let &l:concealcursor=l:concealcursor
  exec 'syntax match UnhanceWord'
        \ '"[' . l:character . ']\{' . l:min_match_size . ',\}"' .
        \ 'ms=s+' . l:show_first .
        \ ',me=e-' . l:show_last
        \ 'contains=UnhanceChar'
        \ 'oneline'
  exec "syntax match UnhanceChar contained '.' conceal"
        \ l:conceal_char_def
endf

function! s:UnhanceRevert()
  if !exists('b:unhanced')
    return
  endif
  unlet b:unhanced
  let &l:syntax=b:unhance_restore['syntax']
  let &l:conceallevel=b:unhance_restore['conceallevel']
  let &l:concealcursor=b:unhance_restore['concealcursor']
  unlet b:unhance_restore
  syntax clear UnhanceChar UnhanceWord
endf

function! unhance#execute(bang)
  if a:bang || exists('b:unhanced')
    call <SID>UnhanceRevert()
  else
    call <SID>Unhance()
  endif
endf
