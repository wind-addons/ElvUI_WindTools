#Requires -Version 5.1
<#
.SYNOPSIS
    Copy ElvUI Chat.lua regions into WindTools ChatText.lua and reapply WindTools format patches.

.DESCRIPTION
    ChatText replaces ElvUI ChatFrame_MessageEventHandler / MessageFormatter at runtime so
    channel and name formatting can follow WindTools options. Those functions must stay in
    sync with ElvUI. This script extracts the forked regions, applies the WindTools transforms,
    and writes them into marked blocks in Modules/Social/ChatText.lua.

.EXAMPLE
    .\Scripts\Sync-ElvUIChat.ps1
    .\Scripts\Sync-ElvUIChat.ps1 -WhatIf
    .\Scripts\Sync-ElvUIChat.ps1 -ElvUIChatPath "D:\src\ElvUI\ElvUI\Game\Shared\Modules\Chat\Chat.lua"
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ElvUIChatPath,
    [string]$ChatTextPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$windToolsRoot = Split-Path -Parent $PSScriptRoot
if (-not $ElvUIChatPath) {
    $ElvUIChatPath = Join-Path $windToolsRoot "..\ElvUI\ElvUI\Game\Shared\Modules\Chat\Chat.lua"
}
if (-not $ChatTextPath) {
    $ChatTextPath = Join-Path $windToolsRoot "Modules\Social\ChatText.lua"
}

$ElvUIChatPath = [System.IO.Path]::GetFullPath($ElvUIChatPath)
$ChatTextPath = [System.IO.Path]::GetFullPath($ChatTextPath)

if (-not (Test-Path -LiteralPath $ElvUIChatPath)) {
    throw "ElvUI Chat.lua not found: $ElvUIChatPath"
}
if (-not (Test-Path -LiteralPath $ChatTextPath)) {
    throw "ChatText.lua not found: $ChatTextPath"
}

function ConvertTo-Lf {
    param([string]$Text)
    return ($Text -replace "`r`n", "`n" -replace "`r", "`n")
}

function Get-ShortSha256 {
    param([string]$Text)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        $hash = $sha.ComputeHash($bytes)
        return ([BitConverter]::ToString($hash).Replace("-", "").ToLowerInvariant()).Substring(0, 12)
    }
    finally {
        $sha.Dispose()
    }
}

function Get-LuaMatchingEndIndex {
    param(
        [string]$Source,
        [int]$KeywordIndex
    )

    $openers = @{
        "function" = $true
        "do"       = $true
        "if"       = $true
        "repeat"   = $true
    }
    $closers = @{
        "end"   = $true
        "until" = $true
    }
    $keywordOrder = @("function", "elseif", "repeat", "until", "end", "do", "if")

    $state = "code"
    $longEq = 0
    $depth = 0
    $i = $KeywordIndex
    $len = $Source.Length
    $started = $false

    while ($i -lt $len) {
        $c = $Source[$i]

        if ($state -eq "linecomment") {
            if ($c -eq "`n") { $state = "code" }
            $i++
            continue
        }

        if ($state -eq "blockcomment" -or $state -eq "longstring") {
            if ($c -eq "]") {
                $eq = 0
                $j = $i + 1
                while ($j -lt $len -and $Source[$j] -eq "=") {
                    $eq++
                    $j++
                }
                if ($j -lt $len -and $Source[$j] -eq "]" -and $eq -eq $longEq) {
                    $i = $j + 1
                    $state = "code"
                    continue
                }
            }
            $i++
            continue
        }

        if ($state -eq "sqstring") {
            if ($c -eq "\") {
                $i += 2
                continue
            }
            if ($c -eq "'") { $state = "code" }
            $i++
            continue
        }

        if ($state -eq "dqstring") {
            if ($c -eq "\") {
                $i += 2
                continue
            }
            if ($c -eq '"') { $state = "code" }
            $i++
            continue
        }

        if ($c -eq "-" -and ($i + 1) -lt $len -and $Source[$i + 1] -eq "-") {
            if (($i + 2) -lt $len -and $Source[$i + 2] -eq "[") {
                $eq = 0
                $k = $i + 3
                while ($k -lt $len -and $Source[$k] -eq "=") {
                    $eq++
                    $k++
                }
                if ($k -lt $len -and $Source[$k] -eq "[") {
                    $longEq = $eq
                    $state = "blockcomment"
                    $i = $k + 1
                    continue
                }
            }
            $state = "linecomment"
            $i += 2
            continue
        }

        if ($c -eq "[") {
            $eq = 0
            $k = $i + 1
            while ($k -lt $len -and $Source[$k] -eq "=") {
                $eq++
                $k++
            }
            if ($k -lt $len -and $Source[$k] -eq "[") {
                $longEq = $eq
                $state = "longstring"
                $i = $k + 1
                continue
            }
        }

        if ($c -eq "'") {
            $state = "sqstring"
            $i++
            continue
        }
        if ($c -eq '"') {
            $state = "dqstring"
            $i++
            continue
        }

        if ($c -match "[A-Za-z_]") {
            $keyword = $null
            foreach ($word in $keywordOrder) {
                $wordLength = $word.Length
                if (($i + $wordLength) -le $len -and $Source.Substring($i, $wordLength) -eq $word) {
                    $beforeOk = ($i -eq 0) -or ($Source[$i - 1] -notmatch "[A-Za-z0-9_]")
                    $afterOk = (($i + $wordLength) -eq $len) -or ($Source[$i + $wordLength] -notmatch "[A-Za-z0-9_]")
                    if ($beforeOk -and $afterOk) {
                        $keyword = $word
                        break
                    }
                }
            }

            if ($keyword -and $openers.ContainsKey($keyword)) {
                $depth++
                $started = $true
                $i += $keyword.Length
                continue
            }
            if ($keyword -and $closers.ContainsKey($keyword)) {
                $depth--
                $i += $keyword.Length
                if ($started -and $depth -eq 0) {
                    return $i
                }
                continue
            }

            while ($i -lt $len -and $Source[$i] -match "[A-Za-z0-9_]") {
                $i++
            }
            continue
        }

        $i++
    }

    throw "Unclosed Lua block starting at index $KeywordIndex"
}

function Get-ExtractEndWithNewline {
    param(
        [string]$Source,
        [int]$EndIndex
    )

    if ($EndIndex -lt $Source.Length -and $Source[$EndIndex] -eq "`r") {
        $EndIndex++
    }
    if ($EndIndex -lt $Source.Length -and $Source[$EndIndex] -eq "`n") {
        $EndIndex++
    }
    return $EndIndex
}

function Get-LuaDeclarationDoBlock {
    param(
        [string]$Source,
        [string]$Declaration
    )

    $declIndex = $Source.IndexOf($Declaration)
    if ($declIndex -lt 0) {
        throw "Could not find declaration '$Declaration'"
    }

    $scan = $declIndex + $Declaration.Length
    while ($scan -lt $Source.Length -and $Source[$scan] -match "[ \t\r\n]") {
        $scan++
    }
    if ($scan + 2 -gt $Source.Length -or $Source.Substring($scan, 2) -ne "do") {
        throw "Expected 'do' after '$Declaration'"
    }

    $endIndex = Get-LuaMatchingEndIndex -Source $Source -KeywordIndex $scan
    $endIndex = Get-ExtractEndWithNewline -Source $Source -EndIndex $endIndex
    return $Source.Substring($declIndex, $endIndex - $declIndex).TrimEnd("`r", "`n")
}

function Get-LuaFunction {
    param(
        [string]$Source,
        [string]$Signature
    )

    $signatureIndex = $Source.IndexOf($Signature)
    if ($signatureIndex -lt 0) {
        throw "Could not find function signature '$Signature'"
    }

    $extractStart = $signatureIndex
    if ($signatureIndex -ge 6 -and $Source.Substring($signatureIndex - 6, 6) -eq "local ") {
        $extractStart = $signatureIndex - 6
    }

    $functionIndex = $Source.IndexOf("function", $extractStart)
    $endIndex = Get-LuaMatchingEndIndex -Source $Source -KeywordIndex $functionIndex
    $endIndex = Get-ExtractEndWithNewline -Source $Source -EndIndex $endIndex
    return $Source.Substring($extractStart, $endIndex - $extractStart).TrimEnd("`r", "`n")
}

function Edit-RequiredLiteral {
    param(
        [string]$Text,
        [string]$Old,
        [string]$New,
        [string]$Name,
        [int]$ExpectedCount = 1
    )

    $parts = $Text.Split(@($Old), [System.StringSplitOptions]::None)
    $found = $parts.Count - 1
    if ($found -ne $ExpectedCount) {
        throw "Transform '$Name' failed: expected $ExpectedCount occurrence(s), found $found"
    }
    return ($parts -join $New)
}

function Add-AfterLineContaining {
    param(
        [string]$Text,
        [string]$LineContains,
        [string]$InsertLine,
        [string]$Name
    )

    $pattern = "(?m)^([ \t]*" + [regex]::Escape($LineContains) + ")(\r?)$"
    $match = [regex]::Match($Text, $pattern)
    if (-not $match.Success) {
        throw "Transform '$Name' failed: line containing '$LineContains' not found"
    }

    $indent = [regex]::Match($match.Groups[1].Value, "^[ \t]*").Value
    $replacement = $match.Groups[1].Value + "`n" + $indent + $InsertLine
    return $Text.Remove($match.Index, $match.Length).Insert($match.Index, $replacement)
}

function Add-BeforeLineContaining {
    param(
        [string]$Text,
        [string]$LineContains,
        [string]$InsertLine,
        [string]$Name
    )

    $pattern = "(?m)^([ \t]*)(" + [regex]::Escape($LineContains) + ")"
    $match = [regex]::Match($Text, $pattern)
    if (-not $match.Success) {
        throw "Transform '$Name' failed: line containing '$LineContains' not found"
    }

    $indent = $match.Groups[1].Value
    $inserted = $indent + $InsertLine + "`n"
    return $Text.Insert($match.Index, $inserted)
}

function Convert-RegexBlock {
    param(
        [string]$Text,
        [string]$Pattern,
        [scriptblock]$Builder,
        [string]$Name
    )

    $match = [regex]::Match($Text, $Pattern)
    if (-not $match.Success) {
        throw "Transform '$Name' failed: pattern not found"
    }

    $replacement = & $Builder $match
    return $Text.Remove($match.Index, $match.Length).Insert($match.Index, $replacement)
}

function ConvertTo-MarkedRegion {
    param(
        [string]$Name,
        [string]$Unpatched,
        [string]$Patched
    )

    $hash = Get-ShortSha256 -Text $Unpatched
    $body = $Patched.TrimEnd("`r", "`n")
    return "-- [[elvui-sync:$Name sha256:$hash]]`n$body`n-- [[/elvui-sync:$Name]]"
}

function Set-MarkedRegion {
    param(
        [string]$Text,
        [string]$Name,
        [string]$RegionText
    )

    $pattern = "(?s)-- \[\[elvui-sync:$Name(?: sha256:[0-9a-f]+)?\]\]\r?\n.*?-- \[\[/elvui-sync:$Name\]\]"
    $match = [regex]::Match($Text, $pattern)
    if (-not $match.Success) {
        throw "ChatText.lua is missing region markers for '$Name'"
    }
    return $Text.Remove($match.Index, $match.Length).Insert($match.Index, $RegionText.TrimEnd("`r", "`n"))
}

function Invoke-HandlerPatches {
    param([string]$Text)

    $Text = Edit-RequiredLiteral -Text $Text -Old "function CH:ChatFrame_MessageEventHandler(" -New "function CT:ChatFrame_MessageEventHandler(" -Name "handler-rename" -ExpectedCount 1

    $Text = Add-BeforeLineContaining -Text $Text -LineContains "local notChatHistory, historySavedName" -InsertLine "local noBrackets = CT.db.removeBrackets" -Name "handler-noBrackets"

    $Text = Add-AfterLineContaining -Text $Text -LineContains "local coloredName = historySavedName or CH:GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg18)" -InsertLine "coloredName = CT:HandleName(coloredName)" -Name "handler-handleName"

    $Text = Edit-RequiredLiteral -Text $Text -Old "format('[%s]', coloredName)" -New "format(noBrackets and '%s' or '[%s]', coloredName)" -Name "handler-brackets-coloredName" -ExpectedCount 2
    $Text = Edit-RequiredLiteral -Text $Text -Old "format('[%s] (%s)', arg2, charName)" -New "format(noBrackets and '%s (%s)' or '[%s] (%s)', arg2, charName)" -Name "handler-brackets-bnet-char" -ExpectedCount 1
    $Text = Edit-RequiredLiteral -Text $Text -Old "format('[%s] (%s%s)', arg2, clientTexture, charName)" -New "format(noBrackets and '%s (%s%s)' or '[%s] (%s%s)', arg2, clientTexture, charName)" -Name "handler-brackets-bnet-client" -ExpectedCount 1
    $Text = Edit-RequiredLiteral -Text $Text -Old "format('[%s]', arg2)" -New "format(noBrackets and '%s' or '[%s]', arg2)" -Name "handler-brackets-arg2" -ExpectedCount 3

    $systemPattern = "(?m)^([ \t]*)if \(chatType == 'SYSTEM' or chatType == 'SKILL' or chatType == 'CURRENCY' or chatType == 'MONEY' or\r?\n([ \t]*)chatType == 'OPENING' or chatType == 'TRADESKILLS' or chatType == 'PET_INFO' or chatType == 'TARGETICONS' or chatType == 'BN_WHISPER_PLAYER_OFFLINE'\) then\r?\n([ \t]*)frame:AddMessage\(arg1, info\.r, info\.g, info\.b, info\.id, nil, nil, nil, nil, nil, isHistory, historyTime\)"
    $Text = Convert-RegexBlock -Text $Text -Pattern $systemPattern -Name "handler-guild-status" -Builder {
        param($match)
        $ifIndent = $match.Groups[1].Value
        $contIndent = $match.Groups[2].Value
        $msgIndent = $match.Groups[3].Value
        return "${ifIndent}if (chatType == 'SYSTEM' or chatType == 'SKILL' or chatType == 'CURRENCY' or chatType == 'MONEY' or`n${contIndent}chatType == 'OPENING' or chatType == 'TRADESKILLS' or chatType == 'PET_INFO' or chatType == 'TARGETICONS' or chatType == 'BN_WHISPER_PLAYER_OFFLINE') then`n${msgIndent}if chatType ~= `"SYSTEM`" or not CT:ElvUIChat_GuildMemberStatusMessageHandler(frame, arg1) then`n${msgIndent}frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)`n${msgIndent}end"
    }

    $guildPattern = "(?m)^([ \t]*)elseif strsub\(chatType,1,18\) == 'GUILD_ACHIEVEMENT' then\r?\n([ \t]*)frame:AddMessage\(format\(arg1, CH:GetPlayerLink\(arg2, format\(noBrackets and '%s' or '\[%s\]', coloredName\)\)\), info\.r, info\.g, info\.b, info\.id, nil, nil, nil, nil, nil, isHistory, historyTime\)"
    $Text = Convert-RegexBlock -Text $Text -Pattern $guildPattern -Name "handler-guild-achievement" -Builder {
        param($match)
        $elseifIndent = $match.Groups[1].Value
        $msgIndent = $match.Groups[2].Value
        return "${elseifIndent}elseif strsub(chatType,1,18) == 'GUILD_ACHIEVEMENT' then`n${msgIndent}if not CT:ElvUIChat_AchievementMessageHandler(event, frame, arg1, arg12) then`n${msgIndent}frame:AddMessage(format(arg1, CH:GetPlayerLink(arg2, format(noBrackets and '%s' or '[%s]', coloredName))), info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)`n${msgIndent}end"
    }

    $Text = Edit-RequiredLiteral -Text $Text -Old "CH:MessageFormatter(" -New "CT:MessageFormatter(" -Name "handler-call-formatter" -ExpectedCount 2
    return $Text
}

function Invoke-FormatterPatches {
    param([string]$Text)

    $Text = Edit-RequiredLiteral -Text $Text -Old "function CH:MessageFormatter(" -New "function CT:MessageFormatter(" -Name "formatter-rename" -ExpectedCount 1

    $Text = Add-BeforeLineContaining -Text $Text -LineContains "if chatType == 'WHISPER_INFORM' and (GMChatFrame_IsGM and GMChatFrame_IsGM(arg2)) then" -InsertLine "local noBrackets = CT.db.removeBrackets`n" -Name "formatter-noBrackets"

    $Text = Edit-RequiredLiteral -Text $Text -Old "format('[%s]', coloredName)" -New "format(noBrackets and '%s' or '[%s]', coloredName)" -Name "formatter-brackets-coloredName" -ExpectedCount 1
    $Text = Edit-RequiredLiteral -Text $Text -Old "format(header..'[%s] %s', pflag..sender, arg3, msg)" -New "format(header..(noBrackets and '%s %s' or '[%s] %s'), pflag..sender, arg3, msg)" -Name "formatter-brackets-language" -ExpectedCount 1
    return $Text
}

Write-Host "ElvUI Chat.lua : $ElvUIChatPath"
Write-Host "ChatText.lua   : $ChatTextPath"

$elvuiSource = ConvertTo-Lf -Text ([System.IO.File]::ReadAllText($ElvUIChatPath))
$chatTextOriginal = [System.IO.File]::ReadAllText($ChatTextPath)
$chatTextLf = ConvertTo-Lf -Text $chatTextOriginal
$newline = "`n"
if ($chatTextOriginal.Contains("`r`n")) {
    $newline = "`r`n"
}

$extracted = [ordered]@{
    specialChatIcons              = Get-LuaDeclarationDoBlock -Source $elvuiSource -Declaration "local specialChatIcons"
    FlashTabIfNotShown            = Get-LuaFunction -Source $elvuiSource -Signature "function FlashTabIfNotShown("
    ChatFrame_CheckAddChannel     = Get-LuaFunction -Source $elvuiSource -Signature "function ChatFrame_CheckAddChannel("
    ChatFrame_MessageEventHandler = Get-LuaFunction -Source $elvuiSource -Signature "function CH:ChatFrame_MessageEventHandler("
    MessageFormatter              = Get-LuaFunction -Source $elvuiSource -Signature "function CH:MessageFormatter("
}

foreach ($name in $extracted.Keys) {
    $lineCount = ($extracted[$name] -split "`n").Count
    Write-Host ("Extracted {0,-32} {1,5} lines" -f $name, $lineCount)
}

$patched = [ordered]@{
    specialChatIcons              = $extracted.specialChatIcons
    FlashTabIfNotShown            = $extracted.FlashTabIfNotShown
    ChatFrame_CheckAddChannel     = $extracted.ChatFrame_CheckAddChannel
    ChatFrame_MessageEventHandler = Invoke-HandlerPatches -Text $extracted.ChatFrame_MessageEventHandler
    MessageFormatter              = Invoke-FormatterPatches -Text $extracted.MessageFormatter
}

$markedRegions = [ordered]@{}
foreach ($name in $extracted.Keys) {
    $markedRegions[$name] = ConvertTo-MarkedRegion -Name $name -Unpatched $extracted[$name] -Patched $patched[$name]
}

$syncedBlock = @(
    "-- stylua: ignore start"
    "-- Based on ElvUI Chat"
    $markedRegions.specialChatIcons
    ""
    $markedRegions.FlashTabIfNotShown
    ""
    $markedRegions.ChatFrame_CheckAddChannel
    ""
    $markedRegions.ChatFrame_MessageEventHandler
    ""
    $markedRegions.MessageFormatter
    "-- stylua: ignore end"
) -join "`n"

$updated = $chatTextLf
$hasMarkers = $true
foreach ($name in $extracted.Keys) {
    if ($updated -notmatch "-- \[\[elvui-sync:$name") {
        $hasMarkers = $false
        break
    }
}

if ($hasMarkers) {
    foreach ($name in $extracted.Keys) {
        $updated = Set-MarkedRegion -Text $updated -Name $name -RegionText $markedRegions[$name]
    }
}
else {
    $styluaPattern = "(?s)-- stylua: ignore start\r?\n.*?-- stylua: ignore end"
    $styluaMatch = [regex]::Match($updated, $styluaPattern)
    if (-not $styluaMatch.Success) {
        throw "ChatText.lua has no elvui-sync markers and no '-- stylua: ignore start/end' block to replace"
    }
    $updated = $updated.Remove($styluaMatch.Index, $styluaMatch.Length).Insert($styluaMatch.Index, $syncedBlock.TrimEnd("`n"))
}

if ($updated -eq $chatTextLf) {
    Write-Host "ChatText.lua is already in sync."
    return
}

if ($newline -eq "`r`n") {
    $updatedToWrite = $updated -replace "`n", "`r`n"
}
else {
    $updatedToWrite = $updated
}

Write-Host "ChatText.lua will change. Region source hashes:"
foreach ($name in $extracted.Keys) {
    Write-Host ("  {0}: {1}" -f $name, (Get-ShortSha256 -Text $extracted[$name]))
}

if ($PSCmdlet.ShouldProcess($ChatTextPath, "Update synced ElvUI chat regions")) {
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($ChatTextPath, $updatedToWrite, $utf8)
    Write-Host "Wrote $ChatTextPath"
}
else {
    $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "wt-sync-elvui-chat"
    [void][System.IO.Directory]::CreateDirectory($tempRoot)
    $oldTemp = Join-Path $tempRoot "ChatText.old.lua"
    $newTemp = Join-Path $tempRoot "ChatText.new.lua"
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($oldTemp, $chatTextLf, $utf8)
    [System.IO.File]::WriteAllText($newTemp, $updated, $utf8)
    git --no-pager diff --no-index --unified=3 -- $oldTemp $newTemp
    if ($LASTEXITCODE -eq 1) {
        $global:LASTEXITCODE = 0
    }
    Write-Host "WhatIf: no files written."
}
