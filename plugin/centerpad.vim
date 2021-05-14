if exists('g:loaded_centerpad') | finish | endif

command! -nargs=* Centerpad lua require('centerpad').run_command(<f-args>)

let g:loaded_centerpad = 1
