" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/hanleylee
" License:  MIT License

let g:hl_rootmarkers = [
            \ '.svn', 
            \ '.git', 
            \ '.root', 
            \ '.project', 
            \ '.hg', 
            \ '_darcs', 
            \ 'build.xml',
            \ 'Makefile',
            \ 'CMakeLists.txt',
            \ ]
let g:is_in_iterm = $TERM_PROGRAM ==? 'iTerm.app'
let g:is_in_apple_term = $TERM_PROGRAM ==? 'Apple_Terminal'
let g:is_in_gui = has('gui_running')
let g:is_in_term = !has('gui_running')
