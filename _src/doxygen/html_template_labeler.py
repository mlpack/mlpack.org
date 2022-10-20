from __future__ import print_function
from html.parser import HTMLParser
from template_annotator import TemplateAnnotator
from xml.sax.saxutils import escape

import sys

class HTMLTemplateLabeler(HTMLParser):
  current_data = ''

  html_escape_table = {
      '"': "&quot;",
      "'": "&apos;"
  }

  def html_escape(self, text):
    return escape(text, self.html_escape_table)

  def handle_starttag(self, tag, attrs):
    # Print the tag.  Is it a br?  Then we can ignore it.
    if tag == "br":
      print("<br />", end='')
      return
    elif tag == "link":
      print("<link " + ' '.join([a[0] + '="' + self.html_escape(a[1]) + '"' for a in attrs]) + " />", end='')
      return

    # Process the current data we have.
    if self.current_data != '':
      self.process_data()

    print("<" + tag + " " + ' '.join([a[0] + '="' + self.html_escape(a[1]) + '"' for a in attrs]) + ">", end='')
    self.current_data = ''

  def handle_endtag(self, tag):
    # Print the tag, after processing the data we currently have.
    self.process_data()

    # Print the closing tag.
    print ("</" + tag + ">", end='')
    self.current_data = ''

  # HTMLParser splits up the escaped HTML characters, so we have to reassemble
  # by having an internal data storage buffer.
  def handle_data(self, data):
    self.current_data = self.current_data + data

  def handle_entityref(self, name):
    self.current_data = self.current_data + "&" + name + ";"

  def handle_charref(self, name):
    self.current_data = self.current_data + "&#" + name + ";"

  def process_data(self):
    # Do nothing with empty data.
    if self.current_data == '':
      return

    # See if it matches the template grammar.
    t = TemplateAnnotator()
    processed = t.process(self.current_data) # Will modify, if it matches.

    # Print the data.
    print(processed, end='')

