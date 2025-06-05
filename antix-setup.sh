#!/bin/bash
### 選べるテーマ！ ###
#THEME='black'   # 普通のモニタならかっこいい黒系
THEME='laptop'   # ヘボいモニタでも見やすい白系

# 便利な設定関数
function config () {
  target=$1
  key=$2
  val=$3
  if grep -q $key $target; then
    sed -i "s/^ *# *$key/$key/" $target   # コメントアウトを外す
    sed -i "\@^$key=@c $key=$val" $target # 置換
  else
    echo "$key=$val" >>$target            # 追記
  fi
}

function config_dq () {
  config $1 $2 "\"$3\""
}

### Look&Feel ###
#echo <<EOS >~/.gtkrc-2.0.mine
#gtk-can-change-accels = 1
#gtk-theme-name="Mist" # 若干古めかしいが、境界線がくっきりしている
#EOS
# 未来的で可愛いカーソル
config ~/.config/gtk-3.0/settings.ini gtk-cursor-theme-name "Breeze-Show"

### 壁紙を設定 ###
if [ "$THEME" = 'laptop' ]; then
  config ~/.desktop-session/wallpaper-list.conf "zzz-icewm" "/usr/share/wallpaper/leaf-hanging.jpg"
else
  config ~/.desktop-session/wallpaper-list.conf "zzz-icewm" "/usr/share/wallpaper/antiX3.jpg"
fi

### iceWMカスタムテーマ ###
if [ "$THEME" = 'laptop' ]; then
  # laptop用白系テーマ
  orig_tmpath="/usr/share/icewm/themes/FX-light"
  tmpath="$HOME/.icewm/themes/FX-superlight"
  str='Theme="FX-superlight/default.theme"'
else
  # ノーマル黒系テーマ
  orig_tmpath="/usr/share/icewm/themes/NewDay-Medium"
  tmpath="$HOME/.icewm/themes/NewDay-Medium-X"
  str='Theme="NewDay-Medium-X/default.theme"'
fi
echo "$str" >~/.icewm/theme
mkdir -p $tmpath
rm -r $tmpath
cp -r $orig_tmpath $tmpath

# バーをちょっと太く
config ${tmpath}/default.theme BorderSizeX 4
config ${tmpath}/default.theme BorderSizeY 4
config ${tmpath}/default.theme DlgBorderSizeX 2
config ${tmpath}/default.theme DlgBorderSizeY 2

if [ "$THEME" = 'laptop' ]; then
  # 「デスクトップを表示」ボタンが気に入らないので変更
  cp /usr/share/icewm/themes/NewDay-Medium/taskbar/desktop.xpm ${tmpath}/taskbar/desktop.xpm
  sed -i 's/DFDBD2/000000/' ${tmpath}/taskbar/desktop.xpm
  # 基本色を明るく置換
  sed -i 's/AAA1A1/DDD5D5/' ${tmpath}/default.theme ${tmpath}/*.xpm

  # アクティブ部の白〜青グラデーションを明るく
  sed -i 's/5353E2/D1E3FF/' ${tmpath}/taskbar/taskbuttonactive.xpm ${tmpath}/menusel.xpm
  sed -i 's/3062E4/72B3EC/' ${tmpath}/taskbar/taskbuttonactive.xpm ${tmpath}/menusel.xpm

  # ウィンドウバーボタンの色
  sed -i 's/FF0000/FF3D3D/' ${tmpath}/*.xpm # マウスオーバしたときのバツの赤
  sed -i 's/2828E8/72B3EC/' ${tmpath}/*.xpm # マウスオーバしたときの最小最大化の青
  sed -i 's/3C3B37/72B3EC/' ${tmpath}/*.xpm # 上の謎の線を消す

  # グループタブの個数アイコンを白に
  config_dq ${tmpath}/default.theme ColorActiveTaskBarApp "#BBBBBB"

  # ワークスペース表示の青
  config_dq ${tmpath}/default.theme ColorActiveWorkspaceButton "#72B3EC"

  # クイックスイッチ
  config_dq ${tmpath}/default.theme ColorQuickSwitch "#DDD5D5"
  config_dq ${tmpath}/default.theme ColorQuickSwitchText "black"

  # タスクバー/バーの色
  config_dq ${tmpath}/default.theme ColorActiveTaskBarApp "#BBBBBB"
  config_dq ${tmpath}/default.theme ColorNormalBorder "#dddddd"
  config_dq ${tmpath}/default.theme ColorActiveBorder "#dddddd"
fi

### iceWM追加設定 ###
cat <<EOS >~/.icewm/prefoverride
TaskBarShowWindowTitles=1       # タスクバーにタイトルを出す
TaskBarShowShowDesktopButton=2  # 「デスクトップを表示」を右端に
TaskBarTaskGrouping=2           # タスクバーグルーピング
ShowMenuButtonIcon=1            # タイトルバーにアイコンを出す
ShowMoveSizeStatus=0            # ウィンドウ動かすときの座標出さない
QuickSwitchRaiseCandidate=1     # Alt+Tab中に選択ウィンドウが手前に出る
QuickSwitchVertical=0           # クイックスイッチを横表示
LargeIconSize=64                # 巨大クイックスイッチ
EOS
if [ "$THEME" = 'laptop' ]; then
 echo 'TaskBarAtTop=1 # タスクバーをトップに出す' >>~/.icewm/prefoverride
fi

### タスクバーアプリ設定 ###
cat <<EOS >~/.icewm/toolbar
prog "skippy-xd" /usr/share/icons/papirus-antix/48x48/actions/dialog-rows-and-columns.png skippy-xd
prog "ROXTerm " /usr/share/icons/papirus-antix/24x24/apps/roxterm.png roxterm
prog "ファイルマネージャー" /usr/share/icons/papirus-antix/48x48/apps/file-manager.png desktop-defaults-run -fm
prog "ウェブブラウザー" /usr/share/icons/papirus-antix/48x48/apps/web-browser.png desktop-defaults-run -b
prog "antiX Cloud" /usr/share/icons/papirus-antix/24x24/places/folder-red-meocloud.png antix-cloud
EOS

### ログイン画面設定 ###
sudo sed -i 's/current_theme     antiX/current_theme    DarkCity/' /etc/slimski.local.conf

### ホットキーをWindowsっぽく ###
function config-pref () {
  config_dq ~/.icewm/preferences $1 $2
}
# Win+上下左右でウィンドウを画面半分に移動するのは既定でできる
# Win+Shift+上下左右でウィンドウを画面四隅に移動する
config-pref "KeyWinTileTopLeft"           "Super+Shift+Up"
config-pref "KeyWinTileTopRight"          "Super+Shift+Right"
config-pref "KeyWinTileBottomLeft"        "Super+Shift+Left"
config-pref "KeyWinTileBottomRight"       "Super+Shift+Down"
# Ctrl+Win+左右でワークスペースを切り替える
# Ctrl+Win+Alt+左右でワークスペースを切り替えつつウィンドウを拉致
config-pref "KeySysWorkspaceNext"         "Ctrl+Super+Right"
config-pref "KeySysWorkspacePrev"         "Ctrl+Super+Left"
config-pref "KeySysWorkspaceNextTakeWin"  "Ctrl+Super+Alt+Right"
config-pref "KeySysWorkspacePrevTakeWin"  "Ctrl+Super+Alt+Left"
# Win+Tabでウィンドウ一覧表示
if ! grep -q 'skippy-xd' ~/.icewm/keys; then
  echo 'key "Super+Tab" skippy-xd' >>~/.icewm/keys
fi
# Win+Spaceでアプリ検索
sed -i 's/Ctrl+Space/Super+Space/g' ~/.icewm/keys

### zzzFM 設定 ###
sed -i '/single_click/d' ~/.config/zzzfm/session* # シングルクリックを許さない

### ROXterm カラースキーム ###
mkdir -p ~/.config/roxterm.sourceforge.net/Colours
cat <<EOS >~/.config/roxterm.sourceforge.net/Colours/solarized-light
[roxterm colour scheme]
foreground=#65657b7b8383
background=#fdfdf6f6e3e3
0=#eeeee8e8d5d5
1=#dcdc32322f2f
2=#858599990000
3=#b5b589890000
4=#26268b8bd2d2
5=#d3d336368282
6=#2a2aa1a19898
7=#070736364242
8=#00002b2b3636
9=#cbcb4b4b1616
10=#9393a1a1a1a1
11=#838394949696
12=#65657b7b8383
13=#6c6c7171c4c4
14=#58586e6e7575
15=#fdfdf6f6e3e3
16=#4c4c4c4c4c4c
17=#a8a830303030
18=#202088882020
19=#a8a888880000
20=#555555559898
21=#888830308888
22=#303088888888
23=#d8d8d8d8d8d8
cursor=#58586e6e7575
palette_size=16
EOS
if [ "$THEME" = 'laptop' ]; then
  str='solarized-light'
else
  str='Tango'
fi
sed -i -e "/^colour_scheme/c colour_scheme=${str}" ~/.config/roxterm.sourceforge.net/Global

### .vimrc ###
mkdir -p ~/.vimbackupfiles
sudo apt-get -y install vim-gtk3
wget http://ponzu840w.jp/env/.vimrc -O ~/.vimrc
cat <<EOS >~/.vimrc_local
set backupdir-=.
set backupdir^=~/.vimbackupfiles
EOS
if [ "$THEME" = 'laptop' ]; then
  str='colorscheme peachpuff'
else
  str='colorscheme evening'
fi
echo "$str" >>~/.vimrc_local

### .bashrc ###
# $HOME/.local/bin を PATH に追加
str='if [ -d "$HOME/.local/bin" ]; then PATH="$HOME/.local/bin:$PATH"; fi'
if ! grep -q '/.local/bin' ~/.bashrc; then
  echo "$str" >>~/.bashrc
fi

### .desktop-session/startup ###
# クリップボードマネージャの起動有効化
sed -i "s/#clipit/clipit/" ~/.desktop-session/startup

#icewm --restart
/usr/local/lib/desktop-session/desktop-session-restart
