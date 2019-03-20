---
layout: docs
title: Documentation
description: mlpack | fast, flexible C++ machine learning library
custom-css: docs.css
---

{% include_relative doc_header.md %}
{% include_relative binding_header_mod.md %}
</div>

# overview

High-quality documentation is a development goal of mlpack.  mlpack's
documentation is split into two parts: documentation for the bindings, and
documentation for the C++ library.  Generally, working with the bindings is a
good choice for **simple machine learning and data science tasks**, and writing
C++ is a good idea when **complex or custom functionality** is desired.

All interfaces are heavily documented, and if you find a documentation issue,
[please report it](https://github.com/mlpack/mlpack/issues/new?assignees=&labels=t%3A+bug+report%2C+c%3A+documentation%2C+s%3A+unanswered&template=1-documentation.md&title=).

# quickstart

Just getting started with mlpack?  Try these quickstart tutorials for the
bindings to other languages.

{% include_relative quickstart.md %}

Once you're comfortable with the quickstart guides for the language of your
choice, full documentation for every binding can be found below.  Quick links
are in the left sidebar.

 * [Binding documentation](#binding_documentation)

The C++ interfaces of mlpack are carefully documented and doxygen is used to
provide automatically-generated searchable documentation.

 * [Doxygen documentation](doxygen/index.html)

# tutorials

A number of tutorials are available covering individual algorithms
and functionality inside of mlpack, both for bindings to other languages and for
the C++ interface.

{% include_relative tutorials.md %}

<!-- The binding documentation includes headers for each language. -->
<a name="binding_documentation"></a>

{% include_relative binding_documentation_mod.md %}

# changelog/history

{% include_relative changelog.md %}
