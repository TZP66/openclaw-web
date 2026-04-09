param(
    [string]$SourceDir = ".\build\web",
    [string]$OutputZip = ".\build\openclaw-web-upload.zip",
    [string]$Version = $(Get-Date -Format "yyyyMMddHHmmss")
)

$sourcePath = (Resolve-Path $SourceDir).Path
if (-not (Test-Path (Join-Path $sourcePath "index.html"))) {
    throw "未找到 index.html。请先把 Godot 导出的 Web 文件放到 $SourceDir 目录。"
}

$versionScript = Join-Path $PSScriptRoot "version_web_export.ps1"
& $versionScript -SourceDir $sourcePath -Version $Version

if (Test-Path $OutputZip) {
    Remove-Item $OutputZip -Force
}

Compress-Archive -Path (Join-Path $sourcePath "*") -DestinationPath $OutputZip -Force
Write-Output "已生成: $OutputZip"
