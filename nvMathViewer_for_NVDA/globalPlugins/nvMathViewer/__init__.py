# -*- coding: UTF-8 -*-
# Copyright (C) 2020 Nikita Tseykovets
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

import html
import os
import subprocess
import threading

import addonHandler
import globalPluginHandler
import globalVars
import api
from scriptHandler import script
import textInfos
import treeInterceptorHandler
import ui

pluginPath = os.path.join(os.path.dirname(os.path.abspath(__file__)))
nodePath = os.path.join(pluginPath, 'Node.js', 'node.exe')
am2mmlPath = os.path.join(pluginPath, 'am2mml.js')
tex2mmlPath = os.path.join(pluginPath, 'tex2mml.js')

addonHandler.initTranslation()

# Translators: This is the second part of several labels for nvMathViewer's commands in the Input Gestures dialog.
additionalCommandDescription = _("If there is no selection the text will be taken from the clipboard.")


class GlobalPlugin(globalPluginHandler.GlobalPlugin):

	# Translators: The label for the category of nvMathViewer in the Input Gestures dialog.
	scriptCategory = _("Viewing mathematical content")

	@script(
		description='{0} {1}'.format(
			# Translators: The command to view LaTeX as interactive MathML. This is a label for the corresponding command in the Input Gestures dialog.
			_("View the selected LaTeX notation as interactive MathML in the browse mode."),
			additionalCommandDescription
		)
	)
	def script_viewLaTeXAsInteractiveMathML(self, gesture):
		if isSecureMode(): return
		processText('LaTeX')

	@script(
		description='{0} {1}'.format(
			# Translators: The command to view AsciiMath as interactive MathML. This is a label for the corresponding command in the Input Gestures dialog.
			_("View the selected AsciiMath notation as interactive MathML in the browse mode."),
			additionalCommandDescription
		)
	)
	def script_viewAsciiMathAsInteractiveMathML(self, gesture):
		if isSecureMode(): return
		processText('AsciiMath')

	@script(
		description='{0} {1}'.format(
			# Translators: The command to view LaTeX as MathML source. This is a label for the corresponding command in the Input Gestures dialog.
			_("View the selected LaTeX notation as the MathML source in the browse mode."),
			additionalCommandDescription
		)
	)
	def script_viewLaTeXAsSourceMathML(self, gesture):
		if isSecureMode(): return
		processText('LaTeX', source=True)

	@script(
		description='{0} {1}'.format(
			# Translators: The command to view AsciiMath as MathML source. This is a label for the corresponding command in the Input Gestures dialog.
			_("View the selected AsciiMath notation as the MathML source in the browse mode."),
			additionalCommandDescription
		)
	)
	def script_viewAsciiMathAsSourceMathML(self, gesture):
		if isSecureMode(): return
		processText('AsciiMath', source=True)


def isSecureMode():
	"""Return True or False depending on whether NVDA is running in secure mode."""
	if globalVars.appArgs.secure:
		# Translators: The message shown when a command is called during NVDA is running in secure mode.
		ui.message(_("Action cannot be performed because NVDA is running in secure mode."))
		return True
	else:
		return False


def processText(format, source=False):
	"""Take selected text or text from the clipboard and process it in a separate thread."""
	text = getText()
	thread = threading.Thread(target=showMathML, kwargs={
		'text': text,
		'format': format,
		'source': source
	})
	thread.start()


def showMathML(text, format, source):
	"""Show the result of converting text to MathML."""
	if not text:
		# Translators: The message shown when both the selected text and the text in the clipboard are missing at the time of command execution.
		ui.message(_("No selection and no text on the clipboard."))
		return
	if format == 'LaTeX':
		converterPath = tex2mmlPath
	elif format == 'AsciiMath':
		converterPath = am2mmlPath
	else:
		# Translators: The message shown when an internal error occurs during add-on working.
		ui.message(_("Error!"))
		raise ValueError("Unknown input format.")
	# Translators: The message shown when a math notation conversion starts. The "{format}" is replaced by the name of input format. There is no need to translate the text inside the curly brackets.
	ui.message(_("Convert {format}").format(format=format))
	startupinfo = subprocess.STARTUPINFO()
	startupinfo.dwFlags |= (
		subprocess.STARTF_USESTDHANDLES | subprocess.STARTF_USESHOWWINDOW
	)
	startupinfo.wShowWindow = subprocess.SW_HIDE
	result = subprocess.run(
		[nodePath, converterPath, text],
		stdout=subprocess.PIPE,
		stderr=subprocess.PIPE,
		startupinfo=startupinfo,
		stdin=subprocess.DEVNULL,
		encoding='utf-8'
	)
	if not result.stdout:
		ui.message(_("Error!"))
		raise RuntimeError("Node.js script execution error:\n{0}".format(result.stderr))
	if source:
		mml = '<pre>{0}<pre>'.format(html.escape(result.stdout))
	else:
		mml = result.stdout
	message = '{0}<br><h2>{1}</h2><br><pre>{2}</pre><br><hr>{3}'.format(
		mml,
		# Translators: The heading before the original math notation in the window of viewing conversion results. The "{format}" is replaced by the name of input format. There is no need to translate the text inside the curly brackets.
		_("Original {format} notation").format(format=format),
		html.escape(text),
		# Translators: The text at the bottom of the window of viewing conversion results.
		_("Press Escape to close this message")
	)
	# Translators: The title of the window of viewing conversion results. The "{format}" is replaced by the name of input format. There is no need to translate the text inside the curly brackets.
	title = _("View {format}").format(format=format)
	ui.browseableMessage(message, title, True)


def getText():
	"""Return the selected text or text from the clipboard, if not then return False."""
	text = getSelectedText()
	if text: return text
	text = getClipboardText()
	if text: return text
	return False


def getSelectedText():
	"""Return the selected text, if not then return False."""
	# The code for this function is partially taken from the NVDA source code licensed under the GNU GPL.
	# See script_reportCurrentSelection method in globalCommands.py file.
	obj = api.getFocusObject()
	treeInterceptor = obj.treeInterceptor
	if isinstance(treeInterceptor, treeInterceptorHandler.DocumentTreeInterceptor) and not treeInterceptor.passThrough:
		obj = treeInterceptor
	try:
		info = obj.makeTextInfo(textInfos.POSITION_SELECTION)
	except (RuntimeError, NotImplementedError):
		info = None
	if not info or info.isCollapsed:
		return False
	else:
		return info.text


def getClipboardText():
	"""Return text from the clipboard, if not then return False."""
	# The code for this function is partially taken from the NVDA source code licensed under the GNU GPL.
	# See script_reportClipboardText method in globalCommands.py file.
	try:
		text = api.getClipData()
	except:
		text = None
	if not text or not isinstance(text, str) or text.isspace():
		return False
	else:
		return text
