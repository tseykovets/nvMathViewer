#! /usr/bin/env node

/*
* Uses MathJax v3 to convert a AsciiMath string to a MathML string.
* A modified demo code to use MathJax with Node without any other dependencies.
*
* Copyright (C) 2018 The MathJax Consortium
* Copyright (c) 2020 Nikita Tseykovets
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

// Load the packages needed for MathJax
const {AsciiMath} = require('./Node.js/node_modules/mathjax-full/js/input/asciimath.js');
const {HTMLDocument} = require('./Node.js/node_modules/mathjax-full/js/handlers/html/HTMLDocument.js');
const {liteAdaptor} = require('./Node.js/node_modules/mathjax-full/js/adaptors/liteAdaptor.js');
const {STATE} = require('./Node.js/node_modules/mathjax-full/js/core/MathItem.js');

// Create the input jax
const asciimath = new AsciiMath();

// Create an HTML document using a LiteDocument and the input jax
const html = new HTMLDocument('', liteAdaptor(), {InputJax: asciimath});

// Create a MathML serializer
const {SerializedMmlVisitor} = require('./Node.js/node_modules/mathjax-full/js/core/MmlTree/SerializedMmlVisitor.js');
const visitor = new SerializedMmlVisitor();
const toMathML = (node => visitor.visitTree(node, html));

// Convert the math notation from the command line to serialzied MathML
console.log(toMathML(html.convert(process.argv[2] || '', {
	// Process as block element
	display: true,
	end: STATE.CONVERT
})));
