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

function! s:TurbidityObscure()
  if exists("b:turbidity_obscured")
    return
  endif

  let l:character=get(b:, "turbidity_character",
        \ get(g:, "turbidity_character", s:default_character))

  let l:show_first = get(b:, "turbidity_show_first",
        \ get(g:, "turbidity_show_first", s:default_show_first))
  let l:show_last = get(b:, "turbidity_show_last",
        \ get(g:, "turbidity_show_last", s:default_show_last))
  let l:min_match_size = 1 + l:show_first + l:show_last

  let b:turbidity_obscured=1
  let b:turbidity_restore={
        \ 'syntax': &l:syntax,
        \ 'conceallevel': &l:conceallevel,
        \ 'concealcursor': &l:concealcursor,
        \}
  setlocal syntax=text
  setlocal conceallevel=1
  setlocal concealcursor=nvic
  exec "syntax match TurbidityWord"
        \ "'[" . l:character . "]\\{" . l:min_match_size . ",\\}'" .
        \ "ms=s+" . l:show_first .
        \ ",me=e-" . l:show_last
        \ "contains=TurbidityChar"
        \ "oneline"
  syntax match TurbidityChar contained '.' conceal
  syntax cluster Turbidity contains=TurbidityWord,TurbidityChar
endf

function! s:TurbidityElucidate()
  if !exists("b:turbidity_obscured")
    return
  endif
  unlet b:turbidity_obscured
  let &l:syntax=b:turbidity_restore['syntax']
  let &l:conceallevel=b:turbidity_restore['conceallevel']
  let &l:concealcursor=b:turbidity_restore['concealcursor']
  unlet b:turbidity_restore
  syntax clear Turbidity
endf

function! turbidity#toggle(bang)
  if a:bang
    if exists("b:turbidity_obscured")
      call <SID>TurbidityElucidate()
    endif
    return
  endif

  if exists("b:turbidity_obscured")
    call <SID>TurbidityElucidate()
  else
    call <SID>TurbidityObscure()
  endif
endf
