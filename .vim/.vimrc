for f in split(glob('~/.vim/vimrc.d/*.vim'), '\n')
    exe 'source' f
endfor
set t_Co=256

let g:pymode_options_max_line_length = 110
autocmd FileType python set colorcolumn=110
au FileType python setlocal formatprg=autopep8\ -
" Automatically fix PEP8 errors in the current buffer:
"nmap FF :PymodeLintAuto<CR>
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>

set number
nmap <C-N><C-N> :set invnumber<CR>

au BufReadPost *.cnf set syntax=dosini
" execute file
nnoremap <leader>r :wa<CR>:!%:p<CR>
nnoremap <leader>o :!<CR>
nnoremap <leader>e :sp<CR>:e .<CR>
nnoremap <leader>q :qa<CR>

" disable Replace mode
imap <Insert> <Nop>
inoremap <S-Insert> <Insert>
" save in Insert mode
inoremap <F2> <c-o>:w<cr>
inoremap <F5> <c-o><leader>r<cr>
" open vimrc
nmap VV :tabe ~/.vimrc<CR>
nmap BB :tabe ~/.bashrc<CR>
nmap BA :tabe ~/.bash_aliases<CR>
nmap <C-G><C-G> :w<CR>:!runhaskell %<CR>
nmap <C-H><C-H> :w<CR>:!stack install && probe-exe<CR>
" size of a hard tabstop
set tabstop=4
set expandtab
" size of an "indent"
set shiftwidth=4

" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=4

""""""""""""""
" tmux fixes "
""""""""""""""
" Handle tmux $TERM quirks in vim
if $TERM =~ '^screen-256color'
	set t_Co=256

    map <Esc>OH <Home>
    map! <Esc>OH <Home>
    map <Esc>OF <End>
    map! <Esc>OF <End>

    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

colorscheme default
set background=light

"===== pymode =====
let g:pymode_rope = 0
let g:pymode_folding = 0

let mapleader="\\"

" ==== haskell
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>


" XML
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

set listchars=tab:>-     " > is shown at the beginning, - throughout
