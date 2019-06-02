" from code at https://github.com/junegunn/goyo.vim/issues/156

function! censor#highlightSave#backup(groups) abort
  let backup=''
  silent! execute 'redir => backup | ' .
                \ join(map(copy(a:groups), '"hi " . v:val'), ' | ') .
                \ ' | redir END'
  return backup
endfunction

function! censor#highlightSave#restore(highlighting_backup) abort
  let hls = map(split(a:highlighting_backup, '\v\n(\S)@='),
              \ {_, v -> substitute(v, '\v\C(<xxx>|\s|\n)+', ' ', 'g')})
  for hl in hls
    let chunks = split(hl)
    let grp = chunks[0]
    let tail = join(chunks[1:])
    execute 'hi clear ' . grp
    if tail !=# 'cleared'
      let attrs = split(tail, '\v\c(<links\s+to\s+)@=')
      for attr in attrs
        if attr =~? '\v\c^links\s+to\s+'
          execute printf('hi! link %s %s', grp,
                       \ substitute(attr, '\v\c^links\s+to\s+', '', ''))
        else
          execute printf('hi %s %s', grp, attr)
        endif
      endfor
    endif
  endfor
endfunction
