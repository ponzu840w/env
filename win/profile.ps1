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

# ---------------------------------------------------------------------------
#             ssh 接続時は接続元 (mac/iTerm2) と同じ配色にする
# ---------------------------------------------------------------------------
if ($env:SSH_CONNECTION)
{
  $PromptColor = 'DarkBlue'
  Set-PSReadLineOption -Colors @{
    Default = "`e[39m"; ContinuationPrompt = "`e[39m"; Operator = "`e[2;39m"
    Command = 'DarkBlue'; Keyword = 'DarkMagenta'; String = 'DarkCyan'
    Variable = 'DarkRed'; Parameter = 'DarkYellow'; Type = 'DarkGreen'
    Number = 'DarkBlue'; Member = 'Blue'; Comment = 'DarkGreen'
    Emphasis = 'DarkCyan'; Error = 'Red'
    InlinePrediction = 'Magenta'; ListPredictionTooltip = 'Green'
  }
}
