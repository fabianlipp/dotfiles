" ~/.vimrc (configuration file for vim only)

execute pathogen#infect()

" skeletons
function! SKEL_spec()
	0r /usr/share/vim/current/skeletons/skeleton.spec
	language time en_US
	if $USER != ''
	    let login = $USER
	elseif $LOGNAME != ''
	    let login = $LOGNAME
	else
	    let login = 'unknown'
	endif
	let newline = stridx(login, "\n")
	if newline != -1
	    let login = strpart(login, 0, newline)
	endif
	if $HOSTNAME != ''
	    let hostname = $HOSTNAME
	else
	    let hostname = system('hostname -f')
	    if v:shell_error
		let hostname = 'localhost'
	    endif
	endif
	let newline = stridx(hostname, "\n")
	if newline != -1
	    let hostname = strpart(hostname, 0, newline)
	endif
	exe "%s/specRPM_CREATION_DATE/" . strftime("%a\ %b\ %d\ %Y") . "/ge"
	exe "%s/specRPM_CREATION_AUTHOR_MAIL/" . login . "@" . hostname . "/ge"
	exe "%s/specRPM_CREATION_NAME/" . expand("%:t:r") . "/ge"
	setf spec
endfunction
autocmd BufNewFile	*.spec	call SKEL_spec()
" filetypes
filetype plugin on
filetype indent on
" ~/.vimrc ends here


"""" Eigene Ergänzungen
set background=dark
"set mouse=a
set list " shows us whether tabs or spaces are used
set listchars=tab:»·,trail:·,nbsp:+

"" Keep a longer history:
" By default, Vim only remembers the last 20 commands and search patterns
" entered. It’s nice to boost this up:
set history=1000

"" Make file/command completion useful:
" By default, pressing <TAB> in command mode will choose the first possible
" completion with no indication of how many others there might be. The
" following configuration lets you see what your other options are:
set wildmenu
" To have the completion behave similarly to a shell, i.e. complete only up to
" the point of ambiguity (while still showing you what your options are), also
" add the following:
set wildmode=list:longest

"" Set the terminal title:
" A running gvim will always have a window title, but when vim is run within
" an xterm, by default it inherits the terminal’s current title.
set title

"" Maintain more context around the cursor:
" When the cursor is moved outside the viewport of the current window,
" the buffer is scrolled by a single line. Setting the option below will
" start the scrolling three lines before the border, keeping more context
" around where you’re working.
set scrolloff=3

"" Scroll the viewport faster:
" <C-e> and <C-y> scroll the viewport a single line. I like to speed this up:
"nnoremap <C-e> 3<C-e>
"nnoremap <C-y> 3<C-y>

" Enable limited line numbering
" It’s often useful to know where you are in a buffer, but full line numbering
" is distracting. Setting the option below is a good compromise:
set ruler

" Während der Suche schon zum entsprechenden Text springen
set incsearch

" Suchergebnisse farbig markieren (mit :nohls verschwinden die Hervorhebungen
" wieder)
set hlsearch

" Möglichkeit TagList ein- und auszublenden
map <F3> :TlistToggle<cr>

" Rufe eine Shell in einem neuen Fenster auf
map <F4> :ConqueTermSplit bash<CR>

" Demo-Modus für Präsentationen
function DemoMode()
  set cursorline!
  hi CursorLine ctermbg=darkblue guibg=#303070
endfunction
:command DemoMode call DemoMode()
:nnoremap <Leader>d :call DemoMode()<CR>

" Einstellungen für JSON
au BufRead,BufNewFile *.json set filetype=json foldmethod=syntax
au! Syntax json source $HOME/.vim/syntax/json.vim

au FileType json command -range=% -nargs=* Tidy <line1>,<line2>! json_xs -f json -t json-pretty



" Web Development
autocmd FileType javascript,html,css,php set ai
autocmd FileType javascript,html,css,php set sw=2
autocmd FileType javascript,html,css,php set ts=2
autocmd FileType javascript,html,css,php set sts=2
autocmd FileType javascript,css,php set textwidth=79

autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

autocmd FileType javascript,css,php set number


" DoPrettyXML
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()


set t_Co=256
color molokai

runtime macros/matchit.vim

