from HTMLParser import HTMLParser
from template_annotator import TemplateAnnotator
import sys

class HTMLTemplateLabeler(HTMLParser):
  current_data = ''

  def handle_starttag(self, tag, attrs):
    # Print the tag.  Is it a br?  Then we can ignore it.
    if tag == "br":
      print("<br />")
      return

    # Process the current data we have.
    if self.current_data != '':
      self.process_data()

    print("<" + tag + " " + ' '.join([a[0] + '="' + a[1] + '"' for a in attrs]) + ">")
    self.current_data = ''

  def handle_endtag(self, tag):
    # Print the tag, after processing the data we currently have.
    self.process_data()

    # Print the closing tag.
    print ("</" + tag + ">")
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
    print(processed)

