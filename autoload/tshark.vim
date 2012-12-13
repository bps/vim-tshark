" tshark.vim - Translate a pcap with tshark.
" Borrowed heavily from the gzip plugin distributed with Vim.
" Maintainer: Brian Smyth <http://bsmyth.net>

function! s:has_tshark()
    return executable(g:tshark_bin)
endfunction

function! tshark#summary(line_num)
    return b:tshark_summary[a:line_num - 1]
endfunction

function! tshark#read()
    if !s:has_tshark()
        return
    endif

    let pm_save = &patchmode
    set patchmode=

    let l:tshark_file = fnameescape(expand("%:p"))

    " Save the summary lines in memory
    let l:tshark_summary_cmd = g:tshark_bin . " " . g:tshark_summary_opts
    echo "tshark: loading summary with command " . l:tshark_summary_cmd
    let b:tshark_summary = split(system(l:tshark_summary_cmd . " -r " . l:tshark_file . " 2> /dev/null"), "\n")

    " Replace the read lines with the full dump
    let l:line = line("'[") - 1
    if exists(":lockmarks")
        lockmarks '[,']d _
    else
        '[,']d _
    endif

    let l:tshark_detail_cmd = g:tshark_bin . " " . g:tshark_detail_opts
    echo "tshark: loading details with command " . l:tshark_detail_cmd
    setlocal nobinary
    if exists(":lockmarks")
        execute "silent lockmarks " . l:line . "r!" . l:tshark_detail_cmd . " -r " . l:tshark_file . " 2> /dev/null"
    else
        execute "silent " . l:line . "r!" . l:tshark_detail_cmd . " -r " . l:tshark_file . " 2> /dev/null"
    endif

    1
    setlocal nomodifiable
    let &patchmode = pm_save
endfunction
