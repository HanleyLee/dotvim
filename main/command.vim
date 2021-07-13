" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/HanleyLee
" License:  MIT License

command! FormatCN silent! call hl#format_CN()
command! FormatObjectMapper silent! call hl#format_objectmapper()
command! -range FormatSurgeRule '<,'> call hl#format_surge_rule()
command! MergeMD silent! call hl#merge_md()
command! CDF silent call CDF()
command! OFD silent call OFD()
command! TrimWhitespace call TrimWhitespace()
command! -nargs=0 PlugBrowse silent call PlugBrowse()
command! UnescapeJSON silent! call UnescapeJSON()
command! EscapeJSON silent! call EscapeJSON()
