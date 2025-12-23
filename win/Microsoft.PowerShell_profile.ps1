
# $PROFILE

# ---------------------------------------------------------------------------
#                                  プロンプト
# ---------------------------------------------------------------------------
function prompt
{
  # 直前のコマンドのステータス
  $prevStatus = $?
  $statusColor = if ($prevStatus) { 'Cyan' } else { 'Red' }
  $statusSymbol = if ($prevStatus) { '✔' } else { '✘' }

  # パス
  $path = $PWD.Path
  if ($path.StartsWith($HOME))
  {
    $path = $path.Replace($HOME, '~')
  }

  # ホスト名 (.local 等は削除)
  $hostName = [System.Net.Dns]::GetHostName().Split('.')[0]
  $userName = $env:USERNAME

  # --- 1行目: user@hostname:path ---
  Write-Host "$userName@$hostName" -NoNewline -ForegroundColor Cyan
  Write-Host ":" -NoNewline
  Write-Host $path -ForegroundColor DarkGreen

  # --- 2行目: ステータス + プロンプト ---
  Write-Host "$statusSymbol ❯" -NoNewline -ForegroundColor $statusColor

  # 戻り値
  return " "
}

# ---------------------------------------------------------------------------
#                                   History
# --------------------------------------------------------------------------
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 8192
$MaximumHistoryCount = 8192

# ---------------------------------------------------------------------------
#                              Alias & Functions
# ---------------------------------------------------------------------------

# ----- ls -----
function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force @args }
function l { Get-ChildItem @args }

# ----- others -----
function clip
{
  if ($MyInvocation.ExpectingInput) { $input | Set-Clipboard }
  else                              { Get-Clipboard }
}

function nik { vim $HOME\OneDrive\doc\nikki }
function gitlog { git log --decorate --oneline --graph }

