scriptencoding utf-8

if &cp || !has("conceal") || exists("g:turbidity_loaded")
  finish
endif
let g:turbidity_loaded = 1

let s:default_character='0-9a-zA-Z_'
let s:default_show_first=0
let s:default_show_last=0

function! s:TurbidityObscure()
  if exists("b:turbidity_obscured")
    return
  endif

  let l:character=get(b:, "turbidity_character",
        \ get(g:, "turbidity_character", s:default_character))
  if l:character =~ '^\^'
    let l:not_character = strpart(l:character, 1)
  else
    let l:not_character = "^" . l:character
  endif

  let l:show_first = get(b:, "turbidity_show_first",
        \ get(g:, "turbidity_show_first", s:default_show_first))
  let l:show_last = get(b:, "turbidity_show_last",
        \ get(g:, "turbidity_show_last", s:default_show_last))

  let b:turbidity_obscured=1
  let b:turbidity_saved_syntax=&l:syntax
  let b:turbidity_saved_conceallevel=&l:conceallevel
  let b:turbidity_saved_concealcursor=&l:concealcursor
  setlocal syntax=text
  setlocal conceallevel=1
  setlocal concealcursor=nvic
  exec "syntax match Turbidity '[" . l:character . "]' conceal"
  if l:show_first
    exec "syntax match Turbidity '" .
          \ "[" . l:not_character . "]" .
          \ "[" . l:character . "]\\{1," . l:show_first . "}" .
          \ "'"
    exec "syntax match Turbidity '^" .
          \ "[" . l:character . "]\\{1," . l:show_first . "}" .
          \ "'"
  endif
  if l:show_last
    exec "syntax match Turbidity '" .
          \ "[" . l:character . "]\\{1," . l:show_last . "}" .
          \ "\\ze" .
          \ "[" . l:not_character . "]" .
          \ "'"
    exec "syntax match Turbidity '" .
          \ "[" . l:character . "]\\{1," . l:show_last . "}" .
          \ "$'"
  endif
endf

function! s:TurbidityElucidate()
  if !exists("b:turbidity_obscured")
    return
  endif
  unlet b:turbidity_obscured
  let &l:syntax=b:turbidity_saved_syntax
  let &l:conceallevel=b:turbidity_saved_conceallevel
  let &l:concealcursor=b:turbidity_saved_concealcursor
  unlet b:turbidity_saved_syntax
  unlet b:turbidity_saved_conceallevel
  unlet b:turbidity_saved_concealcursor
  syntax clear Turbidity
endf

function! s:TurbidityToggle()
  if exists("b:turbidity_obscured")
    call <SID>TurbidityElucidate()
  else
    call <SID>TurbidityObscure()
  endif
endf

command! Turbidity call <SID>TurbidityToggle()
noremap <script> <silent> <Plug>Turbidity :Turbidity<CR>

" vim: et ts=2 sts=0 sw=0
