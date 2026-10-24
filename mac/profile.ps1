# mac 固有の pwsh 設定（../profile.ps1 から読み込まれる）

# ---------------------------------------------------------------------------
#                                  プロンプト
# ---------------------------------------------------------------------------
$PromptColor = 'DarkBlue'

# ---------------------------------------------------------------------------
#               iTerm2 Solarized Light/dark対応 PSReadLine色設定
# ---------------------------------------------------------------------------
Set-PSReadLineOption -Colors @{
  # --- 基本 ---
  Default            = "`e[39m"

  # --- 構文ハイライト ---
  Command            = 'DarkBlue'     # コマンド (Get-ChildItem)
  Keyword            = 'DarkMagenta'  # 予約語 (if, else, function)
  String             = 'DarkCyan'     # 文字列 ("text")
  Variable           = 'DarkRed'      # 変数 ($HOME)
  Parameter          = 'DarkYellow'   # パラメータ (-Path)
  Operator           = "`e[2;39m"     # 演算子 (=, -gt, -not)
  Type               = 'DarkGreen'    # 型 ([string])
  Number             = 'DarkBlue'     # 数値 (100)
  Member             = 'Blue'         # メンバー/プロパティ (.Length)
  Comment            = 'DarkGreen'    # コメント (#comment)

  # --- プロンプト・その他 ---
  ContinuationPrompt    = "`e[39m"    # 継続プロンプト ( >> )
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
  $colorrc = Join-Path $PSScriptRoot .colorrc
  if (Test-Path $colorrc)
  {
    # Bash用の表現 (LS_COLORS='...'; export...) から値を抽出
    $colors = (dircolors -b $colorrc)[0]
    if ($colors -match "LS_COLORS='(.*?)'") { $env:LS_COLORS = $matches[1] }
  }
}

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
function nik { vim /Users/ponzu840w/.od/doc/nikki }
function gay { vim /Users/ponzu840w/.od/doc/gay.txt }

#$env:BLOG_ROOT = "/Users/ponzu840w/work/bbr/data-test"
$env:BBR_REPO = "/Users/ponzu840w/work/bbr/data"
$env:PATH = "${env:PATH}:~/work/bbr/bin"
$env:PATH = "${env:PATH}:~/work/cc65/bin"
$env:PATH = "${env:PATH}:/usr/local/bin"
$env:PATH = "/opt/homebrew/bin:${env:PATH}"
$env:PATH = "~/.local/bin:${env:PATH}"
$env:PATH = "${env:PATH}:/Users/ponzu840w/work/cc65/bin"
$env:HOMEBREW_NO_ENV_HINTS = 1

function rbenv
{
  Remove-Item Function:\rbenv -ErrorAction SilentlyContinue
  $rbenvShim = "$HOME/.rbenv/shims"
  if ((${env:PATH} -split ':') -notcontains $rbenvShim) { ${env:PATH} = "${rbenvShim}:${env:PATH}" }
  rbenv @args
}

# tmuxがインストールされていて、かつtmuxセッション内でなければ実行
#if ((Get-Command "tmux" -ErrorAction SilentlyContinue) -and -not $env:TMUX) {
#    # VSCode内のターミナルや、SSH接続先としての起動でないかチェック（多重起動防止）
#    if (-not $env:VSCODE_PID -and -not $env:SSH_CONNECTION) {
#        # 'main' という名前のセッションがあればアタッチ、なければ新規作成
#        # -u はUTF-8強制オプション（日本語文字化け防止のお守り）
#        tmux -u new-session -A -s main
#    }
#}

function python  { python3.14 @args }
