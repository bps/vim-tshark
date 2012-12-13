" tshark.vim - Settings for tshark dumps.
" Maintainer: Brian Smyth <http://bsmyth.net>

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal binary " This will be unset after loading the text
setlocal buftype=nofile
setlocal foldexpr=TsharkFolds()
setlocal foldlevel=0
setlocal foldmethod=expr
setlocal foldtext=TsharkFoldText()
