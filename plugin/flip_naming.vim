" flip_naming.vim
" Author: Donglai


if exists("g:load_flip_naming") || v:version < 700
    finish
endif

let g:load_flip_naming = 1

function s:flipNaming() 
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    if line_start != line_end
        return
    endif
    let mode = -1
    let currline = getline(line_start)
    let selectedTxt = currline[column_start  - 1: column_end - 1]
    let val = selectedTxt[:]
    if val =~ "_"
        let mode = 1
    elseif val =~ '\<\([A-Z][a-z_][A-Za-z_]\+\)\>'
        let mode = 0
    endif
    let newone = ""
    if mode == 1
        let newone = s:getNextForMode1(val)
    elseif mode == 0
        let newone = s:getNextForMode0(val)
    end
    if column_start == 1
        let newline = newone . currline[column_end + 1 : ]
    else 
        let newline = currline[0: column_start - 2] . newone . currline[column_end + 1 : ]
    endif

    call setline(line_start, newline)
endfunction

function s:getNextForMode1(val)
    let list = split(a:val, "_")
    let nlist = []
    for s in list
        let co0 = substitute(s, '\<\(.\)\(\w*\)', '\u\1\L\2', 'g')
        call add(nlist, co0)
    endfor
    let r = join(nlist, '')
    return r
endfunction

function s:getNextForMode0(val)

    let str = a:val
    let i = 0
    let wlist = []
    while i < len(str)
	let c = str[i]
	if toupper(c) ==# c
		"let index = len(wlist) - 1
		call add(wlist, c)
	else
		if len(wlist) == 0
			call add(wlist, c)
		else 
			let wlist[len(wlist) - 1] =  wlist[len(wlist) - 1] . toupper(c)
		endif
	endif
        let i += 1
    endwhile
    let nstr = join(wlist, '_')
    return nstr
endfunction

function flip_naming#FlipNaming() 
    call s:flipNaming()
endfunction

function! Gflip()
    call s:flipNaming()
endfunction

vnoremap D :call flip_naming#FlipNaming() <enter>


