set nocompatible

" General {
set background=dark
if !has('win32') && !has('win64')
    set term=$TERM
endif
filetype on
filetype plugin indent on
set mouse=a	" automatically enable mouse usage

set encoding=utf-8
scriptencoding utf-8
set ffs=unix,dos,mac
set fenc=utf-8
set fencs=ucs-bom,utf-8,enc-jp,gb18030,gbk,gb2312,cp936
if has('multi_byte') && v:version > 601
    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
endif

set shortmess+=filmnrxoOtT	" abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash
set history=1000
set spell
set nobackup
set undofile
set undolevels=1000
set undoreload=10000

" }

" Vim UI {
color darkslategray
syntax on	" syntax highlighting
set tabpagemax=15
set showmode
set cursorline
set so=4
if has('cmdline_info')
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %p%)
    set showcmd
endif
if has('statusline')
    set laststatus=2

    set statusline=%<%f\ %h%m%r%=%k[%{&ff}/%Y/%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
endif
if has('gui_running')
    let do_syntax_sel_menu=1
endif
set guioptions-=T
set guioptions-=m
set guioptions+=R
set guioptions+=c
set guioptions+=e
set backspace=indent,eol,start
set linespace=0

" Search options
set showmatch
set incsearch
set hlsearch
set winminheight=0
set ignorecase
set smartcase

set wildmenu
set wildmode=list,longest,full
set whichwrap=b,s,h,l,<,>,[,]
set scrolljump=5
set scrolloff=3
set foldenable
set gdefault
set list
set listchars=tab:>-,trail:.,extends:#,nbsp:.

if version > 700
    map <C-t> <C-O>:tabnew<CR>
"    map <C-w> <C-O>:tabclose<CR>
    map <C-S-tab> <C-O>:tabp<CR>
    map <M-Left> <C-O>:tabp<CR>
    map <C-tab> <C-O>:tabn<CR>
    map <M-Right> <C-O>:tabn<CR>
endif
" }

" Formatting {
set nowrap
set autoindent
set cindent
set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
set pastetoggle=<F12>
set clipboard=unnamed
let mapleader=','

" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap <C-J> gj
noremap <C-K> gk
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
nmap <silent><F2> :noh<CR>
" }

" Key Binding {
" Easier save
map <leader>w :w!<CR>
map <silent><leader>ss :source ~/.vimrc<CR>
if has('unix')
    map <leader>e :e =expand('%:p:h').'/'<CR>
else
    map <leader>e :e =expand('%:p:h'). '\\'<CR>
endif

" Key mapping to maxium the window
if has('gui_running')
    noremap <silent> <Leader>wx <C-O>:simalt ~x<CR>
    noremap <silent> <Leader>wr <C-O>:simalt ~r<CR>
endif
" }

" Misc {
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" }

" AutoCmd {
autocmd! BufWritePost .vimrc source ~/.vimrc
autocmd! BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
" }

" Functoins {
if has('autocmd')

    if !has('gui_running')
        "English message only
        language messages en

        " Do not increase the windows width in the taglist.vim plugin
        if has('eval')
            let Tlist_Inc_Winwidth=0
        endif

        " Set text-mode menu
        if has('wildmenu')
            set wildmenu
            set cpoptions-=<
            set wildcharm=<C-Z>
            nmap <F10>      :emenu <C-Z>
            imap <F10> <C-O>:emenu <C-Z>
        endif
    endif

    if has('autocmd')
        function! SetFileEncodings(encodings)
            let b:my_fileencodings_bak=&fileencodings
            let &fileencodings=a:encodings
        endfunction

        function! RestoreFileEncodings()
            let &fileencodings=b:my_fileencodings_bak
            unlet b:my_fileencodings_bak
        endfunction

        function! CheckFileEncoding()
            if &modified && &fileencoding != ''
                exec 'e! ++enc=' . &fileencoding
            endif
        endfunction

        function! ConvertHtmlEncoding(encoding)
            if a:encoding ==? 'gb2312'
                return 'gbk'              " GB2312 imprecisely means GBK in HTML
            elseif a:encoding ==? 'iso-8859-1'
                return 'latin1'           " The canonical encoding name in Vim
            elseif a:encoding ==? 'utf8'
                return 'utf-8'            " Other encoding aliases should follow here
            else
                return a:encoding
            endif
        endfunction

        function! DetectHtmlEncoding()
            if &filetype != 'html'
                return
            endif
            normal m`
            normal gg
            if search('\c<meta http-equiv=\("\?\)Content-Type\1 content="text/html; charset=[-A-Za-z0-9_]\+">') != 0
                let reg_bak=@"
                normal y$
                let charset=matchstr(@", 'text/html; charset=\zs[-A-Za-z0-9_]\+')
                let charset=ConvertHtmlEncoding(charset)
                normal ``
                let @"=reg_bak
                if &fileencodings == ''
                    let auto_encodings=',' . &encoding . ','
                else
                    let auto_encodings=',' . &fileencodings . ','
                endif
                if charset !=? &fileencoding &&
                            \(auto_encodings =~ ',' . &fileencoding . ',' || &fileencoding == '')
                    silent! exec 'e ++enc=' . charset
                endif
            else
                normal ``
            endif
        endfunction

        function! GnuIndent()
            setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
            setlocal shiftwidth=2
            setlocal tabstop=8
        endfunction

        function! RemoveTrailingSpace()
            if $VIM_HATE_SPACE_ERRORS != '0' &&
                        \(&filetype == 'c' || &filetype == 'cpp' || &filetype == 'vim')
                normal m`
                silent! :%s/\s\+$//e
                normal ``
            endif
        endfunction

        function! UpdateLastChangeTime()
            let last_change_anchor='\(" Last Change:\s\+\)\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}'
            let last_change_line=search('\%^\_.\{-}\(^\zs' . last_change_anchor . '\)', 'n')
            if last_change_line != 0
                let last_change_time=strftime('%Y-%m-%d %H:%M:%S', localtime())
                let last_change_text=substitute(getline(last_change_line), '^' . last_change_anchor, '\1', '') . last_change_time
                call setline(last_change_line, last_change_text)
            endif
        endfunction

        " Function to insert the current date
        function! InsertCurrentDate()
            let curr_date=strftime('%Y-%m-%d', localtime())
            silent! exec 'normal! gi' .  curr_date . "\<ESC>l"
        endfunction

        " Key mapping to insert the current date
        inoremap <silent> <C-\><C-D> <C-O>:call InsertCurrentDate()<CR>

        " Highlight space errors in C/C++ source files (Vim tip #935)
        if $VIM_HATE_SPACE_ERRORS != '0'
            let c_space_errors=1
        endif

        " Use Canadian spelling convention in engspchk (Vim script #195)
        let spchkdialect='can'

        " Show syntax highlighting attributes of character under cursor (Vim
        " script #383)
        map <Leader>a :call SyntaxAttr()<CR>

        " Automatically find scripts in the autoload directory
        au FuncUndefined * exec 'runtime autoload/' . expand('<afile>') . '.vim'

        " File type related autosetting
        au FileType c,cpp setlocal cinoptions=:0,g0,(0,w1 shiftwidth=4 tabstop=8
        au FileType diff  setlocal shiftwidth=4 tabstop=4
        au FileType html  setlocal autoindent indentexpr=
        au FileType changelog setlocal textwidth=76

        " Text file encoding autodetection
        au BufReadPre  *.gb               call SetFileEncodings('gbk')
        au BufReadPre  *.big5             call SetFileEncodings('big5')
        au BufReadPre  *.nfo              call SetFileEncodings('cp437')
        au BufReadPost *.gb,*.big5,*.nfo  call RestoreFileEncodings()
        au BufWinEnter *.txt              call CheckFileEncoding()

        " Detect charset encoding in an HTML file
        au BufReadPost *.htm* nested      call DetectHtmlEncoding()

        " Recognize standard C++ headers
        au BufEnter /usr/include/c++/*    setf cpp
        au BufEnter /usr/include/g++-3/*  setf cpp

        " Setting for files following the GNU coding standard
        au BufEnter /usr/*                call GnuIndent()

        " Remove trailing spaces for C/C++ and Vim files
        au BufWritePre *                  call RemoveTrailingSpace()

        " Automatically update change time
        "au BufWritePre *vimrc, *.vim      call UpdateLastChangeTime()

        " Mark .asm files MASM-type assembly
        au BufNewFile,BufReadPre *.asm let b:asmsyntax='masm'
    endif
endif
" }
