#!/bin/bash
# antix-app.sh

sudo apt update
sudo apt upgrade -y

### 選べるテーマ！ ###
#THEME='black'   # 普通のモニタならかっこいい黒系
THEME='laptop'   # ヘボいモニタでも見やすい白系

### VIM ###
# デフォルトのvimは簡素すぎるのでパーフェクトなvimをインストール
sudo apt-get -y install vim-gtk3
# .vimrc
mkdir -p ~/.vimtmp
wget http://ponzu840w.jp/env/.vimrc -O ~/.vimrc
if [ "$THEME" = 'laptop' ]; then
  str='colorscheme peachpuff'
else
  str='colorscheme evening'
fi
echo "$str" >~/.vimrc_local

### ROXterm強制フォーカスデーモン ###
# ROXtermの2つ目以降のウィンドウがファーカスなしで起動する場合があるので
# デーモンで強引にフォーカスを当てる
# 詳しくは https://github.com/ponzu840w/roxterm_focus
sudo apt-get -y install libc6-dev libx11-dev
wget https://github.com/ponzu840w/roxterm_focus/archive/refs/heads/master.zip
unzip master.zip
cd roxterm_focus-master
make
sudo make install
echo "/usr/local/bin/roxterm_focus &" >> ~/.desktop-session/startup

### audacious ###
# ミュージックプレイヤー。XMMSがプリインストールされているが、こっちの方が軽いので置き換える
sudo apt-get -y remove xmms
sudo apt-get -y install audacious
sed -i '/audio/s/=.*;/=audacious.desktop;/' ~/.config/mimeapps.list
#sed -i 's/mp3blaster/audacious/g' ~/.config/streamtuner2/settings.json

## clip by xsel ###
# xselを使ってクリップボードに文字列を入れるコマンドを追加
# 使用例: echo "hoge" | clip
# -> クリップボードに"hoge"を入れる
sudo apt-get -y install xsel
# エイリアス
str="alias clip='xsel --clipboard --input'"
if ! grep -q 'alias clip' ~/.bashrc; then
  echo "$str" >>~/.bashrc
fi
