#!/bin/bash
#
# Build the source that we will extract and use for a given version.  When this
# is complete, the directory doc/mlpack-${version}/ will be populated with
# binding_header.md and binding_documentation.md and changelog.md, and the
# doxygen/ directory.
#
# For mlpack-git, this is the only script that needs to be run nightly.
#
# This also expects src/mlpack-$1.tar.gz to exist.
#
# $1: version (i.e. "3.0.4").

version=$1;

srcdir="$PWD/_src/mlpack-$1"
docdir="$PWD/doc/mlpack-$1"
doxygensrcdir="$PWD/_src/doxygen"

# Get list of versions.
doxygen_versions=();
for i in `ls files/mlpack-*.tar.gz | sort -r`;
do
  doxygen_versions+=(mlpack-`basename $i .tar.gz | sed 's/mlpack-//'`);
done

# Unpack and patch the code if needed.  Remove any old code.
echo "Unpacking and patching version $version...";
cd _src/;
rm -rf mlpack-$version/;

# Handle git repository separately.  Note that mlpack-git.tar.gz is just a
# placeholder file.
if [ "a$version" == "agit" ];
then
  git clone https://github.com/mlpack/mlpack mlpack-git/;
else
  tar -xvzpf ../files/mlpack-$version.tar.gz;
fi

if [ -f markdown-patches/mlpack-$version-markdown.patch ];
then
  echo "Patch mlpack-$version-markdown.patch found; applying...";
  cd mlpack-$version/;
  patch -p1 < ../markdown-patches/mlpack-$version-markdown.patch;
  cp ../markdown-patches/menu_bg.png src/mlpack/bindings/markdown/res/;
  cd ../;
fi
cd ../;

# Remove any old directory if needed.
echo "Creating output directory for Markdown output...";
rm -rf doc/mlpack-$version/;
mkdir -p doc/mlpack-$version/;

echo "Generating documentation for version $version...";

# Build the Markdown documentation.  This assumes that each version has the
# Markdown bindings available as a target.
cd _src/mlpack-$version/;
mkdir -p build/;
cd build/;
cmake -DDOWNLOAD_DEPENDENCIES=ON -DBUILD_MARKDOWN_BINDINGS=ON ../;
make -j4 markdown;
if [ "$?" -ne "0" ];
then
  echo "Failure building Markdown bindings for version ${version}!";
  exit 1;
fi

# Copy the Markdown documentation to the right place.
cat doc/mlpack.md |\
    awk '/<div id="header" markdown="1">/ { flag=1; }
         /<div id="docs" markdown="1">/ { flag=0; }
         // { if(flag == 1) { print $0; }}' >\
    ../../../doc/mlpack-$version/binding_header.md;
# In the documentation we also have to fix the version links.
cat doc/mlpack.md |\
    awk '/<div id="docs" markdown="1">/ { flag=1; }
         // { if(flag == 1) { print $0; }}' |\
    sed -E 's|^# mlpack [^ ]* ([^ ]*) binding documentation|# mlpack '$version' binding documentation|' >\
    ../../../doc/mlpack-$version/binding_documentation.md

cd ../../../;

# Lastly, generate what we need to build the Doxygen documentation---if this
# version has a Doxyfile.
if [ -f _src/mlpack-$version/Doxyfile ];
then
  option_string="";
  for dv in ${doxygen_versions[@]};
  do
    option_string="$option_string<option value=\"$dv\"";
    if [ "a$dv" == "a$version" ]; then
      option_string="$option_string selected=\"\"";
    fi
    option_string="$option_string>$dv</option>";
  done
  msearchbox_string="`cat _src/doxygen/msearchbox.html | tr '\n' ' '`";

  cp _src/doxygen/header.template.html _src/doxygen/header.$version.html;
  # Make sure this file exists...
  bundle exec jekyll b -b /;
  cat _site/index.html |\
      awk '/[ \t]*<body>/{show=1;next} /[ \t]*<main>/{show=0} // {if(show == 1){print $0;}}' |\
      sed 's|learning library</big></div>|learning library</big></div><div id="ens_header_version_select"><select class="doxygen-version-select" id="version-select" onchange="changeVersion()">'"$option_string"'</select></div>|' |\
      sed 's/class="active" //' |\
      sed 's|title="GitHub">GitHub</a>|title="GitHub">GitHub</a>'"$msearchbox_string"'|' >>\
      _src/doxygen/header.$version.html;

  cd _src/mlpack-${version}/build/;

  # Do we need to update the Doxygen stylesheet?
  modified_lines=`cat ../Doxyfile | grep 'doxygen-src/header.html' | wc -l`;
  if [ "a$modified_lines" == "a0" ]; then
    # Modify the Doxyfile.
    sed -i "s|HTML_HEADER[ ]*=[ ]*.*$|HTML_HEADER = \"${doxygensrcdir}/header.$1.html\"|" ../Doxyfile;
    sed -i "s|HTML_FOOTER[ ]*=[ ]*.*$|HTML_FOOTER = \"${doxygensrcdir}/footer.html\"|" ../Doxyfile;
    sed -i "s|HTML_STYLESHEET[ ]*=[ ]*.*$|HTML_STYLESHEET = \"${doxygensrcdir}/doxygen.css\"|" ../Doxyfile;
    sed -i "s|HTML_EXTRA_STYLESHEET[ ]*=[ ]*.*$|HTML_EXTRA_STYLESHEET = \"${doxygensrcdir}/style-doxygen.css\"|" ../Doxyfile;
  fi

  # Modify other parts of the Doxyfile.
  sed -i "s|GENERATE_TREEVIEW[ ]*=[ ]*.*$|GENERATE_TREEVIEW = YES|" ../Doxyfile;
  sed -i "s|TREEVIEW_WIDTH[ ]*=[ ]*.*$|TREEVIEW_WIDTH = 220|" ../Doxyfile;
  sed -i "s|DISABLE_INDEX[ ]*=[ ]*.*$|DISABLE_INDEX = YES|" ../Doxyfile;
  echo "LAYOUT_FILE = DoxygenLayout.xml" >> ../Doxyfile;

  # Fix incorrect links to mlpack-git.
  sed -i 's/mlpack-git/mlpack-'"$version"'/g' ../doc/guide/cli_quickstart.hpp
  sed -i 's/mlpack-git/mlpack-'"$version"'/g' ../doc/guide/python_quickstart.hpp

  # Generate layout file.
  doxygen -l;
  sed -i 's|  <tab type="pages" visible="yes" title="" intro=""/>|  <tab type="pages" visible="no" title="" intro=""/>|' DoxygenLayout.xml;

  # Build documentation.
  cmake ../
  make clean;
  rm -rf doc/html/
  make -j4 doc; # Hopefully you have four cores... :)

  cd doc/html/;
  for i in *.html; do
    sed -i 's|<a href="https://www.mlpack.org/docs/|<a href="https://www.mlpack.org/doc/|g' "$i";
    sed -i 's|<a href="http://www.mlpack.org/docs/|<a href="http://www.mlpack.org/doc/|g' "$i";
    sed -i 's|/man.html|/cli_documentation.html|g' "$i";
    sed -i 's|/python.html|/python_documentation.html|g' "$i";
    sed -i -E 's|/man/mlpack_([^.]*)\.html|/cli_documentation.html#\1|g' "$i";
    sed -i -E 's|/python/([^.]*)\.html|/python_documentation.html#\1|g' "$i";
  done
  # Move the extra CSS to the right place.
  cp $doxygensrcdir/tabs.css .;
  cp $doxygensrcdir/navtree.css .;
  cp $doxygensrcdir/dynamic_tables.js .;
  cp $doxygensrcdir/resize.js .;
  cp $doxygensrcdir/navtree.js .;
  cp $doxygensrcdir/version_redirect.js .;

  cp $doxygensrcdir/htaccess.template .htaccess;
  cp $doxygensrcdir/404.html 404.html;

  # Now postprocess all of the HTML.
  for i in *.html; do
    $doxygensrcdir/label_html_templates.py $i > tmp.html;
    mv tmp.html $i;
  done
  cd ../../

  # Now move the HTML to the right place.
  rm -rf $docdir/doxygen;
  mv doc/html $docdir/doxygen;

  # Now add the author tags to the generated tutorials.
  python3 $doxygensrcdir/tutorial_author_annotator.py doc/tutorials/ $docdir/doxygen/

  # Now add the visualization to the optimizer tutorial.
  if [ -f "$docdir/doxygen/optimizertutorial.html" ];
  then
    python3 $doxygensrcdir/optimizer_visualization_annotator.py $docdir/doxygen/optimizertutorial.html
  fi

  cd ../../../;
fi

cat _src/mlpack-${version}/HISTORY.md |\
    sed -E 's|\(#([0-9]*)\)|[#\1](https://github.com/mlpack/mlpack/issues/\1)|g' >\
    doc/mlpack-${version}/changelog.md;
