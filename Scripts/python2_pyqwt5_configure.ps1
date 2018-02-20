param(
    [string]$InstallPrefix,
    [string]$QwtInstallPrefix,
    [string]$Qt4Root,
    [string]$Python2Executable
)

$env:PATH = "$Qt4Root/bin;$env:PATH"
$Python2ModulesDir = "$InstallPrefix/lib/python2.7/site-packages"

if (Test-Path env:PYTHONPATH) {
    $env:PYTHONPATH = "$env:PYTHONPATH;$Python2ModulesDir"
} else {
    $env:PYTHONPATH = $Python2ModulesDir
}

echo "$QwtInstallPrefix/lib"
# Output is redirected to avoid fake errors
& $Python2Executable configure.py `
    -I "$InstallPrefix/include" `
    -I "$QwtInstallPrefix/include" `
    -L "$QwtInstallPrefix/lib" -l qwt `
    --sip-include-dirs "$InstallPrefix/sip" `
    --module-install-path="$Python2ModulesDir/PyQt4/Qwt5" 2>&1 > configure_log
#    -L "$InstallPrefix/lib" -l qtcore4 `

(gc qwt5qt4\Makefile) -replace 'qwt5\.lib', '' | Out-File qwt5qt4\Makefile
