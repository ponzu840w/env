#!/bin/bash
### 設定ファイルのごみ箱 ###
mkdir -p ~/.oldfiles

### antixリポジトリの認証が死んでるのでキーを強制インストール ###
# https://www.antixforum.com/forums/topic/expired-gpg-key/
sudo apt-get update --allow-insecure-repositories
yes | sudo apt-get install antix-archive-keyring --allow-unauthenticated

### もし上記だけでもダメだったら認証を無効化（アブナイよ！） ###
#cp -n /etc/apt/sources.list.d/antix.list ~/.oldfiles/antix.list.old
#sudo sed -i -e '/^deb/s/\[.*\] //' /etc/apt/sources.list.d/antix.list

### アプデ ###
sudo apt-get update
yes | sudo apt-get -y upgrade

### 日本語入力パッケージインストール ###
sudo apt-get install -y --install-recommends fcitx fcitx-mozc

### fcitx起動設定 ###
str="
# fcitxの起動
fcitx-autostart&
"
if ! grep -q 'fcitx-autostart' ~/.desktop-session/startup; then
  echo "$str" >>~/.desktop-session/startup
fi
if ! grep -q 'fcitx-autostart' /etc/skel/.desktop-session/startup; then
  echo "$str" | sudo tee -a /etc/skel/.desktop-session/startup
fi

str="
# fcitxの起動
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
"
if ! grep -q 'GTK_IM_MODULE' ~/.desktop-session/desktop-session.conf; then
  echo "$str" >>~/.desktop-session/desktop-session.conf
fi
if ! grep -q 'GTK_IM_MODULE' /etc/skel/.desktop-session/desktop-session.conf; then
  echo "$str" | sudo tee -a /etc/skel/.desktop-session/desktop-session.conf
fi

### vimがroxtermでおかしくなるのを防ぐ bashrc ###
str="
# vimがroxtermでおかしくなるのを防ぐ
export TERM=gnome-256color
"
if ! grep -q 'gnome-256color' ~/.bashrc; then
  echo "$str" >>~/.bashrc
fi
if ! grep -q 'gnome-256color' /etc/skel/.bashrc; then
  echo "$str" | sudo tee -a /etc/skel/.bashrc
fi

### キーレイアウト切り替えをAlt+ShiftからWin+Spaceに ###
# ウィンドウ切り替えとの重複回避
sudo sed -i 's/grp:.*,/grp:win_space_toggle,/' /etc/default/keyboard
sudo sed -i 's/grp:.*\"/grp:win_space_toggle\"/' /etc/default/keyboard

### 時計の文字化け解消 ###
sed -i -e 's/^xftfont DejaVu/xftfont/' ~/.conkyrc
sudo sed -i -e 's/^xftfont DejaVu/xftfont/' /etc/skel/.conkyrc

### zzzfmの日本語化 ###
wget ponzu840w.jp/env/for_use_antix-contribs_zzzfmpot_ja.po -O zzzfm_ja.po
msgfmt -c -o zzzfm.mo zzzfm_ja.po
sudo cp zzzfm.mo /usr/share/locale/ja/LC_MESSAGES/zzzfm.mo
rm zzzfm_ja.po zzzfm.mo
