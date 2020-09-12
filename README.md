# nvMathViewer
Screen reader extension for non-visual viewing mathematical content in LaTeX and AsciiMath notations as MathML.

## About
nvMathViewer is a extension for screen readers that can be used to view mathematical content in LaTeX and AsciiMath notations as MathML.

These notations are widely used to write mathematical symbols and formulas in computer systems.
However, understanding LaTeX and AsciiMath requires special knowledge and skills that the average user may not have, such as a simple schoolboy or a humanitarian student.
In addition, reading these notations directly may not be convenient enough, because it does not provide additional opportunities for analyzing the structure of formulas.

nvMathViewer solves these problems and enables blind users to quickly view any LaTeX or AsciiMath notations using special functions of screen readers for non-visual reading mathematical content and structural navigation through it.

## Download
You can download the following ready builds of nvMathViewer:

* [Add-on for NVDA 2019.3 and newer](https://tseykovets.ru/download/nvda/nvMathViewer.nvda-addon)
* [Extension for JAWS 16.0 and newer](https://tseykovets.ru/download/jaws/nvMathViewer.zip)

## Building
To build the extension from source on Windows, you need:

First, prepare external binary components. To do this:

1. Clone a repository  of the extension with a command line in a separate directory, for example nvMathViewer:  
	>git clone https://github.com/tseykovets/nvMathViewer.git nvMathViewer
2. Download the standalone console version of 7-Zip archiver, namely  7-Zip Extra from <https://www.7-zip.org/download.html>
3. Download the portable version of Node.js runtime environment, namely Windows Binary (.zip) from <https://nodejs.org/en/download/>
4. Unpack the 7-Zip archive and copy the 7za.exe file to the source code directory so that it is located in the nvMathViewer\bin\7za.exe
5. Unpack the Node.js archive and copy all its contents to the source code directory so that the node.exe file is located in the nvMathViewer\bin\Node.js\node.exe
6. Go to the Node.js directory with a command line:  
	>CD nvMathViewer\bin\Node.js
7. Install mathjax-full package with a command line:  
	>npm install -g mathjax-full
8. After installation, you can remove large  unnecessary packages and components to save space, for example:  
	>RD /S /Q node_modules\npm node_modules\mathjax-full\components node_modules\mathjax-full\es5 node_modules\mathjax-full\node_modules node_modules\mathjax-full\ts

Second, build the version for a screen reader you are interested in. To do this:

* Run the build_for_nvda.bat file in the root of the source code directory to build the add-on for NVDA.
* Run the build_for_jaws.bat file in the root of the source code directory to build the extension for JAWS.

The ready file will appear in the same root directory of the source code.
