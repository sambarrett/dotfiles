" Install vim-plug if we don't already have it
if empty(glob("~/.vim/autoload/plug.vim"))
    " Ensure all needed directories exist  (Thanks @kapadiamush)
    silent exec '!mkdir -p ~/.vim/plugged'
    silent exec '!mkdir -p ~/.vim/autoload'
    " Download the actual plugin manager
    exec '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    auatocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" commenting command improvements
Plug 'tpope/vim-commentary'
" Change brackets and quotes
Plug 'tpope/vim-surround'
" Make vim-surround repeatable with .
Plug 'tpope/vim-repeat'

" code linting
Plug 'scrooloose/syntastic', { 'for': ['php', 'python', 'javascript', 'css'] }

"Plug 'klen/python-mode', { 'for': ['python'] }

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'


filetype plugin indent on
call plug#end()
