param(
    [string]$SourceDir = ".\build\web",
    [string]$Version = $(Get-Date -Format "yyyyMMddHHmmss")
)

$sourcePath = (Resolve-Path $SourceDir).Path
$htmlFile = Get-ChildItem -Path $sourcePath -File -Filter *.html |
    Where-Object { $_.Name -notlike "*.offline.html" } |
    Select-Object -First 1

if (-not $htmlFile) {
    throw "未找到主 HTML 文件。请确认 $sourcePath 下存在 Godot Web 导出产生的 index.html。"
}

$baseName = [System.IO.Path]::GetFileNameWithoutExtension($htmlFile.Name)
$jsName = "$baseName.js"
$wasmName = "$baseName.wasm"
$pckName = "$baseName.pck"
$offlineName = "$baseName.offline.html"
$iconName = "$baseName.icon.png"
$appleTouchIconName = "$baseName.apple-touch-icon.png"
$audioWorkletName = "$baseName.audio.worklet.js"
$audioPositionWorkletName = "$baseName.audio.position.worklet.js"
$serviceWorkerName = "$baseName.service.worker.js"
$sideWasmName = "$baseName.side.wasm"

foreach ($requiredFile in @($jsName, $wasmName, $pckName)) {
    if (-not (Test-Path (Join-Path $sourcePath $requiredFile))) {
        throw "缺少必需文件 $requiredFile。请先完成 Godot Web 导出，再执行此脚本。"
    }
}

function Get-VersionedAssetName {
    param([string]$Name)

    return "{0}?v={1}" -f $Name, $Version
}

function Set-ObjectProperty {
    param(
        [Parameter(Mandatory = $true)]$Object,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)]$Value
    )

    if ($Object -is [hashtable]) {
        $Object[$Name] = $Value
        return
    }

    $existing = $Object.PSObject.Properties[$Name]
    if ($existing) {
        $existing.Value = $Value
    } else {
        $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value
    }
}

function Remove-OldVersionedFiles {
    param(
        [string]$Directory,
        [string]$BaseNameValue
    )

    $escapedBase = [regex]::Escape($BaseNameValue)
    $patterns = @(
        "^$escapedBase\.[A-Za-z0-9_-]+\.js$",
        "^$escapedBase\.[A-Za-z0-9_-]+\.wasm$",
        "^$escapedBase\.[A-Za-z0-9_-]+\.pck$",
        "^$escapedBase\.[A-Za-z0-9_-]+\.audio\.worklet\.js$",
        "^$escapedBase\.[A-Za-z0-9_-]+\.audio\.position\.worklet\.js$",
        "^$escapedBase\.[A-Za-z0-9_-]+\.service\.worker\.js$",
        "^$escapedBase\.[A-Za-z0-9_-]+\.side\.wasm$"
    )

    Get-ChildItem -Path $Directory -File | Where-Object {
        $name = $_.Name
        foreach ($pattern in $patterns) {
            if ($name -match $pattern) {
                return $true
            }
        }
        return $false
    } | Remove-Item -Force
}

function Set-VersionedLocateFilePath {
    param(
        [string]$Content,
        [string]$OriginalSuffix
    )

    $escapedSuffix = [regex]::Escape($OriginalSuffix)
    $pattern = 'return `\$\{loadPath\}' + $escapedSuffix + '(?:\?v=[^`]+)?`;'
    $replacement = 'return `${loadPath}' + $OriginalSuffix + '?v=' + $Version + '`;'
    return [regex]::Replace($Content, $pattern, $replacement)
}

Remove-OldVersionedFiles -Directory $sourcePath -BaseNameValue $baseName

$versionedJsName = Get-VersionedAssetName $jsName
$versionedWasmName = Get-VersionedAssetName $wasmName
$versionedPckName = Get-VersionedAssetName $pckName
$versionedAudioWorkletName = Get-VersionedAssetName $audioWorkletName
$versionedAudioPositionWorkletName = Get-VersionedAssetName $audioPositionWorkletName
$versionedServiceWorkerName = Get-VersionedAssetName $serviceWorkerName
$versionedSideWasmName = Get-VersionedAssetName $sideWasmName

$htmlPath = $htmlFile.FullName
$htmlContent = Get-Content -LiteralPath $htmlPath -Raw

$htmlContent = [regex]::Replace(
    $htmlContent,
    '<script src="' + [regex]::Escape($jsName) + '(?:\?v=[^"]+)?"></script>',
    '<script src="' + $versionedJsName + '"></script>'
)

$configMatch = [regex]::Match(
    $htmlContent,
    'const GODOT_CONFIG = (\{.*?\});',
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)

if (-not $configMatch.Success) {
    throw "未在 $($htmlFile.Name) 中找到 GODOT_CONFIG。"
}

$configJson = $configMatch.Groups[1].Value
$config = $configJson | ConvertFrom-Json

if (-not $config.fileSizes) {
    $config | Add-Member -NotePropertyName fileSizes -NotePropertyValue ([pscustomobject]@{})
}

foreach ($propertyName in @($config.fileSizes.PSObject.Properties.Name)) {
    if ($propertyName -match '\?v=') {
        $config.fileSizes.PSObject.Properties.Remove($propertyName)
    }
}

$wasmSize = (Get-Item -LiteralPath (Join-Path $sourcePath $wasmName)).Length
$pckSize = (Get-Item -LiteralPath (Join-Path $sourcePath $pckName)).Length

Set-ObjectProperty -Object $config.fileSizes -Name $wasmName -Value $wasmSize
Set-ObjectProperty -Object $config.fileSizes -Name $pckName -Value $pckSize
Set-ObjectProperty -Object $config.fileSizes -Name $versionedWasmName -Value $wasmSize
Set-ObjectProperty -Object $config.fileSizes -Name $versionedPckName -Value $pckSize

Set-ObjectProperty -Object $config -Name "mainPack" -Value $versionedPckName
Set-ObjectProperty -Object $config -Name "serviceWorker" -Value $versionedServiceWorkerName

$updatedConfigJson = $config | ConvertTo-Json -Compress -Depth 20
$htmlContent = $htmlContent.Remove($configMatch.Groups[1].Index, $configMatch.Groups[1].Length)
$htmlContent = $htmlContent.Insert($configMatch.Groups[1].Index, $updatedConfigJson)
Set-Content -LiteralPath $htmlPath -Value $htmlContent -Encoding UTF8

$indexJsPath = Join-Path $sourcePath $jsName
$indexJsContent = Get-Content -LiteralPath $indexJsPath -Raw
$indexJsContent = [regex]::Replace(
    $indexJsContent,
    'loadPromise = preloader\.loadPromise\(`\$\{loadPath\}\.wasm(?:\?v=[^`]+)?`, size, true\);',
    'loadPromise = preloader.loadPromise(`${loadPath}.wasm?v=' + $Version + '`, size, true);'
)
$indexJsContent = Set-VersionedLocateFilePath -Content $indexJsContent -OriginalSuffix ".audio.worklet.js"
$indexJsContent = Set-VersionedLocateFilePath -Content $indexJsContent -OriginalSuffix ".audio.position.worklet.js"
$indexJsContent = Set-VersionedLocateFilePath -Content $indexJsContent -OriginalSuffix ".js"
$indexJsContent = Set-VersionedLocateFilePath -Content $indexJsContent -OriginalSuffix ".side.wasm"
$indexJsContent = Set-VersionedLocateFilePath -Content $indexJsContent -OriginalSuffix ".wasm"
Set-Content -LiteralPath $indexJsPath -Value $indexJsContent -Encoding UTF8

$serviceWorkerPath = Join-Path $sourcePath $serviceWorkerName
if (Test-Path $serviceWorkerPath) {
    $cachedFiles = @(
        ('"{0}"' -f $htmlFile.Name),
        ('"{0}"' -f $versionedJsName),
        ('"{0}"' -f $offlineName),
        ('"{0}"' -f $iconName),
        ('"{0}"' -f $appleTouchIconName),
        ('"{0}"' -f $versionedAudioWorkletName),
        ('"{0}"' -f $versionedAudioPositionWorkletName)
    ) -join ","

    $cacheableFiles = @(
        ('"{0}"' -f $versionedWasmName),
        ('"{0}"' -f $versionedPckName)
    ) -join ","

    $serviceWorkerContent = Get-Content -LiteralPath $serviceWorkerPath -Raw
    $serviceWorkerContent = [regex]::Replace(
        $serviceWorkerContent,
        "const CACHE_VERSION = '[^']*';",
        "const CACHE_VERSION = '$Version';"
    )
    $serviceWorkerContent = [regex]::Replace(
        $serviceWorkerContent,
        'const CACHED_FILES = \[[^\]]*\];',
        "const CACHED_FILES = [$cachedFiles];"
    )
    $serviceWorkerContent = [regex]::Replace(
        $serviceWorkerContent,
        'const CACHEABLE_FILES = \[[^\]]*\];',
        "const CACHEABLE_FILES = [$cacheableFiles];"
    )
    Set-Content -LiteralPath $serviceWorkerPath -Value $serviceWorkerContent -Encoding UTF8
}

Write-Output "已写入显式版本号: $Version"
Write-Output "HTML 入口: $($htmlFile.Name)"
Write-Output ("{0} -> {1}" -f $jsName, $versionedJsName)
Write-Output ("{0} -> {1}" -f $wasmName, $versionedWasmName)
Write-Output ("{0} -> {1}" -f $pckName, $versionedPckName)
if (Test-Path $serviceWorkerPath) {
    Write-Output ("{0} -> {1}" -f $serviceWorkerName, $versionedServiceWorkerName)
}
