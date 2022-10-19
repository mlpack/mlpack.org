#!/usr/bin/python2
#
# Process the given HTML file, outputting the labeled templates on stdout.
import sys
from html_template_labeler import HTMLTemplateLabeler

labeler = HTMLTemplateLabeler()

f = open(sys.argv[1], 'r')
labeler.feed(f.read())
