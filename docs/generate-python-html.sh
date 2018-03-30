#!/bin/bash
#
# The first argument should be a version number.
#
# Run this from the directory that the HTML files should be generated in.

headerdir=/var/www/www.mlpack.org/docs/
coderoot=/var/www/www.mlpack.org/mlpack-$1/

# Make sure we build the bindings.
dir=`pwd`;
cd $coderoot/build/
make python
cd $dir;

for i in $coderoot/build/src/mlpack/bindings/python/mlpack/*.so
do
  name=`basename $i .so`;
  if [ "$name" == "arma_numpy" ]; then
    continue
  elif [ "$name" == "test_python_binding" ]; then
    continue
  fi

  dirname=$name;
  # Only a few exceptions...
  if [ "$name" == "knn" ]; then
    dirname="neighbor_search";
  elif [ "$name" == "kfn" ]; then
    dirname="neighbor_search";
  elif [ "$name" == "krann" ]; then
    dirname="rann";
  elif [ "$name" == "gmm_generate" ]; then
    dirname="gmm";
  elif [ "$name" == "gmm_train" ]; then
    dirname="gmm";
  elif [ "$name" == "gmm_probability" ]; then
    dirname="gmm";
  elif [ "$name" == "hmm_train" ]; then
    dirname="hmm";
  elif [ "$name" == "hmm_viterbi" ]; then
    dirname="hmm";
  elif [ "$name" == "hmm_loglik" ]; then
    dirname="hmm";
  elif [ "$name" == "hmm_generate" ]; then
    dirname="hmm";
  elif [ "$name" == "nbc" ]; then
    dirname="naive_bayes";
  elif [ "$name" == "preprocess_describe" ]; then
    dirname="preprocess";
  elif [ "$name" == "preprocess_split" ]; then
    dirname="preprocess";
  elif [ "$name" == "preprocess_binarize" ]; then
    dirname="preprocess";
  elif [ "$name" == "hoeffding_tree" ]; then
    dirname="hoeffding_trees";
  fi

  htmlfile=$name.html;
  echo "Generating ${htmlfile}..."

  # Generate base HTML.
  cp $headerdir/header-python.html $htmlfile;
  cat $headerdir/print_python_doc_html.cpp | \
      sed 's/DIR_NAME/'$dirname'/g' |        \
      sed 's/METHOD_NAME/'$name'/g' >        \
      print_python_doc_html_$name.cpp

  g++ -o print_python_doc_html_$name         \
      print_python_doc_html_$name.cpp        \
      -I$coderoot/build/include/             \
      -I$coderoot/src/                       \
      -L$coderoot/build/lib/                 \
      -lmlpack                               \
      -larmadillo
  LD_LIBRARY_PATH=$coderoot/build/lib/ ./print_python_doc_html_$name >> $htmlfile;

  rm -f ./print_python_doc_html_$name.cpp
  rm -f ./print_python_doc_html_$name;
  echo "</div>" >> $htmlfile;
  echo "</body>" >> $htmlfile;
  echo "</html>" >> $htmlfile;
done
