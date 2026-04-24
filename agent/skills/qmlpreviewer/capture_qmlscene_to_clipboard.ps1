param(
    [Parameter(Mandatory = $true)]
    [string]$QmlScenePath,

    [Parameter(Mandatory = $true)]
    [string]$QmlFilePath,

    [int]$StartupDelayMs = 4000,
    [int]$WindowPollTimeoutMs = 10000,
    [int]$WindowPollIntervalMs = 200,
    [switch]$KeepOpen,
    [switch]$__StaReady
)

$ErrorActionPreference = 'Stop'

if ([System.Threading.Thread]::CurrentThread.GetApartmentState() -ne [System.Threading.ApartmentState]::STA -and -not $__StaReady) {
    $quotedArgs = @(
        '-NoProfile'
        '-ExecutionPolicy'
        'Bypass'
        '-Sta'
        '-File'
        ('"{0}"' -f $PSCommandPath)
        '-QmlScenePath'
        ('"{0}"' -f $QmlScenePath)
        '-QmlFilePath'
        ('"{0}"' -f $QmlFilePath)
        '-StartupDelayMs'
        $StartupDelayMs
        '-WindowPollTimeoutMs'
        $WindowPollTimeoutMs
        '-WindowPollIntervalMs'
        $WindowPollIntervalMs
        '-__StaReady'
    )

    if ($KeepOpen) {
        $quotedArgs += '-KeepOpen'
    }

    $argumentString = ($quotedArgs | ForEach-Object { $_.ToString() }) -join ' '
    $child = Start-Process -FilePath 'powershell.exe' -ArgumentList $argumentString -PassThru -Wait
    exit $child.ExitCode
}

if (-not (Test-Path -LiteralPath $QmlScenePath -PathType Leaf)) {
    throw "qmlscene.exe 不存在: $QmlScenePath"
}

if (-not (Test-Path -LiteralPath $QmlFilePath -PathType Leaf)) {
    throw "QML 文件不存在: $QmlFilePath"
}

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

if (-not ('Win32QmlSceneWindow' -as [type])) {
Add-Type @'
using System;
using System.Runtime.InteropServices;

public static class Win32QmlSceneWindow {
    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool ClientToScreen(IntPtr hWnd, ref POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
'@
}

function Set-ClipboardImageWithRetry {
    param(
        [Parameter(Mandatory = $true)]
        [System.Drawing.Bitmap]$Image,

        [int]$RetryCount = 5,
        [int]$RetryDelayMs = 120
    )

    $attempt = 0
    while ($true) {
        try {
            [System.Windows.Forms.Clipboard]::SetImage($Image)
            return
        }
        catch {
            $attempt++
            if ($attempt -ge $RetryCount) {
                throw
            }

            Start-Sleep -Milliseconds $RetryDelayMs
        }
    }
}

$process = $null
$captureSucceeded = $false

try {
    $qmlImportPath = Join-Path (Split-Path -Parent $QmlScenePath) '..\qml'
    $process = Start-Process -FilePath $QmlScenePath -ArgumentList @('--maximized', '-I', $qmlImportPath, $QmlFilePath) -PassThru

    Start-Sleep -Milliseconds $StartupDelayMs

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $windowHandle = [IntPtr]::Zero

    while ($stopwatch.ElapsedMilliseconds -lt $WindowPollTimeoutMs) {
        if ($process.HasExited) {
            throw "qmlscene 已退出，退出码: $($process.ExitCode)"
        }

        $process.Refresh()
        if ($process.MainWindowHandle -ne 0 -and [Win32QmlSceneWindow]::IsWindowVisible($process.MainWindowHandle)) {
            $windowHandle = [IntPtr]$process.MainWindowHandle
            break
        }

        Start-Sleep -Milliseconds $WindowPollIntervalMs
    }

    if ($windowHandle -eq [IntPtr]::Zero) {
        throw '未找到 qmlscene 可见窗口'
    }

    [void][Win32QmlSceneWindow]::ShowWindow($windowHandle, 3)
    [void][Win32QmlSceneWindow]::SetForegroundWindow($windowHandle)
    Start-Sleep -Milliseconds 300

    $rect = New-Object Win32QmlSceneWindow+RECT
    if (-not [Win32QmlSceneWindow]::GetWindowRect($windowHandle, [ref]$rect)) {
        throw '读取 qmlscene 窗口区域失败'
    }

    $captureLeft = $rect.Left
    $captureTop = $rect.Top
    $captureRight = $rect.Right
    $captureBottom = $rect.Bottom

    $clientRect = New-Object Win32QmlSceneWindow+RECT
    if ([Win32QmlSceneWindow]::GetClientRect($windowHandle, [ref]$clientRect)) {
        $clientTopLeft = New-Object Win32QmlSceneWindow+POINT
        $clientBottomRight = New-Object Win32QmlSceneWindow+POINT
        $clientBottomRight.X = $clientRect.Right
        $clientBottomRight.Y = $clientRect.Bottom

        $clientTopLeftOk = [Win32QmlSceneWindow]::ClientToScreen($windowHandle, [ref]$clientTopLeft)
        $clientBottomRightOk = [Win32QmlSceneWindow]::ClientToScreen($windowHandle, [ref]$clientBottomRight)

        if ($clientTopLeftOk -and $clientBottomRightOk -and $clientBottomRight.X -gt $clientTopLeft.X -and $clientBottomRight.Y -gt $clientTopLeft.Y) {
            $captureLeft = $clientTopLeft.X
            $captureTop = $clientTopLeft.Y
            $captureRight = $clientBottomRight.X
            $captureBottom = $clientBottomRight.Y
        }
    }

    $width = $captureRight - $captureLeft
    $height = $captureBottom - $captureTop

    if ($width -le 0 -or $height -le 0) {
        throw "无效窗口尺寸: ${width}x${height}"
    }

    $bitmap = New-Object System.Drawing.Bitmap $width, $height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

    try {
        $graphics.CopyFromScreen(
            (New-Object System.Drawing.Point $captureLeft, $captureTop),
            [System.Drawing.Point]::Empty,
            (New-Object System.Drawing.Size $width, $height)
        )

        Set-ClipboardImageWithRetry -Image $bitmap
    }
    finally {
        $graphics.Dispose()
        $bitmap.Dispose()
    }

    Write-Output ("ClipboardImage={0}x{1}" -f $width, $height)
    $captureSucceeded = $true
}
finally {
    if ($process -and -not $KeepOpen -and -not $process.HasExited) {
        Stop-Process -Id $process.Id -Force
    }
}

if ($captureSucceeded) {
    exit 0
}
