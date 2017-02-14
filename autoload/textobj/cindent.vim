function! textobj#cindent#select_a()
  return s:select(1)
endfunction

function! textobj#cindent#select_i()
  return s:select(0)
endfunction

function! s:findNearestIndentedNonEmptyLine(cursor_linenr) abort
  let found_zero_indent = 0

  let linenr = a:cursor_linenr
  while linenr <= line('$')
    if !s:isEmptyLine(linenr)
      if indent(linenr) == 0
        let found_zero_indent = 1
      endif
      break
    endif
    let linenr += 1
  endwhile

  if found_zero_indent
    let linenr = a:cursor_linenr
    while linenr >= 1
      if !s:isEmptyLine(linenr)
        break
      endif
      let linenr -= 1
    endwhile
  endif

  return linenr
endfunction

function! s:findStart(base_linenr, include_sourround) abort
  let base_indent = indent(a:base_linenr)
  let linenr = a:base_linenr
  while linenr >= 1
    let indent = indent(linenr)
    if s:isEmptyLine(linenr)
      let linenr -= 1
      continue
    endif
    if indent < base_indent
      if !a:include_sourround
        let linenr += 1
      endif
      break
    endif
    let linenr -= 1
  endwhile
  return linenr
endfunction

" TODO: special case on no indent?

function! s:findEnd(base_linenr, include_sourround) abort
  let base_indent = indent(a:base_linenr)
  let linenr = a:base_linenr
  while linenr <= line('$')
    let indent = indent(linenr)
    if s:isEmptyLine(linenr)
      let linenr += 1
      continue
    endif
    if indent < base_indent
      if !a:include_sourround
        let linenr -= 1
      endif
      break
    endif
    let linenr += 1
  endwhile
  return linenr
endfunction

function! s:select(include_sourround)

  let cursor_linenr = line('.')

  let base_linenr = s:findNearestIndentedNonEmptyLine(cursor_linenr)
  let start_linenr = s:findStart(base_linenr, a:include_sourround)
  let end_linenr = s:findEnd(base_linenr, a:include_sourround)

  " start line nr last to be able to expand upwards manually
  return ['V',
  \       [0, end_linenr, 1, 0],
  \       [0, start_linenr, 1, 0]
  \ ]
endfunction

function! s:isEmptyLine(linenr) abort
  return getline(a:linenr) == ''
endfunction

