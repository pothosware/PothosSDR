param(
    [string]$InstallPrefix,
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

& $Python2Executable configure.py `
    --confirm-license --verbose `
    --no-designer-plugin `
    --enable QtOpenGL --enable QtGui --enable QtSvg `
    -b "$InstallPrefix/bin" -d $Python2ModulesDir `
    -p "$InstallPrefix/pyqt4-plugins" `
    -v "$InstallPrefix/sip"

# nmake missing $<
# The double space before moc_translator.cpp is left on purpose!
(gc pylupdate\Makefile) -replace 'o moc_translator\.cpp', 'o  moc_translator.cpp translator.h' | Out-File pylupdate\Makefile
