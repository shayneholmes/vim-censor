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

" declare defaults
let s:unhance_character='0-9a-zA-Z_'
let s:unhance_show_first=0
let s:unhance_show_last=0
let s:unhance_concealcursor='nvic'
let s:unhance_conceal_char=v:null

function! s:getSetting(name) abort
  return get(g:, a:name,
        \ get(b:, a:name,
        \ get(s:, a:name,
        \ v:null)))
endfunction

function! s:createSyntaxRules() abort
  let l:character = s:getSetting('unhance_character')

  let l:show_first = s:getSetting('unhance_show_first')
  let l:show_last = s:getSetting('unhance_show_last')
  let l:min_match_size = 1 + l:show_first + l:show_last

  let l:concealcursor = s:getSetting('unhance_concealcursor')
  let l:conceal_char = s:getSetting('unhance_conceal_char')
  if empty(l:conceal_char)
    let l:conceal_char_def = ''
  else
    let l:conceal_char_def = 'cchar=' . l:conceal_char
  endif

  exec 'syntax match UnhanceWord'
        \ '"[' . l:character . ']\{' . l:min_match_size . ',\}"' .
        \ 'ms=s+' . l:show_first .
        \ ',me=e-' . l:show_last
        \ 'contains=UnhanceChar'
        \ 'oneline'
  exec "syntax match UnhanceChar contained '.' conceal"
        \ l:conceal_char_def
endfunction

function! s:saveSettings() abort
  let b:unhance_restore={
        \ 'syntax': &l:syntax,
        \ 'conceallevel': &l:conceallevel,
        \ 'concealcursor': &l:concealcursor,
        \}
endfunction

function! s:restoreSettings() abort
  let &l:syntax=b:unhance_restore['syntax']
  let &l:conceallevel=b:unhance_restore['conceallevel']
  let &l:concealcursor=b:unhance_restore['concealcursor']
  unlet b:unhance_restore
endfunction

function! s:activate() abort
  let b:unhance_active = 1
  call s:saveSettings()
  setlocal syntax=text
  setlocal conceallevel=1
  let &l:concealcursor='nciv'
  call s:createSyntaxRules()
endfunction

function! s:deactivate() abort
  unlet b:unhance_active
  syntax clear UnhanceChar UnhanceWord
  call s:restoreSettings()
endfunction

function! unhance#execute(bang) abort
  if a:bang
    if get(b:, 'unhance_active', 0)
      call s:deactivate()
    endif
  else
    if get(b:, 'unhance_active', 0)
      call s:deactivate()
    else
      call s:activate()
    endif
  endif
endfunction
