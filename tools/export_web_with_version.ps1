param(
    [string]$ProjectDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [string]$Preset = "Web",
    [string]$ExportPath = "build/web/index.html",
    [string]$Version = $(Get-Date -Format "yyyyMMddHHmmss"),
    [string]$GodotExe = ""
)

function Resolve-GodotConsolePath {
    param([string]$PreferredPath)

    if (-not [string]::IsNullOrWhiteSpace($PreferredPath) -and (Test-Path $PreferredPath)) {
        return (Resolve-Path $PreferredPath).Path
    }

    $candidatePaths = @(
        "E:\openclaw\tmp\godot46\editor\Godot_v4.6-stable_win64_console.exe",
        "E:\openclaw\Godot_v4.6.1-stable_win64_console.exe"
    )

    foreach ($candidatePath in $candidatePaths) {
        if (Test-Path $candidatePath) {
            return (Resolve-Path $candidatePath).Path
        }
    }

    $commands = Get-Command Godot_v4.6.1-stable_win64_console.exe, Godot_v4.6-stable_win64_console.exe -ErrorAction SilentlyContinue
    if ($commands) {
        return $commands[0].Source
    }

    throw "未找到 Godot 控制台导出程序。请通过 -GodotExe 指定可执行文件路径。"
}

$projectPath = (Resolve-Path $ProjectDir).Path
$exportFullPath = if ([System.IO.Path]::IsPathRooted($ExportPath)) {
    $ExportPath
} else {
    Join-Path $projectPath $ExportPath
}
$exportDir = Split-Path -Parent $exportFullPath
$godotConsole = Resolve-GodotConsolePath -PreferredPath $GodotExe
$versionScript = Join-Path $PSScriptRoot "version_web_export.ps1"

if (-not (Test-Path $exportDir)) {
    New-Item -ItemType Directory -Path $exportDir -Force | Out-Null
}

& $godotConsole --headless --path $projectPath --export-release $Preset $exportFullPath
if ($LASTEXITCODE -ne 0) {
    throw "Godot Web 导出失败，退出码: $LASTEXITCODE"
}

& $versionScript -SourceDir $exportDir -Version $Version
if ($LASTEXITCODE -ne 0) {
    throw "Web 版本号写入失败，退出码: $LASTEXITCODE"
}

Write-Output "已完成导出并写入显式版本号: $Version"
Write-Output "导出目录: $exportDir"
