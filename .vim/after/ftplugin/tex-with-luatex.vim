" Rename to tex.vim to enable for all TeX-Files

unlet b:current_syntax
syntax include @TEX syntax/tex.vim
unlet b:current_syntax
syntax include @LUA syntax/lua.vim

syntax region luatex matchgroup=Snip start='\\begin{luacode}' end='\\end{luacode}' containedin=@TEX contains=@LUA
syntax region luatex matchgroup=Snip start='\\begin{luacode\*}' end='\\end{luacode\*}' containedin=@TEX contains=@LUA
highlight link Snip Constant

let b:current_syntax="luatex"

