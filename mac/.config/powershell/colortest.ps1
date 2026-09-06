# 端末表示色の可読性確認用関数セット

# ANSI色を一覧表示
function Show-AnsiColor
{
  # ConsoleColorの列挙値はANSI番号と一致しない(DarkBlue=1 に対し ANSI blue=4)ため、
  # ANSI番号順に名前を並べた対応表を持つ。
  $names = @(
    'Black', 'DarkRed', 'DarkGreen', 'DarkYellow', 'DarkBlue', 'DarkMagenta', 'DarkCyan', 'Gray'
    'DarkGray', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White'
  )

  Write-Host ""
  Write-Host "  #  ConsoleColor名  前景を変化                背景を変化"
  for ($i = 0; $i -lt 16; $i++)
  {
    $fg = if ($i -lt 8) { 30 + $i } else { 82 + $i }
    $bg = $fg + 10
    Write-Host ("{0,3}  {1,-14}  " -f $i, $names[$i]) -NoNewline
    Write-Host "`e[${fg}m██ Sample あア漢 0123`e[0m   " -NoNewline
    Write-Host "`e[${bg}m`e[39m Sample あア漢 0123 `e[0m"
  }
  Write-Host ""
  Write-Host "`e[39m     デフォルト前景        e[39m    — テーマに追従する`e[0m"
  Write-Host "`e[2;39m     デフォルト前景 faint  e[2;39m`e[0m"
  Write-Host ""
}

# PowerShellの色使いを一覧表示
function Show-PSReadLineColor
{
  $o = Get-PSReadLineOption
  $r = "`e[0m"

  Write-Host ""
  $o.PSObject.Properties |
    Where-Object { $_.Name -like '*Color' } |
    Sort-Object Name |
    ForEach-Object {
      Write-Host ("  {0,-28}" -f ($_.Name -replace 'Color$', '')) -NoNewline
      Write-Host "$($_.Value) Sample あア漢 0123 $r  " -NoNewline
      Write-Host ($_.Value -replace "`e", '\e')
    }

  Write-Host ""
  # 記号(| { } . [ ] ;)はOperatorではなくDefaultで描かれる。PSReadLineが
  # Operator扱いするのはTokenFlagsにAssignment/Binary/UnaryOperatorが立つものだけ。
  $d = $o.DefaultTokenColor
  Write-Host (@(
    "  $($o.CommentColor)# サンプル$r"
    "  $($o.KeywordColor)function$r ${d}Test-Color$r ${d}{$r"
    "    $($o.VariableColor)`$n$r $($o.OperatorColor)=$r $($o.NumberColor)42$r $($o.OperatorColor)-gt$r $($o.NumberColor)7$r"
    "    ${d}[$r$($o.TypeColor)string$r${d}]$r$($o.VariableColor)`$s$r $($o.OperatorColor)=$r $($o.StringColor)'~/work/env'$r${d}.$r$($o.MemberColor)Length$r"
    "    $($o.CommandColor)Get-ChildItem$r $($o.ParameterColor)-Path$r $($o.VariableColor)`$s$r ${d}|$r $($o.CommandColor)Select-Object$r $($o.ParameterColor)-First$r $($o.NumberColor)3$r"
    "  ${d}}$r"
    ""
    "  $($o.ErrorColor)Error$r  $($o.EmphasisColor)Emphasis$r  $($o.InlinePredictionColor)InlinePrediction$r  $($o.ListPredictionTooltipColor)Tooltip$r"
    "  $($o.ContinuationPromptColor)>>$r $($o.SelectionColor)Selection$r"
  ) -join "`n")
  Write-Host ""
}
