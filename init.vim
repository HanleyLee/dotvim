" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/hanleylee
" License:  MIT License
" Vim 配置原则:
" 1. 一定要了解此项能实现什么功能再配置
" 2. 没有必要的插件能不装就不装, 尽量用 Vim 原生功能

exec 'source '.expand('$VIM_CONFIG/main/preinit.vim')

"███████████████████████   Vim 系统特性   ██████████████████████████

"=======================   Main   =================================={{{
" set viminfo='50000,~/.viminfo
" set viminfo=%,\"100,'10,/50,:100,h,f0,n~/.viminfo
set nocompatible " 关闭 vi 兼容模式, 必选

if has('nvim')
    set viminfo='1000,f1,<500,:1000,@1000,/1000,h,r/Users/hanley/Desktop/t1,s10,n~/.nviminfo " 设置 viminfo, 必须放在 nocompatible 之后
else
    set viminfo='1000,f1,<500,:1000,@1000,/1000,h,r/private/tmp,s10,n~/.viminfo " 设置 viminfo, 必须放在 nocompatible 之后
endif

filetype plugin indent on " 开启插件功能,必选
" set shell=bash\ -i
set shell=zsh
set modifiable " 设置文件可被修改
set tags=./.tags;,./tags;,.tags,tags
set splitbelow " 设置新的垂直分割窗口在下侧
set splitright " 设置新的垂直分割窗口在右侧
set modeline
set modelines=5
set history=10000 " 历史命令最大记录数
set backup " backup 当前文件
set writebackup " 在保存时自动写入 backup
set undofile
set backupcopy=yes " 默认为 auto, yes 性能低, no 直接重写, auto 会自动选择, 在 mac 上 auto 会覆盖文件创建时间

let s:undo_dir = has('nvim') ? expand('$HOME/.cache/nvim/undo') : expand('$HOME/.cache/vim/undo')
let s:backup_dir = has('nvim') ? expand('$HOME/.cache/nvim/backup') : expand('$HOME/.cache/vim/backup')
let s:cache_dir = has('nvim') ? expand('$HOME/.cache/nvim/swp') : expand('$HOME/.cache/vim/swp')

call GuardExistDirectory(s:undo_dir)
execute 'set undodir=' . s:undo_dir
call GuardExistDirectory(s:backup_dir)
execute 'set backupdir=' . s:backup_dir
call GuardExistDirectory(s:cache_dir)
execute 'set directory=' . s:cache_dir

" set signcolumn=number
" set pythonthreedll=/opt/homebrew/Frameworks/Python.framework/Versions/Current/Python
" set pythonthreehome=/opt/homebrew/Frameworks/Python.framework/Versions/Current
set mouse+=a " 保证行号不被复制
set visualbell " 错误时不发出声音, 只显示在屏幕上
set ttimeout        " time out for key codes
set ttimeoutlen=10  " wait up to 20ms after Esc for special key(default 1s)
set switchbuf+=usetab,newtab
"}}}

"=======================   File   ======================={{{
set fileformat=unix " 保存文件的格式为 unix
set fileformats=unix,mac,dos
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set encoding=utf-8 " UTF-8 支持
scriptencoding utf-8
set termencoding=utf-8
set fileencoding=utf-8 " 编码方式为 utf-8
set updatetime=50 " 如果在此时间内没有操作, 则会在磁盘上写入 swap 文件, 默认为 4000(时间越短越卡); 也会影响到 coc 的 highlight
" set autochdir " 自动将当前编辑文件的路径变为工作目录(比如用于 args 批量操作)
" set autowriteall " 类似 autowrite, 但是在文件关闭, 切换等场景上会自动触发保存, 本项设置后相当于开启了 autowrite
let filetype_m='objc'
" let filetype_mm='objc'
"}}}

"=======================   Search   ============================={{{
set hlsearch " highlight all matching phrases after <enter>, equal to 'hls'
set incsearch " show partial matches for a search phrase when typing, equal to 'is'
set ignorecase " ignore upper/lower case when searching, equal to 'ic'
set smartcase " 搜索时只有输入大写字母时才会强制符合大小写, 需要与 ignorecase 一同设置才能正常工作
set showmatch " 匹配括号
"}}}

"=======================   Indent   ========================={{{
set backspace=2 " Backspace 键是否可以删除字符
set autoindent " 自动缩进, 需要与 smartindent 配合使用才有效果
set smartindent " 智能缩进, 在进行代码编写的时候会智能判断缩进距离, 与 autoindent 配合使用
set smarttab
set shiftwidth=4 " 设置缩进的字符数, 与 tabstop 不同, 这个是系统进行自动缩进时会使用的值
set tabstop=4 " 按下一次 tab 键缩进的距离, 不代表空格或制表符
set expandtab " 缩进使用空格代表, 如果要使用制表符可以改为 noexpandtab, 设置后旧文件仍然采用之前的 tab 格式, 可以使用`%retab!`强制转换为新tab 格式
"}}}

"=======================   Appearance   ============================{{{
syntax on " 设置语法高亮
"set termguicolors " true colors for vim in terminal
set number " 显示行号
set wildmenu " 输入部分命令按下 tab 键可以弹出符合的命令列表
set wildmode=full
set showcmd " 右下角显示正在操作的命令
" set cmdheight=2
set list " 设置显示行尾, 换行, 制表符等隐藏字符

set listchars=tab:▸-,eol:↲,trail:-,space:⋅ " 自定义换行, 制表符等显示格式

set laststatus=2 " 必须设置, 否则 lightline 不能正确显示

set hidden  " 允许在未保存 buffer 的时候切换至另一个 buffer
set noshowmode " 隐藏vim 的默认提示当前状态信息, eg. 在状态栏下显示'insert', 'replace'等信息
set t_Co=256 " Vim 能显示的颜色数
set shortmess-=S " 显示当前搜索的结果数量及当前位置
set foldenable " 保证在开启文件的时候是全部展开的
set foldmethod=indent
set foldopen-=hor
set foldnestmax=10
set foldlevel=99
set relativenumber
set completeopt=longest,menuone " popup:展示补全列表的侧边窗口
if has('textprop')
    set completeopt+=popup
endif
if has('textprop') && has('quickfix')
    set completepopup=align:menu,border:off,highlight:WildMenu " 调整侧边窗口的样式
endif
set cursorline " 突出光标所在行, 开启后速度变慢
set scrolloff=5 " 设置光标距离最顶(底)部的距离不小于 5 行(一旦小于 5 行即触发位于下方的 scrolljump)
" set scrolljump=5 " 光标移动到底部时自动向下翻动 5 行
set signcolumn=yes
set textwidth=150
set colorcolumn=+1
set formatoptions-=croql

if has('termguicolors')
    set termguicolors
endif

" set cursorcolumn " 突出光标所在列, 开启后速度变慢
" set linespace=16 " 设置行间距
" set showtabline=2 " 始终显示窗口上头的 tabline
"}}}

"███████████████████████   Source Load File   ██████████████████████████{{{
"=======================   Variable   ============================
call Source('$VIM_CONFIG/main/variable.vim')

"=======================   Plugin   ============================
call Source('$VIM_CONFIG/main/plugin.vim')

"=======================   Function   ============================
call Source('$VIM_CONFIG/main/function.vim')

"=======================   Path   ============================
call Source('$VIM_CONFIG/main/path.vim')

"=======================   Keymap   ============================
call Source('$VIM_CONFIG/main/keymap.vim')

"=======================   Command   ============================
call Source('$VIM_CONFIG/main/command.vim')

"=======================   Auto   ============================
call Source('$VIM_CONFIG/main/autocmd.vim')

"=======================   Appearance   ============================
call Source('$VIM_CONFIG/main/appearance.vim')"
"}}}
