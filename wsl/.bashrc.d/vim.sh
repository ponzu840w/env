# ~/.bashrc.d/vim.sh
# vimコマンドでwindows版nvim.exeを起動するラッパースクリプト

# パスのlinux->windows変換
#   新規ファイルなどの面倒に対応
#   vimのファイル名指定用
function __vimarg () {
  local EXEARG=$(echo $@ | awk 'BEGIN{ORS} {
    split($0,inarg)
    for(i in inarg){
      #print "[[DEBUG]inarg["i"]:"inarg[i]"]"
      if(inarg[i]~/^-/){ # オプション引数は素通り
        print(inarg[i])
      }else{             # パス引数
        "test -d "inarg[i]" ; echo $?" | getline ts
        if (ts==0) {     # ディレクトリなら、そのままWindowsパスにする
          print(winpath(inarg[i]))
        }else{           # ファイルの場合、新規ファイルかもしれないのでディレクトリ部分だけwslpathに通す。
          num=split(inarg[i],splpath,"/")
          if (num==1) {  # カレントディレクトリならそれも必要なし
            print(inarg[i])
          }else{
            base=substr(inarg[i],1,length(inarg[i])-length(splpath[num]))
            print("'\''"winpath(base) "\\" splpath[num]"'\''")
          }
        }
      }
    }
  }
  function winpath(path,  wpath) {  # UNIXパスがWindowsパスになって返る魔法の関数。
    #print "[[DEBUG]winpath:"path"]"
    "wslpath -w "path"" | getline wpath
    close("wslpath -w "path"")  #パイプ閉じ忘れがち
    return wpath
  }')
  #echo "[DEBUG] \$EXEARG=" $EXEARG
  echo $EXEARG
}

function vim () { # CoolRetroTerm用
  # シェルのカレントディレクトリに移動するvimスクリプトを作成
  # ***直接eval文中でやると二バイト文字が暴れる***
  echo 'cd '$(__vimarg .) > /tmp/vimopendir.vim
  # CRTのときはデフォルトカラースキームにする
  local VIMCOM='set shell=bash'
  # https://askubuntu.com/questions/210182/how-to-check-which-terminal-emulator-is-being-currently-used
  local TERMNAME=$(basename "/"$(ps -o cmd -f -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/ .*$//'))
  if [[ "$TERMNAME" == Cool-Retro-Term* ]]; then
    VIMCOM="colorscheme default|$VIMCOM"
  fi
  # 1.作成したスクリプトの実行
  # 2.カラースキームを指定
  # 3.termコマンドで出るシェルをbashに変更
  # をしたうえで、（Windowsパスに変換された）引数ファイルを開く
  eval nvim.exe "-S" $(__vimarg /tmp/vimopendir.vim) "-c" '"$VIMCOM"' $(__vimarg $@)
}
