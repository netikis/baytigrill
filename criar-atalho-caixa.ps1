# Cria atalho "BAYTIGRILL Caixa" na Area de Trabalho com icone do restaurante
param(
    [string]$Pasta = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$Pasta = (Resolve-Path $Pasta).Path

$bat = Join-Path $Pasta 'INICIAR-CAIXA-IMPRESSAO-AUTOMATICA.bat'
if (-not (Test-Path $bat)) {
    Write-Host '[ERRO] Nao encontrou INICIAR-CAIXA-IMPRESSAO-AUTOMATICA.bat' -ForegroundColor Red
    exit 1
}

# Icone: favicon.ico ou gera a partir do logo
$ico = Join-Path $Pasta 'favicon.ico'
$logo = Join-Path $Pasta 'logo-baytigrill-sistema.png'

if (-not (Test-Path $ico) -and (Test-Path $logo)) {
    try {
        Add-Type -AssemblyName System.Drawing
        $img = [System.Drawing.Image]::FromFile($logo)
        try {
            $bmp = New-Object System.Drawing.Bitmap 256, 256
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            try {
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.Clear([System.Drawing.Color]::FromArgb(42, 51, 40))
                $scale = [Math]::Min(256 / $img.Width, 256 / $img.Height)
                $w = [int][Math]::Round($img.Width * $scale)
                $h = [int][Math]::Round($img.Height * $scale)
                $x = [int]((256 - $w) / 2)
                $y = [int]((256 - $h) / 2)
                $g.DrawImage($img, $x, $y, $w, $h)
                $hIcon = $bmp.GetHicon()
                $icon = [System.Drawing.Icon]::FromHandle($hIcon)
                try {
                    $fs = [System.IO.File]::Create($ico)
                    try { $icon.Save($fs) } finally { $fs.Close() }
                } finally { $icon.Dispose() }
            } finally { $g.Dispose(); $bmp.Dispose() }
        } finally { $img.Dispose() }
        Write-Host 'Icone favicon.ico criado a partir do logo.' -ForegroundColor Green
    } catch {
        Write-Host 'Aviso: nao foi possivel gerar favicon.ico' -ForegroundColor Yellow
    }
}

if (-not (Test-Path $ico)) {
    $icoAlt = Join-Path $Pasta 'icons\icon-256.png'
    if (Test-Path $icoAlt) { $ico = $icoAlt } else { $ico = $logo }
}

$desktop = [Environment]::GetFolderPath('Desktop')
$lnk = Join-Path $desktop 'BAYTIGRILL Caixa.lnk'

$shell = New-Object -ComObject WScript.Shell
$atalho = $shell.CreateShortcut($lnk)
$atalho.TargetPath = $bat
$atalho.WorkingDirectory = $Pasta
$atalho.IconLocation = "$ico,0"
$atalho.Description = 'BAYTIGRILL - Caixa com impressao automatica na KNUP'
$atalho.WindowStyle = 1
$atalho.Save()

Write-Host ''
Write-Host 'Atalho criado com sucesso!' -ForegroundColor Green
Write-Host "Nome: BAYTIGRILL Caixa" -ForegroundColor Cyan
Write-Host "Local: $lnk" -ForegroundColor Gray
Write-Host ''
Write-Host 'Use esse icone na Area de Trabalho para abrir o caixa todo dia.' -ForegroundColor White
