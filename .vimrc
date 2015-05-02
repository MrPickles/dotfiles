" Vim configuration script.

set nocompatible
set backspace=indent,eol,start " set insert mode backspace (for certain systems)
set smartindent " allow automatic indentation
set expandtab " replace tabs with spaces
syntax on " allow syntax highlighting
set number " show line numbers

" set indentation size (default 4 spaces)
set tabstop=4
set shiftwidth=4

" set indentation to two spaces for HTML and JavaScript 
au FileType html setlocal ts=2 sw=2
au FileType javascript setlocal ts=2 sw=2

" use tabs instead of spaces for makefiles
au FileType make setlocal noexpandtab
" Explicitly show tabs in buffer
au FileType make setlocal list
au FileType make setlocal listchars=tab:>-

