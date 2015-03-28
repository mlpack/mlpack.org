#!/bin/bash
# For every .1 file in the directory, generate a corresponding .html page.

for i in *.1
do
  htmlfile=${i/.1/.html};
  echo "Generating ${htmlfile}..."

  # Generate base HTML.
  cp header.html $htmlfile;
  cat $i | groff -mandoc -Thtml -P -l -P -r |\
      grep -v 'body>' |\
      grep -v 'html>' |\
      tr '\n' '%' | sed 's/^.*<\/head>//' |\
      sed 's/p style="margin-left:11%; margin-top: 1em"/p class="closemargin first"/g' |\
      sed 's/p style="margin-left:11%;"/p class="closemargin"/g' |\
      sed 's/p style="margin-left:22%;"/p class="farmargin"/g' |\
      tr '%' '\n' |\
      sed 's/<b>/<font class="code">/g' |\
      sed 's/<\/b>/<\/font>/g' |\
      sed 's/<i>/<font class="code2">/g' |\
      sed 's/<\/i>/<\/font>/g' |\
      sed -E 's/\/font>=([A-Za-z0-9., $\/\(\)]*)</\/font><font class="code2">=\1<\/font></g' |\
      sed -E 's/\/font>=([A-Za-z0-9., $\/\(\)]*)$/\/font><font class="code2">=\1<\/font>/g' \
          >> $htmlfile;
  echo "</div></body></html>" >> $htmlfile;
done
