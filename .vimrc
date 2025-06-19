" 対応環境: Windows(95以降), Linux, macOSのvim/neovim

"---------
" .vimrc_local
"---------
"" REDMAX Windows
"if !has('nvim')
"  colorscheme winpablo
"endif
"if has('nvim')
"  colorscheme vim
"endif
"set shell=pwsh
"set backupdir^=D:/5.バックアップ/vim/vimbackupfiles//
"set nocursorline

"" antiX Linux
"colorscheme peachpuff

"---------
"---------
set encoding=utf-8
set fileformats=unix,dos,mac
set fileencodings=guess,utf-8,ucs-bom,ucs-2le,ucs-2,iso-2022-jp,euc-jp
set fileencoding=utf-8

"---------
"  生成ファイル
"---------
" ~/.vimtmp/ を生成ファイルの保存先とする
" このディレクトリは事前に生成しておくこと
if has('eval')
  let vimtmp = '~/.vimtmp//'
endif

" undo
if has('persistent_undo')
  exe 'set undodir=' .. vimtmp
  set undofile
endif

" swap
set directory -=.
if has('eval')
  exe 'set directory^=' .. vimtmp
endif
set swapfile

" backup
set backupdir-=.
if has('eval')
  exe 'set backupdir^=' .. vimtmp
endif
set backup

"---------
"  キーバインド
"---------
inoremap jk <ESC>
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk
imap <C-a> <C-O><Plug>CapsLockToggle

" タブをWebブラウザ風に操作するキーバインド
nnoremap <C-t> :tabnew<cr>  " C-t で新規タブを開く

set backspace=indent,eol,start    " バックスペースでなんでも消せる
set whichwrap=b,s,h,l,<,>,[,],~   " 行をまたいで移動
set shellslash        " Windowsでパスの区切り文字をスラッシュで扱う
set cinoptions+=:0    " インデント方法の変更
set history=10000     " コマンドラインの履歴を10000件保存する
set expandtab         " 入力モードでTabキー押下時に半角スペースを挿入
set shiftwidth=2      " 自動インデントの幅
set softtabstop=2     " タブキー押下時に挿入される文字数
set smartindent       " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set wildmenu          " コマンドモードの補完
if !has('nvim')
  set clipboard^=autoselect " ヤンクでクリップボードにコピー
  set guioptions+=a         " yでコピーした時にクリップボードに入る
endif
if has('win32')
  set clipboard^=unnamed
else
  set clipboard^=unnamedplus
endif

"---------
"  検索
"---------
set ignorecase  " 小文字で検索すると大文字小文字を無視
set smartcase   " 大文字で検索すれば大文字小文字を無視しない
set wrapscan    " 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
set incsearch   " インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set hlsearch    " 検索結果をハイライト表示


"---------
"  表示
"---------
"nnoremap <Esc><Esc> :nohlsearch<CR><ESC> " Escの2回押しでハイライト消去
set listchars=tab:^\ ,trail:~     " 行末のスペースを可視化
set showmatch matchtime=1         " 対応する括弧やブレースを表示
set noerrorbells      " エラーメッセージの表示時にビープを鳴らさない
set cmdheight=2       " メッセージ表示欄を2行確保
set laststatus=2      " ステータス行を常に表示
set showcmd           " ウィンドウの右下にまだ実行していない入力中のコマンドを表示
set display=lastline  " 省略されずに表示
set list              " タブ文字を CTRL-I で表示し、行末に $ で表示する
set tabstop=2         " ファイル内にあるタブ文字の表示幅
set guioptions-=T     " ツールバーを非表示にする
set guioptions-=m     " メニューバーを非表示にする
set showmatch         " 対応する括弧を強調表示
set title             " タイトルを表示
set number            " 行番号の表示
if has('syntax')
  syntax on           " シンタックスハイライト
endif
"set nofoldenable     " 検索にマッチした行以外を折りたたむ(フォールドする)機能
"hi Comment ctermfg=3 " コメントの色を水色
"set nrformats=       " すべての数を10進数として扱う
set cursorline        " カーソルをハイライト
                      " 令和5年11月2日 WindowsTerminalで誤動作するようになったのでコメントアウト
if !has('nvim')
  set guioptions+=R   " 右スクロールバーを非表示
endif

"---------
" その他
"---------
" マウスによるカーソルやスクロール移動の有効化
if !has('nvim')
  if has('mouse')
    set mouse=a
    if has('mouse_sgr')
      set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
      set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
  endif
endif

" ペースト時のみインデントしない
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
      set paste
      return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" .vimrc_local読み込み用
if filereadable(expand('$VIM/.vimrc_local'))
  source $VIM/.vimrc_local
endif
if filereadable(expand('$VIM/_vimrc_local'))
  source $VIM/_vimrc_local
endif
if filereadable(expand('$HOME/.vimrc_local'))
  source $HOME/.vimrc_local
endif
if filereadable(expand('$HOME/_vimrc_local'))
  source $HOME/_vimrc_local
endif

" neovim専用設定
if has('nvim')
  autocmd TermOpen * :startinsert
  autocmd TermOpen * setlocal norelativenumber
  autocmd TermOpen * setlocal nonumber
  tnoremap <ESC> <C-\><C-n>
  tnoremap <C-W>n       <cmd>new<cr>
  tnoremap <C-W><C-N>   <cmd>new<cr>
  tnoremap <C-W>q       <cmd>quit<cr>
  tnoremap <C-W><C-Q>   <cmd>quit<cr>
  tnoremap <C-W>c       <cmd>close<cr>
  tnoremap <C-W>o       <cmd>only<cr>
  tnoremap <C-W><C-O>   <cmd>only<cr>
  tnoremap <C-W><Down>  <cmd>wincmd j<cr>
  tnoremap <C-W><C-J>   <cmd>wincmd j<cr>
  tnoremap <C-W>j       <cmd>wincmd j<cr>
  tnoremap <C-W><Up>    <cmd>wincmd k<cr>
  tnoremap <C-W><C-K>   <cmd>wincmd k<cr>
  tnoremap <C-W>k       <cmd>wincmd k<cr>
  tnoremap <C-W><Left>  <cmd>wincmd h<cr>
  tnoremap <C-W><C-H>   <cmd>wincmd h<cr>
  tnoremap <C-W><BS>    <cmd>wincmd h<cr>
  tnoremap <C-W>h       <cmd>wincmd h<cr>
  tnoremap <C-W><Right> <cmd>wincmd l<cr>
  tnoremap <C-W><C-L>   <cmd>wincmd l<cr>
  tnoremap <C-W>l       <cmd>wincmd l<cr>
  tnoremap <C-W>w       <cmd>wincmd w<cr>
  tnoremap <C-W><C-W>   <cmd>wincmd w<cr>
  tnoremap <C-W>W       <cmd>wincmd W<cr>
  tnoremap <C-W>t       <cmd>wincmd t<cr>
  tnoremap <C-W><C-T>   <cmd>wincmd t<cr>
  tnoremap <C-W>b       <cmd>wincmd b<cr>
  tnoremap <C-W><C-B>   <cmd>wincmd b<cr>
  tnoremap <C-W>p       <cmd>wincmd p<cr>
  tnoremap <C-W><C-P>   <cmd>wincmd p<cr>
  tnoremap <C-W>P       <cmd>wincmd P<cr>
  tnoremap <C-W>r       <cmd>wincmd r<cr>
  tnoremap <C-W><C-R>   <cmd>wincmd r<cr>
  tnoremap <C-W>R       <cmd>wincmd R<cr>
  tnoremap <C-W>x       <cmd>wincmd x<cr>
  tnoremap <C-W><C-X>   <cmd>wincmd x<cr>
  tnoremap <C-W>K       <cmd>wincmd K<cr>
  tnoremap <C-W>J       <cmd>wincmd J<cr>
  tnoremap <C-W>H       <cmd>wincmd H<cr>
  tnoremap <C-W>L       <cmd>wincmd L<cr>
  tnoremap <C-W>T       <cmd>wincmd T<cr>
  tnoremap <C-W>=       <cmd>wincmd =<cr>
  tnoremap <C-W>-       <cmd>wincmd -<cr>
  tnoremap <C-W>+       <cmd>wincmd +<cr>
  tnoremap <C-W>z       <cmd>pclose<cr>
  tnoremap <C-W><C-Z>   <cmd>pclose<cr>
endif
