let g:autopep8_max_line_length=109
let g:autopep8_disable_show_diff=1

let g:jedi#use_tabs_not_buffers = 1
let g:jedi#goto_definitions_command = "gd"
let g:jedi#popup_on_dot = 0

autocmd FileType python map <buffer> <Leader>f :call Autopep8()<CR>
autocmd FileType python setlocal omnifunc=jedi#complete
autocmd FileType python setlocal completeopt-=preview
autocmd FileType python VirtualEnvActivate vim

inoremap # X#
