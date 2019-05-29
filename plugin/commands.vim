if &compatible || !has('syntax') || !has('conceal')
  finish
endif

command -bang Censor call censor#execute(<bang>0)
