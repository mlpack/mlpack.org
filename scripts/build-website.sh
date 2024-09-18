#!/bin/bash
#
# Build the Markdown documentation from the most recent version of mlpack and
# put it in place.  After running this script, the website is ready to deploy.
# (Just copy everything except scripts/ and src/ to the deployment location.
# See deploy-site.sh.)

# Workflow:
#
# - make sure the most recent mlpack release .tar.gz is in files/.
# - run this script with $PWD=root of repository

# Get most recent version.
active_version=`ls files/mlpack-*.tar.gz |\
                grep -v 'git' |\
                grep -v 'latest' |\
                sort -r |\
                head -1 |\
                sed 's|files/mlpack-||' |\
                sed 's|.tar.gz||'`;

# Unpack the code so that we can extract the Markdown documentation to build the
# website.
rm -rf src/mlpack-${active_version}/;
cd src/;
tar -xvzpf ../files/mlpack-${active_version}.tar.gz;
cd ../;

# Copy necessary files for the website build.
mkdir -p src/mlpack-${active_version}/doc/html/;
# Note we put these here just so they are one directory above the built
# documentation, so that the relative links in the template header work.
cp *.html src/mlpack-${active_version}/doc/;
cp src/template.html.* src/mlpack-${active_version}/doc/html/;
cp css/style.css src/mlpack-${active_version}/doc/css/;
cp img/mlpack-logo.svg src/mlpack-${active_version}/doc/img/;
# Make sure that the sidebar has enough top margin.
sed -i 's/top: 5px/top: 55px/' src/mlpack-${active_version}/doc/css/gfm-mod.css;

# Now use the builtin script to build the documentation into HTML and test it.
cd src/mlpack-${active_version}/;
./scripts/build-docs.sh
if [ "$?" -ne "0" ];
then
  echo "Failure building HTML website from Markdown!";
  exit 1;
fi

# Finally, copy the website to the correct place (the root directory).
cd ../../;
rm -rf doc/;
mkdir -p doc/;
cp -r src/mlpack-${active_version}/doc/html/* doc/;

# Clean up the build workspace.
rm -rf src/mlpack-${active_version}/;
