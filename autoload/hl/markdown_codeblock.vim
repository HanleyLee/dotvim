" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/hanleylee
" License:  MIT License

function! hl#markdown_codeblock#TextObj(type) abort
    " the parameter type specify whether it is inner text objects or arround text objects.
    normal! $
    let start_row = searchpos('\s*```', 'bn')[0]
    let end_row = searchpos('\s*```', 'n')[0]

    let buf_num = bufnr()
    if a:type ==# 'i'
        let start_row += 1
        let end_row -= 1
    endif
    " echo a:type start_row end_row

    call setpos("'<", [buf_num, start_row, 1, 0])
    call setpos("'>", [buf_num, end_row, 1, 0])
    execute 'normal! `<V`>'
endfunction

function! hl#markdown_codeblock#EditBlock(mode) range abort
    if exists('b:markdown_temporary_buffer') && b:markdown_temporary_buffer
        echo 'Sorry, you cannot edit a code block inside a temporary buffer'
        return
    endif
    if a:mode == 'n'
        " Github fenced code blocks like ```ruby
        let github_flavor_fence = {'start': '^\s*`\{3,}\(\w\+\)\%(\s.*$\|$\)', 'end': '^\s*`\{3,}\s*$'}
        " Github fenced code blocks with metadata like ```{ruby, <WHATEVER>}
        let github_flavor_metadata_fence = {'start': '^\s*`\{3,}{\(\w\+\),[^}]\+}\%(\s.*$\|$\)', 'end': '^\s*`\{3,}\s*$'}
        " Github fenced code blocks alternate style like ~~~ruby
        let github_flavor_alternative_fence = {'start': '^\s*\~\{3,}\(\w\+\)\%(\s.*$\|$\)', 'end': '^\s*\~\{3,}\s*$'}
        " Liquid fenced code blocks {% highlight ruby %}, (since we support some liquid/jekyll tags, why not?)
        let liquid_flavor_fence = {'start': '^\s*{%\s*highlight\s\+\(\w\+\)\s*%}\%(\s.*$\|$\)', 'end': '^\s*{%\s*endhighlight\s*%}\%(\s.*$\|$\)'}

        let various_flavor_fences = [
                    \ github_flavor_fence,
                    \ github_flavor_metadata_fence,
                    \ github_flavor_alternative_fence,
                    \ liquid_flavor_fence,
                    \ ]

        for fence in various_flavor_fences
            let current_line = a:firstline
            let code_block = s:DetectFencedCodeBlock(current_line, fence['start'], fence['end'])
            if code_block['from'] != 0 && code_block['to'] != 0
                break
            endif
        endfor
    elseif a:mode == 'v'
        let code_block = s:RangeCodeBlock(a:firstline, a:lastline)
    endif

    if code_block['from'] == 0 || code_block['to'] == 0
        echoerr 'Sorry, I did not find any suitable code block to edit or create'
        return
    endif

    if has_key(g:filetype_extension_dic, code_block['language'])
        let code_block['file_extension'] = g:filetype_extension_dic[code_block['language']]
    else
        let code_block['file_extension'] = '.' . code_block['language']
    endif
    let code_block['tmp_file_path'] = tempname() . code_block['file_extension']
    let code_content = getline(code_block['from'], code_block['to'])
    let unindent_code_content = s:UnindentBlock(code_content, code_block['indentation'])

    let bufname = bufname()

    call writefile(unindent_code_content, code_block['tmp_file_path'])

    execute 'vsplit ' . code_block['tmp_file_path']

    let b:markdown_temporary_buffer = 1
    " autocmd BufWritePost <buffer> call s:UpdateOriginCodeBlock()
    autocmd BufLeave <buffer> call s:UpdateOriginCodeBlock()
    let b:origin_bufname = bufname
    let b:origin_code_block = code_block
endfunction

function! s:UnindentBlock(content, indentation)
    return map(a:content, 'substitute(v:val, ''^' . a:indentation . ''', '''', ''g'')')
endfunction

function! s:IndentBlock(content, indentation)
    return map(a:content, 'substitute(v:val, ''^'', ''' . a:indentation . ''', ''g'')')
endfunction

function! s:DetectFencedCodeBlock(current_line, start_delimiter, end_delimiter)
    let code_block = {'from': 0, 'to': 0, 'language': 'txt', 'indentation': '', 'surround': 0}
    let initial_position = getpos('.')
    let search_position = copy(initial_position)
    let search_position[1] = a:current_line
    let search_position[2] = 0
    cal setpos('.', search_position)

    let start_code_block_backward = search(a:start_delimiter, 'cbnW')
    let end_code_block_forward = search(a:end_delimiter, 'cnW')

    let found_code_block = start_code_block_backward > 0 && end_code_block_forward > 0
    let inside_code_block = start_code_block_backward <= a:current_line && end_code_block_forward >= a:current_line
    let valid_code_block = found_code_block && inside_code_block

    if valid_code_block
        let code_block['language'] = s:ExtractLanguage(start_code_block_backward, a:start_delimiter)
        let code_block['indentation'] = s:ExtractIndentation(start_code_block_backward)
        let code_block['back_to_position'] = initial_position
        let code_block['from'] = start_code_block_backward + 1
        let code_block['to'] = end_code_block_forward - 1
    endif
    return code_block
endfunction

function! s:RangeCodeBlock(from, to)
    let code_block = {'from': 0, 'to': 0, 'language': 'txt', 'indentation': '', 'surround': 0}
    if a:to >= a:from
        let code_block['from'] = a:from
        let code_block['to'] = a:to
        let code_block['back_to_position'] = getpos('.')
        let code_block['language'] = 'markdown'

        if a:from == a:to && getline(a:from) =~ '^\s*$'
            let code_block['surround'] = 1
            let code_block['make_room_before'] = getline(a:from - 1) !~ '^\s*$'
            let code_block['make_room_after'] = getline(a:to + 1) !~ '^\s*$'
            let code_block['language'] = input('filetype? (default: markdown) ', '', 'filetype')
            if code_block['language'] =~ '^\s*$'
                let code_block['language'] = 'markdown'
            endif
        endif
    endif
    return code_block
endfunction

function! s:ExtractLanguage(start_at, upper_delimiter)
    return substitute(getline(a:start_at), a:upper_delimiter, '\1', '')
endfunction

function! s:ExtractIndentation(start_at)
    return substitute(getline(a:start_at), '\(^\s*\).\+$', '\1', '')
endfunction

function! s:UpdateOriginCodeBlock()

    call deletebufline(b:origin_bufname, b:origin_code_block['from'], b:origin_code_block['to'])
    " let code_content = readfile(b:origin_code_block['tmp_file_path'])
    let code_content = getline(1, '$')
    let indented_code_content = s:IndentBlock(code_content, b:origin_code_block['indentation'])
    call appendbufline(b:origin_bufname, b:origin_code_block['from'] - 1, indented_code_content)
    call setpos('.', b:origin_code_block['back_to_position'])

    let back_to_position = b:origin_code_block["back_to_position"]
    call win_execute(bufwinid(bufnr(b:origin_bufname)), ['call setpos(".", back_to_position)', 'redraw'])

    execute 'w'
    call delete(b:origin_code_block['tmp_file_path'])
    execute 'silent bwipeout! ' . b:origin_code_block['tmp_file_path']
    " execute 'bwipeout'
endfunction

