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
```>git clone https://github.com/tseykovets/nvMathViewer.git nvMathViewer```
2. Download the standalone console version of 7-Zip archiver, namely  7-Zip Extra from <https://www.7-zip.org/download.html>
3. Download the portable version of Node.js runtime environment, namely Windows Binary (.zip) from <https://nodejs.org/en/download/>
4. Unpack the 7-Zip archive and copy the 7za.exe file to the source code directory so that it is located in the nvMathViewer\bin\7za.exe
5. Unpack the Node.js archive and copy all its contents to the source code directory so that the node.exe file is located in the nvMathViewer\bin\Node.js\node.exe
6. Go to the Node.js directory with a command line:  
```>CD nvMathViewer\bin\Node.js```
7. Install mathjax-full package with a command line:  
```>npm install -g mathjax-full```  
Note: The latest version of MathJax tested for compatibility with nvMathViewer is 3.1.2. You can download this particular version:  
```>npm install -g mathjax-full@3.1.2```
8. After installation, you can remove large  unnecessary packages and components to save space, for example:  
```>RD /S /Q node_modules\npm node_modules\mathjax-full\components node_modules\mathjax-full\es5 node_modules\mathjax-full\node_modules node_modules\mathjax-full\ts```

Second, build the version for a screen reader you are interested in. To do this:

* Run the build_for_nvda.bat file in the root of the source code directory to build the add-on for NVDA.
* Run the build_for_jaws.bat file in the root of the source code directory to build the extension for JAWS.

The ready file will appear in the same root directory of the source code.

## Localizing
To localize the extension in new languages, you need:

### Add-on for NVDA
Once before any actions with translations you need to download and install Poedit translation editor from <https://poedit.net/download>. After installation, start the editor and open the menu "File", activate the "Preferences" item and on the "General" tab write your name and E-mail. You can set the rest of preferences as you wish.

You can make a new translation or update an existing one.

Here is an outline of what you should do to make a translation, for example, from English to Russian:

1. Determine the code of the target language according to the ISO 639. For example, code of Russian is "ru". See <https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes>
2. Create the subdirectory "\locale\ru\LC_MESSAGES in" the add-on directory where "ru" can be any other language code.
3. Start Poedit and open the menu "File", activate the "New" item (or just press CTRL+N).
4. Select "Russian" in the dialogue and press "OK".
5. Press "Extract from sources" button in the next dialogue.
6. On "Translation properties" tab in the next dialogue write project name (e. g. "Russian translation of nvMathViewer for NVDA"), language team (e. g. "Ivan Petrov <ivan@example.com>"), charset and source code charset as "UTF-8" and press "Advanced extraction settings" button.
7. In the "Extract notes for translators from" edit write "Translators:" and press "OK".
8. In the "Catalogue properties" dialogue press "OK" and then open the menu "File", activate the "Save" item (or just press CTRL+S) and save the new file as nvda.po in the path "\locale\ru\LC_MESSAGES\nvda.po"
9. Open the menu "Catalogue", activate the "Properties" item (or just press Alt+Enter).
10. On the "Sources paths" tab press the browse button next to the "Paths" list and activate the "Add folders" item in the pop-up menu.
11. In the dialogue that opens select the root directory of the add-on, that is, the one in which the main manifest.ini file is located.
12. Press "OK" and open the menu "File", activate the "Save" item (or just press CTRL+S).
13. Open the menu "Catalogue", activate the "Update from source code" item.
14. Translate all phrases with Poedit. Pay attention to notes for translators which are displayed in the Poedit's interface.
15. Open the menu "File", activate the "Save" item (or just press CTRL+S). Close Poedit.
16. Copy the "\manifest.ini" file and create the "\locale\ru\manifest.ini" file based on it.
17. Open the "\locale\ru\manifest.ini" file in a text editor, delete all lines except the line starting with "description" and translate the content of this line after the equal sign.
18. Copy the "\doc\en" directory (or other directory you choose) and create the "\doc\ru" directory based on it.
19. Open the "\doc\ru\help.html" file in a text editor and translate its content (you will need a basic knowledge of HTML). Pay attention to notes for translators which are written on separate commented out lines starting with "Translators:".

Here is an outline of what you should do to update, for example, a Russian translation:

1. Open the "\locale\ru\LC_MESSAGES\nvda.po" file with Poedit where "ru" can be any other language code.
2. Open the menu "Catalogue", activate the "Update from source code" item.
3. Translate all untranslated phrases with Poedit. Pay attention to notes for translators which are displayed in the Poedit's interface.
4. Open the menu "File", activate the "Save" item (or just press CTRL+S). Close Poedit.
5. Check the relevance of the "\doc\ru\help.html" and "\locale\ru\manifest.ini" files against the "\doc\en\help.html" and "\manifest.ini" files. Update if necessary.

After that, try building the add-on with the new or updated translation and test its functionality before distributing.

### Extension for JAWS
In the extension directory, there are subdirectories and files that correspond to various languages that already have translations. English translation is the most complete and up-to-date and is probably the best candidate to use as a starting point. However, other translations can be used and might be better starting points if the language is similar to your language.

Here is an outline of what you should do to make a translation, for example, from English to Russian:

1. Copy the "\enu" directory (or other directory you choose) and create the "\rus" directory based on it. Try to use directory names that match the names of translation directories within JAWS.
2. Open the "\rus\nvMathViewer.jsm" file in a text editor and translate constant values and a text of messages between lines  
```@msg_*```  
and  
```@@```  
Pay attention to notes for translators which are written on separate commented out lines starting with "Translators:".
3. Open the "\rus\nvMathViewer.jsd" file in a text editor and translate the contents of lines starting with ":Synopsis" and ":Description". The parts ":Synopsis" and ":Description" do not need to be translated.
4. Copy the "\ReadMe_in_English.html" file (or other ReadMe file you choose) and create the "\ReadMe_in_Russian.html" file based on it. Try to use the common name of language in the file name.
5. Open the "\ReadMe_in_Russian.html" file in a text editor and translate its content (you will need a basic knowledge of HTML). Pay attention to notes for translators which are written on separate commented out lines starting with "Translators:".

After that, try building the extension with the new translation and test its functionality before distributing.
