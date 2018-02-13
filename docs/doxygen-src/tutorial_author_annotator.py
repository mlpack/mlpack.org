#!/usr/bin/python
#
# Usage: python tutorial-author_annotator.py path/to/raw/tutorials/folder/ path/to/doxygen/generated/html/files/

import re
import glob
import os
import sys

rawTutorialPath = sys.argv[1]
if rawTutorialPath[-1] != "/":
  rawTutorialPath += "/"

doxygenTutorialPath = sys.argv[2]
if doxygenTutorialPath[-1] != "/":
  doxygenTutorialPath += "/"

authorHTML='''<span class="mlabel" style="border: 0px solid #333333;">
    <a href="%(info)s" style="color:#ffffff !important">%(author)s</a>
    </span>'''

rawTutorialFiles = glob.glob(rawTutorialPath + "*/*.txt")

for file in rawTutorialFiles:
    with open(file) as f: content = f.read()

    # Extract all author lines. It's possible that a page has multiple authors,
    # in this case the syntax should look like:
    # @author Author1
    # @author Author2
    authorLines = [line for line in content.split('\n') if "@author" in line]

    # Remove '@author' from the line.
    for i in range(len(authorLines)):
      authorLines[i] = authorLines[i].replace("@author", "")

    authorBlock = '''<div align="right">''';

    # Construct the author html block.
    for authorContent in authorLines:
      # Extract additional author information if provided. The syntax looks
      # like: @author Author1 (information).
      infoPattern = re.compile(r'.* \((.*)\)', re.MULTILINE|re.DOTALL)
      info = infoPattern.match(authorContent)
      info = info.groups()[0] if info else ""

      if info == "":
        author = authorContent.strip()
      else:
        author = authorContent[0:authorContent.find('(')].strip()

      if authorBlock == '''<div align="right">''':
        author = "Author: " + author

      authorBlock += authorHTML % {'author' : author, 'info' : info}

    authorBlock += '''</div>'''

    # Extract the page name.
    pagePattern = re.compile(r'.*@page (\w+)', re.MULTILINE|re.DOTALL)
    page = pagePattern.match(content)
    page = page.groups()[0] if page else None

    # Search for the doxygen generated page.
    if page:
      tutorial = glob.glob(doxygenTutorialPath + page + ".html")

      if len(tutorial) == 1:
        with open(tutorial[0]) as f: content = f.read()

        # Add the author information right after the first headline.
        h = content.find('</h1>')
        if h > 0:
          with open(tutorial[0], "w") as f:
            f.write(content[0:h+5])
            f.write(authorBlock)
            f.write(content[h+6:-1])
