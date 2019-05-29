scriptencoding utf-8

if &cp || !has("conceal") || exists("g:turbidity_loaded")
  finish
endif
let g:turbidity_loaded = 1

command! -bang Turbidity call turbidity#toggle(<bang>0)
noremap <script> <Plug>Turbidity :Turbidity<CR>

" vim: et ts=2 sts=0 sw=0
