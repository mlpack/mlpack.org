from pyparsing import Literal, Word, Combine, Group, Optional, ZeroOrMore, \
    Forward, nums, alphas, alphanums, LineEnd, ParseException, Suppress, \
    OneOrMore, delimitedList
import re
import sys

class TemplateAnnotator:

  def __init__(self):

    # Define the grammar.  We need some literals.
    templateLiteral = Literal("template")("template")
    openBracket = Literal("&lt;")("open_bracket")
    closeBracket = Literal("&gt;")("close_bracket")
    typenameLiteral = Literal("typename")("type_decl")
    classLiteral = Literal("class")("type_decl")
    equalLiteral = Literal("=")
    comma = Literal(",")("comma")
    ellipses = Literal("...")
    operatorLiteral = Literal("operator")
    tildeLiteral = Literal("~")

    digit = Word(nums)

    identifier_nondigit = Word(alphas + "_:") # catch underscores and ::

    identifier = Forward()
    identifier << (identifier_nondigit + Optional(identifier) + Optional(digit))("identifier*")

    default_argument = Group(Literal("=")("equals") + identifier)("default_argument*")

    template_param_list = Forward()

    template_param = Group(classLiteral + Optional(identifier) + Optional(default_argument))("template_param*") |\
                     Group(typenameLiteral + Optional(identifier) + Optional(default_argument))("template_param*") |\
                     Group(templateLiteral + openBracket + template_param_list + closeBracket + classLiteral + Optional(identifier) + Optional(default_argument))("template_template_param*")

    # This needs to be its own separate thing so that the comma gets grouped in
    # the template_param div.
    template_param_with_comma = Group(classLiteral + Optional(identifier) + Optional(default_argument) + comma)("template_param*") |\
                                Group(typenameLiteral + Optional(identifier) + Optional(default_argument) + comma)("template_param*") |\
                                Group(templateLiteral + openBracket + template_param_list + Group(classLiteral + Optional(identifier) + Optional(default_argument) + comma)("template_template_param_name"))("template_template_param*")

    # This also needs to be its own separate thing so that the closing bracket
    # gets grouped in the template_param div.
    template_param_with_close = Group(classLiteral + Optional(identifier) + Optional(default_argument) + closeBracket)("template_param*") |\
                                Group(typenameLiteral + Optional(identifier) + Optional(default_argument) + closeBracket)("template_param*") |\
                                Group(templateLiteral + openBracket + template_param_list + Group(classLiteral + Optional(identifier) + Optional(default_argument) + closeBracket)("template_template_param_name"))("template_template_param")

    template_param_list << Group(ZeroOrMore(template_param_with_comma) + template_param_with_close)("template_param_list")

    self.grammar = (Literal("template")("template_decl") + openBracket + template_param_list) |\
                   (Literal("template")("template_decl") + openBracket + closeBracket)

  def process(self, string):
    try:
      a = self.grammar.parseString(string)

      # Now process the string.  We get XML back, but we really need named divs.
      retstr = a.asXML('template_expr')\
          .replace('<template_expr', '<div class="template_expr"')\
          .replace('</template_expr', '</div')\
          .replace('<template_decl', '<div class="template_decl"')\
          .replace('</template_decl', '</div')\
          .replace('<open_bracket', '<div class="open_bracket"')\
          .replace('</open_bracket', '</div')\
          .replace('&amp;lt;', '&lt;')\
          .replace('<close_bracket', '<div class="close_bracket"')\
          .replace('</close_bracket', '</div')\
          .replace('&amp;gt;', '&gt;')\
          .replace('<template_param_list', '<div class="template_param_list"')\
          .replace('</template_param_list', '</div')\
          .replace('<template_param', '<div class="template_param"')\
          .replace('</template_param', '</div')\
          .replace('<template_template_param_name', '<div class="template_template_param_name"')\
          .replace('</template_template_param_name', '</div')\
          .replace('<template_template_param', '<div class="template_template_param"')\
          .replace('</template_template_param', '</div')\
          .replace('<type_decl', '<div class="type_decl"')\
          .replace('</type_decl', '</div')\
          .replace('<identifier', '<div class="identifier"')\
          .replace('</identifier', '</div')\
          .replace('<default_argument', '<div class="default_argument"')\
          .replace('</default_argument', '</div')\
          .replace('<equals', '<div class="equals"')\
          .replace('</equals', '</div')\
          .replace('<comma', '<div class="comma"')\
          .replace('</comma', '</div')\
          .replace('<template', '<div class="template"')\
          .replace('</template', '</div')

      # Strip away extra spaces.
      retstr = re.sub(r"^[ ]*", "", retstr)
      retstr = re.sub(r"[ ]*$", "", retstr)
      retstr = re.sub(r"\n[ ]*", "\n", retstr)
      retstr = re.sub(r"[ ]*\n", "\n", retstr)

      return retstr.replace('\n', '')

    except ParseException, err:
#      print err.line
#      print " "*(err.column - 1) + "^"
#      print err
      return string # Unmodified.
