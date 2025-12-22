# $PROFILE

# ---------------------------------------------------------------------------
#                                  プロンプト
# ---------------------------------------------------------------------------
function prompt
{
  # 直前のコマンドのステータス
  $statusColor = if ($?) { 'DarkBlue' } else { 'Red' }
  $statusSymbol = if ($?) { '✔' } else { '✘' }

  # パス
  $path = $PWD.Path
  if ($path.StartsWith($HOME))
  {
    $path = $path.Replace($HOME, '~')
  }

  # ホスト名 (.local 等は削除)
  $hostName = [System.Net.Dns]::GetHostName().Split('.')[0]
  $userName = $env:USER

  # --- 1行目: user@hostname:path ---
  Write-Host "$userName@$hostName" -NoNewline -ForegroundColor DarkBlue
  Write-Host ":" -NoNewline -ForegroundColor Black
  Write-Host $path -ForegroundColor DarkGreen

  # --- 2行目: ステータス + プロンプト ---
  Write-Host "$statusSymbol ❯" -NoNewline -ForegroundColor $statusColor

  # 戻り値
  return " "
}

# ---------------------------------------------------------------------------
#                 iTerm2 Solarized Light対応 PSReadLine色設定
# ---------------------------------------------------------------------------
Set-PSReadLineOption -Colors @{
  # --- 基本 ---
  Default            = 'Black'

  # --- 構文ハイライト ---
  Command            = 'DarkBlue'     # コマンド (Get-ChildItem)
  Keyword            = 'DarkMagenta'  # 予約語 (if, else, function)
  String             = 'DarkCyan'     # 文字列 ("text")
  Variable           = 'DarkRed'      # 変数 ($HOME)
  Parameter          = 'DarkYellow'   # パラメータ (-Path)
  Operator           = 'DarkGray'     # 演算子 (=, |)
  Type               = 'DarkGreen'    # 型 ([string])
  Number             = 'DarkBlue'     # 数値 (100)
  Member             = 'Blue'         # メンバー/プロパティ (.Length)
  Comment            = 'DarkGreen'    # コメント (#comment)

  # --- プロンプト・その他 ---
  ContinuationPrompt    = 'Black'     # 継続プロンプト ( >> )
  Emphasis              = 'DarkCyan'  # 強調 (検索マッチなど)
  Error                 = 'Red'
  InlinePrediction      = 'Magenta'
  ListPredictionTooltip = 'Green'
}

# ---------------------------------------------------------------------------
#                                  GNU Tools
# ---------------------------------------------------------------------------
$gnuBase = "/opt/homebrew/opt"
$gnuBinPath = "libexec/gnubin"
$gnuManPath = "libexec/gnuman"

foreach ($tool in @("coreutils", "findutils"))
{
  $bin = "$gnuBase/$tool/$gnuBinPath" # PATH
  if ($env:PATH -notlike "*$bin*") { $env:PATH = "${bin}:$env:PATH" }

  $man = "$gnuBase/$tool/$gnuManPath" # MANPATH
  if ($env:MANPATH -notlike "*$man*") { $env:MANPATH = "${man}:$env:MANPATH" }
}

# ---------------------------------------------------------------------------
#                                  ls colors
# ---------------------------------------------------------------------------
if (Get-Command dircolors -ErrorAction SilentlyContinue)
{
  if (Test-Path ~/.colorrc)
  {
    # Bash用の表現 (LS_COLORS='...'; export...) から値を抽出
    $colors = (dircolors -b ~/.colorrc)[0]
    if ($colors -match "LS_COLORS='(.*?)'") { $env:LS_COLORS = $matches[1] }
  }
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
# GNU lsが前提。pwshのエイリアスは削除。使いたければgci。
if (Test-Path Alias:ls) { Remove-Item Alias:ls -Force }
function ls { command ls -FG --color=auto @args }
function ll { ls -lh  @args }
function la { ls -A   @args }
function l  { ls -C   @args }

# ----- others -----
function clip
{
  if ($MyInvocation.ExpectingInput) { $input | Set-Clipboard }
  else                              { Get-Clipboard }
}
function nik { vim /Users/ponzu840w/.od/doc/nikki }
function gitlog { git log --decorate --oneline --graph }

