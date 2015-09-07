" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker spell:
" vim: set tabstop=2
"
" }

" Environment {
" 	Basic {
 		set nocompatible	"Must be the first line
 		set background=dark	"Assume dark background
" 	}

"	Windows Compatible {
		"On Windows, also use '.vim' instead of 'vimfiles'
		if has('win32') || has('win64')
			set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$VIM/.vim/after
		endif
"	}
"}

" General {
	set background=dark

	if !has('win32') && !has('win64')
		set term=$TERM
	endif

	filetype plugin indent on
	syntax on
	set mouse=a
	scriptencoding utf-8

    set encoding=utf-8
    set ffs=unix,dos,mac
    set fenc=utf-8
    set fencs=ucs-bom,utf-8,enc-jp,gb18030,tgbk,gb2313,cp936

    if has('multi_byte') && v:version > 601
        if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
            set ambiwidth=double
        endif
    endif

	"abbrev. of messages (avoids 'hit enter')
	set shortmess+=filmnrxoOtT
	set viewoptions=folds,options,cursor,unix,slash
	
	"allow cursor beyond last character
	"set virtualedit=onemore
	
	"set history size
	set history=1000

	"turn on spell check
	set spell
    set so=4

	" Directories {
		set backup
		set undofile
		set undolevels=1000
		set undoreload=10000

		"au BufWinLeave * slient! mkview "make vim save view (states) (folds, cursor, etc)
		"au BufWinEnter * slient! loadview "make vim load view (states) (folds, cursor, etc)
	" }
" }

" Vim GUI {
	" Load color scheme
	color solarized

	"Show only 15 tabs
	set tabpagemax=15

	"Display current mode
	set showmode

	"Highlight current line
	set cursorline
	hi cursorline guibg=#333333
	hi CursorColumn guibg=#333333

	if has('cmdline_info')
		set ruler
		set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
		set showcmd
	endif

	if has('statusline')
        set laststatus=2

		" Broken down into easily includeable segments
		set statusline=%<%f\    " Filename
		set statusline+=%w%h%m%r " Options
		"set statusline+=%{fugitive#statusline()} "  Git Hotness
		set statusline+=\ [%{getcwd()}]          " current dir
		set statusline+=%=                      " right alignment
		set statusline+=\ [0x\%02.2B] " ASCII / Hexadecimal value of char
		set statusline+=\ [%{&ff}/%Y/%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}] " set filetype and encoding
	    set statusline+=\ %-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
	endif

	set backspace=indent,eol,start	" backspace for dummys
	set linespace=0					" No extra spaces between rows
	set nu							" Line numbers on
	set showmatch					" show matching brackets/parenthesis
	set incsearch					" find as you type search
	set hlsearch					" highlight search terms
	set winminheight=0				" windows can be 0 line high 
	set ignorecase					" case insensitive search
	set smartcase					" case sensitive when uc present
	set wildmenu					" show list instead of just completing
	set wildmode=list:longest,full	" command <Tab> completion, list matches, then longest common part, then all.
	set whichwrap=b,s,h,l,<,>,[,]	" backspace and cursor keys wrap to
	set scrolljump=5 				" lines to scroll when cursor leaves screen
	set scrolloff=3 				" minimum lines to keep above and below cursor
	set foldenable  				" auto fold code
	set gdefault					" the /g flag on :s substitutions by default
	set list
	set listchars=tab:>.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
	set nowrap                     	" wrap long lines
	set autoindent                 	" indent at the same level of the previous line
    set cindent
	set shiftwidth=4               	" use indents of 4 spaces
	set expandtab 	  	     		" tabs are spaces, not tabs
	set tabstop=4 					" an indentation every four columns
	set softtabstop=4 				" let backspace delete indent
	"set matchpairs+=<:>            	" match, to be used with % 
	set pastetoggle=<F12>          	" pastetoggle (sane indentation on pastes)
	"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
	" Remove trailing whitespaces and ^M chars
	autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" }

" Key Mappings {
	"The default leader is '\', but many people prefer ',' as it's in a standard
	"location
	let mapleader = ','

	" Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
	nnoremap ; :

	" Easier moving in tabs and windows
	map <C-J> <C-W>j<C-W>_
	map <C-K> <C-W>k<C-W>_
	map <C-L> <C-W>l<C-W>_
	map <C-H> <C-W>h<C-W>_

	" Wrapped lines goes down/up to next row, rather than next line in file.
	nnoremap j gj
	nnoremap k gk

	" The following two lines conflict with moving to top and bottom of the
	" screen
	" If you prefer that functionality, comment them out.
	map <S-H> gT
	map <S-L> gt

	" Stupid shift key fixes
	cmap W w
	cmap WQ wq
	cmap wQ wq
	cmap Q q
	cmap Tabe tabe

	" Yank from the cursor to the end of the line, to be consistent with C and D.
	nnoremap Y y$
		
	""" Code folding options
	nmap <leader>f0 :set foldlevel=0<CR>
	nmap <leader>f1 :set foldlevel=1<CR>
	nmap <leader>f2 :set foldlevel=2<CR>
	nmap <leader>f3 :set foldlevel=3<CR>
	nmap <leader>f4 :set foldlevel=4<CR>
	nmap <leader>f5 :set foldlevel=5<CR>
	nmap <leader>f6 :set foldlevel=6<CR>
	nmap <leader>f7 :set foldlevel=7<CR>
	nmap <leader>f8 :set foldlevel=8<CR>
	nmap <leader>f9 :set foldlevel=9<CR>

    "clearing highlighted search
    nmap <silent> <leader>/ :nohlsearch<CR>
    nmap <f2> :nohlsearch<CR>

	" Shortcuts
	" Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
	cmap cd. lcd %:p:h

	" visual shifting (does not exit Visual mode)
	vnoremap < <gv
    vnoremap > >gv 

	" Fix home and end keybindings for screen, particularly on mac
	" - for some reason this fixes the arrow keys too. huh.
	map [F $
	imap [F $
	map [H g0
	imap [H g0
		
	" For when you forget to sudo.. Really Write the file.
	cmap w!! w !sudo tee % >/dev/null
" }

" Plugins {
	" VCS commands {
		nmap <leader>vs :VCSStatus<CR>
		nmap <leader>vc :VCSCommit<CR>
		nmap <leader>vb :VCSBlame<CR>
		nmap <leader>va :VCSAdd<CR>
		nmap <leader>vd :VCSVimDiff<CR>
		nmap <leader>vl :VCSLog<CR>
		nmap <leader>vu :VCSUpdate<CR>
	" }

    " CtrlP {
        let g:ctrlp_map='<c-p>'
        let g:ctrlp_cmd='CtrlP'
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX
        set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
    " }

    " OmniComplete {
		"if has("autocmd") && exists("+omnifunc")
			"autocmd Filetype *
				"\if &omnifunc == "" |
				"\setlocal omnifunc=syntaxcomplete#Complete |
				"\endif
		"endif

		" Popup menu hightLight Group
		"highlight Pmenu	ctermbg=13	guibg=DarkBlue
        "highlight PmenuSel	ctermbg=7	guibg=DarkBlue		guifg=LightBlue
		"highlight PmenuSbar ctermbg=7	guibg=DarkGray
		"highlight PmenuThumb			guibg=Black

		hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
		hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
		hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

		" some convenient mappings 
		inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
		inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
		inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
		inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
		inoremap <expr> <C-d>	   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
		inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " and make sure that it doesn't break supertab
       let g:SuperTabCrMapping = 0
        
		" automatically open and close the popup menu / preview window
		au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
		set completeopt=menu,preview,longest
	" }

	" AutoCloseTag {
		" Make it so AutoCloseTag works for xml and xhtml files as well
		au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
	" }

    	" NerdTree {
		map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
		map <leader>e :NERDTreeFind<CR>
		nmap <leader>nt :NERDTreeFind<CR>

		let NERDTreeShowBookmarks=1
		let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
		let NERDTreeChDirMode=0
		let NERDTreeQuitOnOpen=1
		let NERDTreeShowHidden=1
		let NERDTreeKeepTreeInNewTab=1

        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
	" }
" }

" GUI Settings {
    if has('gui_running')
        set guioptions-=T   "remove toolbar
        set guioptions+=c   "use console dialog
        set lines=40        "use 40 lines instead of 24
    else
        set term=buildin_ansi
    endif
" }


function! InitializeDirectories()
  let separator = "."
  let parent = $HOME 
  let prefix = '.vim'
  let dir_list = { 
			  \ 'backup': 'backupdir', 
			  \ 'views': 'viewdir', 
			  \ 'swap': 'directory', 
			  \ 'undo': 'undodir' }

  for [dirname, settingname] in items(dir_list)
	  let directory = parent . '/' . prefix . dirname . "/"
	  if exists("*mkdir")
		  if !isdirectory(directory)
			  call mkdir(directory)
		  endif
	  endif
	  if !isdirectory(directory)
		  echo "Warning: Unable to create backup directory: " . directory
		  echo "Try: mkdir -p " . directory
	  else  
          let directory = substitute(directory, " ", "\\\\ ", "")
          exec "set " . settingname . "=" . directory
	  endif
  endfor
endfunction
call InitializeDirectories()

function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction

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

function! RemoveTrailingSpace()
    if $VIM_HATE_SPACE_ERRORS != '0' &&
                \(&filetype == 'c' || &filetype == 'cpp' || &filetype == 'vim')
        normal m`
        silent! :%s/\s\+$//e
        normal ``
    endif
endfunction

" AutoCmd {
if has('autocmd')
    au BufReadPre  *.gb               call SetFileEncodings('gbk')
    au BufReadPre  *.big5             call SetFileEncodings('big5')
    au BufReadPre  *.nfo              call SetFileEncodings('cp437')
    au BufReadPost *.gb,*.big5,*.nfo  call RestoreFileEncodings()
    au BufWinEnter *.txt              call CheckFileEncoding()
    au BufReadPost *.htm* nested      call DetectHtmlEncoding()
    au BufWritePre *.c,*.h,*.cpp,*.m,*.cs,*.java    call RemoveTrailingSpace()
endif
" }
