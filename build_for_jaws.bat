@echo off
goto :start
The MIT License (MIT)

Copyright (C) 2020 Nikita Tseykovets

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
:start

set name=nvMathViewer
set extension="%cd%\%name%.zip"
set za="%cd%\bin\7za.exe"
set nodeSource="%cd%\bin\Node.js"
set target=%cd%\nvMathViewer_for_JAWS\nvMathViewer
set nodeTarget="%target%\Node.js"
set common=%cd%\common
set am2mmlSource="%common%\am2mml.js"
set am2mmlTarget="%target%\am2mml.js"
set tex2mmlSource="%common%\tex2mml.js"
set tex2mmlTarget="%target%\tex2mml.js"

:: Checking the build environment
if not exist %za% (
	echo Error: 7-Zip not found.
	goto :end
)
if not exist %nodeSource% (
	echo Error: Node.js not found.
	goto :end
)

:: Creating symbolic links for common components
if not exist "%target%" MD "%target%"
if exist %nodeTarget% RD /S /Q %nodeTarget%
if exist %nodeTarget% (
	echo Error: Failed to update Node.js directory from previous build.
	goto :end
)
MKLINK /D %nodeTarget% %nodeSource%
if not exist %nodeTarget% (
	echo Error: Failed to create a symbolic link for Node.js directory.
	goto :end
)
if exist %am2mmlTarget% DEL /Q %am2mmlTarget%
if exist %am2mmlTarget% (
	echo Error: Failed to update am2mml.js file from previous build.
	goto :end
)
MKLINK %am2mmlTarget% %am2mmlSource%
if not exist %am2mmlTarget% (
	echo Error: Failed to create a symbolic link for am2mml.js file.
	goto :end
)
if exist %tex2mmlTarget% DEL /Q %tex2mmlTarget%
if exist %tex2mmlTarget% (
	echo Error: Failed to update tex2mml.js file from previous build.
	goto :end
)
MKLINK %tex2mmlTarget% %tex2mmlSource%
if not exist %tex2mmlTarget% (
	echo Error: Failed to create a symbolic link for tex2mml.js file.
	goto :end
)

:: Building
if exist %extension% DEL /Q %extension%
if exist %extension% (
	echo Error: Failed to delete file of previous build.
	goto :end
)
echo Extension build:
%za% a -tzip -ssw %extension% .\nvMathViewer_for_JAWS\
if exist %extension% (
	echo The extension is saved as %extension%
) else (
	echo Error: Failed to create archive of the extension.
)

:: Deleting build artifacts
RD /S /Q "%target%"
if exist "%target%" (
echo Error: Failed to delete build artifacts at path "%target%"
)

:end
pause
