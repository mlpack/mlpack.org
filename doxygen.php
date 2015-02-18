<html>
<head>
<meta name="keywords" content="mlpack, libmlpack, c++, armadillo, machine learning, data mining, classification, regression, tree-based methods, dual-tree algorithm">
<meta name="description" content="mlpack: a scalable c++ machine learning library">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>mlpack: a scalable c++ machine learning library</title>
</head>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="doxygen.css">
<link href='http://fonts.googleapis.com/css?family=Cousine|Maven+Pro:500' rel='stylesheet' type='text/css'>
<body>
<!-- very simple table with as few words as possible -->
<br>
<div class="titlebar">
<div class="left-image">
   <a href="http://www.fast-lab.org"><img src="fastlab.png"></a>
</div>
<div class="right-image">
   <img src="buzz.png">
</div>
<div class="title">
   <div class="titlefont">mlpack</div>
   <div class="subtitle">a scalable c++ machine learning library</div>
</div>

</div>
<div class="separator"></div>
<center>
<div class="mlnavbar">
   <div class="mlnavitem" name="mlnavmain"><a href="index.html">main</a></div>
   <div class="mlnavitem" name="mlnavabout"><a href="about.html">about</a></div>
   <div class="mlnavitem" name="mlnavtut"><a href="tutorial.html">tutorials</a></div>
   <div class="mlnavsel" name="mlnavdoc">docs</div>
   <div class="mlnavitem" name="mlnavhelp"><a href="help.html">contact</a></div>
   <div class="mlnavitem" name="mlnavbugs"><a
href="https://github.com/mlpack/mlpack/">bugs</a></div>
</div>
</center>
<div class="separator"></div>
<center>
<div class="mainsection">
<?php
  $page = $_GET['doc'];
  if ($page == '') { $page = 'index.html'; }

  /***
   * Ensure that file being opened is in doxygen/ (that is, it'd better not be a
   * big open security hole).  We'll just refuse to open the page if it has a
   * forward or backward slash, or if it has a dollar sign (I don't know if
   * file_get_contents() would deal with environment variables), or if it has a
   * tilde.
   */
  if (preg_match('/[~$\/\\\]/', $page) != 0)
  {
    echo 'Invalid Doxygen page ' . $page . '.';
  }
  else
  {
     /* Load file and change some things around so we wrap it right. */
     $patterns = array();
     $replacements = array();

     $patterns[0] = '/href="([^#][^:"]*)"/';
     $replacements[0] = 'href="doxygen.php?doc=\\1"';

     $patterns[1] = '/MLPACK/';
     $replacements[1] = 'mlpack';

     // For images.
     $patterns[2] = '/(<img[^>]*src)="([^"]*)"/';
     $replacements[2] = '\\1="doxygen/\\2"';

     // Remove doxygen stylesheets.
     $patterns[3] = '/<link href="[^"]*" rel="stylesheet" type="text\/css"[ ]*\/>/';
     $replacements[3] = '';

     print preg_replace($patterns, $replacements, file_get_contents('doxygen/' . $page));
   }
?>
</div>
</body>
</html>
