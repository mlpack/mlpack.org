#!/bin/bash
#
# Generate documentation in doc/mlpack-${version}/ for each version.

# Workflow:
#
# - make sure all .tar.gzs are dropped in _src/.
# - run this script with $PWD=root of repository

# We need a working copy of the site.
#jekyll b;

rm -f doc/mlpack-*/lang_list.md;
rm -f doc/mlpack-*/tutorials.md;
rm -f doc/mlpack-*/quickstart.md;

# Get most recent version.
active_version=`ls files/mlpack-*.tar.gz |\
                grep -v 'git' |\
                sort -r |\
                head -1 |\
                sed 's|files/mlpack-||' |\
                sed 's|.tar.gz||'`;

# Update redirect if necessary.
sed -i "s/doc\/mlpack-[^\/]*\/cli_documentation.html/doc\/mlpack-${active_version}\/cli_documentation.html/" \
    _includes/doc_redirect.html;

# Get list of versions.
doc_versions=();
for i in `ls files/mlpack-*.tar.gz | sort -r`;
do
  version=`basename $i .tar.gz | sed 's/mlpack-//'`;

  # Copy link image to the right directory because I can't figure out how to
  # make the anchor-headings plugin use relative directories.
  cp res/link_icon_gray.png doc/mlpack-${version}/;

  # Make sure that we get binding_documentation_mod.md generated.
  _src/scripts/modify-docs.sh doc/mlpack-${version}/binding_documentation.md \
      doc/mlpack-${version}/binding_documentation_mod.md;

  # Generate a modified header but keep the languages list.
  echo "  <div class=\"language-select-div\">" >> doc/mlpack-${version}/lang_list.md;
  echo "  <select class=\"language-select\" id=\"language-select\" onchange=\"changeLanguage()\">" >> doc/mlpack-${version}/lang_list.md;
  _src/scripts/insert-doc-header.sh doc/mlpack-${version}/binding_header.md \
      doc/mlpack-${version}/binding_header_mod.md >> doc/mlpack-${version}/lang_list.md;
  echo "  </select>" >> doc/mlpack-${version}/lang_list.md;
  echo "  </div>" >> doc/mlpack-${version}/lang_list.md;

  langs=`grep '<option' doc/mlpack-${version}/lang_list.md |\
         sed -E 's/^.*value=\"(.*)\".*$/\1/'`;

  # Now split the documentation into each language.
  for l in $langs;
  do
    # Assemble the awk query and grep queries for the documentation and for the
    # header.
    awk_filter="";
    grep_filter="cat doc/mlpack-${version}/binding_header_mod.md";
    sed_filter="cat doc/mlpack-${version}/binding_documentation_mod.md";
    for ll in $langs;
    do
      if [ "a$l" != "a$ll" ];
      then
        awk_filter="$awk_filter /<div.* id=\"$ll\".*/ { no_print=1; }";
        grep_filter="$grep_filter | grep -v '(#'$ll'_'";
        sed_filter="$sed_filter | sed 's/\[Detailed documentation\](#${ll}_[^)]*_detailed-documentation){: .language-detail-link #${ll} }//g'"
      fi
    done

    # Now filter all other languages.
    eval ${sed_filter} |\
        awk '/<div.* id=\"'"$l"'\".*/ { no_print=0; }
             /^<\/div>.*/ { no_print=0; next }
             '"$awk_filter"'
             // { if(no_print != 1) { print $0; } }' |\
        sed 's/<div .*//' |\
        sed 's/#'"$l"'_//' |\
        sed 's/#doc_'"$l"'_//' > doc/mlpack-${version}/${l}_binding_documentation_mod.md;
    eval ${grep_filter} | sed 's/#'"$l"'_/#/' >\
        doc/mlpack-${version}/${l}_binding_header_mod.md;

    # Now, make a page for every language.
    cat _src/templates/documentation.md |\
        sed 's/include_relative binding_documentation_mod.md/include_relative '$l'_binding_documentation_mod.md/' |\
        sed 's/include_relative binding_header_mod.md/include_relative '$l'_binding_header_mod.md/' >\
        doc/mlpack-${version}/${l}_documentation.md;
  done

  # Get list of versions.
  doc_versions+=("${version}");

  # Generate the tutorials list in Markdown and add it to a div.
  _src/scripts/extract-tutorials.sh ${version} doc/mlpack-${version}/tutorials.md;

  # Generate the list of quickstart tutorials in Markdown and add it to a div.
  _src/scripts/extract-quickstarts.sh ${version} doc/mlpack-${version}/quickstart.md;
done

# Now go through and assemble each version's documentation page.
for i in `ls files/mlpack-*.tar.gz | sort -r`;
do
  version=`basename $i .tar.gz | sed 's/mlpack-//'`;
  echo "Generating headers for version ${version}...";

  echo "<div id=\"header\" markdown=\"1\">" > doc/mlpack-${version}/doc_header.md;
  echo "<form>" >> doc/mlpack-${version}/doc_header.md;
  echo "  <div class=\"version-select-div\">" >> doc/mlpack-${version}/doc_header.md;
  echo "  <select class=\"version-select\" id=\"version-select\" onchange=\"changeVersion()\">" >> doc/mlpack-${version}/doc_header.md;

  for v in ${doc_versions[@]};
  do
    if [ "a$v" == "a$version" ];
    then
      echo "    <option value=\"mlpack-$v\" selected>mlpack-$v</option>" >> doc/mlpack-${version}/doc_header.md;
    else
      echo "    <option value=\"mlpack-$v\">mlpack-$v</option>" >> doc/mlpack-${version}/doc_header.md;
    fi
  done

  echo "  </select>" >> doc/mlpack-${version}/doc_header.md;
  echo "  </div>" >> doc/mlpack-${version}/doc_header.md;
  cat doc/mlpack-${version}/lang_list.md >> doc/mlpack-${version}/doc_header.md;
  echo "</form>" >> doc/mlpack-${version}/doc_header.md;
  echo "" >> doc/mlpack-${version}/doc_header.md;

  cat _src/mlpack-${version}/HISTORY.md |\
      sed -E 's|\(#([0-9]*)\)|[#\1](https://github.com/mlpack/mlpack/issues/\1)|g' >\
      doc/mlpack-${version}/changelog.md;

done
