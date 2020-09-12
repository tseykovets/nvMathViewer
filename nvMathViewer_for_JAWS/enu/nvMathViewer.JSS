; nvMathViewer: viewing LaTeX and AsciiMath notations as MathML
/*
* Copyright (C) 2020 Nikita Tseykovets
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

;#pragma usePoFile 0

Include "HJConst.jsh"
Include "nvMathViewer.jsm"

Const
	HtmlTemplate = "<!DOCTYPE html>\n<html lang=\"%1\">\n<head>\n<meta charset=\"utf-8\">\n<title>%2</title>\n</head>\n<body>\n%3\n<h2>%4</h2>\n<textarea readonly>%5</textarea>\n</body>\n</html>",
	VirtualViewerTemplate = "%1\n%2\n\n%3\n\n%4"

Globals
	string sNodePath,
	string sTex2mmlPath,
	string sAm2mmlPath,
	object oShell,
	string sHtmlFile

void Function AutoStartEvent ()
	let sNodePath = GetJAWSSettingsDirectory () + "\\..\\nvMathViewer\\Node.js\\node.exe"
	let sTex2mmlPath = GetJAWSSettingsDirectory () + "\\..\\nvMathViewer\\tex2mml.js"
	let sAm2mmlPath = GetJAWSSettingsDirectory () + "\\..\\nvMathViewer\\am2mml.js"
	let oShell = CreateObject ("WScript.Shell")
	let sHtmlFile = FormatString ("%1\\%2", oShell.ExpandEnvironmentStrings ("%TEMP%"), "nvMathViewer.html")
EndFunction

Script ViewLaTeXAsInteractiveMathML ()
	ShowMathML ("LaTeX")
EndScript

Script ViewAsciiMathAsInteractiveMathML ()
	ShowMathML ("AsciiMath")
EndScript

Script ViewLaTeXAsSourceMathML ()
	ShowMathML ("LaTeX", true)
EndScript

Script ViewAsciiMathAsSourceMathML ()
	ShowMathML ("AsciiMath", true)
EndScript

void Function ShowMathML (string sFormat, optional int iSource)
	var
		string sText,
		string sConverterPath,
	object oExec,
	string sResult
	let sText = GetText ()
	If NOT sText Then
		SayFormattedMessage (OT_JAWS_MESSAGE, msg_No_selection_and_no_text_on_the_clipboard)
		Return
	EndIf
	If sFormat == "LaTeX" Then
		let sConverterPath = sTex2mmlPath
	ElIf sFormat == "AsciiMath" Then
		let sConverterPath = sAm2mmlPath
	Else
		SayFormattedMessage (OT_JAWS_MESSAGE, msg_Error)
		Return
	EndIf
	SayFormattedMessage (OT_JAWS_MESSAGE, FormatString (msg_Convert_format, sFormat))
	let oExec = oShell.Exec (FormatString ("\"%1\" \"%2\" \"%3\"", sNodePath,sConverterPath, sText))
	let sResult = (oExec.StdOut.ReadAll ())
	If NOT sResult Then
		SayFormattedMessage (OT_JAWS_MESSAGE, msg_Error)
		Return
	EndIf
	If iSource Then
		If UserBufferIsActive () Then
			UserBufferDeactivate ()
		EndIf
		SayFormattedMessage (OT_USER_BUFFER, FormatString (VirtualViewerTemplate, sResult, FormatString (msg_Original_format_notation, sFormat), sText, msg_Press_Escape_to_close_this_message))
	Else
		CreateFileInUtf8 (sHtmlFile, FormatString (HtmlTemplate, HtmlLang, FormatString (msg_View_format, sFormat), sResult, FormatString (msg_Original_format_notation, sFormat), sText), false)
		oShell.Run (FormatString ("\"%1\"", sHtmlFile))
	EndIf
EndFunction

string Function GetText ()
	var
		string sText
	let sText = GetSelectedText ()
	If sText Then
		Return sText
	EndIf
	let sText = GetClipboardText ()
	If sText Then
		Return sText
	EndIf
	Return false
EndFunction

void Function CreateFileInUtf8 (string sFile, string sText, int iBOM)
	var
		object oStream,
		object oBinaryStream
	let oStream = CreateObject ("ADODB.Stream")
	oStream.Type = 2
	oStream.CharSet = "utf-8"
	oStream.Open
	oStream.WriteText (sText)
	If iBOM Then
		oStream.SaveToFile (sFile, 2)
		oStream.Close
	Else
		let oBinaryStream = CreateObject ("ADODB.Stream")
		oBinaryStream.Type = 1
		oBinaryStream.Mode = 3
		oBinaryStream.Open
		oStream.Position = 3
		oStream.CopyTo (oBinaryStream)
		oStream.flush
		oStream.Close
		oBinaryStream.SaveToFile (sFile, 2)
		oBinaryStream.Close
	EndIf
	EndFunction
