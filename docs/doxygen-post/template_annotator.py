from pyparsing import Literal, Word, Combine, Group, Optional, ZeroOrMore, \
    Forward, nums, alphas, alphanums, LineEnd, ParseException, Suppress, \
    OneOrMore, delimitedList

class TemplateAnnotator:

  def __init__(self):

    # Define the grammar.  We need some literals.
    templateLiteral = Literal("template")("template")
    openBracket = Literal("&lt;")("open_bracket")
    closeBracket = Literal("&gt;")("close_bracket")
    typenameLiteral = Literal("typename")("type_decl")
    classLiteral = Literal("class")("type_decl")
    equalLiteral = Literal("=")
    comma = Literal(",")
    ellipses = Literal("...")
    operatorLiteral = Literal("operator")
    tildeLiteral = Literal("~")

    digit = Word(nums)

    identifier_nondigit = Word(alphas + "_:") # catch underscores and ::

    identifier = Forward()
    identifier << (identifier_nondigit + Optional(identifier) + Optional(digit))("identifier*")

    default_argument = Group(Literal("=")("equals") + identifier)("default_argument*")

    template_param_list = Forward()

    template_param = Group((classLiteral + Optional(identifier) + Optional(default_argument)) |\
                           (typenameLiteral + Optional(identifier) + Optional(default_argument)) |\
                           (templateLiteral + openBracket + template_param_list + closeBracket + classLiteral + Optional(identifier) + Optional(default_argument)))("template_param*")

    template_param_list << Group(delimitedList(template_param))("template_param_list")

    self.grammar = (Literal("template")("template_decl") + openBracket + template_param_list + closeBracket) |\
                   (Literal("template")("template_decl") + openBracket + closeBracket)

  def process(self, string):
    try:
      a = self.grammar.parseString(string)

      # Now process the string.  We get XML back, but we really need named divs.
      return a.asXML('template_expr')\
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
          .replace('<type_decl', '<div class="type_decl"')\
          .replace('</type_decl', '</div')\
          .replace('<identifier', '<div class="identifier"')\
          .replace('</identifier', '</div')\

    except ParseException, err:
#      print err.line
#      print " "*(err.column - 1) + "^"
#      print err
      return string # Unmodified.
