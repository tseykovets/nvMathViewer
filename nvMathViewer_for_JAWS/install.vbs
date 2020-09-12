' The MIT License (MIT)
'
' Copyright (C) 2020 Nikita Tseykovets
'
' Permission is hereby granted, free of charge, to any person
' obtaining a copy of this software and associated documentation files
' (the "Software"), to deal in the Software without restriction,
' including without limitation the rights to use, copy, modify, merge,
' publish, distribute, sublicense, and/or sell copies of the Software,
' and to permit persons to whom the Software is furnished to do so,
' subject to the following conditions:
'
' The above copyright notice and this permission notice shall be
' included in all copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
' MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
' IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
' FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
' OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
' WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Option Explicit

Dim oShell, oFSO, sExecutable, sSharedSettings, oArgs, sVersion, sScompile, sLang, bNewLocale, sTmp, sLangVersion, sSource, sScriptsSource, sNodeSource, sTarget, aFolders, iFolder, sScriptsTarget, sMyExtensions, sMyExtensionsTmp, aExtensions(), sExtension, sName

Set oShell = CreateObject ("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")

sExecutable = oShell.ExpandEnvironmentStrings("%PROGRAMFILES%") & "\Freedom Scientific\JAWS"
Call ExecutableExists()
sSharedSettings = oShell.ExpandEnvironmentStrings("%ALLUSERSPROFILE%") & "\Freedom Scientific\JAWS"
Call SharedSettingsExists()

Set oArgs = Wscript.Arguments

If oArgs.Count >= 1 Then
	sVersion = oArgs(0)
Else
	sVersion = InputBox("Enter the version of JAWS: ")
	If IsEmpty(sVersion) Then WScript.Quit
End If
sExecutable = sExecutable & "\" & sVersion
Call ExecutableExists()
sScompile = sExecutable & "\scompile.exe"
Call ScompileExists()
sSharedSettings = sSharedSettings & "\" & sVersion
Call SharedSettingsExists()

If oArgs.Count >= 2 Then
	sLang = oArgs(1)
Else
	sLang = InputBox("Enter the language of JAWS: ")
	If IsEmpty(sLang) Then WScript.Quit
End If
sTmp = sSharedSettings & "\Scripts"
sSharedSettings = sSharedSettings & "\SETTINGS\" & sLang
Call SharedSettingsExists()

bNewLocale = oFSO.FolderExists(sTmp)
If bNewLocale Then sSharedSettings = sTmp

If oArgs.Count >= 3 Then
	sLangVersion = oArgs(2)
Else
	If oArgs.Count = 2 Then
		sLangVersion = oArgs(1)
	Else
		sLangVersion = InputBox("Enter the language version of nvMathViewer: ")
		If IsEmpty(sLangVersion) Then WScript.Quit
	End If
End If
sSource = oFSO.GetParentFolderName(oFSO.GetFile(Wscript.ScriptFullName))
sScriptsSource = sSource & "\" & sLangVersion
Call ComponentExists(sScriptsSource)
sNodeSource = sSource & "\nvMathViewer"
Call ComponentExists(sNodeSource)

sTarget = oShell.ExpandEnvironmentStrings("%APPDATA%") & "\Freedom Scientific\JAWS\" & sVersion & "\Settings"
If Not oFSO.FolderExists(sTarget) Then Call CreateFolder(sTarget)
sScriptsTarget = sTarget & "\" & sLang
oFSO.CopyFolder sScriptsSource, sScriptsTarget, True

sMyExtensions = sScriptsTarget & "\myExtensions.jss"
If Not oFSO.FileExists(sMyExtensions) Then
	sMyExtensions = sSharedSettings & "\myExtensions.jss"
	If Not oFSO.FileExists(sMyExtensions) Then
		WScript.Echo "Error: The myExtensions.jss file not found on the path " & sMyExtensions
		Call DeleteScripts()
		WScript.Quit
	End If
End If

If Not CompileScripts(sScriptsTarget & "\nvMathViewer.jss") Then
	WScript.Echo "Error compiling nvMathViewer.jss"
	Call DeleteScripts()
	WScript.Quit
End If

sTmp = Mid(CreateObject("Scriptlet.TypeLib").GUID, 2, 36)
sMyExtensionsTmp = sScriptsTarget & "\" & sTmp & ".jss"
oFSO.CopyFile sMyExtensions, sMyExtensionsTmp, True
With oFSO.OpenTextFile(sMyExtensionsTmp, 8)
	.Write(vbCrLf & "use ""nvMathViewer.jsb""")
	.Close
End With
If Not CompileScripts(sMyExtensionsTmp) Then
	WScript.Echo "Error compiling myExtensions.jss"
	Call DeleteScripts()
	Call DeleteMyExtensionsTmp()
	WScript.Quit
End If

ReDim aExtensions(1)
aExtensions(0) = "jss"
aExtensions(1) = "jsb"
For Each sExtension In aExtensions
	sName = "myExtensions." & sExtension
	If oFSO.FileExists(sScriptsTarget & "\" & sName) Then
		oFSO.DeleteFile sScriptsTarget & "\" & sName, True
	End If
	oFSO.GetFile(sScriptsTarget & "\" & sTmp & "." & sExtension).Name = sName
Next

oFSO.CopyFolder sNodeSource, sTarget & "\nvMathViewer", True

CreateObject("FreedomSci.JawsApi").RunScript("RefreshScripts")
WScript.Echo "nvMathViewer is installed"

Sub ExecutableExists()
	If Not oFSO.FolderExists(sExecutable) Then
		WScript.Echo "Error: The JAWS system directory not found on the path " & sExecutable
		WScript.Quit
	End If
End Sub

Sub SharedSettingsExists()
	If Not oFSO.FolderExists(sSharedSettings) Then
		WScript.Echo "Error: The JAWS shared settings directory not found on the path " & sSharedSettings
		WScript.Quit
	End If
End Sub

Sub ScompileExists()
	If Not oFSO.FileExists(sScompile) Then
		WScript.Echo "Error: The script compiler not found on the path " & sScompile
		WScript.Quit
	End If
End Sub

Sub ComponentExists(sComponent)
	If Not oFSO.FolderExists(sComponent) Then
		WScript.Echo "Error: The required component not found on the path " & sComponent
		WScript.Quit
	End If
End Sub

Sub CreateFolder(sPath)
	aFolders = Split(sPath, "\")
	sPath = aFolders(0)
	For iFolder = 1 To UBound(aFolders)
		sPath = sPath & "\" & aFolders(iFolder)
		If Not oFSO.FolderExists(sPath) Then oFSO.CreateFolder(sPath)
	Next
End Sub

Function CompileScripts(sFile)
	If oShell.Run("""" & sScompile & """ """ & sFile & """", 0, True) = 0 Then
		CompileScripts = True
	Else
		CompileScripts = False
	End If
End Function

Sub DeleteScripts()
	oFSO.DeleteFile sScriptsTarget & "\nvMathViewer.js?", True
End Sub

Sub DeleteMyExtensionsTmp()
	oFSO.DeleteFile sScriptsTarget & "\" & sTmp & ".js?", True
End Sub
