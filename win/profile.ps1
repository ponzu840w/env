# Windows 固有の pwsh 設定（../profile.ps1 から読み込まれる）

# ---------------------------------------------------------------------------
#                              Alias & Functions
# ---------------------------------------------------------------------------

# ----- ls -----
function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force @args }
function l { Get-ChildItem @args }

# ----- others -----
function nik { vim $HOME\OneDrive\doc\nikki }

function ucrt { C:\msys64\msys2_shell.cmd -defterm -here -no-start -ucrt64 }
function ytdl { yt-dlp --cookies-from-browser firefox @args }
function ytdloop {
  Write-Host "URLを入力するとダウンロードします。^Cで終了。"
  while ($true) {
    $inputLine = Read-Host
    if ($inputLine -ne "") {
      yt-dlp --cookies-from-browser firefox $inputLine
    }
  }
}
