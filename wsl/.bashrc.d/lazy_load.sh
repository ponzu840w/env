# ~/.bashrc.d/lazy_load.sh
# 言語処理系など時間のかかる環境設定を、実際に使うまで遅延

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  nvm_load() {
    # 関数自体の定義を消して、本来のnvmを読み込む
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    # ユーザーが入力したコマンドを改めて実行
    "$@"
  }
  # ダミーの関数（エイリアス）を登録
  alias nvm=nvm_load
  alias node=nvm_load
  alias npm=nvm_load
  alias npx=nvm_load
fi

# rbenv
function rbenv() {
  unset -f rbenv
  eval "$($HOME/.rbenv/bin/rbenv init - bash)"
  rbenv "$@"
}
export GRDIR="$HOME/work/gr"

# plenv
function plenv() {
  unset -f plenv
  eval "$($HOME/.plenv/bin/plenv init -)"
  plenv "$@"
}

