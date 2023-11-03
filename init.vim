set nu rnu
set nocompatible
if has('filetype')
  filetype indent plugin on
endif
if has('syntax')
  syntax on
endif
set showtabline=2
set hlsearch
set number
set cursorline
set hidden
set visualbell
set t_vb=
if has('mouse')
  set mouse=a
endif

set expandtab
set tabstop=2
set shiftwidth=2

set t_ZH=␛[3m
set t_ZR=␛[23m

let mapleader = "\\"
let maplocalleader = ","

autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

colorscheme catppuccin-mocha
" set cmdheight=0 " TODO test if this hides anything important

syntax on
if has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

if exists(':GuiFont')
    GuiFont Serious Sans Nerd Font Mono:h11
endif
if exists('g:neovide')
    set guifont=Serious\ Sans\ Nerd\ Font\ Mono:h7
endif

lua require('plugins')
lua require('init')

hi! link TelescopeResultsTitle StatusLine
hi! link TelescopePreviewTitle StatusLine
hi! link TelescopePreviewNormal Identifier
hi! link TelescopeResultsNormal StatusLine
hi! link TelescopePreviewBorder StatusLineNC
hi! link TelescopeResultsBorder StatusLineNC
hi! link TelescopePromptNormal StatusLine

let g:coq_settings = { "keymap.pre_select": v:true, "keymap.recommended": v:false }
execute "COQnow"

" Keybindings
ino <silent><expr> <Esc>  pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>  pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>   pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>   pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
ino <silent><expr> <Tab>  pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
nno <C-Left> gT
nno <C-Right> gt

set clipboard+=unnamedplus
set noshowcmd
hi MatchParen gui=underline
