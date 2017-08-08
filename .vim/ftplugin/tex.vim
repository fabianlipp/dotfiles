let g:Tex_SmartKeyQuote=0

function! SyncTexForward()
	let s:syncfile = fnamemodify(fnameescape(Tex_GetMainFileName()), ":r").".pdf"
	let execstr = "silent !okular --unique ".s:syncfile."\\#src:".line(".").expand("%\:p").' &'
	echom execstr
	exec execstr
endfunction
nnoremap \lf :call SyncTexForward()<CR>

