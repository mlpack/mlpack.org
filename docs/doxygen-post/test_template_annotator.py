#!/usr/bin/python
from template_annotator import TemplateAnnotator
t = TemplateAnnotator()
a = t.grammar.parseString('template &lt; typename A &gt;')

print a.asXML('div')
print ''

a = t.grammar.parseString('template &lt; &gt;')

print a.asXML('div')
print ''

a = t.grammar.parseString('template &lt; typename A, typename B &gt;')

print a.asXML('div')
print ''

a = t.grammar.parseString('template&lt;typename A&gt;')

print a.asXML('div')
print ''

a = t.grammar.parseString("template&lt;typename VecType &gt;")

print a.asXML('div')
print ''

a = t.grammar.parseString("template&lt;typename MetricType, typename StatisticType = EmptyStatistic, typename MatType = arma::mat &gt;")

print a.asXML('div')
print ''

a = t.grammar.parseString('template &lt; template &lt; typename A &gt; class B &gt;')

print a.asXML('div')
print ''
