" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/HanleyLee
" License:  MIT License

if !PlugLoaded('asynctasks.vim')
    finish
endif

if PlugLoaded('fzf.vim')
    command! -nargs=0 AsyncTaskFzf call asynctasks#fzf_task()
endif
