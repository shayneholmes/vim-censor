" declare defaults
let s:censor_pattern='\w\+'
let s:censor_concealcursor='nvic'
let s:censor_replacement_char=v:null
let s:censor_highlight_def=v:null

function! s:getSetting(name) abort
  return get(b:, a:name,
        \ get(w:, a:name,
        \ get(g:, a:name,
        \ get(s:, a:name,
        \ v:null))))
endfunction

function! s:createSyntaxRules() abort
  let l:pattern = s:getSetting('censor_pattern')

  let l:concealcursor = s:getSetting('censor_concealcursor')
  let l:replacement_char = s:getSetting('censor_replacement_char')
  if empty(l:replacement_char)
    let l:conceal_char_def = ''
  else
    let l:conceal_char_def = 'cchar=' . l:replacement_char
  endif

  exec 'syntax match CensoredWord'
        \ '"' . l:pattern . '"'
        \ 'contains=CensoredChar'
  exec "syntax match CensoredChar contained '.' conceal"
        \ l:conceal_char_def
endfunction

function! s:setConcealHighlight()
  let l:highlight_def = s:getSetting('censor_highlight_def')
  if empty(l:highlight_def)
    return
  endif
  exec 'highlight Conceal' l:highlight_def
endfunction

function! s:saveSettings() abort
  let b:censor_restore={
        \ 'syntax': &l:syntax,
        \ 'conceallevel': &l:conceallevel,
        \ 'concealcursor': &l:concealcursor,
        \}
  if !empty(s:getSetting('censor_highlight_def'))
    let b:censor_restore['highlight'] =
          \ censor#highlightSave#backup(['Conceal'])
  endif
endfunction

function! s:restoreSettings() abort
  let &l:syntax=b:censor_restore['syntax']
  let &l:conceallevel=b:censor_restore['conceallevel']
  let &l:concealcursor=b:censor_restore['concealcursor']
  if has_key(b:censor_restore, 'highlight')
    call censor#highlightSave#restore(b:censor_restore['highlight'])
  endif
  unlet b:censor_restore
endfunction

function! s:activate() abort
  let b:censor_active = 1
  call s:saveSettings()
  setlocal syntax=text
  setlocal conceallevel=1
  let &l:concealcursor='nciv'
  call s:createSyntaxRules()
  call s:setConcealHighlight()
endfunction

function! s:deactivate() abort
  unlet b:censor_active
  syntax clear CensoredChar CensoredWord
  call s:restoreSettings()
endfunction

function! censor#execute(bang) abort
  if a:bang
    if get(b:, 'censor_active', 0)
      call s:deactivate()
    endif
  else
    if get(b:, 'censor_active', 0)
      call s:deactivate()
    else
      call s:activate()
    endif
  endif
endfunction
