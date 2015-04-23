Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = "C:\PothosSDR\PothosGui.lnk"
Set oLink = oWS.CreateShortcut(sLinkFile)
    oLink.TargetPath = "C:\PothosSDR\bin\PothosGui.exe"
 '  oLink.Arguments = ""
 '  oLink.Description = "Pothos GUI"
 '  oLink.HotKey = "ALT+CTRL+F"
 '  oLink.IconLocation = "C:\PothosSDR\bin\PothosGui.exe, 2"
 '  oLink.WindowStyle = "1"
 '  oLink.WorkingDirectory = "."
oLink.Save
