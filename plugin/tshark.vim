" tshark.vim - Folding support for pcap dumps
" Maintainer: Brian Smyth <http://bsmyth.net>

if exists("g:loaded_tshark") || &cp || !has("folding")
    finish
endif
let g:loaded_tshark = 1

" Name of the tshark binary. Specify a full path if it's not in your PATH.
if !exists('g:tshark_bin')
    let g:tshark_bin = "tshark"
endif
" Options to pass for the foldtext summary text.
if !exists('g:tshark_summary_opts')
    let g:tshark_summary_opts = "-t a"
endif
" Options to pass for the full details.
if !exists('g:tshark_detail_opts')
    let g:tshark_detail_opts = "-V -t a"
endif
" Set true to add a fold for each protocol level.
if !exists('g:tshark_nested_folds')
    let g:tshark_nested_folds = 0
endif

augroup tshark
    au!
    autocmd BufReadPost *.pcap call tshark#read()
augroup END

function! TsharkFolds()
    let l:line = getline(v:lnum)
    if g:tshark_nested_folds
        if match(l:line, '^Frame') >= 0
            return ">1"
        elseif match(l:line, '^\x\x\x\x') >= 0
            return "="
        elseif match(l:line, '^\S') >= 0
            return "a1"
        else
            return "="
        endif
    else
        if match(l:line, '^Frame') >= 0
            return ">1"
        else
            return "="
        endif
    endif
endfunction

function! TsharkFoldText()
    let l:frame_num_line = getline(v:foldstart)
    if g:tshark_nested_folds
        if foldlevel(v:foldstart) > 1
            return l:frame_num_line
        endif
    endif
    let l:colon_loc = match(l:frame_num_line, ":")
    " The format is: 'Frame n: more text'
    let l:frame_num = strpart(l:frame_num_line, 6, l:colon_loc - 6)
    return tshark#summary(l:frame_num)
endfunction
