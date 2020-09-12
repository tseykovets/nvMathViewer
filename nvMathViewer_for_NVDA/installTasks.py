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

import sys

import addonHandler
import gui
import wx

addonHandler.initTranslation()


def onInstall():
	# Additional compatibility check for very old versions of NVDA in Python 2
	if sys.version_info.major < 3:
		raise RuntimeError("Incompatible NVDA version")
	# Translators: The message box shown at the end of the add-on installation
	gui.messageBox(_("To learn how to use nvMathViewer, after restarting, open the NVDA menu, enter the  Tools subMenu  , activate  the Manage add-ons item, select nvMathViewer from a list and press on the Add-on help button."), "nvMathViewer", style=wx.OK | wx.ICON_WARNING)
