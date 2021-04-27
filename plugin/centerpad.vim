if exists('g:loaded_centerpad') | finish | endif

command! -nargs=0 -complete=command Centerpad lua require('centerpad').toggle()

let g:loaded_centerpad = 1
