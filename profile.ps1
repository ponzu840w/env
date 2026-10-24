# $PROFILE.CurrentUserAllHosts（Windows, mac 共通）
# OS 固有の設定は末尾で <os>/profile.ps1 を読み込む

# ---------------------------------------------------------------------------
#                                  プロンプト
# ---------------------------------------------------------------------------
# user@host と成功時の記号の色。OS 側で上書きする
$PromptColor = 'Cyan'

function prompt
{
  # 直前のコマンドのステータス（以降の処理で上書きされる前に取得）
  $prevStatus = $?
  $statusColor = if ($prevStatus) { $PromptColor } else { 'Red' }
  $statusSymbol = if ($prevStatus) { '✔' } else { '✘' }

  if ($PWD.Provider.Name -eq 'FileSystem')
  {
    # カレントディレクトリをシステムと同期
    [System.IO.Directory]::SetCurrentDirectory($PWD.ProviderPath)

    # tmuxにカレントディレクトリを送信（psmux は自力で追従するので不要）
    if ($env:TMUX -and -not $IsWindows)
    {
      Write-Host -NoNewline "`e]7;file://localhost$($PWD.ProviderPath)`a"
    }
  }

  # パス
  $path = $PWD.Path
  $comparison = if ($IsWindows) { 'OrdinalIgnoreCase' } else { 'Ordinal' }
  if ($path.StartsWith($HOME, $comparison))
  {
    $path = '~' + $path.Substring($HOME.Length)
  }

  # ホスト名 (.local 等は削除)
  $hostName = [System.Net.Dns]::GetHostName().Split('.')[0]
  $userName = [Environment]::UserName

  # --- 1行目: user@hostname:path ---
  Write-Host "$userName@$hostName" -NoNewline -ForegroundColor $PromptColor
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
#                                   Binds
# --------------------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs

# ---------------------------------------------------------------------------
#                              Alias & Functions
# ---------------------------------------------------------------------------
function clip
{
  if ($MyInvocation.ExpectingInput) { $input | Set-Clipboard }
  else                              { Get-Clipboard }
}

function gitlog { git log --decorate --oneline --graph }

# ---------------------------------------------------------------------------
#                                OS 固有の設定
# ---------------------------------------------------------------------------
$osDir = if ($IsWindows) { 'win' } elseif ($IsMacOS) { 'mac' }
if ($osDir) { . (Join-Path $PSScriptRoot $osDir 'profile.ps1') }
Remove-Variable osDir
