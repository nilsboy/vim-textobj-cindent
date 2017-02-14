if exists('g:loaded_textobj_cindent')
  finish
endif

call textobj#user#plugin('cindent', {
\      '-': {
\        'select-a': 'ai',  '*select-a-function*': 'textobj#cindent#select_a',
\        'select-i': 'ii',  '*select-i-function*': 'textobj#cindent#select_i',
\      }
\    })

let g:loaded_textobj_cindent = 1

