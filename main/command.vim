" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/hanleylee
" License:  MIT License

command! -range=% -nargs=0 FormatCN let b:view = winsaveview() | silent! <line1>,<line2> call hl#Format_CN() | call winrestview(b:view)
" command! -range=% -nargs=0 FormatCN silent! <line1>,<line2> call hl#Format_CN()
command! FormatObjectMapper silent! call hl#format_objectmapper()
command! -range FormatSurgeRule '<,'> call hl#format_surge_rule()
command! MergeMD silent! call hl#merge_md()
command! CDF silent call CDF()
command! OFD silent call OFD()
command! TrimWhitespace call TrimWhitespace()
command! -nargs=0 PlugBrowse silent call PlugBrowse()
command! UnescapeJSON silent! call UnescapeJSON()
command! EscapeJSON silent! call EscapeJSON()

if PlugLoaded('asynctasks.vim') && PlugLoaded('fzf.vim')
    command! -nargs=0 AsyncTaskFzf call hl#asynctasks#fzf_task()
endif

if PlugLoaded('coc.nvim')
    command! -nargs=0 Format :call CocAction('format') " Add `:Format` command to format current buffer.
    command! -nargs=? Fold :call CocAction('fold', <f-args>) " Add `:Fold` command to fold current buffer.
    command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport') " Add `:OR` command for organize imports of the current buffer.
endif

if PlugLoaded('fzf.vim')
    command! -nargs=* -complete=file AgAll :call hl#fzf#ag_all(<q-args>)
    command! -bang FM call fzf#run(fzf#wrap({'source': 'cat $FZF_MARKS_FILE | sed "s/.*: \(.*\)$/\1/" | sed "s#~#${HOME}#"', 'sink': 'e'}, <bang>0))
    " command! -bang FM call fzf#run(fzf#wrap({'source': 'cat ~/.fzf-marks | sed "s/.*: \(.*\)$/\1/" | sed "s#~#${HOME}#"', 'sink': 'e'}, <bang>0))

endif

if PlugLoaded('vim-floaterm')
    command! LF FloatermNew lf
    command! FFF FloatermNew fff
    command! NNN FloatermNew nnn
    command! XPLR FloatermNew xplr
    command! Ranger FloatermNew ranger
    command! Vifm FloatermNew vifm

endif

