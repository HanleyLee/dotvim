" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/HanleyLee
" License:  MIT License

if !PlugLoaded('vim-highlightedyank')
    finish
endif

let g:highlightedyank_highlight_duration = 1000 " 500 毫秒后高亮消失, -1 为不消失
